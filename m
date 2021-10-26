Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B1C43A962
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 02:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbhJZAq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 20:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234876AbhJZAqZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 20:46:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6016E60D43;
        Tue, 26 Oct 2021 00:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635209042;
        bh=51nDe4g1GRzT0FxnFRgq55N00hoO5mqaMKDy0BbNkOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=isxhs2l5YFf9GFdXrMU30o+vQsZbN4LvVqPjNUWd1DOdVTPmCfWn8SK3h5YtNzkyo
         b6KC2Fg7005hEt0bIoR+0OAs/gFEoDJjIfcrTxDSK06P+34T0ZWQPNYVXwnT5ZG1sY
         HjI2TDoG2Yj/2rompLKcsrSGMw7jScGE2lv7Jeo7EYHkyzitm8EPmES981ZTa85qib
         Tj+qAboaWVXxoVH0zKb2RrCoBoQLwwccNpE5cCzLeA36TT4NsZUR2BxOGLALP2jybY
         SbxsyY7r4hKhSEc6xrXvweX+JNeMfIa505f47maPH4Ygv+KdtULM6+XS4MRy/RG315
         tq17U55l6u3Ww==
Date:   Mon, 25 Oct 2021 17:44:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
Message-ID: <20211025174401.1de5e95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025172405.211164-1-sean.anderson@seco.com>
References: <20211025172405.211164-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 13:24:05 -0400 Sean Anderson wrote:
> There were several cases where validate() would return bogus supported
> modes with unusual combinations of interfaces and capabilities. For
> example, if state->interface was 10GBASER and the macb had HIGH_SPEED
> and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
> another case, SGMII could be enabled even if the mac was not a GEM
> (despite this being checked for later on in mac_config()). These
> inconsistencies make it difficult to refactor this function cleanly.

Since you're respinning anyway (AFAIU) would you mind clarifying 
the fix vs refactoring question? Sounds like it could be a fix for 
the right (wrong?) PHY/MAC combination, but I don't think you're
intending it to be treated as a fix.

If it's a fix it needs [PATCH net] in the subject and a Fixes tag,
if it's not a fix it needs [PATCH net-next] in the subject.

This will make the lifes of maintainers and backporters easier, 
thanks :)
