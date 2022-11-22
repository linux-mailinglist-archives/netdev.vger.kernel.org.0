Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D158F6340F0
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbiKVQKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiKVQKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:10:23 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2060.outbound.protection.outlook.com [40.107.103.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2162772998
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:10:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEhbSI70URgjL48Mt0byF5EWHjZ0jH+RmtGqUC3KuBQ0XyQ91t3IDPtFfEKvct6NGTznAr9mNYQjqOn3W/KKcEdipl1tCpsbla4YfuVfCJt9in0Nf7gEP3SNQWBSqXrZzzabbR3oNAU0Le9NZPrT3Cesg44/ZOFOkmBQnLnGh/uIiqeEN8yIifiwpY/VufgAxwioz5BehWxlOQS8leliGAHFeAOTZkX9YoAf3j4Wyi0mGCtbayLJi9tBrepr34L9Yb1KBvB0P9bJbbRfTWSqmVtKyWECilxXBYVVBWVem9a4KK/8gnJi9i0XqixgGfKFAZVlkely/CgwJN1VePbvAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKtvUMy3xWvxfzPBSBERS8ToWGxBs4PC7vQZvsxayTs=;
 b=fmzKW90bzLa/bApOCORuasIpFEknA3rmrMXNyekrCHD1VGibKz2msBHHmqpFOQgeRJ41Z6Com1AfNXSqUOlsFbYqcjxQxeVMsjeLOUOiRRG+1Ljl2wedAOCBfDYPHHovDSzygkyH5hQ+8Y49e3Zstl3U8WwsDywG1/PcdYTWTd5qnRDE5IC03Qpl161SJI7LiwnOzsuLYaao2/+3Dkb7wzGL9/l6BK0DdwmgyOplMAnY/62Hw9JeJJ3M97A/s6vxKP1qLShOSbCHjsmq5sg29PBkcZva0rL4tbeek5TuAGCCE+GgXjqkQjq85nNnNFU2j8fQkzrD0U5P3/jInBintA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKtvUMy3xWvxfzPBSBERS8ToWGxBs4PC7vQZvsxayTs=;
 b=P8C8RaVm6pVTzB85rxWTAnDhTCneZuCjDHolqto4Vo8guYuoj6Zp19SgJ1tuYqXyqw1O2CJHBEYBGHBdNLW/m3cssRzinaGnb3wq8hzrmQzQ7g8IH0RLsd/uKj2m2uE7FrxHgdLwJ+utHOKHPlmLklWUq+Yj/wqA1UrmQd0Nz9VUUWrLS6DNjtxn/I1qdfqks7HJqYOccO4KZ04vrYs33ALr0id1+nUz1lngmwLcYf26sf+nNFGwB90phqAIO+xUQkY1dnaZqq0mZZEdpXEdhA/9rTfSQHZwfajzDRrbYA65HsK91ArPsq4CFEajqDXhckfYL2+CV6uXiV0zF6Jw0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DB9PR03MB7739.eurprd03.prod.outlook.com (2603:10a6:10:2cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 16:10:14 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 16:10:14 +0000
Message-ID: <522f823f-70d2-d595-1f2b-1ca447c6f288@seco.com>
Date:   Tue, 22 Nov 2022 11:10:03 -0500
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
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221122001700.hilrumuzc5ulkafi@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::29) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DB9PR03MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 72ccec99-4149-4fe3-f938-08dacca40a21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s2n/ecPKU+bz8X0wPvoRw/FAjd+AsJtKpVBPssHrH5nZPBFGi3wBlCcbKTFZByyFG4lNy8nklS9XwzSElsClZKM8tofV2dJ48Mu+ZraeJLEmWwZLGuLblhxgEKCAHDMEVIInhwIT23R6VWLQSNkoWwEyljAbtxuHIA6UjFRHHJ6/oQJg6JuWUJD9jhO0uWagLaj9eVpXO18azGTTpUw+S1x4gnXx9Z03MJRauD5ktK13b1F1+XEnUKM0v0Gjme93XCA3hNm0XwfCRNSIutR5kXY5RzliMoZovUi4uWXBec+lOlUwUSj1r0gb2kwgYbmhHCEcA8MHO0wOBRrIEQoS1+y7ZzC1LglZi5sozDcsKYnnFa+EcNoC/LrPHr0XPlxAi4IC/uPMCcPZNs33fc46orTslPPrSLLG9LXp62444NgKPsVWG4vvjoSlknlGLlusTJwQwPy03K/+kupjcvCFv2pn90x3S/YY5uTWPhIBrVcJeqHci2YqtH1r6aNW6ip4rxyXXdITtm2goFf3eL0dgf6iSDsmKQahNiFU3ZFkcxQTMtf9FQ2u46Vfym8Qey7D5y6rvUAaW/+2snBhLPWvVHDLpwowVdVpRjUKCBNucKl4RKO7xphyZQa141ClaQfdXWrBh3ygqS2S7zTl6/AtyBHdufQV3F54kir8mW70TgfMszUsONxomli8KqeUgeXzHlV/u8YgMMWlICCfDU5PfpEsDAGNx629v3K2mJzCn9iJqIzDvk5raC64GuysV7gnDGWK5gWspd+wOTB2QVdR2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(36756003)(31686004)(38100700002)(66476007)(38350700002)(41300700001)(44832011)(2906002)(31696002)(86362001)(83380400001)(6486002)(316002)(66556008)(66946007)(8676002)(4326008)(6512007)(186003)(26005)(54906003)(7416002)(6916009)(478600001)(8936002)(5660300002)(6506007)(2616005)(52116002)(53546011)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGRBZDVtVmhRajQ4MDI1TFNSTHNReW9rZDV3RlZQOFE0YnZCK1EzRGRRdnAx?=
 =?utf-8?B?aytQTXhBZ3Y2aHhhM3BJWVhmRGZrVXVTOEhlaFlqdDBiQWN3elRRc2ZveGlm?=
 =?utf-8?B?M0dKTTVsR0dkUG85dXlONHdUOXhrY2t2ampTVy9wSTVTcFFCdkU2bFBwTVlM?=
 =?utf-8?B?bWNpUWluTnE1aFgvYXlQOEl6M0tZQjZSVlVMaGNFTzJiZE5iS3BHbWRRRDNL?=
 =?utf-8?B?TjZLVmpkMmNUY0g0Rm1ldFdqamFLejJUaytyZWo0TTBMNmhvVVRSSzd5NkxS?=
 =?utf-8?B?Nk8rd3hEUk1zR096ZGZaS1lGQjhqVHRGa25VamRPbE84N3VFRlVnNmE1WEZl?=
 =?utf-8?B?YjgwSmxiZ2hQdFZneXdaYUcrMWNKSFJoZmhXa3FHQWtpZ1JqQ0plUmVHYzlk?=
 =?utf-8?B?Qkk0YU9ZY3gwd0kycmR5NHZRampWbTBRVnhsR2NFZlI3V0pwY0t4elpVN1Bx?=
 =?utf-8?B?UUkvRlhBTVErZHZXL3daTUp4ZXBUZm82YjdlTjNONGlZczJ6T1lETW1vYW1Z?=
 =?utf-8?B?cXFOQmFhbUNDajkyWnZXZ0gwaUcyT084a2lRT1ROV0tKdEFXaSt4UjdOSEhO?=
 =?utf-8?B?dXhWd2taZXAwankxeC9JWkQ3R2dzWG0ranZ4blBIckNVdmh1OCtLS2h0ZWRL?=
 =?utf-8?B?UzdCMXpaQ1pXVGtvRnRMR092OG1GdVBma2tZQTVnOFE1b3cwNHFLOHZFSkJP?=
 =?utf-8?B?aTBaSFJYT0FDV3NzOERTUVFlaVVabEsyVThZVXFrV1JLcHBWYVpacEV2SkFp?=
 =?utf-8?B?V2w4V0FEV0xxK0xVMXJ6N1gzVDh4YzhIWFlDVllPTDBBWUVHa0hHeGIrUUFk?=
 =?utf-8?B?cHhaMXR5Yk5CdkFUcEhMNXpPd0hxcjYvZGI1SkIvODNwSDBzaGJFa08veTlv?=
 =?utf-8?B?b0NPYms0R0VHSE4yM1pscXpmQTFCOGxSUzlMdmw0M2RnRWIyQkVvc2twV0FC?=
 =?utf-8?B?NVpOcEZPWWdTZThOK2RCNkhLOEZ1bGhucUkyZnE5UFQ0VFhkaEQ1WlJtbWZv?=
 =?utf-8?B?MXJIN2dBQ09Ic1d5b2NEMTB2c1hEVzFNb3FiL05VMUoyUHZlZUlZREw5OUU0?=
 =?utf-8?B?N2NNQTczbGlqd1FwSTNZcUM5ODJ4RVVHSzJ5NFFrak5PMGdTL1BUN2dDYm8w?=
 =?utf-8?B?NnZWU2V1TkdQUXpCSXFLMmFFNEd4WFB3bUE5aHNTWmw1TFBHYWlnUWp3ZHI0?=
 =?utf-8?B?MEYzWENBYndjQTF5NW00QkhXT2Nlc2dwbW1KT3l1aHpHUXByc2lDOFpySVVD?=
 =?utf-8?B?YzlTRmhrOElBWG1JVFIwcy9mdnczQzJZZm1zaGIyNGtHQm5VamVzOXhxY1ZR?=
 =?utf-8?B?NCtsWnFTNGFPM2FJdStqVkVsZy80aFBEb1gycExzby9FUFlveStWTmN0QlVU?=
 =?utf-8?B?Sk8xSG91c3F5NmFzbjhBbERxWDB0UUxpc0hLYmhERklqUk5NOURwTFc5VUFW?=
 =?utf-8?B?bjA3RkVKdGZaMmtUblU1VHJ1SEdrRWlVTjVBbVVITCtOOHZQU3Q3djMwOFBo?=
 =?utf-8?B?WHNCZzhITUVINi9vNkExYkY1WXREUVBuUGtJVFlDN2VuajdYeXVSQ1hLVTY1?=
 =?utf-8?B?dllEUXoydFZMQVgvUk1RWTZNcERtRmpCWkF6K0c5cmNSTXkrNlpiZkt3SnJm?=
 =?utf-8?B?M0ovUHA5am1TOG15NjQwdzhzT2tOcTVGUjNHSmExT2pUSGtiKzlNSDB0L0Fr?=
 =?utf-8?B?MGZKWk1KSXE2Z1BmU2VqZFBabHh5bFllOFRzNXNJTHBUaXhQZ1cwMUpZM1Jo?=
 =?utf-8?B?UXRmSnV6aVFQZWhsWk9xMGxLdWt5c0lVZ29yVE9LWXMyeFl6cmV4dnpqSnVX?=
 =?utf-8?B?OWNkNnpRWGtMMitjM3dhLzloc2Z1Z1VHUTZDVEN4V1YvTjBTK3pBL2ZFbXdZ?=
 =?utf-8?B?Z29uQmVDeCtkSjNENHJ0a0U4dVZCYThlbnB6RUZETGQ2R1pZZ2hJR0trOS9S?=
 =?utf-8?B?dnFDNnk1M0I3amVwaGk0dzFkaHI0bXRlWmpuWE1DTTFQeE90Si9BWVN2TGdH?=
 =?utf-8?B?TmJIZFlCWFo3N3M1ait4cTkveGhKZmhpT1lYTGEvcnlVSDlyMkZIRVZnNkor?=
 =?utf-8?B?dmJlNUhLV0dYZStldGZnclg3UEdSdWp6UjdrMWFWU2tRQm5GdGdrZWtLSUFF?=
 =?utf-8?B?R0ZPRFZGVGs4aUlnRUhDckpnSUwycWdBeDAzYVQvdkpVMGtGTFBWZEp6Z0Jw?=
 =?utf-8?B?cGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ccec99-4149-4fe3-f938-08dacca40a21
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 16:10:14.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtpGrKS6+8LSq1Bzfbwyu1dl6V0MQsp7ndafo7oLyCecFwEup5I/v5i0N1HxU0KYIwgeJCUmR6GbGC40cbUuoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 19:17, Vladimir Oltean wrote:
> On Mon, Nov 21, 2022 at 05:42:44PM -0500, Sean Anderson wrote:
>> Are you certain this is the cause of the issue? It's also possible that
>> there is some errata for the PCS which is causing the issue. I have
>> gotten no review/feedback from NXP regarding the phylink conversion
>> (aside from acks for the cleanups).
> 
> Erratum which does what out of the ordinary? Your description of the
> hardware failure seems consistent with the most plausible explanation
> that doesn't involve any bugs.

Well, I don't have a setup which doesn't require in-band AN, so I can't
say one way or the other where the problem lies. To me, the Lynx PCS is
just as opaque as the phy.

> If you enable C37/SGMII AN in the PCS (of the PHY or of the MAC) and AN
> does not complete (because it's not enabled on the other end), that
> system side of the link remains down. Which you don't see when you
> operate in MLO_AN_PHY mode, because phylink only considers the PCS link
> state in MLO_AN_INBAND mode. So this is why you see the link as up but
> it doesn't work.

Actually, I checked the PCS manually in phy mode, and the link was up.
I expected it to be down, so this was a bit surprising to me.

> To confirm whether I'm right or wrong, there's a separate SERDES
> Interrupt Status Register at page 0xde1 offset 0x12, whose bit 4 is
> "SERDES link status change" and bit 0 is "SERDES auto-negotiation error".
> These bits should both be set when you double-read them (regardless of
> IRQ enable I think) when your link is down with MLO_AN_PHY, but should
> be cleared with MLO_AN_INBAND.

This register is always 0s for me...

>> This is used for SGMII to RGMII bridge mode (figure 4). It doesn't seem
>> to contain useful information for UTP mode (figure 1).
> 
> So it would seem. It was a hasty read last time, sorry. Re-reading, the
> field says that when it's set, the SGMII code word being transmitted is
> "selected by the register" SGMII ANAR. And in the SGMII ANLPAR, you can
> see what the MAC said.

... possibly because of this.

That said, ANLPAR is 0x4001 (all reserved bits) when we use in-band:

[    8.191146] RTL8211F Gigabit Ethernet 0x0000000001afc000:04: INER=0000 INSR=0000 ANARSEL=0000 ANAR=0050 ANLPAR=4001

but all zeros without:

[   11.263245] RTL8211F Gigabit Ethernet 0x0000000001afc000:04: INER=0000 INSR=0000 ANARSEL=0000 ANAR=0050 ANLPAR=0000

It's all 1s when using RGMII. These bits are reserved, so it's not that
interesting, but maybe these registers are not as useless as they seem.

> Of course, it doesn't say what happens when the bit for software-driven
> SGMII autoneg is *not* set, if the process can be at all bypassed.
> I suppose now that it can't, otherwise the ANLPAR register could also be
> writable over MDIO, they would have likely reused at least partly the
> same mechanisms.
> 
>> > +	ret = phy_read_paged(phydev, 0xd08, RTL8211FS_SGMII_ANARSEL);
>> 
>> That said, you have to use the "Indirect access method" to access this
>> register (per section 8.5). This is something like
>> 
>> #define RTL8211F_IAAR				0x1b
>> #define RTL8211F_IADR				0x1c
>> 
>> #define RTL8211F_IAAR_PAGE			GENMASK(15, 4)
>> #define RTL8211F_IAAR_REG			GENMASK(3, 1)
>> #define INDIRECT_ADDRESS(page, reg) \
>> 	(FIELD_PREP(RTL8211F_IAAR_PAGE, page) | \
>> 	 FIELD_PREP(RTL8211F_IAAR_REG, reg - 16))
>> 
>> 	ret = phy_write_paged(phydev, 0xa43, RTL8211F_IAAR,
>> 			      INDIRECT_ADDRESS(0xd08, RTL8211FS_SGMII_ANARSEL));
>> 	if (ret < 0)
>> 		return ret;
>> 
>> 	ret = phy_read_paged(phydev, 0xa43, RTL8211F_IADR);
>> 	if (ret < 0)
>> 		return ret;
>> 
>> I dumped the rest of the serdes registers using this method, but I
>> didn't see anything interesting (all defaults).
> 
> I'm _really_ not sure where you got the "Indirect access method" via
> registers 0x1b/0x1c from.

Huh. Looks like this is a second case of differing datasheets. Mine is
revision 1.8 dated 2021-04-21. The documentation for indirect access was
added in revision 1.7 dated 2020-07-08. Although it seems like the
SERDES registers were also added in this revision, so maybe you just
missed this section?

> My datasheet for RTL8211FS doesn't show
> offsets 0x1b and 0x1c in page 0xa43.

Neither does mine. These registers are only documented by reference from
section 8.5. They also aren't named, so the above defines are my own
coinage.

> Additionally, I cross-checked with
> other registers that are accessed by the driver (like the Interrupt
> Enable Register), and the driver access procedure -
> phy_write_paged(phydev, 0xa42, RTL821x_INER, val) - seems to be pretty
> much in line with what my datasheet shows.

| The SERDES related registers should be read and written through indirect
| access method. The registers include Page 0xdc0 to Page 0xdcf and Page
| 0xde0 to Page 0xdf0.

Each register accessed this way also has

| Note: This register requires indirect access.

below the register table.

>> I think it would be better to just return PHY_AN_INBAND_ON when using
>> SGMII.
> 
> Well, of course hardcoding PHY_AN_INBAND_ON in the driver is on the
> table, if it isn't possible to alter this setting to the best of our
> knowledge (or if it's implausible that someone modified it). And this
> seems more and more like the case.

I meant something like

	if (interface == PHY_INTERFACE_MODE_SGMII)
		return PHY_AN_INBAND_ON;

	return PHY_AN_INBAND_UNKNOWN;

Although for RGMII, in-band status is (per MIICR2):

- Enabled by default
- Disablable
- Optional

So maybe we should do (PHY_AN_INBAND_ON | PHY_AN_INBAND_OFF) in that
case. That said, RGMII in-band is not supported by phylink (yet).

--Sean
