Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9E94957C2
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 02:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343710AbiAUBfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 20:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239700AbiAUBfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 20:35:18 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B607C061574;
        Thu, 20 Jan 2022 17:35:18 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id k4so8824657qvt.6;
        Thu, 20 Jan 2022 17:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XlpFI84bOjXDIKsLry0zm6Nf4XTJwuG9N3/EyF/LIkc=;
        b=jBsFfq//SLOoNJa4YJ+vOS3PFmjtwBNRrgNNhCr3QPCYMtTiTnaoRPjcFOyqB73apc
         wl4+pufIhtR8X62l1a279bVocUlgLRaKwzD3NzFprtdpQKRNH0DVeRmoS+nSF6zvk/fP
         2PzEfSS9ZTbYSwDVZqzmG0NUT72u6IGDHQPr4lGlsza3c5Kpzwp4MjsTFcJ3SungAHO0
         3h4cJj0baeOwsfJxIdw2uAvlNr6B33uVNIZeiuSiuXDg2suYPvxMxMs0K+opfBFiq0V2
         ybNPmxoylp7qbvYQ4Pizh6ExhA0OqJR7Yk5MRD7ShsBSyQBL9dftH/9fPy1q56ZY+xWA
         /Pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XlpFI84bOjXDIKsLry0zm6Nf4XTJwuG9N3/EyF/LIkc=;
        b=uBmGZDm+LIELkCOyFAEmp1rnPU8FuUlgCfpx2Tc47VXjxnN8yGaR09p82V7PTSyglB
         1j+b1hQ6gjdGm7HwxOsxaeDptbF/eRGFqmRl8AaHjp614kR7GyfYyX2OKQskgAslLfJ1
         Mv91AcTOaSU0hkaYmkVefE7eL5D0BEEW2qW/eWrqInWpkE9CaeTPKpsRkMxe+mqeGx4E
         VFiAiC+7ZwfTYXh3N4NJGxwi/PUtviG3u9v7hSUniqmfkaOwAV7mPLkAe5YdQLqip3rG
         KhUT239QVKhDZGwkYfOT54ez6GNMr9exrK4jV/caBRzwwEzHtyqc4c2ff505vqP1QoUn
         y5jg==
X-Gm-Message-State: AOAM531IG74DB5uCH/72eLjE/BxNF1/Wn700lDIG8PlfIFm5DoVwMzXn
        qZRCdfHYKVL/l9UwFi7bZaY=
X-Google-Smtp-Source: ABdhPJxj9wj/QOhdwWx6apVy7R7UlvurS5idAc669qDMKSuYo4IYeO5v8HHIeXSZmSL4acT+Gh253Q==
X-Received: by 2002:a05:6214:627:: with SMTP id a7mr1666916qvx.114.1642728917637;
        Thu, 20 Jan 2022 17:35:17 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id v25sm2264249qtc.96.2022.01.20.17.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 17:35:17 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] bluetooth: mgmt: Replace zero-length array with flexible-array member
Date:   Fri, 21 Jan 2022 01:35:08 +0000
Message-Id: <20220121013508.950175-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use "flexible array members" for these cases. The older
style of one-element or zero-length arrays should no longer be used.
Reference:
https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 include/net/bluetooth/mgmt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 99266f7aebdc..3d26e6a3478b 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1112,7 +1112,7 @@ struct mgmt_ev_adv_monitor_device_found {
 	__s8   rssi;
 	__le32 flags;
 	__le16 eir_len;
-	__u8   eir[0];
+	__u8   eir[];
 } __packed;
 
 #define MGMT_EV_ADV_MONITOR_DEVICE_LOST		0x0030
-- 
2.25.1

