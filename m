Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52EC50B4D1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446468AbiDVKSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446462AbiDVKSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:33 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2079.outbound.protection.outlook.com [40.107.104.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40AB32054
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzjnqYAjM+2esPLHJ3nmQnoGeD0qnH5KW+QbGKMB67eFCD2CZUxBRyw8NsKEy9l6bsu7FoD8I36vMfr/6ToDV/gTCbUWjqMdte06pFMRifVIb7lstJdoNqxVmsBCjiS8pn4x93Y0rpz0il4Pc+RvowiEfbiHQB4mSkwoo3sYy/vB9vYj7ZaI7JdeMB5RocnjNC0vyO2qPf3j/yeXKcvZqKXFwJMx2NZZxCTh2ZKc0chV3XrsHqnEp6sXNGnd1OUZzDqzQUCaaeI6i2dL9QPgzYG2GR/hBfv86k1cY77WRUv/cHaVxEqWEf3b5Qkw5YAoVYXSgi4AZJQQBT9PIA0/KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jXX+Eq124fodDf0PvA3GdimKQoaKUja+m869JJB6/Y=;
 b=gRsMUDjGXn5LcKjSC90T5kkfyIdS4lk7Ohvo2YByl1F29/GIfz5R8OD7OKBGQMdBJWcw4Qx1a+JwIGutrZagTr8rTpBcZww66Puuga2aX64gfJc26qN/Q1St9BvDun9fMiXEbqczTvXMJiAofmn4YbSXjArHk/MgeL+WBt8C4vYJAL7x9I0dbQkNs+oZ/Kl2AhEUAZ9Ou6nm8pCJDy6wj8iVVmT7Myvo0QqM/gKeDcCKpdcVaTsZhgwAWQB/Ss1gqKbhXu0CuFrWmsLQFsP63wpIlPzUEy9X17I/NOVlucgRBGsPcPmwHKO2MFAlELY3T+uBWnVKu123NZAnUvkXgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jXX+Eq124fodDf0PvA3GdimKQoaKUja+m869JJB6/Y=;
 b=lcuwsJY6Fo9/FpFeC2bqxk9aqA3KpzAuZlwxmhUVaVL4X4VvjwGhOQLv6iwooiVIXpnNh4HWi5savxwscsMS6W9J04M7yR/OIhPlnxt/O8CFAseuCXKdcKNQSPnfgjK/Xx5E5iV0QpKCGFgpklDPBO3F5MXWRQbP76BIteds7WM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6836.eurprd04.prod.outlook.com (2603:10a6:208:187::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 10:15:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 5/8] selftests: forwarding: add helper for retrieving IPv6 link-local address of interface
Date:   Fri, 22 Apr 2022 13:15:01 +0300
Message-Id: <20220422101504.3729309-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
References: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8407e998-d5f5-4f76-c570-08da24490386
X-MS-TrafficTypeDiagnostic: AM0PR04MB6836:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB68363047218A2ECFAAB50721E0F79@AM0PR04MB6836.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3FhFuZOYLecPcM3O+kZPQMQK08J16xPtTboQigwyeueloGXL5KJhhPxaw3nSQGlA5UByWXkbTCB7Qh8dGokqRvdsLy6CZ5bD7lvvCpl4GfEt9BBPlJPmqKe+hd4xf+vioccAK3azZJ0ayUq1ySYcI65yc628vlnZKpZQH/VNyMMXwWJp5pMMdlM2uV25WNPCjMjCnvt3lOSekYf8wAjykiZtIJk4Woibxr11jwa8HUIYEUUP43gf6Pv59MdlMp+GDZFw4pTqjaltHQgPlsbqnRtQcYGa9UfEKjIb9Cn3+XgwNMpx8e8va/oBcRgZthoF49XnDlbI1Ay8HbgtpKbB0ex9CL5cyi5W4qZu7zjK/9HFM7lYt1X0jt5lGUWt+ni0Kp01c+6HQwa8S8ymjzCkGEUx9lE2Q9aXnf35psq0ObR0bss+5VM3UQ8hZYWxlsRWlaFVjOyg247T6O52ox1TXF4jZFr/s+vLVNjLtoaqQEh7DBsToPKgP14caK5/D017SJzIXxMSCyu5LYre877gX84PlB4inDS+Z6zUNxSlDnWjjN8hWQ9eC/kSWJ2tf87lmqbOvv1e3YpO1U1GL+6BIi/IAgMMy9XJhpbFmsBTBySsEUuB+Y4SydQqxR9KeJ4EipYB7ZgDjBT1sxmNM2LfHqa+jVYOYX3cWx/9uJa+WPWBgbetZdMMHynD3ADjR2DEtyxMNmD1E516CRvkd279w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(38100700002)(38350700002)(7416002)(5660300002)(4744005)(2616005)(52116002)(44832011)(66946007)(66556008)(4326008)(6512007)(6486002)(2906002)(8936002)(6506007)(66476007)(6666004)(8676002)(86362001)(6916009)(54906003)(186003)(36756003)(26005)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7BAUaOCNsC9ttu8htfPSyvYHSVr7clAvzVgLwfOgklZZms88sLt81tKNlksa?=
 =?us-ascii?Q?haQjpLPMC/if9D3w5YrTg202FUI1RVrdZ6fwuAyiiaGkILlYEWGyFyT4ghL6?=
 =?us-ascii?Q?xBYB9oD46zgwv2ydV5oS23ip+h7A3Mj2VI6zAIJ62m9Wavp7OzSjKsuPHGng?=
 =?us-ascii?Q?OmB8iUPiZaQIseQ8zCDdLXp0p84+siEZpeqyOlMSl0R272weqxOITP3uScQN?=
 =?us-ascii?Q?gytQIQix7fMEoBYcynAJmrhspGWQSwnSzqpTXK/Jtfs8eRFrNkPgl5FjbV4c?=
 =?us-ascii?Q?dSGLL5ilgHJdo19ad0noXlo5NUd0bVt3ML6K8rTvP2YKn8iDq5zZVbfaDi7W?=
 =?us-ascii?Q?rhan2d9T2Da42cgen0EIg5oP22axoJaMXhuPXqOIYiMs6TRwIUaAY91lQp42?=
 =?us-ascii?Q?ZogWUou918fZE5sQAyFe6ASIHz8tX7URlQT/5ib8WLnfqRS4uVvoSiUHM4aC?=
 =?us-ascii?Q?rV9N36emT2G1YVcZVBQuYetHMOlou7US3tCK7HkGAU8HowrmgPNA8+qoWGAA?=
 =?us-ascii?Q?IZxZ38GrCqU+N2nTqOqRD4RtigS0vXWmKx5vXyyWdx9+ZihCPpdPngZABd95?=
 =?us-ascii?Q?fnUlhwdkO90Rbe3U/qMmR3z59aHaWSnZG9js+CZijtp0w7kMs3yqwmgJzLPL?=
 =?us-ascii?Q?aeYNzD2jBsdZdare+DHF3kkkvUO+hqjW1OpRwq7MtM9DoLmoMQ4vCgvLew0z?=
 =?us-ascii?Q?FGVtJ7f9QbeZyiMcadRjvG5i32Y+pyhhx+ny4G2h9CGEmpNbcvvjReZo3hZe?=
 =?us-ascii?Q?vgIgH0z/eQohhvDcQzWBSFTgjMkhlE8SE/6JMnWp+0jU1iZFWAZK5vtX2Pci?=
 =?us-ascii?Q?yltuajac15UxPtB89P5vANNxsnhoVIz74k8YQPJ8Rvl/U6Jt9bzVC76IF86p?=
 =?us-ascii?Q?SuuoMHF+KRitydDgpC/IumPv+xvI5x/OksccE7vFWzzmX11trZxBaYPlgICD?=
 =?us-ascii?Q?mFB/i95qNoowi8ZJB+ajk14w8oy2wB+x3ptykj/6p8/JKNphR7Lr1sPmpE1z?=
 =?us-ascii?Q?RlSOqdpOAu6WXgWtWk91foz+6zO5pLqAxMepzJXZ/x6ilxrry4endXnnvbim?=
 =?us-ascii?Q?W8Dz3ziPAm86cd44zI/KIAf6Mn17PMHBJrrMUXbH6cAAvApLBVlZGrKwPS/P?=
 =?us-ascii?Q?bpoY6etY1lg0/LAvw21IEX1oSFQ7XI/YFFtRFhmyx5rSi8ZFYO3dF+B2WrP9?=
 =?us-ascii?Q?AEFfN9Mi09UmPwLXo5FxvY7VoGEIYEqdS46sB34mNRUJvVmjB83+LubQZrn6?=
 =?us-ascii?Q?dvkK4MRXrFcnJLQqkGr8g3IsbWF0l97mzdz++SJ4PNwutJ6BIiGHazHqtb/h?=
 =?us-ascii?Q?7BLniYavjENrrL3EKQCZwyloBc7r5H0GaBBpX186rMaNBCq0LscSYk7k65mi?=
 =?us-ascii?Q?rnWCHxkbc48LQORYK8PWuE2mw+AgcAuIvjmngmmgPKuCBk/t+YgXA6nBfIOb?=
 =?us-ascii?Q?Ti4nO8oTluLrU5tKA5EgpXU+vuEmncq5nHUk0rfiAj4Bn8t0vsGTz6cuVVro?=
 =?us-ascii?Q?N8co0l8uxRNsbTVNv/Muzwqu9mNiszv5VIzuDHwJPU96bN9jiMxDYlbJkS7Z?=
 =?us-ascii?Q?TleiyDYeLYtN4fAzznTzOFzQlO3dQpzmoamx2xlmzE0L8KWV2DnK677xSa7A?=
 =?us-ascii?Q?8VW9V4HPSPKgsv0VBFpZMup//kFzcWAXLDrjLQSKRBXZDA6F51V+HdEXjWe9?=
 =?us-ascii?Q?QoyfNHqLc0CGzqnWGQF9VispATw3XLceMpAyS54NdmWDD2Tm4Lpwgp98snYW?=
 =?us-ascii?Q?wy4dOgJuGwexlMBcHX9MGcATvOvk0VQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8407e998-d5f5-4f76-c570-08da24490386
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:23.8597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WngOPCmpHcDesYAXpqmiP1gzntU7+pY0pqIiYp2/1/GAu4R4ggj5yvqVTssmZyOQhg24ugoykT2mWev76qUew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6836
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pinging an IPv6 link-local multicast address selects the link-local
unicast address of the interface as source, and we'd like to monitor for
that in tcpdump.

Add a helper to the forwarding library which retrieves the link-local
IPv6 address of an interface, to make that task easier.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 15fb46b39fe8..5386c826e46a 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -868,6 +868,15 @@ mac_get()
 	ip -j link show dev $if_name | jq -r '.[]["address"]'
 }
 
+ipv6_lladdr_get()
+{
+	local if_name=$1
+
+	ip -j addr show dev $if_name | \
+		jq -r '.[]["addr_info"][] | select(.scope == "link").local' | \
+		head -1
+}
+
 bridge_ageing_time_get()
 {
 	local bridge=$1
-- 
2.25.1

