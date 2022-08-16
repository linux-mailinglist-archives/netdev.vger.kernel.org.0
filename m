Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC3E596583
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238007AbiHPW3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiHPW3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:29:34 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AEB75FE6
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:29:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PY2hPqn9RUHkjB8570kjX7AnMeeJQP/jbfSCHdTWDUpItTGvl3F3nEpPASGwMKVmXMzgyjQOiUUypBtpKxofbzgkiQMNxnKthkcfX1Sk6LqPM0r3Da+gHKEEZfyz+I0RWqD1NtlxjONPtt31EkPteAjQU3ycndm4oCx/M4vD3MMLWj1Lmosgmi4BHgGI+vSncuXlo77770OCFNXd+tS4CMJPtNH8MCWn7reWDMFceB5VeHpRaU22BrqqRcAV5MWPjh+J/ujYMS1W19wX8ZZ9XTu/Rht8dr17c95cV6FB4PySTpTUJopUg3qm1mwkvbrDqPQ0efe3DKRD5JZV5INbZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9GZMpP5xWxvqHT+V+u8nKlJoZGgRsYQ1v+BTKIWw10=;
 b=PSN916r6YEWPBy+MPb5cr2O7iQDtdzTwl5TIVvN3/7Qt8AMtNtSsHqmhjNvDTS29C0vLdnAD6l4RCXB//RlM5+lnogIwCuU7hPQtVh/cmVtNxGnWE2A2Xvz4bhQ09Urp2F3j8MIIFo1Z46CGCusdbk3zc3F72+Zrigv6A64XRBVBceaE97bMQ+ZisK/qhgaQX1OOzapUlthjnxrPc0UPUSvhZM97Xzo1Kp7r5g1s4raPfX3G0LyX4bKTAHcIVtuO2SUoE5DTLzo+31JlPBnQl3ddeoGyqR/N4KHBDDg7fR52mgColbb/L/B3021WPZ6Y/QkHvP8rBcXaMsrKor46cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9GZMpP5xWxvqHT+V+u8nKlJoZGgRsYQ1v+BTKIWw10=;
 b=ovcVxS6AuiYaEEJ2U6lUtb5ejCwMUIqPUW4PXuMG5yXkyJEF9kGFcTDiUPiU5524wZavaidx94/w4WF1gxA1ceNu6sDmLKxIrtQCG4+o7v3FA52N8GXYTmLCl/pg98Ax2PoZO3bxKCKtq5W90R5jsYEt68P2gKLXWrNO+NMjBJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8618.eurprd04.prod.outlook.com (2603:10a6:20b:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 22:29:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 22:29:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: [RFC PATCH net-next 1/7] net: ethtool: netlink: introduce ethnl_update_bool()
Date:   Wed, 17 Aug 2022 01:29:14 +0300
Message-Id: <20220816222920.1952936-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01c67073-3e10-4b98-ec0d-08da7fd6c97c
X-MS-TrafficTypeDiagnostic: AM9PR04MB8618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p0bwxsaclPTMWVlUFlwDd7UBGuN1j1cshzmRl6SJ8QF8XMNIPjJ/cLEsPdxd8xdfzmkluFAaO/XIrqwMUtVPHicGSZZIN1elB5lk4wcR0osoZRBDL0aSGDCJvVcETih+hd4fWWoPf2Yda44WCyPMtUkAS0/GSkpnBaj7EJ4OlRUtMclp4wWReydqHnJBsIak2Mr6KoqOP4uXTuDwEFpbIgXHMppFx6MirzcDRe4ZMIoBVUIzEe6yJoGBMOcmM6VVkNlNqhwRplPiRIsrG4cISj1j4p24WavghI9248Mya7LlCzNi5LXVZ7icd8deCbpMpV9J5mfNpRB8LT2N/dA6FGOL8Nc5r1A2vvdy8E1DhM6N4KLf0CoX07K9IiPcFZvMVXEJCYmMyoBfx5/8CXjeXqI1k3YWG/gyjJ4W1izhNvP078S3yyWD5WSjPz4+TcxYsnsIe0SGwpm1TrzbUa31iemHShvtP7dq0WMeitarokWC2/Tyx40D49VjkkZ6Ug35rkylReSS4GdPgVeO3v8wz49d9yqwm/uRnjVqZt+gmp1bY97MLtlyHE56V9IOVmbnQGt3l+gKks6WRy7F0lA4K0TiZs2Yg7KM78ui2dr9hnukU0RarT9C1Dbz1elbBAgJ5yXH9Odxy5tDHIa+J3a7ZSaz6sxsqDBNe7PvILFVLF+x/gwtvcZ8uBEJq1FNDBNY93664Dj2mF4FbyN9lDx9kBffTpU2o88Yu+ehTeXENJItJmYd6EuMgfkt5lleDbMrivfht+WzCois3FF/nPgsXOd6MVdjNfyXOA+rQ+UugA7NgLfA2G9fTgo+AqfSzy1UKXsh3ndtuNGY0NmrIl/Wsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(66946007)(44832011)(316002)(1076003)(66556008)(8676002)(83380400001)(41300700001)(6666004)(6916009)(4326008)(2906002)(36756003)(54906003)(186003)(2616005)(38100700002)(26005)(38350700002)(6506007)(6512007)(66476007)(6486002)(8936002)(86362001)(478600001)(52116002)(5660300002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B6Fg1Y+RllZFWjll7xc6GAF7dbUFLpGN+ejkCGIkDFFayxGimJEdifWnsd40?=
 =?us-ascii?Q?FgLviq2Aa5LCnHvNbV9WXzTBB2RGDo8bHuxWwLsZg8nd/yKSVvPfrustTDIu?=
 =?us-ascii?Q?zqJJ0i1I246iEHaA7Ion3LY8dbpAcp5+HYCDeQQmftqyZIAcaSC+8qwcVJ7t?=
 =?us-ascii?Q?C7nXG9VHLCPxMhWEnapd+KhnmwuX6YXWI7mHuAGv3M8eDGf7MGX8aIiNj/RJ?=
 =?us-ascii?Q?w9dYTwNWBKJ34k9Jwrksel28T2jjOESxhM+jbyc9ZQk7XmqSyo0Iu10pwZrJ?=
 =?us-ascii?Q?nO/h5UnzoNg2HUVn1gdON92yqb0m0SCJWXDuTwDiApQEXUVax5qwt+bzriVQ?=
 =?us-ascii?Q?vhSeeTSon+eo6X5FB27Ti1lAmGuMfuZakpOPYF4+Yu87Gtzo27UeSI16Jmzj?=
 =?us-ascii?Q?ycSpYuGtFT/fNKBsKCdHncgodrR4fYhaWAFxGv6dYesD0hbY/S020J00TGu9?=
 =?us-ascii?Q?3c404C9LWq4FmBel5uAx9ZkNcnBS2abfm8n0SdDw+Ie9a4E8NepiuDHJuGvx?=
 =?us-ascii?Q?IcrgsWEXMKE28t8C9quAWqiczQbUoQLnNWJ1x0kwwpSPmi3/+9IizkS0PW3e?=
 =?us-ascii?Q?ZceVbVMMonqwSFiyhPgiad6SsrHYKadwJuSAk7cNDG7wEqkynmE4MsDUdzYT?=
 =?us-ascii?Q?h03EYtjtusCd0IiRVyhoXw4KFBN6YbptVim/OuJFy/2yW3yUJqanxlyDLsbh?=
 =?us-ascii?Q?EfB+mL7RQ0OqBav7qb1qwo9TAG5pex4cABbj7hmG5159JZhJQnuA8MuzqlIv?=
 =?us-ascii?Q?fM1062IWzbimzAmyygs+LkqE/OzVRPaToCIhQqrRJbRkExhVBHLJDBUwtZ5p?=
 =?us-ascii?Q?WhwSWJ3Zf/PWzB7reKruoUExDH5za8qoj4lHj6mjMIBuexe1gyXjvWrrD9Lb?=
 =?us-ascii?Q?aT++6bR6BFnIjAn07P1QPxDrnQewztqo48FvjNPWdmg2YI69CgKxwioQqXqm?=
 =?us-ascii?Q?MMs4ArviMA+V0ypzJyGFgoZKKEN/X0i7bjxn+hZuHQGwaXe1ORT4Xd9oG+5M?=
 =?us-ascii?Q?Cc1XXBPp0jSYwCZ1wMoNEkzx2RlurVLdgpmUFfAR4ijucH762kfv0kbPYftm?=
 =?us-ascii?Q?K4VqDdHM9dK5dctoEWHn6lFZ2pdTQfix7wJjze6r7GFHBCcszGG1r+K4u/Jw?=
 =?us-ascii?Q?M9okYg0NvSmGl2+c26+pNwl6fgjqVW/VdZOaeWP26OS/vOWuNcR7Id7bKPpy?=
 =?us-ascii?Q?TuBXEA0GXD+eunKDm8plHZIRFRS8S8k3csiWctTVAuK6Px6Nja1hFVdpxw4U?=
 =?us-ascii?Q?J57DUP99nwakRMLyhISkin69hSUrNvx1FZ8+ftipTgysRzWIg+BiiECmV2qa?=
 =?us-ascii?Q?dFJEBquexOYXShdfc6knc2VFV161SOQ5JxCre2Wc8npENK/IDtGb4QdWsD27?=
 =?us-ascii?Q?MW54jBzdIDj12Ji6jyyoHiGcxhJunYIARBTw8Q62ORajvQdEmGFYkT3+nAju?=
 =?us-ascii?Q?57tjhmBZ/d6cqj6bbeDXkM0NIyMqCsnMQU91SDrGIS/GJO9pu9/jbQ3mXfbO?=
 =?us-ascii?Q?xGkoTp2sJEo8dRqeeMjpfodFTbJxaSLrcwfuB54ayl1aAkp65kyDCPieB5IF?=
 =?us-ascii?Q?oKD1EtVn0gwBMoSy8zF3MAZaTHoEDs1FoqHO7p2tFxcNUVH6EdpRbit8Ze7U?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c67073-3e10-4b98-ec0d-08da7fd6c97c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:29:31.0232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZr9PTanfj9JBiukdt9ZTx2hMNHktM3gMcNWFoyee/0Mvf4oiHDjSPM4/BW58s0h25fRoeGxG3MUBI6fjEQKdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8618
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a reason I can't really understand, ethnl_update_bool32() exists,
but the plain function that operates on a boolean value kept in an
actual u8 netlink attribute doesn't. Introduce it; it's needed for
things like verify-disabled for the MAC merge configuration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ethtool/netlink.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index c0d587611854..1653fd2cf0cf 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -111,6 +111,32 @@ static inline void ethnl_update_u8(u8 *dst, const struct nlattr *attr,
 	*mod = true;
 }
 
+/**
+ * ethnl_update_bool() - update bool from NLA_U8 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Use the u8 value from NLA_U8 netlink attribute @attr to set bool variable
+ * pointed to by @dst to false (if zero) or 1 (if not); do nothing if @attr is
+ * null. Bool pointed to by @mod is set to true if this function changed the
+ * logical value of *dst, otherwise it is left as is.
+ */
+static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
+				     bool *mod)
+{
+	u8 val;
+
+	if (!attr)
+		return;
+	val = !!nla_get_u8(attr);
+	if (*dst == val)
+		return;
+
+	*dst = val;
+	*mod = true;
+}
+
 /**
  * ethnl_update_bool32() - update u32 used as bool from NLA_U8 attribute
  * @dst:  value to update
-- 
2.34.1

