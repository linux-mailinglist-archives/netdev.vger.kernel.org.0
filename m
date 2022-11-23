Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E400636A2F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiKWTyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239309AbiKWTxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:53:45 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FF0C7204
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:52:15 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso9338322pjb.6
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Md9ZWXHDLM85YwaZa/3mJElMaCka2JtXSIbE+IlBCds=;
        b=SdZWtsaRUwsnRl7l4iGx3Q8mmajbRUbVsT04AU6mUvnB2mzjIUJAH9DeWSKHkG6XWk
         hD3ytudVB7Lk+nDClU+1crv7MHoU/8Ds1vvdt32/Ftqne2KTcttnFGFLZffwPnJpzs7Z
         nrBqOk08IwQLjdJPzYK6GOSc6gYZdeFP2a0QxB/FJVSGOjabt1ZgyZyoTAbsE9ZK7btW
         aYiGBVvDeVvW8iJ0P2GJjmz8krDfZImkRU1UZvq0YM/Ty8mAxexOqK7c16LYvI7k4dYH
         GMkxa1d4QtmISwHuOfKoa8lzQZJ0WfxSWOZ0wV4I+bQci7JRHvXgZ68WgzqofW+3giyU
         4GYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Md9ZWXHDLM85YwaZa/3mJElMaCka2JtXSIbE+IlBCds=;
        b=GR0tDrc60MG8jo5VKSzBuGH2FJJH/cbAb/Tm2cZYd/qx8y3ID/IT1RgJfpPZvO6tKZ
         THiImOpTWF//e84Udh7iXQLyg3miPhKhJvvhUTDjj91XksFDIJELnFPxz8qu7eYTxcnT
         SPl1bGAjKe/A8FwQq7Ap67mDhqPd9dZY2z2mT0d34+Eat6SvHeqPEJzL5A6O3ZT1aUUc
         CzNf1mlxuyhtlja5J3/8A2aN4YdCWHzcWJMsDLmlEK7Iw1hfRWSQO4RuU7QBmF2AHX1V
         ycUTTpHkwtnkjqK6oAXS30DYPs1dswr/xNEqUlFyBb/kTB/AnA9ewPma/CU3q2g5KOLz
         juGQ==
X-Gm-Message-State: ANoB5pnsD4+YcAzwSelhqUdz10t5F5imsQKBukm53VjubohCjrnYTeho
        FjtucaLML/YKoiX5wHfJ+AClTi4=
X-Google-Smtp-Source: AA0mqf6D3mjyGd46PLpkf4SCynyVivIxr+D0ItYoiaFgU5Sy5wjbFedEvH0VS5j1Oz4Z0Lbp6UOw2V8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:2013:b0:188:f7d0:3952 with SMTP id
 s19-20020a170903201300b00188f7d03952mr9949169pla.164.1669233134546; Wed, 23
 Nov 2022 11:52:14 -0800 (PST)
Date:   Wed, 23 Nov 2022 11:52:12 -0800
In-Reply-To: <20221123111431.7b54668e@kernel.org>
Mime-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-7-sdf@google.com>
 <874jupviyc.fsf@toke.dk> <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
 <20221123111431.7b54668e@kernel.org>
Message-ID: <Y3557Ecr80Y9ZD2z@google.com>
Subject: Re: [xdp-hints] [PATCH bpf-next v2 6/8] mlx4: Introduce mlx4_xdp_buff
 wrapper for xdp_buff
From:   sdf@google.com
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23, Jakub Kicinski wrote:
> On Wed, 23 Nov 2022 10:26:41 -0800 Stanislav Fomichev wrote:
> > > This embedding trick works for drivers that put xdp_buff on the stack,
> > > but mlx5 supports XSK zerocopy, which uses the xsk_buff_pool for
> > > allocating them. This makes it a bit awkward to do the same thing  
> there;
> > > and since it's probably going to be fairly common to do something like
> > > this, how about we just add a 'void *drv_priv' pointer to struct
> > > xdp_buff that the drivers can use? The xdp_buff already takes up a  
> full
> > > cache line anyway, so any data stuffed after it will spill over to a  
> new
> > > one; so I don't think there's much difference performance-wise.
> >
> > I guess the alternative is to extend xsk_buff_pool with some new
> > argument for xdp_buff tailroom? (so it can kmalloc(sizeof(xdp_buff) +
> > xdp_buff_tailroom))
> > But it seems messy because there is no way of knowing what the target
> > device's tailroom is, so it has to be a user setting :-/
> > I've started with a priv pointer in xdp_buff initially, it seems fine
> > to go back. I'll probably convert veth/mlx4 to the same mode as well
> > to avoid having different approaches in different places..

