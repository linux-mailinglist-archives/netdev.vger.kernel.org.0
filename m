Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AC24C017F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiBVSjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiBVSja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:39:30 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50F895483
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:39:03 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id j15so26581635lfe.11
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=L6wm5MBeh72wTvetYJOdYxWP9lbwHJ1SwpX9xuNkcog=;
        b=FC6vL+DyPy2ZqUQIZn5eGRGldQYaavmiV9PU77iUP4riRePtOWz7KT/De8Zl8X1G3Y
         nFI289B1K4VDxGgPHwA6MkLghdg/qUkq5RtCcMgb8EWJaFaGqnFQwD2kvYyXu+qLEAqh
         anDMkBPJvCY3spU714K8Ee9cjpamenRkFF7Dc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=L6wm5MBeh72wTvetYJOdYxWP9lbwHJ1SwpX9xuNkcog=;
        b=HJ8VFhBGcZCasKkjhWVJIjzLp1xTgGnaD715Vz0NZszKDC1PwSLIdIqvV2dleMZPks
         hhsv8Lh830oYqqQuC9FLgN3GAzncrEOmHgV9CRJr4+RO0IkfKQEq57Neli+5ZHvunG+C
         LZaqZTaCVgohNiL2Ah/4Xo+axyWCdoRmylwG9BYLdFPM+/KYLrYII01JcitIf4juZ4tk
         SNfdK3HCYOAwilczgyvvZTZFg9bBOyv3j5C0X//VoQW3bamBDCwJfnY0zzujQss8GmBO
         WHqDTQVUwodxWfzJvkjo8E5F17kWAPb7Gf0vbMmyPIYjed3P8HBH8h5DKeq/gBS/ZoVy
         oHrA==
X-Gm-Message-State: AOAM530x+RxCjHOaFh6HGPhbcrLHzXYhqbiMpVC+xczzj54WI08rqrju
        x5wAWpg0LQw2q/TLdMl6Ey0lgZajtG7X6A==
X-Google-Smtp-Source: ABdhPJxOxQLtIik5i4TpnPW4Xd/iainAY7zmgnXqK4oPYCpLARRmRIOq49Mi7rEZas/PTcKNO8fMBg==
X-Received: by 2002:a19:7504:0:b0:443:15b6:5641 with SMTP id y4-20020a197504000000b0044315b65641mr18087261lfe.351.1645555141917;
        Tue, 22 Feb 2022 10:39:01 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0f9c.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id u8sm1397505lfi.211.2022.02.22.10.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 10:39:01 -0800 (PST)
