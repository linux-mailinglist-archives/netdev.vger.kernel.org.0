Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434DD2D3743
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgLHX61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:58:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbgLHX61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 18:58:27 -0500
Date:   Tue, 8 Dec 2020 15:57:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607471866;
        bh=zSy5op/jGCv17pkOLX915S+fxbyO1GasgZK/PQVb1x0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=EzHUgq8dwToEd+i/40Cfv1PIk2OCc77ngczpqv7uJScYlEvPr766WeGZLIwdRBYAa
         l/o8zifIpScWaW3gLS9xucyRtoGTEw0HyCVeyHkpiW8Y5GGssnKiGKmspPt6jH3D03
         0wvQDPl+ZGDA6Q9NaaperV7z7bC7GhW3m49H3IYp/Z0TcxlxmXJ7ezb0EcOOWHY4iR
         1JrwRJfu+l5H4W7ialE3IBcIVC+tjxrPEyErn0GHoajY6d5/9hUAlfylLFCwWa5/V8
         vScpnYcDCjds82+yfoPFhsPr6m4XKcJTKRumne1w0KCc7TjIgXXGgS1iT4BUvn1Xv4
         czPuNyHbmfYXA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Message-ID: <20201208155744.320d694b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207010040.eriknpcidft3qul6@skbuf>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
        <20201206235919.393158-6-vladimir.oltean@nxp.com>
        <20201207010040.eriknpcidft3qul6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 01:00:40 +0000 Vladimir Oltean wrote:
> - ensuring through convention that user space always takes
>   net->netdev_lists_lock when calling dev_get_stats, and documenting
>   that, and therefore making it unnecessary to lock in bonding.

This seems like the better option to me. Makes the locking rules pretty
clear.
