Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863D06DED75
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjDLIVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDLIUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:20:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363E165A6
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681287600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrDM6RNDF8iazisvGqbzUFWdh4RCgV/FJAY9/jrsClg=;
        b=O9RCQmrVMd7xNoZSj75+7r6pSyE41q26VwJyRUQfvLmXv0YS5dX4H6JxIgVNLTI4ovpDZE
        GIZpqrgZ8y1J73nQGjf7OJeaGWZ7w7QJTdQqDYP00LPjF33zc4440jUOtcRmbbV77MbIin
        vRiAlcfTZ0ONNg2HA34l/Zg6g1PebEI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-BA94o5TDM0eoeJ4N_aoxmg-1; Wed, 12 Apr 2023 04:19:55 -0400
X-MC-Unique: BA94o5TDM0eoeJ4N_aoxmg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB7121C0754E;
        Wed, 12 Apr 2023 08:19:54 +0000 (UTC)
Received: from toolbox.infra.bos2.lab (ovpn-192-9.brq.redhat.com [10.40.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D49E01415117;
        Wed, 12 Apr 2023 08:19:52 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 3/6] ice: remove ice_ctl_q_info::sq_cmd_timeout
Date:   Wed, 12 Apr 2023 10:19:26 +0200
Message-Id: <20230412081929.173220-4-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-1-mschmidt@redhat.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sq_cmd_timeout is initialized to ICE_CTL_Q_SQ_CMD_TIMEOUT and never
changed, so just use the constant directly.

Suggested-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c | 5 +----
 drivers/net/ethernet/intel/ice/ice_controlq.h | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c2fda4fa4188..f4c256563248 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2000,7 +2000,7 @@ void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res)
 	/* there are some rare cases when trying to release the resource
 	 * results in an admin queue timeout, so handle them correctly
 	 */
-	while ((status == -EIO) && (total_delay < hw->adminq.sq_cmd_timeout)) {
+	while ((status == -EIO) && (total_delay < ICE_CTL_Q_SQ_CMD_TIMEOUT)) {
 		mdelay(1);
 		status = ice_aq_release_res(hw, res, 0, NULL);
 		total_delay++;
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 6bcfee295991..c8fb10106ec3 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -637,9 +637,6 @@ static int ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 		return -EIO;
 	}
 
-	/* setup SQ command write back timeout */
-	cq->sq_cmd_timeout = ICE_CTL_Q_SQ_CMD_TIMEOUT;
-
 	/* allocate the ATQ */
 	ret_code = ice_init_sq(hw, cq);
 	if (ret_code)
@@ -1066,7 +1063,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 
 		udelay(ICE_CTL_Q_SQ_CMD_USEC);
 		total_delay++;
-	} while (total_delay < cq->sq_cmd_timeout);
+	} while (total_delay < ICE_CTL_Q_SQ_CMD_TIMEOUT);
 
 	/* if ready, copy the desc back to temp */
 	if (ice_sq_done(hw, cq)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index c07e9cc9fc6e..e790b2f4e437 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -87,7 +87,6 @@ struct ice_ctl_q_info {
 	enum ice_ctl_q qtype;
 	struct ice_ctl_q_ring rq;	/* receive queue */
 	struct ice_ctl_q_ring sq;	/* send queue */
-	u32 sq_cmd_timeout;		/* send queue cmd write back timeout */
 	u16 num_rq_entries;		/* receive queue depth */
 	u16 num_sq_entries;		/* send queue depth */
 	u16 rq_buf_size;		/* receive queue buffer size */
-- 
2.39.2

