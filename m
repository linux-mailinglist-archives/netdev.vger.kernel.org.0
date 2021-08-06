Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9403E2251
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 06:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242087AbhHFEFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 00:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhHFEFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 00:05:54 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90634C061798;
        Thu,  5 Aug 2021 21:05:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a8so14143445pjk.4;
        Thu, 05 Aug 2021 21:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xTUSIk0PEm8dgw5EgzCWiooT9Ptt7rnMynSDDHrUL4=;
        b=P9QyDwPfaCBusnlXTuu8jpSN8khInXlLCQ/da6NCgEyS3nN+rpE75pUJmpr4/XwEMv
         aErgvi+ExObcztUeWzsK4JDkhIoDldjw8/RLiiNFPwlFk3XrV4IYne/UmWpGRRgu74Q9
         xyUYCgY39kEhZep5et8zywvCTZ4Nh3hyVEkppRQuY/igndPb30C30qHWBuZZSSonNlm2
         6QAF397lUIAqDlg9Di+bOhvCOtOcOJhcMShMwto4tOykNPjdNAktEd09F+0wbgUOKMGM
         5T7DCvODfVxCfTZavL+NbxOwDa9EUIiDY4QJBLj9n3+66jvOmYyqrFAOuFjh19QhF29Y
         x1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xTUSIk0PEm8dgw5EgzCWiooT9Ptt7rnMynSDDHrUL4=;
        b=FkJd+jD9rs43K67VZP7B23HS1g7vF2dt6sfZvQB4iM+FwzYxA7N6lY1bugxUVsUWGj
         TrHOZRuPirUHNVTwo58MihIDuQXnnc/3xICv/ZAMl2kY2we/0UC4YjxCYDu3EyDmivft
         YqkbDWosqc1cPWwnu7+dZXJA7+osRwct7tTRFAwBJkma++L5LCNzeVvzEiWqxDm+fLB8
         ajsh346hgvOWu7gQuo8udR3lP00HcG39sUlJ76J7zHMJhlvzEUh+H1S1yClcDVjwzw0I
         Sf+QDibtINqS9PsXq8ra8DqzbxbP7vOzIZrsUxnyDzyYXXQXhcfY1/XgnBToeh1Wk+Fx
         nrMQ==
X-Gm-Message-State: AOAM533NPBPz2wKuF6/aAs8x+35zL8K50n2j6EPfo/MYF4CHoqrvf3GU
        DY8GArgHoAb5ixPxjLYtBCs=
X-Google-Smtp-Source: ABdhPJy2+Gv/lUqLi0cu47cWtSKJ+epXlw5mBn6fJYrYzFKdgAssRpEufHv2GHAmie5Vs+J8jK4bLg==
X-Received: by 2002:a63:5619:: with SMTP id k25mr286282pgb.92.1628222738170;
        Thu, 05 Aug 2021 21:05:38 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id 186sm8597505pfg.11.2021.08.05.21.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 21:05:37 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: mt7530: add the missing RxUnicast MIB counter
Date:   Fri,  6 Aug 2021 12:05:27 +0800
Message-Id: <20210806040528.735606-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing RxUnicast counter.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 385e169080d9..9d7c52172af5 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -47,6 +47,7 @@ static const struct mt7530_mib_desc mt7530_mib[] = {
 	MIB_DESC(2, 0x48, "TxBytes"),
 	MIB_DESC(1, 0x60, "RxDrop"),
 	MIB_DESC(1, 0x64, "RxFiltering"),
+	MIB_DESC(1, 0x68, "RxUnicast"),
 	MIB_DESC(1, 0x6c, "RxMulticast"),
 	MIB_DESC(1, 0x70, "RxBroadcast"),
 	MIB_DESC(1, 0x74, "RxAlignErr"),
-- 
2.25.1

