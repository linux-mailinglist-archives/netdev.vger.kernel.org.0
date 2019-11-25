Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CCC10954C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 22:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfKYV4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 16:56:02 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46459 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKYV4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 16:56:02 -0500
Received: by mail-pl1-f194.google.com with SMTP id k20so2644317pll.13
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 13:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7jqHl6x4pjL/HzfIg3K7Ztaqz6uuG1gLLVRGuSbKjWI=;
        b=LfPjhwGXZHj6UdgcClnrCdlKMTlHJ4oBh7P3EJJWEslidgW4TrnKjw2xKM1PvdzV5K
         zP+S3Ew0PFnyi0Fj9AtDsVx0g6yd+yZIGPnQ+1vJqb3mLfQoJ9Qz7szAineic/Df0gup
         e27K42v/HTrj43bAL4Ef3GtS7AOu0k4oJTRAJIzz+MhQXu9jrGreGYwK4VuvlozKCnKJ
         tjjvrVH2+oqsDrGKgJOUUJIHzgZyN14D0fUiHrvDu1CEhKrkUGsxtUjUBRz2mKTA46y4
         RLtF4qyY/y1/zmN1uORF5mCxldsUgsWETYVI05ttrVeH7FYvTOy6ZaAHLV4iEL9XFDwx
         /kAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7jqHl6x4pjL/HzfIg3K7Ztaqz6uuG1gLLVRGuSbKjWI=;
        b=eTBnKzwT4Rls+Bm2t9JyFVLZj7NOA5/JWunU2799g9SqOZHD0iOUVoYlbqMjIjPMGh
         1zEcgeI40b58yWhMDtGsq/GuZgxEKNw5n96DSdrftQGHFjU9uDhbqbS1SsDf53h21zLV
         l+tjJeWBHI1pNeg3tAcMTVrtLk0WeHHBlYlPXFe+R7em2S6qbKnmWnEuhRwp30PzAQVx
         nzVor0/cJjip7r/4p1pkguccEkfbaTy0nCtLhTBgBAQImH4+rfrPZoEN/fO297UWHi/0
         hVrv4tPPoFeCRN080CePKIf0aB+vescvzzu+cgVJvJ+zmUjQO+ct1l3HbMMPrXRGoGWh
         yCYQ==
X-Gm-Message-State: APjAAAUgFTFC8jaK0JVf/2GBZurfzfc9CSTD3Uosx+aHdEYN4yMCbgMz
        H/55+czzUXcZJP0FEozbZ7/Mquhq
X-Google-Smtp-Source: APXvYqwRVtdUSF0/8smU/RSsJAHynpa5a8gBWDfWLAdLdYWW4sHCGAllexv5xQQI9+RQujGco3w8uA==
X-Received: by 2002:a17:902:7b88:: with SMTP id w8mr30705361pll.205.1574718960114;
        Mon, 25 Nov 2019 13:56:00 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id y12sm366567pjy.0.2019.11.25.13.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 13:55:58 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH 0/2] net: stmmac: dwc-qos: ACPI device support 
Date:   Mon, 25 Nov 2019 13:51:13 -0800
Message-Id: <20191125215115.12981-1-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

Hi David

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

