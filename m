Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1547557E111
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiGVL5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiGVL46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:56:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94A5BB212
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:56 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r6so5531411edd.7
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=03MRB+asuYHEWRjNWyWQYFq+NaD83n6aClneexveW8M=;
        b=VtV9tIueqyAIzh5ghN54ab7O0Qjq2qjh7hr5zpWjHFAwQ9wiO7A7x/9R0KEbP9LdqX
         Q/dRZ2DZbJ3q3fEbKtD/jF3a1Fz80ErXsw4xQSOgo6ORVUpz+QUSYsxmTeHMVWZY9WWy
         eQBF6of88Gv+pBG2dxc+C3lGk8EvKN8CEt4BA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=03MRB+asuYHEWRjNWyWQYFq+NaD83n6aClneexveW8M=;
        b=f5+qq9dUj3cOg1Anpgx1hdrO5Wel3vWPbvYAsRhhBkM2knwZrJ1aJoqPeafUc0goFw
         Jnw62OjoYE4ZylYjEeN+WyfdgxONZ1LT7V+h75KmiuwOaqIIwUUyi5XZoVdl6vtaDqAi
         zU+rSpwWIonkyhapLqzItOHUtK0u6BeiVrsS1ufWPLBAQT0hJxfYiE0V+ePcN6veNAmi
         zAByHfmGK9mWC8Aac+w9laObQv5oQGsYZ5iZdHCMGnGx6YUpn/9K8FOY3v2AgxvRtaiq
         6nQhHD/cXny/X9hVtR086DLywErSLJqgnvTLlCDmxIyOEmNVlBo8Gk8ToChARQk3or2S
         AbBQ==
X-Gm-Message-State: AJIora+ctGQzhr7BiDSY95eG3IMdQI8OmQRGAXvBuBnrdpVB47pgb849
        ocu4ZSyyoKDYuRkfuJRqU+qY9A==
X-Google-Smtp-Source: AGRyM1tuKPZ19wuvTpZlTKmC8A4+UWEmcvUJCyz7kl2ifrZUs11Q1Rg0a8nm4Kr9s2T0q6nxu3Khug==
X-Received: by 2002:a05:6402:11cb:b0:43a:b592:efbb with SMTP id j11-20020a05640211cb00b0043ab592efbbmr248964edw.157.1658491016413;
        Fri, 22 Jul 2022 04:56:56 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id kx6-20020a170907774600b0072b3182368fsm1934370ejc.77.2022.07.22.04.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 04:56:56 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Wataru Gohda <wataru.gohda@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] brcmfmac: Fix to add brcmf_clear_assoc_ies when rmmod
Date:   Fri, 22 Jul 2022 13:56:29 +0200
Message-Id: <20220722115632.620681-5-alvin@pqrs.dk>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220722115632.620681-1-alvin@pqrs.dk>
References: <20220722115632.620681-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wataru Gohda <wataru.gohda@cypress.com>

Conn_info->req_ie/resp_ie is used to indicate the assoc_req_ies /
assoc_resp_ies to cfg80211 layer when connection is done. The buffer is
freed and allocated again at next connection establishment. The buffers
also needs to be freed at the timing of rmmod as well.

Signed-off-by: Wataru Gohda <wataru.gohda@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 605206abe424..6ef574d69755 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6429,6 +6429,7 @@ static void wl_deinit_priv(struct brcmf_cfg80211_info *cfg)
 	cfg->dongle_up = false;	/* dongle down */
 	brcmf_abort_scanning(cfg);
 	brcmf_deinit_priv_mem(cfg);
+	brcmf_clear_assoc_ies(cfg);
 }
 
 static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
-- 
2.37.0

