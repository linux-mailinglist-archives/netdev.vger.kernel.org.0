Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8149A390A85
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 22:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhEYUet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 16:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhEYUes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 16:34:48 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D43C061574;
        Tue, 25 May 2021 13:33:18 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id j184so9752194qkd.6;
        Tue, 25 May 2021 13:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9qilWmNlzfl6fvjkh4Q/jQnzzgBrCqLLxE6DcLSuqOc=;
        b=L1KClaDKIohLYlR385K9XGa5vtqsqHPx+lPVLdwyuv0lsNdRrtqj4ItwdhoEFsztst
         tYYYK7EiBTd0GP4ZXbQxL09h/deNlDP2l88PouUlvLpZiw7gk9A4xXuRIPQ4JjYKvo4T
         Y+9YGiyQ73k9oz+i7CabMC6/+aHk9nLvFAUwP7eN8kjFV1yaYhd6cwpUK0gSBqyCKHnC
         9ogWTf1icOdV0b6/ktfBnDwpbJy/936ACvZjku962tCMRxv1mAQP2JG0Ekd7a9MJSlQp
         D1OSrfrtu42kDVnEMZBobf2ddYjjgXi3CfSN1ZINbyOIS4yFoGM9ge3D4s4vGoIkOfbC
         vBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9qilWmNlzfl6fvjkh4Q/jQnzzgBrCqLLxE6DcLSuqOc=;
        b=HEzI04prn2CB4R2MM9QZerprYKGklGEljLIF7Kd/Z3gyMLDjWpbZ7h9Bj6icf2GvVh
         2cOhTYMSSRD0JxtGA6sH/0Hc4t5nktiPdjef3m1MnuOzBzSeMxiTC6Z1uT2Ui1WZPvce
         MSzKhviNceqZVzeYV4ZVyMFEM0aox0GyTb3A3p3b3RuvBQOPEUUucVASTSbegmtYExat
         8ydz/DEMHKU5PwAKmkFjulQ727BI0xXFcYoZ5FG506t/wWmCp2AtHwrFDkShrLhaqg54
         YSvfb2WaDXTtWtInqCOF8N5GVolWsj8AJB4cjG+Tn9omzWC94zsMGNmW3gQUtEZFJUiD
         EQGA==
X-Gm-Message-State: AOAM530pL9Ktwd/VXeLZIwhF+wHOj7RrzGMt7B2nHB/yifLmH9YcAF9Y
        XeiHIHXIUek+G85wNU4zvSc=
X-Google-Smtp-Source: ABdhPJxb99gzSWh5vAWsadbIhK88O71Uer9ZaNKpD93/HteHpjUwRD2ng4gnN377OcMehun4zvVXNw==
X-Received: by 2002:a37:c4d:: with SMTP id 74mr37056735qkm.264.1621974797856;
        Tue, 25 May 2021 13:33:17 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:a465:c799:7794:b233])
        by smtp.gmail.com with ESMTPSA id g4sm159312qtg.86.2021.05.25.13.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 13:33:17 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH v2 0/2] fixes for yt8511 phy driver
Date:   Tue, 25 May 2021 16:33:12 -0400
Message-Id: <20210525203314.14681-1-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel clang bot caught a few uninitialized variables in the new
Motorcomm driver. While investigating the issue, it was found that the
driver would have unintended effects when used in an unsupported mode.

Fixed the uninitialized ret variable and abort loading the driver in
unsupported modes.

Thank you to the Intel clang bot for catching these.

Changelog:
V2:
- fix variable order
- add Andrew Lunn's reviewed-by tags

Peter Geis (2):
  net: phy: fix yt8511 clang uninitialized variable warning
  net: phy: abort loading yt8511 driver in unsupported modes

 drivers/net/phy/motorcomm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
2.25.1

