Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C3929A590
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 08:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507712AbgJ0Hd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 03:33:59 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42068 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730835AbgJ0Hd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 03:33:59 -0400
Received: by mail-ed1-f66.google.com with SMTP id v19so362726edx.9
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 00:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=66vHYoqa6whG3krPCX3D1qlK8K0wfzKnD+NhnstScx4=;
        b=UZOXxG3bGkBnD4zUM9ftQaqXBZD6Ucwwz0WqPGWeeWRwT6D1h5CNWiwzjY1BIZ6ZGO
         F+MSFrj/YMoo/xKicz3tYnaGe6yiGyfCS+eKhYbAWmwJp74sChijjKLa8Zq66JWRlQTg
         es9tjx0s5c36vfLv9PagXlsxaBaUuMK81il0oScnIuJd0nt5Jx7jlynafJWA0nsvIzAa
         2PptitjzFoKIYSYZ89cxz4yiQNURKkcs80teeD7S7KonGhos1I4tusCH0tsHm/En03IZ
         oPPnOmnsjNuVov9nkdFPnEOcrAHSOcKtU8/NJpLQoldSZHDpWXJPpO+o0L8baCotUh+b
         a5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=66vHYoqa6whG3krPCX3D1qlK8K0wfzKnD+NhnstScx4=;
        b=ALXxlFPjuG66jNXUgsk/xK3VH1CtnJtNXCXlHS98uuTS85VXjTTNs4hJSoiHLrDJhx
         JMeOKJ/UY3q7nUTHeAP9nFm2y5oTeBDDBh1RS4VDmWf/tRUjrw8bg6ckLj51WQhDNJrZ
         6UDCkeG6sWd94RkWTSpd+ntnGiM69xWORaSLjliTPH6JcWyJeJf7uhqiC7GiphgHcWpL
         b2SSWKVLC6DzaJLjnCfQ1wSUowG7UbsA/20yApYwUUooRu0a0ORSgxZoamO9fUMAUo9z
         u3UKiMV6LGmSkduFpm5uG+TaiQfhjm4CfvNfV9TD3T2RpnpAwTp6pCHpcQDpBbe5lpkS
         d4GA==
X-Gm-Message-State: AOAM530aN1addFY21jEEkxYYvVPvpEb3UEjO1GRqJbnfPgOQzFvFw4xN
        oDIPPIT7iEo3XFKcKvO10rMREa5ScmZPcmBqSO5X6k7BAPg=
X-Google-Smtp-Source: ABdhPJwovVYMOgNA6lm9ValuONtBFeUvdbi0QJpCmUz1VYt5VbCBXmATuHDW5H8plOfkX7+mj2n5DJcOXdjPz0g8ESI=
X-Received: by 2002:a50:e40c:: with SMTP id d12mr835831edm.35.1603784036319;
 Tue, 27 Oct 2020 00:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 27 Oct 2020 08:33:45 +0100
