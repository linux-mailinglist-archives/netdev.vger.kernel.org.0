Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C669CB85
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfHZIaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:30:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37896 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729328AbfHZIaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:30:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id e11so10157758pga.5;
        Mon, 26 Aug 2019 01:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TSnxaRUgg7zVb+c6LGqQf5Uz1TCb/aeYLpuotKE+sJs=;
        b=etgwajZIBg5S5RyrvVCzkP2qMiTuuhPJW5IrXrdgqcSnbDqMebJYJN+0QGWYcrnwbA
         aByTvpea8z9Fz7ZJvbdNKnaua2VCEFhBhB+6PaTNotG2soUqEaQ/WuRXi2uJPcow6Gti
         0yy4PqDQlCbdAyC9ajFfxRhnt7+TusEQhXLU3L5e+l3+q5Lf4sfkiJA8fS7ZpGunYjoA
         uyYfwfMoc0w7/djgrX3zwocaQ1jLeE8fp9FmovgYYt/bsYc6aU9PEbRPtswQHZ0D/TtG
         1mb3BZ4L2pOLV3H+4zXhhiGRTwYx0oQOI96eXKNRLY9Hfry04DGETcgvIsdtdA2Yrnp2
         NBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TSnxaRUgg7zVb+c6LGqQf5Uz1TCb/aeYLpuotKE+sJs=;
        b=FPRCf6n3aU6w09d6uI7l+dYSQuD5hBLwZdnsBKhNBy7OjSZUr5dBIGaP2smb/ZuVbs
         TQYvXMQtNvnNJ5/KDznB5gXTKu6FFwq0jrRuJHHTboh2ORHNIsWAtdu8OzCzcaw6JBMq
         WnOj27bChqVjtHk9aB4e92XEx+yCFUNjSdOU6xRn2QgU/EtZY0InWEBTbBVZRyeB2dVH
         E9nQwYpE5uajY7F37/GC+TlvBxCBbNowttMX6peHBOzXIAEhnTT15yPFC9TIvHFLjqaO
         DcJ/zzzr+uePr9IS/ZOnnyCbiQc7jta0uHvID5P9lp3UMCsjWiGDmS7adNhRyTijtjyo
         3ZJA==
X-Gm-Message-State: APjAAAXowjcr0tKLlKU8yuRB5F2PSWn+82sbH8Dxa5QAxQf+dH8wRz/4
        aFr9/yTOTjq6BKRKBMxiOmsOCDYaquA=
X-Google-Smtp-Source: APXvYqwf3gZG4zqRt5BtBt1T7HLkiAqMaMIZ1P3i1JNMoSm4EvHulTtmURe55ObJVCvAKDGuNaH3Lg==
X-Received: by 2002:a62:1808:: with SMTP id 8mr18918135pfy.177.1566808212879;
        Mon, 26 Aug 2019 01:30:12 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3sm14341794pfn.4.2019.08.26.01.30.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 01:30:12 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 0/3] sctp: add SCTP_ECN_SUPPORTED sockopt
Date:   Mon, 26 Aug 2019 16:30:01 +0800
Message-Id: <cover.1566807985.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to make ecn flag per netns and endpoint and then
add SCTP_ECN_SUPPORTED sockopt, as does for other feature flags.

Xin Long (3):
  sctp: make ecn flag per netns and endpoint
  sctp: allow users to set netns ecn flag with sysctl
  sctp: allow users to set ep ecn flag by sockopt

 include/net/netns/sctp.h   |  3 ++
 include/net/sctp/structs.h |  3 +-
 include/uapi/linux/sctp.h  |  1 +
 net/sctp/endpointola.c     |  1 +
 net/sctp/protocol.c        |  3 ++
 net/sctp/sm_make_chunk.c   | 16 +++++++---
 net/sctp/socket.c          | 73 ++++++++++++++++++++++++++++++++++++++++++++++
 net/sctp/sysctl.c          |  7 +++++
 8 files changed, 102 insertions(+), 5 deletions(-)

-- 
2.1.0

