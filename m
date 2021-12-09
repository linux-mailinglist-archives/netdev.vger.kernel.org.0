Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEEC46F6C1
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 23:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhLIW37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 17:29:59 -0500
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:60174
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230479AbhLIW37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 17:29:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXYjUSI+W2pATlyhLA2QppASKqK834mVUp80eM2PLCpVYERuGWS8jjYvFJek3PxMb2B8yKRJFbIbWZxCLyL1qcHJBMZy5ISgP3Sy9Fstm/E0+l9zZZMscoGO3K4Gik6+r5AU+yS5u5UffV4TSEDKlIgaVoy+tRm5jsm1YryWHptquQ+oCrGrNbVGyG/PJYWQJqo5Ao+7MTZb2X2kAn10EvU6W3PJcU8WaNjao6q2gWFcniOzHT+im9mFlX6+sqp7JjAox1pj1e9RP2WUgWxhl5BaePGP/3WcQtX+hyCYgIjSqSHRhi8s1AknDXgcTkukcGd3WNwWpBLxnVsuU7Gy5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WAdPtFWah6F2Ol7Iv0JGgm2E0Dh57O4/pVeivioBlA=;
 b=TVYUTmWS6vK21Yy7gPLjHdhkleR9aTFxZWMWJCqW5e9kl+KcPis/HKeuDKdRYe2w19oCmGJULl26KWt3UOz2eagbTxaUAJVpQ5WxitcRXvKBUpOSvS1FCalE+ODja/2nQE85EqASmr6JLicGgadI91lqQkTsm147BbcEigV9yaZ9cXU2mKFZ1GGrJq2PsJdhd8cNWAPdrTppw+Gv4jsuJ1O8Owgq3VrOyIVjYKn8SSByJHOfQ/VLt/FTv1LsxL1iu6Jp1umHb2bnAMvgBK8gSBzOawDRQZud0umZTZQx5ZyuuBQW8RdikCr0HeYgyUwX5R9FkD+5gY7ydze6PMTx3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WAdPtFWah6F2Ol7Iv0JGgm2E0Dh57O4/pVeivioBlA=;
 b=lB7UTUuc1VYBYFYfQ9qTKtsi5Em8tT9EWM5/y70/BUyrfWZQhNaTScpYxcwPAGMIv9mx3gEpm81oI5ycoZApAJYGp2A+VglfzCTfK2Fs1YB+A5YPMWL7xPyOQ4rszFrp4BBlKOjC0GBxXrtc13fPTZghovYCLL4u42xLmjaf06Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0301MB2184.eurprd03.prod.outlook.com (2603:10a6:4:4f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 22:26:22 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 22:26:22 +0000
Subject: Re: [PATCH net-next v3] net: phylink: Add helpers for c22 registers
 without MDIO
To:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Cc:     linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20211119155809.2707305-1-sean.anderson@seco.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <b0b80264-0a1d-f67b-b1ca-204857352b31@seco.com>
Date:   Thu, 9 Dec 2021 17:26:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20211119155809.2707305-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0031.namprd16.prod.outlook.com
 (2603:10b6:208:134::44) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR16CA0031.namprd16.prod.outlook.com (2603:10b6:208:134::44) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 9 Dec 2021 22:26:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f27ef6f3-dec7-4f0e-03c3-08d9bb62edc6
X-MS-TrafficTypeDiagnostic: DB6PR0301MB2184:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0301MB2184A70705A980B3F1AD3B5E96709@DB6PR0301MB2184.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nd6zBAol3BRZWoq/agRJysmioJLiY1hQ6ihs96IG1Ivsix8bhTs7Wj7ctdix68oAhjIrFNl+hRRSZ2cLE+OQafUFNwUH/BJCgm0dt/ulRSq86YZ11FKIvhUbNQBAzIZMRwYSnOiEormjDEXypL3rmtPT7re6Cjad9TzlhnU5NgPqRr+OFwCN6MTwEM1XhIwMFMmxzmsftRS/3TQ4LvEN9IAQ9Q3H55ud5WGfrTsCVRYpDuQd034z4xO90O2OXDOY1cVKvd1gzktMRRh/TCvjGmeVuHx6XdSo/BSRzIVxi1huWzD/beoOUQGPtyvaCGYX11pZWykel00zNaX1PTj/b7HsmXAONN2HO4mXxHyfbXKyZQPx/OUaok77Pz4H2RLM2kQ7B223KUTdip7u4VRFF3Ag8U43k7alANYEvGkUtuSf+I97kL0/GT2fFTsyyEngvtKWV0idJin8kaes7R/GWaNWrBCe9FPhiHCAhizVTNdMT3JaVkjjHEKeETVufCt+VQXdQfNoLu0u7fOzbLcmQ9xfqxg+/SVORC3pWn/4+32P5vqNjj9FEl1CmIU7K6Wx2RE2ux6N0oCl2U4Mx4imMZwZCbP9bOGOb4/UdyE2i32DF4oh6EC/9awo6H6Pa3uBB3pYn2M6xGNjEXK9eAr/g86vlwGZTw/Kh/nlV1kAn5zvOUEtaEXo5aEKWDqX/eZENyatlQNFkpr0PC1V2cMk1nyB86WH9Cu0YhFl/Uq3vspye4FF0F+J1/M9JgycArQqt3DP97ejePHAm5B/l5I2LHP3a8xTXWA2RdtBXPxVp2bcLuZTikH+0Lo/Pg1A4Pjkdmf1JWGqi+bUAxt5knzodvzIpkkTfNgBG1aac2SHdnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(2616005)(956004)(53546011)(52116002)(66556008)(8936002)(66476007)(54906003)(44832011)(86362001)(6666004)(31686004)(36756003)(2906002)(316002)(8676002)(31696002)(6916009)(966005)(186003)(508600001)(4326008)(16576012)(26005)(38350700002)(83380400001)(5660300002)(38100700002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUhtVVVBWlN0WGxnajRIdlpoVFhLM1R6Rkk2T2dwQzRUNlhoQnltL3pDeVoy?=
 =?utf-8?B?UHdrZ3pOd25EalM0TVpYU2VUT2JjazNaR2xISkd1TVR4K1BQeVR2SXVBY0ZR?=
 =?utf-8?B?eXdWT1l6K0hxTHkyL0IvTFp4N1I4cFdqdS9TUFRNT1h1TGdManNWaHVWdVhG?=
 =?utf-8?B?MnAzU2FLTXZ2a3VCQVUxK05WVkU4Q0I5bW85VVl1T1ZQZ1FXclBvNjFKdnA5?=
 =?utf-8?B?QkNsZUhCeGxHVUdUd1ltaG1lWnZlT0dEeXQ1WVhvZnZFaGUrZnJiS2JQYVJT?=
 =?utf-8?B?OGgxdGlMR2swZnIzTWYxSXVqbkhjMm02Yy9MUXBJNVJqd0VyR1RlVzliVzdZ?=
 =?utf-8?B?Qnh1WHhYbkptQXZoc1FSc2R4Y2crbmxock5vUnBvcERXVDhSYVVmaXpUcEhi?=
 =?utf-8?B?dDB2bEZnYTh1SldiUVpmS3drdjF1MDJ3UEd5eVU2YVc2anNUZHp1MDBrYXB6?=
 =?utf-8?B?cVFPOHZvMUFHa1hJRG5EN2xzR2RReUYrN0ZKWjBlUEJDd3lHOEd3V1liWHBu?=
 =?utf-8?B?THQ5S0pGRy85dTlYUzRIWHY2a0dhQWVCVHZvVHkvZzlqeTQ3ZnE3Wjc1WFVn?=
 =?utf-8?B?RTVYSitVckk3Z3ZSUDJkS3I3eDlPbmNqMW1kTUFuU1RtditUbVlub1EwbFdE?=
 =?utf-8?B?ejVwUXJmZHFWWVhaSnlCaHZlSUdlcXR3RFZXamJPQnF4VkY5S3JlWmQwWDht?=
 =?utf-8?B?SU5nRFoxS3JTVUxqVmJVZHBBMy9ONXdtbUdsc0h2dmlSOTV1YUh1WnV1QllK?=
 =?utf-8?B?OXIxeUNwVjhwbHJJc05GMHpXLzRJcE02S0NTM0pudVV1eENMY3dKMmR0Skpk?=
 =?utf-8?B?N0tmamtEZ0tKTzhjL0syQ2wxbWxzcWdTNlc3cWRBRTJ2SzBwbERPdm9OZng1?=
 =?utf-8?B?Y2FEZG0zT2ZIaVo1WEZreGhDcHdBUzJtb2pLSXV0c2IwTDZjeUZ1b3I1TGZE?=
 =?utf-8?B?V0lkN1NkR0RYMFVSVVFrMk1NTUdpL1g0YmozYTV5eERjNTVLNE91a2tlcUt5?=
 =?utf-8?B?TGFmdEtPQXdMVHlDeVNIbjY5NEdUWFphWlRoQWRLeXdNNFNyMnZpYUJ1dDM2?=
 =?utf-8?B?ZFRMQjNrcW5HQUxwb3BzL0Npejh0d0VZZWFOV1hZSlFxNDhhZG9jcjBsNWZK?=
 =?utf-8?B?OXFnSjd0VHFSS3M1anRCRHZ3SmI2WEZwUWRXSDF4TkdBMVI4bCtYVjIwdWVz?=
 =?utf-8?B?MlZ5WnRKSkZONWgvdXhwNm85K2dnamtva0x6QjluQUlKOEhQb05BS0x5QkJN?=
 =?utf-8?B?aGdLMWFMWktjR0JlaG1WY1lrU3czMS8rRHNGUkk1L2N1Q0ZZREpqSmJ6RUpG?=
 =?utf-8?B?MUVJaFpLaUVRY1pxcmpQdDVXY2xDblIyc2hJQTRnMUtWQWVHNTFqZ2xWYVMx?=
 =?utf-8?B?SnJXN05Qa2lteGFMY25QM0UvTmJMVVZTUlQ5cktldTBPQ0VwTEl4VFI5SGx0?=
 =?utf-8?B?cUVOS2U4cnV1TjlJTlFPMTZqbi9jbVk1R1RkcEhHbFhQdlRha0sxWTRib2lN?=
 =?utf-8?B?UjR0L256S21nTEcvcDlMTERmWnB2YjEzdHNoK0ZFMHVZM0JidVluWGsxMUZQ?=
 =?utf-8?B?U2x4b3pIa3ZzYlZGZ0pWbGJ5amJBNURRblI1cHFSTUo4WVFnN1dnNUxmYzBo?=
 =?utf-8?B?enF4NS9DN0tGTm9SbWJPUnRCWkJGZWZSeXF1V2xIQTB0UlZOZzBhaWk0Y3lX?=
 =?utf-8?B?VGVXbmJoZDgyc2ErL2lQcTBBQWRQeHMvSGlCSytVaFhEN0ZUSTNWcDhBc0g3?=
 =?utf-8?B?Qll4ZVBNby93Q2x1alJISVJKSStmY2Jvd1Fxcjk3L0x1VUg5aDB5YlpuRHNG?=
 =?utf-8?B?ME85M0kyZGRkWitJWkdwUGlnNmhWeVVlWlIrdmxORDFEd0tpWG9LSDFIUTVj?=
 =?utf-8?B?amM4L1pvRWUxWkFzYjAySStvNjJmMU9kRDFZbHl3VFhrQUtqYTY1akhQZ055?=
 =?utf-8?B?Y21UR3NoTVRRbFNoK2lFM1VKWWhDVXNHWEk1Vzh6SWRHVmxEQWs0WDNnc0Y4?=
 =?utf-8?B?bHZsWTZMdTJTYXNtVHlSUjY5SXVYSXJQVjBIRFFvWU9QUVlyWWQ3dU9IVUpR?=
 =?utf-8?B?c3MvN0xiL1dQRTdGdW5jSlJvcGhnV0wrOFR6RlZ0OFlGeGNpYUhwZ2lIN05q?=
 =?utf-8?B?Y2w5bzlHQ1BkNG9KYkh3d0FKQUFrTER1aXQxOGV3eVRtWng1ejQrbktVaDZt?=
 =?utf-8?Q?wrvbwZqWrGKK5dvtimJW9Fo=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27ef6f3-dec7-4f0e-03c3-08d9bb62edc6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 22:26:22.1311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfNjoUQ3tS9nLXthyCsRnltUb1fnO7+e96sZlZeYkF9JY+wUNzteHcMQBa0uDDXBB18zZFOctUmzCITHNgVwzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping?

On 11/19/21 10:58 AM, Sean Anderson wrote:
> Some devices expose memory-mapped c22-compliant PHYs. Because these
> devices do not have an MDIO bus, we cannot use the existing helpers.
> Refactor the existing helpers to allow supplying the values for c22
> registers directly, instead of using MDIO to access them. Only get_state
> and set_advertisement are converted, since they contain the most complex
> logic. Because set_advertisement is never actually used outside
> phylink_mii_c22_pcs_config, move the MDIO-writing part into that
> function. Because some modes do not need the advertisement register set
> at all, we use -EINVAL for this purpose.
> 
> Additionally, a new function phylink_pcs_enable_an is provided to
> determine whether to enable autonegotiation.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> This series was originally submitted as [1]. Although does it not
> include its intended user (macb), I have submitted it separately at the
> behest of Russell.
> 
> [1] https://lore.kernel.org/netdev/YVtypfZJfivfDnu7@lunn.ch/T/#m50877e4daf344ac0b5efced38c79246ad2b9cb6e
> 
> Changes in v3:
> - Change adv type from u16 to int
> 
> Changes in v2:
> - Add phylink_pcs_enable_an
> - Also remove set_advertisement
> - Use mdiobus_modify_changed
> 
>   drivers/net/phy/phylink.c | 120 +++++++++++++++++++++-----------------
>   include/linux/phylink.h   |   7 ++-
>   2 files changed, 72 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 33462fdc7add..428f9dc02d0e 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2813,6 +2813,52 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
>   }
>   EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
>   
> +/**
> + * phylink_mii_c22_pcs_decode_state() - Decode MAC PCS state from MII registers
> + * @state: a pointer to a &struct phylink_link_state.
> + * @bmsr: The value of the %MII_BMSR register
> + * @lpa: The value of the %MII_LPA register
> + *
> + * Helper for MAC PCS supporting the 802.3 clause 22 register set for
> + * clause 37 negotiation and/or SGMII control.
> + *
> + * Parse the Clause 37 or Cisco SGMII link partner negotiation word into
> + * the phylink @state structure. This is suitable to be used for implementing
> + * the mac_pcs_get_state() member of the struct phylink_mac_ops structure if
> + * accessing @bmsr and @lpa cannot be done with MDIO directly.
> + */
> +void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
> +				      u16 bmsr, u16 lpa)
> +{
> +	state->link = !!(bmsr & BMSR_LSTATUS);
> +	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
> +	/* If there is no link or autonegotiation is disabled, the LP advertisement
> +	 * data is not meaningful, so don't go any further.
> +	 */
> +	if (!state->link || !state->an_enabled)
> +		return;
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		phylink_decode_c37_word(state, lpa, SPEED_1000);
> +		break;
> +
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		phylink_decode_c37_word(state, lpa, SPEED_2500);
> +		break;
> +
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		phylink_decode_sgmii_word(state, lpa);
> +		break;
> +
> +	default:
> +		state->link = false;
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_decode_state);
> +
>   /**
>    * phylink_mii_c22_pcs_get_state() - read the MAC PCS state
>    * @pcs: a pointer to a &struct mdio_device.
> @@ -2839,55 +2885,26 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
>   		return;
>   	}
>   
> -	state->link = !!(bmsr & BMSR_LSTATUS);
> -	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
> -	/* If there is no link or autonegotiation is disabled, the LP advertisement
> -	 * data is not meaningful, so don't go any further.
> -	 */
> -	if (!state->link || !state->an_enabled)
> -		return;
> -
> -	switch (state->interface) {
> -	case PHY_INTERFACE_MODE_1000BASEX:
> -		phylink_decode_c37_word(state, lpa, SPEED_1000);
> -		break;
> -
> -	case PHY_INTERFACE_MODE_2500BASEX:
> -		phylink_decode_c37_word(state, lpa, SPEED_2500);
> -		break;
> -
> -	case PHY_INTERFACE_MODE_SGMII:
> -	case PHY_INTERFACE_MODE_QSGMII:
> -		phylink_decode_sgmii_word(state, lpa);
> -		break;
> -
> -	default:
> -		state->link = false;
> -		break;
> -	}
> +	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
>   }
>   EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
>   
>   /**
> - * phylink_mii_c22_pcs_set_advertisement() - configure the clause 37 PCS
> + * phylink_mii_c22_pcs_encode_advertisement() - configure the clause 37 PCS
>    *	advertisement
> - * @pcs: a pointer to a &struct mdio_device.
>    * @interface: the PHY interface mode being configured
>    * @advertising: the ethtool advertisement mask
>    *
>    * Helper for MAC PCS supporting the 802.3 clause 22 register set for
>    * clause 37 negotiation and/or SGMII control.
>    *
> - * Configure the clause 37 PCS advertisement as specified by @state. This
> - * does not trigger a renegotiation; phylink will do that via the
> - * mac_an_restart() method of the struct phylink_mac_ops structure.
> + * Encode the clause 37 PCS advertisement as specified by @interface and
> + * @advertising.
>    *
> - * Returns negative error code on failure to configure the advertisement,
> - * zero if no change has been made, or one if the advertisement has changed.
> + * Return: The new value for @adv, or ``-EINVAL`` if it should not be changed.
>    */
> -int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
> -					  phy_interface_t interface,
> -					  const unsigned long *advertising)
> +int phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
> +					     const unsigned long *advertising)
>   {
>   	u16 adv;
>   
> @@ -2901,18 +2918,15 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
>   		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>   				      advertising))
>   			adv |= ADVERTISE_1000XPSE_ASYM;
> -
> -		return mdiodev_modify_changed(pcs, MII_ADVERTISE, 0xffff, adv);
> -
> +		return adv;
>   	case PHY_INTERFACE_MODE_SGMII:
> -		return mdiodev_modify_changed(pcs, MII_ADVERTISE, 0xffff, 0x0001);
> -
> +		return 0x0001;
>   	default:
>   		/* Nothing to do for other modes */
> -		return 0;
> +		return -EINVAL;
>   	}
>   }
> -EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_set_advertisement);
> +EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_encode_advertisement);
>   
>   /**
>    * phylink_mii_c22_pcs_config() - configure clause 22 PCS
> @@ -2930,16 +2944,18 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
>   			       phy_interface_t interface,
>   			       const unsigned long *advertising)
>   {
> -	bool changed;
> +	bool changed = 0;
>   	u16 bmcr;
> -	int ret;
> +	int ret, adv;
>   
> -	ret = phylink_mii_c22_pcs_set_advertisement(pcs, interface,
> -						    advertising);
> -	if (ret < 0)
> -		return ret;
> -
> -	changed = ret > 0;
> +	adv = phylink_mii_c22_pcs_encode_advertisement(interface, advertising);
> +	if (adv >= 0) {
> +		ret = mdiobus_modify_changed(pcs->bus, pcs->addr,
> +					     MII_ADVERTISE, 0xffff, adv);
> +		if (ret < 0)
> +			return ret;
> +		changed = ret;
> +	}
>   
>   	/* Ensure ISOLATE bit is disabled */
>   	if (mode == MLO_AN_INBAND &&
> @@ -2952,7 +2968,7 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
>   	if (ret < 0)
>   		return ret;
>   
> -	return changed ? 1 : 0;
> +	return changed;
>   }
>   EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_config);
>   
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 3563820a1765..01224235df0f 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -527,11 +527,12 @@ void phylink_set_port_modes(unsigned long *bits);
>   void phylink_set_10g_modes(unsigned long *mask);
>   void phylink_helper_basex_speed(struct phylink_link_state *state);
>   
> +void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
> +				      u16 bmsr, u16 lpa);
>   void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
>   				   struct phylink_link_state *state);
> -int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
> -					  phy_interface_t interface,
> -					  const unsigned long *advertising);
> +int phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
> +					     const unsigned long *advertising);
>   int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
>   			       phy_interface_t interface,
>   			       const unsigned long *advertising);
> 
