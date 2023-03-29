Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF646CDA3B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjC2NPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjC2NPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:15:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162A44239
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680095691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WPdjBuNFJA01CaowYyCwadzYirboBSCd7QNKpN6vC7Y=;
        b=Dfbbs+ief9aEMFY3GVOm+gZ877dLRHrEnd42T1HG3NyT5TgU9exw90egfkmLdmTc9ds0/n
        csTKeToOWD3nVMtIs+VLQIdvTEQ5BsJfOoZURDR2xUAIUk10LitaKxzrYn3WrlP9biWTO5
        m43MWGRLzq4XqLFj/t91eCbW4gV5F0s=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-kslVgU_MPSi0WNVlUCXa4Q-1; Wed, 29 Mar 2023 09:14:49 -0400
X-MC-Unique: kslVgU_MPSi0WNVlUCXa4Q-1
Received: by mail-qt1-f200.google.com with SMTP id h6-20020ac85846000000b003e3c23d562aso10228469qth.1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680095689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPdjBuNFJA01CaowYyCwadzYirboBSCd7QNKpN6vC7Y=;
        b=LQGQwR569l5R5nVGvNT6hNbl5h5+vr3CaWWsXvC+HE76l4Owbhwu+tg03jBW54R8X1
         6nTqU1Fpe2Mq05BF/b+Onv5KXnpdh1MjSaJZOY9SjBv3iuOhbpKu2axmXkjHy6RDyEJX
         OpvL/wl4jJLjt24TEeCZt+N1Bu/u0jaiS9ubVG6Afo4edB8SXY1lWPydkGtbQWBUzE/c
         3gY8Uzvv36gXvGs5hHEVjGi9EjjXRwkDdMmck1Pc5UwKg6oENwOy8r0x+Yxznw78PMwh
         ipT9JyQNPTC13dHm8zVOwRo/5p967BYF6+N9cslIk6A5JZD3fv9J5kWda7/sUZYRxoQ/
         R1Jg==
X-Gm-Message-State: AAQBX9daNg3jdjkSgOrRfXYjVRTPFEB40s9iEM2kNeYX66NeF3bmS47B
        g+Ew9E+Di6D2PHPNiSrb/UKlgVod0rLcdIfUpe7bDTbmTHvzElLl1A/3983H/fAqngyglyyOCy/
        IkUbuiOmp4/Urgn++
X-Received: by 2002:a05:622a:1aaa:b0:3e0:b1cc:40e1 with SMTP id s42-20020a05622a1aaa00b003e0b1cc40e1mr3420391qtc.34.1680095689087;
        Wed, 29 Mar 2023 06:14:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350aFSwrLO0P2h8zzqcnjlp0S/1t1QpJlUafJta+Wduz8ax0ZCRHmpsFg7r/2A3p9mPdMpRZMcw==
X-Received: by 2002:a05:622a:1aaa:b0:3e0:b1cc:40e1 with SMTP id s42-20020a05622a1aaa00b003e0b1cc40e1mr3420351qtc.34.1680095688803;
        Wed, 29 Mar 2023 06:14:48 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f66-20020a37d245000000b00745f3200f54sm18486229qkj.112.2023.03.29.06.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 06:14:48 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] mwifiex: remove unused evt_buf variable
Date:   Wed, 29 Mar 2023 09:14:44 -0400
Message-Id: <20230329131444.1809018-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/wireless/marvell/mwifiex/11h.c:198:6: error: variable
  'evt_buf' set but not used [-Werror,-Wunused-but-set-variable]
        u8 *evt_buf;
            ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/marvell/mwifiex/11h.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11h.c b/drivers/net/wireless/marvell/mwifiex/11h.c
index b0c40a776a2e..2ea03725f188 100644
--- a/drivers/net/wireless/marvell/mwifiex/11h.c
+++ b/drivers/net/wireless/marvell/mwifiex/11h.c
@@ -195,7 +195,6 @@ int mwifiex_11h_handle_chanrpt_ready(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_chan_rpt_event *rpt_event;
 	struct mwifiex_ie_types_chan_rpt_data *rpt;
-	u8 *evt_buf;
 	u16 event_len, tlv_len;
 
 	rpt_event = (void *)(skb->data + sizeof(u32));
@@ -208,8 +207,6 @@ int mwifiex_11h_handle_chanrpt_ready(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	evt_buf = (void *)&rpt_event->tlvbuf;
-
 	while (event_len >= sizeof(struct mwifiex_ie_types_header)) {
 		rpt = (void *)&rpt_event->tlvbuf;
 		tlv_len = le16_to_cpu(rpt->header.len);
@@ -231,7 +228,6 @@ int mwifiex_11h_handle_chanrpt_ready(struct mwifiex_private *priv,
 			break;
 		}
 
-		evt_buf += (tlv_len + sizeof(rpt->header));
 		event_len -= (tlv_len + sizeof(rpt->header));
 	}
 
-- 
2.27.0

