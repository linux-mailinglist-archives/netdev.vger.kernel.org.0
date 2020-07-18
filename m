Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAD8224C67
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgGRPWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 11:22:47 -0400
Received: from lists.nic.cz ([217.31.204.67]:52938 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgGRPWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 11:22:46 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id E64E9140527;
        Sat, 18 Jul 2020 17:22:44 +0200 (CEST)
Date:   Sat, 18 Jul 2020 17:22:44 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Healy <cphealy@gmail.com>, netdev <netdev@vger.kernel.org>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber
 with vf610-zii-dev-rev-c
Message-ID: <20200718172244.59576938@nic.cz>
In-Reply-To: <20200718150514.GC1375379@lunn.ch>
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com>
        <20200718164239.40ded692@nic.cz>
        <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com>
        <20200718150514.GC1375379@lunn.ch>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jul 2020 17:05:14 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > If the traces were broken between the fiber module and the SERDES, I
> > should not see these counters incrementing.  
> 
> Plus it is reproducible on multiple boards, of different designs.
> 
> This is somehow specific to the 6390X ports 9 and 10.
> 
>      Andrew

Hmm.

What about the errata setup?
It says:
/* The 6390 copper ports have an errata which require poking magic
 * values into undocumented hidden registers and then performing a
 * software reset.
 */
But then the port_hidden_write function is called for every port in the
function mv88e6390_setup_errata, not just for copper ports. Maybe Chris
should try to not write this hidden register for SerDes ports.

Marek
