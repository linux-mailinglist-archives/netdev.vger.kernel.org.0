Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1BC415C7D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240516AbhIWLGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:06:10 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:37313 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240448AbhIWLGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 07:06:07 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 367D35802D9;
        Thu, 23 Sep 2021 07:04:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 23 Sep 2021 07:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=WiSiNj5Dd4L3sJtCbOLr5sy4Eh6
        6vg0BdL+CDFeLWzI=; b=pKzs3k+1PkbeH5UZ1NglyqTY51nkSI+yHijyRhSHMjM
        vUnz40shknrCSWW2jGz55dLprD+Wf1FuA62NFoinE1VLBn9kj3eG+kFJaA8iq/kG
        IaWm/j8yAA++K4y9JRwAikmv6hkX8GhGvAa1p8KeRyvzyfqH0NaC15ZtGt0NcEqw
        V/31aH/zPjl2LbXUg9AO8/N3VpiXbshqGELQb/h8nf01ykzzjtjGtHnY/yYAxI9p
        HTvnsDt9PnWDJtxWBZlYU0VKpqiEijxaYt703hgPp2yW9c3pWFl4X8C37YSK8199
        W0IppLz8Lj4ub87XxoTAgd89y2hJCp3rcCSutwN26rw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WiSiNj
        5Dd4L3sJtCbOLr5sy4Eh66vg0BdL+CDFeLWzI=; b=wwBNx0HfcIs+YJqH3e5oZA
        Rp5Dk4lDQhaGlbEKuGwQkP0Aaw4jspJpjFQwMLxRE5Oxiu12Wp6yGso+wl3V5+o6
        hGqD4TFyfPcnpFEbNWgv57zJl+MIBOktWNCrCzp+ApucEWDofn+n3hT+DJvO6ogp
        faPXtTLkAOqHZyhO46XR+fx1t/r2BbA/dOhgJwXfyq508IuAOJii5vUXY7QNXpMR
        71QAXp+wQHkkz2OqMvfTTnv4oVmsK2ysEzJk6QGWkYAkT4pDFG/egtYmx2xAiSx0
        /hLyS/rQ5IorSFw6lkXU85HRJ4GFGEtICu/W8TqD1GDg05rVli5QnFsPMxK7aukQ
        ==
X-ME-Sender: <xms:Ql9MYXzyiYlX_ullhmfzGJGVkcU6S2a-N3jdLhMC0NvNiB1QT-a2fQ>
    <xme:Ql9MYfTC3dlwWs97aTM_35lXQYhZRtYvLOjtH821fOoHuqdQ1hMg_L5Jl0MU6r6c8
    0hn_C8j7feRAg>
X-ME-Received: <xmr:Ql9MYRWS40hXiqlmp_VUga_SQf6fL_-JPs1w1-1Mn1Mespqpwj-m-DiGAbj4cuYgwqoUFrNE7XeZPf-CRl9tVn6LffzCvOYh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeiieevhf
    ehtddvudefjeehffegtdfghfdvvdektdehueduleeiteffkefffedtheenucffohhmrghi
    nhepuhhrlhguvghfvghnshgvrdgtohhmpdhkvghrnhgvlhdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:Ql9MYRh9Y6RwzFdfGK3qIXezBsgXAtLpKnVYPFgMi8JPa7YUfAfU8A>
    <xmx:Ql9MYZCXI7-qDW9Vj3FDtBAfS-3sJh8SGBmol4lLCWLUsmrGUHo5fA>
    <xmx:Ql9MYaKE-XUbEw2BvyYvPXDh6KZyU92RdUEhW55LbGwQmm-Slhw4Tw>
    <xmx:Q19MYR69HCpkknODMKDCxiIoXPCU7BaIncWlrqhwduJOGaluSmXOTA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 07:04:34 -0400 (EDT)
Date:   Thu, 23 Sep 2021 13:04:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Patrick.Mclean@sony.com, stable@vger.kernel.org,
        regressions@lists.linux.dev, ayal@nvidia.com, saeedm@nvidia.com,
        netdev@vger.kernel.org, Aaron.U'ren@sony.com,
        Russell.Brown@sony.com, Victor.Payno@sony.com