References: <20220221180358.169101-1-jakub@cloudflare.com>
 <8ff3f2ff692acaffe9494007a3431c269372f822.camel@linux.ibm.com>
 <88a4927eaf3ca385ce9a7406ef23062a39eb1734.camel@linux.ibm.com>
 <0eeac90306f03b4fdb2b028ffb509e4d20121aec.camel@linux.ibm.com>
 <87fsoakjj6.fsf@cloudflare.com>
 <6e28c1c3ef0eda6f041593216ac32b210e55e4b7.camel@linux.ibm.com>
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
Date:   Tue, 22 Feb 2022 19:24:11 +0100
In-reply-to: <6e28c1c3ef0eda6f041593216ac32b210e55e4b7.camel@linux.ibm.com>
Message-ID: <87bkyykapm.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 06:42 PM +01, Ilya Leoshkevich wrote:
> On Tue, 2022-02-22 at 15:53 +0100, Jakub Sitnicki wrote:
>> On Tue, Feb 22, 2022 at 03:22 AM +01, Ilya Leoshkevich wrote:
>> > On Tue, 2022-02-22 at 01:43 +0100, Ilya Leoshkevich wrote:
>> > > On Mon, 2022-02-21 at 22:39 +0100, Ilya Leoshkevich wrote:
>> > > > On Mon, 2022-02-21 at 19:03 +0100, Jakub Sitnicki wrote:
>> > > > > Shifting 16-bit type by 16 bits is implementation-defined for
>> > > > > BPF
>> > > > > programs.
>> > > > > Don't rely on it in case it is causing the test failures we
>> > > > > are
>> > > > > seeing on
>> > > > > s390x z15 target.
>> > > > >=20
>> > > > > Fixes: 2ed0dc5937d3 ("selftests/bpf: Cover 4-byte load from
>> > > > > remote_port in bpf_sk_lookup")
>> > > > > Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>> > > > > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> > > > > ---
>> > > > >=20
>> > > > > I don't have a dev env for s390x/z15 set up yet, so can't
>> > > > > definitely
>> > > > > confirm the fix.
>> > > > > That said, it seems worth fixing either way.
>> > > > >=20
>> > > > > =C2=A0tools/testing/selftests/bpf/progs/test_sk_lookup.c | 3 ++-
>> > > > > =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>> > > > >=20
>> > > > > diff --git
>> > > > > a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
>> > > > > b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
>> > > > > index bf5b7caefdd0..7d47276a8964 100644
>> > > > > --- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
>> > > > > +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
>> > > > > @@ -65,6 +65,7 @@ static const __u32 KEY_SERVER_A =3D SERVER_A;
>> > > > > =C2=A0static const __u32 KEY_SERVER_B =3D SERVER_B;
>> > > > > =C2=A0
>> > > > > =C2=A0static const __u16 SRC_PORT =3D bpf_htons(8008);
>> > > > > +static const __u32 SRC_PORT_U32 =3D bpf_htonl(8008U << 16);
>> > > > > =C2=A0static const __u32 SRC_IP4 =3D IP4(127, 0, 0, 2);
>> > > > > =C2=A0static const __u32 SRC_IP6[] =3D IP6(0xfd000000, 0x0, 0x0,
>> > > > > 0x00000002);
>> > > > > =C2=A0
>> > > > > @@ -421,7 +422,7 @@ int ctx_narrow_access(struct
>> > > > > bpf_sk_lookup
>> > > > > *ctx)
>> > > > > =C2=A0
>> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Load from rem=
ote_port field with zero padding
>> > > > > (backward
>> > > > > compatibility) */
>> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0val_u32 =3D *(__=
u32 *)&ctx->remote_port;
>> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (val_u32 !=3D bpf_=
htonl(bpf_ntohs(SRC_PORT) << 16))
>> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (val_u32 !=3D SRC_=
PORT_U32)
>> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return SK_DROP;
>> > > > > =C2=A0
>> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Narrow loads =
from local_port field. Expect
>> > > > > DST_PORT.
>> > > > > */
>> > > >=20
>> > > > Unfortunately this doesn't help with the s390 problem.
>> > > > I'll try to debug this.
>> > >=20
>> > > I have to admit I have a hard time wrapping my head around the
>> > > requirements here.
>> > >=20
>> > > Based on the pre-9a69e2b385f4 code, do I understand correctly
>> > > that
>> > > for the following input
>> > >=20
>> > > Port:=C2=A0=C2=A0=C2=A0=C2=A0 0x1f48
>> > > SRC_PORT: 0x481f
>> > >=20
>> > > we expect the following results for different kinds of loads:
>> > >=20
>> > > Size=C2=A0=C2=A0 Offset=C2=A0 LE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BE
>> > > BPF_B=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1f=C2=A0=C2=A0=
=C2=A0 0
>> > > BPF_B=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x48=C2=A0=C2=A0=
=C2=A0 0
>> > > BPF_B=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0x48
>> > > BPF_B=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0x1f
>> > > BPF_H=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x481f=C2=A0 0
>> > > BPF_H=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0x481f
>> > > BPF_W=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x481f=C2=A0 0x481f
>> > >=20
>> > > and this is guaranteed by the struct bpf_sk_lookup ABI? Because
>> > > then
>> > > it
>> > > looks as if 9a69e2b385f4 breaks it on big-endian as follows:
>> > >=20
>> > > Size=C2=A0=C2=A0 Offset=C2=A0 BE-9a69e2b385f4
>> > > BPF_B=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x48
>> > > BPF_B=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1f
>> > > BPF_B=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > BPF_B=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > BPF_H=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x481f
>> > > BPF_H=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> > > BPF_W=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x481f0000
>> >=20
>> > Sorry, I worded this incorrectly: 9a69e2b385f4 did not change the
>> > kernel behavior, the ABI is not broken and the old compiled code
>> > should
>> > continue to work.
>> > What the second table really shows are what the results should be
>> > according to the 9a69e2b385f4 struct bpf_sk_lookup definition,
>> > which I
>> > still think is broken on big-endian and needs to be adjusted to
>> > match
>> > the ABI.
>> >=20
>> > I noticed one other strange thing in the meantime: loads from
>> > *(__u32 *)&ctx->remote_port, *(__u16 *)&ctx->remote_port and
>> > *((__u16 *)&ctx->remote_port + 1) all produce 8008 on s390, which
>> > is
>> > clearly inconsistent. It looks as if convert_ctx_accesses() needs
>> > to be
>> > adjusted to handle combinations like ctx_field_size =3D=3D 4 && size =
=3D=3D
>> > 2
>> > && target_size =3D=3D 2. I will continue with this tomorrow.
>> >=20
>> > > Or is the old behavior a bug and this new one is desirable?
>> > > 9a69e2b385f4 has no Fixes: tag, so I assume that's the former :-(
>> > >=20
>> > > In which case, would it make sense to fix it by swapping
>> > > remote_port
>> > > and :16 in bpf_sk_lookup on big-endian?
>>=20
>> Thanks for looking into it.
>>=20
>> When it comes to requirements, my intention was to keep the same
>> behavior as before the split up of the remote_port field in
>> 9a69e2b385f4
>> ("bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide").
>>=20
>> 9a69e2b385f4 was supposed to be a formality, after a similar change
>> in
>> 4421a582718a ("bpf: Make dst_port field in struct bpf_sock 16-bit
>> wide"), which went in earlier.
>>=20
>> In 4421a582718a I've provided a bit more context. I understand that
>> the
>> remote_port value, even before the type changed from u32 to u16,
>> appeared to the BPF program as if laid out in memory like so:
>>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offsetof(struct bpf_sk_lookup, remote_por=
t) +0=C2=A0 <port MSB>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +1=
=C2=A0 <port LSB>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +2=
=C2=A0 0x00
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +3=
=C2=A0 0x00
>>=20
>> Translating it to your handy table format, I expect should result in
>> loads as so if port is 8008 =3D 0x1f48:
>>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0=C2=A0 Offset=C2=A0 LE=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 BE
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_B=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0x1f=C2=A0=C2=A0=C2=A0 0x1f
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_B=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0x48=C2=A0=C2=A0=C2=A0 0x48
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_B=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_B=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_H=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0x481f=C2=A0 0x1f48
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_H=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_W=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0x481f=C2=A0 0x1f480000
>
> Hmm, I think for big-endian the layout is different.
> If we look at test_sk_lookup.c from 9a69e2b385f4^:
>
>         /* Narrow loads from remote_port field. Expect SRC_PORT. */
>         if (LSB(ctx->remote_port, 0) !=3D ((SRC_PORT >> 0) & 0xff) ||
>             LSB(ctx->remote_port, 1) !=3D ((SRC_PORT >> 8) & 0xff) ||
>             LSB(ctx->remote_port, 2) !=3D 0 || LSB(ctx->remote_port, 3)
> !=3D 0)
>                 return SK_DROP;
>
> LSB() on little-endian is just byte indexing, so it's indeed=C2=A0
> 1f,48,00,00. However, on big-endian it's indexing from the end, so
> it's 00,00,48,1f.

I understood that LSB() is indexing from the end on BE because SRC_PORT
constant value differs on LE (=3D 0x481f) and BE (=3D 0x1f48) platforms, so

                 LE  BE
  SRC_PORT >> 0  1f  48
  SRC_PORT >> 8  48  1f

So on LE we first compare remote_port MSB, then LSB.
While on BE we start with remote_port LSB, then MSB.

But, now that you have pointed it out, I notice that sizeof(remote_port)
has changed and from 4 to 2, and I can't see how LSB(=E2=80=A6, 3) and LSB(=
=E2=80=A6, 4)
loads can keep working on big-endian.

[...]
