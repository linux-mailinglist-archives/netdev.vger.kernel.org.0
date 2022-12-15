Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C050D64DEB6
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiLOQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiLOQct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:32:49 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2083.outbound.protection.outlook.com [40.107.20.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AE1BC8F;
        Thu, 15 Dec 2022 08:32:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw76QzF0R0zhS87tJ1KPYxSLGrGkJjjJJ/kW33JcvBxC8+4vWd97eAHdVNFd4Fx6VWlrFbw+Bgt5JrytUmHp5hfld9UgnjuMzXT27AeC3uJgjTMp/WQQfKxX72pKX3g0srirf71lo1O5dC4Lf/gKT1/wuCCGp0+LRpjmvrlLjdxRdfxCtQRwDf6ZOUHxS8WAV05of205xoy+ymXbOmxg4zIL6No+0nr7VvAUtc0Tz+1ijlqiIFHzCoPU+jzXLAxw/vPKBd7rLlj6KRIhijLUehVvu/lSRLZJZKJKwAzTFtqmcxoaJdm0eVUMcO2i5Mha3Jb8Hq6DHg1oRExvn7QHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+FIpnMpi548PPZm8sUShfIoXacgU00KY+RhRWG941s=;
 b=AJZzv8XOvJYeJND5Tvxgis9/OzSOB7gC2HVNtIJrgI+NfCAgtZuz3DoyENGElbmOn2SNNF3ADNRx7TWXVG2JCIty05PhrMe/1stVFAadB9/dFCIcy+ddOa4F36v67iXbmMTr+s6DhQheh/8RuM8KaMZcB8VEgCjuEdDTadiWjRHmR4zGPk37hpwMPC4toV5y0am2f2XYLjNgLsTfUDAXxn6XWh/DC8bokYkCjr9jf7gsXPHUIzTPdopnhU6SBPhlQv9ybX6OdET/2E+EyDoXZ0j2WYs5jPwgyQ3Gq9gpLJxkrz3/m4mEPOYhUZ32kWLHGletpuVLcTmhTTGwmiY4HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+FIpnMpi548PPZm8sUShfIoXacgU00KY+RhRWG941s=;
 b=fA4krbyDbPGGEp62HpdRqAet3R6bw135JTnCU8merCvKdzsWxI/+m9lMkkaeCAkqIAh3cJhFP7VCmDAsXTw6ajlr91ad7cgrEFxQ5ZZcDekUwxaPzrN0g7AtrrMwIjR9J6CoJC+2s2ZjLUL89c5z6cRokHTL71F7yW+GzrXOs8R3fEHzcfurDPxhbwmAjYh3wQXLBZOuPy0aPC7mPhPuDuqu6DFqhGbL5Lrqj3CRoBwOdreva3gWVcDo02pA0VoCXBqr/zJfIu7UYbo1k6nKXZLli8ikUeqFgfUpHUIwhEFl9VaZfJ5NVJ+o36uG1QKpvxYDfVbQKNX28wqHjajcRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB6900.eurprd03.prod.outlook.com (2603:10a6:20b:2de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 15 Dec
 2022 16:32:44 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 16:32:44 +0000
Message-ID: <8b6ad6a9-05fd-d4c4-16cb-5596e3defc04@seco.com>
Date:   Thu, 15 Dec 2022 11:32:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] powerpc: dts: t208x: Disable 10G on MAC1 and
 MAC2
Content-Language: en-US
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
References: <20221103212854.2334393-1-sean.anderson@seco.com>
 <VI1PR04MB5807CB6B0A348FD680AC420FF2E19@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <VI1PR04MB5807CB6B0A348FD680AC420FF2E19@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:208:32e::33) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB6900:EE_
