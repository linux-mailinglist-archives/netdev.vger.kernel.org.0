Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F76423CA
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiLEHoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiLEHoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:44:02 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D8513F22
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:44:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRxXVZGQJzG90bkOtPwKSTLFQoGAUJQI0NO2zUg4tpYi79jgDn5/eS4mrS1PLoqzf8/NvOYLcpedJVR+HNUVKzpMLT8wLdPdyJXljJ1j4CTe0nLFszxADXQUNV7EWwg3TeNqpKdvKPVGXbzh9F7e3c75aK24oYgNfBOqD0i3gv6oX1NuDzOX5NOUSCWf5bwuQpLkUeemNTiEJJcJ58zi5a5OL5de308yfjFzX6dTrr6IMu51n1laq/4VLkP7DitSMsihcq8tPStwEc6j/UpuUASQBXlzrJETJnQs7wJk+mAuLdHn6kJJgqvu5Ebr6sHny6tWm4l18232Ftwcgv4h1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ETmXry3f+7bWBnHi7TJsQfqt3JBJsRP1p6vLGxiN1E=;
 b=N7lfwZJZKKYzLtHHgoBC9/pvk6fztP7uowH1TElWj31AhzOFxeMddyuA2RlGEnXkfe8s0QMeOBmFC0eyvwK44EstVq387zQJ8jNJhoa0JVJ4LNcSnVlkMU2JLG08oekywUmbn+IRKBjW3hmFWeSHEtvUZp7IJo9QilMoqNuHUKUTwQRB+uL2cwnA7BgQRgQLzV09lHu3zQnhRVu70zOk3mgGDuNx/iiNOioqfSkwANVVfcEYUt4hKYcc57ZzQY7dhWdOvCVJzOLxxYT7/8/hIgoD8JLNZLed85anCzFMYHXwJg9aH1IFKz2A/7dwYkThEbHLzwqdBqB5sr/j3c3uUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ETmXry3f+7bWBnHi7TJsQfqt3JBJsRP1p6vLGxiN1E=;
 b=dmS3GNK7EyH+j7/ElNVBl6befusVxEimB/SUfZxBeX1GhAAB50DdqA5nFIhMz0f7jh/Ahm2fb1RzEo/X9AEslDyX/s7KSuENJmlhcykksrKGvtxLM2CN5JT3KDgBWK66Mg/QWXXO/Xs3M40h0f0RELUsj1xt613jQ+WBZ7nvQExrGs+hfI92N2XRRuRrX/RZ9OTYdObWPhmMQeiqALxUVeQKQGKWdWbfLI0Eh3NVRASPu4N3UNLiZwT7m1egVOyJnvg7k0JpNTnYdRy6LghhXOOV4RgOj51EhyowgWkYXf3vqV/Ltf9Cgx7nSi2mCPNqt3wZRFccu3NcGp34Tch53w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 07:43:59 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 07:43:59 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] bridge: mcast: Remove redundant function arguments
