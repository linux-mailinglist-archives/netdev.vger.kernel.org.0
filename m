Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78573B58D2
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 02:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfIRAA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 20:00:27 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36719 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfIRAA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 20:00:26 -0400
Received: by mail-io1-f65.google.com with SMTP id b136so11948018iof.3;
        Tue, 17 Sep 2019 17:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MdJOyIaAxsqTTOGBVhPPqQpQxjpwNJs1HcQFYx3Zzjg=;
        b=jWw9DjXC8X0srUG5iRljpsbgeveN9bipAp40ZauDfDI5ciDtXBTSOl6zx/ERQq/stC
         dxax2laU4flVGPyPiO9aL0aqHg5cHPGP5L5NbFg+Sk6dRinavy+eqiQ+KPaQFwketJUd
         BiJTeeJRxxBXZe4nEdEy52LoTKz9DsQ4rQMSarNvkTp5AxXUvD3lLZ/yOQy9VO30Zlfv
         0IFSl8r5WN29vLItvLteSkSOwiYj00ELuOJpYeJrSXrz/IJfJ9fRnBnUPwITsq4U64VX
         uCGWSrxhxfcCeihZ1PN9BZjDxxdjrS3+O50Zk3TGk53SONW2Bt/dbhGbDfYOCgdqm5TK
         lfAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MdJOyIaAxsqTTOGBVhPPqQpQxjpwNJs1HcQFYx3Zzjg=;
        b=H+bX+TPSGL4NT4yma03T/Ts+JNP4G33fGChqaCAvnaYul5GPR4oyNYGk5DqRZzyCnL
         kHzGk5Eeb8VNUL8YNxcfE3I86kglPPZ7FGIA84vh0Fjx991UHvz7ugH+nUhu4LxWR8jD
         zLLuqpTvMXv3X8Fu/swlYwl5eRRuUIJcxcZCBjWudmHotBD/mNNV/bCOy05ptZFN56Gx
         QamPb1evKUQNLZSwKeJcH/r7CxoUTogRbRGDhCwsCB2Los9682hfFqJyoXcOnrKc6Zrk
         wMwO3WWcT8QVBwdv7wF8SjZx9K2IxSO25tXUbKNC13KkqaKxaNyo+2fXnetha56jrgCY
         4pHQ==
X-Gm-Message-State: APjAAAVquua5KPxgK20n+dVtoEr9wL5xCrqoxKtIUyWTZnFeieZBxSmv
        GGhOY5sI38YdKRtDeT9bBx8=
X-Google-Smtp-Source: APXvYqzmiswsCyeFthfzjufcIIgZlOT29bJ0N0k7YjBWC3ZXRNMFWqSFzUBIIbggvt7Sob9yutzjnA==
X-Received: by 2002:a6b:c409:: with SMTP id y9mr1823814ioa.155.1568764825846;
        Tue, 17 Sep 2019 17:00:25 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id x2sm2815969iob.74.2019.09.17.17.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 17:00:25 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ethernet/intel:  release the local packet buffer
Date:   Tue, 17 Sep 2019 19:00:12 -0500
Message-Id: <20190918000013.32083-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In e100_loopback_test the buffer allocated for the local packet needs to
be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/intel/e100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index a65d5a9ba7db..4de7dca341fc 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2394,6 +2394,7 @@ static int e100_loopback_test(struct nic *nic, enum loopback loopback_mode)
 	e100_hw_reset(nic);
 err_clean_rx:
 	e100_rx_clean_list(nic);
+	dev_kfree_skb(skb);
 	return err;
 }
 
-- 
2.17.1

