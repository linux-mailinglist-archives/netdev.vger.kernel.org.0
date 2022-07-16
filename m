Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B425770E6
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiGPSyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiGPSyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:10 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130050.outbound.protection.outlook.com [40.107.13.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D578A1C936
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFIilpNLGMw1cDT7TlxhkAQ2nVS23X0FZQ7btwdSjFOA4I0BIS+qBvczKZo0NQQdclCOXqfvo1kTT76tPUqgFYzxjJNUnxfUfDfPPFL20Ap2gZIBAlkFfh5IkiUEYg/oN/Z/IAIiPc0U0O9J8AnpHQsvonMB0jMEjYxxHX5z4NBUDB9TMrEpblf0CBGAJC2Mrilm44p7ZTR7874dp0J8MKTm2Zl5PyUqRKHvAtp2dxoTCzaMcrzl+qIJiuOvrd/pI3X//UwAXfcxIwVrzF3OJR7Lo+hn+0FKu//MnMB6c4oNYprAYMaiWQEDT5XRwukPdw4e1TRTB8/SCWhs6UhU1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eA8RScdnKYO6056OBfbmSYZq5OXnCFvuJ42rYfVA9Ek=;
 b=b6cp+zHEIenWBW609PKE177impQ2wIisF8CgK1wgG15faajEXryuJZPK2VAbE7+NSqLyohY1c5UwCTf1m+ylT+7h/cuMWHGSyVjkdUdr+PqqD+APHIabusMiszz6q0WwYd5Ut6SG0w4wFoPbHTIhWT8LXsX2rK5npgkuOIJrpVyeoDFGRVWmkEY7b7v4r6yVoATM4lw7wCUo0x95jrQmh+d380SM15s8w0nTMjWLt8mcj91RGFStF+2spdhnj536Zvckwh9fNKjciTNs3DDfNeouQ7+t+o+gw0siNbK3Z+AwlobRqcg99w/R2C1vD5/9E9NXCxsRRwqNxNYbRHBA5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eA8RScdnKYO6056OBfbmSYZq5OXnCFvuJ42rYfVA9Ek=;
 b=j8URMRlY7NGxk8PjrbBrMyBJcFA8fjXhZ9UZI/IwN7gnnhC6loWLUZs9GGgV49YDaiyNHH1ljIqQIUnAe89XfCkM0aXaj3VlpwjMfXm1drkRIMtrxiH3mtqrozJmR7oPQRNLSNcviHZQya3nr8Eoq729cZzBDzFrhrYKeYyfhrg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:04 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 05/15] docs: net: dsa: document change_tag_protocol
