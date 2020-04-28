Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDB21BCDBE
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgD1U4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgD1U4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:56:09 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230E1C03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 13:56:09 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id h4so259660wmb.4
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 13:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kpQFpR/0b6N8KmjidP1fsCfB9j4sgrDTZeRMr0iPetg=;
        b=GTAbvlqSiTBVfiQ9JAA6P/PMnvV235j5hWE1gOiwN+aPjF/2f9h0hg1aUMkWbXDVt2
         wl8OOgla/iNzJtLE0k18BbUkfs22jbbfxTOnE5xI6uLscbTD1IRz87UXaTinwPbrUDr9
         ac7u5QDnSs2rGssannCS9mo0PajwZ9ImoaBCW4yeK/gmYS5VQRswb77fDIj7in7+rpNK
         1Oimu5GsAK0yzhMA/WVIohgg7+STe/8W4TyDCENvTtFwdXmVwOGTiKOji8s8Mz5O9SIq
         Bo/9HpXLWsSN65Xvh6TUAfgvmmQ9NKwSA8Axd/TCRYMPyojWMT7IUACTkOBULl2DQMv1
         cIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kpQFpR/0b6N8KmjidP1fsCfB9j4sgrDTZeRMr0iPetg=;
        b=im0MkU37rhYD1hxKBekMDsuPko4vrGTNL1B7jd2FKss4urT6QWlLQHgchUWAhSDIdJ
         jqYsQMxT9m+J/5RdgfYIp6pTj0pgX7H2cxY1Mx4IdBzINBdNhBXXVt5klrXkwJau8w2r
         5AnOa7xnvirMdsSiRAV3u21Cm8SwFfzxMpWURfSHNbtK2K1D/ZjE/JWeXBb/C0Mx6adF
         lH0vSAKC7A30tqBVcDP+Oc6fdsN868CxdRrqY5bJHr6XR2MMiKwYsId6IEQAFOcz+L2H
         c04S4kLoGzqhJxn+b/+Rh/VnRHIOUHbWELx8O8uhpG7wprnG50tAbIlP8BfohODW7AuC
         C7pg==
X-Gm-Message-State: AGi0PuYvga2kjonvgtfNLnFHnc4O6UFRXeKEdwyjkdElVLUmWBaBKexT
        LxDMj69BF5roBi64Inq2P9lK11Ly
X-Google-Smtp-Source: APiQypJxzkiILVakpLIFcWihd+FseJrIBTOn671EZT6/GryVl1Sq1cGjFirduYvCXoeyEuB8aGufhA==
X-Received: by 2002:a1c:6a17:: with SMTP id f23mr6232137wmc.136.1588107367607;
        Tue, 28 Apr 2020 13:56:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3a:4f00:1417:f780:dfa5:2ab4? (p200300EA8F3A4F001417F780DFA52AB4.dip0.t-ipconnect.de. [2003:ea:8f3a:4f00:1417:f780:dfa5:2ab4])
        by smtp.googlemail.com with ESMTPSA id m188sm4747286wme.47.2020.04.28.13.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 13:56:07 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: configure PME_SIGNAL for RTL8125 too
Message-ID: <f0e60fd0-a4ac-2b2e-7278-f3f599e7d6e2@gmail.com>
Date:   Tue, 28 Apr 2020 22:55:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8125 supports the same PME_SIGNAL handling as all later RTL8168
chip variants.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8966687aa..7aea37455 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1425,7 +1425,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		break;
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_52:
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_61:
 		options = RTL_R8(tp, Config2) & ~PME_SIGNAL;
 		if (wolopts)
 			options |= PME_SIGNAL;
-- 
2.26.2

