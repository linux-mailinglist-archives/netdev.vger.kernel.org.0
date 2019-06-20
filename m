Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF9C4CB85
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 12:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfFTKHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 06:07:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42859 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfFTKHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 06:07:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so1379526pff.9;
        Thu, 20 Jun 2019 03:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LIIZTinoKgJ1YU1uWDUn+rFYAPOlDhLPa51iI7JhAfQ=;
        b=GnZu5jDImxbJEGt4N+Khm3Og1TXWC/T/dXTQ6IDcjolCbwNqA5fSF33cR+ssMSz9y0
         rIqq8UUVjXYLDJTSk6ezY/bsHHAX/psn8Sd9/r6KnURGmd3puxwrHvf3zT0+pNjetxMT
         FBxp+FQoGbDUk4sNHYkO1DI+mVr4yvJ0+Ja3i/Yxee969TtWjUYKvObTKM/zuQnnVBv5
         oMGMirehNqr8XS8zBRaef/JPmnZveQkruS/aWJc7BZjnnbeUX+s5xYC4ebC1JKuxMsza
         BnCkKhiYtcIZeEfxc3mi0v7P4fGOmE4MOTgrblalj3E3vYkvyMrsbIqTspJSja4pGVRW
         3/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LIIZTinoKgJ1YU1uWDUn+rFYAPOlDhLPa51iI7JhAfQ=;
        b=SGk4Su08bsnbWRAdJxOVD0kBAwhbPzeh0GBLOO64/ZiGmSywS/L55/udDrZjyIcEHc
         EKcKvdcY4ZvpiA9Kbc+/FDvG65HzvTI+NhViQVVHES/veBwsFWO3hzUmSHZxc1+M/g/N
         sdwdQL8skhkvJj1ZLLBZKE8Ia9c6Ce643fJWUF9D2fQAVnTck4JjHx5MRHHa3+Mt3uZn
         WRdGUIr1eAQKv6T7/j5UnHEVvI/xeGi1mzss28DkhFIG5Q8NVVQv7Z6e2YPXumJ583fB
         ono1q4dlMcXX+ObW7A6RXGMXterZTwEFNMdGuTm3Cpga0oRBPbt8Qd+3bENAuNHWn/E7
         q+gw==
X-Gm-Message-State: APjAAAW7hpVwSxQHiVZVp0c3cWeM2BBHaZwNcFxQgdl+dlSEwvLLM+bC
        08N5H0NaGJWw3xHnyQ4kXoYX3kRcOZE70w==
X-Google-Smtp-Source: APXvYqwd56C3jfO5jgJdGmzvloHjCQo0f4S9qOOP+Tt7xqcDMEjmIEtk3xv0aK6NCcTuCKovcHjhAw==
X-Received: by 2002:a63:8341:: with SMTP id h62mr1300186pge.206.1561025242339;
        Thu, 20 Jun 2019 03:07:22 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id y22sm41574267pgj.38.2019.06.20.03.07.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 03:07:21 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        bruce.richardson@intel.com, songliubraving@fb.com,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 0/2] net: xdp: XSKMAP improvements
Date:   Thu, 20 Jun 2019 12:06:50 +0200
Message-Id: <20190620100652.31283-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add two improvements for the XSKMAP, used by AF_XDP
sockets.

1. Automatic cleanup when an AF_XDP socket goes out of scope. Instead
   of manually cleaning out the "released" state socket from the map,
   this is done automatically. This mimics the SOCKMAP behavior; Each
   socket tracks which maps it resides in, and remove itself from
   those maps at relase.

2. The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flag on insert,
   which this patch addresses.

Song, this v3 of the series doesn't have any code changes, it's just a
rebase onto the latest bpf-next. You had some questions on the
map_entry pointer, but the thread died after that.


Thanks,
Björn

v1->v2: Fixed deadlock and broken cleanup. (Daniel)
v2->v3: Rebased onto bpf-next


Björn Töpel (2):
  xsk: remove AF_XDP socket from map when the socket is released
  xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP

 include/net/xdp_sock.h |   3 ++
 kernel/bpf/xskmap.c    | 117 +++++++++++++++++++++++++++++++++++------
 net/xdp/xsk.c          |  25 +++++++++
 3 files changed, 130 insertions(+), 15 deletions(-)

-- 
2.20.1

