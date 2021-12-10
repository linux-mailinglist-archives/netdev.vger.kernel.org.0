Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EA346F947
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhLJCpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:45:03 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49906 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhLJCpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:45:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00D97CE25DC;
        Fri, 10 Dec 2021 02:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8282EC004DD;
        Fri, 10 Dec 2021 02:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639104085;
        bh=gs1hihtp3lcVOlDvEMy2luivUpx16A21L5U7s+OO6Is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TOnNKJu9sCBq0U7eH3COwg2HgIlZSIjeD0xmy5rAC7VpH70oCObZVLvAIJIDFLHva
         6rtjKj80ynw8KmVwj1IzGGFlBdKf1oJWGfJUWOaq78DzWVN2zx7y29AYkJNaTpYLXO
         RRMnNtRjSoqcXZm5NQCa3Or29kVHe6EoXcNRrW/cNBeYt5AviF++RXwQZqsBCdL3aO
         x91fL/IQwRVK9sk52v1VX7lxi6GIs9zpcSvQlA0iv2r3C3EfzGwwIn5Gt0UihsmMkI
         JfmkX5PetfR5Au98tKMdkIf8+fn8/gryrehqx/9VoY4DdNvMu18+oVA8ifo6EFnax8
         sAclA5avEAY4A==
Date:   Thu, 9 Dec 2021 18:41:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "sonic.zhang@analog.com" <sonic.zhang@analog.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH net-next] net: stmmac: bump tc when get underflow error
 from DMA descriptor
Message-ID: <20211209184123.63117f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VI1PR04MB68009F16CAA80DCEBFA8F170E6709@VI1PR04MB6800.eurprd04.prod.outlook.com>
References: <20211208100651.19369-1-xiaoliang.yang_1@nxp.com>
        <VI1PR04MB68009F16CAA80DCEBFA8F170E6709@VI1PR04MB6800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Dec 2021 01:31:52 +0000 Joakim Zhang wrote:
> > net: stmmac: bump tc when get underflow error from DMA descriptor
> > 
> > In DMA threshold mode, frame underflow errors may sometimes occur
> > when the TC(threshold control) value is not enough. The TC value need to be
> > bumped up in this case.
> > 
> > There is no underflow interrupt bit on DMA_CH(#i)_Status of dwmac4, so
> > the DMA threshold cannot be bumped up in stmmac_dma_interrupt(). The
> > i.mx8mp board observed an underflow error while running NFS boot, the
> > NFS rootfs could not be mounted.
> > 
> > The underflow error can be got from the DMA descriptor TDES3 on dwmac4.
> > This patch bump up tc value once underflow error is got from TDES3.
> > 
> > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>  
> 
> 5 queues with FIFO cut-through mode can work well after applying this patch.

This never worked, correct? It's not a regression fix?
