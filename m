Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66541BB8F9
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 10:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgD1IkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 04:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbgD1IkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 04:40:16 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C093EC03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:40:15 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b18so19477691ilf.2
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgoxFMUdLiKv6yFQpO1kd2XItfoVBOn51NlGT7Acvsc=;
        b=PLbEZO3jlbKqZlVVJgBRLfj7SEU6wisnhvmLrQkzoOMAePFiq5lkMuIW3QIfFmyg/e
         Wa2xIKdnMTUtzLkUrGvhabbs6d8jmo19jxEBT15GOZK96D+H/MILzduMEWNYxZovQHM/
         lUKhQuGHXhEpSfxMkfDstq0qd41XDKx1h4Pks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgoxFMUdLiKv6yFQpO1kd2XItfoVBOn51NlGT7Acvsc=;
        b=tDO7EUjQwwpPrcNRNcPzOvMa1yFvgltRquxzBMjEK4xhyTeWsOKnHNn0JRcPsyErnJ
         ruN67DyCd///h7tslUjm1ehqaGMDncOIV5EaHpbqshMnrfpc9YyAoUF+B5KsDiSMGV6f
         tfB54Mz32E2P9ekYsUY01DXlw+NaSUMtFJu8Zq+Abl+kijJw/zyvzq98t3wzZ4YeS57N
         rDVObjXdEuNqZimhARJ7TtXIv/DSYW9XAgOd8mFULrkWHtkX33u/vKJzvMjyqkCE7TUU
         kM15XbyfTYRPi+We5Atf7bfXTUraVbygVQipmXhF25S1KRS2kZrareTnUtNCaRXA8+pp
         elaA==
X-Gm-Message-State: AGi0Pubgbr4cniKoz1lXJkSCqk1ARl/Bin0juNTdfWiCMbmd79xHqeCp
        G26FUxLf/rRHkR721kBKqOGosbphONgVZpbWBPUiLQ==
X-Google-Smtp-Source: APiQypIAdTyXs7YWsIo8sCRxG+dr/iQlku33KafzPsf93e4INgijwz0ejSHkVEhZCvuC1O+OUPvTzBkDaDUpDCqEj2Y=
X-Received: by 2002:a92:c144:: with SMTP id b4mr24997256ilh.89.1588063214612;
 Tue, 28 Apr 2020 01:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200426071717.17088-1-maorg@mellanox.com> <20200426071717.17088-11-maorg@mellanox.com>
In-Reply-To: <20200426071717.17088-11-maorg@mellanox.com>
From:   Devesh Sharma <devesh.sharma@broadcom.com>
Date:   Tue, 28 Apr 2020 14:09:38 +0530
Message-ID: <CANjDDBji-brbJyDOsAMwmVK5G0z0_4P_YZUVJ33B-jAOvsWO=Q@mail.gmail.com>
Subject: Re: [PATCH V6 mlx5-next 10/16] RDMA: Group create AH arguments in struct
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, Jason Gunthorpe <jgg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org,
        Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com,
        linux-rdma <linux-rdma@vger.kernel.org>, netdev@vger.kernel.org,
        alexr@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 12:47 PM Maor Gottlieb <maorg@mellanox.com> wrote:
