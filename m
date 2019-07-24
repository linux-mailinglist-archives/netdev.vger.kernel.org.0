Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBB772D66
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfGXL0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:26:02 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:35732 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGXL0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:26:02 -0400
Received: by mail-pg1-f180.google.com with SMTP id s1so14777739pgr.2;
        Wed, 24 Jul 2019 04:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UBvzwYXKLD0KHI1zY1uVWe8TykAO+CwaOeNfqT2YYZc=;
        b=kFJc2XNyi6Z1sFBtVh7MVdzJ9zPWXszdTeMH6mI+jCoag4U6vdbrOo1gJQMLFpB4uO
         sbLrNIdBejUeH6GDxmd1I70ZdvryrmrV5D+8jqx2pP2RMarhE8ucQ4m/fQEz3nK29RXW
         wa3IqqjiLRIzKJgZD0vUd4PlDfxUJBaMyiVMhQhDLT2zSq68RmYpDvdTX8NhDX8UBxhO
         Uqu1g+M4rE/f84Qmg/c1/OvnKc7dRJKOQNf5lFh2w/jPqPLVZBFBXn7aUA5Cq+cJqSkQ
         5VKD/dcTQPQxgpPuUrLun3C8KCl001FKBpOKiUsaz2SfDAfqB8++NfL4yGvwfGICBh/V
         KkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UBvzwYXKLD0KHI1zY1uVWe8TykAO+CwaOeNfqT2YYZc=;
        b=dL6OOiNE2QDXzdbtfx4rQvVa3B7rhEgbMMhR1b84wnuoL596Sk5heTGhozj1s+FIub
         Zv91HLvzEo8M78RG4GKWqZS5oEHMNa8WqUiITUG27KGG6EltSjjW9s1BJtpUVBYX6PjB
         N4aNmxUs7PaxO8i6GbW1Qf2SqhjtFaFuMAL5WPNTVWKmXgeRmdxYpT4Edq7ud83EQlSw
         XzDxF26N/L8k1pbUgBkLc80YqW5RkaNClLLLXSv3CKnz2g4Otza2RrXNg7CXFPau5S1n
         ZUNckElqvtczXjazG7L+rsx+nfJPYmMr0T3n0MLvzUYZEBfhvVEGi78zyE9Jmkht1M3p
         vnVg==
X-Gm-Message-State: APjAAAVLL1YHiFxjy2a70JlkgS5KuRHtcRlw8MLl2+WdHdu42jsbnKdS
        U+UTivyQQj+p22lubtl/D2Q=
X-Google-Smtp-Source: APXvYqyKjyDme9E80qasrfULjENVRc+RFwY9pj0J15zzuMNrNlpCbscblS1CnsJgIKkpCTlmOcWR+w==
X-Received: by 2002:a65:62d7:: with SMTP id m23mr81066508pgv.358.1563967561743;
        Wed, 24 Jul 2019 04:26:01 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id w18sm58008680pfj.37.2019.07.24.04.25.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:26:00 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Maya Erez <merez@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>, netdev@vger.kernel.org,
        wil6210@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 00/10] Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 19:25:24 +0800
Message-Id: <20190724112524.13042-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches use dev_get_drvdata instead of
using to_pci_dev + pci_get_drvdata to make
code simpler.

Chuhong Yuan (10):
  net: marvell: Use dev_get_drvdata where possible
  forcedeth: Use dev_get_drvdata where possible
  sfc: Use dev_get_drvdata where possible
  sfc-falcon: Use dev_get_drvdata where possible
  ath: Use dev_get_drvdata where possible
  iwlegacy: Use dev_get_drvdata where possible
  iwlwifi: Use dev_get_drvdata where possible
  mwifiex: pcie: Use dev_get_drvdata
  qtnfmac_pcie: Use dev_get_drvdata
  rtlwifi: rtl_pci: Use dev_get_drvdata

 drivers/net/ethernet/marvell/skge.c                |  6 ++----
 drivers/net/ethernet/marvell/sky2.c                |  3 +--
 drivers/net/ethernet/nvidia/forcedeth.c            |  3 +--
 drivers/net/ethernet/sfc/ef10.c                    |  4 ++--
 drivers/net/ethernet/sfc/efx.c                     | 10 +++++-----
 drivers/net/ethernet/sfc/falcon/efx.c              |  6 +++---
 drivers/net/ethernet/sfc/falcon/falcon_boards.c    |  4 ++--
 drivers/net/wireless/ath/ath5k/pci.c               |  3 +--
 drivers/net/wireless/ath/ath9k/pci.c               |  5 ++---
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |  6 ++----
 drivers/net/wireless/intel/iwlegacy/common.c       |  3 +--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 12 ++++--------
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  8 ++------
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  4 ++--
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  6 ++----
 15 files changed, 32 insertions(+), 51 deletions(-)

-- 
2.20.1

