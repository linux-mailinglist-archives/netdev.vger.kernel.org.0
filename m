Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DD31DAD9D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgETIgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:36:46 -0400
Received: from mail-eopbgr60053.outbound.protection.outlook.com ([40.107.6.53]:18053
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbgETIgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:36:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOGTLGzHkf4FAiwRg48W+qlPypgfNRF2OwofBD6xpiUuvrhsMjmzlaLahcpZHYyex1DAJSOxeBQRBFRZJYyyMqlPPBtVy8Z/jcZ90J3rb3nNvssjCRJe0h+gdz96sKkiSRKjPXjBx0+u/QE2Fp0E1RfrNnPQKag/UgUwKhrvWmfx/BwNWdVi8Avp30DVCGoesTk3AlV11E6CzK0jJIV8h1TIRoDXQDBshruJA7hEUXom51Ft/n5CHroroxjwfmRnEXWeSsHPNkF4yfjdhcQLj7MN4tgoXoqzh9S0TdUrbm15n42EIzH63zFUGG4CCXP3Qhm/mSJKbYCUVp7TX2xzzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gbgYCiCXSoVdEaEF8JtK+o7WpHgZV6uyU3PW34MvcY=;
 b=ARbWVtzzIVzJQL6wxNk8VI6akE/hx2rq7Jg6Ye5THpdOfzqf2oWFmXdIqDWNGh19XvaqAkPEu3a7FrVE73Y1rstWYf5yN5BJphONz8sZtmuyzAzox+JdneyH868wOcRCBLw+AQDn5VjJbONSUGpxGDLeCU33HaTx86devo1OcESu+9b/E8bN9fbn0X7+eT0dkJlLilOk8wyGM0yUP2jnr9B3dVWE7D3vbPsbwGjFGD93BAE+EigH33dYtFd1wFOUsJiR8j8GpnspmOWa4UCOYDLYURaUwwjvZkgZFWBSC1GBg4wEUxmK9CYojgCBckg1+amg/oQdrXk3jUlf64AUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gbgYCiCXSoVdEaEF8JtK+o7WpHgZV6uyU3PW34MvcY=;
 b=rmzEe+ZqkKgk6nW6ydq5ePN89u8R05H44ty8IIrO9H3Pwe5CJCq/upe5zXFheDRGG57sq7cYW36MBLMeMPUxmfDX6GAlKr3zt6Wi5CprS7ipwy6O/pO0J11OYtuXQIaPZWzdp1cfRre2CcbxUYgHMvMKJfqWEAKhCd3lvt++3ac=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3926.eurprd04.prod.outlook.com
 (2603:10a6:209:23::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 20 May
 2020 08:36:43 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 08:36:43 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, martin.fuzzey@flowbird.group,
        robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH net 0/4] net: ethernet: fec: move GPR reigster offset and bit into DT
Date:   Wed, 20 May 2020 16:31:52 +0800
Message-Id: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0233.apcprd06.prod.outlook.com (2603:1096:4:ac::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 08:36:40 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 363a9351-3053-45ab-8711-08d7fc98ec76
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3926BA40A404EDB12CDCB4A0FFB60@AM6PR0402MB3926.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Nxl2fDMYolcMfwTOobA/ktUFqfA26iKbychz4fWEORkJmSnUajzmccwhDov8Rtf5bd5oj5ueDYG1A+5PU8759Y1U6eR1PujmRtf7tLVBAq97rBIszK1dThC2GOtLCyx3o5iW/MBRhYaWJVZv9CJm484e1Qq3W24bY35D8faABCPkuB67T7YVFudosmIS786zD8pJo1mFoQQ4RSTKnKlbNgnF5Dk54IhzgPFggvutowY5bg1vWpXW2xvWpxqqcUHwzSOuqIWi/es1dMA7LiBz9dQNDo7bWITdnnaSGq4x+jjdo73KFw4qDKzQq0ECi4fvfjdygeS0Z0Ch2Da4M/3L/dPE8ys/ShJnHRPYMA/L06agudP8GSllMGI872WwUtr0lBooI3Tvju+Fsfu/pX2jeWW9Cw00wNmaY4rrS2yS0QUx6XW7oxwPpr92pPaTBkC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(6916009)(8936002)(66476007)(8676002)(66946007)(86362001)(66556008)(316002)(2616005)(16526019)(478600001)(186003)(36756003)(26005)(4326008)(956004)(6512007)(6666004)(6486002)(9686003)(52116002)(6506007)(2906002)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pt9zuJ9k4Rv8yngVvc6UYskV0fMyXGnn01uM1FivUypmZFR7KHp2weYR1ZjJ7225zzDO0TfDbDNsSBWsvlFrpuREwjOq8xtI5oK1MAzbEf2aBbvMBeev2avNsY2cGLZsCMbTgOJFhP17se0aNtuKNeDEH4RdsHZr1c646moq1chc16IfANhJ2CI+MiLycy/rV3bv7tNh5Jji2umABw3Z0XQDO9i+02ACsBpGXYHbRJw0RzhXwqjwrEtFSnAJ/YJ51s6B7dMK9KYBkZFly58tXwyNsG4zBzQAfs5jcNi6bjHNjx8fdyYWMymRW5VOnLIo4YZitbRfpaO3QARejEvw1BPt4iPu7aC3ZmOc88SVTcFXuFVdY+LIZl3hnbdWK8DAaXR9s09kdt0ThIS1w/Aq8UAVQ5dMW5JeBXH/yQqLdV4OjXCu1B+2F2EFjBDpDoOT5dOO7GfiQ4+8aKUlZvyDBx5xOIKIy5IzJ7vgMuDbZxM=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 363a9351-3053-45ab-8711-08d7fc98ec76
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 08:36:43.2971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yMITiMAz5rcI+U260VePbUW2NT/AAorzwdoa3y+HHaBQ6PiMaM8L7yTaObK2Cxgw7ZHHHxi0oLzWW7u0WsCi3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3926
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The commit da722186f654(net: fec: set GPR bit on suspend by DT configuration)
set the GPR reigster offset and bit in driver for wake on lan feature.

It bring trouble to enable wake-on-lan feature on other i.MX platforms
because imx6ul/imx7d/imx8 has two instances, they have different gpr bit.

So to support wake-on-lan feature on other i.MX platforms, it should
configure the GPR reigster offset and bit from DT.


Fugang Duan (4):
  net: ethernet: fec: move GPR register offset and bit into DT
  dt-bindings: fec: update the gpr property
  ARM: dts: imx6: update fec gpr property to match new format
  ARM: dts: imx6qdl-sabresd: enable fec wake-on-lan

 Documentation/devicetree/bindings/net/fsl-fec.txt |  7 ++++++-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi            |  1 +
 arch/arm/boot/dts/imx6qdl.dtsi                    |  2 +-
 drivers/net/ethernet/freescale/fec_main.c         | 22 +++++++++++-----------
 4 files changed, 19 insertions(+), 13 deletions(-)

-- 
2.7.4

