Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B9032B3D1
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837986AbhCCEHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:18 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:45402 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1840032AbhCBWAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 17:00:00 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id HCz0lBDmUlChfHCz7lGZxY; Tue, 02 Mar 2021 22:55:19 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614722119; bh=NEbohqdbwN+HUaVB9JtituZcWRKqH3j386ItSbrdTVs=;
        h=From;
        b=UL48eIdhXOxIx29uC2TD7NQD2TaY6i/9JHl5+z9iOe98LAZ4aSBm4WIjOh0KigF7F
         Qkkd+Be6dW/c10RNTUa/xe93wXb3aWv7TQ7NDSWQfB1nqbHW8N18bu0LzjE+vgtof9
         yD72a8OAJvGllcAPx3cRQ1ksSHqfgCTxmXNkQgOakQqejVAu0BNzyI6DM6Nm9U8RA5
         nJDFQqg62aw/Rsxr1UEfQRiT+YLkgGEu2ID2AuW90sZ4UB6hbiW3cQUPkTzvFCzW6y
         UDeS9o5+AocJiOrmqhr2n7RoJdfKLEE73sDPl9TrY2ei1llmwWviM+aeUmLJpnA/1H
         mJ/V25sVi/6Fg==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603eb447 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17 a=gu6fZOg2AAAA:8
 a=UWWQGboxuyQ_KojGJ2wA:9 a=-FEs8UIgK8oA:10 a=NWVoK91CQyQA:10
 a=2RSlZUUhi9gRBrsHwhhZ:22 a=BPzZvq435JnGatEyYwdK:22 a=pHzHmUro8NiASowvMSCR:22
 a=Ew2E2A-JSTLzCXPT_086:22
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
Subject: [PATCH v4 0/6] can: c_can: add support to 64 message objects
Date:   Tue,  2 Mar 2021 22:54:29 +0100
Message-Id: <20210302215435.18286-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfCNlwnz3gfkmh0/i+idqmVXV3IC5zhju5NcNjmP77+0Sy4O0/i5t7BHkMNi08XyPTlPv2sB4vCqUCvz/7ifRdCVVcAqVLLovQAbiOld/IqVqy++PRsNH
 LPWSEUzarsR2z4SFq/slAp18rS+7kp+XCGL9PnM99yB2EMRB2daQsNPaEI+yzen7u/lXxMzJzAldven4Y4oa+tKcKW4/C3u8m5mSi2i6szDAmRjDlsEJKGyJ
 03YdaVENCNeYo9GLMo34CTVOXBgRSyAZPqO3I/GXKJ7wHYOncGVN2jboI2nykNmhfT3LT/9xcpIJPWRKcs7xI4ia2+Mct40avnilfc4/60a0AdkvPTiKicyS
 Wq8jwC6oz9WkLnzjUlvT4aChXKS64mBDsACwJa5TLcJYMYh/U82FrLKxMSSZsuo4wTMyrgPYVCQa/ydDeyzzqd4rRV7peiMsn23y2Z67Dd9GaLz1IovrFcDS
 f09PwDeJb3LwU0l7fU21iTrIn8AciGYg52U5d3Fp26ljIIoPiwZhOW1D6IIP48nks3/LORWGTsODxyhCmPKMqmx0Vpfslhvrt8D4KK71UhRv9C02zFfqvAAU
 ID1aS29j/z0D3Mcz0yT39OKFStf2wS9nkou1EcYUe5Z36VN8/N6tyTBHZD5Oz2Mhmnb8f06qtymwzmHbwauXc58oooXHW3IkBoPM/ovqnURybA==
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

Changes in v4:
- Restore IF_RX interface.
- Add a comment to clarify why IF_RX interface is used instead of IF_TX.
- Use GENMASK() for setting msg_obj_rx_mask.
- Use BIT() for setting single bits and GENMASK() for setting masks.

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
  can: c_can: add a comment about IF_RX interface's use
  can: c_can: use 32-bit write to set arbitration register
  can: c_can: prepare to up the message objects number
  can: c_can: add support to 64 message objects

 drivers/net/can/c_can/c_can.c          | 90 ++++++++++++++++----------
 drivers/net/can/c_can/c_can.h          | 32 ++++-----
 drivers/net/can/c_can/c_can_pci.c      |  6 +-
 drivers/net/can/c_can/c_can_platform.c |  6 +-
 4 files changed, 78 insertions(+), 56 deletions(-)

-- 
2.17.1

