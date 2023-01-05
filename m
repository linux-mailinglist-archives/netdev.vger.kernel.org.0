Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C76D65F33B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbjAERzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbjAERzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:55:49 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D50A564CB;
        Thu,  5 Jan 2023 09:55:46 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id u9so91944974ejo.0;
        Thu, 05 Jan 2023 09:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2vOnOVXBYCMZDKD8mgmU526n0sgvjAuhpbWzK63bgqo=;
        b=Iv5TuTTR9yZDhbR8odBB2ehvIemJbPOuyPyfdbMA5iJwoMEykH5JU7ex7p+GAwp0sS
         BhlaeEZFlIyKXj5tcTrpOxYru3pA59wj9lprcfY9BbxAlGfkhk6NHvTIXvTv6jRKJcgz
         8+/Wbip24OdcB9fRNKv/37bhX7uOkwWXHMLzZuK5o1b4DnroTqfiznByL+wUAesr+CSU
         t+0zKdeFJxAuSc7HUE3Y5BI3vq07G3ZIXEyEj1LY6hxAdlSO4L97Tw0eNKTYN3DL2ese
         enwuoiXEJDCyF33ukexwoLOSVzajxECRuAAIwx3u8pJRHtu/6nQp5vJy+khMAh5olVdr
         nBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vOnOVXBYCMZDKD8mgmU526n0sgvjAuhpbWzK63bgqo=;
        b=T9v59qWA+0AW+fEdb5TpUW4muCL/+FvMybjd0VdhICdaTMVXWGZfJTHwpddz8LY7+s
         7EcYXhvG4zx/rWcfg4GnpQAib036oEIYIKXQpsCUlS5ywmSIO/aaj8gVmYHpt+vfA3H4
         FjUtKUbFA1Er5APzzCzwFNPGQnlr8Fsp5lmOQoLzQT1fFFKB5iWUk6QuFCWgyYsnCZUR
         4bDKvQFivqJPyzDpXibAou5danMQb6kxogfGkHegUKeUPoHlj51Jeaif26aWG/EyTSdV
         gn8TkOJsuuUAJjSsGWijr8ft5a7Wh5nyxbIjC1ARC01SnUfbt011+U5IP6F8yK0uotC5
         2XBA==
X-Gm-Message-State: AFqh2kpO+b+Kt6xsygaINmP2TAtS8n6r0+1Zkfhr/ENYmfk1T1kvodDS
        6zkHeQCoWYEMMHbe13nC/5k=
X-Google-Smtp-Source: AMrXdXsimYZ8Sq3WEzusTuYXCQMa5JNdP8QQdKs5vOMLE4lkTVuRSZAU7JzbsgUvY6McUGU+qTFxRA==
X-Received: by 2002:a17:907:6d12:b0:7c1:79f5:9545 with SMTP id sa18-20020a1709076d1200b007c179f59545mr64022698ejc.42.1672941344964;
        Thu, 05 Jan 2023 09:55:44 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id m11-20020a50cc0b000000b00487fc51c532sm10451222edi.33.2023.01.05.09.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 09:55:44 -0800 (PST)
Date:   Thu, 5 Jan 2023 19:55:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230105175542.ozqn67o3qmadnaph@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105175206.h3nmvccnzml2xa5d@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 07:52:06PM +0200, Vladimir Oltean wrote:
> On Thu, Jan 05, 2023 at 12:43:47PM -0500, Sean Anderson wrote:
> > Again, this is to comply with the existing API assumptions. The current
> > code is buggy. Of course, another way around this is to modify the API.
> > I have chosen this route because I don't have a situation like you
> > described. But if support for that is important to you, I encourage you
> > to refactor things.
> 
> I don't think I'm aware of a practical situation like that either.
> I remember seeing some S32G boards with Aquantia PHYs which use 2500BASE-X
> for 2.5G and SGMII for <=1G, but that's about it in terms of protocol switching.
> As for Layerscape boards, SERDES protocol switching is a very new concept there,
> so they're all going to be provisioned for PAUSE all the way down
> (or USXGMII, where that is available).
> 
> I just pointed this out because it jumped out to me. I don't have
> something against this patch getting accepted as it is.

A real-life (albeit niche) scenario where someone might have an Aquantia
firmware provisioned like this would be a 10G capable port that also
wants to support half duplex at 10/100 speeds. Although I'm not quite
sure who cares about half duplex all that much these days.
