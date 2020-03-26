Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A883C1946DA
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgCZS4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:56:34 -0400
Received: from mail-vi1eur05on2128.outbound.protection.outlook.com ([40.107.21.128]:7650
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726340AbgCZS4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:56:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAaWnSGgg37Ft0+YoCZIUKZoUbA3BXxyzDqjxBeKGfzu4GQu9nKU7cxECZGdrjhUMaf8j3ZBlxQfYiTTjLVzQWzu2EiQqAAyYZGlKjabYaOST1wSave9t0db5367bYYtgQW5YhgCC2L1khZcXpfrntByLi/nswlzmV7Rghxnoyece1RlIO0DvJCsSfIFj2EXsywHXsf9OvVL0rXqdQKpj0ff+nF75nPEVWPZ46eSyF47ovj299MM0wwYTKztVkrbNQOGHFfjQS8ErVxsqF1zz8pQVzRxZkAtQM5/rXSWRQ5NhA1IcViSIDKPCGuyBedH1qrIJP3t55cC7YJe4+/8jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+uKuvXvMIBIp7JDVSKO7t+eHoJ4s441xAMcTn8+KCE=;
 b=KJlr8M38MGV5+sCGe407pMdfRv/shfCvrb2WTeAYxfcFL6O8fNa9m6dbfi3wgWKtUeZmZ4WHdSdNV8TGaeFbt3yM1IQqWehEtWYXalboCBgxdDBXtjvBNlPBBGkp3e6/W8xibC60ec8rtWhtcCRiK1Xg8jCbnjEYQhMPZzbqfNavqV8LO0ljWuXv/wzX2tbP569/ZeACzf3KQEJuG1whGHUe0kVO8PqQsh/YigCDNa/zH2V6GPG53iwg3hKcMihxdHtMlKr4/479aqaonQc+JKN3BUpssSywQ0dOThMQQfLGliZSql9Dp6/15jsCtadoZiNMl5qEFscWg7jlv4CHng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+uKuvXvMIBIp7JDVSKO7t+eHoJ4s441xAMcTn8+KCE=;
 b=gZRwl+HIiz4XX/S1P3tm/6WWvbPSQgbiMI7oIKmjII5QuAVbuEj2i4qfcnuCnXiU99X3UbdHtimbjuhRA19WCe3wu+SN9DjbSgBl8p5ISML4Lf0Qlvxdyr5J0K/hgeQemPE+UJBkWg7g6ng9ea/KekvwHSNxbuLzJyS5NxSG2kA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3692.eurprd04.prod.outlook.com (52.134.65.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Thu, 26 Mar 2020 18:56:29 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::adc7:fc68:a912:5f46]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::adc7:fc68:a912:5f46%2]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 18:56:29 +0000
Date:   Thu, 26 Mar 2020 19:56:26 +0100
From:   William Dauchy <w.dauchy@criteo.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net, ip_tunnel: fix interface lookup with no key
Message-ID: <20200326185626.GA22732@dontpanic>
References: <20200325150304.5506-1-w.dauchy@criteo.com>
 <67629ca1-ad66-735a-ecfc-28531b079c40@6wind.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67629ca1-ad66-735a-ecfc-28531b079c40@6wind.com>
