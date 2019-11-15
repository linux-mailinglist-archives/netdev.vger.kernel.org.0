Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E73FE375
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfKOQ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:56:31 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36368 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfKOQ4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 11:56:30 -0500
Received: by mail-pj1-f68.google.com with SMTP id cq11so103650pjb.3;
        Fri, 15 Nov 2019 08:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=NbbetL8CbWzPFwnyvMgyLu5m3+9biqmJdmqKjyKfIR0=;
        b=hVAd2W1PrV07Z5BzI6AIvG8xtLS8Yk63JVDezoAPE+P9UbCTix1mD/pn14vkopZmVl
         TDAtlsOeFZVT5j80ZwKSxdtohrvv8rY0+Wtl58uZY5zm/P5b/BQNyjYOZO6QWTG4pJaO
         shMrJoqSHG605yWcLMBjQDnwclWAFdb0bhBm2gjKMDILWx3LQwR/v+7SL+vK3gJ9pWko
         0uECxXH11PLS+MNwB0GJh1MJ1DLAPlMiJDJXVo6ST7+TQyMnzdgaox5ta9NuSFlto1LE
         O7hvV2yibLKwYaRpveXydvJ7ojkYGpR5Ep6f7+jElqKs/0L7twLhXjfUibTDCi1uksMX
         +QJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=NbbetL8CbWzPFwnyvMgyLu5m3+9biqmJdmqKjyKfIR0=;
        b=YOTukat0eMVq5MCY6v/ZR2xuX99Yb0fiQjXE0m63sUmQVQ2gEMIz3nksMPowzJ2jZF
         82o6I4PTm0h0dt8Rl2HZ8xoOopyAXyI6XO4JNYP/hXc1ut98jIOnkf0wHfdqYHdlyjAt
         64WGQgvqNOWJtvumZEBpTz5JNU59QmK1egTznbnewG2cUdPLS3XgOY6gMfv8ChAvMrrE
         VfncJJITBbdti5WPToikuF9OwaCFw9I3rcbKAEcVB30j9yud4pAayKhHs0FIh7FOA3Wk
         piaOpqrqD60TYXHW4TsYiXsAj9T8cEE6znSjBDufIEFGuc3NVGIAttWzMOb/Zga3D3tX
         Tcfw==
X-Gm-Message-State: APjAAAWSheRi6JwbadLkgRN2KJl8uIRcMh2CrVhpvy3RgrK/b/8Sl63W
        bBX68gYv9yyeR2jdlAjqmUA=
X-Google-Smtp-Source: APXvYqw9ejOejfQ1GCpRH1iPDmook8ubHCdYl1HQYL6C3lvf7FgMMM0/+T+sjRzB97HA4YqR3iVCIg==
X-Received: by 2002:a17:90a:bd0c:: with SMTP id y12mr21179873pjr.108.1573836989284;
        Fri, 15 Nov 2019 08:56:29 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id a6sm12136151pja.30.2019.11.15.08.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 08:56:28 -0800 (PST)
Date:   Fri, 15 Nov 2019 08:56:27 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5dced8bbe72ed_5f462b1f489665bc31@john-XPS-13-9370.notmuch>
In-Reply-To: <20191115021318.sj5zfokruljugcno@ast-mbp.dhcp.thefacebook.com>
References: <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
 <8c251f3d-67bd-9bc2-8037-a15d93b48674@solarflare.com>
 <20191112231822.o3gir44yskmntgnq@ast-mbp.dhcp.thefacebook.com>
 <0c90adc4-5992-8648-88bf-4993252e8992@solarflare.com>
 <20191115021318.sj5zfokruljugcno@ast-mbp.dhcp.thefacebook.com>
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Wed, Nov 13, 2019 at 06:30:04PM +0000, Edward Cree wrote:
> > > There is also
> > > no way to place extern into a section. Currently SEC("..") is a sta=
ndard way to
> > > annotate bpf programs.
> > While the symbol itself doesn't have a section, each _use_ of the sym=
bol has a
> > =C2=A0reloc, and the SHT_REL[A] in which that reloc resides has a sh_=
info specifying
> > =C2=A0"the section header index of the section to which the relocatio=
n applies."=C2=A0 So
> > =C2=A0can't that be used if symbol visibility needs to depend on sect=
ion?=C2=A0 Tbh I
> > =C2=A0can't exactly see why externs need placing in a section in the =
first place.
> =

