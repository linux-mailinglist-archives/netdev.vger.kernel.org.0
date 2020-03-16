Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B04F187356
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 20:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbgCPTbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 15:31:43 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40216 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732385AbgCPTbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 15:31:43 -0400
Received: by mail-pj1-f66.google.com with SMTP id bo3so7797730pjb.5
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 12:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=YNTeZqde8fTcgIsaj5NImGXCew6vWLEqqGAE7nc/SjM=;
        b=xUjBAO2IsAjTQtDLo8k9sZST3Z37phdrRatr3ouV7bTTF/yAdtk+1U8lAb3tscIpa7
         d50HByV3u7W+HLzWLc+j6IKr561CvzrkA+cPmgVx9vlzWoR4wKZ+HwOTyU+RcK3we8ad
         J6nDeIJz8OLY4SbR3S97x+dywOkRi4/ZGEQNi3Q/wR9eDxlDEyG3APjGxxF/17jEfXF8
         5+t6GK0L+r/gKLTsVQTSJ2mqVHwom+MSMjewGKuZ2aJUVCsc7KYL1MBFblg5DDJdsaMn
         aD6O945dsTNYePVK8v6cNMGUJ1/ajPadKJoSooj95A+uF+HUsAf0QSWahXxra5uDOh1W
         CBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YNTeZqde8fTcgIsaj5NImGXCew6vWLEqqGAE7nc/SjM=;
        b=AqnAIp/zZlihIYB0p85W9JnkT+3BDCwtxljE7hTxfwz0NwtFg+AkvlQop70ZHT0BZY
         RzuQ9B0PsNQKxweyShRO10KbpChej7SBwBF500xNbRNSwRjQxH/8Rm1T4CH/+rc3Dprn
         HXNmfL7B/5JZMqkOVsXpZxDCe0dEj92v3BtMVkTqf9tE8pn+2iZNW7s/fkNxbRtmt04k
         uvwuYD1eIJrdrk6GjUPb8ppdyaJ6Z4U2pakX9Zi5aLVfDFsydLlqVOqRKSONvOoVdgu5
         J9WNWxVTVkuRF267shrf7QYiZ/yEicO7UGigZ5kQLAiGiODHrSrd9U9sHUQxFF8m7Wcp
         123A==
X-Gm-Message-State: ANhLgQ38qU854M3M3cksUzHH9PMK1Uv3bD7pLeTnx0EQgbD79U/6s2tr
        QWBNa5vv/K+17H2bwKZzRrFeutcIIU0=
X-Google-Smtp-Source: ADFU+vv6dm3pYYKyKziVX23yLRNsnTTtnEoZkErJ1p5Oenxs+fTKmypoFeqfbA7FlNCo4qqUtx0/bA==
X-Received: by 2002:a17:90a:5d85:: with SMTP id t5mr1130684pji.126.1584387101755;
        Mon, 16 Mar 2020 12:31:41 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w17sm656413pfi.59.2020.03.16.12.31.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:31:41 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/5] ionic bits and bytes
Date:   Mon, 16 Mar 2020 12:31:29 -0700
Message-Id: <20200316193134.56820-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few little updates to the ionic driver while we are in between
other feature work.  While these are mostly Fixes, they are almost all low
priority and needn't be promoted to net.  The one higher need is patch 1,
but it is fixing something that hasn't made it out of net-next yet.

Shannon Nelson (5):
  ionic: stop devlink warn on mgmt device
  ionic: deinit rss only if selected
  ionic: remove adminq napi instance
  ionic: return error for unknown xcvr type
  ionic: add decode for IONIC_RC_ENOSUPP

v2: add Fixes tags to patches 1-4, and a little
    description for patch 5

 .../net/ethernet/pensando/ionic/ionic_devlink.c    |  9 +++++++--
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    | 14 +++++++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  4 +++-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  3 +++
 4 files changed, 26 insertions(+), 4 deletions(-)

-- 
2.17.1

