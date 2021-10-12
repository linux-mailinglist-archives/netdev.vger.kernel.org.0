Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CA9429FF7
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbhJLIfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234870AbhJLIfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 04:35:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 322CC6101D;
        Tue, 12 Oct 2021 08:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634027587;
        bh=fakIsIuKhcbVYQcHQbb+3RZ9hFiFRfVnIKR0x3kHKrU=;
        h=In-Reply-To:References:From:To:Cc:Subject:Date:From;
        b=FDCrxjJXFwTNCvlQtkbuycOp1zCRlkZbNOdDlzh2+sAHUDj2t/lciIZMU+itXjRol
         ARQuGrgh4MfKczLEefRDlBhSxI2ALpK94tJU4aoDB4iC2ysuXMPvkqHjWSNaGDkoRd
         ru8FR5QnG+7PRLeOKxNxtgo0dHPPBeF7kfUfOB9Kxini5kRYwrOpNt4IJeMoVr2MD4
         629CDTJbcnBDX5+ZyiSIt91YIvtt5gea5RzybnQDoxdqwlapQKdBfH/GW0B8Ep9ME8
         WFRUtZGHNGc0BogqRE1EF9BrxY8hdLmGtMJZ33A0QpBOK7J8vFtNiy+L6JQqRVb+s6
         Zed0+L65Ir3YQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211011165517.2857893-1-sean.anderson@seco.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
From:   Antoine Tenart <atenart@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
Message-ID: <163402758460.4280.9175185858026827934@kwain>
Date:   Tue, 12 Oct 2021 10:33:04 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sean,

Quoting Sean Anderson (2021-10-11 18:55:16)
> As the number of interfaces grows, the number of if statements grows
> ever more unweildy. Clean everything up a bit by using a switch
> statement. No functional change intended.

I'm not 100% convinced this makes macb_validate more readable: there are
lots of conditions, and jumps, in the switch.

Maybe you could try a mixed approach; keeping the invalid modes checks
(bitmap_zero) at the beginning and once we know the mode is valid using
a switch statement. That might make it easier to read as this should
remove lots of conditionals. (We'll still have the one/_NA checks
though).

(Also having patch 1 first will improve things).

Thanks,
Antoine
