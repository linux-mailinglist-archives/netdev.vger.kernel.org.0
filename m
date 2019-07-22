Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32A970779
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 19:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfGVRiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 13:38:09 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41509 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfGVRiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 13:38:09 -0400
Received: by mail-pg1-f176.google.com with SMTP id x15so7654499pgg.8;
        Mon, 22 Jul 2019 10:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vxCA123yN4ZeEjfZTQxVf3zCKC3d3RjHGIAz2Y/qjEk=;
        b=jQcwBjJRX82OJjdAK4YO6IlJmBadOrZvpSDCjT8jS8OcTBIJg0mhV9HMgAJcJdPDhV
         CSvhE+cpTFXVFJTDoQsvR2CClrStCPAg9QCvwGL+kBQZYw1O4Nc8IE1e0Ex1G9vspebm
         opbSWjGfH6CLPCMi3td9i6zYMoqxRmeUD30IkIkUfZ7NXAwEebd7iIsXulsnfxh3FM0k
         K98KKqd3okSZOVDyc1DMdPzewpa1h1at+4YXq4YbsfWmNtT222kJvVLM5/5uGmivuS6X
         8XsN+xIbIfd+MrspTLkKZnt2e5IuEQnmO0rddKSEQCOwwqK8aHaYRh/D5TjPq8gh8qu1
         y/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vxCA123yN4ZeEjfZTQxVf3zCKC3d3RjHGIAz2Y/qjEk=;
        b=CClWVXk50niMPpEx5rU1ncu/NpBqhhP2wPxjH0bspL4O6rwydFnAseuDpv9u4k4seI
         KHtp61pqY2MHq2WeY9OXzvixuXatyGdVnAo/m8LmfF9rsKhT3PpztXYP69RtjSbLGQI0
         HK2j8ujRenMH9qpgXiK30CQaoukC771xgzCrkZfZK3Go4gHPaSADcRXfB6NNVE2GVcqI
         8IQ7SxP5SO9IopcEVAkrJ1wJEQeWQdR5kPKaCm6d3RLkpr3m17Di74jeC8qmvrzhmUSV
         mPJcnoAhbf7bMNzfxdHrXGCZNBbf9GERwKHn3VSihLF4l7+RcPeIweJbySV5FPCJTW64
         oreA==
X-Gm-Message-State: APjAAAXW6gm0fJHhl4Gl7seZl7aKAf0gBSg/bLAEUqKM//VtXLFNy4ZM
        SDmC4N0DyC/NeGArfDvjXZVwXXvX
X-Google-Smtp-Source: APXvYqxexwwBcDPAAM5MwWSKov47o7XmvhzkJhSNPYB8xb+/TU+GlfpE9OfdZsEDRPJJAgaoblfSbg==
X-Received: by 2002:a63:9318:: with SMTP id b24mr62004893pge.31.1563817088417;
        Mon, 22 Jul 2019 10:38:08 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b3sm54277250pfp.65.2019.07.22.10.38.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 10:38:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 0/4] sctp: clean up __sctp_connect function
Date:   Tue, 23 Jul 2019 01:37:56 +0800
Message-Id: <cover.1563817029.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to factor out some common code for
sctp_sendmsg_new_asoc() and __sctp_connect() into 2
new functioins.

Xin Long (4):
  sctp: check addr_size with sa_family_t size in
    __sctp_setsockopt_connectx
  sctp: clean up __sctp_connect
  sctp: factor out sctp_connect_new_asoc
  sctp: factor out sctp_connect_add_peer

 net/sctp/socket.c | 377 +++++++++++++++++++++---------------------------------
 1 file changed, 147 insertions(+), 230 deletions(-)

-- 
2.1.0

