Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15964598958
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345021AbiHRQqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345009AbiHRQqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:33 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99CDBE4DD;
        Thu, 18 Aug 2022 09:46:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+6vjJDkxQo0SHXd3FVpxxLYtCmEGEw+zna2Cu7WXEZTscJDH91xRjq4YtdX4lSXqJ4R4azDoZZ3HlUsRl3g8va2zJ78Pacb+i43PW4V6Nap4vlVCnx16HYHt20+QGk90d05pQhUxgRqslMQSz3zbsR9XMGcihlKd+67GiedeTQkgy7+tXWmmqQQy1ElsirrZ51qqQgiDNUOCPqxhsRWJux4s4q0ZIE/LY67MWi4tjdb1HFjX+nmltHuw0QIuzA3Dna/f3YJ/SfJyP9i0WO4+aKxXnTKwOt11ph4XSsD0o0rXLQZmY2I16suV4VB2LQZNeYIrAZi2cvjD/eUb2JEmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjcsfjliJwSEh13O05pl4nrVds79IIkn4hXvFzLQxyc=;
 b=m6Yl/0NxHbRV+ppuMRp12YD3JzrjnsGe0MH4DWA6bNk/1OALGg7GTwkeo7VJCEWOq1AV1UGywBo+a5qBVIzOu1m2K1j9kRkMwpyYUKpcptIpon2+PA15wdjtPL5nDv/dLFZ+SlZLsMqOBIS6v46TteXDoilKLSxkn/xZ0hdsKKggcnWYxU8SlZ4dsrCB62RPNxVPH3x7tE6MqLqur0V5hw1fPTkaAgfJU6M0Axg9uhYqYuKGK85Z7NmzpzeInGYN+xeUiZhEB7XLDGLMUwtmjKZk+m/M5ylZfPCK/asAw3qJVUsiAh7GoyNXSQMdjDZ2XLEtcg57TpVNB34knd6uOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjcsfjliJwSEh13O05pl4nrVds79IIkn4hXvFzLQxyc=;
 b=LWfE/lemokzoccNYexXV/nVOMp5WPuJI+W0knZ3lYGsiIZiCzoA9fVpnIWzxCMBqE3mFGupvpJ+Y5Ag+n4Ei+e6q0A+pfHJW0nxJuDwk0Nx7bAjFMgSyFBldUP4E6mBc85juC3SU4C4TSSmrrl6QbTphZLEX5YPQ5VW/Lp4DybO8oFN2ApgTCgHIZIWTVpoWZU9Vs9dNu1ztTAWLO3+MLZgTVpxaTqw7cbSjYo8SSI/uohfDYmkGgtJtUxlHgMu/rmUTDBFVQka7AiJpRCvHRPBsg+hw7NG7u5UcGxPb1HctPrsc7DWSPRgT+FRp1Q6wkWfxdGLagaNegzc2exLhoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:30 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:29 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 02/10] net: phylink: Document MAC_(A)SYM_PAUSE
