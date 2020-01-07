Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E317D131E15
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 04:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgAGDoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 22:44:02 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40816 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbgAGDoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 22:44:02 -0500
Received: by mail-pj1-f68.google.com with SMTP id bg7so8631250pjb.5
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 19:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QRvRJ17yAgfqPGiRV0RGDzXVBVOSCZZmRgPS4VPHyZM=;
        b=msqyXN5A/XFGJTrGUpT6BRCugPWU2RdyJG+SWNJxSouWK7j8cdfbq8tlEf2u/IFxTW
         4MngSdkANbTOFVw0qQuwPak3vrZ2wKCK5sMOYfp8l3eNScUGPHAA+WBRIKZpkxIjUa/5
         0B6IysJSkFtDmsF5FALJ51KBLcVwEULzNrrq+CWbUNDfa/1FiDedxUgXIGbyltJiCQuh
         lIJK9E95VVrArQP2wAR8DmO7owGh8zUTotT3e3Qe043P10BqbobA4NdaPpXw1bUhuvTX
         spdi0NuIuoIF06pRrON3hd7ajDuWuzqB0YdhsOHg28fTXNj0bQyPPxLxpfm5FivU4YFi
         Gh7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QRvRJ17yAgfqPGiRV0RGDzXVBVOSCZZmRgPS4VPHyZM=;
        b=RFixQiSb44+0IWrFbwnz9U6MImsCtt16y2NNq7xUDVqeJcJ+4SLvoYQR7TkbT8Pb1v
         ZMw5p2FaTDGtjboFvTsbxq/k6C7CWRX9HmM3Q7k1DV6yBcNUQssM3aTGdu1m0IH7m+qU
         0m4/eaZ6vUa07slhn+htPRoP/yX5TxKJqL76oBPzjjTUL/zjsa1CZeeBM3xYWTRrChCr
         jViKZXrdFhR8z7JHii9kZmmF74EHI8OR5zLb4e0zkDXyExMJPVw0ksJhrSXdP7AaWXyj
         F/I4xvEclvW0TzxM2Vt+wqFirwdWSjE0RoFgPrU/krlyc+coEG7Twa1Yp6DzSkYY70Fz
         Tjjw==
X-Gm-Message-State: APjAAAVekHplQHk9HOJxr/hR5HpPP9joJoYSQbp48VlrCXES7F1BM14k
        lgcUH6yn5MOcGuOqnteMCfotFgpP/Mc=
X-Google-Smtp-Source: APXvYqzyBsg381no1M5EAJLNH0M34WgcMyoXim/RdpEhxGWSueh0VV2XFN1+cNX5DUIYv9aOChsMkg==
X-Received: by 2002:a17:90a:d986:: with SMTP id d6mr47235440pjv.78.1578368641432;
        Mon, 06 Jan 2020 19:44:01 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a22sm85262959pfk.108.2020.01.06.19.44.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 19:44:00 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/4] ionic: drop use of subdevice tags
Date:   Mon,  6 Jan 2020 19:43:46 -0800
Message-Id: <20200107034349.59268-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200107034349.59268-1-snelson@pensando.io>
References: <20200107034349.59268-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subdevice concept is not being used in the driver, so
drop the references to it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index ca0b21911ad6..bb106a32f416 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -19,10 +19,6 @@ struct ionic_lif;
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
 
-#define IONIC_SUBDEV_ID_NAPLES_25	0x4000
-#define IONIC_SUBDEV_ID_NAPLES_100_4	0x4001
-#define IONIC_SUBDEV_ID_NAPLES_100_8	0x4002
-
 #define DEVCMD_TIMEOUT  10
 
 struct ionic_vf {
-- 
2.17.1

