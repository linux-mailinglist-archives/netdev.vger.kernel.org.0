Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D63252433
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHYXcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHYXcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:32:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84CCC061755
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:32:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b127so310713ybh.21
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=NtMj2bcsf5T/oy70A+QWn2i5VysKtCM7HUSW6c9Q/F8=;
        b=OF4V+BTAnjuhDpqLAN3ENPlRr166XM4CkXsvkYoyGn409D3rDgpiebFFLDw3Nb3Sxj
         BL4V0wcGv2ATKHvLcee8AHM0nUKWjzsZbBj+ieulmIkxuwpuoBtqwNegR45YD34zu7aC
         9tFk5w88uXhMfV7TRO1pi9MuE3bMy003AifqjPEfhTk39BZVIfI18OtrDorwPG5KYpvb
         ERmyQ5x4uP/FIWisIJEHWGLlwJXhCKFP3ObP0its4rrZwGSatjaXpqixLyPksut9mBC4
         O2gjlb6++NyKz2/y/kiuddgVOJbTFe3KPqKaqrWlAGxd+akzqOmCD/b/jeSp4HiPh8cH
         MgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NtMj2bcsf5T/oy70A+QWn2i5VysKtCM7HUSW6c9Q/F8=;
        b=BFzoI3cOTEXPny72eD5Xfm4lveuTZ3PcrVMz+J6c1PU555VgKiGDa88poxeFaGTaE+
         n83g0fqSCo+27U4BPC40AByO8ZtkWK4T0oTCt267JBb3st080c5Xg9i9mJ+KTkLk46K2
         6D+JUD4R5PtOWUoHQrTbokZom1P0WQM1w102y8I4ZOEP00SA6QHkjS4BxZwf/k5tichB
         6+ht89KM5r7xQXHf8pBltdgUfz/y7I9iexNbb5VLvbc8cTijPTc9mduSMuZvgBqQwD8G
         nbA/xa0P5Uo/vuaaHuppgtSYqH0Xke2jYD8w1FB8ynRevcc+27tf13sJnZjFiREBvPO4
         HDkA==
X-Gm-Message-State: AOAM531spJPYEy62fE6Jjj9rojBpRvF/siSZkQXORAh87+ViuFFUWWWW
        bUoozj/JceXMpf7Bz+uzrOJ8yfTcp6ROoGOn72kE
X-Google-Smtp-Source: ABdhPJyYcNHSnzxlABPklRA+Q1XOh563ginyu6oORioyUTcYQOT0k/q9zvtSpJqy2O7Bu2rS8xH9F5r60KnWDXBAYgzF
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a25:428a:: with SMTP id
 p132mr17184715yba.453.1598398329019; Tue, 25 Aug 2020 16:32:09 -0700 (PDT)
Date:   Tue, 25 Aug 2020 16:31:51 -0700
In-Reply-To: <20200825233151.1580920-1-danielwinkler@google.com>
Message-Id: <20200825163120.2.I569943db89c40c4007ef7290d145c9f3d023932f@changeid>
Mime-Version: 1.0
References: <20200825233151.1580920-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH 2/2] bluetooth: Add MGMT capability flags for tx power and ext advertising
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For new advertising features, it will be important for userspace to
know the capabilities of the controller and kernel. If the controller
and kernel support extended advertising, we include flags indicating
hardware offloading support and support for setting tx power of adv
instances.

In the future, vendor-specific commands may allow the setting of tx
power in advertising instances, but for now this feature is only
marked available if extended advertising is supported.

This change is manually verified in userspace by ensuring the
advertising manager's supported_flags field is updated with new flags on
hatch chromebook (ext advertising supported).

Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

 include/net/bluetooth/mgmt.h | 2 ++
 net/bluetooth/mgmt.c         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index beae5c3980f03b..9ad505b9e694e4 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -572,6 +572,8 @@ struct mgmt_rp_add_advertising {
 #define MGMT_ADV_FLAG_SEC_1M 		BIT(7)
 #define MGMT_ADV_FLAG_SEC_2M 		BIT(8)
 #define MGMT_ADV_FLAG_SEC_CODED 	BIT(9)
+#define MGMT_ADV_FLAG_CAN_SET_TX_POWER	BIT(10)
+#define MGMT_ADV_FLAG_HW_OFFLOAD	BIT(11)
 
 #define MGMT_ADV_FLAG_SEC_MASK	(MGMT_ADV_FLAG_SEC_1M | MGMT_ADV_FLAG_SEC_2M | \
 				 MGMT_ADV_FLAG_SEC_CODED)
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 8041c9cebd5cf6..c5d128f331c6dc 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7202,6 +7202,8 @@ static u32 get_supported_adv_flags(struct hci_dev *hdev)
 
 	if (ext_adv_capable(hdev)) {
 		flags |= MGMT_ADV_FLAG_SEC_1M;
+		flags |= MGMT_ADV_FLAG_HW_OFFLOAD;
+		flags |= MGMT_ADV_FLAG_CAN_SET_TX_POWER;
 
 		if (hdev->le_features[1] & HCI_LE_PHY_2M)
 			flags |= MGMT_ADV_FLAG_SEC_2M;
-- 
2.28.0.297.g1956fa8f8d-goog

