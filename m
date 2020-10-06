Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1CC284FE4
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgJFQbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:31:47 -0400
Received: from mailout07.rmx.de ([94.199.90.95]:56426 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgJFQbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 12:31:47 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4C5NJv70GPzBtqq;
        Tue,  6 Oct 2020 18:31:43 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4C5NJY2FFWz2xKS;
        Tue,  6 Oct 2020 18:31:25 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.15) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Oct
 2020 18:30:58 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net v2] net: dsa: microchip: fix race condition
Date:   Tue, 6 Oct 2020 18:30:57 +0200
Message-ID: <1774255.9Jiduhijpd@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201006162125.ulftqdiufdxjesn7@skbuf>
References: <20201006155651.21473-1-ceggers@arri.de> <20201006162125.ulftqdiufdxjesn7@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.15]
X-RMX-ID: 20201006-183129-4C5NJY2FFWz2xKS-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, 6 October 2020, 18:21:25 CEST, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 05:56:51PM +0200, Christian Eggers wrote:
> > - Checking for mib_read_interval in ksz_switch_remove() can be obmitted,
> >   as the condition is always true when ksz_switch_remove() is called.
> 
> If there's an error in the probe path, I expect that the
> mib_read_interval will not get set, and the delayed workqueue will not
> be scheduled, will it? So I think the check is ok there.

If think that ksz_switch_remove() will not be called at all if there is an 
error in the probe path. In all other cases, the work should be queued.

Regards
Christian



