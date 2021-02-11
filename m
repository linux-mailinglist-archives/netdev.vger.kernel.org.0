Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF3A319692
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhBKX2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:28:32 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:33202 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBKX23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 18:28:29 -0500
Received: by mail-ot1-f46.google.com with SMTP id c16so6862844otp.0;
        Thu, 11 Feb 2021 15:28:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NMJ7yLd9O23CBO6jbidyP4gLEKA1R1vMVgKZt27Rrho=;
        b=Vp9SdcKW10x0XUTXmhV0gK0xgGHVDL1PwJk3KXI0Rdg9VFHFgCHqb6cGg44B5Vmv9a
         hGtmLz1Tz9/pxlrFX238IlMdvCegAzNjrkbMNXlPI3mQsW9wW71RatxbXZAo3LxD+pqG
         8PZrMgBWjb7/LCfZFsx9zKkfofK79i8d3i5fCzi9GzKWZjbNRalhRu/PbPVyRLsgHnQ8
         QIu+TubdoRDmn540pwryyWRA5hx5D5JYyM/NAhYTN5lmOzBBLQ9O4l7OqZq8tUkTn1f1
         fSeR2JJZ7tvGcQn3HqueX8U9ztywPvJETzNAblxp2hqSLZvwl/SD3vPInJ8ofsC5Wiv5
         RtHA==
X-Gm-Message-State: AOAM532eSUZf1e9NYsKDRVwDHyY4BeT2WkxMyK/PZ5tc+OaqjnNU51kY
        MC/ifeWPWMtIfNXcVkSNxQ==
X-Google-Smtp-Source: ABdhPJxCLDZrG4wjSzEe3ksZoou3d9Y2oSOGUfFU4jjPmhV2WnoDeeXu5PQ90Om+6OiCd4FYz8Tnog==
X-Received: by 2002:a9d:74c6:: with SMTP id a6mr250282otl.369.1613086068486;
        Thu, 11 Feb 2021 15:27:48 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id s18sm1283922oih.53.2021.02.11.15.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:27:47 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Gilles Muller <Gilles.Muller@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, cocci@systeme.lip6.fr,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2 0/2] of: of_device.h cleanups
Date:   Thu, 11 Feb 2021 17:27:43 -0600
Message-Id: <20210211232745.1498137-1-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a couple of cleanups for of_device.h. They fell out from my
attempt at decoupling of_device.h and of_platform.h which is a mess
and I haven't finished, but there's no reason to wait on these.

Rob

Rob Herring (2):
  of: Remove of_dev_{get,put}()
  driver core: platform: Drop of_device_node_put() wrapper

 arch/powerpc/platforms/pseries/ibmebus.c |  4 ++--
 drivers/base/platform.c                  |  2 +-
 drivers/net/ethernet/ibm/emac/core.c     | 15 ++++++++-------
 drivers/of/device.c                      | 21 ---------------------
 drivers/of/platform.c                    |  4 ++--
 drivers/of/unittest.c                    |  2 +-
 drivers/usb/dwc3/dwc3-st.c               |  2 +-
 include/linux/of_device.h                | 10 ----------
 scripts/coccinelle/free/put_device.cocci |  1 -
 9 files changed, 15 insertions(+), 46 deletions(-)

-- 
2.27.0

