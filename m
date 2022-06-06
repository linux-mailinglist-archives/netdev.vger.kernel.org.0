Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F79753ECD0
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiFFROA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 13:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiFFRNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 13:13:45 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E703467B;
        Mon,  6 Jun 2022 10:03:56 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BA33440004;
        Mon,  6 Jun 2022 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654535035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BeTjfg5dR7YkIvFUJwxUXcQIa0zY9mGXo3ppwn8z9N4=;
        b=JZFZXt07dNu0tB67Tt4wrJn7SjGk5WZURsmn1H6RPf9uUsiBYmcJ0ZfsKcphmPmqTCVu4M
        9W867m7aexyA0yeqHlMz1JiNbIsh0GF0mHsEAKbqah/+CcF4RAkqcUSyLoIhSHKCw2ppJE
        BjlKjIsYu4j71Nys2glpwcv0sd9jX3hAtLLZeuiL+n71RxhhDIPxR0jJZrQu68K3ZSsZgw
        S/IKVJAq4o7QLC6K6VDFLK1BwEgam49UfAYY/TzSnAVJ7v6FdnoSHp047wqIt61s8EDNdi
        /ZPg/52S0mpLJS5A5n8iLOqF89tEt4JPNrlXMhiF7z9lURxekjaxBdzDZa1RGg==
Date:   Mon, 6 Jun 2022 19:03:51 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH wpan-next v4 00/11] ieee802154: Synchronous Tx support
Message-ID: <20220606190351.73f42faf@xps-13>
In-Reply-To: <CAK-6q+if-dNbpbneTfUtj6MrZXiYPq9npZfMkatXKo8cfU1m9w@mail.gmail.com>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
 <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
 <d844514c-771f-e720-407b-2679e430243a@datenfreihafen.org>
 <20220603195509.73cf888f@xps-13>
 <CAK-6q+if-dNbpbneTfUtj6MrZXiYPq9npZfMkatXKo8cfU1m9w@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

aahringo@redhat.com wrote on Fri, 3 Jun 2022 21:50:15 -0400:

> Hi,
> 
> On Fri, Jun 3, 2022 at 1:55 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Stefan, Alex,
> >
> > stefan@datenfreihafen.org wrote on Wed, 1 Jun 2022 23:01:51 +0200:
> >  
> > > Hello.
> > >
> > > On 01.06.22 05:30, Alexander Aring wrote:  
> > > > Hi,
> > > >
> > > > On Thu, May 19, 2022 at 11:06 AM Miquel Raynal
> > > > <miquel.raynal@bootlin.com> wrote:  
> > > >>
> > > >> Hello,
> > > >>
> > > >> This series brings support for that famous synchronous Tx API for MLME
> > > >> commands.
> > > >>
> > > >> MLME commands will be used during scan operations. In this situation,
> > > >> we need to be sure that all transfers finished and that no transfer
> > > >> will be queued for a short moment.
> > > >>  
> > > >
> > > > Acked-by: Alexander Aring <aahringo@redhat.com>  
> > >
> > > These patches have been applied to the wpan-next tree. Thanks!
> > >  
> > > > There will be now functions upstream which will never be used, Stefan
> > > > should wait until they are getting used before sending it to net-next.  
> > >
> > > Indeed this can wait until we have a consumer of the functions before pushing this forward to net-next. Pretty sure Miquel is happy to finally move on to other pieces of his puzzle and use them. :-)  
> >
> > Next part is coming!
> >
> > In the mean time I've experienced a new lockdep warning:
> >
> > All the netlink commands are executed with the rtnl taken.
> > In my current implementation, when I configure/edit a scan request or a
> > beacon request I take a scan_lock or a beacons_lock, so they may only
> > be taken after the rtnl in this case, which leads to this sequence of
> > events:
> > - the rtnl is taken (by the net core)
> > - the beacon's lock is taken
> >
> > But now in a beacon's work or an active scan work, what happens is:
> > - work gets woken up
> > - the beacon/scan lock is taken
> > - a beacon/beacon-request frame is transmitted
> > - the rtnl lock is taken during this transmission
> >
> > Lockdep then detects a possible circular dependency:
> > [  490.153387]        CPU0                    CPU1
> > [  490.153391]        ----                    ----
> > [  490.153394]   lock(&local->beacons_lock);
> > [  490.153400]                                lock(rtnl_mutex);
> > [  490.153406]                                lock(&local->beacons_lock);
> > [  490.153412]   lock(rtnl_mutex);
> >
> > So in practice, I always need to have the rtnl lock taken when
> > acquiring these other locks (beacon/scan_lock) which I think is far
> > from optimal.
> >  
> 
> *Note that those can also be false positives.
> 
> > 1# One solution is to drop the beacons/scan locks because they are not
> > useful anymore and simply rely on the rtnl.
> >  
> 
> depends on how long it will be held.
> 
> > 2# Another solution would be to change the mlme_tx() implementation to
> > finally not need the rtnl at all.
> >
> > Note that just calling ASSERT_RTNL() makes no difference in 2#, it
> > still means that I always need to acquire the rtnl before acquiring the
> > beacons/scan locks, which greatly reduces their usefulness and leads to
> > solution 1# in the end.
> >
> > IIRC I decided to introduce the rtnl to avoid ->ndo_stop() calls during
> > an MLME transmission. I don't know if it has another use there. If not,
> > we may perhaps get rid of the rtnl in mlme_tx() by really handling the
> > stop calls (but I was too lazy so far to do that).
> >
> > What direction would you advise?  
> 
> Hard to say without code. Please show us some code of the current
> state... there should also be some stacktrace of the circular lock
> dependency, please provide the full output _matching_ the provided
> code.

