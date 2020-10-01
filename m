Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC36280355
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732671AbgJAP51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:57:27 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:42080 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732128AbgJAP50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:57:26 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d31 with ME
        id afxE2300B2lQRaH03fxLjb; Thu, 01 Oct 2020 17:57:24 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Thu, 01 Oct 2020 17:57:24 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 5/6] can: usb: etas_es58X: add support for ETAS ES58X CAN USB interfaces
Date:   Fri,  2 Oct 2020 00:56:41 +0900
Message-Id: <20201001155641.3421-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930161838.GB1663344@kroah.com>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr> <20200930144602.10290-6-mailhol.vincent@wanadoo.fr> <20200930161838.GB1663344@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	num_element =
> > +	    es58x_msg_num_element(es58x_dev->dev,
> > +				  bulk_rx_loopback_msg->rx_loopback_msg,
> > +				  msg_len);
> > +	if (unlikely(num_element <= 0))
> > +		return num_element;
> 
> Meta-comment on your use of 'unlikely' everywhere.  Please drop it, it's
> only to be used if you can actually measure the difference in a
> benchmark.  You are dealing with USB devices, which are really really
> slow here.  Also, humans make horrible guessers for this type of thing,
> the compiler and CPU can get this right much more often than we can, and
> we had the numbers for it (someone measured that 80-90% of our usages of
> these markings are actually wrong on modern cpus).
> 
> So just drop them all, it makes the code simpler to read and understand,
> and the cpu can actually go faster.

All those branch on which the unlikely() macro were applied were
supposed to never been executed under normal circumstances. But I
indeed have no benchmark to claim such use.

Thank you for the detailed explanation, makes perfect sense. Each use
of the likely()/unlikely() macros will be removed in v3 revision.
