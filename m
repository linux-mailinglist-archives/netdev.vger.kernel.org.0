Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61CE613F3FF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389147AbgAPSqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:46:43 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46834 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390111AbgAPSqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:46:42 -0500
Received: by mail-ed1-f66.google.com with SMTP id m8so19860725edi.13
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MpgDSjN1hru1swQnDhilNNSgICrtREzkuBPYk3ZlLc=;
        b=XW5bzVPFidoKJ+nZuvZll3aqCPRmO7YUk14LTJRAUxHAwhx30Q1+eEb1BObbP2Ja32
         WoFXLoSh2uONha2QtTBRqXSGhgo3RuPwBnwCiDDnUmbnQcc9I3whA28XiAmlpeyoCy0B
         2m8Uvx4mHfK939eWVwxxz37xqlYVKRlJZokdGEKjh27qdlTLMVI4HGB/3zoJhZLvxN7C
         /aKEmoJdJYsR2icfCWvxqQ10LwkDtu6NsYm2QEjn36lDfUSjKrEDzQVQzTQfRnYllHWR
         HgZJlHPRGQzf6mPb+wrZ2Vig8+l99JIRlGgC+zr6E7HnRqxFfRmOs5jylsQSdIEZctTF
         gd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MpgDSjN1hru1swQnDhilNNSgICrtREzkuBPYk3ZlLc=;
        b=K0ZKWBORXLWBHBPsLiMLB8Iu7QQz8qcNJI9m0jieopzhdwvBzwqVOobi+M4VoTJJnG
         Hb2rCPprLVkVZhPP5nMUWeCCl1pZ00DCm703XuqUOGGToApTCj5+zyVpmOS//hbj1urv
         f19mfosDq33ixm7ijK+mEkEWvuztOMpd5ndDuwynTWGq4Z4mP9E8JQs1NT4Qw+mED3Sq
         XnxZLuaJ43YgGSD/v8y8TI5idgcY8jHT/oB365zNx7EiEdTk0nClxLwVaq3MyKwW0n20
         EvOj6Qs3WTQfEaAAkTxuEYpZWYwFtCuBqqwA0phMfaKDNFEhcDuq1y6WOngLLM+jrv8L
         KgQw==
X-Gm-Message-State: APjAAAUED5QNtSG0OJDid+mzpcZKesh0l6Im1LITi+8TsvrE1AOwrI+g
        JgxEgnOH3q3n7ITPssc6EonE+GBhNfLz37DZpuU=
X-Google-Smtp-Source: APXvYqzmA5yMaBsoPcyu3el0apxbTQ13eYgXwDSsM8V8aZGLPBEOL9SjY+v2O8JWrkWMB1VMoqRRKK55VAqrn+HQftA=
X-Received: by 2002:a17:906:1e48:: with SMTP id i8mr4129667ejj.189.1579200400499;
 Thu, 16 Jan 2020 10:46:40 -0800 (PST)
MIME-Version: 1.0
References: <20200116183635.4759-1-olteanv@gmail.com> <16c5ec6f-fae7-6a51-1814-dbd939c32ac0@gmail.com>
In-Reply-To: <16c5ec6f-fae7-6a51-1814-dbd939c32ac0@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 16 Jan 2020 20:46:29 +0200
Message-ID: <CA+h21hr0ZcvyVQ7RH61pDXi=rx08YwRXkoc+n5eG5MmrCNO5pA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: Don't error out on disabled ports
 with no phy-mode
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jan 2020 at 20:38, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 1/16/20 10:36 AM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The sja1105_parse_ports_node function was tested only on device trees
> > where all ports were enabled. Fix this check so that the driver
> > continues to probe only with the ports where status is not "disabled",
> > as expected.
> >
> > Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> > index 784e6b8166a0..b27ef01b9445 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_main.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> > @@ -580,6 +580,9 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
> >               u32 index;
> >               int err;
> >
> > +             if (!of_device_is_available(child))
> > +                     continue;
>
> This works, or you can use for_each_available_child_of_node()?
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

Thanks Florian. I've sent out a v2. I would have linked to v2 in
patchwork here but it looks like it's down.

-Vladimir
