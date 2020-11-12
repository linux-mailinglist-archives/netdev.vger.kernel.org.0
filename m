Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522AB2B0625
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgKLNUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLNUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:20:04 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D93C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:04 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a3so5474468wmb.5
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eMLK5wFM3ylLU00PJbRy+Dts0K2HhGy+/Yk3kcCr//I=;
        b=YGVtNKo+kKiaY6XJvBFtbaP8sFavkFFVBUBsegmYbjw8a+sYjC+4ONrRWozIwu8S1c
         zGMPeTeod0GBn++IiBgp3GwY3MolP4bntUVy8sAKCVgIzEEHImGBR+Oi5fcxorwZ7qlb
         iYDJ5V3MSDrK3zATgtfPQcDD6KBN6SutlkzmEsPJleMjm1hGdYuLQ1jTkUvqbNbM1l5G
         Tk0IFKdcKZLSY32AAXOIhaZhbrRFdEe0tWS+XiZjPKCtC4h5/+5c0YXhbU4Jdwt8xS0F
         lIvsl1rfWXBQYFsDWO26/0RFTEU3Cc5K/7ZiqhuGuIjRVL10I+a2TbO1+Y+W/I365Vf6
         C0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eMLK5wFM3ylLU00PJbRy+Dts0K2HhGy+/Yk3kcCr//I=;
        b=gUgPxvKxxHIyXu4kfPO7qkXuF38wtz9GxLMPrkMQFMt73k+qqIVYV6QZzJwFiVsjP5
         yQwUOcXYYt9oJrYcASgPoLZMC24CzbY+HvMPf4MaRJpj6UqQsUPOkTJPvalKw4RxawOp
         C4u7SK7O1+XTdPxxXXZppDHmNdMO1hpPkuPSqW0Gw1AZ7Pc7uHiz7NgJ7beorXiE9GoH
         6fO6ZbhGnZPsO4WYpUX5kDvi5m4lHXwHuQYTJ/0V5cJUDkue30OGAskNxf5cE6x3bHDg
         ZhM5earzO0fHkE+G0jJXOFScOzzjE33RYO6+QJ3ec/R9PGUuL4JCibQuwm1pCj8vpMqe
         J2bA==
X-Gm-Message-State: AOAM531JXCuI+kKoRr3bql3qrK1Fx6NpQFlVC+gR6f5zMYIIjLsQlEtr
        cF9QMRNgggc5dzdws3aFGJDAbg==
X-Google-Smtp-Source: ABdhPJypUJzBSf/UrRpXCaxMahDxGMlGNloxollAPMhwxtws4wXdGnm+IatNgsfEO+UfZfcWDSDYPA==
X-Received: by 2002:a7b:c05a:: with SMTP id u26mr10154380wmc.159.1605187202922;
        Thu, 12 Nov 2020 05:20:02 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id t136sm2806326wmt.18.2020.11.12.05.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:20:02 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devel@driverdev.osuosl.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-wimax@intel.com,
        netdev@vger.kernel.org, Yanir Lubetkin <yanirx.lubetkin@intel.com>
Subject: [PATCH 0/6] Rid i2400m driver set of W=1 issues
Date:   Thu, 12 Nov 2020 13:19:53 +0000
Message-Id: <20201112131959.2213841-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

This is a rebased set that went to Net before the move to Staging.

Lee Jones (6):
  staging: net: wimax: i2400m: control: Fix some misspellings in
    i2400m_set_init_config()'s docs
  staging: net: wimax: i2400m: driver: Demote some non-conformant
    kernel-docs, fix others
  staging: net: wimax: i2400m: fw: Fix some function header
    misdemeanours
  staging: net: wimax: i2400m: netdev: Demote non-conformant function
    header
  staging: net: wimax: i2400m: tx: Fix a few kernel-doc misdemeanours
  staging: net: wimax: i2400m: fw: Fix incorrectly spelt function
    parameter in documentation

 drivers/staging/wimax/i2400m/control.c |  4 ++--
 drivers/staging/wimax/i2400m/driver.c  |  9 +++++----
 drivers/staging/wimax/i2400m/fw.c      | 14 +++++++++++---
 drivers/staging/wimax/i2400m/netdev.c  |  2 +-
 drivers/staging/wimax/i2400m/tx.c      |  6 +++++-
 5 files changed, 24 insertions(+), 11 deletions(-)

Cc: "David S. Miller" <davem@davemloft.net>
Cc: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wimax@intel.com
Cc: netdev@vger.kernel.org
Cc: Yanir Lubetkin <yanirx.lubetkin@intel.com>
-- 
2.25.1

