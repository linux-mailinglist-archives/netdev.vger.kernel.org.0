Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E193D3D4A3C
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhGXVIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 17:08:11 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43816
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229982AbhGXVHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 17:07:43 -0400
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id F36083F351
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 21:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627163291;
        bh=ov7yn4H0ornXwxrX1ZBFt/XnbBsClxe6Xsh+B5h5Cag=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=BjN0/bNBaiaHopwYXYLf3BdjG40rIjk9OiBA7Am9VklfQ3JD2ee+x5ZgiGtm9KM4e
         ZGr56xLuygUtRzN0watEHfSjmWidd6bhi1OjPqrmaXrrFP6bLoCoY3aNLxbR0FWolR
         URPbx4ZSC6BfpiKJ+F5RjeMzt77v2q0Z68WUhR2bwXHCSgcqenbPm8BodLx5iU2xwZ
         iKxO3SeO6tuBN9TDHlX9GTtFq48aF8RTCJX3qBepy+BsFOvqsyOmUNMHl79PWrFBAX
         U3iaQKDuB3HOUnsJ2v5ziIEoGGHBZ/pzFEk8pWMu9gehaodnm7OTYnEjXOsI0Ds/en
         6+WTOrTwW5a8A==
Received: by mail-ej1-f71.google.com with SMTP id p6-20020a17090635c6b02904f7606bd58fso1063913ejb.11
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ov7yn4H0ornXwxrX1ZBFt/XnbBsClxe6Xsh+B5h5Cag=;
        b=UZldUX0FJcvQIBMZiG5EsmeN1FkX6wqADM+JTGHH8TC2XYiqOdsRpk1POpvvFUe75Y
         7BBg4P2gG1afoN14cQDLJDTaiORsAIiaIGauTCRcw/nJhpdbjDOdLOw05SnbCf/bVX1N
         MPOCjX94FS/NvydeuMX/92RMnX1e8wpckpelul+FNbjyQyChhBjjDIpwgrHERrh3ZowT
         d0IhoNRVKyDVy8wqnfXPWi000qLSkKfzdechzvjdkeoDxJ/k+F2g5dm+Sv8SWouEuRjy
         a5+tNa2k9oaks3wthY2mUpcxG21XyTit1Rs0Qfaj/41vtt5phHk0qjmppURs+i0bjMGo
         xgew==
X-Gm-Message-State: AOAM532WZDxRObOcnmUz4rG7S7F2mw+LwFwiUqEpxjik9h6oKLnRnzuV
        I2K9/00YUQJVe/Vw0Bwed1+7Cnw2ivRImEXieixk3VySqG88ieqw5/xrHfg+kJV8O4Lxhu2ucqa
        RPL97c7nCOXi3MKUqCy4nckPnXLywbZdd/A==
X-Received: by 2002:a17:906:5e4c:: with SMTP id b12mr10085421eju.230.1627163288266;
        Sat, 24 Jul 2021 14:48:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4DjgiuYIHPq50fWezEY5ArO3iNlytrDP/udlFADjFqzzpxgUDWdNRebg5J3N9yopeTwgO0Q==
X-Received: by 2002:a17:906:5e4c:: with SMTP id b12mr10085415eju.230.1627163288139;
        Sat, 24 Jul 2021 14:48:08 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id j5sm8383005edv.10.2021.07.24.14.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:48:07 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 01/12] nfc: constify payload argument in nci_send_cmd()
Date:   Sat, 24 Jul 2021 23:47:32 +0200
Message-Id: <20210724214743.121884-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
References: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nci_send_cmd() payload argument is passed directly to skb_put_data()
which already accepts a pointer to const, so make it const as well for
correctness and safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 include/net/nfc/nci_core.h | 2 +-
 net/nfc/nci/core.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 1df0f8074c9d..bf573eca07ca 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -360,7 +360,7 @@ int nci_core_rsp_packet(struct nci_dev *ndev, __u16 opcode,
 int nci_core_ntf_packet(struct nci_dev *ndev, __u16 opcode,
 			struct sk_buff *skb);
 void nci_rx_data_packet(struct nci_dev *ndev, struct sk_buff *skb);
-int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, void *payload);
+int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, const void *payload);
 int nci_send_data(struct nci_dev *ndev, __u8 conn_id, struct sk_buff *skb);
 int nci_conn_max_data_pkt_payload_size(struct nci_dev *ndev, __u8 conn_id);
 void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index da7fe9db1b00..09967b836361 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1332,7 +1332,7 @@ int nci_send_frame(struct nci_dev *ndev, struct sk_buff *skb)
 EXPORT_SYMBOL(nci_send_frame);
 
 /* Send NCI command */
-int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, void *payload)
+int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, const void *payload)
 {
 	struct nci_ctrl_hdr *hdr;
 	struct sk_buff *skb;
-- 
2.27.0

