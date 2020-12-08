Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEE22D2CAE
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgLHOLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbgLHOLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:11:01 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449AFC061749;
        Tue,  8 Dec 2020 06:10:36 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b26so14001341pfi.3;
        Tue, 08 Dec 2020 06:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=y+TsitjoIH7JH9XtdYcvo6WGHGk7yTErwwqWOT90yJs=;
        b=LH/JS4D0m7XlgPj3AwO9UpQ1nBJ/6Y0MA41PnlSZPWYKJ+j1uaoXlRkPA9CA9YHTUn
         wRe3Bff37TfY2yeNz8U7FtlmjKhLsJYIlbU6o/lTo4aqYAoIVT/pXOQDz5QwtgsJmg9M
         HxFVv4Elma9ml2rgvM5SSSo0wj8CQ5dZH86Hg7UUKqldAbxXrmDSlHYJltie83X3Bimc
         MpZ0c3dqqKtsYIm9AV6i68iGtrY1IxT3cwUhMNWFmfpyTVso3Ttto/WoBdEvwBDm6JiA
         RHIRuoFvQStBC0dlGbzk63MDjUbRc2Lyv6IdC7ljcW/9e732f+LgnXr7grkoFxy2faeo
         9QIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y+TsitjoIH7JH9XtdYcvo6WGHGk7yTErwwqWOT90yJs=;
        b=ZYMkD8WgjXbmoYXY+2XXtym251AGR+sz5TqPfScO+CJzUoTBPP/c7dOnmyoMegKK9Y
         ggW90vlUJ1N8l89mKH/b07q3u8FhCgMP/bFJH9If+Urz103HDoVTM7elUAIyfSicHp1g
         SydPutVIei9OfPnMI5I55ZILrHV+Alz/hpkkz+HF4ji/kPj6Dy8j86FxNc9OZlyjSrIQ
         crazW9dWwHTrqYz6OJ1Y7CDienXbhjVpV1Px/r+U3BBemVLJ/CPutc01PsoaqvI2bizk
         JasrzJVnxE/7l0r7vgFQ6f8pxC3uyKqEE0AXlpfgC9q5g5szR6twFFoI/mtjVId2tBck
         QM0g==
X-Gm-Message-State: AOAM533K4bgV3GCYmJkG7ojTy3rKgUcP4rtZxr9p9eYJvNqI2VzblrYA
        m2+I6WYNRwHmdm4bm+COaAI=
X-Google-Smtp-Source: ABdhPJzxMAj44XvY1JnbcrdV2ne9K3OSDAYvDMV0QTQMPNVlGHzRrlDWcsvhB82njiBXQIZKz6NAAg==
X-Received: by 2002:a65:594b:: with SMTP id g11mr22767467pgu.424.1607436635756;
        Tue, 08 Dec 2020 06:10:35 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id m15sm9071951pfa.72.2020.12.08.06.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 06:10:34 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 0/2] nfc: s3fwrn5: Change I2C interrupt trigger to EDGE_RISING
Date:   Tue,  8 Dec 2020 23:10:10 +0900
Message-Id: <20201208141012.6033-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

For stable Samsung's I2C interrupt handling, I changed the interrupt 
trigger from IRQ_TYPE_LEVEL_HIGH to IRQ_TYPE_EDGE_RISING and removed 
the hard coded interrupt trigger type in the i2c module for the flexible 
control.

1/2 is the changed dt binding for the edge rising trigger.
2/2 is to remove the hard coded interrupt trigger type in the i2c module.

ChangeLog:
 v2:
  2/2
   - remove the hard coded interrupt trigger type.

Bongsu Jeon (2):
  dt-bindings: net: nfc: s3fwrn5: Change I2C interrupt trigger to
    EDGE_RISING
  nfc: s3fwrn5: Remove hard coded interrupt trigger type from the i2c
    module

 .../devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml      | 2 +-
 drivers/nfc/s3fwrn5/i2c.c                                 | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.17.1