> Can we not do this please? Add 16B of "private driver space" after
> the xdp_buff in xdp_buff_xsk (we have 16B to full cacheline), the
> drivers decide how they use it. Drivers can do BUILD_BUG_ON() for their
> expected size and cast that to whatever struct they want. This is how
> various offloads work, the variable size tailroom would be an over
> design IMO.

> And this way non XSK paths can keep its normal typing.

Good idea, prototyped below, lmk if it that's not what you had in mind.

struct xdp_buff_xsk {
	struct xdp_buff            xdp;                  /*     0    56 */
	u8                         cb[16];               /*    56    16 */
	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
	dma_addr_t                 dma;                  /*    72     8 */
	dma_addr_t                 frame_dma;            /*    80     8 */
	struct xsk_buff_pool *     pool;                 /*    88     8 */
	u64                        orig_addr;            /*    96     8 */
	struct list_head           free_list_node;       /*   104    16 */

	/* size: 120, cachelines: 2, members: 7 */
	/* last cacheline: 56 bytes */
};

Toke, I can try to merge this into your patch + keep your SoB (or feel free
to try this and retest yourself, whatever works).

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h  
b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index bc2d9034af5b..837bf103b871 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -44,6 +44,11 @@
  	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
  	 sizeof(struct mlx5_wqe_inline_seg))

+struct mlx5_xdp_cb {
+	struct mlx5_cqe64 *cqe;
+	struct mlx5e_rq *rq;
+};
+
  struct mlx5e_xsk_param;
  int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param  
*xsk);
  bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c  
b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index c91b54d9ff27..84d23b2da7ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -5,6 +5,7 @@
  #include "en/xdp.h"
  #include <net/xdp_sock_drv.h>
  #include <linux/filter.h>
+#include <linux/build_bug.h>

  /* RX data path */

@@ -286,8 +287,14 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct  
mlx5e_rq *rq,
  					      u32 cqe_bcnt)
  {
  	struct xdp_buff *xdp = wi->au->xsk;
+	struct mlx5_xdp_cb *cb;
  	struct bpf_prog *prog;

+	BUILD_BUG_ON(sizeof(struct mlx5_xdp_cb) > XSKB_CB_SIZE);
+	cb = xp_get_cb(xdp);
+	cb->cqe = NULL /*cqe*/;
+	cb->rq = rq;
+
  	/* wi->offset is not used in this function, because xdp->data and the
  	 * DMA address point directly to the necessary place. Furthermore, the
  	 * XSK allocator allocates frames per packet, instead of pages, so
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index f787c3f524b0..b298590429e7 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -19,8 +19,11 @@ struct xdp_sock;
  struct device;
  struct page;

+#define XSKB_CB_SIZE 16
+
  struct xdp_buff_xsk {
  	struct xdp_buff xdp;
+	u8 cb[XSKB_CB_SIZE]; /* Private area for the drivers to use. */
  	dma_addr_t dma;
  	dma_addr_t frame_dma;
  	struct xsk_buff_pool *pool;
@@ -143,6 +146,11 @@ static inline dma_addr_t xp_get_frame_dma(struct  
xdp_buff_xsk *xskb)
  	return xskb->frame_dma;
  }

+static inline void *xp_get_cb(struct xdp_buff *xdp)
+{
+	return (void *)xdp + offsetof(struct xdp_buff_xsk, cb);
+}
+
  void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb);
  static inline void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
  {

> > > I'll send my patch to add support to mlx5 (using the drv_priv pointer
> > > approach) separately.
> >
> > Saw them, thanks! Will include them in v3+.