> I think section for extern can give a scope of search and make libbpf d=
ecisions
> more predictable? May be we can live without it for now, but we need BT=
F of
> extern symbols. See my example in reply to John.
> =

> > > I think we need to be able to specify something like section to
> > > extern variables and functions.
> > It seems unnecessary to have the user code specify this.=C2=A0 Anothe=
r a bad
> > =C2=A0analogy: in userland C code you don't have to annotate the func=
tion protos in
> > =C2=A0your header files to say whether they come from another .o file=
, a random
> > =C2=A0library or the libc.=C2=A0 You just declare "a function called =
this exists somewhere
> > =C2=A0and we'll find it at link time".
> =

> yeah. good analogy.
> =

> > > I was imagining that the verifier will do per-function verification=

> > > of program with sub-programs instead of analyzing from root.
> > Ah I see.=C2=A0 Yes, that's a very attractive design.
> > =

> > If we make it from a sufficiently generic idea of pre/postconditions,=
 then it
> > =C2=A0could also be useful for e.g. loop bodies (user-supplied annota=
tions that allow
> > =C2=A0us to walk the body only once instead of N times); then a funct=
ion call just
> > =C2=A0gets standard pre/postconditions generated from its argument ty=
pes if the user
> > =C2=A0didn't specify something else.
> =

> regarding pre/post conditions.
> I think we have them already. These conditions are the function prototy=
pes.
> Instead of making the verifier figuring the conditions it's simpler to =
use
> function prototypes instead. If program author is saying that argument =
to the
> function is 'struct xpd_md *' the verifier will check that the function=
 is safe
> when such pointer is passed into it. Then to verify the callsite the ve=
rifier
> only need to check that what is passed into such function matches the t=
ype. I
> think it's easy to see when such type is context. Like 'struct __sk_buf=
f *'.
> But the idea applies to pointer to int too. I believe you were arguing =
that
> instead of tnum_unknown there could be cases with tnum_range(0-2) as
> pre-condition is useful. May be. I think it will simplify the verifier =
logic
> quite a bit if we avoid going fine grain.

I was thinking we may want tnum_range(0-2) conditions and also min/max le=
ngths
of arrays, buffers etc. otherwise it might be tricky to convince the veri=
fier
its safe to write into an array. I at least am already hitting some limit=
s here
with helper calls that I would like to resolve at some point. We had to u=
se
some inline 'asm goto' logic to convince clang to generate code that the
verifier would accept. Perhaps some of this can be resolved on LLVM backe=
nd
side to insert checks as needed. Also adding compiler barriers and if/els=
e
bounds everywhere is a bit natural.  I expect post conditions will
be important for same reason, returning a pointer into a buffer without
bounds is going to make it difficult to use in the caller program. =


But(!) lets walk first implementing BTF based conditions and linking is
a huge step and doesn't preclude doing more advance things next.

> Say we have a function:
> int foo(struct __sk_buff *skb, int arg)
> {
>    if (arg > 2)
>       return 0;
>    // do safe stuff with skb depending whether arg is 0, 1, or 2.
> }
> That first 'if' is enough to turn pre-conditions into 'any skb' and 'an=
y arg'.
> That is exactly what BTF says about this function.
> =


But this would probably break,

 char *foo(struct __Sk_buff *skb, char *buffer)
 {
      int i;

      for i =3D 0; i < BUFFER_LENGTH; i++) {
             buffer[i] =3D blah
      }
      return buffer[i]
 }

Lets deal with that later though.=
