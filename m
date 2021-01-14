Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E802F684F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbhANRwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:52:07 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8754 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbhANRwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:52:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6000849e0001>; Thu, 14 Jan 2021 09:51:26 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Jan
 2021 17:51:25 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 14 Jan 2021 17:51:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Km1+3bAu3BH+H3/M48KkskjeYtQub/AoRWdC59m5BHDpRoogbVZbrcHSE0+zmexXs3qYiUlmrpgKUMAQjRPLRRxfOhZWh9JS+1lKEAtpKF0VPJuJhrMj+Cma0rMBzztpqpVQ/hNwFRO2seyurZO0P1KgTPkJ2ma8zDSDDHE4V1RSFxOlsSq2PlSvdPO4sFaqb8EsaY9P+KNYO9nPAIo6Eq5IdSR5PCjGBLIRL5V+kmtGIvXNZcCj5emkmMV1y9RJGs4n4FHOwnsHOozJwXoTsusbg0LeUKi7Z3pdoDEo1mNbc1UbYS8NFrSbBYbWAPrSfUoer4qNzLL2hmsoEMkq3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ABF3mk6Qn7hIJTtomit0hYHqXXJiE31q4gqpI3Q3f0=;
 b=VF3lrrQ49tKcQSTwCZYVKa2DpQTKspJ7ln2sPhjTBFGT8e4uDh3ZFdonJFEVd8Rq7IK5E+ogTpe8PB9ZQDYdR6jIciU1Sg0REvdi1JzGaP2MUmKXsnWzEtWlOgjomvdEplBFVn1SYjWfwo79F2996YF8rMax/waH8yfpeO8/+Fv0nAEzsdnAIhzeQDo/tHnRYV1FN3dahQdXNBXMV3xiBqv7qDmCZThnjK36Bf7aIdy2xk8vhdnc037uIYI/1D1ZgLH9pxDHF46wCM+52t8k5sEt1MU/w5p9UaV4clY1X0xRVyFEpvT7irEQoNmyz3r7y6y4JL4+1TlAolyq2zSvsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: zte.com.cn; dkim=none (message not signed)
 header.d=none;zte.com.cn; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4545.namprd12.prod.outlook.com (2603:10b6:5:2a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 17:51:24 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.010; Thu, 14 Jan 2021
 17:51:24 +0000
Subject: Re: [PATCH net-next] net: bridge: use eth_type_vlan in
 br_dev_queue_push_xmit
To:     <menglong8.dong@gmail.com>, <kuba@kernel.org>
CC:     <roopa@nvidia.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Menglong Dong <dong.menglong@zte.com.cn>
References: <20210114075101.6501-1-dong.menglong@zte.com.cn>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <547a00ff-cc4a-05de-b3c5-14266a3b90e5@nvidia.com>
Date:   Thu, 14 Jan 2021 19:51:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210114075101.6501-1-dong.menglong@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::23) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.209] (213.179.129.39) by ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 17:51:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2eb18db-aab7-4385-9612-08d8b8b502c3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4545:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB45459ACF14955C79D9625E05DFA80@DM6PR12MB4545.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FNUmYjNkE9/V9R8psmdyZghPlVTdQKfLQgi0MROxIE8hy8uX4wwdcV1EgGjr8KwFv51ej25vCiOD6II1Xm0O44ZhLauSiheq4CXkA1dSr1dYw//5sBa6Ed63ZVzL8HUnfls1K4hUMaLKhLMancypjiusz2NAmCsoe41JWHED8v9iNdbZfIhRma8AOtYtspUKBm82Q1U3G4bLkqnC3VPF76Ct3eluXbxHfsVKnRXdO0OE/0n64fY8kbI5jNA21DHpfCv/+TbYG1uDoC92bJNgT9LLD3whgF4F0vm1frwJ9guno6kKT7GCnNvuO5UCAhIegklSNDu6uXqDLkr+srGCpZDaxVcdN682b2h/hr6R709rU4HV2y2+hnz+k8fiv7welfzQcxIvFrrSg93ZVvWALnC/PrkF1PMyPEwzAD8wOdB0OLuEXWT0qY8LHWifn3+j/ACf3JFmboWOJK1TD9CxPtZ5LKLZT+lS8YnoKV0a9HE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(4326008)(31696002)(956004)(2906002)(53546011)(31686004)(8676002)(86362001)(5660300002)(66476007)(2616005)(316002)(66946007)(186003)(6666004)(16526019)(36756003)(478600001)(26005)(66556008)(83380400001)(6486002)(16576012)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cktOdEJwcFdQcVFKNUhibjVKaTZRTkl5eXRWZDZ0OUNhV2ZuT2M5YUI4YXlH?=
 =?utf-8?B?ZVErMzVFY3BPemxKVi96Zkt3ckpPVW5UTVFxdEJuend6MXYzU1V6YzFuTHpW?=
 =?utf-8?B?ZmlvNFJNcmVSVkdtamNEU25SU0dYVis1ZzNGVGNsTUcrWURFbnF3WnErcUtP?=
 =?utf-8?B?cTZib2gvcVE3clpadnRnRTM2L1dpSnJNMzg1enI2bGdLU2RIQ2cyYkVYd1ov?=
 =?utf-8?B?M2Y3VE1MbEpjenl6YWNBYzVnNUN4aU9jTHhtYmprR090UkhmeDRJZDFhU0M4?=
 =?utf-8?B?MXpOWERwU25DVkw3KytYUSsrbEFnREUvZDc5Ti84MHVLejBCSzRJRklUMXdP?=
 =?utf-8?B?YWpkM2lUb2NuSGdTZUNSdWd1ZjlOZVh6eTJvUklDdjcrQmtaQ01hNm9qNENu?=
 =?utf-8?B?b09JVWhkV0pEYVhEVXZMai9HcTVkclpjUkJUUWxIQUt4OThkdVF3aEZ4Tndp?=
 =?utf-8?B?ckZHTzdBUTZzcS9LNk9GeXlnVTYwa2ZlMHZqWGloV2tmaWVzcWxBcnlycHEr?=
 =?utf-8?B?Wm9lNm5nd0tPaDlYTGI4aGFFbFFFRVlTZjZRU29CbHJBMXEvWGlCVmJYbjRW?=
 =?utf-8?B?eVFMQnVkcGtIZ3BtakltTEdIeEltbVlwZTByUjhJZ3FaUHhXOVZwM3YxeVhk?=
 =?utf-8?B?T3ZNNFM1Ym1tUEIzcnU3MFVyN2h3NUdxd2NBb3N5WjE3WHJSdUovRzlCcFlj?=
 =?utf-8?B?ZE51Vi95NDhtZmFqRHJkNmVTeFg4b200TVlieENKaFFHY0N5M2daZ2szQ0tp?=
 =?utf-8?B?TEV5SDdWQ1I2TWdibVM0a1M1RGE5WEZRbnFsSlVsRC84eU0yOS8rVVRreXQx?=
 =?utf-8?B?MmUxOTYzL0IxR1ByYUNERmh4Z0k2a1NhdjhTdkdpUUtQU1FvQXhVLytzMTVj?=
 =?utf-8?B?Q1gwb2N0NDlUc2R1djNEcVpBcUpZL2QySlJZZjh1eVljeGpMU2w3bXA4Nk5G?=
 =?utf-8?B?a3dyQVFHR1VsajNvSnlBTGkzc1RtdUlJTXNCVk5ZaXFoaThUZTl3Qm1SSEpX?=
 =?utf-8?B?bEdYZjJreFNPNzVSQlV1R3YzUkpKaHBXU2xaMTlua1cwd0tLenFVRWt6QTV6?=
 =?utf-8?B?OVFjMW43MW5GWVpYOUdXeGJRVkF6aVU4aWYzYUdRSm1zUUZhRjhaNFlGdDE0?=
 =?utf-8?B?UFJhYUZGalNIYzU5QVdYWDQwWkxGOU9SNkYvSkdaNjMxM3R3QkRjSTBFcVVp?=
 =?utf-8?B?NDg4Qkg1WXErTWx6NGNEdERsbUxMa1ZzT0NvTlpWcVNtQU14TU1td2dNZWlt?=
 =?utf-8?B?dFV1OEZpWmFNV1M2OGZJSlo4KzUyTEpwZGowckkwdEZVKzZkaGllTThEYi9L?=
 =?utf-8?Q?lbfkuuPnDbG2EAMp9gmpNqC+UXSFACd31/?=
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 17:51:24.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: f2eb18db-aab7-4385-9612-08d8b8b502c3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j+M0CSteOWK+kBZPwKbd+XM0wQVyTt74LJ6L0RN1bnYb0S+fgGM3Y2UW9zfP0LrrVgGxCYa0ZSCgM1oMQ1v+Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4545
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610646686; bh=9ABF3mk6Qn7hIJTtomit0hYHqXXJiE31q4gqpI3Q3f0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=XDBm0hAE5MX9Bqa3nfMODIECWakC2+WwbFXGdVfnYPRc3COGneNhaNARBrUWfyO40
         bWGo8auZIA8a4dnSRHLTEm43zb/Ws1oEdF4qlqagyzr7tVTP4556XmEKZt9YvAWd8K
         SINZgagkJkbTAhtSgvVMp0Uwd1IE0hh5N0LnwzTTIX+MdJTuLmLP2a5wktUJ5HFZtj
         Pzuc+0DfnaP+0yZozmGbIGEJERfA1tO5qJ3+Hl4RUebWJBJeGfWpCQgn8aQPClQ2pG
         sTtpBXbEMamHOw9fD9wGRt9jK2I/F4VE4T3BdXaTj9KGF4WJnlDjSkrnuFRk363Q55
         +yysLB6LUtEKQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/01/2021 09:51, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Replace the check for ETH_P_8021Q and ETH_P_8021AD in
> br_dev_queue_push_xmit with eth_type_vlan.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> ---
>  net/bridge/br_forward.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index e28ffadd1371..6e9b049ae521 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -39,8 +39,7 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
>  	br_drop_fake_rtable(skb);
>  
>  	if (skb->ip_summed == CHECKSUM_PARTIAL &&
> -	    (skb->protocol == htons(ETH_P_8021Q) ||
> -	     skb->protocol == htons(ETH_P_8021AD))) {
> +	    eth_type_vlan(skb->protocol)) {
>  		int depth;
>  
>  		if (!__vlan_get_protocol(skb, skb->protocol, &depth))
> 


Please change all similar checks, there are also:
br_netlink.c - br_validate()
br_vlan.c - br_vlan_set_proto()

Thanks.
