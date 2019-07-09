Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42F7638B0
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfGIPcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:32:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55057 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIPcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:32:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so3547150wme.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 08:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qcq8rUVZZJFGmSSEKqWesXctYfgnV1qKb9FXHbMcaOk=;
        b=Zlk4DMdodU5g3j2MOsJ7Rj5q4xTI/QMrcdiJuGb4jIlNt8t5OpICihtRxc90ORDWyJ
         IcR3a8fEl/OnKwnELLJHCuUcq1ujO4rSzJRZtfO6nM7m75loDMKKrqxdmUVj83yB/DzR
         cYDOeSw23+eF3UpeiOwwrJUe/COb9NcXuE1OSo+rqxQmEmIFjrXMYz99tKcZdVO9XG4T
         7zdVGVmPd9Ecm9ix1s32xUFIh1TWxvEdHrnaw26swhLXLrBMeVdT0ti1cnPbOnu+jL6i
         oRApfCF+d61FsIvLJNA2BccRBsdnvNa946d3LGJ0lQ58exTWK9/3GEgwihTsf7daMo2r
         GFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qcq8rUVZZJFGmSSEKqWesXctYfgnV1qKb9FXHbMcaOk=;
        b=QUPGEjrjd84iT54qntGU1pYFBFFVgy5ZeuPbScuF+yEFKkjGw2qiiozoaGgmzcRm0c
         +ZQfAe26Cqm9TbrGsWXYJ+AGYFpSLrGVJiUdgIzH8xCIty1oMNyEE8W4vLdK9uIGVVih
         3z4HbBtMxqSnVz/LmWkBWttVbA3GftPxJOJN+DavfdIv+f6/105LgKQOMxVf3Jss31K/
         3UwEie7cbNznC9X5R/P1bieiviwop8JDvjAYwcEf3s112obtVMQpoVDLoXqKGD7CIxcX
         d32+u9Mm2yZDJWajB10b6eoxVkuQfGXxzJ36wh9dE8kQ3D/dp0KNPLCCzb6XLrcfAiY+
         S9AQ==
X-Gm-Message-State: APjAAAX4LdBqFC1XTPVYlMIlEg68a4VCrEDR2IRpHXJRKhpaaxdN4DFd
        rh/aSD7aDmpyMjPZPiEuyjg=
X-Google-Smtp-Source: APXvYqyMo1N1NqkecjnE5xNLZ+JVKoDOQNshS/QblGaDTac23oxdwBtSNjElwuOONOKBvpYaD4cMRA==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr469995wmj.155.1562686337365;
        Tue, 09 Jul 2019 08:32:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p14sm2533781wrx.17.2019.07.09.08.32.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:32:17 -0700 (PDT)
Date:   Tue, 9 Jul 2019 17:32:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 14/16] net/mlx5e: Recover from rx timeout
Message-ID: <20190709153216.GG2301@nanopsycho.orion>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-15-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-15-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:06PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Add support for recovery from rx timeout. On driver open we post NOP
>work request on the rx channels to trigger napi in order to fillup the
>rx rings. In case napi wasn't scheduled due to a lost interrupt, perform
>EQ recovery.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>---
> .../net/ethernet/mellanox/mlx5/core/en/health.h    |  1 +
> .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 30 ++++++++++++++++++++++
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  1 +
> 3 files changed, 32 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>index e8c5d3bd86f1..aa46f7ecae53 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>@@ -19,6 +19,7 @@
> int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
> void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
> void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
>+void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq);
> 
> #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
> 
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
>index c47e9a53bd53..7e7dba129330 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
>@@ -109,6 +109,36 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
> 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
> }
> 
>+static int mlx5e_rx_reporter_timeout_recover(void *ctx)
>+{
>+	struct mlx5e_rq *rq = (struct mlx5e_rq *)ctx;

No need to cast. Please fix this in the rest of the patchset too.


>+	struct mlx5e_icosq *icosq = &rq->channel->icosq;
>+	struct mlx5_eq_comp *eq = rq->cq.mcq.eq;
>+	int err;
>+
>+	err = mlx5e_health_channel_eq_recover(eq, rq->channel);
>+	if (err)
>+		clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
>+
>+	return err;
>+}
>+
>+void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
>+{
>+	struct mlx5e_icosq *icosq = &rq->channel->icosq;
>+	struct mlx5e_priv *priv = rq->channel->priv;
>+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
>+	struct mlx5e_err_ctx err_ctx = {};
>+
>+	err_ctx.ctx = rq;
>+	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
>+	sprintf(err_str,
>+		"RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x\n",
>+		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
>+
>+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
>+}
>+
> static int mlx5e_rx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ctx)
> {
> 	return err_ctx->recover(err_ctx->ctx);
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>index 2d57611ac579..1ebdeccf395d 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>@@ -809,6 +809,7 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
> 	netdev_warn(c->netdev, "Failed to get min RX wqes on Channel[%d] RQN[0x%x] wq cur_sz(%d) min_rx_wqes(%d)\n",
> 		    c->ix, rq->rqn, mlx5e_rqwq_get_cur_sz(rq), min_wqes);
> 
>+	mlx5e_reporter_rx_timeout(rq);
> 	return -ETIMEDOUT;
> }
> 
>-- 
>1.8.3.1
>
