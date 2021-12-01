Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C48E4653FF
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351897AbhLARgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351892AbhLARgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:36:04 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE1BC06175B
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 09:32:42 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so303973pjb.2
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 09:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VDFng/HdHr1z5en3DZh+RIhvqJzKbtsFFlHQpWJVHps=;
        b=PFbBnO4QcqiOnDyKLMv8qME2XvouVSAqMxxG3Be+nyokOph72Oo9J3ZajgDmRuExPz
         Dn5RdJoX0jAUjmfLBvltEkFSxz07kOnztJ3V7VA8B6EGAO2EXHm+I8Cwo40CYBeoYBk5
         rpTQs+r8ZUQFp/Rn3RPrvb6Tv4lp1KQ5bbEXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VDFng/HdHr1z5en3DZh+RIhvqJzKbtsFFlHQpWJVHps=;
        b=qC58TyBVZWgU6HkAUaCNBBbQzlxSY6RUDFulwEwQ1Ta3hthtXLvlxxJ6j0so71mIiy
         xEa2JgYZYwxrl6jbsxAhwFncQd7nBSY0ySyCBwacbUADKB40bVAW2wl1abw/EYsnFEls
         idILOw6LAfYAjMIg3GDTSgbZEMn43u8wFs4ys2spYwPHe91c9s1KzkZwaHrXi3VB+7Ke
         QNmBebALS0fFPRRcnATIVj5EFfG4uAvrdvnU1KLXuLsZQ7wpSvv7VjSCJ3+JU/iMx/TE
         xEZj8zRp/h/Jth8ueGVGHvFuKql5WYZRQMAgbuiI17FA1hJHwj4sFIXSoTUxaVP9vWAP
         ic3g==
X-Gm-Message-State: AOAM532890af/6budwX6JacU/DUxr2IJvw6EXt0KrDqoihndqPXNBUBo
        qXwfXBO9j1tv2U6zCLCkP7aulA==
X-Google-Smtp-Source: ABdhPJxbCZOLVkbSi8hSb8aaT9HL/poHl09z8+W5KXqp0xjeO6WgjDUDlHuOBseaXUocTBzQ/OOf2g==
X-Received: by 2002:a17:902:8645:b0:142:8c0d:3f4a with SMTP id y5-20020a170902864500b001428c0d3f4amr9084371plt.3.1638379962062;
        Wed, 01 Dec 2021 09:32:42 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o9sm293481pgu.12.2021.12.01.09.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:32:41 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Carlos Cobo <luisca@cozybit.com>,
        linux-kernel@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 1/2] libertas: Add missing __packed annotation with struct_group()
Date:   Wed,  1 Dec 2021 09:32:33 -0800
Message-Id: <20211201173234.578124-2-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201173234.578124-1-keescook@chromium.org>
References: <20211201173234.578124-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1155; h=from:subject; bh=UHcWUjjchMfnBh6ACbi53yKeEOrVQYslm/sSokOlE+M=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhp7Gx/RgHNdsPLmzjDYuEiI9vMdoO8j78eyHwZ2rs IlEbUlSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYaexsQAKCRCJcvTf3G3AJrphD/ 95/0le+jMZxsKtI9YiFhTKDT13uBt5ykYHVuufhXiYOgLEZGOEs/DggHAW/krcqe6o4Rj1DvtOAQ/z KqL1FFThrORl6RPJSvwKhvp8iYUClSzGzR7A05Him9mWzuNAnJiMUb0SOz21wkJfjcGunHUpGpsGLo kh0JZ32GbPNdEUQd5+Pe3jqNjEGhtUMslNSTMoeBbd4gOuX40342pCZPrl/J8Ks7xieEJ0NhiFzOWB qbfH1h4qHqLI0/d48KzJq9oWzZkC+crx0/77bPI0GCTL7/EUZIJ8jwo7pdQMS9zp+iTVeb+hyfQ/p1 4q8u7vZ1fOm4t27MGFULoSb0k/+zOl67P8+Z0IF0GCTOPqdHUGFUtu7MqxDuXBqoNh1rEvc1tNB94Z V+z96IUZmnbrAmwMSKOPebFjGA/tjeOTbrj7X2omLrl72MRCucteYt87ikxvwI2XvMsO1gDjXylk1F 4hyXvgE+5op4uov0SzQPxYMKHMx1/HbaF0kkSrMrM2jDKGhSruZDwe1Te6vA1/8hgzJRcSeTC4vmS6 oWcglWNo2PiXWm0fjQxOr4XDSAtfQ5i8Iz1eK6jnnWg4us7bSmZ2p6y9C+JILBSQRW4KMvp6CLvibf x3cgwIDZMABSV/mhU69wM2hohHYZoBoCV6AOKw+aa2a1vAZZEoWYSUP0IqYw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build testing of the newly added struct_group() usage missed smaller
architecture width tests for changes to pahole output. Add the missed
__packed annotation with struct_group() usage in a __packed struct.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-mm/202111302102.apaePz2J-lkp@intel.com
Fixes: 5fd32ae0433a ("libertas: Use struct_group() for memcpy() region")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/marvell/libertas/host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/host.h b/drivers/net/wireless/marvell/libertas/host.h
index af96bdba3b2b..ceff4b92e7a1 100644
--- a/drivers/net/wireless/marvell/libertas/host.h
+++ b/drivers/net/wireless/marvell/libertas/host.h
@@ -308,7 +308,7 @@ struct txpd {
 	__le32 tx_packet_location;
 	/* Tx packet length */
 	__le16 tx_packet_length;
-	struct_group(tx_dest_addr,
+	struct_group_attr(tx_dest_addr, __packed,
 		/* First 2 byte of destination MAC address */
 		u8 tx_dest_addr_high[2];
 		/* Last 4 byte of destination MAC address */
-- 
2.30.2

