Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1262D4E655A
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348570AbiCXOgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351053AbiCXOgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:36:54 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D422384;
        Thu, 24 Mar 2022 07:35:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b24so5824096edu.10;
        Thu, 24 Mar 2022 07:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jt66HNIsSgHK1QN5MOHClDI947FHdQQhnkZW+fpRDcI=;
        b=XRqYDq2e0KeQ2nMyIYT8PphgcQN7TW3zxsdDlXUss9wHPnmqE9yQFQ5gAUy5UJw4jr
         LSTvz6mViI7htcfUKFqU86pLNNPy2C0z72qaTnzJFthZlfQHVxDh8h2KMMN1XkkNFIek
         ym8pM6ySzBGLDjGRZ6/Y8Ymy9lbo10VuWywm1Ajn9X/clGHgwv2YBlRNpg3glWWK9EAy
         qTpTp3+FYUUE2aCBuIk/xgWY4cwLr26kCBhHmZrpMalZqQ+sPHh87kaIk2CgZv1PVD/1
         aOolLQhIeTSB85mzSfxY6x9jQjwvj8H8Ml9D2cay2zXEbvZS8cRw5ceoFhLGz0X/Agqy
         hlzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jt66HNIsSgHK1QN5MOHClDI947FHdQQhnkZW+fpRDcI=;
        b=SitME5c6m9jAUvB5WXZFxvll7TvqwXPGuavZ71k4fCCw0PGBapgUG+DG6bs829DNkR
         86zQGLL/fhVpbdynRJQ7RzIOv9hTYxLxnZ1GNID4xSd4SAiUFWnOAfpkbPXetI0bWGYh
         P9bFB6AL2IuWGo1YcqEn2VVun4z7pRQpl8psevaF2zfa9mG2tZb7MzeG+KP2jntC9581
         DEoPr2LF2rlE1H1rC/5GWnulnW5Yqaiqew6wQH2JzVwp9WdBFif1bib2pjMZkE5O665X
         +w2EHNKz4VFfId1k8PW9DLCDH1JURFysPPP9I5vhtPop440X52NTpu0qvt9ZHO46sdo/
         TmRQ==
X-Gm-Message-State: AOAM532dvA7qbusMa4VZ9Re4WszOGpBr3LKn9BEip5RzazEeRuc9MetZ
        1ObchKob4K/eCRu+MAV0nlc=
X-Google-Smtp-Source: ABdhPJyFzj7rNrzhvO2H9J6CJvMnktnldUdFz1zY1bP+sgzg4enOZvVJS34NA0uYDFgiwazwrOxlQQ==
X-Received: by 2002:a50:ec0c:0:b0:418:f415:6bfe with SMTP id g12-20020a50ec0c000000b00418f4156bfemr7082712edr.15.1648132521606;
        Thu, 24 Mar 2022 07:35:21 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id hr13-20020a1709073f8d00b006dfcc331a42sm1183208ejc.203.2022.03.24.07.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 07:35:20 -0700 (PDT)
Date:   Thu, 24 Mar 2022 16:35:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: sja1105q: proper way to solve PHY clk dependecy
Message-ID: <20220324143519.yvcgt3u2icnbbafy@skbuf>
References: <20220323060331.GA4519@pengutronix.de>
 <20220323095240.y4xnp6ivz57obyvv@skbuf>
 <20220324134824.GG4519@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324134824.GG4519@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 02:48:24PM +0100, Oleksij Rempel wrote:
> > 3. Clock gating the PHY won't make it lose its settings.
> > 
> > I expect that during the time when the sja1105 switch needs to reset,
> > the PHY just sees this as a few hundreds of ms during which there are no
> > clock edges on the crystal input pin. Sure, the PHY won't do anything
> > during that time, but this is quite different from a reset, is it not?
> > So asserting the hardware reset line of the PHY during the momentary
> > loss of clock, which is what you seem to suggest, will actively do more
> > harm than good.
> 
> can i be sure that MDIO access happens in the period where PHY is
> supplied with stable clk

This is a good question. I suppose not, but I never ran into this issue.
You can try to force this by having the PHY library use poll mode for an
RMII PHY (case in which, IIRC, 3 or 4 PHY registers will be read every 2
seconds), then from user space do something like this:

ip link add br0 type bridge && ip link set br0 up
ip link set swp0 master br0 && ip link set swp0 up
while :; do
	ip link set br0 type bridge vlan_filtering 1
	sleep 1
	ip link set br0 type bridge vlan_filtering 0
	sleep 1
done

Every VLAN awareness change triggers a reset in the switch, and this
ends up calling sja1105_static_config_reload().

If you can artificially reproduce PHY access failures, first it's
interesting to analyze their impact, does the PHY state machine
transition to a halted state, or does it ignore the errors and continue
with the next poll cycle? If it continues, it's probably not worth doing
something.

To avoid the problem, you should probably need to iterate using
dsa_switch_for_each_user_port(), and mutex_lock(&dp->slave->phydev->lock)
for each RMII PHY during the reset procedure (similar to the other
things we lock out during the switch reset). The tricky part seems to be
releasing the locks in the reverse order of the acquire...
