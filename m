Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DF932590B
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 22:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhBYVxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 16:53:43 -0500
Received: from smtp-17.italiaonline.it ([213.209.10.17]:38312 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234550AbhBYVxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 16:53:06 -0500
X-Greylist: delayed 82703 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2021 16:53:05 EST
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id FOYQlNUJ2lChfFOYTlkbf6; Thu, 25 Feb 2021 22:52:19 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614289939; bh=twkxEz/c7cqZmimIxIW4zZBadfOthraWlBWEAgYQSfY=;
        h=From;
        b=FsLQauvKGw29rGVjIxmark8otPN+g2A3pMGhaJgGQVNwB77cc3qEsZs0EO/xHC8Qw
         DTnczn1+xkZHqaS6lhDJvSn4zaBNGH3WJC1viV+KlQ/sJkPDzVwoD5T9SvxJz+JTye
         Ar84b3XFUd0VoXzFic/AtAPTPqMKBxve1sf32lAXyPNjODmfiopq3s+k7N4Og64tpW
         Uj9wKVFtGhuGWmqpDCP5aZLPLSBavrWvKKstvGv3BKPzNYsa9uLFYnTh1MjKeEG0z1
         uMRtfkU/zObUzOF4GoCHYXkqaJ+bDyLZENEaLs4cUWkDpUVSrbtmc6Qqt+4hSNB1Fm
         +S0VN7TTmz56w==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=60381c13 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17 a=gu6fZOg2AAAA:8
 a=_nVJ0L4g9Xc5rHmjS8IA:9 a=-FEs8UIgK8oA:10 a=NWVoK91CQyQA:10
 a=2RSlZUUhi9gRBrsHwhhZ:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 0/6] can: c_can: add support to 64 message objects
Date:   Thu, 25 Feb 2021 22:51:49 +0100
Message-Id: <20210225215155.30509-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfN0e8pKNwQDTelLjuTfm8BEU4wdA+HYwT1FZjd6i9f9cOrhyJuJZkw5PvVHe32vfSrPOfQU8ge3SFuXa/qRuz/xDEKR3csTwOImj7lO+0Sjokr9+iuEm
 bNfE6du0EuZ3lNtD6zc+wBmaLnPQsH4/Vkl7zNkSjlRBlulgRwJzjOJo3xWbQ6GWVRGHS67R8/r2ypeoIdIex7zQ0RwkqOxN3xFm4lycfZbmZznYseIvDEys
 8yeuMu0arMIHPDtnIP6yVCIXr2FuwGe/bMPsf2v8Yww7D6kVV2eWFMPz8Xg1sDf/+d45kEiwHK4EjzL9216R43m32+rhI5fhJe3OnSa96NupjcKEH58EGg09
 nZo2/lmHRreVGLrbplmqVCapH8vbcEtfGqkkt5y908/RlIwfNW+10B8bNoa2glEBYjpx8F7wiCxWkwg0K5nCzklgYw56/CHHeCR7sdLrLlNqg5ZjjuRK3lNI
 REMdxYn172dcDv7P0ldi26n6BORcTu9emKNd0gWchJuW5fw8KN5AEYXFHcMvEPN2X78Nxb7lZ7rahPYOfoB9feRdLzB98MQU/Zn3Ao5esWQs9E69BUm2NrrD
 xEQzM/Qb8OYxCLKrCo+ckOZnfm+4F81sYjKQaPZXLCpqYMNd9N0loGKs/lX1KYmd2volJl0iUrzfDIBd2sA0UlmZw9MEgkE+SU07ZvTV4H7GBQ==
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

Changes in v2:
- Fix compiling error reported by kernel test robot.
- Add Reported-by tag.
- Pass larger size to alloc_candev() routine to avoid an additional
  memory allocation/deallocation.
- Add message objects number to PCI driver data.

Dario Binacchi (6):
  can: c_can: remove unused code
  can: c_can: fix indentation
  can: c_can: fix control interface used by c_can_do_tx
  can: c_can: use 32-bit write to set arbitration register
  can: c_can: prepare to up the message objects number
  can: c_can: add support to 64 message objects

 drivers/net/can/c_can/c_can.c          | 77 +++++++++++++++-----------
 drivers/net/can/c_can/c_can.h          | 32 +++++------
 drivers/net/can/c_can/c_can_pci.c      |  6 +-
 drivers/net/can/c_can/c_can_platform.c |  6 +-
 4 files changed, 68 insertions(+), 53 deletions(-)

-- 
2.17.1

