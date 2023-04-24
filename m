Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435086ECB8C
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjDXLr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDXLrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:47:55 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2040.outbound.protection.outlook.com [40.107.255.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510D63A90;
        Mon, 24 Apr 2023 04:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXtvUe0eTmxj+Z/t5vKMyZjXlAaUXCiFR2l5k2H1VzqDTnFqDsjBtfkYNByGhRtnJpO8Mh4PB5k9BFWdedysUdj0Hptsr+nDXPw7n/yHETpkYMxAF+d6vIqYAYyOGaTeT7ppchgBeZOMec1WF245AXCwvgYP82/iFTzelToRcObgNCtuVQQs/fRIFM6lUdxVmjfRfK1KuwBOpHiwegqoJMyWbM2Cb4ENG+B03Z9R9dfyWPlzH9cI2DgIMWjrFcnS0nIw/oXrYdOMo4AegGUe6DTbub70Bf3uXe3PaZo0D5vUIz/HJQYbfO7EfcSKhLfYhU/4lPXoYIj80I4EYyxi6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iptLSsrMCZdIjxke77KAxa3IT4sHZDn/7QuwoCCANqs=;
 b=oNqvK/JB7WBQzfuwhCcFhmHSdx/uATrpPcBkCfcvljI9ejOG3mw1VoStoqEn7kfc4A6Yt3Isvn4lRecOERP9+ZuJkQ2ZBCbnPDf07dHJc87tBAYLB1rbjn6ops7E9MDMQ7rvXtyeekzH9BVLlI5oK3wsWlc7Zl2smr0kip2PnLYbSoGy5pHF7e3bFZyQ4hoxhce8qlQuRjZ71jsOdj5gHyO/GNuXaYirJXo2Uo1ptmERYOknupuC65vBwG80BQ7A9D7Y1PVdX6E4s4QpZZ18fT2tRMq/YjxUkQ9M/qwbiBsR3oIuVrq2gnwHGM2Zw2XKsFo4bwue1efiVfkgVLyf4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 211.20.1.79) smtp.rcpttodomain=stwcx.xyz smtp.mailfrom=wiwynn.com; dmarc=fail
 (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=wiwynn.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wiwynn.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iptLSsrMCZdIjxke77KAxa3IT4sHZDn/7QuwoCCANqs=;
 b=frIC0qtDsE48Baa5Oa4X1gtBOmKwrArjfZ3OxUjVrQWIGm7EhE4dF3JnNgVpcyEdt7Cgu7l4zoODwXMnKWCZcGefK4zXEyPayIICFi7mXHnTwg6qFDYENeqzLzIO60DRgID6PWtN+kU8MX8rrOmxjTSuKdsmk6vd6R0dlj1BoQV2YgyflSDeTn7RP41cxxiwPdcjejkmQPS0bF2vrp8y8UJec7d+fYNFAYPgUKsHciyklAkE7K4K1t9Mdvc0PwWRL2PV7FTNsCoelWDRbgWUeSefmZ2vLidJEMAi/7Z0MOy58t44jS7z3GXN3N1Etgj+/pGlgubfuOKwwjcIQJUM3A==
Received: from TYAPR01CA0043.jpnprd01.prod.outlook.com (2603:1096:404:28::31)
 by SEZPR04MB5827.apcprd04.prod.outlook.com (2603:1096:101:7b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 11:47:48 +0000
Received: from TYZAPC01FT014.eop-APC01.prod.protection.outlook.com
 (2603:1096:404:28:cafe::b9) by TYAPR01CA0043.outlook.office365.com
 (2603:1096:404:28::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 11:47:47 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 211.20.1.79)
 smtp.mailfrom=wiwynn.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=wiwynn.com;
Received-SPF: Fail (protection.outlook.com: domain of wiwynn.com does not
 designate 211.20.1.79 as permitted sender) receiver=protection.outlook.com;
 client-ip=211.20.1.79; helo=localhost.localdomain;
Received: from localhost.localdomain (211.20.1.79) by
 TYZAPC01FT014.mail.protection.outlook.com (10.118.152.64) with Microsoft SMTP
 Server id 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 11:47:46
 +0000
From:   Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
To:     patrick@stwcx.xyz
Cc:     Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/1] Fix the multi thread manner of NCSI driver
Date:   Mon, 24 Apr 2023 19:47:41 +0800
Message-Id: <20230424114742.32933-1-Delphine_CC_Chiu@wiwynn.com>
X-Mailer: git-send-email 2.17.1
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZAPC01FT014:EE_|SEZPR04MB5827:EE_
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6a7b090e-5830-47f4-0c97-08db44b9b951
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SO5gF3a1Fho5MaIhNvKgvNlRsl676Y2LJFrEZzhYR+SqGqOL9fOj7CSTgD5LyDQ0CGSUnb6qM02zOXuOOUfeVG/VlnB9NuPKoLk59p3XIQRL5BG+54iBN0Br6Sm85EZ3b9maLojK+f2KiEGY+32/nsyEEeWkNxRdKtXOVHqu1O7ng+jeZQCC03+5pjXvoZGTZ4QCOxgVVA8mYvmW75BmdK8v2jR1yuqZ/SfXheh0BjQvEgh0A/UcDCamoWyPZWZcKBRbUXR5sHKFJo60dTtsAQcKqZP/gZn8/yEs8mCSTvuxUomogP3YW9rIbDIZa/i+GiFt6qD1FYOSqqhXtvxsmCFqeO63kyheL3I0828EkvzhGRPXN3NzOUnMgdNAJTSf16bvGIaUZRDPKhk62XF+jZAFcZQQGD9oltquW8tVqueA9sxLrBQPFukJcEuhnMFL+E2a73GR7p1v6/AWI2NSlFUvrwHJCrRyHRgi0VLQYEb/Ba33OCbJXS+QS7aVneOXJ/3ewG7QkrjYGO3ijyqBAtaQXveakxJHhnUNLgGFJOZ8+Intq0sjgZgWPDZwU+FPMIAVxSH/oMT4xc4PnwqKUc037wEW0BEKFlRo6a4fe+zgTPcdheVp0xK9unIa5TcqFNvhDHJDZZDB86/K3DqOwksCkGt5RGgem9/cQ2nHHeo=
X-Forefront-Antispam-Report: CIP:211.20.1.79;CTRY:TW;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:localhost.localdomain;PTR:211-20-1-79.hinet-ip.hinet.net;CAT:NONE;SFS:(13230028)(6069001)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(46966006)(36840700001)(54906003)(36756003)(478600001)(36736006)(82740400003)(316002)(9316004)(4326008)(6916009)(40480700001)(70206006)(70586007)(356005)(41300700001)(81166007)(2906002)(8936002)(8676002)(5660300002)(2616005)(336012)(6512007)(6506007)(1076003)(26005)(86362001)(186003)(6666004)(83380400001)(47076005)(6486002)(82310400005)(956004)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: wiwynn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 11:47:46.8042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7b090e-5830-47f4-0c97-08db44b9b951
X-MS-Exchange-CrossTenant-Id: da6e0628-fc83-4caf-9dd2-73061cbab167
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=da6e0628-fc83-4caf-9dd2-73061cbab167;Ip=[211.20.1.79];Helo=[localhost.localdomain]
X-MS-Exchange-CrossTenant-AuthSource: TYZAPC01FT014.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR04MB5827
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently NCSI driver will send several NCSI commands back
to back without waiting the response of previous NCSI command
or timeout in some state when NIC have multi channel. This
operation against the single thread manner defined by NCSI
SPEC(section 6.3.2.3 in DSP0222_1.1.1).

1. Fix the problem of NCSI driver that sending command back
to back without waiting the response of previos NCSI command
or timeout to meet the single thread manner.
2. According to NCSI SPEC(section 6.2.13.1 in DSP0222_1.1.1),
we should probe one channel at a time by sending NCSI commands
(Clear initial state, Get version ID, Get capabilities...), than
repeat this steps until the max number of channels which we got
from NCSI command (Get capabilities) has been probed.

Delphine CC Chiu (1):
  net/ncsi: Fix the multi thread manner of NCSI driver

 net/ncsi/internal.h    |   1 +
 net/ncsi/ncsi-manage.c | 101 +++++++++++++++++++++--------------------
 net/ncsi/ncsi-rsp.c    |   4 +-
 3 files changed, 55 insertions(+), 51 deletions(-)

-- 
2.17.1

