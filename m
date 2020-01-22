Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C23145EA2
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgAVWdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:33:33 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:50273 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVWdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:33:32 -0500
Received: by mail-pg1-f202.google.com with SMTP id d129so502799pgc.17
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 14:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Zw96/zGvg4GFyygSCwHpRkXnkRGQ1UzHbDvCzfb/MmQ=;
        b=wOIG+iqi4ktTCbQfMTZz9vcs0pKSubc7xANz0RFD5xQBJccV5IxFBjy2EVoXlE7UPB
         SRIPE3O2IGDmOEtGNH0N7L3BrfD/FTFbwiue7EzTN0B7tqdo0VmZh9d14I5uFALdKOyH
         XuCZfjnflk01d6fqpiCuPMOuhG8mwntXGgqnZcZwhgol0ES1zqwgAy9XEbJWQ57/Cu1w
         ZZosladm4p+se7ESeoSWmpk5wWrYwzWFqVKhmbo/92249s74fUONokKcgF8lCdNqV+YD
         h1EhbT50IoG2BQTrkrkl9+oeDdRHPWWxw9AbkxB9yfxII0FhIjQmbADKyeho9osjZ7Lt
         Uo6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Zw96/zGvg4GFyygSCwHpRkXnkRGQ1UzHbDvCzfb/MmQ=;
        b=g76DiY+hHXwDRvbtPhii0V+D1iyyziUPfNAdTT9R1Ca66RedR7uCvNypHs2U0fGdZQ
         VNgI7H357v0MNixdXRmI5qHrGchM+NALSsP7AetSCOz0bodggnUlvbPHxmUd3cfhClw2
         1uin+GHau5WGlI0a8SflFRogQ7B/h7rBTm2wLvY2fsTdA+XsE1UQJcyjBaRooP+gYhnK
         Pm1hg43EvcCBZMyneMYQhBwJ1oZWmrB+mWrWgdIQjyQtpYpJ0hmhJIjDP+XlUyXSOVog
         zlYSzJeQC1M+QXJr57PaJJ0zvL7e0Zya1Swt6qK4PZbCwrSRcXjCyBUegKCCFpLRGZDq
         RPhg==
X-Gm-Message-State: APjAAAU9gNdk8bBRXyhoyG4PpzWLYOvPZ4M5bZJ4N5npAwgRBbZm34Sl
        v8dxklg3Kx/AhxeBBfVgVlyptOgMc31YvZom+yvHwMutEHUb5QPVmDLeoNo/ftnkCAZQuOWKMoV
        AXwU6gEpB1BTz1evMBzIzTa8lGolAlEeECOiczw8tKJ0rCe96dha0NAcR3QnGTw==
X-Google-Smtp-Source: APXvYqy2yn+COCHs8oc0SAlLT0FjWp3tOkV0d7QM+ZtSTtQjgf7ZhaMUqXdPETKEtq4pz//KilJUUjIqsvE=
X-Received: by 2002:a63:454a:: with SMTP id u10mr564512pgk.248.1579732411517;
 Wed, 22 Jan 2020 14:33:31 -0800 (PST)
Date:   Wed, 22 Jan 2020 14:33:26 -0800
Message-Id: <20200122223326.187954-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH] net-core: remove unnecessary ETHTOOL_GCHANNELS initialization
From:   Luigi Rizzo <lrizzo@google.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ethtool_channels does not need .cmd to be set when calling the
driver's ethtool methods. Just zero-initialize it.

Tested: run ethtool -l and ethtool -L
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 net/ethtool/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 182bffbffa78..92442507a57e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1555,7 +1555,7 @@ static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 static noinline_for_stack int ethtool_get_channels(struct net_device *dev,
 						   void __user *useraddr)
 {
-	struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
+	struct ethtool_channels channels = {};
 
 	if (!dev->ethtool_ops->get_channels)
 		return -EOPNOTSUPP;
@@ -1570,7 +1570,7 @@ static noinline_for_stack int ethtool_get_channels(struct net_device *dev,
 static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 						   void __user *useraddr)
 {
-	struct ethtool_channels channels, curr = { .cmd = ETHTOOL_GCHANNELS };
+	struct ethtool_channels channels, curr = {};
 	u16 from_channel, to_channel;
 	u32 max_rx_in_use = 0;
 	unsigned int i;
-- 
2.25.0.341.g760bfbb309-goog

