Return-Path: <netdev+bounces-1873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 561B16FF611
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C4BE28146C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83E9641;
	Thu, 11 May 2023 15:34:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9DA629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:34:29 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F75D559F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=JaUOMAwWPoxX7PGKWZzAjX2xPVWnbLnXWmeVJl45UHU=; b=ho
	TqRUe+N93MzANpWilEp6Rrso+PgBkl9xykAMBFjERNOTnf1PjTO5v9bSEMyKcaGbCtA7rKmXg04li
	HOHQs7bFe/Zzz3Bsqa4IeV5Xu6zlQCAJ9o3mNQ+PX/MBWm9scFGLDWBvpRRUWSJvUaTRb+kNMNhho
	Mtbm23KZPAoE5Ls=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1px8JE-00CZTm-LG; Thu, 11 May 2023 17:34:24 +0200
Date: Thu, 11 May 2023 17:34:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Ron Eggler <ron.eggler@mistywest.com>
Cc: netdev@vger.kernel.org
Subject: Re: PHY VSC8531 MDIO data not reflected in ethernet/ sub-module
Message-ID: <69d0d5d9-5ed0-4254-adaf-cf3f85c103b9@lunn.ch>
References: <2cc45d13-78e5-d5c1-3147-1b44efc6a291@mistywest.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2cc45d13-78e5-d5c1-3147-1b44efc6a291@mistywest.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> ***[ 6.728165] DEBUG: in ravb_emac_init_gbeth(), calling
> ravb_set_rate_gbeth(), priv->duplex: 0, priv->speed: 0*
> ***[ 6.751973] DEBUG: in ravb_set_rate_gbeth() - priv->speed 0*
> ***[ 6.831153] DEBUG: in ravb_adjust_link(), phydev->speed -1, priv->speed
> 0*
> ***[ 6.839952] DEBUG: in ravb_adjust_link(), priv->no_avb_link 0,
> phydev->link 0*

If there is no link, everything else is meaningless. You cannot have
speed without link.

> While I also receive the following using the mii-tool utility:
> # mii-tool -vv eth0
> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 1000baseT-FD flow-control, link ok
>   registers for MII PHY 0:
>     1040 796d 0007 0572 01e1 cde1 000f 2001
>     4006 0300 7800 0000 0000 4002 0000 3000
>     0000 f000 0088 0000 0000 0001 3200 1000
>     0000 0000 0000 0000 a035 0054 0400 0000
>   product info: vendor 00:01:c1, model 23 rev 2
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD
>   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD flow-control

Assuming you are not using interrupts, phylib will poll the PHY once a
second, calling
phy_check_link_status()->
  phy_read_status()->
    phydev->drv->read_status()
or
    genphy_read_status()

Check what these are doing, why do they think the link is down.

      Andrew

