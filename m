Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35D91F0693
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 14:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgFFMtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 08:49:11 -0400
Received: from mail-eopbgr150095.outbound.protection.outlook.com ([40.107.15.95]:33374
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbgFFMtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jun 2020 08:49:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jyl593S0ScEb/8REN7eXjSr7uS2ocFU7qBQZScg7RZ1M/jkf7joUsoevCY7NxliHJqRCdY/459CHnV5g/h6ixjVRowx3wFJ7fz/EcyOsBn3MDjxzKdpUVrufmvAuQnN6fcUIqGcERc4Y8wvYcvw76iBVD9q1IIZA+VRJuQPxHn414mz7qKtAwD2EyK5YC1amKkq9x08UNe8DExdOSHd5d5o4z+snfX2pvzeWwxNKuH5csScLifgsgrVtFtsYHZSQPZbubIZ+cnCW0oWzKEbV1nCbHh1oCniCD6cV+enSCCJXmc0xpoUMalTittpAcIPQgks+Wcqvo9D4wJVEQPnlBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdG7XHEFem4zh8B4h3Gu9RvLv3YFXm5g8918qfftPYw=;
 b=Lv1towMckwNLcqJxpAw/aKQ1hdS+ltsYr6ip17wo03zTRbFeI97HpelVy3GRFpptypihc3tIDM7MyWMTsaH6QVJnCt+RlTlqmedVjRInVt/VdtSi4UCDhq8LySmuqfKuKkyYJegauiJgHmvjqrHpRFAPGNTiQe30CQcTr4NX0P/j/+AabRYz2O/7b2cHiXLcf4Hn7GHTuBkMVGxUe+44WwdZpbBO625OvXJhAbTKXbSTL5sqix64xE/XGFVY0dtKXdduNAS2Ir4RXhC9HKu1zqW8Q7b3UMpRt9qZJaruJlADK3WcFyt/VnXAF5XlH1TC8NLDjs7u542t+yOoUnyXww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdG7XHEFem4zh8B4h3Gu9RvLv3YFXm5g8918qfftPYw=;
 b=o/c33j+qu432YvAKV+ehnNP0rpw6YJaR17RxchtQKGwLxLEA/6TrokF1RSWrGsxRnipq0vfEkBw7T4bD/3vs6eYZagdbl9mfW6dzR4+JieBNHDDMZyeEj3+K1wsNA0TuH9BAlMwBT5l12CuqYyIva2STmmms0YbgZE24fh/uEFY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com (2603:10a6:208:162::17)
 by AM0PR08MB3442.eurprd08.prod.outlook.com (2603:10a6:208:d7::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Sat, 6 Jun
 2020 12:49:07 +0000
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::b8a9:edfd:bfd6:a1a2]) by AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::b8a9:edfd:bfd6:a1a2%6]) with mapi id 15.20.3066.022; Sat, 6 Jun 2020
 12:49:07 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] ethtool: remove extra checks
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Message-ID: <6d90f9b2-9bdd-d813-ef4e-ed0a7d1acaf2@virtuozzo.com>
Date:   Sat, 6 Jun 2020 15:49:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0202CA0020.eurprd02.prod.outlook.com
 (2603:10a6:200:89::30) To AM0PR08MB5140.eurprd08.prod.outlook.com
 (2603:10a6:208:162::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM4PR0202CA0020.eurprd02.prod.outlook.com (2603:10a6:200:89::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sat, 6 Jun 2020 12:49:06 +0000
X-Originating-IP: [185.231.240.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d82f7b2c-e93c-4ea6-6ca3-08d80a17fffa
X-MS-TrafficTypeDiagnostic: AM0PR08MB3442:
X-Microsoft-Antispam-PRVS: <AM0PR08MB3442D94DE803B0488838FFFFAA870@AM0PR08MB3442.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-Forefront-PRVS: 04267075BD
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhJZzYyZaqEGryhvrgMBiqTShwbWGhon1bTbJKsYR18sUq+8RYgNlpYY/iaezSi3irgI0L2B1r0LRdoVOJedtTRaREJ9Uadot0FIpZPV03a4s1P32wYuk9+7cSzEzB41AJIYKOxAqrTKIqV8Q/nk210Xzm0PcmmjE9Kr+/nJTNMiimxBtG7XlpJuHp45Nc0ihilPKzEwLmMB12M0KSAg+OiviRJcDxhHqlupZJwl6lmEk3M1MOjQmgy/j5SQT5eXU+Tudo8zZigPWxsWrZ1qZ1rgo+lXsTEW9b8nOYiItdjhgGOT+fQsYPWzc3KCkEfo8nCzGbb0o5IE7f0rM8HpIdPTi2OJFFfPWCZHScotk08VoqjHx6gMgkXnHeprAUbq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB5140.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(39840400004)(366004)(478600001)(4326008)(86362001)(31696002)(8676002)(8936002)(956004)(2616005)(83380400001)(52116002)(16526019)(66476007)(186003)(66946007)(26005)(5660300002)(66556008)(316002)(31686004)(16576012)(36756003)(54906003)(6486002)(6916009)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Ucfs4bVnLhAscoRmgy9J31UAgm21HtGIXke1brZSsoC8kRJ123i5+DBksTTAa7OExs8Jr6qZDKFkI3xBns0jifwbOuvAIpWgPtpmYVztsDqI5nadavEaeKOlzNeGFgBAwinw9JxZ0jjZbUna/03aYMn2sOZ0/idrTR+8ruwfDTK8B7hE3Si56wGIkY1rLCubhSNuU37mg0/hQMiueeDqp1A6wzXDI6DUsLdWJ0npWdHz16JAQPRugrMXOfAXKyOGS1I2YeDT7apK6wvFzkT5UcRNKhzL7ySXqLMcJV7spdPKpjpiNEM9aiZx4a9hZEwNwUW3/KUe6gogn4Kp/Pbe81at1MqYWcw4rvJh6aKsD42FpggklamUezLkqb0Ju8CNSKg1ScoVYbYmeHs8Z6o9Sv6hLhBWwfbaTrcMv8Ge35CKrG8a3g94EJcfwt8hHcPMYbjJTeyBm8cP2/4SoHc/uZSvOIPMtvNkrsWrAeXxt6M=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82f7b2c-e93c-4ea6-6ca3-08d80a17fffa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2020 12:49:06.9631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDqZ4QmrRqpp5gtTN9DzNzZTUSAyUAUF0pSoeMp+0mvk2IliawR+3fWTrzewNM8Ym1UKGDjfhHV5UGJx7IY9vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3442
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Found by smatch:
net/ethtool/linkmodes.c:356 ethnl_set_linkmodes() warn:
 variable dereferenced before check 'info' (see line 332)
net/ethtool/linkinfo.c:143 ethnl_set_linkinfo() warn:
 variable dereferenced before check 'info' (see line 119

In both cases non-zero 'info' is always provided by caller.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ethtool/linkinfo.c  | 3 +--
 net/ethtool/linkmodes.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 677068d..5eaf173 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -140,8 +140,7 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 
 	ret = __ethtool_get_link_ksettings(dev, &ksettings);
 	if (ret < 0) {
-		if (info)
-			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 		goto out_ops;
 	}
 	lsettings = &ksettings.base;
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 452608c..b759133 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -353,8 +353,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 
 	ret = __ethtool_get_link_ksettings(dev, &ksettings);
 	if (ret < 0) {
-		if (info)
-			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 		goto out_ops;
 	}
 
-- 
1.8.3.1

