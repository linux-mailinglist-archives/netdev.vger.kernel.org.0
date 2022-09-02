Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EB85AB967
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 22:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiIBUWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 16:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiIBUWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 16:22:08 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0293AD4194
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 13:22:07 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u17so3662260wrp.3
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 13:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=iQJz8X3ZfmBeoQMygPe+a+k85PcMpFtijzhfSa4P5T0=;
        b=D+piVbs+gsIfHVYy7DcB7CcCJkMeT701CsPBz9OW0gs2EnqC3VgQyF97O47WtwfvLs
         rtuT7Dl+KCKJQpbXeP8dEt/k0dkG7Jx7tUznWTLNEqzJuaIRkY+OWvMWPt5OnyTuH9g0
         QoSNpea7RrJvdlEB+KPs3yxRWH7dnHnqHEbmF3uqwiTB5Sk3f2Ipmuo/h3HQ3H/ctGt6
         laRKtS0OBvuXQUh5xaouYLX+It1PBYh3oupdyiQCVqjk24bF6MGuf6yTJZiu/WAEsPbn
         NNT8qDseXYXzfZFGfJJo08CVGiJSCotQldJNwsJmlI6290Spf9DRylgu/ZVtzBqvMp19
         vlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=iQJz8X3ZfmBeoQMygPe+a+k85PcMpFtijzhfSa4P5T0=;
        b=TwXMSeCznFwUQ/BhsKdVNlnqNUSxK9KSuElV5Vobi8vXRK/J7V5UufknUEJBUfJeCa
         DqUUSgLWOKJsmTTFb+7+eGFJHBTcec96BSRFAjLsjojEpdl3ISeIRIXtPqq4RpF5+M0d
         Cf7qnxdxTI5MQ/3esmTlEIqDCu9bivdyjgFA7qJhf5bnQy3xYOcoTUMBFwR8Q3yd8NC3
         yej7vy+IJBSyqNzE5JCk/jU3HNSb2J015TNscHoZnjLBPib4iCwRBAMNAvBxejgq+txx
         2XSja4obMNyRpYRyX8A7gpkugezHE1Cr8bKXD+V6AikLhnRQYBLvfE6+SuVREAwmDMiA
         Hwtw==
X-Gm-Message-State: ACgBeo2hHSz+uI8rOQU2Org9dc6aUNpjtkiZ7p4xioGz3hL1VOFbwylv
        zLZFsWooK1+9Zzy1xv1/32YR/TlzknE=
X-Google-Smtp-Source: AA6agR5wbbpED7IGTGnAdeQ1nNIfz0Rta+gz1WoivArcQFVxGUgTW4mCbVDpcsVVtRVfiXEWGswXGg==
X-Received: by 2002:a05:6000:1e1e:b0:226:e5c9:4b08 with SMTP id bj30-20020a0560001e1e00b00226e5c94b08mr10979646wrb.648.1662150125496;
        Fri, 02 Sep 2022 13:22:05 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c4c2:4e00:f4b8:68d8:d295:8a3b? (dynamic-2a01-0c23-c4c2-4e00-f4b8-68d8-d295-8a3b.c23.pool.telefonica.de. [2a01:c23:c4c2:4e00:f4b8:68d8:d295:8a3b])
        by smtp.googlemail.com with ESMTPSA id w11-20020adfcd0b000000b0022063e5228bsm2211794wrm.93.2022.09.02.13.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 13:22:05 -0700 (PDT)
Message-ID: <5c282efc-0734-9153-905c-e54ffbc82f60@gmail.com>
Date:   Fri, 2 Sep 2022 22:21:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove comment about apparently non-existing
 chip versions
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not clear where these entries came from, and as I wrote in the
comment: Not even Realtek's r8101 driver knows these chip id's.
So remove the comment.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 779ca268d..a8b0070bb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2050,12 +2050,6 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7c8, 0x348,	RTL_GIGA_MAC_VER_09 },
 		{ 0x7c8, 0x248,	RTL_GIGA_MAC_VER_09 },
 		{ 0x7c8, 0x340,	RTL_GIGA_MAC_VER_16 },
-		/* FIXME: where did these entries come from ? -- FR
-		 * Not even r8101 vendor driver knows these id's,
-		 * so let's disable detection for now. -- HK
-		 * { 0xfc8, 0x388,	RTL_GIGA_MAC_VER_13 },
-		 * { 0xfc8, 0x308,	RTL_GIGA_MAC_VER_13 },
-		 */
 
 		/* 8110 family. */
 		{ 0xfc8, 0x980,	RTL_GIGA_MAC_VER_06 },
-- 
2.37.3

