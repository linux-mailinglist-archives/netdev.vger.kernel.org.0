Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7373B8DA
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391390AbfFJQDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:03:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35644 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbfFJQDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:03:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id s27so5284093pgl.2;
        Mon, 10 Jun 2019 09:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KGwst6bDkDL8lX+aOaFeYpcRj/960Hn2O4BfzP7Fnyg=;
        b=U1vTE/7Bfwn9gbiS18KVoOJftPL+G5H1SkbHmdIRVwVJlVUh84FUwofcjmINyDHsTd
         5g6dEgmdi60ZjkvUSeDx7YvdtlSrjCD12Kxf8cmTIcnuGvwFJooiVafHQXXsEwzbZdbW
         4rfpF7D3CVpCOcPkw8M2/RXt14sT6nm+xISNlhgJ7ugOaQAwAhN8Hkozs/z51U3zAVj5
         fARSm0K4sCknc1xn9HJnPy0kTMgxj92A14pikSBPxBaJO2Aw+vBpGxjDNvTY+s0An5yH
         6jOf7aTEa6Xx1Bgpui2HTsXXiwZm6qfpeUII+ICrzY+xmzLgmozHljRYzXRSEtc1NKR9
         8BMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KGwst6bDkDL8lX+aOaFeYpcRj/960Hn2O4BfzP7Fnyg=;
        b=hM9beytMEachHoqTyAL2smBA65yLhlpl5nxIMsmnAYXxPnBwSP6AlSHzGMsJ5Ezrw0
         1eDBnXrJGdP9w1eYRiZPqf857ULChH+5GrzxEIVxTvYa75wP/tC9f/uoUBx2UYOt+KQ7
         DJT25DTwgTqk2no8ZXxEE9UH11hgORzzpGtSEouImQF3Lja55NqM9pZ1tRo3MSaKHIWE
         /cwtifdqIjIKdTzsSDRdiweOjkZkaF6Rxd6W0HnPEpHMjxgAplMurAjmDsND7X1MUpE4
         m7AC96GB+UZ5AZ1+tD6oY2l8wumtjlgCizioYW3KV8LlCvNK0TsMA/g/adJZB6hY4ehB
         zFwg==
X-Gm-Message-State: APjAAAXSxaMdvLMw+rxcsWq/Us6bUFa4q/hu0tAUb5agbTNlmac9u10l
        94Qps0FUk248NUFJB6JhE3Q=
X-Google-Smtp-Source: APXvYqxrv8a6o9KyEzxxV/7KWrV+btjncBPiQKLADFWZ0Z4smTyyxjvjMdp223q+hVdVnK5Q2aHuVQ==
X-Received: by 2002:a63:306:: with SMTP id 6mr2868567pgd.263.1560182595919;
        Mon, 10 Jun 2019 09:03:15 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id f5sm10574118pfn.161.2019.06.10.09.03.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:03:15 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, toke@redhat.com, brouer@redhat.com,
        bpf@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com
Subject: [PATCH bpf-next v3 2/5] nfp, netdevsim: use dev_xdp_support_offload() function
Date:   Mon, 10 Jun 2019 18:02:31 +0200
Message-Id: <20190610160234.4070-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610160234.4070-1-bjorn.topel@gmail.com>
References: <20190610160234.4070-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Make all drivers with XDP offloading support use
dev_xdp_support_offload().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c | 7 +++++++
 drivers/net/netdevsim/netdev.c                    | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 986464d4a206..e320cacc95e6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -135,6 +135,13 @@ nfp_net_pf_alloc_vnic(struct nfp_pf *pf, bool needs_netdev,
 			nfp_net_free(nn);
 			return ERR_PTR(err);
 		}
+		if (nn->app && nn->app->type->xdp_offload) {
+			err = dev_xdp_support_offload(nn->dp.netdev);
+			if (err) {
+				nfp_net_free(nn);
+				return ERR_PTR(err);
+			}
+		}
 	}
 
 	pf->num_vnics++;
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e5c8aa08e1cd..26e4fc12cdbe 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -311,6 +311,10 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	SET_NETDEV_DEV(dev, &ns->nsim_bus_dev->dev);
 	dev->netdev_ops = &nsim_netdev_ops;
 
+	err = dev_xdp_support_offload(dev);
+	if (err)
+		goto err_free_netdev;
+
 	rtnl_lock();
 	err = nsim_bpf_init(ns);
 	if (err)
-- 
2.20.1

