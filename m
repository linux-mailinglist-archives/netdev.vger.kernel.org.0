Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B4A253A7F
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgHZW5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgHZW4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:56:41 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC48C061756;
        Wed, 26 Aug 2020 15:56:41 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id r13so833518ljm.0;
        Wed, 26 Aug 2020 15:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hgAI8q2j0AZh1tvmkKar6IJHXC6blIHNOlRoGq8CQhg=;
        b=BVXtUQ3+S7vWfJMKiRXenJgRm8IQbPOYDE1d4+ncKZ+ng0sOlYNqlR2OPvSvkEQuIf
         EdjWcmRLkQ09egztT44e2+/B/+qSqCmgxTV3/TVx7Wge99hpudsLwYcNjl2LV5MVLruu
         gsT8zuItxYTs5v016vwxwkgQErLrBtAgYaD6Xput1JCekN6AxIVuIbdv+6LOUzAfGhQd
         GqLoEVE0yKQlk2jIUEgjTgtQ4qkfQnUYTZO8nX7szugrw9eTOvte/9tuV6hKNQ+gxLGN
         KQvk7jpYglX7GA2Wg7k1ws+ocOD/RSOvmXX7f3jZL+G5Ufjrv3+zAm05/BqvAQpmpIE5
         fD6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hgAI8q2j0AZh1tvmkKar6IJHXC6blIHNOlRoGq8CQhg=;
        b=o0tvyPM7sO8Jmuvyvpw2Wo0q2U+m0xWdvtfzIFeD//9slM5oh4KWlLz+DWOhgfy2Gd
         B8xN6Y+Zu016BDJKpiVAeUVC69hLiIbCElRuWKVYZ5bD+oNshDflDPFTmvPnuA00Bu7d
         SPiodmpj/LfZKGtVt7FyB8niAHmFRhoYU93+5h/DVbn9x/sK5QlK9OEHRPmkYdRq9Nm5
         3MTONaSvXsc4rUtc2PXf+N4/c2LeyfdlGZKGZA/HXBRdqaGjdUvn4RJjMlvdLyNc2CM9
         4ugGSVL3J6nLuiUORvb0zn9KT2DjZC6s6TMkl8EQWgclmUarGRnSGm36xxf6/nK3GUlz
         ajaw==
X-Gm-Message-State: AOAM531PAZDz5D2sbAaVQ2wm7B0TPYSK23q0GEaG5WVi9Jjen3RO6E6X
        Xw9ZC0E/kx84QPmYa+n/n38=
X-Google-Smtp-Source: ABdhPJyQrkoC0ZxPorDSS349rPbvidPOhC6FwNRTdt7IAYrl1WtWCfeagJJEa0S0KyoiD7E6twotQA==
X-Received: by 2002:a2e:6815:: with SMTP id c21mr555840lja.132.1598482599855;
        Wed, 26 Aug 2020 15:56:39 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id u28sm49075ljd.39.2020.08.26.15.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:56:38 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH net-next 1/6] net: ethernet: qualcomm: constify qca_serdev_ops
Date:   Thu, 27 Aug 2020 00:56:03 +0200
Message-Id: <20200826225608.90299-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
References: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of qca_serdev_ops is to pass its address to
serdev_device_set_client_ops() which takes a const pointer. Make it
const to allow the compiler to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/net/ethernet/qualcomm/qca_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index 375a844cd27c..362b4f5c162c 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -167,7 +167,7 @@ static void qca_tty_wakeup(struct serdev_device *serdev)
 	schedule_work(&qca->tx_work);
 }
 
-static struct serdev_device_ops qca_serdev_ops = {
+static const struct serdev_device_ops qca_serdev_ops = {
 	.receive_buf = qca_tty_receive,
 	.write_wakeup = qca_tty_wakeup,
 };
-- 
2.28.0

