Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3105F7E4
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfGDMWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:22:00 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33462 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbfGDMV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:21:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hj0kL-0005pG-4r; Thu, 04 Jul 2019 14:21:53 +0200
Message-ID: <2f1a8edb0b000b4eb7adcaca0d1fb05fdd73a587.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 04 Jul 2019 14:21:52 +0200
In-Reply-To: <20190704121718.GS20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
         <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
         <20190703114933.GW2250@nanopsycho> <20190703181851.GP20101@unicorn.suse.cz>
         <20190704080435.GF2250@nanopsycho> <20190704115236.GR20101@unicorn.suse.cz>
         <6c070d62ffe342f5bc70556ef0f85740d04ae4a3.camel@sipsolutions.net>
         <20190704121718.GS20101@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-07-04 at 14:17 +0200, Michal Kubecek wrote:
> On Thu, Jul 04, 2019 at 02:03:02PM +0200, Johannes Berg wrote:
> > On Thu, 2019-07-04 at 13:52 +0200, Michal Kubecek wrote:
> > > 
> > > There is still the question if it it should be implemented as a nested
> > > attribute which could look like the current compact form without the
> > > "list" flag (if there is no mask, it's a list). Or an unstructured data
> > > block consisting of u32 bit length 
> > 
> > You wouldn't really need the length, since the attribute has a length
> > already :-)
> 
> It has byte length, not bit length. The bitmaps we are dealing with
> can have any bit length, not necessarily multiples of 8 (or even 32).

Not sure why that matters? You have the mask, so you don't really need
to additionally say that you're only going up to a certain bit?

I mean, say you want to set some bits <=17, why would you need to say
that they're <=17 if you have a
 value: 0b00000000'000000xx'xxxxxxxx'xxxxxxxx
 mask:  0b00000000'00000011'11111111'11111111

johannes

