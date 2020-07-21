Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF15228539
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgGUQWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgGUQWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 12:22:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A31C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 09:22:34 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w6so22231960ejq.6
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 09:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LOFAT1qmYyIbrdPnShbvRI3eZlOavkqzrx0C1i1Mizs=;
        b=Q3GnjVblJnAjcRd4J+i0SINIV1ZKBzD0NFv9ymOpBOM97XtwfPGQduC5bdnalYhYnT
         mfdRXfAnq8/oGzl+I/RwPX7u7StVSdsoaL4lzV3NTUVpTgBad6dIu2vRWCTXlpePorGt
         q+91hlb5JN8C05S/4hBengn2lBSKzjCd9YjfF5shmooLgSbYRTshDMNgu/KIMENhBabo
         7SPHjr5+XOJbotqfTtuse/APcoxcxQr0myDDQiA6SzIkz+N72qiFRjNBpp9jwIZDapQX
         wA0vU2Yms6oJrvlJa1FChCQcM4VXhoZLrpe6BWrtsOUFwV+lgRcsly4cJDiZF9DCRK2d
         lnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=LOFAT1qmYyIbrdPnShbvRI3eZlOavkqzrx0C1i1Mizs=;
        b=XpiBbaUxoq8EXxRUhC5XDNr86TrtZjr0LUSw1CKvXcWD/K6kpWp7P+Aa+7JL8bN++S
         DjgL9Ho9MXGql3PwHqILvF88jpQ0IIt41IjGeV8n4gy1Nn1vxfnC72SYLJu99IYY9Lzp
         pHg5qVUbAmnY6Sdrx+IWYl8fnFeqpUG2a7dOzWr+RknPqqD8bOeODb+2Dc78p1UKWTCc
         da9KQpU37BhJL5qosc6LVMrisWaekTUSn375i4VW71eHtVKCMyPgMyvhw3PZy5Mc8ILL
         LYfwb5t8DupUzOyJ6TOimAGTFVEz88SgDM4MQrvasU0LDPO307l6xHQSW/TKCpH4jB3V
         wLUQ==
X-Gm-Message-State: AOAM53030ZF+bRGrfRL+yshb9mmBF0t0aPvKzSWtD1x65D8cYuuYSb6r
        p/3aga4suCGVnzH/pFy8rfCx8di0pwc=
X-Google-Smtp-Source: ABdhPJzPxnLwVoU31V5EnJzn5pt5f4PZ4TKvAk1B28ebNnGBdVQ5/QUbE8xp6DMggCHtLuhhnRQMDg==
X-Received: by 2002:a17:906:53d4:: with SMTP id p20mr25701165ejo.472.1595348553283;
        Tue, 21 Jul 2020 09:22:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:802f:6d3:a4a8:fe5? (p200300ea8f235700802f06d3a4a80fe5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:802f:6d3:a4a8:fe5])
        by smtp.googlemail.com with ESMTPSA id c9sm17516293edv.8.2020.07.21.09.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2020 09:22:32 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: allow to enable ASPM on RTL8125A
Message-ID: <9b112086-5a2a-efad-42a8-7236a8172a7b@gmail.com>
Date:   Tue, 21 Jul 2020 18:22:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For most chip versions this has been added already. Allow also for
RTL8125A to enable ASPM.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 975f5c10b..d1da92ac7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3622,6 +3622,7 @@ static void rtl_hw_start_8125a_1(struct rtl8169_private *tp)
 	rtl_ephy_init(tp, e_info_8125a_1);
 
 	rtl_hw_start_8125_common(tp);
+	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8125a_2(struct rtl8169_private *tp)
@@ -3649,6 +3650,7 @@ static void rtl_hw_start_8125a_2(struct rtl8169_private *tp)
 	rtl_ephy_init(tp, e_info_8125a_2);
 
 	rtl_hw_start_8125_common(tp);
+	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8125b(struct rtl8169_private *tp)
-- 
2.27.0

