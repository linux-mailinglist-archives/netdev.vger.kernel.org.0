Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CECD63ABA9
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiK1O4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiK1O4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:56:37 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2127.outbound.protection.outlook.com [40.107.104.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491401F9DA;
        Mon, 28 Nov 2022 06:56:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIjGhtCYBF0ZOQKUUA3FmKUDXrlyXC8EL8Mz8Zq05qy583MvrnOl5xVugQkMGoZRjHDYLSHtG7ATMidfVpmh5pwJhJAIWcwdR0qnntAmsCYA3ofEgnT9QtDMUJ0mvm9h+2Yekk4FlqNkfrjxYHugcEjD1F0bEvH5F/ivENyuTtWOcTst4L08Cpwh7gta8kPLXj3yVz09NoqgFxpixKWSMo4dy6SUNI0KhInzy/19EAoQLfkRppWo2KxA8mF8PPa/hqmkKrgSshxqgoemayq5sPuXkpj2NjBfWeVyUi9ibAqAvLRmru+a4J6BH3u122KlCMq0Hnn7upM4+cuaTs4EYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLZ6DNP1ktx/hPYmzo5z4YhkL6IZRM49lF+iYUWdR7s=;
 b=NjcUOxRfwKH+lANPn2/f42VqTDLThy2rT09UJj2DA/kkOd8VYt3OXcw74N/l2HmEMprzByG0+84uJNSpproUrpwVnxpxZ1nbYvK/55D02KpIvlt8g45SXAAifYAOp9bpfA/zwgRJovb6r9ypugrJuikqXgetxYYk6/pD0owOJde9PFekqi/4pGt5ncY1wLrP3MLSoFz+s4VZn7OALoiARRFby69Uxcfvm0+OUKexeG2mYzPeQcoDE6Z5aqaA3lIUK3GAE/fxm0qiwFlyM7Th1x5io3PnDTVpKAR10jhWaoUVb5j0sDt15WOMAs/6EBuHG0+bC1JpkI2X03i+JaQ8Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=microchip.com smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLZ6DNP1ktx/hPYmzo5z4YhkL6IZRM49lF+iYUWdR7s=;
 b=j443V07Iz4wN2fxEL+TCFtY4MJS9o81Fz83MhqGU1n341Fp7iqjBRzMD5vNt9rFbek4f743SqnTjIamLBtGC1ipZlIAHoGH7lZN0dXSjhZJODcThCLkdL29IgTy8to6w1uGHrZI+EzeGewmTE1j0Y0FyyIXg+BhRj51sYJdyprY=
Received: from AS9P250CA0013.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:532::24)
 by DB5PR07MB9454.eurprd07.prod.outlook.com (2603:10a6:10:48e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Mon, 28 Nov
 2022 14:56:32 +0000
Received: from AM0EUR02FT027.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:532:cafe::23) by AS9P250CA0013.outlook.office365.com
 (2603:10a6:20b:532::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Mon, 28 Nov 2022 14:56:32 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 AM0EUR02FT027.mail.protection.outlook.com (10.13.54.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.15 via Frontend Transport; Mon, 28 Nov 2022 14:56:31 +0000
Received: from n95hx1g2.localnet (192.168.54.110) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 15:56:30 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: Re: [Patch net-next v1 01/12] net: dsa: microchip: ptp: add the posix clock support
Date:   Mon, 28 Nov 2022 15:56:30 +0100
Message-ID: <5639053.DvuYhMxLoT@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <CALs4sv19Efi0oKVqRqRFtF2SCr6Phejh4RFvuRN1UCkdvcKJeg@mail.gmail.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com> <20221128103227.23171-2-arun.ramadoss@microchip.com> <CALs4sv19Efi0oKVqRqRFtF2SCr6Phejh4RFvuRN1UCkdvcKJeg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.110]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0EUR02FT027:EE_|DB5PR07MB9454:EE_
X-MS-Office365-Filtering-Correlation-Id: 63361fa4-f5f3-45f9-f8b6-08dad150bca2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwTVnFj4KE2dDNB5EWjjEa6fLNyw2quX5RZ5FdW/NRERWf/uPY2pogWWm1/kkJ7pnweom4YJukVAWpT3ggdHaMOfenJYBEAZYEXbIYquBbNlyd+2DSJFsqG87TnbbDCCgGwObFgW8Fi4JThyj00y+yRIOe1qTtL/cDQyHVTtWN8ksArbV8B7liBgCOGNKsvCw7pdajFlOKHMdoGWrfjaMaUQHoPFCaH59EHvF/j/c/6u4GJ3aBSdq5ciXSaGTdOrY3SOulshEJnh40AzosBYuk8khfJYg8QrXMZcZMe5EKgp+yyCrngYWPZkPBqPMaPpBLNTtIAMFymnAtMil6vZ+g1/0ViVWOMnFJGUPWiXm4xXx8Zee7xBQXDNCGi5SbCkkwRU5uJRF925MswLMLhUKmxauxxwKOYyPzEFtnFupV0bDFWHU4vUPo8ndbiHRRVVH2x3NBRJZ5wYBr3NO1brTaWDt7kRYPIEsgG8+P3cV4+f9BdWv3mHioEULAEuMsV8Yz3OvusFhMt9gD29FUb/YanQMpNwUYsDAgm8JyF880NINCoIwrexwGpLEBaukfZ8u4mZ2xn2pIlYBrV5Mppno4NYKgxIf9YV2CG9jy40E2yE4n4yIlkS85eCY9/5XZWXLZG+IU9xVZfbE8angaql1jZbvr4ybcvmmeqfhBS017gevItpx5cHvwD9hpFsSlOqF9iNwFvdg2CJcCHK/8aOkDO+9FmU2YTEYAX3VLIG6wCgqQQ7tEhvP2PC7NIoaku1
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39850400004)(136003)(451199015)(36840700001)(46966006)(110136005)(26005)(8936002)(2906002)(70206006)(336012)(426003)(82740400003)(47076005)(5660300002)(7416002)(186003)(36860700001)(54906003)(41300700001)(8676002)(16526019)(53546011)(478600001)(33716001)(4326008)(83380400001)(40480700001)(9576002)(316002)(70586007)(82310400005)(9686003)(36916002)(81166007)(356005)(86362001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 14:56:31.8419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63361fa4-f5f3-45f9-f8b6-08dad150bca2
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: AM0EUR02FT027.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR07MB9454
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, 28 November 2022, 15:49:33 CET, Pavan Chebbi wrote:
> On Mon, Nov 28, 2022 at 4:03 PM Arun Ramadoss
> <arun.ramadoss@microchip.com> wrote:
> 
> > diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
> > new file mode 100644
> > index 000000000000..e578a0006ecf
> > --- /dev/null
> > +++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
> > @@ -0,0 +1,57 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* Microchip KSZ PTP register definitions
> > + * Copyright (C) 2022 Microchip Technology Inc.
> > + */
> > +
> > +#ifndef __KSZ_PTP_REGS_H
> > +#define __KSZ_PTP_REGS_H
> > +
> > +/* 5 - PTP Clock */
> > +#define REG_PTP_CLK_CTRL               0x0500
> > +
> > +#define PTP_STEP_ADJ                   BIT(6)
> > +#define PTP_STEP_DIR                   BIT(5)
> > +#define PTP_READ_TIME                  BIT(4)
> > +#define PTP_LOAD_TIME                  BIT(3)
> 
> PTP_WRITE_TIME sounds more intuitive than PTP_LOAD_TIME?
PTP_LOAD_TIME has been derived from the data sheet:

-------------8<--------------
PTP Clock Load
--------------
Setting this bit will cause the PTP clock to be loaded with the time value in
registers 0x0502 to 0x050B.
------------->8--------------

I would also prefer PTP_WRITE_TIME. But is it ok to deviate from data sheet?

> Also I see that all the #defines are introduced in this patch, some of
> which are used later. It is a good idea to introduce the #defines in
> the same patches where they are being used for the first time.
> I will be looking at the entire series but am responding to this now.
> 
> > +#define PTP_CLK_ADJ_ENABLE             BIT(2)
> > +#define PTP_CLK_ENABLE                 BIT(1)
> > +#define PTP_CLK_RESET                  BIT(0)
> > +
> > +#define REG_PTP_RTC_SUB_NANOSEC__2     0x0502
> > +
> > +#define PTP_RTC_SUB_NANOSEC_M          0x0007
> > +#define PTP_RTC_0NS                    0x00
> > +
> > +#define REG_PTP_RTC_NANOSEC            0x0504
> > +#define REG_PTP_RTC_NANOSEC_H          0x0504
> > +#define REG_PTP_RTC_NANOSEC_L          0x0506
> > +
> > +#define REG_PTP_RTC_SEC                        0x0508
> > +#define REG_PTP_RTC_SEC_H              0x0508
> > +#define REG_PTP_RTC_SEC_L              0x050A
> > +
> > +#define REG_PTP_SUBNANOSEC_RATE                0x050C
> > +#define REG_PTP_SUBNANOSEC_RATE_H      0x050C
> > +#define PTP_SUBNANOSEC_M               0x3FFFFFFF
> > +
> > +#define PTP_RATE_DIR                   BIT(31)
> > +#define PTP_TMP_RATE_ENABLE            BIT(30)
> > +
> > +#define REG_PTP_SUBNANOSEC_RATE_L      0x050E
> > +
> > +#define REG_PTP_RATE_DURATION          0x0510
> > +#define REG_PTP_RATE_DURATION_H                0x0510
> > +#define REG_PTP_RATE_DURATION_L                0x0512
> > +
> > +#define REG_PTP_MSG_CONF1              0x0514
> > +
> > +#define PTP_802_1AS                    BIT(7)
> > +#define PTP_ENABLE                     BIT(6)
> > +#define PTP_ETH_ENABLE                 BIT(5)
> > +#define PTP_IPV4_UDP_ENABLE            BIT(4)
> > +#define PTP_IPV6_UDP_ENABLE            BIT(3)
> > +#define PTP_TC_P2P                     BIT(2)
> > +#define PTP_MASTER                     BIT(1)
> > +#define PTP_1STEP                      BIT(0)
> > +
> > +#endif
> > --
> > 2.36.1
> >
> 




