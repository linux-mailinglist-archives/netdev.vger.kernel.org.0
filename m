Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822BB6341CB
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbiKVQps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiKVQpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:45:47 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60076.outbound.protection.outlook.com [40.107.6.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EC54733F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:45:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEfqOETp3tKCHHQ2NBGhVRbGf8eiLRfgxzOn4maA7zJcewLJ7eAc+x4npvIANJkfU1Y0/T3X1AGkg31sXSFKJa578Ab1XO9ufXwyMx0NQoCJhevjlwT4hR6h7f9YPiDBnRQoCvZgpIO8A92bBo3vQq1az5qrcJ1GUgKdzrzxiFdQKDNNvWmRyujtUB0xCH/dBNv5GYiP/2QCgQvrJ/t/rWuMMuLoof9ynX1Kincme/yikWDTKELKbnbZjMxD1lV4IFM+mMM4yTLzGZUmKGeASy664CGpWOuXH00KSaj8RsfScNaPCGr7SJiiW6ywJqqcqQqedHAX5CfH1BtCHawiMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZi3i+Q0AB3l5aQqrZG3oO5F5baatxk5/CSoqa17LZo=;
 b=FL/gwoD04n5atdBpfyZ4eYE/7wN8i97rIYOJB5BOwhVqatiX7yUttSW/Gfm3CxvqTIJelG4dWu6THy3DBJuKS0Fs/zIL9QoZYi1RQMmZ1Y2K/pnHQNaXPXweG8+/W5O/IU527rsVUZe2zs+4uxGMuhrRniSFKJT6m3RAAaEymcIgqVFRhxwZ1npew/ebii+oTlLfIH3UQAfgizbcx7U2mec43sjdtVOsUtBAPo3OZeu+63aeYpVMVh24uw5vncg8jhUVrv1muuBaRCxuMxLwp9pWBGHwyjPqPPcS0jlYHDDrs6AFEylPDGgADmmVuYU2bN0KgoQbbdSiVGaYDI1C+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZi3i+Q0AB3l5aQqrZG3oO5F5baatxk5/CSoqa17LZo=;
 b=mSmgTDgqIytqaD6Hj+ruvnJ5RT0SKNjpID8ZNO7MSOm8GTzAS+yjwMnHWT44/sYk23ZyUsdgR228Q005Ev7pXDzPfBGmT8M/NMyq6t+MK5wwENOtm3BcFC6SpSgj3tDFk7gSKo81t7/rDvXxtKQfI5lQsbTCKfGZm5xi4OoM9XKhf7cgK7LzWfp3lWZDMU4od4rYGb0Roy7DHrlAZvqiylOWEPpO+zwX6GvLqy4QNh7FRQewkX45sjxB782fjWnx8Rs7KOkvH/Ju5VD0pAn8pDUnPHCcTLul2yeEBsQLx/4bljPHj5WaWfpqClLybS0JgA2AcMDfpJVrfav6l0poEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PA4PR03MB8200.eurprd03.prod.outlook.com (2603:10a6:102:26d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 16:45:41 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 16:45:41 +0000
Message-ID: <47960d0c-189b-28c8-8337-ee1b202ad144@seco.com>
Date:   Tue, 22 Nov 2022 11:45:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
 <20221121194444.ran2bec6fhfk72lt@skbuf>
 <4bf812ec-f59b-6f64-b1e0-0feb54138bad@seco.com>
 <20221122001700.hilrumuzc5ulkafi@skbuf>
 <522f823f-70d2-d595-1f2b-1ca447c6f288@seco.com>
 <20221122163012.w5gsoawp22lc3nyl@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221122163012.w5gsoawp22lc3nyl@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PA4PR03MB8200:EE_
X-MS-Office365-Filtering-Correlation-Id: 78d794bf-e949-4ace-d2d4-08dacca8fcd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iZ3O5Kml56T7rObJqDSUlahUyz6K/jBFDYAg0eI/I/D+WD3FU233QW1plv31RiWnZKCVeJkAWIaEM3mNbDLGSs3bwjZwqG3Gn2PQxut9L8iqQtVPhrx8KtQxyknTFWQm9mz+QKg4+iX3ZdtaE1VAz9zvfUwRpwXTATPG5RJDdaB2dwuBZP/rDI17ikxM8XdFlD4G/1MD9vpCKKWZ9/hs779zFVQO80YXAmxDvIKUCspUogfgvxMpPfa/nwDM56xh0VwJ4Ac5XRvfadVzKV7z5elYRQEAZcZIiZ/Vu9GiiXSN6Gxt69TCW18rseSwWF5Nv4LKcJodJXMJu7Jsp1ncIKrKjgBC13Qy2NOKCvha6GmLizTRcd99hH5E7EMSEM8LekDRo3BxlTHaoZgAiNlESibwVm0WozML22ZD0qpZu2U1M5aKi6/mXPFua5+KzVAktZrdxPoJ2K2tN2U6YbaRFup5GtPLI3iubpgNur3NUhPxP2c9aKzeCqCdDxmKDolPAZs/fbDMx8FaWHV5NJvJUM89ApSslZAKdY/d4EIpvQGZ+SOApuvIKPYdgvWRX5fgY+pKS+r38wtttCBUhuRCeQAOTltjWwA/EXHdnhj6YhJ8pEYXsvlt/LxUeBevJO7QxfGiSQfSmaZaPl40IXNb0M9lcIGElblKp4pMWW/uuBYiwOsKfku/pTsq/nIBAH5i8EpefoZd7jaDgxdFKOAhfaHJhMYsJC8RYjR93V2EP3uxBYR36qxffu0QBcaLDsj/J+CnCikkS5UYSNjcbNY2gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(39850400004)(366004)(396003)(451199015)(31686004)(36756003)(8676002)(31696002)(38350700002)(2906002)(4326008)(86362001)(8936002)(7416002)(38100700002)(83380400001)(5660300002)(6916009)(316002)(54906003)(2616005)(66556008)(186003)(66946007)(6486002)(66476007)(478600001)(26005)(44832011)(41300700001)(52116002)(6666004)(6512007)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDk2YlRqS2VOdEVaQjVCTGdIZzhKVkdFMnlrZVZXN0dHcXFPMEdqV3YyM3c1?=
 =?utf-8?B?VTRaMFIwNUNqMnByblRMbTJtRlNaa3lib0gxcUhkRkRmN0xHaC9PQStNYXpY?=
 =?utf-8?B?SlluWGJ5NWQxbE5VWlJXejRFUTlORGw2QzFQeFpURUgzMVJIU0Q3ZERhbXE3?=
 =?utf-8?B?Q3JYTktobWlsWE9ONU1rMERocmJvbk1RYWZOdXZDYm1EZFZxRmFUeEFiejFV?=
 =?utf-8?B?MGZPVVpnaGN6c09qSzB6ZGJqUVMrdG11TTJoZWlOR1M4ODBGNlR5WEZoMnV1?=
 =?utf-8?B?cVJKeVBuNnZJVGl3QlRQN2lPYU44TVcrSUl6NytoZGtlem1VNURqTzlrbmhv?=
 =?utf-8?B?eDNqL2s2K0hPdFMwUmxVcGpJeFIxRU5XaVM1SkkzcFEzc3pTdkhpRnkrblBu?=
 =?utf-8?B?ZGdJMlhQbjMxaW9WazRzejIxbFVna1BFZjk1c0FhUG5xTlI5U1Q1S3JRSnZC?=
 =?utf-8?B?cUNUWTRBMCtWVTlZRENtbCtuSGw2cHFxOWZGSFpNRHA1aEl0dTQyVVdtS2M3?=
 =?utf-8?B?V3ZSQUhOaWd6WGNkc1NUTUdtUDhFRVBHcXltYzV1czJObFZ3V3g5ZndIaVoz?=
 =?utf-8?B?OC8xYWVNQnhQeVRwOE1FMjUwc3hhMXVQclVHdXJvU0hlT1IvbHhPOGJrN2pr?=
 =?utf-8?B?YVhwNlpDQVJCV1g1OHQvUVBTM1ZJVmtMWXRBMERva0dPVVMrb08xT1hWK2Jx?=
 =?utf-8?B?Y2N4UDAxTlV0WUoreHZmWjRtbTFWTGxObUZGRzZTdUVlOEhZa3pIaC9MMzBr?=
 =?utf-8?B?eFUvTUlQbmlJUUllM3ZJSHM3SURuQ2J5a1RoVDdhdzZNVGRpUjR5a2h5aFc1?=
 =?utf-8?B?T0psWmVMYVF3UVY3MXowYmZLQkx2WTlSRzZNT2ZMZVlLY21uQ1VUNDdNRmpl?=
 =?utf-8?B?ZVJ1YjJXMlRxeHFENE4vK2ZtcmsvVG1MNHRIRGk5VTYrSWdGY2pPOTBGeE1L?=
 =?utf-8?B?NWo0SUhDKzlBbEpURzhNMkZwOHkva1lxMmxvNWtXNWYzRDJOOTdUZE82RXpW?=
 =?utf-8?B?ZWJNSUFLRWRYanRLRTFZWkg2NHR5SklxSEZOMXV5RGptK3RLZDhUMERhT2U1?=
 =?utf-8?B?R1RBc09vTHg0Mm5hbkFUd3RNMms4V0RZVDZRdjRrNy9WVVc1eUIzdzMrdmg1?=
 =?utf-8?B?Q1NOWlNzdlk4WGZsK0lWZ2hKV2dqcGpyZXdWMUcyYkxkV0d2N05WU0NOV1Fn?=
 =?utf-8?B?dlBkTndoV2F5Ly9reitaVlFHeUlZNnBHQVlUbFpRQmc1RG9lVFVtK2xrQlFM?=
 =?utf-8?B?T3RiQXZodnQxZDd4Y3hibDhvdm5GQno3N1grRmZ0NTB6T3Z4RWNDem9Yam05?=
 =?utf-8?B?RHk3dkp5R2pqbzhxS2JJOUVZVTR5ZkxWaGFqaGM0WkRjV2laek8zOHFpbXVY?=
 =?utf-8?B?RmczWXNSamJpZzJldlNwOFdkU2RUMUVEUGZxN2xCMkVlTmsxWDdVeUh1WjBs?=
 =?utf-8?B?cUZZNmUwZDB5ZEREKzFOMkhYWWpxU0pQck1hZmFxVzdTUnV5T25pZmFJZWJJ?=
 =?utf-8?B?d3VVL2tYc3BHdGtIWmNJWGFvemhXOTVpVnlDNTNRQUxQYnQ5SU45THp6QVdw?=
 =?utf-8?B?RjZWM1dNbFhOV0JsNkFISGRoT2RzaUZnT3RELzNJZ2lBck0xQzRWVUZLQkpk?=
 =?utf-8?B?RXE4aSt3NW91b0V2UDBtckhML2pOS1lDWFBqbmdmYkdxRnFtcWxmSWhFUm5n?=
 =?utf-8?B?VGlCUWxVVGJCV09WeVdHeDZranZ3eHBQMmdITUhMTEdGNnBxQU1aSFZ3NkY2?=
 =?utf-8?B?ZjlGUWFuVjBzcWI2bGFNL2s3OWkxTFpYUUtTRVBaUVZuL1JmeDNFZUh3dHpH?=
 =?utf-8?B?U01ocW1Rc0NDSExSNnBFQzVYMExzdDc0Sjk5QVA4RnUxeDhKYmg2aVRxZ2pi?=
 =?utf-8?B?Q0VOUlRSeTkrdWk3VkNDcW1UNUwyTjZZZldmT0txMjhUcmp4cmUvRDUzVm1C?=
 =?utf-8?B?YXEyWlBsRlozYWdxU0RFelp1TlBHcjRGVk1PVTlxRitjcXQxdVN1d0gvTEI4?=
 =?utf-8?B?WFJuWDVEWXUwY01xRVRkZU0vTTk1M0d2WEh2RTBNUTgzcDE2SHJIT2RuY0hr?=
 =?utf-8?B?VjAzYUd2SW9hOUkybVF6TDNqSDh3ZDI5Q2JSQm40YlpBNkgzaDdxZloyQnpm?=
 =?utf-8?B?cFZvQitpVm8xb3NZT2Zia3JobjBVWXc4YmxjZW50dS9iVjl5emNLMldIcXJP?=
 =?utf-8?B?OEE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d794bf-e949-4ace-d2d4-08dacca8fcd3
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 16:45:41.4658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNU79xKnXVcEGUKisndEEIYYVdo4nHxtk7NHYV+sOvv22FcbImbqDi2oPBDWiqSY0HtiNJhg8wPVcWobCNPGmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB8200
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/22 11:30, Vladimir Oltean wrote:
> On Tue, Nov 22, 2022 at 11:10:03AM -0500, Sean Anderson wrote:
>> On 11/21/22 19:17, Vladimir Oltean wrote:
>> > On Mon, Nov 21, 2022 at 05:42:44PM -0500, Sean Anderson wrote:
>> >> Are you certain this is the cause of the issue? It's also possible that
>> >> there is some errata for the PCS which is causing the issue. I have
>> >> gotten no review/feedback from NXP regarding the phylink conversion
>> >> (aside from acks for the cleanups).
>> > 
>> > Erratum which does what out of the ordinary? Your description of the
>> > hardware failure seems consistent with the most plausible explanation
>> > that doesn't involve any bugs.
>> 
>> Well, I don't have a setup which doesn't require in-band AN, so I can't
>> say one way or the other where the problem lies. To me, the Lynx PCS is
>> just as opaque as the phy.
> 
> ok.
> 
>> > If you enable C37/SGMII AN in the PCS (of the PHY or of the MAC) and AN
>> > does not complete (because it's not enabled on the other end), that
>> > system side of the link remains down. Which you don't see when you
>> > operate in MLO_AN_PHY mode, because phylink only considers the PCS link
>> > state in MLO_AN_INBAND mode. So this is why you see the link as up but
>> > it doesn't work.
>> 
>> Actually, I checked the PCS manually in phy mode, and the link was up.
>> I expected it to be down, so this was a bit surprising to me.
> 
> Well, if autoneg is disabled in the Lynx PCS (which it is in MLO_AN_PHY),
> then the link should come up right away, as long as it can lock on some
> symbols IIRC. It's a different story for the PHY PCS if autoneg is
> enabled there. Still nothing surprising here, really.
> 
>> > To confirm whether I'm right or wrong, there's a separate SERDES
>> > Interrupt Status Register at page 0xde1 offset 0x12, whose bit 4 is
>> > "SERDES link status change" and bit 0 is "SERDES auto-negotiation error".
>> > These bits should both be set when you double-read them (regardless of
>> > IRQ enable I think) when your link is down with MLO_AN_PHY, but should
>> > be cleared with MLO_AN_INBAND.
>> 
>> This register is always 0s for me...
>> 
>> >> This is used for SGMII to RGMII bridge mode (figure 4). It doesn't seem
>> >> to contain useful information for UTP mode (figure 1).
>> > 
>> > So it would seem. It was a hasty read last time, sorry. Re-reading, the
>> > field says that when it's set, the SGMII code word being transmitted is
>> > "selected by the register" SGMII ANAR. And in the SGMII ANLPAR, you can
>> > see what the MAC said.
>> 
>> ... possibly because of this.
>> 
>> That said, ANLPAR is 0x4001 (all reserved bits) when we use in-band:
>> 
>> [    8.191146] RTL8211F Gigabit Ethernet 0x0000000001afc000:04: INER=0000 INSR=0000 ANARSEL=0000 ANAR=0050 ANLPAR=4001
>> 
>> but all zeros without:
>> 
>> [   11.263245] RTL8211F Gigabit Ethernet 0x0000000001afc000:04: INER=0000 INSR=0000 ANARSEL=0000 ANAR=0050 ANLPAR=0000
> 
> So enabling in-band autoneg in the Lynx PCS does what you'd expect it to do.
> I don't know why you don't get a "SERDES auto-negotiation error" bit in
> the interrupt status register. Maybe you need to first enable it in the
> interrupt enable register?! Who knows. Not sure how far it's worth
> diving into this.
> 
>> It's all 1s when using RGMII. These bits are reserved, so it's not that
>> interesting, but maybe these registers are not as useless as they seem.
> 
> Yeah, with RGMII I don't know if the PHY responds to the SERDES registers
> over MDIO. All ones may mean the MDIO bus pull-ups.
> 
>> > Of course, it doesn't say what happens when the bit for software-driven
>> > SGMII autoneg is *not* set, if the process can be at all bypassed.
>> > I suppose now that it can't, otherwise the ANLPAR register could also be
>> > writable over MDIO, they would have likely reused at least partly the
>> > same mechanisms.
>> > 
>> >> > +	ret = phy_read_paged(phydev, 0xd08, RTL8211FS_SGMII_ANARSEL);
>> >> 
>> >> That said, you have to use the "Indirect access method" to access this
>> >> register (per section 8.5). This is something like
>> >> 
>> >> #define RTL8211F_IAAR				0x1b
>> >> #define RTL8211F_IADR				0x1c
>> >> 
>> >> #define RTL8211F_IAAR_PAGE			GENMASK(15, 4)
>> >> #define RTL8211F_IAAR_REG			GENMASK(3, 1)
>> >> #define INDIRECT_ADDRESS(page, reg) \
>> >> 	(FIELD_PREP(RTL8211F_IAAR_PAGE, page) | \
>> >> 	 FIELD_PREP(RTL8211F_IAAR_REG, reg - 16))
>> >> 
>> >> 	ret = phy_write_paged(phydev, 0xa43, RTL8211F_IAAR,
>> >> 			      INDIRECT_ADDRESS(0xd08, RTL8211FS_SGMII_ANARSEL));
>> >> 	if (ret < 0)
>> >> 		return ret;
>> >> 
>> >> 	ret = phy_read_paged(phydev, 0xa43, RTL8211F_IADR);
>> >> 	if (ret < 0)
>> >> 		return ret;
>> >> 
>> >> I dumped the rest of the serdes registers using this method, but I
>> >> didn't see anything interesting (all defaults).
>> > 
>> > I'm _really_ not sure where you got the "Indirect access method" via
>> > registers 0x1b/0x1c from.
>> 
>> Huh. Looks like this is a second case of differing datasheets. Mine is
>> revision 1.8 dated 2021-04-21. The documentation for indirect access was
>> added in revision 1.7 dated 2020-07-08. Although it seems like the
>> SERDES registers were also added in this revision, so maybe you just
>> missed this section?
> 
> I have Rev. 1.2. dated July 2014. Either that, or I'm holding the book
> upside down...

Looks like 1.7 just added SERDES ANSCR and SERDES SSR. So I suppose the
other registers were documented earlier, without the not about indirect
access.

>> > My datasheet for RTL8211FS doesn't show
>> > offsets 0x1b and 0x1c in page 0xa43.
>> 
>> Neither does mine. These registers are only documented by reference from
>> section 8.5. They also aren't named, so the above defines are my own
>> coinage.
>> 
>> > Additionally, I cross-checked with
>> > other registers that are accessed by the driver (like the Interrupt
>> > Enable Register), and the driver access procedure -
>> > phy_write_paged(phydev, 0xa42, RTL821x_INER, val) - seems to be pretty
>> > much in line with what my datasheet shows.
>> 
>> | The SERDES related registers should be read and written through indirect
>> | access method. The registers include Page 0xdc0 to Page 0xdcf and Page
>> | 0xde0 to Page 0xdf0.
>> 
>> Each register accessed this way also has
>> 
>> | Note: This register requires indirect access.
>> 
>> below the register table.
> 
> Ok, possible. And none of the registers accessed by Linux using
> phy_read_paged() / phy_write_paged() have the "indirect access" note?

Correct.

> Maybe it was a documentation update as you say, which I don't have.

Looks like it. Probably to work around some bug.

>> >> I think it would be better to just return PHY_AN_INBAND_ON when using
>> >> SGMII.
>> > 
>> > Well, of course hardcoding PHY_AN_INBAND_ON in the driver is on the
>> > table, if it isn't possible to alter this setting to the best of our
>> > knowledge (or if it's implausible that someone modified it). And this
>> > seems more and more like the case.
>> 
>> I meant something like
>> 
>> 	if (interface == PHY_INTERFACE_MODE_SGMII)
>> 		return PHY_AN_INBAND_ON;
>> 
>> 	return PHY_AN_INBAND_UNKNOWN;
> 
> Absolutely, I understood the first time. So you confirm that such a
> change makes your Lynx PCS promote to MLO_AN_INBAND, which makes the
> RTL8211FS work, right?

Correct.

>> Although for RGMII, in-band status is (per MIICR2):
>> 
>> - Enabled by default
>> - Disablable
>> - Optional
>> 
>> So maybe we should do (PHY_AN_INBAND_ON | PHY_AN_INBAND_OFF) in that
>> case. That said, RGMII in-band is not supported by phylink (yet).
> 
> Well, it kinda is. I even said this in one of the commit messages
> 
> |    net: phy: at803x: validate in-band autoneg for AT8031/AT8033
> |
> |    These PHYs also support RGMII, and for that mode, we report that in-band
> |    AN is unknown, which means that phylink will not change the mode from
> |    the device tree. Since commit d73ffc08824d ("net: phylink: allow
> |    RGMII/RTBI in-band status"), RGMII in-band status is a thing, and I
> |    don't want to meddle with that unless I have a reason for it.
> 
> Although I'd be much more comfortable for now if we could concentrate on
> SERDES protocols. I'm not exactly sure what are the hardware state machines
> and responsible standards for RGMII in-band status, what will happen on
> settings mismatch (I know that NXP MACs fail to link up if we enable the
> feature but we attach a switch and not a PHY to RGMII - see c76a97218dcb
> ("net: enetc: force the RGMII speed and duplex instead of operating in
> inband mode") - but not much more). Essentially I don't know enough
> right now to even attempt to make any generalizations. Although I suppose
> a discussion could be started about it.

I think deferring this is the right thing to do. It's not clear to me if 
in-band RGMII is even necessary (as all hardware I've seen includes MDIO).

--Sean
