Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BEC671807
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 10:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjARJni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 04:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjARJlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 04:41:12 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2057.outbound.protection.outlook.com [40.107.95.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FBB656E1;
        Wed, 18 Jan 2023 00:58:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRc7yRlkyUUB+1d7HTLTPuKwmL+Esd+rhM+DM5qltUrIwUyH8r4bHYYOptoAwcpffV0D8Ccdml3ww8WEgK7bk1e3Cl/PwxUfAW82WqPqgag1ByGg7v3iCwMOzfFXh2Xk1cYj0uM3o7xYNNWrfEdRJKko4s+2Cq55NvG7aNAZ87G2s/x35M9dlWED3zGxfrQhgpMAdyV/v52LoTaz1lgJ0CH1FZYoXvVxRpaIR4F99+/BYgCcSrp5ienPurtAnebu1xgFGYVb84WGkBnJPoRxEavmwmtmB3bfETJe3WCpMgzhG6JQ7mJGJfv2e5qMorPH1lIVbsDrl1gg8Py6cDln5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2c32Ygh25XfwuNohv3aPEHfgzsmiE+Z/us/yUOHMxk=;
 b=h0Els8seMxDIIKXYqPi0jGk+q7Vp5zIzJxMmHjDOCb6FobrYeQ4O7yDTd5KwmC+CmW1DRY0Jptgwy7I40WSKIqnFAwZWxOj4MWfa4V3g5q8eZAQlWHGm5sC47c5dcgkinvR9W9h6eloX7wifDwVef3Q/RWzPu8dfLLvG5zqXxK/CAxFTjbhP3hC794KbxzaxNdTLeFblkhfwO7ITVwCG6iy1Y5UO0ilJGkwj+fAF+/n0xicG3N2KqeQ76ZljUBSiUlkYNSW8rr1xvrvPtcwqWLutuH4D7Z/rP8whqm/6kEBOgo+xs8gvmUGqzgf778SyhfQnPJoMV8tshycup1XjWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2c32Ygh25XfwuNohv3aPEHfgzsmiE+Z/us/yUOHMxk=;
 b=ZKE/KcigGt4hG5SdZeHwTiqK60bkQ8U2FmcmgIDuVRAW57NmDEBTSUpRoWXIL1iURA79//2PfOSBlv6Yh7Tk8VbPdUGQup2RyXw9JEVBqXj6WQE56sUa1IIWKNrrO83SbzXBNg4QQhp7/app1ZIlHsQ1AlKoh4OFRXSY2me4YaIPrg5VETc6UoIctuqR6gAXaYjUFpxaf/fSk2pq65ILr8mHzM4zsJ7eGk/D5jdd7jTDv4FoPPQrjQ5LRm3LT1fy4+BmObnTYCwqj83zvbU+teE1RE/8DpLa6C9IEbngnxMzuvOlhx593HwD3UlJx9slINayQ4CYnyIQ7d8SypMLVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23)
 by MW4PR12MB6874.namprd12.prod.outlook.com (2603:10b6:303:20b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 18 Jan
 2023 08:58:13 +0000
Received: from MW3PR12MB4409.namprd12.prod.outlook.com
 ([fe80::f803:f951:a68f:663a]) by MW3PR12MB4409.namprd12.prod.outlook.com
 ([fe80::f803:f951:a68f:663a%5]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 08:58:13 +0000
Message-ID: <f6e661b2-f2f8-1747-2180-b7e6aa0b4bcd@nvidia.com>
Date:   Wed, 18 Jan 2023 10:58:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <Y8eWEPZahIFAfnoI@sol.localdomain>
From:   Israel Rukshin <israelr@nvidia.com>
In-Reply-To: <Y8eWEPZahIFAfnoI@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0120.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::10) To MW3PR12MB4409.namprd12.prod.outlook.com
 (2603:10b6:303:2d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4409:EE_|MW4PR12MB6874:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e25eb8d-4f9b-435f-0dde-08daf9322188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ilNjqfXK6g+30eb2e5HWhGih2haJFT7Nr68dD4XjROTBrwnoRwNEvx96+8azEWxvgJCjIVNcxy10GsFj0zLPzaLFIRoI1zHfQomzzWEGQ5ybRAATwUD6sH62X7jBHAl+PkSmgd9yJDW89uuLEL7hJP+h+r5Oxy097ljg8M2fN0XZ6mNZ8ANj4gLz3/q2IEUYLCLI3x0l+thryBzJrGi96taTAjQIOSXcAXe0VZsadtdkkoN6MxL5YcKu8JQvBWs/4Tzt0pF8FB6D0k1ouUByDJW8E5uoE5pTQxFycCRq8vlIO/Umg/G5RXhPgJIyFkvZZ/tDeL29gWo7R4w3ddYat47WGimp8UXJaMLp0jebr8STGpPVw3xWQHnFSnKGDetsa4vSUruEMpEe8uUUDifktIz9Ef7Mf2MD6vBzlBXoEEZlzESYOiXdz9AzBT3lmYBt8+9X5jxmA6Pg3pHi/N5ySFZEjjYHqXdKjtVMLkms8TelxFvwT4/QuHiSPqZP6qLM5BZu+GyHcZwUhf5/qlGxQYbP5IObBmAuyvSka9DlavcjsyjQxFxgVxZnj8GFWThNIOG1k+Au7eqtXTf+An/+XtA16gybWnFuWaE2SVMLU/JtXBSB4AKPWBBsW6l+AmIm/hSN5mPuG1ntFmOqBC5LqWiugS/e+WPD4ogk0aw0drVaY3JhE2zV0lxjIM9AkQDtqXPyDKNgp6o83ThdNeiF+m3bTsaIYiqpKs5g0QXYRaY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4409.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199015)(66476007)(38100700002)(86362001)(8936002)(8676002)(2906002)(4326008)(7416002)(31696002)(5660300002)(107886003)(66556008)(478600001)(66946007)(41300700001)(6506007)(6512007)(26005)(186003)(2616005)(53546011)(110136005)(54906003)(6666004)(6486002)(316002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHhSZkQzdlp4SFJ2YzhudTVYeVJRTlhZZW5weDExWXFmMUM3UDlVVFBGUEow?=
 =?utf-8?B?TDNNK0Q4MWRuc3ZYNFNKZTEySjc4a2J1dlVsWnJYZEh6SVAzWi9jeHQ0SDYy?=
 =?utf-8?B?QnlQTThvdUZIVU9yblNJclpFZnJmVlpRUEt1NTZGV29CYys0NVV4UmZqTlEz?=
 =?utf-8?B?Tk5Fbi9KelZlZU5WNVRZNElmVzNESGRuVkY3Z3VOaWlHWkd2SmordFR4UU13?=
 =?utf-8?B?dFA2b3FwNUdXWGNMVVVuVzV3blFjQWE2QmZqeS9aUVJ3ckl3L29ubjdKaGJF?=
 =?utf-8?B?cDlnbmVWdnZ5eGlvemNNOWppUFhWUW1STVp6RnlDUkF4NHFuV1dNT3gvazl5?=
 =?utf-8?B?SUpiWHBCK0QvdUFuNXdjV1BjWEdJZWZvM1Zvb2NWY3RCMkU4aUNUd2Z6MEdO?=
 =?utf-8?B?dEJVa28vZXIzQVAvMlRHOXZ3TEkwcXVXNFdHYmhJdGpQcjdKTTBCWUhFbVRj?=
 =?utf-8?B?dno0U0RrM3MvUytFYTljQ0J5YU5MT2kwQ3FXbi9lZUNlQjFSNEwwaTA4QWRX?=
 =?utf-8?B?QTZtbE8wYTlQTEJhM09DZE5QQ0pHck9PcVI1QlQzbEpFODhxb1ArMndMMEQr?=
 =?utf-8?B?czB0d3VYZVI4MWxmQ082eTdDY3kzNkgzeU94WEdieXVSRnh4VUtZODdvTXcx?=
 =?utf-8?B?RjUrSStPSmRtaDJVTW9TbXh4R2RyUWliTDkzTUw0eGdianlJdWFOQlJWY2Mz?=
 =?utf-8?B?OGgzQk44enpCK05FazZMdSt2dGtqd2ZGMWZWWmxMNUg4c29FbktUUlpLOVZS?=
 =?utf-8?B?QkZRMGVpdUZ1cGJpeTVmOTVjNXgvOW95OGNUZ1JZTUxIWnJLbEZhNThoNXlO?=
 =?utf-8?B?WGNNWUdjUWRoTWFLd08rWG1ySG8vWUlpSGRXcDgwZC91enRhZXAwaFVPbkwr?=
 =?utf-8?B?cmdTU1FuZC9RMnpMeU1ma2YyK29xNTNCZWs5cXoyeStpL3VVaFZDbjF5clFQ?=
 =?utf-8?B?WGRMYTdHc2F3L3ZvVmVieTJOVFQ2ZktpZTNVUjNkT1NUWEthQmVkbTRoNElj?=
 =?utf-8?B?aHpHYlRCVHNoa2dVUFcvZXpoS2pZZXpvVXl3RW42YUNZcGNaNHpoNzd1SEJk?=
 =?utf-8?B?SExWRUZPMWJxUERNR3huREFqeHN4Z2oyVWNIUzZzeE02a1RjNFVVL3F4dURC?=
 =?utf-8?B?ZWd6OUJvdUpPNjNqOWZ0R1hrYk5ESm8vTHpORlZkOW1IS0lidGgrZlM1UVJX?=
 =?utf-8?B?azJzTDZNZGdjMzEwbEFiS1dVNmhBUXd3T1phM0NOWVFQdlkrUm14S1FtcmN3?=
 =?utf-8?B?VVAwT1plVHdWK3owYlZXTUVQeFh6RHlabUxpTjFpMko2M0pCdlJKa290YWw1?=
 =?utf-8?B?NFZoaDJIL0pFSDc2Y0ZxYnNYdnkvWjJ3N0VMaVNEUTJHWWFmbTFKSXJsdjlm?=
 =?utf-8?B?YWZCdE11ajhTd1RNRWtLSkkwSXlWZ3V3N1diNWRyNXVrWXhpZVNWT1JldThO?=
 =?utf-8?B?SjRPVTBWZ2lOUzErZFYzdWFSc0V4QzZvdCtLazVDblFORkZFQWo2RHBrUk9t?=
 =?utf-8?B?dlFKT1pibHU0b3VnOVVpNUlxQUpGWnJPMjQ4SzgySjV3QUNsQnlOMVVoWnpJ?=
 =?utf-8?B?Q0g1M3lZdURHVk1kLy9FalBtMG5ZS0JpSGhRQnNIREZPeXpubDdpdFh1aEVB?=
 =?utf-8?B?dDAwUnJtZ0cxSUpESk41OWxreldzRFZPWG1lY1FJQVV5QXhqYnR2VEdvNlJh?=
 =?utf-8?B?RkdaeU03RXRrUmdzWWd4RUwzMWJaNDhaSm5YblFRcUtDRjBBcVNQZU1YQTJJ?=
 =?utf-8?B?Wm9TQm5aelNzcGEvdDRiRlFVZHBUUi9lRkkxVmVRbHJFWmdxc05ONEdqTVBF?=
 =?utf-8?B?WDRDdmdHNEJIeWFMK3BkbGJJMnlQeUJ5ZXdqcjk4eHNpSWNRbFNyZDNOSTlQ?=
 =?utf-8?B?U3YzeHdEVHFSYVBubEpERUkyRmQyL0lEbE84QytqcUVtZW9HVkJGR1BRMU9w?=
 =?utf-8?B?SlcyVjZCdUpSbW9NdjlDSmJBc3pJL2ZWdGxhMVFvbURBSk5sUUJlRzZIOUla?=
 =?utf-8?B?bHF1amw3VzhVdm9pUEVCTUYyZ0VDMXdJdU5BaWlnSXRmRWFsb1dHdWY2UjdW?=
 =?utf-8?B?bFkwaGpFKzNHeTd0Rm5LdjVUc3E4U3RjbHFhZ0pmSHBRdWovQUlrSW83NTBD?=
 =?utf-8?Q?BLyX7UkB4XAGKSByryw3h0rki?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e25eb8d-4f9b-435f-0dde-08daf9322188
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4409.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 08:58:13.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EMYwc1XkaAiHPcEZfSI4pEpYkL8EE/fB+DybznFbZ6R/5kSO0yzrKzqkFGGk0RG0I8+oAayALNm/jrzBJ3WC2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6874
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 1/18/2023 8:47 AM, Eric Biggers wrote:
> Hi Leon,
>
> On Mon, Jan 16, 2023 at 03:05:47PM +0200, Leon Romanovsky wrote:
>> >From Israel,
>>
>> The purpose of this patchset is to add support for inline
>> encryption/decryption of the data at storage protocols like nvmf over
>> RDMA (at a similar way like integrity is used via unique mkey).
>>
>> This patchset adds support for plaintext keys. The patches were tested
>> on BF-3 HW with fscrypt tool to test this feature, which showed reduce
>> in CPU utilization when comparing at 64k or more IO size. The CPU utilization
>> was improved by more than 50% comparing to the SW only solution at this case.
>>
>> How to configure fscrypt to enable plaintext keys:
>>   # mkfs.ext4 -O encrypt /dev/nvme0n1
>>   # mount /dev/nvme0n1 /mnt/crypto -o inlinecrypt
>>   # head -c 64 /dev/urandom > /tmp/master_key
>>   # fscryptctl add_key /mnt/crypto/ < /tmp/master_key
>>   # mkdir /mnt/crypto/test1
>>   # fscryptctl set_policy 152c41b2ea39fa3d90ea06448456e7fb /mnt/crypto/test1
>>     ** “152c41b2ea39fa3d90ea06448456e7fb” is the output of the
>>        “fscryptctl add_key” command.
>>   # echo foo > /mnt/crypto/test1/foo
>>
>> Notes:
>>   - At plaintext mode only, the user set a master key and the fscrypt
>>     driver derived from it the DEK and the key identifier.
>>   - 152c41b2ea39fa3d90ea06448456e7fb is the derived key identifier
>>   - Only on the first IO, nvme-rdma gets a callback to load the derived DEK.
>>
>> There is no special configuration to support crypto at nvme modules.
>>
>> Thanks
> Very interesting work!  Can you Cc me on future versions?
>
> I'm glad to see that this hardware allows all 16 IV bytes to be specified.
>
> Does it also handle programming and evicting keys efficiently?
>
> Also, just checking: have you tested that the ciphertext that this inline
> encryption hardware produces is correct?  That's always super important to test.
> There are xfstests that test for it, e.g. generic/582.  Another way to test it
> is to just manually test whether encrypted files that were created when the
> filesystem was mounted with '-o inlinecrypt' show the same contents when the
> filesystem is *not* mounted with '-o inlinecrypt' (or vice versa).
sure, I ran the manual test of comparing the encrypted files content 
with and without the '-o inlinecrypt' at the mount command.
>
> - Eric
  - Israel
