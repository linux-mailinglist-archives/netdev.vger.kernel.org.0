Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0980C381BCB
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 02:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhEPAHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 20:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhEPAH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 20:07:29 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB073C061573
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 17:06:15 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 59DEB92009C; Sun, 16 May 2021 02:06:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 53C5E92009B;
        Sun, 16 May 2021 02:06:09 +0200 (CEST)
Date:   Sun, 16 May 2021 02:06:09 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Arnd Bergmann <arnd@kernel.org>
cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
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
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
Message-ID: <alpine.DEB.2.21.2105160145080.3032@angie.orcam.me.uk>
References: <20210515221320.1255291-1-arnd@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 May 2021, Arnd Bergmann wrote:

> For the ISA drivers, there is usually no way to probe multiple devices
> at boot time other than the netdev= arguments, so all that logic is left
> in place for the moment, but centralized in a single file that only gets
> included in the kernel build if one or more of the drivers are built-in.

 As I recall at least some ISA drivers did probe multiple interfaces in 
their monolithic configuration; I used a configuration with as many as 
five ne2k clones for a bridge machine for a fairly large network (~300 
machines) and as I recall it required no command-line parameters (but then 
it was some 25 years ago, so I may well not remember correctly anymore).  
It may have been with ISA PnP though (damn!).

 For modular drivers it was deemed too dangerous, for obvious reasons, and 
explicit parameters were the only way.

> * Most of ISA drivers could be trivially converted to use the module_init()
>   entry point, which would slightly change the command line syntax and
>   still support a single device of that type, but not more than one. We
>   could decide that this is fine, as few users remain that have any of
>   these devices, let alone more than one.
> 
> * Alternatively, the fact that the ISA drivers have never been cleaned
>   up can be seen as an indication that there isn't really much remaining
>   interest in them. We could move them to drivers/staging along with the
>   consolidated contents of drivers/net/Space.c and see if anyone still
>   uses them and eventually remove the ones that nobody has.

 I have a 3c509b interface in active use (although in the EISA mode, so no 
need for weird probing, but it can be reconfigured), and I have an ne2k 
clone in storage, so I could do some run-time verification if there is no 
one else available.  I'll see if I can do some driver polishing for these 
devices, but given the number of other tasks on my table this is somewhat 
low priority for me.

  Maciej
