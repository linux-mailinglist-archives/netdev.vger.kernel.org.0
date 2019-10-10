Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6C5D2E17
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 17:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfJJPqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 11:46:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41975 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfJJPqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 11:46:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id q9so8502259wrm.8;
        Thu, 10 Oct 2019 08:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sC7OgET7WuI6MVv7t9GfPyX9NmB9ODXWMBvtaCRh7aA=;
        b=bsDyFOUNIz0iGZ9C5a6DZWtYVC1f/1+CiyJ6Zkytog2cAj0j51ooR8Ns6sOhpj2NAq
         zC1x11Thn8EWQCrpgDdS5d10ipSRR/j0RN4PHB5QftXRSUsDaEGMOiJVslkyM8RS8mfj
         iMEPaDfclD7uV/l0GTaMcscEiM7atfXN84y7SMQjaR/Hjtf0VqDrXq3EBKqMoeS3xs70
         ky8e3Ei8gFe9fBzhsL5Z1sxUzRcSLGlVdXsBMnGEO5jyZYK8nMn3DghFrU96jjCWSCso
         DyDeTR0mrZ2miQBylRqK0naROAdiF1BFmnZC1q01G6tbICB3b3/tNP1kYokQF3Ql+uTV
         1zFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sC7OgET7WuI6MVv7t9GfPyX9NmB9ODXWMBvtaCRh7aA=;
        b=rBC+GHlyAXT1gkXFdgwMVC12MnWgKkb/0KBEIzd2PKEHp6v6YevnxNZHcXDWcOzeC8
         5FrVDpTt+Ioa4Nu+KKEfjt5DY0jl3K2+jL4W2bcBtbCy8Q3TKprd5EthF6Sqnh27gQco
         r4pnDq3i9qAHwh55ob6tRb1/Gfo168sBYH8q2YunlCpYhWERSpuGTaNP0TD1c7L8P3CC
         CgXQvBprR4Hg22fueHr4Oz0UKnZPiBwIbmd99FIYcNKUTDW88jkBLJ51oOrzhqRX1Cv5
         aQNeBdrHg4IH9eBCgO+xlmKzLKY+QKdx6itg12cyVmgiVyBd+eYzKmnNXr5XHwNis48n
         4eXA==
X-Gm-Message-State: APjAAAXppnPtUjZmAOD4YrNnOs1nJMylReF2XNBIxxgDnJxF6xcoLEbd
        LTDDyhpLSnViI7tI48BJT+UXMRwk9gccBQ==
X-Google-Smtp-Source: APXvYqx7OMJNGGu4fqxeXC2N1JbijhETuH3V/dxLnimGu/kq/uuzbLUXwtFMmmiD/gr+lut+mEkKVg==
X-Received: by 2002:a5d:6246:: with SMTP id m6mr9446584wrv.262.1570722375663;
        Thu, 10 Oct 2019 08:46:15 -0700 (PDT)
Received: from andrea.corp.microsoft.com ([2a01:110:8012:1010:e9a3:da77:7120:dee0])
        by smtp.gmail.com with ESMTPSA id u25sm6719807wml.4.2019.10.10.08.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 08:46:14 -0700 (PDT)
From:   Andrea Parri <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Andrea Parri <parri.andrea@gmail.com>
Subject: [PATCH v2 0/3] Drivers: hv: vmbus: Miscellaneous improvements
Date:   Thu, 10 Oct 2019 17:45:57 +0200
Message-Id: <20191010154600.23875-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

The patchset:

  - refactors the VMBus negotiation code by introducing the table of
    VMBus protocol versions (patch 1/3),

  - enables VMBus protocol version 4.1, 5.1 and 5.2 (patch 2/3),

  - introduces a module parameter to cap the VMBus protocol versions
    which a guest can negotiate with the hypervisor (patch 3/3).

Thanks,
  Andrea

---

Changes since v1 ([1]):
  - remove the VERSION_INVAL macro (Vitaly Kuznetsov and Dexuan Cui)
  - make the table of VMBus protocol versions static (Dexuan Cui)
  - enable VMBus protocol version 4.1 (Michael Kelley)
  - introduce module parameter to cap the VMBus version (Dexuan Cui)

[1] https://lkml.kernel.org/r/20191007163115.26197-1-parri.andrea@gmail.com

Andrea Parri (3):
  Drivers: hv: vmbus: Introduce table of VMBus protocol versions
  Drivers: hv: vmbus: Enable VMBus protocol versions 4.1, 5.1 and 5.2
  Drivers: hv: vmbus: Add module parameter to cap the VMBus version

 drivers/hv/connection.c          | 68 ++++++++++++++++----------------
 drivers/hv/vmbus_drv.c           |  3 +-
 drivers/net/hyperv/netvsc.c      |  6 +--
 include/linux/hyperv.h           | 12 +++---
 net/vmw_vsock/hyperv_transport.c |  4 +-
 5 files changed, 48 insertions(+), 45 deletions(-)

-- 
2.23.0

