Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EF53044DA
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389806AbhAZRP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:15:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390764AbhAZJ1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 04:27:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 152A923104;
        Tue, 26 Jan 2021 09:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611653164;
        bh=n9V/J8e1eqv74S9xZ5fa3DLyRbZIQAOTaxLDUbYwHkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DVBMX5ML+9cNH7+RQ1EHJQmzJaKeva177oUJz8EmuWGnbv3oAeZAujkGJmJspvJRF
         KmFTGrQaZu6Px5ryOdwdI09ZSfWFaHXXpMRgVEZC++RsII4J4I9PWr2JXicoqTmo0Q
         ozc0LYSJX/0F82pMQspLCWl7toeGNv7BEyuao/tSi+OZZ52N229/HSEqTlyZpjZeQI
         dDRgTUZ858WgBJddsL1m12qrUndGLQWJVt/nK/bsY8btEmxcEpnVC7/QXSP5wMVReQ
         A6QWXftQTz/4fNWOxBonBK3W/wusiND203Zny9SAJ5XeIGfgGMJdHmlzr46Ak1+yja
         W8AmBtBlmIdGw==
Date:   Tue, 26 Jan 2021 11:26:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v4 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210126092601.GE1053290@unreal>
References: <20210124131119.558563-1-leon@kernel.org>
 <20210124131119.558563-2-leon@kernel.org>
 <20210125135229.6193f783@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210126060135.GQ579511@unreal>
 <48c5a16657bb7b6c0f619253e57133137d4e825c.camel@perches.com>
 <20210126084817.GD1053290@unreal>
 <cb6dec52b62dd008d20e9de45f1f15341bbde6ad.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb6dec52b62dd008d20e9de45f1f15341bbde6ad.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 12:57:06AM -0800, Joe Perches wrote:
> On Tue, 2021-01-26 at 10:48 +0200, Leon Romanovsky wrote:
> > On Tue, Jan 26, 2021 at 12:20:11AM -0800, Joe Perches wrote:
> > > On Tue, 2021-01-26 at 08:01 +0200, Leon Romanovsky wrote:
> > > > On Mon, Jan 25, 2021 at 01:52:29PM -0800, Jakub Kicinski wrote:
> > > > > On Sun, 24 Jan 2021 15:11:16 +0200 Leon Romanovsky wrote:
> > > > > > +static int pci_enable_vfs_overlay(struct pci_dev *dev) { return 0; }
> > > > > > +static void pci_disable_vfs_overlay(struct pci_dev *dev) {}
> []
> > > $ ./scripts/checkpatch.pl -f include/linux/*.h --types=static_inline --terse --nosummary
> > > include/linux/dma-mapping.h:203: WARNING: static function definition might be better as static inline
> > > include/linux/genl_magic_func.h:55: WARNING: static function definition might be better as static inline
> > > include/linux/genl_magic_func.h:78: WARNING: static function definition might be better as static inline
> > > include/linux/kernel.h:670: WARNING: static function definition might be better as static inline
> > > include/linux/kprobes.h:213: WARNING: static function definition might be better as static inline
> > > include/linux/kprobes.h:231: WARNING: static function definition might be better as static inline
> > > include/linux/kprobes.h:511: WARNING: static function definition might be better as static inline
> > > include/linux/skb_array.h:185: WARNING: static function definition might be better as static inline
> > > include/linux/slab.h:606: WARNING: static function definition might be better as static inline
> > > include/linux/stop_machine.h:62: WARNING: static function definition might be better as static inline
> > > include/linux/vmw_vmci_defs.h:850: WARNING: static function definition might be better as static inline
> > > include/linux/zstd.h:95: WARNING: static function definition might be better as static inline
> > > include/linux/zstd.h:106: WARNING: static function definition might be better as static inline
> > >
> > > A false positive exists when __must_check is used between
> > > static and inline.  It's an unusual and IMO not a preferred use.
> >
> > Maybe just filter and ignore such functions for now?
>
> Not worth it.
>
> > Will you send proper patch or do you want me to do it?
>
> I'll do it eventually.

Thanks

>
>
