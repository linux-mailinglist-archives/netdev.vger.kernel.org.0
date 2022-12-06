Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8552F644E61
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 23:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiLFWMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 17:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLFWMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 17:12:45 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C521717043;
        Tue,  6 Dec 2022 14:12:42 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id d14so17446485edj.11;
        Tue, 06 Dec 2022 14:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iYXLmwmRWqCyzAqnG3aNR/0AAohD2KWeWKOH7EUJLow=;
        b=PBhzGIZ+ATOupWPKL5grDJCU68MrkeDJpiKg0onlWWcqUyo1Mv2L+ykCaleiVc6vBO
         S+2Wu/oqBIqTGID6spdgTgGQn/1IOgqILcfzdQmiL8dZU0ZsrEtI7U8mh3I1czV59kFD
         E/A0kji4qFDVudma8gMbdf/O0+DQrHwYFyfypBnG8S0OJqurIcx5Rh+X9yRCRmVmp+xe
         q916Yru6yAvStgs01hw/2EVwYgHZugkfCQL3M1Cat+KDlE81qy+W4V37LS+FYfgUlQ1A
         N2ixhucuYHEYG5qKSmbN9dQwMAHrettbepTX3JWEzvBo1VLEUaxbxYs3MYJSBTD7z1OY
         TsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYXLmwmRWqCyzAqnG3aNR/0AAohD2KWeWKOH7EUJLow=;
        b=3n9jLaNxkNJmEKq2NKpzgUM3nm6GuNiBLUruZNLI663uWj3cFOL7Jv3yfmHWotTbfc
         V3LqXk/F5LbRAyrxhLeMd42r0bC4DS/aegDRINjC7VWXKk6R3iWlpkGBrwsOzUgYUIUc
         WdjwA+8niA7hvravzZuiWEgSKkIMoJjNhqjYaw9RDFm1peb8kEne4m+sa+WNyj3uvqVG
         RYAxR5UnLT5sR5ftxVByUjITmtlUZ9iXw4lUPG75MGxSFWGOkMs/TlIZEWkNO2ZVZWmA
         4qbHrR6lmiyYjdC++HmDI0uYC9XRu6AYTY62Pf5kAzWcCqcQuN7gEj/8MMvivrHOHUSM
         hL4w==
X-Gm-Message-State: ANoB5pmKqWMO7QwuqZwwm92J05fNMkUl6G9OcPQTQCk9ChXdkGBKC5q9
        fIiU/02HLYYk8VBFlzixkSc=
X-Google-Smtp-Source: AA0mqf5mkqk5k/z5QmE6FQqCbFxEGSqZxp3bArtHGiABx2k5B/hMwQgmCDCIwBHreNIf13tELMH63g==
X-Received: by 2002:a05:6402:1013:b0:463:f3a:32ce with SMTP id c19-20020a056402101300b004630f3a32cemr63753523edu.366.1670364761155;
        Tue, 06 Dec 2022 14:12:41 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906200a00b007ae243c3f05sm7664381ejo.189.2022.12.06.14.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 14:12:40 -0800 (PST)
Date:   Wed, 7 Dec 2022 00:12:38 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] dsa: lan9303: Move to PHYLINK
Message-ID: <20221206221238.5p4wv472wwcjowy5@skbuf>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206193224.f3obnsjtphbxole4@skbuf>
 <Y4+vKh8EfA9vtC2B@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4+vKh8EfA9vtC2B@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 09:07:54PM +0000, Russell King (Oracle) wrote:
> > Are you going to explain why modifying this register is no longer needed?
> 
> ... otherwise it is a fixed link, so the PHY is configured for the fixed
> link setting - which I think would end up writing to the an emulation of
> the PHY, and would end up writing the same settings back to the PHY as
> the PHY was already configured.

To be clear, when you say "an emulation of the PHY", are you talking
about the swphy behind the fixed-link, or about the LAN9303_VIRT_PHY_BASE
registers, which correspond to the RevMII Virtual PHY of the switch CPU port?

As far as I can understand the Microchip LAN9303 documentation, the DSA
master can have a phy-handle to the switch node (which
devicetree/bindings/net/dsa/lan9303.txt seems to confirm), and the
switch can pretend it's a PHY when accessed by a switch-unaware
(Generic) PHY driver at the usual PHY MDIO registers. Through the
Virtual PHY feature and registers, it can also pretend it's the "other"
PHY, and this MII_BMCR register of the Virtual PHY can ultimately
autoneg with "itself" and control what the DSA master sees in terms of
reported speed, duplex, and AN complete.

Prior to this change, the driver, when given a DT blob with a fixed-link
on the switch CPU port, would disable BMCR_ANENABLE in the Virtual PHY.
After the change, it would leave things as they are (which is not
necessarily the way things are out of reset). Which way is better?
Does it matter? Is it a stupid question? No clue.

> So, I don't think adjust_link does anything useful, and I think this is
> an entirely appropriate change.

That it may well be, but its presentation is entirely inappropriate.
Andrew has told Jerry before that it's important to split, describe and
justify his changes accordingly, so it's not like the things I'm
complaining about are news to him. Things would go a lot smoother if
Jerry explained his patches better.

Reviewing patches which do stuff that isn't explained in the commit
message reminds me of Forrest Gump. Life is like a box of chocolates,
you never know what you're going to get. That's not how it's supposed to
work, a box of chocolates should contain chocolates, at least here.
