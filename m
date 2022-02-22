Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1E84C041F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 22:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiBVVwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 16:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbiBVVwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 16:52:09 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0CD27161;
        Tue, 22 Feb 2022 13:51:40 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MKGOuI015658;
        Tue, 22 Feb 2022 21:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ShY5bluNr7TMIwQjuventtCSdXjVZ3r3lwXTCQsNi+g=;
 b=eLpAgkQjqKpLJ4I18z4tAzqUPUnEWwIU3Ss2xILyfsgPF17VXUN7XNkLe7PqpsTNjl78
 jiiLdh2a0h6xZ8sUa+YMhQgoXV+ostcFFFsigRwdaiJ9dEMnelYFr/M5bt09q8Mwor4o
 F3gWYo0sPGBzv7E01GnrZ6F2rPGbMXX7sFDjGrCjmek0g057aWCHoG1dvGI9DIqvHFp9
 HByqdIJaaPUn4efM0GCZl928tuY5JqJGkpGSuSRLaDMDwpKw41sExTeRblZcgTkvqkPo
 /3whtGU3deMR87RneL6pWJnbmj7DkYiEL2G/FwVcbCe96E5ViBobtaKpzaU0OrQXeqpf Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ed6qm1sba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 21:51:26 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21MLWihb011304;
        Tue, 22 Feb 2022 21:51:26 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ed6qm1sb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 21:51:25 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MLh79e004872;
        Tue, 22 Feb 2022 21:51:24 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3ear69cj7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 21:51:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MLpLKt10879450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 21:51:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A807611C050;
        Tue, 22 Feb 2022 21:51:21 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4302C11C04A;
        Tue, 22 Feb 2022 21:51:21 +0000 (GMT)
Received: from [9.171.78.41] (unknown [9.171.78.41])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 21:51:21 +0000 (GMT)
Message-ID: <8a88c49e2d4f5715776c33a6cc83cc1985f4e106.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix implementation-defined
 behavior in sk_lookup test
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Feb 2022 22:51:21 +0100
In-Reply-To: <87bkyykapm.fsf@cloudflare.com>
References: <20220221180358.169101-1-jakub@cloudflare.com>
         <8ff3f2ff692acaffe9494007a3431c269372f822.camel@linux.ibm.com>
         <88a4927eaf3ca385ce9a7406ef23062a39eb1734.camel@linux.ibm.com>
         <0eeac90306f03b4fdb2b028ffb509e4d20121aec.camel@linux.ibm.com>
         <87fsoakjj6.fsf@cloudflare.com>
         <6e28c1c3ef0eda6f041593216ac32b210e55e4b7.camel@linux.ibm.com>
         <87bkyykapm.fsf@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d4F6fb75Gcd-DFZbSh0X7NXjf4wjdPlL
