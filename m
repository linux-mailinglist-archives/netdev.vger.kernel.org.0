Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DA08EEE7
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733302AbfHOPAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:00:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55291 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732229AbfHOPAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:00:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so1529028wme.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WPjOAnZ6DM44rpKDf5ErzyVWiSn5JFBQCXEWf67zCeY=;
        b=z4TOHubQDXl0F5kyDbvSwCXz9icNhreThbItk9nKoAQY5wQqrxBQDgRo8xatFyyEjK
         2u3E8Mj5eNJBVxRuL6+e/fa6Vx6OWC2jj3Ca3vmG/D5Qxnk21+t2vCaEloSW7wzcZklT
         mMy+0llYblKvE6jTAFBrcPD19E107q3Ltop7YHzSmwERZuYZrgdFC71As8hHrbvuy1AP
         cr69m1Y7ao2sBOPwbCSnyDwrA9UV0J8bVaSo5wcvcPDt8usYlSU1olbBMoXg1symRdLD
         6OC+mb4UHVrOMKRbyiw7R0SBsUUUUcuONBU1ngcMEhfvZUptdK52m1orwAOwPNvKfQiE
         3pQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WPjOAnZ6DM44rpKDf5ErzyVWiSn5JFBQCXEWf67zCeY=;
        b=toFNfeishKpN2zyWF35ZdDL0NVXmtgBBaZ4yK2incdBrRU11p1ZQQA9uCIqSpcXmF4
         +QuMGePPc0hqc/O1BCq5FzM2VQxAw/sxUkt09VLrHeJizRbWNrNfKbqYoekugGBPRo6M
         QEAZTJaXpR6ONGnpenoWjf2FB8KYTBqqp2ftcR55wft/8hcLFyqVHNN7xxIxvAlX4tNG
         N1L5/xuIhXUd8gBFgLvAYJdJNEUONlVPIvhFqjZQfwBepcpnnGdQ9LiXwgH9Kp9oLmKy
         qoI63pBx0qV8TGbPN7urXQQZq7u7YRDqq7NSfmgsV3aBU+/f8tHeP2ij5Xn3Tu+H6oHu
         OPKw==
X-Gm-Message-State: APjAAAWe4zqnBEXqOsMgcP6YlvRDZGW5t3DbPPZo1CgJ33uL9NpySha6
        eP5qz2RFi96sCY3FAYsSN0kxGA==
X-Google-Smtp-Source: APXvYqzoUpka7CXCUJQAbcSDGE/qzVr65hzIknalCFmbkpMRxk0FW9NHqHkCMLDHn/JhrxHa2l/agQ==
X-Received: by 2002:a1c:b189:: with SMTP id a131mr3298787wmf.7.1565881232364;
        Thu, 15 Aug 2019 08:00:32 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a23sm2794857wma.24.2019.08.15.08.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 08:00:31 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 2/5] tools: bpf: synchronise BPF UAPI header with tools
Date:   Thu, 15 Aug 2019 16:00:16 +0100
Message-Id: <20190815150019.8523-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815150019.8523-1-quentin.monnet@netronome.com>
References: <20190815150019.8523-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synchronise the bpf.h header under tools, to report the addition of the
new BPF_BTF_GET_NEXT_ID syscall command for bpf().

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tools/include/uapi/linux/bpf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4393bd4b2419..874bc5eefee1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -106,6 +106,7 @@ enum bpf_cmd {
 	BPF_TASK_FD_QUERY,
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
+	BPF_BTF_GET_NEXT_ID,
 };
 
 enum bpf_map_type {
-- 
2.17.1

