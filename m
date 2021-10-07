Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0247D4259B4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbhJGRq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:46:58 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:50346
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbhJGRq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:46:57 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 010463FFE4
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633628703;
        bh=Coe08tkAG3DLADP+J9knykBNBTwMfZOYcNMbzRGgajM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=kYC7oH6Pq/+x2J9TxxpklkV86xXqxZqDguDhQJXe+Euo/E+STOQWV/5EJtDt2Z9M0
         y/A044R9zBivmyN3kthkJ5dcsk3VWrR60hfs3P3DSovkvUZy+sqwdXJmNhGZcOEOug
         DJM5eyqiot5RGBHXkNPsdpWfPfkgPHeSJpXGKLjtUSdV/082aHg78/7IdYp6Bgs0Qq
         7izRAjDOj026LDXApZ5MJfWDrb/83fSEtspJnFUL52QWXoRFWVpX9GUd3BZy9tZ0m0
         6kndb94O5O7OwyUInoPnzS0MnTKbQLspwbNQWjgl1E20LjrlKcH7aUitF+j8hK8qFs
         G6TXbwiC/WaeA==
Received: by mail-ed1-f71.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so6618468edi.12
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 10:45:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Coe08tkAG3DLADP+J9knykBNBTwMfZOYcNMbzRGgajM=;
        b=sNUpZKTJDs1QZmEtkPq3XJnckZZH39oasbhimMFzc/Fyh00YC8xvPxkogd5IONy8t3
         AvDacAOMOVocjh+qwOQ66YJndg8gxX03TVUlkTHr1c5kBniHgbRkaJeHFghQOBHCaBHL
         1XB9M/NW0Metl5i0wmVevcHF8PQPWoBf4zLr5teOsNUuPq24KSLq7vFuaGv8X1u84/fh
         Er2zGGPFuDgl67BYlsiWMr7rmOPqtb7xavLKzBfb+8s3w736XYu08ugylZMe3CWDenxM
         li03XcICcimgL3IixQTD3HaeH7ILhIAV2gCN95vOmLEBGUezw4iu2LaztySE5HJxDoNb
         C+CQ==
X-Gm-Message-State: AOAM531tYmki1M+AuoYioiaApLWBJGGJLiKqX98x2Ci3/8wABLefUpD5
        3b+7d5VVRT03UEN6enzEuQWRmBP+2Ck/u5x9YDSRS8pvZuJYTdHeKXIfM5JIwyQHIFmk8wuXDY9
        Cwzp6Db+x/9RvxkQiVkbBLE5Mc8d1jDK6jA==
X-Received: by 2002:a05:6402:40f:: with SMTP id q15mr7790416edv.333.1633628702713;
        Thu, 07 Oct 2021 10:45:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/cRrFbBE0AEAY1wTn0RkOd29OzBi3ThqVg6eaCa0cLj3RymI+vrrOi/pDfxhLH7N7JZpaZg==
X-Received: by 2002:a05:6402:40f:: with SMTP id q15mr7790386edv.333.1633628702498;
        Thu, 07 Oct 2021 10:45:02 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-186-13.adslplus.ch. [188.155.186.13])
        by smtp.gmail.com with ESMTPSA id u23sm24243ejx.99.2021.10.07.10.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 10:45:02 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Lin Ma <linma@zju.edu.cn>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Greg KH <greg@kroah.com>, Will Deacon <will@kernel.org>
Subject: [PATCH] nfc: nci: fix the UAF of rf_conn_info object
Date:   Thu,  7 Oct 2021 19:44:30 +0200
Message-Id: <20211007174430.62558-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

The nci_core_conn_close_rsp_packet() function will release the conn_info
with given conn_id. However, it needs to set the rf_conn_info to NULL to
prevent other routines like nci_rf_intf_activated_ntf_packet() to trigger
the UAF.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/nci/rsp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index a2e72c003805..b911ab78bed9 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -334,6 +334,8 @@ static void nci_core_conn_close_rsp_packet(struct nci_dev *ndev,
 							 ndev->cur_conn_id);
 		if (conn_info) {
 			list_del(&conn_info->list);
+			if (conn_info == ndev->rf_conn_info)
+				ndev->rf_conn_info = NULL;
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}
-- 
2.30.2

