Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E74925C6
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfHSODA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:03:00 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36306 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfHSOC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:02:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id w2so1233720pfi.3;
        Mon, 19 Aug 2019 07:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ki1QpfmbFT/OvNxdnhlaYXkdjqPbFttVETHX9PSqp9g=;
        b=ZKuXtt3iCE/qMKFDbxNRR9FtYg3/48f3IDY7v7EFYOmmJNKYhzMKYe6WB2Znvmz363
         sT43zm4SkT5fL+c6NFMr6rCDlzCIPK9HMTd4VaXg2mvCy+WX4nCyH6ODg2wQFyKFLdtB
         Kr/aj8MrWKxUf83SJ0t6mMVbKM7+K/Gxx4+IDMr0Me0Tzlnq4Dv4uTlNvpHYavUh6MJV
         PVilHmdlhfp6RPqqCMSoj8vRoNgW48c9NoK+oJMc5wPBI9FXInElRIFmx46CGuiDVA7F
         Xlnlzcum8Dl8azk5XJH/DTzcbzc3DXqQoX0cm8vPzM4nQa1qExFP5u9PT8wNYyHQYza0
         YVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ki1QpfmbFT/OvNxdnhlaYXkdjqPbFttVETHX9PSqp9g=;
        b=Tt0JDGvP0xHQnEkWh8Mm+wOHtckQtLx1mGeQH6PRfVKvtCtwdhAnpOoJGMIKBlm4fL
         nypeTsU0UgboPifAtDYFOjMO7Hk7/UBu0A/xQ1EkTUkyZHc78vF1Mv/RVlOxQK11jyAk
         sSul/H0B/hgcapNjGuqxOR4qg0wLUnlQhH4kDnMo9YHxV4kbSQqhlJz2NkXYMw1XvGkU
         Z79QXhuQY+WbNLB1h0zEE11ZDhJkzvUnR0OkLZRjhVYHwqkTcpLaV0RULns8xStnUGXM
         d3xZeQDDflOrZFwL/YHs4DYHZ0i66ut9BeeMTBg8mbXIVHptyHzC6dg6RRQo0UIIbnxj
         kZYQ==
X-Gm-Message-State: APjAAAWBS/8LyJ64WO6e+jC8Wctlk/0f5ysgsz9Om7jEp2Q4nrOUBe/h
        cghOhcSHLv4/fGPyqHYU71GFgbFS
X-Google-Smtp-Source: APXvYqy4xL+oneCqfsBspgiW3tQy8DtLfkJ7u8rUHOjKWNB4M4/xqT/w6prahKm0oLyzm9BNUyedrw==
X-Received: by 2002:aa7:914e:: with SMTP id 14mr24139869pfi.136.1566223378914;
        Mon, 19 Aug 2019 07:02:58 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ev3sm17257853pjb.3.2019.08.19.07.02.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:02:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 0/8] sctp: support per endpoint auth and asconf flags
Date:   Mon, 19 Aug 2019 22:02:42 +0800
Message-Id: <cover.1566223325.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset mostly does 3 things:

  1. add per endpint asconf flag and use asconf flag properly
     and add SCTP_ASCONF_SUPPORTED sockopt.
  2. use auth flag properly and add SCTP_AUTH_SUPPORTED sockopt.
  3. remove the 'global feature switch' to discard chunks.

Xin Long (8):
  sctp: add asconf_enable in struct sctp_endpoint
  sctp: not set peer.asconf_capable in sctp_association_init
  sctp: check asoc peer.asconf_capable before processing asconf
  sctp: add SCTP_ASCONF_SUPPORTED sockopt
  sctp: use ep and asoc auth_enable properly
  sctp: add sctp_auth_init and sctp_auth_free
  sctp: add SCTP_AUTH_SUPPORTED sockopt
  sctp: remove net sctp.x_enable working as a global switch

 include/net/sctp/auth.h    |   2 +
 include/net/sctp/structs.h |   1 +
 include/uapi/linux/sctp.h  |   2 +
 net/sctp/associola.c       |   9 --
 net/sctp/auth.c            | 101 ++++++++++++++++++--
 net/sctp/endpointola.c     |  64 ++-----------
 net/sctp/sm_make_chunk.c   |  18 ++--
 net/sctp/sm_statefuns.c    |   6 +-
 net/sctp/sm_statetable.c   |  28 +++---
 net/sctp/socket.c          | 230 ++++++++++++++++++++++++++++++++++++++-------
 10 files changed, 325 insertions(+), 136 deletions(-)

-- 
2.1.0

