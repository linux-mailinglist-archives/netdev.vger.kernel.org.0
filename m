Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFAB642FAA
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiLESPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiLESPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:15:48 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2100.outbound.protection.outlook.com [40.107.21.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3615520371
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 10:15:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGfEzUEm/NNy4PrzJCQbEcWYfvHKT+p+wrnAwEFWYBzjihDzBbqSGHSL8PqaQV5jjV0JXLz+4i4wGOZTiSebNBuJWkgbrz0g3q4FcUtOWzWn38pK1SpM1tWuLSTisVjT672xnEFo6+5wMtUKKQ6aHaa6LxXv8CVwVoKk6t0R7hBYmoVYzOfiEhOKsvK5EKXehxYc6/UmRIOVDiTxZXaB/THFJZLAwj65Ch9nrgRnv/bkXlWFLt/+5ytkL7pc39P9KTR0mgy/j2lmva1YGiz3kWZEoup893L3U+EwV9WHoaVyxHSyNZULb9Yoh5UtNKrsXyxbNU5Dpnn7wgx+Zz9kJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWvu7DNGJn0CtTSYKiB6lRUrw25t101UDdtqKAVdAkU=;
 b=eqi8GX2YVDnRJ2ZsqVyBEGw/kAIz0aBq/Qm42jC2cjZ/uRE+wd+3QdODK+i6C81T20dCrIKwEhhycul1gm/1CCaAlGU75rrg07H0cj4w6KAXhYrQ9KokjPutkxJZ8IGY0nkd1Zerg7DHoI5QVEORCoQsmGQRlTLa6JIdHggAeqBZgRSRq6oKItN6hlrJA2HSqt5sVsh1FxGy6ZoBxSzq5HMWX4AHQ4t3708BUvr6AUf6kBFAUmvWQBOargfUNcVh+47tzyC36jYXig/yMnrgn5WsNg9lLbSfpYh0K+wHj3/JMaxtLPYQHw5h0UzWoh+pQzuUzHKaYg1Q7KPSfnGodA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWvu7DNGJn0CtTSYKiB6lRUrw25t101UDdtqKAVdAkU=;
 b=Neh45oGyWBt5wHetY7AGHmHfsrIsQiieWOi8FzLyqZCT5k/XPOcPoQF5MtWPgxiDf6XLCTB4Y8eQkRe9ghxet7UU4yLgfw5HLPos3QFpMj0FgE76Fee7DMCiSSWSluFK6ltFBCZRSL4bJPSLffU1GmioHWO8qU2zpCFRJULmdVA=
Received: from DB6PR07CA0071.eurprd07.prod.outlook.com (2603:10a6:6:2a::33) by
 AS8PR07MB7512.eurprd07.prod.outlook.com (2603:10a6:20b:2a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 18:15:43 +0000
Received: from DB5EUR02FT010.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:6:2a:cafe::f7) by DB6PR07CA0071.outlook.office365.com
 (2603:10a6:6:2a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Mon, 5 Dec 2022 18:15:43 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 DB5EUR02FT010.mail.protection.outlook.com (10.13.58.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 18:15:43 +0000
Received: from n95hx1g2.localnet (192.168.54.10) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 19:15:42 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     <netdev@vger.kernel.org>
Subject: Using a bridge for DSA and non-DSA devices
Date:   Mon, 5 Dec 2022 19:15:42 +0100
Message-ID: <2269377.ElGaqSPkdT@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.10]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB5EUR02FT010:EE_|AS8PR07MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e1af5e3-8cde-4b58-16fd-08dad6ecb90e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: beJ8lw7oM1ctQtKPJorbpo4e/Gq1LrQKGnEMCnzjkA8azjNeApb2l9Z5rUj0lqNGPpKQ0v0lGYxWTQXmozQ98I6meelwyDKMZFd6KTaNmZutrCdGMzi48CgCiSgeRuuqGAI3L5Ui0E68/N7SbJYVXruEL8WKaOEoKVc3tAG0CpQFS2lrk14AyJZf5U5l1jYHp3LcF6VGBnN5gHwqKFtiyMO3XJMZIkFmM/kbbImq7gW1ffeAKsNdt159UxCpG0+RTrRKP8iLS4fJQHpv9HmQHjqo8kSWTlyZSiAy52YX5v3qK8/AO3ZgtkCIB0zd2islUKX1RsBexw8r1LZ2jy6oRr5Nd+b1S48FwVkeeSeaVQnlHEMt+Spe3TQROUSxXhRo81xgcCJm4GcyqedWhm6x+hN7gt2tnoXRHyLtmMXMAGP0ZyFl0DvkV0kclb4V/94zuPPojLJyyjlEZVEzCHb5RRXogSttd2jLCeQa8ZjPXrGYg8jbGbtANmmHxrbIYCkq7ieerDdlq1rEDU6Z6fp7BUULKKyY9x1WF+fNAuaIMmS9bu5u2osWP77E1sKozgd76fIwNYHRD9wjpaliotoXY8bwqC8pIvh2e+fSUQw8aKtGFG1h5TeJ0int4nvS1ObniKuqW18DJcJftENdfyD+LkLWz2dud0XE7gJ8cbqic7FuJLUjzVs3xAg+FIB1/7AsTUOkDbTOjx5ZT2jl2nmzMg==
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39850400004)(136003)(451199015)(36840700001)(46966006)(36860700001)(356005)(86362001)(81166007)(82740400003)(4744005)(5660300002)(41300700001)(2906002)(8936002)(33716001)(8676002)(82310400005)(9576002)(40480700001)(9686003)(26005)(186003)(336012)(47076005)(16526019)(426003)(316002)(6916009)(70586007)(70206006)(478600001)(36916002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 18:15:43.0274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1af5e3-8cde-4b58-16fd-08dad6ecb90e
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR02FT010.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB7512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usually a bridge does forwarding of traffic between different hardware
interfaces in software. For DSA, setting up a bridge configures the
hardware in a way that traffic is forwarded in hardware.

Is there any problem combining these two situations on a single bridge?
Currently I use a bridge for configuring a DSA switch with two DSA slave
interfaces. Can I add a non-DSA device (e.g. an USB Ethernet gadget)
to this bridge?


regards
Christian



