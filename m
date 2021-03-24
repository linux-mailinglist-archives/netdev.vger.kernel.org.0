Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E38347814
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 13:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhCXMQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 08:16:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232574AbhCXMQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 08:16:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lP2QQ-00Clxp-JU; Wed, 24 Mar 2021 13:15:50 +0100
Date:   Wed, 24 Mar 2021 13:15:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Don Bollinger <don@thebollingers.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YFstdr1tgRk4jQwJ@lunn.ch>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
 <1616433075-27051-2-git-send-email-moshe@nvidia.com>
 <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org>
 <YFk13y19yMC0rr04@lunn.ch>
 <3e78a1cd-e63d-142a-3b78-511238e48bef@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e78a1cd-e63d-142a-3b78-511238e48bef@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> OK, so following the comments here, I will ignore backward compatibility of
> having global offset and length.

Yes, we can do that in userspace.

> That means I assume in this KAPI I am asked to get data from specific page.
> Should I also require user space to send page number to this KAPI (I mean
> make page number mandatory) ?

It makes the API more explicit. We always need the page, so if it is
not passed you need to default to something. As with addresses, you
have no way to pass back what page was actually read. So yes, make it
mandatory.

And i suppose the next question is, do we make bank mandatory? Once
you have a page > 0x10, you need the bank. Either we need to encode
the logic of when a bank is needed, and make it mandatory then, or it
is always mandatory.

Given the general pattern, we make it mandatory.

But sometime in the future when we get yet another SFP format, with
additional parameters, they will be optional, in order to keep
backwards compatibility.

	  Andrew

