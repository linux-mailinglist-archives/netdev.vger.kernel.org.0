Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7087618781B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCQDWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:22:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46939 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgCQDW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:22:29 -0400
Received: by mail-pf1-f193.google.com with SMTP id c19so11118593pfo.13
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 20:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jcs/0s3CZSPtzbiw1HbYF9/yaS+V0LYheoQxKQVUgmI=;
        b=hv4Vtc2KQyyE5KmPpXzLpj1wRip/OF/MRj/c/YN62e7VowmHFmobYjvFTfOin0rshf
         om2xQR86rG53nf/urEGUUgDyAnU0teTWhP2P00KFqpSI/UI0k4EGuR6JdcWjGGTLnIlD
         TTKC/AT9gH5Qb017GxUjjGnm92tPplmUe84zg2jabzKCAHdmeKm383lzsCdFyDZC6knZ
         HPCyxABnxsf1OwDIg8WPeMvfUNlpeg0I0f34DWIKqIs93LWXcHApfgqT8c35O8DO8tAn
         pp6N0vPblubO+FF2QejlYxnOsoj9feAHUx7QzmMmoDP+BfwR24NZs3mA1j/PDe4r6HdG
         qu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jcs/0s3CZSPtzbiw1HbYF9/yaS+V0LYheoQxKQVUgmI=;
        b=RjFwECKdHzl52ufIHo5NPV+XJrgffcY+5k08pXIU8ZtZix0K4uno6jN8nLQEDA5jhS
         NloTrAICtR2WAxXj4WIWpiQSLsPrz3/owQqaD8XthdDB/JeCEV6cz5sV3jpYVzL1IeSv
         QbEbzY/lnbz2AWX/NqF/ZC72hin97ITEBTTgbeihYf+b0kqyuiK19qpP0kdoWmQ2IypI
         338SopHMEIWhyoE63J8NYLxHWo+O+m18dbxs7F+3xihIevQSe4ZLXBiRDwMHBMbD51X+
         T00KRaE6YSI4IAfxcxRCgCiBUQc0+kj4QH4qM1I2Jw2Vg9cwj+xNADS7fL1UuDe5JfAy
         VJvQ==
X-Gm-Message-State: ANhLgQ1mPYCl9KlYfMQ53+QTz9gSzp01xROhxuNwNDsinFx4w2jsFs/E
        xEctQUPbkZoefXXK/Q8lsxgkbu8inqA=
X-Google-Smtp-Source: ADFU+vu3S3cfEDSrsZnLTc8o+IaASNFuwnLO+3V2YhZrH1OMx01gbVIHNUZ6bEia8HwK7HiUnJ5czw==
X-Received: by 2002:a63:a35a:: with SMTP id v26mr3142113pgn.40.1584415347693;
        Mon, 16 Mar 2020 20:22:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f8sm1185639pfq.178.2020.03.16.20.22.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 20:22:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 5/5] ionic: add decode for IONIC_RC_ENOSUPP
Date:   Mon, 16 Mar 2020 20:22:10 -0700
Message-Id: <20200317032210.7996-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317032210.7996-1-snelson@pensando.io>
References: <20200317032210.7996-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add decoding for a new firmware error code.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index e4a76e66f542..c5e3d7639f7e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -58,6 +58,8 @@ static const char *ionic_error_to_str(enum ionic_status_code code)
 		return "IONIC_RC_BAD_ADDR";
 	case IONIC_RC_DEV_CMD:
 		return "IONIC_RC_DEV_CMD";
+	case IONIC_RC_ENOSUPP:
+		return "IONIC_RC_ENOSUPP";
 	case IONIC_RC_ERROR:
 		return "IONIC_RC_ERROR";
 	case IONIC_RC_ERDMA:
@@ -76,6 +78,7 @@ static int ionic_error_to_errno(enum ionic_status_code code)
 	case IONIC_RC_EQTYPE:
 	case IONIC_RC_EQID:
 	case IONIC_RC_EINVAL:
+	case IONIC_RC_ENOSUPP:
 		return -EINVAL;
 	case IONIC_RC_EPERM:
 		return -EPERM;
-- 
2.17.1

