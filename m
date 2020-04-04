Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA24419E2A7
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 06:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgDDES6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 00:18:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43806 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgDDES5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 00:18:57 -0400
Received: by mail-pl1-f193.google.com with SMTP id v23so3608812ply.10;
        Fri, 03 Apr 2020 21:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RYBw0jscJ7RIPg1FtwMYWRF/5a1itsd2oqmX1RSvlkU=;
        b=nIC1WW3JnpY0kXulmgHBCMm8dVI0J6+XWuJbz+aJqixjx5QuRENSI6yVJQx63wm/yI
         0XEbyxutJC299usNzOygubVF/woGkAHuaGvlx0RXGL1X9OEKkiBhpS+0ZZZLfKMBzECQ
         OzfzKsYAZftzK3wToJG6aNQ9pVJf8eyJ5I1n/0dlvGThJTNJmNVqKyeNeFVKeR32vN4T
         mSSQOQ/ebpBP+N2hgePfvZSimuiKPiMBK0b0mdoYfVZ99JGcSZnKc9gjLs1BCrtVps9c
         06VNRupC4bWYTkYf+sAqF4Eny4L3KxCSu3BQ74hcPzpVJ4YyQX00Zo8vawjhTl9b+GvS
         HaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RYBw0jscJ7RIPg1FtwMYWRF/5a1itsd2oqmX1RSvlkU=;
        b=WVuhOpbObvc/dlh665vt5TR08UCYusWpzHI0JHiFQEpguevVYFZ8uwSGCNTjzin92g
         PiOHvb++EpD6u+9FjytC6bNfZHH26Wn+XSnlqelPDSn0QEdipSl3XR2mPlc/i/HbMtuy
         NpR86fX98Qz4jgn/dlXjm/N95rPNAgvsuMFSeSyQm/e0BIrdrnDdyUOMkkGYD7dQppId
         XD3aRhGxGGr0kPI+4U6mSZKaXRYLJNvq20bXgey/+LfBm0IJbbmtvmY8yaQhnPgsnroW
         cOyirC8poB7HJjmttWlNGuF7jMJm8of93zMLWBPa+eBr9CEg/Zm0NcNxaZ3ywT+E5jmb
         NlVQ==
X-Gm-Message-State: AGi0PuaxumXFTjhi7qno6h1sepsGdkH8UATJnRbuetLpD10cw+v2X6Lm
        nL2VZlWO9F+KPfko3A8LJp4=
X-Google-Smtp-Source: APiQypKgRloQwvyXKmr5XWUhphK+qHlbjk1WaNBD1LpCqacWpKr9wET/Dl94AlA/cwLBugzUnLJSmQ==
X-Received: by 2002:a17:902:aa4c:: with SMTP id c12mr11424525plr.168.1585973936936;
        Fri, 03 Apr 2020 21:18:56 -0700 (PDT)
Received: from localhost (n112120135125.netvigator.com. [112.120.135.125])
        by smtp.gmail.com with ESMTPSA id q6sm6786902pja.34.2020.04.03.21.18.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Apr 2020 21:18:56 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH 0/5] ath9k: bug fixes
Date:   Sat,  4 Apr 2020 12:18:33 +0800
Message-Id: <20200404041838.10426-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some bugs in ath9k reported and tested by syzbot.
https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.com
https://lore.kernel.org/linux-usb/0000000000003d7c1505a2168418@google.com
https://lore.kernel.org/linux-usb/0000000000006ac55b05a1c05d72@google.com
https://lore.kernel.org/linux-usb/0000000000000002fc05a1d61a68@google.com
https://lore.kernel.org/linux-usb/000000000000590f6b05a1c05d15@google.com

Qiujun Huang (5):
  ath9k: Fix use-after-free Read in htc_connect_service
  ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
  ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
  ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
  ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

 drivers/net/wireless/ath/ath9k/hif_usb.c      | 58 ++++++++++++++-----
 drivers/net/wireless/ath/ath9k/hif_usb.h      |  6 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 10 +++-
 drivers/net/wireless/ath/ath9k/htc_hst.c      |  6 +-
 drivers/net/wireless/ath/ath9k/wmi.c          |  6 +-
 drivers/net/wireless/ath/ath9k/wmi.h          |  3 +-
 6 files changed, 67 insertions(+), 22 deletions(-)

-- 
2.17.1

