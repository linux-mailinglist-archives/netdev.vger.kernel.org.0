Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F50144733E
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 15:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhKGOQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 09:16:51 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:35142
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhKGOQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 09:16:51 -0500
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 49A463F4A7
        for <netdev@vger.kernel.org>; Sun,  7 Nov 2021 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636294444;
        bh=O9pqCgMsXCaNEj0SpUPq8dlJCX+c7h9cDUUijvaulx0=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=mAdRykuFTYV4poZFUyWqpRB30FtJu9uB7stMGEqJ1HAX+rA/qbBY123phz6Ywf98Z
         CKjJQ8EQqJiQBLJ6jN8ysuLAsanmjVzrF5y0xY1ZlQt1Y5OA1TlHdqDNcGO715YhnD
         uGT0a0heigRODYhG2iqfKDAT9M6OhcJq01Nz5mfLfzBV+kczcgzshXn14eqpcF5ZGH
         N4kn7ZNIgr5d0zMYh3Mq2NmqX77scUKCD2d+WXzkQd7ovOIfXteHt4r0IeKnR+vDUC
         RepjA6hNJbYfhjsmzZ4B/SGv7wDsD88R4iAL0gav86Q/LIr/3LVVEkOrV9qWfYKoif
         ix3wPKDxHyiLw==
Received: by mail-lf1-f71.google.com with SMTP id y40-20020a0565123f2800b003fded085638so5411796lfa.0
        for <netdev@vger.kernel.org>; Sun, 07 Nov 2021 06:14:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O9pqCgMsXCaNEj0SpUPq8dlJCX+c7h9cDUUijvaulx0=;
        b=suzze1rniCN4ALfpef6ta6Us+SSVFneF8hmqj+fkMjo8QNepU5oyDnBBpaCX3gGxjj
         OkTatkvHvB4eMO+0YjxYbxCYZ2znnPNAmQbdmh87hl7SoKA2DXrluBPnS/ZTMrs5Yh9m
         9rQyCCcCuQtj7gRwvjDJ0kSSGdXTR5XmBt2ZN3DN4odsN5f5oAQ/vuy/b7XQfVVw65rt
         5r14ElV5fOxA7vbpgcOEZfEGadTbcqKGuqC3v3MGYktVGzKLNtLlCgB5cIXxzdc57xLI
         pk2ZU1B1jj+FRNw0e9tASuLt0CyO8reAmQaC6L45Sj+6HtRb5q+cFHPfXjhh40/IVMml
         QnfA==
X-Gm-Message-State: AOAM532Q1+TS5XYiI+HArGYm5BAMVOiMHzPolGVzEiveODMw3cdcfr+0
        GMK8CwAQsEV1g32ERvJR32ohK12Dp39FZ0ok+JvUgv4GDPgMBYdeH1jUMOK4Mo0qFZa8+vAIdq8
        uapZc6ypqh/g2gr1Eo1TBMOwkPtflLz3u7g==
X-Received: by 2002:a05:6512:388e:: with SMTP id n14mr19430186lft.72.1636294443621;
        Sun, 07 Nov 2021 06:14:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuH1fKHFHacU0lmRyB5Colku3qqo+9IOCcLj0U1LZ/I5Q+tnSl6nsY4lQLrZ5FxRoPfk/71A==
X-Received: by 2002:a05:6512:388e:: with SMTP id n14mr19430164lft.72.1636294443378;
        Sun, 07 Nov 2021 06:14:03 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id d16sm285435ljj.87.2021.11.07.06.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 06:14:03 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: port100: lower verbosity of cancelled URB messages
Date:   Sun,  7 Nov 2021 15:14:00 +0100
Message-Id: <20211107141400.523651-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not an error to receive an URB with -ENOENT because it can come
from regular user operations, e.g. pressing CTRL+C when running nfctool
from neard.  Make it a debugging message, not an error.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/port100.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 16ceb763594f..d7db1a0e6be1 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -624,7 +624,7 @@ static void port100_recv_response(struct urb *urb)
 		break; /* success */
 	case -ECONNRESET:
 	case -ENOENT:
-		nfc_err(&dev->interface->dev,
+		nfc_dbg(&dev->interface->dev,
 			"The urb has been canceled (status %d)\n", urb->status);
 		goto sched_wq;
 	case -ESHUTDOWN:
@@ -678,7 +678,7 @@ static void port100_recv_ack(struct urb *urb)
 		break; /* success */
 	case -ECONNRESET:
 	case -ENOENT:
-		nfc_err(&dev->interface->dev,
+		nfc_dbg(&dev->interface->dev,
 			"The urb has been stopped (status %d)\n", urb->status);
 		goto sched_wq;
 	case -ESHUTDOWN:
@@ -942,7 +942,7 @@ static void port100_send_complete(struct urb *urb)
 		break; /* success */
 	case -ECONNRESET:
 	case -ENOENT:
-		nfc_err(&dev->interface->dev,
+		nfc_dbg(&dev->interface->dev,
 			"The urb has been stopped (status %d)\n", urb->status);
 		break;
 	case -ESHUTDOWN:
-- 
2.32.0

