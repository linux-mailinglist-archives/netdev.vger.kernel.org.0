Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3B03A5A05
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 20:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhFMShl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 14:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbhFMShk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 14:37:40 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17275C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 11:35:39 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id l4so4432609ljg.0
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 11:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABCZuN3t1TlhXpGL1G5x2Ki4iTUdcfdjekYhFBxIM58=;
        b=BCYjyrvt6+vAHcrfJ4JdKOt7Z7iDGaaiHjupD8+mJIR1FALC6ukaJyPYJv5S/6NtZ8
         xeY3ph1P3kr7MAey6NOYat6yowGQRrDda1+HCn/yYQInYaqwS0Wfi60uolvdqn3bN13a
         eEGcmvuPL5D9Yor8KKc/ZsRA1ArEmDKGz/ZKUOkJdNIMRN1dhekRXY1wF6+ESwmH01xh
         vWeKGOOY1g2Bsldxp3hlwhtBdkvWidTn+mPylPqQqSixmOWwJPI9ccDn0fCGz7gHYPCE
         wrs6VtaOgzArlZNEW83JI1+UCdg64AZu9HHYwDiHxG+buflqdhiZtXYAw4JMvh/n0c/w
         ynRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABCZuN3t1TlhXpGL1G5x2Ki4iTUdcfdjekYhFBxIM58=;
        b=mj21JP4ZSFrGDWNWb27mVe6y+SFZiAR5juCGlqO0vC29VEPs4ak4mnCTw2DvXHa3KP
         VFdGlCUE/n0xKTziFzj8MKjYKIqY5YNJVctJusArulneL9zujgFPYNuGcwPYDaaixcKG
         LONfuYc1GD2LVhLbsS5BAgLE7XZiA0u30ljPyvr5AkGBXUdt/l2IvdAOFeWBnjLZGGp5
         qgg4DsYUj0kApSQIOU/DA+c7YO+FtPTLBGlXj+DP5QCpY+C90M398+YYBNMK0jAKin85
         oIOYFAaWPP6GCncs5iRmI6ys7/LRXz0HefEu8fSDcpMq3LA20LtxM7ID0UIroL+neV16
         DwbQ==
X-Gm-Message-State: AOAM531TS1C23tIKdU0Ttt8hGODGy+t6yAMNTEbtp2oOmxK6U5zgm5I/
        fOf88I43bQDN4XCB3wFw5o4X8g==
X-Google-Smtp-Source: ABdhPJys6iUk47YA7nWrTTeLUIq63E6kg/b8lzDwkiIPE04hoQDdV/v88ZnlGrmOnPzg+Gief66l5g==
X-Received: by 2002:a2e:a54d:: with SMTP id e13mr10904765ljn.266.1623609337157;
        Sun, 13 Jun 2021 11:35:37 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e12sm904984lfs.157.2021.06.13.11.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 11:35:36 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com,
        Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH 0/3] ACPI MDIO support for Marvell controllers
Date:   Sun, 13 Jun 2021 20:35:17 +0200
Message-Id: <20210613183520.2247415-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The MDIO ACPI binding has been established and merged to the
Linux tree, hence it is now possible to use it on the platforms
that base on the Marvell SoCs.

This short patchset adds ACPI support for the mvmdio controller.
mvpp2 driver is also updated in order to use the phylink in
ACPI world. For the latter a backward compatibility is ensured
- in case an older firmware is used, the driver would fall back to the
hitherto link interrupt handling.

The feature was verified with ACPI on MacchiatoBin and CN913x-DB.
Moreover regression tests were performed (old firmware with updated kernel,
new firmware with old kernel and the operation with DT).

The firmware ACPI description is exposed in the public github branch:
https://github.com/semihalf-wojtas-marcin/edk2-platforms/commits/acpi-mdio-r20210613
There is also MacchiatoBin firmware binary available for testing:
https://drive.google.com/file/d/1eigP_aeM4wYQpEaLAlQzs3IN_w1-kQr0

I'm looking forward to the comments or remarks.

Best regards,
Marcin


Marcin Wojtas (3):
  net: mvmdio: add ACPI support
  net: mvpp2: enable using phylink with ACPI
  net: mvpp2: remove unused 'has_phy' field

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 ---
 drivers/net/ethernet/marvell/mvmdio.c           | 27 +++++++++++++++++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 22 ++++++++++++----
 3 files changed, 41 insertions(+), 11 deletions(-)

-- 
2.29.0

