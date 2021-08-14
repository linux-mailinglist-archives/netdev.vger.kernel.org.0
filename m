Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD9B3EC234
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbhHNLEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbhHNLD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:03:59 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C119C061764;
        Sat, 14 Aug 2021 04:03:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n12so19151518edx.8;
        Sat, 14 Aug 2021 04:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ew8zkLnn7LDJ3G3mug2qgb6I6ZSVcE5YleahMWZh1bc=;
        b=mGmvsYMnIK2O+rI4LtKwOSGjN1ggQb8WZkCAnpdM1JWZfeI5xQemYzN3fF1RwnlZI2
         tAKNtTQdJ9tqRyTUb0rXaDBVg//qJl753pqI2kDmfGzsqZfCyS/ECA8s6181o6egIdSr
         U8bTHTUkM4oXbhyei5kwXHPqiBLWc/rX3bsT68I0nCYLYpGUcRccL9f73Od0hR5Ki1Bi
         LkKkZE6Al09Va2VpY5NBkVqEQ0ek/3dc8sc6uHN4g19API5Vu3mvTKko7zJtCLq1KfeF
         y2phn5ITuE+qDE4oYbk9P7Uv3Ltu/EXBdUjujz5Xu/DUyQVnR3X6yH9xQonh5JqGs2/Z
         m0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ew8zkLnn7LDJ3G3mug2qgb6I6ZSVcE5YleahMWZh1bc=;
        b=MwOHgKZZOcaoF6xZM4ZbnzH57SWiJfa1mPHviB2PkSQUXZsvbWCboEGlUc7EYdTgcX
         vkbstCrParestjec18h7m//bfoyi3ajKjJEqG6SB6YH8e8mqhsDTB+r211UwIEXuxXUW
         v82udvY9SWoybT3BQ95Vf7nGbd68GGW2hmks+0ZupW+hn5iiWFuTCaDEOkyGQEQhdCKq
         v/5bJjg4XPefnj7psL7Ur639xEHy6AwBGgR+V4+XO4pJgOLYuQwDh+nVOvi7+GGZ6WUB
         Uw8nJ1Jjp8iZXHN6IQ55vBaCT9hugtSTGMqdeJ14JiSVoXM+2q92cBAnTeXGLZLjzz/J
         YaBw==
X-Gm-Message-State: AOAM531pXC4uNZI+qXcQbvsbFPBOPxmn9zsqirJyaHvcClMPuD8paWRQ
        4v/VlZU6JL9/71OsQ7HLRXg=
X-Google-Smtp-Source: ABdhPJzxJO/dwOjj4AgPAPgxWYRCFUHH1peMRGZdr3DfLSDskXukeW2N+VoSWAB7/cp0Co8o3J95nA==
X-Received: by 2002:aa7:da52:: with SMTP id w18mr8626508eds.48.1628939009922;
        Sat, 14 Aug 2021 04:03:29 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id cz17sm2123959edb.36.2021.08.14.04.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:03:29 -0700 (PDT)
Date:   Sat, 14 Aug 2021 14:03:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 02/10] net: mdio: mscc-miim: convert to a
 regmap implementation
Message-ID: <20210814110328.7fff5z4hdhnju3pd@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210814025003.2449143-3-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 07:49:55PM -0700, Colin Foster wrote:
> Utilize regmap instead of __iomem to perform indirect mdio access. This
> will allow for custom regmaps to be used by way of the mscc_miim_setup
> function.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

git b4 20210814025003.2449143-1-colin.foster@in-advantage.com
Looking up https://lore.kernel.org/r/20210814025003.2449143-1-colin.foster%40in-advantage.com
Grabbing thread from lore.kernel.org/linux-devicetree/20210814025003.2449143-1-colin.foster%40in-advantage.com/t.mbox.gz
Analyzing 11 messages in the thread
Checking attestation on all messages, may take a moment...
---
  ✓ [PATCH RFC v3 1/10] net: dsa: ocelot: remove unnecessary pci_bar variables
  ✓ [PATCH RFC v3 2/10] net: mdio: mscc-miim: convert to a regmap implementation
  ✓ [PATCH RFC v3 3/10] net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect mdio access
  ✓ [PATCH RFC v3 4/10] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
  ✓ [PATCH RFC v3 5/10] net: dsa: ocelot: felix: add interface for custom regmaps
  ✓ [PATCH RFC v3 6/10] net: mscc: ocelot: split register definitions to a separate file
  ✓ [PATCH RFC v3 7/10] net: mscc: ocelot: expose ocelot wm functions
  ✓ [PATCH RFC v3 8/10] net: mscc: ocelot: felix: add ability to enable a CPU / NPI port
  ✓ [PATCH RFC v3 9/10] net: dsa: ocelot: felix: add support for VSC75XX control over SPI
  ✓ [PATCH RFC v3 10/10] docs: devicetree: add documentation for the VSC7512 SPI device
  ---
  ✓ Signed: DKIM/inadvantage.onmicrosoft.com (From: colin.foster@in-advantage.com)
---
Total patches: 10
---
 Link: https://lore.kernel.org/r/20210814025003.2449143-1-colin.foster@in-advantage.com
 Base: not found
Applying: net: dsa: ocelot: remove unnecessary pci_bar variables
Applying: net: mdio: mscc-miim: convert to a regmap implementation
Using index info to reconstruct a base tree...
M       drivers/net/mdio/mdio-mscc-miim.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/mdio/mdio-mscc-miim.c
CONFLICT (content): Merge conflict in drivers/net/mdio/mdio-mscc-miim.c
error: Failed to merge in the changes.
Patch failed at 0002 net: mdio: mscc-miim: convert to a regmap implementation
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
