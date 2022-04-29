Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9980C515930
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381857AbiD2X77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381860AbiD2X75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:59:57 -0400
Received: from mail-il1-x164.google.com (mail-il1-x164.google.com [IPv6:2607:f8b0:4864:20::164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A073DDEF
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 16:56:35 -0700 (PDT)
Received: by mail-il1-x164.google.com with SMTP id z12so4939825ilp.8
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 16:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:content-transfer-encoding;
        bh=rhWp1AKBOyqcG3QjLO4nWaJXvvyqXsoLu/c9Xuqgxf4=;
        b=oYkrbetiJa1DcR+95BGFuKA273SQo7kkJ4KrkLyP+Yk5zyQqHMSKwnPpAsEtvjbYz2
         r8KqrqbLCUKM5sgvhmNWlR4NTgzY17Lqf3ZgO7xPHW/b9iIaecN1W9cqkwapdWDQl0Pz
         NVfQ+JekhBb6bdNCnaI3n04Qx/dtzRoCTKABd8KN9T0DQTm/eet1JHt0VOxhRAAT4n5r
         QzfH51QE5fEhvlmVLV0RT85Qg4JZcCVhV1ZB+cY22B1K1cCIoXRrW01BhfImlNqgXvFF
         yCbweY0aTuiKoOfH+w8NfqA4kvpaCdN4d/s22buHcDATlWF64JPRm4uH6guO3obLkRlE
         0Hdw==
X-Gm-Message-State: AOAM531w0nSou36wP+Z2ydCTEbOgkxDptYBGdx6g6RD/khC4Cf5j/V5o
        GvBErqSsJhwzHkpnNWXC2u/1S6M7O6QRa/lYESdovu7VAJ3Y
X-Google-Smtp-Source: ABdhPJxAayWgz3tZPEUuIHsUOIZfNThDXu/GbVfddf4sHIZaslnH/EGHTdkX1w8JoBMbbmcLLpl59JjhogjM
X-Received: by 2002:a05:6e02:1c45:b0:2cd:95dd:ae1a with SMTP id d5-20020a056e021c4500b002cd95ddae1amr701931ilg.100.1651276595115;
        Fri, 29 Apr 2022 16:56:35 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id a7-20020a056638164700b0032b3a7363f6sm235056jat.20.2022.04.29.16.56.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 16:56:35 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.70.41])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 2D1CA3045064;
        Fri, 29 Apr 2022 16:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1651276594;
        bh=rhWp1AKBOyqcG3QjLO4nWaJXvvyqXsoLu/c9Xuqgxf4=;
        h=From:To:Cc:Subject:Date:From;
        b=o4iJMhSMeeqwukInPgtCBAav5GBwiKBq4YBQxSYpINNXybYE3dNsSH2nBiDWetj5Q
         9huzeLWStt2Yh/qUvoBEvZKegxKs8NzLoFnK0N27kAbq230EJ3QKCoNFR5HL77wCHc
         N7Oy74d3ymAVp8hSsgzY65yTWmK/dVbD3VMLbSpMz1fZPBVjvGN/k909n57ICGqDoq
         ijOYjejoCZ/vTeCkc144dWzX9biyOT4xC2OgnHwwdaxF11EQbjheUibmKZrf85eIyH
         mYflXpTndSTs7Da6KV8zhE8PPMmM3ab+jzTxpRRrfmfIx9a7LcMxKOqfoMIr1MWX0l
         yJsYIxYZXasAg==
Received: from kevmitch by chmeee with local (Exim 4.95)
        (envelope-from <kevmitch@chmeee>)
        id 1nkaTN-0003Sm-TX;
        Fri, 29 Apr 2022 16:56:29 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     kevmitch@arista.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Takuma Ueba <t.ueba11@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] igb: skip phy status check where unavailable
Date:   Fri, 29 Apr 2022 16:55:54 -0700
Message-Id: <20220429235554.13290-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

igb_read_phy_reg() will silently return, leaving phy_data untouched, if
hw->ops.read_reg isn't set. Depending on the uninitialized value of
phy_data, this led to the phy status check either succeeding immediately
or looping continuously for 2 seconds before emitting a noisy err-level
timeout. This message went out to the console even though there was no
actual problem.

Instead, first check if there is read_reg function pointer. If not,
proceed without trying to check the phy status register.

Fixes: b72f3f72005d ("igb: When GbE link up, wait for Remote receiver status condition")
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dc..68be2976f539 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5505,7 +5505,8 @@ static void igb_watchdog_task(struct work_struct *work)
 				break;
 			}
 
-			if (adapter->link_speed != SPEED_1000)
+			if (adapter->link_speed != SPEED_1000 ||
+			    !hw->phy.ops.read_reg)
 				goto no_wait;
 
 			/* wait for Remote receiver status OK */
-- 
2.35.1

