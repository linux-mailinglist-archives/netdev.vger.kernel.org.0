Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C303033EF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbhAZFJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbhAYN0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:26:14 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD3DC06174A
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 05:25:15 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id m22so17707784lfg.5
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 05:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L3XVlCmEvFUUK4TdCen7gzk/JsV1RDgOScAX/Jsq6gk=;
        b=e0cuny2GH9PczbzQrVAAAO+Kh29HZcyZgcXm9RWzWkv95XwAo52+AbntS4df72RPJP
         pALBAog13AD111F7T2EJOwd+op45bIwZI86NiaST93l6bAeZ+Lg4VUxk2I+iSQod65lA
         cz3CIkFyWk3z9qlyE07YrqlZH1iWCuTLiVwlHUnM1/AVxN8mbgVZtWAJO6lA5/2RhMUx
         7/KaPv7FPAeXb3gOKiqDYtHH6ANc92I2lbWNKzFhyVSoSfjy8ERmBaRn/ODs/DOuUcT5
         MkPzMmgTvZ1DN6Uv0zRZjBjKrJ6bg62w9UoEcDKpBWMLVEz/jkP9guyYlBI5BOQ+e2Ox
         DR8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L3XVlCmEvFUUK4TdCen7gzk/JsV1RDgOScAX/Jsq6gk=;
        b=Q4JKxwIntaMSlR7THP7NmzKldmxGDYgq5dbiq9BeaZhVwjlJ7EhXMTBask9wJiYpI9
         ha0y4MpGUzKeIQwKhl1uSjd8OyizKAVYg+P9tflg1YJaQRzmropQQqWgrvhL2NYxo4Ry
         EtKt8DT/dOL+9XcJ/r2j2J3fuCkXj71ZofbNdgGmfBKxSTaiUhQzbJCOpPKYJ9LWljg4
         iqoaimGDcrvnrt5tt8dN5TVWuC/R2RLyKP1n8r6e0kcobmXj6Ko3xqnyd0ujCXsQYp/T
         kX6PfgXJgjfNkSMaQ8az8JHMtIhLojW3mmP64Q31C4vdg68OOoj30WFZLNyPcd+7Wmcy
         xO/A==
X-Gm-Message-State: AOAM5323ItNXRV7x1PoHJvLdSdrybz/QfKCoQzjDN0sHylphLrfKEN66
        Amo6CkmX2JvGD78qPkgMj2YU4N4/KSL8UlPNaxzgsQ==
X-Google-Smtp-Source: ABdhPJy/mNjzVis7rlMla5hcgPSEs42xQlQ3FK6FdC6cUAFeXj6cNtnnXjl6Xwyjw+ik5CHkTfXDCNxeVfiNmcI3EzU=
X-Received: by 2002:a19:495d:: with SMTP id l29mr252466lfj.465.1611581114148;
 Mon, 25 Jan 2021 05:25:14 -0800 (PST)
MIME-Version: 1.0
References: <20210120063019.1989081-1-paweldembicki@gmail.com>
 <20210121224505.nwfipzncw2h5d3rw@skbuf> <CACRpkdb4n5g6vtZ7sHyPXGJXDYAm=kPPrc9TE6+zjCPB+aQsgw@mail.gmail.com>
 <20210124234509.c4wkoauiqchv4aan@skbuf>
In-Reply-To: <20210124234509.c4wkoauiqchv4aan@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 25 Jan 2021 14:25:02 +0100
Message-ID: <CACRpkdYi9dZjj8A9=sUJPDCvm9ajDVVAZzW5+hmH8Oux-dpixQ@mail.gmail.com>
Subject: Re: [PATCH] dsa: vsc73xx: add support for vlan filtering
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 12:45 AM Vladimir Oltean <olteanv@gmail.com> wrote:

> Anyhow, you did not approve or disprove the tag_8021q idea.

I just don't understand it well enough so I didn't know what to
say about that...

> With VLAN trunking on the CPU port, how would per-port traffic be
> managed? Would it be compatible with hardware-accelerated bridging
> (which this driver still does not support)?

I think in vendor code it is done like it is done on the RTL8366RB:
one VLAN per port, so the filtering inside the switch isolate the ports
by assigning them one VLAN each and the PTAG of the packets
make sure they can only reach the desired port.

(+/- my half-assed knowledge of how VLAN actually works,  one
day I think I understand it, next day I don't understand it anymore)

Yours,
Linus Walleij
