Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078877223B
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfGWWUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:20:07 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37705 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfGWWUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:20:06 -0400
Received: by mail-io1-f68.google.com with SMTP id q22so85260524iog.4;
        Tue, 23 Jul 2019 15:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pl9nO+hunkGocGh4P+3+7RACb7n3AOCHKdRk3PRyj78=;
        b=jClr9tGO0M2uPdTqgL+wilDjNYPCY1lHULxJyU4k5vGRMTiCplHDR9talFGARjm7fM
         WaQzedbOLIChWY2xd0aavGY1YIl0rc4yFY1QjuAdhFpLnHbnquNpQhnyWdCtpD/yh0wj
         mic0mlosfXm6fh2jHggFADTo3xWjod0o0w9F7sh+It2QAgSNWfwcfcRKhDg4DFqN94+h
         ji0X4ENlzZZuWoW70qUl9zRrs75DGINQ0bLoXjHq010Tx1Ahq71E4+ryf93RiyEK95rp
         YvkGkm2a3vss0Nk42AMTYFrs7VsYkuxBS7APMVVSARpeApcEDLQ/NmTZMcXqTLfb6OxH
         OCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pl9nO+hunkGocGh4P+3+7RACb7n3AOCHKdRk3PRyj78=;
        b=cZSQ1ymJOy2X/xkGh0cvvKuov+L6j5K/GMoQjbV8MCDhB4kHd6sxqexUaU8uK+mmVe
         XlenphHDTpDqh5pMWhdDwsTWWoywYlIDjTmaR1HRt7y/mreLelPNlGTqGjvU7ONFR7eJ
         Rl8cK46GpH5vCUGZ7lAfXH526Im3U9R77rUgvwkrrTDFAn3k3vYk7Je7x5aD6LnC+P7n
         lN3vW18UQflGGrVR/HMZfGF+0Za/5On2FfbckbB7KmqTYMLRskuiYn9Y4jnXG04/ucJl
         BmolN/r+K72FLAB6fNVsBX71w58neOfQ0LSR2vS3x60taSEAoHikqcYdJ3b6sW/GgJ9w
         +jRw==
X-Gm-Message-State: APjAAAUqo0mM0+S1z9lxxmMgQFoDviDNkl1XNMAAu0IdAFbMcmtvK5Xv
        xubjzGcDZnkaNZsiWUZE7ow=
X-Google-Smtp-Source: APXvYqzWffs9myy9EKo6r23AJN8vEydCexjw2y+Jif/lnPMEBM5O8yaoI59b8eVQgRLAxQMFdQQJNQ==
X-Received: by 2002:a5e:c241:: with SMTP id w1mr68853307iop.58.1563920405893;
        Tue, 23 Jul 2019 15:20:05 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id x22sm33378952iob.84.2019.07.23.15.20.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:20:05 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76_init_sband_2g: null check the allocation
Date:   Tue, 23 Jul 2019 17:19:54 -0500
Message-Id: <20190723221954.9233-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
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

