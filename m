Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D71BF90DA
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfKLNle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:41:34 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46262 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfKLNld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:41:33 -0500
Received: by mail-ed1-f68.google.com with SMTP id x11so14907530eds.13
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 05:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sXgW0jx5yGW44bwsmo+2CWaYrX0xe/7Zhr7EheJ3VYQ=;
        b=ABuH02is6TaJO0Rth2TprgRWq4WuNCgidoc+SqIVgDNR3fpR4PWKIJi5Ul9MoUID+5
         x8cVHIgFFqEuCtoWlXdKK7qoRPV+TUoHWpb8Z1+dlvCNzj9VjF9O6WeUA5bSLGrlj/j9
         yY3U2jECY3IFbFbjyodcZystZPS6WWP3egVDHM3olXHAYBF83+7ocWj5Vc2XDnlBiSzm
         sUo2YhqBWgcHSHgqrToS3SVmfO2DwHeb8anQB8xUmLrstJj0HtSQgQXIdRuL1qGY8aFm
         jDQyMBGu5xoGqoxP1Bk78nrejQDxjPvtZK091nBuS0U86XhZyo/5J7STB4nbc3NGZXjw
         UwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sXgW0jx5yGW44bwsmo+2CWaYrX0xe/7Zhr7EheJ3VYQ=;
        b=IB0MhLyojnkcyOo4Od/BwSSBLBJL+CJh6HYcE46JLLktKkrLEjttQokdR1OkYTISaX
         21eef7wSaeyn6Dn+/JpAjwHeWmFmEcBeAninyrn9wrkT0yuPTR27QpdRoENwYF9V04M3
         5egZLmgXTp9bDRrYvYwdKlNnbUgyYI8HVgVAzOQ08Q2NY5jSQrdXL6Eb2vQNfloZy/cJ
         m2h/30MFnELQCjlxcqWcyhWCsOwsyB3Yl42Crw0d6myLA1Ba+qwE8XtPuQRvh4JtH/7/
         aOzo2NODY1F7fym7URImBUtVHxEJxAcOP5OzGaRepKoLGELBZEw3+vmf58WF80gap4wp
         WrPA==
X-Gm-Message-State: APjAAAXwSjlKT3HfdUdRWH0NvG1q1H0dJyBm2pGm3TTpnAkeCoUY3qe+
        wsCWaDLxMI9RJhsvTySJTP1s0AwLM7DR8c84E6M=
X-Google-Smtp-Source: APXvYqwaMK+Ua6a+Qkm/oiT7b/rImDxWLOsS8ly4OIHUEAWEN3vZseTEpQTmVDtKDQCH6u62YIPZw5cLBK4QtrFIWYg=
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr28250062ejq.133.1573566091938;
 Tue, 12 Nov 2019 05:41:31 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-5-olteanv@gmail.com>
 <20191112133959.GF5090@lunn.ch>
In-Reply-To: <20191112133959.GF5090@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 15:41:20 +0200
Message-ID: <CA+h21hoxjeqZzdg1KLKB3Yp39zEz7Q0BZ5bNXocEnsreczpL_w@mail.gmail.com>
Subject: Re: [PATCH net-next 04/12] net: mscc: ocelot: create a helper for
 changing the port MTU
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 15:40, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Nov 12, 2019 at 02:44:12PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Since in an NPI/DSA setup, not all ports will have the same MTU
>
> By this, do you mean that the CPU port needs a bigger MTU because of
> the extra header?

Yes, see the next patch.

>
>     Andrew
