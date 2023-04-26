Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFD56EF7D5
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241375AbjDZPkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241140AbjDZPkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:40:21 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Apr 2023 08:40:18 PDT
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199EF423C;
        Wed, 26 Apr 2023 08:40:17 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 7B92A1085789;
        Wed, 26 Apr 2023 18:04:31 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 7B92A1085789
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1682521472; bh=MedIm+CRBEd4wBFXItt1kJMETQQkrwjcl8xl77kiovM=;
        h=From:To:CC:Subject:Date:From;
        b=HPLnLR4ts/3Y8SbFjB0Xawyp50TRlwaIt4fceP1t8BbvQc4lgJQTqtFLVJozsO5Ij
         VKwm55CT0gqEPbRGtPFD/DevevAQJ4l2OrJI+CZFIC0VIPXp4rEzoSX/Z1tj10yAJ9
         +cgB2C/GewAMwc9RQ2DAVXqp7dFsFtsLBt6mcWEc=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
        by mx0.infotecs-nt (Postfix) with ESMTP id 754A4305F450;
        Wed, 26 Apr 2023 18:04:31 +0300 (MSK)
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Patrick McHardy" <kaber@trash.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: [PATCH] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Thread-Topic: [PATCH] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Thread-Index: AQHZeFBn+k9SKA6Ie0ib54vOLuLARQ==
Date:   Wed, 26 Apr 2023 15:04:31 +0000
Message-ID: <20230426150414.2768070-1-Ilia.Gavrilov@infotecs.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 177015 [Apr 26 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 510 510 bc345371020d3ce827abc4c710f5f0ecf15eaf2e, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;infotecs.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/04/26 03:46:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/04/26 04:45:00 #21166225
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ct_sip_parse_numerical_param() returns only 0 or 1 now.
But process_register_request() and process_register_response() imply
checking for a negative value if parsing of a numerical header parameter
failed. Let's fix it.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expe=
ctations")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
 net/netfilter/nf_conntrack_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_=
sip.c
index 77f5e82d8e3f..d0eac27f6ba0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -611,7 +611,7 @@ int ct_sip_parse_numerical_param(const struct nf_conn *=
ct, const char *dptr,
 	start +=3D strlen(name);
 	*val =3D simple_strtoul(start, &end, 0);
 	if (start =3D=3D end)
-		return 0;
+		return -1;
 	if (matchoff && matchlen) {
 		*matchoff =3D start - dptr;
 		*matchlen =3D end - start;
--=20
2.30.2
