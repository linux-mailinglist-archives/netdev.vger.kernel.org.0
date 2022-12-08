Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97992647A4D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 00:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiLHXrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 18:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHXrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 18:47:08 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E7B17E04
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 15:47:07 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so6298909pjr.3
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 15:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsiZ9s0yp8OUDlVyAwoSvSCb5GsD3AVTDpcvuxldQfs=;
        b=nXOiiX+VU152FyXbI9HbjdFrabUKjr2ExBALOa4KD1qpYheo3s//ZXaiKEj2spZ7oB
         lDyFoINq111EyQnfb1ZOg9mX4je9hOTWtixoDjmCXnD//x6Byj5YmhwTOuYzmYSV03q2
         0GmIN8X/Mt7wB8A4cCNZCibWQ93HqiWHuUN+nyUNASQW/GAawMOEARYd7QnDDkgIvkZh
         Zl7qi82uPc0rzMpHvHEtx9YSzi5x1WN0M/rdzCDO1tyAmSyN1+1flttrLi6Uv7W/dIt1
         uxs4SeoMgcFgq9w3U9a4O+i6Q/XtZHNe/u4gum9pb8dT9TZ/ygpKNGIEZpA3pJy+uwrm
         OtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qsiZ9s0yp8OUDlVyAwoSvSCb5GsD3AVTDpcvuxldQfs=;
        b=8RlgPNfqu2yhpV/qh2GuxJkXbnzqOfN3RrXuAPRTjil45XMjGmKyNMGT3FCGsm5fe4
         HCEUk+oSVacyQz7nY3kJQr/FmErutXxWK/cBBa77abzuyXe/R/9sEZzMKLjd38gjWtlj
         ELwNgqSytxlF0i6buC4Z6IFX7Y9qz6omF36epaAtu0mqW0y31nbecEBveD26Zvllu5JL
         DinYxkDgvvpqw7bVXlW/9rjfz9tu+aYinpSD+pXXIMDUZoPHxM1u5TY+WW/6FyrIyjLD
         wq5BUqGK0XS76NNIJCJXYmnm12JpUWSWhmTWwn9ieHWJZ9Yn6UlGdMu3v5jijXQnao6J
         hYaw==
X-Gm-Message-State: ANoB5pnqaUUQUQ9TaRsrJeWTvMOJlE1EqxIHLXbHlET4eUzCRshhkpzh
        pE7IfPOPiVW0HWgUfaG0GRALhl+M5WXAkw8+X/KTww==
X-Google-Smtp-Source: AA0mqf53HTVaefPFy0V6y2L9HDcjm12+3TUzV47rrKRIHbnH5Tk9Q+Y9tu1d7g1+iMNJKIsJtvsc9Q2rd4XXLT+X+c0=
X-Received: by 2002:a17:90a:6382:b0:219:fbc:a088 with SMTP id
 f2-20020a17090a638200b002190fbca088mr65066280pjj.162.1670543227082; Thu, 08
 Dec 2022 15:47:07 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-4-sdf@google.com>
 <878rjhldv0.fsf@toke.dk>
In-Reply-To: <878rjhldv0.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 15:46:55 -0800
Message-ID: <CAKH8qBvgkTXFEhd9hOa+SFtqKAXuD=WM_h1TZYdQA0d70_drEA@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 2:39 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > There is an ndo handler per kfunc, the verifier replaces a call to the
> > generic kfunc with a call to the per-device one.
> >
> > For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> > implements all possible metatada kfuncs. Not all devices have to
> > implement them. If kfunc is not supported by the target device,
> > the default implementation is called instead.
>
> So one unfortunate consequence of this "fallback to the default
> implementation" is that it's really easy to get a step wrong and end up
> with something that doesn't work. Specifically, if you load an XDP
> program that calls the metadata kfuncs, but don't set the ifindex and
> flag on load, the kfunc resolution will work just fine, but you'll end
> up calling the default kfunc implementations (and get no data). I ran
> into this multiple times just now when playing around with it and
> implementing the freplace support.
>
> So I really think it would be a better user experience if we completely
> block (with a nice error message!) the calling of the metadata kfuncs if
> the program is not device-bound...

Oh, right, that's a good point. Having defaults for dev-bound only
makes total sense.

> Another UX thing I ran into is that libbpf will bail out if it can't
> find the kfunc in the kernel vmlinux, even if the code calling the
> function is behind an always-false if statement (which would be
> eliminated as dead code from the verifier). This makes it a bit hard to
> conditionally use them. Should libbpf just allow the load without
> performing the relocation (and let the verifier worry about it), or
> should we have a bpf_core_kfunc_exists() macro to use for checking?
> Maybe both?

I'm not sure how libbpf can allow the load without performing the
relocation; maybe I'm missing something.
IIUC, libbpf uses the kfunc name (from the relocation?) and replaces
it with the kfunc id, right?

Having bpf_core_kfunc_exists would help, but this probably needs
compiler work first to preserve some of the kfunc traces in vmlinux.h?

So yeah, I don't have any good ideas/suggestions here on how to make
it all magically work :-(

> > Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
> > we treat prog_index as target device for kfunc resolution.
>
> [...]
>
> > -     if (!bpf_prog_map_compatible(map, prog)) {
> > -             bpf_prog_put(prog);
> > -             return ERR_PTR(-EINVAL);
> > -     }
> > +     /* When tail-calling from a non-dev-bound program to a dev-bound =
one,
> > +      * XDP metadata helpers should be disabled. Until it's implemente=
d,
> > +      * prohibit adding dev-bound programs to tail-call maps.
> > +      */
> > +     if (bpf_prog_is_dev_bound(prog->aux))
> > +             goto err;
> > +
> > +     if (!bpf_prog_map_compatible(map, prog))
> > +             goto err;
>
> I think it's better to move the new check into bpf_prog_map_compatible()
> itself; that way it'll cover cpumaps and devmaps as well :)

Will do, thanks!

> -Toke
>
