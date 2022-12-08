Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7D8646A9D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLHIe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHIe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:34:57 -0500
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AD65E9E1;
        Thu,  8 Dec 2022 00:34:55 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id CC69B1182B4F;
        Thu,  8 Dec 2022 11:26:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru CC69B1182B4F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1670488018; bh=s0kXhZ5QwF8NQVrywWavoH3BbIaBSkcol4p+WMzzHbA=;
        h=From:To:CC:Subject:Date:From;
        b=Odhxsp/yQQ9jHQH54WIsk46NzZXhtblFcJ6Ujtjvtjb8aYD/EZeLdV4DSDye3AlUL
         VKlJ8qHPtW3mIhPrlyx8l9ugaezJiHpXk4kobWaxPgvg7AOtQcpWqvxtEb8YFXq/Oj
         bcMsHGqEzgu2kKYvTTHTc/kECV9TU6q20ZrDAIdk=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id C9A80301A0D5;
        Thu,  8 Dec 2022 11:26:57 +0300 (MSK)
Received: from msk-exch-01.infotecs-nt (10.0.7.191) by msk-exch-01.infotecs-nt
 (10.0.7.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.12; Thu, 8 Dec
 2022 11:26:57 +0300
Received: from msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07]) by
 msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07%14]) with mapi id
 15.02.1118.012; Thu, 8 Dec 2022 11:26:57 +0300
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Jiri Pirko <jiri@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arkadi Sharshevsky <arkadis@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: devlink: Add missing error check to
 devlink_resource_put()
Thread-Topic: [PATCH] net: devlink: Add missing error check to
 devlink_resource_put()
Thread-Index: AQHZCt7VLcCQYXqvEkyWdGuOlfYO7w==
Date:   Thu, 8 Dec 2022 08:26:57 +0000
Message-ID: <20221208082338.3923376-1-Ilia.Gavrilov@infotecs.ru>
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
X-KLMS-AntiSpam-Lua-Profiles: 174026 [Dec 08 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, infotecs.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/08 05:05:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/08 05:14:00 #20660675
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the resource size changes, the return value of the
'nla_put_u64_64bit' function is not checked. That has been fixed to avoid
rechecking at the next step.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: d9f9b9a4d05f ("devlink: Add support for resource abstraction")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
 net/core/devlink.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89baa7c0938b..ff078bcef9ba 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4193,9 +4193,10 @@ static int devlink_resource_put(struct devlink *devl=
ink, struct sk_buff *skb,
 	    nla_put_u64_64bit(skb, DEVLINK_ATTR_RESOURCE_ID, resource->id,
 			      DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
-	if (resource->size !=3D resource->size_new)
-		nla_put_u64_64bit(skb, DEVLINK_ATTR_RESOURCE_SIZE_NEW,
-				  resource->size_new, DEVLINK_ATTR_PAD);
+	if (resource->size !=3D resource->size_new &&
+	    nla_put_u64_64bit(skb, DEVLINK_ATTR_RESOURCE_SIZE_NEW,
+			      resource->size_new, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
 	if (devlink_resource_occ_put(resource, skb))
 		goto nla_put_failure;
 	if (devlink_resource_size_params_put(resource, skb))
--=20
2.30.2
