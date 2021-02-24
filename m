Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE6D324758
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhBXXE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:04:29 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:57019 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236272AbhBXXEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:04:01 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id F32VlxCf1lChfF32Ylf7W1; Wed, 24 Feb 2021 23:53:56 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614207236; bh=6o6jDBvR5XQjgJ8BGNlWOmm64d1YNEr7t6lmSQ620tU=;
        h=From;
        b=eMZ0ljuDRUWKxtg+LRiec7AwT//WdWV8DapMtlEaTrbn3xmFeSnqYmc/m2KojXnLE
         7o3pac8rWyodynOZ4n6q6MymMlO83caXAORJF2C0jm8C8V7CYRYNFImIpLfITzZXOI
         nio6wM29gj9urJiiAvMQdErK5bNi0Mbj3p/5Wj/QHHshe+Wz6Dv5zua1vXUhgKMnZx
         8R45rkF2jlJGujmU1qhNQFGSi4jAby2QavNwvUgWmK/h7X3PYhrZk75L6rT9JRdqMo
         6EjyVRWBdezFc7isgpa78NNHgxmMfhfH7RevBaAZGVQjUVPdjKC00xyopIqdzsPoUP
         PC0aEJ/+ClVIQ==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=6036d904 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17 a=gu6fZOg2AAAA:8
 a=FCneKAZuOMEC46B4a7wA:9 a=-FEs8UIgK8oA:10 a=NWVoK91CQyQA:10
 a=2RSlZUUhi9gRBrsHwhhZ:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/6] can: c_can: add support to 64 messages objects
Date:   Wed, 24 Feb 2021 23:52:40 +0100
Message-Id: <20210224225246.11346-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfMOLlCecWLvUGrZ7U5u1wIQsmh8zYjADupowNCTunlqn3AYJ7cx8lPJ5yDyX/ogisOrWL37tzz2APPsamdAFFz7RVfq6ILVDTaGTkwAYAyYMKMmju+Xq
 ePNcq/wACcZ5kKxR5dJ/AUMgfJ+odwsBZqSD9gsmUVWbH4CAHg5j+lllLg14qWp1UytCf11ESQZ9TGbEvW+asfU2+au/UIyKp0/jI6vrbaM14GyH9hmXLChT
 hbjtTFRt8arwVuXsjGfMkIaxiROIHm0WWNye3GNqan2EKzOpJYsNlqs5qxrUekH3XvGqbyJ24Nh6wvDi5OOEV+aiMqVZCnI0yqo6HEUBPgfXEgQMqmM/+mNw
 +dfF8VhFQabo+sb2C3hUcatQCudUvCfQfP8FHZNWtYYNeHB28eap5vmwElBfxDp6K5ognpcMr4+bH3+cLstLS4RLve3UpUIFsQ3407/G77JTxlJdGFBkB956
 tds9OXOuvwXkUZVkO+Hh0mnH+o0ZhN6aL2/r9uHb/m9QFn8+yGLg1u7aOvAa4NEBjIg/Id48aGuWTa11wQpx9/0mNjF4nOZM7PrjoLZdbJo3Uifc/lJzkJ/c
 aLniYsX/CbTlG5xsV7fqGUKQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The D_CAN controller supports up to 128 messages. Until now the driver
only managed 32 messages although Sitara processors and DRA7 SOC can
handle 64.

The series was tested on a beaglebone board.

Note:
I have not changed the type of tx_field (belonging to the c_can_priv
structure) to atomic64_t because I think the atomic_t type has size
of at least 32 bits on x86 and arm, which is enough to handle 64
messages.
http://marc.info/?l=linux-can&m=139746476821294&w=2 reports the results
of tests performed just on x86 and arm architectures.


Dario Binacchi (6):
  can: c_can: remove unused code
  can: c_can: fix indentation
  can: c_can: fix control interface used by c_can_do_tx
  can: c_can: use 32-bit write to set arbitration register
  can: c_can: prepare to up the message objects number
  can: c_can: add support to 64 messages objects

 drivers/net/can/c_can/c_can.c          | 83 ++++++++++++++++----------
 drivers/net/can/c_can/c_can.h          | 32 ++++------
 drivers/net/can/c_can/c_can_platform.c |  6 +-
 3 files changed, 69 insertions(+), 52 deletions(-)

-- 
2.17.1

