Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF11E415279
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237984AbhIVVNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237840AbhIVVNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 17:13:21 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7335FC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:11:50 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id v24so15215451eda.3
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5DX723n6IP6GeCbvXQpEmevbv8UGmwY9B8RvTiyRPpI=;
        b=Rx1Fek6sRB7nW63T6T1IP011SLwGoqtqbzW4/Tg9UNS2/X/bh+UtLTscoVtQOvLA/X
         rzRlvsj/aV6SlbiDQWSH+W82eFvmg+KFWxT7FuB1QI3gEMkMrp8aEGAoGWs8hvXXki3m
         uoCIFYhJIyF8L/rP0o21ftuFLzaEG7CsiC4fk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5DX723n6IP6GeCbvXQpEmevbv8UGmwY9B8RvTiyRPpI=;
        b=0gfw9+GLIq+DGaWLJ2EYSZLTMYgWNVyabALAyXd/sgN0lwIoVFt1LxB2ywXHvjRMPX
         tocRmx904/jnOlN6q6G72rYnZgublq4BaSRBAwPyDxEQ9N/TCro3KbqZbRb/9cZVPTWQ
         fqxRpeQjl6R8EuwNUGUgKfMfC2li9Pi6l2hzRIls5TcktwudGJ9Suc0H80vYGJ1vuoH6
         XBiq2VbSBSJrJEjQWtbKYyVayhRW4rm6bETsBoGh9phb3J4U6n037IpuX/iLN6uebxLl
         77K2KfOuPMD+ZKEH606AfO19EnnmyxWl7f0b+IyeyMLg35Fjhg6O9m1B88jHB7XpQ8p1
         kquw==
X-Gm-Message-State: AOAM531FlbDvVqZzzp6NPS9sjrA6caD6oXxVluFtC+eHsiE20ucb0muK
        lU7zg19+xaRz+5/2zAhbmyU/N2vBhXHwSUYyqnHVNw==
X-Google-Smtp-Source: ABdhPJy6p1+FBqINeYnptOfsAWRm2e1H4Q50vMZ09xCOBNWmY/bf4fMZsTW8md7hgcisw8EEhqhL4K/vkLYH1rrxWG0=
X-Received: by 2002:a17:906:1146:: with SMTP id i6mr1476321eja.12.1632345109000;
 Wed, 22 Sep 2021 14:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <87o88l3oc4.fsf@toke.dk> <20210921155443.507a8479@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87k0j81iq5.fsf@toke.dk>
In-Reply-To: <87k0j81iq5.fsf@toke.dk>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Wed, 22 Sep 2021 14:11:37 -0700
Message-ID: <CAC1LvL11QfiuLq3YGLsJn2meLuo5jXivFf2v-y10-ax7p7sjXQ@mail.gmail.com>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 1:03 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Jakub Kicinski <kuba@kernel.org> writes:
>
> > On Tue, 21 Sep 2021 18:06:35 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> >> 1. Do nothing. This would make it up to users / sysadmins to avoid
> >> anything breaking by manually making sure to not enable multi-buffer
> >> support while loading any XDP programs that will malfunction if
> >> presented with an mb frame. This will probably break in interesting
> >> ways, but it's nice and simple from an implementation PoV. With this
> >> we don't need the declaration discussed above either.
> >>
> >> 2. Add a check at runtime and drop the frames if they are mb-enabled a=
nd
> >> the program doesn't understand it. This is relatively simple to
> >> implement, but it also makes for difficult-to-understand issues (why
> >> are my packets suddenly being dropped?), and it will incur runtime
> >> overhead.
> >>
> >> 3. Reject loading of programs that are not MB-aware when running in an
> >> MB-enabled mode. This would make things break in more obvious ways,
> >> and still allow a userspace loader to declare a program "MB-aware" to
> >> force it to run if necessary. The problem then becomes at what level
> >> to block this?
> >>
> >> Doing this at the driver level is not enough: while a particular
> >> driver knows if it's running in multi-buff mode, we can't know for
> >> sure if a particular XDP program is multi-buff aware at attach time:
> >> it could be tail-calling other programs, or redirecting packets to
> >> another interface where it will be processed by a non-MB aware
> >> program.
> >>
> >> So another option is to make it a global toggle: e.g., create a new
> >> sysctl to enable multi-buffer. If this is set, reject loading any XDP
> >> program that doesn't support multi-buffer mode, and if it's unset,
> >> disable multi-buffer mode in all drivers. This will make it explicit
> >> when the multi-buffer mode is used, and prevent any accidental subtle
> >> malfunction of existing XDP programs. The drawback is that it's a
> >> mode switch, so more configuration complexity.
> >
> > 4. Add new program type, XDP_MB. Do not allow mixing of XDP vs XDP_MB
> > thru tail calls.
> >
> > IMHO that's very simple and covers majority of use cases.
>
> Using the program type (or maybe the expected_attach_type) was how I was
> imagining we'd encode the "I am MB aware" flag, yes. I hadn't actually
> considered that this could be used to also restrict tail call/freplace
> attachment, but that's a good point. So this leaves just the redirect
> issue, then, see my other reply.
>

I really like this apporoach as well, but before we commit to it, how likel=
y
are we to encounter this type of situation (where we need to indicate wheth=
er
an XDP program supports a new capability) again in the future. And if we do=
,
are we willing to require that all programs supporting that new feature are
also mb-aware? Essentially, the suboptimal case I'm envisioning is needing =
to
have XDP_MB, XD_MB_NEW_THING, XDP_NEW_THING, and XDP all as program types. =
That
leads to exponential explosion in program types.

Also, every time we add a program type to encode a feature (instead of a tr=
uly
new type), we're essentially forcing a recompilation (and redeployment) of =
all
existing programs that take advantage of the libbpf section name program
typing. (I'm sure there are tools that can rename a section in an ELF file
without recompilation, but recompilation seems the simplest way to correct =
the
ELF files for most people.)

If we think this is a one-off, it's probably fine, but if we think it'll ha=
ppen
again, is it worth it to find a solution that will work for future cases no=
w,
instead of having XDP, XDP_MB, and then having to find a solution for futur=
e
cases?

--Zvi

> -Toke
>
