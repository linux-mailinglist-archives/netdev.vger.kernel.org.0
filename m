Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED6F3B7F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfKGWfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:35:51 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33233 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGWfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:35:50 -0500
Received: by mail-wm1-f65.google.com with SMTP id a17so5174739wmb.0;
        Thu, 07 Nov 2019 14:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7DxvwxQedFVL2v9G3KjJjmTcPC9r0YYtv+wCtWcZn/s=;
        b=UFb+JQLSdTgLALt+snoVbg0YHvipQDnHMm12gsLqrs/Ka7XweF3p48wHXBo7IyyR7G
         Z7vwxM2iB3HMhxvj7q+KA/+xFe61dxFP6cUQKwaQ2hA5XvHsc+2SGX7Jbiv73rHjeGzt
         5KPqQOY//PTFxqiTlLyPlwD6rmSAWJ9aYlIJBmPtZhmizEofi032wG6Zhv1/yO0Oh5ea
         vgA4ItacVPMX6gG0HpHLFLVrwpjJ+zPxbuXpg53QmrMFWupJ3wlIDu2fCaLMTwSB89h1
         89AcdO3JTkbFrkH+lwGqImpDN8eAw1mLMsQT3b/S8aVS1kOa2/TNxOFfnyOq7ACaqpEl
         Lprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7DxvwxQedFVL2v9G3KjJjmTcPC9r0YYtv+wCtWcZn/s=;
        b=PyHskRVvyi+Zc1t8e0tychNqUBOmMQpLTsEH6OzXtmzAMAEVbUerY7plfo+lmTgYvg
         dIdIVQjgptczdKqN+NiAQhwro1J9K8vOmLk/I8UIp7rOY7Pe19omSdgcK1diRiAzI3Jl
         bpFr56WSug6AP16clhcJpjMi2DYic16uPjzpl76ufMqhsJ+AjQOP52m04yr2PO1++CUm
         viAJ11PC72r2wn2Rug7uJvBthV8LCrJW091oCR6oO63uKurSqgn1nnY8Kt5QptKl+J4V
         mbTgrvPkUYvVdGr57hUB8hQYZTlJssmAz9h+uHg9APjRfL7s3aOvfZ4Z4BIehm6jqEHR
         W03Q==
X-Gm-Message-State: APjAAAX10BE+9m+E2LYnHPxCFzz4NURfyEODglwa3bmtFxCn/JWt6fhc
        rJRyIHPoacvOaK2wl9/bApCeprzm
X-Google-Smtp-Source: APXvYqwLlMl9Bzz6Hn/3cFKnXywBnFRlQlXBMYJFjbiAEuCCR5o/uRj9bugs7dKIP2MRi9DvClDGbQ==
X-Received: by 2002:a7b:c411:: with SMTP id k17mr1316208wmi.119.1573166146414;
        Thu, 07 Nov 2019 14:35:46 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y6sm3667194wrw.6.2019.11.07.14.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 14:35:45 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Timur Tabi <timur@kernel.org>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/2] net: Demote MTU change prints to debug
Date:   Thu,  7 Nov 2019 14:35:35 -0800
Message-Id: <20191107223537.23440-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jeff, Timur,

This patch series demotes several drivers that printed MTU change and
could therefore spam the kernel console if one has a test that it's all
about testing the values. Intel drivers were not also particularly
consistent in how they printed the same message, so now they are.

Thanks

Florian Fainelli (2):
  net: ethernet: intel: Demote MTU change prints to debug
  net: qcom/emac: Demote MTU change print to debug

 drivers/net/ethernet/intel/e1000/e1000_main.c | 4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c    | 3 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 4 ++--
 drivers/net/ethernet/intel/igb/igb_main.c     | 5 ++---
 drivers/net/ethernet/intel/igbvf/netdev.c     | 4 ++--
 drivers/net/ethernet/intel/igc/igc_main.c     | 5 ++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 drivers/net/ethernet/qualcomm/emac/emac.c     | 6 +++---
 8 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.17.1