Date:   Sat, 16 Jul 2022 21:53:34 +0300
Message-Id: <20220716185344.1212091-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 112f9f86-d2cd-4cf9-8e7f-08da675c8c73
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 85V7T3FtOqIlSy/BtSm8s4gMe2SIqr9gTFx8mmRo/rCO+FKeltDbwWAEeWGGolokImnrgF9tFT274G1eKjmaY3E3L9NuWUAA6NWWFdCMxM21mVjO0vsTV8tidsKPfqTEoNppG8k6wmlsWu8tSF9or9+xwn4wHXexquhbXBBj446771we+nKsY8gZrEcS0yvd09YW385MY1EVxHvmop9/gNN3kZg1/Izmm3b7paI2DOHb79vPwTeY8Ch29fTN0yM29zZftrViVM4PfCj0ZMuAeScqcew6LBVTll072oql2ntiyOkzjRPnJ2fraFE5OwJCgHMIre1/K/2MDrEseM04xpBPPOvqTIalHnjD08xDugmPBavx53rGmdJlrA3UsM/tgNpHz/61HYZsE5FYUihf2sa/wCgJZ9D13w0LpGg+zgZ5wwX7KlXi9ffrEevII3HK25njjo8jc0yR8nEagGSBrKO8pQkaOXJGEmglgIlqOJsgjwj6rxws4TeYp/WGBQmnFiULESVghqB0DhOJzkIPcJsGy3UQbGkeWP63yh9lxfQ9SPvU7wmpOyyxVxTl2ZsrC9+V4H8KffLpl4PplBPtjxHh03spSZJQsGLHjXaKuLzTsMkqx9ihgMiTgo6MMhu650ggGUu7cFV4SV56aBruokX/9wtooKdgpJqIc6apt4qwhtJrgNHv3dqxYeyqAwN8UHUdDlPI43BTWu70OwPKxhuLnwmelpzD0bmedimP2w9m0FuJQWJXigzv8GB+mGdBwaz1FoSusBdPrD7LRVo43A8SgW+PlExlPEnM3pFU5s3KlirRWN37p9s8URWFtmct
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B+sixBaE0QOqvVpqnpAhw7AiWQRQ1g3jPlnOFY+Lp+gA3yNMgtXz6dgMDzYV?=
 =?us-ascii?Q?rusj+Mvht71CTvGOB5CV9awxpOs5IKrFNNWPMmC7F8xPPHbtaRFWeKpWYZNE?=
 =?us-ascii?Q?w2ubWjthwR817otHDvfvRhtwoaxXSLTF5U0bJ6kx7vmCIok4hevUAmw1vaTt?=
 =?us-ascii?Q?QKsROuFAM1D9YQ9/l6AUVMDb6ANYx4q2ITthzExJ2bS5f0r5GFmA83Bgt1bP?=
 =?us-ascii?Q?NhXYt2VjMhXwTbtsvfHv0RQKS/fZbNsXkgVZxjLkNfkvUOqIhfjMfwBZV5e7?=
 =?us-ascii?Q?b4vFGnPHe0c8l3n2QOu9Xj9EgbVl8WGymaz8U1cq1pZ4zDxoM4BTap2m5Vtn?=
 =?us-ascii?Q?WaVsHl9IzD/cWX5vuZjgGfMMRFxuikYc8SLNNOeXkwaKXV4FczckNWQLHXTO?=
 =?us-ascii?Q?9aVBNIw+9uCaBaGgM0s82ZjfJALlF1qSITrnqMRx9RNts0UZZRu9lNolw9Zg?=
 =?us-ascii?Q?SckLH53oH7ZLF3tN5lmIahtoI1A4F4GqVy5I/r4LzmZ4794+kHfz9Y80ZNHi?=
 =?us-ascii?Q?VQ2N3NfRX3fnQ0yol6bDM6LS8Sj74UWbVKFcNP2KopV2gYmKqC2/sGTT2P/e?=
 =?us-ascii?Q?oB+zJhqi2pCeazZGbvuHh13LOIRZ40QvQhTFgo9La+cOPvEY6EP1vhLsokma?=
 =?us-ascii?Q?KlJudxQJB3+UuJyBt3KebG+/iAjC8QkIaOLWEDWk+xN2q16VuqysM3ia9+LL?=
 =?us-ascii?Q?V1VVkPdcgENE3N4Gf3w47I5IHNaXjnUJ7mcJwUg6hxLHmjtOIGNdkQc8/AbV?=
 =?us-ascii?Q?HIW1QlI1khi8mne6AkRhPJ3JY/3Y0TQgplDr5hf7UjWhjOfpXpMtyPhiX0UE?=
 =?us-ascii?Q?CkQuWD2Ohs9XJJtka0PY8lUz3dhYSVQTnsN0EhvlXy/+yxve4OmqElQCVi7o?=
 =?us-ascii?Q?bHh4urCVxzVTQB4c2GPSuioQWfN8k9VVWuQddl3fvsAOHQ36RqlRdfR6uXBn?=
 =?us-ascii?Q?pHjHLcBomZemqjrZOmEvHcINi0NksyNb66NtVOq1t6EfGQYEfrST0777oZiu?=
 =?us-ascii?Q?F0FvyXC0YJCm99bchC4cGruibFWQy0cBYRD6QX5OqqdZQH/RcXKKd7SXgqzk?=
 =?us-ascii?Q?NGuEqvEKekBtfBAR5uXQ0ExwM1Iwhv4t9J6OwU1Hb3wPp7RIFIRybwYCiQlr?=
 =?us-ascii?Q?akdfT0FyEGt1gfdPnSKi3XSeYmvQqZXg2CuBqLfgbJengUEp9ANH980tFuBT?=
 =?us-ascii?Q?y5iFgOcoDxIT49TydtbgP0B93tLnJ1PNQq/6DWDcmyRBZ0iTYr/rj9qp5ui+?=
 =?us-ascii?Q?lRBIwOxBTG2TdWYsrFKopwl1wv5GflnKBXL0VQpEBAP8tM6dNGd+44f0AeuT?=
 =?us-ascii?Q?/FreQanA0tT4DipDVCo6Q9xEX0n0idRJcg3UfaYgypFP6KqLSW/1VqoR2phj?=
 =?us-ascii?Q?nuN2VVSQv2Rqn459adGPo+F0XvJWKBpyx7yCGJZPagPvg39lT2QOVEm1/dL6?=
 =?us-ascii?Q?M2kQeUgag6oJwe0IqPR5U8RB1Sa7aLG40BU0u4qzpZOPQfliiiYzNwompQjV?=
 =?us-ascii?Q?kqY1/FmqQzG0rxx1Yi8lwJxgUF3JruVORpM3K7LSsbyeGXPwyD5I/HieDtq1?=
 =?us-ascii?Q?oE/m6NtNP5H/wY4zD++0TymaQbYcyNxzhZGOpMAyBd/xcbWsurfUWwVjXsuc?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112f9f86-d2cd-4cf9-8e7f-08da675c8c73
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:02.6756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsPfiaYLFKxaBzFMF/Hre1kvCTFsdnp1dyXvzEisH97KGgYJmCJVnWJamHtTkdPx+WZB7WO+c9eaizhKmevnFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for changing the tagging protocol was added without this
operation being documented; do so now.

Fixes: 53da0ebaad10 ("net: dsa: allow changing the tag protocol via the "tagging" device attribute")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 76b0bc1abbae..83c1a02376c8 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -600,6 +600,12 @@ Switch configuration
   upstream switch, in case there are hardware limitations in terms of supported
   tag formats.
 
+- ``change_tag_protocol``: when the default tagging protocol has compatibility
+  problems with the master or other issues, the driver may support changing it
+  at runtime, either through a device tree property or through sysfs. In that
+  case, further calls to ``get_tag_protocol`` should report the protocol in
+  current use.
+
 - ``setup``: setup function for the switch, this function is responsible for setting
   up the ``dsa_switch_ops`` private structure with all it needs: register maps,
   interrupts, mutexes, locks, etc. This function is also expected to properly
-- 
2.34.1

