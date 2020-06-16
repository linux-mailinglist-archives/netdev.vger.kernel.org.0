Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CD91FB5F1
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgFPPTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgFPPTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:19:50 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC84EC061573;
        Tue, 16 Jun 2020 08:19:49 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id p20so21885953ejd.13;
        Tue, 16 Jun 2020 08:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZiOuvmoSSjpVKcWmYlLX95BFlmP9sXL24P7r2+PCcjw=;
        b=V7nbsQc91vxVAIyBNjXV42qarynuKWnnlkHUdfXx94u5/owbOVDlc2oJVCGQa9+EFM
         pfq/HD6YnrQ4Sgi+LsIX7jWubCL2KbX4wRniV+OBQflmeFfnISgb8vek+ytchN72Mrv6
         JKBKuQ8aKXg3qGX7I/u14IUwwbdZA56TRNM8faXyaNvxsSaQd8FONSoLU+/gs92IV36m
         auNkbEKKUD5yvcrrhaRQxBXx5nvZMHMYY26660i97BrRiAX4kFj3un3PVOAdNjI7Mkws
         dSC1XejS+4vfEshuthaN0jUPVuVHFdeFxNdg7zmQEvbfLZvtqL7egFEqB740FocQIT+A
         P0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZiOuvmoSSjpVKcWmYlLX95BFlmP9sXL24P7r2+PCcjw=;
        b=rGndzBKCDqzu6gtQJ8hMFo/Y11vbzIEchNLVdisevcw2DkNoPUj09JaBzCksQD5+SW
         udg4psTotI3B+RwKJJ6plkeOcB1Re1IoD8QEXK56/S/WStryOXxH6XreD8JQqP4cTpOg
         kqnHHubGv8orcUMdn9o2bkNVDbY0EGs8FzAJC/l3D93kqzCfX0VeEJOaw0Hbh4I2sCKm
         tYOU7UeZ+wpO6VUpYkNbB+FTcNC82iKsb+hUmiKlR9ksgFo6OBIKHD94j+RdyLO8gYRP
         W76iMFJOQ7zCuFBJGwikn6Jtf9mgXdVNxV0+5T9OWH6tPE5ABIDbgTtCDXDYMoeUCt+E
         q0xA==
X-Gm-Message-State: AOAM531GtlGgP/OR7fAOuQTim8jJe31b7bZx1dVd07u8A0FXOx0Viwwl
        tQBDb66WoqF5AhduLz72U8s=
X-Google-Smtp-Source: ABdhPJxbyyjKnCOROp7UQPWuq/+0z2rga06zZ3FIwLZb/nkrHkqCkxQj+UpVq95519AoNZdnzQnE6w==
X-Received: by 2002:a17:906:1f4f:: with SMTP id d15mr3259576ejk.206.1592320787673;
        Tue, 16 Jun 2020 08:19:47 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id ce23sm11368587ejc.53.2020.06.16.08.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 08:19:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, joakim.tjernlund@infinera.com,
        madalin.bucur@oss.nxp.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 0/2] Reapply DSA fix for dpaa-eth with proper Fixes: tag
Date:   Tue, 16 Jun 2020 18:19:08 +0300
Message-Id: <20200616151910.3908882-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Joakim notified me that this fix breaks stable trees.
It turns out that my assessment about who-broke-who was wrong.
The real Fixes: tag should have been:

Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")

which changes the device on which SET_NETDEV_DEV is made.

git describe --tags 060ad66f97954
v5.4-rc3-783-g060ad66f9795

Which means that it shouldn't have been backported to 4.19 and below.
This series reverts the commit with the misleading commit message, and
reapplies it with a corrected one. The resulting code is exactly the
same, but now, the revert should make it to the stable trees (along with
the bad fix), and the new fix should only make it down to v5.4.y.

Changes in v2:
Corrected the reversed sysfs paths in the new commit description.

Vladimir Oltean (2):
  Revert "dpaa_eth: fix usage as DSA master, try 3"
  dpaa_eth: fix usage as DSA master, try 4


-- 
2.25.1

