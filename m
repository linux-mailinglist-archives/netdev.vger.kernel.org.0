Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D28B5E59F9
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiIVEEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiIVEDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:03:03 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B251CAF0FC;
        Wed, 21 Sep 2022 21:02:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Um0mP8r8pCy/9Piy7ifeFPechKyVFCKPtbeB5Psle3/0G0L9tVTlYrGCWAzYdnxq1I0ZBEL/4HzCgXSAuJ5eldpf133NptJ17fvKLJ/1tLj3uKBYGI/Bi9sI6W64XVm79zPkoOB5nN8KM1XH24bfjLT35gq/nxTpwqdkXbGytgV1J9tjusQ3YxcVknLBwnWJvtNhCXjowogb3jR05JmI1F2ZQOCT1VyJvuFkXz3F1cHneLmSW9NV8YYV/LoL7Tq9WD30o6f92sQIKqxg5U668WP3bGBCWnCy5/2Nm3CPJnzJD0v4gn7SP0qQ/FPpwd7SWz8Ke6fX9n60ptIXViHOZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1EqDZLeGa1PGjXMcCdYL4dKOADUpamKDgDZTr0W7P9c=;
 b=mZ0d05D6UzbI9hfgJSgo3aIVDLyq7aLl3axJJph9BSDY1IVT+0UHd7N9/+p700b9fC4RF/SUkDBae5oo16FTSO+fgl2fOWXxHkK5sPLz2d9LTuMARHrjZmI0x1YSjPiwL1av+h8jDC/bD7RLQgMjUMSf7M8LPK15yu/Lncw2b83BpDh7ujBu0Su728cHPJzlCegsYZ1fJGw4AOVz4DGHctG0RoLPcZ9CjbtynnbsosOsVHLvws6ICOE+UU4pyJBXy29/WpTwTUFV+HEVYYkTXtMHKJeGz+1iCZVEg/IKybhEABCnUPHFo+QdAFs8tyLPkdR7MuHybZQKeWmzW6s7vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EqDZLeGa1PGjXMcCdYL4dKOADUpamKDgDZTr0W7P9c=;
 b=ttetO8EjOhSOuJ1dw+eW+sFTy+C92uhHxg5uzcxwNAiJNADGP3lB5m81fTRul8li2vPW+m/VHFFRKH04w4snNTugvDlZWmEh3YyOMnxZN4zzbHFwcSHysotk2Cm+XOO8N97hbviBm+eFCs2IeKNzNcZYnYFTMm+Hoep0YUWJxGU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:32 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:32 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 09/14] pinctrl: ocelot: avoid macro redefinition
