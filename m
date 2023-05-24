Return-Path: <netdev+bounces-4997-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8061970F661
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B9CF2813D5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D8E182D7;
	Wed, 24 May 2023 12:25:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6D6182A0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:25:32 +0000 (UTC)
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1F59C;
	Wed, 24 May 2023 05:25:30 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
	by mx0.infotecs.ru (Postfix) with ESMTP id 0127411BF7BF;
	Wed, 24 May 2023 15:25:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 0127411BF7BF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
	t=1684931128; bh=9mAjhgzeqJ7XN8wp3Dnu2jv0mqJQOccXz7CqEQVQHKw=;
	h=From:To:CC:Subject:Date:From;
	b=VC2xCnBzIQNPacx5/gYtdGIZGnKlrudWZOCCQvxEqdQYUZ04IaeWNAHEPDb2F+T+9
	 BCzL9RVCOe1TSp5dT2TbtzAu91SVVPE63JSU60dxW/u95+axQPOweYkVdCFWxgAzJ3
	 UdhvCdJkPLEtSm8UqZxc4ELLgzf7l0W4SfSlkGn8=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
	by mx0.infotecs-nt (Postfix) with ESMTP id EE1F530CF59E;
	Wed, 24 May 2023 15:25:27 +0300 (MSK)
From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "lvc-project@linuxtesting.org"
	<lvc-project@linuxtesting.org>
Subject: [PATCH net] netfilter: nf_tables: Add null check for
 nla_nest_start_noflag() in nft_dump_basechain_hook()
Thread-Topic: [PATCH net] netfilter: nf_tables: Add null check for
 nla_nest_start_noflag() in nft_dump_basechain_hook()
Thread-Index: AQHZjjrSqRHcp0pJTUepPr3ePI89VQ==
Date: Wed, 24 May 2023 12:25:27 +0000
Message-ID: <20230524122448.1860908-1-Ilia.Gavrilov@infotecs.ru>
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
X-KLMS-AntiSpam-Lua-Profiles: 177575 [May 24 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 513 513 41a024eb192917672f8141390381bc9a34ec945f, {Tracking_from_domain_doesnt_match_to}, infotecs.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/24 11:31:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/24 09:52:00 #21416728
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The nla_nest_start_noflag() function may fail and return NULL;
the return value needs to be checked.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: d54725cd11a5 ("netfilter: nf_tables: support for multiple devices pe=
r netdev hook")
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c09e4d12ac1..b49f7f877ba6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1588,6 +1588,8 @@ static int nft_dump_basechain_hook(struct sk_buff *sk=
b, int family,
=20
 	if (nft_base_chain_netdev(family, ops->hooknum)) {
 		nest_devs =3D nla_nest_start_noflag(skb, NFTA_HOOK_DEVS);
+		if (!nest_devs)
+			goto nla_put_failure;
 		list_for_each_entry(hook, &basechain->hook_list, list) {
 			if (!first)
 				first =3D hook;
--=20
2.30.2

