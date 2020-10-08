Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E86287956
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbgJHP7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbgJHP6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:21 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5434C0613D3;
        Thu,  8 Oct 2020 08:58:21 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x16so4677181pgj.3;
        Thu, 08 Oct 2020 08:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GptPqW+YBVZbflI+JOZGmhDhTFZoI6lt7BxarReCpAo=;
        b=UMKeA8LY1Qk7ghT/Io+5D79urxzLni27kL5YzE4uT+H/0BuTRwwg9sgXP3Z1UU82MC
         4xped/OOHN2PZCXpebyYCoyOUCMzG8i+gmp6UbTPu94xjlpFNslvlX3GomtTHNN0nyrJ
         iGEy/ZzImzHDaIg4ghhWhx1j8f56UXLKD9ksh7gaXwDCgJjEkgjdmzGdwx2n301rcmay
         YXpPf0YYoPYR49NEeVqFbJbqxht5M5t7gWzPIS18q73FXJtR8Fs2JgSYSBpgxNrED2H3
         3bAV58jj0sG26M+nM4JuNIs1SCAXQFXjP07/i6/pwU32eEcOE6nYDpGrWOymhJeJw8In
         6UsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GptPqW+YBVZbflI+JOZGmhDhTFZoI6lt7BxarReCpAo=;
        b=UI0E5tPYbDmN27zmbD0joMSKXIdnJ9FcSCvDjGHeV3s4mLXvFWXAL/zzzfcROPGqCk
         Zi7kPkkH9uDUXFWZ/hAP1s7sU+yiSo/j10xE+PP3fMHn5i3zXKS9FglXrzrS4GWqnE8x
         Vz//bM5ERtz6P+DM+ZvONWVjQnG0EPjmIWCdlM2I4w14X4oLnhj1nJpmbZjRMW3KK+5D
         0nbRfNHIFDo4puiX5fUjPFoppvDIzV7QbFcKgffzMDP9ab2Gov2GR1sHMSNtfJGo3rhR
         hxzRjngjoYo0JgO01wmayxL1/qTBQvZwpL2aQjlejgfUiZtCLg+hunnv73xaV5t/ictB
         PH5w==
X-Gm-Message-State: AOAM532lYpID5JPK7H8/xcmL0zSPME8ssnorDpJBia9EZTQXaLTeOCRF
        We/8C9bYAJ81ZuJhFOB8hPw=
X-Google-Smtp-Source: ABdhPJzIAX4KCPiO/JSqKYkaV8RS4Q//H5n6WE8edJ/nxs+KEDg7UobC1HDGUkM3vk4D7dpq664AOQ==
X-Received: by 2002:a17:90a:2dcd:: with SMTP id q13mr8762014pjm.202.1602172701435;
        Thu, 08 Oct 2020 08:58:21 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:58:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 116/117] Bluetooth: 6LoWPAN: set lowpan_control_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:08 +0000
Message-Id: <20201008155209.18025-116-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index cff4944d5b66..0936184f0813 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1214,6 +1214,7 @@ static const struct file_operations lowpan_control_fops = {
 	.write		= lowpan_control_write,
 	.llseek		= seq_lseek,
 	.release	= single_release,
+	.owner		= THIS_MODULE,
 };
 
 static void disconnect_devices(void)
-- 
2.17.1

