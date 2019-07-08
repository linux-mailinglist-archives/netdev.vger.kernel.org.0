Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C275F626B0
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390208AbfGHQ5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:57:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39186 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGHQ5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:57:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so7895802pfe.6;
        Mon, 08 Jul 2019 09:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FGkuWWLfOtXU5HO+HxGwaAPhk1GNPOE5eh4/6gJ/Zio=;
        b=Ufq7PnKs0kxuj4hKbVqDPwPyrh87hQb7GKPCr+4SYFtw9MXGljwQr8HCEvN5L3KC0P
         z5RpPDh1hknSWb87r/ExZ2UXTJ5HAxB3TDcA4pyghp2MPvzmE+iB+vE0X6q0sxd9fgAs
         mBrbNp1t/L9jrVecve8/mxD+qAjTMRH0tmV+ygd5MGVPsu3tCRx+e5iNfgB4Z0hjfM5J
         qRIPpQTYkcSPbHImxxd2KGToDArFEYHhjaZE1TLObfh3j1et807gySlbi355vmALadud
         yHI1BVptjWIm1774bZxaRZX7MSfb3QDo04vAO+aaHVCKcNV9BFjL24hsq1WhwFzWuL2I
         63CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FGkuWWLfOtXU5HO+HxGwaAPhk1GNPOE5eh4/6gJ/Zio=;
        b=Y209WsuuurDGxAjPEQ3woqWPRiXpX70hqh1l0Awnn/7Njsgui2ss9guOmKSxxpBfcT
         deYcx5mRzA/MqKlTqgwUhljKa2frM9YhOyoR6obJIu1RDHAKQ6aIo/vfqqgrW24S7KBM
         BU7uT/j7n5zA20xwTABsR6b8gXF5nKDx7od1P8DBFyWZuP2o3I/r4KSzw9vxGAwVnzNf
         cV2jmRsCqQRAXiF+MspcxzbVPbI2h0QkJV/h7T9+htGrMY8WQYJENJy3qOJxjG3GzG+z
         WqBjA0jSXTGUEXn86am8ey5/6qWp8IrvOvomCqM3WmUW/GnOErESv4I8cFFZ89fb+H3i
         QDww==
X-Gm-Message-State: APjAAAUsuAUQqcBxYLM3RgkJII5qULd0QuyokE/MyerDLyaIIFqstFft
        nFVooZeNQ37MP7DvaP/Mat5POqCq
X-Google-Smtp-Source: APXvYqyf2RJWtFPMA+wB+7J/B40pIUp+Laex6gkhdZbHc4WhuELI8Dw6uoQ3ObLb6qeWtRqY480ObQ==
X-Received: by 2002:a65:60cc:: with SMTP id r12mr26254524pgv.333.1562605036420;
        Mon, 08 Jul 2019 09:57:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x14sm22027034pfq.158.2019.07.08.09.57.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 09:57:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 0/4] sctp: tidy up some ep and asoc feature flags
Date:   Tue,  9 Jul 2019 00:57:03 +0800
Message-Id: <cover.1562604972.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to remove some unnecessary feature flags from
sctp_assocation and move some others to the right places.

Xin Long (4):
  sctp: remove reconf_enable from asoc
  sctp: remove prsctp_enable from asoc
  sctp: rename asoc intl_enable to asoc peer.intl_capable
  sctp: rename sp strm_interleave to ep intl_enable

 include/net/sctp/structs.h   | 37 ++++++++++++++++++-------------------
 net/sctp/associola.c         |  2 --
 net/sctp/sm_make_chunk.c     | 21 ++++++++++-----------
 net/sctp/socket.c            | 19 ++++++++-----------
 net/sctp/stream_interleave.c |  4 ++--
 net/sctp/stream_sched.c      |  2 +-
 6 files changed, 39 insertions(+), 46 deletions(-)

-- 
2.1.0

