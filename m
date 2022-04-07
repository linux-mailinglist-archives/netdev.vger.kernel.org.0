Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCB24F74EA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 06:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbiDGEoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 00:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240747AbiDGEox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 00:44:53 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64329BB0A0;
        Wed,  6 Apr 2022 21:42:48 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a6so8453206ejk.0;
        Wed, 06 Apr 2022 21:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IBqPOS9QHe+JJ1knT5EDEfSF4t5LcFtWDmlgHbBMhvA=;
        b=mraPced7Vb+0aMa+6xkhCQHTp+CsZEIqXKzf7RH55AZR2n4cOJvyzpEhm3ZwfskBpQ
         ftDW2snMQvZiWTcXQ3TStUOK77GXazfDCqvMa2qNWWn8BGMw2gnx30jC1k4309ow9TAc
         9C46CLz/+RWxStgcmmCzpByGmE9cIbB0HBFQbamUk5JCkTw7Cz+hh42M0ohVG6Q82i+u
         JHPe98uACGr4DEa6m+fO45j2bCBxaA/pRsN2dt7aDqaqzy4g3Dw4Lp0UREArB1M/h9Nx
         KB9bSYRwLrgCfHwoAOqh/iUIKIA8WKMtiIhLFBB+uqww1uoiwSmOJBO/ACjFGHgoL9vW
         Blxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IBqPOS9QHe+JJ1knT5EDEfSF4t5LcFtWDmlgHbBMhvA=;
        b=8IqiuH1evFPZh7DXprz+vW6N8zN03/JhkWx1hq3vi6J4BeNXGz/ik7q1akIB1zbK+r
         EoUbfPEsYXAiTqf5rNhuc/VsxeGFc6umRoL2M4Y22z1Oi9PdvPDRCx86qxBm/jSgdkxr
         IZZugxbfGGRzMn0vCuYQYAXk2IfUSDshf/hWAWVNgbGMfpZ3M+fbJ+V2JGf6lbFQoLGr
         h1bt/p7x3+gzd4MISJUt0QRswVpQsGmFjXKFsa+B8sndTCszfe1oJ7cuI4m2HT132tvS
         KCgOqR+zFJ4MXzjyBlsyFdjeYjgaElx3JbUVgt5ODyVRRKy1gDDYZQ2dUwFiYLW/3zeC
         oPdg==
X-Gm-Message-State: AOAM531DUj9Rrjpcx0sthceCRcM4up4StR5FALqhVhdi7SgkOLcB/u7i
        Tvf1mj16EDEDxYtRiVDlfEE=
X-Google-Smtp-Source: ABdhPJxLJCKSENJThJGXDyEAuiOLtuQqO5MxkmrIvMBPZspDL7/ZilnNbfE6svYfBQeIPtWYS8TbrQ==
X-Received: by 2002:a17:906:b107:b0:6e0:a25a:af6e with SMTP id u7-20020a170906b10700b006e0a25aaf6emr11606494ejy.359.1649306566930;
        Wed, 06 Apr 2022 21:42:46 -0700 (PDT)
Received: from anparri.mshome.net (host-87-11-75-174.retail.telecomitalia.it. [87.11.75.174])
        by smtp.gmail.com with ESMTPSA id e3-20020a170906374300b006e7f060bf6asm4199455ejc.207.2022.04.06.21.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 21:42:46 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH 1/2] scsi: storvsc: Print value of invalid ID in storvsc_on_channel_callback()
Date:   Thu,  7 Apr 2022 06:40:33 +0200
Message-Id: <20220407044034.379971-2-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407044034.379971-1-parri.andrea@gmail.com>
References: <20220407044034.379971-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That being useful for debugging purposes.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
---
 drivers/scsi/storvsc_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9a0bba5a51a71..67ae2b5b1d5bb 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1334,7 +1334,8 @@ static void storvsc_on_channel_callback(void *context)
 				/* Transaction 'rqst_id' corresponds to tag 'rqst_id - 1' */
 				scmnd = scsi_host_find_tag(shost, rqst_id - 1);
 				if (scmnd == NULL) {
-					dev_err(&device->device, "Incorrect transaction ID\n");
+					dev_err(&device->device, "Invalid transaction ID %llx\n",
+						rqst_id);
 					continue;
 				}
 				request = (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
-- 
2.25.1

