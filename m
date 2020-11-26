Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471A02C4ECE
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 07:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbgKZGgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 01:36:12 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:46711 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731824AbgKZGgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 01:36:11 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kiAsv-0004yq-RA; Thu, 26 Nov 2020 07:36:05 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kiAsu-0003lF-NY; Thu, 26 Nov 2020 07:36:04 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 09CE7240041;
        Thu, 26 Nov 2020 07:36:04 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 769AB240040;
        Thu, 26 Nov 2020 07:36:03 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 6B83D200F6;
        Thu, 26 Nov 2020 07:36:02 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v7 0/5] net/x25: netdev event handling
Date:   Thu, 26 Nov 2020 07:35:52 +0100
Message-ID: <20201126063557.1283-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1606372565-000064E4-6B688AB8/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---

Changes to v6:
o integrated some code styling suggestions by Jakub.

Changes to v5:
o fix numbering in commit message of patch 2/5.

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

 net/lapb/lapb_iface.c | 82 ++++++++++++++++++++++++++++++++++++++++++-
 net/lapb/lapb_timer.c | 11 ++++--
 net/x25/af_x25.c      | 38 +++++++++-----------
 net/x25/x25_link.c    | 47 +++++++++++++++++++------
 net/x25/x25_route.c   |  3 --
 5 files changed, 142 insertions(+), 39 deletions(-)

--=20
2.20.1

