Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FB662FC1E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241826AbiKRSCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbiKRSBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:01:47 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on0617.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8555E70180;
        Fri, 18 Nov 2022 10:01:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erWIkJcJdXENT0G3bg6OxoY9hQP9ZUOuW6rka0rHtkaUTPdgNbbMVDaTbITwXRIDdmE1f4xzN8sx5XriW523Ssk1hrHXWYYnC0+Z6nQVrTOJTmpaCL+mVHMZkne6pE0F/ixb8ylv4rY9wRJifpeBw4rwp7jbPOSR5C1I9QXGLmRfI0HzD18NP/fRrJGSJasuzjTJdLMBpcjne2/9Tp17m/X5HOwUlsBK8i/9fxsf/bcI4xcS3jKGH88ii8dYM3k0U5RdQsRc91spPQtB97VWns4i0AWISKhrcr48QTcexhD6kA3DvkYTRmgStEErI2t093THCawk/F/e17TJ8d/Bnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sveHET0skTNEmErl38IPDiFmF+Pamojy2Y8u1OWLQM=;
 b=UTQ1qRmmrDdD2huwRYjrWStHJFnOslzsI0x9Gk7TBBUrSyzjoLqnygRvifOk5tvGrvbLzDVT2a7eodurzijF7Q9yNlFQOMN60BSO9SLs2iHJfa3Sb3HDSVc4OvISCzjEra+lgTqNGFG2/CddFCHirDJFdxlibK4fIM0ZHUIz1MJDwgugixTiS1fny+IsTDuwClJssS4TiI07oohQZalSG97EjcivTNFbNgBxWxwfkEpP46v/KYAs0GOuH7ZWihwfmQTg17/d8r869cBFLb20B1QWe7BnbUPyFp06yo8URpcRlPd9jn2TlPEB85vUyyhr2puhH98h22LdHxB3iFIzXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sveHET0skTNEmErl38IPDiFmF+Pamojy2Y8u1OWLQM=;
 b=TAO9wgUxu0HG4VRu/F25dAIUEIWJmpyhtLphShUubWWQ6dCbyW5w4ojodh9peqWcrK7S15OIiVfmjc4AvhwIgUtUk3OJMfX+43Bgbv94l/G0uOQSMA6y11icmOCKDN9WHY4bWzBjZpanmp5r2K5V0F1enkZgza1Exk5yDUuMydtKzzn9YPZPerUHAtrHG7LB9nvkqApnvmBD4dqC8LZIc1q1sv1XUG8H9pjsNxVoWXW0FT/ulmJ7C4JaABTSgHrUTKQxB4a48aQxUWqwSjFDMsBktBxaCrZxLatydw/JfFmTO5l3Rmp7CZN+FtCZvDyeOCeivL4BiKaQjjv8PGrbQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB9439.eurprd03.prod.outlook.com (2603:10a6:20b:5a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 18:01:41 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 18:01:41 +0000
Message-ID: <aaa87b05-d740-4a59-d47d-6b0b350469c7@seco.com>
Date:   Fri, 18 Nov 2022 13:01:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf>
 <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
 <20221118164914.6k3gofemf5tu2gfn@skbuf>
 <1015dfec-542d-8222-6c4e-0cf9d5ee7e5a@seco.com>
 <20221118173014.4i7fccrgcqr6dkp4@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221118173014.4i7fccrgcqr6dkp4@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0040.namprd19.prod.outlook.com
 (2603:10b6:208:19b::17) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB9439:EE_
X-MS-Office365-Filtering-Correlation-Id: b4a33b3f-72ff-4930-91a6-08dac98ef170
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKBmOCDPnvkp7z7XNb5bwDRYsne3AfC/2oQe4BD4rpNBrRSgRoTOMDxV/QckYnz5npPZdxfppBZDtf8mLjOpCl6BOaix2XCaFpU7QKPUj9nb06vZYADIDQPL58WLHnKAdYeizi4wG3YmVv4EWvy0Vkuubk4i6sDIDviZYsuVRFVWCHVO7ureNH2PI2kSE0/z01jfu2EF5TaQAWxfS8p3qCdmEOaXcxmv85Hbgn8QZB+NS7y8bwdWYSXpDyjkdrhUr/QSrGqTvWsJ9a8nTek1i+dTfiOwAmeiMQ/f9baWnStKTZL577maWuk8O7Y0DDh8/RwNlIBvrWnwXdNookuSktjX/TyWJfOTmG76XcZ7NKzXXp4ZCYenbkk0us3mTQrU3+L021tlTNUsJcXy+/rE3tMnzJyslV9wLTArIM1OkSJmRNoqaNvDAE3way8YgdFODYHJWTNZ6U6sMr0Tv8xJOnvABdn6Iwq78Ya7IOxc2UHc/pdOpzmF6lypLNZWwbWnXurJZeeekLw91OhckDdK8XkhbGEAcd/Z/PZEwS/0f3uXGD30qA62O37zkKyYs/3fbdcEia3X+lC0nD63fGt4xtQ10Ssvzacoe5SKZew+Zt3wp+wDiV5Mz6prp/jUOKFLvrrRzWRFESzCiLNSV92ZdEvk5bHOSJFiS312d7zOOjMuTYhzVT5QJZVctLFQcBgPpouGDjRFpoPrla4M5YepNBzdgjBz2dEsngy3M6f1nJd15xljzm1J8pLi8ypEZLcUBjdz8Z1gRR2ReQ5khB7/edIjqGEyELNx3CWQAFM1ois=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39850400004)(366004)(451199015)(83380400001)(66946007)(38100700002)(86362001)(31696002)(38350700002)(66556008)(8936002)(4326008)(7416002)(2906002)(2616005)(44832011)(8676002)(66476007)(41300700001)(5660300002)(6506007)(52116002)(26005)(6666004)(53546011)(6512007)(186003)(966005)(478600001)(54906003)(6916009)(316002)(36756003)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejdJNDFSQmhab2I4eXFrdUFLSFlaeE5mUGtLNjQ2OWtLUWpHdmhXQnd5OG1k?=
 =?utf-8?B?UWo4cXVMbEdhd09xRm5LV2phLzQ0MG05dWZHMFl5WWxaZG5ONmxlZjFUWWRY?=
 =?utf-8?B?VE1hTXZCSktJOVYybE5jL3NxV1BrY2V4aVBUangvYXlrSENyYmFkc2Qya05v?=
 =?utf-8?B?WGJudnhXN3BDZlZZRGhPdzFBZk1YVFBTSUtSd3U3Q3pDZnFhaHZka2huaDRO?=
 =?utf-8?B?eFd3c2lMbFczeTkwcnAzUHQwS3lRblQzOWhqMVdNNE5RVHN6NTdRQ1RQLzFm?=
 =?utf-8?B?WE5KQmhvMVNaRkVycGZkU0lua21YU1Q5TDhYdmRFQkNMNkFLdE5hQk1xR2hl?=
 =?utf-8?B?enNlRS91VzUyK282WGUxY2svZ2NhbXlKbmZGblFXa1pJMGc4V3RRYTUzcGJI?=
 =?utf-8?B?bGJKSUFJL0FzN3BzNVNWVXN4MlgvTDlWQ3hiTFJWcktMb2dtZ01mbURZWVc3?=
 =?utf-8?B?c0tTWUIweGg2RDlpYlhSdG9KSnNwc0xmd2tzeEZ5a2toUXAwQlpzM3AvbVVT?=
 =?utf-8?B?NnpoVnVQamNJKzRkTTBla1JqUHhLLzVPQzFSRXk1eW9oU094U1lhV3hNVWs0?=
 =?utf-8?B?WktnL3VKTmhLRzJnV2w4T1FJZ0NEcnhVV3U0bGtmQjRyK0QvRXMwdW9ud25D?=
 =?utf-8?B?YXdCOFVDcEdwWnBwaWgxcWM5ekpuRGUwMmNENzBuQVdXQjBFY2lZVUNxZ3Bi?=
 =?utf-8?B?cVpuOVdYWnNTL1hiVlAzdTdTVlpGaXZWQy9CUng4SjdiRlRGSFlIbmpTZks5?=
 =?utf-8?B?L3ZYSTF0ZnB2UnJkazNWWkdIQ2ZsRGxTUVR0Zk1vODFIb0JkaFNDOUhOWVlL?=
 =?utf-8?B?cUJNU3puUjlhZDl2eFd4cG1vd3Vza2FzODl1NnNjb2FxWkU1S3lWd3ZDcmY1?=
 =?utf-8?B?RDE3NWJsc2FDUDZ2SmJxUHQ4RXo5L0RiSldXVlFtZUdSSWpSbVFDbjRTbnJs?=
 =?utf-8?B?eTVKck1Pei9sb2ZLcDFlcVBNN2FER2VRUkFDTTRBNnVWdVd2YTRndklqQXox?=
 =?utf-8?B?RG5pRXV5VS9qdlphU25JOHNUeFl3U2hnTkIwakVPMXl5V29RakM5b3ZXV05S?=
 =?utf-8?B?VHhYcUo3T2FSYXZWY1luT3V6M1MxU1FvK3poOTlNVFFtNE1BdkZBSmRLR3NQ?=
 =?utf-8?B?TUtRTkRobTU1OHYza1dWMytsbG80K1V0NTJtTDY4ZmFyU2NkbngxeGdBNXFl?=
 =?utf-8?B?Y3UxNFpweThZd0w2eTZFT29kTkxzKzQ3YWZab1h1bEMzK0tFS3dkSzVTOTB6?=
 =?utf-8?B?RUhVNG5ieGEvbm1yaXJ4OTNhRmNZSldubGlLamJ2YkNQK3dvL1NNT0R0UlFv?=
 =?utf-8?B?UlR2RCtBT1c1ajN4MFExY2R5Rmlua0l6Rmh4Z0xrSDFwRVpJZTFDZ0FDandG?=
 =?utf-8?B?TFlKeTliR1lNb0RnVExjRjhsRGJjK09LVGZvV1VJcGlxRnRBUFkxQ1JhUEFw?=
 =?utf-8?B?TDFCUjMzTU1WVWpaakJ4RVNIR3FXTWVxUFQ4TlRwdGF0Njc4NXZ5RERJWXJz?=
 =?utf-8?B?Vm41ME5uRFdDSlgyWWRDbHpiK1YveVFGMnc0YSt5UkRabVpmckhJbWFaUjZM?=
 =?utf-8?B?YkcyWlFuQ3h5a2lxYmQwUXlNNWt2ZUY4WEpMTlNMaTBWV3NXdDlocjZxVjNs?=
 =?utf-8?B?UzlHY0lDeWpQN1VRMG81N3ErTUdaUTJXRllMd0ZicFovU1lGbXR2S3NtS09u?=
 =?utf-8?B?R2JwaFBROHc1blFtM1FoTWloa0lzRnpYclhvWjdUSkJ6M3NVOWM3ai9vUnZw?=
 =?utf-8?B?WkN1VmlEK1BpaFNCc2NjM2VkL1FaakhJSmJLS2M5UlNTVzZDT1N1UWNyV0ti?=
 =?utf-8?B?ZUlKRmlJTzVObUloeFp2dklDeUUwcjBmc1h3dGw1SDV6S01EQ0F1YXovejZa?=
 =?utf-8?B?blJXaVNqcXRaQzFHKzZMUlVGcmNJWitUVVVCL1NCZ3FRbUxlTDV1RlBiLzgx?=
 =?utf-8?B?VitQWDN1cXNGV2tsYkZWTHdrMTVMeDd5c2QvVDhzaG94b1c1NnE2S1Z3MFds?=
 =?utf-8?B?Q2s2emZ6QU85bWE4eEd1SURLaWU4NXhzQkRwM01yak0wNU55M2pqWGkrU2lo?=
 =?utf-8?B?M3BicC9MM2kyaDIwbUtpblpxMnZEWm8yOTl3WElVbDk2ejNDU3c5a0psZUQ2?=
 =?utf-8?B?NG84c1pGZlM0Z3VBNnI5Q2xOT1pjMXpCOHRIbFhSc3ZibnhNRmZYQ3ljbktt?=
 =?utf-8?B?d2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a33b3f-72ff-4930-91a6-08dac98ef170
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 18:01:41.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hdfpqlraZrr/Gcv7GVa3OUBx+AIVJ8dt2r9IyyzWrHULm6FOQq28ha8o/hCGApnd/neap7hkB6526y6UuDsIlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9439
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/22 12:30, Vladimir Oltean wrote:
> On Fri, Nov 18, 2022 at 12:11:30PM -0500, Sean Anderson wrote:
>> >> - We can check all the registers to ensure we are actually going to rate
>> >>   adapt. If we aren't, we tell phylink we don't support it. This is the
>> >>   least risky, but we can end up not bringing up the link even in
>> >>   circumstances where we could if we configured things properly. And we
>> >>   generally know the right way to configure things.
>> > 
>> > Like when?
>> 
>> Well, like whenever the phy says "Please do XFI/2" or some other mode we
>> don't have a phy interface mode for. We will never be able to tell the MAC
>> "Please do XFI/2" (until we add an interface mode for it), so that's
>> obviously wrong.
> 
> Add an interface mode for it then...

