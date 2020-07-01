Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445F6211581
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgGAV6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:58:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28236 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726942AbgGAV6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:58:10 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 061LroPd025388;
        Wed, 1 Jul 2020 14:58:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Z/neJdmZz7gLa94snsiKxLxCT5WVI9Mb2GrP0wwgStw=;
 b=gkSMPNQ+H6pQpVeIXExH6MTvBvW74q7YNlMX+8H52HOe4k5WhWoBbKxFo7gWHbTGnd2k
 wPZCl6YX5XtxBPVsw2w6/DoSNTP1o9KgqW1DdDDVIfX76RTy4iFNxuJwJijQBVBdm5M2
 cTmtb9z0zr+2gGnGm4J5Bg5o5AsVhFhy+Kw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3xh45uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Jul 2020 14:58:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 14:58:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+Oq2Qk99pFwgmddQPIc9Zl6nJ4lxFnsRnehdTyTvarISH3SsCx2NZ5ewUT95sd2pFoDGD4KQjkZZp4JDtDIGE5qKfy/91jgBAI95tfrpeTFxLSMuMpEZRe7FdvJE5X8Z9YsbpWPLQCYZSIPfi6WlaSqZCHjdMtgC4vOclYdd9t/vzK2isp6N+O2n0fDMkiTLEDXmo+2iIz5iR0RYzuRwBaO4+cqQJMr5ZOdQtkAbu1+0ioiFvHwykozO5S8rM62d3l8ZAEZeGDfKAnb18sRbsTGphBg3kIlrDV2mzAk/mIB7b4tH6n4pr095A05zSZ5KcBAP8Mn1ED24BAT3PxFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/neJdmZz7gLa94snsiKxLxCT5WVI9Mb2GrP0wwgStw=;
 b=QNfJ73+2GBsmQqKHo54b1BULhPgJ/roBXaKCPaxjN/NuwOhatxD5547ItE0XvmCCjw/9WwH8wQ27DcAFOpr90Jf2FkxBdUfl/Fq0RpXlbGpLjmS+2CoKBEB1R/ppJEeQwwXGgF6XqKIYpfDRvrTKkMJp4nb5O4sluRBvMMh5NiIlE2/l04GZREoSFXxkAlJLWNZw99m89h6pp6G9ROKxh5iwLPzb4N6o31U8f5Rf2z3hVnwrLxwZjw9EZ18TGqAlc50xeENUyxhzNKtao0i5blFKEYSE54Rfv9pI+0HLKIsd624EHQL68b/5MEIYokxzDguCFQjftq5AxDx9QU+Jkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/neJdmZz7gLa94snsiKxLxCT5WVI9Mb2GrP0wwgStw=;
 b=AaN774xgKY7e7gTgoxwzLoazu1qQoT8FW+wHzej5fE9SuEmP3nuDpizO0YXn3F5gc2GaviuPzddDvNdJ1GHe5bJLeDtcwplRjZ7CH6wKCdHXosajYENUvlOa7P8o+/jmDgMSeAuNLGVetlBfqN7kCUqBpCnu0z32LFY7DFens+c=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3734.namprd15.prod.outlook.com (2603:10b6:610:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21; Wed, 1 Jul
 2020 21:58:03 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.028; Wed, 1 Jul 2020
 21:58:03 +0000
Date:   Wed, 1 Jul 2020 14:58:01 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] ip: Fix SO_MARK in RST, ACK and ICMP packets
Message-ID: <20200701215801.5bpdv7xyxmr7v555@kafai-mbp.dhcp.thefacebook.com>
References: <20200701200006.2414835-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701200006.2414835-1-willemdebruijn.kernel@gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:a03:117::16) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:9113) by BYAPR08CA0039.namprd08.prod.outlook.com (2603:10b6:a03:117::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 21:58:02 +0000
X-Originating-IP: [2620:10d:c090:400::5:9113]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 184b50b2-452b-47e7-60d1-08d81e09d3f7
X-MS-TrafficTypeDiagnostic: CH2PR15MB3734:
X-Microsoft-Antispam-PRVS: <CH2PR15MB3734D0B4D3FDA5B0208D100DD56C0@CH2PR15MB3734.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGf+D/5gPpB5+mFoGaT1s2qMyQR+7FEOeIaQKSZ4RM5eUCjXB7IeelnD6GoEpe5lfKVqWVdHhmfH7ERn2D82osRA6UaWaV8ePoKic2m3EuQDhZCvBBxI9vWt3JVIF3nbJLMw1wq6ob2mChdpAnv4oY5BDrUG6gwE768b5pn3inCsVmJfEA4URw7IIW5ru3sv8+1i80khFQZb9POnbjeAj3vDxXaJPIvQiQkdyFZGYvJifceOjrA2gwzqBEME5osSOwrK2/Tt+J4COXus334vC/BjCJn32GSI/78fxkzpkjePF+Mw4ISF/AgPt4GTHW+75oD7vk5eQz63HEAlHjvi2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(39860400002)(366004)(136003)(396003)(83380400001)(55016002)(8676002)(8936002)(86362001)(478600001)(316002)(9686003)(52116002)(2906002)(6916009)(4744005)(1076003)(7696005)(186003)(4326008)(6506007)(16526019)(66476007)(66556008)(66946007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: TIMKZXCtQKkKMWUJV2Jj9aAh3hjuEPXwZ3yltvnMqYvu+Dvq1u1mx0T0JU1Spj3I27ZbizSWyPRDWxcM1A6pswgFvsPXfR9o68QKe9+smRLhdOPa8AXGv+CQ7aD6CRsDN4GXOow4cizf4s7mvdAOGiG2AwzYUS17pMrwu7o6ONKyTXOpyvNPtpiV/2d+VNrS3fTRGrBPezUUft7UUIJNthaDhjoqxKyL5G2uKplCmssAcEAwAyXT2DjM+MGqf7KMfyAsVTFr1dhgAdfdZWov0Q6kR4xMJ3yyXJI9m4vUE+RK+wiAJhoFOUh3xuaJl2Cf8fT3u0ooLw5aUQSktCeXOSsRjsAaQ5T5rcw34Tfxjn9zjhhZ6JBRjcHiROS/zHrchtBQAOwF9wRC8muKfyUPeSMXXGffl1INpG1zZOV6cKIWFFwC1q2BA0l7lUrZJ8S8CFodIL/5E5UdC8wXkIQ0Gbg0Z3fi3VbG+va7qmKpO3nXA/g/jcNz0W3OIVVbuceWFqi3Mr8UPewYfTph7YD8cw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 184b50b2-452b-47e7-60d1-08d81e09d3f7
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 21:58:03.4347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVK4lO8lcZEUVu8VXB4mwfxC1WJNU8Vx2FxRf1wCMI08EZKhxRNjF2UcpQuc+f2k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3734
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_15:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxlogscore=707
 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 04:00:06PM -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> When no full socket is available, skbs are sent over a per-netns
> control socket. Its sk_mark is temporarily adjusted to match that
> of the real (request or timewait) socket or to reflect an incoming
> skb, so that the outgoing skb inherits this in __ip_make_skb.
> 
> Introduction of the socket cookie mark field broke this. Now the
> skb is set through the cookie and cork:
> 
> <caller>		# init sockc.mark from sk_mark or cmsg
> ip_append_data
>   ip_setup_cork		# convert sockc.mark to cork mark
> ip_push_pending_frames
>   ip_finish_skb
>     __ip_make_skb	# set skb->mark to cork mark
> 
> But I missed these special control sockets. Update all callers of
> __ip(6)_make_skb that were originally missed.
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
