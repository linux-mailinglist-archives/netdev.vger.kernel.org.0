Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707001C1B9F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgEAR0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728933AbgEAR0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:26:36 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD12C08E859
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 10:26:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x18so12290663wrq.2
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 10:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a6wPzzaAib5DH3Zs/s/voSmXDBvZjx2Piu7nRV2HDvc=;
        b=L+/v5lV7QmhUfuqxAAknTP2A5qs4FP67SUJqNRcwp4cHbubxFw39xHzbTyYcbdyDfv
         i7EWFdBNwcMPI0l3hyONwXScnTUyahou6Mqp/4V0/s5V3aE9BvhHIirWLwFIxDxGhyRD
         bhgPvJcrE4SX6tBTe2fFK1yPROWvtTHpcT9dTO7M00/yjAO9L0DbX2nr23dFz4LecxI4
         VygXEnsev917ePpC+Jj+auecYAZXE3wFTq+WnjXJ+i/+fRnke7j2U9A9TrNB3mtYcECM
         ohXTCEWLPRb14BVvDX1JV80APJj4+67BEzRYq3ILw9qZoJ+jCDUVlejQUaYPbFLwPLQG
         yeIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a6wPzzaAib5DH3Zs/s/voSmXDBvZjx2Piu7nRV2HDvc=;
        b=Nd1P6rdpKLYaPLM1QVPOVrSERV6SBqzdaYQVZjTi3og3vgHkhQJfD/wTQ/Cy61ERtM
         aAxsB2alUvqO0ytWyJlPb0P4SsXdUYIdBOyl9nc00RYSENzXagL9f7/7egOYPjniFJ7a
         IEQu+dQV6tMHAA6vQE1jZ9Cdho63vd3sIJd3OuaOKvt5rrxjseZrPwT2Ni4OP4RDehDM
         0mRvVu44FunCl/MAdgTocx8DfVEwZg7HfbVzXqH4VcbsrKi/1zQbOdGjUzvUXjQ7kUQG
         xfOMMyHY2oL6R60xiE0xKzdEw6UgMu8T5MZkbuGRR07eNQwmYl778odRQjpIHG/FWhPG
         hImA==
X-Gm-Message-State: AGi0PuZlq6QMA2r+5ojRuWQZ5X4W5MFx3hRPd2NQSQuv3v2gGSeWgqDd
        aYTlNFfGtrru8i71NMfk3rL40dog
X-Google-Smtp-Source: APiQypL0C283hAECn73LJRcAnW2vuiRDkSbHlsWArVCZtNHaRKORucl+s12jc1EaZWuLDr4wCmEihA==
X-Received: by 2002:a05:6000:4:: with SMTP id h4mr5395201wrx.386.1588353994474;
        Fri, 01 May 2020 10:26:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:54e4:3086:385e:b03b? (p200300EA8F06EE0054E43086385EB03B.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:54e4:3086:385e:b03b])
        by smtp.googlemail.com with ESMTPSA id e21sm5638683wrc.1.2020.05.01.10.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 10:26:34 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: remove "out of memory" error message from
 rtl_request_firmware
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Message-ID: <b26a948c-464d-b154-5512-3d8df314cdda@gmail.com>
Date:   Fri, 1 May 2020 19:24:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When preparing an unrelated change, checkpatch complained about this
redundant out-of-memory message. Therefore remove it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1c2ea7506..768721d56 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2507,10 +2507,8 @@ static void rtl_request_firmware(struct rtl8169_private *tp)
 		return;
 
 	rtl_fw = kzalloc(sizeof(*rtl_fw), GFP_KERNEL);
-	if (!rtl_fw) {
-		netif_warn(tp, ifup, tp->dev, "Unable to load firmware, out of memory\n");
+	if (!rtl_fw)
 		return;
-	}
 
 	rtl_fw->phy_write = rtl_writephy;
 	rtl_fw->phy_read = rtl_readphy;
-- 
2.26.2


