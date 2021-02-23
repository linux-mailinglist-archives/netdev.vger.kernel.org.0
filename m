Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B6E32280C
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 10:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhBWJtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhBWJsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 04:48:22 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDAFC06174A;
        Tue, 23 Feb 2021 01:47:42 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lEUHz-007Iqu-8F; Tue, 23 Feb 2021 10:47:31 +0100
Message-ID: <7909a51a9b234932e1761484a1c2ab5d8fa16317.camel@sipsolutions.net>
Subject: Re: [PATCH net v1 3/3] [RFC] mac80211: ieee80211_store_ack_skb():
 make use of skb_clone_sk_optional()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org
Date:   Tue, 23 Feb 2021 10:47:22 +0100
In-Reply-To: <20210222185141.oma64d4uq64pys45@pengutronix.de>
References: <20210222151247.24534-1-o.rempel@pengutronix.de>
         <20210222151247.24534-4-o.rempel@pengutronix.de>
         <3823be537c3c138de90154835573113c6577188e.camel@sipsolutions.net>
         <20210222185141.oma64d4uq64pys45@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-22 at 19:51 +0100, Marc Kleine-Budde wrote:
> On 22.02.2021 17:30:59, Johannes Berg wrote:
> > On Mon, 2021-02-22 at 16:12 +0100, Oleksij Rempel wrote:
> > > This code is trying to clone the skb with optional skb->sk. But this
> > > will fail to clone the skb if socket was closed just after the skb was
> > > pushed into the networking stack.
> > 
> > Which IMHO is completely fine. If we then still clone the SKB we can't
> > do anything with it, since the point would be to ... send it back to the
> > socket, but it's gone.
> 
> Ok, but why is the skb cloned if there is no socket linked in skb->sk?

Hm? There are two different ways to get here, one with and one without a
socket.

johannes

