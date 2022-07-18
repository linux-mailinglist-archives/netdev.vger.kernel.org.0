Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008B55788A2
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiGRRk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbiGRRk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:40:57 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5058826552;
        Mon, 18 Jul 2022 10:40:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVgOB1i+uWM4Yt7klwuCchIBCdVcySAlXmF49PukCQlFfY5FU9cdsMuAjz1Bp5I/nQcqA9IWbo1hV7YZPo3Fpz+4WHNqt7UA5/uR7xhR9nIMciqwypNVEAMIbNxEMLktO4k34FxNUCl/08IN0uB0j8NN2NM+GE0Y5B0kBVZj6yQ/3Os88Adq7eJBFimSeM4tJ/3aM+Qz33e5TfBYkc4qx1Ho4RrIS7jb8Lzqab/rlUti4FKnOdg8Z/Qt4cn5tj9rvW++5ly2SS16VQnhVaApFQoqfVTC0MVNUMiT3SigPraoEtcww79cU7MrfP9iI3UVpFC8HxwBjpldsxySU+GDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=octZ3sJVq70YYFPUWEAd3myJxXIvOfTaiyxXDScnNio=;
 b=D93Rk4AwpXAH/Yf/D9Gl9MblPr+JFnF5AMIFvITCo9IvAzriIttlrKjvYsJAMUc105EoX+Lxsgh7r2Dk+CvsEvlDzLInRjbtUQUMU1wb1bS83nikB7R4OI0Y4smFu09USCO+EM9cotPgmxes0Rxiz+KyL73vWVM8hcrIYT6K4Rwyl2uY8+40QcH1EI1+J2MdcnBTB7mcbuWDYfx4ruWGEZX8SKFDYeLKJD+YqJJhsbrJNIgP7XxCtuaV2hyFFmBmqiUBQ9LQJjPaB4oiRAl5cHH3Dr435s383SBbeu/5MzKa8K9i2C5U4VbqJe+606UCvfGdSmLp7WpZC+FT/BbbzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=octZ3sJVq70YYFPUWEAd3myJxXIvOfTaiyxXDScnNio=;
 b=Fwi0D7XC60Ga+pLYIJoqLU+TnUb6CCViRgsW6rmjxDne/bmZ1nrGGf2PJNIg0FbjPvqmICvUkVvAoxN5m85EfdgyZN+BagH1d2pSDOCLCBU4fCveg/xndzEIpmiNb/aXKwcpV3LBz6Z3LqXQQXg9CgnlfKg50VwGKHkhCNoIIUmRA2KDESczR1E8nwseYFRmea+a/bLazVDCEZ4Lvu71VSMQFGfV/jf2ld+4hLRx9JjkUpon1g3s+CYnRvReyWKgKjRQ9J/sSPNK/jZtzx7/7uP7PpBj+NdduUcK9OLBkDkwZUZosssUALyBov8EUQFCBlA40LVRwZJjfKGmdVlIcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DU0PR03MB8503.eurprd03.prod.outlook.com (2603:10a6:10:3cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Mon, 18 Jul
 2022 17:40:51 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 17:40:51 +0000
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com> <YtMaKWZyC/lgAQ0i@lunn.ch>
 <YtWFAfu1nSE6vCfx@shell.armlinux.org.uk>
 <b1c3fc9f-71af-6610-6f58-64a0297347dd@seco.com> <YtWYWhAm/n5mnw4I@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <0275eb0c-1311-2b3b-1e37-d5297ba1a443@seco.com>
Date:   Mon, 18 Jul 2022 13:40:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtWYWhAm/n5mnw4I@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0017.namprd18.prod.outlook.com
 (2603:10b6:610:4f::27) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fff6c969-5b31-49bf-f130-08da68e4a851
X-MS-TrafficTypeDiagnostic: DU0PR03MB8503:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfVBNU59aSS8AEvtjr8X40a/bPpLSpVhcfKaOFzsejey037J0H26yAn2wZGpHkz/9awE1sSRM6aQ8xijilsIi7Lklnn95KGTFODrrHx/r7ySHtU5/W/OAEsxHNg+93o3Dvzv1zIF/893L/8pbuf1hjQUnFwcQvc2hLDiKGhFKeRRJngxQlDLKnaxg/r0kgIU13IjceAw95cYf7i/om8/4uB5uqCxsoqRb3i+f/oQyUV03Sr4GdMSfZRELLbZIgmhuzyoDOeebm8uhC+vYSlWo3BKnVPVBaGzUNR3pEtswCQPa4ZiZpuSLOALieho9y6fYXZh42nB1XwL2Frcuq7x6VjswZF4s5ccO7oqdw6ILIPoS6aR6eOEJRpj2r00KQUNKR/oVOjQuf64Rx+s7V1S8KfcEoQAuifyCNX/Ci9Mr7mnsAarNjjdMYFfDRwQrVB2PTaXup5fwzVbcWtkBzjys7Z0DvM57b7qW6DujyrX7F58MRNp/NA+dlm/kHvwe2+MLivzTcZ2FdUBMwApm60vH5AvlNwZ1S+ZNiZVKtUeKyLTLMesYsSqNEb0MMJru0svxzRybmdQ73XYFH3jViLyCJe3TwirrZaxc6runDdF/y1rO48RgkEQQO/LQKWQFkkwJBitC69xL7aSfF/oMjyT5fzJj5uYk/H+2n1ucM10hlEuVMzeGyM7s6qwfO05JskzWsQV3yVxymA2dbVscwMJqPWgeAnlXdOhZr7kt5zT829n5P34nfCUVOWfzcmEZTniKHmGXMmrhbXtkiq//VE36BQNeeZAFU6Add8g6BJNoN83phwd9mtLECgK4mYhyAx52UfJCfNpfLK32WYEqE9DTnmRrECfBrnzWfOVieMSNc9uzQzIEZ76Ex35UiXdjpQK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(396003)(39850400004)(136003)(66556008)(4326008)(8676002)(66946007)(8936002)(5660300002)(44832011)(66476007)(7416002)(36756003)(2906002)(38350700002)(38100700002)(31686004)(53546011)(86362001)(6486002)(316002)(6512007)(31696002)(26005)(54906003)(6506007)(83380400001)(2616005)(41300700001)(186003)(6666004)(52116002)(6916009)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm1TV1FacDlsa25wVXY2TWVxOXZwOFJ1SFRSZ1NwbDNrODRiQjZlUUxONWw5?=
 =?utf-8?B?UDlOeEs4a1RSZnRuamkzb2g4UWhoVDBCd3FMakY4WjZ2b28zYlhDQW5uWFpx?=
 =?utf-8?B?V2dkbDBabVJsMHZUL25PMjNGQTUvRlVWREduYlFaMGdaZm5VeG5ITm16S2VI?=
 =?utf-8?B?K0xOcytxNEFzc1o4MWQ2YkpGTWdMUVZsTHNzR2lKUzhFUUdmNGxXdDQ2aWlx?=
 =?utf-8?B?U0NobGszYVVxaUZpQzZvdjJvUUNDZzh4MTdQZDU0cGhzNHh3cjhWMFlLMUxl?=
 =?utf-8?B?azdGSWRmeUtsR3I3MVVsL1pTdlpHV2hjTVhHazM2eCtoWUhiZnZCRE5odXJH?=
 =?utf-8?B?L2k1UkgvdzgyUjh1d3VqbjByODdpN2hPMEpzYTJsYmFabjk4eDNNejNNdDJB?=
 =?utf-8?B?RDZ2TEFMQlFZOUk0azhkTmwyTmttdm1FUXBTYzBCcW9MbXZ5UFFlcXUwVDhq?=
 =?utf-8?B?cUF5QVdIR0Z6REw2MlEwdGxFRXBUMStCdER3OFVMenV1b2J3K0lSWU1Yd3hO?=
 =?utf-8?B?bm1udTJ3a244aUd5REx6amlDazVJR2NNT1VvVVlOWUdIcFFQNkJjQXdJcloz?=
 =?utf-8?B?RURENklwNmNqKytjcWpFWXRyU21TOFFWMDRJdWdTNldHYnAwT2RCa3U4aEl4?=
 =?utf-8?B?NWhHWlpBRVpLMkhBODdZOVhndXlWTEhzaUoxMkZjMlF3UEVWRVdKbWlydkEy?=
 =?utf-8?B?YUVYTmwrK0tIcWNudWFQQU5xcThuL01LM0xyWEx3SkU5Vno2amh5eHk5TWI0?=
 =?utf-8?B?UmxaZVFjMUlZaFZZcTVTbHpxWS8zYkxrZElYZlR3a3VlK29NcWNqMzlCWFYv?=
 =?utf-8?B?L2hMRDRMMVFVaDZHMVRjbDJvZkoxYUdSaE1GcDF6WDlqaG1DeGNGYnhheVBz?=
 =?utf-8?B?YlpBaE1UN25KczI3QVpiZGNBb2lLMDFLMkZrNk8rR3M4L2YvUWo2eU9UUks2?=
 =?utf-8?B?M21HU0lUNnV1dHo4OXNRdWwydmtyUitEQXBTRVQ2a2NUcmdRQnhtRWpUYjhw?=
 =?utf-8?B?eTltQ2NHY3REQXcvNWJzWWE0ZDBKcm1JcnBIaTBwTG1lRnRNaEdnSUVYVDNT?=
 =?utf-8?B?ZXdrU1hCSE9vdlEvK3RnMm1nK2Y1RGtrUXM1b1BIenh2UVlHU1F1dW9NVE0v?=
 =?utf-8?B?cHVWNStScXlRK1hyRDJkV3RRVE5IWUVqK3Y1VmNqenFDeDNFMWFkSXZxZDZ2?=
 =?utf-8?B?QnFyYjBaazNWRS9CcXppZXNVNmxiZWJ4ZWEvWStWbk9jQmdzUW9WQ1pUNTRG?=
 =?utf-8?B?cUFhcFY4ZE9pcm92RkxJdUYydGlhSjNaM2lVazJ2Y0kzYlhUM1BOcHBuZHE4?=
 =?utf-8?B?UG12Q291bGFuMjYzV3J6Y21RV2t1OFIzTzlqaHJsc3Nqd1BReXYrbC8vc1kx?=
 =?utf-8?B?UXEyY1pPbE1vaGowK0kyVEJPRFVVM1FlWU8ralB1T2d2Sk9UU1c3Q2J6UFJk?=
 =?utf-8?B?amdhMWFxSENRaCtDdzdrSHFuOWtVdjFDTEJUaktyQ1VQL3RqYlJacWNpUi9K?=
 =?utf-8?B?UGZpaFFBLzRXd3dhSVFWbDZFQXRKdS9yaTNKT2x3dENaZUpaUE41UmRySWE0?=
 =?utf-8?B?Y2ZWMlBWbDB0NVp2bkZHSFV1RXBZa2ZGUFFKMURXbm9GZDhzVVRaeHZpSi8z?=
 =?utf-8?B?MmwvR1FHS09FZE5RZnNSTjVOQTlaVlhvc2dlYWN1V3JvVmh5N2xVSU9JN1kz?=
 =?utf-8?B?ZTFoODZOVHdrZGNWUlp2MVZsYkdkOVpRSlF0UGs2M2NBZEhPbDNnK1NxZVRN?=
 =?utf-8?B?NmpRUE1ZQkxLMXVoV28zUWdTcWtsWFkyYTRKb2E4ZXlRWG9YcDRGTllxNEg0?=
 =?utf-8?B?VEJqNlBzOHgzUWwyd08vNlRTTjloMW9sRlZkemV4OWk1U2xVRmFzMG4xd08y?=
 =?utf-8?B?cHlBaGtEYzVVR01wT01FeUFDVWJhMjBvczZnZ0hSRGZXWHVwTUk2alZFZmxx?=
 =?utf-8?B?Y0kyY29BWHJZZEViS2U0aHZTVnkvSTdrdkxKTnRwanYwYi9HbkNxRys1eUox?=
 =?utf-8?B?MkN0bEZVSVJxZ2t0YWV6RFlPWmpMd0pSYnRFT0ZQdTBWd2NheGc1TmVRL2Vx?=
 =?utf-8?B?dHBlUHNrZTF5cXpmdXVzaERhY094WXZFdVRnZ3VFdDMzejRuZFJDWkZVV0h3?=
 =?utf-8?B?Y1ppbGx1WDhJeWplL1FESG5COFAvRE9BTVZ2dXhENGVTZ0FHdGh6MU9Ka291?=
 =?utf-8?B?aEE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fff6c969-5b31-49bf-f130-08da68e4a851
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 17:40:51.3214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYj8C3E3UNXSJM0LIntX2ayKDsb1ZiksiNIIXEwxr6guoQLup8zPdofTmDpi9l95Ug4Cjxv4SGQtlt0awl8A1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8503
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/22 1:28 PM, Andrew Lunn wrote:
>> > I am rather worried that we have drivers using ->speed today in their
>> > mac_config and we're redefining what that means in this patch.
>> 
>> Well, kind of. Previously, interface speed was defined to be link speed,
>> and both were just "speed". The MAC driver doesn't really care what the
>> link speed is if there is a phy, just how fast the phy interface mode
>> speed is.
> 
> I'm not sure that is true. At least for SGMII, the MAC is passed the
> line side speed, which can be 10, 100, or 1G. The PHY interface mode
> speed is fixed at 1G, since it is SGMII, but the MAC needs to know if
> it needs to repeat symbols because the line side speed is lower than
> the host side speed.

Right. In this case the phy interface speed is changing, so the MAC
needs to know about it. I suppose a more precise definition would be
something like

> The data rate of the media-independent interface between the MAC and
> the phy, without taking into account protocol overhead or flow control,
> but including encoding overhead.

as opposed to the link speed which is

> The data rate of the medium between the local device and the link
> partner, without ...

--Sean
