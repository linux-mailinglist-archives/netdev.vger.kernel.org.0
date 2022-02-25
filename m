Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF464C4239
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbiBYK0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbiBYK0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:26:13 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5831DDFD1
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:25:41 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id u7so6703221ljk.13
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=5dv4/lYYYynkGTfjwQ1LaTUlJAy6uWzUoPFSJxjFa2U=;
        b=FCqBPCtMhuxOuNTpGBvaxsuoprHho98IuETQXW+dRbHykkZgCkE1kqTpaqn1W2SaZ1
         LjYndQS8RkjE55T+gXW7sRr7EKNWpQq3Ok2ZldqoWirSvOwjeLScrl2aMb88qhZwYH3f
         Fhp1/x4xoQiLkQokIkrDVyMhOtw2hxckarYNk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=5dv4/lYYYynkGTfjwQ1LaTUlJAy6uWzUoPFSJxjFa2U=;
        b=crBt0PG5xxXEwkl16JxHlet4hGD8Hd0l8lEUxUlWEUpzilSNa9w8T4sMm2HyFHhOrA
         i+YbIxGNWIUiYTKtgJluSPs6oyQYh/Ai+Gq8yguPdqgHJarjwwyjFlgU8f3m9ara0csR
         pgUI22E2KE6zNDmSiYjO0eRqVDcALQTsgWUApx6gt7O5ELkMeyLC2+j+i7/QREfPEGtU
         KlqGFDsMr4aERxMb6ePl8rmGyS80QI5rUBwqf/ccW0cp0LUkjGCJK0t8LEMFqj3h5ipR
         Vqz+BLmUbWVg86VuXPXmoAW6uMlSeS15PdGsTDDXwdkhnfbjeiL62h5y8y/o9RkE4aLd
         3Hug==
X-Gm-Message-State: AOAM532Onl1NK7iFJfsSmpvUsaEgzRL0luj4VSWuRj1vAyyAmKCJs52w
        b+zDL27rBTc0FOLDALFRHaNHXnu1vaGZqA==
X-Google-Smtp-Source: ABdhPJzUsTYYkcAtzS0CUR3FEoeE9C5Uinl2yjOS/Gk9cy68B+THUq/rOlhaViESYPLZ7MYlEfu5Rg==
X-Received: by 2002:a05:651c:2113:b0:246:7097:afff with SMTP id a19-20020a05651c211300b002467097afffmr2497580ljq.417.1645784739221;
        Fri, 25 Feb 2022 02:25:39 -0800 (PST)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id r6-20020a19ac46000000b00442f6964cc1sm162064lfc.230.2022.02.25.02.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:25:38 -0800 (PST)
References: <20220221180358.169101-1-jakub@cloudflare.com>
 <8ff3f2ff692acaffe9494007a3431c269372f822.camel@linux.ibm.com>
 <88a4927eaf3ca385ce9a7406ef23062a39eb1734.camel@linux.ibm.com>
 <0eeac90306f03b4fdb2b028ffb509e4d20121aec.camel@linux.ibm.com>
 <87fsoakjj6.fsf@cloudflare.com>
 <6e28c1c3ef0eda6f041593216ac32b210e55e4b7.camel@linux.ibm.com>
 <87bkyykapm.fsf@cloudflare.com>
 <8a88c49e2d4f5715776c33a6cc83cc1985f4e106.camel@linux.ibm.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix implementation-defined
 behavior in sk_lookup test