X-ClientProxiedBy: LNXP123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::33) To DB3PR0402MB3914.eurprd04.prod.outlook.com
 (2603:10a6:8:f::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dontpanic (2a01:e35:243a:cf10:6bd:73a4:bc42:c458) by LNXP123CA0021.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:d2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Thu, 26 Mar 2020 18:56:28 +0000
X-Originating-IP: [2a01:e35:243a:cf10:6bd:73a4:bc42:c458]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 100509e2-3567-4d34-a88d-08d7d1b76432
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3692:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB369286A0DFDBD156618F9350E8CF0@DB3PR0402MB3692.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(8936002)(6916009)(2906002)(52116002)(9686003)(66946007)(9576002)(16526019)(66476007)(66556008)(6496006)(5660300002)(86362001)(8676002)(81166006)(33716001)(1076003)(55016002)(316002)(33656002)(186003)(4326008)(478600001)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3692;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGEUnAAbVEU1mYmfOqYLIyogqXSHeEoNAJocH3ADtY2NNm5vJwWvL85WcU6osE7YWoNtK/bJSa2J0tgrp1TLg4LzqTBd0L2L/Hl52seyUQAT0IWDbe/bS9wgrJnWHPBUmFNHW+ztBy2Gb9eIvm2H2cpEPaDXEcCsVY65hWt/MMyaXLproxIP57JQBToHcz2MJvsT/HhoEJR6wKh5Knx9vQcnTRzvyL9RxOaf533kucxStD2TBtcZ9tVBE/u4e06XRuamKjnkIB/caS60ZYuuf1lGBI6+D1MyBOoyRSxQYJw4/cHW808XwDzeKxRdWPjoQMf+jrvZwE0MbnVv3rBJ0NGOEAZbI3NgRipXdHORkzQhKbX3GmaT8oSpnET3LbqNwBH0Qdoeggx09dA9I1O1T5ZmWmycUBD9RKvezO3jlpsi67D6Giey+NV4fZFDFNtc
X-MS-Exchange-AntiSpam-MessageData: 9aAficrpzXIIRBltOSyp/lehnxPYTLykJ8an1f6j+yThPgFAghjU9EqqfjkE4PQRARtXegzQTIQSMR/VsJ2aHpI6hx8MYkAN6KIrWWEYsX5mJOmxziv0wNf7l1jC3AjzyNQ7CvxJACHS8RZZ9yYqOOqYogYC9s+FOliqaRODrLYT12DXMfIu0lGXRw6ytR8ujfslStb72RWQcF51hyLLsQ==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 100509e2-3567-4d34-a88d-08d7d1b76432
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 18:56:29.0564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4IXZahXfNBcXb9VKLkPvLwoqxkzdudE6aZicztoStriYJNFKxHLvSMkyBT/bmrE2etaQtW8tDWfqC0pQuMRy6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3692
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nicolas,

Thanks for your review.

On Thu, Mar 26, 2020 at 07:01:20PM +0100, Nicolas Dichtel wrote:
> Hmm, removing this test may break some existing scenario. This flag is part of
> the UAPI (for gre). Suppose that a tool configures a gre tunnel, leaves the key
> uninitialized and set this flag. After this patch, the lookup may return
> something else.

Indeed I was not sure about possible other impacts, as it seemed to not
break iproute2 tooling, but it's true it could break other tools.
But if we consider to remove the key test in that case, would it be
acceptable to have something like:

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 74e1d964a615..8bdb9856d4c4 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -142,23 +142,32 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
    cand = t;
  }

- if (flags & TUNNEL_NO_KEY)
-  goto skip_key_lookup;
-
- hlist_for_each_entry_rcu(t, head, hash_node) {
-  if (t->parms.i_key != key ||
-      t->parms.iph.saddr != 0 ||
-      t->parms.iph.daddr != 0 ||
-      !(t->dev->flags & IFF_UP))
-   continue;
+ if (flags & TUNNEL_NO_KEY) {
+  hlist_for_each_entry_rcu(t, head, hash_node) {
+   if (t->parms.iph.saddr != 0 ||
+       t->parms.iph.daddr != 0 ||
+       !(t->dev->flags & IFF_UP))
+    continue;

   if (t->parms.link == link)
    return t;
   else if (!cand)
    cand = t;
- }
+ } else {
+
+  hlist_for_each_entry_rcu(t, head, hash_node) {
+   if (t->parms.i_key != key ||
+       t->parms.iph.saddr != 0 ||
+       t->parms.iph.daddr != 0 ||
+       !(t->dev->flags & IFF_UP))
+    continue;
+
+   if (t->parms.link == link)
+    return t;
+   else if (!cand)
+    cand = t;
+  }

-skip_key_lookup:
  if (cand)
   return cand;



-- 
William
