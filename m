Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803833AB392
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhFQMbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhFQMba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 08:31:30 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5484AC061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 05:29:23 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gb32so1412012ejc.2
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 05:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xksRp1kP5wm7skdQgZmFr3hjg6acj3lQ45S+eP4Pjyc=;
        b=RN/UDDm/lrrs2JYuTvZOtgBr5TlrWi8qzNmZHCvqSWwS3EgXpQRKqg42wBKFEL950i
         BGkWJ3hwacOS/1rF2nSLnOnvPxJh6TFHEuAnfUr9fEIK6HLCJVWjO6R1kEytlemXfuhl
         ahgBhYPgiReBEpLYEBgsMRdhGC9qQxsz0uFWM4Hmd7POMh0ufwEMZ/6Nabpbg8z6jX1z
         40y7VrD7nSPUrw4UQCcN43zzlI/zLjcblOx6mpKrUFbrdgX02Hl1B2fD47ftDPCLAjgc
         Tshq8vq+mPW8LXRoPrhwy6jAy4K4oVApk/JPE2Z9Etd65lWlX96UC9bYCX+PPCg+4pPf
         0a1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xksRp1kP5wm7skdQgZmFr3hjg6acj3lQ45S+eP4Pjyc=;
        b=Pss7HoFyxon6clbQyust2FuUrN5b56BNOoMR/qFrZ/dWj6trHc1DpKnhfsin1ufduv
         p6BaeYRU5y457vhYnH3xSE7GenZPWVgxNsc1rQXn3E0j1L9N7Zt1yEa408HrCSBnSpuD
         m3drI4fszgV7cbAQehXxY9FUbt6glFTEuB4KlKNY8HfjPKjADv4zr0rffticbgzmz+4f
         rdWVhOGYvIQhmyLlA/4tnY2XJILa18Y7rGwFYOfMZ018VzFnJoZsir2Nloen1FC+YMvO
         kjd74maGtyhuy0qZ3veqYMl6JxodOwZpmnUPx1XdN8Wo3qbgFQQcXUPeSTw/GB13D23/
         oq/g==
X-Gm-Message-State: AOAM532tK1NAlP4QzwnpEMHNsHQTEzJjczL36yPR2Uhdi42inUPlWIVv
        TsmCl7iA9eH/uob7S5DkJQg=
X-Google-Smtp-Source: ABdhPJzeVvLbN8D5dist/MNOFlaZrMDyHY6xm/PwBThS6AhdjXhwlXP9A8KzKiOszqFUhFVELzYgdQ==
X-Received: by 2002:a17:906:6d43:: with SMTP id a3mr5043700ejt.142.1623932961804;
        Thu, 17 Jun 2021 05:29:21 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id de10sm3706179ejc.65.2021.06.17.05.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 05:29:21 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        grant.likely@arm.com, calvin.johnson@oss.nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 0/3] net: mdio: setup both fwnode and of_node
Date:   Thu, 17 Jun 2021 15:29:02 +0300
Message-Id: <20210617122905.1735330-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The first patch in this series fixes a bug introduced by mistake in the
previous ACPI MDIO patch set.

The next two patches are adding a new helper which takes a device and a
fwnode_handle and populates both the of_node and fwnode so that we make
sure that a bug like this does not happen anymore.
Also, the new helper is used in the MDIO area.

Ioana Ciornei (3):
  net: mdio: setup of_node for the MDIO device
  driver core: add a helper to setup both the of_node and fwnode of a
    device
  net: mdio: use device_set_node() to setup both fwnode and of

 drivers/base/core.c            | 7 +++++++
 drivers/net/mdio/fwnode_mdio.c | 2 +-
 drivers/net/mdio/of_mdio.c     | 9 ++++-----
 drivers/net/phy/mdio_bus.c     | 3 +--
 include/linux/device.h         | 1 +
 5 files changed, 14 insertions(+), 8 deletions(-)

-- 
2.31.1