X-MS-Office365-Filtering-Correlation-Id: b56c2466-bfd6-4ac1-d71d-08dadeb9fe0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyvVf9l2POjK+X74fb4x8bLH+6Isf8E9YefTyi1g8x7SRFrxedBoEBSbongzLZckz2QRgVvKrUA2SD4ywpIcmXeNRGYaoD0Vl+/XBlsAFVvoXqES3qYHqRo8mSIyBVb3ltP0mSfDolFuwSJJyaorptsJQNhv67dT2ZIoF5N5ijpIbEGA5zgAs0VZBg3HBGw2Pg8GW9PpURZjZ4ESheBaLc6P99H7KPXwi8Vy9KfZWMbKSqt6DztEGzA43/i6PeEXcJXunxU1DNUqfOZeWvCcWnhva1YMu1NQYZec3IVjxV4SvPFuL0zqx/RMWAqI0sjC8JSBbgCedOTqXv7si2XjXWK1dkc/0QtkXsS9KDZOWapsHG/GBh8Z6RyuwrKpLt/OD0KoM8D+YpOUt2gIQhx4bXYMqKvHD6+i8G+tPaQr+YL6N7Quxq1QE9Pj8outMcJBRfD3d5cwsWj93BbB5NgBSUuq19qhhQdZSrbI8ry7VITUHEAmJ2E/jr7GUCTAmHrhbSG89/MjlWbmLeMEfR8zpd7tyBfaMzhxV7eBdkL2H8mR13IQPLilCLh/Aupb2xyg44HgH9GG1PKuHPvFavkXP5Cqgsl0d9TuPEJE/1+WWW4WOdJ47n027a2EI4n9+5bPBhi/rSNKxRTfGEd7KCUN+jPtPngXgN7jiBNXWidBnjiue20vS/AcJYjU20QG7gqt8IItOLAbKAy654zx0+tEGPasJz9OZqFcqOTfZzyWLGrIJz6t7Q/NYn+WPPALCdsIONiKs6tD6wrwAwj/CIrO6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(346002)(39850400004)(451199015)(6916009)(54906003)(26005)(316002)(8936002)(41300700001)(66946007)(5660300002)(83380400001)(8676002)(36756003)(66556008)(186003)(4326008)(478600001)(6506007)(6486002)(52116002)(6666004)(6512007)(31696002)(53546011)(86362001)(2616005)(66476007)(38350700002)(38100700002)(2906002)(31686004)(7416002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wjh1SUxxT0RUL3E2UC9jN2JPZ3MzVmIwd3R5Y3lrQjZIeWExWWhOV1lWWjZy?=
 =?utf-8?B?N2RWUzJtdVJ3ZktxeHZaUHN2OVd2UkNsNUVYS2JmbjMyM2JLQWNCbGhWZis4?=
 =?utf-8?B?RUduYXA0VDdkNnBxdzVkNWJxWnJEVUptb1ZsQjJ5L2lZTFptTGdJWXordU54?=
 =?utf-8?B?VFBGaC8vaUhMWHE3RER0S2FkaU9wK0ZHMzFCYVZ4RzhjRngwM2tZZENnOVdy?=
 =?utf-8?B?a0NxU1NCUVRVNEs0NDJucDB1UVJDbEhWeWdGMGkwbnJINSthNGFyWXB6MVdm?=
 =?utf-8?B?QUZSUmNNU1ZGNzc2WFRkTkxCUjJ0TVJMU0psRWc1N2dialZxRTFZSDZlYTB5?=
 =?utf-8?B?NW4vRDdWanlTNnY0K3NxVDhiaTZERWlCRlhzWlM4ZCtxWlR5ZzN4YjdydGtV?=
 =?utf-8?B?YkZrMVVHaFY1S1pRcHQzQm5PejJQeVJNdlFab3NFMTZMSXBxUmNGMnBuQ0J4?=
 =?utf-8?B?MmloZFZQN2ZMaFp0R1VoOVlocnhETFhkQ1pWR3VGQlNwVGZ3YngvRkpMazJj?=
 =?utf-8?B?ak91SjZqNzQ3NHdxRWlpNGVLTWF0V0ZzRERwdmVwMjFyR3ppT00xempOc3FO?=
 =?utf-8?B?aFRoMVMxeVB4RktwZjk3QlZSMHB6OGpQN1A1ajRqdm9tVGZCYTVwREtkemhU?=
 =?utf-8?B?dGREaGM1cWNVOFJwVTZxaDZMb3RUcWRoT3hiemtZc0VFM1dHbHFleVpQcHdW?=
 =?utf-8?B?R0VTNHF4SS9ZWVhBTGdLTmRvdmJZU3NBSWhtOXFjRFdkL3hBckRZcnloMGVj?=
 =?utf-8?B?SXVta1IzSk9VMzlTelNnZU9qdTMwOHZMNDdIdFZOd1dyUC9xWmc3c3F5eVFz?=
 =?utf-8?B?dm1UMXF0M05nTFFTYlhreW5XOWVyM3dpYW1jYzgrSktwOVhSNXlBbjJlVFJ1?=
 =?utf-8?B?SXJ0eWtHREJCb0phQ0RET05rWGV2WHRnaHQ3SjlsTmxpZ0dJNVQ1eGl0Y2tL?=
 =?utf-8?B?d2k4NnlhL0Q0VUFFOWt4Ujd6dlA5WHBoVW8wcnc3N1VuTFNVWXVUMlRZZllu?=
 =?utf-8?B?YmlBQmozVzYzZDhPMWpQLzBhVWZuc3ZIVEU5UkRBdU1YcHVSRjV0dVhITXI0?=
 =?utf-8?B?M1ZxZzQ2Y01GSTZJc3IwU3d6WU1qckJIaUNOaTRrWk9lN2tLWFE1S0hVaWph?=
 =?utf-8?B?Z3VBczl4Q3IzeXN0d1h6ODZ0cFdJajAyNGRxZGxRZnIwSWh2QUI2VTd3TGxi?=
 =?utf-8?B?SXcySHpDMmNpSllyMGpVUEtreUZOaStONXpyZEZhcmRzZ05od2UzUm9NMk5l?=
 =?utf-8?B?MzFIc3pVTVliN1ZPczZsVmt6NVNtSmdSK1lmZXNOR05yMEhXN0JhbnhXQTA3?=
 =?utf-8?B?RVRWSGdONG9xS3QwQkdjdy8yaHB4UVE0QVRWNkhMT2VrdkR5cUFvNzNMOXgz?=
 =?utf-8?B?c1dYMFpQaXBheXpRQm0zWld1T3o2V0ovTkxlT0k0M3JwR3pSaDJaZlRmWjFG?=
 =?utf-8?B?SHJrY0NzRjhIcW5iSW9XN09GM2h3aGRFejh2Uzd1ckRlM1JVS2dwMmZyY3Qy?=
 =?utf-8?B?WjZYTWdSTDM4TTQvM25IRGJJRFJkM2pxc2pvaW5vN2R3anRCU1lFMWF0NVYv?=
 =?utf-8?B?aVlBSC9uUVpuWjBINTRXZWoxSHFDNmdQd3grR2xpclZxTjgrZDJNODJKTUpi?=
 =?utf-8?B?VldKT1pwQ3F3TjMrMWYyYmYxa2ZWc21nTDdSY0R2MzE1OE5NeXd2NURvT3d6?=
 =?utf-8?B?U0ZYZmhmZWQrZzRxalFlZWF0NHVNaUxvUVlwOGgxd2d4VEc3ZjVCT2ZlUXdP?=
 =?utf-8?B?Q1lWT0RnZGtjMzNpcmhlK2tsWUxEN2FxeThHUnp5TWZlMCtBNWh2dkMzSmZS?=
 =?utf-8?B?Ry81UVM4RHQ5YllCUTFRQngvK2RSYkVLaFd4elVwWEd0dWJzeUxnb3B0eGdn?=
 =?utf-8?B?bWFSWVdTTVdkQ0UyS041N0lYNnB1Vjc5NkNQWDRubFNITHJuaVJQZXBOQUJp?=
 =?utf-8?B?R3VxYUNkVElnWmdhSFplNE9ZTElZaFdnQXlEeUp0c3FBNlFuM3BqZlduSHgz?=
 =?utf-8?B?dHZhZXlrbmQzOWNwR3RPVWNSbFJjV3UrSm55eE44Q2RtUW5jbW13VWFmWjZt?=
 =?utf-8?B?VENmYVNCRWNHTzBQV1N4dTMxS3Y0MTZuTHhUdzVkOHRFZjMxSXdaY3hwdVdv?=
 =?utf-8?B?eWpFem5hZnJ0TTNMNUZSQWpaUHkwQjJnajV2aHpoSkd4RFY0YVhCT2lzcXlJ?=
 =?utf-8?B?MkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b56c2466-bfd6-4ac1-d71d-08dadeb9fe0c
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 16:32:44.0479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2yRFKe2WlfIVtJ1tN7LL6BhLqeK6bcu8lkmjWMktR0QA1yvcr6ExqGSwdnoDn8LPGBOyJ1YcXnwB/YQR5ozPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB6900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/22 11:12, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Thursday, November 3, 2022 23:29
>> To: David S . Miller <davem@davemloft.net>; netdev@vger.kernel.org
>> Cc: devicetree@vger.kernel.org; Michael Ellerman <mpe@ellerman.id.au>;
>> linux-kernel@vger.kernel.org; Rob Herring <robh+dt@kernel.org>;
>> Christophe Leroy <christophe.leroy@csgroup.eu>; linuxppc-
>> dev@lists.ozlabs.org; Nicholas Piggin <npiggin@gmail.com>; Krzysztof
>> Kozlowski <krzysztof.kozlowski+dt@linaro.org>; Sean Anderson
>> <sean.anderson@seco.com>; Camelia Alexandra Groza
>> <camelia.groza@nxp.com>
>> Subject: [PATCH net-next] powerpc: dts: t208x: Disable 10G on MAC1 and
>> MAC2
>> 
>> There aren't enough resources to run these ports at 10G speeds. Just
>> keep the pcs changes, and revert the rest. This is not really correct,
>> since the hardware could support 10g in some other configuration...
>> 
>> Fixes: 36926a7d70c2 ("powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G")
>> Reported-by: Camelia Alexandra Groza <camelia.groza@nxp.com>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
> 
> Hi Sean,
> 
> I know I'm late, but there are a couple of issues with this patch. Do you intend
> on sending a v2 or should I pick it up?
> 
>>  .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 45 -------------------
>>  .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 45 -------------------
>>  arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  6 ++-
>>  3 files changed, 4 insertions(+), 92 deletions(-)
>>  delete mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>>  delete mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> 
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> deleted file mode 100644
>> index 6b3609574b0f..000000000000
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> +++ /dev/null
>> @@ -1,45 +0,0 @@
>> -// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
>> -/*
>> - * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset
>> 0x400000 ]
>> - *
>> - * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
>> - * Copyright 2012 - 2015 Freescale Semiconductor Inc.
>> - */
>> -
>> -fman@400000 {
>> -	fman0_rx_0x08: port@88000 {
>> -		cell-index = <0x8>;
>> -		compatible = "fsl,fman-v3-port-rx";
>> -		reg = <0x88000 0x1000>;
>> -		fsl,fman-10g-port;
>> -	};
>> -
>> -	fman0_tx_0x28: port@a8000 {
>> -		cell-index = <0x28>;
>> -		compatible = "fsl,fman-v3-port-tx";
>> -		reg = <0xa8000 0x1000>;
>> -		fsl,fman-10g-port;
>> -	};
>> -
>> -	ethernet@e0000 {
>> -		cell-index = <0>;
>> -		compatible = "fsl,fman-memac";
>> -		reg = <0xe0000 0x1000>;
>> -		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
>> -		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
>> -		pcs-handle-names = "sgmii", "xfi";
>> -	};
>> -
>> -	mdio@e1000 {
>> -		#address-cells = <1>;
>> -		#size-cells = <0>;
>> -		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
>> -		reg = <0xe1000 0x1000>;
>> -		fsl,erratum-a011043; /* must ignore read errors */
>> -
>> -		pcsphy0: ethernet-phy@0 {
>> -			reg = <0x0>;
>> -		};
>> -	};
>> -};
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> deleted file mode 100644
>> index 28ed1a85a436..000000000000
>> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> +++ /dev/null
>> @@ -1,45 +0,0 @@
>> -// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
>> -/*
>> - * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset
>> 0x400000 ]
>> - *
>> - * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
>> - * Copyright 2012 - 2015 Freescale Semiconductor Inc.
>> - */
>> -
>> -fman@400000 {
>> -	fman0_rx_0x09: port@89000 {
>> -		cell-index = <0x9>;
>> -		compatible = "fsl,fman-v3-port-rx";
>> -		reg = <0x89000 0x1000>;
>> -		fsl,fman-10g-port;
>> -	};
>> -
>> -	fman0_tx_0x29: port@a9000 {
>> -		cell-index = <0x29>;
>> -		compatible = "fsl,fman-v3-port-tx";
>> -		reg = <0xa9000 0x1000>;
>> -		fsl,fman-10g-port;
>> -	};
>> -
>> -	ethernet@e2000 {
>> -		cell-index = <1>;
>> -		compatible = "fsl,fman-memac";
>> -		reg = <0xe2000 0x1000>;
>> -		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
>> -		ptp-timer = <&ptp_timer0>;
>> -		pcsphy-handle = <&pcsphy1>, <&pcsphy1>;
>> -		pcs-handle-names = "sgmii", "xfi";
>> -	};
>> -
>> -	mdio@e3000 {
>> -		#address-cells = <1>;
>> -		#size-cells = <0>;
>> -		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
>> -		reg = <0xe3000 0x1000>;
>> -		fsl,erratum-a011043; /* must ignore read errors */
>> -
>> -		pcsphy1: ethernet-phy@0 {
>> -			reg = <0x0>;
>> -		};
>> -	};
>> -};
>> diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> index 74e17e134387..fed3879fa0aa 100644
>> --- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> @@ -609,8 +609,8 @@ usb1: usb@211000 {
>>  /include/ "qoriq-bman1.dtsi"
>> 
>>  /include/ "qoriq-fman3-0.dtsi"
>> -/include/ "qoriq-fman3-0-10g-2.dtsi"
>> -/include/ "qoriq-fman3-0-10g-3.dtsi"
>> +/include/ "qoriq-fman3-0-1g-2.dtsi"
>> +/include/ "qoriq-fman3-0-1g-3.dtsi"
> 
> These two should be qoriq-fman3-0-1g-0.dtsi and qoriq-fman3-0-1g-1.dtsi.
> You are including 1g-2.dtsi and 1g-3.dtsi twice.

So they should.

>>  /include/ "qoriq-fman3-0-1g-2.dtsi"
>>  /include/ "qoriq-fman3-0-1g-3.dtsi"
>>  /include/ "qoriq-fman3-0-1g-4.dtsi"
>> @@ -619,9 +619,11 @@ usb1: usb@211000 {
>>  /include/ "qoriq-fman3-0-10g-1.dtsi"
>>  	fman@400000 {
>>  		enet0: ethernet@e0000 {
>> +			pcs-handle-names = "sgmii", "xfi";
>>  		};
>> 
>>  		enet1: ethernet@e2000 {
>> +			pcs-handle-names = "sgmii", "xfi";
> 
> The second pcsphy for this port is still qsgmiia_pcs1 as described in
> qoriq-fman3-0-1g-1.dtsi. It should also be overwritten, not only the name
> property:
> 	pcsphy-handle = <&pcsphy1>, <&pcsphy1>;

This is the sort of reason I wanted to just delete the 10g property.

--Sean

>>  		};
>> 
>>  		enet2: ethernet@e4000 {
>> --
>> 2.35.1.1320.gc452695387.dirty
> 

