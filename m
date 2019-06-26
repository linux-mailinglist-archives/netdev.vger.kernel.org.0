Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CE4572A7
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFZUh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:37:59 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43400 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfFZUh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:37:59 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgEg0-00060x-R6; Wed, 26 Jun 2019 22:37:56 +0200
Date:   Wed, 26 Jun 2019 22:37:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ran Rozenstein <ranro@mellanox.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Message-ID: <20190626203756.scm4qwookyz5l3un@breakpoint.cc>
References: <20190617140228.12523-1-fw@strlen.de>
 <08e102a0-8051-e582-56c8-d721bfc9e8b9@mellanox.com>
 <AM4PR0501MB276924D7AD83B349AA2A6A0BC5E30@AM4PR0501MB2769.eurprd05.prod.outlook.com>
 <20190625091903.gepfjgpiksslnyqy@breakpoint.cc>
 <AM4PR0501MB2769CE8DC11EE4A076B62CCCC5E20@AM4PR0501MB2769.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB2769CE8DC11EE4A076B62CCCC5E20@AM4PR0501MB2769.eurprd05.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ran Rozenstein <ranro@mellanox.com> wrote:
> The test dose stress on the interface by running this 2 commands in loop:
> 
> command is: /sbin/ip -f inet addr add $IP/16 brd + dev ens8f1
> command is: ifconfig ens8f1 $IP netmask 255.255.0.0
> 
> when $IP change every iteration.
> 
> It execute every second when we see the reproduce somewhere between 40 to 200 seconds of execution.

I tried this without success:

DEV=dummy0
for j in $(seq 2 254);do
  for i in $(seq 2 254);do
    IP="10.$((RANDOM%254)).$((RANDOM%254)).$i"
    ip -f inet addr add $IP/16 brd + dev $DEV
    ifconfig $DEV $IP netmask 255.255.0.0
  done
done

I'll let this loop overnight, but so far nothing turned up in
dmesg (lockdep/kasan kernel).
