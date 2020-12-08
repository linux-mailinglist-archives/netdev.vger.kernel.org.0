Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9DF2D2391
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgLHGXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:23:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:32806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgLHGXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 01:23:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B9515AD7C;
        Tue,  8 Dec 2020 06:22:21 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1131C6078E; Tue,  8 Dec 2020 07:22:20 +0100 (CET)
Date:   Tue, 8 Dec 2020 07:22:20 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 1/9] ethtool: Add support for configuring
 frame preemption
Message-ID: <20201208062220.3xrhdo47lgpyttfi@lion.mk-sys.cz>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
 <20201202045325.3254757-2-vinicius.gomes@intel.com>
 <20201205094325.790b187f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87eek11d23.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eek11d23.fsf@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 02:11:48PM -0800, Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> >> + * @min_frag_size_mult: Minimum size for all non-final fragment size,
> >> + * expressed in terms of X in '(1 + X)*64 + 4'
> >
> > Is this way of expressing the min frag size from the standard?
> >
> 
> The standard has this: "A 2-bit integer value indicating, in units of 64
> octets, the minimum number of octets over 64 octets required in
> non-final fragments by the receiver" from IEEE 802.3br-2016, Table
> 79-7a.

Can we be sure that newer version of the standard cannot change this,
e.g. come with a finer granularity? Perhaps it would be safer to express
the size in bytes in the userspace API and translate to this internal
representation in common ethtool code.

Also, please don't forget to update Documentation/networking/ethtool-netlink.rst

Michal
