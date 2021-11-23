Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4D6459A51
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhKWDCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 22:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhKWDCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 22:02:38 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC1DC061574;
        Mon, 22 Nov 2021 18:59:29 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y13so85459274edd.13;
        Mon, 22 Nov 2021 18:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3UcVmjOkaeq0kNvjI1cDnssGFTNyiUyhvOYLRToYdaE=;
        b=owdpgktlSNW8nnzNdfLwurN3pQogxXisHj8TMBvuu2+kSSSpw1KzsxG4DuHlyCLbSp
         rsGDbgCZA0Jxa0I0KauSV+1pTJ2eVnjIsasoBHw/Q9ZJ7DOP0cQPuD8pht7b0dFYRtNw
         ofaD5YTNAjG/E1h/VjNZxU7Hz4GHOntdfjSZA7b2xwC1gWw/kf37SYuY7mCzYQasx394
         JpIrh/JqKnsEYFyww2zldGKwdB1EiBxmDiBID/7GvXMfcv2ERHw5IQ1Ga87Zgg4oq6Y+
         CY/imCPSXVBx1UjzwfE3PlPD1TDlP36zmzl1MyqNl2f08GZgB/hMEFsQEulajX2X1SkS
         LXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3UcVmjOkaeq0kNvjI1cDnssGFTNyiUyhvOYLRToYdaE=;
        b=YXkrB1QrbnXAvRDB28A7dDTjZhQgzbrwH+HL2QYH6E9EzrbS6EWprC1q5OCLQe0Ya1
         bs860SoUY2u/WvsZwUkT4GOg52XKuuDJk3Ad8CZ9+k1WTjMI2gUKCH2zE4iMFegPm3Jm
         ijxurCvgXRY/5XlRz5GBrbc0hqPe8BzWSwoewcex/s3Jq04496Z6pPMt+Ydrj14uTE+M
         RpSRZBck/gPH410YGkmktxpxASOjri5kyInGTFnbu5tayNDyDWPKV+NdKEx7zBJk/AH9
         BAbE/L97Bg/9jABEuU4fFHcaTKJ7pG+XdqGDISw5e0nNLneYww9NHMq18Mkl0LeY4ifF
         GbQA==
X-Gm-Message-State: AOAM533Ywy0c/CKs6CTFziUIJlbCHDYhFKsHX4Lrky6b/wkCOXwd0dwa
        SqMpDbRESJCfmcrm8erB1/M=
X-Google-Smtp-Source: ABdhPJzJ4jdNGVsSRdBtQpJUfMqUvmt2jjvwFC+VL4EaHrnWwjc2nRQwvq+ygrmxZ8oBY2Sxz8RM6w==
X-Received: by 2002:a17:907:7f0f:: with SMTP id qf15mr3189014ejc.560.1637636368048;
        Mon, 22 Nov 2021 18:59:28 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id dy4sm4870718edb.92.2021.11.22.18.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 18:59:27 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 0/2] Add mirror and LAG support to qca8k
Date:   Tue, 23 Nov 2021 03:59:09 +0100
Message-Id: <20211123025911.20987-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the continue of adding 'Multiple feature to qca8k'

The switch supports mirror mode and LAG.
In mirror mode a port is set as mirror and other port are configured
to both igress or egress mode. With no port configured for mirror,
the mirror port is disabled and reverted to normal port.

The switch supports max 4 LAG with 4 different member max.
Current supported mode is Hash mode in both L2 or L2+3 mode.
There is a problematic implementation for the hash mode where
with multiple LAG configured, someone has to remove them to
change the hash mode as it's global.
When a member of the LAG is disconnected, the traffic is redirected
to the other port.

Some warning are present from checkpatch but can't really be fixed
as it would result in making the regs less readable.
(They really did their best with the LAG reg logic and complexity)

Ansuel Smith (2):
  net: dsa: qca8k: add support for mirror mode
  net: dsa: qca8k: add LAG support

 drivers/net/dsa/qca8k.c | 272 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  37 ++++++
 2 files changed, 309 insertions(+)

-- 
2.32.0