X-Proofpoint-GUID: KpDmbjKR_Waskj-KlwancLLoa9UKcO9D
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_07,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-02-22 at 19:24 +0100, Jakub Sitnicki wrote:
> On Tue, Feb 22, 2022 at 06:42 PM +01, Ilya Leoshkevich wrote:
> > On Tue, 2022-02-22 at 15:53 +0100, Jakub Sitnicki wrote:
> > > On Tue, Feb 22, 2022 at 03:22 AM +01, Ilya Leoshkevich wrote:
> > > > On Tue, 2022-02-22 at 01:43 +0100, Ilya Leoshkevich wrote:
> > > > > On Mon, 2022-02-21 at 22:39 +0100, Ilya Leoshkevich wrote:
> > > > > > On Mon, 2022-02-21 at 19:03 +0100, Jakub Sitnicki wrote:
> > > > > > > Shifting 16-bit type by 16 bits is implementation-defined
> > > > > > > for
> > > > > > > BPF
> > > > > > > programs.
> > > > > > > Don't rely on it in case it is causing the test failures
> > > > > > > we
> > > > > > > are
> > > > > > > seeing on
> > > > > > > s390x z15 target.
> > > > > > > 
> > > > > > > Fixes: 2ed0dc5937d3 ("selftests/bpf: Cover 4-byte load
> > > > > > > from
> > > > > > > remote_port in bpf_sk_lookup")
> > > > > > > Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > > > > > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > > > > > ---
> > > > > > > 
> > > > > > > I don't have a dev env for s390x/z15 set up yet, so can't
> > > > > > > definitely
> > > > > > > confirm the fix.
> > > > > > > That said, it seems worth fixing either way.
> > > > > > > 
> > > > > > >  tools/testing/selftests/bpf/progs/test_sk_lookup.c | 3
> > > > > > > ++-
> > > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > > > 
> > > > > > > diff --git
> > > > > > > a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > > > > > > b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > > > > > > index bf5b7caefdd0..7d47276a8964 100644
> > > > > > > --- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > > > > > > +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > > > > > > @@ -65,6 +65,7 @@ static const __u32 KEY_SERVER_A =
> > > > > > > SERVER_A;
> > > > > > >  static const __u32 KEY_SERVER_B = SERVER_B;
> > > > > > >  
> > > > > > >  static const __u16 SRC_PORT = bpf_htons(8008);
> > > > > > > +static const __u32 SRC_PORT_U32 = bpf_htonl(8008U <<
> > > > > > > 16);
> > > > > > >  static const __u32 SRC_IP4 = IP4(127, 0, 0, 2);
> > > > > > >  static const __u32 SRC_IP6[] = IP6(0xfd000000, 0x0, 0x0,
> > > > > > > 0x00000002);
> > > > > > >  
> > > > > > > @@ -421,7 +422,7 @@ int ctx_narrow_access(struct
> > > > > > > bpf_sk_lookup
> > > > > > > *ctx)
> > > > > > >  
> > > > > > >         /* Load from remote_port field with zero padding
> > > > > > > (backward
> > > > > > > compatibility) */
> > > > > > >         val_u32 = *(__u32 *)&ctx->remote_port;
> > > > > > > -       if (val_u32 != bpf_htonl(bpf_ntohs(SRC_PORT) <<
> > > > > > > 16))
> > > > > > > +       if (val_u32 != SRC_PORT_U32)
> > > > > > >                 return SK_DROP;
> > > > > > >  
> > > > > > >         /* Narrow loads from local_port field. Expect
> > > > > > > DST_PORT.
> > > > > > > */
> > > > > > 
> > > > > > Unfortunately this doesn't help with the s390 problem.
> > > > > > I'll try to debug this.
> > > > > 
> > > > > I have to admit I have a hard time wrapping my head around
> > > > > the
> > > > > requirements here.
> > > > > 
> > > > > Based on the pre-9a69e2b385f4 code, do I understand correctly
> > > > > that
> > > > > for the following input
> > > > > 
> > > > > Port:     0x1f48
> > > > > SRC_PORT: 0x481f
> > > > > 
> > > > > we expect the following results for different kinds of loads:
> > > > > 
> > > > > Size   Offset  LE      BE
> > > > > BPF_B  0       0x1f    0
> > > > > BPF_B  1       0x48    0
> > > > > BPF_B  2       0       0x48
> > > > > BPF_B  3       0       0x1f
> > > > > BPF_H  0       0x481f  0
> > > > > BPF_H  1       0       0x481f
> > > > > BPF_W  0       0x481f  0x481f
> > > > > 
> > > > > and this is guaranteed by the struct bpf_sk_lookup ABI?
> > > > > Because
> > > > > then
> > > > > it
> > > > > looks as if 9a69e2b385f4 breaks it on big-endian as follows:
> > > > > 
> > > > > Size   Offset  BE-9a69e2b385f4
> > > > > BPF_B  0       0x48
> > > > > BPF_B  1       0x1f
> > > > > BPF_B  2       0
> > > > > BPF_B  3       0
> > > > > BPF_H  0       0x481f
> > > > > BPF_H  1       0
> > > > > BPF_W  0       0x481f0000
> > > > 
> > > > Sorry, I worded this incorrectly: 9a69e2b385f4 did not change
> > > > the
> > > > kernel behavior, the ABI is not broken and the old compiled
> > > > code
> > > > should
> > > > continue to work.
> > > > What the second table really shows are what the results should
> > > > be
> > > > according to the 9a69e2b385f4 struct bpf_sk_lookup definition,
> > > > which I
> > > > still think is broken on big-endian and needs to be adjusted to
> > > > match
> > > > the ABI.
> > > > 
> > > > I noticed one other strange thing in the meantime: loads from
> > > > *(__u32 *)&ctx->remote_port, *(__u16 *)&ctx->remote_port and
> > > > *((__u16 *)&ctx->remote_port + 1) all produce 8008 on s390,
> > > > which
> > > > is
> > > > clearly inconsistent. It looks as if convert_ctx_accesses()
> > > > needs
> > > > to be
> > > > adjusted to handle combinations like ctx_field_size == 4 &&
> > > > size ==
> > > > 2
> > > > && target_size == 2. I will continue with this tomorrow.
> > > > 
> > > > > Or is the old behavior a bug and this new one is desirable?
> > > > > 9a69e2b385f4 has no Fixes: tag, so I assume that's the former
> > > > > :-(
> > > > > 
> > > > > In which case, would it make sense to fix it by swapping
> > > > > remote_port
> > > > > and :16 in bpf_sk_lookup on big-endian?
> > > 
> > > Thanks for looking into it.
> > > 
> > > When it comes to requirements, my intention was to keep the same
> > > behavior as before the split up of the remote_port field in
> > > 9a69e2b385f4
> > > ("bpf: Make remote_port field in struct bpf_sk_lookup 16-bit
> > > wide").
> > > 
> > > 9a69e2b385f4 was supposed to be a formality, after a similar
> > > change
> > > in
> > > 4421a582718a ("bpf: Make dst_port field in struct bpf_sock 16-bit
> > > wide"), which went in earlier.
> > > 
> > > In 4421a582718a I've provided a bit more context. I understand
> > > that
> > > the
> > > remote_port value, even before the type changed from u32 to u16,
> > > appeared to the BPF program as if laid out in memory like so:
> > > 
> > >       offsetof(struct bpf_sk_lookup, remote_port) +0  <port MSB>
> > >                                                   +1  <port LSB>
> > >                                                   +2  0x00
> > >                                                   +3  0x00
> > > 
> > > Translating it to your handy table format, I expect should result
> > > in
> > > loads as so if port is 8008 = 0x1f48:
> > > 
> > >       Size   Offset  LE      BE
> > >       BPF_B  0       0x1f    0x1f
> > >       BPF_B  1       0x48    0x48
> > >       BPF_B  2       0       0
> > >       BPF_B  3       0       0
> > >       BPF_H  0       0x481f  0x1f48
> > >       BPF_H  1       0       0
> > >       BPF_W  0       0x481f  0x1f480000
> > 
> > Hmm, I think for big-endian the layout is different.
> > If we look at test_sk_lookup.c from 9a69e2b385f4^:
> > 
> >         /* Narrow loads from remote_port field. Expect SRC_PORT. */
> >         if (LSB(ctx->remote_port, 0) != ((SRC_PORT >> 0) & 0xff) ||
> >             LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff) ||
> >             LSB(ctx->remote_port, 2) != 0 || LSB(ctx->remote_port,
> > 3)
> > != 0)
> >                 return SK_DROP;
> > 
> > LSB() on little-endian is just byte indexing, so it's indeed 
> > 1f,48,00,00. However, on big-endian it's indexing from the end, so
> > it's 00,00,48,1f.
> 
> I understood that LSB() is indexing from the end on BE because
> SRC_PORT
> constant value differs on LE (= 0x481f) and BE (= 0x1f48) platforms,
> so
> 
>                  LE  BE
>   SRC_PORT >> 0  1f  48
>   SRC_PORT >> 8  48  1f
> 
> So on LE we first compare remote_port MSB, then LSB.
> While on BE we start with remote_port LSB, then MSB.
> 
> But, now that you have pointed it out, I notice that
> sizeof(remote_port)
> has changed and from 4 to 2, and I can't see how LSB(…, 3) and LSB(…,
> 4)
> loads can keep working on big-endian.

Oh, right - it should be 00,00,1f,48 on big-endian.
Out-of-bounds LSB is indeed an issue. I've posted my current
thoughts as an RFC series [1], this one is addressed in patch 3.

[1]
https://lore.kernel.org/bpf/20220222182559.2865596-1-iii@linux.ibm.com/

> 
> [...]

