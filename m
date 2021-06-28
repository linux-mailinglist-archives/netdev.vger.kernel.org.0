Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F1E3B68E5
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbhF1TQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 15:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbhF1TQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 15:16:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442FCC061574;
        Mon, 28 Jun 2021 12:13:55 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v7so16307186pgl.2;
        Mon, 28 Jun 2021 12:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FCBFmtwOR6fhUxZYcJtkwS/nAWJxZbi/eKZP1HaTfjs=;
        b=R1vrDf5utYExbR3KR8e9iyDLvdjvFr8IhaQtqZ0nSHsAqUW2BJBIZt00FNyn2OlKSu
         ozaeo/K2VIpgm5OHjMHpYHmvavQrC+TGzXoh4Sywn0WwWPUPcNOhP2Zhjj+PKxuxmUI9
         qHpsf7UBuOrvPvS2XkZrsaDevFMZdLOD50xkG+gktQT+LxRLycWoB3c9DwjOZSn7s216
         i8i/ssY45GA63pBsIsHdb1R+kkSLd8HqQtB5t1ms7H15m6BMTlgpcVC+UfX+qdn6YDD5
         mNXew0HhpFNRBVMwScKF8w2GpNqYQUJclDjcVr8TyPLpsiJvb2LLXm2S4CBWqAnyBgrf
         n58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FCBFmtwOR6fhUxZYcJtkwS/nAWJxZbi/eKZP1HaTfjs=;
        b=Xd9feFwUcNFgF77As1kHUqXKz/RmZfu4m4wjlRrL8tArPuXRGvVGejkPeB5IvwGXDV
         SUeQtmicM1moi+r2OUO3QEhHZp9eta7xwNzrJUDrr2l07Tb2rVgyrpo/3U0ZHok/OuVu
         JCPzvxlY8m8RQQGkcsWaJvvYcSpLn9WD7u1phYKoHRTv0ndCP9q9VvZIVtX4mvsA5o9E
         /c2RTJIp2zeA+Qt3WFM/rvXtT2OEp1NrbbBb9ugkZFsgW8m+xoHvsYqqe9WBypFqe9dq
         5o4bhWw3zWGt8882tl3AkQ07cM3LvrCTmnORWXMXaLERAiKprw9jhSPH0KfOnpT00Kz/
         paQg==
X-Gm-Message-State: AOAM532wPyDN2O7Fjqrw+Z8EiNrPHUrxfM6aHYDCkIyVgV9Geb20eniX
        HGzvoz7hdgJFtX9b/3q9GUM=
X-Google-Smtp-Source: ABdhPJwOtgMutNVrcz9rBP/JozhlPeTtAb0H5NvPNa2fMv8VcdttdcnQaYVz6z0M0JKVoq8sWA2GdA==
X-Received: by 2002:a63:c00b:: with SMTP id h11mr24803406pgg.352.1624907634734;
        Mon, 28 Jun 2021 12:13:54 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:ff7f:d8af:5617:5a5c:1405])
        by smtp.gmail.com with ESMTPSA id kk4sm268521pjb.50.2021.06.28.12.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 12:13:54 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 275BAC08CB; Mon, 28 Jun 2021 16:13:52 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 0/4] sctp: add some size validations
Date:   Mon, 28 Jun 2021 16:13:40 -0300
Message-Id: <cover.1624904195.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilja Van Sprundel reported that some size validations on inbound
SCTP packets were missing. After some code review, I noticed two
others that are all fixed here.

Thanks Ilja for reporting this.

Marcelo Ricardo Leitner (4):
  sctp: validate from_addr_param return
  sctp: add size validation when walking chunks
  sctp: validate chunk size in __rcv_asconf_lookup
  sctp: add param size validation for SCTP_PARAM_SET_PRIMARY

 include/net/sctp/structs.h |  2 +-
 net/sctp/bind_addr.c       | 19 +++++++++--------
 net/sctp/input.c           | 11 +++++++---
 net/sctp/ipv6.c            |  7 ++++++-
 net/sctp/protocol.c        |  7 ++++++-
 net/sctp/sm_make_chunk.c   | 42 +++++++++++++++++++++++---------------
 6 files changed, 58 insertions(+), 30 deletions(-)

-- 
2.31.1

