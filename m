Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4AF6CACFE
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 20:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjC0SZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 14:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjC0SZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 14:25:47 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2057.outbound.protection.outlook.com [40.107.7.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CE930E2;
        Mon, 27 Mar 2023 11:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdPWkEPzYbVYwW76BG2IC2TrmJoLlsDnTRzpvT6Kb+8=;
 b=tWuddxnbZ5e1KmHKSWVCh+zq0oRTUcN7H0s/FtiribiQURrsI52p/w9snIVBhwOZJHTGTJ1pmW3NiINrP4Udq7McuH8BSrcWJ/gnthQYifdve7ALUDO1LCbDUJIg9E/w0MiEonxWX1Dd7EzaM/MxCwmrWQE3kQgsLezosYLxsl4NKZVrKCZPoSqX7hIJotZLf5JL+nrQLYA+/FLxt0bRw/nthSmH8ChlWgr/9etRJKZwibZE2P3zvDFOJCJk81Ayl3fFjwhkIjS1glW0QJhJPjjc5XY5ywNUgrf/iqb+uqltWyUMwNJVJFF53G+A3woZe+p1AVnCXSWY3kII8FfeWA==
Received: from AM6PR05CA0017.eurprd05.prod.outlook.com (2603:10a6:20b:2e::30)
 by AS4PR03MB8578.eurprd03.prod.outlook.com (2603:10a6:20b:585::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Mon, 27 Mar
 2023 18:25:42 +0000
Received: from AM6EUR05FT051.eop-eur05.prod.protection.outlook.com
 (2603:10a6:20b:2e:cafe::b1) by AM6PR05CA0017.outlook.office365.com
 (2603:10a6:20b:2e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.42 via Frontend
 Transport; Mon, 27 Mar 2023 18:25:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.85)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.85 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.85; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.85) by
 AM6EUR05FT051.mail.protection.outlook.com (10.233.241.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Mon, 27 Mar 2023 18:25:41 +0000
Received: from outmta (unknown [192.168.82.135])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 8A2A32008026E;
        Mon, 27 Mar 2023 18:25:41 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (unknown [104.47.13.58])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id B980D2008006D;
        Mon, 27 Mar 2023 18:25:41 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVWq9KNbI9PFRSoG4jq4aKOTHWxrP2c5nAuj2bMk6JehP1rA80Nv2yzMS/eyKrTZFYNlyeXYL3Dxxfnb7bpEopfMdajpAsU4UFz6c62atfdiYpssYaIAjS8qT63ggrbh7dKNfevH1M3SiaKViuHMshjBZywCZEzvpBK3OgBb5ttM+7OHqYMVvYe5lqR3IWvJTvTs+jVQ8LzQOzfK7F+HFXyM/y1KZYG7Aqc3xPOPEuG95Ig3cl3kN2y2U0AoOXfGnv+mOBz1V9dIMXhHT8+ewlNqSI//PvM3cfMG20mJu/zW1g/dNMnmNICEGotrRomOPZRfGLyknVvB+/ic3lQmwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdPWkEPzYbVYwW76BG2IC2TrmJoLlsDnTRzpvT6Kb+8=;
 b=iE6w3xMdeRirPJChQrPSzwKQepHVziSY5gIqmrt4erl3YNVsAxfRmy0svUA3e/pB81J7nCSb/0yHK2nY9V6C+tsoDN6XtFowvCxpiFOUCSmHcpPdHhlrR5zvd/Y8QTTLskyIt3/Lxf9yUqvfFOcqL4IgNK1Imh3Y6z2R1/w10/pPwgPSK+akkEhxPZlU/Jlh6or8rVHM9DlkSDp+T2MYg3O06qM1V/PEzBN4RUibusAhlp0lNhQ8c0a0KptWElUiGeCP3ifslZN6Yvr4W6cKs3dvkkzOOIP6RJvjeP1PR0dcBFZQRXBbHDoZJLrybn+65oQQU4cciCIoOb+/HRYTLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdPWkEPzYbVYwW76BG2IC2TrmJoLlsDnTRzpvT6Kb+8=;
 b=tWuddxnbZ5e1KmHKSWVCh+zq0oRTUcN7H0s/FtiribiQURrsI52p/w9snIVBhwOZJHTGTJ1pmW3NiINrP4Udq7McuH8BSrcWJ/gnthQYifdve7ALUDO1LCbDUJIg9E/w0MiEonxWX1Dd7EzaM/MxCwmrWQE3kQgsLezosYLxsl4NKZVrKCZPoSqX7hIJotZLf5JL+nrQLYA+/FLxt0bRw/nthSmH8ChlWgr/9etRJKZwibZE2P3zvDFOJCJk81Ayl3fFjwhkIjS1glW0QJhJPjjc5XY5ywNUgrf/iqb+uqltWyUMwNJVJFF53G+A3woZe+p1AVnCXSWY3kII8FfeWA==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PAXPR03MB7547.eurprd03.prod.outlook.com (2603:10a6:102:1da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:25:32 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6178.041; Mon, 27 Mar 2023
 18:25:32 +0000
Message-ID: <5772a810-7ba7-5a98-f56b-2b780bf51de0@seco.com>
Date:   Mon, 27 Mar 2023 14:25:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
 <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
 <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
 <20230323152724.fxcxysfe637bqxzt@LXL00007.wbi.nxp.com>
 <d6900e52-ddd2-9334-3ed0-734b3e4a957a@seco.com>
 <20230324130728.yqxqzny2jwvvslri@LXL00007.wbi.nxp.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230324130728.yqxqzny2jwvvslri@LXL00007.wbi.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:208:239::25) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PAXPR03MB7547:EE_|AM6EUR05FT051:EE_|AS4PR03MB8578:EE_
X-MS-Office365-Filtering-Correlation-Id: 17b4663d-d9fc-427a-001a-08db2ef0ac15
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: HN9uNXugAuvlQzMfWivVg0ZNiDJbNHHKOn/DVFO0pl/RFfBkCACVvcABuMzt1BkzhyOVR+DuVd/1F5lMYKX59mV5tb2NMT6IwvcPqzvNUlRy9Te7xRU2u7/ZEBY/aPF337sS7B0dlSgXoFnlRPfX9tLKlpJIUrn3w7cEna32OI7jH+j/yn6FGmu+Iywz26wFkcomrGLN2PW3x8Iu22RO1H0DlZMUawrNdgG+u01Or+7DC6U6tF3Y3zlQtatQdzn6Edo21Kye3y1gLR6vsUh2eDCuXhH/duoIA1gV60N8aEBf6gD1CeFDWBu+P+zK7AR7ck5RVr6Rijozvfe8bF4PbnOQvWLJ4h7qCRrpupDQ75I4lnDFeIBUOm5Sc7v0Xdpp7JJrvYGF+8tO5BxWDhXBUOGx+N8xjyJkn0poiu1K7LQLSRNVSDqOTN/WnDEucEW/Jf53hSrWkQy/QJLOVLUF5ehUqAGipP81q5IcocJvp2RntUyu9UbiMjb0URNRsYEYfxUqJS9CPRhUAkd0mLOxLlTzD+sDlqlS9W3WjnQ0hMN2B7gHAPSF6SneWIZZdOapfJhbM25ZOZlVqa54KqQvac15Wwzq2w3PyQarMqMSzlOTnm7Zigqv4SsJjIVc9gUb48rIR0IILsfANVgXb/hA4Wt+/CuxR+ZgynPcgudqTolwtMjh+wNYRJ6HvxdvuFzo
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39850400004)(366004)(136003)(346002)(451199021)(316002)(478600001)(54906003)(36756003)(8936002)(31696002)(5660300002)(86362001)(66476007)(38350700002)(38100700002)(2906002)(4326008)(6916009)(8676002)(44832011)(66556008)(66946007)(41300700001)(6666004)(186003)(6512007)(6506007)(26005)(53546011)(31686004)(2616005)(6486002)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7547
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM6EUR05FT051.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 02656380-385d-465c-0974-08db2ef0a69c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PhgB80vO+sawXwhliK82GL3UtaJUxzF3xZ/XliSdgMrMzhOIr2WEcWOW9BW2ooYMQoc6yTgbfpsxUgLGu1/WKy6wKrMLiplXVOhUxAchOVHzjtYCD0nkuptYS3Y3NCv8Qbh7uD8xJf4J/v68PjeYxqZ54lhbXy/IUs4qKaDWQJNqIqtAkMdPjcgv7UC6G1OGQHhDTmJDD3ehIdxHfOV88UZHBxqC/OxiHcf8eN8xdge0HAuuA6L2NlRPD4jsKTJ7R5UPkT/Q9Faql1mg8Z2c6gX52/FqC8GgNOwgqIgTy2+pHOzKtfCfiZe6H+/BKLhfGDVQisiImbq8C1pTiUU1LFTtYbwkQPQBOvbQH8tw3HNqrUanEa9ZSvseITCV/sgNfUqFEFOyR5D7Mfl80d92EajNyOhW6Pih68dLAcYYxO/ZYt8IfS3pZsR606XO+It9uSboqR2DzsXD4QeR3rg+wmCKWqT3yoy/KRWHxPRi9YqbQcak7K8smTOBbpW5wQ+kPKHJeNQCrzyhyJuKtff1HMK1fcwBa2ybxrbXoxpUiqssd3y6DdSBrxP0ha2vEEhJsoyszndyN2iwTt2anrTJqthVGASMiMZUXk13aRqyaeC6FOjxW8cEG9OU6ML81sJH1HubIM7yzyPhBBOwxBkXjYiuaU7oZNkx0/5FOjybF/Ef1AIns7NS2DOVCITPLmd1ppOnfThQgbTq/KR6rWwKiluLs9D9tXZTZRk0tuhUu5lIHSpmOXVa3z/fDl8oFau3j+7txzvUpwNaCCLN56IzQ==
X-Forefront-Antispam-Report: CIP:20.160.56.85;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230028)(39850400004)(346002)(136003)(376002)(396003)(451199021)(40470700004)(46966006)(36840700001)(31686004)(2616005)(47076005)(336012)(34020700004)(41300700001)(31696002)(44832011)(36860700001)(36756003)(86362001)(5660300002)(7596003)(7636003)(356005)(8936002)(82740400003)(40460700003)(6486002)(54906003)(478600001)(70586007)(8676002)(4326008)(6916009)(70206006)(2906002)(6512007)(53546011)(40480700001)(82310400005)(6666004)(6506007)(316002)(186003)(26005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:25:41.6674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b4663d-d9fc-427a-001a-08db2ef0ac15
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.85];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT051.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8578
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 09:07, Ioana Ciornei wrote:
> On Thu, Mar 23, 2023 at 12:30:34PM -0400, Sean Anderson wrote:
>> On 3/23/23 11:27, Ioana Ciornei wrote:
>> > On Mon, Mar 06, 2023 at 11:13:17AM -0500, Sean Anderson wrote:
>> >> On 3/6/23 03:09, Ioana Ciornei wrote:
>> >> > On Fri, Mar 03, 2023 at 07:31:59PM -0500, Sean Anderson wrote:
>> >> >> When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
>> >> >> add backplane link mode support"), Ioana Ciornei said [1]:
>> >> >> 
>> >> >> > ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
>> >> >> > by Linux (since the firmware is not touching these). That being said,
>> >> >> > DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
>> >> >> > also have their PCS managed by Linux (no interraction from the
>> >> >> > firmware's part with the PCS, just the SerDes).
>> >> >> 
>> >> >> This implies that Linux only manages the SerDes when the link type is
>> >> >> backplane. Modify the condition in dpaa2_mac_connect to reflect this,
>> >> >> moving the existing conditions to more appropriate places.
>> >> > 
>> >> > I am not sure I understand why are you moving the conditions to
>> >> > different places. Could you please explain?
>> >> 
>> >> This is not (just) a movement of conditions, but a changing of what they
>> >> apply to.
>> >> 
>> >> There are two things which this patch changes: whether we manage the phy
>> >> and whether we say we support alternate interfaces. According to your
>> >> comment above (and roughly in-line with my testing), Linux manages the
>> >> phy *exactly* when the link type is BACKPLANE. In all other cases, the
>> >> firmware manages the phy. Similarly, alternate interfaces are supported
>> >> *exactly* when the firmware supports PROTOCOL_CHANGE. However, currently
>> >> the conditions do not match this.
>> >> 
>> >> > Why not just append the existing condition from dpaa2_mac_connect() with
>> >> > "mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE"?
>> >> > 
>> >> > This way, the serdes_phy is populated only if all the conditions pass
>> >> > and you don't have to scatter them all around the driver.
>> >> 
>> >> If we have link type BACKPLANE, Linux manages the phy, even if the
>> >> firmware doesn't support changing the interface. Therefore, we need to
>> >> grab the phy, but not fill in alternate interfaces.
>> >> 
>> >> This does not scatter the conditions, but instead moves them to exactly
>> >> where they are needed. Currently, they are in the wrong places.
>> > 
>> > Sorry for not making my position clear from the first time which is:
>> > there is no point in having a SerDes driver or a reference to the
>> > SerDes PHY if the firmware does not actually support changing of
>> > interfaces.
>> > 
>> > Why I think that is because the SerDes is configured at boot time
>> > anyway for the interface type defined in the RCW (Reset Configuration
>> > Word). If the firmware does not support any protocol change then why
>> > trouble the dpaa2-eth driver with anything SerDes related?
>> 
>> It's actually the other way around. If the firmware is managing the phy,
>> why try to probe it? Consider a situation where the firmware supports
>> protocol change, but the link type is PHY. Then we will probe the
>> serdes, but we may confuse the firmware (or vice versa).
> 
> And how is that conflicting with what I said?

The existing checks let the above scenario happen.

> Again, I agree that we don't want to manage the SerDes PHY in situations
> in which the firmware also does it. And that means adding and extra
> check in the driver so that the SerDes PHY is setup only in BACKPLANE
> mode.
> 
>> 
>> > This is why I am ok with only extending the condition from
>> > dpaa2_mac_connect() with an additional check but not the exact patch
>> > that you sent.
>> 
>> AIUI the condition there is correct because Linux controls the PCS in
>> both PHY and BACKPLANE modes (although the RGMII check is a bit
>> strange).
>> 
> 
> I am not sure if we talk about the same check.

Ah, sorry. I was referring to the check for dpaa2_pcs_create.

> I was referring to this check which has nothing to do with the PCS
> (which is why I don't understand why you mentioned it).
> 
> 	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
> 	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
> 	    is_of_node(dpmac_node)) {
> 		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);

Say we have DPAA2_MAC_FEATURE_PROTOCOL_CHANGE and DPMAC_LINK_TYPE_PHY.
Then this clause will be taken, even though we are not manging the phy.

> Also, why is the RGMII check strange? RGMII does not use a SerDes PHY.

The RGMII check for the PCS should be in place for both PHY and BACKPLANE.

--Sean
