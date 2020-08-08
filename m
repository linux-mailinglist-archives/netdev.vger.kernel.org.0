Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A653E23F63C
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 06:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgHHEGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 00:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgHHEGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 00:06:42 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E736C061756;
        Fri,  7 Aug 2020 21:06:42 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id p4so3635899qkf.0;
        Fri, 07 Aug 2020 21:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eBX2STd6CRBk1vKmSlEBQtLB8UUMASbhavMeJ1WJR0A=;
        b=ImMnrn3Z4k3xH3d5wjuGGYN5dCY5Wg7yTR6mWwxE/0/bqZN2eh0ux/M635crPwEWDO
         RUqUkjgZ166oTo3IMuMmnuMHsSMhkDzoRms1MNwfTUorcMFXA6UACHWMaal1MUaCARlN
         RUqIlF2x87k23WZtrRs2/GqwsDiG1blYKkLittDuyJQzNHsFAhC5NfgMSB0kFmP2VIYD
         2X3iQoriLLXUSbdBDPmnR2S8YGDLWYyiyAjU6JfeQLkoIAcUMa/itMhvlGFDVDWyx3bU
         osogjoRLH9tdNW8lQiZdZcy9WzfK4K3DIN248WTy1sj5QRBgygAtyaU6lmCPxULnuLC6
         DqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eBX2STd6CRBk1vKmSlEBQtLB8UUMASbhavMeJ1WJR0A=;
        b=X8F/7+R/+iOLZpWCkoZZGiEWtCqKhrLp07JmhlwRAMhMeiKzwtceA9z1bxXNv6OUCD
         cY4M1/wG3Ji18qN2IyUlmTI9Qs9DaVgI5f1HlE0cdYvfddV5B66z0LLXpguJXMHGyRjR
         fSn6heNYswsJZ8gqsc9nv7g0OoDAKIhsCudvqdxRL8DsYG4JlxOMoO7AoRWIcIhyZv20
         C83m2htx14OUIYLS2hsn37pQRocNvw+aP7/jKOIbooj2gJUGQYofZYVIX4UlZRD7J6YM
         R416hKME0SNhHzWGqtXZsU1vAhV1kHvkx9fMPScmuhsE4rhClvXxFXPNY3rg6yQV/ded
         pVHg==
X-Gm-Message-State: AOAM533KCDOXIwgVQnuVm7h/kpwsqVHLrPNJ4K0R9w6UdrwadWG4Z0Jn
        bDE3XyX9MYIC5ZvyPztVPw==
X-Google-Smtp-Source: ABdhPJyiVi2TyBkfekwvTN8eseV1M60k4LZxF4cWE/pBssVqKoNRkt5Jy/31+Zj0ox2uqwcG0951nA==
X-Received: by 2002:a37:a503:: with SMTP id o3mr16204813qke.162.1596859601722;
        Fri, 07 Aug 2020 21:06:41 -0700 (PDT)
Received: from localhost.localdomain (146-115-88-66.s3894.c3-0.sbo-ubr1.sbo.ma.cable.rcncustomer.com. [146.115.88.66])
        by smtp.gmail.com with ESMTPSA id i7sm9264630qtb.27.2020.08.07.21.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 21:06:41 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] Bluetooth: Fix NULL pointer dereference in amp_read_loc_assoc_final_data()
Date:   Sat,  8 Aug 2020 00:04:40 -0400
Message-Id: <20200808040440.255578-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent amp_read_loc_assoc_final_data() from dereferencing `mgr` as NULL.

Reported-and-tested-by: syzbot+f4fb0eaafdb51c32a153@syzkaller.appspotmail.com
Fixes: 9495b2ee757f ("Bluetooth: AMP: Process Chan Selected event")
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 net/bluetooth/amp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/amp.c b/net/bluetooth/amp.c
index 9c711f0dfae3..be2d469d6369 100644
--- a/net/bluetooth/amp.c
+++ b/net/bluetooth/amp.c
@@ -297,6 +297,9 @@ void amp_read_loc_assoc_final_data(struct hci_dev *hdev,
 	struct hci_request req;
 	int err;
 
+	if (!mgr)
+		return;
+
 	cp.phy_handle = hcon->handle;
 	cp.len_so_far = cpu_to_le16(0);
 	cp.max_len = cpu_to_le16(hdev->amp_assoc_size);
-- 
2.25.1

