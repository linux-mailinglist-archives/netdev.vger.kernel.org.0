Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403FF5BEFE5
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiITWNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiITWMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:12:54 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1046EF31;
        Tue, 20 Sep 2022 15:12:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fz6F+Uc+x7J/D8pktAQcTwfgZNszioSHz9AhFfIRa2+uu1OMmYdTplYUnCaXTF5OCeUvnsrmpiRCO9HrL9sbYkTlaWlSIgwU1VIwFRLnktj5Go2Jf/wA+PzscTMWo/DgHL6NnI5XBwafCmT/gJEgxWosfK/vR1xX5JTNjxRtWOcvt6PoX8PryAnDOETn3F/j/Ali+CIAwiHsjLszlzUv4aM4KVFMZHsfYsqCldoC3OF///CpzBc+iJ9hfqQKk0t7Q+MUHQoUzCKWs+8/hCLwuvNVQCCmPzMHjhhBD8K3RpX2RcIaoWYT8AUu23J3QeELcAWTUNdmn9pzxOLujTcCAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6apz+0663ewfrtoWRAeKbmoPGedQUwBkRJNtZGIpaeg=;
 b=SnHpgCpYzUGroFVjIYcYgXg9JtDsH97gMhvA5efOYNrUXMs4qgPuJw2RUPoVeJHIWYqppGGIpwhpBTHiPRQbSXkKfvBhnFD2emAWnc/+KtMVQ9v9CoY3UlotNhIynZNxwkl524GabW/ig6DXkOiY16zSjquxioLax0z6EgzshvBdKeMFMcTHGtvc+Amow3SJ3TBXfgZKdUWeRbYWgHWJ05gU22PQN0ulC+zg27Q6dECArLDb0BjsisSv17Eg/EEsxDIiKwxd80VmaaStlBiXxCIqyTWa/5FCRvqNSr+FIYgGBUFb7+QKmbxu2YDOA92aXZoUT5f1oTDoeCDVLYwjew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6apz+0663ewfrtoWRAeKbmoPGedQUwBkRJNtZGIpaeg=;
 b=mktR/gEoAMm3SRgPcRzdsSLaG1/TmCM6SujzWesCg04p1mnvHRP1rx+CRCd3wNvs5m2Y867cDTXM/l6vNjlMIcbXhTJyDgj2v7hmrQpq4EU/eVPiCywIYAWUioSNeAePH1S6eIbB21bvX17lr+XWa6/IhiGfQ5UtFonepOTIKCYj+bcoeadR2pHF+BRo5DZUKctu0D7R39lyvamkwciaEGgvpPw0ZrVnB4SC7yypTTpUcBGtS6auxtX4Pwtq561SJopDFI6Y9TDHpnyOe1O94YS1wOdIkRdeJfc/ayUsp4wbY0IVvRAhOPr+HRUocZz9XThO/kRkvbjmG+iqmQxUzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:48 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:48 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v6 1/8] net: phylink: Document MAC_(A)SYM_PAUSE
