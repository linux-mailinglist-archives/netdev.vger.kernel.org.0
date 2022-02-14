Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804C84B5D47
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiBNVvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 16:51:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiBNVvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 16:51:41 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE45246669;
        Mon, 14 Feb 2022 13:51:32 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d27so25216473wrb.5;
        Mon, 14 Feb 2022 13:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GjIRoyJj91USYJhsJOt4VTkElHF79+gC5Km5wwm1XGg=;
        b=jYCEsDRuLEPQfhcoVtjjg46hRK8EGNMOXXQP0b/GkxrbVZMCaH+S7+hbIq6wNWRVfQ
         emZW0QvPmMRMLrnuHuP0bsGuKSHWmrGvkePVUV+AwSO467w4Zc88ETOYGmWY0bW2pgfD
         VHh7My/5JF39BLj5QHrH9lj4vy6Tz/4rdJt/GitlIl8ZCuKnoOf27quFj0twDdWeYvoe
         FLZHfv6vopBfZWtmQhqXTBgxfGapky2picMGEiVyOz6SpuC6UjnfcTQCHPf/GYEvPuyi
         9iEj3e5hsdPuf5hJiPEImYRf+MObFoULH+lEI98T0+o6WF/Ky13k2dQ5IWQUzqF9/u94
         RT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GjIRoyJj91USYJhsJOt4VTkElHF79+gC5Km5wwm1XGg=;
        b=bxhQltxLSTMx30SLdGx3g5BoETl/PsAMRAd8e6S5s+saOJ6BhLwkENab22jEGodx1w
         8kiyw0auHyWXgL0W7S81XobW7M3jVs4uA+nsBS26/XvS2rPA8c2jnS7KVBQ8sr7PgBwP
         4Nnb2iKfhLPZJXTa1Lh39bcDWWM3evyA9LJaq4tvkOPfHt85caz6+C4XVmm/my4UQEj/
         5pS79Nn5+e8gmlypzpkGNoy1OM+UYwQfHfDnERhbJi/JQ5IurBi8oNP3103ZTTdBYFkJ
         KXGb4MFLtIR+dh6a00h8YFbGpSqe1C8PQlDR6v9xtMUlm0W3W8YMj+b/2hZ8zICk5JQH
         B9/A==
X-Gm-Message-State: AOAM532G6XW/viHnh7VLmLXIf/IqYUaT0eV3lF453/01RPQXYGuo3Nzw
        XoTFxw3Cq071cNtGU6sM6UA=
X-Google-Smtp-Source: ABdhPJwD52lyAVJmaDI1XSEVhzc/ZzjyBglhUgsNg8+HZ8DnaUQkwjyLXo61yqK39PlJb54USlPo0g==
X-Received: by 2002:adf:da46:: with SMTP id r6mr754754wrl.71.1644875491379;
        Mon, 14 Feb 2022 13:51:31 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id a1sm31423931wrf.42.2022.02.14.13.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 13:51:31 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: make array bt_uuid_any static const
Date:   Mon, 14 Feb 2022 21:51:30 +0000
Message-Id: <20220214215130.66993-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Don't populate the read-only array bt_uuid_any on the stack but
instead make it static const. Also makes the object code a little
smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/bluetooth/mgmt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 914e2f2d3586..4b15b95e61e6 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2269,7 +2269,9 @@ static int remove_uuid(struct sock *sk, struct hci_dev *hdev, void *data,
 	struct mgmt_cp_remove_uuid *cp = data;
 	struct mgmt_pending_cmd *cmd;
 	struct bt_uuid *match, *tmp;
-	u8 bt_uuid_any[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
+	static const u8 bt_uuid_any[] = {
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+	};
 	int err, found;
 
 	bt_dev_dbg(hdev, "sock %p", sk);
-- 
2.34.1

