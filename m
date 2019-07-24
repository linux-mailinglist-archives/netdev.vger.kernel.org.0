Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A777316D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfGXOR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:17:56 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45756 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfGXORz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 10:17:55 -0400
Received: by mail-io1-f68.google.com with SMTP id g20so89896576ioc.12;
        Wed, 24 Jul 2019 07:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pl9nO+hunkGocGh4P+3+7RACb7n3AOCHKdRk3PRyj78=;
        b=d+XNfrK6cC2Wn6gvabfhUWgJIeVpcGO/Uu6+pC4RCQJKyw8+NBSwGR+cTC1MJoLo9U
         4Bvz3/JgJ93WJZHfxWtpb2r4Os/qZFoXxSYw3p6B+r0VnCJ5SjW7ijFZh9F9rIxVWChe
         1YId1MFsU/1UthPqnat5tRtc6PS+q3PhlR2GoZC8hu/oMgMA8+5rwLD9B9YLZHqe1zrk
         KEZfQasCdQdlIbaNNOXHSkTc3gPNsVq5Kc1MDosgLPKRBrKNBcHAEUwZIHHh/7gkQNg1
         Ap20T3173w8lr1Au0OGiB7k0bVRE+A91zvqCi0Pm3+tsgrshgEtOcxHtklEsIWDwxsaV
         BSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pl9nO+hunkGocGh4P+3+7RACb7n3AOCHKdRk3PRyj78=;
        b=G800u9F601nF9E/sFWTFyBNQPRqPKJR1kOkB2/a39ntPq7KiAOWg+Hxz5ylH03dyEB
         BNoT9kh1SH7AVyZnWZi1jSICIurkbk1GaqjcXUzvTDoiSmsz1Pjkyq+uA5agCFTpiVga
         VRlgtXzrXhou7y73IUSkd54rvxuNGjaC049PH4/BgWlDMRls6BS7uwV5M15YiBsgiosG
         curpwgTrE18Ip4gsusMZnSZeFlYOG+ACcnMJf5O8TKYumepAEOxrpqXbNIM/bIjkQjWr
         wpOu10ctBzncgFe/9VntB7iEUMWCGWu1tGshqcSteibdMzDnHcs2y54lyq5HDcYRdVmo
         8Z2A==
X-Gm-Message-State: APjAAAU/THL7FxR7XxUluyxNv8Fm5W1hwxydvl74sBoJQSDCBY5T3aMC
        Gyxq8hi6EFlvapfEWp+ixLg=
X-Google-Smtp-Source: APXvYqz9OF+x2WTGlu/HH4W5NyZIEwxfrCRlfhLTUcbrr1zQuVHHj1E9ruPCRHw4aSTh73+cpex+cg==
X-Received: by 2002:a02:6016:: with SMTP id i22mr60556184jac.56.1563977874678;
        Wed, 24 Jul 2019 07:17:54 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id p25sm37377171iol.48.2019.07.24.07.17.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 07:17:53 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     kvalo@codeaurora.org
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt7601u: null check the allocation
Date:   Wed, 24 Jul 2019 09:17:36 -0500
Message-Id: <20190724141736.29994-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <87d0i00z4t.fsf@kamboji.qca.qualcomm.com>
References: <87d0i00z4t.fsf@kamboji.qca.qualcomm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_kzalloc may fail and return NULL. So the null check is needed.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/mediatek/mt7601u/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 9bfac9f1d47f..cada48800928 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -557,6 +557,9 @@ mt76_init_sband_2g(struct mt7601u_dev *dev)
 {
 	dev->sband_2g = devm_kzalloc(dev->dev, sizeof(*dev->sband_2g),
 				     GFP_KERNEL);
+	if (!dev->sband_2g)
+		return -ENOMEM;
+
 	dev->hw->wiphy->bands[NL80211_BAND_2GHZ] = dev->sband_2g;
 
 	WARN_ON(dev->ee->reg.start - 1 + dev->ee->reg.num >
-- 
2.17.1