Of course, here is the branch that I used to produce the warning:
https://github.com/miquelraynal/linux/ branch wpan-next/scan

Triggering this is just a matter or executing nl802154_send_beacons().
And here is the trace which appears in the dmesg:

[  234.224911] mac802154_hwsim mac802154_hwsim: Added 2 mac802154 hwsim hardware radios
[  257.846221] Sending beacon

[  257.847439] ======================================================
[  257.847446] WARNING: possible circular locking dependency detected
[  257.847463] 5.18.0-rc4-uwb+ #217 Not tainted
[  257.847473] ------------------------------------------------------
[  257.847479] kworker/u4:4/53 is trying to acquire lock:
[  257.847488] ffffffff9d049d48 (rtnl_mutex){+.+.}-{3:3}, at: ieee802154_mlme_tx+0xf/0x160 [mac802154]
[  257.847577] 
               but task is already holding lock:
[  257.847584] ffff89b082ea7ae0 (&local->beacons_lock){+.+.}-{3:3}, at: mac802154_beacons_work+0x1d/0xb0 [mac802154]
[  257.847651] 
               which lock already depends on the new lock.

[  257.847668] 
               the existing dependency chain (in reverse order) is:
[  257.847674] 
               -> #1 (&local->beacons_lock){+.+.}-{3:3}:
[  257.847702]        __mutex_lock+0x9d/0x9a0
[  257.847719]        mac802154_send_beacons+0x32/0x80 [mac802154]
[  257.847767]        nl802154_send_beacons+0xd7/0x1f0 [ieee802154]
[  257.847829]        genl_family_rcv_msg_doit+0xe5/0x140
[  257.847842]        genl_rcv_msg+0xd7/0x1e0
[  257.847852]        netlink_rcv_skb+0x4c/0xf0
[  257.847862]        genl_rcv+0x1f/0x30
[  257.847871]        netlink_unicast+0x191/0x260
[  257.847882]        netlink_sendmsg+0x22e/0x480
[  257.847892]        sock_sendmsg+0x59/0x60
[  257.847907]        ____sys_sendmsg+0x20c/0x260
[  257.847922]        ___sys_sendmsg+0x7c/0xc0
[  257.847932]        __sys_sendmsg+0x54/0xa0
[  257.847942]        do_syscall_64+0x3b/0x90
[  257.847956]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  257.847972] 
               -> #0 (rtnl_mutex){+.+.}-{3:3}:
