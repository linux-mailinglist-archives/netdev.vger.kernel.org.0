Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5567A30993E
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhA3Xsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 18:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhA3Xsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:48:32 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C65EC061573;
        Sat, 30 Jan 2021 15:47:52 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id rv9so18534573ejb.13;
        Sat, 30 Jan 2021 15:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZUHZvq9Ynb7GHrViRpXoA7KwnYEZy9HTSBIIQWPzb7w=;
        b=V+2iyN966+5XCIkHlDCAXztkdHMSl6foNUeYMYbUBi808e6bcNNz6Hbeo8uSokQ2Bl
         zQjEBolLQoG9CpV1b4TDCMQg8GvOgiXaeqbAM+l4slTMunFZidnl18oSab5biVLn/9wV
         8hwJMmsLa7HxrXCIWrb3bXDzTbRwjeVrRL1mUKLMECVAAUE5X1LHr2jOyyExaNZR6pcv
         g7NtChUG0shlKAIfwlZX+dfZsSHXc7hs4ahgjGaz2xt4AIfkpZXyoNpNIWwV3lCxAKfA
         tazrdUraPp7IDcC9qay24avUPuFhnUPDwVIdqjFmhhAYN4Bpi8fXU0VVvODxaVWY7LEA
         ZTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ZUHZvq9Ynb7GHrViRpXoA7KwnYEZy9HTSBIIQWPzb7w=;
        b=bcVP76tQPky+/Lp0H9SLWSBEIwESGj3zy9/HWt45saM+UDxHUUDw1s2bgX0YklawdS
         YdfdjFcd9FXtcYDDfo4DSCDyoaoaw0Adi07moh5W14ty+3BWgvXi7+XMJq8qqIjzNEr2
         c1lExqPctnvMZqXA437A4NO/RrW9fDbADk54XQH/5Qis3qsSwNjo8YhFVid5Nc6O1eTi
         9u1cbR9fLX3vV6B39H7GZagnISShSK/EIKh7QAOq/mbrGdVPx8ZMxhxJ8Vpvx28GEf5b
         1ptkBkqGEwzPfcGfi9eie8aYdtZHVQ8ktJ7gXN+xnP348AAftiH9j+Uxa+7YHDCQLubP
         pi/A==
X-Gm-Message-State: AOAM532L7wbj8M2Eu/Tuxf/AZKU80ZIGOSqashlJ2kjmkyxcA/wxEjzR
        Qd4CxkxeGGYFP/yTNddwTgJfRlvD60/3cM4y
X-Google-Smtp-Source: ABdhPJz4YzDVMWOOElK4WClzBaGKcVmh7tugHohhd18MB43G9kZ3KDIW+GCpZbFVtb6Vtpna2NzhFw==
X-Received: by 2002:a17:906:958f:: with SMTP id r15mr10772898ejx.360.1612050471142;
        Sat, 30 Jan 2021 15:47:51 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:50 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Petko Manolov <petkan@nucleusys.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] drivers: net: update tasklet_init callers
Date:   Sun, 31 Jan 2021 00:47:21 +0100
Message-Id: <20210130234730.26565-1-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates the remaining callers of tasklet_init() in drivers/net
to the new API introduced in 
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

All changes are done by coccinelle using the following semantic patch.
Coccinelle needs a little help parsing drivers/net/arcnet/arcnet.c

@ match @
type T;
T *container;
identifier tasklet;
identifier callback;
@@
	tasklet_init(&container->tasklet, callback, (unsigned long)container);

@ patch1 depends on match @
type match.T;
identifier match.tasklet;
identifier match.callback;
identifier data;
identifier container;
@@
-void callback(unsigned long data)
+void callback(struct tasklet_struct *t)
{
	...
-	T *container = (T *)data;
+	T *container = from_tasklet(container, t, tasklet);
	...
}

@ patch2 depends on match @
type match.T;
identifier match.tasklet;
identifier match.callback;
identifier data;
identifier container;
@@
-void callback(unsigned long data)
+void callback(struct tasklet_struct *t)
{
	...
-	T *container;
+	T *container = from_tasklet(container, t, tasklet);
	...
-	container = (T *)data;
	...
}

@ depends on (patch1 || patch2) @
match.T *container;
identifier match.tasklet;
identifier match.callback;
@@
-	tasklet_init(&container->tasklet, callback, (unsigned long)container);
+	tasklet_setup(&container->tasklet, callback);


Emil Renner Berthing (9):
  arcnet: use new tasklet API
  caif_virtio: use new tasklet API
  ifb: use new tasklet API
  ppp: use new tasklet API
  net: usb: hso: use new tasklet API
  net: usb: lan78xx: use new tasklet API
  net: usb: pegasus: use new tasklet API
  net: usb: r8152: use new tasklet API
  net: usb: rtl8150: use new tasklet API

 drivers/net/arcnet/arcnet.c    |  7 +++----
 drivers/net/caif/caif_virtio.c |  8 +++-----
 drivers/net/ifb.c              |  7 +++----
 drivers/net/ppp/ppp_async.c    |  8 ++++----
 drivers/net/ppp/ppp_synctty.c  |  8 ++++----
 drivers/net/usb/hso.c          | 10 +++++-----
 drivers/net/usb/lan78xx.c      |  6 +++---
 drivers/net/usb/pegasus.c      |  7 +++----
 drivers/net/usb/r8152.c        |  8 +++-----
 drivers/net/usb/rtl8150.c      |  6 +++---
 10 files changed, 34 insertions(+), 41 deletions(-)

-- 
2.30.0