> But note that I have absolutely no clue what XFI/2 is. Apparently
> Aquantia doesn't want NXP to know....

SERDES Mode [2:0]
  0 = XFI
  1 = Reserved
  2 = Reserved
  3 = SGMII
  4 = OCSGMII
  5 = Low Power
  6 = XFI/2 (i.e. XFI 5G)
  7 = XFI*2 (i.e. XFI 20G)

This is about it (aside from a mention in the PHY XS System Interface
Connection Status register). I assume it's over/underclocked XFI, much
like how 2500BASE-X is over/underclocked "SGMII."

I got my manual from Marvell's customer portal (okta). My document is
dated March 10, 2022.

>> >> - Add a configuration option (devicetree? ethtool?) on which option
>> >>   above to pick. This is probably what we will want to do in the long
>> >>   term, but I feel like we have enough information to determine the
>> >>   right thing to do most of the time (without needing manual
>> >>   intervention).
>> > 
>> > Not sure I see the need, when long-term there is no volunteer to make
>> > the Linux driver bring Aquantia PHYs to a known state regardless of
>> > vendor provisioning. Until then, there is just no reason to even attempt
>> > this.
>> 
>> I mean a config for option 1 vs 2 above.
> 
> How would this interact with Marek's proposal for phy-mode to be an
> array, and some middle entity (phylink?) selects the SERDES protocol and
> rate matching algorithm to use for each medium side link speed?
> https://patchwork.kernel.org/project/netdevbpf/cover/20211123164027.15618-1-kabel@kernel.org/

