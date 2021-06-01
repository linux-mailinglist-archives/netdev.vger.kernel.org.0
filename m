Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A285397481
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhFANpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:45:19 -0400
Received: from mail-bn8nam08on2113.outbound.protection.outlook.com ([40.107.100.113]:46689
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233758AbhFANpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 09:45:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDP5/2xGMl5p3Ybd6rdj7wXDWxwySzoFbkyJKDbEZAs7rxJ+sBMP2Z7oJBE4DReid4hHcRJy85KNPazcwarDemWkPJvIvIZViferC1oZL5ivLJ1fFZbLSJ+25BBEYvsO9FH4rBgCu3ILZxSHThPuNzuCXkswKkFb5cfe7L3f9KH5M7qBi6wiouLCFxGkRrbSHudi5Q6rPrCoPJXSFxVo9B1grB2Dfg1ZRdw1CXOxUV9xJdVOjlLtawlgVnAKccKrAzKLzbd1Ctz4gmxsgsPJRLWPmD39SiY+9+Y3z4uqYxMVZZSYNGGY8JGtHZgO3i0YbhPiWBDMa1fWLeqxbU4FZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/5yrIUfCHTbv1CioZJKWbmkXgr2UaiDbqXUSWaP2vI=;
 b=ktfn8Th3QLi/hQjSp0/ef/wbsrYd5m7LKd7Ve4O4L1pXIwwHb0NoKqoCEqIAyY66Ge41s8/WQ130XwEOp3KSkGa1NtjPDaJVWSCOEpxdOO7QGUI/nGxqJcTrcskKcK1WRzX/Jqox4N4Hdt6ZlQOggC6ourxiCFK0yoP66Eka3TTASH9Keb5CJAMM5eSrh0HNJl4GH9e9cVl38k7HJVAF8rTz4Zx2Zc++KgKwAZp6yIDpUEyglWN0QtOtPzpx/ZDbTg8oxR4PTyqqcXW6UxXuxDZ2a+Ij4f60xNJc3Zf/G2OiGop0mKIFNluTumu5TMKDtsRmeI2dheizBVb21LjTEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/5yrIUfCHTbv1CioZJKWbmkXgr2UaiDbqXUSWaP2vI=;
 b=llN+ZYKbfLAzvF3JDUDChvMd+vKVr5vygAy1eQLozLId/RdESwTE50TNSQlUSkTCyziHyN6UuSK8fmvhBtSIaWsM1blEiIsNUlcq2wJMGUuCVytDMo99m3auL9d3Axi6g1rEP/IXWB2UcdWYXdNh3XR7/C4tVkj8Ej7rsc6AqBY=
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM5PR13MB1689.namprd13.prod.outlook.com (2603:10b6:3:13a::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.12; Tue, 1 Jun 2021 13:43:35 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::596b:d416:7a7f:6a34]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::596b:d416:7a7f:6a34%6]) with mapi id 15.20.4195.018; Tue, 1 Jun 2021
 13:43:35 +0000
Subject: Re: [PATCH net-next v2 8/8] nfp: flower-ct: add tc merge
 functionality
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
 <20210531124607.29602-9-simon.horman@corigine.com>
 <CALnP8Zb_MPukyNrFNWN9+--bQROQOqTV=K_cLngR_kmUMNJSDg@mail.gmail.com>
