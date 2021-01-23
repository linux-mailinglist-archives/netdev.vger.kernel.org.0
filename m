Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6583301743
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 18:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbhAWRdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 12:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbhAWRdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 12:33:18 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B2DC06174A;
        Sat, 23 Jan 2021 09:32:38 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id n6so10259361edt.10;
        Sat, 23 Jan 2021 09:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FdwjG+/goCAlHzUdu2se/N1hjJwHSvoGioV6fhKxFvw=;
        b=TquSW4rasw3h0DG7ldt2v9LIDMEVP7FnVrKmY3JpW2l7cGIrL0fZzLIFdL9tmn1r0b
         ea/15STiQI1/TFkSxFDfgvwJSwaZ9G3HqM6BersUYj2UC+C7Cn3s3Ypq0GvFdrJuIVbo
         6jfKcIml1jMR8nKWwWRJ0tWU5MZ/StD786IUjDd4jm/JM2tPAE83lRxHHVqxHJBck709
         ArIDCQJ0IHqc62GRXZcLa/TfNqZu2Gjdubps0y+IfPXUzzIppyI4xFzuuAXd79aLopRZ
         dXS1ypJr7vbeANpPHPN7WSsJD6lHWXoHxsXfk080dWOLb7uL8CLFGSL9nTTWTp2OGgQF
         6oCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=FdwjG+/goCAlHzUdu2se/N1hjJwHSvoGioV6fhKxFvw=;
        b=TsObhYcKsRa9v8g6cV2AW3UKh1KXCLneoG/aaJo7o6dEqupep/PLd4aBf5mcc9oCwO
         ThkO21mdMVPcQld6YGGedAxw7JFjgkAg65cTdZO/PcATZXFRyGW2v+jHm9ChezgalCaw
         5RMK02FXWXOCzmOUv+cT17CihIHp9CxhHZTgDY+ejaopGTpenUOjwmX7kTH6BIEsRFlG
         Td+sgpFhWg9YX+ksjjzzGTtfOoxPfpLDNwdO4nMEYQ4EB1amDioHX4G6yOUuK+exkXy1
         8H1qtT2wPwppGrrcAIor8eMfh4C8rAeRHyAMLdV8dJtkLT2T3MMrgZnV646w0WloFq9Y
         5sbA==
X-Gm-Message-State: AOAM530uJAWi3zRYJUwszo0yBHTXz7+yLaNgEt2hc/UXnid2Gasr/hKB
        ytukYtvpwP85XasyQZr0zpEh0PF0qcM=
X-Google-Smtp-Source: ABdhPJzDHazHz5O841+SNuHM1hVyNdm45DFR1cYgZRSyYN8o2W8+26jQRKYUeBvRUS1WXxuFiqH/fA==
X-Received: by 2002:a05:6402:220e:: with SMTP id cq14mr1685198edb.240.1611423157054;
        Sat, 23 Jan 2021 09:32:37 -0800 (PST)
Received: from stitch.. ([2a01:4262:1ab:c:de4:866f:76c3:151d])
        by smtp.gmail.com with ESMTPSA id e19sm7528116eds.79.2021.01.23.09.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 09:32:36 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <esmil@mailme.dk>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] net: usbnet: convert to new tasklet API
Date:   Sat, 23 Jan 2021 18:32:19 +0100
Message-Id: <20210123173221.5855-1-esmil@mailme.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

This converts the usbnet driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

It is split into two commits for ease of reviewing.

Emil Renner Berthing (2):
  net: usbnet: use tasklet_init
  net: usbnet: use new tasklet API

 drivers/net/usb/usbnet.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

-- 
2.30.0

