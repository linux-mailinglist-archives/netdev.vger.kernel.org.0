Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EF148CF76
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbiALXzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiALXzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 18:55:41 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC22EC061748;
        Wed, 12 Jan 2022 15:55:35 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id k30so7049237wrd.9;
        Wed, 12 Jan 2022 15:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZrJnoV8ByVp01mrwYzfs3BpkSmN3S2DUUHlhgKf3S44=;
        b=VVT0NC1971pm7KJrYLjrND6wXdnBy4Fkz/NuATd6EdPB7ByJKyrJ0afI5SGvvRXz2X
         50ZqJy4nI9D9gJBtTUBrkaRKLvs9lZsw5k29MfgIoIu5wR7NJXXhceHyij6sn3KnQo/v
         101KK4ILIIy9LNQeBHo7LoBE3TeEu/FT99q1PtGFVefk/+mPyV1iHV6Swr0omhaMw/Wm
         cT2vOaYP996ZtAtk9NTEToEVNxMldvHLfoatdCFTpGTecvpuAY03QbV2xg5TnDohKGub
         EdYZ6tp6FS33cpLf7vvHzAxFOW6TTtRuqqce6e3+xxDWJJ5G8V5ZzlaPKylbuHWMkf/I
         N0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZrJnoV8ByVp01mrwYzfs3BpkSmN3S2DUUHlhgKf3S44=;
        b=ba6Bq9ZGYC/qsGyFKlrYqfdgSinsiH3NYCt7Di8lcfhaV+dqAmXks1Qetesi+gN6z2
         ittuyqGVXtIjrVncHWUOokQPtjlgA1hfv1DpqkJz0oav6q4O4WIdeb2C8aFfXE7AysQY
         G7xCSfuZOPeF1LGrdHkLSfRnQ39/6XG9GfVOiIMp386sJWWMAgI85aONBKhG+r2FuOT1
         C4k50mRiSJp+hRrMr25mHTFjFPmcykjDH45SPhzabB8B1lDVHyKll6uFaaypFK1nm2f7
         oL+0EFfFO4/A/ACX/0B4nQH0REM93jGPy0D+DYiM7Qa2PAcjhgSzoAcRdEsL8QtsAyxl
         w2Vw==
X-Gm-Message-State: AOAM5301V+Xn0pvbSki90j5Mb4iR88497o3VGbRN8HHTVosEAP5S+9q+
        FkTHm3KEDDGpeU/3vVQc+Fg=
X-Google-Smtp-Source: ABdhPJy8XX5/dFYxJ5mkFUXKlNg3U36B1VmjIA6pRqoybdXmuNWLWzgHhjNNEEC94ODARsOq6v3/Hg==
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr1711033wrg.31.1642031734649;
        Wed, 12 Jan 2022 15:55:34 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id o8sm1337903wry.20.2022.01.12.15.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 15:55:34 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] atm: iphase: remove redundant pointer skb
Date:   Wed, 12 Jan 2022 23:55:33 +0000
Message-Id: <20220112235533.1281944-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pointer skb is redundant, it is assigned a value that is never
read and hence can be removed. Cleans up clang scan warning:

drivers/atm/iphase.c:205:18: warning: Although the value stored
to 'skb' is used in the enclosing expression, the value is never
actually read from 'skb' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/atm/iphase.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index bc8e8d9f176b..3e726ee91fdc 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -178,7 +178,6 @@ static void ia_hack_tcq(IADEV *dev) {
 
 static u16 get_desc (IADEV *dev, struct ia_vcc *iavcc) {
   u_short 		desc_num, i;
-  struct sk_buff        *skb;
   struct ia_vcc         *iavcc_r = NULL; 
   unsigned long delta;
   static unsigned long timer = 0;
@@ -202,8 +201,7 @@ static u16 get_desc (IADEV *dev, struct ia_vcc *iavcc) {
            else 
               dev->ffL.tcq_rd -= 2;
            *(u_short *)(dev->seg_ram + dev->ffL.tcq_rd) = i+1;
-           if (!(skb = dev->desc_tbl[i].txskb) || 
-                          !(iavcc_r = dev->desc_tbl[i].iavcc))
+           if (!dev->desc_tbl[i].txskb || !(iavcc_r = dev->desc_tbl[i].iavcc))
               printk("Fatal err, desc table vcc or skb is NULL\n");
            else 
               iavcc_r->vc_desc_cnt--;
-- 
2.33.1

