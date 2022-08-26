Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FA45A1D96
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243786AbiHZAIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244288AbiHZAIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:08:19 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2048.outbound.protection.outlook.com [40.107.21.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62899C8774;
        Thu, 25 Aug 2022 17:08:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBnq1hGrngsqUJdG6Zm05n1Eoxszw6rXJnIgc7m6YMODyUnKuyJKpJXpON6EIzXdbHdvkHE8bIxWXgBegw+vgkYoKoNvmU3mEOAw9o12tTJfyslOx7DJnL8aIvsjAxnlrbsH49jb3cppUSTpXox3XnOGsIjlN+jHFV6cUXvcThjxlqyK+1l4Ei2kt8R39kYtI77JWAMqFiUamniRY8Q9zv9Y70H4FgdRy+RlxhAKf34Vwpyx66Tc9mIMlWzpLblIpu5JvVcPMtXwHdIWTNfMu3H30cLQVNwlCn1AfMm/YzDeAxBGYAdkLXWA8xjSI69dNlUxTEZRbiKiKD+BbX4Tpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cmqfc25JmN2/5RFCB1EzOZtDmsErkU6GoI7j2itHpus=;
 b=SaBtMoiTNcaotHSrvSwgYvzpzZ576NBk3oLACe24Zt7DhhbRH1DMZGjhH9gcrJuCuPKa1Bx9NfFzm2zGLIEURtaFobW8jYn5tTyl42CQ4UdfX26pJfvh/D5HsPo6ttr43wXo1woEzBp+JI3I+nNWVZ9mb/ZLoxGDcWXfAENoh6tFrwr46bIE07cZhtDyjWaihGS9SfnTAhAEdfqWbeT1Abmk0gGDUpT1biX2K2BUKei9HWmx5A4UEtR2gEvPjsJh2GaaOhfRI9NPrlwDFePcRtBpOPh+FoTxtVBLMPP0GmIiEVlt6Jkbi+e0KK4/cOmTxcLwzrx4IISFhMa0bmc/hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cmqfc25JmN2/5RFCB1EzOZtDmsErkU6GoI7j2itHpus=;
 b=h9Q2YwrfD3OFoiKcmjfvRuA44ROdSnAoBe+HcfPOQXaK0lNfKQrEMLV5sfHhFCpv4c69pvMWXlVPxsMCDMjJFXj8RFCLwnbmLPVZejjjm61MbREyINPdYERzy3P6NL+aKsn8oeyqInLCbWgy7t9Q+ouve2ghXFMYJ3BjpuM6bl9r1RSBU36EqYkPX+huWgOZpJipihway3PjnPweb4TjA+BUEfezxJXR4lI/RVFeBpq8OZ5VNBoVADJQTStx3fqvnRlJQSGJ58tdt6jF0248T2by/LnvA8sJOExBpf/8a+JkgR0uTc/rqUVi+VYvGwRbTAdd8tWlKwLshpKl4491Wg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB7146.eurprd03.prod.outlook.com (2603:10a6:10:209::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 26 Aug
 2022 00:08:12 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Fri, 26 Aug 2022
 00:08:12 +0000
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220725153730.2604096-3-sean.anderson@seco.com>
 <20220818165303.zzp57kd7wfjyytza@skbuf>
 <8a7ee3c9-3bf9-cfd1-67ab-bb11c1a0c82a@seco.com>
 <35779736-8787-f4cb-4160-4ff35946666d@seco.com>
 <20220818171255.ntfdxasulitkzinx@skbuf>
 <cfe3d910-adee-a3bf-96e2-ce1c10109e58@seco.com>
 <20220818195151.3aeaib54xjdhk3ch@skbuf>
 <b858932a-3e34-7365-f64b-63decfe83b41@seco.com>
 <68b28596-cd16-2485-87df-b659060b0b0b@seco.com>
 <68b28596-cd16-2485-87df-b659060b0b0b@seco.com>
 <20220825234526.f6pjq56sab4pm6u4@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <a2708113-6e53-3e1c-c3f6-3e9fcbe1f0fd@seco.com>
Date:   Thu, 25 Aug 2022 20:08:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220825234526.f6pjq56sab4pm6u4@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0170.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fc9790e-786b-4a49-f95c-08da86f71092
X-MS-TrafficTypeDiagnostic: DBBPR03MB7146:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hHLMUvzHYCLav2XBz5Q5II9b5+NjODzCCYMJPOb+kDp0hBPfAKlkdzPs7AB6G5Ut/toc+Iq8nI+gRCM6KhekywQhsAelGWwL1PE56mOCnj7gzDbyClq/v0U3t5fMdLwMIwbcrN93cffzUua74Ml67OmU63HttZEHk1w9fUzoAnbrh/SOg/094zbYmYuFP0DT3nb9XDgHMoTRPRZjbYYU1FCQFOt99D1e1a6GWsm4I42aFnVDsd8/1hHMzIhZ67Y9t0Ipz581t8T/8SXFA1BRoRy8PfK1VUxuzIXglWIXFHaA9ehHwP3vgp7YKtmBy2I/zD2gKJ2DbZ2jRZvxNu/dRJBj/QU2RIxhersKxsS0Iar9Td1XevrKHFDDKRNMEsnGBIno3td0SzUeMV2qSKmEMwuoXlreYzzQmBB6XowljjB/BtS7GcrtC1BH+sD3su6xN1F7zy/g09n5L/Mo/LA1CpMpPSgRoFV1YEsTlzj/3qsY14WCnzmJUATNcDbjs8Dk5VOVa4EcWZDYcXttr6/nmu29SoE+VyvvxDwSQHjPW3RacDizI+v25B9eiKM50lkjjZ1/eHJ+PReojZyrHnxgnnA6KQzskyyk5CFOc9bND3YS+aqousxHub/oNrN0TfQzvJsCQbYo8UEKga9JwWd5+Eer6fjYCZhKY/2DxP9Vr3MHIjtjZ6BQheFsRNKCVhShvJSlqAtPokPfQX3K5v8IiS/UiNXmdoK8Nx+ycP03RgB0ytCHqLogsvSXK+WSIFcYrJUgb+jJLJ5Uz7NBh7b7L9ugxQ+PrT8L7KoAX3HRwQXGRMjzrM5z6rtC7K1uW8Jt6UGD5Rm2FcPJXk8rBDcRP7JnYrd4fn3/YtaaKDqE8Uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39850400004)(136003)(376002)(366004)(396003)(83380400001)(186003)(2616005)(38100700002)(36756003)(38350700002)(6916009)(316002)(31696002)(86362001)(52116002)(53546011)(2906002)(6512007)(26005)(54906003)(6506007)(7416002)(6666004)(8936002)(41300700001)(31686004)(5660300002)(66476007)(66556008)(66946007)(8676002)(6486002)(966005)(4326008)(44832011)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGpQcHRiS1grakt4YkRpcG9HcS9FeHM2TEo3K20rU2x3UkZoU055eXhMODdU?=
 =?utf-8?B?alMxdi81Y0ZoeDRqdTBDQ2NURmFTVSs3emhaM09kc2gwMFBTaDdSdHBBRmRR?=
 =?utf-8?B?d0ZFQ3dLZjdPWmpnNll6NmZCeXVHcm14c2hOeTNpZ01LTXI5blcwRURnQ1F4?=
 =?utf-8?B?eWs5cEZITlVPWFc4Qk0rRVNXOFNSNnFWR0pxY24rdXhzbmNRQWpTemRhaWYx?=
 =?utf-8?B?T1hDNVN5ZzZOdVpsL1JkM21nQnpIM0FuZXFjR3FiSzVOYUw5TGt0b1Z6cy9U?=
 =?utf-8?B?Q2RYQjZqbW1iR0hTSm96eDNKT0xWRE1KU09DSmRtTEhCU3hWdWkweHg2WTVP?=
 =?utf-8?B?WEhJODF5V2xhbHNDdks0NWJCbjU4eGxFWHZMWFQxa2d2RGw1UWRUZHUzRExK?=
 =?utf-8?B?SEVueW9Da3VLb1lLK1FkNzBqZllhaHcvWGl2YjFrUXB1NHo2eDRHVmk5SVk0?=
 =?utf-8?B?SjRKdUd3bmZYb3RLUEtIb3M2RDM3ZVBabHV3OElrWkR6V2cxU29rajJxdXUz?=
 =?utf-8?B?aFUxUXIwWkNHNzdvQlptZkVvUEFaQ3FjUkRPYWJNdCtPeGUvMTJNQzVnV1Yy?=
 =?utf-8?B?eG1KYlZWSHplSkV0eEpkOU1DQWY3dDBiRDN4MXhjRER5SlVWdFRhcFExS3Zy?=
 =?utf-8?B?QjkwWWFaOVRFYkpkYVNMWnlhZE5kSGRaKytuakJ1dU10bXlJM3V3K3pYRE1Y?=
 =?utf-8?B?MW90VlYzNFJZMDZ0cndzalpKWTdPV3NyU0RLN3FkcFRDU3RPdHdKV2NFZlU2?=
 =?utf-8?B?OHV2SlJUWUVZaitjZ1prMzJNakRFNVM1d0Y3QzNWV2ExWWw2eHRFMzUwRWFM?=
 =?utf-8?B?L0VBbnYwNnh6UlZqL0VCbFFBb0Y3N2JrancwN2RiNjVxUjU1dURxbW81Tzh4?=
 =?utf-8?B?MmRoUzhmaEVjMENZNldzajNaYnI5TjdaMnRtdjZLenZ6RFViOUxaYy9BbXRk?=
 =?utf-8?B?MzZyVkswWjZPdkhSVy91aXF4RzRnM1pIM1V3bnVVeU1rRHBIWEJJc1UydW1G?=
 =?utf-8?B?ZVBwd2RVMjM4OGFMdDQ3UGxFK3E1REV2R1RBTmlzUHRnM0I4aUI2VlZEcjRD?=
 =?utf-8?B?SEhLdWZ0YkJGdE0vNXJWTWJHMDZQZTFoNzdpVS9qNWg1SXpZN0M1Q2w5WW5l?=
 =?utf-8?B?TWdmWWRPd3NNRjM1VEFoc081REg5REFRcnkyWGtjQzgrWmlzbWdBOXp3L3cy?=
 =?utf-8?B?N1p6VUNTMVhoVTRyNUtQZGZVWVVsdjRCVnJuR2VjcXROdW9nclZKZG1jRC9G?=
 =?utf-8?B?c2F3MG0xcFFYTWw2bHM4bk9JVXNrOGZUeFlxSEFXMUhzaElzL21tc0swemgz?=
 =?utf-8?B?L2VRdHFFUkJiRWxWYjRyR0JobXVlOHVnQWFFVHFpaTNNeVh5UVk1U3V2L1Yr?=
 =?utf-8?B?RVNsdW1IRysrQ1VDRDE0U3ZzZ0djdjlCNGNsRUFXbzAzYjJvbEZCSGZEMXYy?=
 =?utf-8?B?bUVHYmtzNnE4TW9qSm9CZGNNSnpmcnR3QXBlVEYwdmliUjY4enpVTEtYbnlD?=
 =?utf-8?B?VTdGdHpZZkNaY0tiQzFISm5lWFluZFFrQ3hUenVCRnZOZExBUmdhMXZuOENO?=
 =?utf-8?B?S2RuckxCL29HUGYwd2Z2UjFrVHlBMjFrUDhiSVp0d1lUL3ZLcnI4TitpK1E4?=
 =?utf-8?B?NCtmSG02L0k4aENsa0RtejJGZW1Sa1RkT3RhNUtqU0xJQlFsRjUxR24xanZx?=
 =?utf-8?B?ajJDMkxMenR2Rk5wNktkeDVBK0JDZ2VkS1B6MVpqMS9GaTNJTFNkWW0vNGU0?=
 =?utf-8?B?STlOcSswdjg0QXRyRGpabEtZckorUGpKVTk2Vm9kU3RBMm9zSEZGTHNCNFZ5?=
 =?utf-8?B?NkNPQ1RsaDhaSGt5U1MzMzIzVzN6SFZLaEFBNTZqeUs5WmpraGk0eHlJOWM1?=
 =?utf-8?B?RG5qditTVnVkeGdYKys4Yjg2VXQxcnpaUXQ2SjZqTEtiWXMzZThpVm9CbHZR?=
 =?utf-8?B?OEk0d1R1NUFUWWNrTjBNVC8wQkdDTHhWZCtTbHlFM3lUQWZvUUR1M2NXRXBz?=
 =?utf-8?B?SlBrMEtJNS94MDhPc1FjbCtOT0puZnFPMjE2aVY1ZE5Td3pPMkRNdUZwRHhJ?=
 =?utf-8?B?dmw0aHpGRjZEc3ZjdTRuTE1jSS9FSkJ3RDZHQzArT1JzTE5XMG5LT1AwVTNF?=
 =?utf-8?B?c202Q1BxaXFmWnZCY2xheXJNNkZWVW04Yzh4SGI5VTNrWFdSdzdaWjhDWHJE?=
 =?utf-8?B?SUE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc9790e-786b-4a49-f95c-08da86f71092
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 00:08:12.1489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VoBh8fpI4gApd4AnMYeCFvmisCIoDYWD5cUCvxSNkI16lyykwRYrsXcotqKjyJvkSxj1teCaGJ0vOkGsNitvUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7146
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/22 7:45 PM, Vladimir Oltean wrote:
> On Thu, Aug 25, 2022 at 06:50:23PM -0400, Sean Anderson wrote:
>> > The problem is that our current model looks something like
>> > 
>> > 1. MAC <--               A              --> phy (ethernet) --> B <-- far end
>> > 2. MAC <-> "PCS" <-> phy (serdes) --> C <-- phy (ethernet) --> B <-- far end
>> > 3.                                --> C <-- transciever    --> B <-- far end
>> > 4.                                -->           D                <-- far end
>> > 
>> > Where 1 is the traditional MAC+phy architecture, 2 is a MAC connected to
>> > a phy over a serial link, 3 is a MAC connected to an optical
>> > transcievber, and 4 is a backplane connection. A is the phy interface
>> > mode, and B is the ethtool link mode. C is also the "phy interface
>> > mode", except that sometimes it is highly-dependent on the link mode
>> > (e.g. 1000BASE-X) and sometimes it is not (SGMII). The problem is case
>> > 4. Here, there isn't really a phy interface mode; just a link mode.
>> >
>> > Consider the serdes driver. It has to know how to configure itself.
>> > Sometimes this will be the phy mode (cases 2 and 3), and sometimes it
>> > will be the link mode (case 4). In particular, for a link mode like
>> > 1000BASE-SX, it should be configured for 1000BASE-X. But for
>> > 1000BASE-KX, it has to be configured for 1000BASE-KX. I suppose the
>> > right thing to do here is rework the phy subsystem to use link modes and
>> > not phy modes for phy_mode_ext, since it seems like there is a
>> > 1000BASE-X link mode. But what should be passed to mac_prepare and
>> > mac_select_pcs?
>> > 
>> > As another example, consider the AQR113C. It supports the following
>> > (abbreviated) interfaces on the MAC side:
>> > 
>> > - 10GBASE-KR
>> > - 1000BASE-KX
>> > - 10GBASE-R
>> > - 1000BASE-X
>> > - USXGMII
>> > - SGMII
>> > 
>> > This example of what phy-mode = "1000base-kx" would imply. I would
>> > expect that selecting -KX over -X would change the electrical settings
>> > to comply with clause 70 (instead of the SFP spec).
>> 
>> Do you have any comments on the above?
> 
> What comments do you expect? My message was just don't get sidetracked
> by trying to tackle problems you don't need to solve, thinking they're
> just there, along the way.
> 
> "The problem" of wanting to describe an electrical using phy-mode was
> discussed before, with debatable degrees of success and the following
> synopsis:
> 
> | phy_interface_t describes the protocol *only*, it doesn't describe
> | the electrical characteristics of the interface.  So, if we exclude
> | the electrical characteristics of SFI, we're back to 10GBASE-R,
> | 10GBASE-W, 10GFC or 10GBASE-R with FEC.  That's what phy_interface_t
> | is, not SFI.
> |
> | So, I propose that we add 10GBASE-R to the list and *not* SFI.
> 
> https://lore.kernel.org/netdev/20191223105719.GM25745@shell.armlinux.org.uk/
> 
> I don't have access to 802.3 right now to double check, but I think this
> is a similar case here - between 1000Base-SX and 1000Base-KX, only the
> PMA/PMD is different, otherwise they are still both 1000Base-X in terms
> of protocol/coding.

Well, the main thing is that the PCS has to know we are doing c73 AN, as
opposed to c37. Maybe we need another MLO_AN_? Or perhaps the PCS should
look at the advertisement in order to determine how to advertise? But
then who determines whether we do c73? This should really come from the
device tree, and not involve userspace manually setting up the advertisement.

And of course the serdes has to find out what the link mode is. I suppose
we could stick this stuff in the device tree. Maybe using ethtool link modes
for phy_set_mode_ext is better, but it's still not ideal since many link modes
are electrically identical (we don't want to special-case full/half duplex in
every serdes driver).

> As for the second "example". I had opened my copy of the AQR113C manual
> and IIRC it listed 10GBASE-KR in the system interfaces, but I don't
> recall seeing 1000Base-KX. And even for 10GBASE-KR, there weren't a lot
> of details, like what is configurable about it, is there C73 available etc.
> Not extremely clear what that is about, tbh. Something that has
> 10GBase-KR on system side and 10GBase-T on media side sounds like a
> media converter to me. Not sure how we model those in phylib (I think
> the answer is we don't).

I'd agree with your assesment that it's a media converter and that the
documentation isn't clear. However, it's fairly trivial to support in the
manner I outlined. That's actually the main thing I'm getting at: the rest
of the code is structured to treat a PHY_INTERFACE_MODE_1000BASEKX in the
right way, even if it's not really a phy interface mode (...just like
1000BASE-X isn't really a phy interface mode).

--Sean
