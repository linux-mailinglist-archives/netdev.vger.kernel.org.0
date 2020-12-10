Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119C12D643A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392995AbgLJR6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393004AbgLJR6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:58:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBB5C0613CF;
        Thu, 10 Dec 2020 09:57:44 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1knQCC-0004PW-Ga; Thu, 10 Dec 2020 18:57:40 +0100
Date:   Thu, 10 Dec 2020 18:57:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from
 netfilter
Message-ID: <20201210175740.GI4647@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20201207134309.16762-1-phil@nwl.cc>
 <CAHsH6Gupw7o96e5hOmaLBCZtqgoV0LZ4L7h-Y+2oROtXSXvTxw@mail.gmail.com>
 <20201208185139.GZ4647@orbyte.nwl.cc>
 <CAHsH6GvT=Af-BAWK0z_CdrYWPn0qt+C=BRjy10MLRNhLWfH0rQ@mail.gmail.com>
 <9fc5cbb8-26c7-c1c2-2018-3c0cd8c805f4@6wind.com>
 <CAHsH6GsoavW+435MOTKy33iznMc_-JZ-kndr+G=YxuW7DWLNPA@mail.gmail.com>
 <b5c1259b-71e8-57d2-85f2-d5971f33e977@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5c1259b-71e8-57d2-85f2-d5971f33e977@6wind.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Thu, Dec 10, 2020 at 02:18:45PM +0100, Nicolas Dichtel wrote:
> Le 10/12/2020 à 12:48, Eyal Birger a écrit :
> > On Thu, Dec 10, 2020 at 1:10 PM Nicolas Dichtel
> > <nicolas.dichtel@6wind.com> wrote:
> [snip]
> > I also think they should be consistent. But it'd still be confusing to me
> > to get an OUTPUT hook on the inner packet in the forwarding case.
> I re-read the whole thread and I agree with you. There is no reason to pass the
> inner packet through the OUTPUT hook (my comment about the consistency with ip
> tunnels is still valid ;-)).
> Sorry for the confusion.
> 
> Phil, with nftables, you can match the 'kind' of the interface, that should be
> enough to match packets, isn't it?

Yes, sure. Also, the inner packet passes POSTROUTING hook with ipsec
context present, it's just not visible in OUTPUT. Of course the broader
question is what do people use ipsec context matches for. If it's really
just to ensure traffic is encrypted, xfrm_interface alone is sufficient.

Originally this was reported as "ipsec match stops working if
xfrm_interface is used" and I suspected it's a bug in the driver.
Knowing the behaviour is expected (and at least consistent with vti),
the case is closed from my side. :)

Thanks, Phil
