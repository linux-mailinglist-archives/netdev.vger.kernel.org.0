Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4FB311136
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhBERsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbhBERpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 12:45:23 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A49CC061756;
        Fri,  5 Feb 2021 11:27:07 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id t142so4719807wmt.1;
        Fri, 05 Feb 2021 11:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nQ5XuXL2KjXNQ6Da97fSEh5p9x+2C/EGVVzkYBXX5uw=;
        b=Sxjh6er0UyBlGr9VjYFEbEueB3OKZsc9k26ygQmo2G2/Xb9+Fr51nLn6OilBaI+A63
         9wbtURKXzMPxFKqkaDyyTiIfQ6CE4P8CVgK1tWqMV6QGVMi6EUOIguMU7iL9s3Za/aAO
         WH2GDO3WKcsgJMvVQIl36pC2xSNzD7deOR/ZvBRmzR/AoLCPV47GnzdoiqdkiZP9P6Sw
         AZCIRB0w8mlKhO2eDK82qNY+MRm1HKT3lGZG3aFksu4m146x+GNY8fNC4Taw52jZl0DC
         VGEXnin9g9USWMJDlN/eZXREf9KSIV8LaaGPNM2egDrty/Fo0BI/xjiHc8Zup/I6M7PH
         724w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nQ5XuXL2KjXNQ6Da97fSEh5p9x+2C/EGVVzkYBXX5uw=;
        b=VWofHmhYDe5YckHkX13jSwWDGSapay3X+1KVIcvkUCfuTBJryF+X1X/3oiJh+QUPJh
         4WhT/aT6yDQ774YtjwEkH1jEY6QhTFjK8BocAsjobV7uM4OOKjLjAWeEML93dnyVpS5p
         Y9iltckib1eEujrN0Pbph/4yAhOCN6LvEPOKv6Eq03chzSBuk63PpAty47Z5EYUMLgXa
         RzWILAPsIuC80kH56c816hv2jP+w2UxdhYKCpktH3Ffz/YrVtTAWVt86uRygGACj1bnr
         Vm5+muFzr//7B6ne1mSh+WeSIYyCUSleONxgHlMDj02s+JKtHrb/CEb8rwCsNSzAII6F
         zzEQ==
X-Gm-Message-State: AOAM530y0BmhuA/4zHENECkHPYORw/kwlHcRh3AZdC1NbCMfdTZdpp5O
        xaeg/O+BcNdn1zMhRu3T2mPObSjIHLnuHA==
X-Google-Smtp-Source: ABdhPJwY/fMzNcta3vA5H/vo73CK7DW+2SOiUynvm09+mzQ6lPnx5msSJIkFILTSEw/aOfJOzhO0kA==
X-Received: by 2002:a1c:105:: with SMTP id 5mr4841773wmb.89.1612553225362;
        Fri, 05 Feb 2021 11:27:05 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:11de:46a1:319f:d28? (p200300ea8f1fad0011de46a1319f0d28.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:11de:46a1:319f:d28])
        by smtp.googlemail.com with ESMTPSA id f14sm9601215wmc.32.2021.02.05.11.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 11:27:04 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH resend net-next v2 0/3] cxgb4: improve PCI VPD handling
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <6658af1a-88fc-1389-0126-77201b4af2b3@gmail.com>
Date:   Fri, 5 Feb 2021 20:26:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Working on PCI VPD core code I came across the Chelsio drivers.
Let's improve the way how cxgb4 handles PCI VPD.

One major goal is to eventually remove pci_set_vpd_size(),
cxgb4 is the only user. The amount of data exposed via the VPD
interface is fixed, therefore I see no benefit in providing
an interface for manipulating the VPD size.

This series touches only device-specific quirks in the core code,
therefore I think it should go via the netdev tree.

v2:
- remove patch 1 from the series

Resending the series because it seems netdev patchwork swallowed it.

Heiner Kallweit (3):
  cxgb4: remove unused vpd_cap_addr
  PCI/VPD: Change Chelsio T4 quirk to provide access to full virtual
    address space
  cxgb4: remove changing VPD len

 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |  1 -
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 21 ++++---------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  1 -
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 --
 drivers/pci/vpd.c                             |  7 +++----
 5 files changed, 7 insertions(+), 25 deletions(-)

-- 
2.30.0

