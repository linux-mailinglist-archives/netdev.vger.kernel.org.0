Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2419E618
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 17:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgDDPem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 11:34:42 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46223 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgDDPem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 11:34:42 -0400
Received: by mail-ot1-f67.google.com with SMTP id 111so10537805oth.13;
        Sat, 04 Apr 2020 08:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wJJHt0CSx4rCuEsqr8ESfPqtz2SvcHs+oQjfrjV6kEc=;
        b=rvWQiF5F8bJnmlWbMT7R49NetVKvTAdp4EJoY3L86knHIuMiThiWt9GN38kOhTFKJh
         R/puK9Sr3rH99oncCgmc1eK4NIkt+fy8pJp82Uj0vAMSBEQnbAGzU5HSBYLjcU31y0Hq
         4yaatE2LPEJ5lgaSEd+1NuCPVvtORn+cSTnedW8fICKr4mMw9NT+KjMSLPPB7sN4dlZC
         dLsMVRtTOT7xshyqN4Uaiqm3NnxvOoKvRkQmkMqQn3LongPZHMloOdNa73uECn/jAC9x
         dkVQTIIDejHXp9ieN+gkTLpU7d54CHS/0Ks69XfSwNU+pS+nL+vefjtCj7Al4RwaRHRj
         jSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wJJHt0CSx4rCuEsqr8ESfPqtz2SvcHs+oQjfrjV6kEc=;
        b=qvrzP2zJZuma8eBENfjixEQZSgXoh9tiuwNs/hnBp+0tx/iQaepfGS0CvDBcBP2TjF
         klgYZmoAnbliOaWJEg//04Eij7dhyIEdEIzNvy9I2ulwk31K3+JjOZBs7AtE7Nx1Fl+C
         vDa0oH8/Ztu78FpsG0GEQH6of2bJbjZ0fJeynaMWqP6qYphGiMNl/mFPjFwvQRW8rn3u
         yaQLmy2e4CcJxq/lJf56PNb/MoNjS3Zc2r6stsvjFJefUNW3t+XBqyZXVc7e74iAQAmf
         wnYbeHpcwP3kNpNrzi8f0ErQVNM9J8aKmzT3fPOVK1vWxY2SoksV3pJ+m+4Mprv+dQGt
         vUKQ==
X-Gm-Message-State: AGi0PuYGM1M4Kc6mqRFnjd239hP2meLsH+7zGofk7MrZ0ZA9uW4GNVHc
        f5TLcb1UH2xlqa9qR634WDeK+Q6l8W0WKeMTZqY=
X-Google-Smtp-Source: APiQypJurN6kKeueDqM6o5vZ2pCFzzx2u9sVqqily6xPz9KLmAwCuSMsRcuswvGToxGksPlnBUBs6hgZxPamk8aeaiQ=
X-Received: by 2002:a9d:7a45:: with SMTP id z5mr10438979otm.181.1586014481828;
 Sat, 04 Apr 2020 08:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200403112830.505720-1-gch981213@gmail.com> <20200403180911.Horde.9xqnJvjcRDe-ttshlJbG6WE@www.vdorst.com>
 <CAJsYDVJj1JajVxeGifaOprXYstG-gC_OYwd5LrALUY_4BdtR3A@mail.gmail.com> <20200404150810.GA161768@lunn.ch>
In-Reply-To: <20200404150810.GA161768@lunn.ch>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Sat, 4 Apr 2020 23:34:30 +0800
Message-ID: <CAJsYDV+NY90r=PV0dYRRaTEuxQAMTbakLvguX-1jOu3OQwYfSQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mt7530: fix null pointer dereferencing in port5 setup
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Sat, Apr 4, 2020 at 11:08 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > MT7530 tries to detect if 2nd GMAC is using a phy with phy-address 0 or 4.
> >
> > What if the 2nd GMAC connects to an external PHY on address 0 on a
> > different mdio-bus?
>
> In general, you using a phy-handle to cover such a situation. If there
> is a phy-handle, just use it.

If it's determining where switch mac5 is wired, a phy-handle is fine.
Here we are determining where exposed rgmii2 pins are wired.
It can be wired to switch mac5 or skip the switch mac completely
and connected to phy0/phy4.
Current driver is determining rgmii2 wiring on mt7530 using phy-handle
on *another unrelated ethernet node* which doesn't sound right.

-- 
Regards,
Chuanhong Guo
