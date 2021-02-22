Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23370320FEB
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 05:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBVEA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 23:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBVEA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 23:00:56 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D562C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:00:16 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id r19so3515043otk.2
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZXGajvIMM0wquwcf46YTi+rJ0g3JMeDQVGsO6rxPwpE=;
        b=EgJjrq79hanZPNMKHktSzIbh4PCFK77yLaed4Gf0MtWhZbmC73B/SPlh8YbpsMUqbX
         cA0aOYKtJZRjwzo5nyCTN4ucFs/mhKrHtF+uSduzW7xF4b+HK55+ySrV+grYEDEYP/WY
         X6/R8M29/J5QCV26+/dMnfbETlrgwnsyEG1Z3KxMF6PU76Bzip4qsA/EJRJHL92JSf+I
         NjwkaBCPVQMwDscqMwGgIiyxj0SNI2A6gEOgcirp3O26r3TxRA9zIOVJkRokpF3IMqmw
         SFWtMONSQB6tDv8cm0YzQ6Zb7a3oIluGkMKTv986FCmFYGaPyrgYSIIzX4CzcpCHsKAW
         VL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZXGajvIMM0wquwcf46YTi+rJ0g3JMeDQVGsO6rxPwpE=;
        b=odc4TsxOhZrA0POLx25cBIzl9vV/ecq9gtkUHcFzf6RjM915bTlItT+Mcwt7aflUZg
         uRm5E6TOjC+TDwXLYem14vePuZvPNB/QD/3406/cZXVyf95nNoFwC3ExQENywalvikLN
         C51h2yz6PCs937bH2o9yrWre8qOPyfUtJqos9fLH14Ug7R3WLSSc+PdMDlViuZ1SmBY+
         3Ac5Xbdk7sF1qhaM8aXKdfBoPtHqm6TpDvqCSXXYt8KWUeFH2TfIGJ25d9LbTJr8ZhHo
         VwUwbsToDx7Gud4hbHzySdHZdCUsmhCguawFBkqQOABPy+q27rn3/whPrSr2sM4sRfia
         O/BA==
X-Gm-Message-State: AOAM533iX28GqwX4hm3GRkGIRDkshlTBuyCpAc/roO3q18zuM1HPfCWB
        ikSf1TnqfVmB0cCUqv21mSJbYNGHv87fyqJf
X-Google-Smtp-Source: ABdhPJx95UN0Q+v/0sphu/IshsnJJ4lPWQfHcWZtvCrBYNASuKkmN2Zn97qRU81FifcUxt5tyVERAg==
X-Received: by 2002:a05:6830:150c:: with SMTP id k12mr416529otp.104.1613966414811;
        Sun, 21 Feb 2021 20:00:14 -0800 (PST)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id t2sm3518066otj.47.2021.02.21.20.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 20:00:14 -0800 (PST)
From:   Tom Seewald <tseewald@gmail.com>
To:     netdev@vger.kernel.org
Cc:     tseewald@gmail.com, intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Auke Kok <auke-jan.h.kok@intel.com>,
        Jeff Garzik <jeff@garzik.org>
Subject: [PATCH net 1/2] e1000e: Fix duplicate include guard
Date:   Sun, 21 Feb 2021 22:00:04 -0600
Message-Id: <20210222040005.20126-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The include guard "_E1000_HW_H_" is used by header files in three
different drivers (e1000/e1000_hw.h, e1000e/hw.h, and igb/e1000_hw.h).
Using the same include guard macro in more than one header file may
cause unexpected behavior from the compiler. Fix the duplicate include
guard in the e1000e driver by renaming it.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/hw.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 69a2329ea463..db79c4e6413e 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 1999 - 2018 Intel Corporation. */
 
-#ifndef _E1000_HW_H_
-#define _E1000_HW_H_
+#ifndef _E1000E_HW_H_
+#define _E1000E_HW_H_
 
 #include "regs.h"
 #include "defines.h"
@@ -714,4 +714,4 @@ struct e1000_hw {
 #include "80003es2lan.h"
 #include "ich8lan.h"
 
-#endif
+#endif /* _E1000E_HW_H_ */
-- 
2.20.1

