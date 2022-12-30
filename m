Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9946599B5
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 16:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiL3P3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 10:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiL3P3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 10:29:41 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2089.outbound.protection.outlook.com [40.107.6.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A20719295;
        Fri, 30 Dec 2022 07:29:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPyf/SRyd8loOoAOofayOVBvCFeUIuBOIA954zQ6zhTYEnVCTU/1NDZIjpiU605WcCg54Hols51L65wPloYkjAsrdyY/NESqDcCMXqhn9lKYtbzAZBkLfKWzgXG75agyQhkgBEcdNNHtYzyGsLI2Y+cZZd/aSdF7cd+IKAbU1+OL1Vj48iFsiJMlAem5B+QCTizZeeOG/LC6QQxqj2Oe6JaGXDbuYC+dDmyAl/CkR/FtZBKDChz2U8NjLo1+/1lFm6yHnoo1RPQWpg7Zbm+a2UELUOspHnEbocOK2E/AsRFG9M0PjXVmDEvyAWoQ/uDTQD0x6MHc1yBzq6lGnkZS6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEu9peSxx4ByVtT6CZzFV9m4iKbfZtwgG04GvH0qgWc=;
 b=AHlIR6yWH6PTzrvIj/vgSUsrYD/cacImtnYu4PDP3qSt2umrAL4BrUsx7+m91Lf8L6gwJ0sV31sNy3Cf+KE4fhtOqFdeylgpGPVOJpc8IuKDIiq/JM+vIvlddzm8mbhtQwEOHxzmHzzDNcKIfmCHvA2Xb2P1IbFb9dGbblmRtVCgLaitbC4ZkcNq2n1r3scCQt/N09TtHpkQHdzIEv1tgA03qc02CcftxvdZqPp50hyrnKfnjIV7xjX2nAgc1FSsLdYMVxQ0QgzWquf9RP4mnv+lEkFhXMW3Uei28Qj68XSI9X44dIoYFHWzZAz6QhganS2O2tSwd3beb0A6HnBlGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEu9peSxx4ByVtT6CZzFV9m4iKbfZtwgG04GvH0qgWc=;
 b=x6Q28FfSt17hPi4P+txQgALvsTYwc25oCSC/VueJoRMp6Rpo7ne3lw+5gzUTvyhJDdwzxExowW6QimGv6jp3p0jcRKxunhf8CaV2Q2gKQmsXMSkTThQTehkxf2UpZ29aFZ0bziJW4xrCM4E1i4bsxWrD57Dyhuhj+fFWcw9+TUCJSca4YqLArX1RgQ1DKPBVZCEY/OEhy5Bk4R8ln3VJxz5w79eWk+4yF6qgSj2q1F/+0sI0df9hcKFmZz8g202Hs9avnpUSxCmv6Gqcpa8uXWD6JvYM4dbzCfJOr9vv3OUbrQlcQO8FDiHOkuFK9fIDrhggvWNqLHN866CeYgJhPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB8569.eurprd03.prod.outlook.com (2603:10a6:20b:572::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Fri, 30 Dec
 2022 15:29:37 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.016; Fri, 30 Dec 2022
 15:29:37 +0000
Message-ID: <c50d546c-1fef-7037-6eba-0a6099726dfc@seco.com>
Date:   Fri, 30 Dec 2022 10:29:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net] net: dpaa2-mac: Get serdes only for backplane links
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221227230918.2440351-1-sean.anderson@seco.com>
 <20221230101710.btdw227v62nnj3le@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221230101710.btdw227v62nnj3le@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0054.namprd16.prod.outlook.com
 (2603:10b6:208:234::23) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB8569:EE_
X-MS-Office365-Filtering-Correlation-Id: c5aa6463-5b7a-4d18-5112-08daea7aa940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGvsq/Sm9AXP0bFIlL2n3avwOI9AoqEHghFDQVIBCPxUcyfImWCyFpkpXHi75cO3n1THQfCZwkhJaNRH9ZO1iuny70qzkhdE/aMjNa/KRrXbVH0OQvmC6o1R20uNpTQ6ZP4QJbJEzQ2ZVaYyLPZjTwQDEUrk/NcDl/f5QvEl0HsXRWd9bEph02suXi0+9yMiy+MUij5zz2ak8cFp752Yu+s6wBejc+yKP2LMGrIUKuLMfARB4BNdhSLIBlLceUaC70AkQtu7tgUDNmUABTEIzGi7fZTG+W3+GeXFQ3V0i3wyxdJX2Zrd5cFsFyHjAfGL7YV0E0swFtAno3mwJn8DQteYSq86WfRO/iqbsxnhU0xoTlyots1DBYZGWwIEqlZ359ME4kpPEHQZZFJduDzQfUJguvqoGpGpX0AlfaNo8VSSZzZH2BIdrcw5SOag4u+AFkXxFDoZ+DPiUWl/4yhQkJdjC+NvqB5t06yLeFWqey0cXy5HCRp4B6qZBAk/qNhR2uJ9R29M+2filGdDlx8IZ+51Kq3CO+95XzPJlFB70CBJYDCtDYurCBJa1eqyVL2i+BPX4FeVA+RhBhdMg+FEfgpd0rLo3g3OwMs4YRltDti18kXOsmV/TehwNei5yeYxnkbMnZmBEDl1ejxwdJABI6xgcQ7iK4JdggWY8ND3p2hXUNi+Xvr1f9xv3d6yGmo/dhy2f1mBihlEEgDK+cjdQ7pusL/dvfEpD31KcPya1zsvEH5Oa05DwZVcn+UKRsXqHcsZ5wo+NCQ9e0t68ppNh4PEjL/YQhwixB/6Vpke8c4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39850400004)(346002)(376002)(136003)(396003)(451199015)(38100700002)(38350700002)(41300700001)(54906003)(4326008)(83380400001)(31696002)(86362001)(66946007)(6916009)(66476007)(66556008)(8676002)(316002)(26005)(8936002)(5660300002)(6512007)(44832011)(2616005)(2906002)(186003)(478600001)(966005)(6486002)(6666004)(53546011)(52116002)(6506007)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0loM2dGNnBUdWs2OUZBek8xbDRWbXU0ajcxNmwwZVlkbVR3QzQ0Skw2TFpX?=
 =?utf-8?B?SjJpNVh1VzFhK0RuNFpyNGhTbTUyajBSOGVjQzJnVjBuNCsyRyszUVRlSEt1?=
 =?utf-8?B?WVhvbkRXRTRoVkltSUx6bEcrbHpFdXNwd3JubW5iZmJiWjk0MGRkeUtPQUNa?=
 =?utf-8?B?VFMvenh5aG5YNFFlb1dYZ3Zub1JwVXZGVWJ2bWMzSDlKOWcxbUJ0MThiVzl4?=
 =?utf-8?B?ZmNXSHJ4SUsxNGxKd1A2SEQyNktzQUEweXFuZmN6MTJYUGlkTjlVamhUQVl6?=
 =?utf-8?B?UXpJcTJ6enNLaW14MWtzMDc5WkJaT0oxRW5yTUhCT3ZGYTNMNi9rcEF3S0Nx?=
 =?utf-8?B?V29yZDduTVNsNFdOWlBKYmNmUnRXUldCNTJGMXMxVWJML1NIMnpSQ056Q0Zv?=
 =?utf-8?B?cXhzcm9XSUhXTERiWHpPanA4U3QvSk1LUjdPNGtZY1VtNW1FaTdSK3h5YlJF?=
 =?utf-8?B?OUhDSTVHTXJqY2tGODZESUM5SEhvck9UeXpZR2VraWFsRG5CWGkwN1Y1K3Fh?=
 =?utf-8?B?NnVPSDVEdkg1Q0pBWEREQkJMbUE4Y1oyMEJ6ZlpKZEd1WHUwdHo1L3o5VmRO?=
 =?utf-8?B?Q3psdU4xSGlHdHd3YUFyZXVoVzN4eThwM09QT2hMeWhFMnpwQkNmcEV5dVg0?=
 =?utf-8?B?TmNhTWFwaDdlV0lFMXFycWJyVzcyZUdyVUJIVEp1bGJBVFNCbTBLQlNWUFlY?=
 =?utf-8?B?OXIzd2M2KzIvVzFnV3R2OExvUnlBZkttM3VWbE1SdGlpY1duSjhqS2pTRFFU?=
 =?utf-8?B?SlRJNy9hTHBydXZRM3RVR3VWKzBtR25KWmRmOXV2dHdMU1FzTkxPMU9pRUNp?=
 =?utf-8?B?dXBSSlNwS1JxcjNuT29PUDI2ZnJTdjl2K1pzMmZsZ01TaVc5ci85blIwOXU2?=
 =?utf-8?B?aUQ4T0tCRThmYTNuckJJTnlvUDB0RlhsRnZnOVBsN1ZkSmQwTzBlQTFRdGRq?=
 =?utf-8?B?Si95dm5MSUsxUUJCRnA3TWlaalFuTHU3aG0vQ0swcDhSV3Jxczh6clR4OC9x?=
 =?utf-8?B?S1AzNTdqSEd6SytyT2JERFFyd0xna2wwL2V6N3JoY2V6ZExEZDRENmlsWlpH?=
 =?utf-8?B?KzRYQW0reG5aamxsUDVpQjRreC9zWjA3SVJOaUNmNXVMM2dFNTJONGUzOERG?=
 =?utf-8?B?VllneGwrSlpVWFJJMmFGVFg4eDJFOW5ncFJvNHZqd29hWXFXN0dMT1JBOXhN?=
 =?utf-8?B?WTZCTUNCcVpBNytwN3k4d0IvNm1md0dpNHJ1R0l2Ulo1ZVF3UFJKZE9xbVh4?=
 =?utf-8?B?YWJXZHZJL3diY2lzejN2S1ROMkdETUNEdEtTTkthQWM1dEplNi9QdGNMa0Nh?=
 =?utf-8?B?amZTRXRLSzBxVkIzc21pQWIxQjBBQkg5WVpjRXNRZVFlbmpQU1dra1JhSUNQ?=
 =?utf-8?B?NGI0RlB3a1RvZm03aUtkV2x3aHdmdHZqcjdCRHpuSndqWkRUREJnYjNVWW9C?=
 =?utf-8?B?NFJEcmVTejJiVWR0OFB3Uy9UeXgwaHVoM251bjRpR3J0Q1M1WWZraUltRWRE?=
 =?utf-8?B?aWdzL3RiVUZrdHd1R2VFeE9rNDNVOFZRSzJEZENrOEQ3ZUJUa3IwMXNUQWhM?=
 =?utf-8?B?NVdXRTFVNmxBVExaU0libG9FNWxDa2orWVNwbkpVSHgxMnlhSmQxaWFVSEdy?=
 =?utf-8?B?OXRFcC9lcFNVNWRjMXd6c1B0aTFPVUY4M3lIWExsc0ZZWHJYendvSEVPT3oy?=
 =?utf-8?B?MDhXZisvMDhHMnhOQlZ1cy8vRGtYY0V0cFRjSzdZdVRWc1JBRXMxTWwxT2ht?=
 =?utf-8?B?VlB3b0IydUVMWDRsNG5meFlMTlVhZUMyZmVvaEVVQXBndWM3T2ZQWW9wUG5o?=
 =?utf-8?B?TmtKaktsZ3BrSkx6b001QjN5M0VmVHQ5TU4zUk8rV2RMOWJJQU11Zy9EZXRa?=
 =?utf-8?B?SWx1bVpvUysyZE5Wcy9CTFJvdDU0UVZNVGh6Z1kyOE5IU1owNVB4Yzd3WUYv?=
 =?utf-8?B?V0hnTVdxVTR4TEFPbUhscW83bTdjUlMxdmlsS0l1Ujk5L0VpVjZtbSttdjh3?=
 =?utf-8?B?QUo3S2tyNi81ZGJxa2NDclJFT2FxakhsL053QTdWRHpWZzBpYTRTdmY3bUtM?=
 =?utf-8?B?UVN6aHQ2Vmhuc1RtZWd1aGFDaEh4dWVwR0p6U2ltTVBGYTcrT3YrTDdQRFBS?=
 =?utf-8?B?K0JFVDY1V1JoUmVCNHdiVHB6c3R3K0hzZyszUWRsMW0rUnZpZVBvbFRYTzJB?=
 =?utf-8?B?VHc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5aa6463-5b7a-4d18-5112-08daea7aa940
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2022 15:29:37.4226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ITIev6wql9nDaE4VhYgUeQ7cqvWAVHiVRLhP22TC+ZStXMDkEl5Ta6VtBnIokLhVe1a/R0U9GEF2Yk4pGjXog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB8569
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/22 08:32, Ioana Ciornei wrote:
> Hi Sean,
> 
> On Tue, Dec 27, 2022 at 06:09:18PM -0500, Sean Anderson wrote:
>> When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
>> add backplane link mode support"), Ioana Ciornei said [1]:
>> 
>> > ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
>> > by Linux (since the firmware is not touching these). That being said,
>> > DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
>> > also have their PCS managed by Linux (no interraction from the
>> > firmware's part with the PCS, just the SerDes).
>> 
>> This implies that Linux only manages the SerDes when the link type is
>> backplane. From my testing, the link fails to come up when the link type is
>> phy, but does come up when it is backplane. Modify the condition in
>> dpaa2_mac_connect to reflect this, moving the existing conditions to more
>> appropriate places.
>> 
> 
> What interface mode, firmware version etc are you testing on LS1088A?

I tried with fixed/phy/backplane link modes. Firmware is

fsl-mc: Management Complex booted (version: 10.34.0, boot status: 0x1)

> Are you using the SerDes phy driver?

I am using [1].

[1] https://lore.kernel.org/linux-phy/20221230000139.2846763-1-sean.anderson@seco.com/T/#t

>> [1] https://lore.kernel.org/netdev/20210120221900.i6esmk6uadgqpdtu@skbuf/
>> 
>> Fixes: f978fe85b8d1 ("dpaa2-mac: configure the SerDes phy on a protocol change")
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> I tested this on an LS1088ARDB. I would appreciate if someone could
>> verify that this doesn't break anything for the LX2160A.
> 
> I will test on a LX2160A but no sooner than next Tuesday. Sorry.
> 
>> 
>>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 16 ++++++++++------
>>  1 file changed, 10 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> index c886f33f8c6f..0693d3623a76 100644
>> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> @@ -179,9 +179,13 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
>>  	if (err)
>>  		netdev_err(mac->net_dev,  "dpmac_set_protocol() = %d\n", err);
>>  
>> -	err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET, state->interface);
>> -	if (err)
>> -		netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n", err);
>> +	if (!phy_interface_mode_is_rgmii(mode)) {
>> +		err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET,
>> +				       state->interface);
>> +		if (err)
>> +			netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n",
>> +				   err);
>> +	}
>>  }
> 
> This check is not necessary. Just above the snippet shown here is:
> 
> 	if (!mac->serdes_phy)
> 		return;
> 
> And the 'serdes_phy' is only setup if the interface mode is not a rgmii.

