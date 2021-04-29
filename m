Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79A936E5E5
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 09:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239331AbhD2H2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 03:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbhD2H2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 03:28:35 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C79C06138C
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 00:27:48 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so6765173pjb.4
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 00:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lG7fN/8t7j6+iLVQDFN6M3QfpChMwMgL2bDEqLa02Qg=;
        b=o60cTcFzKjZX8No9QlOUH0ywJR5DGB2ckobVxKGj1L3r3yyfwakt0O58LTrx85TMaW
         ALH1hf0SggjV3NhjAH7Rx2OVX25cLd+rmewdhEKcfD7X+aH1uquihIKdlsB06SM1jvQ+
         E7EIOPcGKx78e2lMjav+mliBO7ne05IjYkIQ02cCkNBleG2PSqrKOdtPgEXw9MohfzPG
         /08g4DLCOlEl+7kd1eIV3DivNXcZERo4zcmt4Z+ajuytA/VM0+zuIXgq2/4IusAmUtj8
         a99w+D6UTZFgkScfcqdNddLqV75Gi65qbPyG4JNHichuA5jbPR+iwuL63SiORK4wuc0g
         7LwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lG7fN/8t7j6+iLVQDFN6M3QfpChMwMgL2bDEqLa02Qg=;
        b=LnRpGYnyKlrooEpTkbhOQ01XmP2GWyMqUlNibWAAMJASmyH3/cqKWefcmZGsB5sFBH
         IxjuvyBDGKV5q6Rl9LsTJBnHnnukM3hjgh6iIcvtQdHjV/1+kM/s7ci0JSVLKAZ6G1gT
         RPHnm0/DNFI/X2t962IY5n05rQu1IGNCBl40Sljm1zyCWu7X/b9WUTyYxBU5bAxmG5Jr
         TvUTBOs45r3zpaEVkLdH5+FBDPoNCL8f/q1nKr2QiNkQRwWWzPFFo7+exx7Mg9cvuY42
         oErJzHGjBTIQXBSjTYnPEDAGwO0CjHMNXledKInDoKxzOgL3GzHXlC2nToEAiE6MZBUs
         +OIQ==
X-Gm-Message-State: AOAM533L8JjY8agRPSU1mdZ+SbWg2wuLVQviSf3eXSS90wAUZ0CgEBb1
        KGR55fgImgztd4jKOSAIloWt8w==
X-Google-Smtp-Source: ABdhPJx4W5jNoRZhQiC9645r/h31OFGTNwljVCcUp6NkakGEw9IMReUvVm8qBOVVaZtRC9a9uoS/5Q==
X-Received: by 2002:a17:902:ec84:b029:ea:b28d:e53e with SMTP id x4-20020a170902ec84b02900eab28de53emr33378997plg.77.1619681268180;
        Thu, 29 Apr 2021 00:27:48 -0700 (PDT)
Received: from starnight.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.googlemail.com with ESMTPSA id m9sm1674753pgt.65.2021.04.29.00.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 00:27:47 -0700 (PDT)
From:   Jian-Hong Pan <jhp@endlessos.org>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-firmware@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH v2] brcm: Add a link to enable khadas VIM2's WiFi
Date:   Thu, 29 Apr 2021 15:25:03 +0800
Message-Id: <20210429072502.4350-1-jhp@endlessos.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <c62e9f94-25fc-6791-c328-5454abc403b9@gmail.com>
References: <c62e9f94-25fc-6791-c328-5454abc403b9@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to kernel message on khadas VIM2 board equipped with BCM4356:

brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4356-sdio for chip BCM4356/2
usbcore: registered new interface driver brcmfmac
brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac4356-sdio.khadas,vim2.txt failed with error -2
brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac4356-sdio.txt failed with error -2

System needs the NVRAM file "brcmfmac4356-sdio.khadas,vim2.txt" to
enable the WiFi chip BCM4356. Found it can share with the same file
"brcmfmac4356-sdio.vamrs,rock960.txt" with a soft link as
"brcmfmac4356-sdio.khadas,vim2.txt". Both 2.4GHz and 5GHz WiFi are
enabled with the linked config.

This patch adds the link to brcmfmac4356-sdio.vamrs,rock960.txt for it.

Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
---
v2: Modified the commit description.

 WHENCE | 1 +
 1 file changed, 1 insertion(+)

diff --git a/WHENCE b/WHENCE
index 3c29304..5773020 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2780,6 +2780,7 @@ Link: brcm/brcmfmac43455-sdio.Raspberry\ Pi\ Foundation-Raspberry\ Pi\ Compute\
 File: "brcm/brcmfmac43455-sdio.MINIX-NEO Z83-4.txt"
 File: "brcm/brcmfmac4356-pcie.gpd-win-pocket.txt"
 File: brcm/brcmfmac4356-sdio.vamrs,rock960.txt
+Link: brcm/brcmfmac4356-sdio.khadas,vim2.txt -> brcmfmac4356-sdio.vamrs,rock960.txt
 
 Licence: GPLv2. See GPL-2 for details.
 
-- 
2.31.1