From:   Louis Peens <louis.peens@corigine.com>
Message-ID: <3bf36f32-58b7-fc24-bea8-ab4886888cb9@corigine.com>
Date:   Tue, 1 Jun 2021 15:43:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CALnP8Zb_MPukyNrFNWN9+--bQROQOqTV=K_cLngR_kmUMNJSDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [169.0.222.115]
X-ClientProxiedBy: LO2P265CA0238.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::34) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.103] (169.0.222.115) by LO2P265CA0238.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 13:43:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 361c410f-7ee0-473c-028b-08d9250340b6
X-MS-TrafficTypeDiagnostic: DM5PR13MB1689:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR13MB1689A0F1159EC6BCEF8DDEDD883E9@DM5PR13MB1689.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jZvOvcZ5ZQRQbfn425a3RsUsiB2iM9UlJg5x1tQ32ogC6EAhhAHaYF7p4KyMjJU0By/vsWHMS6mM88E0bIQD9gJyNDQFvijRDWdEP84l9Ebq4D+BSXA/wxcFewB4oHtsHj/piSLScdw7/DcfZDu5JcRUupeIYDDuiPk9ZnKF8qPJzdCjwD1wA8X4JU3vdsY9V0Wt+cHdmKL3rPgQUMvNvOiN4UnarixSmTgFgly+FOrqBeJPeTaUyvZxEYmJSS1ZGLIUfZdd1/LOhZbZURcqy5Cw4pfgXZ9IBs8aLUTrsnLIdaIRaBVgQ2y8brnbpTqCq4teHgNgZep6fJiXK9OmCQPVqozVmO7RPRtCYMw/DpjkLhfEk/OHTfuUzjGh9ty4Spjya+uIjDaBHnalCPyqGv80QvgWLFIUIhZ3AI0ssaXxVTIgxWylCRt7VLnWDc6V+FtEcHyk//OhZN3YkcIx9mvTUmgxCK0evooGXSIiQdcxTXj9GikCtsPSphc7PtZbHgijOejX6k6rakrCXx2uyZPF1PyhSbJHOTvWEoChDUziN4nYUrHntfLHB013DJGAfodUC2lK/f6mXvY80aUO39CFiVt3Thy/PtER13X+n0O4TBMzd5Al0VmZHb8CR1+XbolXd1DGxkFqqR/x9H91Q5G5FaKFM5byy9ocydKTjHkVFE2wmYSQaL9VqyDYtfKkLKVfn7CyQ/LWzFu8TEkO9P721TJO6raaQpJTlFBKw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(136003)(346002)(376002)(366004)(38100700002)(53546011)(31696002)(6636002)(4326008)(66476007)(478600001)(8936002)(52116002)(2906002)(107886003)(8676002)(16526019)(44832011)(2616005)(6486002)(86362001)(956004)(186003)(6666004)(26005)(55236004)(31686004)(316002)(5660300002)(66946007)(66556008)(38350700002)(36756003)(54906003)(16576012)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QTBtZ0cyR05JQmpJbzhLdGxwbVpHWVlOcFo1cStRUjB0V25ZT2QzU1c5V3Vn?=
 =?utf-8?B?aGhTT1Q3blYwQS92NldDRnFwSXBHOXVCdXFhUGNLSFJUSjloVlRJa2p1ZmE2?=
 =?utf-8?B?OXhwZkx2MlA2dnFROW9XSEd3dURYYi9ZcDZQZVB3R0lJWFFNeTdDZ040TFR4?=
 =?utf-8?B?VTB0a09kT1lVaE5TK0Y2WFFyREZQbEdkM21QRlI0dTdNSEVUMisvVWRRQjVq?=
 =?utf-8?B?SmR3dDZCbEFQcW5abitZNjhuaFRiU2oxckw5cE93dDhCTHVFcEtQbzE3WW94?=
 =?utf-8?B?TjAvTWtVN3M2cDRhZlhsQzBpbHJGWktWRGsrZHJZU21LdGhWbythZFYwaFNT?=
 =?utf-8?B?eUdPZHlsUXp5SG1neDRGUlJEQWpjSE0zQlhHRjg3TG1tWmhiOG03WTV6ZDh2?=
 =?utf-8?B?SGdMRUtac2hSeWEvNTFKRDZKbVgwMFpjQWw0VWozNXBmcXg1YlBKN1ZLVHhX?=
 =?utf-8?B?Ullhb2FIQlgrazFxV2JUK0hHYm9sbHN6eXBFVlZ0ZlpFSzhoOVl1Z3dlU1VU?=
 =?utf-8?B?elJmeVQwODNkNlFFZmx5TVZDWC83SFRES3BsWWVvbmtzNFZrQnNlRVRmZjU2?=
 =?utf-8?B?WEhoTGpoZzZCd0Jsc0krVVQzWXBjcjVpcCtPeWFDNkhmVVZ0ajQwOUoyNVYz?=
 =?utf-8?B?aHk3aWN6L0lzdzRRUVFuQnZ3bDZhUGFPNThoVHQxb3crbWxNQWIzcFFOMWR4?=
 =?utf-8?B?U0x1d0hnako4QXBHajU2ZzI5R2RUNEdLZFFxdmowWFFrSDlSMGFCU2FYUHVi?=
 =?utf-8?B?SThsVEpucnlCc2VDUGc5b09NSG1PZW1lOFIveWdCT3JEc0M5blY0dDVzVHBs?=
 =?utf-8?B?bXlqWVJYTTUzM3ZLamJvaTlZc0VEd2V3bU1GaUdheEJsYkthRU00bVF3OG1o?=
 =?utf-8?B?bTQ4ODZEY3RXS3owOEVxbTdSR0VzRnNDeEF5OVlRc2lBVnVqNmZSbW1qRlo4?=
 =?utf-8?B?cGxUVnkrcWFCRDdDWjhPU3k1MTlVYjJLbHY4OHNvZFpKeEcxQ09NWEIvQWRj?=
 =?utf-8?B?OE13VXRraFlSQitENE9NeEc5NUF4R0xXamNaYjF2cDlvUC90b0t5NUlzQ0RK?=
 =?utf-8?B?NzRKOFNKRVRGa080eUFlcldWUWlCWUxuNHRaMmYxWmJ5TUszT2ZTUTRVQVRM?=
 =?utf-8?B?SXRSQXBMalA1UDk1ektUbk9CTTFyVy9JcHhsSnUwaUdrc1czdkxoRHhxWCtU?=
 =?utf-8?B?SElrakVDN25WM2lmWU9SSTA4M3FLa3RtbGd0V0UxMGJsd05sbXZQK3V0Q2lE?=
 =?utf-8?B?MzRwcENXejdLbnhMU29xd3BJSGpEeVBxa09UMG51dUh1eTVnMHErZnhVZlVV?=
 =?utf-8?B?YkYwcW8yaG12YXdmMEI0ZXhCK0tyUjg2OXFDcERpaTNOM29sajA5dTJzSisz?=
 =?utf-8?B?UUpIdnlsK3RRMWF6R0FZeGVPYjVwVE95T0IzWTNYRCtSNjRBTDEwU0RxbnJL?=
 =?utf-8?B?NjlmMzlueW0zMUZ3V1dZTGFFQU1MU2NPWHA5cVRPSDN4ZnZ0VGt0ZElvZG5m?=
 =?utf-8?B?NCswZDVScWxqMCtOdXlJbE1WdkxGMkU1LzlxUk1LN0dVUGVWRWZ2NFNQTC9L?=
 =?utf-8?B?b2hGVnhWR1pCZmVDYmN1WVVpdlpCUDVvaUhPWjhNc3JSY3l1a09YR0J1MFNz?=
 =?utf-8?B?dklzOWt1WlRvb2hoR0hvMUNKY0hhNGdYNk40T1dDa2dJVlBqRHBvNk9UY01w?=
 =?utf-8?B?YTJKRElQUitEV0Y0dStNTS9WNUtieU16bHRDelE5eWU5dXQ4UFRaMlNaci9E?=
 =?utf-8?Q?IgqaQmCsvawYD8M9j2Ays5XY653DrgeRVNRojKf?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361c410f-7ee0-473c-028b-08d9250340b6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 13:43:35.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4PJ6bSEYSgXx+WJ8EZLXIo9CWNuapiAAc1Hvin8PNedN2cNHhakYUjoKy3ASLAZ60JOes9H9pmCdhRpkarCKMAxP9YZlPQ4w35GAbKOiIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1689
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/05/31 20:24, Marcelo Ricardo Leitner wrote:
> On Mon, May 31, 2021 at 02:46:07PM +0200, Simon Horman wrote:
>> +static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
>> +			      struct nfp_fl_ct_flow_entry *ct_entry1,
>> +			      struct nfp_fl_ct_flow_entry *ct_entry2)
>> +{
>> +	struct nfp_fl_ct_flow_entry *post_ct_entry, *pre_ct_entry;
>> +	struct nfp_fl_ct_tc_merge *m_entry;
>> +	unsigned long new_cookie[2];
>> +	int err;
>> +
>> +	if (ct_entry1->type == CT_TYPE_PRE_CT) {
>> +		pre_ct_entry = ct_entry1;
>> +		post_ct_entry = ct_entry2;
>> +	} else {
>> +		post_ct_entry = ct_entry1;
>> +		pre_ct_entry = ct_entry2;
>> +	}
>> +
>> +	if (post_ct_entry->netdev != pre_ct_entry->netdev)
>> +		return -EINVAL;
>> +	if (post_ct_entry->chain_index != pre_ct_entry->chain_index)
>> +		return -EINVAL;
> 
> I would expect this to always fail with OVS/OVN offload, as it always
> jump to a new chain after an action:ct call.
Ah, I can see that this may look confusing, I will considering adding
a short comment here for future me as well. The origin for the chain_index
is different for pre_ct and post_ct. For pre_ct the chain_index is populated from
the GOTO action, and for post_ct it is from the match. This checks that the
chain in the action matches the chain in the filter of the next
flow.

The assignment happens in the nfp_fl_ct_handle_pre_ct and nfp_fl_ct_handle_post_ct
functions of [PATCH net-next v2 5/8] nfp: flower-ct: add nfp_fl_ct_flow_entries
> 
>   Marcelo
> 