Message-ID: <CAMGffEn-bOgELLb1rTg9W+f2Hqd6A46T1rkDZegKov8TrAkDxA@mail.gmail.com>
Subject: Re: [PATCH] RDMA: Add rdma_connect_locked()
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 3:25 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> There are two flows for handling RDMA_CM_EVENT_ROUTE_RESOLVED, either the
> handler triggers a completion and another thread does rdma_connect() or
> the handler directly calls rdma_connect().
>
> In all cases rdma_connect() needs to hold the handler_mutex, but when
> handler's are invoked this is already held by the core code. This causes
> ULPs using the 2nd method to deadlock.
>
> Provide a rdma_connect_locked() and have all ULPs call it from their
> handlers.
>
> Reported-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Fixes: 2a7cec538169 ("RDMA/cma: Fix locking for the RDMA_CM_CONNECT state"
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/core/cma.c            | 39 +++++++++++++++++++++---
>  drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c   |  4 +--
>  drivers/nvme/host/rdma.c                 | 10 +++---
>  include/rdma/rdma_cm.h                   | 13 +-------
>  net/rds/ib_cm.c                          |  5 +--
>  6 files changed, 47 insertions(+), 26 deletions(-)
>
> Seems people are not testing these four ULPs against rdma-next.. Here is a
> quick fix for the issue:
>
> https://lore.kernel.org/r/3b1f7767-98e2-93e0-b718-16d1c5346140@cloud.ionos.com
>
> Jason
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 7c2ab1f2fbea37..2eaaa1292fb847 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -405,10 +405,10 @@ static int cma_comp_exch(struct rdma_id_private *id_priv,
>         /*
>          * The FSM uses a funny double locking where state is protected by both
>          * the handler_mutex and the spinlock. State is not allowed to change
> -        * away from a handler_mutex protected value without also holding
> +        * to/from a handler_mutex protected value without also holding
>          * handler_mutex.
>          */
> -       if (comp == RDMA_CM_CONNECT)
> +       if (comp == RDMA_CM_CONNECT || exch == RDMA_CM_CONNECT)
>                 lockdep_assert_held(&id_priv->handler_mutex);
>
>         spin_lock_irqsave(&id_priv->lock, flags);
> @@ -4038,13 +4038,20 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
>         return ret;
>  }
>
> -int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
> +/**
> + * rdma_connect_locked - Initiate an active connection request.
> + * @id: Connection identifier to connect.
> + * @conn_param: Connection information used for connected QPs.
> + *
> + * Same as rdma_connect() but can only be called from the
> + * RDMA_CM_EVENT_ROUTE_RESOLVED handler callback.
> + */
> +int rdma_connect_locked(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
>  {
>         struct rdma_id_private *id_priv =
>                 container_of(id, struct rdma_id_private, id);
>         int ret;
>
> -       mutex_lock(&id_priv->handler_mutex);
>         if (!cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_CONNECT)) {
>                 ret = -EINVAL;
>                 goto err_unlock;
> @@ -4071,6 +4078,30 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
>  err_state:
>         cma_comp_exch(id_priv, RDMA_CM_CONNECT, RDMA_CM_ROUTE_RESOLVED);
>  err_unlock:
> +       return ret;
> +}
> +EXPORT_SYMBOL(rdma_connect_locked);
> +
> +/**
> + * rdma_connect - Initiate an active connection request.
> + * @id: Connection identifier to connect.
> + * @conn_param: Connection information used for connected QPs.
> + *
> + * Users must have resolved a route for the rdma_cm_id to connect with by having
> + * called rdma_resolve_route before calling this routine.
> + *
> + * This call will either connect to a remote QP or obtain remote QP information
> + * for unconnected rdma_cm_id's.  The actual operation is based on the
> + * rdma_cm_id's port space.
> + */
> +int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
> +{
> +       struct rdma_id_private *id_priv =
> +               container_of(id, struct rdma_id_private, id);
> +       int ret;
> +
> +       mutex_lock(&id_priv->handler_mutex);
> +       ret = rdma_connect_locked(id, conn_param);
>         mutex_unlock(&id_priv->handler_mutex);
>         return ret;
>  }
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index 2f3ebc0a75d924..2bd18b00689341 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -620,7 +620,7 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
>         conn_param.private_data = (void *)&req_hdr;
>         conn_param.private_data_len = sizeof(struct iser_cm_hdr);
>
> -       ret = rdma_connect(cma_id, &conn_param);
> +       ret = rdma_connect_locked(cma_id, &conn_param);
>         if (ret) {
>                 iser_err("failure connecting: %d\n", ret);
>                 goto failure;
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> index 776e89231c52f7..f298adc02acba2 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -1674,9 +1674,9 @@ static int rtrs_rdma_route_resolved(struct rtrs_clt_con *con)
>         uuid_copy(&msg.sess_uuid, &sess->s.uuid);
>         uuid_copy(&msg.paths_uuid, &clt->paths_uuid);
>
> -       err = rdma_connect(con->c.cm_id, &param);
> +       err = rdma_connect_locked(con->c.cm_id, &param);
>         if (err)
> -               rtrs_err(clt, "rdma_connect(): %d\n", err);
> +               rtrs_err(clt, "rdma_connect_locked(): %d\n", err);
>
>         return err;
>  }
For rtrs, looks good to me!
Thanks for the quick fix.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
