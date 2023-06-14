Return-Path: <netdev+bounces-10870-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D21730993
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1292A1C20DAA
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193E6125AC;
	Wed, 14 Jun 2023 21:07:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF2F125A4
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:07:39 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3521FD4;
	Wed, 14 Jun 2023 14:07:37 -0700 (PDT)
Received: from stefanw-SCHENKER ([37.4.248.58]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MWAjC-1qbdWV3db0-00Xe0s; Wed, 14 Jun 2023 23:07:21 +0200
From: Stefan Wahren <stefan.wahren@i2se.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Stefan Wahren <stefan.wahren@chargebyte.com>,
	Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH V2 net] net: qca_spi: Avoid high load if QCA7000 is not available
Date: Wed, 14 Jun 2023 23:06:56 +0200
Message-Id: <20230614210656.6264-1-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gO0kR5BythBG+gWfTdyOGzZGoT+88Kz1d2/8tmsYxwYPp/AGmSB
 lPmZeAZOMTsB6i4hRI0Rv35Nha3NCnf6yLKVp7ZWWCBN9YGIWCxQNGk6RRo7icpb3TjxMQh
 msBr09eUxpiq6yEHNZHTPvksWml+PF5pOUJXPk2338HjUNe2J+9cdNMxYnvWRq7u5hQEdkj
 VdMLqT8P2NZS/aHGbGlQA==
UI-OutboundReport: notjunk:1;M01:P0:JfalXIoL/cE=;KFZvrtSmWNt3/u0HYOPGGwocAa5
 CApBh1ONIAfzahlLOysMw2eclK5c0HSckMkhHZqO23CKDW3saahriVbDpq/xaKmaCMtFCCuaj
 6inrelcrTyWk9JEI0uJbxNGevFSD2hyoXOPcU/l+BxU4BcT4J3xvMKdiNqUCjwmVNMmRgp7A+
 RDK5nqaKvrRaS+NrUtrCR1Ce1Cid0dqVyT7Awd8JjIyxJlhePzlf0D2eea2Kr6f1v+an46owq
 kjjmPs+i4UEgW7wHiOLxGOc1tbvCgIXc3lKg4+mmMrqYw4zyhPsLG5Njt4Yq27U7IfMPvetYG
 oo4eqpTYhDw/Rx0E2LcCki2i1D5OhUD9uteMdaI6qZlDtDSZjoiNxb1vCo11m+SfMS9sUjlz8
 7cq7e1YND5hjCwU1gsKOWClMQd9RXreRGcud7uzYnafsZP+pQ2iXWf/Uwyu5alsNTP0w3N5U2
 aRzADYIlMEBRfmO+Tdp8yeemB1zkQynoGMb2QJjtEJZuRhq7U0tud3fzXUQ4qhudZHwxM85sD
 j0Hpw1oP5cbYI9N0d4r9IOB0dApnusNePC40tp6SZyE9tnAZzbMbD6c9+pAZdwMaIklgdUkbz
 7DedsYolqeb9bvjZlEHryWPUapEYQXkHESVb1Jzac7g4hwvonq73qnO0o3usvHyuwC/306ZjY
 L7m6pftMtrAfcpWLOrZJJocMEDlfOjektd2XQhPjvw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In case the QCA7000 is not available via SPI (e.g. in reset),
the driver will cause a high load. The reason for this is
that the synchronization is never finished and schedule()
is never called. Since the synchronization is not timing
critical, it's safe to drop this from the scheduling condition.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
---

Changes in V2:
- send from different account which doesn't break the patch

 drivers/net/ethernet/qualcomm/qca_spi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index bba1947792ea16..90f18ea4c28ba1 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -582,8 +582,7 @@ qcaspi_spi_thread(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if ((qca->intr_req == qca->intr_svc) &&
-		    (qca->txr.skb[qca->txr.head] == NULL) &&
-		    (qca->sync == QCASPI_SYNC_READY))
+		    !qca->txr.skb[qca->txr.head])
 			schedule();
 
 		set_current_state(TASK_RUNNING);

