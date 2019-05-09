Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98A0184C4
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 07:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfEIFOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 01:14:15 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:43967 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbfEIFOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 01:14:15 -0400
Received: from bootlin.com (lfbn-tou-1-417-253.w86-206.abo.wanadoo.fr [86.206.242.253])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 2CD8F200003;
        Thu,  9 May 2019 05:14:09 +0000 (UTC)
Date:   Thu, 9 May 2019 07:14:08 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: mvpp2: cls: Add missing NETIF_F_NTUPLE flag
Message-ID: <20190509071408.23eae42a@bootlin.com>
In-Reply-To: <20190507102803.09fcb56c@cakuba.hsd1.ca.comcast.net>
References: <20190507123635.17782-1-maxime.chevallier@bootlin.com>
        <20190507102803.09fcb56c@cakuba.hsd1.ca.comcast.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, David,

On Tue, 7 May 2019 10:28:03 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

>> -	if (mvpp22_rss_is_supported())
>> +	if (mvpp22_rss_is_supported()) {
>>  		dev->hw_features |= NETIF_F_RXHASH;
>> +		dev->features |= NETIF_F_NTUPLE;  
>
>Hm, why not in hw_features?

Because as of today, there's nothing implemented to disable
classification offload in the driver, so the feature can't be toggled.

Is this an issue ? Sorry if I'm doing this wrong, but I didn't see any
indication that this feature has to be host-writeable.

I can make so that it's toggle-able, but it's not as straightforward as
we would think, since the classifier is also used for RSS (so, we can't
just disable the classifier as a whole, we would have to invalidate
each registered flow).

Thanks,

Maxime
