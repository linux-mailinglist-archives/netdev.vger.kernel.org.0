Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F08413B1D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 22:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhIUUNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 16:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhIUUNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 16:13:45 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8E7C061574;
        Tue, 21 Sep 2021 13:12:17 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 17so234480pgp.4;
        Tue, 21 Sep 2021 13:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p61fV+YPNEywapwVLSX3U6IkS8bYclMoOHe7cYi5X18=;
        b=eIy54y+X5rgzItP7ZeWNXNshPCqA+89uCpiYem2Hhf29ySBVE3JPvC0IBj/zg6NEcz
         RM6t6f5jaNo1Zbo/OrdJxxef5tuXOSk9m2sjb08mgBowxwXV4FMBcVzZkUUWiQzWWaBe
         MOmblvVkMFYmlihUphw/7/NvX8GpP7VVjCBv3YgPB//ROnQwRC/v3LurUtOKRM+m+gzU
         p1qFcsTqYsk+eT7FXDFPDZWYLAgPpZfsL9D5RJg11gLR+7lggtCII+YSsGoOADNZhClN
         0TcHnp7tSKqGc+HYX/9gI7yUKEEjDHfPj0WPMeYtjTy4kdQ698TbtLRDFiZmoUbgWiez
         sskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p61fV+YPNEywapwVLSX3U6IkS8bYclMoOHe7cYi5X18=;
        b=2XVjJB+YmhTWh1ckswSiCAS4b5qYHIQVtkK64SZwwqyHd+SgUtB/W99egvRBU5+ViU
         n/V0bZcAAShmF03cbMc3Ng7ZWLMyAao+0k0KBirRpWLioGry87cuEwo5bWxve+Yy8VTs
         prI4COPEtNLHpK5DBwEZkgKtgerIlk/Sux74iTobGFPyO5kWWHBd00xOLDeMhtwUtwQx
         lUIvGJ33HOl56yW8TA8+vDSPnqCCqEtyJnI0asIK86ozG21BxGpj3L31g1if6TKYYUui
         55Beqx6HPxRaK9K96BFFbPBBKE1AeHYMYgaLLIQi0TUU/NkLwYCIzlu3KbrhDPwlrU1j
         jeKA==
X-Gm-Message-State: AOAM531qz6Y28uk/mOjG64fPjk9OP0mawbkk/XD6JnPlpssnlOXBmPDQ
        jUQfC7LwpuhXaORmgOz03uCkjqNCVSFlAGX07OM=
X-Google-Smtp-Source: ABdhPJwSwTZ/v7tYZwxP/eM3wDvQUMohzR0Zg4VWVjePKQEqDpo6w9XNyrOfaoDKf0yf82Hoamb32jTBX+xN+eVpm2o=
X-Received: by 2002:a63:5c51:: with SMTP id n17mr29849307pgm.376.1632255136460;
 Tue, 21 Sep 2021 13:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <87o88l3oc4.fsf@toke.dk> <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
 <87ilyt3i0y.fsf@toke.dk>
