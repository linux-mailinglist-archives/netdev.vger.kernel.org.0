Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6CB3137BF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhBHPab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbhBHP1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:27:45 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EEFC06178B
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 07:27:05 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id k10so12139040otl.2
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 07:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t9HL/7RQHQPjh8ZrDL9l34X8Zw99bskTLK9PQpmiv9w=;
        b=TLX5JCxehS0e/ZL5QU7nGeK4l+fXHceAOdwK11r3Y5kqQGbZPsT2beM/4oKDjq5+fW
         6+LR7HN4cdV+SsbhWo9hGCm4c9oowZUxeUrQ3LDwyDnw44eoro8jDPRggA4S5E0MGC4A
         l8qYud9++4EgAMZjBdQbBceoEQKm9OBA1Nj4qMtrItI09EuPKWXxbrKom/ZPd1zHwe/k
         uDFZ13A5Lm0T5/ubva+5kBuY1dM05WoqCA2dc6YluPCaiUFxCZs8+/GA8IewoN+tTOY3
         MCiAL/nSv8ZNRY4FQFZsuED1AcG5binH/9PHPelaR5GNzgG8sFlClNt0n65QdH/JBWpB
         msHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t9HL/7RQHQPjh8ZrDL9l34X8Zw99bskTLK9PQpmiv9w=;
        b=bUalFJT8Ka4IpEg75+3YcKhwU3Vc7cd+SIEx1gVnSB1crMpLIPSrqLQ50n4eEOf9BX
         GS65lvfecZ8s4HC1R21bVH+hzL+LuFGD0exyqQI5/EOddQ+NvUz0hKxOJlIzMrqRvYiz
         A315yL2g9WTdjlh/qjlHuSk9te3OANiKmHQy5lLBJsJ6It5IU0ri1MIGvTBhyGooMHur
         Ls+9zmTi5xQsXbbb/2rpUrVRuvdSJiF0/85ZLf70qwXLoUcd/xambSQuGPvltI3cCKS0
         B344ozchBSrfRwRhCxHu/+pw+Aas0jxYTAs46QFnX47PodOSmocufHk2MBKk7eQxCQoP
         jx/w==
X-Gm-Message-State: AOAM531pOyXT0Ue+ui9NevKba2G0u8x+XsEnTJpDxqA0b5/qW1k7VTH9
        OzsO76jPFw9PsfJwGahvJf5cxF1yvhjlR6oqzQ==
X-Google-Smtp-Source: ABdhPJxE37B9A0JQhqFKgtVQ9LPomY0tdtgea9dU4EI0ZkrWBCOIAv3NFUz/S1VW7V1MitsT4pEzi44S7ntp97X3CGc=
X-Received: by 2002:a9d:e82:: with SMTP id 2mr13078755otj.287.1612798023318;
 Mon, 08 Feb 2021 07:27:03 -0800 (PST)
MIME-Version: 1.0
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-2-george.mccollister@gmail.com> <20210201145943.ajxecwnhsjslr2uf@skbuf>
 <CAFSKS=OR6dXWXdRTmYToH7NAnf6EiXsVbV_CpNkVr-z69vUz-g@mail.gmail.com>
 <20210202003729.oh224wtpqm6bcse3@skbuf> <CAFSKS=MhuJtuXGDQHU_5w+AVf9DqdNh=zioJoZOuOYF5Jat-eQ@mail.gmail.com>
 <20210206234324.wk676psq3mwslud4@skbuf>
In-Reply-To: <20210206234324.wk676psq3mwslud4@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 8 Feb 2021 09:26:51 -0600
Message-ID: <CAFSKS=MVcQq3812us46HW2sK4uYoWxUbTvEDwH3dMF5b6bvohw@mail.gmail.com>
Subject: Re: [RESEND PATCH net-next 1/4] net: hsr: generate supervision frame
 without HSR tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 5:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Feb 02, 2021 at 08:49:25AM -0600, George McCollister wrote:
> > > > > Why is it such a big deal if supervision frames have HSR/PRP tag =
or not?
> > > >
> > > > Because if the switch does automatic HSR/PRP tag insertion it will =
end
> > > > up in there twice. You simply can't send anything with an HSR/PRP t=
ag
> > > > if this is offloaded.
> > >
> > > When exactly will your hardware push a second HSR tag when the incomi=
ng
> > > packet already contains one? Obviously for tagged packets coming from
> > > the ring it should not do that. It must be treating the CPU port spec=
ial
> > > somehow, but I don't understand how.
> >
> > From the datasheet I linked before:
> > "At input the HSR tag is always removed if the port is in HSR mode. At
> > output a HSR tag is added if the output port is in HSR mode."
> > I don't see a great description of what happens internally when it's
> > forwarding from one redundant port to the other when in HSR (not PRP)
> > but perhaps it strips off the tag information, saves it and reapplies
> > it as it's going out? The redundant ports are in HSR mode, the CPU
> > facing port is not. Anyway I can tell you from using it, it does add a
> > second HSR tag if the CPU port sends a frame with one and the frames
> > going between the ring redundancy ports are forwarded with their
> > single tag.
>
> So if I understand correctly, the CPU port is configured as an interlink
> port, which according to the standard can operate in 3 modes:
> 1) HSR-SAN: the traffic on the interlink is not HSR, not PRP
> 2) HSR-PRP: the traffic on the interlink is PRP-tagged as =E2=80=9CA=E2=
=80=9D or =E2=80=9CB=E2=80=9D
> 3) HSR-HSR the traffic on the interlink is HSR-tagged.
>
> What you are saying is equivalent to the CPU port being configured for a
> HSR-SAN interlink. If the CPU port was configured as HSR-HSR interlink,
> this change would have not been necessary.
>
> However 6.7 Allowed Port Modes of the XRS7000 datasheet you shared says:
>
> | Not every port of XRS is allowed to be configured in every mode, Table
> | 25 lists the allowed modes for each port.
>
> That table basically says that while any port can operate as a 'non-HSR,
> non-PRP' interlink, only port 3 of the XRS7004 can operate as an HSR
> interlink. So it is more practical to you to leave the CPU port as a
> normal interlink and leave the switch push the tags.

If one were to set "HSR/PRP enabled" and "Port is HSR/PRP interlink
port" in HSR_CFG on the CPU port it wouldn't be possible (per the
datasheet) to enable the management or PTP timer trailer. Those modes
are intended for interlinking with a second HSR/PRP switch's
interlink. I was trying to keep this commit message somewhat switch
model agnostic and not dive into the details of the XRS7000 series. Do
you think I should describe all of this in detail in this commit
message?

-George
