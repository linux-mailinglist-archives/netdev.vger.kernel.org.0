Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7929B64743C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiLHQ1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiLHQ1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:27:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C412C6FF34;
        Thu,  8 Dec 2022 08:27:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5F7AB824BC;
        Thu,  8 Dec 2022 16:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E7CC433F2;
        Thu,  8 Dec 2022 16:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670516823;
        bh=2rZpNHS3zjVnsnclVnie2ZUW06W/KbA77iI6A1Cxwto=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CD0XdI/CmJXuvBPJGjhWMaM01S3ubk6YjXjajjz6MlN+6pJyLxyEcZ5UkXGhAHja2
         nn3cymWvua1BOdteGqpPZZj93BGRpKofIfuPjkprWq0xpLSj2mHrXpO1S+O9oMore1
         gFoNfVBjuISAD1njKRpuFg+Z57NbxVx90YX1w2UDb18omYEiLUQlI9Eu7PxHDX2I0M
         ZQ+gsoBIStSt46+drJHAjH8T3D2tM2qU7hb3ASqw6XmbEbExb8JAxRUNmnpzNJZQtf
         2ag8pw2jA1ti3sSJDNCFspqFeDECIQzke//Q+bey1RCEMqW/XLvRIPQ6dNDyu9ZQgR
         5SSna6ZOt+b9w==
Date:   Thu, 8 Dec 2022 08:27:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: add stats64
 support for ksz8 series of switches
Message-ID: <20221208082701.7b7fffc3@kernel.org>
In-Reply-To: <20221208055512.GE19179@pengutronix.de>
References: <20221205052904.2834962-1-o.rempel@pengutronix.de>
        <20221206114133.291881a4@kernel.org>
        <20221207061630.GC19179@pengutronix.de>
        <20221207154826.5477008b@kernel.org>
        <20221208055512.GE19179@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Dec 2022 06:55:12 +0100 Oleksij Rempel wrote:
> I tested it by sending correct and malformed pause frames manually with
> mausezahn. Since it is possible to send and receive pause frames
> manually, it is good to count all bytes in use, otherwise we may have
> bogus or malicious stealth traffic without possibility to measure it.

=F0=9F=99=83=EF=B8=8F=F0=9F=99=83=EF=B8=8F
