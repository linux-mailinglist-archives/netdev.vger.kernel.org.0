Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0DF32E01F
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCEDbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhCEDba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:31:30 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CD1C061574;
        Thu,  4 Mar 2021 19:31:29 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l18so1070913pji.3;
        Thu, 04 Mar 2021 19:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3DJxHAaaivZloDKJkg7BmraW1QxR1uQyEaZvyq60QtM=;
        b=G90QU+ixdE7gddy1nulVOaRcMw5p33BJcRUNVZMYb2MsNAi3VN83E2lcBSYX49Iv68
         nX0x2GMyT35CXiXj/M7HW1LScfqTCR2jqvXr2Rfmbga/oKVr7h5l/ECiaIxU8a1skvkY
         0huaucMpQzbTNownRDYDSvGKuGBsgxkNQ4wHtk2F0tFvofKy8H/8YmOKVC+osZpbwxB8
         IVgRTwgoti8HsIB+omRnQtl8W1VkOCJMJ+VtQ+ExjuzZWv7A6615IyVWM3ILVSRKfgd3
         lHdVL7jODYkT5moFiEtHhN0SD/E1H0Ufms2om4vG4VUfnxZb0x4uu3Esn7vBpGrrti8M
         V78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3DJxHAaaivZloDKJkg7BmraW1QxR1uQyEaZvyq60QtM=;
        b=l9pfUYZkS0N/oCYjotjRCQMRqZUuctfz7hT69TcWlMkTyxl6XLMenapkIgaxYh6YfY
         3k7hOt0Ujdf+sOpzUAiV+wh3r2PC+1TmFc5dDFzZZ8F1J64J4Sb9W7kispBy8OOSU/bt
         rx5qR36TolmvAYfuK79G5FxgI5iew3qLwHTk/PeaEOpqiZuyDmS3S69kh3b/t2jMT22z
         zr5sh27HBhgb6K50XLDmiztBkZQEclpfVcMoMNlAruOmsRA/d2NcSVp8XoS+Furp2wN4
         ME9r08Tka3Df0svb5dwV3VKMfynqkePGrUiyFZuytA2oK0pnRFrqCFoQQLKkkR4KRHpp
         Xqhw==
X-Gm-Message-State: AOAM530MTdCpdjmvq3JHnYFcxHzeEHNSW/2PicIqRB4EYOxaRD6Thj6n
        rIEyL+64yTec57yMo1qtP3E=
X-Google-Smtp-Source: ABdhPJzwhnyVa8A94pkpvh6czEX/mrz9sKQ2e8ru0ba4B1YycIkFNeP6RSRTg+rbceFq8xjGizT9Kg==
X-Received: by 2002:a17:902:6b45:b029:e0:7a3:a8c with SMTP id g5-20020a1709026b45b02900e007a30a8cmr6885503plt.1.1614915089101;
        Thu, 04 Mar 2021 19:31:29 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id i66sm712567pfe.31.2021.03.04.19.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 19:31:28 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        lee.jones@linaro.org, colin.king@canonical.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] marvell: libertas_tf: fix error return code of if_usb_prog_firmware()
Date:   Thu,  4 Mar 2021 19:31:15 -0800
Message-Id: <20210305033115.6015-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When check_fwfile_format() fails, no error return code of
if_usb_prog_firmware() is assigned.
To fix this bug, ret is assigned with -EINVAL as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index a92916dc81a9..ceca22da5a29 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -825,8 +825,10 @@ static int if_usb_prog_firmware(struct lbtf_private *priv)
 	}
 	kernel_param_unlock(THIS_MODULE);
 
-	if (check_fwfile_format(cardp->fw->data, cardp->fw->size))
+	if (check_fwfile_format(cardp->fw->data, cardp->fw->size)) {
+		ret = -EINVAL;
 		goto release_fw;
+	}
 
 restart:
 	if (if_usb_submit_rx_urb_fwload(cardp) < 0) {
-- 
2.17.1

