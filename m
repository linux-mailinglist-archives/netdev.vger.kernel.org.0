Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5583271EA
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhB1Kjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:39:53 -0500
Received: from smtp-17.italiaonline.it ([213.209.10.17]:36310 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230165AbhB1Kjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:39:52 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id GJTalhz13lChfGJTglvZRl; Sun, 28 Feb 2021 11:39:10 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614508750; bh=ziAzFVZ3uS0lb+druwSg3LA2nuwxKORpwdmOSwsrVeM=;
        h=From;
        b=nCBVJz8btVGh/maCUphMLHHernNphjdPL4P+D3iDdjoFzksl+CC+n+MC7zedEaQEk
         jnVIwhVYbwnNczGDndzNH8e6DzFs7ClA+GfCm14HQC5JnuMEWzuqBcVvuyTsJ9Jqm0
         xeyJvwwMm4JAITvXHm6aFKyFIXKn3jdicFJG5b9EuEERK7SQjm6D15m54F/faou2fk
         rHtD8wHq4KboVvxOAI/vdwW59vghjMwJh0o6p8KMB4Qe7c/rQrItyrGdz5Qkdp+ErW
         5nFyrxjCMyW8X7evHg1ibH9dljysPZOfMwTCrLgfPDc+6/QhaRbz3o2s9pz0eukn7M
         8lzX0Sz15lVew==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603b72ce cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17 a=gu6fZOg2AAAA:8
 a=Tq4YLLmbGr4d6G5IlPUA:9 a=-FEs8UIgK8oA:10 a=NWVoK91CQyQA:10
 a=2RSlZUUhi9gRBrsHwhhZ:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
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
Subject: [PATCH v3 0/6] can: c_can: add support to 64 message objects
Date:   Sun, 28 Feb 2021 11:38:49 +0100
Message-Id: <20210228103856.4089-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfBfdn0MAFYXUTT9rWnrZZsFBNZzaW6Gt1SyHLr1O1thZ+2m3NdtXD++Z7t/W8X8IBi4zrvE98Wpm0R7zAwtJFRvwa6sw72TfiEm5gJ8+HsLUdMe/y0YC
 11crQcDsOYJ26ES4Z2dm0fUGSl/C5SEf2fDJ8dNzhVFi39Wllrq9LLNOvCluhWxNL7bmZ4u0w9S++GwBWY3WVnRLdyFLevNeN9zrNoQgIVyaVrtGl6ai+6mu
 b8JJCHWwhqiemSq6+Z9rAjNiXEpW9n1ind3ow+I+OZ+8/Y5DvelqcEZlLY8AfMHTD9kQX3i4K4nUwb7QNuaE2ngVCEiEdObb5IqJGLbG/UGye+zHNMIxvTuR
 MasSCjH++pzRwkNWUJCyyUgOzi0/SxBuzE7exZKUenRNZiEJP3KVnZZX1yCuP9FAL9pzHd1WK3ra+M1f1BeUAef7h0GvXohn5v74hrxmn3rIgMSe42ailMqW
 ebMMyxPD5nqTs98SulmNCVmvKQpBIDQC1gJ9e2aImamVefq8zKAsCEoh77Y6E+q5XX10Ovm6R2V0VXEndmyyt6bPtYdjVWNWmWLbZGf5S/r2w9P0rBhda5Qy
 vjw6EGxAdlj9P6Cbj/jDxBOUYmyIhCvUf6riVDLGqpq2wVbORrzOVik68kVTbzshjW9ANZwksgK64W/luXHqDKGIM9AEWipcRm3SQOdGEM8Qzw==
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

Changes in v3:
- Use unsigned int instead of int as type of the msg_obj_* fields
  in the c_can_priv structure.
- Replace (u64)1 with 1UL in msg_obj_rx_mask setting.
- Use unsigned int instead of int as type of the msg_obj_num field
  in c_can_driver_data and c_can_pci_data structures.

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

