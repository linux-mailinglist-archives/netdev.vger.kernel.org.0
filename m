Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167B826ADD6
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgIOTnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbgIORLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:11:42 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1D5C061351;
        Tue, 15 Sep 2020 10:10:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k15so4114389wrn.10;
        Tue, 15 Sep 2020 10:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=z4AlU+bb1rRabX9jd0xPn0doqLyUa6Q99eDRG9m8Hck=;
        b=IjyD3RKXnOA+jYMv7/MCPOcg+luKGNwOrcqJ0Y6VXkQE56UMurXy259fmpHxcq/QmR
         ob5294GZJkRAdnTAwtAHvk1TyOrRRZG1WX8JAkVw8TOPs1PTKdsKiHNRCStoh81mUKD6
         gy2OLcqxLwZko4jt0Edl6UChHFoOX/IXgNU/2CHI/1bm0Bm5YOP+I0m11I5PXplVnL60
         /WPwDA/QoqX8D/4940GipTMeNbtNn8GBYL9iG3GsaKu4ScMol3UQcUx77nu4q0yCCl0U
         /LYg1ovDAv+TrQnFjaD7qWAMF5g5AtOFgn9JpAz1EkHae2a+igYoRuKS650PPJhuxdb0
         m+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z4AlU+bb1rRabX9jd0xPn0doqLyUa6Q99eDRG9m8Hck=;
        b=XzAs2EWsTB6KlxjbXqanV1n+W4OqKu/rlhtpyf4V8+RXwd3iJu/+xkMpsG9gTPtOk8
         rwN8kb7ne71thPwx1gld9W48KQr5S72VceKKobqthbhl13hjWSJc/Qyk68BDOYD8RN18
         FZop2/oapWukEriXSrDkCH40lJGwcOyRdjSmXiKZXnjAB11SMfqfI4Pb6r0MitzGHd0K
         n/P5cqx1MILQMvA1H7PFs0SLIZ0CJZ0LGJ0Wk6l3RzCShW/Bh9MV4Uzr6fX6EnfRpHH2
         Tdwur9dVxMsMnTYZtFJMZjm9ZyX739U6J5FAuxOvFcruFSeWCkM+Jizv2MgSScXOH9ks
         bMrg==
X-Gm-Message-State: AOAM533k2Julqk83EYUqyKekU4izssueU70DuG9VJq8QyBXux0kAkrJ7
        ag8pBkb4lpTvIjkvHCac3xkgWnhP+LQcrw==
X-Google-Smtp-Source: ABdhPJyrsbFv7yAgMEnhArc6JtSBxI092rwtDMuaTpvj40ps2My+GndLF84RgkedbyJN/oq3yjJYWw==
X-Received: by 2002:a5d:5106:: with SMTP id s6mr23912942wrt.166.1600189826089;
        Tue, 15 Sep 2020 10:10:26 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id b194sm356558wmd.42.2020.09.15.10.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 10:10:24 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Date:   Tue, 15 Sep 2020 20:10:08 +0300
Message-Id: <20200915171022.10561-1-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This is the second version of the patch-set to upstream the GAUDI NIC code
into the habanalabs driver.

The only modification from v2 is in the ethtool patch (patch 12). Details
are in that patch's commit message.

Link to v2 cover letter:
https://lkml.org/lkml/2020/9/12/201

Thanks,
Oded

