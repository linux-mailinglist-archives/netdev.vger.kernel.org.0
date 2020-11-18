Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981182B7EE0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgKRN7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:59:41 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:40913 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgKRN7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:59:40 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfNzj-0002u9-GH; Wed, 18 Nov 2020 14:59:35 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfNzi-0001hY-G0; Wed, 18 Nov 2020 14:59:34 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 0BD08240041;
        Wed, 18 Nov 2020 14:59:34 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 83038240040;
        Wed, 18 Nov 2020 14:59:33 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 5584E20370;
        Wed, 18 Nov 2020 14:59:33 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v3 0/6] net/x25: netdev event handling
Date:   Wed, 18 Nov 2020 14:59:13 +0100
Message-ID: <20201118135919.1447-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1605707975-000037DC-375AD673/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
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

Martin Schiller (6):
  net/x25: handle additional netdev events
  net/lapb: fix lapb_connect_request() for DCE
  net/lapb: handle carrier loss correctly
  net/lapb: fix t1 timer handling for DCE
  net/x25: fix restart request/confirm handling
  net/x25: remove x25_kill_by_device()

 include/net/x25.h     |  2 +
 net/lapb/lapb_iface.c | 22 +++++++++--
 net/lapb/lapb_timer.c | 11 +++++-
 net/x25/af_x25.c      | 66 +++++++++++++++++++++++--------
 net/x25/x25_link.c    | 90 ++++++++++++++++++++++++++++++++++++-------
 net/x25/x25_route.c   |  3 --
 6 files changed, 155 insertions(+), 39 deletions(-)

--=20
2.20.1

