Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E7433AFF
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFCWRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:17:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfFCWRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:17:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D70F11009E4E3;
        Mon,  3 Jun 2019 15:17:20 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:17:20 -0700 (PDT)
Message-Id: <20190603.151720.1436141762608920922.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: sfp: read eeprom in maximum 16 byte increments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1hXREK-0005KT-1e@rmk-PC.armlinux.org.uk>
References: <E1hXREK-0005KT-1e@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:17:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sun, 02 Jun 2019 15:13:00 +0100

> Some SFP modules do not like reads longer than 16 bytes, so read the
> EEPROM in chunks of 16 bytes at a time.  This behaviour is not specified
> in the SFP MSAs, which specifies:
> 
>  "The serial interface uses the 2-wire serial CMOS E2PROM protocol
>   defined for the ATMEL AT24C01A/02/04 family of components."
> 
> and
> 
>  "As long as the SFP+ receives an acknowledge, it shall serially clock
>   out sequential data words. The sequence is terminated when the host
>   responds with a NACK and a STOP instead of an acknowledge."
> 
> We must avoid breaking a read across a 16-bit quantity in the diagnostic
> page, thankfully all 16-bit quantities in that page are naturally
> aligned.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable.
