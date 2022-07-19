Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADE0578F81
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbiGSBDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiGSBDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:03:31 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78C6E29CB9;
        Mon, 18 Jul 2022 18:03:30 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id D8D70FFA1A;
        Tue, 19 Jul 2022 01:03:28 +0000 (UTC)
Date:   Tue, 19 Jul 2022 03:03:26 +0200
From:   Max Staudt <max@enpas.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] can: slcan: remove legacy infrastructure
Message-ID: <20220719030326.49f204f6.max@enpas.org>
In-Reply-To: <1dbd95e8-e6d7-a611-32d0-ea974787ff5a@hartkopp.net>
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
        <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com>
        <20220717233842.1451e349.max@enpas.org>
        <6faf29c7-3e9d-bc21-9eac-710f901085d8@hartkopp.net>
        <20220718101507.eioy2bdcmjkgtacz@pengutronix.de>
        <1dbd95e8-e6d7-a611-32d0-ea974787ff5a@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 12:23:05 +0200
Oliver Hartkopp <socketcan@hartkopp.net> wrote:

> IMO it does not break user space when slcan gets the common naming 
> schema for CAN interface names.

For what it's worth, slcan provides a specific ioctl to resolve from
(tty fd) to (netdev name). As far as I can see, any sane program should
use this API to find whatever device it has created, irrespective of
the netdev name.


@ Marc: slcand and slcan_attach in can-utils do not depend on the
slcanX name, as far as I can see. They are the main interfaces to
slcan, and apart from that I can only think of scripts doing netlink
stuff and scanning for slcanX. Does this change your opinion, or is
breaking such scripts already a step too far?

I'm thinking that in other circumstances, I've had cases where devices
were numbered differently just because they enumerated faster or slower
at different boots, or with other kernel versions, or because of media
inserted, etc. - though renumbering is of course one step less than
changing the prefix.


> We had the same thing with 'eth0' which is now named enblablabla or 
> 'wlan0' now named wlp2s0.

Actually, the kernel still calls them ethX and wlanX. It's systemd+udev
that renames them to the "unique" names afterwards. It's an extra step
that happens in userspace.

udev is immensely useful, but also great stuff for race conditions :)



Max
