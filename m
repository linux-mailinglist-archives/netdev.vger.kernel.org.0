Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A072BA1EE
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgKTFkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:40:53 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:55709 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgKTFkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 00:40:52 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfzA6-000GFk-FZ; Fri, 20 Nov 2020 06:40:46 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfzA5-000JKw-Ks; Fri, 20 Nov 2020 06:40:45 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id D6745240043;
        Fri, 20 Nov 2020 06:40:42 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 4F087240040;
        Fri, 20 Nov 2020 06:40:42 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id E404720D9C;
        Fri, 20 Nov 2020 06:40:41 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v4 0/5] net/x25: netdev event handling
Date:   Fri, 20 Nov 2020 06:40:31 +0100
Message-ID: <20201120054036.15199-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-ID: 151534::1605850846-0001FA9D-0BEA42DA/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---

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

 net/lapb/lapb_iface.c | 72 +++++++++++++++++++++++++++++++++++++++++++
 net/lapb/lapb_timer.c | 11 +++++--
 net/x25/af_x25.c      | 38 ++++++++++-------------
 net/x25/x25_link.c    | 47 +++++++++++++++++++++-------
 net/x25/x25_route.c   |  3 --
 5 files changed, 133 insertions(+), 38 deletions(-)

--=20
2.20.1

