Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8644441C83F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345172AbhI2PXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:23:49 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:57911 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345161AbhI2PXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:23:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 908EA580BD1;
        Wed, 29 Sep 2021 11:22:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 29 Sep 2021 11:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=D0IBY5Pj6/F0JNNHa8/d4D4dhFcHLMGCSTOY+LuBz
        EA=; b=ZhuEp73RqBc+dT9dwPx5WFYuR7Gt0Z5v5JwZxAbdDiwVFqr1XKrU6RdqT
        3rIoZ0CA9UXgji52+2PrjjTwfscTVJtNtaUNw4fuAiPKrcbpUMNPX+nbUdTlMNuo
        UaNOlBBEIdPZdvCUm5E44mVcU0XNBF9ghUkUbjMwtk8eCdD0C5jk3+SwnJ6370BB
        QgME+XdXif4rDMO/pgeg2l7pi1D3C/yDyz3uvu0xiYDNJw4CBYPifZEneb/EJw82
        CIeEpqkNGZ0o97zwmk1ZQKBea3uhtd66i3eUUC6mqyYKw5ZNZrEiGUPGVcPsmtQJ
        c5glFMBe4zEv4TdYBsw7o2ck4Y7Pw==
X-ME-Sender: <xms:moRUYcIiQiek66OCH96DYUulnzjzdZQUThcHnOdDoDcRmeKGDlXjTg>
    <xme:moRUYcI0MbGkED8qssdPRBiBWe_CrvaZAgkwunl6h6SPDjj1Nxxvi8lGvBHu2FgjH
    55Xn4IWK7oq_YU>
X-ME-Received: <xmr:moRUYcsakn1EZN6tshS1xq22hr0tGjDovRi3VpZjiEiXyTscCqvuL1Z2x-0vTKvY1JMClYZZLUhTFqgVM2ETrrkiuXTVYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekvddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdffveekfeeiieeuieetudefkeevkeeuhfeuieduudetkeegleefvdegheej
    hefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:moRUYZY2T71Ye70VK0ZXT9k0rMv0XvUrClrZ-XxbCRE7b_iEWDrspw>
    <xmx:moRUYTbGUGgYGvqoe_LLC_BahVB-nT9wy_dlTmqtTbk_4_48J7znPQ>
    <xmx:moRUYVCFJwt-bPeKh9TD9dC-MuOE8-gqr0XNjl2JX7tu6qUkLlwV3g>
    <xmx:nYRUYRaaJhOxHhrGXNsvKxWu6G5VIgXneeVfia8eaWBmOXFI-btEUQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Sep 2021 11:22:01 -0400 (EDT)
Date:   Wed, 29 Sep 2021 18:21:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Ido Schimmel <idosch@nvidia.com>, u.kleine-koenig@pengutronix.de
Cc:     Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-pci@vger.kernel.org, kernel@pengutronix.de,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michael Buesch <m@bues.ch>,
        Oliver O'Halloran <oohall@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH v5 07/11] PCI: Replace pci_dev::driver usage that gets
 the driver name
Message-ID: <YVSElahmw2AMwnNH@shredder>
References: <20210929085306.2203850-1-u.kleine-koenig@pengutronix.de>
 <20210929085306.2203850-8-u.kleine-koenig@pengutronix.de>
 <YVR74+8Rw6XmTqDD@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVR74+8Rw6XmTqDD@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 05:44:51PM +0300, Ido Schimmel wrote:
> On Wed, Sep 29, 2021 at 10:53:02AM +0200, Uwe Kleine-König wrote:
> > struct pci_dev::driver holds (apart from a constant offset) the same
> > data as struct pci_dev::dev->driver. With the goal to remove struct
> > pci_dev::driver to get rid of data duplication replace getting the
> > driver name by dev_driver_string() which implicitly makes use of struct
> > pci_dev::dev->driver.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> For mlxsw:
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> 
> Thanks

Actually, I found out that after loading and executing another kernel
(or the same one) via kexec I get this splat [1].

[1]
 BUG: unable to handle page fault for address: ffffffffffffffc8         
 #PF: supervisor read access in kernel mode                       
 #PF: error_code(0x0000) - not-present page
 PGD 6e40c067 P4D 6e40c067 PUD 6e40e067 PMD 0 
 Oops: 0000 [#1] SMP                                                    
 CPU: 0 PID: 786 Comm: kexec Not tainted 5.15.0-rc2-custom-45114-g6b0effa5a61f #112
 Hardware name: Mellanox Technologies Ltd. MSN3700/VMOD0005, BIOS 5.11 01/06/2019                                                                              
 RIP: 0010:pci_device_shutdown+0x16/0x40
 Code: 01 00 31 d2 4c 89 e7 89 c6 e8 36 ce 01 00 41 89 c5 eb bb 90 55 48 8d af 40 ff ff ff 53 48 8b 47 68 48 89 fb 48 83 f8 78 74 0e <48> 8b 40 c8 48 85 c0 74 
05 48 89 ef ff d0 80 3d 35 81 b7 01 00 74                                             
 RSP: 0018:ffff95fec0d37db8 EFLAGS: 00010297                            
 RAX: 0000000000000000 RBX: ffff8d70c0f1f0c0 RCX: 0000000000000004
 RDX: ffff8d7115a03a00 RSI: 0000000000000206 RDI: ffff8d70c0f1f0c0      
 RBP: ffff8d70c0f1f000 R08: 0000000000000002 R09: 0000000000000502
 R10: 0000000000000000 R11: 0000000000000006 R12: ffff8d70c0f1f0c0                                                                                             
 R13: ffff8d70c0f1f140 R14: 00000000fee1dead R15: 0000000000000000                                                                                             
 FS:  00007fd3089e0b80(0000) GS:ffff8d7237c00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                     
 CR2: ffffffffffffffc8 CR3: 0000000155abb001 CR4: 00000000003706f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  device_shutdown+0x12e/0x180 
  kernel_kexec+0x52/0xb0
  __do_sys_reboot+0x1c0/0x210 
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7fd308afd557
 Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 89 fa be 69 19 12 28 bf ad de e1 fe b8 a9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 
c3 48 8b 15 f1 a8 0c 00 f7 d8 64 89 02 b8
 RSP: 002b:00007fff7d01e0a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a9
 RAX: ffffffffffffffda RBX: 00005606db11d380 RCX: 00007fd308afd557
 RDX: 0000000045584543 RSI: 0000000028121969 RDI: 00000000fee1dead
 RBP: 0000000000000000 R08: 0000000000000007 R09: 00007fd308bc8a60
 R10: 0000000000000021 R11: 0000000000000246 R12: 0000000000000003
 R13: 00007fff7d01e1f0 R14: 00005606db11d8c0 R15: 00000000ffffffff
 Modules linked in:
 CR2: ffffffffffffffc8
 ---[ end trace 0cb0bc633a6fde3e ]---

Where:

(gdb) l *(pci_device_shutdown+0x16)
0xffffffff8156abf6 is in pci_device_shutdown (drivers/pci/pci-driver.c:496).
491             struct pci_dev *pci_dev = to_pci_dev(dev);
492             struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
493
494             pm_runtime_resume(dev);
495
496             if (drv && drv->shutdown)
497                     drv->shutdown(pci_dev);
498
499             /*
500              * If this is a kexec reboot, turn off Bus Master bit on the
