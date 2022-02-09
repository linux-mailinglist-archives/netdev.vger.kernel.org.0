Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779754AEA9E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 07:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiBIGvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 01:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBIGvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 01:51:19 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5750FC05CB81
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 22:51:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBgV7KTXXM15/IhxXQ4wryw/7E7Dzyka/bieVR7bSbz285DvLnFnYeQGuRCp2Fyj8IYtxRgxdS+SJOlfnTqLaC7/UOOAK8M8KkPbG78oBY5nGVia3AivzI4xUbkp62hXc4axWHz/9BVi+ksyBdO+0nB4vjAY/9MOaomQEw9ornXL3IiA9cKbwkcyCMLXhfo7UdKaqKxWhesWclZd5/Ikum5ncshDeYJMR9uTV8PNvklDFJzG1Nylm9HjjwQk1bTeqZfDOTWQWUahg9rjVGzrqs2JoEaiSDZ4MDL3tEOax5YK6FWPoRim78FpJMJw+FXukMXuklOPN+7mXeroSyEmZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=17zvvr9K6cVrw7cktBF9phjqjw/7lDsGGOD6AOIJlS0=;
 b=ElWwLZ9DBZBHzBj8WT8P23rs6vrKKBwIw+S1rWPxRi/S6h02Om6QjjbPILr0InxYI+kTMnG0hEv1crw2NYg7wjbkNuTG+zQEXr0nZBfmF+8WV9I4PAJ6h7BC3wAskFDbeEzqe2IQCg322CkOeba3haA2LESO7575U6DYWlKh06x+lVsVb7r+06xDPwTeGKwmXkiv+9Yc1PVFydUEMT6XxjCGYov71NldU/5NYqZgpPdpZSJ4Af4SplAGY1Blp995tnK6lmFm8qVTn592L2k8f+xjTSVzyU340BCYHR2NVe2Okev38As4f/wPARPwD50+mC1VYYCra+4Ns7ZZjnVJ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17zvvr9K6cVrw7cktBF9phjqjw/7lDsGGOD6AOIJlS0=;
 b=C2mvwGMJ5lUOy7T+gNTr7hUZtHuyLp4s3StsPVnARlJBashv4R7WWKiHWA7TPxPhBvJ0dT8iytccByvFDL0r0B9zCQGkp+H8XGE5BJ/AbEdWtGh1lkDZA7wYJ8Hd7VbtgWyJ5HxXDfqZ5hWAUGlCmcwb0DXHCvczb//+DwIhNen77B4atieDu/7gxd9j93i42mwBNEEAkOs5vhBYBkEp2uopI1ueAki4AwlSZJvB+e5pM/bm8sGMuYqlF3ZPc3PJ3UlgzDfLREbwqDZdzSE/neUPwg1zLMTjyM7WYsren6Kij3upkJGOJ3PldZ+2RFweIV8Dx4tr1Zh1dK2M+uuxTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by MN2PR12MB4470.namprd12.prod.outlook.com (2603:10b6:208:260::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 06:51:21 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::e8f9:fbd:239:2c88]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::e8f9:fbd:239:2c88%5]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 06:51:21 +0000
Message-ID: <e894e2bd-6cc2-2fdc-37c9-1b4f1cda701c@nvidia.com>
Date:   Wed, 9 Feb 2022 08:51:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next] tunnel: Fix missing space after
 local/remote print
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
References: <20220208144005.32401-1-gal@nvidia.com>
 <20220208095729.35701fd7@hermes.local>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220208095729.35701fd7@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR07CA0057.eurprd07.prod.outlook.com
 (2603:10a6:20b:459::34) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d395e7dd-a3b5-400d-64d3-08d9eb9894cf
