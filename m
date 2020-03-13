Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F9918468A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 13:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgCMMLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 08:11:34 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40515 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgCMMLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 08:11:34 -0400
Received: by mail-qk1-f193.google.com with SMTP id m2so11988643qka.7
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 05:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XX5mru32Gi5sOBQ/FNp2q0Ts+vriYrqCzKI6fxK8S5s=;
        b=YBfjzNAK8oAtbEB33Vg9nHEuPwS/uL5qvwqB0VYbnBqck4G5PNPfhE5uActu40HgpB
         zixEME3kMx+bgjh7VoxHYnQzZ8A9InXxC3V9WF0R/QFXOD41aXctw+9xJYbyby0wiUtj
         e6mpUSO1UynXjsGLTylQmPE9SoZxb6ozlc4RrekMF9cyX6ZVJ5h/sfV83Q4+iaGP9c5M
         3kIZbBn1sCoEf98wDnBy8c5gftnCRPb08ByAPfSFAvBCkIbODTaFkbSwrXQtDMUZCcCt
         N89yFZ6WOCHUBv5eLNS8rJMBtciy6tXVwE3tBVlzBF+jJIxKpuqQhBV1rTaVUVPxh/T1
         GUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XX5mru32Gi5sOBQ/FNp2q0Ts+vriYrqCzKI6fxK8S5s=;
        b=Mul+3Dnu4S3QZN58qspDgmI2idO2qZX0SW6pcnI340o4al5KYX6DBsLyr2rkmeU2jP
         hdMT8/AwNj0ycX2sL0Id3THjtF8PaoP25ps44QQwc3awWWu3tdQaq5+ytC26e2RrgcgG
         4qp/HU6oEuWHHgoMdoTAPlo8yVDx+aUE4Vrslgj07Q36J0E6NW2h3HKjmznMskL+NqRo
         Tlgu5gw7/+OM2PohLRd8O9p25dCGpn10W520q/NX8d1MGmcTYB7LLy23WsHvVEkgU4O6
         g+beSMls8AGYC12Jqvdcs1pMVJLf1SDbC8HJ4A32ZLZDRaTF6a9RZkJ5LhEp1VvjRYSg
         r9Tw==
X-Gm-Message-State: ANhLgQ0PYmzUqyUpFi6Yom5UYbkK0wQ4DHxnQRKuNm0TGyyfM1izH0f5
        8FpYhbQONx1DJJnkpD1kLKiItg==
X-Google-Smtp-Source: ADFU+vu0UgXCyUMs+9W34yBOVDQS5+nQD1LI345IKOny09UNx3zrIg4Fpy09IPHUBow+wMtngzhIxQ==
X-Received: by 2002:a37:9e88:: with SMTP id h130mr9926845qke.145.1584101493013;
        Fri, 13 Mar 2020 05:11:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l60sm8281895qtd.35.2020.03.13.05.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 05:11:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] soc: qcom: ipa: build IPA when COMPILE_TEST is enabled
Date:   Fri, 13 Mar 2020 07:11:26 -0500
Message-Id: <20200313121126.7825-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make CONFIG_QCOM_IPA optionally dependent on CONFIG_COMPILE_TEST.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---

David, this implements a suggestion made by Jakub Kicinski.  I tested
it with GCC 9.2.1 for x86 and found no errors or warnings in the IPA
code.  It is the last IPA change I plan to make for v5.7.

Once reviewed and found acceptable, it should go through net-next.

Thanks.

					-Alex

 drivers/net/ipa/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index b8cb7cadbf75..bcab7e52d4e6 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -1,6 +1,6 @@
 config QCOM_IPA
 	tristate "Qualcomm IPA support"
-	depends on ARCH_QCOM && 64BIT && NET
+	depends on (ARCH_QCOM || COMPILE_TEST) && 64BIT && NET
 	select QCOM_QMI_HELPERS
 	select QCOM_MDT_LOADER
 	default QCOM_Q6V5_COMMON
-- 
2.20.1

