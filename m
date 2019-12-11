Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CACCC11A43C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 06:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfLKF6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 00:58:31 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:59003
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725800AbfLKF6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 00:58:31 -0500
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 95F1520AF8;
        Wed, 11 Dec 2019 05:58:23 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 11 Dec 2019 06:58:23 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>, khc@pm.waw.pl,
        gregkh <gregkh@linuxfoundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Networking <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org, Kevin Curtis <kevin.curtis@farsite.com>,
        "R.J.Dunlop" <bob.dunlop@farsite.com>,
        Qiang Zhao <qiang.zhao@nxp.com>
Subject: Re: [PATCH 4/4] [RFC] staging/net: move AF_X25 into drivers/staging
Organization: TDT AG
In-Reply-To: <CAK8P3a0X7fYFTHTQbNB56tcnAxwM9HvrLWwDkH49bGKbqSByMw@mail.gmail.com>
References: <20191209151256.2497534-1-arnd@arndb.de>
 <20191209151256.2497534-4-arnd@arndb.de>
 <20191209.102950.2248756181772063368.davem@davemloft.net>
 <CAK8P3a25UGV1KS1ufZsyQJk1+9Rp9is0x6eOU7pr5Xf6Z3N2gA@mail.gmail.com>
 <407acd92c92c3ba04578da89b1a0f191@dev.tdt.de>
 <CAK8P3a0X7fYFTHTQbNB56tcnAxwM9HvrLWwDkH49bGKbqSByMw@mail.gmail.com>
Message-ID: <0b117c3e34891c771ddb54815cff76d9@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-10 14:51, Arnd Bergmann wrote:
> On Tue, Dec 10, 2019 at 9:59 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> On 2019-12-09 20:26, Arnd Bergmann wrote:
>> > On Mon, Dec 9, 2019 at 7:29 PM David Miller <davem@davemloft.net>
>> > wrote:
>> >>
>> >> From: Arnd Bergmann <arnd@arndb.de>
>> >> Date: Mon,  9 Dec 2019 16:12:56 +0100
>> >>
>> >> > syzbot keeps finding issues in the X.25 implementation that nobody is
>> >> > interested in fixing.  Given that all the x25 patches of the past years
>> >> > that are not global cleanups tend to fix user-triggered oopses, is it
>> >> > time to just retire the subsystem?
>> >>
>> >> I have a bug fix that I'm currently applying to 'net' right now
>> >> actually:
>> >>
>> >>         https://patchwork.ozlabs.org/patch/1205973/
>> >>
>> >> So your proposal might be a bit premature.
>> >
>> > Ok, makes sense. Looking back in the history, I also see other bugfixes
>> > from the same author.
>> >
>> > Adding Martin Schiller to Cc: for a few questions:
>> >
>> > - What hardware are you using for X.25?
>> 
>> I would say that X.25 is (at least in Germany) not dead yet. For
>> example, it is still used in the railway network of the Deutsche Bahn 
>> AG
>> in many different areas. [1]
>> 
>> We deliver products for this and use the Linux X.25 stack with some
>> bugfixes and extensions that I would like to get upstream.
> 
> Right, when I looked for possible users, I found several examples
> where X.25 is still relevant, my impression was just that none of those
> were using the mainline Linux network stack.
> 
> Thank you for clarifying that.
> 
>> As hardware/interfaces we use X.21bis/G.703 adapters, which are
>> connected via
>> HDLC_X25 and LAPB. Also for this there are extensions and bugfixes,
>> which I  would like to include in the kernel.
> 
>> > - Would you be available to be listed in the MAINTAINERS file
>> >   as a contact for net/x25?
>> 
>> Yes, you can add me to the MAINTAINERS file.
>> I have only limited time, but I will try to follow all requests
>> concerning this subsystem.
> 
> Great! I don't expect there to be a lot of work, but it definitely 
> helps
> to have someone who can look at the occasional build failure or
> code cleanup patch.
> 
> If this works for everyone, I'd submit the following patch:
> 
> commit b63caa9a8d86a5bfc64052bf9aab9b22181120fd (HEAD)
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Tue Dec 10 14:28:39 2019 +0100
> 
>     MAINTAINERS: add new X.25 maintainer
> 
>     Martin Schiller is using the Linux X.25 stack on top of HDLC and
>     X.21 networks. He agreed to be listed as a maintainer to take
>     care of odd fixes.
> 
>     Add him as the primary contact for net/x25 and net/lapb, as well
>     as a reviewer for drivers/net/wan, which contains the HDLC code.
> 
>     Cc: Martin Schiller <ms@dev.tdt.de>
>     Cc: Andrew Hendry <andrew.hendry@gmail.com>
>     Cc: Krzysztof Halasa <khc@pm.waw.pl>
>     Link:
> https://lore.kernel.org/netdev/407acd92c92c3ba04578da89b1a0f191@dev.tdt.de/
>     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 

ACK!

Acked-by: Martin Schiller <ms@dev.tdt.de>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8e58410a799a..00b624b96103 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6889,6 +6889,7 @@ F:        
> Documentation/i2c/muxes/i2c-mux-gpio.rst
> 
>  GENERIC HDLC (WAN) DRIVERS
>  M:     Krzysztof Halasa <khc@pm.waw.pl>
> +R:     Martin Schiller <ms@dev.tdt.de>
>  W:     http://www.kernel.org/pub/linux/utils/net/hdlc/
>  S:     Maintained
>  F:     drivers/net/wan/c101.c
> @@ -9255,13 +9256,6 @@ S:       Maintained
>  F:     arch/mips/lantiq
>  F:     drivers/soc/lantiq
> 
> -LAPB module
> -L:     linux-x25@vger.kernel.org
> -S:     Orphan
> -F:     Documentation/networking/lapb-module.txt
> -F:     include/*/lapb.h
> -F:     net/lapb/
> -
>  LASI 53c700 driver for PARISC
>  M:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>  L:     linux-scsi@vger.kernel.org
> @@ -17911,11 +17905,16 @@ S:    Maintained
>  N:     axp[128]
> 
>  X.25 NETWORK LAYER
> +M:     Martin Schiller <ms@dev.tdt.de>
>  M:     Andrew Hendry <andrew.hendry@gmail.com>
>  L:     linux-x25@vger.kernel.org
>  S:     Odd Fixes
>  F:     Documentation/networking/x25*
> +F:     Documentation/networking/lapb-module.txt
> +F:     include/linux/lapb.h
>  F:     include/net/x25*
> +F:     include/uapi/linux/x25.h
> +F:     net/lapb/
>  F:     net/x25/
> 
>  X86 ARCHITECTURE (32-BIT AND 64-BIT)
> 
> -----
>> > - Does your bug fix address the latest issue found by syzbot[1],
>> >   or do you have an idea to fix it if not?
>> 
>> I don't have a direct solution for the concrete problem mentioned 
>> above,
>> but at
>> first sight I would say that the commit 95d6ebd53c79 ("net/x25: fix
>> use-after-free in x25_device_event()") holds the wrong lock
>> (&x25_list_lock).
>> Shouldn't this be the lock &x25_neigh_list_lock as in x25_get_neigh(),
>> where x25_neigh_hold() is called?
> 
> After looking at it again, my best guess is something else:
> x25_wait_for_connection_establishment() calls 
> release_sock()/lock_sock()
> while waiting. At this point, a concurrent x25_connect() can
> overwrite the x25->neighbour variable, which needs to be checked
> again before calling x25_neigh_put().
> 

That's a good point. I wonder why any further call to x25_connect() on
the same socket isn't simply returning (EALREADY) as long as
sock->state == SS_CONNECTING?

Martin