X-MS-TrafficTypeDiagnostic: MN2PR12MB4470:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4470BB7A39BCB4648612FDF2C22E9@MN2PR12MB4470.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9X7coefMxcKTRHTPbgcr7IxUWX5ZjYxhTMIlxl2XcFSD3Xg8r46bUu/SR5JK1ZXcF0ryWfEeyaV9HO3t8OIt8ERNaZ2DxqLZwgeh2hHx7vq3+BHWRX7Blm/5Mg/J0nN/q3yiRNUYJvPAYnT3fzgA+EJMqQWZC4UXydL5bMXZq/OZcNo6hz3n06Zb8c0yN1AAjrFwwp4AwobxSdkOJaFZ6mzt7HfVXqco/kRPguN5WlbynpxfYSc8oAk0QS9Va43RqTjvBb0IFMqbmGt6nHC1ZyW+7p7T0abCHJb8Trqyou4wnbjAjEAC++TE293O5PrGSle1lnFjvCctCoqwKCBCgTjvbWvT+NDdEfz2H5regnjoyDnymci0gG5taMiQpAKn98XMSTJLpdP6A1qyT8+KowssrANDn2kx+VUJPxBW3gcmoiQKzjOruRJ3tDFCNGb+Lfgq6sX3UufLqFrvm6nBnyrN2/RX1EjrI6LgWB4qw9hl/0+cvtaCvqIJJdvkgGIPpJUyLyuXF9xwqyNwMGcRqXxEBsFvz7WABmRQHrkRF4pcbn2EsIK4z580gLRg488/O9ZOo0JhPHK6PpGivn8ovMBhuagHKc21dtpRw8JJxrRFEgcGSet6l7oOJjQDfZH9jiWEONdS3iq3SlWndNJ51HTpG1AuARSR4eeXoKA8jk3IGN3Jj+o9sVIpY8X4OKd/HfUrapo3Xx1IFH/OXFSHjeRIkT83OXpyO3oKhYfzGU6L9F3jX1m3ZtnzptsyfuAd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(2906002)(4326008)(8676002)(66476007)(8936002)(6666004)(66556008)(66946007)(31696002)(316002)(38100700002)(4744005)(2616005)(186003)(26005)(36756003)(31686004)(508600001)(53546011)(6506007)(6486002)(6512007)(83380400001)(6916009)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2pocDlhUnMweW5JZmxuRzZXS2htN3M1Uy9qaEJTNGRxRk5Nb1l2WkpQWElq?=
 =?utf-8?B?emx0TUZobzVTYVN4clVvVXFOWGZQRXlrUjh5c1MvUzJucVBqRHVhallQWkRq?=
 =?utf-8?B?VTZyZ1dZNDFKSXU0Q1RCa003UXRDcVQ3bHYrMUtQcmVISmZFNTBNd3M1RFp0?=
 =?utf-8?B?MWN6L25HNDN2VU1EOEh2SGJxOFVZcFdxVWg4aHNjOC9vL3FtYzZIV0Iyek85?=
 =?utf-8?B?QnFXSVZuL3hEQUQ5RVNnajAxQ0I5T3pHZExkUWhPRU9IQS92U3FicC9mT1RF?=
 =?utf-8?B?WGlEQ2RadmVZSjBBV1RGRzBoZ1B3czdqdzZDTHVYSDJ1eFo1ajRmWEVveTJ5?=
 =?utf-8?B?YkY2bVhnMmJ3UkgwVVp6Sk9HUEhBMDVmQmVzb0p4ZlBKRjJha3I3V1NuUTJJ?=
 =?utf-8?B?S1pEV2FLK2gzc3VaNlFwQjRLdjc0di9FVTJYMkhObHkvRXcxa0hUU1huWGIy?=
 =?utf-8?B?aEQrOUorQmNmb2hGNTJSWU00dDFQVGZNbTZudjVYNk1Xc2hxdFpjUzF0bkxU?=
 =?utf-8?B?L0VDYnl2dEhJK2ZCTVpQb0txdmNGU2tQeEtRckNyLzJqcXUwcDlwd3NjQzFH?=
 =?utf-8?B?N0w1eEdsNkpSdUhGaVhBNmFlRFVwR2ZHM2Ezd3Zid2RrclRMSHpSeHgwSHJk?=
 =?utf-8?B?ZS83SjFHaVFCUW94ak5LMlh4T0czVGVnR0xpMXJrcWY1anZwQklhUEdmblRG?=
 =?utf-8?B?VnhJSUtxV1FORndtUDN6Zmp0OU96a3lVcCtLaEN3RW44bmQyMDlURFhpWFZy?=
 =?utf-8?B?aUxDWUdLTStLczkyVHRhaXVrNWNtZEJGYzNjcmNJUDkxUmtJckJBTnlZd2VW?=
 =?utf-8?B?ZTVqMFNMWGdWQzRUU20vNzFVeXB1aWdta2RXbVNFUDgvRlVjbDRBbFJoQ3Ez?=
 =?utf-8?B?emIvRTdBWHltTzRGbVFnQUFRNWJtZEdIUGRwRXFwVm5QRDJwclcyZTNmTFBY?=
 =?utf-8?B?YmlJVEorT2ZqUEE2RGVMdWtFNHZqNzlTQkpVNk5HRkg4R0wrT09IM3VNUG9Z?=
 =?utf-8?B?WDRLUkYzVjd5UUJVWVVlWGNSQUFBb1hkK0lLZGI3T01lWk5odUR4S0ZId2ps?=
 =?utf-8?B?UVBDMDFnSVlrTzZVTkFvRjRubTZRblBYY25pcWZJMUpmUm1tc2cwdXE4OHJt?=
 =?utf-8?B?UTAxOW9JN1hQVGU1T3h6bE9VT21HbHJqVTFLRk51MWhUTkJ0Y2xCRDU4RjRK?=
 =?utf-8?B?OWhIUno3VEJmNEZUS2Z2TFRDTWJ3cUJFblMrRDkybjJWN0MxenorY2RjM2FW?=
 =?utf-8?B?UjFwQkpoZHY5dlI4RHp3RVdWSHZxL0pyWkYwY2xaM0t0TlcvVzJRdEdLRVFS?=
 =?utf-8?B?bUJodjRNVUZyYUtvdXIvQ3dwYnZHREtsdGVWL0RkVko4VnA2RVNXM2l6cS83?=
 =?utf-8?B?MThzU3IvS21XUGRlOU1hamhTSzgxUHErTXNLbTIxVEhTS09ia0daL3ZJNit6?=
 =?utf-8?B?SzRIZS9GSHZDOHEwM2Y1bVVKS2lLL0pqSlpNRnhhMjRXNHR6eEpneHJjYkI4?=
 =?utf-8?B?TVJkeTJRM290ZjlQRTlVeHN6Z2p2d3RJZGRENFVCaTYxQ1NnOHg0MUsrQXRv?=
 =?utf-8?B?emdwLytiU0hzTWdpVlRUTWNyVnpaT3ZtTTlRbXRsWHVMM25vRW9MTi9JcEZn?=
 =?utf-8?B?V0NEQTY5QmtzRFZLTWc0S3ZES3VHTjZvVlM5cFRsc2NTSG5oVFI4K3pOZTFu?=
 =?utf-8?B?blpNTndwVTcrNmpoZm5SMDhxanpHZ0pxeU9mODNRdGNQSHdoU3Y0cUY0L2w4?=
 =?utf-8?B?NjRPL0JkV2trT1JUWkpmOU9jWkd1TUhMdXJYTVBEUlFLd0pBWWY2MEljUGxi?=
 =?utf-8?B?YTBzME8rYTczVWV3WDY5WTYrdk5XTTV4dEJJUW9xNWZMQ0pWcGFIMUNJWkp5?=
 =?utf-8?B?TmpDek5wSVVtazZqYzhQemZsR1JOM1NiMjNJZmxlMEs0MzMyL2dDSGlNZWpm?=
 =?utf-8?B?ZGVPU2FvdjRjY05peW1ZeHBSakxpWHdBMVpJeXRFS2tmY0V3ajhwQi9KRURw?=
 =?utf-8?B?ZUpabVlyUEh6bm95Q2Q0bVNFTGRncGtTTytkd1ZhYktTYm1sL2NOZzRHQ1Jl?=
 =?utf-8?B?bkc1cmlFd09LQ1BZS3V0dW5aTkh1OC9GU3ZZdWVub3NQZkxyUVBMOEtkMmds?=
 =?utf-8?Q?frR0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d395e7dd-a3b5-400d-64d3-08d9eb9894cf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 06:51:21.6936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kKmlVtdTNn1FTUyoQDmJ29Pf1x8DFFtJsZqrsyIj5ZXRB+nviRgltTs8lj5f0du
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4470
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2022 19:57, Stephen Hemminger wrote:
> On Tue, 8 Feb 2022 16:40:05 +0200
> Gal Pressman <gal@nvidia.com> wrote:
>
>> The cited commit removed the space after the local/remote tunnel print
>> and resulted in "broken" output:
>>
>> gre remote 1.1.1.2local 1.1.1.1ttl inherit erspan_ver 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> Fixes: 5632cf69ad59 ("tunnel: fix clang warning")
>> Signed-off-by: Gal Pressman <gal@nvidia.com>
>> ---
>>  ip/tunnel.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/ip/tunnel.c b/ip/tunnel.c
>> index f2632f43babf..7200ce831317 100644
>> --- a/ip/tunnel.c
>> +++ b/ip/tunnel.c
>> @@ -299,6 +299,8 @@ void tnl_print_endpoint(const char *name, const struct rtattr *rta, int family)
>>  	}
>>  
>>  	print_string_name_value(name, value);
>> +	if (!is_json_context())
>> +		print_string(PRINT_FP, NULL, " ", NULL);
> is_json_context is not needed here.

Thanks, will remove.

