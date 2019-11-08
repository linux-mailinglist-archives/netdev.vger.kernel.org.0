Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D5AF3F62
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKHFFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:05:25 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33267 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbfKHFFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:05:25 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 965A94AB12;
        Fri,  8 Nov 2019 16:05:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:content-type:content-type
        :mime-version:x-mailer:message-id:date:date:subject:subject:from
        :from:received:received:received; s=mail_dkim; t=1573189522; bh=
        2z8NoLGLbEpW9K61LvRG5hEo89RzfwjjpFFMZD7V3oc=; b=TfYxcrmUPYkvRT47
        3Zv47gT2HQ7ySUKwg4aEegtWN1dkOYHNBI4DzDsSyk2o88g6qdGBalGxbsQvq4Zz
        G76XMBWshKlwaSErWSHLOHXY+WxtrpcijEDsiDK77hpsneNAyG+UuhhKy3dxezVf
        D5KynF35djuSyv1YjxiLl8sPHX4=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3b7x4rY802Rv; Fri,  8 Nov 2019 16:05:22 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 30D574AB15;
        Fri,  8 Nov 2019 16:05:21 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 73BE24AB12;
        Fri,  8 Nov 2019 16:05:20 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next v2 0/5] TIPC Encryption
Date:   Fri,  8 Nov 2019 12:05:07 +0700
Message-Id: <20191108050512.4156-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides TIPC encryption feature, kernel part. There will be
another one in the 'iproute2/tipc' for user space to set key.

v2: add select crypto 'aes(gcm)' for TIPC_CRYPTO in Kconfig

Tuong Lien (5):
  tipc: add reference counter to bearer
  tipc: enable creating a "preliminary" node
  tipc: add new AEAD key structure for user API
  tipc: introduce TIPC encryption & authentication
  tipc: add support for AEAD key setting via netlink

 include/uapi/linux/tipc.h         |   21 +
 include/uapi/linux/tipc_netlink.h |    4 +
 net/tipc/Kconfig                  |   15 +
 net/tipc/Makefile                 |    1 +
 net/tipc/bcast.c                  |    2 +-
 net/tipc/bearer.c                 |   49 +-
 net/tipc/bearer.h                 |    6 +-
 net/tipc/core.c                   |   14 +
 net/tipc/core.h                   |    8 +
 net/tipc/crypto.c                 | 1986 +++++++++++++++++++++++++++++++=
++++++
 net/tipc/crypto.h                 |  167 ++++
 net/tipc/link.c                   |   19 +-
 net/tipc/link.h                   |    1 +
 net/tipc/msg.c                    |   15 +-
 net/tipc/msg.h                    |   46 +-
 net/tipc/netlink.c                |   18 +-
 net/tipc/node.c                   |  325 +++++-
 net/tipc/node.h                   |   13 +
 net/tipc/sysctl.c                 |   11 +
 net/tipc/udp_media.c              |    1 +
 20 files changed, 2651 insertions(+), 71 deletions(-)
 create mode 100644 net/tipc/crypto.c
 create mode 100644 net/tipc/crypto.h

--=20
2.13.7

