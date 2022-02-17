Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193304BA2C0
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbiBQOSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:18:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiBQOSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:18:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C3F2AA3AE;
        Thu, 17 Feb 2022 06:18:38 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HEC9CH027125;
        Thu, 17 Feb 2022 14:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=NvjzEBomC5fbZjfcTUQ5sCHHunjhz1rWtfSasDV8I+Q=;
 b=m+i3NeNupx/APTrSCtdsMBEnEdZ108LfgYsSotVjh4QufhjyhY73PzFZgMEluZ2ukxJ1
 +4kUcMGtoeDugzspMZelyFiQvVhYC0hfXrm+6SWDtyzmlUdCn42vWQ8v2VDUvY4DJ2KD
 LgMVgnWiefZGNaW/0jJME4mLvnm1znRbkz/3ZaoRK4o/rQxxwl+iVfK0EqL8c/A7CWIe
 j15NONSzXpbdbHX7Mcb1xRFUg/2PydGnMOhsPLlQDkL3MQi9KqZ8HLRjp9hit/d99dfY
 037fyWVCmz+89KWCcsmYAAeOK1+tnt6trm3gXzOqsRGSUkSv+YKRdj/qLHW6fUUmeq9D 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9mg2vebx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:18:23 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HEEhMw000943;
        Thu, 17 Feb 2022 14:18:22 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9mg2veb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:18:22 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEDctx029529;
        Thu, 17 Feb 2022 14:18:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3e645k90qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:18:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEIIu635258698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:18:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B421A405B;
        Thu, 17 Feb 2022 14:18:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72591A4054;
        Thu, 17 Feb 2022 14:18:17 +0000 (GMT)
Received: from [9.171.78.41] (unknown [9.171.78.41])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:18:17 +0000 (GMT)
Message-ID: <e0999e46e5332ca79bdfe4d9b9d7f17e4366a340.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: Cover 4-byte load from
 remote_port in bpf_sk_lookup
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Yonghong Song <yhs@fb.com>
Date:   Thu, 17 Feb 2022 15:18:17 +0100
In-Reply-To: <CAEf4BzaRNLw9_EnaMo5e46CdEkzbJiVU3j9oxnsemBKjNFf3wQ@mail.gmail.com>
References: <20220209184333.654927-1-jakub@cloudflare.com>
         <20220209184333.654927-3-jakub@cloudflare.com>
         <CAEf4BzaRNLw9_EnaMo5e46CdEkzbJiVU3j9oxnsemBKjNFf3wQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HSuw5ap9S9hRpO3IK3xS40mI5vSD92mo
X-Proofpoint-ORIG-GUID: dzq2Cyl4fbqlVPCcvfM4J9PxxuG1uAxG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-16 at 13:44 -0800, Andrii Nakryiko wrote:
> On Wed, Feb 9, 2022 at 10:43 AM Jakub Sitnicki <jakub@cloudflare.com>
> wrote:
> > 
> > Extend the context access tests for sk_lookup prog to cover the
> > surprising
> > case of a 4-byte load from the remote_port field, where the
> > expected value
> > is actually shifted by 16 bits.
> > 
> > Acked-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> >  tools/include/uapi/linux/bpf.h                     | 3 ++-
> >  tools/testing/selftests/bpf/progs/test_sk_lookup.c | 6 ++++++
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/include/uapi/linux/bpf.h
> > b/tools/include/uapi/linux/bpf.h
> > index a7f0ddedac1f..afe3d0d7f5f2 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -6453,7 +6453,8 @@ struct bpf_sk_lookup {
> >         __u32 protocol;         /* IP protocol (IPPROTO_TCP,
> > IPPROTO_UDP) */
> >         __u32 remote_ip4;       /* Network byte order */
> >         __u32 remote_ip6[4];    /* Network byte order */
> > -       __u32 remote_port;      /* Network byte order */
> > +       __be16 remote_port;     /* Network byte order */
> > +       __u16 :16;              /* Zero padding */
> >         __u32 local_ip4;        /* Network byte order */
> >         __u32 local_ip6[4];     /* Network byte order */
> >         __u32 local_port;       /* Host byte order */
> > diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > index 83b0aaa52ef7..bf5b7caefdd0 100644
> > --- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > @@ -392,6 +392,7 @@ int ctx_narrow_access(struct bpf_sk_lookup
> > *ctx)
> >  {
> >         struct bpf_sock *sk;
> >         int err, family;
> > +       __u32 val_u32;
> >         bool v4;
> > 
> >         v4 = (ctx->family == AF_INET);
> > @@ -418,6 +419,11 @@ int ctx_narrow_access(struct bpf_sk_lookup
> > *ctx)
> >         if (LSW(ctx->remote_port, 0) != SRC_PORT)
> >                 return SK_DROP;
> > 
> > +       /* Load from remote_port field with zero padding (backward
> > compatibility) */
> > +       val_u32 = *(__u32 *)&ctx->remote_port;
> > +       if (val_u32 != bpf_htonl(bpf_ntohs(SRC_PORT) << 16))
> > +               return SK_DROP;
> > +
> 
> Jakub, can you please double check that your patch set doesn't break
> big-endian architectures? I've noticed that our s390x test runner is
> now failing in the sk_lookup selftest. See [0]. Also CC'ing Ilya.

I agree that this looks like an endianness issue. The new check seems
to make little sense on big-endian to me, so I would just #ifdef it
out.

> 
>   [0]
> https://github.com/libbpf/libbpf/runs/5220996832?check_suite_focus=true
> 
> >         /* Narrow loads from local_port field. Expect DST_PORT. */
> >         if (LSB(ctx->local_port, 0) != ((DST_PORT >> 0) & 0xff) ||
> >             LSB(ctx->local_port, 1) != ((DST_PORT >> 8) & 0xff) ||
> > --
> > 2.31.1
> > 