Date:   Fri, 25 Feb 2022 11:01:37 +0100
In-reply-to: <8a88c49e2d4f5715776c33a6cc83cc1985f4e106.camel@linux.ibm.com>
Message-ID: <877d9jjl99.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 10:51 PM +01, Ilya Leoshkevich wrote:
> On Tue, 2022-02-22 at 19:24 +0100, Jakub Sitnicki wrote:
>> On Tue, Feb 22, 2022 at 06:42 PM +01, Ilya Leoshkevich wrote:
>> > On Tue, 2022-02-22 at 15:53 +0100, Jakub Sitnicki wrote:
>> > > On Tue, Feb 22, 2022 at 03:22 AM +01, Ilya Leoshkevich wrote:
>> > > > On Tue, 2022-02-22 at 01:43 +0100, Ilya Leoshkevich wrote:
>> > > > > On Mon, 2022-02-21 at 22:39 +0100, Ilya Leoshkevich wrote:
>> > > > > > On Mon, 2022-02-21 at 19:03 +0100, Jakub Sitnicki wrote:
>> > > > > > > Shifting 16-bit type by 16 bits is implementation-defined
>> > > > > > > for
>> > > > > > > BPF
>> > > > > > > programs.
>> > > > > > > Don't rely on it in case it is causing the test failures
>> > > > > > > we
>> > > > > > > are
>> > > > > > > seeing on
>> > > > > > > s390x z15 target.
>> > > > > > >=20
>> > > > > > > Fixes: 2ed0dc5937d3 ("selftests/bpf: Cover 4-byte load
>> > > > > > > from
>> > > > > > > remote_port in bpf_sk_lookup")
>> > > > > > > Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>> > > > > > > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> > > > > > > ---
>> > > > > > >=20
>> > > > > > > I don't have a dev env for s390x/z15 set up yet, so can't
>> > > > > > > definitely
>> > > > > > > confirm the fix.
>> > > > > > > That said, it seems worth fixing either way.
>> > > > > > >=20
>> > > > > > > =C2=A0tools/testing/selftests/bpf/progs/test_sk_lookup.c | 3
>> > > > > > > ++-
>> > > > > > > =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>> > > > > > >=20
>> > > > > > > diff --git
>> > > > > > > a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
>> > > > > > > b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
>> > > > > > > index bf5b7caefdd0..7d47276a8964 100644
>> > > > > > > --- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
>> > > > > > > +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
>> > > > > > > @@ -65,6 +65,7 @@ static const __u32 KEY_SERVER_A =3D
>> > > > > > > SERVER_A;
>> > > > > > > =C2=A0static const __u32 KEY_SERVER_B =3D SERVER_B;
>> > > > > > > =C2=A0
>> > > > > > > =C2=A0static const __u16 SRC_PORT =3D bpf_htons(8008);
>> > > > > > > +static const __u32 SRC_PORT_U32 =3D bpf_htonl(8008U <<
>> > > > > > > 16);
>> > > > > > > =C2=A0static const __u32 SRC_IP4 =3D IP4(127, 0, 0, 2);
>> > > > > > > =C2=A0static const __u32 SRC_IP6[] =3D IP6(0xfd000000, 0x0, =
0x0,
>> > > > > > > 0x00000002);
>> > > > > > > =C2=A0
>> > > > > > > @@ -421,7 +422,7 @@ int ctx_narrow_access(struct
>> > > > > > > bpf_sk_lookup
>> > > > > > > *ctx)
>> > > > > > > =C2=A0
>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Load from=
 remote_port field with zero padding
>> > > > > > > (backward
>> > > > > > > compatibility) */
>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0val_u32 =3D =
*(__u32 *)&ctx->remote_port;
>> > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (val_u32 !=3D =
bpf_htonl(bpf_ntohs(SRC_PORT) <<
>> > > > > > > 16))
>> > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (val_u32 !=3D =
SRC_PORT_U32)
>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return SK_DROP;
>> > > > > > > =C2=A0
>> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Narrow lo=
ads from local_port field. Expect
>> > > > > > > DST_PORT.
>> > > > > > > */
>> > > > > >=20
>> > > > > > Unfortunately this doesn't help with the s390 problem.
>> > > > > > I'll try to debug this.
>> > > > >=20
>> > > > > I have to admit I have a hard time wrapping my head around
>> > > > > the
>> > > > > requirements here.
>> > > > >=20
>> > > > > Based on the pre-9a69e2b385f4 code, do I understand correctly
>> > > > > that
>> > > > > for the following input
>> > > > >=20
>> > > > > Port:=C2=A0=C2=A0=C2=A0=C2=A0 0x1f48
>> > > > > SRC_PORT: 0x481f
>> > > > >=20
>> > > > > we expect the following results for different kinds of loads:
>> > > > >=20
>> > > > > Size=C2=A0=C2=A0 Offset=C2=A0 LE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BE
>> > > > > BPF_B=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1f=C2=A0=C2=
=A0=C2=A0 0
>> > > > > BPF_B=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x48=C2=A0=C2=
=A0=C2=A0 0
>> > > > > BPF_B=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0x48
>> > > > > BPF_B=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0x1f
>> > > > > BPF_H=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x481f=C2=A0 0
>> > > > > BPF_H=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0x481f
>> > > > > BPF_W=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x481f=C2=A0 0=
x481f
>> > > > >=20
>> > > > > and this is guaranteed by the struct bpf_sk_lookup ABI?
>> > > > > Because
>> > > > > then
>> > > > > it
>> > > > > looks as if 9a69e2b385f4 breaks it on big-endian as follows:
>> > > > >=20
>> > > > > Size=C2=A0=C2=A0 Offset=C2=A0 BE-9a69e2b385f4
>> > > > > BPF_B=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x48
>> > > > > BPF_B=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1f
>> > > > > BPF_B=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > > > BPF_B=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > > > BPF_H=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x481f
>> > > > > BPF_H=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > > > BPF_W=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x481f0000
>> > > >=20
>> > > > Sorry, I worded this incorrectly: 9a69e2b385f4 did not change
>> > > > the
>> > > > kernel behavior, the ABI is not broken and the old compiled
>> > > > code
>> > > > should
>> > > > continue to work.
>> > > > What the second table really shows are what the results should
>> > > > be
>> > > > according to the 9a69e2b385f4 struct bpf_sk_lookup definition,
>> > > > which I
>> > > > still think is broken on big-endian and needs to be adjusted to
>> > > > match
>> > > > the ABI.
>> > > >=20
>> > > > I noticed one other strange thing in the meantime: loads from
>> > > > *(__u32 *)&ctx->remote_port, *(__u16 *)&ctx->remote_port and
>> > > > *((__u16 *)&ctx->remote_port + 1) all produce 8008 on s390,
>> > > > which
>> > > > is
>> > > > clearly inconsistent. It looks as if convert_ctx_accesses()
>> > > > needs
>> > > > to be
>> > > > adjusted to handle combinations like ctx_field_size =3D=3D 4 &&
>> > > > size =3D=3D
>> > > > 2
>> > > > && target_size =3D=3D 2. I will continue with this tomorrow.
>> > > >=20
>> > > > > Or is the old behavior a bug and this new one is desirable?
>> > > > > 9a69e2b385f4 has no Fixes: tag, so I assume that's the former
>> > > > > :-(
>> > > > >=20
>> > > > > In which case, would it make sense to fix it by swapping
>> > > > > remote_port
>> > > > > and :16 in bpf_sk_lookup on big-endian?
>> > >=20
>> > > Thanks for looking into it.
>> > >=20
>> > > When it comes to requirements, my intention was to keep the same
>> > > behavior as before the split up of the remote_port field in
>> > > 9a69e2b385f4
>> > > ("bpf: Make remote_port field in struct bpf_sk_lookup 16-bit
>> > > wide").
>> > >=20
>> > > 9a69e2b385f4 was supposed to be a formality, after a similar
>> > > change
>> > > in
>> > > 4421a582718a ("bpf: Make dst_port field in struct bpf_sock 16-bit
>> > > wide"), which went in earlier.
>> > >=20
>> > > In 4421a582718a I've provided a bit more context. I understand
>> > > that
>> > > the
>> > > remote_port value, even before the type changed from u32 to u16,
>> > > appeared to the BPF program as if laid out in memory like so:
>> > >=20
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offsetof(struct bpf_sk_lookup, remote=
_port) +0=C2=A0 <port MSB>
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 +1=C2=A0 <port LSB>
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 +2=C2=A0 0x00
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 +3=C2=A0 0x00
>> > >=20
>> > > Translating it to your handy table format, I expect should result
>> > > in
>> > > loads as so if port is 8008 =3D 0x1f48:
>> > >=20
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0=C2=A0 Offset=C2=A0 LE=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 BE
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_B=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0x1f=C2=A0=C2=A0=C2=A0 0x1f
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_B=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0x48=C2=A0=C2=A0=C2=A0 0x48
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_B=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_B=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_H=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0x481f=C2=A0 0x1f48
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_H=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_W=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0x481f=C2=A0 0x1f480000
>> >=20
>> > Hmm, I think for big-endian the layout is different.
>> > If we look at test_sk_lookup.c from 9a69e2b385f4^:
>> >=20
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Narrow loads from remote=
_port field. Expect SRC_PORT. */
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (LSB(ctx->remote_port, 0=
) !=3D ((SRC_PORT >> 0) & 0xff) ||
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 LSB=
(ctx->remote_port, 1) !=3D ((SRC_PORT >> 8) & 0xff) ||
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 LSB=
(ctx->remote_port, 2) !=3D 0 || LSB(ctx->remote_port,
>> > 3)
>> > !=3D 0)
>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return SK_DROP;
>> >=20
>> > LSB() on little-endian is just byte indexing, so it's indeed=C2=A0
>> > 1f,48,00,00. However, on big-endian it's indexing from the end, so
>> > it's 00,00,48,1f.
>>=20
>> I understood that LSB() is indexing from the end on BE because
>> SRC_PORT
>> constant value differs on LE (=3D 0x481f) and BE (=3D 0x1f48) platforms,
>> so
>>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 LE=C2=A0 BE
>> =C2=A0 SRC_PORT >> 0=C2=A0 1f=C2=A0 48
>> =C2=A0 SRC_PORT >> 8=C2=A0 48=C2=A0 1f
>>=20
>> So on LE we first compare remote_port MSB, then LSB.
>> While on BE we start with remote_port LSB, then MSB.
>>=20
>> But, now that you have pointed it out, I notice that
>> sizeof(remote_port)
>> has changed and from 4 to 2, and I can't see how LSB(=E2=80=A6, 3) and L=
SB(=E2=80=A6,
>> 4)
>> loads can keep working on big-endian.
>
> Oh, right - it should be 00,00,1f,48 on big-endian.
> Out-of-bounds LSB is indeed an issue. I've posted my current
> thoughts as an RFC series [1], this one is addressed in patch 3.
>
> [1]
> https://lore.kernel.org/bpf/20220222182559.2865596-1-iii@linux.ibm.com/

Sorry for the radio silience.

I have patched my way through cross-compiling bpf selftests to s390, and
can reproduce the sk_lookup test failure on big-endian.

bpftool gen object/skeleton refusing to process BE BPF objects on an LE
host got me stuck for a moment, but user mode qemu saved the day.

FWIW, sock_fields test are also broken on BE, but failing silently, as I
observed by instrumenting the read_sk_dst_port BPF prog with bpf_printk.

I will be able check out the RFC series over this weekend.

