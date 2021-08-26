Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25013F8E37
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243319AbhHZSxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 14:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243350AbhHZSxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 14:53:33 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D07FC061757;
        Thu, 26 Aug 2021 11:52:45 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g135so2385998wme.5;
        Thu, 26 Aug 2021 11:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nhTcmbI7mRHDQlXLUbdU7oSZOkATHD42lq4wKqjaJs4=;
        b=cNLHcdGZdQe3JZnNy8yr3yC7jg+I+4RssX8j6e6bhzPE5Endi0H5nru+Xx9Eiz5/+y
         qoQ//Gn6egXSeKQx2bcttXidzr5DTi5Wt1l5owENISuSz8RCVuUgreBK1nxFqnR/JnRy
         tRkVfI2hCZO+zZDWL2dfqeMCiXmLn7AeCob4Nu1j+FMLckBmduGfFFllIGCTkGPpBzEe
         NIFNzP4QPOfCeRfVt+VmqeCCSSzLcxUaNQJxV0gYj56ActazE051ILx3NnKPun2LX+xn
         qGn3gq63yxMU4F5vuzlK52W+OhFUcGYUOO9eSylbtL2RtD+vml1n/6GkkJIGWYNN0rPz
         ClhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nhTcmbI7mRHDQlXLUbdU7oSZOkATHD42lq4wKqjaJs4=;
        b=skq2dQb8Bz7YKfW/nq77N6yHoVxs2G+J/1uhQhGRSDC5WNST7KObUR0jOjuhBoU2To
         miEngnDKaRzzxRZZxPb98Xfc48bX2VutkiKhO/yy/yYj9PbNvFiHu50UDHjFlwj+75lk
         sRRbhNTe1bq1qCMIC9Ry+huZM5SnOaFwaSwRFEJRj6LTS2iXB0hukGd3kTFeykZ/CbxO
         KYBp6pC4j5q9E/WS+076rh2vsRLk2R9GP3JPFRzpYETvGtgF65SdKZXGTH5t9eMv9OI5
         uTBzB8smRfMgXdmuqiLWV8k2ccqANA7gso20kAV2dkiD5FDuGIqRojOP3C7OxQZ6vUG6
         mHkw==
X-Gm-Message-State: AOAM532OYLt1aiCiDKkHNzyXAe10Ft/5Y2c6RJAFjeixwv+UNvhSYwxg
        nHiEAJxMkgFFH5ZjfyrC0VRrBUuf0/T+/A==
X-Google-Smtp-Source: ABdhPJzDs78+UYJHa/kCufATtkr/hl2yoBvnzoJHQoGWEmxtyDSt3CADxh/6/rtsvrlY/WBC6Tj8TQ==
X-Received: by 2002:a1c:f314:: with SMTP id q20mr15995961wmq.154.1630003963573;
        Thu, 26 Aug 2021 11:52:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:b5d8:a3dc:f88f:cae2? (p200300ea8f084500b5d8a3dcf88fcae2.dip0.t-ipconnect.de. [2003:ea:8f08:4500:b5d8:a3dc:f88f:cae2])
        by smtp.googlemail.com with ESMTPSA id k14sm3886409wri.46.2021.08.26.11.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 11:52:43 -0700 (PDT)
To:     Raju Rangoju <rajur@chelsio.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/7] PCI/VPD: Final extensions and cleanups
Message-ID: <5fa6578d-1515-20d3-be5f-9e7dc7db4424@gmail.com>
Date:   Thu, 26 Aug 2021 20:52:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series finalizes the VPD extensions and cleanups.
It should be applied via the PCI tree.

Heiner Kallweit (7):
  PCI/VPD: Stop exporting pci_vpd_find_tag()
  PCI/VPD: Stop exporting pci_vpd_find_info_keyword()
  PCI/VPD: Include post-processing in pci_vpd_find_tag()
  PCI/VPD: Add pci_vpd_find_id_string()
  cxgb4: Use pci_vpd_find_id_string() to find VPD id string
  PCI/VPD: Clean up public VPD defines and inline functions
  PCI/VPD: Use unaligned access helpers

 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 13 ++-
 drivers/pci/vpd.c                          | 71 +++++++++++-----
 include/linux/pci.h                        | 95 ++--------------------
 3 files changed, 61 insertions(+), 118 deletions(-)

-- 
2.33.0

