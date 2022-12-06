Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1887644156
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiLFKhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiLFKhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:37:35 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2107.outbound.protection.outlook.com [40.107.104.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BBCDFF5;
        Tue,  6 Dec 2022 02:37:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmvy2MbPypklUx+zYZH6oQZxEptrmjKpQiIXz/bKWUdNLdO2+Bp0S00V9CqpEJi9GlhxenSVUTAPUABPksZxXOecnuax9Aysu58qaz1YsHz1zARmWjESzfl1QLL72/rKLHFBtN6onT2ajQM6q85JlgEqEC3CnnnLsNBdbHld6d5xaoMt63MJbFwePUv2dcqdjIu5Kaw9+bmDIKMuPNUC/H3jBgoGW4dunhsx8/mpr2O5nTBJHeaAb2iv1UGR25c0Gac5CnnNIkPStqUCyeRjZij5lkKfPr1nnFLMu/E1vbR4xYcRoXBqgD/j6M6usj3l9a/EqIGQ8aPcBIbR1hJxpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvpybjwYHuTgSRIoUgF0dbWFoIys3U1QXeH49adwjMA=;
 b=JTI6h4q2l11hT6gDcTmH0dyEoR3N1UP+4Q18CP2t5VQEBvBjL74ctoGPpXAjmPSE0wTyYWEChutq2dlV/HYqd21VseksqMaa+Z2oIaDEwuk0Swy7zVat8w4hNDzhK/3p/W5H1EJTPqY42ycTLsPGAVLD/+aR08qbpRPav3piT1JWbmT6Ql9IMvjuWU8/Hxf8Wxoc+EPqdZLMLjmD4FxpgDqhkk30i4OLT6ptXoi35jYrwWRwXL9y9yYWqeiG1PUSwHSAX1+y0QD57cJ8zl5GvBNC0uyU9IqQjH/0W93w7qKIoXsMluvO2A/JH2/jn85I88iIXuyvOv8EHzTm1ipKMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvpybjwYHuTgSRIoUgF0dbWFoIys3U1QXeH49adwjMA=;
 b=Qpj3Bq7udoVxW+GTNdvlOrCvNQCKwGxJZn6IQwRpAFzKQGjqzHrvm8kXhALsMchCAPS+x4yTmlbBRJJKedpRbTcvWtnnrADnXxgr10XF8zwS/zZqUDCeoZEmPiXhhNP6t5xGBPSrb0uUV1LDHKK0M6yTZZy5DHg0GHA+ZZL4QO0=
Received: from AM6P195CA0015.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:81::28)
 by PAXPR07MB8470.eurprd07.prod.outlook.com (2603:10a6:102:2b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Tue, 6 Dec
 2022 10:37:29 +0000
Received: from AM0EUR02FT031.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:209:81:cafe::37) by AM6P195CA0015.outlook.office365.com
 (2603:10a6:209:81::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 10:37:29 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 AM0EUR02FT031.mail.protection.outlook.com (10.13.54.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.14 via Frontend Transport; Tue, 6 Dec 2022 10:37:27 +0000
Received: from n95hx1g2.localnet (10.30.4.179) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 11:37:27 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: Re: [Patch net-next v2 01/13] net: dsa: microchip: ptp: add the posix clock support
Date:   Tue, 6 Dec 2022 11:37:26 +0100
Message-ID: <5892889.lOV4Wx5bFT@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20221206091428.28285-2-arun.ramadoss@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com> <20221206091428.28285-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.30.4.179]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0EUR02FT031:EE_|PAXPR07MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f7ab710-c081-4c99-c847-08dad775dec5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHSIlmcsYiTrJB8sv4yHaPYsoRl/lDrQ1xi1cTg6MoI3nwVhdBfpCJUpxGqKplgMM1lY5zrCZYNjmf1+KZSfhLnMXTUiIkOOsG5Pt01ZkwvKuqEGjjWdt3L/ZwiTPTKqOHMr6idwxHFZk4auuIdINN2bzdmVszE4TxtQPsVNJKr1J++gJnMFWP/fzo2lh6U5d2nycEnR489XEFwGxINYUrAGoxPlxf4eiNxKfaLF3O6CCuBCJto6GsYeTb1XZ8R3cjhkREOgEraY6XuaHxBhJnBpizPKKriRxrB0ppCf1++1alDQeI/Dgd5AFq1J0l84msoUc1lpm6CKSNeM/aF8XXlISaFRs8zhLsZpgDiEeq8xEjnkjykVfLrHrHSqXATgQS6UJdmoU2MyrNGaHK5q6DGHlWf9J4XA0E/4IFha5iI1v14tvJbSrdZqY1JkHm68AbfWVqxVri54jtEVQBq3Rl2Ons20NQGERTmwRTXy4t+kI35Zz7w6+12Nad6H3j0Vf1lVxdWO/lU+QDhufSEKc+Pdv+h+ohchx1csIpQY61S2EowU/mOIRjzVfGQtv6RkMIVBF5SGOBiaGsWSqZ7ZsrXaKZ9jvm1/sJ6gjnAVC2WtQTqIBwpsaSEqXGvnY8RRfv52+euFIHQ1C7deh/USh7/GtKRe6Y1FYZTaW6l1yLsLdQDMqoGhP3hATndZEwc0S5yWKvIVHkGYW37Uq93vGcsJy5g4RxrAwnjbyr8xwQIW8eTSWFlu8vptiRoOLDiyPkd0rOPSZ0wZsiRVt3HP4w==
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(36840700001)(46966006)(316002)(36916002)(186003)(2906002)(5660300002)(47076005)(426003)(86362001)(336012)(8936002)(54906003)(7416002)(26005)(110136005)(9576002)(41300700001)(83380400001)(33716001)(16526019)(9686003)(82310400005)(70586007)(70206006)(40480700001)(36860700001)(478600001)(4326008)(8676002)(82740400003)(81166007)(356005)(39026012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:37:27.4527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7ab710-c081-4c99-c847-08dad775dec5
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: AM0EUR02FT031.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR07MB8470
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Tuesday, 6 December 2022, 10:14:16 CET, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch implement routines (adjfine, adjtime, gettime and settime)
> for manipulating the chip's PTP clock. It registers the ptp caps
> to posix clock register.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> ---
> v1 -> v2
> - added arri in copyright message
> - Deleted setting 8021_1as bit and added P2P bit in ksz_ptp_clock_register()

did I miss the discussion about this change? I thought that the first goal is
to use KSZ switches as a boundary clock which implies using the 802.1AS feature.

Using the KSZ in P2P transparent clock mode IMHO requires writing the peer delays
into switch registers (which needs to be implemented in a companion 
application/script for ptp4p).

As far as I remember, there is also no support using ptp4l with 1-step transparent
clock switches.

regards
Christian




