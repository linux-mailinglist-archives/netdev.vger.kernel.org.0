Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03F04C0B4A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 05:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbiBWEz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 23:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiBWEz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 23:55:27 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CC45DE6E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:54:59 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id p7so5892896qvk.11
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5NTt4ZRD2gIM9lqtl05BkQj1DQPcSxM4o/1x49c91yo=;
        b=K9uOMxwBv4H5YFzZxD5qU+OW81LOG7cWBYyo7WyRmn5gr4gv99IPOjTpB/Za8BVazL
         nxhJ5j9NX5N0VHVXZYSLBOkiqCiDEZSwWTCZ6v8X8d9aQp6IyOpyEVapUWFFtvMU0UkY
         kCedGw0VZG7fI0F5uW2wfSzsP8LWjgyXlLfSCe95Vnmm5OK0DsoakcMLJ0b5I5+kRY3m
         61Cil0NSnas5n2lPojb1W2fT7aYrrebtCk9hQHjgt1QU2DsF+Oc4Y1uBB9fgDfAKNmuK
         mbc6fATgntxYGf8Br9BhhaoRsL4YfweOEkD79D4/rGdUXru0f2HXEzVvCluRdbYmysol
         fvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5NTt4ZRD2gIM9lqtl05BkQj1DQPcSxM4o/1x49c91yo=;
        b=o2ZhsGWJk1J/mRoh6gP40uxb25fhK4sgglDaLIApqdaM391GVFODhtC9Wv/gnJ5Bmo
         8y8jZDpyRYp2gmgdVnP34dBQdG3fbNdmoIe1uoL7mP5L+s/I1qdlbws1PeUgniL9OMTI
         gxvjl+PE/Z/iaenw3IGvFL53dq+02xvmS2EVKSYNsre5OP9vzBrX7ndhhy1Wg9n5GjZV
         slYpXwFisrt3tYpRGDI3vv8jJzqb1Hn40MGi1KXhvaSqiHcGYtDj+DPlspDDYBrMOT2m
         3oaGm0egnolIRtnZLWRJfjoG+30adP3biNyvvDev9EYtHcxQxC8/yhrzJJrebl/zEGnI
         VkdQ==
X-Gm-Message-State: AOAM5333nhTfpH6y7dcU0Cp6/XXvLF2hQ5t16LAmg9Lw8gr/8PdCG9RR
        +WtRjPrWi62QyBswNmMZco6cIAnFk1o=
X-Google-Smtp-Source: ABdhPJxAAbS239rDKfn925V1JPyQn7osATVOwVsz02ISfbth1gE8+rZZ+taVLOAL2vq4b2k4zEbBZw==
X-Received: by 2002:a05:6214:4114:b0:432:5ec4:8e63 with SMTP id kc20-20020a056214411400b004325ec48e63mr1167872qvb.91.1645592098747;
        Tue, 22 Feb 2022 20:54:58 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x12sm1403351qtw.9.2022.02.22.20.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 20:54:58 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        william.xuanziyang@huawei.com
Subject: [PATCH net-next] Revert "vlan: move dev_put into vlan_dev_uninit"
Date:   Tue, 22 Feb 2022 23:54:57 -0500
Message-Id: <563c0a6e48510ccbff9ef4715de37209695e9fc4.1645592097.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit d6ff94afd90b0ce8d1715f8ef77d4347d7a7f2c0.

Since commit faab39f63c1f ("net: allow out-of-order netdev unregistration")
fixed the issue in a better way, this patch is to revert the previous fix,
as it might bring back the old problem fixed by commit 563bcbae3ba2 ("net:
vlan: fix a UAF in vlan_dev_real_dev()").

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/8021q/vlan_dev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index d1902828a18a..e5d23e75572a 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -638,12 +638,7 @@ void vlan_dev_free_egress_priority(const struct net_device *dev)
 
 static void vlan_dev_uninit(struct net_device *dev)
 {
-	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-
 	vlan_dev_free_egress_priority(dev);
-
-	/* Get rid of the vlan's reference to real_dev */
-	dev_put_track(vlan->real_dev, &vlan->dev_tracker);
 }
 
 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
@@ -856,6 +851,9 @@ static void vlan_dev_free(struct net_device *dev)
 
 	free_percpu(vlan->vlan_pcpu_stats);
 	vlan->vlan_pcpu_stats = NULL;
+
+	/* Get rid of the vlan's reference to real_dev */
+	dev_put_track(vlan->real_dev, &vlan->dev_tracker);
 }
 
 void vlan_setup(struct net_device *dev)
-- 
2.31.1

