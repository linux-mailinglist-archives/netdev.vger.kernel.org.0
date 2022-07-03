Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99DD56452C
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 07:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiGCFZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 01:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGCFZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 01:25:05 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CAF65B7;
        Sat,  2 Jul 2022 22:25:04 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u20so5878964iob.8;
        Sat, 02 Jul 2022 22:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3HK4FIkMME7ZTlM2PzRYa6D9QnahAXeNs3vGXTyYa7k=;
        b=A/Q7P6AuSXIR9xFWwKATffVwqcsQ9jv1DytdFzmEb+kP4vs7QWD9lot7u3Cr4jqXIV
         40NAlvTwzGV1Mzhe7tpFMej6ApJERvZ73R6wiPuBtiiRNb9vtWUThXZgfHfnmsrYkY5+
         xKlbOpFi4Z0Q4Dvj2Jll8oDCGLOqnHrGKFa7oQtcFe45B/SuaEJ1pwAU9DoimPXVXzII
         mvMUccrVCrIFp8pIaaUmP/ETUrEPhrsSedLzeaKlAIhNLSKDNUApB3LltZWoVkeGzek5
         y9Esbrt2TkoNGYPz+iywwMaW8pW0IG7fvY3eHzu1ffCUkJvdc5h1MCsHse5ZzRw4Q5Jp
         T15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3HK4FIkMME7ZTlM2PzRYa6D9QnahAXeNs3vGXTyYa7k=;
        b=fAPKZIWSs+1WCEn7DkuOmTE7XM+3c0bvE5HA355v1q7JLBeQwiMPQhKsb90cfdCaeH
         taQmxbT/Wqk6zceyVSUKiDKEMCnrqTIVR7Dgc+dJy2D7EcGZHGgJmb82/I+2AVO5Oo7w
         YOxW/YXsJ4pz7RFeP96qzalQ2oVpbRpltavV6lohdT/WbaA8Zt48v0b4aN/ADY7ZK1lE
         QvVqZ+Ylk1lRPxf41cNJWqG7QHj7Qf9+9R+jvFCdi3A96XQgFv+8J7UUitqzNGf+58Bz
         4c6EVsAY2xGaB9vBv11gQWwGHy0OGb+VqQfBRgQntVg52PzcPCNEaU6vwQXsZ47MpwKB
         feNQ==
X-Gm-Message-State: AJIora87OkPBXjQcRdjj/LkOUYP/VaSNC3UndZx0IrT1/bGfkMiWAiXb
        A1LuH2ytfbDthPkR7KZ53y4DV0sR9TLQSZl1LAc=
X-Google-Smtp-Source: AGRyM1vRhLJ4eHeXdcYhvoSVdvgNc/t2+D/qhSYhSMXF5Vy7NwaWfeLwQwan9Qg3zplL4fO0sGG+LEJH/5iDSh3Kwyw=
X-Received: by 2002:a05:6638:f81:b0:33c:5393:c0ff with SMTP id
 h1-20020a0566380f8100b0033c5393c0ffmr13997565jal.231.1656825903468; Sat, 02
 Jul 2022 22:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220623192637.3866852-1-memxor@gmail.com> <20220623192637.3866852-2-memxor@gmail.com>
 <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sun, 3 Jul 2022 10:54:23 +0530
Message-ID: <CAP01T77fsU8u6GP+HXfQQ_gdu+kp3Am1+Ao-mNYULjDazHs38Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 at 08:53, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 24, 2022 at 12:56:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> > Similar to how we detect mem, size pairs in kfunc, teach verifier to
> > treat __ref suffix on argument name to imply that it must be a
> > referenced pointer when passed to kfunc. This is required to ensure that
> > kfunc that operate on some object only work on acquired pointers and not
> > normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> > walking. Release functions need not specify such suffix on release
> > arguments as they are already expected to receive one referenced
> > argument.
> >
> > Note that we use strict type matching when a __ref suffix is present on
> > the argument.
> ...
> > +             /* Check if argument must be a referenced pointer, args + i has
> > +              * been verified to be a pointer (after skipping modifiers).
> > +              */
> > +             arg_ref = is_kfunc_arg_ref(btf, args + i);
> > +             if (is_kfunc && arg_ref && !reg->ref_obj_id) {
> > +                     bpf_log(log, "R%d must be referenced\n", regno);
> > +                     return -EINVAL;
> > +             }
> > +
>
> imo this suffix will be confusing to use.
> If I understand the intent the __ref should only be used
> in acquire (and other) kfuncs that also do release.
> Adding __ref to actual release kfunc will be a nop.
> It will be checked, but it's not necessary.
>
> At the end
> +struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
> will behave like kptr_xchg with exception that kptr_xchg takes any btf_id
> while here it's fixed.
>
> The code:
>  if (rel && reg->ref_obj_id)
>         arg_type |= OBJ_RELEASE;
> should probably be updated with '|| arg_ref'
> to make sure reg->off == 0 ?
> That looks like a small bug.
>

Indeed, I missed that. Thanks for catching it.

> But stepping back... why __ref is needed ?
> We can add bpf_ct_insert_entry to acq and rel sets and it should work?
> I'm assuming you're doing the orthogonal cleanup of resolve_btfid,
> so we will have a single kfunc set where bpf_ct_insert_entry will
> have both acq and rel flags.
> I'm surely missing something.

It is needed to prevent the case where someone might do:
ct = bpf_xdp_ct_alloc(...);
bpf_ct_set_timeout(ct->master, ...);

Or just obtain PTR_TO_BTF_ID by pointer walking and try to pass it in
to bpf_ct_set_timeout.

__ref allows an argument on a non-release kfunc to have checks like a
release argument, i.e. refcounted, reg->off == 0 (var_off is already
checked to be 0), so use the original pointer that was obtained from
an acquire kfunc. As you noted, it isn't strictly needed on release
kfunc (like bpf_ct_insert_entry) because the same checks happen for it
anyway. But both timeout and status helpers should use it if they
"operate" on the acquired ct (from alloc, insert, or lookup).