Date:   Wed, 21 Sep 2022 21:00:57 -0700
Message-Id: <20220922040102.1554459-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c88097b-e343-4dfa-1d74-08da9c4f22b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JtWz1DClgfOJDpUOjOqRarRQynfYOzGUvrYychaAJ+74hLckPg7UM/V938DApCJTSbspnnV+nwVmRXJNVczz4y2k40gTFrcDyhSdtFLgYkRjFOCjNX/e90XGVF0QPxunPN0DnRnYvD4x7tZyMEszLU48lhyfkfM7kM42o5WWAml4mbdY/PmYQ+qJeB88fqOeoxDcNbi9szUl8jf5IascCfeC3a1a0w38t/tcd8GrnK+gWBqDa7civtrGL2qNpJwtWbI/cpGbW+aFFvk+7FdmnVe9oCxaC/Qn4csr5G5flEFuRlI0w1vwvQrVFLXuOQrFmPjM7n/FV0XvPyzo+mVau3l2T1FmjRxzOWdReUYkM7977NnGBritt3cuhAZ09uGWUhPZk+W/CbT9n4vw6Djd9N+gmnB3ihB23mXQT9D+NUBpc4JlZVzRQDwRmWgSgzEPNHkT1fY+FqbCHAD9QNg/e4/zgpaxf+gR9z0VAdRpFKV/lYTJ2ESR2Hr2RIqmp4EONlVg4FyS918mNtUt00DHTtWYdhVCGAfCb4Kl2prbz06c6E7Z2SAVck9go1BtQoMozodruwCGogtWEmQfqm8oJ+AzuRV7DR2pmDYOzNXgR8vkEWJpX0uDnKgBQNH5SLT1QefUc8ELc1G60g2SV6bTf0HV6kxPrQ6JRJgwoLOhHv7feyEwUCvPAOk3dNOcdFPr20reLvQm5ApEke7wOTL2gX+xA+5tk93cD84U98FZboyFxT6Uog4oXAXDEGbiq/mieBVpiJucUa79/42Vq2fhfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1pprJVUMIvBL5V5/BJWoILn4jdxNMC7sRHccc6gE5ta+nItn5SJR0s2og9yR?=
 =?us-ascii?Q?V2KypZt3II1QtlNR7sGWoH5Of0/kv/lCx1ob8VtYfMsIwGZQ/qxWoGRKQ/AI?=
 =?us-ascii?Q?pFhS/JVBFLYl9jJT1ETTH+LyAaaS/flBllvIWVD8PK/9RO1WmZw2MdVpds0G?=
 =?us-ascii?Q?ifOvASF8WYEb8L8CcZQ/kxvurQwCAyj9vw40kigErD3nrk+DWepDoX/FRN30?=
 =?us-ascii?Q?VfLUiAOrfj6c2SCoYGl2JgyQyjRwnSSYjsB4Ii6O+SsYEFMK743SffDoCagQ?=
 =?us-ascii?Q?bb2L2CLYoaDGmDFF1Pttnr0eoh6NvVwVU05ACiRf45T/MmByXRI0zBvl76fb?=
 =?us-ascii?Q?Zxuw3hxOCWG1LbpJIcKsCwyS5fPcXkE7Mc0iwFjRmjIs9PAZjJGlNer28iNM?=
 =?us-ascii?Q?RT0++t0Yv6GLz5AB7qkMFlXxN6ATX6VRWxcfGy2LhLn0kaM/Bkj+wJy55Mk9?=
 =?us-ascii?Q?mtrprv5zCLAwPGlT/F5o7vOyQ7QJQnggk4pHJ3nxJ9W7VOjuL6n5r2Z1+cOl?=
 =?us-ascii?Q?VBDXwWtRKBumVCHFyybmaxLE7rj075S0zRWkWrV0qtlVZ5F5kW1P5m2Cthq4?=
 =?us-ascii?Q?mYOREVx2yuTxJbpFgoCOIwGt1+H1sBLOOgT9lSZUz8Jk5nXfzlNwYNzoACTs?=
 =?us-ascii?Q?XUmxtQqbNtazNrF0eR/imz6u9LNmadX5Hzn6wfuiaAsFs/5fDXdCJczGlW6j?=
 =?us-ascii?Q?seXq6msGv1a9L2MrUEWzMo3SrtjgGwvIT3Bquloa+IcIbnYAV+wYZ1oda/DP?=
 =?us-ascii?Q?EboTYaKcJJ2HBpIxtU+7lTBwP56UoceS53GWzSNZwV1Npr+u4vguOJEudNJN?=
 =?us-ascii?Q?9GQLpFjI1x202oYejJNcQpq4rbRTsxPr5NNa6Qf671zAe0cZWII/bxpcdSiZ?=
 =?us-ascii?Q?b4d9XN2Ez4jJzY0LEeGfZCe1PeBSL4Z8pITbDa0hbrpQracow3mxk0zffzHd?=
 =?us-ascii?Q?p8do6vZbZSEvApHDXQ0kJOMnmOidDtilHi+6a/lnnZ02+ymqNHCk02D9qhSX?=
 =?us-ascii?Q?oruRHukVUgsPgHH6B8dW5kxdSv4I7InHJwOAGmTuCDmYrm0Zup/NdssjEQT7?=
 =?us-ascii?Q?EVj+wLaajpE6Jnj/bwX69/fIc4EUhc3zjOPxkV3as2lr13F6r7IuMjNslxgt?=
 =?us-ascii?Q?PGmwNgYPmo+mXBf6oRcsCbkLbr5jbgV05p5/Mbpz4Po/peTo63RB+RlGrP+g?=
 =?us-ascii?Q?z0IHO5nN2HnSOBX8qeevvOob4/w2bgVpY7Mxw9w5wtBVe83bokuMbcfwkORm?=
 =?us-ascii?Q?ay1H8Nqo9O8mxrEFKVIjvCy6Fcw+H2WaStXZJi/L/cgjTiVZmFpNbFJYrpjX?=
 =?us-ascii?Q?3hbzRq7Sf/yUGpcOGldOF90pId2i3waZTf6ukxmsaHkEZa/FfeSGbhWbeing?=
 =?us-ascii?Q?y3mz1DpgyZNm49FBY5sJqRDHqmBfO5JxubjdgtRUbfb67+pOFzf4hRxQTDbc?=
 =?us-ascii?Q?USdrnR4q+j94xdYJ4ixYcqvsetIPxVS9L1OumrNBt78h7TRJOK4rmFlg9djI?=
 =?us-ascii?Q?MdPYw1R0t3BS+sm00asaWal6luNfk+UW3cMEYILqrUuM+CUWoPGikUfLvcbZ?=
 =?us-ascii?Q?p61rUPOlXZlo2iZB0E+Autc07afcx4x+2Di22ugJOC7hr9dSPpZpPls37aZi?=
 =?us-ascii?Q?rahBAqK9FiGkpASZMhzClRs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c88097b-e343-4dfa-1d74-08da9c4f22b7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:32.6684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEYA+oDOdMsXMl7EM2ZTD4UVy85vsaEJc35XZkbJBt4GQekezAEo1tOYw3K/k51QzbBfy7fO29gBZ4zGnA+YkuySzSF0AXGlbUnC3dPE5Vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro REG gets defined in at least two locations -
drivers/pinctrl/pinctrl-ocelot.c and include/soc/mscc/ocelot.h. While
pinctrl-ocelot.c doesn't include include/soc/mscc/ocelot.h, it does in fact
include include/linux/mfd/ocelot.h.

This was all fine, until include/linux/mfd/ocelot.h needed resources from
include/soc/mscc/ocelot.h. At that point the REG macro becomes redefined,
and will throw a compiler error.

Undefine the REG macro in drivers/pinctrl/pinctrl-ocelot.c before it is
defined to avoid this error.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch

---
 drivers/pinctrl/pinctrl-ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index f635743a639d..b2191407fc1a 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1231,6 +1231,7 @@ static int lan966x_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#undef REG
 #define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
 
 static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
-- 
2.25.1

