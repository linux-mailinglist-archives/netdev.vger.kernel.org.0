Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA01B34D57B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhC2QvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:51:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhC2Quz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 12:50:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQv6A-00DqUo-1x; Mon, 29 Mar 2021 18:50:42 +0200
Date:   Mon, 29 Mar 2021 18:50:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Kochetkov <fido_max@inbox.ru>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: dsa: Fix type was not set for devlink port
Message-ID: <YGIFYiYSGAnrjOiD@lunn.ch>
References: <20210329153016.1940552-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329153016.1940552-1-fido_max@inbox.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 06:30:16PM +0300, Maxim Kochetkov wrote:
> If PHY is not available on DSA port (described at devicetree but absent or
> failed to detect) then kernel prints warning after 3700 secs:
> 
> [ 3707.948771] ------------[ cut here ]------------
> [ 3707.948784] Type was not set for devlink port.
> [ 3707.948894] WARNING: CPU: 1 PID: 17 at net/core/devlink.c:8097 0xc083f9d8
> 
> We should unregister the devlink port as a user port and
> re-register it as an unused port before executing "continue" in case of
> dsa_port_setup error.
> 
> Fixes: 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")

This commit says:

    Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
    not treat failures to set-up an user port as fatal, but after this
    commit we would, which is a regression for some systems where interfaces
    may be declared in the Device Tree, but the underlying hardware may not
    be present (pluggable daughter cards for instance).

Florian

Are these daughter cards hot pluggable? So we expect them to appear
and the port is then usable? Or is a reboot required?

    Andrew
