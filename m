Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8D346C8AE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbhLHAc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:32:56 -0500
Received: from relay026.a.hostedemail.com ([64.99.140.26]:51746 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229503AbhLHAc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:32:56 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2021 19:32:55 EST
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id 37F7E20FC5;
        Wed,  8 Dec 2021 00:23:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id A41C52002A;
        Wed,  8 Dec 2021 00:23:20 +0000 (UTC)
Message-ID: <5b44cebddcda765942aa118d25740a074137d0f8.camel@perches.com>
Subject: Re: [PATCH 2/2] wilc1000: Fix missing newline in error message
From:   Joe Perches <joe@perches.com>
To:     David Mosberger-Tang <davidm@egauge.net>,
        Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Dec 2021 16:23:18 -0800
In-Reply-To: <00d44cb3-3b38-7bb6-474f-c819c2403b6a@egauge.net>
References: <20211206232709.3192856-1-davidm@egauge.net>
         <20211206232709.3192856-3-davidm@egauge.net>
         <4687b01640eaaba01b3db455a7951a534572ee31.camel@perches.com>
         <00d44cb3-3b38-7bb6-474f-c819c2403b6a@egauge.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A41C52002A
X-Spam-Status: No, score=-4.35
X-Stat-Signature: kqwa4ns4rtai67cewqax5n5aisczig7o
X-Rspamd-Server: rspamout08
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+9Fk+jLiyLjv0vbVVIihJWAYk+EQJbxQw=
X-HE-Tag: 1638923000-80965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-07 at 15:58 -0700, David Mosberger-Tang wrote:
> On 12/6/21 6:33 PM, Joe Perches wrote:
> 
> > On Mon, 2021-12-06 at 23:27 +0000, David Mosberger-Tang wrote:
> > > Add missing newline in pr_err() message.
> > []
> > > diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
> > []
> > > @@ -27,7 +27,7 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
> > >   	struct wilc *wilc = user_data;
> > >   
> > >   	if (wilc->close) {
> > > -		pr_err("Can't handle UH interrupt");
> > > +		pr_err("Can't handle UH interrupt\n");
> > Ideally this would use wiphy_<level>:
> > 
> > 		wiphy_err(wilc->wiphy, "Can't handle UH interrupt\n");
> 
> Sure, but that's orthogonal to this bug fix.

Of course.

> I do have a "cleanups" 
> branch with various cleanups of this sort.  I'll look into fixing pr_*() 
> calls in the cleanups branch (there are several of them, unsurprisingly).

netdev_<level> -> wiphy_<level> conversions too where feasible please.

