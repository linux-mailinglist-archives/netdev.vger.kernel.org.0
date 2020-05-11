Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E301CE906
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgEKXT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKXT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:19:28 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D055DC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:19:27 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id h15so7215085edv.2
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ItTg4twR+xsuKUuAGWWERIN/sxuzJ5FYac7Ah0/5Qjw=;
        b=PiN5VrH7bm8o1BnGp7UE31mmKVHhJKZCjXkbDSt0CWdN6+ayp6f0rknuZhDRir6eUq
         7SPQKavxtHZfxPHo1iGiYi1ExOH2HAs9L8ndBkMT3UvJLpMJUUJwHti2uUMT5jrqQ6LU
         X+LApenUMBmHlnf3H9BDkUSAfeDoaI7vbLTV64O0j/ruMFTLxd4vwwOipPqlKZFozDm7
         FXZABzAYQnTG9pXJYPX8n+/Zi5fG3VzqQqAzZwwndL6ZKWUededYClPzwkEgM0BB+q45
         ww2VwPfb5fsDguwKI0q2duW1VPeHdqN+v/pBUFDQGTblp2m5K/211i1EnGGutBAhw3j1
         vEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ItTg4twR+xsuKUuAGWWERIN/sxuzJ5FYac7Ah0/5Qjw=;
        b=CWpIyARyYjoWn5DdSm92Zb8MHNuKGBdq06xCL5CERJuq0pBn9iMhBS0uFx+ptZOgeD
         HgJyTLHofEdjmQcpD1qpfZvMm0ZNvsdH2gh4HuEhTWsh8Oq6TrEZtVVKTAtylc0E6Zoz
         wvg2aaTPVL0CvE3hMqq91LqR+qUmPnTgioD6e7umt4lSGE3iW9S2zntJiWRU7avWmkHG
         mYt1OGW8OS4CCgz10ANwFAqHeQ/GZt/Xi8Oq2upjbi8gXU7kKcxKCw1/ZDNrrTPwEVlR
         Wc9CeKXlzQPB7spruXKRFR8T60nBiTleOBRQDQD/MnQbM7zlbWCdD/UU0IwJuH1NSQpl
         MlWA==
X-Gm-Message-State: AOAM532gA1tiqEITO9Fh9E9t12BOkffReRTTsfXv+OmK61MLR9KfgpFH
        prvemsMBhko3XGw1j1BrA0D3lZfo0IrWGReo4xc=
X-Google-Smtp-Source: ABdhPJxpDggOShfV/ZfyooDBu3qC8au8FtbMyXnZjSqOjPMNSWVGePB8tTxa9ciwTqiIsXg/XvTUV585BA6Tj8C+P80=
X-Received: by 2002:a05:6402:417:: with SMTP id q23mr1480180edv.139.1589239166580;
 Mon, 11 May 2020 16:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200511202046.20515-4-olteanv@gmail.com> <20200511154019.216d8aa6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+h21hqC=wQmgb_pwaJTdZsj5ceL5fMu1OLKp8wix8M-pPg4tQ@mail.gmail.com> <20200511.161105.2010361750917771255.davem@davemloft.net>
In-Reply-To: <20200511.161105.2010361750917771255.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 May 2020 02:19:15 +0300
Message-ID: <CA+h21hrxjjhNBJfxVKAZ2CO3=6=Mb3Za=8BjKia4k=w=MXtZVg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: dsa: tag_ocelot: use a short prefix on
 both ingress and egress
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 at 02:11, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue, 12 May 2020 01:44:53 +0300
>
> > On Tue, 12 May 2020 at 01:40, Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Mon, 11 May 2020 23:20:45 +0300 Vladimir Oltean wrote:
> >> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >> >
> >> > There are 2 goals that we follow:
> >> >
> >> > - Reduce the header size
> >> > - Make the header size equal between RX and TX
> >>
> >> Getting this from sparse:
> >>
> >> ../net/dsa/tag_ocelot.c:185:17: warning: incorrect type in assignment (different base types)
> >> ../net/dsa/tag_ocelot.c:185:17:    expected unsigned int [usertype]
> >> ../net/dsa/tag_ocelot.c:185:17:    got restricted __be32 [usertype]
> >
> > I hate this warning :(
>
> You hate that endianness bugs are caught automatically? :-)
>

Well, there's no bug here, really, what's annoying is that it's
warning me when a convention is not being followed. It would have been
smarter if it just limited itself to the situations when not following
that convention actually causes a problem.
