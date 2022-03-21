Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287B24E2119
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344819AbiCUHTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344803AbiCUHTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:19:38 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6FF1D30F;
        Mon, 21 Mar 2022 00:18:14 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id p34-20020a4a95e5000000b003248d73d460so2629237ooi.1;
        Mon, 21 Mar 2022 00:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=y08CTq7Uc/emJmGixC3ZOpR6XVsrGK9UeeXjkwmEXts=;
        b=DWQeq0QN2GF5ZR6Mkj1otvzOuXXiTZ6lYTxYqYy4JDIuc4ocN12M6JOrCvvTwxaBgF
         PnquKMdNCLl8N3YVEnDgN31aynnMxzudKwfLJfFLWCgXFdAFMEjwqb5j1oQqJORxl3De
         EgBZTU6knxf1bL+CFgII+jHgMbohruOnerVhBnd6ZfhmqOo0w02NprlHHFnz1/9qHA/V
         Mg5xe9wnftymrtFZCZR3w9zOrnJdVPQ1C0DLuWvOeYZdaf6TJp2wq4xyJD9OnBUrcJ5J
         QLMKK0PB3aQprORw5gxIHoO6/Evf3losA8RICEeltGe6vQYpK8b7pT1JaiaQra0k/IWg
         a3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y08CTq7Uc/emJmGixC3ZOpR6XVsrGK9UeeXjkwmEXts=;
        b=blNxSIqVDDBlWrjsfGauBITfebLeS8qjtS7Wx5seApJM9ssCh5+b3tRmVM9YGNsdJm
         QYMwRsXuwWpa+8Bz76Qqh1dXIlnR5fzn3Qs/fDMQA4u90j76N8fslGvvITvv5CzRL2Rv
         tHiLYiiG9WHMSm/57+ubbdvTxiYIAeGm0uVDIiu8s30s3l2mEdbHezeixem74mrUm1v4
         wpqSV7PBXlkJJ3sSMkQ0ywzGO0ZpCr657kIIaPSwFdqCbY4LFG6NpKkjqrFRa958//uk
         Oe4YqPkjydB5ntu2ViowlsCSfzJ0ZdjRms+td7oDAMSQt8u5QfQ1Hwv4FR2gVAlBt0xW
         Odfg==
X-Gm-Message-State: AOAM531keeTUD/YMDHM567eKBgNlT+nWwEizmhdDrjB0xP4HAvPKI1nD
        Ebv0r012/21zWfHkoLxDBHM=
X-Google-Smtp-Source: ABdhPJwlZ6CfLMxbGVgq2p/e46owzjT2a7lT3d6XH7K9UKgmiTswlgMwEuvnEmhVpdTZJb+t8Ya65w==
X-Received: by 2002:a05:6870:9a0b:b0:dd:aecb:9540 with SMTP id fo11-20020a0568709a0b00b000ddaecb9540mr8283663oab.164.1647847093633;
        Mon, 21 Mar 2022 00:18:13 -0700 (PDT)
Received: from tong-desktop.local ([2600:1700:3ec7:421f:a425:dbce:b9cb:7c6f])
        by smtp.googlemail.com with ESMTPSA id 11-20020a05687013cb00b000dd9b5dd71csm5956101oat.56.2022.03.21.00.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 00:18:13 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Karsten Keil <isdn@linux-pingi.de>, Sam Creasey <sammy@sammy.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tong Zhang <ztong0001@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 3/4] i825xx: fix typo "Frame to short" -> "Frame too short"
Date:   Mon, 21 Mar 2022 00:18:08 -0700
Message-Id: <20220321071809.3477290-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321071350.3476185-1-ztong0001@gmail.com>
References: <20220321071350.3476185-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Frame to short" -> "Frame too short"

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/ethernet/i825xx/sun3_82586.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/sun3_82586.h b/drivers/net/ethernet/i825xx/sun3_82586.h
index 79aef681ac85..eb4138036b97 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.h
+++ b/drivers/net/ethernet/i825xx/sun3_82586.h
@@ -150,7 +150,7 @@ struct rfd_struct
 #define RFD_ERR_RNR  0x02     /* status: receiver out of resources */
 #define RFD_ERR_OVR  0x01     /* DMA Overrun! */
 
-#define RFD_ERR_FTS  0x0080	/* Frame to short */
+#define RFD_ERR_FTS  0x0080	/* Frame too short */
 #define RFD_ERR_NEOP 0x0040	/* No EOP flag (for bitstuffing only) */
 #define RFD_ERR_TRUN 0x0020	/* (82596 only/SF mode) indicates truncated frame */
 #define RFD_MATCHADD 0x0002     /* status: Destinationaddress !matches IA (only 82596) */
-- 
2.25.1

