Return-Path: <netdev+bounces-7120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9C171A30A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B75301C2106D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3203C22D69;
	Thu,  1 Jun 2023 15:48:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ECC22D59
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:48:26 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3793B12C;
	Thu,  1 Jun 2023 08:48:24 -0700 (PDT)
X-GND-Sasl: miquel.raynal@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685634502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o7g8geOFL01H4LLVd1sZGDXNsnzHTuWlDNunKVy5KbU=;
	b=YTeEeNjnpSoDJ4lQg49FIRYkZZGNKscCHYJ9MPLpV2M75sIEprLzL1KIXAmV7hbwfXNU/t
	jyoDZqicLRYEVItxBHJ9ygpHdmdYjR9HnZuxT4YAZ4vBKRJX1gKdZk6oFy3n1Qae0fCPWJ
	DBmb/Y074+hpUM8Js4rms8awnBOrr3fl+fXwgTJ2klN81Sk1ZMDu+77+4tT6iFpk0MjTy4
	DJTm0WoP+jXvDbAyDj4AVNnLyNoeSqh+U1f379oblL7+Lz0/aShbR3iERmPGoepmo0JFta
	410uxPDnDtwAA3ga059jfHWHAWUmuw+rOcNcMrz6f1j4yWeu+CMVBJyBVSyMVg==
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id ADA71C0003;
	Thu,  1 Jun 2023 15:48:18 +0000 (UTC)
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	linux-wpan@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	David Girault <david.girault@qorvo.com>,
	Romuald Despres <romuald.despres@qorvo.com>,
	Frederic Blain <frederic.blain@qorvo.com>,
	Nicolas Schodet <nico@ni.fr.eu.org>,
	Guilhem Imberton <guilhem.imberton@qorvo.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 00/11] ieee802154: Associations between devices
Date: Thu,  1 Jun 2023 17:48:06 +0200
Message-Id: <20230601154817.754519-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

Sorry for sending this so late I was a bit busy, but here is the next
step. I know there are a lot of patches in this series compared to the
previous ones but it was hard to make smaller. I actually split as much
as I could the commits so the review process should not be too
difficult, thanks to the relative shortness of each diff.

Now that we can discover our peer coordinators or make ourselves
dynamically discoverable, we may use the information about surrounding
devices to create PANs dynamically. This involves of course:
* Requesting an association to a coordinator, waiting for the response
* Sending a disassociation notification to a coordinator
* Receiving an association request when we are coordinator, answering
  the request (for now all devices are accepted up to a limit, to be
  refined)
* Sending a disassociation notification to a child
* Users may request the list of associated devices (the parent and the
  children).

Here are a few example of userspace calls that can be made:
iwpan dev <dev> associate pan_id 2 coord $COORD
iwpan dev <dev> list_associations
iwpan dev <dev> disassociate ext_addr $COORD

I used a small using hwsim to scan for a coordinator, associate with
it, look at the associations on both sides, disassociate from it and
check the associations again:
./assoc-demo
*** Scan ***
PAN 0x0002 (on wpan1)
	coordinator 0x060f3b35169a498f
	page 0
	channel 13
	preamble code 0
	mean prf 0
	superframe spec. 0xcf11
	LQI ff
*** End of scan ***
Associating wpan1 with coord0 0x060f3b35169a498f...
Dumping coord0 assoc:
child : 0x0b6f / 0xba7633ae47ccfb21
Dumping wpan1 assoc:
parent: 0xffff / 0x060f3b35169a498f
Disassociating from wpan1
Dumping coord0 assoc:
Dumping wpan1 assoc:

I could also successfully interact with a smaller device running Zephir,
using its command line interface to associate and then disassociate from
the Linux coordinator.

Thanks!
Miquèl

Miquel Raynal (11):
  ieee802154: Let PAN IDs be reset
  ieee802154: Internal PAN management
  ieee802154: Add support for user association requests
  mac802154: Handle associating
  ieee802154: Add support for user disassociation requests
  mac802154: Handle disassociations
  mac802154: Handle association requests from peers
  ieee802154: Add support for limiting the number of associated devices
  mac802154: Follow the number of associated devices
  mac802154: Handle disassociation notifications from peers
  ieee802154: Give the user the association list

 include/linux/ieee802154.h      |   1 +
 include/net/cfg802154.h         |  70 ++++++
 include/net/ieee802154_netdev.h |  60 +++++
 include/net/nl802154.h          |  22 +-
 net/ieee802154/Makefile         |   2 +-
 net/ieee802154/core.c           |  25 ++
 net/ieee802154/nl802154.c       | 229 +++++++++++++++++-
 net/ieee802154/pan.c            | 103 ++++++++
 net/ieee802154/rdev-ops.h       |  30 +++
 net/ieee802154/trace.h          |  38 +++
 net/mac802154/cfg.c             | 175 ++++++++++++++
 net/mac802154/ieee802154_i.h    |  27 +++
 net/mac802154/main.c            |   2 +
 net/mac802154/rx.c              |  25 ++
 net/mac802154/scan.c            | 400 ++++++++++++++++++++++++++++++++
 15 files changed, 1196 insertions(+), 13 deletions(-)
 create mode 100644 net/ieee802154/pan.c

-- 
2.34.1


