Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7D6234A4F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbgGaRic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:38:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17610 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733236AbgGaRib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:38:31 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VHXadr009059;
        Fri, 31 Jul 2020 10:38:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=QSujTpEpdUgUrabSk+fQg+toAzXU6nlIQYtu94hPFSA=;
 b=f1jpYxzAh0KKqw78eFVNtpvi+bvmBX0gJ0tAiohoqjaXb4vcpbIk3c0V6fZkd8sQJdNe
 PgkGjO4KCtYLEb6PMH+TcVbZq7TJ1krkRumf6ix22Of1p3QihW7FABu7p0hCF7yNI+9M
 x0nhK1q1DdveIT7nMAtcOVn+dhbjOLromEI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32kxekf6a8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 31 Jul 2020 10:38:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 10:37:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNmIGgdB2Z1S2YVc9+e2gtspkkTbC/hfF7AG/gyCtZ7LNpbmsOTsRJP1A+D2Sylmfz2MFfMFV/V0GxpfLyOn81Ft0s5c7nrgcJwLh8A9JDs2RlDYXL3NKAremTMncTvH3Vxnsnx1l9zFWzB2Y4vXov0/fyfVyBU/Z14rgyR5qeXBaXWOIPxru+6M4xL272r4umwxnTCGa6dRpR18uTV4IpIfB4r8tSnnqXMKwvYHXuU3EgLIodDFWZjvqeHWdV+O+D32K3wPBIoE9GMwBEXC6pVb/oZehPvDP2+IHjyM1f3159Oi4ptdxDQQT/cnwgDOgMbjmgrh/T+79rz5o5XamQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSujTpEpdUgUrabSk+fQg+toAzXU6nlIQYtu94hPFSA=;
 b=KshixrNXjDihwywSMhqJ0g3JTv3UPeI7bUDu7F5WcFn6SQY5CsAHJsGbOwAICo9Q6/iZ+qxZtG7wxmGudt32b02Rb+uXl/pzexOCp375+uz+q8KrrwycqHA+E1JHFvhvXtHvZhhwhYuw1cPPNKzbv4fcsPdWy1JEYwrKtEpzQVQmjppmg3fhb7SktoFn1F1ZWcj/JOi5PMMCh+5aBtaTPrE/g+jbtDilUnOg1VYb79TSs6ODjQB696Xiu6i5T+tq6fU8/DCHS4EqXxyUY7uyGRbqvxFbBezbJN4G2IUHJN8vG4B8cds2ALY1fNhWLNYsehzrxWfjsM968V33lAZSTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSujTpEpdUgUrabSk+fQg+toAzXU6nlIQYtu94hPFSA=;
 b=A9dgu3e0fTL3oTp26JqR8j5iigz19jkPHefcrk9o8OFSXXzMZXKsTKzQsDabLyt++Zv2mEdpmVVZVygDmkv0CuouHA7TdXAVksjETzycrU2kdUxAl1yYBSLMlXs6QnC/cCKMQeYgtNxtCStZP9Qfp6txrclf9aMBOpsf5aKw2X0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3668.namprd15.prod.outlook.com (2603:10b6:a03:1fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.19; Fri, 31 Jul
 2020 17:37:39 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 17:37:39 +0000
Date:   Fri, 31 Jul 2020 10:37:34 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v3 bpf-next 4/9] tcp: Add unknown_opt arg to
 tcp_parse_options
Message-ID: <20200731173734.2eqvydx4cb5lllty@kafai-mbp.dhcp.thefacebook.com>
References: <20200730205657.3351905-1-kafai@fb.com>
 <20200730205723.3353838-1-kafai@fb.com>
 <CANn89i+f4se896OPGx6dPKZuObeJR2gaTExqoAHmDK=r7cTmaw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+f4se896OPGx6dPKZuObeJR2gaTExqoAHmDK=r7cTmaw@mail.gmail.com>
