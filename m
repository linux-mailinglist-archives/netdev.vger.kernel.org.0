Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465F76B7D9C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjCMQdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjCMQdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:33:01 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132B35D8AB;
        Mon, 13 Mar 2023 09:32:22 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id j11so51107765edq.4;
        Mon, 13 Mar 2023 09:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678725117;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=izuBuxwdIPWQ5BlFBYrEudMxJy/3eKoBODl3Q7pVmOg=;
        b=TO9SHC1L76A030IlfBQdRZXsYVblsYUnuEnrg9Jp7bigY9gICjXS9gpdz0+2hHzq9O
         QbhwIllnbRszvTC3+1rjU+Htx/GQft05w9puK7+zIogdV/oGgv3QsuiCUe0NcZRdhg0I
         /bvqDVSy6HcrWvfcb9Ujwz+VZw7RQbuGk/QYI3Nkgz6dJqqCy8yjzJN+bJtWx6dKr/cr
         supZ31QqVRdXJfyvYX4dN8CA3Bm2fCEKBe3IU7ROZAi7UM3K3pXCW3RN+yacyGDFfuI/
         1k4/G0b8NWV1tFRTySYJl0TlT2IlmKqlboe07fqOm2cPIcX1QzpQExVMKKSuzybgy4dT
         Yv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678725117;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izuBuxwdIPWQ5BlFBYrEudMxJy/3eKoBODl3Q7pVmOg=;
        b=uLYaxK+8HdGR0tiNSkkQeAiQ45ZNIzhGisXKSZQtPMzfe/zz801WmF/haInCBWxhoJ
         YGPkoSGfv7gDT+28p8VrbMPuujLdYu7GrPzs56mCJ06CZtF6Oy7zDD28UxlTdMnvQtqU
         8YW5rF17DBMbSP+WRr1oefr66QvuvBh1angPSeQrOHpTPmW9Xk0b7T4Hbb1jJEuJJBXH
         PrqNKUv57L4ztFr5LY0dDtJCBtiD0ho5qsN5cEcFpel57XCrgGEWBo9o1rNOztL2CQT7
         CdwdIYK4Sop2sv8+n1MtAA1qJT27y6gj/9sCFgKNtkYwpGvbj9yn6uRzAui8i+KMcc1d
         OlZw==
X-Gm-Message-State: AO0yUKVCxFuFSCQnmnOY8sRuD/0KXwoAOL11bc7wurCE6QfiL254UUZb
        JM0NZEE9tbXbca559/rJzIGwE/m2aS7WJZdH
X-Google-Smtp-Source: AK7set/EfQ2Eu+Z0rlqqlk9uoROfYt6ba42FXHP99LpzKZ2/SvQ9MQr3forX2MDa4CtuYQQWwKeLtw==
X-Received: by 2002:a17:906:308e:b0:8b1:3ba7:723b with SMTP id 14-20020a170906308e00b008b13ba7723bmr32930522ejv.30.1678725116892;
        Mon, 13 Mar 2023 09:31:56 -0700 (PDT)
Received: from [127.0.1.1] (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id lc22-20020a170906dff600b00922b009fc79sm2816144ejc.164.2023.03.13.09.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:31:56 -0700 (PDT)
From:   Jakob Koschel <jkl820.git@gmail.com>
Date:   Mon, 13 Mar 2023 17:31:50 +0100
Subject: [PATCH net] ice: fix invalid check for empty list in
 ice_sched_assoc_vsi_to_agg()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-ice-fix-invalid-iterator-found-check-v1-1-87c26deed999@gmail.com>
X-B4-Tracking: v=1; b=H4sIAPVPD2QC/x2NQQ7CMAwEv1L5jKW0gQtfQRycxCEW4CCnrZCq/
 p2U42i0sxs0NuEG12ED41WaVO0wngaIhfTBKKkzTG7yzrsRJTJm+aLoSi9JKDMbzdUw10UTxsL
 xiY48X8LZpxw89FSgxhiMNJYj9qbWV4f4GPfY//8GyjPc9/0H8Gx3HpQAAAA=
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1678725116; l=2303;
 i=jkl820.git@gmail.com; s=20230112; h=from:subject:message-id;
 bh=WjMjEPfty/nItSmP8wasMGB1SdFJhn1Xtbp3MghZjCI=;
 b=jGby7KQI+wBKqCv86pOj7AXtN0VEVq+RnsbhBAVivykpoAIcDyFE8MHkejVkEKHqLu2yKKv3bC2G
 706m/EvgBNjfklWYHPdDXUUnsN/0U77WE5aZpZW+GW19dbh6e313
X-Developer-Key: i=jkl820.git@gmail.com; a=ed25519;
 pk=rcRpP90oZXet9udPj+2yOibfz31aYv8tpf0+ZYOQhyA=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code implicitly assumes that the list iterator finds a correct
handle. If 'vsi_handle' is not found the 'old_agg_vsi_info' was
pointing to an bogus memory location. For safety a separate list
iterator variable should be used to make the != NULL check on
'old_agg_vsi_info' correct under any circumstances.

Additionally Linus proposed to avoid any use of the list iterator
variable after the loop, in the attempt to move the list iterator
variable declaration into the macro to avoid any potential misuse after
the loop. Using it in a pointer comparision after the loop is undefined
behavior and should be omitted if possible [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 4eca8d195ef0..b7682de0ae05 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2788,7 +2788,7 @@ static int
 ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 			   u16 vsi_handle, unsigned long *tc_bitmap)
 {
-	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info = NULL;
+	struct ice_sched_agg_vsi_info *agg_vsi_info, *iter, *old_agg_vsi_info = NULL;
 	struct ice_sched_agg_info *agg_info, *old_agg_info;
 	struct ice_hw *hw = pi->hw;
 	int status = 0;
@@ -2806,11 +2806,13 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 	if (old_agg_info && old_agg_info != agg_info) {
 		struct ice_sched_agg_vsi_info *vtmp;
 
-		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
+		list_for_each_entry_safe(iter, vtmp,
 					 &old_agg_info->agg_vsi_list,
 					 list_entry)
-			if (old_agg_vsi_info->vsi_handle == vsi_handle)
+			if (iter->vsi_handle == vsi_handle) {
+				old_agg_vsi_info = iter;
 				break;
+			}
 	}
 
 	/* check if entry already exist */

---
base-commit: eeac8ede17557680855031c6f305ece2378af326
change-id: 20230301-ice-fix-invalid-iterator-found-check-0a3e5b43dfb3

Best regards,
-- 
Jakob Koschel <jkl820.git@gmail.com>

