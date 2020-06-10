Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8461F53E1
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgFJLxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:53:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:37334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgFJLxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 07:53:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B9287AC12;
        Wed, 10 Jun 2020 11:53:54 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A002760739; Wed, 10 Jun 2020 13:53:50 +0200 (CEST)
Date:   Wed, 10 Jun 2020 13:53:50 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
Message-ID: <20200610115350.wyba5rnpuavkzdl5@lion.mk-sys.cz>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
 <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 12:50:30PM +0200, Heiner Kallweit wrote:
> On 10.06.2020 11:13, Michal Kubecek wrote:
> > Just to make sure you are hitting the same problem I'm just looking at,
> > please check if
> > 
> > - your kernel is built with ETHTOOL_NETLINK=n
> 
> No, because I have PHYLIB=m.
> Not sure what it would take to allow building ethtool netlink support
> as a module. But that's just on a side note.

Yes, this is the unfortunate fallout of the new dependency between
ETHTOOL_NETLINK and PHYLIB introduced with the cable diagnostic series.
As "make oldconfig" silently disables ETHTOOL_NETLINK when PHYLIB=m,
many people won't even notice. Even I fell for this when I suddently
noticed my testing merge window snapshot has ETHTOOL_NETLINK disable.
I guess we will have to find some nicer solution.

Michal
