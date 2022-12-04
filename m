Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5203D641F4B
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 20:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiLDTss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 14:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiLDTsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 14:48:47 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37DC11825;
        Sun,  4 Dec 2022 11:48:35 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id fc4so16252532ejc.12;
        Sun, 04 Dec 2022 11:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gn5F6cGaMlevc3P+NWYHVafrK/+jYG7DO6PO569PTNQ=;
        b=Haqoljlk3Xt52rAEQuBNRyk5fWWF+Fr62JGGaCnEjtBAAIQRN6CpmqHUqN4hQ42eIw
         5+3KkEVjY9WYJoXX5hTssho+uCGLm75sBbvqAGSX9/fbRM3pPKltPEWKBDM2TwLIJ/I0
         wXHeyUStjcsuXhAJwF99NiJBlRBrJRbgdsYuol2c6FFR7iRoMRZLBXzbxFpQq9m0nK5z
         BPlN6A8guXTAX+ztClf1T8ClknQaWCemsg0p8RoHQQkhvDHc9y8hjy6AI7sL5TjlqUDP
         VDDwh0zZJJGrFeuyTLw5/KuyRI5HAfB6wvLmcuS5D+6nLS3UYDGqg3iMcO5kCAb5+0EF
         BRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gn5F6cGaMlevc3P+NWYHVafrK/+jYG7DO6PO569PTNQ=;
        b=FmlLyT1AyVS9O1bN/H1Phs68A5ErcXjauTvMz6J4DNMeae2GRwY5PkrNRTuElxN7Wg
         YnJWsFy+uJdjNetmR888LiWg4Zevfc+mL2w7Oy/8G5DlHuUUcY1kO/q4mYMDiwq6Yp94
         yiEDjx0ryWxsBhwILWH+780FCWvDlAzo2uS+U53bYK+yu2TCtxol3oqpP3C4NFMMpFjW
         C+N1MeYMW+4X415ODpZERjrxwKvBZVEcK49/cX5MqnPfQU7wbZyquwcQeUBIN1KUz63d
         hcMnX9zQBxhHXogkTIYaBy/wD8KfgrdozvvylsEVk0UnUi0YQkBqqOfpsavIvDdGGDvK
         Mr5g==
X-Gm-Message-State: ANoB5plpJQJz+Z32zMXKPdCB3rXtwOiKSAViVPwXV0Ztgmja30KNqoeD
        zsJ6akML3S/iw5Bf9hBp6UaYsgcfAiDU7qQL
X-Google-Smtp-Source: AA0mqf4C7EXEySKnvOXk2YHUJ6lxGqj96U6cqvofv+AZ5HWGBa+qj71hcyS/70jRgHFSXoyQW41PJw==
X-Received: by 2002:a17:906:a155:b0:7b5:576e:b7d6 with SMTP id bu21-20020a170906a15500b007b5576eb7d6mr58705512ejb.127.1670183314297;
        Sun, 04 Dec 2022 11:48:34 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id c5-20020a1709060fc500b007ae10525550sm5461458ejk.47.2022.12.04.11.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 11:48:33 -0800 (PST)
Date:   Sun, 4 Dec 2022 20:48:42 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/4] drivers/net/phy: Add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y4z5mlV+KjHfUCa/@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
 <Y4zplu5hdrh8CvZ5@gvm01>
 <Y4ztv0mvMFEuLccG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4ztv0mvMFEuLccG@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 07:58:07PM +0100, Andrew Lunn wrote:
> > > > +static int ncn26000_enable(struct phy_device *phydev)
> > > > +{
> > > 
> > > This is actually the config_aneg() implementation, it should be named
> > > as such.
> > I can certainly rename it, however I did this for a reason. The NCN26000
> > only supports P2MP mode. Therefore, it does not support AN (this is
> > clearly indicated in the IEEE specifications as well).
> > 
> > However, it is my understanding that the config_aneg() callback is
> > invoked also for PHYs that do not support AN, and this is actually the
> > only way to set a link_control bit to have the PHY enable the PMA/PCS
> > functions. So I thought to call this function "enable" to make it clear
> > we're not really implementing autoneg, but link_control.
> 
> Anybody familiar with PHY drivers knows the name is not ideal, but
> when they see config_aneg() they have a good idea what it does without
> having to look at the code. All PHY drivers should have the same basic
> structure, naming etc, just to make knowledge transfer between drivers
> easy, maintenance easy, etc.
Fair enough, I'll change the name in the next patchset version