Subject: Re: mlx5_core 5.10 stable series regression starting at 5.10.65
Message-ID: <YUxfP7K7jABqk6VE@kroah.com>
References: <BY5PR13MB3604D3031E984CA34A57B7C9EEA09@BY5PR13MB3604.namprd13.prod.outlook.com>
 <YUl8PKVz/em51KHR@kroah.com>
 <BY5PR13MB3604527F4A98D0F86B02AC98EEA19@BY5PR13MB3604.namprd13.prod.outlook.com>
 <YUrLfMhATS3u6jq5@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUrLfMhATS3u6jq5@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 09:21:48AM +0300, Leon Romanovsky wrote:
> On Tue, Sep 21, 2021 at 10:22:57PM +0000, Patrick.Mclean@sony.com wrote:
> > > On Mon, Sep 20, 2021 at 08:22:44PM +0000, Patrick.Mclean@sony.com wrote:
> > > > In 5.10 stable kernels since 5.10.65 certain mlx5 cards are no longer usable (relevant dmesg logs and lspci output are pasted below).
> > > >
> > > > Bisecting the problem tracks the problem down to this commit:
> > > > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=fe6322774ca28669868a7e231e173e09f7422118__;!!JmoZiZGBv3RvKRSx!phUrsR595UusBY2Q9eNJQS7-VNtnb72Rcvhe-W0QKDPir1WY9mvWOkLLfe63k-6Uvw$
> > > >
> > > > Here is how lscpi -nn identifies the cards:
> > > > 41:00.0 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [ConnectX-5] [15b3:1017]
> > > > 41:00.1 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [ConnectX-5] [15b3:1017]
> > > >
> > > > Here are the relevant dmesg logs:
> > > > [   13.409473] mlx5_core 0000:41:00.0: firmware version: 16.31.1014
> > > > [   13.415944] mlx5_core 0000:41:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
> > > > [   13.707425] mlx5_core 0000:41:00.0: Rate limit: 127 rates are supported, range: 0Mbps to 24414Mbps
> > > > [   13.718221] mlx5_core 0000:41:00.0: E-Switch: Total vports 2, per vport: max uc(128) max mc(2048)
> > > > [   13.740607] mlx5_core 0000:41:00.0: Port module event: module 0, Cable plugged
> > > > [   13.759857] mlx5_core 0000:41:00.0: mlx5_pcie_event:294:(pid 586): PCIe slot advertised sufficient power (75W).
> > > > [   17.986973] mlx5_core 0000:41:00.0: E-Switch: cleanup
> > > > [   18.686204] mlx5_core 0000:41:00.0: init_one:1371:(pid 803): mlx5_load_one failed with error code -22
> > > > [   18.701352] mlx5_core: probe of 0000:41:00.0 failed with error -22
> > > > [   18.727364] mlx5_core 0000:41:00.1: firmware version: 16.31.1014
> > > > [   18.743853] mlx5_core 0000:41:00.1: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
> > > > [   19.015349] mlx5_core 0000:41:00.1: Rate limit: 127 rates are supported, range: 0Mbps to 24414Mbps
> > > > [   19.025157] mlx5_core 0000:41:00.1: E-Switch: Total vports 2, per vport: max uc(128) max mc(2048)
> > > > [   19.053569] mlx5_core 0000:41:00.1: Port module event: module 1, Cable unplugged
> > > > [   19.062093] mlx5_core 0000:41:00.1: mlx5_pcie_event:294:(pid 591): PCIe slot advertised sufficient power (75W).
> > > > [   22.826932] mlx5_core 0000:41:00.1: E-Switch: cleanup
> > > > [   23.544747] mlx5_core 0000:41:00.1: init_one:1371:(pid 803): mlx5_load_one failed with error code -22
> > > > [   23.555071] mlx5_core: probe of 0000:41:00.1 failed with error -22
> > > >
> > > > Please let me know if I can provide any further information.
> > > 
> > > If you revert that single change, do things work properly?
> > 
> > Yes, things work properly after reverting that single change (tested with 5.10.67).
> 
> The stable@ kernel is missing commit 3d347b1b19da ("net/mlx5: Add support for devlink traps
> in mlx5 core driver"), which added mlx5 devlink callbacks (.trap_init and .trap_fini).

Ok, will go revert this now, thanks for confirming it and letting me
know.

> I don't know why the commit that you reverted was added to stable@ in
> the first place. It doesn't fix any bug and has no Fixes tag.

Looks like it was brought in as a dependancy for another fix that
required it as the revert was not clean and I had to do it "by hand".

thanks,

greg k-h
