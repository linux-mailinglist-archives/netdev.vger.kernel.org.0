Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEF76247AF
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiKJQ4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiKJQ40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:56:26 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2073.outbound.protection.outlook.com [40.107.247.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA0A1903F;
        Thu, 10 Nov 2022 08:56:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZAdxyPT8xgGmeBbPcleOP/e75U38/yluiseyc5ZvQJoNCjXaOkoGGSjasviLzwVrCxHa+xSKbXjNc3niTl3f6ZM1vKcbSg272pv3sv/adRsOxIFbQ0kRHeGNPiQ6tdG6X0ck+5R1bSBJCyArlx2lIwwSzozkhpasMftzhiCNd9IJhQkjegHJjzTXDxoy++9CI69WVqueUzdREUZF/RdQXRlxaKJpDlcLWQhzZvAzffmdFPzTqFSR84qi0N1diwyIHwRvbHgw3e8jMV7TOo35Ja7NnAdzwVxJzF+cemL2NFdVlnzjREcHr9yLDytyD1FdsMA1PAMGG5E849W4cWznQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8Hz+Bk9EQflfkT2+GO5wfHftgoEuT8PjxVbwU7V35M=;
 b=LLODOpOD5cPNzD0MSRhdFNXyS/kPrmlkNCaCc3ymYSXzszbttKzGwNoDiMtAh+xVfSqPjm49RDR4nH/GxdtmZuG/3+oHdskWRv3arK+bRhdFbsZXqjcXSqwOedhjWnxAY1Y3yCug3HXq1iAT5w03NDsXjtHmlKyG4wBPqcUbF0rKTEkjltgeTN9EMDHg0tFeV2z6c9Uy7W2Ib/L7tCYtv7EEhd+ej2CV8UsZ4bqac/pLB2+fDqBnc3OHC/NmQiP8HJAssDSHZ/aJOaegUWaYRLpiHNIHlOixb8ViyERov8nskADX6zsWXcOLurPV3I9SCbsPnpGXKxSSujjUGxY9Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8Hz+Bk9EQflfkT2+GO5wfHftgoEuT8PjxVbwU7V35M=;
 b=Hj13MswtM9lDiw+BJTCKykLuNbXIPeCRJ9SB+kU+0DrjQ23VJZl7ZRV+jIzSJAHWv2WWuapDmr2vZ+9eVBKpaQQzUb9l80QDFU/p9suOvKcuPjJGuM+9uheS3HtH9rGX/ywHI/HnGY0mYrz6Sy/AMjvsioGB0yegwDpg8O3jr4jKj5SBH636Vz7F1bMYRbxkeosovdfOydvwDIOtf7QXOzHNa6vZH+A0XYI9YqXOVMJCnXnIm/y0w0TJ4x5Qw+7DWemXqJvsEY6BKzgKxIu5epu5MNghAnAUFDvXlz98gr/VvmCMQRwexZkqHdqPUlELxAY3EiIoKvYnVc9ecdnP+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7905.eurprd03.prod.outlook.com (2603:10a6:20b:420::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 10 Nov
 2022 16:56:21 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 10 Nov 2022
 16:56:21 +0000
Message-ID: <ce6d6a26-4867-6385-8c64-0f374d027754@seco.com>
Date:   Thu, 10 Nov 2022 11:56:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf>
 <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
 <20221110152925.3gkkp5opf74oqrxb@skbuf>
 <7b4fb14f-1ca0-e4f8-46ca-3884392627c2@seco.com>
 <20221110160008.6t53ouoxqeu7w7qr@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221110160008.6t53ouoxqeu7w7qr@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0035.namprd10.prod.outlook.com
 (2603:10b6:208:120::48) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7905:EE_
X-MS-Office365-Filtering-Correlation-Id: 19bae4df-7afd-427e-6ce5-08dac33c7e47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6O2F6/6PHjGnleEuq22jQFo6nnVbPvwQc4egQjd4VZ2Kdri6v8VdOn4XKehKepLlbhj97syRULn9mpC9fGDH9Bjv7cA5+LZAkHiG4kbOuPUudKTV9XJ5CFIgenOv+CBUgDFHPp1poymqijUUQiPEqFgnXFAsgqLI4vFdvNNfLq8JjMCMc+E3wjgZGjXTgxzq8PsOREzF8/407f9xPkGS7rHue6vgWKyd1kmxAR6iuQ6In+2GHfqU234ix6wWaCUNhj1vDsoDdc30gxSWMetvbHhMsOr+m+FD/VLDl4NdCVlarNUm15ZwdLheFBVPtierdTtjXquJfThIzN2rBNn5wsVNkehcD2FZikmpR7YyjObnSz3nJ2xMhPnkaXTkFvkmsjvj8x61FTCBkZhbyQiJRgWzLi3gUykkRHDEXUcGyVSX+psf6ntWHpRojJ3BuaNBhcQj1ghD4UpxxQDjoWb32PwktlxRM7/8wcTor8sdsD+u16DIDdnb0dGeiZCcKtsZuJHNftqez+V3oc+apZQ4n1VszX+TDjD8rPotWv1SgYPNZdwQEwBZ91fOlqAnbZ86GklwajFD2CP2gwLfxt9U2sZqAP5VnVTBanjNZK0v9BpRLzK1hFZvRBPcxYcky0hIccaH4bX/UIiWbR9furjhgNRaJm9FUPxRI8Ok5Fj992aCDObs+uddlrc8qOV619mW9ouBflyIuJj4E/ulejERUaWNDFa9bcx8j21yI69pczAP7zb0BhQi7KF0InT/ot6kfCjZrCN2SHJ14pWkmO9RtZxMDZU00KK+xQOE514TqtYNyH95pMVA8zI+pzL6KuFL2JKsZpFV8Dxhj++mCicSTySwm2TJSyA7htEW4YJ3BS0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39850400004)(136003)(376002)(346002)(451199015)(66946007)(41300700001)(44832011)(966005)(6486002)(36756003)(8936002)(7406005)(7416002)(83380400001)(6666004)(2906002)(66476007)(316002)(66556008)(8676002)(478600001)(5660300002)(54906003)(4326008)(6916009)(186003)(31686004)(38100700002)(86362001)(38350700002)(26005)(6512007)(53546011)(2616005)(6506007)(52116002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WW9vRmJyN3gySmI1WDVjTkpaYjNLeXBVNzNKaWF2T1RNQXNaRWt5MVU1YmJ5?=
 =?utf-8?B?bTlUK1M3NG5ZVmhEWURjNFFDWVNKWWtLQ3o5SlEzdXRlNjVyRm5tL0RvaG84?=
 =?utf-8?B?ZW8zTFBFWDNaakRFT0Fyb3gwdVdabkM2WTJOQkZzM1k4d3Uxb1k1UTVRTnJh?=
 =?utf-8?B?dDQ2Y0lGc2JwVlZHenRnV2s0VkdJR04xdldHRnBEOWR3WEsxZktvOFZIdHho?=
 =?utf-8?B?RXNSNUlMeFFja2p3SjN6SXRIRDVldWtmYStvUHl1aXdtSGdtNUwyL3NGRG5E?=
 =?utf-8?B?RC9ib2s1MW1iQmNXN2JHYW9OeCtiNnpyZzdCWlRZQWMrV3ZqTU03ZmNLM2d6?=
 =?utf-8?B?bDlRRTBmK0crS0lXVW03ekNvam9hVktrNllQb2FHNGwvZkxDNXl4RmJNYTEz?=
 =?utf-8?B?Uk1QZXFTU2hCdE0zbGVsdGZYeEh3TVY4Z0FwR1pQSGxyVyt0QzRSVWtvS0w2?=
 =?utf-8?B?Z2FKd21saTc0bXowQnVhQ3pFdWp2Q1NHcE9vUlVCQk1oN1pBT0wrWXo4K1dn?=
 =?utf-8?B?dlZqNjBxakxqRmtybUFFOEQ3bFE1OFplY2NNSlh6a3RUSXk0WWxuR3A2UVJY?=
 =?utf-8?B?OTZmYkJ2eElTWmVqTGVESUNPdklpQ0FVdG93K0t3d2xvM1BtczJ3S3lIMHBu?=
 =?utf-8?B?UGJRb1Y5by9xN3doRFA3b0ppWWphVDQ4Ui95TXdjb3dLMmFOS0RCS1dIWEo1?=
 =?utf-8?B?MXdmbUVNTk9sQ3NhY3Fabi9SOU9sdmZCRitSZ1p2YWxQVWlzTUZOdFM1Y2ph?=
 =?utf-8?B?TmlOekJoQ3RmeVhkZ2RuSklCREY1ZkFDNHVuSk11ckxvUFhxUUpMcWlkRHZ2?=
 =?utf-8?B?ZWRjZXVzV1d6MGpDaW1mOGhkUFJwNEpHazczbTlWRVhqekpXajgxMlRvOWxr?=
 =?utf-8?B?UHl6UUlHaCtGanZIZDlHY3lTNmNSa1gzcmpWZjE2UWwrd1VqR2xKZFhvTURB?=
 =?utf-8?B?Q1lIL2pVVlFWU3J6dDNUYy8ySlEwem9QdjN3RElOMlVTU3NTMFlCNTBwMlda?=
 =?utf-8?B?R0d1NnJOVWVqQ2xkRzk2MU5uTithUENONWs5UllpRW02YzJkaEwxNGMzT2dr?=
 =?utf-8?B?SlVnRFZPaXNwZ0tjOVJzSjFkdlpUd1l0M2JCV3NRdTlIc3oxYk43a1JDaExV?=
 =?utf-8?B?WGljRVdzOGp0QVNMSzBUbFU1ZG5PUHMvZTM1MlN5bFcwTytjUURDUisrbzIx?=
 =?utf-8?B?Kyt3T0xkalloeWhnK2dmQ3RGSk9KUGNGMGUrK3BKbXJBMURxQWJubUxCWTRo?=
 =?utf-8?B?ZXZBR0dPN1YvMUVtdGJCbzhSbmg1bnRjdDBaSUNqSlkrM3ZnRDgvUFpJL3Bp?=
 =?utf-8?B?RnhqRjNPcmt4dkNVdjEybEFpMk0rY04rbkRBVllMcXFVWHZDMmFXUzhhQkI5?=
 =?utf-8?B?S3RqclY3Y1lodDdweFN0aWc3U014Q1N6djlPL3Vtb3NtV2dIZmNmaHQyNng2?=
 =?utf-8?B?akZ2WHhCK1ludm1DdXVyMDU5Y2E0ajlxUlBabkJXNHZBSk4reEQwNzlMZWxu?=
 =?utf-8?B?MTJycDVqeFJXc0F5c3JLY2hvdmpLaExGdm1uTExIMnlVZEFsMFd2Y29RYVl1?=
 =?utf-8?B?VDd3NkZOTmdxckNvTkRPVWppSjU2RnF1Y3AvK1hjc3M0MTFLUmVkYmIrK052?=
 =?utf-8?B?YWlWT2xBMm9ZbnRySG5zT0JZZE00MTltWmhiaEtOTjFqS0dhM3VZN0krV2RS?=
 =?utf-8?B?Nmp6ZWlueWwxbTJ4VEJwMWMwNk1PWDArN252UkhCZURlTmxlMjFHdW13RmJH?=
 =?utf-8?B?SG5wVjU0a1htU2tlcFpXemRrZXpESzdxMzlSY1pISEh1ZEl4SFBWOGxadTZ2?=
 =?utf-8?B?Mmh6L3ZKRERZejJmVWhrNWRjVU80V0FNVyt0T3kydDQ5d09zdWg0MTFtMkhs?=
 =?utf-8?B?cHArbkVhWXBTTnVGSlM5YnhIWm5ncDlHYkhLZE8wZVRnSVZ1MHZvT1VKL3lI?=
 =?utf-8?B?YUVEY2RNWWk1eVNxMjJOTU83WXlKVXJ5R29tenIrV3drMlpFYmF6elM0R0Q3?=
 =?utf-8?B?UktXWEJZTUQ3MjZSQVFjUVBWMTQxWGplT2M1R0txektHSGFqbE1qSWQ2Z1dQ?=
 =?utf-8?B?YkgrVGM3UTdrNUdmOWVzN0FxanRZRmU4SDdMdE82cjlXWUQ3QmthUkxKNnIx?=
 =?utf-8?B?eVgwQSthRUcyOUJoMEI1VDdnVEkvWTVOTy9jdWZVRmh3UzhpaGloSmQ3d1FE?=
 =?utf-8?B?cXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19bae4df-7afd-427e-6ce5-08dac33c7e47
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 16:56:21.3379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGavneTPkX5IAvP4TbyORM/wSarwMWtEbpB89HJ/s7b9A6mjzXJP+hytiHefmrcEnE0uHv1sEqCCDAshCuqtLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7905
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/22 11:00, Vladimir Oltean wrote:
> On Thu, Nov 10, 2022 at 10:39:30AM -0500, Sean Anderson wrote:
>> On 11/10/22 10:29, Vladimir Oltean wrote:
>> > On Thu, Nov 10, 2022 at 09:55:32AM -0500, Sean Anderson wrote:
>> >> On 11/9/22 17:41, Vladimir Oltean wrote:
>> >> > On Thu, Nov 03, 2022 at 05:06:39PM -0400, Sean Anderson wrote:
>> >> >> Several (later) patches in this series cannot be applied until a stable
>> >> >> release has occured containing the dts updates.
>> >> > 
>> >> > New kernels must remain compatible with old device trees.
>> >> 
>> >> Well, this binding is not present in older device trees, so it needs to
>> >> be added before these patches can be applied. It also could be possible
>> >> to manually bind the driver using e.g. a helper function (like what is
>> >> done with lynx_pcs_create_on_bus). Of course this would be tricky,
>> >> because we would need to unbind any generic phy driver attached, but
>> >> avoid unbinding an existing Lynx PCS driver.
>> > 
>> > If you know the value of the MII_PHYSID1 and MII_PHYSID2 registers for
>> > these PCS devices, would it be possible to probe them in a generic way
>> > as MDIO devices, if they lack a compatible string?
>> 
>> PCS devices are not PHYs, and they do not necessarily conform to the
>> standard PHY registers. Some PCS devices aren't even on MDIO busses (and
>> are instead memory-mapped). To implement this, I think we would need to be
>> very careful. There's also the issue where PCS devices might not be
>> accessable before their mode is selected by the MAC or SerDes.
> 
> I don't get where you're going with this. Does any of these arguments
> apply to the Lynx PCS? If not, then what is the problem to using their
> PHY ID register as a mechanism to auto-bind their PCS driver in lack of
> a compatible string?
> 
> You already accept a compromise by having lynx_pcs_create_on_bus() be a
> platform-specific way of instantiating a PCS. However, the only thing
> that's platform-specific in the lynx_pcs_create_on_bus() implementation
> is the modalias string:
> 
> struct phylink_pcs *lynx_pcs_create_on_bus(struct device *dev,
> 					   struct mii_bus *bus, int addr)
> {
> 	struct mdio_device *mdio;
> 	struct phylink_pcs *pcs;
> 	int err;
> 
> 	mdio = mdio_device_create(bus, addr);
> 	if (IS_ERR(mdio))
> 		return ERR_CAST(mdio);
> 
> 	mdio->bus_match = mdio_device_bus_match;
> 	strncpy(mdio->modalias, "lynx-pcs", sizeof(mdio->modalias)); // <----- this
> 	err = mdio_device_register(mdio);
> 	if (err) {
> 		mdio_device_free(mdio);
> 		return ERR_PTR(err);
> 	}
> 
> 	pcs = pcs_get_by_dev(dev, &mdio->dev);
> 	mdio_device_free(mdio);
> 	return pcs;
> }
> EXPORT_SYMBOL(lynx_pcs_create_on_bus);
> 
> Otherwise it could have been named just as well "pcs_create_on_bus()".

Yes, this could be made generic when we convert other drivers. This
really is just intended for (non-dt) platform devices. It might even be
better to do this with swnodes...

> And this is what I'm saying. What if instead of probing based on
> modalias, this function is made to bind the driver to the device based
> on the PHY ID?
> 
> The point about this functionality being generic or not is totally moot,
> since it's the driver who *decides* to call it (and wouldn't do so, if
> it wasn't an MDIO device; see, there's an "mii_bus *bus" argument).
> 
> It could work both with LS1028A (enetc, felix, where there is no
> pcs-handle), and it could also work with DPAA1/DPAA2, where there is a
> pcs-handle but there is no compatible string for the PCS.

