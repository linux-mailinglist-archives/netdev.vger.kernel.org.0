Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9DD4CE570
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 16:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiCEPHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 10:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiCEPHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 10:07:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4432A1C65EE
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 07:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646492817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jzfuT3+UZ/fGMOnKdum70e9dYbgqhz4vQr25uVQN9DA=;
        b=JVDn4Wil3N5HvARWHO3+5zfo+R6lBsvlKBlRKyEm+6T/fs0b5/2tK059EpoID/klQSuSf5
        AAiN7JoiGOJELsHMrXdSALWC0g5SnKOxcAZj5S1R7bLkThn+xKVincpN2WVpkB/ccG94Yg
        LRTs7HspyAXyadjqaeWrtasK9vNgj8I=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-X9n468tmNQylmj92KYexTA-1; Sat, 05 Mar 2022 10:06:56 -0500
X-MC-Unique: X9n468tmNQylmj92KYexTA-1
Received: by mail-qv1-f69.google.com with SMTP id d15-20020a0cb2cf000000b00432e2ddeefaso9365118qvf.23
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 07:06:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jzfuT3+UZ/fGMOnKdum70e9dYbgqhz4vQr25uVQN9DA=;
        b=Ki19dWjE+QyIwkqQFuf3vC01I8l5CAjYjGq3sYJgvKGJgmiRni2KzOQXwYNxGZ0SdJ
         k16w5+weiJ9InQ/Ww0Ra9ouJjEygsm0J3d2G/+6GXWcnyBCXyld6S9OGyvmJIhcOqQDJ
         h/fjbI7xYarJURfdwWpz2icfS39ocWWC3dtKWaCioRmKA5CUXyZEXKiYeSnOZAVMs0OP
         3uqt65053y1snu+6gIlKm4xdgAUmPsbjYdfo1bmm85n03Yxc7YR2hgTNUjxtlmEafD5O
         4hcl7lHlgrm42pyTCakgh/orjOSp5wSgmk8ABRXjn6H6uP9LsfRj2VzAz4B6yMXgPw5f
         Yn0Q==
X-Gm-Message-State: AOAM5331lC1G4e9vv1bLkDbvB1G9lmXw8e5xlL2MPguqw+whWDjsbUkx
        Fne/5QhoBMf1q4x85EsEvFhLNqflV4ZQU6r1UawlycsjfHAKUUq/tFtASkzPwWCQ3AnJBWgXuBV
        3AHBnvf1DUBME2zOb
X-Received: by 2002:a0c:e781:0:b0:42c:4e4f:a6db with SMTP id x1-20020a0ce781000000b0042c4e4fa6dbmr2581488qvn.107.1646492815793;
        Sat, 05 Mar 2022 07:06:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXNODovOUBWo4HOvZzg3rfVWr4dLTHn/VYXWRhOb5U7dn9g/nH3+CwN0NmC7BVIBC0c7RVNw==
X-Received: by 2002:a0c:e781:0:b0:42c:4e4f:a6db with SMTP id x1-20020a0ce781000000b0042c4e4fa6dbmr2581464qvn.107.1646492815534;
        Sat, 05 Mar 2022 07:06:55 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id c6-20020ac87d86000000b002ddd9f33ed1sm5754191qtd.44.2022.03.05.07.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 07:06:55 -0800 (PST)
From:   trix@redhat.com
To:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        Yuval.Mintz@qlogic.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] qed: return status of qed_iov_get_link
Date:   Sat,  5 Mar 2022 07:06:42 -0800
Message-Id: <20220305150642.684247-1-trix@redhat.com>
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

Clang static analysis reports this issue
qed_sriov.c:4727:19: warning: Assigned value is
  garbage or undefined
  ivi->max_tx_rate = tx_rate ? tx_rate : link.speed;
                   ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

link is only sometimes set by the call to qed_iov_get_link()
qed_iov_get_link fails without setting link or returning
status.  So change the decl to return status.

Fixes: 73390ac9d82b ("qed*: support ndo_get_vf_config")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index bf4a95186e55c..0848b5529d48a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -3817,11 +3817,11 @@ bool qed_iov_mark_vf_flr(struct qed_hwfn *p_hwfn, u32 *p_disabled_vfs)
 	return found;
 }
 
-static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
-			     u16 vfid,
-			     struct qed_mcp_link_params *p_params,
-			     struct qed_mcp_link_state *p_link,
-			     struct qed_mcp_link_capabilities *p_caps)
+static int qed_iov_get_link(struct qed_hwfn *p_hwfn,
+			    u16 vfid,
+			    struct qed_mcp_link_params *p_params,
+			    struct qed_mcp_link_state *p_link,
+			    struct qed_mcp_link_capabilities *p_caps)
 {
 	struct qed_vf_info *p_vf = qed_iov_get_vf_info(p_hwfn,
 						       vfid,
@@ -3829,7 +3829,7 @@ static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
 	struct qed_bulletin_content *p_bulletin;
 
 	if (!p_vf)
-		return;
+		return -EINVAL;
 
 	p_bulletin = p_vf->bulletin.p_virt;
 
@@ -3839,6 +3839,7 @@ static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
 		__qed_vf_get_link_state(p_hwfn, p_link, p_bulletin);
 	if (p_caps)
 		__qed_vf_get_link_caps(p_hwfn, p_caps, p_bulletin);
+	return 0;
 }
 
 static int
@@ -4697,6 +4698,7 @@ static int qed_get_vf_config(struct qed_dev *cdev,
 	struct qed_public_vf_info *vf_info;
 	struct qed_mcp_link_state link;
 	u32 tx_rate;
+	int ret;
 
 	/* Sanitize request */
 	if (IS_VF(cdev))
@@ -4710,7 +4712,9 @@ static int qed_get_vf_config(struct qed_dev *cdev,
 
 	vf_info = qed_iov_get_public_vf_info(hwfn, vf_id, true);
 
-	qed_iov_get_link(hwfn, vf_id, NULL, &link, NULL);
+	ret = qed_iov_get_link(hwfn, vf_id, NULL, &link, NULL);
+	if (ret)
+		return ret;
 
 	/* Fill information about VF */
 	ivi->vf = vf_id;
-- 
2.26.3

