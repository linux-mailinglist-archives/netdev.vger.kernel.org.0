Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F842131FB
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgGCDDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGCDDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:03:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2457C08C5C1;
        Thu,  2 Jul 2020 20:03:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j1so13380021pfe.4;
        Thu, 02 Jul 2020 20:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pvp5GqQnObwsM2WQjJTtbVs7GSQZ7G4lQMiDZtzgLT0=;
        b=ZV3DqdoAbv0sFGAPIy2vkGDpPQM3nJTjXxSxp1azMqqhWwEFZ4MNgt6imgmKYn5em9
         I//8hxGOtjnFDUE87+sSiEPaqAZBuo1MA3v5wIJEkoKRw2uCndE3p0nq94bDdxm4GhAZ
         NIYLUq7Jb8NgNXvScBQUQn8HhKRwuhU085HiMk/G+Z+0GtfDsbGK5V+Nhq4O+r7Wv6WO
         3/Xdt/7xjKCGo0FyRtZ9AVsEbouMwK2gBxWlv9zi9XVjf/u99YBtc0DAUFdQ5fjkX1V7
         dnerw5o3FWksd0dsim81SKJkQu6qVj+pHFJgBMjFYxuuKn1G1aJm8sVPbNZycGvysmLF
         fBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pvp5GqQnObwsM2WQjJTtbVs7GSQZ7G4lQMiDZtzgLT0=;
        b=Z11McIv6oF6ul+/eDDyOPSnHJrgpxtU0c89W3Ufes/tjVfpYalYcm2bD3ZpU57AQYO
         JU0TcUIL5yQMikQawJMs8FtQzj6jZIgv3fm/xEe3nd7/SCYivjy2QsklXjO0CQXiDZTh
         iKhKNz8fTbEsTH8PgqR+CmydUhCtho708BCL2PJ+EYU+8yEpE68HaeZKX2cIiKH7/fIf
         Y58iKzATgYwR6+m/fEHad8OE/vZsNpKI9PRBdh0tUHc49E4y7wvzN1DxuDKgCga5bhl0
         zh34kk3ebqVODzuVGe1xK47zslvMzCQzBdhwmp9yiWMHZwyBtg/cZUpJApDwHZfuHUL2
         iX3w==
X-Gm-Message-State: AOAM531LFyuTlMGsH44XVCrLIEDmtkVdAbEkdvSuJxOxgixxNAkrmkdS
        KjGCJ+QE0B52nIsvjtFhmlw=
X-Google-Smtp-Source: ABdhPJxqzBmZHDywKghAsAeSDH/TwjeYkBmOSJz/G1Ubh82iVyKdl/rlDNKTcaA6NcZxDscaEEpD3A==
X-Received: by 2002:a63:5821:: with SMTP id m33mr27669386pgb.43.1593745383084;
        Thu, 02 Jul 2020 20:03:03 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id h194sm9903223pfe.201.2020.07.02.20.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 20:03:02 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v2 0/2] smsc: use generic power management
Date:   Fri,  3 Jul 2020 08:31:36 +0530
Message-Id: <20200703030138.25724-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from smsc ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

V2: Kbuild in V1, warning: variable 'err' is used uninitialized whenever 'if'
conditio is false in funcution .resume() .

Vaibhav Gupta (2):
  epic100: use generic power management
  smsc9420: use generic power management

 drivers/net/ethernet/smsc/epic100.c  | 19 +++++--------
 drivers/net/ethernet/smsc/smsc9420.c | 40 ++++++++--------------------
 2 files changed, 17 insertions(+), 42 deletions(-)

-- 
2.27.0

