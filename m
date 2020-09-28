Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84C127AB6F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgI1KDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:03:00 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:20046
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbgI1KDA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 06:03:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsE49l0j2TXvTmow8Ookq4Hhd/zftjeZY/KGwK7LOuyyaEpHwfvCbP5g0CkSbJpbD5MPqNgTuLGnb8kqvo3BcVY8A0Imz9RljcOeHsybw6gC2Sq60UckLTXCvJrrbEU9UwWLp3ZNzeVhqPTlVSXe3vasX0B8+/87ED+jsEnWwpEzd1etRMbLE0OqEDZqQRL6jbnMcJlr9NxwDw+n8LVsqh9Xzs02dwKHoj7ABHTuPKzMRACUaixtxvlG+3QnUDn/K8oIzYZEgQnyVzmxg7eTrQS8xDfIyONBtLyYZadencXgsKiPCLZIO20KF9yfn+3bqr+ybw9Q8lWH7qOi0QpT/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlfWZaHfRgnX47q8r2HLK3OkdRntlWmDYMq/i8svLq0=;
 b=ZmR9rvgEOy3RIUH3A9Z6AVI77ianJKi6k4g8GggvKX6xn0xgHmFv4ybkovK3ijb1lCf8DBVpO+K+3Gt9CCiaZMVIr7zVgOyyvnHZELsHdPvIDT+RMllnI+qUm6hWS9sCFbwmUqA96G/gnieRzR3dWVUYFyio+KhozJ1h0SLWxNNDAofgD/O3KJYavbf2rbsouG0NqsDDguVvCW3vW5FYkl4sqHUTza7qUHrMFmcka7Vg4941A4kG2HbCZi2fuuPbPkU/Kfxb9znjQTN/RcyGsE7zeKAsMe+7BFEMI4c6cet8auSF11RvEUxTcmhq9QdwtO0Lg9I00lKRnwImUtSqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlfWZaHfRgnX47q8r2HLK3OkdRntlWmDYMq/i8svLq0=;
 b=U7h4mQMjB3wYTAFqziEkaaY5DRO63pNsU1pCaZ+QxcInnYGSk3ZaRzqMlWF6Vu/WnMk+Orfk4PEaRikcKw0K852v7fHsYuQ2vJSqReg1Ys5YHzCiRT9640ZMHN+6wv12PHJ2GVo2MUcSeMMsLOg0WTZozdCz19vKhCBzGZI0hkQ=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3769.eurprd04.prod.outlook.com (2603:10a6:8:f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Mon, 28 Sep
 2020 10:02:56 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 10:02:56 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 0/3] patch set for flexcan
Date:   Tue, 29 Sep 2020 02:02:50 +0800
Message-Id: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Mon, 28 Sep 2020 10:02:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a99ae320-4b76-4b7c-de78-08d86395ac0a
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3769C365AF5FCA176E620A22E6350@DB3PR0402MB3769.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yVxd6GTEgfTCng2w56XG7SfoA2Hj8smiYkrClnu9o8SYdrtGQuwCaue+zeyCz5zR+HzbjaCjnFDKAqDMw9TK/3cMJoVdcC2wG986zn2JKoxzzYv6Lht308QXz8WTBoXmrvVMt1/ZIccFyj7+psVIuhg1W+jhjA25QigkG9ppfucv1q3JH6AH2OyY3KJHqV7r30GlQiq/hQdlb2A2kTZH+sqWc5XOyPZQEy277/3arTuKVxgH0sfx1PBdkfPbqv6to6fOuVMQ9YakyhjpHT0zeGUDamlYOsXY7siuN5cUScG0xh6LlE14uSBkgBMNiMNp4D57/BYwna2pV+F4Os5/QK2+luWn33DvO1clb/FpWNVb6wlFitBYbzsPbrzRlnUgNzxaU3ZO/zNYych2wWViicTeXxc3D1UVARNtkrCscIzWbvEbo01Cc1I2zZ6OUShL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(6506007)(52116002)(2906002)(478600001)(4744005)(956004)(2616005)(186003)(16526019)(5660300002)(66556008)(6512007)(66476007)(4326008)(316002)(8676002)(8936002)(66946007)(86362001)(36756003)(26005)(69590400008)(6666004)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9Rl7ibN/ZhttFHA+LQ7Q81zfjA4NquOlCPfHSPrbdM44fm/GH0S89MU1zH6WToSIdMU/WSlplUgEAgNI25PnDvTAOW1uFchavMLKoyyFkRxSBqHUBvRWes/iaVZe+nK2cCMi80ma2p0CWKDzKeEp+xpP716KvNTfXGuaFena5fdO87FYD0hHjdXtbKqlgWjGbR7uzT5L+FZp38y0mNw8MYd7Hq69uqyHWYJ1gIfRgxB0eLqwsK92S+eGGfDZvbLQFem6PPrpkjcgbPFX+tEJV9I47nVP3EpAxKUDA7tNLmkGDpCfORNvGWCq5HWrjZAagI4uSPrx6KyUfMGUkdKV3iZ1qMAxYKfiXtrDn8IrmwleUdOwqhPYlVx86+SAT4HiZiq/YquF+hp9q/nOZjrTeeBZ21ZqM9wG0fb1wwTPjIlVhssrnL2QHpH8aRQ9dbEkyFW4JuYe5b/RZHquai2ZHTp+EohyNVlMxOyy4vsONYP9cF3UuaGl+5tT6x++LyAqacjBvQUzcQUVfqUnz1YHKqiMrbVTyZW18E1sdZXSdtmMDD+vbpyR74RXHRggDhyvpmC4ox0FDkpW7AI4Cmy8lJu+LybcSjyeKIrOS6FcqZktZQAh67hedmsmFySC7P/5raPEfxCU3GOGWTQlH3/iFA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a99ae320-4b76-4b7c-de78-08d86395ac0a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2020 10:02:56.6340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jHkVUdqKZWt7rGjldC5pcN66lss3Fd2WA7Qu7gNWK0R1Eqsq2rdb4vxce+xxYRYSpxR18K1M0YRlbPAq82X0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3769
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

ECC is enabled by default if SoCs support this feature, so I think the
common solution is to initialize all flexcan memory for these SoCs. For
that, I create FLEXCAN_QUIRK_SUPPORT_ECC quirk to add this feature, then
users can decide to whether select FLEXCAN_QUIRK_DISABLE_MECR qurik or not.

If you agree with me, later I will add a patch into patchset to modify
devtype_data for vf610, ls1021a and lx2160a, after Pankaj's check.

Joakim Zhang (3):
  can: flexcan: initialize all flexcan memory for ECC function
  can: flexcan: add flexcan driver for i.MX8MP
  can: flexcan: disable runtime PM if register flexcandev failed

 drivers/net/can/flexcan.c | 61 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

-- 
2.17.1

