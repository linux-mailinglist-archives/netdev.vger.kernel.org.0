Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9A1642BC2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiLEPaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiLEP3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:29:38 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2089.outbound.protection.outlook.com [40.107.104.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6914B186D4
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:28:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fe+i5zlnA3hcd9kyMNspuy64i3EHh/M/x6neJt8B3vuvYpNzLga/QB/r5aAcVhKz+IVIJS4V36rnPQh8DB8Wmztg67PBDskj7LTqqhJPupU7OQ3iP0UgtzNmQ7qjkblO9y/UVIKYrcDhp1jLg/Zj+7K4oOgLp0MgVv4PVDIg9E5oBvTN08Ys0vwAgvEMbZn/hfQ0+8RRrpgCXmB7L5BEenIbT0uJjp0NUE8hzqd6UGVxR2dRITQ2nqPozpkz/+8FLR6jmLnyJGM+a+XsEUOMlsl573YNQ85WBBb2bTklxSGAtirAZpsADNPy3LuuAi/lS4SLHP1uEM+/uDpvTxfNLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=InKxNnAIul+kX90Ab18Ya6RqNGFJsjIdgXFyQmVUEuQ=;
 b=SfODgAzxH5SWcdCRmczCdMfry/CzZe39O/Vw4wn1GZuinLNbW01B53yH5Zxk5wjOg9DoiKRtGb75+IuUTaJX6+lFQzWDECuGI0w/rwKNz7wCkeYwV/CMh6mcNUOkWf77lOiLLq29uf/j/qMujtO723vSZP5CL2+EQMVX5DcGYQ/T1nRFdVTXi+H96jRgHxYpqrYhoACnL2RXQ1wkw7NXFYwt7caspopU+rLyjLKDbgbnWi7vNIlvZRjmw+QVt2qN4D+TiqTrUaFDQaxKOoaIvrziphg/S4EN0b1SD7tOGzqn7UbSbPYGR8HxKfXn70xWCzYcu8RqzXL3mZcZNdPCiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InKxNnAIul+kX90Ab18Ya6RqNGFJsjIdgXFyQmVUEuQ=;
 b=CGnZS7Y37wrTlYOzAASQa1mINhjVc5ihxv/JYoCf623WNbjDLRASG3KjmN5LqzJn2QTgKaFAqQ2sfFKnMkZWgEquum0rWuXgmnP8DAS2ySqG3EHa+tZ5njz4LApaX1gIRHeqZg4MrOMJZdManr5+ZZZKVBuu0tN9jfDRh0Ifryyd3wmlB7ut3/v6hFwMVV6zwfCCRXxnVhjaIs/8dE8vsz1WOy6LDRrde+yGasyix3w5mR9mIqP20Xp9YnMom0mRs4ACh+9IJgBTHJnTtblSyrIhteP1B5QG1HG6ssuMJaxRseIkjWeegHU+l+59W/rDxGUbnnhKXmh3pdPUKX9wxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB9605.eurprd03.prod.outlook.com (2603:10a6:20b:5a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 15:28:43 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%7]) with mapi id 15.20.5880.011; Mon, 5 Dec 2022
 15:28:43 +0000
Message-ID: <c80ab3f0-66f8-8446-f7d5-eb6add2ce9d2@seco.com>
Date:   Mon, 5 Dec 2022 10:28:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] net: phy: swphy: Support all normal speeds when
 link down
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
References: <20221204174103.1033005-1-andrew@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221204174103.1033005-1-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0065.namprd20.prod.outlook.com
 (2603:10b6:208:235::34) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB9605:EE_
