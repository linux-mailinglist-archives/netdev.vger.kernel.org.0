Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4D13DF09A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbhHCOsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:48:00 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:59171 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236662AbhHCOre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:47:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id EBF245806A0;
        Tue,  3 Aug 2021 10:46:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 03 Aug 2021 10:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=ZhhzKAcbp08j/zLplXp7CUKlTW+9yQngYwV71xLLU
        uk=; b=F/09aFygJQYV2RtiZgmhk7lrEY/SgDHVCp9GLx/945GbshDofvqnTjhPv
        MdQvU0XkuXuw8J+MuhKrJ5gR1GZcomEdsTK6ZD7aIFtguwONkYK584aL0vB3+uOi
        1cZ7en9ladrjw6Am+2BpbC6fRp8uuoZu3LuWznvdmPAybGSJD4k6LsC2dgve+Rgl
        7lVDmmuL7y/jEYsgA56vScY1S21u5F3TLg4OLHZRv4+oQDdiQgC7TWc+gnXL5h4w
        2rvrqIo0t83pmPMDPPc41jSJk9WPHxdOeJIBVx4KzCnsejQeB77xOjaT3gfaZ5ud
        PQwuZWkKpupEjh03t9vkMNG6BzFeQ==
X-ME-Sender: <xms:slYJYT6kZeAR_u8nmIhOwwTdbdSTNZDG6YV26ZSH5RAkJpiwDMEecg>
    <xme:slYJYY6-9FEu98HWO-uZSzE-IqI3ADKc0IPE-fH4fhb6O37ZXlqSYAoGH26C6xR_Y
    3AnO0EnJ1_HFrI>
X-ME-Received: <xmr:slYJYacOsY7ys2tiGj1OcG6XygrXSWg4xrc9GnX_-fPcsyrhgEjtC7VnWYQEv5nVsTuIg9N7CZQZGuQjxh2ppRV9AbXp_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrieeggdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvffevkeefieeiueeitedufeekveekuefhueeiudduteekgeelfedvgeehjeeh
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:slYJYUKzZG3Xz6r6LaeXad3wYy6LOTbk81cO0cMnwYXwbSFEc7wHjQ>
    <xmx:slYJYXJjCcb3nZi9UnC0Hz6_YYtYtVnj1jBbwCxXsrsAsiMMX5tIkw>
    <xmx:slYJYdxfVsvKDxmjEDddhWRd4PUJmS19TokpDNA-XT3HSimKkg7Dwg>
    <xmx:uFYJYVgEB2oEZs8RPQxAloMFD7GNawFrzXmXD3USqGR6p1WsqWraOg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Aug 2021 10:46:09 -0400 (EDT)
Date:   Tue, 3 Aug 2021 17:46:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Michael Buesch <m@bues.ch>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        xen-devel@lists.xenproject.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 5/6] PCI: Adapt all code locations to not use struct
 pci_dev::driver directly
Message-ID: <YQlWrcCY3X01eNJJ@shredder>
References: <20210803100150.1543597-1-u.kleine-koenig@pengutronix.de>
 <20210803100150.1543597-6-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210803100150.1543597-6-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 12:01:49PM +0200, Uwe Kleine-König wrote:
> This prepares removing the driver member of struct pci_dev which holds the
> same information than struct pci_dev::dev->driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  arch/powerpc/include/asm/ppc-pci.h            |  3 +-
>  arch/powerpc/kernel/eeh_driver.c              | 12 ++++---
>  arch/x86/events/intel/uncore.c                |  2 +-
>  arch/x86/kernel/probe_roms.c                  |  2 +-
>  drivers/bcma/host_pci.c                       |  6 ++--
>  drivers/crypto/hisilicon/qm.c                 |  2 +-
>  drivers/crypto/qat/qat_common/adf_aer.c       |  2 +-
>  drivers/message/fusion/mptbase.c              |  4 +--
>  drivers/misc/cxl/guest.c                      | 21 +++++------
>  drivers/misc/cxl/pci.c                        | 25 +++++++------
>  .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  2 +-
>  .../ethernet/marvell/prestera/prestera_pci.c  |  2 +-
>  drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
>  .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  2 +-
>  drivers/pci/iov.c                             | 23 +++++++-----
>  drivers/pci/pci-driver.c                      | 28 ++++++++-------
>  drivers/pci/pci.c                             | 10 +++---
>  drivers/pci/pcie/err.c                        | 35 ++++++++++---------
>  drivers/pci/xen-pcifront.c                    |  3 +-
>  drivers/ssb/pcihost_wrapper.c                 |  7 ++--
>  drivers/usb/host/xhci-pci.c                   |  3 +-
>  21 files changed, 112 insertions(+), 84 deletions(-)

For mlxsw:

Tested-by: Ido Schimmel <idosch@nvidia.com>