Date:   Tue, 20 Sep 2022 18:12:28 -0400
Message-Id: <20220920221235.1487501-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220920221235.1487501-1-sean.anderson@seco.com>
References: <20220920221235.1487501-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS4PR03MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c20186-7f6e-4da4-3930-08da9b554044
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehj+SlJDszo3a6wWsVMVKruVBeoTAmoyaLrLR0emW+lrkE9k1t1ZX6PA/9vCcdfQt7zCqEjPPxAOfiY6Tfp0kSE3wxG+jX30zJpEiPg3GnVg7m54XT9O49JjDjxA5R3G2Piv++uIdGgMDk2LK5FNrnmVgVNCoyYxlCdcfu1XNOETI6F3WfdDEgrgEdZSTUN2xAmVjKk/+Vwq7GrRS/1mLDBmIjuWrTh2K2+2NKr+UQIS+RsumgBX+bfpRCGM9V1B5FvhholzrBg093aFKuRuL8OEyPKXSYw5nU5jnfHCDF0P4fPb6RSGIptnSrNYYqQe7Euf18x4MOCwGDt6lbDPSGTrufmBIyxLhH2Y8dW3EPaerauDjwPEH8O7KLH8dMca4AzTTOTagortOfVcpszSjXNVq5Z2/NWEhPHTxd0p6PjTITVv0QzsLHnoygGOgT9WJFkwsNkrCf2UUXbYK9ObKg/Dc4+850zRdi9Uso8NiqJ08+0PMoWgz2OYCJsHEsoAm0o50R++edPjV+JT2+OO+nZBV/mt+gFJ5+Vx8zB2NBGciJ6dan001tt3H/BIhIgPn9BXbigx/578dV8Q+VTl9I43vAR0z9ibmKMLntK1p9YWzbokQ597+h2VjhhznQvJrdkgBK8Ms+C0xqKYKo8hxwSBRQBVLZSJydxub0VVvhaZwGJQnf8Slp0NzsWn+Q8YsnflmK7zTGDTYfkICUCWar8hvi95dwbRmfUBKmo1CZXm05p5WNR58jYghTW84d8BJd/5M2zbJAcy9UdVhomd8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(7416002)(8676002)(186003)(478600001)(1076003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(107886003)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pWdAreTjRDUBv7KD24F1XRjl2mpKFi6GNkmiEWZZVm025vEbCIycrG/ExNGC?=
 =?us-ascii?Q?W9dOC2+WiEptAgaj2Rp023HpbNSkKXI/NLrTyM+PdfpDjFHp39h8yLWIgrz9?=
 =?us-ascii?Q?EY7DPOs1/ffPzFI0k/ec7d41kbrj2/Vrfh8hxxCaWVTG+M9ODGTrQ51rmG7w?=
 =?us-ascii?Q?wntNLqNz5xJRLfTR2NEj2vBVn6Lxm3jGs46Ui0M+97KKoXGjA8j2En5coWq/?=
 =?us-ascii?Q?un0exbhMNYtm6UAQ9RTlS7Fcfcf+TUmACfkQK1YNqd3NBVo6bR+26/i/ZOS8?=
 =?us-ascii?Q?BMLrlN6Gsx/KuW31cXLKinB2UD0vgYjrwvXP5zBk4jRm7BPaqSwKMf9Cysff?=
 =?us-ascii?Q?I+4V8yEaYPTqzCXQ8r4IcjV702BrITmbTI4Homx1TKSULIg6q/B+WJ2lyERT?=
 =?us-ascii?Q?O8YO6xZLtyCc06f0PEedhXqc+ax7r8SQhGNcXFbk140pbvizm+NNE04dstJo?=
 =?us-ascii?Q?+EapOh1c+HmkxM2VOHStlEPixAuKu1caHUs1+edQ3QhFhEwUV8sOpfj2TYCm?=
 =?us-ascii?Q?EXqdqpMiGR9mHn/Vt8JInUEqV/wiv9KzHk5Nq2875VUJDOjjim+wgBEt5rIM?=
 =?us-ascii?Q?7l6vUfA+9wT4+cczAOpAgfJCS7u8Y3UqNoWNCsx2g6lqwabVVcMbpgiUoNpk?=
 =?us-ascii?Q?4QimSRBvpDDyZmqFQaMg8qRcQQqHTXf+cuGFX0eqX+ELV9z3wKCiSsN20HgC?=
 =?us-ascii?Q?pRwGvkxkaLxnM+GqXEB9phQg4Bx+IZQh/v8zBNOSnrqMe2PZwocFi8dW1p2U?=
 =?us-ascii?Q?XvdLyh3D7L4isC30LJ+GEs9G6M/w+6ZHMjTFxpmzkaewt8JliS42eahAS07y?=
 =?us-ascii?Q?fetGrKxpU3b2n1aesDtwbftd8hYBX8itciOrZs3GRMOGQGFsICBAGEtlrdnw?=
 =?us-ascii?Q?GHGyolJLDxwjh5420kc9vEr6tcayXohaQMdLM17jsNRSml828V5VoV9UjICl?=
 =?us-ascii?Q?G6PYZh4ePRmcnY9a2XlMI8uJD9s82EMSZp8xJKhocgn8Fom+Um3CI30u8CQE?=
 =?us-ascii?Q?L3TGXN9eVPC8gQ+NfXdZNq3miSBV321fn+dd1aQuQKf0TQ4SxPX0CUeGjZFN?=
 =?us-ascii?Q?DZ91QlhiR8NrsbGdA/srxbwXyN/Tb2sPybWUyFtdzVD2PxNKxlOAdtDtJHF+?=
 =?us-ascii?Q?5/b4a6cCJgoAExuJQjSLa97jrhzgthJurB8wfwmG85KHC2DZ0OdzxnSCMPBd?=
 =?us-ascii?Q?mwYDlBn23jfc1NYdbj2JAlz4ic5KkVwQKiyuJcS3dSH6cXqauKwa+w5Yxnhn?=
 =?us-ascii?Q?Q+voU9iqBLBHXdiUUUZ+8MG34XUF6EPiTYFtXzBJB5/mqcWSK8RVr+9kVxzT?=
 =?us-ascii?Q?RzGlzV3X3+SLIA5ybXCqlClbWRn1MRPm0DcmIiKSORbQ0Ky9BpLcnRnvYU34?=
 =?us-ascii?Q?8e5XYqh2tH16YmZCYViKKkbCrO7WvoHWYJ39ioqAehBJouanJl7r0i7ajRP8?=
 =?us-ascii?Q?KtVMEBA7ULyQxtJ0O4ijxjHW9CJSe76BGzreK/6TPBSoWWADMi64+8CWR8oE?=
 =?us-ascii?Q?VUWgAU8yurDejFuMr5HkqWKq8ssdVenzDIe4VQIESzH2RreAnMFxBDF2E56O?=
 =?us-ascii?Q?1ZnphE+bgeZtsn85LJFQTO9wCeJY4dTjTd83QtIWq3Apzd3k6nRLtG8BDy+e?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c20186-7f6e-4da4-3930-08da9b554044
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:47.9866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jxOchBr6qlq47gjUh3yqGsq8UOg+OfKCLX972YUrNjCuUq8+utG7qftXKqnkIO3LN1D93+1C9RCQtlDDshY0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This documents the possible MLO_PAUSE_* settings which can result from
different combinations of MAC_(A)SYM_PAUSE. Special note is paid to
settings which can result from user configuration (MLO_PAUSE_AN). The
autonegotiation results are more-or-less a direct consequence of IEEE
802.3 Table 28B-2.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v6:
- Reword documentation, (hopefully) taking into account feedback

Changes in v3:
- New

 include/linux/phylink.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..1f997e14bf80 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -21,6 +21,35 @@ enum {
 	MLO_AN_FIXED,	/* Fixed-link mode */
 	MLO_AN_INBAND,	/* In-band protocol */
 
+	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE are used when configuring our
+	 * autonegotiation advertisement. They correspond to the PAUSE and
+	 * ASM_DIR bits defined by 802.3, respectively.
+	 *
+	 * The following table lists the values of tx_pause and rx_pause which
+	 * might be requested in mac_link_up. The exact values depend on either
+	 * the results of autonegotation (if MLO_PAUSE_AN is set) or user
+	 * configuration (if MLO_PAUSE_AN is not set).
+	 *
+	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE MLO_PAUSE_AN tx_pause/rx_pause
+	 * ============= ============== ============ ==================
+	 *             0              0            0 0/0
+	 *             0              0            1 0/0
+	 *             0              1            0 0/0, 0/1, 1/0, 1/1
+	 *             0              1            1 0/0,      1/0
+	 *             1              0            0 0/0,           1/1
+	 *             1              0            1 0/0,           1/1
+	 *             1              1            0 0/0, 0/1, 1/0, 1/1
+	 *             1              1            1 0/0, 0/1,      1/1
+	 *
+	 * If you set MAC_ASYM_PAUSE, the user may request any combination of
+	 * tx_pause and rx_pause. You do not have to support these
+	 * combinations.
+	 *
+	 * However, you should support combinations of tx_pause and rx_pause
+	 * which might be the result of autonegotation. For example, don't set
+	 * MAC_SYM_PAUSE unless your device can support tx_pause and rx_pause
+	 * at the same time.
+	 */
 	MAC_SYM_PAUSE	= BIT(0),
 	MAC_ASYM_PAUSE	= BIT(1),
 	MAC_10HD	= BIT(2),
-- 
2.35.1.1320.gc452695387.dirty

