Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217674BEF7D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbiBVCXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:23:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239115AbiBVCXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:23:10 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3FF25C50;
        Mon, 21 Feb 2022 18:22:45 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M2BSbD017190;
        Tue, 22 Feb 2022 02:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=I3JTyi/5CUqYoBzfDtW+vIZRRtdcuH2wE5VkQO7dqGc=;
 b=gUaroSv7Wyur+0RwZfUHcYsvBx+eGnxG5L7PEjkWS05kz+9Kgs5Un38cf5xnDhW+JL0K
 FU5UGqEmybFt0EPxXPYx74QrEl+LggwllxaPh6yAG/BB5WIVkG8BKzC0OzOelBuEY1Nq
 c9YcAod2/n3vac6j4waeSUcFkQ99HEeZ3P/qLbQ6hMVAkRhyBYvCO+ir8y5bQapEsclJ
 m5nPif246DH6AsrmxNNcJ1lvZDg7OP0BMWRbhFKdzYorXWGuuHTfCzElyy3SUOhTas5l
 dIZCp6RahplVgQ8TFUgVEVFQT7C6Gfcdj2ZY7Y7W3HWGYLKPwW3bnOUZR8wp/yrpeXUC uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecpu10616-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 02:22:32 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M2Kics003196;
        Tue, 22 Feb 2022 02:22:31 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecpu1060t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 02:22:31 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M2Cx4L028506;
        Tue, 22 Feb 2022 02:22:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3ear69604k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 02:22:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M2MRI051511692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 02:22:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C5C3A405D;
        Tue, 22 Feb 2022 02:22:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9633A4059;
        Tue, 22 Feb 2022 02:22:26 +0000 (GMT)
Received: from [9.171.78.41] (unknown [9.171.78.41])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 02:22:26 +0000 (GMT)
Message-ID: <0eeac90306f03b4fdb2b028ffb509e4d20121aec.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix implementation-defined
 behavior in sk_lookup test
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Feb 2022 03:22:26 +0100
In-Reply-To: <88a4927eaf3ca385ce9a7406ef23062a39eb1734.camel@linux.ibm.com>
References: <20220221180358.169101-1-jakub@cloudflare.com>
         <8ff3f2ff692acaffe9494007a3431c269372f822.camel@linux.ibm.com>
         <88a4927eaf3ca385ce9a7406ef23062a39eb1734.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AGw2JirgupHmcoCJ7oKtdTaxhR4jPnGD
X-Proofpoint-GUID: T6jIeH_yNHvnZRrwdjC_hfo3h1HS1m5q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_11,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220010
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-02-22 at 01:43 +0100, Ilya Leoshkevich wrote:
> On Mon, 2022-02-21 at 22:39 +0100, Ilya Leoshkevich wrote:
> > On Mon, 2022-02-21 at 19:03 +0100, Jakub Sitnicki wrote:
> > > Shifting 16-bit type by 16 bits is implementation-defined for BPF
> > > programs.
> > > Don't rely on it in case it is causing the test failures we are
> > > seeing on
> > > s390x z15 target.
> > > 
> > > Fixes: 2ed0dc5937d3 ("selftests/bpf: Cover 4-byte load from
> > > remote_port in bpf_sk_lookup")
> > > Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > ---
> > > 
> > > I don't have a dev env for s390x/z15 set up yet, so can't
> > > definitely
> > > confirm the fix.
> > > That said, it seems worth fixing either way.
> > > 
> > >  tools/testing/selftests/bpf/progs/test_sk_lookup.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > > b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > > index bf5b7caefdd0..7d47276a8964 100644
> > > --- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > > +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > > @@ -65,6 +65,7 @@ static const __u32 KEY_SERVER_A = SERVER_A;
> > >  static const __u32 KEY_SERVER_B = SERVER_B;
> > >  
> > >  static const __u16 SRC_PORT = bpf_htons(8008);
> > > +static const __u32 SRC_PORT_U32 = bpf_htonl(8008U << 16);
> > >  static const __u32 SRC_IP4 = IP4(127, 0, 0, 2);
> > >  static const __u32 SRC_IP6[] = IP6(0xfd000000, 0x0, 0x0,
> > > 0x00000002);
> > >  
> > > @@ -421,7 +422,7 @@ int ctx_narrow_access(struct bpf_sk_lookup
> > > *ctx)
> > >  
> > >         /* Load from remote_port field with zero padding
> > > (backward
> > > compatibility) */
> > >         val_u32 = *(__u32 *)&ctx->remote_port;
> > > -       if (val_u32 != bpf_htonl(bpf_ntohs(SRC_PORT) << 16))
> > > +       if (val_u32 != SRC_PORT_U32)
> > >                 return SK_DROP;
> > >  
> > >         /* Narrow loads from local_port field. Expect DST_PORT.
> > > */
> > 
> > Unfortunately this doesn't help with the s390 problem.
> > I'll try to debug this.
> 
> I have to admit I have a hard time wrapping my head around the
> requirements here.
> 
> Based on the pre-9a69e2b385f4 code, do I understand correctly that
> for the following input
> 
> Port:     0x1f48
> SRC_PORT: 0x481f
> 
> we expect the following results for different kinds of loads:
> 
> Size   Offset  LE      BE
> BPF_B  0       0x1f    0
> BPF_B  1       0x48    0
> BPF_B  2       0       0x48
> BPF_B  3       0       0x1f
> BPF_H  0       0x481f  0
> BPF_H  1       0       0x481f
> BPF_W  0       0x481f  0x481f
> 
> and this is guaranteed by the struct bpf_sk_lookup ABI? Because then
> it
> looks as if 9a69e2b385f4 breaks it on big-endian as follows:
> 
> Size   Offset  BE-9a69e2b385f4
> BPF_B  0       0x48
> BPF_B  1       0x1f
> BPF_B  2       0
> BPF_B  3       0
> BPF_H  0       0x481f
> BPF_H  1       0
> BPF_W  0       0x481f0000

Sorry, I worded this incorrectly: 9a69e2b385f4 did not change the
kernel behavior, the ABI is not broken and the old compiled code should
continue to work.
What the second table really shows are what the results should be
according to the 9a69e2b385f4 struct bpf_sk_lookup definition, which I
still think is broken on big-endian and needs to be adjusted to match
the ABI.

I noticed one other strange thing in the meantime: loads from
*(__u32 *)&ctx->remote_port, *(__u16 *)&ctx->remote_port and
*((__u16 *)&ctx->remote_port + 1) all produce 8008 on s390, which is
clearly inconsistent. It looks as if convert_ctx_accesses() needs to be
adjusted to handle combinations like ctx_field_size == 4 && size == 2
&& target_size == 2. I will continue with this tomorrow.

> Or is the old behavior a bug and this new one is desirable?
> 9a69e2b385f4 has no Fixes: tag, so I assume that's the former :-(
> 
> In which case, would it make sense to fix it by swapping remote_port
> and :16 in bpf_sk_lookup on big-endian?
> 
> Best regards,
> Ilya

