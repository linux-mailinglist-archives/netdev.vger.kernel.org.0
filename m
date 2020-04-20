Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B055C1B1186
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgDTQ1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:27:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19450 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgDTQ1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:27:36 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KGL8wv012046;
        Mon, 20 Apr 2020 09:27:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=bPx/BPs3T7e4yqb7y0lzIAIgHvBMV0+PJe3jzeCZ210=;
 b=MjRFkgGSPnkl17iknlUMAPp6zRQUK5MgbxSRolkYdhOXMWFCcBkI9WzC1Pzx5eqYH/3G
 vdZUCmtBiY46enohhEv3b46aig59U9yzGtiaRSjKcemW0jjreIfOu7+Mf9d36AIGBQOi
 Cy2V6rNEKamaroNSnhwNoYxg3kYqGR74Jik= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30fycfhdqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 20 Apr 2020 09:27:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 20 Apr 2020 09:27:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kll01P8JBNKK8bADtgEKCjSmtzJrfdYRA/f79eJN9Nn1PBunfHQOASy1xXBzqWYRMAXLHX6EeT8cl6rjRpUH2gnMJMfuCFrCbX/pYe2NF1vM0NyS9UEWGUM9FJo0R+gn4RnsUBdtNLAHo+0pSq7PRi4j0Z/DBJD673VDmJ+cDtBCaLbIhwtCTZPesoF7pjsh7bmpPpMURpsJa9Y5KZrLvnQ0bRqs59zPaEQpBLDKl4AexBftJIJp5MjXGLKaXiGuwF2Mg7Y9HUjCyWXO1FuSYO3u6IREyUGsKgsI+Wyaw8RwdrthDImNjiuups3SQBRTDTapKQwCtkF7l4jPzPEulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPx/BPs3T7e4yqb7y0lzIAIgHvBMV0+PJe3jzeCZ210=;
 b=lCP5jQCfYkfelOENeGNwfW0AwPh+CssSGaNW9w1s6dvwWjtOasLA+7qwJmQjeyJTgOIYWCpu4lPpp2CZt283S7WCGsY6HiKDy6neimScuyeg7GUpZm2gWqTelK4x1q6sjsRTDWFOtwEkP40lGi3RZpKn91NrD8BP+/QuoFC8fMzUatCk0kmbi+T5gyQmMO9D0De02zl5ESjOv4Ryi1/UQbHANt4ml+8iI1I9+/XUV0FwRJzEeGINIbISSFP9rGTwtLvrKkz4aAJrvpL7BE4f8Kx+edGyIZ7x3jN+TGEC0vBvHpEti6ouKGDR6sC0Z6V4I7WEt9BqrWZRxWisoZzqYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPx/BPs3T7e4yqb7y0lzIAIgHvBMV0+PJe3jzeCZ210=;
 b=ZEMhjDqL9puMTLMHtYgdAtwuKkLh1NmqYnPExICe8oZzjTCzsLNLD8GtXEbHNk32C8ZGLPx7mloe4rPhkRwG+BuHz8M+vpHfeLrgpfKY6uRs7wNWoiLoA3fXUWiPoqlxy7t5E1+CAScV8jm3KHtfMOl5gYRDgjp/seyUyIjxDt8=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3206.namprd15.prod.outlook.com (2603:10b6:a03:10d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 16:27:17 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 16:27:17 +0000
Date:   Mon, 20 Apr 2020 09:27:15 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     David Ahern <dsahern@kernel.org>
CC:     <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf] libbpf: Only check mode flags in get_xdp_id
Message-ID: <20200420162715.GA91440@rdna-mbp>
References: <20200420161843.46606-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200420161843.46606-1-dsahern@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR15CA0046.namprd15.prod.outlook.com
 (2603:10b6:300:ad::32) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:ea35) by MWHPR15CA0046.namprd15.prod.outlook.com (2603:10b6:300:ad::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:27:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:ea35]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a769daf-60d0-4f91-af0b-08d7e547b114
X-MS-TrafficTypeDiagnostic: BYAPR15MB3206:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3206B939E00512D165C9CEA4A8D40@BYAPR15MB3206.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(7916004)(366004)(136003)(39860400002)(396003)(376002)(346002)(8676002)(66556008)(316002)(66476007)(186003)(86362001)(9686003)(2906002)(66946007)(478600001)(8936002)(4326008)(6486002)(33716001)(5660300002)(6916009)(16526019)(33656002)(52116002)(1076003)(81156014)(6496006);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lwQ8QSkUnlleFbGxieukYBB3m7zjR/wJR6xwNeRrL7aEkYCNi3nhlio1wX/KJOzJxKM4dOuDyht31qt4nOd3SR05zke46Dq+GT2AslChiKdcPbcwMDShFyvaruhQT9j0svHLpDYI5K0V6ADNrhr5TOs3999vtOEB/DXfK42J+6sEVS039e03z+Rg0BD8a2iAqDH7EPMpyh7oBhWOPrLwqaisQ1bXGf0643n57Y2Bh2KOgndUfMSjxYfoMt3gF00IQZmxBx6Wd4HZQR8lzLd6G818jGiX3fcR9f1sukXCl5FYgpPj55Zq+fwtCqOqx2zMTU/IOOwfV/Jp6r3t7mu+zzJp9Wq2OXspZ0B70TGiqqjO4RT4x9skB1GisOIXWNZWKpjEAhyOgBRaa2FixMjYc3oBMup2pVYbKdJ72u4o5dKYyn3G4o+8vlQGiojFasdB
X-MS-Exchange-AntiSpam-MessageData: SouZMtimmwbOOk4+I9WW6cY55CYb6pVth87m4gZ0bdVsWZ4PWpgyOLK6S/9HSeQw4g8q+AuxW/ZYy0MSjC0Ijh16XUuFUSdG2O7uW3yA0uyy8JzxWiUXwcdOdxaxSYhs2+eE383jXQ/3umr/5nMDIb9QW9QJDnc8uOB7tdOtSn2UWJT8s91dJggp7CAsqsjC
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a769daf-60d0-4f91-af0b-08d7e547b114
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:27:17.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zIGHZXSgYmV9tJ543VZ+1l8L2Q8XDWI7iBoKiv1MKyFoytmaQKyJEBTxInnCdCUl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3206
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_06:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 adultscore=0 phishscore=0
 mlxlogscore=979 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004200133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> [Mon, 2020-04-20 09:18 -0700]:
> From: David Ahern <dsahern@gmail.com>
> 
> The commit in the Fixes tag changed get_xdp_id to only return prog_id
> if flags is 0, but there are other XDP flags than the modes - e.g.,
> XDP_FLAGS_UPDATE_IF_NOEXIST. Since the intention was only to look at
> MODE flags, clear other ones before checking if flags is 0.
> 
> Fixes: f07cbad29741 ("libbpf: Fix bpf_get_link_xdp_id flags handling")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Andrey Ignatov <rdna@fb.com>

Makes sense. Thanks.

Acked-by: Andrey Ignatov <rdna@fb.com>

> ---
>  tools/lib/bpf/netlink.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index 342acacf7cda..692749d87348 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -352,6 +352,8 @@ int bpf_get_link_xdp_egress_info(int ifindex, struct xdp_link_info *info,
>  
>  static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
>  {
> +	flags &= XDP_FLAGS_MODES;
> +
>  	if (info->attach_mode != XDP_ATTACHED_MULTI && !flags)
>  		return info->prog_id;
>  	if (flags & XDP_FLAGS_DRV_MODE)
> -- 
> 2.20.1
> 

-- 
Andrey Ignatov
