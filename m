Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF9D186176
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgCPCOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:14:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42682 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbgCPCOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:14:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id x2so8686721pfn.9
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 19:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/Ps79MNWemTqFVkVcZXagy/YLrNWBTYfOEZxlvWsZ8k=;
        b=Z1H52ctRWrHw8k8HnKCrdU+/y9MEwa0rMmkZSe9QimKyGavQVF/7W8+UgTQRbIu00G
         o7eOKf+ibGQ5UjGoKMWqVRCVaCKmQxG7PoIZThnO2Uw359jAN00D5l6jVrlcNrrjnfsO
         hLd5dEyZr7IWymeHWlIJ8U0Zm7XxbVBhUWZjTqmkK72OdXNiekQdfjL5tFvHjQQGcNJM
         y1ranK5P9YYxPeN/4o8gVXrJxkYiYYkPrIn5EUlUh1drgaWfeAdy2mO+faftSpqaLBlE
         gVnDBPcG62GNmbKHM3U8iiJblkuGm5FhpzE3cXUDEb6Fmsb7ltoax7DsG2XhObu34dr5
         kr9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/Ps79MNWemTqFVkVcZXagy/YLrNWBTYfOEZxlvWsZ8k=;
        b=Z5VSe97sYwP33HGhEKf/PbMXyhRM7Q1bj1Zr4RmdTi+SW5Qle284qTr8l0Mxch9V2a
         2bgBfoL7EpNKqJbaM9D4uNlMvedgqwk0tm5R37cGZtvjP8GXQI+q93FSpxo2Ew3M2oXh
         5qfuoGt9rCBoao5GHEfdCd2yoNMuF5W+FD/AycieYzuraMQJ5FJL/y/Empfmyy11m48b
         qJEheRnTHVcOjb1ANbVW4pho3Q3OYJRGBueBxeA3+LpAoMSar4ACBoMaK3fziYdMXr2C
         u07as1f/MosuqNU44JhGMf+qUTq6n4vgH9KRVtnWlOHnkf4wLha3ETwNI207cgkNT2wf
         PriA==
X-Gm-Message-State: ANhLgQ24dU02FKOCW/eEudO2lRYFDiMIqUHIzsVCktErZwUrEFxVM9Yx
        N+mxd+NmUBCL2AoCe8zzCBkzjnd0CrQ=
X-Google-Smtp-Source: ADFU+vtjZcx7vt++pNxYiPqMu6zqk3I0AMad99iLdztLTBQowO7u9xS5+2GyukdKGfJFI1FK/GlHZQ==
X-Received: by 2002:a65:5b49:: with SMTP id y9mr24582029pgr.153.1584324876720;
        Sun, 15 Mar 2020 19:14:36 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p4sm4386142pfg.163.2020.03.15.19.14.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 19:14:36 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/5] ionic bits and bytes
Date:   Sun, 15 Mar 2020 19:14:23 -0700
Message-Id: <20200316021428.48919-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few little updates to the ionic driver while we
are in between other feature work.

Shannon Nelson (5):
  ionic: stop devlink warn on mgmt device
  ionic: deinit rss only if selected
  ionic: remove adminq napi instance
  ionic: return error for unknown xcvr type
  ionic: add decode for IONIC_RC_ENOSUPP

 .../net/ethernet/pensando/ionic/ionic_devlink.c    |  9 +++++++--
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    | 14 +++++++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  4 +++-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  3 +++
 4 files changed, 26 insertions(+), 4 deletions(-)

-- 
2.17.1

