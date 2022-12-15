Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8836164DC74
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 14:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiLONvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 08:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLONvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 08:51:09 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2134.outbound.protection.outlook.com [40.107.15.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E00219039;
        Thu, 15 Dec 2022 05:51:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EebpOLDYGWtq8MwrkxdrhJIXu5F3cxYafVMpJn97oWyxjGVLIerxIpuhIqjTb0kYtUa3DXr1Ma20872Tf5PcfmX/ATfNu/8J50rhaqvIMjeO4hjcXpoWCF99qZZ6XANC1547peJBmFsluSjRRBtG9Q8saK3DpEiEcBhKj2T437FV8wWrmrA3W6/MLZjc72ITMvqhnCMcK+4HYBgDxfsrVuFu7/5aNdDA/5qXqLWjOIMUZ0iKyu8XJCWqdJPX/h9k4LeLkbZqkvSUf9n/AWCh+Rup4HiYZmdc6nWhtLPqahAPUnf+HS6Ps0d9e7o5hNM75Nl7+CCT4KAuLUUjR0eXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVV9UAOTxc5i9aZkUJPifSu/K2KMCq4S2yXn+xdo9A8=;
 b=FINW0UziTOBr2/k3UZdWEulRVBrt5Tv7U1TEgADQMTu0h8n39+tZy88G67ey2o4N8TysdkMB9f1cgh5jJYiBgYTvAVOuMvpEvJ4ixj+X2Y0zwRNGgB+MdQc3tdXQPzdJj+oFxliKkhFW3nQiZJ4+cygQUTUYSRY+Px5LJLBHb+jQPVj5SrbCgz6Q5dXWljxQUUOqY/HCj3efUjCuE0SaqvtCJRaRVULgF3ysXfrQbGsIq5mVFbgH+1CbiOg7xZuGLfQJgaAVdyuXPeczur1t0vVeemAhbwmxt3wXz4HCTZMscppP+ADg/HcqYLptwT4oO106g4oiSGxc/uZYLTcOrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=microchip.com smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVV9UAOTxc5i9aZkUJPifSu/K2KMCq4S2yXn+xdo9A8=;
 b=CQ4SP+wQQCO+7PZTsV7+bohSWjQdNxrzVC7Mwa/iTGE5yY7hgB2A4PlJqDAbQinuTMNxKCJuePvvG2hICtQXADkkO8SkDu2kyC9G2b8EeWny42vcJt1b25Q5XoAepGzitK/SpCDbItOuyap8Ex+F+8WmvROJF/q2eGDaNF/c5As=
Received: from DU2PR04CA0045.eurprd04.prod.outlook.com (2603:10a6:10:234::20)
 by GV1PR07MB9023.eurprd07.prod.outlook.com (2603:10a6:150:86::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 13:50:58 +0000
Received: from DB5EUR02FT054.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:10:234:cafe::a) by DU2PR04CA0045.outlook.office365.com
 (2603:10a6:10:234::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12 via Frontend
 Transport; Thu, 15 Dec 2022 13:50:58 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 DB5EUR02FT054.mail.protection.outlook.com (10.13.59.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.12 via Frontend Transport; Thu, 15 Dec 2022 13:50:57 +0000
Received: from n95hx1g2.localnet (10.30.4.179) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 15 Dec
 2022 14:50:57 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <linux@armlinux.org.uk>,
        <Tristram.Ha@microchip.com>
Subject: Re: [Patch net] net: dsa: microchip: remove IRQF_TRIGGER_FALLING in request_threaded_irq
Date:   Thu, 15 Dec 2022 14:50:57 +0100
Message-ID: <2280237.ElGaqSPkdT@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <0d35858867ae1c3de899d6162aa39e013daff435.camel@redhat.com>
References: <20221213101440.24667-1-arun.ramadoss@microchip.com> <0d35858867ae1c3de899d6162aa39e013daff435.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.30.4.179]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB5EUR02FT054:EE_|GV1PR07MB9023:EE_
X-MS-Office365-Filtering-Correlation-Id: 876608d0-0cb4-4d1d-ccd3-08dadea364e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDa8oFv++UqO/QZQdTPlo5AB5abajgevseV3sjjt5pYUhmHt3f10hvr7BylHlNmxmrkr5YZsb4IY6mQX40jG8xP7zlRKmbkr5WsjJ86uZu5Ob69S44alt2I2C1jzAq0NyTXYqsCTCS3L+WjDpBYCsc0X3/AUpyj/L4iq18HrrW9Ine9gUDWYcio6qzSbfN4iVWgYEx8Hz1wAwzBkPrl2OlbeRSj03yiBFP8uGgnaUx3g/WgKpINj36jGVEcz2PO8ecBH9pvHqvuGJPc78RoXt+6EhsRYbPlarlG/Tfu99az3hgi+ZSySpxWw7nL0cf38aBBjzWcGMqIyDYeSw2UTYWguia1g8XzBXQFB1zFtyMNIwfUGxkpwGY/d90FIgUVsuXMDMUbINErQ4dIoOKbDPFFHVYPh7t8giay9o/JneWg/rw16QFC34P9PY/rdJsSZKhnY9ALf6UaSHRGDQW8nDGjwF4QbgFEkvu54vsjABGfSJh9U0pX0RLb44p6OFAf54I24aA38ilKlv9mEEQwV6Sxk0VH8IjgukBzmvCjGLb/4674aqqACOButZeYx9DlotnmRWLewMboD114F/LOaA79k2pK2Tvu81APK+zeb0FhPvXAChQZqlhAagqzcE67CNd1jMruyml1seS8R5C8mHURQWCqTl42KtOCq6wFVfUIU/k8e3uZ2FOZCpNi5fU3HgBqjMBXiWw8lM8JmZ/lMvgADshl/5OiackgNNoNv0AY=
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(36840700001)(46966006)(47076005)(426003)(83380400001)(36860700001)(86362001)(82740400003)(81166007)(356005)(2906002)(5660300002)(4001150100001)(41300700001)(8936002)(82310400005)(7416002)(9576002)(40480700001)(33716001)(36916002)(4326008)(26005)(186003)(16526019)(9686003)(336012)(316002)(8676002)(70586007)(70206006)(54906003)(478600001)(966005)(110136005)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 13:50:57.9538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 876608d0-0cb4-4d1d-ccd3-08dadea364e5
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR02FT054.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR07MB9023
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On Thursday, 15 December 2022, 12:29:22 CET, Paolo Abeni wrote:
> On Tue, 2022-12-13 at 15:44 +0530, Arun Ramadoss wrote:
> > KSZ swithes used interrupts for detecting the phy link up and down.
> > During registering the interrupt handler, it used IRQF_TRIGGER_FALLING
> > flag. But this flag has to be retrieved from device tree instead of hard
> > coding in the driver, 
> 
> Out of sheer ignorance, why?

As far as I know, some IRQF_ flags should be set through the firmware
(e.g. device tree) instead hard coding them into the driver. On my
platform, I have to use IRQF_TRIGGER_LOW instead of IRQF_TRIGGER_FALLING.
If the value is hard coded into the driver, the value from the driver
will have precedence.

See also: https://stackoverflow.com/a/40051191

> > so removing the flag.
> 
> It looks like the device tree currently lack such item, so this is
> effecivelly breaking phy linkup/linkdown?
What is "the" device tree. Do you mean the device tree for your specific
board, or the example under 
Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml?
The latter doesn't mention the irq at all.

BTW: In my kernel log I get the following messages:

> ksz9477-switch 0-005f: configuring for fixed/rmii link mode
> ksz9477-switch 0-005f lan0 (uninitialized): PHY [dsa-0.0:00] driver [Microchip KSZ9477] (irq=POLL)
> ksz9477-switch 0-005f: Link is Up - 100Mbps/Full - flow control off
> ksz9477-switch 0-005f lan1 (uninitialized): PHY [dsa-0.0:01] driver [Microchip KSZ9477] (irq=POLL)

Should I see something different than "irq=POLL" when an
irq line is provided in the device tree?

regards
Christian



