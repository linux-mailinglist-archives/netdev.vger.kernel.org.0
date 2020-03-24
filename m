Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069CC191A62
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgCXT6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:58:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40902 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgCXT6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:58:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id u10so4154wro.7
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 12:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YrlZ5dj2TG/+8HlHikEtWEWqf5skKNek+Zwk02QjQGA=;
        b=l+AsGMYpGjZY9JcE0ECymVJuZqgCpLUv6gVDRecYLmBXVonSZGFbdEJQAsgN/bhxxs
         1f6/ATjI1xfXS0gjfkhF/BFBflQAPNfkkRKjj/hHqfzHHb1t3MZETDU8joQbLLZTmE1A
         Dtv4SINMLqm0V8eOU0jBO1xSPUtgafr38OVXda1aoepLBXGxllyEoeAEIJlamfGpX3w7
         tRA7oVz0XQAeckvhr5q/1BDiUPIZZs05gdNgyi3+Gup3b/gVwzlDrOVrs7qLHekKnqAv
         N6BZvU0koKCZluv3aC1DlyU+v87UTJidJRSNjN2Ety0aekrqpJ5DtwUGYXbZPQXjlfMl
         SkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YrlZ5dj2TG/+8HlHikEtWEWqf5skKNek+Zwk02QjQGA=;
        b=NdkY01sNZ7wwLrN+UoqhD6dr5kmxEz4VdLi8v7BrTMhvkfHUkC9J5BvEzgDLQR95YX
         ks7DAMOeAZanXg+kVMnxXmWGHWjoN99dDEE7aTkGuuEtH/hdQJDclDe5NGPu0XtU2riS
         Dhy6+B49DqXPW9ob1aK01ix0seOd7kP+gWDyQgAvFfxppItBJgbhT/hCbDohXkodNVgr
         DMK5+Er13jRotwKqQuTd82g+7AnwQxRKhtsJ29mQq7BBd+snYIfjm1lwAX6ISz35Pqku
         czXsq+6AlvB3RtZ1BLqtqcNHkxymiVY41AB9eSIKUNgX4jg+aSbyqzC1NdeG7QriZgH2
         4WGg==
X-Gm-Message-State: ANhLgQ1gzZmphJWoLkRZuBrT82pTlQp92FoNiEEA91Cekg2ga/zR8A35
        4Kz3+GMufkVHYDNVCpqRE4MR6vmX
X-Google-Smtp-Source: ADFU+vtfRCpRVHOJ/hFDF4mOcBxgb+R/L1963fTvTL6dCDa8r9qXPDLNPG0ws6iTrmY7Yj2ByOaEgQ==
X-Received: by 2002:a5d:69c7:: with SMTP id s7mr38067843wrw.165.1585079917130;
        Tue, 24 Mar 2020 12:58:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:15d9:db2:d01c:1c4c? (p200300EA8F29600015D90DB2D01C1C4C.dip0.t-ipconnect.de. [2003:ea:8f29:6000:15d9:db2:d01c:1c4c])
        by smtp.googlemail.com with ESMTPSA id 195sm5727747wmb.8.2020.03.24.12.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 12:58:36 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: re-enable MSI on RTL8168c
Message-ID: <d99291a4-aea0-6670-0a64-1103337c2906@gmail.com>
Date:   Tue, 24 Mar 2020 20:58:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original change fixed an issue on RTL8168b by mimicking the vendor
driver behavior to disable MSI on chip versions before RTL8168d.
This however now caused an issue on a system with RTL8168c, see [0].
Therefore leave MSI disabled on RTL8168b, but re-enable it on RTL8168c.

[0] https://bugzilla.redhat.com/show_bug.cgi?id=1792839

Fixes: 003bd5b4a7b4 ("r8169: don't use MSI before RTL8168d")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b7dc1c112..7949ec63a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5091,7 +5091,7 @@ static int rtl_alloc_irq(struct rtl8169_private *tp)
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~MSIEnable);
 		rtl_lock_config_regs(tp);
 		/* fall through */
-	case RTL_GIGA_MAC_VER_07 ... RTL_GIGA_MAC_VER_24:
+	case RTL_GIGA_MAC_VER_07 ... RTL_GIGA_MAC_VER_17:
 		flags = PCI_IRQ_LEGACY;
 		break;
 	default:
-- 
2.26.0

