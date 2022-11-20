Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0929A631334
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 10:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiKTJeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 04:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKTJeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 04:34:10 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A661CFFE;
        Sun, 20 Nov 2022 01:34:05 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id F16D318833EC;
        Sun, 20 Nov 2022 09:33:57 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id E9CED2500516;
        Sun, 20 Nov 2022 09:33:57 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id BC6E491201E4; Sun, 20 Nov 2022 09:33:57 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 20 Nov 2022 10:33:57 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221115222312.lix6xpvddjbsmoac@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221115222312.lix6xpvddjbsmoac@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <b2067339924d0ed7dec25ab51b43a17c@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-15 23:23, Vladimir Oltean wrote:
> 
> How much (and what) do you plan to add to switchdev.{c,h} in the 
> future?
> It's a bit arbitrary to put only mv88e6xxx_handle_violation() in a file
> called switchdev.c.
> 
> port_fdb_add(), port_mdb_add(), port_vlan_add(), port_vlan_filtering(),
> etc etc, are all switchdev things. Anyway.
> 

Firstly, those functions you list are ops functions, while what is in
switchdev.{c,h} is not, secondly the functions in switchdev.{c,h} are 
the
first to send switchdev messages like SWITCHDEV_FDB_ADD_TO_BRIDGE 
events.

Furthermore I think that chip.c is bloated, but I also do plan to add 
more
to switchdev.{c,h}, and there can be others adding in the future...
