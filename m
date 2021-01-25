Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D677A302A44
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 19:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbhAYSbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 13:31:06 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:35521 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbhAYS2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 13:28:21 -0500
Date:   Mon, 25 Jan 2021 18:27:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611599255; bh=BNsVpptmPCWnM/HSD7DFkyRUhexA9u11ZFBtrI8eXBw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=aw2vpID7+/tcFGlQBlD9SjxMuz+grORCsiUs4coVpZPWcuIL3pf1vkiYfr2JRZaZT
         EwhVJPGp3/tZwXNjCo8HiBvRNB9hO/AUA499dNaBjQzn5xAam5Sfdypp43gCxrTBsx
         nZWz6AhMji7ekBopTmogGQmAm02Ir/+PZU0xCzWxobwLTcq9S+o+av/RuMqjxh1qno
         jCu7otS0DW5MtXXM5XrHrcf1DWg4fRB1uVvyBRofxLUGowVVNpS5WgGrNWzJDCPpP+
         Yu5v0rgcUcRC4wejN4NhYEol36SE9E3WINOxv3ldpJtKfmAAbgK7gv9F42sBHN7c8x
         bc+pB4ZowJz6Q==
To:     David Rientjes <rientjes@google.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 2/3] net: constify page_is_pfmemalloc() argument at call sites
Message-ID: <20210125182702.247232-1-alobakin@pm.me>
In-Reply-To: <85978330-9753-f7a-f263-7a1cfd95b851@google.com>
References: <20210125164612.243838-1-alobakin@pm.me> <20210125164612.243838-3-alobakin@pm.me> <85978330-9753-f7a-f263-7a1cfd95b851@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Mon, 25 Jan 2021 10:19:48 -0800 (PST)

> On Mon, 25 Jan 2021, Alexander Lobakin wrote:
>=20
> > Constify "page" argument for page_is_pfmemalloc() users where applicabl=
e.
> >
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   | 2 +-
> >  drivers/net/ethernet/intel/fm10k/fm10k_main.c     | 2 +-
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 2 +-
> >  drivers/net/ethernet/intel/iavf/iavf_txrx.c       | 2 +-
> >  drivers/net/ethernet/intel/ice/ice_txrx.c         | 2 +-
> >  drivers/net/ethernet/intel/igb/igb_main.c         | 2 +-
> >  drivers/net/ethernet/intel/igc/igc_main.c         | 2 +-
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 2 +-
> >  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 2 +-
> >  include/linux/skbuff.h                            | 4 ++--
> >  11 files changed, 12 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/=
net/ethernet/hisilicon/hns3/hns3_enet.c
> > index 512080640cbc..0f8e962b5010 100644
> > --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> > @@ -2800,7 +2800,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3=
_enet_ring *ring,
> >  =09writel(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
> >  }
> >
> > -static bool hns3_page_is_reusable(struct page *page)
> > +static bool hns3_page_is_reusable(const struct page *page)
> >  {
> >  =09return page_to_nid(page) =3D=3D numa_mem_id() &&
> >  =09=09!page_is_pfmemalloc(page);
>=20
> Hi Alexander,

Hi David!

> All of these functions appear to be doing the same thing, would it make
> sense to simply add this to a header file and remove all the code
> duplication as well?

That's an interesting idea. I'll be glad to do this if drivers'
maintainers agree it's okay for them.

Thanks,
Al

