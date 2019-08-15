Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9248ED38
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbfHONqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:46:37 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:43452 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732411AbfHONqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:46:37 -0400
Received: by mail-wr1-f53.google.com with SMTP id y8so2249807wrn.10
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 06:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/0s2IcTQuAGAyzHbYITLSI+/AM1NtScquQY52Y6KN8=;
        b=aSQjkpBzU2paamoypbsNwGkRyvZO5cnw9QjS56Jt7EnTQezJL16SSobesP172ApMtd
         Eulzj+41blxaj4h1fIyibFLeFa10CefHiS3NYD6rvBf0xFlVowujfVYkE1+ramvepfuG
         kzWjTSmShMaGsLaCWtn2rN+DZal8q22GJ40alGW9xWfrQ5a8qoN2sJUGMkt+BqES9xM6
         kgT1IKqniOnYiMJE/4SEjGh8B4jzIWsf/uiMDTCzlMWcYnAHRHYeF1hdV5yNfXL7d3je
         cL75mVlNzhEDMWpVFioXrb93X/odsJxn3/5ba1PsSyNEmYTKeL4Ap7BteFIpxSYAOBcV
         e4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/0s2IcTQuAGAyzHbYITLSI+/AM1NtScquQY52Y6KN8=;
        b=aGTh/S07YIbwxPi/cDapCjhBvzyS9+W6DbrfU6VAj//b5KzisS+pLQC45ur6t6OegU
         jQZe/uz9chSszIKJRmb3oOQZ3/yplI9EJgtDSeaf7dL35DSKZ0zWbE/nO4R1Zaoqpn1y
         csgtuDQrW1D1kbF1J0aPqBpJ3k6NBxWo0FTky9t1uUPa8difDiaz16pzDIFh2LwXglOB
         LDps9JWIG/+kanxFlU/MPBAI0sLcCbgVqXOtkjRbwJN+g2QYTPUiF01N9A9ZUlIdHHRg
         iZj+tQMA+r/Q+kiUdTKRXPCaH97Q6k2//O5jWITZO0Oa3S9vdJYKDKV69TgWP9j1gfv8
         S7DA==
X-Gm-Message-State: APjAAAUgsY4lChTHqicVWVUEKhNec0gPCGT4H5OOk/4exlMuRE1Ulnfe
        tQL5TvikM3mBpMWuwVIghHQ8Pb+LXj0=
X-Google-Smtp-Source: APXvYqzuysEFsIY6kpjva6jrh6wpwUJ/kQh8ErJ1CqTvlB2O/KsX4Yt5LzudQhcVXYibf4bE9IwOsQ==
X-Received: by 2002:adf:f3c5:: with SMTP id g5mr5190571wrp.189.1565876795233;
        Thu, 15 Aug 2019 06:46:35 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t24sm1288673wmj.14.2019.08.15.06.46.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 06:46:34 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v4 0/2] netdevsim: implement support for devlink region and snapshots
Date:   Thu, 15 Aug 2019 15:46:32 +0200
Message-Id: <20190815134634.9858-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement devlink region support for netdevsim and test it.

---
Note the selftest patch depends on "[patch net-next] selftests:
netdevsim: add devlink params tests" patch sent earlier today.

Jiri Pirko (2):
  netdevsim: implement support for devlink region and snapshots
  selftests: netdevsim: add devlink regions tests

 drivers/net/netdevsim/dev.c                   | 63 ++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h             |  1 +
 .../drivers/net/netdevsim/devlink.sh          | 54 +++++++++++++++-
 3 files changed, 116 insertions(+), 2 deletions(-)

-- 
2.21.0

