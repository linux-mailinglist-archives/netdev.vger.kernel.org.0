Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFA820AC26
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 08:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgFZGLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 02:11:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3072 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgFZGLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 02:11:03 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q6APcu024294;
        Thu, 25 Jun 2020 23:10:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Np4jU9bELGf7d9Hz82wcnD6feVxJNWFwDFN6cWxt3zE=;
 b=PQXvh55De620ZPiXTQzc7R98ocNbRafMaN9yQCyCCWAWwvk+c05/BgnU/ObhvhMxRBYg
 wIGBkj7jYf6OyeeURqremkaDRhpeHNglthcvdAyVFMqCqp4Am7drKbyq/aGe2L0pFWOb
 /eRXqB7Y5eWRh1NWfVuVGP4RcP3ejDDEEg4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31w3w2hka6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jun 2020 23:10:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 23:10:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceJEIPJXwKP9w/c9dK+mmu72sLF8gWNraxnCcrFVLzUlxcO3EPXa1i5v8UwcbDCII+zOyYhWDbqnuGMGDHgA1kj6fM3yzknwzkulDqmzGdZ/9etpg3A1IpA9zDctbOYcsNJOdelpSwRWi/3vsBexrH/bkAIawXHvSD+g9smiPeu0txrzlT1rdvR0b3iHh5jv0g9MJCNpi/k0lumsuN8wwJteerqGe5Vu+M2tgJy6mnFTSNCTQOTR+hP7wX3foW9E29Yxw4mzWcJhp0khhG+ZVwjiWeyjuIk3gNhjV/OaUyAV7/pvocD7UWrsSf/vTD1l+VXD8/AQFeG5rdDeEDUrAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Np4jU9bELGf7d9Hz82wcnD6feVxJNWFwDFN6cWxt3zE=;
 b=ewsmMM6ni4EtHXPb6/0v0/g31uGeL0xHbnA5WtHcUUAPtIPtF1jbfn/AMiQPpfLp5GF69g7bIrYe0Wb0th/3I+aG4mI8em+TIL/p4REKg0E7yZwHlNo8lne1e4PPKa557XkAqT6ZK7Kh/ShtJ+wAQ8hntZQF5Nlaglf5/CffI0SAtXYfHvcoo05gSKmWGYL1eo13EUxtW5fDbEq3dMKo3WoMGWceCdRzKq0uqej03W3WI09IgYI7EGgnLxAEGjfpyGFwDprqbFW2pP7yjYivN2WEQcNHIwLOtwgY8g5K+z6eWDquPBiAQivEaQ60G06WzPN6Qv8xKgCsqwUfokg/7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Np4jU9bELGf7d9Hz82wcnD6feVxJNWFwDFN6cWxt3zE=;
 b=ZxZ3Umea1G/YXhakv+iA6vRBmOiPaGAXu4yXzoC4fz1Bov4+ywYCYV+GjRh/ePczCKsS2NnkA3hI8eC1rOyf7HUhdtCfi8X1U0PcalhYl8uwjiYeB1eTGXWetK4YT4y8nkMUM6FwyJ6HUYn/d1y54uUL8i9ex/ILGIG1se5Zn+s=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB3273.namprd15.prod.outlook.com (2603:10b6:5:164::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 06:10:46 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 06:10:46 +0000
Date:   Thu, 25 Jun 2020 23:10:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [bpf PATCH v2 1/3] bpf, sockmap: RCU splat with redirect and
 strparser error or TLS
Message-ID: <20200626061044.7lhxxcsuphkkknc2@kafai-mbp.dhcp.thefacebook.com>
References: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
 <159312677907.18340.11064813152758406626.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159312677907.18340.11064813152758406626.stgit@john-XPS-13-9370>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR17CA0036.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::49) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:7d5a) by BY5PR17CA0036.namprd17.prod.outlook.com (2603:10b6:a03:1b8::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24 via Frontend Transport; Fri, 26 Jun 2020 06:10:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:7d5a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 451c1572-4eca-46b0-c380-08d81997aa7c
X-MS-TrafficTypeDiagnostic: DM6PR15MB3273:
X-Microsoft-Antispam-PRVS: <DM6PR15MB327331814930FAA9C8A62F04D5930@DM6PR15MB3273.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJZiZ8/mrNnGQHeNqQXPLrVwUbFS/0Mr9CtK6E7dvoaQwdl1FHY+veoUctiErNwvILsyaPXWXa+2eB/jOFY9MtIiHX7iZJTpW/Wr1dFdoUujNEPckUeIotcfpagn7VqAo+K5rvNA0OQrRmr3mFwyYlg6HDDVbH7nseSH5Yuosffrs6VAc9JBp8UfjvGEhLuExCdxKYN5MQeRmD1iAJW0UbnOgJbd+99Kv9V//Km2CtdYYE+vcHaIMf0l9NQetAl301WHCrETjcRAMGDsqmXAGpdVQkRcvdViCou/VqD3tPLTI4cYCcZEfQMGdnoMX9YKK1qqneZ+uNM3Qg278vLr+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(83380400001)(8676002)(478600001)(66946007)(5660300002)(66476007)(2906002)(66556008)(55016002)(9686003)(4326008)(1076003)(6916009)(7696005)(316002)(86362001)(186003)(16526019)(6506007)(8936002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WfyY8ol+TRrFwsHGYzOKNYZEa1CyKpA96+MOt5JQN0UKXwmzh5MxxmCNQnKqM2OX62OJ7igfmdIJfC22SmbURIdj5TQHToYTbGqvmRF8ob7RWWXx62Z968P+3zbl2v1W/uJYcmALkwijjzMD0Kg8V8vauts4tjDy+IY+IVEYa/4IRu/HJyvi0sg6bT9xbrAuTYl8RejLyourHS8ptL1PSKFyv/T4kWErq+uqV4BHIfphqvM6Px2kCuVizMlSIUlfk+aNMKmMnKQefb7SpI1wEPNcX6qposrHmXEwIDH7DBQjSLx9sH1lG0aDVrD3bq0W8LopxxzFltgnnsXSDLobZobG5eC3PE/HbRtFZoiNvC+31xJv261DCqA/ETLm+Gp89ijPQSCld/YnEaYbIWBYwJ6K1N93CqQHUh8GnbEENbNNhxc+YHPshvVpEFEsuDGBCQKIlLcRjPH3piTAFItvmckIIZC07sRqbObI2PoqL1WAqvULm9KKnHO6Jw/anlhYEZBm74s6Zd0nugTmAomL4g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 451c1572-4eca-46b0-c380-08d81997aa7c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 06:10:46.6622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofPxDjAWhJCq6ULzCel0bj5vpAMZbuS4lm8xHBaIMCBfO7Dd0OaUP32DDskaxrCs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3273
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_01:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 04:12:59PM -0700, John Fastabend wrote:
> There are two paths to generate the below RCU splat the first and
> most obvious is the result of the BPF verdict program issuing a
> redirect on a TLS socket (This is the splat shown below). Unlike
> the non-TLS case the caller of the *strp_read() hooks does not
> wrap the call in a rcu_read_lock/unlock. Then if the BPF program
> issues a redirect action we hit the RCU splat.
> 
> However, in the non-TLS socket case the splat appears to be
> relatively rare, because the skmsg caller into the strp_data_ready()
> is wrapped in a rcu_read_lock/unlock. Shown here,
> 
>  static void sk_psock_strp_data_ready(struct sock *sk)
>  {
> 	struct sk_psock *psock;
> 
> 	rcu_read_lock();
> 	psock = sk_psock(sk);
> 	if (likely(psock)) {
> 		if (tls_sw_has_ctx_rx(sk)) {
> 			psock->parser.saved_data_ready(sk);
> 		} else {
> 			write_lock_bh(&sk->sk_callback_lock);
> 			strp_data_ready(&psock->parser.strp);
> 			write_unlock_bh(&sk->sk_callback_lock);
> 		}
> 	}
> 	rcu_read_unlock();
>  }
> 
> If the above was the only way to run the verdict program we
> would be safe. But, there is a case where the strparser may throw an
> ENOMEM error while parsing the skb. This is a result of a failed
> skb_clone, or alloc_skb_for_msg while building a new merged skb when
> the msg length needed spans multiple skbs. This will in turn put the
> skb on the strp_wrk workqueue in the strparser code. The skb will
> later be dequeued and verdict programs run, but now from a
> different context without the rcu_read_lock()/unlock() critical
> section in sk_psock_strp_data_ready() shown above. In practice
> I have not seen this yet, because as far as I know most users of the
> verdict programs are also only working on single skbs. In this case no
> merge happens which could trigger the above ENOMEM errors. In addition
> the system would need to be under memory pressure. For example, we
> can't hit the above case in selftests because we missed having tests
> to merge skbs. (Added in later patch)
> 
> To fix the below splat extend the rcu_read_lock/unnlock block to
> include the call to sk_psock_tls_verdict_apply(). This will fix both
> TLS redirect case and non-TLS redirect+error case. Also remove
> psock from the sk_psock_tls_verdict_apply() function signature its
> not used there.
Acked-by: Martin KaFai Lau <kafai@fb.com>
