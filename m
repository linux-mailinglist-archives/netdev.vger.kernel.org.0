Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FF71646C0
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 15:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgBSOTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 09:19:09 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40122 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgBSOTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 09:19:08 -0500
Received: by mail-ed1-f65.google.com with SMTP id p3so29306903edx.7
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 06:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f3y7S9SB6CCbxSqfCpOomRGrdvVW8/NginhXNb/fJJA=;
        b=jyMG7GyPneMJq/k+r3j3O9OMwsZsUsNJNW5Sb0qqXXGgMgIml/g33Ebw1lR76L/vgR
         LIorBfErWDvykiPsH3liiy2sKAHWs5aN37I+f2CYani164ikCYa2iCAbCcLrV30k/gUm
         ZLMoib1G/CHcympJ9a2+EWLg6RGqwEH9h6Wm7se+AYgJ4nxwrSVpgg5EKjfEVCvk92bC
         Tvn9s5hWgbKkrFPI7U4sgVG6wWJKXjF4dNoZco8KvrvkD/+04hke8+SUBguU2Y0yPnOg
         UMM8XVT7BpxmFvdmav3HLZDMkxo1QpC2Rv2LqNVg6FceOE0EwDRVXw7GVjD3T1PvHnYB
         Br7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f3y7S9SB6CCbxSqfCpOomRGrdvVW8/NginhXNb/fJJA=;
        b=feRFsaXBIW2tTIe/p9HvTXWsiRBbdOpH/EWAmYKq9893Au4+D3zUfGrcaCgImz+9cW
         0gVPUYrfyA8jG4zbNnX1+tTRV5xtnt+vHDbjL5U+jueV5i0XRiZxsEMxuuHohlCqFVaq
         reS2epeGkAlioGVsfrgEbPXQWSDAs7CkQdeGergLCRlNITjX/nce4X/6ADhw8bfVJEss
         sRYLruR8Ji2AOW7R+pSzeiMziEWNkVpCYvp6hI+0yeOSg3HraPSbr8PWVK48jo0OhCiJ
         GIHrkheghWd6PuvtRs9s0rmhDBhBU/X9mTTKbqRgtOzp5B2UQgwtenynlioL7Agh43dS
         lMkQ==
X-Gm-Message-State: APjAAAWeyZYD31Em5Vimu+EBoUBbVB/m2chciX21H27ASzLxFo3XniDE
        a5Igj/+l4zcPM19o5GnB7YSGiXEcVSzYkMsLJvE=
X-Google-Smtp-Source: APXvYqzgDzocpjvBsDS4EFclZwQ1dUX/Ze/TA+DAxmbRu7JrZLQ9VkvRk+U12Z4j3JR782Zo5vrA6w1WT7+DlAySttk=
X-Received: by 2002:a17:907:2636:: with SMTP id aq22mr8971691ejc.176.1582121947368;
 Wed, 19 Feb 2020 06:19:07 -0800 (PST)
MIME-Version: 1.0
References: <20200217150058.5586-1-olteanv@gmail.com> <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
 <20200218134850.yor4rs72b6cjfddz@lx-anielsen.microsemi.net>
 <CA+h21hpj+ARUZN5kkiponTCN_W1xaNDTpNB4u4xdiAGP5QqmfA@mail.gmail.com> <20200219101149.dq7jwhs6aypv43kf@lx-anielsen.microsemi.net>
In-Reply-To: <20200219101149.dq7jwhs6aypv43kf@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 19 Feb 2020 16:18:55 +0200
Message-ID: <CA+h21hpVSzNhYayzF4hfaPiVzLEsxaWPPCrCWhsureRw977jPA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 at 12:11, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> If
> you are certain this is what you want for Felix then lets try find a way
> to make it happend for Felix without chancing the behaivural for Ocelot.
>

I really think this is not the way to go.
As I've explained, you already have the code path in your driver that
I want Felix to operate in.
You just need to put your front-panel port in a bridge, and then
remove it from the bridge. That's it. Whatever your switch does in
that mode, I would like Felix to do it at probe time too. Chances are
that it doesn't bother you, otherwise that code would have been
removed already.

>
> /Allan
>

Thanks,
-Vladimir
