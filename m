Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E633A603C
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfICEbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:31:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45227 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfICEbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 00:31:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so15786758wrj.12
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HvgIVQ5wePpc53a0WZHssNW2zP99K5JKKocjXlfikDA=;
        b=eS9G7XvlYSr+PEtaj9dZfU3SS6b9zqki2JOUkPVYyToAQ2n7NhV1bDG6M6U/3WiBtU
         QZNueP8ldtFoX6fGSMvuuCNPrytbFTEhfbR0adewg3IqIU4tvoDWBkyYzChVUdvRM+dO
         pBdIiWqHu3r49VJa9hURW3bQggVqy+JYomE9cTclG4Fqm+SnCI2URLuKgxNBuQbk3v1/
         8NaYoIiWCAEFGh6NdP3pxrWM8Ygr9M4X4CP/WdAGXS/y5KcGL9/blkUIZftZJ/ivvUcz
         JxN4IOfWLOr/dlbj/IySPC5oW8jjPrczPdMh7PCDLaFBoJ/r6kb5cFQbQ00tmKkraPb4
         dumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HvgIVQ5wePpc53a0WZHssNW2zP99K5JKKocjXlfikDA=;
        b=ATN2iUFa8qDMFlmplef3yj5UsHt43VhP8cnrVBg1cFSzs58C1avq6KERZnVC/LE2Ms
         K7RYA82X66HNIa0NDRCTn+IpvBxr7fAM/ck1RnqLJ95Pw6r/bzW83H1LgYnfsr+O2Wo3
         AMOMDu1TZHcqHTV+eGbY+msyIn8PiIPHEsNHNCxrT/QMi6Cw/z2TF4Q2UuViCExDal5V
         vv5gWrtZVEbXXPH1G8f9m8GxCI8+78d5xiiKw0pLqMA7auwba0XwDVqFy4lRfreo80pE
         UuYzn7qJqf2h5UHCuUw7bX4/R4rVGcfjqHofNTv351mDR8rbNeJh2rjB1BZ1cz5Fo31k
         iCLg==
X-Gm-Message-State: APjAAAX8J0EyLdVCHPzXYWg5rPbO4XTCnv9QdH5I8qNr2Zfqj9c1fflY
        9aJoAf/vJu0LeBWH2cscsKvasg==
X-Google-Smtp-Source: APXvYqzBqCV5/kiz3HQDkEWfYxCCGaRMDUZ2dR+rGU05EF/n2KL78m+O1u8jahiJqVyDS3OeNyei4Q==
X-Received: by 2002:adf:e452:: with SMTP id t18mr39900155wrm.0.1567485088970;
        Mon, 02 Sep 2019 21:31:28 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e13sm21024465wmh.44.2019.09.02.21.31.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 21:31:28 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/5] net/tls: minor cleanups
Date:   Mon,  2 Sep 2019 21:31:01 -0700
Message-Id: <20190903043106.27570-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set is a grab bag of TLS cleanups accumulated in my tree
in an attempt to avoid merge problems with net. Nothing stands
out. First patch dedups context information. Next control path
locking is very slightly optimized. Fourth patch cleans up
ugly #ifdefs.

Jakub Kicinski (5):
  net/tls: use the full sk_proto pointer
  net/tls: don't jump to return
  net/tls: narrow down the critical area of device_offload_lock
  net/tls: clean up the number of #ifdefs for CONFIG_TLS_DEVICE
  net/tls: dedup the record cleanup

 drivers/crypto/chelsio/chtls/chtls_main.c |  6 +-
 include/net/tls.h                         | 48 +++++++++-----
 net/tls/tls_device.c                      | 78 +++++++++++------------
 net/tls/tls_main.c                        | 46 ++++---------
 net/tls/tls_sw.c                          |  6 +-
 5 files changed, 85 insertions(+), 99 deletions(-)

-- 
2.21.0

