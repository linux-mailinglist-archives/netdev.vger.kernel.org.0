Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DBD621DD2
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiKHUmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiKHUms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:42:48 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7AD67133;
        Tue,  8 Nov 2022 12:42:47 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A8HQofl032334;
        Tue, 8 Nov 2022 12:42:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=b/uyn2DhR1Fdqjkrf+V8LcqMK8HBEi7P55ivfn8OZUs=;
 b=GIIIoD9XCt6N9ez/gbiwMItqwwvQI8dS5oAEasbN8TBGAIMgUOAEzd1dzwpoFcsQIXiP
 DJ4s0TQWC02F7ktSvvDb1VaX48YRNf9Tg9Hi0XTvF25gFrPy33DuJy8WciedRIqXBqv9
 7eb7nnMEMSfwnDs92SAIsyzsOs07gN8GMF8olwRoEYJ0EHx073B9DYToKOBbOy2zk3iX
 7qke/DrmI2NVruCpu9zapyiwYCv+D7TrUoqLolVv086QAToq0o4caisQodoYJhs9u/Dx
 Y0E4k5WYeVmCYfnsjLSvRi583D9bnLWl2IRCpjP6OjYb826iBSW9q2+pl3WSoBq70+ay sQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kquh58svt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 12:42:29 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Nov
 2022 12:42:27 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Nov 2022 12:42:26 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 834523F7089;
        Tue,  8 Nov 2022 12:42:26 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/8] Add octeon_ep_vf driver
Date:   Tue, 8 Nov 2022 12:41:51 -0800
Message-ID: <20221108204209.23071-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: d1UMSbNckWYHQkkCwzt-C5QmC0JnggPU
X-Proofpoint-ORIG-GUID: d1UMSbNckWYHQkkCwzt-C5QmC0JnggPU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver implements networking functionality of Marvell's Octeon
PCI Endpoint NIC VF.

This driver support following devices:
 * Network controller: Cavium, Inc. Device b203
 * Network controller: Cavium, Inc. Device b403

Veerasenareddy Burru (8):
  octeon_ep_vf: Add driver framework and device initialization
  octeon_ep_vf: add hardware configuration APIs
  octeon_ep_vf: add VF-PF mailbox communication.
  octeon_ep_vf: add Tx/Rx ring resource setup and cleanup
  octeon_ep_vf: add support for ndo ops
  octeon_ep_vf: add Tx/Rx processing and interrupt support
  octeon_ep_vf: add ethtool support
  octeon_ep_vf: update MAINTAINERS

 .../ethernet/marvell/octeon_ep_vf.rst         |   19 +
 MAINTAINERS                                   |    9 +
 drivers/net/ethernet/marvell/Kconfig          |    1 +
 drivers/net/ethernet/marvell/Makefile         |    1 +
 .../net/ethernet/marvell/octeon_ep_vf/Kconfig |   19 +
 .../ethernet/marvell/octeon_ep_vf/Makefile    |    9 +
 .../marvell/octeon_ep_vf/octep_vf_cn9k.c      |  489 +++++++
 .../marvell/octeon_ep_vf/octep_vf_config.h    |  155 +++
 .../marvell/octeon_ep_vf/octep_vf_ethtool.c   |  307 +++++
 .../marvell/octeon_ep_vf/octep_vf_main.c      | 1136 +++++++++++++++++
 .../marvell/octeon_ep_vf/octep_vf_main.h      |  305 +++++
 .../marvell/octeon_ep_vf/octep_vf_mbox.c      |  358 ++++++
 .../marvell/octeon_ep_vf/octep_vf_mbox.h      |  137 ++
 .../marvell/octeon_ep_vf/octep_vf_regs_cn9k.h |  154 +++
 .../marvell/octeon_ep_vf/octep_vf_rx.c        |  508 ++++++++
 .../marvell/octeon_ep_vf/octep_vf_rx.h        |  199 +++
 .../marvell/octeon_ep_vf/octep_vf_tx.c        |  335 +++++
 .../marvell/octeon_ep_vf/octep_vf_tx.h        |  242 ++++
 18 files changed, 4383 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/marvell/octeon_ep_vf.rst
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/Makefile
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_config.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_mbox.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_regs_cn9k.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_tx.h


base-commit: ee1bfbcc71cfac3b570365558cf38cb70f6ca971
-- 
2.36.0

