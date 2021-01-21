Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BAD2FE63C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbhAUJVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728563AbhAUJVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:21:24 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BEEC061575;
        Thu, 21 Jan 2021 01:20:44 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g15so964935pgu.9;
        Thu, 21 Jan 2021 01:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Sz/h72dyLuELqYJOsFy6jSdWskNfpEWG/8SaPjEfNs=;
        b=D3Jb7OEi/dpAyRpfll0onfd5v22BLMmUNM7AftmWLPyMZydhXKUFfKOGgY2VUymS2y
         qpbf9VZOhJIEjt987+Rc8gzoQoMk3oJ0v5/SlJUTuHP0XyzsatjjKR8z0q71GJZhSfB6
         sVfS5Z+MkotMlbOECdgPoEhAyGTfy/gQOzHRnCwnYCOSOFmQELPYmwmkGBf1Xc2oPr2q
         zz2z33vHzUcr0TWC0jYsO7i/o0Mv0E6xlb1PuIFiTkef1ihaReXzojvjW1hgmBeY6kVm
         4Z4hPHSU1UQKUr11q4SB0cPm/CE2zUyh+6Rxf7EMH+AkVW/iF9pqX2vXFxIejkwpRmpg
         OtYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Sz/h72dyLuELqYJOsFy6jSdWskNfpEWG/8SaPjEfNs=;
        b=q+M9oGABfGG9GLShnPCbvNJG5jPBuU8Aqri+jlLkr1BiLFbhr+pv/dJXO2lSAIHnoN
         u9PggNslR4XbIrLA7D+VvsFsPCvmHByQrIBfH02fzgSvCQKwW7jnE4+OJQfD2tZLAgPE
         ig72ubkxC09s4vUjViWfzR29dyIxJ/EszEjbNsgcRlAIpX8PpXFhOWDCWl13ln/5NpCv
         kmpv1TN22+N4F2Rnns6mdrNQEve/nWJZEEzSw4Uhp2T5E7f/BehE7akmH6AtLmkfS7b7
         CJMRIwmbhbQeilzZFEKZxB38EDGjkndVlK6h29vCxIxE3MrJxFtDOZM3C28s7VG/xovh
         LsVw==
X-Gm-Message-State: AOAM53161OAzTW5SW30c9qi9UR7Uc3VNXnzYok/p1UhVV15GROu/hky4
        P+K1XdAIXfFhUiL9fwcLFP0=
X-Google-Smtp-Source: ABdhPJwRiG1jIWQRcy3oGXvT5gmAgoiayc+xl1rW116hZwd/Es4CDE/8AZqd8065JnY5773amNZ0Mw==
X-Received: by 2002:a62:445:0:b029:19c:162b:bbef with SMTP id 66-20020a6204450000b029019c162bbbefmr13244073pfe.40.1611220843758;
        Thu, 21 Jan 2021 01:20:43 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.69])
        by smtp.gmail.com with ESMTPSA id i1sm5231415pfb.54.2021.01.21.01.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 01:20:43 -0800 (PST)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     davem@davemloft.net, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, sgruszka@redhat.com,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH] rt2x00: reset reg earlier in rt2500usb_register_read
Date:   Thu, 21 Jan 2021 17:20:26 +0800
Message-Id: <20210121092026.3261412-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function rt2500usb_register_read(_lock), reg is uninitialized
in some situation. Then KMSAN reports uninit-value at its first memory
access. To fix this issue, add one reg initialization in the function
rt2500usb_register_read and rt2500usb_register_read_lock

BUG: KMSAN: uninit-value in rt2500usb_init_eeprom rt2500usb.c:1443 [inline]
BUG: KMSAN: uninit-value in rt2500usb_probe_hw+0xb5e/0x22a0 rt2500usb.c:1757
CPU: 0 PID: 3369 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Compute Engine
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 lib/dump_stack.c:113
 kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
 __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
 rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1443 [inline]
 rt2500usb_probe_hw+0xb5e/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
 rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427
 rt2x00usb_probe+0x7ae/0xf60 wireless/ralink/rt2x00/rt2x00usb.c:842
 rt2500usb_probe+0x50/0x60 wireless/ralink/rt2x00/rt2500usb.c:1966
 ......

Local variable description: ----reg.i.i@rt2500usb_probe_hw
Variable was created at:
 rt2500usb_register_read wireless/ralink/rt2x00/rt2500usb.c:51 [inline]
 rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1440 [inline]
 rt2500usb_probe_hw+0x774/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
 rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index fce05fc88aaf..f6c93a25b18c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -48,6 +48,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
 				   const unsigned int offset)
 {
 	__le16 reg;
+	memset(&reg, 0, sizeof(reg));
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
 				      &reg, sizeof(reg));
@@ -58,6 +59,7 @@ static u16 rt2500usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
 					const unsigned int offset)
 {
 	__le16 reg;
+	memset(&reg, 0, sizeof(reg));
 	rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
 				       USB_VENDOR_REQUEST_IN, offset,
 				       &reg, sizeof(reg), REGISTER_TIMEOUT);
-- 
2.25.1

