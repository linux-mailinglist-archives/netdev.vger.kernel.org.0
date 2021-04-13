Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE10735D8BD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhDMHUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:20:08 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:57125 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhDMHUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:20:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=hB3SMJzbxciIfyeOiBGYdr0s9dNbL/Qk4jbtoGZXblQ=;
        b=DmXqp38c+wiXIAy28bTFfdtGjBDX/g846tjhbDA9FGLenh5AEwhbIDIoT8Yr6ik2dMbR2zBZZUyDa
         XS8Lps5ezWY4URxyMCiK4JHli8S9OEIriGdLTHN6aAotMQawMGZpYdVNNayKgY63J8hCmOajuwfHcL
         tNex7uUlpI8aQhzrlNV+fhmHPKo2akVDLK88gbDNjwvAdM0A3auyfe55C1K/GFlva3h2ZTNSZxHibq
         KGxmTpgkO1l4aB1u3NUrlu8bc6gP+D4lk+F752sv76pAfgvnXQa1E0uqtrYA8YP5+d0HYLt1LO9rnh
         T6v/kpHAJO4+S2k2o2qT8MFj4h0pAJw==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 13 Apr 2021 10:19:34 +0300
Date:   Tue, 13 Apr 2021 10:19:30 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     system@metrotek.ru, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <20210413071930.52vfjkewkufl7hrb@dhcp-179.ddg>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
 <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
 <YHTacMwlsR8Wl5q/@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHTacMwlsR8Wl5q/@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 01:40:32AM +0200, Andrew Lunn wrote:
> On Mon, Apr 12, 2021 at 03:16:59PM +0300, Ivan Bornyakov wrote:
> > Some SFP modules uses RX_LOS for link indication. In such cases link
> > will be always up, even without cable connected. RX_LOS changes will
> > trigger link_up()/link_down() upstream operations. Thus, check that SFP
> > link is operational before actual read link status.
> 
> Sorry, but this is not making much sense to me.
> 
> LOS just indicates some sort of light is coming into the device. You
> have no idea what sort of light. The transceiver might be able to
> decode that light and get sync, it might not. It is important that
> mv2222_read_status() returns the line side status. Has it been able to
> achieve sync? That should be independent of LOS. Or are you saying the
> transceiver is reporting sync, despite no light coming in?
> 
> 	Andrew

Yes, with some SFP modules transceiver is reporting sync despite no
light coming in. So, the idea is to check that link is somewhat
operational before determing line-side status. 

