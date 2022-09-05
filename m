Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC635AD759
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiIEQWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiIEQWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:22:00 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DD45B058;
        Mon,  5 Sep 2022 09:21:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yw5u/L5SwW5vjp6Yvg3S5s+p27HeyZq5LqkkeLZoWW9A5fyab5/Hgm/yMx7cD8O4Z1X9cD8DXNzR/CwUR1Tv16ocnM1BL4vesEX36+JRNgkERq5qwmQZkYUVcxL3aHnRacoaH/XjeS6HfWC/nsrT/sMThqM4JyEzYJvUbE0VuhLeYMlOQxhmuq7Qsfio9q3/nvWv6CeFJ88MeLPsgaJDE0lef6Ami1cqUZ/5Eu28aeRdomxhPf1r9nQLuzA0oZpWZahZArE9dKb7i9uFwQhL0dr7XVrlCczfVaH1O7QyiGwGg7C73rNF3OsG+rM/o+iAlTMNM7Stu0nwVwbsWZJv+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkWt1g9y1Rj2yx6TLx+yEiwfaAPfZe2xipge1N5vais=;
 b=BjxRxJ3gDvKBGdOTEigmXrCJ8jBPSt8tTjvL30wxFLp3oPEjq3JN1ISQICJVoJSG9jdm/dOwD7kWgMcpMlOPxkFQeUlvkMCITYTVu1MlkkKDD7376HdH3BzN60w+ywi/t0Y1LPCSW5C92GyPRVIZUrjIf/w68L1++QOFtlkAb+jPprRaFVLZHcOsxCC7tztk8F9oI3TiQs9sEBH7b0/fSmRICzSsEeSCNDc1QRNXVwFvYDEp3oadsoxFi8hJgKdsPiW8yGuLeMfwqIua/EtMknnJkYtrq+NAJQCCSCV1K/250DV9FZBwyBJPrMZrBuHGtThJeJXdTeXPCqYoMnSCdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkWt1g9y1Rj2yx6TLx+yEiwfaAPfZe2xipge1N5vais=;
 b=UUSZWdv7Wmb4/r3EJaKZTcm1BNcwkSZ9y8bA4zL/uQIkqomqG3U8A9fTycwaDnyIblMMCft79p1RNKKSVuQw3x7fsqB76Y/T2Ko8teAOesftXBAczs+L5lGP3Gyr1JLyp3Z5y7nSvONp9UkDUR4Mh3ONkLJnOCj0MWqJ/nU1hnw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:54 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        katie.morris@in-advantage.com
