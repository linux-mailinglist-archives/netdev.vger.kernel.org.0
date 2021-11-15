Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A0C451651
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349463AbhKOVUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347652AbhKOU7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:59:12 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21DFC061570
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:52:52 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c4so33106974wrd.9
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=5kDUy3RyZbZhxT8FfN2eBoCo6MxfGNMeiGHMcv5L5GI=;
        b=lahNnahp7sk+1ew/8E/zznmU2oaPoiZurcnnbfmLcpLcwDOLu5iYdHVY0GQiwAWuFv
         inuwkb5NOYgQ13+26CievUF3fCL+vUsltyrv93nobQ1m/9FFjsiQSKjjG99mwkT4W+//
         nxv/+1blGxQm6/cBR3YvxELNhCTavUSuxCGPwgbOBtRBhkdniArkNCAiqk2jlDH4tlcG
         gCnEM4ujCHpCEe9tbeaTju/TdgkNAZgzIRSALvXDL0WxGELI5Pw122Gg7ZaR+nlQK8pk
         zzr+1MXh3ReT0BSIdkklI5jjjtMS1S2yionpOP1sp+7RjjyuZLlFXkVt6IqwIQMJTglQ
         8y8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=5kDUy3RyZbZhxT8FfN2eBoCo6MxfGNMeiGHMcv5L5GI=;
        b=xF/d0fWbjUPWPFx44noD2njkVf40CF3bq3ywi7YQuict2ulDSxZ5EgkOqbiq8r7GBH
         eakcNg6gO7OMBzA+9zQq+42QV8l+NQqs775vPlYoqoy05qN07VJX2AOnb6Se3NBdBlRJ
         96R+Sn3qbTh5rBhE+9OmrY2JfgnmJSCSVAu6SWCFg47UZgx6bfb82sH8GQclIW0BmVV0
         /N+/ilHvetfoidNAnFNiN1/EpPmeLgSBs5PV4HUgPHOtRUkEyOXFZ/+ChDo/5C49dLMN
         CuC+k/0xOGMnxz9JAGT6LNarYtyA3k+oaTfBIrfalGAByzxpK1j5McEBfh5qFzURdITv
         yz5A==
X-Gm-Message-State: AOAM532wzgKIKGweKqRFgW9Xwc6HFkN4Ebi+oyHn3MfTZ879dSZY6gzl
        nZzTlmS+p6tHyhWu+HgfJtYm5XJVaK0=
X-Google-Smtp-Source: ABdhPJzqrotwJ1lliukStB/N1b8NWYvYcQLWYXnbohZ3foUID2VXJUFzbpvRo3iPMwdlc1BmJC7vxg==
X-Received: by 2002:a05:6000:18a7:: with SMTP id b7mr2473733wri.308.1637009571225;
        Mon, 15 Nov 2021 12:52:51 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:a554:6e71:73b4:f32d? (p200300ea8f1a0f00a5546e7173b4f32d.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:a554:6e71:73b4:f32d])
        by smtp.googlemail.com with ESMTPSA id o10sm19122062wri.15.2021.11.15.12.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 12:52:50 -0800 (PST)
Message-ID: <52842aa1-3050-6258-138c-042c24c3e597@gmail.com>
Date:   Mon, 15 Nov 2021 21:51:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: [PATCH net-next 1/3] r8169: disable detection of chip versions 49 and
 50
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
In-Reply-To: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems these chip versions never made it to the wild. Therefore
disable detection and if nobody complains remove support completely
later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6e46397f0..3033f1222 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1978,8 +1978,11 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 
 		/* 8168EP family. */
 		{ 0x7cf, 0x502,	RTL_GIGA_MAC_VER_51 },
-		{ 0x7cf, 0x501,	RTL_GIGA_MAC_VER_50 },
-		{ 0x7cf, 0x500,	RTL_GIGA_MAC_VER_49 },
+		/* It seems this chip version never made it to
+		 * the wild. Let's disable detection.
+		 * { 0x7cf, 0x501,      RTL_GIGA_MAC_VER_50 },
+		 * { 0x7cf, 0x500,      RTL_GIGA_MAC_VER_49 },
+		 */
 
 		/* 8168H family. */
 		{ 0x7cf, 0x541,	RTL_GIGA_MAC_VER_46 },
-- 
2.33.1