Omer Shpigelman (14):
  habanalabs/gaudi: add NIC H/W and registers definitions
  habanalabs/gaudi: add NIC firmware-related definitions
  habanalabs/gaudi: add NIC security configuration
  habanalabs/gaudi: add support for NIC QMANs
  habanalabs/gaudi: add NIC Ethernet support
  habanalabs/gaudi: add NIC PHY code
  habanalabs/gaudi: allow user to get MAC addresses in INFO IOCTL
  habanalabs/gaudi: add a new IOCTL for NIC control operations
  habanalabs/gaudi: add CQ control operations
  habanalabs/gaudi: add WQ control operations
  habanalabs/gaudi: add QP error handling
  habanalabs/gaudi: Add ethtool support using coresight
  habanalabs/gaudi: support DCB protocol
  habanalabs/gaudi: add NIC init/fini calls from common code

 drivers/misc/habanalabs/common/context.c      |    1 +
 drivers/misc/habanalabs/common/device.c       |   24 +-
 drivers/misc/habanalabs/common/firmware_if.c  |   44 +
 drivers/misc/habanalabs/common/habanalabs.h   |   33 +-
 .../misc/habanalabs/common/habanalabs_drv.c   |    5 +
 .../misc/habanalabs/common/habanalabs_ioctl.c |  151 +-
 drivers/misc/habanalabs/common/pci.c          |    1 +
 drivers/misc/habanalabs/gaudi/Makefile        |    3 +
 drivers/misc/habanalabs/gaudi/gaudi.c         |  957 +++-
 drivers/misc/habanalabs/gaudi/gaudiP.h        |  331 +-
 .../misc/habanalabs/gaudi/gaudi_coresight.c   |  144 +
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     | 4093 +++++++++++++++++
 drivers/misc/habanalabs/gaudi/gaudi_nic.h     |  353 ++
 .../misc/habanalabs/gaudi/gaudi_nic_dcbnl.c   |  108 +
 .../misc/habanalabs/gaudi/gaudi_nic_ethtool.c |  616 +++
 drivers/misc/habanalabs/gaudi/gaudi_phy.c     | 1276 +++++
 .../misc/habanalabs/gaudi/gaudi_security.c    | 3973 ++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c           |   44 +
 .../misc/habanalabs/include/common/cpucp_if.h |   34 +-
 .../include/gaudi/asic_reg/gaudi_regs.h       |   26 +-
 .../include/gaudi/asic_reg/nic0_qm0_masks.h   |  800 ++++
 .../include/gaudi/asic_reg/nic0_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic0_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic0_qpc0_masks.h  |  500 ++
 .../include/gaudi/asic_reg/nic0_qpc0_regs.h   |  710 +++
 .../include/gaudi/asic_reg/nic0_qpc1_regs.h   |  710 +++
 .../include/gaudi/asic_reg/nic0_rxb_regs.h    |  508 ++
 .../include/gaudi/asic_reg/nic0_rxe0_masks.h  |  354 ++
 .../include/gaudi/asic_reg/nic0_rxe0_regs.h   |  158 +
 .../include/gaudi/asic_reg/nic0_rxe1_regs.h   |  158 +
 .../include/gaudi/asic_reg/nic0_stat_regs.h   |  518 +++
 .../include/gaudi/asic_reg/nic0_tmr_regs.h    |  184 +
 .../include/gaudi/asic_reg/nic0_txe0_masks.h  |  336 ++
 .../include/gaudi/asic_reg/nic0_txe0_regs.h   |  264 ++
 .../include/gaudi/asic_reg/nic0_txe1_regs.h   |  264 ++
 .../include/gaudi/asic_reg/nic0_txs0_masks.h  |  336 ++
 .../include/gaudi/asic_reg/nic0_txs0_regs.h   |  214 +
 .../include/gaudi/asic_reg/nic0_txs1_regs.h   |  214 +
 .../include/gaudi/asic_reg/nic1_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic1_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic2_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic2_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic3_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic3_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic4_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic4_qm1_regs.h    |  834 ++++
 drivers/misc/habanalabs/include/gaudi/gaudi.h |   12 +
 .../habanalabs/include/gaudi/gaudi_fw_if.h    |   24 +
 .../habanalabs/include/gaudi/gaudi_masks.h    |   15 +
 .../include/hw_ip/nic/nic_general.h           |   13 +
 include/uapi/misc/habanalabs.h                |  296 +-
 51 files changed, 27083 insertions(+), 62 deletions(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h

-- 
2.17.1