This is changed later on in this patch.

> 	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
> 	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
> 	    is_of_node(dpmac_node)) {
> 		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
> 		
> 		if (serdes_phy == ERR_PTR(-ENODEV))
> 			serdes_phy = NULL;
> 		else if (IS_ERR(serdes_phy))
> 			return PTR_ERR(serdes_phy);
> 		else
> 			phy_init(serdes_phy);
> 	}
> 	mac->serdes_phy = serdes_phy;
> 
> 
> 
>>  
>>  static void dpaa2_mac_link_up(struct phylink_config *config,
>> @@ -317,7 +321,8 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
>>  		}
>>  	}
>>  
>> -	if (!mac->serdes_phy)
>> +	if (!(mac->features & !DPAA2_MAC_FEATURE_PROTOCOL_CHANGE) ||
>> +	    !mac->serdes_phy)
>>  		return;
>>  
>>  	/* In case we have access to the SerDes phy/lane, then ask the SerDes
>> @@ -377,8 +382,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>>  		return -EINVAL;
>>  	mac->if_mode = err;
>>  
>> -	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
>> -	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
>> +	if (mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE &&
>>  	    is_of_node(dpmac_node)) {
>>  		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
>>  
> 
> If the goal is to restrict the serdes_phy setup only if in _BACKPLANE
> mode, then why not just add another restriction here directly?



> What I mean is not to remove any checks from this if statement but
> rather add another one. And this would be the only change needed.

Because the current restriction is wrong.

We will interfere with the firmware if we try to touch the serdes when we have

	mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
	mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE

because we managed the serdes exactly when we have

	mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE

mac->features only determines whether we can change protocols.

--Sean
