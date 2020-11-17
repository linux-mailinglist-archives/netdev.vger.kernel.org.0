Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8D22B5B65
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKQIzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgKQIzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:55:25 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64275C0613CF;
        Tue, 17 Nov 2020 00:55:25 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id q28so5192600pgk.1;
        Tue, 17 Nov 2020 00:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1OytPDdyf7Cx7RlGoMIDG376V85V7Sf/qh4TOl3J0PI=;
        b=MXjliFwxXvtURvZKislZO/l8/YAK10b2vxeXaqBsOBJ7LG+B+LutUyFqNYsuChdDRI
         YLgDMC+Vv5Juhs4fFRLv3ncEY6dr6EIIvrGKxsA6Wj4iFww7Mt9PaSvtbpTKCCk2jb2p
         5wQK+tCxIf6H19ucFWjgHvL2JNcdQ+Lg1Mre5SsYSJ6Whgjr20pmqE9c5Of+vQvUz5z7
         Q/30rfVz7sY6EPz+LwwmJ86Q4etqQ1N+qowmYy6jhenpxIeJ9xTauJS18EJCHn7UHxVe
         WGQ6XBOFAgvST2AMhGntPcLra7hiMxUE7Gv6AiJbIPXF016ammP0mWdXCLhzVGaxO9ly
         4Ypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1OytPDdyf7Cx7RlGoMIDG376V85V7Sf/qh4TOl3J0PI=;
        b=JB36PoA2V2HkJyiTOHfjqyl3DKUSrVDkCCLsp2fbUzZjNjfQ1YymHkbO3NPE/FmZkB
         PGwD6KWbg+kzio27dT8uaf3me047Y9gJP1x5fYsrHryEKHX3U/84dBvQQoRCxLUkRx1K
         gy5sSKwwisv7WlwIn4NOUSByiUKYaRSEcEAvTjdXPuKJm8DWUbqRJAFs+H6nJQ6sy9jG
         pHXtZKdMXTx3t70zS8xW8OPl5v4PcmradQhdENZ3F6lYym8QBGealKXBjpYqvwDK8rzE
         +XLffbYdfdZbah2s6DyTWEj3mA6AVvRmbU01NFO47oGA6U5gXXmUylL2G0mkcMEm53Kt
         +1Fw==
X-Gm-Message-State: AOAM5329/n8KXeu1/F8pxLvq86DOk+4BD+tDGLY16+nGH9OgucbKcD5Y
        mQb5YVaX7wnpmBb8pID6MhXzSaCEwGFlk/EJqy4=
X-Google-Smtp-Source: ABdhPJy5HJBd3EXmRmg6LTZMhu+k1KD2jUDdBTFncRECIeY45EF4AAzQvwpqdDZmq6laqf2S+w2xvJZ9Vv5I3GMncHg=
X-Received: by 2002:a63:3c10:: with SMTP id j16mr2726953pga.140.1605603324935;
 Tue, 17 Nov 2020 00:55:24 -0800 (PST)
MIME-Version: 1.0
References: <20201116093452.7541-1-marekx.majtyka@intel.com>
 <875z655t80.fsf@toke.dk> <CAJ8uoz1C7-a7A0WJqThomSxYwmdkfLpDyC5YnB8g_J+p486RXQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz1C7-a7A0WJqThomSxYwmdkfLpDyC5YnB8g_J+p486RXQ@mail.gmail.com>
From:   Marek Majtyka <alardam@gmail.com>
Date:   Tue, 17 Nov 2020 09:55:13 +0100
Message-ID: <CAAOQfrGzfKf-vpaitfC_KLDnWDo_uJFDF_PE5X9RH_G4Yt8QHA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 0/8] New netdev feature flags for XDP
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Marek Majtyka <marekx.majtyka@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 8:37 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:

Thank you for your quick answers and comments.

>
> On Mon, Nov 16, 2020 at 2:25 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > alardam@gmail.com writes:
> >
> > > From: Marek Majtyka <marekx.majtyka@intel.com>
> > >
> > > Implement support for checking if a netdev has native XDP and AF_XDP =
zero
> > > copy support. Previously, there was no way to do this other than to t=
ry
> > > to create an AF_XDP socket on the interface or load an XDP program an=
d
> > > see if it worked. This commit changes this by extending existing
> > > netdev_features in the following way:
> > >  * xdp        - full XDP support (XDP_{TX, PASS, DROP, ABORT, REDIREC=
T})
> > >  * af-xdp-zc  - AF_XDP zero copy support
> > > NICs supporting these features are updated by turning the correspondi=
ng
> > > netdev feature flags on.
> >
> > Thank you for working on this! The lack of a way to discover whether an
> > interface supports XDP is really annoying.
> >
> > However, I don't think just having two separate netdev feature flags fo=
r
> > XDP and AF_XDP is going to cut it. Whatever mechanism we end up will
> > need to be able to express at least the following, in addition to your
> > two flags:
> >
> > - Which return codes does it support (with DROP/PASS, TX and REDIRECT a=
s
> >   separate options)?
> > - Does this interface be used as a target for XDP_REDIRECT
> >   (supported/supported but not enabled)?
> > - Does the interface support offloaded XDP?
>
> If we want feature discovery on this level, which seems to be a good
> idea and goal to have, then it is a dead end to bunch all XDP features
> into one. But fortunately, this can easily be addressed.

Do you think that is it still considerable to have a single netdev
flag that means "some" XDP feature support which would activate new
further functionalities?

>
> > That's already five or six more flags, and we can't rule out that we'll
> > need more; so I'm not sure if just defining feature bits for all of the=
m
> > is a good idea.
>
> I think this is an important question. Is extending the netdev
> features flags the right way to go? If not, is there some other
> interface in the kernel that could be used/extended for this? If none
> of these are possible, then we (unfortunately) need a new interface
> and in that case, what should it look like?

Toke, are you thinking about any particular existing interface or a
new specific one?

>
> Thanks for taking a look at this Toke.
>
> > In addition, we should be able to check this in a way so we can reject
> > XDP programs that use features that are not supported. E.g., program
> > uses REDIRECT return code (or helper), but the interface doesn't suppor=
t
> > it? Reject at attach/load time! Or the user attempts to insert an
> > interface into a redirect map, but that interface doesn't implement
> > ndo_xdp_xmit()? Reject the insert! Etc.
> >
> > That last bit can be added later, of course, but we need to make sure w=
e
> > design the support in a way that it is possible to do so...
> >
> > -Toke
> >
> > _______________________________________________
> > Intel-wired-lan mailing list
> > Intel-wired-lan@osuosl.org
> > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
