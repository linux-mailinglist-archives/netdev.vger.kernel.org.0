Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C0F64A467
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 16:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbiLLPs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 10:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiLLPsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 10:48:36 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2113.outbound.protection.outlook.com [40.107.7.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C2D6369;
        Mon, 12 Dec 2022 07:48:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAyXfKVEt5lbD71GUtR/XgNkgzvbQ/u//d4hANPJyoTEVPa0mr+olQQIavUmxBGiB+gMFnRoXsT8J+4FBAlvDfgkStxTiOMfqQ7uftdCuQ+YpHr+si9hbJ8ZuNkjTgd4GvDOB5kugvxstXkCH+vOh1IIL+NaIyVwoGixbOF86p441leDWitoorJ27jBTbd5Q0lwWVl5ulMarZ9BgaWzMothvF7Juod9VDwe57Vk5guoQCw4LI5P+TR6WYFEO+bOh3N5iBi1ydOf7Cssv6+OVWoRrMJZB++ncB3ez4K5O8nvc3raKBJ4Cjvi2Lbto0yVb86hthZ6j3XTMuSvGERkRQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYtCQVxaUeUQYb+aqcNpdEBqYAZfhdpSk/V2SJczJv8=;
 b=oJt9oNQOESU43sMjhiSmVYNBL+jCWK+ZScowrBTUck9A7dzal4L4lwUmVAU/JeMT6hjJWo/EkuPTlCBBTOAwgiwOkVsn5uV1UbQcVUtEXZHAtu0f0K255mI+gKmTKZzFhy+ZVNdm1h9xQwf+/5r1ppk9bpDj0aDv0pK4TKRlufCY0P1CNpnINMupCmHvrimIGE3YAz3A63TKGHGql9mn3kwL4lZFZSv89mytgi3YTa5FeyfxVMDaSiB9NE4vJCzV9rDC5XqNGF+KF7YDqHsFxdfDiAgCBwPvbofwDvlEVFo2bPMcNiaNpy65mDc3+gqwgSOVul4LcxN5NwlBqaqk5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYtCQVxaUeUQYb+aqcNpdEBqYAZfhdpSk/V2SJczJv8=;
 b=HuSBZPhs6irnQRt0/jgDsYOXPu5p2PHBwFHoBmx5O9sNrGJ6b+nBAfCcLGpX2car/cQcdVM1Un8zYCMRZFeeyumyiQsOYyUohAU0EY9p5HHSvvZD5Jn6H41phmSMnqLiCJunPjkArHPkMUe27AGmbIFoyLp3pZOaOv5OKsOs730=
Received: from DB8PR03CA0015.eurprd03.prod.outlook.com (2603:10a6:10:be::28)
 by PA4PR07MB8909.eurprd07.prod.outlook.com (2603:10a6:102:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 15:48:31 +0000
Received: from DB5EUR02FT029.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:10:be:cafe::52) by DB8PR03CA0015.outlook.office365.com
 (2603:10a6:10:be::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Mon, 12 Dec 2022 15:48:31 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 DB5EUR02FT029.mail.protection.outlook.com (10.13.58.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.21 via Frontend Transport; Mon, 12 Dec 2022 15:48:30 +0000
Received: from n95hx1g2.localnet (192.168.54.51) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 12 Dec
 2022 16:48:29 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: Re: [Patch net-next v4 00/13] net: dsa: microchip: add PTP support for KSZ9563/KSZ8563 and LAN937x
Date:   Mon, 12 Dec 2022 16:48:29 +0100
Message-ID: <5890893.lOV4Wx5bFT@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20221212102639.24415-1-arun.ramadoss@microchip.com>
References: <20221212102639.24415-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.51]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB5EUR02FT029:EE_|PA4PR07MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: c76250da-e3a3-43dc-fb42-08dadc585184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6e+PdHc0AE68ydMLdn8ze8R7hyjMWeXXNsMx54eaiAXYzdMfWL3ffN8XmFqpXnIhHZLCXfwXH36ZG7yCnn8/Lj2vuWBXKKc5CsI9r5SL+O9VysZ2orp0d2+giKomZiXV71DjV7/tIjgstN0CPaWeix6wdbKn8ytic1GV5CbSQwzkE0HcDaUv9UJ6ogO3OqDTtVItdQIHQzL8Sq0XSo7T1T/1kYW3AMuNmJktCkt3bptsdViy62gk+L3vgxrwCuwT1QXRgKmKEa5qaQJdgoEQgsElBoOS8yix7QM5bnZnMsdIvlgOXyqEaJI9+tCTh04mZJAX/Ho+TPkVCOcjgd2kUvKjiEzoNYa4XRNDVdPSrFuF05IrxeLAiNQy2EGVmsIzbAiZPBL5WaMGYjxrbxnS+IPnU/8w9oKGnK/5/1qDVb7Tt7f9cpSU6nFLnw1cqDIA692nECI9Thifw1AW5838YhnEN4vd0tp/+xWJMgocLtmRdgJS34M+BfDQpSbmr75AnGdS+FObw3qn6MS4I7RCFY4P7rCKuHzAWxLQjImG0vUCttxkXHxuIzdcCm0iKtcygT9eXLVV+Z7BswqyECIXX+jUwZTZrNSn0Slg+UHIF6Ujwa62SRB54sNqjZzoh4Rycfaf+atQTXazxqFOTqHNEb6Dk4abSquOd4/aYYg5DzPRwcCh89aLsvZf9cy+noSSgI32BoHkcr5Q9Jw5cHoVMlyykzNViYnVRtX01MdhxreRw3IPuWn4vQmtWvWC/WO4RdPZPkE9rj5IdQot/mGeyJ5auH3fsgE+7GRJUQCIf7s=
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39850400004)(346002)(136003)(451199015)(36840700001)(46966006)(82740400003)(36860700001)(47076005)(356005)(81166007)(86362001)(5660300002)(7416002)(2906002)(9576002)(70206006)(8676002)(8936002)(82310400005)(33716001)(41300700001)(40480700001)(426003)(9686003)(83380400001)(186003)(336012)(26005)(54906003)(316002)(110136005)(4326008)(478600001)(70586007)(966005)(16526019)(36916002)(39026012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 15:48:30.8467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c76250da-e3a3-43dc-fb42-08dadc585184
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR02FT029.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR07MB8909
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, 12 December 2022, 11:26:26 CET, Arun Ramadoss wrote:
> KSZ9563/KSZ8563 and  LAN937x switch are capable for supporting IEEE 1588 PTP
> protocol.  LAN937x has the same PTP register set similar to KSZ9563, hence the
> implementation has been made common for the KSZ switches.  KSZ9563 does not
> support two step timestamping but LAN937x supports both.  Tested the 1step &
> 2step p2p timestamping in LAN937x and p2p1step timestamping in KSZ9563.
> 
> This patch series is based on the Christian Eggers PTP support for KSZ9563.
> Applied the Christian patch and updated as per the latest refactoring of KSZ
> series code. The features added on top are PTP packet Interrupt
> implementation based on nested handler, LAN937x two step timestamping and
> programmable per_out pins.
> 
> Link: https://www.spinics.net/lists/netdev/msg705531.html
> 
> Patch v3 -> v4
> - removed IRQF_TRIGGER_FALLING from the request_threaded_irq of ptp msg
> - addressed review comments on patch 10 periodic output
> - added sign off in patch 6 & 9
> - reverted to set PTP_1STEP bit for lan937x which is missed during v3 regression
> 
> Patch v2-> v3
> - used port_rxtstamp for reconstructing the absolute timestamp instead of
> tagger function pointer.
> - Reverted to setting of 802.1As bit.
> 
> Patch v1 -> v2
> - GPIO perout enable bit is different for LAN937x and KSZ9x. Added new patch
> for configuring LAN937x programmable pins.
> - PTP enabled in hardware based on both tx and rx timestamping of all the user
> ports.
> - Replaced setting of 802.1AS bit with P2P bit in PTP_MSG_CONF1 register.
> 
> RFC v2 -> Patch v1
> - Changed the patch author based on past patch submission
> - Changed the commit message prefix as net: dsa: microchip: ptp
> Individual patch changes are listed in correspondig commits.
> 
> RFC v1 -> v2
> - Added the p2p1step timestamping and conditional execution of 2 step for
>   LAN937x only.
> - Added the periodic output support
> 
> Arun Ramadoss (5):
>   net: dsa: microchip: ptp: add 4 bytes in tail tag when ptp enabled
>   net: dsa: microchip: ptp: enable interrupt for timestamping
>   net: dsa: microchip: ptp: add support for perout programmable pins
>   net: dsa: microchip: ptp: lan937x: add 2 step timestamping
>   net: dsa: microchip: ptp: lan937x: Enable periodic output in LED pins
> 
> Christian Eggers (8):
>   net: dsa: microchip: ptp: add the posix clock support
>   net: dsa: microchip: ptp: Initial hardware time stamping support
>   net: dsa: microchip: ptp: manipulating absolute time using ptp hw
>     clock
>   net: ptp: add helper for one-step P2P clocks
>   net: dsa: microchip: ptp: add packet reception timestamping
>   net: dsa: microchip: ptp: add packet transmission timestamping
>   net: dsa: microchip: ptp: move pdelay_rsp correction field to tail tag
>   net: dsa: microchip: ptp: add periodic output signal
> 
>  MAINTAINERS                             |    1 +
>  drivers/net/dsa/microchip/Kconfig       |   11 +
>  drivers/net/dsa/microchip/Makefile      |    5 +
>  drivers/net/dsa/microchip/ksz_common.c  |   44 +-
>  drivers/net/dsa/microchip/ksz_common.h  |   48 +
>  drivers/net/dsa/microchip/ksz_ptp.c     | 1187 +++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_ptp.h     |   86 ++
>  drivers/net/dsa/microchip/ksz_ptp_reg.h |  142 +++
>  include/linux/dsa/ksz_common.h          |   53 +
>  include/linux/ptp_classify.h            |   71 ++
>  net/dsa/tag_ksz.c                       |  213 +++-
>  11 files changed, 1843 insertions(+), 18 deletions(-)
>  create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
>  create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
>  create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h
>  create mode 100644 include/linux/dsa/ksz_common.h
> 
> 
> base-commit: 6d534ee057b62ca9332b988619323ee99c7847c1
> 

For the whole series:
Tested-by: Christian Eggers <ceggers@arri.de>  # on KSZ9563 with P2P/BC/L2/1-step



