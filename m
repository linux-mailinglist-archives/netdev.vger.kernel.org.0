Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0493ED9C6
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhHPPU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhHPPUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:20:04 -0400
X-Greylist: delayed 315 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 Aug 2021 08:19:25 PDT
Received: from edrik.securmail.fr (edrik.securmail.fr [IPv6:2a0e:f41:0:1::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E65C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 08:19:16 -0700 (PDT)
Received: from irc-clt.no.as208627.net (irc-clt.no.as208627.net [IPv6:2a0e:f42:a::3])
        (using TLSv1.2 with cipher DHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alarig@swordarmor.fr)
        by edrik.securmail.fr (Postfix) with ESMTPSA id C6F85B0ED2;
        Mon, 16 Aug 2021 17:13:56 +0200 (CEST)
Authentication-Results: edrik.securmail.fr/C6F85B0ED2; dmarc=none (p=none dis=none) header.from=swordarmor.fr
Date:   Mon, 16 Aug 2021 17:13:54 +0200
From:   Alarig Le Lay <alarig@swordarmor.fr>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init
 methods
Message-ID: <YRqAsjXuKeOOiIU9@irc-clt.no.as208627.net>
References: <BYAPR11MB2870B0910C71BDDFD328B339AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
 <CANn89iLnzN6n--tF_7_d0Y1tD6sv3Yx=3H+U_iYbeC21=-r92w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLnzN6n--tF_7_d0Y1tD6sv3Yx=3H+U_iYbeC21=-r92w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed 31 Mar 2021 07:58:07 GMT, Eric Dumazet wrote:
> On Wed, Mar 31, 2021 at 2:01 AM Wong, Vee Khee <vee.khee.wong@intel.com> wrote:
> >
> > Hi all,
> >
> >
> >
> > This patch introduced the following massive warnings printouts on a
> >
> > Intel x86 Alderlake platform with STMMAC MAC and Marvell 88E2110 PHY.
> >
> >
> >
> > [  149.674232] unregister_netdevice: waiting for sit0 to become free. Usage count = 2
> 
> Same answer than the other thread :
> 
> Nope, I already have a fix, but it depends on a pending patch.
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20210330064551.545964-1-eric.dumazet@gmail.com/
> 
> (I need the patch being merged to add a corresponding Fixes: tag)
> 
> You can try the attached patch :

I’ve upgraded some boxes to 4.14.240 which includes the fix, but I have
> unregister_netdevice: waiting for ip6gre0 to become free. Usage count = -1 
every ten seconds.

It’s not the same interface name nor the same count, so perhaps there is
another issue with the patches?

Regards,
-- 
Alarig Le Lay
