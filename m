Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F9F3AA3E3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhFPTK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhFPTK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:10:28 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30246C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:22 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id a1so5909253lfr.12
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CavZCGRLoXvrDbj2owetgbHtF92bmqVvemLNa5eyb70=;
        b=B2UF53JPjL6gYUiFPakB2njYwlv8sdi901/X4Nj9Luo8S/kjkbfXEaruWGQM8CMtNO
         gSijOmTrBc4z1qX/cIhERH69HvYX10JSJ/rGyY27h7VRT5kt1X+yN/psuVZnmid1EAd9
         fesv+QiEtEvWxzFW7PzKYragp6//a9dBo9Ldj4W0W84AqPHi01Y00NKo6y84M5eH+tYo
         mAvm70UKBqwFunhPnwKndaXjTZAJ3BDHVwfR3UXMlPpqk+lRdXPFaUv8hc+4ZXaLZvUH
         3cuErd7FAph/xyecADxUCOQIrzIaTn6/lJvtKj/0FTXs9ZSzcwM41MoXnwftX3CBW3sZ
         dk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CavZCGRLoXvrDbj2owetgbHtF92bmqVvemLNa5eyb70=;
        b=EtvhzrAFGIQS3jOYI3i2np00YkTozgasE8MbSYVOojMV3Y2eVR9Li6HEbh2fS5wVK6
         xU9XIhRptcqwCHW/HEOiaZp7ceb5Ny/KujqlKceJ2IOC5BGLOeavybAPxcNLxouCarqq
         zyWL1sBtcURiHeLNFaIUDf13mfOn7N6tmmTRgYa9mZ1mqT6MuZKo5T6hyL40tkpYZEmd
         H1KRBVEQCGyNytAMfxqMpiwVI+jK5iB3WPyAiDIkk14koF2XU7uGHViFu7U5LmcaKjb6
         x1mvc+Mm/V1MW/YsO7BAej2qHCIiKJ/HdCQDG/11SfTsiZSuugSS7pzQ9xaFizAgK52F
         9ACg==
X-Gm-Message-State: AOAM533IpBlUf3ciJ4tdibUU3vG4y/5u2Q3qebC697KrUKxIK63CdUd0
        jnee6O0RJx8qEI39VRBibeMOtQ==
X-Google-Smtp-Source: ABdhPJxrVjb8+sjTgPNhwvOt8Stre8JI3F6qI6qNlZGwxB3c0vu4rfBLd2SguNV568qUDPWWeJ3Dhw==
X-Received: by 2002:ac2:4e69:: with SMTP id y9mr860737lfs.593.1623870500095;
        Wed, 16 Jun 2021 12:08:20 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id h22sm406939ljl.126.2021.06.16.12.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:08:19 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH v2 0/7] ACPI MDIO support for Marvell controllers
Date:   Wed, 16 Jun 2021 21:07:52 +0200
Message-Id: <20210616190759.2832033-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The second version of the patchset addresses all comments received
during v1 review and introduces a couple of new patches that
were requested.

fwnode_mdiobus_register() helper routine was added and it is used
now by 2 drivers (xgmac_mdio and mvmdio). In the latter a clock
handling was significantly simplified by a switch to
a devm_clk_bulk_get_optional().

Last but not least two additional MAC configuration modes ACPI
desctiption were documented ("managed" and "fixed-link") - they
can be processed by the existing fwnode_ phylink helpers and
comply with the standard _DSD properties and hierarchical
data extension. ACPI Maintainers are therefore added to reviewers' list.

More details can be found in the patches and their commit messages.

As before, the feature was verified with ACPI on MacchiatoBin, CN913x-DB
and Armada 8040 DB (fixed-link handling).
Moreover regression tests were performed (old firmware with updated kernel,
new firmware with old kernel and the operation with DT).

The firmware ACPI description is exposed in the public github branch:
https://github.com/semihalf-wojtas-marcin/edk2-platforms/commits/acpi-mdio-r20210613
There is also MacchiatoBin firmware binary available for testing:
https://drive.google.com/file/d/1eigP_aeM4wYQpEaLAlQzs3IN_w1-kQr0

I'm looking forward to the comments or remarks.

Best regards,
Marcin

Changelog:
v1->v2
* 1/7 - new patch
* 2/7 - new patch
* 3/7 - new patch
* 4/7 - new patch
* 5/7 - remove unnecessary `if (has_acpi_companion())` and rebase onto
        the new clock handling
* 6/7 - remove deprecated comment
* 7/7 - no changes

Marcin Wojtas (7):
  Documentation: ACPI: DSD: describe additional MAC configuration
  net: mdiobus: Introduce fwnode_mdbiobus_register()
  net/fsl: switch to fwnode_mdiobus_register
  net: mvmdio: simplify clock handling
  net: mvmdio: add ACPI support
  net: mvpp2: enable using phylink with ACPI
  net: mvpp2: remove unused 'has_phy' field

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 -
 include/linux/fwnode_mdio.h                     | 12 ++++
 drivers/net/ethernet/freescale/xgmac_mdio.c     | 11 +--
 drivers/net/ethernet/marvell/mvmdio.c           | 75 ++++++++------------
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 23 ++++--
 drivers/net/mdio/fwnode_mdio.c                  | 22 ++++++
 Documentation/firmware-guide/acpi/dsd/phy.rst   | 55 ++++++++++++++
 7 files changed, 138 insertions(+), 63 deletions(-)

-- 
2.29.0

