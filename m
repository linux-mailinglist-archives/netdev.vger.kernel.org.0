Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F4A301D72
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 17:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbhAXQT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 11:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbhAXQTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 11:19:19 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F975C06174A;
        Sun, 24 Jan 2021 08:18:39 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id j13so12343590edp.2;
        Sun, 24 Jan 2021 08:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zb7AHSDTF7LHXpiz7qIXIzHJsP6596iVekrvyL2shdw=;
        b=rGDW+Ljkl9+zWfpWsNO2e5UbHj1bGiF3rqSNb15Sc8Fm3PUyQbhcLseDLRlWaCKhkG
         ky46GfcF1ynouUdcts9uxIiUtE/ytR87mtjYeu/WecU3Z+aqcXK10+LG7UVp2tUTpPSI
         RCXduciokuOqOrBLotaKTom3Sj1xWiQqf2APfvtC9suFkcU8qb1uHw2Uq/Kpq4rEsh+5
         9czuzCX5lEukFx6v3r/SzIqBBt83/ULzjlQPZ26WvqMP8HkCxrhKpA4svBsGzpZG4cJv
         5WaWzyl+oZnXOVMqd812U6mka+jL9fTLLRqXu/WERk2vbI15KgvCE0WN/KVHGmRz/U6W
         FIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zb7AHSDTF7LHXpiz7qIXIzHJsP6596iVekrvyL2shdw=;
        b=qKSph+2oFNc4Ot2KNbPfEhBZciBeAgR65H88lCSRj3yAj+SJ7RMAyQENLRz1XLA5MQ
         nXjHWyHZheKZNKBhoT7z49JJkWTbZs5wzOiHuo1ERF9lgu+QGwSahDc8+W5jd3iQdqJv
         9p3+5rRPc3js7ou+SUoOWObHFPRYQT/fL7fdKZtUG/UGRNSnnvKmhkAuxF+f069SkXIX
         IQ4XbgZDJBT0r5FBvkQVG/Ublvq7k0Loi59Hd7Dco/tq7GuPp/15L+TdoSQcJWYIAdGe
         Vk8PDWkpjlYsQB7RTPNU99BtsR6LKezQNNxl7ro+EiA/kvG8qxeVEhyZQHg3GyrwZS0v
         G8cA==
X-Gm-Message-State: AOAM532jMyQsWxCvElFcJ8VyYPpTp+uRr9MLpcT7QdkQT8fIcikSMCpF
        Z0kLkVo0LI2AHCvyDmAZo4WsrWpu0726yMjyq5U=
X-Google-Smtp-Source: ABdhPJyqOhhtmCwn50qEES+kiwL+UDu11uBR76NW5BCmliggDWbn5T31wd981/uxNgqQ+tvE6mlL0z4AODX5xgdM2a4=
X-Received: by 2002:a50:eb81:: with SMTP id y1mr444071edr.176.1611505118175;
 Sun, 24 Jan 2021 08:18:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611304190.git.lukas@wunner.de> <012e6863d0103d8dda1932d56427d1b5ba2b9619.1611304190.git.lukas@wunner.de>
 <CA+FuTSfuLfh3H45HnvtJPocxj+E7maGwzkgYsfktna2+cJi9zQ@mail.gmail.com> <20210124111432.GC1056@wunner.de>
In-Reply-To: <20210124111432.GC1056@wunner.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 24 Jan 2021 11:18:00 -0500
Message-ID: <CAF=yD-+BXKynYaYgg8n_R1gEtEbkRWm-8WdtrXOjdjyOj-unfg@mail.gmail.com>
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

On Sun, Jan 24, 2021 at 6:14 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> On Fri, Jan 22, 2021 at 11:13:19AM -0500, Willem de Bruijn wrote:
> > On Fri, Jan 22, 2021 at 4:44 AM Lukas Wunner <lukas@wunner.de> wrote:
> > > Add egress hook for AF_PACKET sockets that have the PACKET_QDISC_BYPASS
> > > socket option set to on, which allows packets to escape without being
> > > filtered in the egress path.
> > >
> > > This patch only updates the AF_PACKET path, it does not update
> > > dev_direct_xmit() so the XDP infrastructure has a chance to bypass
> > > Netfilter.
> >
> > Isn't the point of PACKET_QDISC_BYPASS to skip steps like this?
>
> I suppose PACKET_QDISC_BYPASS "was introduced to bypass qdisc,
> not to bypass everything."
>
> (The quote is taken from this message by Eric Dumazet:
> https://lore.kernel.org/netfilter-devel/a9006cf7-f4ba-81b1-fca1-fd2e97939fdc@gmail.com/
> )

I see. I don't understand the value of a short-cut fast path if we
start chipping away at its characteristic feature.

It also bypasses sch_handle_egress and packet sockets. This new
feature seems broadly similar to the first?
