Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1427FE54
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390094AbfHBQLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 12:11:04 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36686 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390064AbfHBQLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 12:11:04 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so72860038edq.3
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 09:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc
         :content-transfer-encoding;
        bh=eASq+F52WIMgivHRKrZz5norLwTJlJKT69QV1wwpHXw=;
        b=DLymMHOiVtvFP38XID1eN7fvsO4Tox93pFAJFEbtT0jTVrF3jZpirsZ2EQYFr3qSlo
         UQZ6JXSG+8L2tXPYhdpsLl9LtkNe2LjuYar/0+2tKG7GG4b+n9jYgoqQW7qIN8dIU1uc
         I+MTi6EPAXiAqyKLw2NCkbzYcZpqLv2F5ai46jry7UDtqfyM5RqqPKl10JALodzP2JkY
         6ZLrJ+cIbVCPp51EpiMsiuDsxw4itE4k2zBW1Rwa6C4jSBhxU6bp2tCeYSDqM33OcnbH
         QliSSyt5yZEwmY0GHKPjeWvFViH9ijqq/pbN7aHGHNAVQSr3SBDzsJGuYUeNSU6aUVm4
         QqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc:content-transfer-encoding;
        bh=eASq+F52WIMgivHRKrZz5norLwTJlJKT69QV1wwpHXw=;
        b=bMdu8DmJkiIUyuMwUqPIm8xM12K1YmCiVRx99nxNO4Ql5H9pEx2SYh4+z1FjLwI8QE
         SGhuSNECN6V0i/dj8Ig4aNzC1l88tdmLyb36TVH4tfCh/gYGiHXKO6oCScvdiMG7z4yI
         P3v2IpSBaTm6BrYg01zQCrss4NJsx0w7h/iLMLNTlGpKHd+MCMAkFwK2dPhQT6MRoswO
         la5PGYc/0vjsTLRxJ5kIWE8ybTYPHAH6E5+8gKhKhkipadIymLO2iZwjwY0fgfeWTLtg
         XWT9cMnSW1HyE/v2TpVWt0tSaCbikZbwv6jjNVxESsXdPXsk9CraKisGiFEM7etNvx1z
         wOeA==
X-Gm-Message-State: APjAAAVPXmE+fk1Ydav8SIaMRYWnynjxN0d4ZDBOoZ/fYZbit95ddMoM
        rrLETDOkGQyqOKn/ykL46xMr3ZMyaZUWvFopPQI=
X-Received: by 2002:a17:906:edd7:: with SMTP id sb23mt105216830ejb.309.1564762261766;
 Fri, 02 Aug 2019 09:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190802121020.1181-1-hslester96@gmail.com>
In-Reply-To: <20190802121020.1181-1-hslester96@gmail.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Sat, 3 Aug 2019 00:10:50 +0800
Message-ID: <CANhBUQ1chO0Q6wHJwbKMvp6LkD7qLBRw57xwf1QkBAKaewHs5w@mail.gmail.com>
Subject: Re: [PATCH] net/mlx4_core: Use refcount_t for refcount
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuhong Yuan <hslester96@gmail.com> =E4=BA=8E2019=E5=B9=B48=E6=9C=882=E6=97=
=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=888:10=E5=86=99=E9=81=93=EF=BC=9A
>
> refcount_t is better for reference counters since its
> implementation can prevent overflows.
> So convert atomic_t ref counters to refcount_t.
>
> Also convert refcount from 0-based to 1-based.
>

It seems that directly converting refcount from 0-based
to 1-based is infeasible.
I am sorry for this mistake.

Regards,
Chuhong

> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  .../ethernet/mellanox/mlx4/resource_tracker.c | 90 +++++++++----------
>  1 file changed, 45 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/driv=
ers/net/ethernet/mellanox/mlx4/resource_tracker.c
> index 4356f3a58002..d7e26935fd76 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> @@ -114,7 +114,7 @@ struct res_qp {
>         struct list_head        mcg_list;
>         spinlock_t              mcg_spl;
>         int                     local_qpn;
> -       atomic_t                ref_count;
> +       refcount_t              ref_count;
>         u32                     qpc_flags;
>         /* saved qp params before VST enforcement in order to restore on =
VGT */
>         u8                      sched_queue;
> @@ -143,7 +143,7 @@ static inline const char *mtt_states_str(enum res_mtt=
_states state)
>  struct res_mtt {
>         struct res_common       com;
>         int                     order;
> -       atomic_t                ref_count;
> +       refcount_t              ref_count;
>  };
>
>  enum res_mpt_states {
> @@ -179,7 +179,7 @@ enum res_cq_states {
>  struct res_cq {
>         struct res_common       com;
>         struct res_mtt         *mtt;
> -       atomic_t                ref_count;
> +       refcount_t              ref_count;
>  };
>
>  enum res_srq_states {
> @@ -192,7 +192,7 @@ struct res_srq {
>         struct res_common       com;
>         struct res_mtt         *mtt;
>         struct res_cq          *cq;
> -       atomic_t                ref_count;
> +       refcount_t              ref_count;
>  };
>
>  enum res_counter_states {
> @@ -1050,7 +1050,7 @@ static struct res_common *alloc_qp_tr(int id)
>         ret->local_qpn =3D id;
>         INIT_LIST_HEAD(&ret->mcg_list);
>         spin_lock_init(&ret->mcg_spl);
> -       atomic_set(&ret->ref_count, 0);
> +       refcount_set(&ret->ref_count, 1);
>
>         return &ret->com;
>  }
> @@ -1066,7 +1066,7 @@ static struct res_common *alloc_mtt_tr(int id, int =
order)
>         ret->com.res_id =3D id;
>         ret->order =3D order;
>         ret->com.state =3D RES_MTT_ALLOCATED;
> -       atomic_set(&ret->ref_count, 0);
> +       refcount_set(&ret->ref_count, 1);
>
>         return &ret->com;
>  }
> @@ -1110,7 +1110,7 @@ static struct res_common *alloc_cq_tr(int id)
>
>         ret->com.res_id =3D id;
>         ret->com.state =3D RES_CQ_ALLOCATED;
> -       atomic_set(&ret->ref_count, 0);
> +       refcount_set(&ret->ref_count, 1);
>
>         return &ret->com;
>  }
> @@ -1125,7 +1125,7 @@ static struct res_common *alloc_srq_tr(int id)
>
>         ret->com.res_id =3D id;
>         ret->com.state =3D RES_SRQ_ALLOCATED;
> -       atomic_set(&ret->ref_count, 0);
> +       refcount_set(&ret->ref_count, 1);
>
>         return &ret->com;
>  }
> @@ -1325,10 +1325,10 @@ static int add_res_range(struct mlx4_dev *dev, in=
t slave, u64 base, int count,
>
>  static int remove_qp_ok(struct res_qp *res)
>  {
> -       if (res->com.state =3D=3D RES_QP_BUSY || atomic_read(&res->ref_co=
unt) ||
> +       if (res->com.state =3D=3D RES_QP_BUSY || refcount_read(&res->ref_=
count) !=3D 1 ||
>             !list_empty(&res->mcg_list)) {
>                 pr_err("resource tracker: fail to remove qp, state %d, re=
f_count %d\n",
> -                      res->com.state, atomic_read(&res->ref_count));
> +                      res->com.state, refcount_read(&res->ref_count));
>                 return -EBUSY;
>         } else if (res->com.state !=3D RES_QP_RESERVED) {
>                 return -EPERM;
> @@ -1340,11 +1340,11 @@ static int remove_qp_ok(struct res_qp *res)
>  static int remove_mtt_ok(struct res_mtt *res, int order)
>  {
>         if (res->com.state =3D=3D RES_MTT_BUSY ||
> -           atomic_read(&res->ref_count)) {
> +           refcount_read(&res->ref_count) !=3D 1) {
>                 pr_devel("%s-%d: state %s, ref_count %d\n",
>                          __func__, __LINE__,
>                          mtt_states_str(res->com.state),
> -                        atomic_read(&res->ref_count));
> +                        refcount_read(&res->ref_count));
>                 return -EBUSY;
>         } else if (res->com.state !=3D RES_MTT_ALLOCATED)
>                 return -EPERM;
> @@ -1675,7 +1675,7 @@ static int cq_res_start_move_to(struct mlx4_dev *de=
v, int slave, int cqn,
>         } else if (state =3D=3D RES_CQ_ALLOCATED) {
>                 if (r->com.state !=3D RES_CQ_HW)
>                         err =3D -EINVAL;
> -               else if (atomic_read(&r->ref_count))
> +               else if (refcount_read(&r->ref_count) !=3D 1)
>                         err =3D -EBUSY;
>                 else
>                         err =3D 0;
> @@ -1715,7 +1715,7 @@ static int srq_res_start_move_to(struct mlx4_dev *d=
ev, int slave, int index,
>         } else if (state =3D=3D RES_SRQ_ALLOCATED) {
>                 if (r->com.state !=3D RES_SRQ_HW)
>                         err =3D -EINVAL;
> -               else if (atomic_read(&r->ref_count))
> +               else if (refcount_read(&r->ref_count) !=3D 1)
>                         err =3D -EBUSY;
>         } else if (state !=3D RES_SRQ_HW || r->com.state !=3D RES_SRQ_ALL=
OCATED) {
>                 err =3D -EINVAL;
> @@ -2808,7 +2808,7 @@ int mlx4_SW2HW_MPT_wrapper(struct mlx4_dev *dev, in=
t slave,
>                 goto ex_put;
>
>         if (!phys) {
> -               atomic_inc(&mtt->ref_count);
> +               refcount_inc(&mtt->ref_count);
>                 put_res(dev, slave, mtt->com.res_id, RES_MTT);
>         }
>
> @@ -2845,7 +2845,7 @@ int mlx4_HW2SW_MPT_wrapper(struct mlx4_dev *dev, in=
t slave,
>                 goto ex_abort;
>
>         if (mpt->mtt)
> -               atomic_dec(&mpt->mtt->ref_count);
> +               refcount_dec(&mpt->mtt->ref_count);
>
>         res_end_move(dev, slave, RES_MPT, id);
>         return 0;
> @@ -3007,18 +3007,18 @@ int mlx4_RST2INIT_QP_wrapper(struct mlx4_dev *dev=
, int slave,
>         err =3D mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
>         if (err)
>                 goto ex_put_srq;
> -       atomic_inc(&mtt->ref_count);
> +       refcount_inc(&mtt->ref_count);
>         qp->mtt =3D mtt;
> -       atomic_inc(&rcq->ref_count);
> +       refcount_inc(&rcq->ref_count);
>         qp->rcq =3D rcq;
> -       atomic_inc(&scq->ref_count);
> +       refcount_inc(&scq->ref_count);
>         qp->scq =3D scq;
>
>         if (scqn !=3D rcqn)
>                 put_res(dev, slave, scqn, RES_CQ);
>
>         if (use_srq) {
> -               atomic_inc(&srq->ref_count);
> +               refcount_inc(&srq->ref_count);
>                 put_res(dev, slave, srqn, RES_SRQ);
>                 qp->srq =3D srq;
>         }
> @@ -3113,7 +3113,7 @@ int mlx4_SW2HW_EQ_wrapper(struct mlx4_dev *dev, int=
 slave,
>         if (err)
>                 goto out_put;
>
> -       atomic_inc(&mtt->ref_count);
> +       refcount_inc(&mtt->ref_count);
>         eq->mtt =3D mtt;
>         put_res(dev, slave, mtt->com.res_id, RES_MTT);
>         res_end_move(dev, slave, RES_EQ, res_id);
> @@ -3310,7 +3310,7 @@ int mlx4_HW2SW_EQ_wrapper(struct mlx4_dev *dev, int=
 slave,
>         if (err)
>                 goto ex_put;
>
> -       atomic_dec(&eq->mtt->ref_count);
> +       refcount_dec(&eq->mtt->ref_count);
>         put_res(dev, slave, eq->mtt->com.res_id, RES_MTT);
>         res_end_move(dev, slave, RES_EQ, res_id);
>         rem_res_range(dev, slave, res_id, 1, RES_EQ, 0);
> @@ -3445,7 +3445,7 @@ int mlx4_SW2HW_CQ_wrapper(struct mlx4_dev *dev, int=
 slave,
>         err =3D mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
>         if (err)
>                 goto out_put;
> -       atomic_inc(&mtt->ref_count);
> +       refcount_inc(&mtt->ref_count);
>         cq->mtt =3D mtt;
>         put_res(dev, slave, mtt->com.res_id, RES_MTT);
>         res_end_move(dev, slave, RES_CQ, cqn);
> @@ -3474,7 +3474,7 @@ int mlx4_HW2SW_CQ_wrapper(struct mlx4_dev *dev, int=
 slave,
>         err =3D mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
>         if (err)
>                 goto out_move;
> -       atomic_dec(&cq->mtt->ref_count);
> +       refcount_dec(&cq->mtt->ref_count);
>         res_end_move(dev, slave, RES_CQ, cqn);
>         return 0;
>
> @@ -3539,9 +3539,9 @@ static int handle_resize(struct mlx4_dev *dev, int =
slave,
>         err =3D mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
>         if (err)
>                 goto ex_put1;
> -       atomic_dec(&orig_mtt->ref_count);
> +       refcount_dec(&orig_mtt->ref_count);
>         put_res(dev, slave, orig_mtt->com.res_id, RES_MTT);
> -       atomic_inc(&mtt->ref_count);
> +       refcount_inc(&mtt->ref_count);
>         cq->mtt =3D mtt;
>         put_res(dev, slave, mtt->com.res_id, RES_MTT);
>         return 0;
> @@ -3627,7 +3627,7 @@ int mlx4_SW2HW_SRQ_wrapper(struct mlx4_dev *dev, in=
t slave,
>         if (err)
>                 goto ex_put_mtt;
>
> -       atomic_inc(&mtt->ref_count);
> +       refcount_inc(&mtt->ref_count);
>         srq->mtt =3D mtt;
>         put_res(dev, slave, mtt->com.res_id, RES_MTT);
>         res_end_move(dev, slave, RES_SRQ, srqn);
> @@ -3657,9 +3657,9 @@ int mlx4_HW2SW_SRQ_wrapper(struct mlx4_dev *dev, in=
t slave,
>         err =3D mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
>         if (err)
>                 goto ex_abort;
> -       atomic_dec(&srq->mtt->ref_count);
> +       refcount_dec(&srq->mtt->ref_count);
>         if (srq->cq)
> -               atomic_dec(&srq->cq->ref_count);
> +               refcount_dec(&srq->cq->ref_count);
>         res_end_move(dev, slave, RES_SRQ, srqn);
>
>         return 0;
> @@ -3988,11 +3988,11 @@ int mlx4_2RST_QP_wrapper(struct mlx4_dev *dev, in=
t slave,
>         if (err)
>                 goto ex_abort;
>
> -       atomic_dec(&qp->mtt->ref_count);
> -       atomic_dec(&qp->rcq->ref_count);
> -       atomic_dec(&qp->scq->ref_count);
> +       refcount_dec(&qp->mtt->ref_count);
> +       refcount_dec(&qp->rcq->ref_count);
> +       refcount_dec(&qp->scq->ref_count);
>         if (qp->srq)
> -               atomic_dec(&qp->srq->ref_count);
> +               refcount_dec(&qp->srq->ref_count);
>         res_end_move(dev, slave, RES_QP, qpn);
>         return 0;
>
> @@ -4456,7 +4456,7 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx=
4_dev *dev, int slave,
>         if (mlx4_is_bonded(dev))
>                 mlx4_do_mirror_rule(dev, rrule);
>
> -       atomic_inc(&rqp->ref_count);
> +       refcount_inc(&rqp->ref_count);
>
>  err_put_rule:
>         put_res(dev, slave, vhcr->out_param, RES_FS_RULE);
> @@ -4540,7 +4540,7 @@ int mlx4_QP_FLOW_STEERING_DETACH_wrapper(struct mlx=
4_dev *dev, int slave,
>                        MLX4_QP_FLOW_STEERING_DETACH, MLX4_CMD_TIME_CLASS_=
A,
>                        MLX4_CMD_NATIVE);
>         if (!err)
> -               atomic_dec(&rqp->ref_count);
> +               refcount_dec(&rqp->ref_count);
>  out:
>         put_res(dev, slave, qpn, RES_QP);
>         return err;
> @@ -4702,11 +4702,11 @@ static void rem_slave_qps(struct mlx4_dev *dev, i=
nt slave)
>                                         if (err)
>                                                 mlx4_dbg(dev, "rem_slave_=
qps: failed to move slave %d qpn %d to reset\n",
>                                                          slave, qp->local=
_qpn);
> -                                       atomic_dec(&qp->rcq->ref_count);
> -                                       atomic_dec(&qp->scq->ref_count);
> -                                       atomic_dec(&qp->mtt->ref_count);
> +                                       refcount_dec(&qp->rcq->ref_count)=
;
> +                                       refcount_dec(&qp->scq->ref_count)=
;
> +                                       refcount_dec(&qp->mtt->ref_count)=
;
>                                         if (qp->srq)
> -                                               atomic_dec(&qp->srq->ref_=
count);
> +                                               refcount_dec(&qp->srq->re=
f_count);
>                                         state =3D RES_QP_MAPPED;
>                                         break;
>                                 default:
> @@ -4768,9 +4768,9 @@ static void rem_slave_srqs(struct mlx4_dev *dev, in=
t slave)
>                                                 mlx4_dbg(dev, "rem_slave_=
srqs: failed to move slave %d srq %d to SW ownership\n",
>                                                          slave, srqn);
>
> -                                       atomic_dec(&srq->mtt->ref_count);
> +                                       refcount_dec(&srq->mtt->ref_count=
);
>                                         if (srq->cq)
> -                                               atomic_dec(&srq->cq->ref_=
count);
> +                                               refcount_dec(&srq->cq->re=
f_count);
>                                         state =3D RES_SRQ_ALLOCATED;
>                                         break;
>
> @@ -4805,7 +4805,7 @@ static void rem_slave_cqs(struct mlx4_dev *dev, int=
 slave)
>         spin_lock_irq(mlx4_tlock(dev));
>         list_for_each_entry_safe(cq, tmp, cq_list, com.list) {
>                 spin_unlock_irq(mlx4_tlock(dev));
> -               if (cq->com.owner =3D=3D slave && !atomic_read(&cq->ref_c=
ount)) {
> +               if (cq->com.owner =3D=3D slave && refcount_read(&cq->ref_=
count) =3D=3D 1) {
>                         cqn =3D cq->com.res_id;
>                         state =3D cq->com.from_state;
>                         while (state !=3D 0) {
> @@ -4832,7 +4832,7 @@ static void rem_slave_cqs(struct mlx4_dev *dev, int=
 slave)
>                                         if (err)
>                                                 mlx4_dbg(dev, "rem_slave_=
cqs: failed to move slave %d cq %d to SW ownership\n",
>                                                          slave, cqn);
> -                                       atomic_dec(&cq->mtt->ref_count);
> +                                       refcount_dec(&cq->mtt->ref_count)=
;
>                                         state =3D RES_CQ_ALLOCATED;
>                                         break;
>
> @@ -4900,7 +4900,7 @@ static void rem_slave_mrs(struct mlx4_dev *dev, int=
 slave)
>                                                 mlx4_dbg(dev, "rem_slave_=
mrs: failed to move slave %d mpt %d to SW ownership\n",
>                                                          slave, mptn);
>                                         if (mpt->mtt)
> -                                               atomic_dec(&mpt->mtt->ref=
_count);
> +                                               refcount_dec(&mpt->mtt->r=
ef_count);
>                                         state =3D RES_MPT_MAPPED;
>                                         break;
>                                 default:
> @@ -5144,7 +5144,7 @@ static void rem_slave_eqs(struct mlx4_dev *dev, int=
 slave)
>                                         if (err)
>                                                 mlx4_dbg(dev, "rem_slave_=
eqs: failed to move slave %d eqs %d to SW ownership\n",
>                                                          slave, eqn & 0x3=
ff);
> -                                       atomic_dec(&eq->mtt->ref_count);
> +                                       refcount_dec(&eq->mtt->ref_count)=
;
>                                         state =3D RES_EQ_RESERVED;
>                                         break;
>
> --
> 2.20.1
>
