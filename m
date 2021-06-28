Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E323B6921
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhF1Tdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 15:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbhF1Tdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 15:33:38 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D273FC061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 12:31:10 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id b2so2563682qka.7
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 12:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x64architecture.com; s=x64;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r5M2GtCdyWVHpdPTGmNoigWQRvUhgbWJWC6QquVhxlA=;
        b=qwuMyjUp8zlnw5vN+WuMTXVWaS+69jKxNgI4AULhLzs+xYbG8PPku73+WnAvVWK5QG
         mHTpxxx8sYaZi+OYUQva0LpKSizjhPyp8krYlNDnDhUoAu2+PCHLv4IQ0zo/G0DkP+2m
         qFRoSKOmJ/8wIp+Ytl/cLyHEe7a3oPou+ucH99pcRkFzFnF4XoOpL/dzuO1PXWSd7q/f
         gysrQDLj48M4DYnhU65R4dAXUuYXc3L/wbkcwipbqQwBnTQSWiDrpx8o4qjLXXkOCdWY
         dpiGh3z3XcwMng1we1opTQCrnS4Ic7WnUpds0z2FO2l36dmO8UcKUzeBQ+r2Ovghv/ws
         ES1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r5M2GtCdyWVHpdPTGmNoigWQRvUhgbWJWC6QquVhxlA=;
        b=mf6OrXzXGqdd8YeqHsCKuidui1m5WfEwA/p2JZlpZVRft6UqRJI2jjk5KySK2emP4g
         jyXm4heuXRjrhbGYGdfM0ge5GXQxJTta/03U9lfDuotfxS9XN/Bx+123FLpJwCt/Wx10
         B5B6AZHjNHHDqOjv19UqyN0k2w5NqSgNleryvJib9YCfcgzgJkTnpvCH38TAe+dhQ4t1
         KMulLHCekGwGqFuSxRvNcciMly15e3F5ht99iy30lbsmUl36aT3Fb0PB2aLYzvXtWClX
         3GuM62CXxP2Wr4gVGF/RIFdiMoIiZklNElff1hrHZL4Yc5f1nur55rUn6RJET6QVNSZz
         nM4Q==
X-Gm-Message-State: AOAM5337UyaVrtOHzpFwomnIf76A/fHj6716TmOp8Rfd00vIGsLX9VwH
        QZLWuzlSZ8qtP9tlijZgyukk0Rkx4umy9pFS
X-Google-Smtp-Source: ABdhPJwnCwstKPguwu+4vHWetfZf006IHocDJZzbadNlsgGQZ+XscRUNYKGiKD/A//OxwdtOg+cKmw==
X-Received: by 2002:a37:468b:: with SMTP id t133mr27431065qka.244.1624908669958;
        Mon, 28 Jun 2021 12:31:09 -0700 (PDT)
Received: from kcancemi-arch.Engineering.com ([167.206.126.218])
        by smtp.gmail.com with ESMTPSA id c4sm4011866qtv.81.2021.06.28.12.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 12:31:09 -0700 (PDT)
From:   Kurt Cancemi <kurt@x64architecture.com>
To:     netdev@vger.kernel.org
Cc:     Kurt Cancemi <kurt@x64architecture.com>
Subject: [PATCH 0/1] Possible Issue Setting the Delay Flags in the Marvell Net PHY Driver
Date:   Mon, 28 Jun 2021 15:28:25 -0400
Message-Id: <20210628192826.1855132-1-kurt@x64architecture.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I believe there is an issue setting the RX and TX delay flags in the Marvell
net PHY driver. This patch fixes the issue for me but I am not convinced that
this is the right way to fix the issue or that this patch will not cause side
effects for other models. Feedback and comments are greatly appreciated.

Backstory:

I have been troubleshooting getting ethernet to work on a board based off of
the NXP T2080RDB (with DPAA ethernet). It has a Marvell 88E1510 PHY chip.
When attempting to use ping to verify that the ethernet was working I was
only getting RX and TX errors. Upon further debugging I discovered that the
RX and TX delay flags were not being set.

I believe there is an issue because of the following:

* The DPAA memac driver correctly reports that the device tree ethernet
  "phy-connection-type" is set to "rgmii-id" and the of_get_phy_mode()
  function correctly returns 0x8 "PHY_INTERFACE_MODE_RGMII_ID"

* A similar fix for this same issue was incorporated into U-Boot back in 2018:
  https://github.com/u-boot/u-boot/commit/431be621c6cbc72efd1d45fa36686a682cbb470a

* The ethernet works with the attached patch.

Kurt

Kurt Cancemi (1):
  net: phy: marvell: Fixed handing of delays with plain RGMII interface

 drivers/net/phy/marvell.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.32.0

