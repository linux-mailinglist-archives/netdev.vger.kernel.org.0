Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572732C217D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgKXJf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:35:57 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:39519 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgKXJf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:35:56 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1khUjm-0008M0-KM; Tue, 24 Nov 2020 10:35:50 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1khUjl-0005kh-Gq; Tue, 24 Nov 2020 10:35:49 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 74089240041;
        Tue, 24 Nov 2020 10:35:48 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id E5EA2240040;
        Tue, 24 Nov 2020 10:35:47 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 7857B20115;
        Tue, 24 Nov 2020 10:35:47 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v5 0/5] net/x25: netdev event handling
Date:   Tue, 24 Nov 2020 10:35:33 +0100
Message-ID: <20201124093538.21177-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1606210550-000064E4-2563A932/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---

Changes to v4:
o also establish layer2 (LAPB) on NETDEV_UP events, if the carrier is
  already UP.

Changes to v3:
o another complete rework of the patch-set to split event handling
  for layer2 (LAPB) and layer3 (X.25)

Changes to v2:
o restructure complete patch-set
o keep netdev event handling in layer3 (X.25)
o add patch to fix lapb_connect_request() for DCE
o add patch to handle carrier loss correctly in lapb
o drop patch for x25_neighbour param handling
  this may need fixes/cleanup and will be resubmitted later.

Changes to v1:
o fix 'subject_prefix' and 'checkpatch' warnings

---

Martin Schiller (5):
  net/x25: handle additional netdev events
  net/lapb: support netdev events
  net/lapb: fix t1 timer handling for LAPB_STATE_0
  net/x25: fix restart request/confirm handling
  net/x25: remove x25_kill_by_device()

 net/lapb/lapb_iface.c | 94 +++++++++++++++++++++++++++++++++++++++++++
 net/lapb/lapb_timer.c | 11 ++++-
 net/x25/af_x25.c      | 38 ++++++++---------
 net/x25/x25_link.c    | 47 +++++++++++++++++-----
 net/x25/x25_route.c   |  3 --
 5 files changed, 155 insertions(+), 38 deletions(-)

--=20
2.20.1

