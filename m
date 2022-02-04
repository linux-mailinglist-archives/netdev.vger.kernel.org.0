Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D34A916E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355926AbiBDAFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351538AbiBDAFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:05:31 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72AAC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:05:30 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id ee12so8801520edb.8
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WmwrxXmJfJp2Xm282uZcnoq3peG3+GCnu7uCtGUMwOQ=;
        b=Und97KBBIIpAIBXzZJ8N2pw/WHpbRlWiP31DOS4dD3q6nYnJR62O3es0zc/JhUqogb
         09Yvxb/Fbp9uYIb8mS9UXZWOizZSXwiixWeYlMmvclIc0TkCyky9ZD46GyGxQLLNHRwb
         4WphQckUcIIi53weqdkci3nu4qg3179vbgGZAXf42mMc3rlg+WtU797dEuSs84HazhuQ
         ZsMevzJuuRV81cBtl71dad/MIsmneDkJOvukgMpQ0o0Jr41X/y3DncpLhdVmp3nHRrrv
         Hmwi3xkMApR6zP15emxzAho1nPMINQ/tdli9Me5TJOgtyetG2TAvycd0mdlkhqWULPDB
         tmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WmwrxXmJfJp2Xm282uZcnoq3peG3+GCnu7uCtGUMwOQ=;
        b=juEQ2AflrjtWQTVSXekqS5v84y308HwOsynr5CmkEedyyqX3+rKk3NPN6m5v0ayxD6
         S04n8Z4f4Z+dLDtKXTESg/H/vETd6ThNvoQmeUKMazcDR/1THbnVnRUZImCfP4qLHFWT
         ziAU+iTh8UetHy3b0aGk9uGBFy5dgmpMLH+qBrq0p8DpRpwgBgIdcoKkV2xEF7rt2JSy
         TepFEreX7xSkMqnMSdjJ7pOJLN/fF9fvIntE1litKBBD5eGq0pnvRp3wyUBAghtuU64f
         YWYaBKTsriHTtwtzmxQCwyAH8571m9qO5TGvjFhD+XOwvb6zccUQBKkxrx6wNJZIPUe6
         su+g==
X-Gm-Message-State: AOAM5319S0nGypZzGI4GrdhV4nF3qshNjVMHGqc0myA5D6xrBme1f/vL
        HP4gI2Kb5QOdecqAi7wEXHM3IKLLa7JWTQKl8WoPaWFc0FU=
X-Google-Smtp-Source: ABdhPJxpd9iM65yvqqdrO4L8RcDEqGg3u6FwL5RbMSQxOJmDeUFF7hvuKE1FdWKCGILCjSz3KL2pQUIpvE/wrLlV7WE=
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr640920ede.358.1643933129049;
 Thu, 03 Feb 2022 16:05:29 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
 <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
 <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
 <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com>
 <802be507c28b9c1815e6431e604964b79070cd40.camel@gmail.com> <CANn89iLLgF6f6YQkd26OxL0Fy3hUEx2KQ+PBQ7p6w8zRUpaC_w@mail.gmail.com>
In-Reply-To: <CANn89iLLgF6f6YQkd26OxL0Fy3hUEx2KQ+PBQ7p6w8zRUpaC_w@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 3 Feb 2022 16:05:17 -0800
Message-ID: <CAKgT0UcGoqJ5426JrKeOAhdm5izSAB1_9+X_bbB23Ws34PKASA@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 1:42 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Feb 3, 2022 at 1:08 PM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, 2022-02-03 at 11:59 -0800, Eric Dumazet wrote:
> > > On Thu, Feb 3, 2022 at 11:45 AM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > >
> > > > It is the fact that you are adding IPv6 specific code to the
> > > > net/core/skbuff.c block here. Logically speaking if you are adding the
> > > > header in ipv6_gro_receive then it really seems li:ke the logic to
> > > > remove the header really belongs in ipv6_gso_segment. I suppose this
> > > > is an attempt to optimize it though, since normally updates to the
> > > > header are done after segmentation instead of before.
> > >
> > > Right, doing this at the top level means we do the thing once only,
> > > instead of 45 times if the skb has 45 segments.
> >
> > I'm just wondering if there is a way for us to do it in
> > ipv6_gso_segment directly instead though. With this we essentially end
> > up having to free the skb if the segmentation fails anyway since it
> > won't be able to go out on the wire.
> >
>
> Having a HBH jumbo header in place while the current frame is MTU size
> (typically MTU < 9000) would
> violate the specs. A HBH jumbo header presence implies packet length > 64K.

I get that. What I was getting at was that we might be able to process
it in ipv6_gso_segment before we hand it off to either TCP or UDP gso
handlers to segment.

The general idea being we keep the IPv6 specific bits in the IPv6
specific code instead of having the skb_segment function now have to
understand IPv6 packets. So what we would end up doing is having to do
an skb_cow to replace the skb->head if any clones might be holding on
it, and then just chop off the HBH jumbo header before we start the
segmenting.

The risk would be that we waste cycles removing the HBH header for a
frame that is going to fail, but I am not sure how likely a scenario
that is or if we need to optimize for that.
