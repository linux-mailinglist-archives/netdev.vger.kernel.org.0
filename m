Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD92633987A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhCLUhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:37:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54794 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234915AbhCLUhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 15:37:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKoWp-00AaIe-Fb; Fri, 12 Mar 2021 21:36:59 +0100
Date:   Fri, 12 Mar 2021 21:36:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Hsu, Chiahao" <andyhsu@amazon.com>
Cc:     netdev@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, kuba@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <YEvQ6z5WFf+F4mdc@lunn.ch>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch>
 <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 04:18:02PM +0100, Hsu, Chiahao wrote:
> 
> Andrew Lunn 於 2021/3/12 15:52 寫道:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> > 
> > On Thu, Mar 11, 2021 at 10:59:44PM +0000, ChiaHao Hsu wrote:
> > > In order to support live migration of guests between kernels
> > > that do and do not support 'feature-ctrl-ring', we add a
> > > module parameter that allows the feature to be disabled
> > > at run time, instead of using hardcode value.
> > > The default value is enable.
> > Hi ChiaHao
> > 
> > There is a general dislike for module parameters. What other mechanisms
> > have you looked at? Would an ethtool private flag work?
> > 
> >       Andrew
> 
> 
> Hi Andrew,
> 
> I can survey other mechanisms, however before I start doing that,
> 
> could you share more details about what the problem is with using module
> parameters? thanks.

It is not very user friendly. No two kernel modules use the same
module parameters. Often you see the same name, but different
meaning. There is poor documentation, you often need to read the
kernel sources it figure out what it does, etc.

Ideally, you want a mechanism which is shared by multiple drivers and
is well documented.

Does virtio have the same problems? What about VmWare? HyperV? Could
you make a generic solution which works for all these technologies?
Is this just a networking problem? Or does disk, graphics etc, need
something similar?

    Andrew