Yeah, this is what I was referring to in the other thread [1]. In order to
implement this properly, we'd need to know what interfaces are supported,
electrically, by the board.

[1] https://lore.kernel.org/netdev/ea320070-a949-c737-22c4-14fd199fdc23@seco.com/

>> > Until you look at the procedure in the NXP SDK and see that things are a
>> > bit more complicated to get right, like put the PHY in low power mode,
>> > sleep for a while. I think a large part of that was determined experimentally,
>> > out of laziness to change PHY firmware on some riser cards more than anything.
>> > We still expect the production boards to have a good firmware, and Linux
>> > to read what that does and adapt accordingly.
>> 
>> Alas, if only Marvell put stuff like this in a manual... All I have is a spec
>> sheet and the register reference, and my company has an NDA...
> 
> Can't help with much more than providing this hint, sorry. All I can say
> is that SERDES protocol override from Linux is possible with care, at
> least on some systems. But it may be riddled with landmines.
> 
>> We aren't even using this phy on our board, so I am fine disabling rate adaptation
>> for funky firmwares.
> 
> Disabling rate adaptation is one thing. But there's also the unresolved
> XFI/2 issue?

I had in mind something like

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 47a76df36b74..18dfc09e80ef 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -109,6 +109,12 @@
  #define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
  #define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
  #define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+#define VEND1_GLOBAL_CFG_SERDES_MODE		GENMASK(2, 0)
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI	0
+#define VEND1_GLOBAL_CFG_SERDES_MODE_SGMII	3
+#define VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII	4
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G	6
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G	7

  #define VEND1_GLOBAL_RSVD_STAT1			0xc885
  #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
