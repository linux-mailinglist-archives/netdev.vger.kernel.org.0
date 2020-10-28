Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD21B29E265
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404326AbgJ2CN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:13:57 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35677 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgJ1Vfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:35:55 -0400
Received: by mail-oi1-f195.google.com with SMTP id w191so1129475oif.2;
        Wed, 28 Oct 2020 14:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJjCYBDQRA1Y87dVSmn/FJuMApnZK8DW4dsai1PK8Pw=;
        b=IlSe4xAjzrFl2CN4AabUTHi5rc5PhVzOfz3NYnnC+R/frrrtauN3sUXKxqgUZCjjyD
         D4NInYinEh6UKEJpIsN+HPQ59yuvb1VDrfq/IWdVvgeZ4zf4IV4YJ8GFQnOHpyy/9xb8
         cjkcIHrSyhYuzjMS4Yi6XN8P4qG/aC/qsvlGBW6f0kjyVi4iyvkhx3JGVibHFZcrrIKL
         XD9ZUz/VjWJ+Z2ie0b90YKtYB4lXL5lgPtOORA+bNLR/EKNSypsxJAdRonowhxfqsvz7
         1/KQRuvV0j4PwmtRgqdAk4jT7qAuN56Aj0168nNkky53Lab0T0DIiO/EpCof06pbnHAM
         VOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJjCYBDQRA1Y87dVSmn/FJuMApnZK8DW4dsai1PK8Pw=;
        b=G9y8V0gMCcpgLDh0Cs5VuKNFAGjsa8d3pJXJ+8epMyhoxFDzD0FLTdsHx6F4az2t5o
         luTmymwgR6IEt5Wh7Ljqx4MyilwBbfVtsGZxVJF3oPX88eiKzm8wiizzsk3v8aqtt0tl
         xpMenuK75fXFhltRBvE0TRV1TW3hEHu8Z5ZATT9QD85VF8l6z3vQR35f7T24CmVWQcvY
         BRN1Uc33tYEBEE/8/vgC8/p2xiSPCNKniYYBpa4LdJv5JGGfhx9dskb2qla78S37YaE2
         feW6EElzgx+yasd1WkQ0tsKrk6eYedflDcfPoNHQjpikC9B37JZLrlWLlw++CqI8enMZ
         4LyA==
X-Gm-Message-State: AOAM530oLWoFzX2g5GoOdWA6oGPn/kW8Fo0GlG2gA8HSu+BQpKizWrGA
        Xx0jZ+kRt3cfxX6B/ubu1CguAa4sPS6zuREP
X-Google-Smtp-Source: ABdhPJxQqTAY26QBlFaEBLgr/WnvE5SDv4jz4MmJ6wZ7NKMd/7P6bvsKyn0mHBpXVIFQt7GPv6+J+A==
X-Received: by 2002:a17:90a:7784:: with SMTP id v4mr7178120pjk.60.1603895121529;
        Wed, 28 Oct 2020 07:25:21 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id 194sm6227192pfz.182.2020.10.28.07.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:25:20 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [PATCH 0/3] mwifiex: disable ps_mode by default for stability
Date:   Wed, 28 Oct 2020 23:24:30 +0900
Message-Id: <20201028142433.18501-1-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

On Microsoft Surface devices (PCIe-88W8897), we are observing stability
issues when ps_mode (IEEE power_save) is enabled, then eventually causes
firmware crash. Especially on 5GHz APs, the connection is completely
unstable and almost unusable.

I think the most desirable change is to fix the ps_mode itself. But is
seems to be hard work [1], I'm afraid we have to go this way.

Therefore, the first patch of this series disables the ps_mode by default
instead of enabling it on driver init. I'm not sure if explicitly
disabling it is really required or not. I don't have access to the details
of this chip. Let me know if it's enough to just remove the code that
enables ps_mode.

The Second patch adds a new module parameter named "allow_ps_mode". Since
other wifi drivers just disable power_save by default by module parameter
like this, I also added this.

The third patch adds a message when ps_mode will be changed. Useful when
diagnosing connection issues.

Thanks,
Tsuchiya Yuto

[1] https://bugzilla.kernel.org/show_bug.cgi?id=109681

Tsuchiya Yuto (3):
  mwifiex: disable ps_mode explicitly by default instead
  mwifiex: add allow_ps_mode module parameter
  mwifiex: print message when changing ps_mode

 .../net/wireless/marvell/mwifiex/cfg80211.c   | 23 +++++++++++++++++++
 .../net/wireless/marvell/mwifiex/sta_cmd.c    | 11 ++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

-- 
2.29.1

