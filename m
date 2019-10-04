Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C383CCB49E
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 08:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbfJDGy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 02:54:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43459 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388362AbfJDGy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 02:54:56 -0400
Received: by mail-pg1-f196.google.com with SMTP id v27so3186072pgk.10
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 23:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WnrMI7Ok1MNg8xlXWuS34jn9100qvN5R6GtazYrUVB0=;
        b=dus/D1AQrCINQwT2rDgSzxJArLHMMlq+CkJrkX7aVpHddXyK1V2u4Z0XGzDLTpHIV8
         gZmlmLpNFCSbuR/owqVyk4ySYvkumwHu6nIVITOvalusuKMIuQMwYyB+Tcyr6/k+pdAu
         /phkmS5f81VB+sVM3H0gF2Yg/sgrMeLCELi1CIfH5w00SHlDrZ0VM0c0a03Cl5od+mip
         pEc1Uka8pc7pc34P6+//cSNUlWkfJss+yIoZmTElwOE3UZafTtpuBfMloKOvXbIjKOHG
         Nll9LK3ZMYEpa3tNpZPxJhUbNOTB1QixKpi2MI+nMiCBYSHzZkRwIrQnlqd0lQHKT2BO
         aUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WnrMI7Ok1MNg8xlXWuS34jn9100qvN5R6GtazYrUVB0=;
        b=PPU/lAmgOj0KOl37cBHzI1n+BJ0n2MuSJi+fCVD4gZpcRbA5JxCtK5hY/NImUEx98L
         oN43+UZdn0EZZ5umA+gVgN7Z+05CQZR18eQDYGzyTATUIHo8qkuzyIvE09MFGt7p2TsE
         bfS6aG1v33V6eBNUPyZ38GNy8XciQQn+neb9w63ee0XuEjS8oXRc2T8alHEtp82i6hR/
         kum7rGxUmEsm8Mbt6wLf3w3VWWuV/d8Wvlhfp/Unq95pUQoBZramb26fmPQKkMG8tajq
         M3E7z2dTI/1RM8odFoBudFrCJOKhp2n5LoQw7nB8gGxlyt6KwDqu7xxu0uOwpPFNvZIW
         UrcQ==
X-Gm-Message-State: APjAAAX81u+Gv6JnE2moGFGlbe7/xEm+tJ46pv4LlKj/Jm8zW5C35WeY
        IMZngvTZkDbJm03xDLMXSjQ=
X-Google-Smtp-Source: APXvYqxjsddIfU+pGkqhQk4WoiJob9/rK1J5FRh0YtXbbJeZ+AOEVcOiSN6DWv7nl36XOj4RC185/Q==
X-Received: by 2002:a62:d445:: with SMTP id u5mr15640803pfl.92.1570172095888;
        Thu, 03 Oct 2019 23:54:55 -0700 (PDT)
Received: from ip.hsd1.ca.comcast.net ([2601:646:8100:a2f0:246f:b102:f969:6b0c])
        by smtp.googlemail.com with ESMTPSA id b9sm4273056pfo.105.2019.10.03.23.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 23:54:55 -0700 (PDT)
From:   Igor Pylypiv <igor.pylypiv@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Igor Pylypiv <igor.pylypiv@gmail.com>
Subject: [PATCH] ixgbe: Remove duplicate clear_bit() call
Date:   Thu,  3 Oct 2019 23:53:57 -0700
Message-Id: <20191004065357.19138-1-igor.pylypiv@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__IXGBE_RX_BUILD_SKB_ENABLED bit is already cleared.

Signed-off-by: Igor Pylypiv <igor.pylypiv@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1ce2397306b9..91b3780ddb04 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4310,7 +4310,6 @@ static void ixgbe_set_rx_buffer_len(struct ixgbe_adapter *adapter)
 		if (test_bit(__IXGBE_RX_FCOE, &rx_ring->state))
 			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
 
-		clear_bit(__IXGBE_RX_BUILD_SKB_ENABLED, &rx_ring->state);
 		if (adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
 			continue;
 
-- 
2.20.1