@@ -675,14 +681,69 @@ static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
  	return 0;
  }

+static int aqr107_global_config_serdes_speed(int global_config)
+{
+	switch (FIELD_GET(VEND1_GLOBAL_CFG_SERDES_MODE, global_config)) {
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI:
+		return SPEED_10000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_SGMII:
+		return SPEED_1000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII:
+		return SPEED_2500;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G:
+		return SPEED_5000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G:
+		return SPEED_20000;
+	default:
+		return SPEED_UNKNOWN;
+	}
+}
+
+static bool aqr107_rate_adapt_ok(struct phy_device *phydev, u16 reg, int speed)
+{
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, reg);
+	if (val < 0) {
+		phydev_warn(phydev, "could not read register %x:%x (err = %d)\n",
+			    MDIO_MMD_VEND1, reg, val);
+		return false;
+	}
+
+	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) !=
+		VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
+		return false;
+
+	if (aqr107_global_config_serdes_speed(val) != speed)
+		return false;
+
+	return true;
+}
+
  static int aqr107_get_rate_matching(struct phy_device *phydev,
  				    phy_interface_t iface)
  {
-	if (iface == PHY_INTERFACE_MODE_10GBASER ||
-	    iface == PHY_INTERFACE_MODE_2500BASEX ||
-	    iface == PHY_INTERFACE_MODE_NA)
+	int speed = phy_interface_max_speed(iface);
+
+	switch (speed) {
+	case SPEED_10000:
+		if (!aqr107_rate_adapt_ok(phydev, VEND1_GLOBAL_CFG_10G, speed) ||
+		    !aqr107_rate_adapt_ok(phydev, VEND1_GLOBAL_CFG_5G, speed))
+			return RATE_MATCH_NONE;
+		fallthrough;
+	case SPEED_2500:
+		if (!aqr107_rate_adapt_ok(phydev, VEND1_GLOBAL_CFG_2_5G, speed))
+			return RATE_MATCH_NONE;
+		fallthrough;
+	case SPEED_1000:
+		if (!aqr107_rate_adapt_ok(phydev, VEND1_GLOBAL_CFG_1G, speed) ||
+		    !aqr107_rate_adapt_ok(phydev, VEND1_GLOBAL_CFG_100M, speed) ||
+		    !aqr107_rate_adapt_ok(phydev, VEND1_GLOBAL_CFG_10M, speed))
+			return RATE_MATCH_NONE;
  		return RATE_MATCH_PAUSE;
-	return RATE_MATCH_NONE;
+	default:
+		return RATE_MATCH_NONE;
+	};
  }

  static int aqr107_suspend(struct phy_device *phydev)
-- 
2.35.1.1320.gc452695387.dirty
