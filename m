Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77A5B961A
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391508AbfITRAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 13:00:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55930 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391425AbfITRAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 13:00:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id a6so3241158wma.5;
        Fri, 20 Sep 2019 10:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hfCmgCUb2nNU06GAY9nG/LhP9CbzKqRKM0kPY/lRAeE=;
        b=qN059aa3GvcPJPqRSUY7RQhs0dXcPMf9HAHpz1q9l/Oc6pmpXDVPlwnmGEs1HWkONm
         cYgRWzromvRRzowOILDKnAiBqgqY8oB1EnHGTD5MWDJx/d39ov8h5zCsayGg6NVK2zzC
         gtHtK9sULu0W6N3+L6kSLvLkq2UImSSHGxW1wivj2gSHH6/pdLCVRFXXx4YThtnk3XA9
         QvOUeQq1DynSPe3yjXU/OjIzOocpMv+Ef00yCjOZ1HSDdNQWZiml54IpwoMthQ521TY/
         Luw4/y4scNzJTjYtyiSHZbNv6TF+IPlWFFjZpp8a/IBuVzSL2FxQz4UwOrO86qFl1Plz
         f/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hfCmgCUb2nNU06GAY9nG/LhP9CbzKqRKM0kPY/lRAeE=;
        b=gP8gyD4t1J1sgKH0FOJphUePKmq1ezs3dehrY55FrvpSCj+YyZRGJBuuNkuVQwwQ4O
         zxkuhmSECwx3aBV+Q7Ph/2V6UHkmwkTvX/meL3rGOfKDSa7ll1iMmilCQ5bFYBqCkoqk
         IUJ7Ge4qE280ojJCnRDNk9Wam505HLYiFa5dAar8RxLrdyXZsydJI3PIgnTVBD3BTT2x
         x/iR06NQlqtkC/JQOjUZmOPkg2H78dwCApVz9by849zzgIvi8v2leAiL8aR5BjL85Hqs
         8xMTU5bm6og554nDIINkvi6TcvIVTNX1ywHq9XwGmfSD5L4vaVQSB4OLWMnXsiF7rqyl
         c0wA==
X-Gm-Message-State: APjAAAV+cjZiM4E7XLJvRMUPm5jV3mo3YpVcL3fyph00D3+O9Rb+b3rA
        EEPdyFPgy2jpHoNFSjNK0zMNbVXv
X-Google-Smtp-Source: APXvYqwKQRv5O1b7rOKlY1vgQouISuvaOd1LvtJwxvvxY8DJhDgab9JzfkzCFtOA1px2eOy9K5Meww==
X-Received: by 2002:a1c:a8cb:: with SMTP id r194mr4202655wme.156.1568998838779;
        Fri, 20 Sep 2019 10:00:38 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id r12sm2216659wrq.88.2019.09.20.10.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 10:00:37 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC 4.10
Date:   Fri, 20 Sep 2019 19:00:34 +0200
Message-Id: <20190920170036.22610-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The DWMAC 4.10 supports the same enhanced addressing mode as later
generations. Parse this capability from the hardware feature registers
and set the EAME (Enhanced Addressing Mode Enable) bit when necessary.

Thierry

Thierry Reding (2):
  net: stmmac: Only enable enhanced addressing mode when needed
  net: stmmac: Support enhanced addressing mode for DWMAC 4.10

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  1 +
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  4 ++--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 22 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  3 +++
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  5 ++++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +++++
 include/linux/stmmac.h                        |  1 +
 7 files changed, 39 insertions(+), 3 deletions(-)

-- 
2.23.0

