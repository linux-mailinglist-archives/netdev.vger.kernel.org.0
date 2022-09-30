Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA455F14D3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 23:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiI3V2i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Sep 2022 17:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiI3V2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 17:28:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8D112EDA2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:28:35 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-60-btexz_hZP5eLBde4-fXgNg-1; Fri, 30 Sep 2022 22:28:31 +0100
X-MC-Unique: btexz_hZP5eLBde4-fXgNg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 30 Sep
 2022 22:28:31 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Fri, 30 Sep 2022 22:28:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Eric W. Biederman'" <ebiederm@xmission.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: RE: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Thread-Topic: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Thread-Index: AQHY1Ogi381Lc0KOOEGaF1/0a4qSLq34eHYA
Date:   Fri, 30 Sep 2022 21:28:31 +0000
Message-ID: <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
        <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
        <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV>
        <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
        <YzXzXNAgcJeJ3M0d@ZenIV> <YzYK7k3tgZy3Pwht@ZenIV>
        <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
        <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
        <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
        <ea14288676b045c29960651a649d66b9@AcuMS.aculab.com>
 <87a66g25wm.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87a66g25wm.fsf@email.froward.int.ebiederm.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric W. Biederman
> Sent: 30 September 2022 17:17
> 
> David Laight <David.Laight@ACULAB.COM> writes:
> 
> > From: Eric W. Biederman
> >> Sent: 29 September 2022 23:48
> >>
> >> Since common apparmor policies don't allow access /proc/tgid/task/tid/net
> >> point the code at /proc/tid/net instead.
> >>
> >> Link: https://lkml.kernel.org/r/dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com
> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> ---
> >>
> >> I have only compile tested this.  All of the boiler plate is a copy of
> >> /proc/self and /proc/thread-self, so it should work.
> >>
> >> Can David or someone who cares and has access to the limited apparmor
> >> configurations could test this to make certain this works?
> >
> > It works with a minor 'cut & paste' fixup.
> > (Not nested inside a program that changes namespaces.)
> 
> Were there any apparmor problems?  I just want to confirm that is what
> you tested.

I know nothing about apparmor - I just tested that /proc/net
pointed to somewhere that looked right.

> Assuming not this patch looks like it reveals a solution to this
> issue.
> 
> > Although if it is reasonable for /proc/net -> /proc/tid/net
> > why not just make /proc/thread-self -> /proc/tid
> > Then /proc/net can just be thread-self/net
> 
> There are minor differences between the process directories that
> tend to report process wide information and task directories that
> only report some of the same information per-task.  So in general
> thread-self makes much more sense pointing to a per-task directory.
> 
> The hidden /proc/tid/ directories use the per process code to generate
> themselves.  The difference is that they assume the tid is the leading
> thread instead of the other process.  Those directories are all a bit of
> a scrambled mess.  I was suspecting the other day we might be able to
> fix gdb and make them go away entirely in a decade or so.
> 
> So I don't think it makes sense in general to point /proc/thread-self at
> the hidden per /proc/tid/ directories.

Ok - I hadn't actually looked in them.
But if you have a long-term plan to remove them directing /proc/net
thought them might not be such a good idea.

> > I have wondered if the namespace lookup could be done as a 'special'
> > directory lookup for "net" rather that changing everything when the
> > namespace is changed.
> > I can imagine scenarios where a thread needs to keep changing
> > between two namespaces, at the moment I suspect that is rather
> > more expensive than a lookup and changing the reference counts.
> 
> You can always open the net directories once, and then change as
> an open directory will not change between namespaces.

Part of the problem is that changing the net namespace isn't
enough, you also have to remount /sys - which isn't entirely
trivial.
It might be possibly to mount a network namespace version
of /sys on a different mountpoint - I've not tried very
hard to do that.

> > Notwithstanding the apparmor issues, /proc/net could actuall be
> > a symlink to (say) /proc/net_namespaces/namespace_name with
> > readlink returning the name based on the threads actual namespace.
> 
> There really aren't good names for namespaces at the kernel level.  As
> one of their use cases is to make process migration possible between
> machines.  So any kernel level name would need to be migrated as well.
> So those kernel level names would need a name in another namespace,
> or an extra namespace would have to be created for those names.

Network namespaces do seem to have names.
Although I gave up working out how to change to a named network
namespace from within the kernel (especially in a non-GPL module).

...
> > FWIW I'm pretty sure there a sequence involving unshare() that
> > can get you out of a chroot - but I've not found it yet.
> 
> Out of a chroot is essentially just:
> 	chdir("/");
>         chroot("/somedir");
>         chdir("../../../../../../../../../../../../../../../..");

A chdir() inside a chroot anchors at the base of the chroot.
fchdir() will get you out if you have an open fd to a directory
outside the chroot.
The 'usual' way out requires a process outside the chroot to
just use mvdir().
But there isn't supposed to be a way to get out.

I can certainly get the /proc symlinks (for a copy of /proc
mounted inside a chroot) to report the full paths for files
that exist inside the chroot.
These should (and do normally) truncate at the chroot base.
(This all happened because a pivot_root() was failing.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

