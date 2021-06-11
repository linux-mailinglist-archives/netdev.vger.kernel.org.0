Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753093A458A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 17:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhFKPhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbhFKPhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 11:37:41 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582FEC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 08:35:43 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so810527ood.2
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 08:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZseriZ5OxO1elE/wbT2+J0bfhpQJVlHXTwmB3hjN6Q=;
        b=rnIGTQ5Bm/JLxkF4Ilh6EqCfDTCXa++HTvGdKO4W84c9t5keFV/XeEf4hQcW270k4F
         JKEEDVg/TPiNi2a/ApMecssORfFJSYJlWTF+ja6oamGxzkKPSSj/+hT5T4i06LUXtwsI
         gxL/RS1uKgh2sGauHR9QrIc26n1Zr7pSJFiDtYCj1TxDuk5gcmdPlQ7U172szkpogwKs
         VGJ6z2yRIWqJ+IsDpKbc3U9UQwbsdS5P1WDEaWgKFw5p15/QP7voDxoSfKhFPvKJ4Y0V
         d7XBEjfZIEbULOuWJnqvoU3+KtSyCrggGCXwayVpAdWVerAJW/nIh5Cf9D6ClpoX8lUH
         v3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZseriZ5OxO1elE/wbT2+J0bfhpQJVlHXTwmB3hjN6Q=;
        b=ci11g0x7lYJpviPUxdPc3GV8n5g24ku5xfcueh8BYfNfjHiNG1P7I8w/xqoG299NOV
         LtkBJ6JM99tSg22flpCV5+X+DBoKVFMYgs2ww/DNND2A1wTQgLycLRexYUk/ESGS8zxQ
         RxboG99OTYGdaQp8s47UvUtW5MugGjWX8y9ZZ6gaVi3HB/ZC7rC4Teo4k/vS+jwJEAkU
         AuPuzOfZ0zPnBHHG0gaX9KU/JfLD2NO/RN5RVQfXn1YI1a8YgZMbbE7jt4+s1YTpgYKq
         7bLvsycJkTJ5g06aIxN9HYEhntY0svsx9D6AYm3QgT7uayY9YcSGfn+wDCz5zYNhdEz1
         GxEQ==
X-Gm-Message-State: AOAM531xRQXn132fmSe4UtMYLevF6PA+8muensqSGoeSE/aEqaJZCdXM
        xGbHL5BaRlR5BLOoi2NkzYMKeDLjPbrk/w==
X-Google-Smtp-Source: ABdhPJypQhZUAEvG0qYwR99gfNNd93PBK3Dv103z6SprAAlCjm+6wFl9j1AxwDQJoYcckWuj9gHLBw==
X-Received: by 2002:a4a:e6c7:: with SMTP id v7mr3561444oot.86.1623425742544;
        Fri, 11 Jun 2021 08:35:42 -0700 (PDT)
Received: from fedora.attlocal.net ([2600:1700:271:1a80::2d])
        by smtp.gmail.com with ESMTPSA id j3sm1212507oii.46.2021.06.11.08.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 08:35:42 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] ibmvnic: fix kernel build warning
Date:   Fri, 11 Jun 2021 10:35:37 -0500
Message-Id: <20210611153537.83420-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/ibm/ibmvnic.c: In function ‘adapter_state_to_string’:
drivers/net/ethernet/ibm/ibmvnic.c:855:2: warning: enumeration value ‘VNIC_DOWN’ not handled in switch [-Wswitch]
  855 |  switch (state) {
      |  ^~~~~~
drivers/net/ethernet/ibm/ibmvnic.c: In function ‘reset_reason_to_string’:
drivers/net/ethernet/ibm/ibmvnic.c:1958:2: warning: enumeration value ‘VNIC_RESET_PASSIVE_INIT’ not handled in switch [-Wswitch]
 1958 |  switch (reason) {
      |  ^~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d66e15866315..830d869e235f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -869,6 +869,8 @@ static const char *adapter_state_to_string(enum vnic_state state)
 		return "REMOVING";
 	case VNIC_REMOVED:
 		return "REMOVED";
+	case VNIC_DOWN:
+		return "DOWN";
 	}
 	return "UNKNOWN";
 }
@@ -1968,6 +1970,8 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
 		return "TIMEOUT";
 	case VNIC_RESET_CHANGE_PARAM:
 		return "CHANGE_PARAM";
+	case VNIC_RESET_PASSIVE_INIT:
+		return "PASSIVE_INIT";
 	}
 	return "UNKNOWN";
 }
-- 
2.23.0