X-MS-Office365-Filtering-Correlation-Id: bec0aadc-6fee-492f-f570-08dad6d56487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+NUcxQQIT/cfEuuH8qwbwWn5VT3AthVsQqmuNRGYimydRvGK1DYsIsWr+C6xoztotnFzlcnG5vcDiqF5qiR04dBjt/dllsxrqnE04K6XC2X/Y0G0X3XvTs/BTODl23F7ST5LHJe8iGkgHWfzGg3QYfVjJFCT/WJLXXN53HzyvtwPMANQgjmrOS0raNCKuAkQ6ncBt7QH0rqA/QbHojfF3MS5Db25tNudT3BSWOHdZBSl2/GtkMKIndF1nNItkEsNxB8Rd65O6Y5if9pbR9tT621um9Fhly2nkN+9AR9qUZdNuB7JM1GENca64kurqApP5jaZrC1Lmmox0gHav6/Eka+eDB6cHv0kGDVQvB1QHzA6NYROalYhW7IJCHiMwEI/zPk37NQTKePFesTC3mfm3Nn5a8tsJ0Nrv54HjCNbfCTFUhYHIylt+jWBhh6897dESRiOm19B1bNuttrQwTNwfP5VN8oO5wFgcEXXNShNokNjANigROdwcNn17bNlpKTFSTVDEKwMx1Oi0EaPPi4UlNV8syxRm28Ia6GuKuuOP/ZY2xR79bvpHZk0Zqkc6d0O7bobr0bIIG6Xhh4SowhBIa/Jr1zuHG2jEJzILjyaRtuPVKMxJTMFkgY8MbFcGymZtXFH/RY8ggZp1tBBsElsS0QVuYRgIeOlgUaEfo8SfuoH1l0FNKB5qHf8fl+qqRMD1IRXc6DTippCNZFmW0Cnxt6WtgqaENMOOGoSwsh12VHJgK+g0+RvCUUQYQT0Tzqk6tlNjeVFpQQbMTjmgeCbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(136003)(39850400004)(376002)(451199015)(31686004)(8676002)(31696002)(8936002)(86362001)(6512007)(6486002)(6666004)(478600001)(26005)(6506007)(44832011)(53546011)(4326008)(2906002)(316002)(52116002)(38350700002)(38100700002)(66556008)(2616005)(66946007)(66476007)(36756003)(186003)(41300700001)(5660300002)(54906003)(110136005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0hMcWU5cW1nbHlVLzlOWnZOQzQ5V0lVbHNISGlUazMwVllCQnF4TUxOMGs5?=
 =?utf-8?B?WlA4UER0bGdLM1BCazZZN291bzIybi84UjNzNTVuSVYrVy9MVEQ5SnljaE1L?=
 =?utf-8?B?QVkrZjlHK2QxVk54bFozNjlUdXJUOFdndEt2SVlCZEt6dWdXSGM0eHQrOVFl?=
 =?utf-8?B?RWNLWm1NNkN1YjBmajlmNlJ1WGVQVXd3RUNoK2Vhbnpyc3hLWEVSdzdxTEll?=
 =?utf-8?B?cVhENTY3T2svM2ZCeDZlVC9RaTNBTkwyTHhaSldBblAxQ2RyQldQL2VzZ1Vj?=
 =?utf-8?B?UmZhZFNNNWY5cUd0VnBsZ0I3aTcyYXNFZWdPTDh3WlJsOEFMVUxMcmFJc1Bs?=
 =?utf-8?B?dXl6R2FCTGVlZFp2WGZtVTgzZmpIU2VUNkZaL2t0aWhvVmg4L1RRZE93YlFR?=
 =?utf-8?B?NWllMnVEbGh1bWRSd205dE93ekdCQ1hUZEZEOUtTb3BCWUptUWdONjQ5M1Mv?=
 =?utf-8?B?MlJuajl4MFdQYmk0cEF1bnRxY2d3VlY1MUVzSEs1dlZaeWRGa0F0MDVwamNp?=
 =?utf-8?B?NjA4QmVFNzI3a1ZLa1RtMnh2MEpuTkVpOE5mWXJxVUQzaTUralp4U0NVaVVE?=
 =?utf-8?B?bHFhc2c1ZnhDVjF2MkhZRVRUdkxyc1dSMVdYZTF6MWVFQ3ZnUWNvMlVaaVJp?=
 =?utf-8?B?TE1zMmNJUlAzUHd1YVdjTG9wWTFFZDFYS1ZPSWV3c2pTMGdjNHpBM3lhck9p?=
 =?utf-8?B?UjNVOE1seVFXWjFCQmt5LzNoZFJJMjdxNXE1c3pKOTQ1SzlCMlRUMU5zbWRM?=
 =?utf-8?B?bHRiK3laVHRoU3AyMFk3OFVlS1BsM21EcU9PczI3RHZIaTFiY2NwNGFUTk1Y?=
 =?utf-8?B?REk3TTNpZEthd0xBUXNadGo3dmdibjdSaFNId0FXc0Z2M3RXbzYzbDhwVGtB?=
 =?utf-8?B?ZXAxeTVzZE56dUVCeU1RK2ZENEorUzNzRXQ2R21oMWw1b1VLR09LRm9BcURB?=
 =?utf-8?B?T1dpVjMzKzJrWWtrTHV4azIrOXlrUUJyTXEzTllmUHJBQUQrUFUwclNMYVlk?=
 =?utf-8?B?ZWdrQ2tvWFM0Q2VGV2NabkVUdjNJUDFlTmZRZjdvMHREYVdSQmNBc01WQkhF?=
 =?utf-8?B?d0kxZkVSSGVvMHQ3V2J1RFdjRnJFSlJRRzRySURLMWxReXo2TlJKS2QvaVpG?=
 =?utf-8?B?Qng4VXM1UkNhdThBNWNTVUdrM0oyZ3dTVGdZTFBjRU9tWmpwUm9TeWRJRDlD?=
 =?utf-8?B?dTQrdVM4MGQ5eHlaZHg4SzZIV2wyQ1hrSHd4VjUyNG50VkM3bHZXT2JHM1FM?=
 =?utf-8?B?SCtKbUNVM1pHSGhKVHJVSWgvZ3BaSDgycC9pcHRIT2Q5Q3JuQmJwQkYwTXA5?=
 =?utf-8?B?bW9FK1p4TE9hOUFOSGZ3clhSK0FXb0ZUT0U3ck9nUTdtUk9zS0Y2ZHdaL0xV?=
 =?utf-8?B?bnpRVm8zWkZ6S3pWQ3pOVUJVWXpjSHE0NDBRejdxSGhVUjYrQWR5UlhaSW5T?=
 =?utf-8?B?S3puWldoUFNyTFBmdVJnakNKQklRNnllVlhXQTUvQWJGNUhpREQwVEtnOVU3?=
 =?utf-8?B?Q2JBbG55WkJhZmtXZEtScGxZWVNTTWZXU2FEWFFnd0ZzbEE1bERiR2NwRERF?=
 =?utf-8?B?ekhDSU8wRWhXMm5LWE1OMFY0ZkwvYSs5TExwMXpjOFlIV2M2N3ppSWptU0xl?=
 =?utf-8?B?WUNSVEl2ZVh6NjlvTi9nOG1uRitwRHFUU1pnd0puRm5IdXVOS0thSTNPVEtp?=
 =?utf-8?B?VFRncDlDQmFNOUlOWWJpTlF3aTgwbWpaK2NsOTZjTkprY202aElhUThFbmVQ?=
 =?utf-8?B?aVlyNGh4L3hlMGRpZFF1eDNtaVBIWXl6TzVxaXNhZlRpbGdCSkkwU2xBSHAw?=
 =?utf-8?B?YWVNUGsxNnJQdldIR3l2SlpOVmVQQmVJS2xRODV3N1YwMm1WTlUzZXM0K0Rv?=
 =?utf-8?B?ZDVVN0tHa2ZoVWFSMmVWNmdFOWh6OFpGSEgrU1BhTGQzUkIxRGRlUktVZisx?=
 =?utf-8?B?a252TFJTOXAyeUx5c2RWeG04NkxEWkp5NUppRnhMaUpRQzlnQVpydXFyYlRh?=
 =?utf-8?B?NlZ6d0kyRHp0NW9jc3ZSWUVCTDAyTldvckxaV2d0YnpxcDFrMi85b0p1NnFy?=
 =?utf-8?B?SlpUL1lXL2VLUk1pMkVMUWxGL1E1VmRZcGROMXlSRFhDSThyMlhaTUltamZO?=
 =?utf-8?B?NlJ4VnFCR3dMcmYvcXVQaVFzMVl5cDcxQ29ONmFXcUVoQlpZSllybEpLeTM2?=
 =?utf-8?B?WkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bec0aadc-6fee-492f-f570-08dad6d56487
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:28:43.0606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPBecCosc8xm4qXqE+4rWwty/s+2ilOhSXUTFxc+jL9Q8Rp9XMS/2GI9B8tvBzmBXkzHdH4e0sG4PseZvepO8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9605
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/22 12:41, Andrew Lunn wrote:
> The software PHY emulator validation function is happy to accept any
> link speed if the link is down. swphy_read_reg() however triggers a
> WARN_ON(). Change this to report all the standard 1G link speeds are
> supported. Once the speed is known the supported link modes will
> change, which is a bit odd, but for emulation is probably O.K.
> 
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
> 
> Hi Sean
> 
> Does this fix your problem?

Well, it removes the WARN, which is all I was after.

--Sean

> drivers/net/phy/swphy.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/swphy.c b/drivers/net/phy/swphy.c
> index 59f1ba4d49bc..63bd98217092 100644
> --- a/drivers/net/phy/swphy.c
> +++ b/drivers/net/phy/swphy.c
> @@ -29,8 +29,10 @@ enum {
>  	SWMII_SPEED_10 = 0,
>  	SWMII_SPEED_100,
>  	SWMII_SPEED_1000,
> +	SWMII_SPEED_UNKNOWN,
>  	SWMII_DUPLEX_HALF = 0,
>  	SWMII_DUPLEX_FULL,
> +	SWMII_DUPLEX_UNKNOWN,
>  };
>  
>  /*
> @@ -51,6 +53,11 @@ static const struct swmii_regs speed[] = {
>  		.lpagb = LPA_1000FULL | LPA_1000HALF,
>  		.estat = ESTATUS_1000_TFULL | ESTATUS_1000_THALF,
>  	},
> +	[SWMII_SPEED_UNKNOWN] = {
> +		.bmsr  = BMSR_ESTATEN | BMSR_100FULL | BMSR_100HALF |
> +			 BMSR_10FULL | BMSR_10HALF,
> +		.estat = ESTATUS_1000_TFULL | ESTATUS_1000_THALF,
> +	},
>  };
>  
>  static const struct swmii_regs duplex[] = {
> @@ -66,6 +73,11 @@ static const struct swmii_regs duplex[] = {
>  		.lpagb = LPA_1000FULL,
>  		.estat = ESTATUS_1000_TFULL,
>  	},
> +	[SWMII_DUPLEX_UNKNOWN] = {
> +		.bmsr  = BMSR_ESTATEN | BMSR_100FULL | BMSR_100HALF |
> +			 BMSR_10FULL | BMSR_10HALF,
> +		.estat = ESTATUS_1000_TFULL | ESTATUS_1000_THALF,
> +	},
>  };
>  
>  static int swphy_decode_speed(int speed)
> @@ -87,8 +99,9 @@ static int swphy_decode_speed(int speed)
>   * @state: software phy status
>   *
>   * This checks that we can represent the state stored in @state can be
> - * represented in the emulated MII registers.  Returns 0 if it can,
> - * otherwise returns -EINVAL.
> + * represented in the emulated MII registers. Invalid speed is allowed
> + * when the link is down, but the speed must be valid when the link is
> + * up. Returns 0 if it can, otherwise returns -EINVAL.
>   */
>  int swphy_validate_state(const struct fixed_phy_status *state)
>  {
> @@ -123,11 +136,14 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
>  	if (reg > MII_REGS_NUM)
>  		return -1;
>  
> -	speed_index = swphy_decode_speed(state->speed);
> -	if (WARN_ON(speed_index < 0))
> -		return 0;
> -
> -	duplex_index = state->duplex ? SWMII_DUPLEX_FULL : SWMII_DUPLEX_HALF;
> +	if (state->link) {
> +		speed_index = swphy_decode_speed(state->speed);
> +		duplex_index = state->duplex ? SWMII_DUPLEX_FULL :
> +			SWMII_DUPLEX_HALF;
> +	} else {
> +		speed_index = SWMII_SPEED_UNKNOWN;
> +		duplex_index = SWMII_DUPLEX_UNKNOWN;
> +	}
>  
>  	bmsr |= speed[speed_index].bmsr & duplex[duplex_index].bmsr;
>  	estat |= speed[speed_index].estat & duplex[duplex_index].estat;

