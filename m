Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096B71999F3
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 17:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgCaPk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 11:40:28 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38327 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730413AbgCaPk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 11:40:27 -0400
Received: by mail-ed1-f67.google.com with SMTP id e5so25667078edq.5;
        Tue, 31 Mar 2020 08:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxOzUkSFr6Wk07X0rWnPtJzVLAiDlRwjY44J+SEwVCw=;
        b=npxLREbo59UnWM8carwNx0WfN7TP3zULYz7BwC7Ynn+Jq+Dnu53Dv+BaXolUmXVF9g
         nsCAA9cvDbvEDrU0il0d06GFVRLsO4ZeCY3QK0z0MFrbXg9tfNRfgcUihUn+TU9oyPRl
         UjNLWYVFCmcFpq5EjE58+zT2B8XH4hGR+xLJtWveeMzZKG0du2DQQbGQHsRuTSTjvXHn
         X9fHHGANLRMBcLSONrxC+3wdAX3Rr4fJkSinyyLnim6lI+oTHla3ZYEf9xUku2t4rXt/
         Dyp+LuXQdME5SUNXfEoqQTkpeZ6IB6c1MtOUQ1lYkhPZiQ+0jqW7XZVhuZ1PfP4aSSXl
         464w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxOzUkSFr6Wk07X0rWnPtJzVLAiDlRwjY44J+SEwVCw=;
        b=KZd4occptj1TMFzS9fDYFupYcmS4C3HDYXekQSybnBHqI1feACpcLMiX4FXE1jFayg
         g9CsKsWb2KcrGtW+/qBZolOFWnAzhPE/raGKUbFXlLXvuFwszAQn8ZZzSpewrBfSM3s4
         um6f0APbtWPoGSzCN84dCDYqX/7HeV/mLJxRJmt+ZsV3Q0NP2kcLj0zcO+iq/HxQXxLc
         tPU+RURbJMNEzzQRXRRnFhEIA/RJ8nIlJM2Bh7lSeJ9Y6KkCRtNqarvjB91OWTmIBS/N
         gjQxSpn2jtIWM5ELgqDsoVZr4JYi+2b1zGlkzzVCaQlZ0PNtGzoLl6jc7e06RDIhkxgO
         6oWA==
X-Gm-Message-State: ANhLgQ0OYrYzd7E838ok1Q0eVMYdmKc8Q6fIF6Wud1tUrj48dsLMpVDd
        oWxPnvpcgqsGhIMrnBHVUF6fkA3KKl1ZLgp0X0M=
X-Google-Smtp-Source: ADFU+vt6LDSkh3Kbj3ZORx+m8WoXhjmCqXW1FNMvnKvPhWcMIAT6fxQs69jf3e7PiUbRpFa4wSK7JXazOdRCpMacu2c=
X-Received: by 2002:a50:9b07:: with SMTP id o7mr16941353edi.139.1585669224465;
 Tue, 31 Mar 2020 08:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch> <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com> <20200330174114.GG25745@shell.armlinux.org.uk>
 <20200331104459.6857474e@erd988> <20200331125433.GA24486@lunn.ch> <20200331151503.GO25745@shell.armlinux.org.uk>
In-Reply-To: <20200331151503.GO25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 31 Mar 2020 18:40:13 +0300
Message-ID: <CA+h21hriL_8gGE8iqShuR0h3m2si=MLTuKk12Btx3=XB1RM++g@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Jander <david@protonic.nl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, kernel@pengutronix.de,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 31 Mar 2020 at 18:15, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Tue, Mar 31, 2020 at 02:54:33PM +0200, Andrew Lunn wrote:
> > >  - Disable the SmartEEE feature of the phy. The comment in the code implies
> > >    that for some reason it doesn't work, but the reason itself is not given.
> > >    Anyway, disabling SmartEEE should IMHO opinion be controlled by a DT
> > >    setting. There is no reason to believe this problem is specific to the
> > >    i.MX6. Besides, it is a feature of the phy, so it seems logical to expose
> > >    that via the DT. Once that is done, it has no place here.
> >
> > The device tree properties are defined:
> >
> > bindings/net/ethernet-phy.yaml:  eee-broken-100tx:
> > bindings/net/ethernet-phy.yaml:  eee-broken-1000t:
> > bindings/net/ethernet-phy.yaml:  eee-broken-10gt:
> > bindings/net/ethernet-phy.yaml:  eee-broken-1000kx:
> > bindings/net/ethernet-phy.yaml:  eee-broken-10gkx4:
> > bindings/net/ethernet-phy.yaml:  eee-broken-10gkr:
> >
> > And there is a helper:
> >
> > void of_set_phy_eee_broken(struct phy_device *phydev)
>
> Disabling the advertisement may solve it, but that is not known.
> What the quirk is doing is disabling the SmartEEE feature only
> (which is where the PHY handles the EEE so-called "transparently"
> to the MAC).
>
> It's all very well waving arms years later and saying we don't
> like code that was merged, but unless someone can prove that an
> alternative way is better and doesn't regress anything, there
> won't be a way forward.
>

For what it's worth, your position on these device tree bindings for
broken EEE seems to have changed from the one that you expressed in
this thread:
https://www.spinics.net/lists/arm-kernel/msg703453.html
To quote from that:

> > There is no "advertisement of SmartEEE" - it's just EEE.  That is
> > because as far as the link partner is concerned, SmartEEE is just
> > EEE.
> > [...]
> >
> > Otherwise, using the existing "eee-broken-*" properties to disable the
> > link modes where EEE fails would be the correct way forward, and should
> > be used in preference to disabling SmartEEE.
> >
> > However, no one has mentioned what the problem that is trying to be
> > addressed.  Is it data corruption?  Is it that the link fails?  Is it
> > lost packets?  Is it that the MAC supports EEE?  I think there needs to
> > be some better understanding of the problem at hand before trying to
> > address it.

Regards,
-Vladimir