In-Reply-To: <87ilyt3i0y.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Sep 2021 13:12:05 -0700
Message-ID: <CAADnVQKi_u6yZnsxEagNTv-XWXtLPpXwURJH0FnGFRgt6weiww@mail.gmail.com>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Zvi Effron <zeffron@riotgames.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 11:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Zvi Effron <zeffron@riotgames.com> writes:
>
> > On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Hi Lorenz (Cc. the other people who participated in today's discussion=
)
> >>
> >> Following our discussion at the LPC session today, I dug up my previou=
s
> >> summary of the issue and some possible solutions[0]. Seems no on
> >> actually replied last time, which is why we went with the "do nothing"
> >> approach, I suppose. I'm including the full text of the original email
> >> below; please take a look, and let's see if we can converge on a
> >> consensus here.
> >>
> >> First off, a problem description: If an existing XDP program is expose=
d
> >> to an xdp_buff that is really a multi-buffer, while it will continue t=
o
> >> run, it may end up with subtle and hard-to-debug bugs: If it's parsing
> >> the packet it'll only see part of the payload and not be aware of that
> >> fact, and if it's calculating the packet length, that will also only b=
e
> >> wrong (only counting the first fragment).
> >>
> >> So what to do about this? First of all, to do anything about it, XDP
> >> programs need to be able to declare themselves "multi-buffer aware" (b=
ut
> >> see point 1 below). We could try to auto-detect it in the verifier by
> >> which helpers the program is using, but since existing programs could =
be
> >> perfectly happy to just keep running, it probably needs to be somethin=
g
> >> the program communicates explicitly. One option is to use the
> >> expected_attach_type to encode this; programs can then declare it in t=
he
> >> source by section name, or the userspace loader can set the type for
> >> existing programs if needed.
> >>
> >> With this, the kernel will know if a given XDP program is multi-buff
> >> aware and can decide what to do with that information. For this we cam=
e
> >> up with basically three options:
> >>
> >> 1. Do nothing. This would make it up to users / sysadmins to avoid
> >>    anything breaking by manually making sure to not enable multi-buffe=
r
> >>    support while loading any XDP programs that will malfunction if
> >>    presented with an mb frame. This will probably break in interesting
> >>    ways, but it's nice and simple from an implementation PoV. With thi=
s
> >>    we don't need the declaration discussed above either.
> >>
> >> 2. Add a check at runtime and drop the frames if they are mb-enabled a=
nd
> >>    the program doesn't understand it. This is relatively simple to
> >>    implement, but it also makes for difficult-to-understand issues (wh=
y
> >>    are my packets suddenly being dropped?), and it will incur runtime
> >>    overhead.
> >>
> >> 3. Reject loading of programs that are not MB-aware when running in an
> >>    MB-enabled mode. This would make things break in more obvious ways,
> >>    and still allow a userspace loader to declare a program "MB-aware" =
to
> >>    force it to run if necessary. The problem then becomes at what leve=
l
> >>    to block this?
> >>
> >
> > I think there's another potential problem with this as well: what happe=
ns to
> > already loaded programs that are not MB-aware? Are they forcibly unload=
ed?
>
> I'd say probably the opposite: You can't toggle whatever switch we end
> up with if there are any non-MB-aware programs (you'd have to unload
> them first)...
>
> >>    Doing this at the driver level is not enough: while a particular
> >>    driver knows if it's running in multi-buff mode, we can't know for
> >>    sure if a particular XDP program is multi-buff aware at attach time=
:
> >>    it could be tail-calling other programs, or redirecting packets to
> >>    another interface where it will be processed by a non-MB aware
> >>    program.
> >>
> >>    So another option is to make it a global toggle: e.g., create a new
> >>    sysctl to enable multi-buffer. If this is set, reject loading any X=
DP
> >>    program that doesn't support multi-buffer mode, and if it's unset,
> >>    disable multi-buffer mode in all drivers. This will make it explici=
t
> >>    when the multi-buffer mode is used, and prevent any accidental subt=
le
> >>    malfunction of existing XDP programs. The drawback is that it's a
> >>    mode switch, so more configuration complexity.
> >>
> >
> > Could we combine the last two bits here into a global toggle that doesn=
't
> > require a sysctl? If any driver is put into multi-buffer mode, then the=
 system
> > switches to requiring all programs be multi-buffer? When the last multi=
-buffer
> > enabled driver switches out of multi-buffer, remove the system-wide
> > restriction?
>
> Well, the trouble here is that we don't necessarily have an explicit
> "multi-buf mode" for devices. For instance, you could raise the MTU of a
> device without it necessarily involving any XDP multi-buffer stuff (if
> you're not running XDP on that device). So if we did turn "raising the
> MTU" into such a mode switch, we would end up blocking any MTU changes
> if any XDP programs are loaded. Or having an MTU change cause a
> force-unload of all XDP programs.

MTU change that bumps driver into multi-buf mode or enable
the header split that also bumps it into multi-buf mode
probably shouldn't be allowed when non-mb aware xdp prog is attached.
That would be the simplest and least surprising behavior.
Force unload could cause security issues.

> Neither of those are desirable outcomes, I think; and if we add a
> separate "XDP multi-buff" switch, we might as well make it system-wide?

If we have an internal flag 'this driver supports multi-buf xdp' cannot we
make xdp_redirect to linearize in case the packet is being redirected
to non multi-buf aware driver (potentially with corresponding non mb aware =
xdp
progs attached) from mb aware driver?
