Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8EA154602
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 15:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgBFOYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 09:24:20 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39768 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFOYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 09:24:20 -0500
Received: by mail-pj1-f67.google.com with SMTP id e9so43438pjr.4;
        Thu, 06 Feb 2020 06:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujphz3B+s46aEe7JvGGM1Ne2ZXEsoldLhyDrK7xK9Ko=;
        b=r2fc3qi/9oNBxawfqNV0KXua36nCnXKLMdct8mDNook6eYV55lHztSV5xJ90MWYldf
         GQDjpa2pqjDN/R6JQwv933Zfvw/ePlhJandlvdwup1MujP/V4rd0jVWQErbPOdC/xghr
         IXDkRz0Qfw2uuZO9HEyg5aOlSMidW2brqKSnkLkFZIeh6dIzQCNCB8ZbPqVqA0s1DS6m
         yKcqYX3Qvo6bdZZmQtrz/tLC/u1qH5MPBtlXeWqx/zXLlLNyZ4zaxTtbPCmqTZMacg1Y
         yMiZypbiuqU+5hShOi+yn7yKlw/zZ3beb2KBtcTgZieAKFb+tvG7XgWGtbvmXtrjgoFD
         vKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujphz3B+s46aEe7JvGGM1Ne2ZXEsoldLhyDrK7xK9Ko=;
        b=TdOjbgvnOonVlcuBLJyd4i76Zw/5sy4mOw6WeR3oJWLg5soGaGLLI3LytxRYB73+sF
         L3vH+woWwjhyvTNnULms3+Z/rbrGFmeCdQ+2f46u6JKAW8dBGQ5+YVypGg8TADVj5qoA
         Miyrw5au0YJP0OF+MDGzjkQ+ZiPpS9pNZ2uEFOZ7jW/vemPL0CN1LRXtj5ylIg7MmMII
         QPXvnm6WAoYYvluL6uRtxa0kLogQoaSFcD20+gexPNossdHVkoDcnWoKYhn8FL3brdIz
         KD5Arhc+cBTafEJ/bmkvYpzCrZU1V8Ci5iM2mMiXEQZ+1jCp7rZthtSudTXj66oahr6X
         W2mw==
X-Gm-Message-State: APjAAAVuTOiGKUQoR1xo3uJzd0T6V3pOQp40AJAwILz8vJ6mBnPKmPos
        Y/Tx5iMehurFyXPMdtn1hkAQ65Yn
X-Google-Smtp-Source: APXvYqy8U1nUa1UlxJnp4Ytp6VfhI1JzoIDrTHA7gjaGrxTdicYH6ucP96q5P+GGXmwsw8HEJLwNKA==
X-Received: by 2002:a17:90a:7784:: with SMTP id v4mr4688042pjk.134.1580999059559;
        Thu, 06 Feb 2020 06:24:19 -0800 (PST)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id q66sm3942259pfq.27.2020.02.06.06.24.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Feb 2020 06:24:19 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org
Cc:     linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH 0/2]  use readl_poll_timeout() function
Date:   Thu,  6 Feb 2020 22:24:02 +0800
Message-Id: <20200206142404.24980-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series just for use readl_poll_timeout() function
to replace the open coded handling of use readl_poll_timeout()
in the stmmac driver. There are two modification positions,
the one in the init_systime() function and the other in the
dwmac4_dma_reset() function.

Dejin Zheng (2):
  net: stmmac: use readl_poll_timeout() function in init_systime()
  net: stmmac: use readl_poll_timeout() function in dwmac4_dma_reset()

 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   | 14 ++++++--------
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 14 ++++++--------
 2 files changed, 12 insertions(+), 16 deletions(-)

-- 
2.25.0

