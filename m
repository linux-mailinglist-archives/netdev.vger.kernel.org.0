Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623C2119E9A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfLJWyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:54:33 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:41826 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJWyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:54:33 -0500
Received: by mail-pj1-f52.google.com with SMTP id ca19so8000743pjb.8
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 14:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=cGIUY1BNqzhlSf04LPcKcXh1tEimGqgQVvtmpDVGbYw=;
        b=P2Ak1l9LdrnmOHju+vaGLdGg5Fpe3Md7eXwO2Sds0ozbSALhlkBUlK3h2SmdvqnNh2
         SZRpeA31GJR9uTa8z84fRKVd3ay1vVufzpQ+MecxBYr1hMRxsmSpZ/E7jwkFgk1W1EG9
         Hptqg16VfFW0RcvJf3MVRYUhQc/J3MXTi9vHv6dRed6EWUXYSEBMind/luCyYxOhmLEa
         Iu14FQC0DkMS+SNfE2WUUcvRONkoPwiWoKFI81wFzqQRJGSfW7zlnssppfIP0JPr2raZ
         +UdQgpmJixq83sXjwGu4BYD/f9nnBwH8JZZi3Fz70gK0n2oY79BU5LhH4kIKkgbM0oA2
         8BEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cGIUY1BNqzhlSf04LPcKcXh1tEimGqgQVvtmpDVGbYw=;
        b=TP2Udo9GGQjSnGJ0uKN8ao+g0sOPs6iuqJ5EPsSOtqIm1BFzIiJUkJ7eBzMvrbz6aH
         jIGGFONC3wJnA0hUwRd3/eV3x28601EXeT//vPrkHuTy6y0RZWxEcqSR4/heezQjmaMh
         ZfjafUyhzJCmvkaMCerAxly2s8OgjQfcHcrY/8X/ALmH7fXTxbfyuCmAvTY+T9vsRo9f
         seFiWilz3UqQ20cKJ7RvH9EhV5GLgxcoYV3AJrMb1KXuc+kRlaSrEkEtmb2lCX/h//uU
         WD+00+/ObEXysBpqMNiuBGaXSg06IyhGa0uUPJpk4EPxvpIKpXV43R4FOUnicWKwGwc2
         XMsA==
X-Gm-Message-State: APjAAAVhMTghFDLU51honbpC+ZfurCiN/IlK3b3uRvj0f5ORHb3U3vUm
        I6br6jTV6iXS66s9cBxz0ctsAzaZhvw=
X-Google-Smtp-Source: APXvYqwA4kI4P8y4C47yP/LMbDNMRomjUYVnpnKklanboIVX5RGwnnXhkk/frNbY0PS2rupsu8tOMw==
X-Received: by 2002:a17:90b:124a:: with SMTP id gx10mr8223257pjb.118.1576018472426;
        Tue, 10 Dec 2019 14:54:32 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e12sm46630pjs.3.2019.12.10.14.54.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 14:54:31 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/2] ionic: add sriov support
Date:   Tue, 10 Dec 2019 14:54:19 -0800
Message-Id: <20191210225421.35193-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up the basic support for enabling SR-IOV devices in the
ionic driver.  Since most of the management work happens in
the NIC firmware, the driver becomes mostly a pass-through
for the network stack commands that want to control and
configure the VFs.

Shannon Nelson (2):
  ionic: ionic_if bits for sr-iov support
  ionic: support sr-iov operations

 drivers/net/ethernet/pensando/ionic/ionic.h   |  16 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  75 +++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  61 ++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  97 +++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 188 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
 8 files changed, 446 insertions(+), 8 deletions(-)

-- 
2.17.1

