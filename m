Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CA53096FB
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 18:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhA3Q72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhA3Q7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 11:59:23 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB16C061574;
        Sat, 30 Jan 2021 08:58:43 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id kg20so17716711ejc.4;
        Sat, 30 Jan 2021 08:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MfMoVHfO0rKFbhfuJqWumZvD8HUvpL3L63SSmxfbwGE=;
        b=flwI+HsFKGSV5iuOD0P8U87awp5SFYN2AIddH3KhseiIuQ2ZEy5fphqGzUlAgbxM2T
         UGDy+uAZDBze0HxWviIXWsDJFJGkTHB9oliiJxyuOo/8lrDb1lqbWhGa4EB8rlVWUBsf
         tRcNaVEbsf0ROlZ5frgnMhN0bsDmgokhg+tPmvixnut9ImWdBDz1KkJpOQqWprzEv7ND
         OXQLY/amon8mzpJKlub8n2C3DESvuBHA7rYDGPnwGABwylqIBQtgomaKO6LnOZA+OLjo
         dwGHMwpKBzDNAAPpYFbP0+B6P3iiRivz5mO9lN45lXb786c0DM1ojYe3GnZb9z+FA5wF
         Xbog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MfMoVHfO0rKFbhfuJqWumZvD8HUvpL3L63SSmxfbwGE=;
        b=qEFDKgtmkW2t9mUu8HrTAUZwE4QKZyW/hFdUeRLlaGx2P06bejg9R+3CRLtDYX76WS
         +qsQG8wwu45UcWTfcsUICs9Jff8sYSk5HAtQCI54qLrXPpm9vsj7ifWHsegrVncuRhdM
         sHBcZuaOCHE+H9X0VxJKJgXjVpziH7aVbt1N5He7jjCndIql264hLu/rOGHTuFD+PAMI
         PPW4TctUqkwX40PSTZIN5YXBl9SwSaRYjH8SFQEU0HtoOqVDxTYnGlCUFouOVgDxaSS9
         XX5iQswKJnJtgLivQdU+riuUheUglo+qV5HE541+epR6muCij4jXJxQh4kY1VS5zTMxY
         /5BA==
X-Gm-Message-State: AOAM5321gSZY8oXZIi0jieicv2oEDbJHPiNcvgmXF2F+Q3wlaGhn7zHV
        ocxpaGXB9AG/Y45JbQ5yCTLxrMa64mG7v6PLP5Y=
X-Google-Smtp-Source: ABdhPJy9J/183fvbfFId3I+LBl0H16qDITdUI/9L8kRbTPDNNgl0r10bGcSujpaiA0OMYph1PkRcqpBD9oXafNPV0Bw=
X-Received: by 2002:a17:906:7698:: with SMTP id o24mr2170840ejm.504.1612025921810;
 Sat, 30 Jan 2021 08:58:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611304190.git.lukas@wunner.de> <012e6863d0103d8dda1932d56427d1b5ba2b9619.1611304190.git.lukas@wunner.de>
 <CA+FuTSfuLfh3H45HnvtJPocxj+E7maGwzkgYsfktna2+cJi9zQ@mail.gmail.com>
 <20210124111432.GC1056@wunner.de> <CAF=yD-+BXKynYaYgg8n_R1gEtEbkRWm-8WdtrXOjdjyOj-unfg@mail.gmail.com>
 <20210130162629.GB1959@wunner.de>
In-Reply-To: <20210130162629.GB1959@wunner.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 30 Jan 2021 11:58:06 -0500
Message-ID: <CAF=yD-+W_RxnmLvYugL0TkgwYM4S3392wNu_=FddujeYx7+gUA@mail.gmail.com>
Subject: Re: [PATCH nf-next v4 5/5] af_packet: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 11:26 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> On Sun, Jan 24, 2021 at 11:18:00AM -0500, Willem de Bruijn wrote:
> > On Sun, Jan 24, 2021 at 6:14 AM Lukas Wunner <lukas@wunner.de> wrote:
> > > On Fri, Jan 22, 2021 at 11:13:19AM -0500, Willem de Bruijn wrote:
> > > > On Fri, Jan 22, 2021 at 4:44 AM Lukas Wunner <lukas@wunner.de> wrote:
> > > > > Add egress hook for AF_PACKET sockets that have the PACKET_QDISC_BYPASS
> > > > > socket option set to on, which allows packets to escape without being
> > > > > filtered in the egress path.
> > > > >
> > > > > This patch only updates the AF_PACKET path, it does not update
> > > > > dev_direct_xmit() so the XDP infrastructure has a chance to bypass
> > > > > Netfilter.
> > > >
> > > > Isn't the point of PACKET_QDISC_BYPASS to skip steps like this?
> > >
> > > I suppose PACKET_QDISC_BYPASS "was introduced to bypass qdisc,
> > > not to bypass everything."
> > >
> > > (The quote is taken from this message by Eric Dumazet:
> > > https://lore.kernel.org/netfilter-devel/a9006cf7-f4ba-81b1-fca1-fd2e97939fdc@gmail.com/
> > > )
> >
> > I see. I don't understand the value of a short-cut fast path if we
> > start chipping away at its characteristic feature.
>
> The point is to filter traffic coming in through af_packet.
> Exempting PACKET_QDISC_BYPASS from filtering would open up a
> trivial security hole.

Sure. But that argument is no different for TC_EGRESS.

That's why packet sockets require CAP_NET_RAW. It is perhaps
unfortunately that it is ns_capable instead of capable. But there is
nothing netfilter specific about this.
