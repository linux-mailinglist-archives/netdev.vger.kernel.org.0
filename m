Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7611F1E2A1F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgEZSdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgEZSdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:33:11 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 919F72068D;
        Tue, 26 May 2020 18:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590517991;
        bh=zqqKYGDqYq+jWP/jsl64bWcD9Pu4bJsseF9495JaNws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xoKoTwDBiy/RtF4geXCUT9O945JVCDIyVCuaAHHe/qgGUoSZxbRMT8nvmG0FfT7t1
         OkkLZoLpkyFRoImhyuBgbQ+iIOnvHNyanKx9oppQJljEQ4c3Hz99pda6K1cI4MsypW
         VS+ABpkVNrs7NQ3kBwrCqLL2vkSrVB88TiRRb/kE=
Date:   Tue, 26 May 2020 11:33:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next RFC v3 2/6] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200526113309.1c46d496@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200526171302.28649-3-vadym.kochan@plvision.eu>
References: <20200526171302.28649-1-vadym.kochan@plvision.eu>
        <20200526171302.28649-3-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 20:12:58 +0300 Vadym Kochan wrote:
> Add PCI interface driver for Prestera Switch ASICs family devices, which
> provides:
> 
>     - Firmware loading mechanism
>     - Requests & events handling to/from the firmware
>     - Access to the firmware on the bus level
> 
> The firmware has to be loaded each time device is reset. The driver is
> loading it from:
> 
>     /lib/firmware/marvell/prestera_fw-v{MAJOR}.{MINOR}.img
> 
> The full firmware image version is located within internal header and
> consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
> hard-coded minimum supported firmware version which it can work with:
> 
>     MAJOR - reflects the support on ABI level between driver and loaded
>             firmware, this number should be the same for driver and loaded
>             firmware.
> 
>     MINOR - this is the minimum supported version between driver and the
>             firmware.
> 
>     PATCH - indicates only fixes, firmware ABI is not changed.
> 
> Firmware image file name contains only MAJOR and MINOR numbers to make
> driver be compatible with any PATCH version.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>

W=1 gives me:

drivers/net/ethernet/marvell/prestera/prestera_pci.c: In function prestera_fw_rev_check:
drivers/net/ethernet/marvell/prestera/prestera_pci.c:590:15: warning: comparison is always true due to limited range of data type [-Wtype-limits]
  590 |      rev->min >= PRESTERA_SUPP_FW_MIN_VER) {
      |               ^~
