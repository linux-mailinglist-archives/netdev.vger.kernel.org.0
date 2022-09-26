Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93755EA635
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 14:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiIZMcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 08:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237915AbiIZMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 08:32:13 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC29D98CD
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:10:58 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id 13so13290860ejn.3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=wCtoNENIcVaIAAxqnqE2pnQR3bzcsl3wG7gZ1OCGir8=;
        b=vZJglMoRJphlFWUDNotdGAHMOBdIZZy0MY9ucyUv6VOwjAk6IDq7Er9EKenNn85jpS
         cSTuUCl9aKBevVdNCPu+jDAYAYcw1IOLCj2C6Fl0LSrZjAPIpJqDeavLFQnRIS6HmuTO
         dovsc47umZ2mu/W/pWPcQYlmj/ua7KI17mZNO76drHVD2Rs2q/3hW1dIjUNQLyyn9/cm
         1ptJBG+hl+RpJ/lIBqUd6bM3xPCdAq6f8Jqbfs7YUWxVipiE496y1pcVMxrmP0PpY+zp
         qHawUMJIvkb0uZe5+0l+G/RoUE8y0qw3RTa6DK8p8KADMTsMbOSOP+zIfhjyOb3vnWo1
         81MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=wCtoNENIcVaIAAxqnqE2pnQR3bzcsl3wG7gZ1OCGir8=;
        b=CiOdpzNOk6SIsVdYIGOMwcmJ+BUamT1y/1XmXNaNff8/ZwI4DPTFKwLoeX4aZxb84z
         TdAgT5rUYn475W0j7Nkiod73MTkO6CJn52y6r5068tpxT/RIyH31agiLnJFvy4fNtzyo
         bpDRY9SSopdplTDNz+DFnlzKdj3LWuos1EdOCl5GW4j/PFkK0KaofxbourfTIue8K3sj
         vU/IGP2HA0Z/hdTU/s/xgGJBEsOhvElxU+F4IU1pJtSDX08KaY2UrE7gNx1l4h5+tWv6
         whZ1aDZc2FdIJ8X7/PZMi7PfYwbga6vq4OQxndxzjl2/fUPs/dLPyrd/lG0XpaP7czSw
         E01A==
X-Gm-Message-State: ACrzQf3gsTSocQpwiDdTFsWHFJwl8MWrg9L6/BSYySOcmCBDCGSp1+KL
        EXPAXIKJeYu59QzTMC14xOFZqRNaB3vFJJkkRzE=
X-Google-Smtp-Source: AMsMyM4KmC5O21bX3YGbgxlmVFrG0Pta7osPlyqJq8AHNBoXl4qSLqKHDetouOSJ6agFrgAt4d/7RQ==
X-Received: by 2002:a17:907:2bcf:b0:772:4b8e:6b29 with SMTP id gv15-20020a1709072bcf00b007724b8e6b29mr17112302ejc.412.1664190583221;
        Mon, 26 Sep 2022 04:09:43 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g6-20020a1709061c8600b00779a605c777sm8142164ejh.192.2022.09.26.04.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 04:09:42 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        snelson@pensando.io, drivers@pensando.io, f.fainelli@gmail.com,
        yangyingliang@huawei.com
Subject: [patch net-next 2/3] ice: reorder PF/representor devlink port register/unregister flows
Date:   Mon, 26 Sep 2022 13:09:37 +0200
Message-Id: <20220926110938.2800005-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220926110938.2800005-1-jiri@resnulli.us>
References: <20220926110938.2800005-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Make sure that netdevice is registered/unregistered while devlink port
is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  6 +++---
 drivers/net/ethernet/intel/ice/ice_main.c | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_repr.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8a80da8e910e..938ba8c215cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2988,9 +2988,6 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 	}
 
-	if (vsi->type == ICE_VSI_PF)
-		ice_devlink_destroy_pf_port(pf);
-
 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		ice_rss_clean(vsi);
 
@@ -3048,6 +3045,9 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		}
 	}
 
+	if (vsi->type == ICE_VSI_PF)
+		ice_devlink_destroy_pf_port(pf);
+
 	if (vsi->type == ICE_VSI_VF &&
 	    vsi->agg_node && vsi->agg_node->valid)
 		vsi->agg_node->num_vsis--;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0ccc8a750374..747f27c4e761 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4599,6 +4599,10 @@ static int ice_register_netdev(struct ice_pf *pf)
 	if (!vsi || !vsi->netdev)
 		return -EIO;
 
+	err = ice_devlink_create_pf_port(pf);
+	if (err)
+		goto err_devlink_create;
+
 	err = register_netdev(vsi->netdev);
 	if (err)
 		goto err_register_netdev;
@@ -4606,17 +4610,13 @@ static int ice_register_netdev(struct ice_pf *pf)
 	set_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 	netif_carrier_off(vsi->netdev);
 	netif_tx_stop_all_queues(vsi->netdev);
-	err = ice_devlink_create_pf_port(pf);
-	if (err)
-		goto err_devlink_create;
 
 	devlink_port_type_eth_set(&pf->devlink_port, vsi->netdev);
 
 	return 0;
-err_devlink_create:
-	unregister_netdev(vsi->netdev);
-	clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 err_register_netdev:
+	ice_devlink_destroy_pf_port(pf);
+err_devlink_create:
 	free_netdev(vsi->netdev);
 	vsi->netdev = NULL;
 	clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 0dac67cd9c77..bd31748aae1b 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -377,10 +377,10 @@ static void ice_repr_rem(struct ice_vf *vf)
 	if (!vf->repr)
 		return;
 
-	ice_devlink_destroy_vf_port(vf);
 	kfree(vf->repr->q_vector);
 	vf->repr->q_vector = NULL;
 	unregister_netdev(vf->repr->netdev);
+	ice_devlink_destroy_vf_port(vf);
 	free_netdev(vf->repr->netdev);
 	vf->repr->netdev = NULL;
 #ifdef CONFIG_ICE_SWITCHDEV
-- 
2.37.1

