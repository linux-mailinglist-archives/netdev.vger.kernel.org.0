Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF1B1FAE95
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgFPKv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgFPKv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:51:28 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C302C08C5C2
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 03:51:28 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id y13so20998218eju.2
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 03:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G7k8h6oMxtrY9029/gMSLA+xs52V/3lxIx7VL1w38fA=;
        b=jaXfXWhwO52SuwQavSVbdul8B7FAJ48ehh7dynLF8raADEGHE5dDXZaz1aeJen3bF0
         TC4ROqKb6YcVC8kqJ1Qb/xzu/0AKoFDU/4tEMpJS6ZtD9Rn2LrkU0hgFgwgzzjZT2goC
         av9SfBcIohyp4hBhab44JG4xW3lexsFu5dBv5vylJ0Eoa+xdlIEXIYju1S/n8vlgcBoz
         HZ9BSXzCWhOe1d4wjAXwYYndPzdsBpyXKb0XoHD/IVkytvBjXDeN41Rn99esN0vKnRqD
         umdbSYzKtd7e14W44uF9oZTSTYoaaAijB1T4082FlgouRyBPrKqlPEI5lsbOE0yjSYn5
         y0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G7k8h6oMxtrY9029/gMSLA+xs52V/3lxIx7VL1w38fA=;
        b=KrpeRFanZMEldCRYfUdVpY87mHb58ugmQABcXv5mR5M6PWfEuvj/Yz38i60DWvDkHi
         XFcpHaKWCppqJqfB59Bm6aqnJRrv1Shg1TZ+9Pg3BiQ5PbAC7Q44uh1e71HDmWpI7o4l
         fub5a7cdGn+eJUtTbPz+ADgOKvBvlAgBkdG1BrfrbzLbJ01QjN/igrwocxgooeZGJE60
         CG3WexwflGp9EsyuguvQMC+IXNiWwbmm8pBAfH1ulfai+6EopseHONoLYRuh/zeRFjeG
         S4makRTji1Bj8eryKLEcLJFcr1GgxKsBNU2W5IbDVQuQI/ZqreFO2JRFf04wreGVnPKC
         Zzqw==
X-Gm-Message-State: AOAM530bqgBjQ1RJltLpgcIWwZ/9Wv5qgxAVLhHBXrp9iH9X+X92m1/K
        dUPHgisRMGcRyBaiOigXN6fyb6PXgRs=
X-Google-Smtp-Source: ABdhPJym1mnF5egKIWRI0L8timYJDTYhuUMoSCqH+R6rXGRuYuLOXwk4a3QxpLHWfF6Z5xVvyEmioA==
X-Received: by 2002:a17:906:2c44:: with SMTP id f4mr2251980ejh.183.1592304687187;
        Tue, 16 Jun 2020 03:51:27 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id l24sm7660567ejb.5.2020.06.16.03.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 03:51:26 -0700 (PDT)
Date:   Tue, 16 Jun 2020 12:51:25 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
Message-ID: <20200616105123.GA21396@netronome.com>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:19:38AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the function __flow_block_indr_cleanup, The match stataments
> this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
> is totally different data with the flow_indr_dev->cb_priv.
> 
> Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
> the driver.
> 
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Hi Wenxu,

I wonder if this can be resolved by using the cb_ident field of struct
flow_block_cb.

I observe that mlx5e_rep_indr_setup_block() seems to be the only call-site
where the value of the cb_ident parameter of flow_block_cb_alloc() is
per-block rather than per-device. So part of my proposal is to change
that.

The other part of my proposal is to make use of cb_ident in
__flow_block_indr_cleanup(). Which does seem to match the intended
purpose of cb_ident. Perhaps it would also be good to document what
the intended purpose of cb_ident (and the other fields of struct
flow_block_cb) is.

Compile tested only.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index a62bcf0cf512..4de6fcae5252 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -438,7 +438,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
+		block_cb = flow_block_cb_alloc(setup_cb, rpriv, indr_priv,
 					       mlx5e_rep_indr_block_unbind);
 		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index b288d2f03789..d281fb182894 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -373,14 +373,13 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 EXPORT_SYMBOL(flow_indr_dev_register);
 
 static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
-				      void *cb_priv,
+				      void *cb_ident,
 				      struct list_head *cleanup_list)
 {
 	struct flow_block_cb *this, *next;
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
-		if (this->release == release &&
-		    this->cb_priv == cb_priv) {
+		if (this->release == release && this->cb_ident == cb_ident) {
 			list_move(&this->indr.list, cleanup_list);
 			return;
 		}