Date:   Mon,  5 Dec 2022 09:42:51 +0200
Message-Id: <20221205074251.4049275-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205074251.4049275-1-idosch@nvidia.com>
References: <20221205074251.4049275-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0068.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::22) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_|PH0PR12MB5607:EE_
X-MS-Office365-Filtering-Correlation-Id: ace697e3-097d-4f9c-0544-08dad69478b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CaS8e8RvFwp4mVjJorgcMuL8lArsft+qvPhCKBnxk/OYovRH5DAsGEZ94p3XDmw8Qi1wuHrrVB3nI5L7Y44CW5crhLsH+G/6nFYC9wH/6ZEw3AQGFoc/Kz/bT/Cbi5yLSleplo4QpmFxe8f4GNqUhGWG1hyMI6FrcMzV+sovwfVhJYqN1/wEhFL0/LivXgJrI6eyeXUXgPmRQH2CZM4TmQhVH9badbsqRcK5oZt3nJrlUqdOaqJc/vzsvC8khFq+hQ7OQ7xTEPVaXob6o11QsfMGkmJZMrGry2Xoia5JbkHx/e2wHHG624vvxPGlXAgz1FgoxnYNHIloXkq0kj5a33jPqYWzSN1E8ZgN329LZoefSw12ETQMZJSxZvanoyoFoCtkJ4qIoJOhMorshqGK6KsJHqiKjxwqDXF0BzpX3k9WKy2l5y1/bMwEMBw2MExpCNsSzIAC/L/aGhNC2+Fsx5ROYaBKggOJMoTgdEJbG3s450O54vSQZ3IYLTjtag6WCyZ871jmA7onrb6BBqDa/k2hprVb6jIM0pu8WqKHNQVvRrCbMqFp2Hg9usmef+HRnlfcImzUHcm0FQJR8die70q4E8A6nitcAlXto98MZl+gEszju5miGx95OHJrIffP0ehQrwomjID2A+3RyygM+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(36756003)(38100700002)(86362001)(5660300002)(2906002)(41300700001)(8936002)(4326008)(83380400001)(66476007)(66946007)(66556008)(478600001)(6486002)(316002)(2616005)(8676002)(6666004)(107886003)(1076003)(186003)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xT9wDPHm5VZSZhg6rmMyRcf2ZozOroRxLRqeRhyl/kxcncQZPE7E5z7DQRLY?=
 =?us-ascii?Q?IKbur5074Vyv4hNmnD7A0Teh7PkEtE731O/+OwF5ShkP3G/neFdlDp5LsyOm?=
 =?us-ascii?Q?oHVLG0eNx8kNJlHU3y7AfD/ywKbHqm+hOuUxrV8KC0yQQqIrjWPrrgmqdN4S?=
 =?us-ascii?Q?VvZi9gv0IDzYfKtwDkF9des4W6GgAklR7IrUkjoDxTqhVQ5BqXTJprBgF0dO?=
 =?us-ascii?Q?yIsBNY8JZElMATln/TJmpoSo4D/H5MGyAap19WZw0H14j2xeMtbF/stg6Ha0?=
 =?us-ascii?Q?z5hSp848hI9GS0b6g0E9XBVNxHGP+uGrLiYDwnuKyynxG8fud3cDfVBppkPv?=
 =?us-ascii?Q?ItzDHLAL4F11s8i2/bYUtEUX+ySui/OiRgSekrYK1sI6NhmSk+2aeOcviMCn?=
 =?us-ascii?Q?AByPiomvHKj4ZiqtWuSmquS6rIMy1iT4RHO8tC5g05LyCUN6EA1cpWVmFqEm?=
 =?us-ascii?Q?aMrrKkCT1/09OJQAOG2/fVlveKy9TPqkIgoOXCXDTS0nx696XyL3O6uA+J0/?=
 =?us-ascii?Q?7mk2e7TCC9QSqz2iBcEv18Y6pgmAilaErRCl64JYtw+0Jk5fYDzIQtgj0Ooi?=
 =?us-ascii?Q?QzdRkq6VWWmk6wb5sMOV40CujA0EIzVch5bCVRC9QOmgm0xSzQcnvqrNkX8m?=
 =?us-ascii?Q?aBcXYuqWpSHT+95BTBtXTOkyMXiKyhcpYrESaPtkXTdoPY9x7C5bK4ruYj2H?=
 =?us-ascii?Q?Be3PD7sb1oe2yA11ySxN4CJuYD1HTr1DGRTaCxrOlrzBkWN4sEqVX9x5xh31?=
 =?us-ascii?Q?PlkDNQFRHXcvGQSSmm9kdbDZKoVGMHR4mlxRRdPeXc6iPAu8NpzpzgwWohzs?=
 =?us-ascii?Q?KRMwYCcnkmPfUwDPku2BuGnS7JXL4F7TMS6+KeE5z2ad1k7lie8zhiA//RjG?=
 =?us-ascii?Q?4UO9zIuhmqb0lMSCR9PV05agJcMcKycBRZ7qMnUGxeQkeS1ykYZ8qMpWIA5n?=
 =?us-ascii?Q?DiKPxJx3jjrMtGYuGBq4ymNsHMojymfkDWpLQnmuL10OagYASupvCd6oILuM?=
 =?us-ascii?Q?+6G9IIz4pDIh+XNpwbOqQWmY4YTeQ1Fxy5XAl13HS6RDhq+4irALo3Y4K5XQ?=
 =?us-ascii?Q?lJMfMf8JHLDbXP40Yqt5tvv06DBSjSHGXFxrHbwIItdEOqZ1k0FB9JUEAO3O?=
 =?us-ascii?Q?a8+8v5V6rpl4G3V3Jq/42EpQ++H1emcZjq/EeASJaspwghE/odeI2ZEBXdfS?=
 =?us-ascii?Q?OPmya3yvgNL4D9u8q8NJbalMWFfS+P1wC27B31eG7Y298WZegNWhmqiqNCAi?=
 =?us-ascii?Q?eMuWujukhP/NGlbotTuaW9emCqesdNEPCY8X5HjkO7a3FSFCrnwf5fzv+Sj7?=
 =?us-ascii?Q?qEP+hHkImFm4NeFx2ifH6PERAXMIJ3Sqroyt1xbEFPHWvKqaf/ka28WGrJMG?=
 =?us-ascii?Q?tkTOPmKotSH5udkB2COKwf9SaQYEk8wCnLnH1xWWeOZg3lkBh+HPhfSgWnXB?=
 =?us-ascii?Q?X4UTq6qbdk4xl0iEjX2NKoSoneb7VgMJMh1BSspDI1gpQ3t8kwWwueYONOax?=
 =?us-ascii?Q?1qO6qhYNpvE8WlLB83z6wQgDwGaf7Ed1cz9uDx8Sj8BweC9aNu4mKsi9PQyy?=
 =?us-ascii?Q?dmnQqbG2k8bJI7cS0m7fHZ+WUUqTJ81sHbcphP7i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace697e3-097d-4f9c-0544-08dad69478b3
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:43:59.6110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tRNg66xDxIRdiJ+8cbnl4re7G3Es58IjpJUaDiBHexRzbhNSyBzQujQk4ZqCIcOLPHj781mQvsfKaInCEBWlyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the first three arguments and instead extract them from the MDB
configuration structure.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index aa5faccf09f8..850a04177c91 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -786,13 +786,14 @@ __br_mdb_choose_context(struct net_bridge *br,
 	return brmctx;
 }
 
-static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
-			    struct br_mdb_entry *entry,
-			    struct br_mdb_config *cfg,
+static int br_mdb_add_group(struct br_mdb_config *cfg,
 			    struct netlink_ext_ack *extack)
 {
 	struct net_bridge_mdb_entry *mp, *star_mp;
 	struct net_bridge_port_group __rcu **pp;
+	struct br_mdb_entry *entry = cfg->entry;
+	struct net_bridge_port *port = cfg->p;
+	struct net_bridge *br = cfg->br;
 	struct net_bridge_port_group *p;
 	struct net_bridge_mcast *brmctx;
 	struct br_ip group = cfg->group;
@@ -879,7 +880,7 @@ static int __br_mdb_add(struct br_mdb_config *cfg,
 	int ret;
 
 	spin_lock_bh(&cfg->br->multicast_lock);
-	ret = br_mdb_add_group(cfg->br, cfg->p, cfg->entry, cfg, extack);
+	ret = br_mdb_add_group(cfg, extack);
 	spin_unlock_bh(&cfg->br->multicast_lock);
 
 	return ret;
-- 
2.37.3