Date:   Thu, 18 Aug 2022 12:46:08 -0400
Message-Id: <20220818164616.2064242-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818164616.2064242-1-sean.anderson@seco.com>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c03eb5d-2112-47b9-fe64-08da8139332a
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAIPDBfVGC/2gxoMG82hMbEJgqiVXH8o/r3r+VBihrgwrsB2SS55i73Tcm6vpYHBefRxXOutRA3C3toTovC1vdQF56oj8pxvo8p3xAaEyB0b/EPMNu5hZTMJKnIOkhf0i4B7qoPRGIqvry5K1CRmVRNL0vA3ubHBkmlvH/s39ZLGtNUQr/I8Cn1y/JWJjv2IF1+YGc+V9T1UNTFA3B72ukgu6TbpEaMaZoj+0zCrhLOvMd7fxorI1BqiZFVwzDZIacqzsGik5RQfwoLMOlKshbiuDtA+5aeIwddVaUokt+yQHDQxQhuQZLLLZpbXfMGBcDl/k/yNsQEycEdiaJZq/61sC74bcu8g1XLs7sXv+Rml263SjieC1NCN5HPy/SH6ltZNvt68Hh/fa4meIh9Hv5J/7KIjwXZ+Klq6qADsLCbzNwHIJMSGbLl4hME35lYGx3ziPPEzWPsD+ilt/JGcu3AGA012kq4wQDWvVjPHQ6nRVhtS7s4+8rqkjVxQ8a9ZjdGHcn0ZVH4Q7/4b0UVOj4xme/FeNb1GRaqPME6AKbxXGCYoLWNPBL1seJ9N37AgBr7GBo6mWiKCN28k4kk73Dj2/0wX0xZNwH9N0+X9y3o3Ej+53EUg0uL5YLE4K9cKwTIa6mhSoxQm+dXu9C3GGfIu4KDJMz9iOF+KMdOjp1uoUwoyX8bhpCFStdmDZJ9e8dT9DB4U2ocJ3sTBA628i+MDi1rY8RRiWIM0tDPbM4A8OGD3qS4dp5BGUYl3CONT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(107886003)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DhXoJUBlT3eXA2SZqPEHvZHMzz82Fqx45MHaf6Nz9o8xMdlJpFNJOQohRRCI?=
 =?us-ascii?Q?yzyVcXrbbpJt5LoS3+bLYb7FwyNWZay25wJOqkzVKZDUXHUQc10rYvz99j6T?=
 =?us-ascii?Q?Ox/qhx/sk/XpBJBVRwE/HAPYaVv5rs6XGIIUuSndBEZVDzGDMdBIwmFmrf9h?=
 =?us-ascii?Q?IhCWYVsEB91FGYd0yoZtxkmXVE1Trti51BmHZdqvbhVsgJD1MDh1MLcV/6Dv?=
 =?us-ascii?Q?ho3J8S0LLL9vZH43PYh02YUn76kvuEZmcWkKCbu+4OFWciLFQRJ3PLdB6u5+?=
 =?us-ascii?Q?AljFleCtqDMtUS21TupalEZvQuRzoEjyaC3ZnQXAzWNwTBEzUK4EdbPUz5UT?=
 =?us-ascii?Q?iQpxnUS5K8xIv/bdRoPmMFqURHxVHBJqFJuHEnxaILnDcrGEOAR7kWdJd4w/?=
 =?us-ascii?Q?sg2Za57csSzYomfiFAjlMQLPUfkZYKTzrHTYLUDXGs93AJaIeJob51L6yox4?=
 =?us-ascii?Q?EA+JKBFheHJm2JDnHQV6NDTvKrOBOJwwXE/IBp3ou2jX+mspG1PQOft/HV8J?=
 =?us-ascii?Q?VBOM3djN/GozOTakj+1epLKXyX/DlA4DZImjcdKecqzgHe6zkt6msiVgMtIh?=
 =?us-ascii?Q?J/Esq3KO1mD9Z7RBGetkuWRQKbE1VXno4id4DjqWgGmiZoVmgx59tCs0XDZ2?=
 =?us-ascii?Q?V/KkIWE0nkYCLEQcuLQZQLXytr0jPJ7BcTPfd68v/TBk77hIISAuQxRHcUfh?=
 =?us-ascii?Q?CalJxHBB1cnvOoFZLM1ReCCeGrtR5yOTFOQepgjembjdvtYDuQnRg1e66eS/?=
 =?us-ascii?Q?pSsbSchKH1MJDogePSWYJpbK9KDOa5u1rhhilCcHhZ1n2VcAJSvPD5FPe+qL?=
 =?us-ascii?Q?EupMfJ5BD9OJScgyBMcnfysBIekrpG5AoWWHIiOoi/xN9kDbmj5ig0Bcd0bO?=
 =?us-ascii?Q?xTfXcFbI9AZqZz0B9oJbxqjUeb4lmIu0Ooo4H3ywQs2BLh5h4fEtRbJWTnVt?=
 =?us-ascii?Q?7SjPzIjSgKPB9RQN9cEaE6VXPeL5wkMPFUzFIK5/aOAC0OxdhekoqWSQwbi6?=
 =?us-ascii?Q?TbmJuEqINCVcq/TUPTpGdwFBwXZ4RvnbmSijiDuPwOOwYDyEMqBhWZU6s40X?=
 =?us-ascii?Q?7bDTo2n+c5Ug3j5DiorSLAjLYIrjnk6qHu1v6pwg7QDrmKoFJiCqrdpFg4dT?=
 =?us-ascii?Q?20ef7twARGPow3y4Zh7R5VN3Sc7fG2zlfi04Cv+7hLHTvSnIRjY37UeQI0LD?=
 =?us-ascii?Q?GkksBWEzOnt/2dBMTz2vsMApWvyBMbM3gQB7FhbsjR/erhGjKQBr3cBBobAK?=
 =?us-ascii?Q?zl6ey2vq2FsnRy4XfkFHwlDVAMrG82SS/nP67vRO9plDt0+2XpPhDMELUlPO?=
 =?us-ascii?Q?KMTgRwUTk/gNnUlSLSFUk6SfTp7awO6HMsbmYbZirHe5NUzuDE9n7mIFlWf4?=
 =?us-ascii?Q?4Ii+kxpsFssOcKjV5lLpkBIDk+JLo7jv6do4NvDpohaxj+ZQ7Tby7UubYiXf?=
 =?us-ascii?Q?IKywzGvLY7pG4vH2yd3j+HbwPzorwUXyq6Ta+0f9gS4VZGK7eODGIc15sQuW?=
 =?us-ascii?Q?kSIfQAXJcq1YpdNr+BYEspmGsYgzU028myftCmYFdpOVaSzHtJKIbQNpsLYC?=
 =?us-ascii?Q?Cd8sxg52d3LwbfQSzDaHvQHuO+PDWGvLJ8eFlDBPtcDYkqQMduFpabxGNrhz?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c03eb5d-2112-47b9-fe64-08da8139332a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:29.9014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fVVvo/v7KyrNj8y85NB3s04fiNdXf39rYhCP9Ji1gEfJq0Rb3IuMEvAZWkNxTmCkjNqlOyGwXfJnVfmPyMm4yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This documents the possible MLO_PAUSE_* settings which can result from
different combinations of MLO_(A)SYM_PAUSE. These are more-or-less a
direct consequence of Table 28B-2.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v3)

Changes in v3:
- New

 include/linux/phylink.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..9629bcd594b1 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -21,6 +21,22 @@ enum {
 	MLO_AN_FIXED,	/* Fixed-link mode */
 	MLO_AN_INBAND,	/* In-band protocol */
 
+	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
+	 * ASM_DIR bits used in autonegotiation, respectively. See IEEE802.3
+	 * Annex 28B for more information.
+	 *
+	 * The following table lists the values of MLO_PAUSE_* (aside from
+	 * MLO_PAUSE_AN) which might be requested depending on the results of
+	 * autonegotiation or user configuration:
+	 *
+	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
+	 * ============= ============== ==============================
+	 *             0              0 MLO_PAUSE_NONE
+	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
+	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
+	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
+	 *                              MLO_PAUSE_RX
+	 */
 	MAC_SYM_PAUSE	= BIT(0),
 	MAC_ASYM_PAUSE	= BIT(1),
 	MAC_10HD	= BIT(2),
-- 
2.35.1.1320.gc452695387.dirty

