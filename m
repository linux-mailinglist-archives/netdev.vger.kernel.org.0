Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13DE49CF1F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbiAZQFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiAZQFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:05:51 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71FDC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:50 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id z7so307772ljj.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=O3M2HIt8kQOpxv5zJgKH4XNzJrbMA91/nYpXH0vUpCs=;
        b=G0RkjZOAZ9y2aiTlJOok460ne4oNGR+8EeKPUUyz46Rs9dr6FTUF85oYFZpU8r+wEI
         Rt0NgLJESU7nK8jSgy7si+Ei/iNbmedRQOFfeePvd7pVhyR090cUxIMK0ugfpw5CKt5+
         rZyLis5z7edIUejWXAPpRN7qcpPE8jcqPsZqhxeUOJG4FtgGkfrMhXTo2jk3LsM/3SQU
         UVtRmYlwVdSoGlGkXHqyY+9T28uf9Gp8Ge7KygGDIqc+RdxaD8G80muqSP/50ZPOenIi
         NTE+C81hxguweFiKvT00JGKKPAZQ25SPkGMoro3XscnmOgpMpl3/d9cXL8RZcNI1Vp/0
         TQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=O3M2HIt8kQOpxv5zJgKH4XNzJrbMA91/nYpXH0vUpCs=;
        b=unhEzPPje8+dgY82MI2fBsofgJZxvB0QV7Tk7kZIeIXo0xdWbJQBddxMQhJJMXXcK5
         gTZ6KXZb6sa2g0VKj5FjY1pSq9IX8sA+mU1d1Skc21Kr0MRQ7OuqCCtYyKBtlZnRMFGC
         nH8D3PG/n9sKll8YOs5ZEqrYHWmd17QxQmNt5xU5HB2piBLpodPSLUmS8ter7pthtN2m
         ox0TJHv84t5K+mfCI7DpxUDs9Wa22lrbrdKvJRlxdUjGu7mVSU5kN6lF/HyQpbAMxFFN
         AgokLw1FAB0TLyzShyr8PHx9SUdp70BwrPeF1EnBw4KGUA4cjdE1YugDbDuLeDBZo1ox
         0bTw==
X-Gm-Message-State: AOAM533sJE6lsAkwDXayLS3DAc6vuvgvlkjrS8IdqXcO/S0VD/oMDP7B
        3NmhLGtYrZJeuF32cQHSE+e+Ntw+cdMF3w==
X-Google-Smtp-Source: ABdhPJyaRsXJy3uTg7y6R7QdLN6DHFXsg9JqmwRfRo6L32ZnpoqaWc63qipX5AKnaLcGNB0b9eR8hQ==
X-Received: by 2002:a05:651c:1543:: with SMTP id y3mr5401321ljp.381.1643213149160;
        Wed, 26 Jan 2022 08:05:49 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p6sm1869984lfa.241.2022.01.26.08.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:05:48 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/5] net/fsl: xgmac_mdio: Preamble suppression and custom MDC frequencies
Date:   Wed, 26 Jan 2022 17:05:38 +0100
Message-Id: <20220126160544.1179489-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch removes the docs for a binding that has never been
supported by the driver as far as I can see. This is a bit of a
mystery to me, maybe Freescale/NXP had/has support for it in an
internal version?

We then start working on the xgmac_mdio driver, converting the driver
to exclusively use managed resources, thereby simplifying the error
paths. Suggested by Andrew.

Preamble suppression is then added, followed by MDC frequency
customization. Neither code will change any bits if the corresponding
dt properties are not specified, so as to not trample on any setup
done by the bootloader, which boards might have relied on up to now.

Finally, we document the new bindings.

Tested on a T1023 based board.

v1 -> v2:
 - Whitespace (Andrew)
 - Fail the probe if a custom frequency has been set, but can not be
   applied. I.e. the input clock is missing or the frequency is out of
   range (Andrew)

Tobias Waldekranz (5):
  dt-bindings: net: xgmac_mdio: Remove unsupported "bus-frequency"
  net/fsl: xgmac_mdio: Use managed device resources
  net/fsl: xgmac_mdio: Support preamble suppression
  net/fsl: xgmac_mdio: Support setting the MDC frequency
  dt-bindings: net: xgmac_mdio: Add "clock-frequency" and
    "suppress-preamble"

 .../devicetree/bindings/net/fsl-fman.txt      | 22 +++--
 drivers/net/ethernet/freescale/xgmac_mdio.c   | 91 +++++++++++++------
 2 files changed, 77 insertions(+), 36 deletions(-)

-- 
2.25.1

