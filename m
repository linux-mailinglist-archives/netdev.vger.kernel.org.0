Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF64F41BE
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353290AbiDEUDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452440AbiDEPyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:54:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7ED4AE0F
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 07:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gxwZZyo5mJHFdc5jTFT7QqaCLsw7lI5fo+F1b7YE5EY=; b=tj0VGuaGKqsh8pAvGV2eOLQPln
        z0CR+o2k5Xc4Q7CeEWT1gwyzMjfWkciSJTmfFCaIQQqLLGufHzMb0OeFVz8ny96ds9oS+WzhAYQZf
        MoWYxsQMzcT2YHkIiogfkyZHLz8elBXdhNRJ7IRZYl7RxOpuCF5qUjSTdfCPY5kNq7gw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbkbA-00EGBq-8H; Tue, 05 Apr 2022 16:56:00 +0200
Date:   Tue, 5 Apr 2022 16:56:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Conor.Dooley@microchip.com
Cc:     palmer@rivosinc.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, linux-riscv@lists.infradead.org
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Message-ID: <YkxYgDnWNxeXou3F@lunn.ch>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is this some sort of lack of support for CONFIG_PM=y in my clock driver,
> that's leading to the PHY getting stuck in reset?
> Or an interaction between CONFIG_PM=y & the macb/generic phy drivers?

What clock is driving the PHY? Sometimes the SoC outputs a clock to
the PHY, and the PHY will not work without it. Sometimes it is the
other way around, the PHY outputs a clock to SoC, so this might not be
your issue.

Maybe PM is turning the clock off because nothing is using it?

      Andrew
