Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375E71BB4B7
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgD1DbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgD1DbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 23:31:03 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA78C03C1A9;
        Mon, 27 Apr 2020 20:31:03 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g19so30226608otk.5;
        Mon, 27 Apr 2020 20:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jm8vfJ9EYyWFOVTVK1su6QOP18i2GwWwk6iXxu1Gwqg=;
        b=tIUU17d61/yZf3H3f7qHle7H6xFFYcz/TYc3xCwWv+zz8GQVMUYUJWtQbqOEBaXVCn
         SHWgaqnH7BSR/SgNiZc04fix5SZOpRu+36gqtZKds2WYSDllT9DtLDGZ6VNifdw2oNL8
         NJZOZWb6nm14vdzNMbLVzOnQRwvO3w4jdky7VqdpEZAVfKqTrKsuD1qq910GBhgbsTQS
         k0XEDmplGZKZWut2od4qJoG64IqiQYy1OkZ2IaZ9YLH3stUnyenxmJS64wtfGNGZJ9j/
         ZAvkELeBXiPY9GCrLI7jebBu/+ckb31IV12xOg/yjj+OHKpX4U6Xse+H5a0WJl7lV89T
         ZUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jm8vfJ9EYyWFOVTVK1su6QOP18i2GwWwk6iXxu1Gwqg=;
        b=XbbHw/sk6rxTJIWIONYTzrenuFaJ99KU6bwbiO2ZeouB//QoepT22WDweGmZTNisAy
         g1FoGuilqS16l7uTeottu82DKMMWx06THmh5x34SmsWwiFrUym6dDWx7h+XL0A4vNwfL
         W9juxoTwJQRlX8suCkVBqGUPyhrJOQTjEok40RGGmlpMTX44QRF9+vKK5ICMtr8eG1iD
         BmOpbWWBvJIHunAopIjhOjDwe/+h/DkL0T3uEXxd+Q4duX3ObA0kcynYinLyUhBtSrmL
         49yGpJq5B5oArFTNtQ/q6LmAPAMMwqKok8mlfQn1aY2t+GUV8TzVv/WzuSR/KsVdQUV8
         AxPg==
X-Gm-Message-State: AGi0PuZhnU3U75gmRTfumAjfF/RpXYHZhRq/TzKJKWAK73FZJpj6ihtW
        kw8uCDzwTX4Am4bFY4eC/jQ=
X-Google-Smtp-Source: APiQypL+AkA11khZIM6HDPAXBFYXba69RckVwzoOGnXcFnSn58KdrLcc0xLwleE4RoRl5yN7hbSKfQ==
X-Received: by 2002:a05:6830:11c6:: with SMTP id v6mr20618099otq.166.1588044662222;
        Mon, 27 Apr 2020 20:31:02 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id q8sm1959615oij.36.2020.04.27.20.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 20:31:01 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] hv_netvsc: Fix netvsc_start_xmit's return type
Date:   Mon, 27 Apr 2020 20:30:43 -0700
Message-Id: <20200428033042.44561-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netvsc_start_xmit is used as a callback function for the ndo_start_xmit
function pointer. ndo_start_xmit's return type is netdev_tx_t but
netvsc_start_xmit's return type is int.

This causes a failure with Control Flow Integrity (CFI), which requires
function pointer prototypes and callback function definitions to match
exactly. When CFI is in enforcing, the kernel panics. When booting a
CFI kernel with WSL 2, the VM is immediately terminated because of this:

$ wsl.exe -d ubuntu
The Windows Subsystem for Linux instance has terminated.

Avoid this by using the right return type for netvsc_start_xmit.

Fixes: fceaf24a943d8 ("Staging: hv: add the Hyper-V virtual network driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1009
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Do note that netvsc_xmit still returns int because netvsc_xmit has a
potential return from netvsc_vf_xmit, which does not return netdev_tx_t
because of the call to dev_queue_xmit.

I am not sure if that is an oversight that was introduced by
commit 0c195567a8f6e ("netvsc: transparent VF management") or if
everything works properly as it is now.

My patch is purely concerned with making the definition match the
prototype so it should be NFC aside from avoiding the CFI panic.

 drivers/net/hyperv/netvsc_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index d8e86bdbfba1e..ebcfbae056900 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -707,7 +707,8 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 	goto drop;
 }
 
-static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netvsc_start_xmit(struct sk_buff *skb,
+				     struct net_device *ndev)
 {
 	return netvsc_xmit(skb, ndev, false);
 }

base-commit: 51184ae37e0518fd90cb437a2fbc953ae558cd0d
-- 
2.26.2

