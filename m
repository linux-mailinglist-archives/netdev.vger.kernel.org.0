Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497D85770EA
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiGPSyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiGPSyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:13 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A4E1C936
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULiUyI7vrm9oeKKnwCWcmF9whCyX73oIxGRXSUSSUR7kbMB9QB6xHdSUnP99RExu5LgaGhweuRlnGqVmGvryxuaeEHED1Te7LB8lz/EGCMM2qurfKWBuI8A4sMS/E92bDtIB+6C3x/Vuw2e6RhtkYoNNbm+UcZLaHoB9535m+Orco+W3fLXdYfTnS651j4EhU2Dp1fbR6Quc0EHh3dpus2K1VLMDcHNeZbY1T3j9qiXzLAaEGZ/xxkcx4ZXPhjjtfbDgoc/Ab/XKRTYrOQJeJKihd/aIKlcTQI122PnmxiFcvYTC9mESu+YAs1oCyHmwFE7J6mTn+BU2NYk6Dm6VIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdCuoRUilrDG9iXezt5jWN5jHgp7Kzw1vFkr4PBugX0=;
 b=QkjtqI+drPeuIY7flBwT8f/zmNrh1sfsFCXqLEG0PplSCnIMjJwNdiUG1r2LqwyhMI4+jh2CvoSH8F1SYaCyAr8TqBb7xBhIvFu3J4v5W1b7Rr00XTQTdz9g4Mw36UKUIUrobtiqviRjaT6VwfuFuHn+pPasMwtKoF1dTdf0zvszEzUC9bacuMIyb9b5c+LpKyY80V7dkAdRDt6VvYCiglm4BB2JHPD8u2XF94NYV/ARC4qCDCoFYpExgVfdghE7flKoKkgq3W2GTZtEVN9gaFYHHUYfTOQWuh4Zd9DZjbFEZQHMmL+g7ivrZWlWG6geEOtJapNZ8xcSRNjT0ONJQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdCuoRUilrDG9iXezt5jWN5jHgp7Kzw1vFkr4PBugX0=;
 b=gooXH1XvN9UCfyEBAml4bdJSQy3iPpdvjw8K3g7SYGvgqBfVHeYJqlnZGK92Z1RYWsi2qDUkJsw3zHSJRVECSDCxgiWRrWntWR7hrgscnQB+yXGne4uScbObcrtEUpEEt5jmM1qEdAQt1u2yVZzBMKlp+ki1O4PsjoGOL7zVirk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:05 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 07/15] docs: net: dsa: document port_setup and port_teardown
