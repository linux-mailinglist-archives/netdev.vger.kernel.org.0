Return-Path: <netdev+bounces-138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 519486F5636
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09A902814FE
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7508A1116;
	Wed,  3 May 2023 10:31:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A167D505
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:31:23 +0000 (UTC)
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3AC19A8;
	Wed,  3 May 2023 03:31:17 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
	by mx0.infotecs.ru (Postfix) with ESMTP id 80BE4108C502;
	Wed,  3 May 2023 13:31:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 80BE4108C502
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
	t=1683109875; bh=KWv390BkinmwwaXe96nBkFt4dpGvWr/qTiStRAKAVhA=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=dpafbq+bhwwYhA/y/OAtDaHVigVH9ay9e74OwOcLJtfsPm1DNxHDuQUzGG05RYT0t
	 5+6Nazeye+n6Hwsputbg/8i2nbfFm0wXrQBLv/dedMvzr6CN8fwe40rs1WhKMKk7D2
	 A8zTVwbqmF+cVei3PnvviOMBr2fKv1hPZrxsBeew=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
	by mx0.infotecs-nt (Postfix) with ESMTP id 7909330A7C8F;
	Wed,  3 May 2023 13:31:15 +0300 (MSK)
From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC: Simon Horman <simon.horman@corigine.com>, Neil Horman
	<nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: [PATCH net v3] sctp: remove unncessary check in
 sctp_sched_set_sched()
Thread-Topic: [PATCH net v3] sctp: remove unncessary check in
 sctp_sched_set_sched()
Thread-Index: AQHZfapjObQbDNSxlkamyq2whi4gYQ==
Date: Wed, 3 May 2023 10:31:14 +0000
Message-ID: <20230503103108.3977352-1-Ilia.Gavrilov@infotecs.ru>
References: <ZFFNLtBYepvBzoPr@t14s.localdomain>
In-Reply-To: <ZFFNLtBYepvBzoPr@t14s.localdomain>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 177141 [May 03 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 510 510 bc345371020d3ce827abc4c710f5f0ecf15eaf2e, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;infotecs.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/03 08:22:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/03 05:22:00 #21210527
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The value of the 'sched' parameter of the function 'sctp_sched_set_sched'
is checked on the calling side, so the internal check can be removed

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
V2:
 - Change the order of local variables=20
 - Specify the target tree in the subject
V3:
 - Change description
 - Remove 'fixes'
 net/sctp/stream_sched.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 330067002deb..52d308bdb469 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -155,9 +155,6 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 	if (old =3D=3D n)
 		return ret;
=20
-	if (sched > SCTP_SS_MAX)
-		return -EINVAL;
-
 	if (old)
 		sctp_sched_free_sched(&asoc->stream);
=20
--=20
2.30.2

