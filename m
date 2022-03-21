Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F9F4E2116
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbiCUHTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344791AbiCUHTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:19:33 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82852708;
        Mon, 21 Mar 2022 00:18:04 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 17-20020a9d0611000000b005b251571643so9961301otn.2;
        Mon, 21 Mar 2022 00:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1Ze5WbkvXa0J67kXY2oJgJpQcoI/5mV3mf6F3/wFF8I=;
        b=aaxpvlRbq34rMmhGTVy58P3EYzKyGf00ulpOONQG5AVlwp+Abmocx5FeyvCbOX6ihx
         F9D3tjOmpdV1qvzSpSn7Hnr3F2vSfQ6JapjmFtj29WMboOxJYcpHvnUyn0Wf1WK08x0F
         9nhmX2Lz08ZN+DCvRp3yPqGCEZW7eg9fI6imY5I/l/RvYJOkUxJHs5QyVdoauO9F+wdW
         aojK537h5NYBmXfMz/xVIR/i/ZxE4Ip7E7M1xA3pXyrMHxx7D+OLA3TozrYd7C7CQNs4
         CBzJtIfYhdXqEUM67nJliKDTjCzWvAdl6FMBsGAioaoudZ8TvqQylKNDesV/RmE7rdZ4
         9XBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Ze5WbkvXa0J67kXY2oJgJpQcoI/5mV3mf6F3/wFF8I=;
        b=gErfzTc6bRB5MyyDzVrHInAiPue8YbokHu+lb+mhLaY0tiXpXvp/+cc8cxtqDHbpDS
         3301lwJQi/TSI2dotiL+4AewFxA72YSix2PHZRkaW4FCQFvyagUnGGnWDA/uv4XI9N6a
         HZ+YuEu4Ejex8g2iavtBEP4fpzC+eV3JgAE/V45bGDcMDzOTb4x4RzGFkDWMbIIOXsgZ
         evbyOQ3aGLOXdFINpW8NB5cIaI9SHc7ksIreJ0cG6Tzk57S1Ck2T3WGx619w1IcZwAsh
         lzwPn5D3pKvEC9hgmxCW4AD3/j6GAc2sT89Kim0V6RptiUM09f7/7FTDz74RwpHrJ3/V
         EFtw==
X-Gm-Message-State: AOAM533IfRHh47yHxitu+J4w1jm+bpEzSCQmRGS22JNbB9RIEPiyMJyu
        s67b0KQc0PyVsKqZWi0+sq0=
X-Google-Smtp-Source: ABdhPJzab3wh4kjvI5zvHHq776LZdCqvse/YuHfF60Att1Dri1YcoUfKtLp9VX+2IFd1QEpzY2kDpw==
X-Received: by 2002:a05:6830:448c:b0:5b2:3552:69c7 with SMTP id r12-20020a056830448c00b005b2355269c7mr7479718otv.79.1647847084006;
        Mon, 21 Mar 2022 00:18:04 -0700 (PDT)
Received: from tong-desktop.local ([2600:1700:3ec7:421f:a425:dbce:b9cb:7c6f])
        by smtp.googlemail.com with ESMTPSA id v20-20020a056870e29400b000da4a0089c9sm5896027oad.27.2022.03.21.00.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 00:18:03 -0700 (PDT)
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
Subject: [PATCH 2/4] s390/ctcm: fix typo "length to short" -> "length too short"
Date:   Mon, 21 Mar 2022 00:17:57 -0700
Message-Id: <20220321071759.3477148-1-ztong0001@gmail.com>
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

"packet length to short" -> "packet length too short"

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/s390/net/ctcm_fsms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index 5db591cf7215..dfb84bb03d32 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -1394,7 +1394,7 @@ static void ctcmpc_chx_rx(fsm_instance *fi, int event, void *arg)
 
 	if (len < TH_HEADER_LENGTH) {
 		CTCM_DBF_TEXT_(MPC_ERROR, CTC_DBF_ERROR,
-				"%s(%s): packet length %d to short",
+				"%s(%s): packet length %d too short",
 					CTCM_FUNTAIL, dev->name, len);
 		priv->stats.rx_dropped++;
 		priv->stats.rx_length_errors++;
-- 
2.25.1

