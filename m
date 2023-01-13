Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A48668B97
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 06:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbjAMFiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 00:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjAMFiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 00:38:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164323C711;
        Thu, 12 Jan 2023 21:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9450DB81DFA;
        Fri, 13 Jan 2023 05:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBD6C433EF;
        Fri, 13 Jan 2023 05:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673588277;
        bh=qgckOnbLBIjA45c7VV8pusTKacJWBosTUlXj+3kBIhg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pt46cguZhTskuQQz+J4WN9bhx+qBVf0XEmmiifO8glUyQzgvYMofuWBrJuLhdR3M9
         PfKA8RsOd1IEmzc2KGXKD0Fn+o3Hp9LKc8ZnJiYxP/xmUFaqEJ/a8P/I3DFOkW+W4V
         JXL1jJGShJR8Mq4YXJLDUYV2eaQYjmBCBLXfIEFZ266bePxJisn8aY/YMdlisW0axj
         3HY8e9ykIe8bZFbPmS5gtNgFLjCHjl3gxL80O7RhVujOVr23L5H46KkJoN9pnIDee/
         Y5YTsWRXoAr4Gtyaz7jq2yGAeSbo//cahUMWayvxyvpAgZGnQJi+GBI+5ZTNrwKJSS
         AqWiqpINfhCiw==
Date:   Thu, 12 Jan 2023 21:37:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: Re: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Message-ID: <20230112213755.42f6cf75@kernel.org>
In-Reply-To: <20230111115607.1146502-1-clement.leger@bootlin.com>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
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

On Wed, 11 Jan 2023 12:56:07 +0100 Cl=C3=A9ment L=C3=A9ger wrote:
> Add support for vlan operation (add, del, filtering) on the RZN1
> driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> tagged/untagged VLANs and PVID for each ports.

noob question - do you need that mutex?=20
aren't those ops all under rtnl_lock?
