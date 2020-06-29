Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25BF20E41E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390672AbgF2VVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbgF2Swn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:52:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E75C031C53;
        Mon, 29 Jun 2020 10:36:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k71so4843467pje.0;
        Mon, 29 Jun 2020 10:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G0sYP00DyHcgSiz/UpCj0vFSMqhUdJtVPzxSy22jFRs=;
        b=X8/CAFiDKcy1LRoopU/VXQqrF/ZXGGSBw4D5FArGbTOu2n4JamyvFgiWlugGFsqSWM
         /9xVgVu+f/ncxxEz0VlzZr31y1FxZzC8Jc+sF648c86tQga2eom8sl6/lfJxOcC2zbt3
         nfj2/wL562qfy3sqaGoUnWITVNcwjvE/Df3g3LcC+6PyutlOA9UrYFg+s4HWkAao31gd
         sjRuHnBD8imlkO9/NQEO6ZY6sbgFNfk5G7L7A3OtSQhS5yHQ7ZRroV6u+Zz/9N2L7ACz
         SpWvD/+s2hgECa2/k9Apgoa1nwhlGvHGZNScfJzhTUsFEHyivbspJCM5V40cttfUNNBU
         ti3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G0sYP00DyHcgSiz/UpCj0vFSMqhUdJtVPzxSy22jFRs=;
        b=Cv8md3T3U6bAAFwBDFW/aoTHCQEgBk9+dmmJjSO3rUL4uWF0sHOE+irZcUVwl5sNG+
         p5eUWxkLE68mXQVC/vf4G2tGdiEy6NL3WViZSHOUdhizm1eeQUjHS7pdBVFn38xVbe/X
         M4d28H0eit8i+WLaFh2T1Xe5UI+VUtE6g5xpZdHkcID6CdUJSn4LQwKONFw9mF8JEGYd
         KX31kHP0CWZKnJX5F//DW3p1YbTWebUiziS2eNcOKNA2lij0jx5pcpmouJyN4MiBt9aR
         UzWTmh9SBN/3P3b1K1ieLGAP2o4lUer8NPoIJrA7Cxs5jMJyU25OAiNCiilW9RWQDMPR
         9x3Q==
X-Gm-Message-State: AOAM531ub9V0scIXKbvkB73yJci0lITm9RB40McHcGdWADMhzW8YJZH4
        qVhUqHv7DxJxeR5iAyrRcwU=
X-Google-Smtp-Source: ABdhPJytPqaMuxgD0wTHbLQsj7ArRGy3HFUVO8WFw4oHOZsTmYK70wTx5FpJaZY3EXhIhz/1MrYa7A==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr11765030pjq.185.1593452173081;
        Mon, 29 Jun 2020 10:36:13 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id k23sm331461pgb.92.2020.06.29.10.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 10:36:12 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v2 0/4] drivers/staging: use generic power management
Date:   Mon, 29 Jun 2020 23:04:55 +0530
Message-Id: <20200629173459.262075-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from amd ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

v2: An error was reported by kbuild in v1. pci_set_master() function call in
drivers/staging/qlge/qlge_main.c, inside qlge_resume(), was passing argument
which got deprecated after upgrade to generic PM. The error is fixed in v2.

Vaibhav Gupta (4):
  qlge/qlge_main.c: use generic power management
  staging/rtl8192e: use generic power management
  rts5208/rtsx.c: use generic power management
  vt6655/device_main.c: use generic power management

 drivers/staging/qlge/qlge_main.c             | 38 ++++++--------------
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |  5 +--
 drivers/staging/rtl8192e/rtl8192e/rtl_pm.c   | 26 ++++----------
 drivers/staging/rtl8192e/rtl8192e/rtl_pm.h   |  4 +--
 drivers/staging/rts5208/rtsx.c               | 30 +++++-----------
 drivers/staging/vt6655/device_main.c         | 25 ++++---------
 6 files changed, 37 insertions(+), 91 deletions(-)

-- 
2.27.0

