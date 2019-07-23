Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2387E71E8D
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbfGWSCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfGWSCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 14:02:04 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57381218A0;
        Tue, 23 Jul 2019 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563904923;
        bh=vavKFC4yrs6z1eZsAqeOyYRdynaZawQ4GerPWJF5eMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDw164j3jya/wNZGy05gYQB8qlSEJOffxh+pD5x+BtH2XfQyupGU9JUJBuI12AVii
         ev3+3V2u011jmL1sx0nI/pINdlIigCAEHqacO2F0RgU239BtRNJKXj/YWtdI6dArqE
         TuUvpPF54+sPOtkIfMCowPG10d5w3LiyAoSLt+18=
Date:   Tue, 23 Jul 2019 21:01:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "cai@lca.pw" <cai@lca.pw>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] lib/dim: Fix -Wunused-const-variable warnings
Message-ID: <20190723180154.GS5125@mtr-leonro.mtl.com>
References: <20190723072248.6844-1-leon@kernel.org>
 <20190723072248.6844-3-leon@kernel.org>
 <63328bfc11778eb851773872aa30d15796a428d9.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63328bfc11778eb851773872aa30d15796a428d9.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 05:05:19PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-07-23 at 10:22 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > DIM causes to the following warnings during kernel compilation
> > which indicates that tx_profile and rx_profile are supposed to
> > be declared in *.c and not in *.h files.
> >
> > In file included from ./include/rdma/ib_verbs.h:64,
> >                  from ./include/linux/mlx5/device.h:37,
> >                  from ./include/linux/mlx5/driver.h:51,
> >                  from ./include/linux/mlx5/vport.h:36,
> >                  from drivers/infiniband/hw/mlx5/ib_virt.c:34:
> > ./include/linux/dim.h:326:1: warning: _tx_profile_ defined but not
> > used [-Wunused-const-variable=]
> >   326 |
> > tx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
> >       | ^~~~~~~~~~
> > ./include/linux/dim.h:320:1: warning: _rx_profile_ defined but not
> > used [-Wunused-const-variable=]
> >   320 |
> > rx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
> >       | ^~~~~~~~~~
> >
> > Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>
> A similar patch was already submitted to linux-kernel ML,
> "[PATCH] linux/dim: fix -Wunused-const-variable warnings"

Are you talking about this merged patch? If yes, it was incomplete.

ommit bedc0fd0f9b517698193d644f914b33951856fd2
Author: Qian Cai <cai@lca.pw>
Date:   Thu Jul 11 09:55:56 2019 -0400

    RDMA/core: Fix -Wunused-const-variable warnings


>
> I basically asked Qian to do the same as you did in this patch.
> Anyway i guess it is ok to drop that patch and keep this one.
>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
>
> > ---
> >  include/linux/dim.h | 56 -----------------------------------------
> > ----
> >  lib/dim/net_dim.c   | 56
> > +++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+), 56 deletions(-)
> >
> > diff --git a/include/linux/dim.h b/include/linux/dim.h
> > index d3a0fbfff2bb..9fa4b3f88c39 100644
> > --- a/include/linux/dim.h
> > +++ b/include/linux/dim.h
> > @@ -272,62 +272,6 @@ dim_update_sample_with_comps(u16 event_ctr, u64
> > packets, u64 bytes, u64 comps,
> >
> >  /* Net DIM */
> >
> > -/*
> > - * Net DIM profiles:
> > - *        There are different set of profiles for each CQ period
> > mode.
> > - *        There are different set of profiles for RX/TX CQs.
> > - *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
> > - */
> > -#define NET_DIM_PARAMS_NUM_PROFILES 5
> > -#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
> > -#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
> > -#define NET_DIM_DEF_PROFILE_CQE 1
> > -#define NET_DIM_DEF_PROFILE_EQE 1
> > -
> > -#define NET_DIM_RX_EQE_PROFILES { \
> > -	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > -	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > -	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > -	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > -	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > -}
> > -
> > -#define NET_DIM_RX_CQE_PROFILES { \
> > -	{2,  256},             \
> > -	{8,  128},             \
> > -	{16, 64},              \
> > -	{32, 64},              \
> > -	{64, 64}               \
> > -}
> > -
> > -#define NET_DIM_TX_EQE_PROFILES { \
> > -	{1,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
> > -	{8,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
> > -	{32,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
> > -	{64,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
> > -	{128, NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE}   \
> > -}
> > -
> > -#define NET_DIM_TX_CQE_PROFILES { \
> > -	{5,  128},  \
> > -	{8,  64},  \
> > -	{16, 32},  \
> > -	{32, 32},  \
> > -	{64, 32}   \
> > -}
> > -
> > -static const struct dim_cq_moder
> > -rx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
> > -	NET_DIM_RX_EQE_PROFILES,
> > -	NET_DIM_RX_CQE_PROFILES,
> > -};
> > -
> > -static const struct dim_cq_moder
> > -tx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
> > -	NET_DIM_TX_EQE_PROFILES,
> > -	NET_DIM_TX_CQE_PROFILES,
> > -};
> > -
> >  /**
> >   *	net_dim_get_rx_moderation - provide a CQ moderation object for
> > the given RX profile
> >   *	@cq_period_mode: CQ period mode
> > diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
> > index 5bcc902c5388..a4db51c21266 100644
> > --- a/lib/dim/net_dim.c
> > +++ b/lib/dim/net_dim.c
> > @@ -5,6 +5,62 @@
> >
> >  #include <linux/dim.h>
> >
> > +/*
> > + * Net DIM profiles:
> > + *        There are different set of profiles for each CQ period
> > mode.
> > + *        There are different set of profiles for RX/TX CQs.
> > + *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
> > + */
> > +#define NET_DIM_PARAMS_NUM_PROFILES 5
> > +#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
> > +#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
> > +#define NET_DIM_DEF_PROFILE_CQE 1
> > +#define NET_DIM_DEF_PROFILE_EQE 1
> > +
> > +#define NET_DIM_RX_EQE_PROFILES { \
> > +	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > +	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > +	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > +	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > +	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> > +}
> > +
> > +#define NET_DIM_RX_CQE_PROFILES { \
> > +	{2,  256},             \
> > +	{8,  128},             \
> > +	{16, 64},              \
> > +	{32, 64},              \
> > +	{64, 64}               \
> > +}
> > +
> > +#define NET_DIM_TX_EQE_PROFILES { \
> > +	{1,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
> > +	{8,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
> > +	{32,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
> > +	{64,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
> > +	{128, NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE}   \
> > +}
> > +
> > +#define NET_DIM_TX_CQE_PROFILES { \
> > +	{5,  128},  \
> > +	{8,  64},  \
> > +	{16, 32},  \
> > +	{32, 32},  \
> > +	{64, 32}   \
> > +}
> > +
> > +static const struct dim_cq_moder
> > +rx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
> > +	NET_DIM_RX_EQE_PROFILES,
> > +	NET_DIM_RX_CQE_PROFILES,
> > +};
> > +
> > +static const struct dim_cq_moder
> > +tx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
> > +	NET_DIM_TX_EQE_PROFILES,
> > +	NET_DIM_TX_CQE_PROFILES,
> > +};
> > +
> >  struct dim_cq_moder
> >  net_dim_get_rx_moderation(u8 cq_period_mode, int ix)
> >  {
> > --
> > 2.20.1
> >
