Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DADB1F0870
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 22:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgFFUBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 16:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgFFUB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 16:01:29 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C7C08C5C2
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 13:01:29 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n141so13431151qke.2
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 13:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Pq6RzQqJCNvdcxNmu8B5Dj+UAbb2+P92x9klLCwkTg=;
        b=snyxI1RFz4ks9PuyfJj3AxurO0chMruanXZ4FnuGVI+PtJ8+px+72zjIAOr27ekn0D
         XraBfMx3R5YFIXc+cr9zw/rejrQL8CWlZ0zjvmMv4l4UWQay4UWiUC0IlVINrxGJKUDE
         VFuKWUUtwEetvUMSTSW6J/SBJGIgCMxpuZ6vMAETDsC2fT9gY+G0B2gwP76MwCRxhRvh
         /8XNqPoimET0t01e5gPHwEi95jaPxlulGpbcGkM/IK0mG/CGlfX7o+uaapqaUCoEvchF
         4no8e2CQFkig7qtwEXrh0zgYaVsVXM1Ahiu7llTifsB69tg6rTxIcI5y0N6FZOBfXnKE
         pLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Pq6RzQqJCNvdcxNmu8B5Dj+UAbb2+P92x9klLCwkTg=;
        b=GtiREQc7tMVHqvKhG84mUoh4QmQ1cKoPQLCnFS8HJWkTFmKBFSALQyE8wUXHlGM4B4
         +OpXNwJbNHbnkRihlVc3E7W6Io77on6kBMfRJ8jY/vlAGah2kdd/kmrfFDVfd8ZKLFZ/
         wlriJORVGrUXwn8f0GRRWSFuZ28fx3HMLpw4G2c2o2K52CDZfFVvGv1nmh/Ro+3GzrnC
         RISGVzHovKwOAWxP0EwS9gyuCHxns65g9gRsaM/tWpXz8ASjrFoWtmp9E2NVvrVodPS6
         sXKELQTlRXvDxwq7q+Cx31ueRsxEmdG55J7vA07yWaYP9+WzAJQXQcQMe4U8HAtqqQjZ
         3I3g==
X-Gm-Message-State: AOAM531C9dCDPAkygfTpB8JQCU5DJoBvilpHaLukzKwOwcv+89nhTsBg
        jJ8MeXnRFw4D6u1fubGPzCJ+OQ==
X-Google-Smtp-Source: ABdhPJxaj9ZWumNwHhmlL7/HI4iCEPKtVDD/DQlVN8Qr2cveSXoE+w30VfvYEcyRHG62uRqGgA9R8Q==
X-Received: by 2002:a37:4595:: with SMTP id s143mr16482248qka.449.1591473688461;
        Sat, 06 Jun 2020 13:01:28 -0700 (PDT)
Received: from ovpn-112-93.phx2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id e1sm3170960qto.51.2020.06.06.13.01.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jun 2020 13:01:27 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     jeffrey.t.kirsher@intel.com
Cc:     sergey.nemov@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] i40e: silence an UBSAN false positive
Date:   Sat,  6 Jun 2020 16:01:16 -0400
Message-Id: <20200606200116.1398-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtchnl_rss_lut.lut is used for the RSS lookup table, but in
i40e_vc_config_rss_lut(), it is indexed by subscript results in a false
positive.

 UBSAN: array-index-out-of-bounds in drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:2983:15
 index 1 is out of range for type 'u8 [1]'
 CPU: 34 PID: 871 Comm: kworker/34:2 Not tainted 5.7.0-next-20200605+ #5
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 03/09/2018
 Workqueue: i40e i40e_service_task [i40e]
 Call Trace:
  dump_stack+0xa7/0xea
  ubsan_epilogue+0x9/0x45
  __ubsan_handle_out_of_bounds+0x6f/0x80
  i40e_vc_process_vf_msg+0x457c/0x4660 [i40e]
  i40e_service_task+0x96c/0x1ab0 [i40e]
  process_one_work+0x57d/0xbd0
  worker_thread+0x63/0x5b0
  kthread+0x20c/0x230
  ret_from_fork+0x22/0x30

Fixes: d510497b8397 ("i40e: add input validation for virtchnl handlers")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 56b9e445732b..d5a959d91ba9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2971,6 +2971,7 @@ static int i40e_vc_config_rss_lut(struct i40e_vf *vf, u8 *msg)
 	struct i40e_vsi *vsi = NULL;
 	i40e_status aq_ret = 0;
 	u16 i;
+	u8 *lut = vrl->lut;
 
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vrl->vsi_id) ||
@@ -2980,13 +2981,13 @@ static int i40e_vc_config_rss_lut(struct i40e_vf *vf, u8 *msg)
 	}
 
 	for (i = 0; i < vrl->lut_entries; i++)
-		if (vrl->lut[i] >= vf->num_queue_pairs) {
+		if (lut[i] >= vf->num_queue_pairs) {
 			aq_ret = I40E_ERR_PARAM;
 			goto err;
 		}
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
-	aq_ret = i40e_config_rss(vsi, NULL, vrl->lut, I40E_VF_HLUT_ARRAY_SIZE);
+	aq_ret = i40e_config_rss(vsi, NULL, lut, I40E_VF_HLUT_ARRAY_SIZE);
 	/* send the response to the VF */
 err:
 	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT,
-- 
2.21.0 (Apple Git-122.2)

