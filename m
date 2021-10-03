Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3D241FF75
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 05:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhJCD0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 23:26:20 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:34396 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhJCD0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 23:26:19 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id F202D20274;
        Sun,  3 Oct 2021 11:24:30 +0800 (AWST)
Message-ID: <d5ada7b46f4abc2c5a7ecf0af0e50e356685a25b.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next 2/2] mctp: test: defer mdev setup until we've
 registered
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     David Gow <davidgow@google.com>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Brendan Higgins <brendanhiggins@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Date:   Sun, 03 Oct 2021 11:24:30 +0800
In-Reply-To: <CABVgOSkuN7XPPvnBQFm_h80eFpx_fT0veDPxMefVbiNa_ZQG8g@mail.gmail.com>
References: <20211002022656.1681956-1-jk@codeconstruct.com.au>
         <20211002022656.1681956-2-jk@codeconstruct.com.au>
         <CABVgOSkuN7XPPvnBQFm_h80eFpx_fT0veDPxMefVbiNa_ZQG8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> Haha -- you sent this just as I'd come up with the same patch here.
> :-)
> 
> With these changes, alongside the rt->dev == NULL in
> mctp_route_release() crash fix mentioned in [1], the tests all pass
> on
> my system. (They also pass under KASAN, which bodes well.)

Awesome, thanks for checking these out. I've since sent a v2 with the
fixes integrated, in order to not break davem's build.

I've refined the rt->dev == NULL case a little; rather than allowing
->dev == NULL in the core code (which should never happen), I've
modified the test's route refcounting so that the route destroy path
should only ever hit the test's own destructor instead (which allows
!rt->dev cases). This means we can keep the ->dev != NULL assumption in
the core, and still handle tests where our fake route->dev is unset.

Cheers,


Jeremy

