Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B50199C5C
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgCaRAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:00:47 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39100 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbgCaRAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:00:46 -0400
Received: by mail-qk1-f193.google.com with SMTP id b62so23817135qkf.6
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 10:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=sKmalB8mEbfeA+ItF9L3+zgLke+ptnCpTfwDhEC9Nd0=;
        b=GGcokJqD3HPJ4ZlpU+fi1kXj43D47Q0TUyze20FJgHb5duGu0bVy1pTDMDSXElQfnI
         izbzBGiisAizJZHJZ08o3hbTKs3WCWQXf+7W3waEGGfUQyoVzjkt+1Dhcl3fKSuub7/L
         bKDTwTkHUPd+qM4DEQrWt/qqIZarP7oP+OYE3gEx/Lg7Q3cDc1Dg09FyYc1NPBnZ09UG
         l15j/HmQYRELDJMuRF1xnBH0Hl2fG5CtOSGv33X0DZXYyYnSX+jnhdsf5/tiuSh5bRXD
         zhSjKt/GfuCT31EuR6qcBe+yGsgCMvZ2LxqVat7wKSaigG+Vwwt2tyqALqdR15u0f8v9
         X2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=sKmalB8mEbfeA+ItF9L3+zgLke+ptnCpTfwDhEC9Nd0=;
        b=NdsXR6qcEYj/fh66km0Dll0RpAoZIY/yJ7EEUwpuICLcbRZ+JRnl0r4HpC4rNfh4i/
         IiOG3QLG0qpdMTZD7o7Ozy/S1rI9O5lgEVbPQ+3by4Vi9zMHO+hioFVncb4Jn6HqT9P0
         wtjfDKBJJrlqBggCwjzyWPaju2B57+WaSd7lNdzFpGu0N1Ku8czDp3LQO4Yhly/PzQdM
         LWe6QhwI3PUHDUsZA9G8jJrSk9aM1RwkuvrVrKE+r8q6hYesv7mZExX1POYoZ3FzaJsk
         C/5Z/Oil9uqPk3uHBoCWF/bXbCKoWu06gKyf3q9heYw3qLyUNDF/Za7gDKk8OCCpK7kC
         WHTg==
X-Gm-Message-State: ANhLgQ1zU87fV+7Cz5wNCYZmNoN6LKnmPNsdQ8yOFULKGD7zRsM0sZe9
        SNY1GAFfVW7LVkUrvTdHfDdcdJ9yv2I=
X-Google-Smtp-Source: ADFU+vuqFbpaLxb1ab2SiMualK+BCK0TzmNr5n+aBggtLZVT7by3M7s85I1eTE4CorOK58BdWsZhAg==
X-Received: by 2002:a37:68d2:: with SMTP id d201mr6149842qkc.231.1585674044927;
        Tue, 31 Mar 2020 10:00:44 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x37sm14140737qtc.90.2020.03.31.10.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 10:00:43 -0700 (PDT)
Date:   Tue, 31 Mar 2020 13:00:42 -0400
Message-ID: <20200331130042.GB1403168@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, ioana.ciornei@nxp.com,
        olteanv@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: fix oops while probing Marvell DSA
 switches
In-Reply-To: <E1jJHhw-0004UO-OJ@rmk-PC.armlinux.org.uk>
References: <E1jJHhw-0004UO-OJ@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Mar 2020 15:17:36 +0100, Russell King <rmk+kernel@armlinux.org.uk> wrote:
> Fix an oops in dsa_port_phylink_mac_change() caused by a combination
> of a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA
> ports unless needed") and the net-dsa-improve-serdes-integration
> series of patches 65b7a2c8e369 ("Merge branch
> 'net-dsa-improve-serdes-integration'").
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000124
> pgd = c0004000
> [00000124] *pgd=00000000
> Internal error: Oops: 805 [#1] SMP ARM
> Modules linked in: tag_edsa spi_nor mtd xhci_plat_hcd mv88e6xxx(+) xhci_hcd armada_thermal marvell_cesa dsa_core ehci_orion libdes phy_armada38x_comphy at24 mcp3021 sfp evbug spi_orion sff mdio_i2c
> CPU: 1 PID: 214 Comm: irq/55-mv88e6xx Not tainted 5.6.0+ #470
> Hardware name: Marvell Armada 380/385 (Device Tree)
> PC is at phylink_mac_change+0x10/0x88
> LR is at mv88e6352_serdes_irq_status+0x74/0x94 [mv88e6xxx]
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
