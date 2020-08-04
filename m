Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D4623C23C
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHDXiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgHDXiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:38:07 -0400
X-Greylist: delayed 2107 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Aug 2020 16:38:06 PDT
Received: from pannekake.samfundet.no (pannekake.samfundet.no [IPv6:2001:67c:29f4::50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FE1C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:38:06 -0700 (PDT)
Received: from sesse by pannekake.samfundet.no with local (Exim 4.92)
        (envelope-from <sesse@samfundet.no>)
        id 1k35xG-0000MS-OY; Wed, 05 Aug 2020 01:02:46 +0200
Date:   Wed, 5 Aug 2020 01:02:46 +0200
From:   "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200804230246.nrllxp2k2bruckcp@sesse.net>
References: <20200804142708.zjos3b6jvqjj7uas@skbuf>
 <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
 <20200804192933.pe32dhfkrlspdhot@skbuf>
 <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
 <20200804194333.iszq54mhrtcy3hs6@skbuf>
 <CANn89iKxjxdiMdmFvz6hH-XaH4wNQiweo27cqh=W-gC7UT_OLA@mail.gmail.com>
 <20200804212421.e2lztrrg4evuk6zd@skbuf>
 <CANn89iKuVa8-piOf424HyiFZqTHEjFEGa7C5KV4TMWNZyhJzvQ@mail.gmail.com>
 <20200804223952.je4yacy57vt5qjwk@skbuf>
 <20200804224430.qt4zc2vihz7zeks6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200804224430.qt4zc2vihz7zeks6@skbuf>
X-Operating-System: Linux 5.8.0-rc1 on a x86_64
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 01:44:30AM +0300, Vladimir Oltean wrote:
>>>> What bug? What repro? You just said you don't have any.
>>> Ask Steinar ?
>>> 
>> Hi Steinar, do you have a reproducer for the bug that Eric fixed in
>> commit d4b812dea4a2 ("vlan: mask vlan prio bits")?
> The Google email address from the original report bounces back. Adding
> another address found by searching for your name on netdev.

Yeah, I don't work at Google anymore, so sesse@google.com does not exist.
(Hi, Eric! Hoping you're fine despite the pandemic.)

By accident, I'm actually sitting right next to the router in question
right now. But the setup has changed at least twice since 2013, and it
doesn't use sit anymore since native IPv6 is where it's at. So no, I don't
have a reproducer anymore. I also really cannot remember the details;
I think maybe the outgoing sit device was for 6rd? And the priority tag was
added by a fairly cheap Zyxel switch that might still be in the loop, but now
there's tagged VLANs anyway...

If you want to spend time to try to reproduce this with the old kernel
(to verify you have a reproducer that you can use to test the bug with),
this is probably what I'd test: Send untagged packets with 802.1p priority
set (most cheap managed switches allow you to force that somehow, I believe;
tcpdump -e will show an 802.1q tag with VLAN 0), try to route them into a sit
tunnel, and see if they become corrupted or not. That's the only thing I can
recommend, sorry. I hoard a lot of things, but reproducers for fixed bugs
from 2013 at my parents' house isn't among them :-)

/* Steinar */
-- 
Homepage: https://www.sesse.net/