>
> Following patch adds additional argument to the create AH function,
> so it make sense to group ah_attr and flags arguments in struct.
>
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> ---
>  drivers/infiniband/core/verbs.c                 |  5 ++++-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c        |  8 +++++---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h        |  2 +-
>  drivers/infiniband/hw/efa/efa.h                 |  3 +--
>  drivers/infiniband/hw/efa/efa_verbs.c           |  6 +++---
>  drivers/infiniband/hw/hns/hns_roce_ah.c         |  5 +++--
>  drivers/infiniband/hw/hns/hns_roce_device.h     |  4 ++--
>  drivers/infiniband/hw/mlx4/ah.c                 | 11 +++++++----
>  drivers/infiniband/hw/mlx4/mlx4_ib.h            |  2 +-
>  drivers/infiniband/hw/mlx5/ah.c                 |  5 +++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h            |  2 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c    |  9 +++++----
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c        |  3 ++-
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.h        |  2 +-
>  drivers/infiniband/hw/qedr/verbs.c              |  4 ++--
>  drivers/infiniband/hw/qedr/verbs.h              |  2 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |  5 +++--
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h |  2 +-
>  drivers/infiniband/sw/rdmavt/ah.c               | 11 ++++++-----
>  drivers/infiniband/sw/rdmavt/ah.h               |  4 ++--
>  drivers/infiniband/sw/rxe/rxe_verbs.c           |  9 +++++----
>  include/rdma/ib_verbs.h                         |  9 +++++++--
>  22 files changed, 66 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 3bfadd8effcc..86be8a54a2d6 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -502,6 +502,7 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
>                                      u32 flags,
>                                      struct ib_udata *udata)
>  {
> +       struct rdma_ah_init_attr init_attr = {};
>         struct ib_device *device = pd->device;
>         struct ib_ah *ah;
>         int ret;
> @@ -521,8 +522,10 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
>         ah->pd = pd;
>         ah->type = ah_attr->type;
>         ah->sgid_attr = rdma_update_sgid_attr(ah_attr, NULL);
> +       init_attr.ah_attr = ah_attr;
> +       init_attr.flags = flags;
>
> -       ret = device->ops.create_ah(ah, ah_attr, flags, udata);
> +       ret = device->ops.create_ah(ah, &init_attr, udata);
>         if (ret) {
>                 kfree(ah);
>                 return ERR_PTR(ret);
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index d98348e82422..5a7c090204c5 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -631,11 +631,12 @@ static u8 bnxt_re_stack_to_dev_nw_type(enum rdma_network_type ntype)
>         return nw_type;
>  }
>
> -int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr,
> -                     u32 flags, struct ib_udata *udata)
> +int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr,
> +                     struct ib_udata *udata)
>  {
>         struct ib_pd *ib_pd = ib_ah->pd;
>         struct bnxt_re_pd *pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
> +       struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>         const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
>         struct bnxt_re_dev *rdev = pd->rdev;
>         const struct ib_gid_attr *sgid_attr;
> @@ -673,7 +674,8 @@ int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr,
>
>         memcpy(ah->qplib_ah.dmac, ah_attr->roce.dmac, ETH_ALEN);
>         rc = bnxt_qplib_create_ah(&rdev->qplib_res, &ah->qplib_ah,
> -                                 !(flags & RDMA_CREATE_AH_SLEEPABLE));
> +                                 !(init_attr->flags &
> +                                   RDMA_CREATE_AH_SLEEPABLE));
>         if (rc) {
>                 ibdev_err(&rdev->ibdev, "Failed to allocate HW AH");
>                 return rc;
Acked-by: Devesh Sharma <devesh.sharma@broadcom.com> for bnxt_re driver.
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> index 18dd46f46cf4..204c0849ba28 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> @@ -170,7 +170,7 @@ enum rdma_link_layer bnxt_re_get_link_layer(struct ib_device *ibdev,
>                                             u8 port_num);
>  int bnxt_re_alloc_pd(struct ib_pd *pd, struct ib_udata *udata);
>  void bnxt_re_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
> -int bnxt_re_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
> +int bnxt_re_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
>                       struct ib_udata *udata);
>  int bnxt_re_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
>  int bnxt_re_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
> diff --git a/drivers/infiniband/hw/efa/efa.h b/drivers/infiniband/hw/efa/efa.h
> index aa7396a1588a..45d519edb4c3 100644
> --- a/drivers/infiniband/hw/efa/efa.h
> +++ b/drivers/infiniband/hw/efa/efa.h
> @@ -153,8 +153,7 @@ int efa_mmap(struct ib_ucontext *ibucontext,
>              struct vm_area_struct *vma);
>  void efa_mmap_free(struct rdma_user_mmap_entry *rdma_entry);
>  int efa_create_ah(struct ib_ah *ibah,
> -                 struct rdma_ah_attr *ah_attr,
> -                 u32 flags,
> +                 struct rdma_ah_init_attr *init_attr,
>                   struct ib_udata *udata);
>  void efa_destroy_ah(struct ib_ah *ibah, u32 flags);
>  int efa_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
> index 5c57098a4aee..454b01b21e6a 100644
> --- a/drivers/infiniband/hw/efa/efa_verbs.c
> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
> @@ -1639,10 +1639,10 @@ static int efa_ah_destroy(struct efa_dev *dev, struct efa_ah *ah)
>  }
>
>  int efa_create_ah(struct ib_ah *ibah,
> -                 struct rdma_ah_attr *ah_attr,
> -                 u32 flags,
> +                 struct rdma_ah_init_attr *init_attr,
>                   struct ib_udata *udata)
>  {
> +       struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>         struct efa_dev *dev = to_edev(ibah->device);
>         struct efa_com_create_ah_params params = {};
>         struct efa_ibv_create_ah_resp resp = {};
> @@ -1650,7 +1650,7 @@ int efa_create_ah(struct ib_ah *ibah,
>         struct efa_ah *ah = to_eah(ibah);
>         int err;
>
> -       if (!(flags & RDMA_CREATE_AH_SLEEPABLE)) {
> +       if (!(init_attr->flags & RDMA_CREATE_AH_SLEEPABLE)) {
>                 ibdev_dbg(&dev->ibdev,
>                           "Create address handle is not supported in atomic context\n");
>                 err = -EOPNOTSUPP;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
> index 8a522e14ef62..5b2f9314edd3 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_ah.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
> @@ -39,13 +39,14 @@
>  #define HNS_ROCE_VLAN_SL_BIT_MASK      7
>  #define HNS_ROCE_VLAN_SL_SHIFT         13
>
> -int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr,
> -                      u32 flags, struct ib_udata *udata)
> +int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
> +                      struct ib_udata *udata)
>  {
>         struct hns_roce_dev *hr_dev = to_hr_dev(ibah->device);
>         const struct ib_gid_attr *gid_attr;
>         struct device *dev = hr_dev->dev;
>         struct hns_roce_ah *ah = to_hr_ah(ibah);
> +       struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>         const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
>         u16 vlan_id = 0xffff;
>         bool vlan_en = false;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index f6b3cf6b95d6..74ef3f0b8b5a 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -1171,8 +1171,8 @@ void hns_roce_bitmap_free_range(struct hns_roce_bitmap *bitmap,
>                                 unsigned long obj, int cnt,
>                                 int rr);
>
> -int hns_roce_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
> -                      u32 flags, struct ib_udata *udata);
> +int hns_roce_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
> +                      struct ib_udata *udata);
>  int hns_roce_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
>  void hns_roce_destroy_ah(struct ib_ah *ah, u32 flags);
>
> diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
> index 02a169f8027b..5f8f8d5c0ce0 100644
> --- a/drivers/infiniband/hw/mlx4/ah.c
> +++ b/drivers/infiniband/hw/mlx4/ah.c
> @@ -141,10 +141,11 @@ static int create_iboe_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
>         return 0;
>  }
>
> -int mlx4_ib_create_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr,
> -                     u32 flags, struct ib_udata *udata)
> -
> +int mlx4_ib_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr,
> +                     struct ib_udata *udata)
>  {
> +       struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
> +
>         if (ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE) {
>                 if (!(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH))
>                         return -EINVAL;
> @@ -167,12 +168,14 @@ int mlx4_ib_create_ah_slave(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
>                             int slave_sgid_index, u8 *s_mac, u16 vlan_tag)
>  {
>         struct rdma_ah_attr slave_attr = *ah_attr;
> +       struct rdma_ah_init_attr init_attr = {};
>         struct mlx4_ib_ah *mah = to_mah(ah);
>         int ret;
>
>         slave_attr.grh.sgid_attr = NULL;
>         slave_attr.grh.sgid_index = slave_sgid_index;
> -       ret = mlx4_ib_create_ah(ah, &slave_attr, 0, NULL);
> +       init_attr.ah_attr = &slave_attr;
> +       ret = mlx4_ib_create_ah(ah, &init_attr, NULL);
>         if (ret)
>                 return ret;
>
> diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> index d188573187fa..182a237b87f7 100644
> --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> @@ -752,7 +752,7 @@ int mlx4_ib_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
>  void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
>  void mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
>
> -int mlx4_ib_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
> +int mlx4_ib_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
>                       struct ib_udata *udata);
>  int mlx4_ib_create_ah_slave(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
>                             int slave_sgid_index, u8 *s_mac, u16 vlan_tag);
> diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
> index 80642dd359bc..9b59348d51b5 100644
> --- a/drivers/infiniband/hw/mlx5/ah.c
> +++ b/drivers/infiniband/hw/mlx5/ah.c
> @@ -68,10 +68,11 @@ static void create_ib_ah(struct mlx5_ib_dev *dev, struct mlx5_ib_ah *ah,
>         }
>  }
>
> -int mlx5_ib_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr,
> -                     u32 flags, struct ib_udata *udata)
> +int mlx5_ib_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
> +                     struct ib_udata *udata)
>
>  {
> +       struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>         struct mlx5_ib_ah *ah = to_mah(ibah);
>         struct mlx5_ib_dev *dev = to_mdev(ibah->device);
>         enum rdma_ah_attr_type ah_type = ah_attr->type;
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index a4e522385de0..524c188cb4b3 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -1180,7 +1180,7 @@ void mlx5_ib_db_unmap_user(struct mlx5_ib_ucontext *context, struct mlx5_db *db)
>  void __mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq);
>  void mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq);
>  void mlx5_ib_free_srq_wqe(struct mlx5_ib_srq *srq, int wqe_index);
> -int mlx5_ib_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
> +int mlx5_ib_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
>                       struct ib_udata *udata);
>  int mlx5_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
>  void mlx5_ib_destroy_ah(struct ib_ah *ah, u32 flags);
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
> index 69a3e4f62fb1..bc3e3d741ca3 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -388,14 +388,15 @@ static void mthca_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
>         mthca_pd_free(to_mdev(pd->device), to_mpd(pd));
>  }
>
> -static int mthca_ah_create(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr,
> -                          u32 flags, struct ib_udata *udata)
> +static int mthca_ah_create(struct ib_ah *ibah,
> +                          struct rdma_ah_init_attr *init_attr,
> +                          struct ib_udata *udata)
>
>  {
>         struct mthca_ah *ah = to_mah(ibah);
>
> -       return mthca_create_ah(to_mdev(ibah->device), to_mpd(ibah->pd), ah_attr,
> -                              ah);
> +       return mthca_create_ah(to_mdev(ibah->device), to_mpd(ibah->pd),
> +                              init_attr->ah_attr, ah);
>  }
>
>  static void mthca_ah_destroy(struct ib_ah *ah, u32 flags)
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
> index 2b7f00ac41b0..6eea02b18968 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
> @@ -155,7 +155,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
>         return status;
>  }
>
> -int ocrdma_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr, u32 flags,
> +int ocrdma_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
>                      struct ib_udata *udata)
>  {
>         u32 *ahid_addr;
> @@ -165,6 +165,7 @@ int ocrdma_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr, u32 flags,
>         u16 vlan_tag = 0xffff;
>         const struct ib_gid_attr *sgid_attr;
>         struct ocrdma_pd *pd = get_ocrdma_pd(ibah->pd);
> +       struct rdma_ah_attr *attr = init_attr->ah_attr;
>         struct ocrdma_dev *dev = get_ocrdma_dev(ibah->device);
>
>         if ((attr->type != RDMA_AH_ATTR_TYPE_ROCE) ||
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
> index 9780afcde780..8b73b3489f3a 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
> @@ -51,7 +51,7 @@ enum {
>         OCRDMA_AH_L3_TYPE_SHIFT         = 0x1D /* 29 bits */
>  };
>
> -int ocrdma_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
> +int ocrdma_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
>                      struct ib_udata *udata);
>  void ocrdma_destroy_ah(struct ib_ah *ah, u32 flags);
>  int ocrdma_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
> index a5bd3adaf90a..d6b94a713573 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -2750,12 +2750,12 @@ int qedr_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
>         return 0;
>  }
>
> -int qedr_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr, u32 flags,
> +int qedr_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
>                    struct ib_udata *udata)
>  {
>         struct qedr_ah *ah = get_qedr_ah(ibah);
>
> -       rdma_copy_ah_attr(&ah->attr, attr);
> +       rdma_copy_ah_attr(&ah->attr, init_attr->ah_attr);
>
>         return 0;
>  }
> diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
> index 18027844eb87..5e02387e068d 100644
> --- a/drivers/infiniband/hw/qedr/verbs.h
> +++ b/drivers/infiniband/hw/qedr/verbs.h
> @@ -70,7 +70,7 @@ int qedr_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr);
>  void qedr_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata);
>  int qedr_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
>                        const struct ib_recv_wr **bad_recv_wr);
> -int qedr_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr, u32 flags,
> +int qedr_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
>                    struct ib_udata *udata);
>  void qedr_destroy_ah(struct ib_ah *ibah, u32 flags);
>
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> index faf7ecd7b3fa..ccbded2d26ce 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> @@ -509,9 +509,10 @@ void pvrdma_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
>   *
>   * @return: 0 on success, otherwise errno.
>   */
> -int pvrdma_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr,
> -                    u32 flags, struct ib_udata *udata)
> +int pvrdma_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
> +                    struct ib_udata *udata)
>  {
> +       struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>         struct pvrdma_dev *dev = to_vdev(ibah->device);
>         struct pvrdma_ah *ah = to_vah(ibah);
>         const struct ib_global_route *grh;
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
> index e4a48f5c0c85..267702226f10 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
> @@ -414,7 +414,7 @@ int pvrdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>  void pvrdma_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
>  int pvrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
>  int pvrdma_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
> -int pvrdma_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
> +int pvrdma_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
>                      struct ib_udata *udata);
>  void pvrdma_destroy_ah(struct ib_ah *ah, u32 flags);
>
> diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
> index ee02c6176007..40480add7dd3 100644
> --- a/drivers/infiniband/sw/rdmavt/ah.c
> +++ b/drivers/infiniband/sw/rdmavt/ah.c
> @@ -98,14 +98,14 @@ EXPORT_SYMBOL(rvt_check_ah);
>   *
>   * Return: 0 on success
>   */
> -int rvt_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr,
> -                 u32 create_flags, struct ib_udata *udata)
> +int rvt_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
> +                 struct ib_udata *udata)
>  {
>         struct rvt_ah *ah = ibah_to_rvtah(ibah);
>         struct rvt_dev_info *dev = ib_to_rvt(ibah->device);
>         unsigned long flags;
>
> -       if (rvt_check_ah(ibah->device, ah_attr))
> +       if (rvt_check_ah(ibah->device, init_attr->ah_attr))
>                 return -EINVAL;
>
>         spin_lock_irqsave(&dev->n_ahs_lock, flags);
> @@ -117,10 +117,11 @@ int rvt_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr,
>         dev->n_ahs_allocated++;
>         spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
>
> -       rdma_copy_ah_attr(&ah->attr, ah_attr);
> +       rdma_copy_ah_attr(&ah->attr, init_attr->ah_attr);
>
>         if (dev->driver_f.notify_new_ah)
> -               dev->driver_f.notify_new_ah(ibah->device, ah_attr, ah);
> +               dev->driver_f.notify_new_ah(ibah->device,
> +                                           init_attr->ah_attr, ah);
>
>         return 0;
>  }
> diff --git a/drivers/infiniband/sw/rdmavt/ah.h b/drivers/infiniband/sw/rdmavt/ah.h
> index bbb4d3bdec4e..40b7123fec76 100644
> --- a/drivers/infiniband/sw/rdmavt/ah.h
> +++ b/drivers/infiniband/sw/rdmavt/ah.h
> @@ -50,8 +50,8 @@
>
>  #include <rdma/rdma_vt.h>
>
> -int rvt_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
> -                 u32 create_flags, struct ib_udata *udata);
> +int rvt_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
> +                 struct ib_udata *udata);
>  void rvt_destroy_ah(struct ib_ah *ibah, u32 destroy_flags);
>  int rvt_modify_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
>  int rvt_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index 9dd4bd7aea92..b8a22af724e8 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -195,15 +195,16 @@ static void rxe_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
>         rxe_drop_ref(pd);
>  }
>
> -static int rxe_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr,
> -                        u32 flags, struct ib_udata *udata)
> +static int rxe_create_ah(struct ib_ah *ibah,
> +                        struct rdma_ah_init_attr *init_attr,
> +                        struct ib_udata *udata)
>
>  {
>         int err;
>         struct rxe_dev *rxe = to_rdev(ibah->device);
>         struct rxe_ah *ah = to_rah(ibah);
>
> -       err = rxe_av_chk_attr(rxe, attr);
> +       err = rxe_av_chk_attr(rxe, init_attr->ah_attr);
>         if (err)
>                 return err;
>
> @@ -211,7 +212,7 @@ static int rxe_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr,
>         if (err)
>                 return err;
>
> -       rxe_init_av(attr, &ah->av);
> +       rxe_init_av(init_attr->ah_attr, &ah->av);
>         return 0;
>  }
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index bbc5cfb57cd2..20ea26810349 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -880,6 +880,11 @@ struct ib_mr_status {
>   */
>  __attribute_const__ enum ib_rate mult_to_ib_rate(int mult);
>
> +struct rdma_ah_init_attr {
> +       struct rdma_ah_attr *ah_attr;
> +       u32 flags;
> +};
> +
>  enum rdma_ah_attr_type {
>         RDMA_AH_ATTR_TYPE_UNDEFINED,
>         RDMA_AH_ATTR_TYPE_IB,
> @@ -2403,8 +2408,8 @@ struct ib_device_ops {
>         void (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
>         int (*alloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
>         void (*dealloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
> -       int (*create_ah)(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
> -                        u32 flags, struct ib_udata *udata);
> +       int (*create_ah)(struct ib_ah *ah, struct rdma_ah_init_attr *attr,
> +                        struct ib_udata *udata);
>         int (*modify_ah)(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
>         int (*query_ah)(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
>         void (*destroy_ah)(struct ib_ah *ah, u32 flags);
> --
> 2.17.2
>
