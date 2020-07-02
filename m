Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4A52125CE
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgGBOM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:12:59 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:34808 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgGBOM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:12:58 -0400
Received: by mail-ej1-f65.google.com with SMTP id y10so29815893eje.1;
        Thu, 02 Jul 2020 07:12:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4r4v5c89GnZeM3QVUO8j4lUJ1Gquc8ZGtP+s3D/cQtU=;
        b=Fl4hAAT6a6wkIITVqcPGXsy2YjeTNEBsdhyJ2dtnjZOtQx8vqUZd+8im+yxizvE39j
         4abOg4Pn8ZUs9ik4bOPIoSOrMUcALGrUPiMaFfygip12AlWd5fiaAkjpi6bZBSaE+Qyn
         aOI29xpvoivYoba7HgCZMpTzkTITlfMT8EVFOWaL8xL2xa3/17y2h536sBP+mzotIy58
         //4CVUqQados9Bq9jaA983yT+NHMQScSheipnUgVesCzhi0KIsRQfBJEqXM263cBJVM8
         1apVO+akbKPPg3LiQHVbt2oPShqRqJP7Hed/aWF2W/y8LeJNyDyN/mKh8ymHDkPw8pzY
         bDUA==
X-Gm-Message-State: AOAM5325xN95syysFnTVLdYTlJZiFMHxbaKAIWghrf8lMIlsA5Qx4wqb
        uB/QSIuHNtMAy51LormuwNL0C5GyY+1yMw==
X-Google-Smtp-Source: ABdhPJzA23lTgTl/podxE17idOaydmlq2gsf7H7fAeyukmLrDb+FWpqgB4bQ1uD6lvFTl75Y86iA/w==
X-Received: by 2002:a17:906:5243:: with SMTP id y3mr29411310ejm.193.1593699176311;
        Thu, 02 Jul 2020 07:12:56 -0700 (PDT)
Received: from msft-t490s.lan ([2001:b07:5d26:7f46:d7c1:f090:1563:f81f])
        by smtp.gmail.com with ESMTPSA id fi29sm6841274ejb.83.2020.07.02.07.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 07:12:55 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 0/5] mvpp2: XDP support
Date:   Thu,  2 Jul 2020 16:12:39 +0200
Message-Id: <20200702141244.51295-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

From: Matteo Croce <mcroce@microsoft.com>

Add XDP support to mvpp2. This series converts the driver to the
page_pool API for RX buffer management, and adds native XDP support.

XDP support comes with extack error reporting and statistics as well.

These are the performance numbers, as measured by Sven:

SKB fwd page pool:
Rx bps     390.38 Mbps
Rx pps     762.46 Kpps

XDP fwd:
Rx bps     1.39 Gbps
Rx pps     2.72 Mpps

XDP Drop:
eth0: 12.9 Mpps
eth1: 4.1 Mpps

Matteo Croce (4):
  mvpp2: refactor BM pool init percpu code
  mvpp2: use page_pool allocator
  mvpp2: add basic XDP support
  mvpp2: XDP TX support

Sven Auhagen (1):
  mvpp2: xdp ethtool stats

 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  57 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 730 ++++++++++++++++--
 3 files changed, 718 insertions(+), 70 deletions(-)

-- 
2.26.2