The crucial difference here is that if we have a pcs-handle property,
then the node it points to will have a device created by the MDIO
subsystem automatically. The reason for this create_on_bus stuff
is to make the process of

1. Create an MDIO bus with no firmware node
2. Create some MDIO devices on that bus
3. Bind them to the correct driver
4. Get the PCS from the driver

less error prone. But for pcs-handle stuff, this should be something
like

1. pcs_find_fwnode()
2. Look up the device for this node
3. Bind it to the correct driver (but taking care that we don't unbind
  an existing driver if it is correct).

And then the driver can call pcs_get().

With your suggestion to use PHY_ID, we wouldn't need that. But we would
still need driver involvement, since probing MDIO busses is not safe in
general (since as Andrew mentioned there are things on the busses which
don't have PHY ID registers). And IMO if we need the driver to go "yes,
it's OK to probe this non-phy on this bus," then we might as well do
what I described above. This could be a bus flag, which I think would
work with existing devices.

I'm worried that this could cause regressions and take a while to iron
out. My current approach is fairly conservative and doesn't require
changes to unaffected code.

>> >> As I understand it, kernels must be compatible with device trees from a
>> >> few kernels before and after. There is not a permanent guarantee of
>> >> backwards compatibility (like userspace has) because otherwise we would
>> >> never be able to make internal changes (such as what is done in this
>> >> series). I have suggested deferring these patches until after an LTS
>> >> release as suggested by Rob last time [1].
>> >> 
>> >> --Sean
>> >> 
>> >> [1] https://lore.kernel.org/netdev/20220718194444.GA3377770-robh@kernel.org/
>> > 
>> > Internal changes limit themselves to what doesn't break compatibility
>> > with device trees in circulation. DT bindings are ABI. Compared to the
>> > lifetime of DPAA2 SoCs (and especially DPAA1), 1 LTS release is nothing,
>> > sorry. The kernel has to continue probing them as Lynx PCS devices even
>> > in lack of a compatible string.
>> 
>> I believe the idea here is to allow some leeway when updating so that
>> the kernel and device tree don't have to always be in sync. However, we
>> don't have to support a situation where the kernel is constantly updated
>> but the device tree is never updated. As long as a reasonable effort is
>> made to update (or *not* update) both the kernel and device tree, there
>> is no problem.
> 
> I don't think you'd have this opinion if device trees were not
> maintained in the same git tree as the kernel itself. You have to
> consider the case where the device tree blob is provided by a firmware
> (say U-Boot) which you don't update in lockstep with the kernel.
> Has nothing to do with "reasonable" or not.

This is exactly the reason why I am saying that we need to have the
device tree updates in the kernel for a bit before these latter patches
can get merged. Actually, it is probably unlikely that these will make
it into the next LTS release (either 6.0 or 6.1), so these will probably
be in device trees for a year before the kernel starts using them.  But
once that is done, we are free to require them.

--Sean
