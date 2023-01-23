Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F9E677C04
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbjAWM55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbjAWM54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:57:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87526E91;
        Mon, 23 Jan 2023 04:57:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZ7hmf9aIEDjBTsURem33U/6cCSPc+mwQM7zdXzsry1zl8yHbMHZQVmBqnk/D4LL2rP6yJY+4LyagMn9HrCkzDShh4VdlK9ikMxRjZbUrMKel1ngvqhAk+q3pSbhLFs7STb1+Ka2n8gnyVDlaJxS4QZLtcSeKm4qCTGdtKc4cyp8LBR5hbdZ2sjo/KbOq4u41U7Wn92F8L4rBSRq+Ks3+ejKUQOqTjYW5TBhfiPy9TWENpMaOl6bWi0ZlUJn6R30j1I25jBBMKAX3TmcpO2BClcA+AmEjBKKHghedIonixi7z+IxoQ/wdaXRisJSqOSveJoCmJCq+ReSFVD2u6jYIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oH81ja54IaX+Zu/3u41kSiSAeCse4yAf5fOkQMZdbE=;
 b=f8VajZ5j4pfbNdWX4lQLq/91nBK5HAYnh3vumnMS/AusPZGd/ehNY8pCQg39cxKDkWouLSZ6yjaG5nHR7GweVo7he9vPSIzcs7fpPlk+Q4ifBhXnKwiYYbFExR2mk+u1eEP1hwHPgRiG1SFNyclhq5WwL7P84WpbPSgQJfykvSbXwvNnF28Wua3upaG4jx3ecZUIIZ3nhTVvYr0tR01EG/efkmiEoNGnwztYwLDYQZV6rX/rf54jfl3S+OZzOQCMCOdxQbECFN1m753mlNbw0zi1d2Dc8y5cmQCMmLWc9nKCkReNWTpY2HtyoRnnBOSySPTrQVysrOSGeQOgD05NWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oH81ja54IaX+Zu/3u41kSiSAeCse4yAf5fOkQMZdbE=;
 b=rV/9xDED0pqJqp/kEh+TzpTyGmJgfU16Ck0LzVqdRjMvm8WbtZaevGCx3hHILeTWlD4qYmhV1wLXI1x60xK3+zu7RTGq3QRNd6Zl7GL0A7a26cBni0PIdHwlEs4s8IQEsf5wAhDCxSddLMnfkJbo4EOqtM1BlIV1IYdVgq0kk3rrVifjfodbV4XaAZjFwmVjOa3KV80uce7SZfd9XEWIz7rh0Gm6nISRoPVKs7OE+XtOlamzzBNgyuhQhB/p4BWPYRbWw9yX5Z6ZzmnSXLDo3HlzeLjfgwEEPraUA20PAt9O86eLTebGxIuJfcBinoVho1gMhuj6qng7DJ8aKbTNBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23)
 by SJ0PR12MB5438.namprd12.prod.outlook.com (2603:10b6:a03:3ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:57:30 +0000
Received: from MW3PR12MB4409.namprd12.prod.outlook.com
 ([fe80::f803:f951:a68f:663a]) by MW3PR12MB4409.namprd12.prod.outlook.com
 ([fe80::f803:f951:a68f:663a%6]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 12:57:30 +0000
Message-ID: <e37fe712-4e0e-229a-a07e-52a0d486819c@nvidia.com>
Date:   Mon, 23 Jan 2023 14:57:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
To:     Sagi Grimberg <sagi@grimberg.me>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Bryan Tan <bryantan@vmware.com>, Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <6f9da88c-f01e-156b-eb19-0b275c46c6b5@grimberg.me>
Content-Language: en-US
From:   Israel Rukshin <israelr@nvidia.com>
In-Reply-To: <6f9da88c-f01e-156b-eb19-0b275c46c6b5@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0194.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::9) To MW3PR12MB4409.namprd12.prod.outlook.com
 (2603:10b6:303:2d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4409:EE_|SJ0PR12MB5438:EE_
X-MS-Office365-Filtering-Correlation-Id: b6380cc0-602c-4a8b-1dbe-08dafd41629e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3kGmea4HoiMh+ozNWXEnjTOfINt84hZOx8ZmXsaf4cBWmwViOiAs/CcMV/uP5R3bcV4IaFml7vGf7fJzom/u5+y7gBvc14Zcdvxv7r+gN3x/f6nL82hE5kOo36MxIbVfJF7gPSwLFKDmBoWdHksXfuYZ9y7At6HkcUbSyj0uKBObteIwXwx2lr8ITmcEjqJeAAw6PkPtONITiXvbv5ZlYiO2WD3RtFAB1MPAkvwvYxuW+vke8+hNDosdFPgi7iGRFB2DDRVjTmmkzpDb0I79dJ8Kb7bDMe5r+ddkIjbqjXI+VGdBqa5tVMXMbiJJ1B/cPduCCVxiZkJ9XV9YCzygu1JdLQgu3W1n3JX9nJRmhqNSAnVGEyb/QqM6XUKKpqEVhVzXi4k19PYqN7pdnAZcsdgpi0jsvtZF4AHZ7u1F37I3wb6X6YvQ3vy5Kzd38zQQVfrvRweuH6S4sSD2ic+p0ipYQ0AV+NOOJQ5bmf3n37XAHjp3YT71+3qMMVoKtlAEq9JmLw576Ygb3M/StmDt2fe4XZIiIG2HI9gP6HNFlWsALPqGFbPaVKlUhgyCqooGUZENHYTWA1eEso8NFpUBrnYkZPPuP3kbOxBcuYD6cRe0yEDj43ZJfY74UlTsHJN2ik8DrbHpqyKY1hryvcJAxyT+5dBQNkOblSsqAeFH62P8/eTQtYHv7obntakCjEcNVYhkCSBKdhQdpdPe96T/sz5ylqqMTqh5M9CofoQdBCw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4409.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(31686004)(36756003)(86362001)(66556008)(66476007)(8676002)(2906002)(5660300002)(66946007)(4326008)(7416002)(31696002)(8936002)(38100700002)(6666004)(478600001)(107886003)(316002)(54906003)(110136005)(6636002)(6486002)(41300700001)(53546011)(26005)(6512007)(83380400001)(186003)(2616005)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0VzSjlXN0VsbUtwclF0c1AyZGJnQTJrUFlGN1FoNGZzMGd5SlBFZUpMQTFk?=
 =?utf-8?B?OURvZ1pjTTh0VGJtNnR2bEIrUHlkNGppQjd2VXVTOEMxa0pWRDh5Tm1xNXBa?=
 =?utf-8?B?LzdiaFBScU1ycCtqcW5XZk5TdVZkT2wxT2M0U1cwN0hvQllySC9jbVFVK3JV?=
 =?utf-8?B?T1l0d1RlU0duMWV2ajFjZVBRSzFuRUxtK3p4bExaWFAwOG9DbEpwZllTY3Za?=
 =?utf-8?B?cWxNSDc5THBNdXR4b25Db05KeHB4b0RyWGFXd1JEdzFOVXVUS3pVU01KS0FV?=
 =?utf-8?B?eWQvcVlidEV0Z2JDc1pxWUZxdGxtd052TlBybm5qK08zZHJmYW8weFl2aGxN?=
 =?utf-8?B?aG92aVdnRDJudk9rK0s0RkdBUTQzaVZsZVMyRXlXbXlsODFWdHp0K3lhQjdq?=
 =?utf-8?B?SFUzN1d5dlRYN2NxUStrQ2VZQUFjaXkyaHpER0pGbkc2YmJhODluYVk2d1Vh?=
 =?utf-8?B?bnA2NHN3dlRFYXBWbWhHODVOZExHdHFwRFhCVjdnMDJWMVNTaFo1Ky9ha2k1?=
 =?utf-8?B?QlZCVHI0SXdIQ2t5UWpCUFgrbGVCL0IzR3JUSk9Kd1BzQURReG0rK3Buam9o?=
 =?utf-8?B?RzBMUk96bXJrNWJaVFRLeVFXNm1UQllMeWRjQzhlR1ZIazdDYlFpZU1TTHl6?=
 =?utf-8?B?Lys4cDRFKzRSRFJxR3JuRXhOU1VmRVRRMW1QcUdDME5lYnNJRkRKQUQ3RFRO?=
 =?utf-8?B?TERBcnZwZGR6OTdIb2hZRHVHdDgvY2swMjV0U3htc3BDdHhvUUdhUkh4WXlJ?=
 =?utf-8?B?bXNTUmVxVnErQ1V6emlBa0ZLZzNPYWUyR0toa0lhRThXNEdMaGJmSXlQU0Nr?=
 =?utf-8?B?dExWTVFqVFBCcThoV1d2bVhlWnpEQkRNeW02YTZxa0F1RVBNMlYzd2pQWEZB?=
 =?utf-8?B?eWwwMVpCZFJ0V1NwRWpkOEdORG5tZTRKanVZb2NUM0wrMFpuNmpRUXRFQmI5?=
 =?utf-8?B?YnIwamtIQlVuMHFia1BkdzliZmVjRVNEMkxBZ0tIOHNZZVdSVUk3NzhFdStE?=
 =?utf-8?B?VDFkdUtXYmJSQXRCem9sUWpRSTFCWlVVajdQVEVrZmtYMnhMSTdHZ2s4dHlM?=
 =?utf-8?B?M1I0RU45RmEvZTFnT05naUFBd1E0dTVLNmVoaTJNMFo1cEJNQkxXMmlUNTJz?=
 =?utf-8?B?RjFYQ2w1TUE4VWVFd0M2RnBXYzhYbzZJK3RVaStUQktYSERjdmxZVlA0V2Qr?=
 =?utf-8?B?QUNrNXozVnNjYTlMU3k2NFNaNGMxYm5vOXd2dTBoK01LU0J3QWpoMFVGYWtu?=
 =?utf-8?B?cmJSdmd5YkxVRmVCV2diSk56Q3cxakxnVUdkY01jSmFwL1NNQlptUEQ5dVpU?=
 =?utf-8?B?MWxHbCtVTGZCekZCaEo1TGhVYUpSWGtrTHBQdjNCVmVWWXVKKzlXNGg5eC8z?=
 =?utf-8?B?TkxCdUNzcklaUjlVRW9TVVNXdVp4VCtrWXl4N29vWWx4SjlSNEYxdGhrcXJh?=
 =?utf-8?B?TXVKNFNjb0RIdUpBbXZ6TWd4QXpPZk1zWHRKSVZ5eTMrUTJTczRMQkp3L3Nz?=
 =?utf-8?B?WjBjdUx1d2lGUHFOWnErQ3B6VWFSS20yVjhjRGJLQUhDRXprRnkraS9SY21T?=
 =?utf-8?B?bGhIeng3K0lPbTZXQXRjdDNRSTkvVWFhbzdtWHc5dTJaWDA4cStlOTZHMUdS?=
 =?utf-8?B?VG16NzRxblg0ejYxY25nQzQxZm9HSnlSZzlLbkUzTUU3cW5FYlNtRzhrL3ZV?=
 =?utf-8?B?RGhPclk4MUdGZUZ5c21qaDRvTHJkdnYzc3pHSzlia1hFTlFSTFJ6bDJ0U1pX?=
 =?utf-8?B?dVpEY25zR1V6aTVRcjJmQ0g5dDZCbUt1c3pkK2tCN0htR1ZsdGlhTkNuNlR0?=
 =?utf-8?B?OU9wUzNFZFlCYVNoTHNRYnlqOVBkcS9JTVk1NGF4TW5wU0ZVMEdXbTcwKy9z?=
 =?utf-8?B?eWp5WkhRaWtqQ255RisrcU9RazJjUHU1ZFBWZy9QYmNyaUpXY2luc0VLL3hz?=
 =?utf-8?B?NFA1TmlFeWR2ZU9XNklrZVBENUExdnNuS3dkMVdvdnhhcHZnQSs3UmI1aEps?=
 =?utf-8?B?QXlJblNLbjNVZTI4ZWUxRmhYOVpLMlpZNVVHQk44RHFueE93TkxMK2FTWEZv?=
 =?utf-8?B?dVlQb3llOU9PYlZqVWR4Tld4UTNSTWpTT1VzMFhZUHlyTTNoV2x0RHRCalAr?=
 =?utf-8?Q?p1ZrOtVKx6m2O0KpptCXRmnDu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6380cc0-602c-4a8b-1dbe-08dafd41629e
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4409.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:57:30.0108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXI5E2EUx/sl4Q7tXzvGLBcxsyOJZpPcPYYi5ldrRXHlKWn8a0YKfselsVnifixPznHCQiVANqPBrmGcQFZpvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5438
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sagi,

On 1/23/2023 1:27 PM, Sagi Grimberg wrote:
>
>>  From Israel,
>>
>> The purpose of this patchset is to add support for inline
>> encryption/decryption of the data at storage protocols like nvmf over
>> RDMA (at a similar way like integrity is used via unique mkey).
>>
>> This patchset adds support for plaintext keys. The patches were tested
>> on BF-3 HW with fscrypt tool to test this feature, which showed reduce
>> in CPU utilization when comparing at 64k or more IO size. The CPU 
>> utilization
>> was improved by more than 50% comparing to the SW only solution at 
>> this case.
>>
>> How to configure fscrypt to enable plaintext keys:
>>   # mkfs.ext4 -O encrypt /dev/nvme0n1
>>   # mount /dev/nvme0n1 /mnt/crypto -o inlinecrypt
>>   # head -c 64 /dev/urandom > /tmp/master_key
>>   # fscryptctl add_key /mnt/crypto/ < /tmp/master_key
>>   # mkdir /mnt/crypto/test1
>>   # fscryptctl set_policy 152c41b2ea39fa3d90ea06448456e7fb 
>> /mnt/crypto/test1
>>     ** “152c41b2ea39fa3d90ea06448456e7fb” is the output of the
>>        “fscryptctl add_key” command.
>>   # echo foo > /mnt/crypto/test1/foo
>>
>> Notes:
>>   - At plaintext mode only, the user set a master key and the fscrypt
>>     driver derived from it the DEK and the key identifier.
>>   - 152c41b2ea39fa3d90ea06448456e7fb is the derived key identifier
>>   - Only on the first IO, nvme-rdma gets a callback to load the 
>> derived DEK.
>>
>> There is no special configuration to support crypto at nvme modules.
>
> Hey, this looks sane to me in a very first glance.
>
> Few high level questions:
> - what happens with multipathing? when if not all devices are
> capable. SW fallback?
SW fallback happens every time the device doesn't support the specific 
crypto request (which include data-unit-size, mode and dun_bytes).
So with multipathing, one path uses the HW crypto offload and the other 
one uses the SW fallback.
> - Does the crypt stuff stay intact when bio is requeued?
Yes, the crypto ctx is copied when cloning the bio.
>
> I'm assuming you tested this with multipathing? This is not very
> useful if it is incompatible with it.
Yes, sure.
You can see the call to  blk_crypto_reprogram_all_keys(), which is 
called when the controller was reconnected after port toggling.

- Israel


