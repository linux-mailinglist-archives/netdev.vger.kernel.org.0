Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5739211C187
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfLLAfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:35:38 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45518 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbfLLAfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:35:38 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so142140pfg.12
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 16:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EJQEr0g4sEmPtojP4+ShTRIPMlj7/5Kt5ctaIgSd5Vk=;
        b=gtjxygZ+GD5bnOiveusiEiO/jB+8ybYnxThCk+Z5NvIvcsh3gHWh6cw+AphmG027qE
         ewe9xKhPI339eSb5dUirYG3NAJCk9c3d7relSFUbuk9a2tmGsjL5MtVYM1EPFKL64pd/
         y6v+lPPl+o0+DSMs4a1m4L7OGzlaSbzCsRObHGTyZMs21Ef/pPzfCRurJgpeFIS3rZlJ
         XOXmRGFeV3KjKQ17bAhNZjTMm1XILs/1expgwAe5Ul3kVZ8PC2p2W6J+SjPTPtvb+LAN
         UPZxXQzENkzm2AwvhtME8L1LuStQ1BlCr5i3muczQv9KizvZy8Dx848BsRLIMZKX6tzr
         n+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EJQEr0g4sEmPtojP4+ShTRIPMlj7/5Kt5ctaIgSd5Vk=;
        b=Cq/u9Z+KQHPvFRqkvywaKnDnCGBzDU715Z0IzDj9jbFoLl9Afr0eB/ztJWnkQqsQkJ
         JPVnBLPMP80IcmCEey65f3CQoXT37Mk+kPxHvc5BtbzkEyvaUrQAXnmWNkKvyjGqLfQn
         6oZD51x1lxtsZioFZqMWUiQZ3JWzMcQunVXWUmlts+2vS+EpXHfxA7D5lA7SyWk/LN6t
         /4/52bsSFncNN/5Vz/sDN64ldMwCbaJyu6Ew5Tp+i0K9EA3JZyAbHxzhFCOyDOW3zxCp
         iXftKNM/QsQMkN89f9dU9+bNtOyAPynzWkINQHgasINS4zxceB3ZHZEKEyLxv39wAdRE
         ELzg==
X-Gm-Message-State: APjAAAVTUmd+4Zk7DjiRpe3osmvJYTcKUvSm0wgM0605BVqRWdTiYOs9
        9vgFPSaqQC9eDJalmTK70KY=
X-Google-Smtp-Source: APXvYqyHmxNqG8lwvrLoIoqKDRDwC0BjBMEKvSjJVBx4xiOZFKxOQUTNYpfnlpraclqtIeJ4uM+h6Q==
X-Received: by 2002:a65:4c06:: with SMTP id u6mr7543599pgq.412.1576110937554;
        Wed, 11 Dec 2019 16:35:37 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 11sm3023984pfj.130.2019.12.11.16.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 16:35:37 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH v2 0/2] net: stmmac: dwc-qos: ACPI device support
Date:   Tue, 10 Dec 2019 23:11:23 -0800
Message-Id: <20191211071125.15610-1-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

Hi David

Reposting the changes after rebasing since the merge window is open now
as per http://vger.kernel.org/~davem/net-next.html

These two changes are needed to enable ACPI based devices to use stmmac
driver. First patch is to use generic device api (device_*) instead of
device tree based api (of_*). Second patch avoids clock and reset accesses
for Tegra ACPI based devices. ACPI interface will be used to access clock
and reset for Tegra ACPI devices in later patches.

Thanks
Ajay


Ajay Gupta (2):
  net: stmmac: dwc-qos: use generic device api
  net: stmmac: dwc-qos: avoid clk and reset for acpi device

 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 141 ++++++++++--------
 1 file changed, 77 insertions(+), 64 deletions(-)

-- 
2.17.1

