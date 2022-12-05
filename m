Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0504D643545
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 21:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiLEUIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 15:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiLEUIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 15:08:44 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2113.outbound.protection.outlook.com [40.107.8.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCAB2315F
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 12:08:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akO7GPvU21wRGzybPDAnDu59BrToWOqLuQ6IcxmtIHgHxkbIR0mcbL5fgrAWJ/nkrmS9e3ujUPGYrN7AGAZdrvRc6bvbPvrWLOC6CuZ+a5JbvogUORvcnWb1PXnFM12tgU5ooDss7g0FxKLb2vyVcO+9RuweAToMHx9Odz/2r/ZnDHGQ+QWpHjjRKFka1Ir/DhVu8kRytDKWh8bKeFuM0gld6j3DNDdy3BM2FnKwTaylRkYsaKnU5m7ZvbKzktBRWr2L/tBZDp1nyLEURUJGl20Fl0W2d6EnKb/7Eipa+OaOoITApK2QJFh4pLg1PpmP0gpzs9UNZC6vLBmS193yMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3XX2dzyO+83BbAdbXu2hvRoEZAd7UGPfVE407CGIMg=;
 b=U4GwWqcOrKkaxndvsJkfqvLij9baYaD45bR6tsYE6nGFMY/S4ON+572V02wclU7jhObHgizxa23WtxxukAojvXEXORmlMPxihpgGuqleHAuXIFS5vLxKWdT7BGb8HQ18oTCRTEZ16pnwByVufUUfpmk6i/oUQsx8GyttnwXo5M2w7jRYX8v/Ic5hSTmLHT4cJ47iBoxaPn0WVlW4rnvtOyGYNeXOtfgqxf9vDUl/cjjf8QpT4FV9iA1RQz9BuxSDCV8cvqCGySfVWB8cOm7haZFOAD1wQ3Il94O1hYipDRZ1aMUklhopzG/uUV6IZMPMzuO7pcRmBjksy/XePMF0sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=gmail.com smtp.mailfrom=arri.de; dmarc=none
 action=none header.from=arri.de; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3XX2dzyO+83BbAdbXu2hvRoEZAd7UGPfVE407CGIMg=;
 b=cmrFYEWNi6JgRCx/VegIAwMuG1YYA/4STuO2k+azb7eThVP9QuwhOXLMIcNvKSCgHykEiEvBXw7n4ke9aiqWHdTa1SIRNkX2+d+5nyXpyug+ZYj530k+7/WhPRDJA8kqi69num1dAW4296EAQozDbp81u2UZCtO2H45urjE/61E=
Received: from DUZPR01CA0002.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::8) by AM9PR07MB7811.eurprd07.prod.outlook.com
 (2603:10a6:20b:303::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 20:08:40 +0000
Received: from DB5EUR02FT011.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:10:3c3:cafe::c2) by DUZPR01CA0002.outlook.office365.com
 (2603:10a6:10:3c3::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Mon, 5 Dec 2022 20:08:39 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 DB5EUR02FT011.mail.protection.outlook.com (10.13.58.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 20:08:39 +0000
Received: from n95hx1g2.localnet (192.168.54.14) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 21:08:38 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: Using a bridge for DSA and non-DSA devices
Date:   Mon, 5 Dec 2022 21:08:38 +0100
Message-ID: <3213598.44csPzL39Z@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20221205190805.vwcv6z7ize3z64j2@skbuf>
References: <2269377.ElGaqSPkdT@n95hx1g2> <20221205190805.vwcv6z7ize3z64j2@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.14]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB5EUR02FT011:EE_|AM9PR07MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ceaa535-6b31-48ad-db8b-08dad6fc800d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yllQFiwNQvSqY1ngCp1BZosBVMMmyEHTnNOIVGqoi5XYGoqfxgJScFHImmsoRw44a5MlZG5pWB0VRUbOUpXTychR+ABAjQdpiyp0jKfAwrUwOMIqlbi6TyyGMB5SbfKsTKX5B2l8byue9cDPZ/tdYQWF7A40Mbgadz5hoGZFOw+d6BifiTRNUC4czQzV8nNIA3CiewUbUeLrlf7JCRaqhfHd7tIpZpvTupkTcZsEvuBf4exHKOGKFW3EkbXuuSmeWlVhYx+B5SsODAJGupCBF5jMW9+Pb/6LBHWSEP722lfW9/g106sO5t2bF/BTwSwGpIjLTEW9ujxZhmjg8Fp5YDTS+MXHPBXjSzqLm/PJ+NnMA2BBonwYEACqfP4r5x0gArUvQ8HU/0ft0L1D5PlZntCj1/DohD9/sCOJuYQai4+l8hHJEJcxSJjLieQPJXI+KIWZbjxDQg0y5zJMrhc1RLhLWmrfb107pGSCbGHoPnbECpSnz1DkU0WyQoJYtrvEZAHcesrJ/0bF1H0buMxKSUnc3kzl/8nOUeOcACUVRunF75j6Nv2bEXClf0Dl/okSeapl3zxsf6ctR/YDqbp7kfx6JqdNVC/6gWHE7Mm0t6LjFQ5YXdOhCqWmHwZQBXWOJApKQ1Xk9gtP0/wSIreJITcO2RPOIbCnjURtbqvIPy4R6ttDrAi/xxFDXZOXwltVJ0ppLSNDJ/Ri1wOgFj+D0TsIvngCSL8UVWzFjUFht+Q=
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199015)(46966006)(36840700001)(2906002)(83380400001)(47076005)(316002)(426003)(86362001)(26005)(186003)(9686003)(36916002)(16526019)(81166007)(478600001)(356005)(82740400003)(6862004)(9576002)(8936002)(5660300002)(41300700001)(4326008)(36860700001)(336012)(70206006)(70586007)(8676002)(82310400005)(33716001)(40480700001)(39026012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 20:08:39.0778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ceaa535-6b31-48ad-db8b-08dad6fc800d
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR02FT011.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR07MB7811
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Monday, 5 December 2022, 20:08:05 CET, Vladimir Oltean wrote:
> Hi Christian,
> 
> In the model that the DSA core tries to impose, software bridging is
> possible, as long as you understand the physical constraints (throughput
> will be limited by the link speed of the CPU ports), and as long as the
> switch doesn't use DSA_TAG_PROTO_NONE (a remnant of the past).

my hope was that a "combined" mode would be possible where traffic
between the DSA slave ports is forwarded in hardware and only other
traffic requires CPU intervention. Our embedded device uses the
KSZ9563 3-port switch with two DSA slave ports. The intention is
that the customer can daisy chain multiple of our devices without
the need for extra Ethernet switches. For reasonable performance,
forwarding shall be done in hardware, especially as the external
port a 1 GBit Ethernet whilst the CPU port is only 100 MBit/s.

Beside the Ethernet interfaces I would like to add further connectivity
options (like USB gadget, WiFi, Bluetooth, ...). I consider these
interfaces as "secondary" in terms of performance and I think that
forwarding will not be an use case here. Currently, each secondary
interface has its own subnet (no bridging), but for every interface I add,
I have to "invent" new IP ranges which eventually collide with other
networks of the customers.

I already took the "lets use IP4LL" joker on one interface but I
learned today, that I cannot do this for further ones
(at least not without bridging). To make things even worse, we decided
to always configure IP4LL as a secondary address on the Ethernet
interfaces (NetworkManager just gained support for this). That's
why I estimate whether it makes sense to put all external interfaces
below a common bridge with only one IP address at all (or one pair
of DHCP+IP4LL).

> 
> Unfortunately the results might depend on which switch driver you use
> for this, since some driver cooperation is needed for smooth sailing,
> and we don't see perfect uniformity. See the
> ds->assisted_learning_on_cpu_port flag for some more details.

Thanks for the pointer, unfortunately this hasn't been implemented
yet for the KSZ switches.

> Did you already try to experiment with software bridging and faced any
> issues?

No, I didn't. But just to make it clear: Will the DSA framework
change to "pure software" switching as soon I add the first non-DSA
slave to an exisiting DSA bridge?

regards
Christian



