Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887F6289B4B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbgJIV5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731745AbgJIV5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:57:38 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B101C0613D5
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 14:57:37 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id r10so5771200ilm.11
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 14:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d3jZiyr9WoKZVnHY3puizzn2dA1n20AzK8goZrtNDk0=;
        b=NQp8ch+vq0QVk5jr8IaIlrDGceBGEv0ED80a+JqoRmTm/E0KkMme2XAspo3jv+hIrF
         hfD65tCg9cNaFMGzQvUlkYWbl54jCuPM0DGRk05bK4xXMQf85D9IkgR8mJFTeYnXoaAW
         DMYHMejVDjWnhg/a4fPL3w5nT9QM1+04RAtswwn2yib6oWBzpJ0E8IoT1S4krh9p7rfD
         Amfqj76Nb44jVMYhWzfGjjc7iLYeGqTyyV+MKouRnCyDJmvoYU+f5/u6ZLW9tnpZ+ZDZ
         AW+oj3HhIpWBBNcg38u1yypNxvIeLXeJzxtkj06STDUSEaElvXeTBTv8bVLiDctA+9aX
         zmZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d3jZiyr9WoKZVnHY3puizzn2dA1n20AzK8goZrtNDk0=;
        b=YjxcuqpOc+SghgvTmebChyQehlk0P57YNFFb3c8hBQpH3cfsDBDdLZgFdZIcdm9q/v
         CKduOs5buu1BnpOKxsU7Qu/+H2zZ+e+rLt9szBAklhFfRz8/3QrRoLu6XdL5CZBxgED0
         rDjbZRsBX6yHleMYYJvf1y07R4kP5zUa0Zc7hNX2mr8VNSoYgambXxDAdkqaYiXuUjFY
         aNMaCMFiImE1QpyBFnlDFdQXzMpDzmKofQSY9a5Tpfocor0LEUYLCNaf/Y+m1iTvf3Xi
         6vmN8tWQE/XoI7tSdjW4RPM0VsUjpURROyQOcAbo/50ntlNUr71FrHgOmZWZiErfHnar
         VHjA==
X-Gm-Message-State: AOAM532VTrSuoZnkiQOXq6UCA6R/XX4JJ4/0SsmhozmhB4FACEnggTzX
        RPLrUaMMxYn+wN0Md+8hvN6Pm9rkIt1kRiM/JTl1yw==
X-Google-Smtp-Source: ABdhPJw8Cc45yI69JTyGDKyiPmqzBQvKobeYE8/qVvjyXSljth0INUstPeL7dEkyG8kPV9XFzuT4VQyeCxLsK1YnlLU=
X-Received: by 2002:a92:2003:: with SMTP id j3mr11617725ile.28.1602280655123;
 Fri, 09 Oct 2020 14:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch> <20201009210744.xa55r6sanggqv5ou@ast-mbp>
In-Reply-To: <20201009210744.xa55r6sanggqv5ou@ast-mbp>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 9 Oct 2020 14:57:23 -0700
Message-ID: <CANP3RGeiF2-EXGU8Bnt05zbGGL6cMs9VU0P4tprx3zjN-w75FA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 2:07 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Oct 09, 2020 at 01:49:14PM -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > On Thu, 08 Oct 2020 16:08:57 +0200 Jesper Dangaard Brouer wrote:
> > > > V3: Drop enforcement of MTU in net-core, leave it to drivers
> > >
> > > Sorry for being late to the discussion.
> > >
> > > I absolutely disagree. We had cases in the past where HW would lock up
> > > if it was sent a frame with bad geometry.
> > >
> > > We will not be sprinkling validation checks across the drivers because
> > > some reconfiguration path may occasionally yield a bad packet, or it's
> > > hard to do something right with BPF.
> >
> > This is a driver bug then. As it stands today drivers may get hit with
> > skb with MTU greater than set MTU as best I can tell. Generally I
> > expect drivers use MTU to configure RX buffers not sure how it is going
> > to be used on TX side? Any examples? I just poked around through the
> > driver source to see and seems to confirm its primarily for RX side
> > configuration with some drivers throwing the event down to the firmware
> > for something that I can't see in the code?
> >
> > I'm not suggestiong sprinkling validation checks across the drivers.
> > I'm suggesting if the drivers hang we fix them.
>
> +1
>
> I've seen HW that hangs when certain sizes of the packet.
> Like < 68 byte TX where size is one specific constant.
> I don't think it's a job of the stack or the driver to deal with that.
> It's firmware/hw bug.

+1
It's not the job of the core stack, but it *is* the job of the driver
to deal with firmware/hw bugs like this.
Sure fix in hw when you can (next rev), in fw if you can't (and have
fw, can release it, rev it, distribute it), but ultimately that's why
drivers have quirks for various revisions of hw/fw... so you very much
fix bugs like this in driver if needed.