Date:   Sat, 16 Jul 2022 21:53:36 +0300
Message-Id: <20220716185344.1212091-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6472b578-e7cd-4028-2873-08da675c8dd9
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebTsl9hSFi5dMjUu0k7uj+NBP4lqmomRYVP21GNK/wIFZKe9UjiOK7w8mDga2ezPjlumrNsmbBcq4dzwW/9d3Ru/56Qh2W2/reSfaLNY0oxHR8lrlcCMXCB2b6BTETf2EOjNGfMlnCgBBDzPpqUA1dnSYWgcHbwb0/kl5X5th/670UJpL2IdsEvts6hSH1Kpz9F49k6pxPKSbesI/G7JM1Ds0xduuN95T02gv7NfVExwQVyWhCSlr+mB33U146VXA5dQ5uBC5OoK5JdmKjG528ARYXly8vup+5zjOmV2tzIGM/stZ4u8KRgNGlAHctEfetVLsolGVz4Zo/5AlX4+gV7xYVu1FmGum1Ixgzj/MJodZqQ2tOrmxmZwdR+WcqUp0YkQNSReEe+K/m+aDhotYXi5wAsWtWpjQSUQDmWJMB9MJIPkTBs0MSvNTiC2h/d2Z1wOOyMSbjFAWU8kHuPEf76AHP5MbPgI8HZaSR6TX6/zzCpdBKw4yviRAC1nkc6d3XtAZYe2nD5qzTsYtkgrKjHHCkEEr3VRvxAqhccdJDGnH9xzvliqLqmWtgYFfXeN8dYhwchJMkgItvF+6KZjLxd6ah3o8H16mdALdQJ+wAGd0vYoZHfCsrsr0k35MTJ1sj9OmXMRFM0X2o7IqyLTTuCwy2kZ56J/yNCtTfS81dobB4qSoKEHdVVBCv/teCZ+b7QFl+81RNxGal+Pb/1F7byngpOeJtn5O0KPGp11q4yuCq6IoUQ11o6yZkHO6V2FT6GsdUlvuTr0FVk/YgNu+CH1zWMPhZfLE1PE7ntRlL7sXN08fdBck6wEAya7S8yB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B3eWQcVSzk0f/p/FiKrJvBtF5pk/HeeLUob/4saLQHM1hqTKR1LdBz/2ZxuR?=
 =?us-ascii?Q?LWhnc6pisCOqzojKywE5k5Ik4tnVeBPO9Urcj8aluQLrcPblhVSBupvq/DEr?=
 =?us-ascii?Q?89ZrY3oW2KNlM33hq5H3c9un3ELHVeseuJZkl+LhIbMweZmn8N+Uwv7yWDyb?=
 =?us-ascii?Q?acdIs8Oacn0X3UyCMQbSXr5giQlj7myUqQkB2vvSTFnujCNQDqhVMFd9OuzN?=
 =?us-ascii?Q?1IJtOEphoLqKIR7WDCHHlIhjFAr0kUpbdXIhaLFdfydcT12fXB8OujSla8fW?=
 =?us-ascii?Q?XjRPYv1DyN/rixDvy6S3+C3zkEZz3MQ203MtoSK/6h+HsdzJxwONyjKrOPMX?=
 =?us-ascii?Q?D75AG6kiQybASSZZvYPE8FCTnazDXe9vCIb9x6dr2czaKdT5C7XiLh9OVYmC?=
 =?us-ascii?Q?u+YrRfIEsZKAKDC9ivk17J94ZuqmqrERdzQkMLVThir/ftZ5Y2c93Uf/KOUQ?=
 =?us-ascii?Q?/2zl577oJJ9jokFtkZsh13oyjZ9pALSg73paEttgTGz/0T3kI6EjQWhdT6Kp?=
 =?us-ascii?Q?roq5thpoLt1glJ3fZjDttFkld6oc5/DWtnWfpQRrLfCAz8NsiREqKbkKvt9C?=
 =?us-ascii?Q?8gILjetiqcyuxiE7fC0REhRmD73+0mpaacky7LbcOBMrhAZTEQOKJiCRzDF4?=
 =?us-ascii?Q?YroO2BreckyPw/unO+70JU4N/pZVRQQizk/pQQJoARczXcaPuBQwYVtauh8d?=
 =?us-ascii?Q?VMyYjVQAKWsP6XzoTQc5mvrN4RUnJtdIxQnNeOuvyu3W5GddYQzZ8gX3zxDY?=
 =?us-ascii?Q?w0S6Om+EIVg03tFDnWi3/71FQTG+DCaKka6JouE3XtSSG5YJq1dE7zQnZePE?=
 =?us-ascii?Q?ZsiDu6MXPBtqNY8Dm0aIbocnwXIDM3V1InkEan2JuHVIMILgEfk6I3x7NiPY?=
 =?us-ascii?Q?ksusO4sJIYjt1XJwFmDZEH8leXXL5ZYxkYnxUwPh/uEtyqmK1S2GMqb6BnGa?=
 =?us-ascii?Q?jGPYIy0/ApJAaDy/UBdrD/o/S5zP88Q33NLVT+85MT3UXecDt9Zfr+NOSXPV?=
 =?us-ascii?Q?8GplhZ/oE2lIv9oRZH/CyQEizU9TfLHWti9ad7+D5jqQleZznive8WBxtNgQ?=
 =?us-ascii?Q?OQRO3QlM59oZxS0YUkbD7djleTD0M0gmUlHXLYYX7ZVpw8p1A6oSUK89ChAB?=
 =?us-ascii?Q?4O8aDxQn1DGP03Cr+DhKQFOWj4tLqJXZuTXcTMd89IzsdmX2EAoHAEgoCm6Y?=
 =?us-ascii?Q?thw3oSfL6u2aSiayQ0XqXlR2bztTVVhFZ4UK91g/6z+eTa7lpupbW+W/AuxU?=
 =?us-ascii?Q?fM3lR705udOLvvsbx7V+O2qnqEGYGTbP+zxE3zrUU1unhIDTFvxa7yioWAxv?=
 =?us-ascii?Q?84j2hUhjNl5isbrNpmC1hhRG+cNJL7aCiC94ZrxFW7AKCqdcMcO3NpFzwlp3?=
 =?us-ascii?Q?kp0R/tA2Rvwr1q6M4gnxo79bvdOenomBeKj5bQaf3OMjcbntNR5ZEquei4bn?=
 =?us-ascii?Q?O34Xmff/gcAMFQzSiFdjjXMQq8NjbsbvkwrW95EJfHRxHtt4HddxjLvEVuLx?=
 =?us-ascii?Q?QeiesLQ+zGi5ABnZnoPVWreIu2S3t6/J5wx7PFgn6G2PrvoWOf2hp0T7krgQ?=
 =?us-ascii?Q?dkGJu/YfsTRyqwQQ9QT0lSdgHMfA2YRem41+FFEFQ6qsV4qnIlnXxtsmuKqr?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6472b578-e7cd-4028-2873-08da675c8dd9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:04.6911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcMVlkeOPB+Xchg3d61H0/N0vrFeF6pAnfm0QWKSubFWQJuxgsam0sUYbzqcBQfciYuTnijYHqobLk7ZdEd5jA==
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

These methods were added without being documented, fix that.

Fixes: fd292c189a97 ("net: dsa: tear down devlink port regions when tearing down the devlink port on error")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index e16eb2e5e787..eade80ed226b 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -620,6 +620,15 @@ Switch configuration
   may have previously configured. The method responsible for undoing any
   applicable allocations or operations done here is ``teardown``.
 
+- ``port_setup`` and ``port_teardown``: methods for initialization and
+  destruction of per-port data structures. It is mandatory for some operations
+  such as registering and unregistering devlink port regions to be done from
+  these methods, otherwise they are optional. A port will be torn down only if
+  it has been previously set up. It is possible for a port to be set up during
+  probing only to be torn down immediately afterwards, for example in case its
+  PHY cannot be found. In this case, probing of the DSA switch continues
+  without that particular port.
+
 PHY devices and link management
 -------------------------------
 
-- 
2.34.1

