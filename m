Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEBD3BDA88
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhGFPzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhGFPzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:55:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08943C061574;
        Tue,  6 Jul 2021 08:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jQt99NgdA5zk5MNb3W23mzSm+lOurEhPK4FFEJDPGCo=; b=WYXv6cFivX25YM9Q9tFxdb3LS
        NqAgKaKwmxfzJwrBhjtgPOf7o5K279yQa1OjjdEgMXAAddquN9Hu9QgR7JiOD8LLcNq1cjLPYKBAk
        G+zYgYdv1CgEVt4tfys8OHgMCJGedZb2s/PD3Fy/IEFynDGxbCrHHG2aoNiRfENQ4QGZs4dTW7FOh
        aIn8XLlijX+t4x6cai4MIdjn7KmI4sHfrcBCqr8FjNRCS/kOZ7JO+pgQr/Zsgvpds7S12Ehkq36+B
        9xnOJtmr6nrxY1nEzTfr5VK6XD5nCLQn61Q9akG+xo8bk/DJHW4i+LRB/LHAmCx9x0+tg8lhIyLEn
        1hBR2TnCw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45802)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m0nMK-0006xE-2g; Tue, 06 Jul 2021 16:51:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m0nMB-00028N-Me; Tue, 06 Jul 2021 16:51:31 +0100
Date:   Tue, 6 Jul 2021 16:51:31 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, mw@semihalf.com,
        Sven Auhagen <sven.auhagen@voleatech.de>, davem@davemloft.net,
        kuba@kernel.org, linuxarm@openeuler.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, thomas.petazzoni@bootlin.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        willy@infradead.org, vbabka@suse.cz, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next RFC 0/2] add elevated refcnt support for page
 pool
Message-ID: <20210706155131.GS22278@shell.armlinux.org.uk>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <20210702153947.7b44acdf@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702153947.7b44acdf@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 03:39:47PM +0200, Matteo Croce wrote:
> On Wed, 30 Jun 2021 17:17:54 +0800
> Yunsheng Lin <linyunsheng@huawei.com> wrote:
> 
> > This patchset adds elevated refcnt support for page pool
> > and enable skb's page frag recycling based on page pool
> > in hns3 drvier.
> > 
> > Yunsheng Lin (2):
> >   page_pool: add page recycling support based on elevated refcnt
> >   net: hns3: support skb's frag page recycling based on page pool
> > 
> >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  79 +++++++-
> >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +
> >  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
> >  drivers/net/ethernet/marvell/mvneta.c              |   6 +-
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
> >  include/linux/mm_types.h                           |   2 +-
> >  include/linux/skbuff.h                             |   4 +-
> >  include/net/page_pool.h                            |  30 ++-
> >  net/core/page_pool.c                               | 215
> > +++++++++++++++++---- 9 files changed, 285 insertions(+), 57
> > deletions(-)
> > 
> 
> Interesting!
> Unfortunately I'll not have access to my macchiatobin anytime soon, can
> someone test the impact, if any, on mvpp2?

I'll try to test. Please let me know what kind of testing you're
looking for (I haven't been following these patches, sorry.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
