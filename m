Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B639066B
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfHPRFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 13:05:23 -0400
Received: from mail.nic.cz ([217.31.204.67]:33740 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbfHPRFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 13:05:22 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 394B9140CDF;
        Fri, 16 Aug 2019 19:05:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565975121; bh=x8L86W80XXo3KBte8Ib77YU49u6r2jeJ7zT2GiMxzlE=;
        h=Date:From:To;
        b=LjjpsjqMwAmnEG3qD6ftr5Di8Fwn29BhCn1shkVqfIu1iDTe1HSRLOwiI+vb+oxJa
         fHQMNad2yX9IrnHawUnIfYwDPS/ataHMR9C2TRUYf0nssKCjerTwWKy05CSwpUDdNI
         B73a7v3xIU3tnVhAMnE+PI97w456HtQgwVsXV/mY=
Date:   Fri, 16 Aug 2019 19:05:20 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH RFC net-next 3/3] net: dsa: mv88e6xxx: setup SERDES irq
 also for CPU/DSA ports
Message-ID: <20190816190520.57958fde@nic.cz>
In-Reply-To: <20190816122552.GC629@t480s.localdomain>
References: <20190816150834.26939-1-marek.behun@nic.cz>
        <20190816150834.26939-4-marek.behun@nic.cz>
        <20190816122552.GC629@t480s.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 12:25:52 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> So now we have mv88e6xxx_setup_port() and mv88e6xxx_port_setup(), which both
> setup a port, differently, at different time. This is definitely error prone.

Hmm. I don't know how much of mv88e6xxx_setup_port() could be moved to
this new port_setup(), since there are other setup functions called in
mv88e6xxx_setup() that can possibly depend on what was done by
mv88e6xxx_setup_port().

Maybe the new DSA operations should be called .after_setup()
and .before_teardown(), and be called just once for the whole switch,
not for each port?
