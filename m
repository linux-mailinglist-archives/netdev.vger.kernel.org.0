Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D853A4CA554
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 13:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbiCBM54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 07:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242011AbiCBM5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 07:57:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10936C249E
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 04:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646225829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4tvH7/UPfOujZY4vvMaOBTun4bBist9qqxPve17cRH0=;
        b=PXsoNd1FyhdPPq9GiLEoXkGdBasgBcJDYaSfjSdTBq/8Eo1IYSQuVMcBZP96cMNE6WcLt0
        H3WwBmpwXKMNxwlmaOLCBPLyANNXtL36KACmpNxG8geJ02tndGwqaYjspUBSWtA6322wME
        d8y46ZT6fMwhy9h3REah6YnwLbev7Qo=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-JzigqbhiOziytljMKptpsA-1; Wed, 02 Mar 2022 07:57:08 -0500
X-MC-Unique: JzigqbhiOziytljMKptpsA-1
Received: by mail-oi1-f197.google.com with SMTP id g5-20020a0568080dc500b002d73eb5c37fso986577oic.16
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 04:57:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4tvH7/UPfOujZY4vvMaOBTun4bBist9qqxPve17cRH0=;
        b=I7T0Q3enLsa7ch5jjkmWWTMVH7SfKUn/nv+ardXLmIcXps7CU47BdF+BPLiPCF5rMq
         3Slc/aXXOi8pm/OfWC3eW6kCsEzemoIDGjXB/2iSDAjyKwdCBFWFgAGW+BbUnncKhWoi
         aqEpUzzj/CDp4a6emM5IPO8+Z5h+ZzCxkUi+XwePiwvTa9H2e8pxZPDXYGgFXmSdWdZ6
         YWUoPjPTjF5HYHcCQIYDa30R+qqjqipEq4PFyPpEfg7MDMhQm+CN6qfdGseke6bemNTC
         N2bPO2FBYDLbPjBMC02/xWSVHai1neOwrfOWwVkbGw2GXnjxGz3ODwHNBHIfKBXn5nn5
         kVrw==
X-Gm-Message-State: AOAM531IwSk6wFKCgwe0PC0hMfpYjKWDuhyEk+wfL9UFZ3x/kMzhhu1u
        YBgkBTLJD7NwJMh3RZeZgj+1VcIpmXqEpFrOnxh03BO/mBpB8Eh3VxxPPyk5a1+T6U01VQKTArq
        88BnAnEGZbcIYUzk2
X-Received: by 2002:a05:6870:238c:b0:d6:f796:c98e with SMTP id e12-20020a056870238c00b000d6f796c98emr7520497oap.82.1646225827388;
        Wed, 02 Mar 2022 04:57:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+HJAWOIaiYoffWdK1JHVICQZFHgy9ZPQ2SGyYS6IGnckQm6gVc5ccom6k+N2+elbCInqJoA==
X-Received: by 2002:a05:6870:238c:b0:d6:f796:c98e with SMTP id e12-20020a056870238c00b000d6f796c98emr7520491oap.82.1646225827239;
        Wed, 02 Mar 2022 04:57:07 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id e199-20020a4a55d0000000b0031ca56292bbsm2816774oob.46.2022.03.02.04.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 04:57:06 -0800 (PST)
From:   trix@redhat.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] i40e: little endian only valid checksums
Date:   Wed,  2 Mar 2022 04:57:02 -0800
Message-Id: <20220302125702.358999-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The calculation of the checksum can fail.
So move converting the checksum to little endian
to inside the return status check.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_nvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_nvm.c b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
index fe6dca846028f..3a38bf8bcde7e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_nvm.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
@@ -682,10 +682,11 @@ i40e_status i40e_update_nvm_checksum(struct i40e_hw *hw)
 	__le16 le_sum;
 
 	ret_code = i40e_calc_nvm_checksum(hw, &checksum);
-	le_sum = cpu_to_le16(checksum);
-	if (!ret_code)
+	if (!ret_code) {
+		le_sum = cpu_to_le16(checksum);
 		ret_code = i40e_write_nvm_aq(hw, 0x00, I40E_SR_SW_CHECKSUM_WORD,
 					     1, &le_sum, true);
+	}
 
 	return ret_code;
 }
-- 
2.26.3

