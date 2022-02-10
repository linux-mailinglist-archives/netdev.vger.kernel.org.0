Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5A74B0614
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiBJGJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 01:09:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiBJGJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 01:09:33 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F595FEC;
        Wed,  9 Feb 2022 22:09:34 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id k9so3943476qvv.9;
        Wed, 09 Feb 2022 22:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jT2VUOtIQfoNyG3Ewt7SAd6JYYbSI+5T48hu+9Y9c+c=;
        b=iu8E8I3Adrnxpo9y5rJvuLSV7Vuh28V4cAxSVRXWS20ZlP/Y+B79F0fvvLIHBup5UV
         YDErmZhQmRfvCaTVikUeq7bDSUjc8pJksT/ZXMmrbnbpHGj6WCY8eyVlEZEQ1hmGXart
         PdO7MdNVRFKPO1+WDv5R2q/CNqBwKAfiQF3c5DVNVUGjSR7bglHeU5Pd7+6QJEQk1zEp
         9QrugWaxry3cpDdjoo04jLq/LwJFWFc9fEc2ywGH7X1vg7zv4XoklrGVdmCdg7F1dkdH
         EedNkYPgq0sBX4ZiqQBTBqNp6K2nJPeGVpmfBO7Dgd9A6YRfVH1Um/YLQY3sRr859HU4
         nmiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jT2VUOtIQfoNyG3Ewt7SAd6JYYbSI+5T48hu+9Y9c+c=;
        b=4V0TLohkAVjRXlzePvMHBaTtPx5VoA54CL33HEu4iQ2+mikzaK4M4cMmWKjfdmVt4p
         6SVFu2siM8QxV3Th7tU9NybINLUQi+tX77e/4mJmlw0chSXULXxyAICetbdrG+hZ0cIp
         kkyjpuIhCOAlY6si6AdzXJkGouKZ+WPQl8yM0ZD+m5lkblyPYlUfxaVAvGiNAMbpB8O3
         glyLOr3mnrAimRDSaUbwP35dofossnex1xRBw++oFGfiozvzrWtMZuCtc1Bu3tTEx3iE
         HrvEPnEnJ+qE70xpuYPct5nJ+O39C5ewpPhNtHO9ZPGsxiwOVAMFOhJWRul8LgYavJC/
         ysuA==
X-Gm-Message-State: AOAM530MB92fB3ViMClRb4KEL8+7xBXAkwHq/tRD/JI6WK2UW55FuV3V
        zBmgmFZRANaoqiO8Yzpqcpo=
X-Google-Smtp-Source: ABdhPJxR8cwFiyTedmD0fWPi9wFBQDTgOLiLzNVHnY4uMjyUFyoKtZw4B4JwNMDOFzLuvLlRPQ5yvg==
X-Received: by 2002:a05:6214:21e8:: with SMTP id p8mr4105812qvj.116.1644473373741;
        Wed, 09 Feb 2022 22:09:33 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o3sm10244425qtw.3.2022.02.09.22.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 22:09:33 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     luciano.coelho@intel.com
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        johannes.berg@intel.com, trix@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] iwlwifi: dvm: use struct_size over open coded arithmetic
Date:   Thu, 10 Feb 2022 06:09:26 +0000
Message-Id: <20220210060926.1608378-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kmalloc(). For example:

struct iwl_wipan_noa_data {
    ...
    u8 data[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index db0c41bbeb0e..bc6ed2f712f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -915,7 +915,7 @@ static void iwlagn_rx_noa_notification(struct iwl_priv *priv,
 		len += 1 + 2;
 		copylen += 1 + 2;
 
-		new_data = kmalloc(sizeof(*new_data) + len, GFP_ATOMIC);
+		new_data = kmalloc(struct_size(new_data, data, len), GFP_ATOMIC);
 		if (new_data) {
 			new_data->length = len;
 			new_data->data[0] = WLAN_EID_VENDOR_SPECIFIC;
-- 
2.25.1

