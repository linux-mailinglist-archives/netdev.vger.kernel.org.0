Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351993837BC
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 17:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244374AbhEQPqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 11:46:43 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:33450 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343834AbhEQPmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 11:42:13 -0400
X-Greylist: delayed 142485 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2021 11:42:13 EDT
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 575C492009E; Mon, 17 May 2021 17:40:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4D95892009D;
        Mon, 17 May 2021 17:40:50 +0200 (CEST)
Date:   Mon, 17 May 2021 17:40:50 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
cc:     Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [RFC 00/13] [net-next] drivers/net/Space.c cleanup
In-Reply-To: <20210517143805.GQ258772@windriver.com>
Message-ID: <alpine.DEB.2.21.2105171711270.3032@angie.orcam.me.uk>
References: <20210515221320.1255291-1-arnd@kernel.org> <20210517143805.GQ258772@windriver.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 May 2021, Paul Gortmaker wrote:

> Leaving the more popular cards was a concession to making progress vs.
> having the whole cleanup blocked by individuals who haven't yet realized
> that using ancient hardware is best done (only done?) with ancient kernels.

 Hmm, it depends on what you want to achieve, although I think it will be 
fair if you require anyone caring about old hardware to keep any relevant 
code base, such as drivers, board support, etc. up to date as our internal 
interfaces evolve.  Otherwise if it works, then I fail to see a reason to 
remove it just because you can.

> Maybe things are better now; people are putting more consideration to
> the future of the kernel, rather than clinging to times long past?
> We've since managed to delete several complete old arch dirs; which I
> had previously thought impossible.  I couldn't even git rid of the x86
> EISA support code six years ago.[1]

 Heh, that machine I raised my objection for is now back in service, after 
a failure of its industrial PSU and the installation of a replacement one 
(which was a bit of a challenge to track down), serving the maintenance of 
the defxx driver for the DEFEA (EISA) variant of the DEC FDDI network 
adapter:

platform eisa.0: Probing EISA bus 0
eisa 00:00: EISA: Mainboard AEI0401 detected
eisa 00:05: EISA: slot 5: DEC3002 detected
defxx: v1.12 2021/03/10  Lawrence V. Stefani and others
00:05: DEFEA at I/O addr = 0x5000, IRQ = 10, Hardware addr = 00-00-f8-c8-b3-b6
00:05: registered as fddi0
eisa 00:06: EISA: slot 6: NPI0303 detected
eisa 00:08: EISA: slot 8: TCM5094 detected
eth0: 3c5x9 found at 0x8000, 10baseT port, address 00:a0:24:b6:8b:db, IRQ 12.
platform eisa.0: EISA: Detected 3 cards

I just need to upgrade it with more DRAM (256MiB supported; not too bad 
for an i486) so that it runs a tad more smoothly.  An alternative would be 
switching to an EISA Alpha machine, however I don't have any at the moment 
and chasing one would be a bit of an issue.

 FAOD I keep getting contacted about the FDDI stuff as it remains in use 
in various industrial and scientific installations and the typical use 
case nowadays is getting whatever old gear, which has fallen apart, they 
have used to communicate with their equipment over FDDI with a modern 
Linux machine, preferably running out of the box with one of the readily 
available distributions, and one of those FDDI cards (normally the PCI 
variant though), which are reasonably available still.

> I'd be willing to do a "Phase 2" of 930d52c012b8 ISA net delete;  I'm
> not sure the bounce through stable on the way out does much other than
> muddy the git history.  I'd be tempted to just propose the individual
> deletes and see where that goes....

 Sounds fair to me.

  Maciej
