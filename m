Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E286D2B9DC1
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKSWno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgKSWnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:43:43 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31763C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:43:43 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id u19so10660984lfr.7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=PWxD5tWSW4No1k+xx57i1FheknQLpgK5g7gzS3PzhVs=;
        b=h4qBSgGGeFy1EAszBwXh4EPz3N1M/oUfuk8fY2BvjVugeaxFRRRJ8iSQRvYRtXMRp3
         vzy8Qmis5vyHufc5YX5f/h9tP+l9QHdjTtgDoPoXTZGVeTCd5b9QB7371j1T5BgnNmDH
         K7HaENAB1ALNheS7u/D0ObuzP090u4z/ZwsFHQCV8QQS5maMjFZwPmKrAZEhMdz7t/2V
         Ug0Hw9ukUM5/xIBx/hDchb6IabG7SPwmt2yXy5lGI+AHstVGijNwFYp04bSQHBdKLvA5
         zurvf5D69g+4CJ4GUTwQSpPzfQMQ1WDc34VCock6iCp8yf99QJtpJhtF6BtttsHqgIIH
         jhqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PWxD5tWSW4No1k+xx57i1FheknQLpgK5g7gzS3PzhVs=;
        b=SdwYFqvdewq6vmUBvFdYwrj42g8aGmBDE6CeIbThYvcnOv1vES4ls+TUzEyfLBS2NP
         OzGKczxxlKnrSJVe1XSO4Nl7b8e/fhRekKO66/4DhXSyISHy06J5W4baRsO34oPMV7mX
         YpVycK/cbSjzgngdz9U7kZTJjoqs4CMLrBCeBsZZrQ078Ei8FjA7xP1cjohK7YSikv/W
         e18BnNzN+7VLyar6why8MofWdaaEy0LpdEb1oz2WZoK4/YyV/jdFCOyY2ze0r08mvHDn
         5tFK8GhVMXdYIc7emdYzg3h/mUGuPf2igejw9HIRnhXsVlYCW707THtsMaxMA8UZQ/TN
         8seg==
X-Gm-Message-State: AOAM531/llZ4af68YAuANSSw/rLnVvIGbk5zFA3+pafnqfAE9HjNLjDb
        AT6cKxxT1VBYI2acIh1FK9bSng==
X-Google-Smtp-Source: ABdhPJww9rUt9VrrlZlXN4RPjwHu3mlYZpLO1Zc16wNcMisZB7jSguubAvK0UmWrjqxU7XrbzPBXKg==
X-Received: by 2002:a19:8346:: with SMTP id f67mr8042022lfd.569.1605825820280;
        Thu, 19 Nov 2020 14:43:40 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id 23sm124290lft.140.2020.11.19.14.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:43:39 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
In-Reply-To: <20201119162451.4c8d220d@bootlin.com>
References: <20201119152246.085514e1@bootlin.com> <20201119145500.GL1551@shell.armlinux.org.uk> <20201119162451.4c8d220d@bootlin.com>
Date:   Thu, 19 Nov 2020 23:43:39 +0100
Message-ID: <87k0uh9dd0.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 16:24, Maxime Chevallier <maxime.chevallier@bootlin.com> wrote:
> I don't think we have a way to distinguish from the DT if we are in
> SGMII-to-Fibre or in SGMII-to-{Copper + Fibre}, since the description is
> the same, we don't have any information in DT about wether or not the
> PHY is wired to a Copper RJ45 port.
>
> Maybe we should have a way to indicate if a PHY is wired to a Copper
> port in DT ?

Do you mean something like:

SGMII->SGMII (Fibre):
ethernet-phy@0 {
   sfp = <&sfp0>;
};

SGMII->MDI (Copper):
ethernet-phy@0 {
    mdi;
};

SGMII->Auto Media Detect
ethernet-phy@0 {
    mdi;
    sfp = <&sfp0>;
};

If so, this could also be useful in scenarios that have nothing to do
with combo ports, but where you have custom connectors.

E.g. at Westermo we make switches with M12/M12X connectors [1] that
sometimes have a 1G PHY behind a 2-pair M12 connector (for complicated
legacy reasons). In such cases we have to remove 1000-HD/FD from the
advertised link modes. Being able to describe that in the DT with
something like:

ethernet-phy@0 {
    mdi = "2-pair";
};

Would be great!

On the topic of combo ports, another thing to consider is how this
should play with ethtool. Ideally it would be aware of the two media
sides, and be able to configure them both independently.

[1]: https://www.westermo.com/products/ethernet-switches/en50155/viper-208-t4g-tbn
