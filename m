Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB302AA6FB
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgKGRXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:23:46 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57564C0613CF;
        Sat,  7 Nov 2020 09:23:46 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id x15so1643017pll.2;
        Sat, 07 Nov 2020 09:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eAp0pK4KzjRqqD/baLCKjCsG8PKBRZRcMg8qB8SJ2ys=;
        b=B4/wE20oItQPSjrj4O0gFoVU1fo1CMtVWbl2Bqs2uJSCLFV63cIsziKsEXwF1grEO3
         RcVmlswSSM5YUGdzxT4t975xfFv9ucdpNQ3hrC3kW7V2yImt1w4WphzZDVCpzPmGMTBo
         fUjD6iZi2M0XkyQqB7JH6CF+k37uKSVR6DN4GOro+ZoaXc3ySmlfw1Ii7hZ1sccXp22a
         +PHT2OVxI4uAmVPyxguP5tXzxJLLdsyEKqxjK0P8i2n6W1GMm+pkBn6mSIJBt0AsERVI
         qPzntnyXKdmyf7ZbX9EcD+ZO/sJNsdVCd2N85EREwdxasx/VG8VSJa1gBwhSRTXHs4/t
         6ixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eAp0pK4KzjRqqD/baLCKjCsG8PKBRZRcMg8qB8SJ2ys=;
        b=UYTL2AoYg5jAi84yOkVekjBQ2Nj62uO8H0RbwvSu6vw9TX3jQnh8+FhPadgGSlVHdE
         crSxtl7eASvZc940M/N82j5xNQprUOUnZX1BHfm1Q2Qb63U+kzNGIBctlQCOTtxFJ3Rn
         yRmoZQ1AKfN80yhBpDGQvYho+ePvrF+bSuseVhxVBGXqwCIQakNf1KkiK5ny3VKXx6kv
         Y9a/V0LX/0+6HWxIMD6Ex07Da23JNg/rno7NfQSBpNWTV3Vr7eQ2BTQD3bkeN3TI7nDX
         nLDsNr29IhPoEZd8DgoWOKQFkeAgz8VAJPLYOXaZOwTDobTzBdKRF3sEFBpriLZSrgNQ
         012w==
X-Gm-Message-State: AOAM530P8GxtrFO/OPUCdCTxciYUW3fYwlCFK7QZxchv3vpID5OJhODa
        2ERwWXQABaM3a0m8RXSbmek=
X-Google-Smtp-Source: ABdhPJyTpVlXUKFNyQbZ6ITAzYdrTBi92c5vkmRIDCWCay2TvL4Fzbc6jDw0XzuPSo5db5Ef9NA/GA==
X-Received: by 2002:a17:902:c242:b029:d6:c58c:7fe7 with SMTP id 2-20020a170902c242b02900d6c58c7fe7mr6147931plg.51.1604769825909;
        Sat, 07 Nov 2020 09:23:45 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:23:45 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, David.Laight@aculab.com,
        johannes@sipsolutions.net, nstange@suse.de, derosier@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, michael.hennerich@analog.com,
        linux-wpan@vger.kernel.org, stefan@datenfreihafen.org,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        stf_xl@wp.pl, pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry.Finger@lwfinger.net, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Subject: [PATCH net v2 07/21] wlcore: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:38 +0000
Message-Id: <20201107172152.828-8-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: f5fc0f86b02a ("wl1271: add wl1271 driver files")
Fixes: bcca1bbdd412 ("wlcore: add debugfs macro to help print fw statistics arrays")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/ti/wlcore/debugfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index b143293e694f..559c93543247 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -35,6 +35,7 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_ADD(name, parent)					\
@@ -68,6 +69,7 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_FWSTATS_FILE_ARRAY(sub, name, len, struct_type)		\
@@ -93,6 +95,7 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_FWSTATS_ADD(sub, name)					\
-- 
2.17.1

