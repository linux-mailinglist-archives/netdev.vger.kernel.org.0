Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47EB5F3EE3
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 10:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiJDIxx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Oct 2022 04:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiJDIxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 04:53:51 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802F163C0
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 01:53:50 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-190-cqLT9I1YPuuRISROdDhghw-1; Tue, 04 Oct 2022 09:53:41 +0100
X-MC-Unique: cqLT9I1YPuuRISROdDhghw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 4 Oct
 2022 09:53:39 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Tue, 4 Oct 2022 09:53:39 +0100
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
Thread-Index: AQHY10qd381Lc0KOOEGaF1/0a4qSLq397Oxw
Date:   Tue, 4 Oct 2022 08:53:39 +0000
Message-ID: <8be364fd938a4ac9959b4c01120cac97@AcuMS.aculab.com>
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
        <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com>
 <87fsg4ygxc.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87fsg4ygxc.fsf@email.froward.int.ebiederm.org>
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
> Sent: 03 October 2022 18:07
> 
> David Laight <David.Laight@ACULAB.COM> writes:
> 
> > From: Eric W. Biederman
...
> > Part of the problem is that changing the net namespace isn't
> > enough, you also have to remount /sys - which isn't entirely
> > trivial.
> 
> Yes.  That is actually a much more maintainable model.  But it is still
> imperfect.    I was thinking about the proc/net directories when
> I made my comment.  Unlike proc where we have task ids there is nothing
> in /proc that can do anything.
> 
> > It might be possibly to mount a network namespace version
> > of /sys on a different mountpoint - I've not tried very
> > hard to do that.
> 
> It is a bug if that doesn't work.

The difficultly is picking the 'spell'.
I think you need to run mount after switching to the namespace.
But you don't want the unshare() that 'ip netns exec' does.
So I think it needs a silly wrapper program.

> >> > Notwithstanding the apparmor issues, /proc/net could actuall be
> >> > a symlink to (say) /proc/net_namespaces/namespace_name with
> >> > readlink returning the name based on the threads actual namespace.
> >>
> >> There really aren't good names for namespaces at the kernel level.  As
> >> one of their use cases is to make process migration possible between
> >> machines.  So any kernel level name would need to be migrated as well.
> >> So those kernel level names would need a name in another namespace,
> >> or an extra namespace would have to be created for those names.
> >
> > Network namespaces do seem to have names.
> > Although I gave up working out how to change to a named network
> > namespace from within the kernel (especially in a non-GPL module).
> 
> Network namespaces have mount points.  The mount points have names.
> 
> It is just a matter of finding the right filesystem and calling
> sys_rename().

I wanted to lookup a net namespace by name - so I could create
a kernel socket in a namespace specified in configuration data.
Not change the name of a namespace.

I ended up only giving a few options - basically saving the
namespace of code that called into the driver.
(Harder in a non-gpl driver since you can't directly hold/release
the namespace itself - fortunately you can create a socket!)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

