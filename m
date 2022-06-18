Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDF15505EB
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 17:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbiFRPxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 11:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRPw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 11:52:58 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39934B95;
        Sat, 18 Jun 2022 08:52:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBSWo/9rSkjHXjr6N6jIgj3+FGQ2vSrzgrVPqa1UoEMtsQ6hcxD/mimkZ6wkt+12kmci156wWLRmIjXtHw96yFd5+90Nf6r8HG02MPm0OUzj7qAwiztFvaxxZgRb9OFfIN7LcWqmAsyZ1G6Im0Ttf99Zr3fMjapmp3K8GtoHmdh0BWhTttQk8rbFap7+UGp9uiWIgyBcEo1w3W97nWROFRL0nHgsK9H0kZ/yWXK42qDvvrmP0rAelGUarhpeFF27x3L8VYoS1tho+2WqrV90W8Zm9j/SUgALQymrW237r0fTEH1vhJi/QR6vKBPuZ5/O0D+b2veKzGhemvMDCuh7EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZfsB1mYcVzGu7E833qw5u/x2zjd793LtQXnRGKpGlo=;
 b=Zh1P+nMfwjeVww2MffZdFAdU7YEP/kwQ20PeY+6LKy/KGewiTj5ORGzQ/HOap0g1lPo5hP6OgptfKL5+Bz32TPjwHeidJQu6h3xl7d5mfbQim2/MngOiWBMfGtFhGkjBPfeEX5NuZpzXIhvP6wLvAWSC5wg9BIh8sq3E36txCot/RVGRNd0+xiW3TWTGhbb1XB14+j7nxgFcjMqRDWSxz3qgN70hjaZ6R5dFY8Z9OvrWM4A72SdbVfhezA/STYZyMPa0ss2x41eF1clotDW5oA0Tmk/1lBh8BUd9gccCtJ+/Wc/cmzmDt5deUMYDOCGI+SOUN5q9pr6/diBViSiMZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZfsB1mYcVzGu7E833qw5u/x2zjd793LtQXnRGKpGlo=;
 b=aIzTBuRhy/LRR1+S7mSHDX9T0V/DBoX1DlR8JPTvUmXGIdlqW/B0fgD8vLzjjs56yItOpsw4DE0FNZr6AuckgrPaWy7TKKKNOCXyciMZPwx7YhStCwvvSi8ONp2lt0t+WSuBEyj6T4ZMOy0UYJ6xEfXhJ21HvMNmlnkkb5FzcErKWDM3cplAaHEnsEoG+7Io1m7+VKis5dlEoa7xUvPixdMon4zjXL/Y4N6cCkdF4uUjzI5nNALuwZgZP+hRZYmUrq3RedpQnCGa27q3RlQ3qYoTJ4vrG9ZzsFjIy1N1h214B6OgQNzRoDW0hwZJxl5r6S7+iRXaYmQ5IQRJUIFpYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4601.eurprd03.prod.outlook.com (2603:10a6:10:16::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 15:52:53 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 15:52:53 +0000
Subject: Re: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-4-sean.anderson@seco.com>
 <GV1PR04MB905598703F5E9A0989662EFDE0AE9@GV1PR04MB9055.eurprd04.prod.outlook.com>
 <GV1PR04MB9055F41AD598F85648B54EE2E0AE9@GV1PR04MB9055.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <df411ea9-b12e-09f2-6f96-0fb4a023cb7d@seco.com>
Date:   Sat, 18 Jun 2022 11:52:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <GV1PR04MB9055F41AD598F85648B54EE2E0AE9@GV1PR04MB9055.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0114.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 785755df-a736-4ada-50cf-08da51429a7c
X-MS-TrafficTypeDiagnostic: DB7PR03MB4601:EE_
X-Microsoft-Antispam-PRVS: <DB7PR03MB460135AB99BF98594984703896AE9@DB7PR03MB4601.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eA5TczEJfRy0J9xcdkxums9M9xLI9U1RoUEXgOdss/zgfydMa1MYgB4pDfNAGgv7QeQ0XKug3EbFVUsEqbZLD6yRclt5uytzU8lMZQZBdaFNJToS8rAW/VBgXnA338bZ/UOrLYhj8LMSACdE/HJSuqQ7tVTEG5u9N4i17NaLLfXYX/tmCmnA8s0dYYhY8+xYf/z8kagd5P8vYaitUN73JwUSDRgBhLqp4ziBTstzBcE+EsHPiC+HFHmuz+5CRSQ8HV1a3ooukRmflsFviXAeSoT+pRYyQymGqZDJFszRoMFCwf8wXJ8JpRVuFXe9ioeXmbtqHLnlgIPQXdKMaLUkwNjdw0gtYtwYjEZdoF1PYAMvJGXwnHhKnZx8yI21YPMJNuFUDoh0t+JXU0eY4POQ8kbR7mvS+6gZUDmdaE2EnhnI4xydkq2OpZnki1uHJWyHGT3Jrh9+osNjMSAN7TOiJNKLdODPpYrMZuYtQpF832UmiCXzLdFsh58msxmYc7ZTuefd7IT0I6j3VpcURivINMh0u9XUJ54w4PGIGGW+OzTHPEhJqyHrh1UXP6/b4+AO8a+Mh3a6+QLX80vF23XzeeiZ/tNbKOi9KEe8eirhNT74RfqoestckjBC9oV6OOz8dblTCl9wu6zXChNRT/M/AKQNzvI+urMJPpGVOMUleJWRbI41lgv8lav35myi/TLtsbxnZfKOmhioSXlO+UssnRNhC2+wKT5BxxuQBGUhPUYepDmzXECQkpga8tBXq54wpawLGSYfpXeJxC4fmxFiXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6512007)(26005)(66556008)(4326008)(316002)(31696002)(110136005)(53546011)(66476007)(52116002)(86362001)(2906002)(6666004)(6506007)(66946007)(54906003)(8676002)(8936002)(36756003)(31686004)(7416002)(38350700002)(5660300002)(38100700002)(6486002)(44832011)(2616005)(83380400001)(186003)(498600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjZzWnMyWnFWM2VXcjc4VGh2MGliWGtQdEtBcHRRaHorczgxMVhyOUIyaERh?=
 =?utf-8?B?RnFHUTJqMzV0bmU5aTVBRmZtTCsveE1hL0JBdklSZDRaYTFmSmVGZHJDNzVj?=
 =?utf-8?B?dGRIZGo1dmZXVVFFQllVTWo2VGxVSkNJM0cwV1lZMVZHRTFMR0lsWERlcDVo?=
 =?utf-8?B?bGJDblpjY0xrYzBaOVBlOWJLK2ZjcUVFKzI0OUYraGtmS1ZpM2grclVCTS9E?=
 =?utf-8?B?eFdWYUdzOFZuRVU2ZUJsdEdKdWdQcmx3akxjcGw2NVVrZGcwTTVpVkhDT2xy?=
 =?utf-8?B?ckxhcU0wWVF0WkZEK0wyVVAzSWozcUx3dXNnYnpNVThSblJCdTU3OEN2N2hY?=
 =?utf-8?B?eGFIU3c2MzhpTTNGbmhoT3ZCUDY4VmM2T2JPSmc3amRyMldZenM0bE5yN0hL?=
 =?utf-8?B?YktxTVQ0dnhrVzR5RzEvTjM2NWFJODdCMUgvc3htbjBadStKWWU1YlRUOTM2?=
 =?utf-8?B?cytIaWsxaUZVSVd6WlpKMTBYM3VLV0JMdjE4QzFTVHVkb29CY1RaQnRoamky?=
 =?utf-8?B?WnVhV3RYem9OTkNsekNnc1F6eVU4Y05XWWZLSjlwYk5FdzdIVW5BK2FZd0RX?=
 =?utf-8?B?NFp3MzNSMTlRblREWnRGM014M3dDbjB2WTBNT2orZGlJMjNLM3Y5RWdJd2Ji?=
 =?utf-8?B?cHFDV0tiUHhOZTNPS0ZwdEQxWWRWRnNBaG8rTmVKSWFqRGtJZ3hYTkVGS3I0?=
 =?utf-8?B?MDNic3A2YjFPRE9qaWsrdENlek52ODU2RjNvTnNZQmZ6Z2wyNkxiTy9qKzBZ?=
 =?utf-8?B?RmJ1VDlrc3FqaVVsVlFrVlcvREZTYnBoRTlBTm1KNzdoaXJYNlBOWnprR3lW?=
 =?utf-8?B?WGdPWGZOTGhWQ1hWSmpTNnJnUUdwVUIxcFpzYzZZamowNzFsWm1iOWg0aEtK?=
 =?utf-8?B?WkErMjRXeVNSNEVRczlydmczZkVBOVByQm9zSEhUTjhyRjduUFBLZmUwVjZB?=
 =?utf-8?B?ZUI4YW83dVdjcXl0eUZocTNHNy9ZSWxUZmdUbytLM1NUelQ0b21qMW9qeUsr?=
 =?utf-8?B?dW84Uk84NVlGZ25VK2hhNGUrelh6MzJ2Q0lhWHhDN2h2aHJVZkZ4Um1xcVZN?=
 =?utf-8?B?S1ZmZ3EyYU4xYlc3bWhzT29RRnRXeHBGdzR2WHBiUGFabUhOSU1UWVAxU003?=
 =?utf-8?B?STZUMGRGU3U4NkRhR24vYjdRSUtYeHp1alNtQUdaVDh2T1RjMVk2OG9EbkEx?=
 =?utf-8?B?a2tJa3RTSy9LMjdIWHhqUjNwN0JUcW4vVmNwb3g2Y0YxYkJXUkN5c2VpN05y?=
 =?utf-8?B?UFNjbDdJWFRYNVB0bytRUE5vMGZWME1GRWZLbHVjMjh0T3c5S0YvWHJVcnUx?=
 =?utf-8?B?MTVBS1N1S0xXZ1AxS2dXMFVGU3BvUXhxVUZvUlNxeEpWeGpBVU45Qjh2TzhN?=
 =?utf-8?B?Q24xVXdyR2tldFMrTDJjcUdWSE9lQWlQbmlGTXFUblo5QWFTZU84UTF4bFBy?=
 =?utf-8?B?STc3SlM5aCt4ZDF3MU9oblV1QjBIdEI5MEpFYk4yRjl4MHhOaHc4eEt6RzNR?=
 =?utf-8?B?NFBnZmlKVGVDcFJIc0ljMjU5SnJFZjc4V2ZQT0JocXhHVlg1TFgybndFVmhY?=
 =?utf-8?B?OWNPMGkvOXFuRzdTMXdqYlBoRXpZdGI5Qjh5WkxDWDBaL01IVmFtM2FuYmtN?=
 =?utf-8?B?VVhLejVvV0F5cjR3S05JWi9MTHEwVlhvRnZQUWF0c3VDWURPQkRQSHRTTzky?=
 =?utf-8?B?ck1aTnpWQVlSWU9OYTdzRGdKUnNMZlBRMTc0Q2cvZGFTOE1ZVVVYMzdncTFT?=
 =?utf-8?B?ZXl5dFlkdXRza1d3c3lZMitaODQvck01Z2sxekxjYmVUcjZzcXQvSWJLNHRV?=
 =?utf-8?B?N3k0YzhOZzZmTkMxZGFFcXFDTDJLWDM5RG14MmM4ZWZhL0tjWWk2MjF6c1Q2?=
 =?utf-8?B?Myt0YXZNTzY5RE5WaVlxWjVDQTQ4ejN3YmIrQm9HVUF1aUJJQWRoZkdCdHRM?=
 =?utf-8?B?bFREdzVRRitnQ3FUbWdpV2NGVGNKSHQvTmJXUHdidGExUkg3VDRmSWNQWCtG?=
 =?utf-8?B?WnEvUEtnR0tJZXRsbCt0cDMwT25NK2pJYXAzY0tWOWhXOFhsUm5PVXZzbmFS?=
 =?utf-8?B?dEFEa05tQ0FNczNQcnYyR25Kb0M3NnBSTmduRGg5S1drU2F0d0pEcTBaRStP?=
 =?utf-8?B?OTJ5cDRsbVpCMGRHQ2RDcHE0Wk1lZHBCR3hPTERKRFZsYk5aaVhUbDJueDZp?=
 =?utf-8?B?ZUtRZ3lsV1Rrc0laTFhXREJLU2hYV2czdU1nZEZ0T3R1MUFqekpUWGNvbUlM?=
 =?utf-8?B?L3VrNk0xTGUweHdtU1d5WElVSVdvZjVFQzVoY3JMSFN5MEJwempFV0xmZmFl?=
 =?utf-8?B?OVpBV3V6aFhYVGRIeVdkcVgzZysyL1p2RmlWVE4zZFB2WlpIQ0NWeXFSUTB0?=
 =?utf-8?Q?Z65Us7guRQSrjg2Y=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785755df-a736-4ada-50cf-08da51429a7c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 15:52:53.2094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YGSnVqdy2kB+H6Wolx14fqNueeBpC9jxzrqeDcinV1q8WfrTmEkrs62gNR+Jp/nn3W2SeFmvksG5D263B8E9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4601
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

On 6/18/22 8:39 AM, Ioana Ciornei wrote:
>>> Subject: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver
>>>
>=20
> Sorry for the previous HTML formatted email...
>=20
>>
>> Hi Sean,
>>
>> I am very much interested in giving this driver a go on other SoCs as we=
ll
>> but at the moment I am in vacation until mid next week.

Please let me know your results. I have documented how to add support for
additional SoCs, so hopefully it should be fairly straightforward.

>>> This adds support for the "SerDes" devices found on various NXP QorIQ S=
oCs.
>>> There may be up to four SerDes devices on each SoC, each supporting up =
to
>>> eight lanes. Protocol support for each SerDes is highly heterogeneous, =
with
>>> each SoC typically having a totally different selection of supported
>>> protocols for each lane. Additionally, the SerDes devices on each SoC a=
lso
>>> have differing support. One SerDes will typically support Ethernet on m=
ost
>>> lanes, while the other will typically support PCIe on most lanes.
>>>
>>> There is wide hardware support for this SerDes. I have not done extensi=
ve
>>> digging, but it seems to be used on almost every QorIQ device, includin=
g
>>> the AMP and Layerscape series. Because each SoC typically has specific
>>> instructions and exceptions for its SerDes, I have limited the initial
>>> scope of this module to just the LS1046A. Additionally, I have only add=
ed
>>> support for Ethernet protocols. There is not a great need for dynamic
>>> reconfiguration for other protocols (SATA and PCIe handle rate changes =
in
>>> hardware), so support for them may never be added.>
>>> Nevertheless, I have tried to provide an obvious path for adding suppor=
t
>>> for other SoCs as well as other protocols. SATA just needs support for
>>> configuring LNmSSCR0. PCIe may need to configure the equalization
>>> registers. It also uses multiple lanes. I have tried to write the drive=
r
>>> with multi-lane support in mind, so there should not need to be any lar=
ge
>>> changes. Although there are 6 protocols supported, I have only tested S=
GMII
>>> and XFI. The rest have been implemented as described in the datasheet.
>>>
>>> The PLLs are modeled as clocks proper. This lets us take advantage of t=
he
>>> existing clock infrastructure. I have not given the same treatment to t=
he
>>> lane "clocks" (dividers) because they need to be programmed in-concert =
with
>>> the rest of the lane settings. One tricky thing is that the VCO (pll) r=
ate
>>> exceeds 2^32 (maxing out at around 5GHz). This will be a problem on 32-=
bit
>>> platforms, since clock rates are stored as unsigned longs. To work arou=
nd
>>> this, the pll clock rate is generally treated in units of kHz.>
>>> The PLLs are configured rather interestingly. Instead of the usual dire=
ct
>>> programming of the appropriate divisors, the input and output clock rat=
es
>>> are selected directly. Generally, the only restriction is that the inpu=
t
>>> and output must be integer multiples of each other. This suggests some =
kind
>>> of internal look-up table. The datasheets generally list out the suppor=
ted
>>> combinations explicitly, and not all input/output combinations are
>>> documented. I'm not sure if this is due to lack of support, or due to a=
n
>>> oversight. If this becomes an issue, then some combinations can be
>>> blacklisted (or whitelisted). This may also be necessary for other SoCs
>>> which have more stringent clock requirements.
>>
>>
>> I didn't get a change to go through the driver like I would like, but ar=
e you
>> changing the PLL's rate at runtime?

Yes.

>> Do you take into consideration that a PLL might still be used by a PCIe =
or SATA
>> lane (which is not described in the DTS) and deny its rate reconfigurati=
on
>> if this happens?

Yes.

When the device is probed, we go through the PCCRs and reserve any lane whi=
ch is in
use for a protocol we don't support (PCIe, SATA). We also get both PLL's ra=
tes
exclusively and mark them as enabled.

>> I am asking this because when I added support for the Lynx 28G SerDes bl=
ock what
>> I did in order to support rate change depending of the plugged SFP modul=
e was
>> just to change the PLL used by the lane, not the PLL rate itself.
>> This is because I was afraid of causing more harm then needed for all th=
e
>> non-Ethernet lanes.

Yes. Since There is not much need for dynamic reconfiguration for other pro=
tocols,
I suspect that non-ethernet support will not be added soon (or perhaps ever=
).

>>>
>>> The general API call list for this PHY is documented under the driver-a=
pi
>>> docs. I think this is rather standard, except that most driverts config=
ure
>>> the mode (protocol) at xlate-time. Unlike some other phys where e.g. PC=
Ie
>>> x4 will use 4 separate phys all configured for PCIe, this driver uses o=
ne
>>> phy configured to use 4 lanes. This is because while the individual lan=
es
>>> may be configured individually, the protocol selection acts on all lane=
s at
>>> once. Additionally, the order which lanes should be configured in is
>>> specified by the datasheet. =C2=A0To coordinate this, lanes are reserve=
d in
>>> phy_init, and released in phy_exit.
>>>
>>> When getting a phy, if a phy already exists for those lanes, it is reus=
ed.
>>> This is to make things like QSGMII work. Four MACs will all want to ens=
ure
>>> that the lane is configured properly, and we need to ensure they can al=
l
>>> call phy_init, etc. There is refcounting for phy_init and phy_power_on,=
 so
>>> the phy will only be powered on once. However, there is no refcounting =
for
>>> phy_set_mode. A "rogue" MAC could set the mode to something non-QSGMII =
and
>>> break the other MACs. Perhaps there is an opportunity for future
>>> enhancement here.
>>>
>>> This driver was written with reference to the LS1046A reference manual.
>>> However, it was informed by reference manuals for all processors with
>>> MEMACs, especially the T4240 (which appears to have a "maxed-out"
>>> configuration).
>>>
>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>> ---
>>> This appears to be the same underlying hardware as the Lynx 28G phy
>>> added in 8f73b37cf3fb ("phy: add support for the Layerscape SerDes
>>> 28G").
>>
>> The SerDes block used on L1046A (and a lot of other SoCs) is not the sam=
e
>> one as the Lynx 28G that I submitted. The Lynx 28G block is only include=
d
>> on the LX2160A SoC and its variants.

OK. I looked over it quickly and it seemed to share many of the same regist=
ers.

>> The SerDes block that you are adding a driver for is the Lynx 10G SerDes=
,
>> which is why I would suggest renaming it to phy-fsl-lynx-10g.c.

Ah, thanks. Is this documented anywhere?

--Sean