[  257.847989]        __lock_acquire+0x1253/0x22e0
[  257.848002]        lock_acquire+0xca/0x2f0
[  257.848011]        __mutex_lock+0x9d/0x9a0
[  257.848023]        ieee802154_mlme_tx+0xf/0x160 [mac802154]
[  257.848058]        ieee802154_mlme_tx_one+0x2d/0x40 [mac802154]
[  257.848092]        mac802154_beacons_work.cold+0x100/0x110 [mac802154]
[  257.848135]        process_one_work+0x26f/0x5a0
[  257.848147]        worker_thread+0x4a/0x3d0
[  257.848158]        kthread+0xee/0x120
[  257.848168]        ret_from_fork+0x22/0x30
[  257.848180] 
               other info that might help us debug this:

[  257.848187]  Possible unsafe locking scenario:

[  257.848192]        CPU0                    CPU1
[  257.848198]        ----                    ----
[  257.848203]   lock(&local->beacons_lock);
[  257.848215]                                lock(rtnl_mutex);
[  257.848226]                                lock(&local->beacons_lock);
[  257.848236]   lock(rtnl_mutex);
[  257.848246] 
                *** DEADLOCK ***

[  257.848252] 3 locks held by kworker/u4:4/53:
[  257.848262]  #0: ffff89b0b66b4138 ((wq_completion)phy0){+.+.}-{0:0}, at: process_one_work+0x1ef/0x5a0
[  257.848290]  #1: ffffa021404e3e78 ((work_completion)(&(&local->beacons_work)->work)){+.+.}-{0:0}, at: process_one_work+0x1ef/0x5a0
[  257.848317]  #2: ffff89b082ea7ae0 (&local->beacons_lock){+.+.}-{3:3}, at: mac802154_beacons_work+0x1d/0xb0 [mac802154]
[  257.848371] 
               stack backtrace:
[  257.848388] CPU: 1 PID: 53 Comm: kworker/u4:4 Not tainted 5.18.0-rc4-uwb+ #217
[  257.848404] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[  257.848422] Workqueue: phy0 mac802154_beacons_work [mac802154]
[  257.848472] Call Trace:
[  257.848490]  <TASK>
[  257.848507]  dump_stack_lvl+0x45/0x59
[  257.848536]  check_noncircular+0xfe/0x110
[  257.848559]  __lock_acquire+0x1253/0x22e0
[  257.848581]  lock_acquire+0xca/0x2f0
[  257.848592]  ? ieee802154_mlme_tx+0xf/0x160 [mac802154]
[  257.848638]  __mutex_lock+0x9d/0x9a0
[  257.848652]  ? ieee802154_mlme_tx+0xf/0x160 [mac802154]
[  257.848690]  ? mark_held_locks+0x49/0x70
[  257.848701]  ? ieee802154_mlme_tx+0xf/0x160 [mac802154]
[  257.848737]  ? _raw_spin_unlock_irqrestore+0x28/0x50
[  257.848753]  ? lockdep_hardirqs_on+0x79/0x100
[  257.848770]  ? ieee802154_mlme_tx+0xf/0x160 [mac802154]
[  257.848804]  ieee802154_mlme_tx+0xf/0x160 [mac802154]
[  257.848841]  ieee802154_mlme_tx_one+0x2d/0x40 [mac802154]
[  257.848878]  mac802154_beacons_work.cold+0x100/0x110 [mac802154]
[  257.848924]  process_one_work+0x26f/0x5a0
[  257.848944]  worker_thread+0x4a/0x3d0
[  257.848959]  ? process_one_work+0x5a0/0x5a0
[  257.848971]  kthread+0xee/0x120
[  257.848981]  ? kthread_complete_and_exit+0x20/0x20
[  257.848995]  ret_from_fork+0x22/0x30
[  257.849022]  </TASK>
