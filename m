Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F4669CC4
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjAMPrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjAMPqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:46:35 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B85360C9;
        Fri, 13 Jan 2023 07:37:35 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id qk9so53208935ejc.3;
        Fri, 13 Jan 2023 07:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y5rgjQrZm3SZWH5xc1Yntbt7VF0DK1bhdzsodlx5W60=;
        b=MQNgWi8LZ0Fj4M6yzg6PwHObSohN3uCeS+1g36NBwbRMApQUmky26RUzq6g+h1BBia
         Zwfpuz4gZblXy4CmhwACPaUiCyVsKuWoY4Pbabj8FkXbDR4YyBrv3J2dUzH0TtHvAJvQ
         rP9rKyJtrzpE+ZGcow4Rx4QhdyLgLNIozCir9fGLS6XwLdbW0OIdlmffe77rjG3kZvq7
         gi5OLRw/LA5C+hDEw66XImQ//9PFjJjulmlM3CrnsEeCpPXuDTpGk0a6M4upluacI+CG
         H7nXxlQcELvGuyfcHnAoqM8M5Q8mKgEW5Xk/3kuHaqac/bdbVqsx1w/Rr+7kzC8Wa7+5
         IoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5rgjQrZm3SZWH5xc1Yntbt7VF0DK1bhdzsodlx5W60=;
        b=PBZphzQulGlndFuZgRmCeB0FBxa7aosn3I1zUXd+w0+BRPK9B4G3f+pvqmcOgoMoyx
         CR7qFxhozviYlLgmY5q1s73jGue4Ds8Sv2OA4pzag6iMiUQzKrq4kvMlmZ2vChq0vF+U
         115N4ZT0N3yCnbUSlcZ7rE58pKmK0eUtINMC8zsg0twai82rDoUvv4D+3C17NsOqInk4
         SY9+LrmcvbfiCjgL+yZUxvfH1WW9ul0FrahdgySxj09t3+8anqXBLvovHRHvRKuzP8IL
         QKHWKYwSHk/kX+ecitYjUY5kmbv15IrYYLkOE8xo3zEbY5StUmKT3qNkcMNeEOMyU7Fe
         1Y0g==
X-Gm-Message-State: AFqh2kr54QybQ2Q49qgZDBzm9sNn5HZhjUPhMsKQtiJxm+7T1Vr6Ss4/
        tMOhCj5V1nKPfSTlXLRZDKo=
X-Google-Smtp-Source: AMrXdXs7KnvuVntPRYQbJGYyUMRcXZL4yxD0dPYsmXhpONsa8Vf/SPhChPxTlTVgvkBXOed3eh1pcA==
X-Received: by 2002:a17:906:7046:b0:7ae:8194:7e06 with SMTP id r6-20020a170906704600b007ae81947e06mr72499501ejj.56.1673624253796;
        Fri, 13 Jan 2023 07:37:33 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id o11-20020a170906768b00b0084d242d07ffsm8329573ejm.8.2023.01.13.07.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 07:37:33 -0800 (PST)
Date:   Fri, 13 Jan 2023 17:37:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: Re: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Message-ID: <20230113153730.bcj5iqkgilgmgds3@skbuf>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
 <20230112213755.42f6cf75@kernel.org>
 <Y8Fm2GdUF9R1asZs@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8Fm2GdUF9R1asZs@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 03:12:40PM +0100, Andrew Lunn wrote:
> On Thu, Jan 12, 2023 at 09:37:55PM -0800, Jakub Kicinski wrote:
> > On Wed, 11 Jan 2023 12:56:07 +0100 Clément Léger wrote:
> > > Add support for vlan operation (add, del, filtering) on the RZN1
> > > driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> > > tagged/untagged VLANs and PVID for each ports.
> > 
> > noob question - do you need that mutex? 
> > aren't those ops all under rtnl_lock?
> 
> Hi Jakub
> 
> Not commenting about this specific patch, but not everything in DSA is
> done under RTNL. So you need to deal with some parallel API calls. But
> they tend to be in different areas. I would not expect to see two VLAN
> changes as the same time, but maybe VLAN and polling in a workqueue to
> update the statistics for example could happen. Depending on the
> switch, some protect might be needed to stop these operations
> interfering with each other. And DSA drivers in general tend to KISS
> and over lock. Nothing here is particularly hot path, the switch
> itself is on the end of a slow bus, so the overhead of locks are
> minimum.

That being said, port_vlan_add(), port_vlan_del() and port_vlan_filtering()
are all serialized by the rtnl_lock().
