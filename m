Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA23F3E5673
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbhHJJNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbhHJJNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:13:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A89FC0613D3;
        Tue, 10 Aug 2021 02:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8vt89Y6r+9GV+oFHjxZBGO2/Fiby2OsZ3MlYOti3J4Y=; b=UugJXkM0/kCE0nZHIyj6L438t
        iCcuNqHh0+zzKlCRxGss8klqt2RqaFkXhpOESSTrJxE9fbquLbrg0H7Kt6zDWE6+WT4YrMWErzNXD
        FD5VCM/8yqJNZP7ODUXQ+nik+cFY6xf/VAoQyPxXxYMhZR5frmK1eGn7NlWHE9mXWKFTjv8xMqUs9
        t9o1fbtAaBRWx8VYdKtkb6j4LDd2eNAvjCJOnWPuplmaCdM7VZGf4RGnnfI/irfj5t5zo3UtfLaCN
        f9v7C+qiPBJ1ABNYQ5ey6qeKq2dgVwIOeyZpJfTQptYUpA0TFDqb88QVEOKhfEwq08hFLh3+OKvUv
        kyDXxh3OQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47142)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mDNoR-0006oG-7K; Tue, 10 Aug 2021 10:12:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mDNoM-00023a-V5; Tue, 10 Aug 2021 10:12:38 +0100
Date:   Tue, 10 Aug 2021 10:12:38 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Message-ID: <20210810091238.GB1343@shell.armlinux.org.uk>
References: <20210809131152.509092-1-vladimir.oltean@nxp.com>
 <YRIhwQ3ji8eqPQOQ@unreal>
 <20210810081616.wjx6jnlh3qxqsfm2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810081616.wjx6jnlh3qxqsfm2@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 08:16:17AM +0000, Vladimir Oltean wrote:
> Hi Leon,
> 
> On Tue, Aug 10, 2021 at 09:50:41AM +0300, Leon Romanovsky wrote:
> > > +	memset(&send_info, 0, sizeof(send_info));
> > 
> > This can be written simpler.
> > struct switchdev_notifier_fdb_info send_info = {};
> > 
> > In all places.
> 
> Because the structure contains a sub-structure, I believe that a
> compound literal initializer would require additional braces for the
> initialization of its sub-objects too. At least I know that expressions
> like that have attracted the attention of clang people in the past:
> https://patchwork.ozlabs.org/project/netdev/patch/20190506202447.30907-1-natechancellor@gmail.com/
> So I went for the 'unambiguous' path.

There's a difference between:

	struct foo bar = { 0 };

and

	struct foo bar = { };

The former tells the compiler that you wish to set the first member of
struct foo, which will be an integer type, to zero. The latter is an
empty initialiser where all members and sub-members of the structure
default to a zero value.

You should have no problem with the latter. You will encounter problems
with the former if the first member of struct foo is not an integer
type.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
