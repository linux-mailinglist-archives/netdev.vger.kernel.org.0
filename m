Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFDD6AFC8C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 02:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCHBz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 20:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCHBz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 20:55:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F9F9CFDC;
        Tue,  7 Mar 2023 17:55:24 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3280Un8V014196;
        Wed, 8 Mar 2023 01:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=DpD4QWY+AUKnWUVvgMGyXh6E6aFL9Ocfd4yjwaFSvvE=;
 b=L5aTL+qwCeN1MhVnMf3Ox2k0w1wo2HK3M8qg6Nz3itdhZitEekGmybr871PllbjLZrac
 d2VOFB/gfbz9c57N4E0lWjS1YWesn47c/fbFARbOAbPe5y6P1Ae0Dha6VLdMYpt5uRGy
 R1JONVzaywAxC0Eq7G3uNdwQkOPSMQY9nbaEka/2Qu2eTOt8mE9frDMdT4UhvN+1C0pv
 ysbBkRGV72C+9G3DnpD2Ja2KfwSe+meH6Sv6MHv4UlOuFDLV1evYRcJ1u6//SzPSEs9L
 0btAOrX8ivXX70ECcLnbs3HDF7vkwLhY/2xW3lj+HU7WZvvsBzn4MECIc6TaVotg/nWH CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6fvwsght-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 01:55:10 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3281UFHn039363;
        Wed, 8 Mar 2023 01:55:09 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6fvwsggw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 01:55:09 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3280dLi6002843;
        Wed, 8 Mar 2023 01:55:06 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3p6g0pg1jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 01:55:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3281t3qW60424462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 01:55:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F1F920043;
        Wed,  8 Mar 2023 01:55:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6687920040;
        Wed,  8 Mar 2023 01:55:02 +0000 (GMT)
Received: from heavy (unknown [9.171.43.1])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  8 Mar 2023 01:55:02 +0000 (GMT)
Date:   Wed, 8 Mar 2023 02:55:00 +0100
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Joanne Koong <joannelkoong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
Subject: Re: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using
 dynptrs to parse skb and xdp buffers
Message-ID: <20230308015500.6pycr5i4nynyu22n@heavy>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-11-joannelkoong@gmail.com>
 <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
 <CAJnrk1YNMoTEaWA6=wDS3iV4sV0A-5Afnn+p50hEvX8jR6GLHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YNMoTEaWA6=wDS3iV4sV0A-5Afnn+p50hEvX8jR6GLHw@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LLZ84yWuCmJUJSEaxGS_81Ni6iOMqT43
X-Proofpoint-GUID: En-lB8LC25S_RlH4K7yG1CegTzfAnK67
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_18,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 impostorscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080010
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 08:28:40PM -0800, Joanne Koong wrote:
> On Wed, Mar 1, 2023 at 10:08 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Mar 1, 2023 at 7:51 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > 5) progs/dynptr_success.c
> > >    * Add test case "test_skb_readonly" for testing attempts at writes
> > >      on a prog type with read-only skb ctx.
> > >    * Add "test_dynptr_skb_data" for testing that bpf_dynptr_data isn't
> > >      supported for skb progs.
> >
> > I added
> > +dynptr/test_dynptr_skb_data
> > +dynptr/test_skb_readonly
> > to DENYLIST.s390x and applied.
> 
> Thanks, I'm still not sure why s390x cannot load these programs. It is
> being loaded in the same way as other tests like
> test_parse_tcp_hdr_opt() are loading programs. I will keep looking
> some more into this

Hi,

I believe the culprit is:

    insn->imm = BPF_CALL_IMM(bpf_dynptr_from_skb_rdonly);

s390x needs to know the kfunc model in order to emit the call (like
i386), but after this assignment it's no longer possible to look it
up in kfunc_tab by insn->imm. x86_64 does not need this, because its
ABI is exactly the same as BPF ABI.

The simplest solution seems to be adding an artificial kfunc_desc
like this:

    {
        .func_model = desc->func_model,  /* model must be compatible */
	.func_id = 0,                    /* unused at this point */
        .imm = insn->imm,                /* new target */
        .offset = 0,                     /* unused at this point */
    }

here and also after this assignment:

    insn->imm = BPF_CALL_IMM(xdp_kfunc);

What do you think?

[...]

Best regards,
Ilya
