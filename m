Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812BA20CA33
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgF1Txo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgF1Txn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:43 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82EAC03E979;
        Sun, 28 Jun 2020 12:53:43 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a1so14492828ejg.12;
        Sun, 28 Jun 2020 12:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XyJoAKzD2xMTmaGb+2U8hknfu7zNJd/hENwzynkwJW4=;
        b=tfxRlJ4UIIdWSnEzUIW/lHNPIDZRbEKOVVQMpsqpQBijWQblZkXJz9RJXxbmY/D42f
         zInCM3145BZV6LRJ/PTtWBquxMqeConvZoFI7xSaE/tP9Z9ab6TaPnCGygtQ/Omu++7y
         8UR7rAjD1CVfq+n0lMSAEoZf0yrhUPEXuM47qjuBMYCn58NR3uXk21V2nAeNweOlyW2t
         ZEwXHoHfe71RKg0dvJDxDFfGheQVXw/ATZXeOIwLS+lJimITqoBy00Zm1K5dXBIIs9Qq
         zKWpj12dDLB+oUpSI9nIZ1+h/aMSvYSQkZtVrwUp9w0NKYCYKmyH1jZPLd7eKBhEQvqw
         O/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XyJoAKzD2xMTmaGb+2U8hknfu7zNJd/hENwzynkwJW4=;
        b=sfr2F1mQnLp3NB0FoJ38hvhssCEQcZsZ0t4mbYWB7gvgU6Ogyo36q2hs235N1j5zoP
         3VZNd/j07bo2e0GXiebK7fLhPRQt12zJ8afjLj6OSBx+YI3KR6VjmEDuGLAO4A0C3O5b
         xlIzQrJ8gvVE95mJErSyh5a0SX+fVMqUQuTlPnUav93zu8UKJXIJPPPTrBo9qgOdCeu/
         9ve+ScDsIBSMP1Saf1TMb7ug4YtRZCollpPddGbLneiZemKQqudDywTPzd+W6RDeR+ys
         zzIfGao+JnH8tFcFtNFllHx3R39nBnHPZKkMoFK4CARnE+gliPveIGprC8dgSGKACFhw
         CDrg==
X-Gm-Message-State: AOAM5313VrsrTCM7tpPaiEa2llm04E8l1MtWh/Nm88L4t+linPBVRP19
        F+0oT+WarjU8x45ncWeLx4k=
X-Google-Smtp-Source: ABdhPJyU6tDnSk4Ih0ey/mu+oeXnr+wchrmQxcBYhsVi3h+82J7obYCNcdpzpszIFShD5lHQz+WdVQ==
X-Received: by 2002:a17:906:fca4:: with SMTP id qw4mr10670632ejb.362.1593374022389;
        Sun, 28 Jun 2020 12:53:42 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:41 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 00/15] always use netdev_tx_t for xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:22 +0200
Message-Id: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit() methods should return a 'netdev_tx_t', not
an int, and so should return NETDEV_TX_OK, not 0.
The patches in the series fix most of the remaning drivers and
subsystems (those included in allyesconfig on x86).


Luc Van Oostenryck (15):
  cail,hsi: fix cfhsi_xmit()'s return type
  caif: fix caif_xmit()'s return type
  caif: fix cfspi_xmit()'s return type
  caif: fix cfv_netdev_tx()'s return type
  net: aquantia: fix aq_ndev_start_xmit()'s return type
  net: arc_emac: fix arc_emac_tx()'s return type
  net: nb8800: fix nb8800_xmit()'s return type
  net: nfp: fix nfp_net_tx()'s return type
  net: pch_gbe: fix pch_gbe_xmit_frame()'s return type
  net: dwc-xlgmac: fix xlgmac_xmit()'s return type
  net: plip: fix plip_tx_packet()'s return type
  usbnet: ipheth: fix ipheth_tx()'s return type
  net/hsr: fix hsr_dev_xmit()'s return type
  l2tp: fix l2tp_eth_dev_xmit()'s return type
  cxgb4vf: fix t4vf_eth_xmit()'s return type

 drivers/net/caif/caif_hsi.c                          | 6 +++---
 drivers/net/caif/caif_serial.c                       | 2 +-
 drivers/net/caif/caif_spi.c                          | 4 ++--
 drivers/net/caif/caif_virtio.c                       | 2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c     | 2 +-
 drivers/net/ethernet/arc/emac_main.c                 | 2 +-
 drivers/net/ethernet/aurora/nb8800.c                 | 2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/adapter.h       | 2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c           | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  | 2 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c       | 2 +-
 drivers/net/plip/plip.c                              | 4 ++--
 drivers/net/usb/ipheth.c                             | 2 +-
 net/hsr/hsr_device.c                                 | 2 +-
 net/l2tp/l2tp_eth.c                                  | 2 +-
 16 files changed, 20 insertions(+), 20 deletions(-)

-- 
2.27.0