Subject: [RESEND PATCH v16 mfd 6/8] resource: add define macro for register address resources
Date:   Mon,  5 Sep 2022 09:21:30 -0700
Message-Id: <20220905162132.2943088-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905162132.2943088-1-colin.foster@in-advantage.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0263.namprd04.prod.outlook.com
 (2603:10b6:303:88::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a45f46c-2fe5-497f-fc51-08da8f5abf2b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ha2g2ZfrQQCAvlY0C3dRr4F5T+4Lm38VvqFboG1tI1DpRdRBdDI4yeyjSF4Kc4wEiNxyQIU8AqK5IACUVlRkxkFUEO5ahlLIWxgO+6YGaMYCwlUTqLXe8UbUfZX9Sulwb/E4YQpBomygUqDloKJuRd8wR9XW3wlY3v0d3Fw/KjB1tVYEBgGdajR/ftNFPjLbOqwI8Tte7vvMPsgpC9jWUnyYa7d6kj5oaecHUORZdRDzDUIMDpj4MDl36nyrJCYNTddgL3DceCSI9b+fJkWi4Bu/oH01GXZUbPPQ+N7LMa6+gb7GwuSTovhWQCTnrTgx2vCepmmjh7PidvTIPWxjGceaSEbxGYgDu1+JvDPOprJ5bUSXi7bJpWKU6PIZq9fg3RMzetFXkaddhogQeLhwuzeGVVMnJfD1vjle5gDmAre70wV3/bS/PtyJ0bgu0/APgHK81MIyX5BTGroyyNaZovLdepkIl7GKKwnmBW1orfcxIz6Lsse1nMdnb5yGQ7nnjR0HjjgtakuTmJOLL8zJcnHEAqEd14mVyjgbDYaFjfIHaa/WmVn0vDhYv4RAucQjKsoxYjnLK6qRanehRnQEla+cM5E+uV3Kc6jLDb5pqlJKj+WTN3q0W1HpZB97lxfYKnwDsCVwSJjRbBjC9yOaG6QrkV2Z5KQAnkqbxm2Vwv8sE6WvR+qIn0dW9dL9YZj+vAROpaiFtEH/Glqe0IPu2nZ+nlLOQl9ijVG1vZXUFFuo6tKoi5VCzF08+QpSSc2U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(41300700001)(6666004)(107886003)(52116002)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HmSExKJ+bmLyJe1Bgk38byAUHIBYZIEfhsNVe/kvkw4k6p+BhTakztWfXR6X?=
 =?us-ascii?Q?OEW7EVOCbZxgSEV4+xd6DpPLgpF3Yet0NZSv/LQPZnxloDRiyJhDy8dARoQY?=
 =?us-ascii?Q?GThvscv4ytACVbCUugNR1Q3KJwr8540hmR9FMUTIKfX6iBbRz4zcjx9zp24r?=
 =?us-ascii?Q?evH+tJyD/2giliUHYH2RahFj57svcH50gsjjO3V+Pe1i05crv6Nu9U/UYo7e?=
 =?us-ascii?Q?Fbfm3Zd1J/CUH3XYzF57ArSWVTpitjPuFbuJ84ZbMWW6+H0r3W0NGimP/v03?=
 =?us-ascii?Q?Tci7OkBmD+GqbqBDB3PpfF+DNJvX2lhNOM6V+DsFWyZZzWdElgD/DqCz8Y2z?=
 =?us-ascii?Q?BqFWVyGulIX70avqNtKRbwiV+f16pDNJxSHyLI4RLbgvZy2YPqlCgSmaXSd7?=
 =?us-ascii?Q?VZccMyR2pCijyAyn9Rt4ZnS+aEJO7/eC2wpwZFUALOl/cum93/8M1PfImoNd?=
 =?us-ascii?Q?iOgpGX9IqzaI+LF+Be3l+tsK7BSgGqLr2CHyZA4Ssl1psc/R2mEhm/uNAdBh?=
 =?us-ascii?Q?lDjpqacFfxz16Lfq3GFq970H0/rHLyG7ASwIZQ+qqhcRh4OvGRR843fFUsxV?=
 =?us-ascii?Q?U6lsGoP/Sl4/o95/VTMf5zY8gzleYu3Qq39r3LicHZBmAjNFAsf5dp7Wtizy?=
 =?us-ascii?Q?BqAqP75a9C1l1EvjttLvUMoP8DetYD6OmDy4S0rZNnaxHXNK2/v7leJoeFLP?=
 =?us-ascii?Q?KXNnC+ivrFh1hVPrQN31nmKI9voyA2IgOTaM/tgl5riqqrlXNQ3fUjsFkagJ?=
 =?us-ascii?Q?vB4Ng+CiAR4mDja43Sts8yyI4AigENXCdZfajR5QSbDgTCEeKTMe1hAUDeAG?=
 =?us-ascii?Q?XyRAaUO+x++dalYN6CYcKesQg4ws0Op9zaZKA9MbCy1/oGv6rzFVfVbmlBHO?=
 =?us-ascii?Q?oZhyJ2fRKZJKwzlDxRYmB9aRVfyrXCqXP6dvsTpnndwB2JZcEg1a3xg/X6Ha?=
 =?us-ascii?Q?v8B5DU6Tn5xMgCWjBz5D5J+KplpneTgkSx2/ckAko0PQ4DXVM1PsZ50s9fWU?=
 =?us-ascii?Q?qHUa4iT7aa8diyPpug8WsPfScrODU9MSU9LxHKkCH41ihKNurT3v1PAEsWvn?=
 =?us-ascii?Q?r1Fb47RC5ykLAk484ouZ0Pva0WwRI55bgEOP/MAaO6bPxpA45WnzZ4wQ70Yl?=
 =?us-ascii?Q?KRZlSstmj4lUdm+Dy1lvwqAgBH9fV3f5YGpmcgZRRl2MRwtfnVPND/h5trlm?=
 =?us-ascii?Q?k5jjMNxTWiN9GmaoIC4mZT8cozXqzTvofmjrBpoGTBGEOYEkyJ8cxfISEshi?=
 =?us-ascii?Q?FTAuoIXcDSWm2Fxpxj2ayjRNftV2PmQmzS1nqbNnzceW93vbW2q8MI7wkeUJ?=
 =?us-ascii?Q?5coRX4130+FFS8nek+lpvbN8XbuncGhk9aRu00w0d9okrH+0igj9DEAz4b6I?=
 =?us-ascii?Q?o4lSL14+U1veB/xspZ0aRCNU6RDEtpMpC6RTWk+229NQ21XbW1YaJjouw4VH?=
 =?us-ascii?Q?yHJX+TMkQ5DsBo+4zqaUS4uNaII7Ert/EXOUZHVXUZ9bkb5nxY4x/4xvZQ17?=
 =?us-ascii?Q?3wCUKh9ywki8hQvbsINuzWRcd6T26wxtoajadXYzlEDajDf4rXBbTHO2r/Zq?=
 =?us-ascii?Q?CSjOmEV1eF5X6O2kF6j9qcU+dpBgQhX9qQ5u+/S0gL9iIKulZR+GH42vU+hU?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a45f46c-2fe5-497f-fc51-08da8f5abf2b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:54.6005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /AhlrFdyXxY0UqgJiy2KWeKGzgLemNMc9PwA38G5bLc4DcwEp6z4ohFu5Rz5JPWAM09FwgtJehgFakwQAkCJgK2w/P2TNTqG3IaYbBDySNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFINE_RES_ macros have been created for the commonly used resource types,
but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
to all other resource types.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---

v16
    * Add Andy Reviewed-by tag

v15
    * No changes

v14
    * Add Reviewed tag

---
 include/linux/ioport.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 616b683563a9..8a76dca9deee 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -172,6 +172,11 @@ enum {
 #define DEFINE_RES_MEM(_start, _size)					\
 	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
 
+#define DEFINE_RES_REG_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
+#define DEFINE_RES_REG(_start, _size)					\
+	DEFINE_RES_REG_NAMED((_start), (_size), NULL)
+
 #define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
 	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
 #define DEFINE_RES_IRQ(_irq)						\
-- 
2.25.1