X-ClientProxiedBy: BYAPR08CA0053.namprd08.prod.outlook.com
 (2603:10b6:a03:117::30) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5cdc) by BYAPR08CA0053.namprd08.prod.outlook.com (2603:10b6:a03:117::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Fri, 31 Jul 2020 17:37:39 +0000
X-Originating-IP: [2620:10d:c090:400::5:5cdc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c008e73b-ae5e-48f6-5e2a-08d835786be6
X-MS-TrafficTypeDiagnostic: BY5PR15MB3668:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3668E1C0C69A09EF4C69F7AED54E0@BY5PR15MB3668.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBwST/vcIftOxuDfxZITGAJWYC12WEOW/6SfyAtC23tBowv37bCeEhCrN0smxyKHFbfyxhdt4E8ciVAvnmOiqw+4PEgPNvpyLhR+tnkxOzEK8rx73ReVMPdmOCk1a7GdY6U34ZFnvG+FH7GfxL5o2aAMEP5EqP0IIgj1N75HkvtXmUTRncgMbW1E0sRjG3t1V5tsGLDvujDUObWQeZeNxRV11FbEj6TalpEloO2XN+OsUzINkIw5jCwL6PGQNDAlIy/Ns11FXDbJS8Ii+Yk65230X4a5QokRxl5zdfj/ffoQ4gHysb+9j8B13d3ZPF2j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(376002)(346002)(366004)(396003)(1076003)(6916009)(53546011)(5660300002)(8676002)(6506007)(52116002)(316002)(7696005)(54906003)(8936002)(83380400001)(9686003)(4326008)(16526019)(478600001)(66556008)(66476007)(186003)(86362001)(55016002)(6666004)(66946007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0XL0SemGEt9nxnTtBagZU2EmLSBwB0qS33K0LCbv4L+CZGboRCve8kmUBRIKpSyH7Vd0Atp9Bi+IraL5u7n4AwLQXpYQfxdC8seZiofj8V7Zxv1SDCm/ldujYZWKrFi+p0iPX1D6+n59lwdaqxvMvieTFr5dCggzJa6424+i5gyjR/ZAwQ7CrtsXiICsK9szewJ5M+bp4StsCxqBJNp/bAFPG45D62+20M7aPblCtR5JsCkvIpRnYMWn3mK3h3pnr5gmJkHw6nrwEyvV4/2Dru5gRJHp9D5Hr7GoV9Om70t0Wivg7Ej1n4qOkYvBXnlej0guj1nhjmgV3Ujd+g82tCiz4NhbuWRobq0xK5vNr4ILLXzpQcJmpPKeHS6VMnGBhlv1WbY8e8g7R45QZ9G7bMNmunmz4SwjcZgggoTyJbh1eJ+pEAlfowo2w2dY24Lso27XLb5CVx9A9sKUVDQiFH9YgD49pG2ghgkAvTYDrHipv570SlW0hCGBwllRgn9kyGRgST9DJCWmAR/jBZ2/l5X596Puj66C5Uc6E6BpXyuvrPFoFvms7xm6yv2xCPvKcffTPMuZQpkBHrROz8ilYk5yveXopnPzdVNJJbZ/TeySjGn+MXxael82LH8W4TRmGIVwXUWnorFkmLCC5bmZkpCxH1mqj37POTbBV5Y0aM2yJhmeMSH504by7Pd6BC5G
X-MS-Exchange-CrossTenant-Network-Message-Id: c008e73b-ae5e-48f6-5e2a-08d835786be6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 17:37:39.8240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9rVYX7Q03FxK/03jaW4X+VJalxBk0Q3bFueN1bNx4x5Wf8FkMVhrJk0MXe5T9xU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3668
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_06:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 09:12:10AM -0700, Eric Dumazet wrote:
> On Thu, Jul 30, 2020 at 1:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > In the latter patch, the bpf prog only wants to be called to handle
> > a header option if that particular header option cannot be handled by
> > the kernel.  This unknown option could be written by the peer's bpf-prog.
> > It could also be a new standard option that the running kernel does not
> > support it while a bpf-prog can handle it.
> >
> > In a latter patch, the bpf prog will be called from tcp_validate_incoming()
> > if there is unknown option and a flag is set in tp->bpf_sock_ops_cb_flags.
> >
> > Instead of using skb->cb[] in an earlier attempt, this patch
> > adds an optional arg "bool *unknown_opt" to tcp_parse_options().
> > The bool will be set to true if it has encountered an option
> > that the kernel does not recognize.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  drivers/infiniband/hw/cxgb4/cm.c |  2 +-
> >  include/net/tcp.h                |  3 ++-
> >  net/ipv4/syncookies.c            |  2 +-
> >  net/ipv4/tcp_input.c             | 40 +++++++++++++++++++++-----------
> >  net/ipv4/tcp_minisocks.c         |  4 ++--
> >  net/ipv6/syncookies.c            |  2 +-
> >  6 files changed, 34 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> > index 30e08bcc9afb..dedca6576bb9 100644
> > --- a/drivers/infiniband/hw/cxgb4/cm.c
> > +++ b/drivers/infiniband/hw/cxgb4/cm.c
> > @@ -3949,7 +3949,7 @@ static void build_cpl_pass_accept_req(struct sk_buff *skb, int stid , u8 tos)
> >          */
> >         memset(&tmp_opt, 0, sizeof(tmp_opt));
> >         tcp_clear_options(&tmp_opt);
> > -       tcp_parse_options(&init_net, skb, &tmp_opt, 0, NULL);
> > +       tcp_parse_options(&init_net, skb, &tmp_opt, 0, NULL, NULL);
> >
> >         req = __skb_push(skb, sizeof(*req));
> >         memset(req, 0, sizeof(*req));
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 895e7aabf136..d49d8f1c961a 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -413,7 +413,8 @@ int tcp_mmap(struct file *file, struct socket *sock,
> >  #endif
> >  void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
> >                        struct tcp_options_received *opt_rx,
> > -                      int estab, struct tcp_fastopen_cookie *foc);
> > +                      int estab, struct tcp_fastopen_cookie *foc,
> > +                      bool *unknown_opt);
> >  const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
> >
> 
> Instead of changing signatures of many functions (and make future
> stable backports challenging)
> how about adding a field into 'struct tcp_options_received' ?
Sounds good.  There is a one byte hole in 'struct tcp_options_received',
so it won't matter much even there is "rx_opt" in "struct tcp_sock".
