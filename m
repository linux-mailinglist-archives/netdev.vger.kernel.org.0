Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC1057D643
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiGUVsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGUVsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:48:15 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10059.outbound.protection.outlook.com [40.107.1.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD89493C0F;
        Thu, 21 Jul 2022 14:48:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArekQ4ifvYOQzcO93Q0ln8/iOVNkMtCRLRNSaOJTCXi72m7WroD85pOtzvmF14YhslOjTJkLlAfMoxiVroR7kEqSgWo7Oa4apldsv7gdPXKkEqHNzLyIQs5GSJf8Q2Q+bURXvQ2BpQVj7SUqH2t5AxudH8v/d7CK46wlZ8TYaP3VKjhf+O3mdJL+5QRQlhV4FfGsaWDKGa7Nmy43mBYL5tfRtj0V+xXdFTKeqnhXC+zM+rhGD9bNUhy3gGUG+Np88N6VpSaRCSS3EbW32CIMLgkXFSZ6d5mi1aDjwlVyW08TFZRLNswllC2Wnh/n5sCU1oc2Tu8rQSQn/j6sxA6vFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPBmhPuacr52CdA/gBcXdLtqx47YWWsop6YZRV/WWrI=;
 b=JWmzfUJqVJemzD1LZU4SR5ye3lL4McbbxWTvAdXV+IZ86ojoPxG56pmgywz2Rj6+ZZ48y0mBY0ghrUPN58PO9PhPq0RviNU2+wwNssevWxXL71tpwU/zls/8Osq4MqHIm5TI4FmDjXFzqRxoqgnh6fkszK/qwvi/BjGpxsTrPiqit6LnBV6F7rabslx/nrwEqF6RPTMCg7dciLHySXBrkQCTNu3r37qr85jxKRllHnQHVsSBJxcaRAarDrGj4BLuKJYlwUzlWAdKssj7s4/4GwIPiQxlteTNlHdp8QtfqNImJ9Tc6RQht1CGGPXkTq52kXhRdoKQ45HJVUf31fufXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPBmhPuacr52CdA/gBcXdLtqx47YWWsop6YZRV/WWrI=;
 b=my5i5B6KX6fFrZLdt3sG14Ub/enVgEoARSyhsf9mqSLpi069BGfuHUhWuLPFD506SpcrKI8v+JiV9uoybfDAbQmGvZejJNDNNGqQNPqsphoLIpeyi9w8B76lQk/qWaV/o2iDJ5ksCQPHtdbAYYfndijpLpCwgaZteHSujILBgSuQZCrGL6Jj2He8B/3rZbBzP8yqNSiW48DeiGLRMmEI35qPNod8HLbQ09sCafzQWH2Eo3vOT3ITHXr+L/mZTjJ4lPCtkIYiz3WYsjktWtfVW8UpGcIeylMeQGwIe1jqGl0EVCdHptsOLoDEacAW+mulL72tORGYdSVp+N1eB+0dyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7886.eurprd03.prod.outlook.com (2603:10a6:102:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 21:48:10 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 21:48:10 +0000
Subject: Re: [PATCH v2 07/11] net: phylink: Adjust link settings based on rate
 adaptation
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-8-sean.anderson@seco.com>
 <YtelzB1uO0zACa42@shell.armlinux.org.uk>
 <YthKSYje5e+swg08@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <84f4f37e-044c-0fd8-7ba4-cba54200d9fe@seco.com>
Date:   Thu, 21 Jul 2022 17:48:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YthKSYje5e+swg08@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR17CA0032.namprd17.prod.outlook.com
 (2603:10b6:208:15e::45) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9bd6f39-329b-41f6-dd03-08da6b62b42d
X-MS-TrafficTypeDiagnostic: PAXPR03MB7886:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1KXvCByGt/NbnBjq4mCpJq6syQWO3k2UXCcVqPGjYsGqeCs4dWvvMlCUDnUVYGMeXar2gpAzbAR+TNOBDvisA3KAK71A9lj1ikR0qw19zHKAuUkNByzLQ+rY92201mLizG1jNZChYzFq8fO+VDXPi7yk6LNvyWfyNuoV8jiYUqQ+xSxLSRNSd3ZffK8jKumjVAYbmmTHjjz/Aso9eJ4Z8R7pf4Ick0rwfFmMKOWUacMKRnTxBjpRjdKpoHtiXCoOioYsM1SANQAp3mkiG95u/tlSJS9I0tFLWu85B4R/m5CHIK0KzQIkAPsFSEAoNKj3MhFt/x/aQvDQSWMR9UZ4Zbfe61DiTFfmozlMwr7cV6rTz64UIHVcUt+LdkOlI/CDKhpuHLtb1Wff5cPaPzyYjsmD7vguPs181LcVy2awi6ZJceY/kB92O7pxrv0h0jZuQaWL4V2WJTzMfY4qIUUQVA5pqxlm1g4WTzEZbhfgiWyl6kztq4GX7c1wYURhVAXZk6cqpsz5aUFQ6Hw9YV7GUb4rzAzg+DEbiSijtBT7n085F73lVP8sfTJs/fgTctT5n4Hj8ypRIhKHqSblk5rFZT5CXQFg/dRdJiPpSyLjzAcqg5Ng52zpg+AcAm24eF/l8RvH9H1m7xuZhw66Mo4R4hV6o+X6uXaxHnjEpvU3oupv7J0C7uxSXY7S1DaWJMRZ9kSxtq9IwCL5c1aqmUkmtbDTikvfQrW0ePpi8mmm08WFfZaoojqpBbHdw4SU1yYeiK/l9bAORd5euoN5Vou1J7cTrAsRA0+seWdsjdHmNK/1G5aGgZ+HxqamKOm68zlJsXEpMX+3CRmZDhJfpkJFZVro7YoQPeRM+lqThZrxGvwzAqRg5tn1NMdRkdgYk0n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(39850400004)(136003)(376002)(186003)(2616005)(83380400001)(2906002)(6666004)(31686004)(41300700001)(478600001)(26005)(52116002)(53546011)(6486002)(6506007)(6512007)(38100700002)(6916009)(31696002)(38350700002)(36756003)(44832011)(4326008)(86362001)(8936002)(66556008)(316002)(7416002)(66946007)(5660300002)(66476007)(8676002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THVRSVRZV0oweE9KVjJna2hDL2VtK0U4UW94cFBTaDlCb1dYcmJCNjZvZ0FP?=
 =?utf-8?B?QkZycnNESjhPMWY5SmxxMWZhdlN0bVRvUnQvMFR6dE4xbGtUaDVQWXk4Z3Bu?=
 =?utf-8?B?N1B3dVVXa2JIa3BOR3pyZU9UaDltZjZzQURlc1EvUUJSUzdVM01KeWxLYVM0?=
 =?utf-8?B?SGt2MTNwZWRGREpXOHJkcHJFcXVBcUpuSkkyZHFaN042SElEOHd2ZkpWK0Mr?=
 =?utf-8?B?bU14ZXpQY2lWNm9walgwMHJhY21NRnI0MTFud3VWeE85MExENUlZdjJJeFlS?=
 =?utf-8?B?QzQvem1OaTJzOVdWSjlGY2lXdmFZb0tpMkZkRnQ5MFE4WEhMN255VEpPRDFZ?=
 =?utf-8?B?UkhvakFDcWZGVGZxMHJGMXFNVkQweGhubVUzbmk0SjJjR0lMQ0FaazJNSUdV?=
 =?utf-8?B?ODVBZ3ViSWtBeEZVakRNdTZnMlROZy8vRTR5OUF3S0xXZ3RjeUxMelEzNEhX?=
 =?utf-8?B?RnAwV1ZFby9xK2Z2TDhOTThubCtyb0QvTjY5OHZ5SVFVRlFYVDFGcXhDc2Vv?=
 =?utf-8?B?SzlMV09mQk1hWGhDZ0wrc0MrZDJiUi9mUCt4M1ZwdTJrdjY4NHR3WnFMd0Fw?=
 =?utf-8?B?ZkluYzJObWNSWUF1SnpsODg3N0gxdi9lVmx4RWpNSGMwbHRYc3hjZnZKYkt0?=
 =?utf-8?B?Ynd5bnR3bzQ1REVHbU52NzdQK3VqdnFvNkZwU1lqTHQzOVlMT1VjeHVBTzlj?=
 =?utf-8?B?enQ1UEZqb0d0UEI4YmlOa3lCZURoZWhWcXpWcTBUd2VmRHJnVnlaNE9EeUJN?=
 =?utf-8?B?UlNWSE5rcldFTVUwYWN3eEpxNTcxcDI3eGkvNDJRSVhxQkxYNTBXK1lBS2d6?=
 =?utf-8?B?MW9PQUhqSUNCSmQ2bzFRU25vU0VDdUJXUzF1QVpGUTV1aEgzaTFwdmtnamxi?=
 =?utf-8?B?ZFZnTEVyUzhvK3p2UDRyYXdNT0liZnlJSGFsZGh2RzY1SkgwOU9lYkRZYktT?=
 =?utf-8?B?cGlwQmZEak1pRmQ5L1YyMzJlUmJocmxmM3ZLeXg3ZEpnRXkyN3FDQWRtMzJJ?=
 =?utf-8?B?M0JTdXkxSk9iN1ZONEZqSm9lL3pPVDBJaUt4U214TkJlN3JGS3hqUktDcTFx?=
 =?utf-8?B?bmR2N1IzUDJkNk5oWVc4c2ZFOHlTdHVweXBCTnR5ZTYyeWpuSENOd0l2MGVP?=
 =?utf-8?B?VEYxMkd4MjdQSXNZSHBWbE9WWjI3YjA1NGpROXNuYmVYcHVOWE1QQUxSUHZ1?=
 =?utf-8?B?TWhIckRMaFhVVG1BNWpmdlh2eXZvbVRRNW1TNjdHR2FJTnNUM3p0WXNOQ2lh?=
 =?utf-8?B?bjhqVnpuM0EyWGluSlZlRk1lV3pyWEQ4ZTNtYlZ3NlRMMVRVWFNET0lNVVVh?=
 =?utf-8?B?djVQVGtFdVBQaXh5WFdjbFUzazhvblg5ODBkMXFsU0NIVEw3YXNjc2dSaEJI?=
 =?utf-8?B?V2E2cE15N1N1N0Jrc25FQktFNFZNQW5qL3FpVkhlRFYvd1NIaHI5TUxoVzFn?=
 =?utf-8?B?T3BBSjNmNlFHMkFHRU1LMVFoOS9FUUVIdGRHdGVnTWFnVVVrRDJqTUdwczJQ?=
 =?utf-8?B?NWMza0RSait4b05reUxpNXl6QVY0QWtPUFRJOW5HMlIwZmJpQ1NwUHpXU085?=
 =?utf-8?B?VXI4YXdzSngvdnp3NGZSRlQxd1pjS05HUm55ZVlUUG1PYjBHMHo0QWVPY3J2?=
 =?utf-8?B?REEwNFo5eE1FNkVxNzR5WDFyb2xTelZQcUdEcVhnU2p6YzZjanlqVm1JZjNl?=
 =?utf-8?B?WUpSTEZSRSt5aTI3QktoR2ZsbzA3VU14ak5BbjU0cHp1Y3JCdlFFSWp4ZXYw?=
 =?utf-8?B?UGtKczNQSGh0T0tjaDBKS1F4OWpqa0t6YmdvWitYVlJwaDFoTWZoeFVZSDRR?=
 =?utf-8?B?aHNmMjhvbXluTTJoYlJUMjJPZW9nK0tvNTk2aFMxaEpFdmh0RC9CbWZCU1hY?=
 =?utf-8?B?aERxSFB0bWprQXBaTmQvVjhraUFiTUlndUpBeXNOeSsxRGEzS01rOEM5ak1i?=
 =?utf-8?B?ZnFVVTRoMFNXaFVTVjNpcXdxam84bzhUNzZCd1dQdzZSK1hUNTZuaHdNV01u?=
 =?utf-8?B?ZVlLMzZsU0pyWXRRcXUveCsvWE5MMGpJalRmdlRIOHF2cUhZVGlhWmRiMW5T?=
 =?utf-8?B?SXVtSUNNWWtNZ0VzMUdSRnBhUDYvamRCK0xnRWZ4RWtEams5UUNOTW5WMUdi?=
 =?utf-8?B?ekcxbGR4b0UwT0ZQU1VRenhhRkE3QTdiVTdKeW1BdFJZeThoTWllbGhHekVi?=
 =?utf-8?B?M1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9bd6f39-329b-41f6-dd03-08da6b62b42d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 21:48:10.2249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: krjf3fFC8q+rD2KLHsBRPQg+yazbpXVQr4RpemSE+w27su+g46urc3WCDw2i5pme1sG3nhoonlg0cU1V9HTiqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7886
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 2:32 PM, Russell King (Oracle) wrote:
> On Wed, Jul 20, 2022 at 07:50:52AM +0100, Russell King (Oracle) wrote:
>> We can do that by storing the PHY rate adaption state, and processing
>> that in phylink_link_up().
> 
> Something like this? I haven't included the IPG (open loop) stuff in
> this - I think when we come to implement that, we need a new mac
> method to call to set the IPG just before calling mac_link_up().
> Something like:
> 
>  void mac_set_ipg(struct phylink_config *config, int packet_speed,
> 		  int interface_speed);
> 
> Note that we also have PCS that do rate adaption too, and I think
> fitting those in with the code below may be easier than storing the
> media and phy interface speed/duplex separately.

This is another area where the MAC has to know a lot about the PCS.
We don't keep track of the PCS interface mode, so the MAC has to know
how to connect to the PCS. That could already include some rate
adaptation, but I suspect it is all done like GMII (where the clock
speed changes).

The only drawback I see with this approach is that we don't use the
MAC/PCS's speed/duplex when in in-band mode. But I think that only
matters for things like SGMII, which (as noted below) probably
shouldn't use rate adaptation.

> A few further question though - does rate adaption make sense with
> interface modes that can already natively handle the different speeds,
> such as SGMII, RGMII, USXGMII, etc?

Generally, no. I think it's reasonable to let the phy decide what's
going on, and just do whatever it says.

>  drivers/net/phy/phylink.c | 103 ++++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/phylink.h   |   1 +
>  2 files changed, 100 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 9bd69328dc4d..c89eb74458cd 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -994,23 +994,105 @@ static const char *phylink_pause_to_str(int pause)
>  	}
>  }
>  
> +static int phylink_interface_max_speed(phy_interface_t interface)
> +{
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_100BASEX:
> +	case PHY_INTERFACE_MODE_REVRMII:
> +	case PHY_INTERFACE_MODE_RMII:
> +	case PHY_INTERFACE_MODE_SMII:
> +	case PHY_INTERFACE_MODE_REVMII:
> +	case PHY_INTERFACE_MODE_MII:
> +		return SPEED_100;
> +
> +	case PHY_INTERFACE_MODE_TBI:
> +	case PHY_INTERFACE_MODE_MOCA:
> +	case PHY_INTERFACE_MODE_RTBI:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	case PHY_INTERFACE_MODE_1000BASEKX:
> +	case PHY_INTERFACE_MODE_TRGMII:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_GMII:
> +		return SPEED_1000;
> +
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		return SPEED_2500;
> +
> +	case PHY_INTERFACE_MODE_5GBASER:
> +		return SPEED_5000;
> +
> +	case PHY_INTERFACE_MODE_XGMII:
> +	case PHY_INTERFACE_MODE_RXAUI:
> +	case PHY_INTERFACE_MODE_XAUI:
> +	case PHY_INTERFACE_MODE_10GBASER:
> +	case PHY_INTERFACE_MODE_10GKR:
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		return SPEED_10000;
> +
> +	case PHY_INTERFACE_MODE_25GBASER:
> +		return SPEED_25000;
> +
> +	case PHY_INTERFACE_MODE_XLGMII:
> +		return SPEED_40000;
> +
> +	case PHY_INTERFACE_MODE_INTERNAL:
> +		/* Rate adaption is probably not supported */
> +		return 0;
> +
> +	case PHY_INTERFACE_MODE_NA:
> +	case PHY_INTERFACE_MODE_MAX:
> +		return SPEED_UNKNOWN;
> +	}
> +}
> +
>  static void phylink_link_up(struct phylink *pl,
>  			    struct phylink_link_state link_state)
>  {
>  	struct net_device *ndev = pl->netdev;
> +	int speed, duplex;
> +	bool rx_pause;
> +
> +	speed = link_state.speed;
> +	duplex = link_state.duplex;
> +	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
> +
> +	switch (state->rate_adaption) {
> +	case RATE_ADAPT_PAUSE:
> +		/* The PHY is doing rate adaption from the media rate (in
> +		 * the link_state) to the interface speed, and will send
> +		 * pause frames to the MAC to limit its transmission speed.
> +		 */
> +		speed = phylink_interface_max_speed(link_state.interface);
> +		duplex = DUPLEX_FULL;
> +		rx_pause = true;
> +		break;
> +
> +	case RATE_ADAPT_CRS:
> +		/* The PHY is doing rate adaption from the media rate (in
> +		 * the link_state) to the interface speed, and will cause
> +		 * collisions to the MAC to limit its transmission speed.
> +		 */
> +		speed = phylink_interface_max_speed(link_state.interface);
> +		duplex = DUPLEX_HALF;
> +		break;
> +	}
>  
>  	pl->cur_interface = link_state.interface;
>  
>  	if (pl->pcs && pl->pcs->ops->pcs_link_up)
>  		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
> -					 pl->cur_interface,
> -					 link_state.speed, link_state.duplex);
> +					 pl->cur_interface, speed, duplex);
>  
>  	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
>  				 pl->cur_link_an_mode, pl->cur_interface,
> -				 link_state.speed, link_state.duplex,
> +				 speed, duplex,
>  				 !!(link_state.pause & MLO_PAUSE_TX),
> -				 !!(link_state.pause & MLO_PAUSE_RX));
> +				 rx_pause);
>  
>  	if (ndev)
>  		netif_carrier_on(ndev);
> @@ -1102,6 +1184,17 @@ static void phylink_resolve(struct work_struct *w)
>  				}
>  				link_state.interface = pl->phy_state.interface;
>  
> +				/* If we are doing rate adaption, then the
> +				 * media speed/duplex has to come from the PHY.
> +				 */
> +				if (pl->phy_state.rate_adaption) {
> +					link_state.rate_adaption =
> +						pl->phy_state.rate_adaption;
> +					link_state.speed = pl->phy_state.speed;
> +					link_state.duplex =
> +						pl->phy_state.duplex;
> +				}
> +
>  				/* If we have a PHY, we need to update with
>  				 * the PHY flow control bits.
>  				 */
> @@ -1337,6 +1430,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
>  	pl->phy_state.speed = phydev->speed;
>  	pl->phy_state.duplex = phydev->duplex;
>  	pl->phy_state.pause = MLO_PAUSE_NONE;
> +	pl->phy_state.rate_adaption = phydev->rate_adaption;
>  	if (tx_pause)
>  		pl->phy_state.pause |= MLO_PAUSE_TX;
>  	if (rx_pause)
> @@ -1414,6 +1508,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
>  	pl->phy_state.pause = MLO_PAUSE_NONE;
>  	pl->phy_state.speed = SPEED_UNKNOWN;
>  	pl->phy_state.duplex = DUPLEX_UNKNOWN;
> +	pl->phy_state.rate_adaption = RATE_ADAPT_NONE;
>  	linkmode_copy(pl->supported, supported);
>  	linkmode_copy(pl->link_config.advertising, config.advertising);
>  
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 6d06896fc20d..65301e7961b0 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -70,6 +70,7 @@ struct phylink_link_state {
>  	int speed;
>  	int duplex;
>  	int pause;
> +	int rate_adaption;
>  	unsigned int link:1;
>  	unsigned int an_enabled:1;
>  	unsigned int an_complete:1;
> 
