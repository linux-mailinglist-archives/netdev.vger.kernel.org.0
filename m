Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B824327CB8D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbgI2M2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:28:41 -0400
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:7136
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728907AbgI2LcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:32:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFFYN4/4r38ODgCTStJUbrzXA0eEKMVDEiPq7yn7bbXIbE3V1R61s7f1UNyQkCeTOx/PfHz1fafgh2uMyif7BV/zWAPJ9n+xuUaYcNxjUJRelUAVh10kY4F3gXurFusM3kVrZHNZYKip74t41CRCfNGnmIOR617MrrWGMUQq3ABvPq68xW96AtnO5UOCytQEOXRZ8LgHvSHv9L003sd7f/3N+Qp6mFcwlHqMnCsF8A7lLQGrMTGpFczQDSr8X1gDYUiZDFDGN22ftykofFLX/o67+gfhME7FgfpTn3bgX762ZkPv04/WPy7HtsSL4n1091jFQBZpP7H8tKCWz1+qWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTyazC3eWCNxUnPU5EFC/DpuYY6CpxIBtQuOmxVM7Lg=;
 b=Xn3O624HhF3Y/Oj70918XwNw0Sq0tUYM9PHXGH4LZzUsFz5PLrZBY4U16PHWMw6R3894k8HJhUgFkiPspat1bNWYuvjd8Z0kEsD+sfHtoYcxSRz0IMBTBo+ouAuqUd/Th9xgFuKMHmBTWbHSOXYockw/zCob8d2AeM72QOic4yqXXsvdOWfK7moQsfmbUQ58Ww0U+6W1i1YMOI1bp3fj9hTjub5x3Gacs78UULi/Vy0je2bhGCI8YtyLh1yUJJhAnQmqkOrciwG0TDWmgljG74Wch7DqrLxMEXEufbPcGQx77y1QRTniWWOxJ80X4Hc/hcjAfp6j+0HhTqWSPJEILQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTyazC3eWCNxUnPU5EFC/DpuYY6CpxIBtQuOmxVM7Lg=;
 b=ANTCgr3rs+oUnxUomzLvscW/9uJ1OZD0TIeCVZ0zZzLIWNdLnqX8Hp0h1a9tjjTaugR3ThTM6V9WKD9XHcNAPcRU6kmXHdZAy1hZSu8aCncjV33sDQoikcGwJwtSiO9MKUOOQx5h5LQvqhYNR6I9AUYz9yE/YiVotG7sWQsQwCo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 11:32:20 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 11:32:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH v2 devicetree 0/2]  Add Seville Ethernet switch to T1040RDB
Date:   Tue, 29 Sep 2020 14:32:07 +0300
Message-Id: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR05CA0008.eurprd05.prod.outlook.com (2603:10a6:205::21)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR05CA0008.eurprd05.prod.outlook.com (2603:10a6:205::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 11:32:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: defac122-a824-4c48-b69d-08d8646b5389
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB55045BACFB9B0CA371540641E0320@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W9wPTqLtBVD5WrhHeUZCG1iYPyNekvwsmSfwzbcz7y89iepMNncXcBYLQE07eSQw28w0ql85hiCTnotWc1PdqrN4iQtxHuOuzSuMqvyeH4NQpPkWcJvZCWlFefX2dq9g5xYHRFy/WA8D1MW26j94USb+lgzD019FcKYmTN6hrOb9Kq8ExMDoNhJdgv1N91vRsNIT3GKsTuIz715G/krBFufHLBEUI50RwjfTSNs1Y3wZtT0ADGH0gwWq7Qo9ZsHYoVJi9evOx/21DB1+EGaWL8XtdjGliiUDujAHGw34wVolk9TZcl/P/58v1OTPAFg3jA56USMok/HlCBMhbBVip3vq8KFF5Oq9iX4v2lIf7CZjbUSfh6uSTeaVoFXEOa+jvKPitAqp4RiYmHVQpCEGbZ+6dMYDfQXQMHmL4lODRLQ/tBed8El0TTu4R4dTDc0l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(36756003)(66476007)(66946007)(66556008)(1076003)(6512007)(69590400008)(44832011)(2616005)(4744005)(6666004)(6486002)(26005)(4326008)(956004)(52116002)(86362001)(186003)(8936002)(16526019)(2906002)(7416002)(6506007)(8676002)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6/5I0VZ77a7YBwnxhYK0/EwzICPta0b6Fld3BRywZn7gOw9/HII+gUSZyTbB6Z+DcDm0URkOg0pqGKgGQBJC7NtTWEX2AXvdTOm5SCSxHEfgsorNOPQwKTeG0v+FsvDKpeFK+7aLpl499E/mkuaPN+RQ3E7J28BSLoYgDaUEXlQ9w5+1rgJkUupyQClEFW0G/Dk46aUMSkOyp0LowMV1RTR5uJ2WEIqu/2J24OHE8w0EToGycmk5t38VCg3aWl03RqTgK3wTh0SkvSudO473bkVhG2EmYgG16TRe7/m/DUsmaTprDRss+HUHkTRZLLzwjZZtj6z6ng3gc1hTr7mmkIJbe7IYjjAjLwIZ0qS1Gfw01w8rKPJ8cwPzSmo934tb5PBknrpkqamcrSZ62qaWVWjcbbbBzR7/Dx480vA0II+Fi4fWnyvztcKpG/XPdazPgu6jXz7lGhUxmfrbGO1objdseH/IdyN5U7kqZb52E1V0orkmkvnKSj6gbKdc8eO6FQ3FBWNESYvFEBoPJO57iezghGpUbpuzCodmI7T/+sMSiJWQAdqvN8oMVeNio6BCCcWFG2kEQ1qw9txklSdkoLZUILIzf5MxfUv/PzYSICeYN764uACx9eyfRxRxWFJT8xAggj0Pu9V888qMIvqvtA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: defac122-a824-4c48-b69d-08d8646b5389
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 11:32:20.0906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFZTkRFazTNq0WCuj3RBtMRkEDSVmubRQZLCkwdmHPZ+dI52W970ZaGWT7ap9MdGremOuzWBjuucK8xn5FrB1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seville is a DSA switch that is embedded inside the T1040 SoC, and
supported by the mscc_seville DSA driver inside drivers/net/dsa/ocelot.

This series adds this switch to the SoC's dtsi files and to the T1040RDB
board file.

Vladimir Oltean (2):
  powerpc: dts: t1040: add bindings for Seville Ethernet switch
  powerpc: dts: t1040rdb: add ports for Seville Ethernet switch

 arch/powerpc/boot/dts/fsl/t1040rdb.dts      | 115 ++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi |  76 +++++++++++++
 2 files changed, 191 insertions(+)

-- 
2.25.1

