Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6983A5C5E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 07:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhFNFX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 01:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhFNFXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 01:23:24 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACE3C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 22:21:06 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so9678054oth.9
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 22:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6pmLxWs71BcZar1YX3kjCzCiOIk0BwpspwBEQaBnxgA=;
        b=KkwpNz/KXb4EeOBILmv4CnVky0cpyxZAZnXlK+0nt8aSrxbiTygyA29BVTRUvVUS7o
         ollcFkTYBwVeIIRUAQHh2gtIyTJOHWzn+X+NhVHInFa5mf8lm1MW+F42FdFHZGWGDcTa
         fGByoXUwjwKV1/Fl4xGalgQOHI6OX8DSri5RJ+8/OJ2+FzIMxpK+GNETkUCmGStjWb0L
         7rsH4D2IC1jhyTnRTtenx47S+K/BlaPnM1l63vWwOhmS5T5rezwjP5o3uikjbQuKIA/D
         3rTM6EhdfYxpY+Ce8PWgectKfbBo2XMeiiPVyjneNN+ZYPfpMBeYpBNuUF3UOCmKMlyP
         52xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6pmLxWs71BcZar1YX3kjCzCiOIk0BwpspwBEQaBnxgA=;
        b=F/Uh6IVgAkNm3kfqP6tRVRIgBG+IT+1bGIWpKrSSD/TT0ZvQdKqzX1QhxSBVmuhxWg
         B2htvQxDRohu5I+IZ4ITeKqaC6rPzMidmXiwnS0BswceQTcQjwM2tRPpmZsSzHH3cBpl
         x9UPwNsE/3UrAHSr2iuGwJgIMaM39uAgixKcvl+GnG/AP9l0Ijx9+MPqKd54xnylgR6V
         GqEMjUE+DM3ipciLlwxSGiET5v1dPuDuSaf7T0QJaHi4Sfqvj6Gys6ouRVc6K2cShX7y
         xmr2oFZPiOye3QqeaScHel3FEB3Urb0K2Kz9Wuqh634+XKDuf87RUQsHBr6gDK9qigA/
         CpCw==
X-Gm-Message-State: AOAM532IFI/VBRQWSwS6RZtzZ6B7Ybp/aLLQ5dkNfwJZPJ7LARwx7EQR
        JX7uQN50rjPKgGntaDO4Yms1w6H+btRM3Q==
X-Google-Smtp-Source: ABdhPJwWW7llhu8RC3SvhWI+PQnglQqLUsOSFiKXBh/vyIxNthBDQZrd5tJOW9Qev5cmesU6BmPWSg==
X-Received: by 2002:a05:6830:1f05:: with SMTP id u5mr11739249otg.322.1623648063117;
        Sun, 13 Jun 2021 22:21:03 -0700 (PDT)
Received: from fedora.attlocal.net ([2600:1700:271:1a80::2d])
        by smtp.gmail.com with ESMTPSA id v14sm3090942ote.15.2021.06.13.22.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 22:21:02 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next] ibmvnic: fix send_request_map incompatible argument
Date:   Mon, 14 Jun 2021 00:20:45 -0500
Message-Id: <20210614052045.28523-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 3rd argument is u32 by function definition while it is __be32
by function declaration.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 99eddb2c8e36..2d8804ebdf96 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -95,7 +95,7 @@ static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *,
 					struct ibmvnic_sub_crq_queue *);
 static int ibmvnic_poll(struct napi_struct *napi, int data);
 static void send_query_map(struct ibmvnic_adapter *adapter);
-static int send_request_map(struct ibmvnic_adapter *, dma_addr_t, __be32, u8);
+static int send_request_map(struct ibmvnic_adapter *, dma_addr_t, u32, u8);
 static int send_request_unmap(struct ibmvnic_adapter *, u8);
 static int send_login(struct ibmvnic_adapter *adapter);
 static void send_query_cap(struct ibmvnic_adapter *adapter);
-- 
2.23.0

