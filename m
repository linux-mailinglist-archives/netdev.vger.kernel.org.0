Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2453C5C30
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhGLMdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:33:32 -0400
Received: from mail-sn1anam02on2054.outbound.protection.outlook.com ([40.107.96.54]:22337
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229950AbhGLMdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 08:33:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yw0j5I7VQJMvBX6RwQl/RtuPLBdqi7XIiRitQxZk7Yhwgyq2YBaR6eIcF4e/1dGHRf9YV5+lEe0aRaekkd+lpdaBHZQKozSi3w3xr3cczBCsffeJmEi9pkuAuwwu7h6O9tnqUxGbMx/x5hnn7jxkR9wlrfOP3gJopdTYHwEDY1uRq+UFC3PQRUFjIQZRYzs46Ut9C8qsHzjSSU/j3p9QDp9ezCBok7vjzQb2s11HxSlr7X/hr0EmGAx/Z6DsbeEPIpngcgXUB3tRUopzew006roDq5D0TQECYUcrEOEtnXIDKXKdK7QSP+b0okjneW8hhKmV5cUeaWza2cODWU/lZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fr8qWNUoJPOeDUp21HLaOYeSazf7XRNJFtPNpjIyvWo=;
 b=QmO6Ql0sz3RllxBjKaRLGRtVBErHjb+ekZR5z81N+DlVYzeKAVIfHuR4lduZHct+oUlf4YEP2xcuXPfR/E4L+JP7qy9AB6c8F+bvwa/HrYwmL3ReVE4B7Li/3CsPh9EnTMVq1CIW0vXxFXaQS6PJBKacEFP5gi2NY3qp8Qhd81tofMTrfwHxPslxgkgK97lQZJtdCkejCDDI89uTkkA8yN5QTFNPlaMmD4trXiww0s2QOMaNVRtrOYON2kWyWsOFPCxYFx0JJmb6X/RTQXamo8gy6GbzMMDfksat26SCeNorjw00sv1J2Xmhp68SnRBbtMTPELTjJn0GbnFxOMcP8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fr8qWNUoJPOeDUp21HLaOYeSazf7XRNJFtPNpjIyvWo=;
 b=HIel2V4F5VdTr07acZJ0wICUFzOnOsp3jq3DTifaAOQyS/2Ylno6+06e1FbJFTAx405SkMSbbhAfWkcARlXVlV14+FYmNEXd+uMLBYLiXuf9dW/ex5Ebd2dCdIUOYgf91PNAXuhYZR7UxETpktKstZMFowNEHcizMpiBA/s8XhuyIBC4EF7JZSYBqz14QHwJjOBd/GXXX29ZDlY1LHOJ/8zbqqAY83lfvE7t4Tf6qcoIKwtx5UW35ZSL4t6n9HttcbE3SsRQqrcgD/djBshbE99f9i8w4Uw4Iq8LkWlOG73rnroRReRgO/gtZR6V/Wze3OmLvyJnG1ab/9py+rxfSw==
Received: from BN9P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::17)
 by CH0PR12MB5124.namprd12.prod.outlook.com (2603:10b6:610:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Mon, 12 Jul
 2021 12:30:40 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::be) by BN9P220CA0012.outlook.office365.com
 (2603:10b6:408:13e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Mon, 12 Jul 2021 12:30:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 12:30:40 +0000
Received: from [172.27.12.28] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 12:30:32 +0000
Subject: Re: [PATCH iproute2 v2] police: Small corrections for the output
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "Paul Blakey" <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210708075751.3687291-1-roid@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <78c3e392-c885-c6b7-48c6-c6712cf2798d@nvidia.com>
Date:   Mon, 12 Jul 2021 15:30:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708075751.3687291-1-roid@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4a21598-f1e8-4021-5ba4-08d94530dc6f
X-MS-TrafficTypeDiagnostic: CH0PR12MB5124:
X-Microsoft-Antispam-PRVS: <CH0PR12MB51245A7BE42690B14F34E34BB8159@CH0PR12MB5124.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:152;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ywelNOZymZS+aAQ6zQk1EjjsVL1XlPLzgrmiHMPz/HdcUa3RjvvTZUQ2QWwd7pO3To87Go6JfL910cOWzFEPUHTawR0PY3mDi6Brr+T+AaAW9vJHNivaFMtWv42OAEHEqRfbcsc/ot166nVt9McRAgy1wKVqoCnNk21+bjMHfbsWO0hEmCOnOXRKhqCu5uMR4vFeVtTaGnR07HRePPxe3dtAcY0U6XM+/xcERIe8N03LKBcBm9E/Mxs93msrMSxjRjX2lD6/XdniyY95Q9jqtDWQcDcDqwzHrFstr7V6hv77kLX7Qp8GWXggCOS5C4K9f22B+KWFaNh2EfoV3GvHr3WRDWJwAutGkt0Il+6oY89+PMVl9sOcQJSjS6YjX+gwBtrZjvG7mymA6sEmw54lL0HYGC9JQobcHorLj1cQLrGJ4uWuJnHPmzk7T66MsiducyBbgSvmV+q81741n5L+mNAZhTLaBfGcTd2Dz4ZmLz96xoH0xJqjfpSj67DSSnUQUIPDtl3TVRvAxcXlUqncrlatiu07qsXDpFqh6zrKYgU6lG9EpioMhMHjKSdmgzfR3e5Dmysr6OwLN76f699hpgRIy80iJ0nTz9SkfcybRyK5AnV85hM8KkQTYnEAhiW1MBhtVdgsMMlp/fl7zGZanhz0v5CwwZ4aYq6uwJRV1InonIG0IhtJqwzWmUTlWc0Gd2Fu9lBjJbNr0GzLuGoKevMpHi4dOVpBNejucbwYSUlIoH55fhORh7mLRVwVIT+YwZyt1AvbVp5/Xz4dL2uzdA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(36840700001)(46966006)(83380400001)(82310400003)(336012)(70206006)(47076005)(316002)(6916009)(36860700001)(2616005)(16576012)(31686004)(82740400003)(36906005)(34020700004)(356005)(4326008)(70586007)(2906002)(54906003)(86362001)(7636003)(5660300002)(53546011)(16526019)(186003)(26005)(31696002)(478600001)(426003)(36756003)(8676002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 12:30:40.6829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a21598-f1e8-4021-5ba4-08d94530dc6f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-08 10:57 AM, Roi Dayan wrote:
> Start a newline before printing the index and ref.
> Print overhead with print_size().
> 
> Fixes: 0d5cf51e0d6c ("police: Add support for json output")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
> 
> Notes:
>      v2:
>      - add newline also before ref.
> 
>   tc/m_police.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tc/m_police.c b/tc/m_police.c
> index 2594c08979e0..d37f69b73e71 100644
> --- a/tc/m_police.c
> +++ b/tc/m_police.c
> @@ -301,7 +301,8 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>   	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
>   		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
>   
> -	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
> +	print_nl();
> +	print_uint(PRINT_ANY, "index", "\tindex %u ", p->index);
>   	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
>   	buffer = tc_calc_xmitsize(rate64, p->burst);
>   	print_size(PRINT_FP, NULL, "burst %s ", buffer);
> @@ -342,12 +343,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>   		print_string(PRINT_FP, NULL, " ", NULL);
>   	}
>   
> -	print_uint(PRINT_ANY, "overhead", "overhead %u ", p->rate.overhead);
> +	print_size(PRINT_ANY, "overhead", "overhead %s ", p->rate.overhead);
>   	linklayer = (p->rate.linklayer & TC_LINKLAYER_MASK);
>   	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
>   		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
>   			     sprint_linklayer(linklayer, b2));
> -	print_int(PRINT_ANY, "ref", "ref %d ", p->refcnt);
> +	print_nl();
> +	print_int(PRINT_ANY, "ref", "\tref %d ", p->refcnt);
>   	print_int(PRINT_ANY, "bind", "bind %d ", p->bindcnt);
>   	if (show_stats) {
>   		if (tb[TCA_POLICE_TM]) {
> 

this patch should be ignored now.
see "police: Fix normal output back to what it was"
