Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC2364ADE6
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiLMCrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbiLMCrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:47:00 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2084.outbound.protection.outlook.com [40.107.6.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C22FDD;
        Mon, 12 Dec 2022 18:46:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxrhejMb0vq2WjVi3yjSSXn2xJrU45tU96lKpojVQEwv3jeuXyo3bg+x2S6xgXms1L6+11g91V407WX7oCM9focYDULJp3lqejgH8xrgXULjNQswL+/ix+aPzzmWOOsALCVrfkPVpaIOsxLQmdeKAMMBtH+eqhwxPMCvQESdPufGW6lujALWfWze4W4ZOU5+Ol8kb8Wu1JlOphjCXiiTQEZ4eJHejBRME/I1qZDkzhuodKMdKYHpNLVTH84WjM4hWl0uMC8T8FCwvYuBVaJcdEpgOcGBYRvy5/IcAZ9P936OagtqWhXWnOIJnaD6u0qcn7lE10Yk7/vut6MClosW0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71VKqNCYuJoJxj7byREUcXD+x+o5espWvBv/edgDN/U=;
 b=N+FO5I3LZ5xjMdsERcfEH5t7Mgr6G/3tA/3YHZI9UVP6AgGNdW/y1iJOsiUk1dSUPpQkLRoi6WDgRMGSMgRl2DId3hi+g0jkhIG8JTWr/kkod5K946deApQ+UYcY/AjimV61oJr5/4FroYGgqMpTGmXRQliaQ6u2yol0rHcfm0ob2eEc95rJJpUzwN96URtri9/k+izpFFQtqei8bF1nD/Lz1pM3Z3Xk87A0LUKBUvGVSF8vhqJR962EJI4h2iCkFJi53tKwgKzzDHfKjYp9LLXxPVIXV4UO1IUxmq9Xu44yOfWwothFeVyZrp80+oaIgKeeXkk3olpo9ufIIXEyRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71VKqNCYuJoJxj7byREUcXD+x+o5espWvBv/edgDN/U=;
 b=vEpvK0v+ean6uWEpsQGkogHAHAr1UYAxF/u9u0j7Dj7G6PSAl1mICwsVeFGPtdui6Dam3J+TtvVVA5o7HGD4ka2A9+mdbfXoSQEWPnyNYth0k2+dJSxxUdsHtM+L3HIvbMt4elf3ordc9Kbt7jWha8+2iu9FSz+OPFwJZrBD8NP0VWtwlAF27IMdvx/9DZ5bzUJdbA+UIjEfFE9dQ2nPZt+WuW47e9lfSofgboCxXZ+wOTf1ZIEYzrX2ucGrtJbHIhTUBBN60836SB5X+QioXhy3vmJrOXtgdQ1152EKnRzvzhG0Jmp4f3+6tQK9OncVCQzkPCSHKfKpSoUfq97jSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by AM9PR04MB7652.eurprd04.prod.outlook.com (2603:10a6:20b:285::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Tue, 13 Dec
 2022 02:46:56 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::5b7:dd56:823:6874]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::5b7:dd56:823:6874%7]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 02:46:56 +0000
Date:   Tue, 13 Dec 2022 10:46:38 +0800
From:   Chester Lin <clin@suse.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>,
        ghennadi.procopciuc@oss.nxp.com
Subject: Re: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <Y5fnjhugp8cQSzwM@linux-8mug>
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-3-clin@suse.com>
 <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
 <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
 <9778695f-f8a9-e361-e28f-f99525c96689@linaro.org>
 <Y42jqDiiq+rOurV+@linux-8mug>
 <3908e923-a063-0377-1854-ccbb3ecc704d@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908e923-a063-0377-1854-ccbb3ecc704d@linaro.org>
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|AM9PR04MB7652:EE_
X-MS-Office365-Filtering-Correlation-Id: 73da0a50-dffd-4b72-e7dc-08dadcb44c09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIRFhwCgcxdM7e7bv3jnoyMS269ZNEJ21ZSHqhnNqh20FojsvXtysrjkSXtlqbdt4HXeOufRprrPxJtbIk8nw1RNwtW2FwPJT1+7UcFSaMURB1EuEohwASsX1Bz/v1amO70DWL46psbC7sSiIxpzEgijqbyQNMXJJofywyyMn0QjTFDmkqSeP+RsKv4XbzXprYDkIANo1eYJO+dD70APdydl/5ACBMuW4grnqj3CR6+Kd0xYZpuWyWLkWnfGhKa9sNDtyOCeKNmXs7Wc1hswcDoVNoqWV3kvcjbTtBd3PnaNOHzUOPOD/ovxyhGw8OI0k7GAFUdi/aV5RyfSXQZODDHVxpRzU7ExKidqBnELZSWxfyzyZRjXkOqL3ngToyBHxW+PbmJfwMByKtClNFqfSazPOW/CjsNG0h32InpBtwFpL2J4AJgej+PHdl3oyexHVE1w2FF+uZ+3qV4ugF7Ct/D4rTKOj8b27c557d3++ofvA3sMN+AvE2bYjrFzqu1MQOpMX4dU5aXdIlISsyO2IKamrjA7ZnXlYC0x4AUOKzt7+LjDtEHhWQ+g8hks1IOu8J86Jnwh66dwkqN+SDewMfAgb4AqT693TpWkmjoqcyimmLsnkCaXnHgZXlPsK78O8iEpYaB5VAeRoVdN/1KbccEgHxEtgoIanQVSw+/60r7l1SHjgaTel6E6i7J/ey7s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199015)(86362001)(6486002)(54906003)(6916009)(316002)(33716001)(966005)(478600001)(2906002)(7416002)(4326008)(66946007)(8936002)(66556008)(8676002)(5660300002)(41300700001)(66476007)(83380400001)(38100700002)(9686003)(26005)(6512007)(6666004)(53546011)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p9loAS5ED5HYnqGz2UEfk37mfpdK/FJcvng4m5vlCQxD4zSMPn0CHacLVnUa?=
 =?us-ascii?Q?QMTmVCpFaoP2bZVorJW+HWzCSc8w2kM53BBhFSZER+y9FeXyEDf5/XXazduR?=
 =?us-ascii?Q?u3IXF9IQuhBc2lYMNjUhjVt+S85Oj0Xr6DyAG0bEGZ6sQabicgttYCbACY4B?=
 =?us-ascii?Q?3PiMWuHQRwKN4c4dUyYLENqdYbQ6dqckYt0f6mE8wqZhTCOg2ZJkera8Um1s?=
 =?us-ascii?Q?uSqaXfgsW7lHIznTrU3xFaTekTy7+1h1Zdto20sNalGRx9lbgEdoC0PjiRd8?=
 =?us-ascii?Q?tqp/yJVA8HWY5SGu7ZltqPV3RCETt4JhvxenCoNblkhZoY19IBHvjgGG1nRk?=
 =?us-ascii?Q?XHGM6/L74A/cIND7ACz5Vnxy+hDJ8GSgKSbo+pJ0MZAiiI0ADwTCc9/SSTby?=
 =?us-ascii?Q?02ExuOHbGyi09wWNksLE+izmCTF6FTkjvz0V5kojMSDzStF0jsmJitRsOchJ?=
 =?us-ascii?Q?FS1Y8Dhy9OKMbzWfll3Qea1vCBMc4a1nfyeIx7UO54E84JPuCGVEzcVGEsll?=
 =?us-ascii?Q?tAxi76lViPXZKJ1SKQWTwAxnpe+3CJoRUtc1kBJ2Rel/0OOw7eL+rhuVNANw?=
 =?us-ascii?Q?OczcPNlAMJPhjth465JKScrIy5WotxQdEUswY6FB50Mk4q0YOkY7RSqcBh0V?=
 =?us-ascii?Q?tpCXrzYz+UYo2iSKTc8XpF8l10PFcchTqQ0EiiCEvTWb0ck4vJBt5s6oubdb?=
 =?us-ascii?Q?UhZ0jGpwlKaMyS5myJCRZx7vEAF+SosDb+SmzvHxsaJ6yk8pPYqezA1NMrKc?=
 =?us-ascii?Q?ovzNkpGlpc90AZjPJvsDMIwsmEhgR7FqWgQTIheXVOcqXQKPcJ46okORB+Nz?=
 =?us-ascii?Q?3gFb9uabEO9ilXSu2P5V0+pERYZMjOVf2XCJFT7MGQJWJWx3SPSdsiuX5gwI?=
 =?us-ascii?Q?xVzfCLCLqT8U1uscJ81WdrRkQj2OJQ5S8himNst0klYmkCx6fEKRWbKT/UoJ?=
 =?us-ascii?Q?YV4D1F/tXbYLph6X0nDQJeq82kHNEtauLiFLYv69/XsNHemGRDsOOSLxe3AD?=
 =?us-ascii?Q?ZAXq+Q/gZDRrD1QVfelDCATDIzOj5vEmglNQJcbSzNW2uHBPkQRIHZ9owpzJ?=
 =?us-ascii?Q?vY715clUKjwgcMYq4H6QELEXQzRQ9XXcix9FUzo2ONtQWRK+KE6UpQUmFLuK?=
 =?us-ascii?Q?/9NWybtdzK4eP2eu7W085VfyzU03IWSrfkkV7toGHPG37iIon94PrfFIbqA7?=
 =?us-ascii?Q?YJgibljWIYPhv311PdoJbgOXWDtTU13NYLql+SPeQFC9vxtTUp8ay8sJuqSS?=
 =?us-ascii?Q?XxBLBmido95F3egr//KMSLM05FIsspj4ri56YCvoiAH807M8EQjrzbH5HQV5?=
 =?us-ascii?Q?y8nFM6uvp0UbGRhu/SGPj54rAv0kdvbfIt9Avh9kUwPUuVBIhHiBtcZI9lVS?=
 =?us-ascii?Q?FugBvMoPT+AcGDuOSTVGo7TTLrkuL1JM3/zkGkEkwzpMTBIhi9ZTGDVEOR69?=
 =?us-ascii?Q?U7RXeaRsoPhk7RUG23bXgzjfR3v3qE2X1xL93VpoLW3tyk1dOc73V9vlXgJ2?=
 =?us-ascii?Q?VYst1/p64CmQ9sr8pQdFS0ambwiKW7rxDNufhDWs1gEjpzdzi+NA0QoOO9I0?=
 =?us-ascii?Q?QnDMQMkAAqifd8QaNTA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73da0a50-dffd-4b72-e7dc-08dadcb44c09
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 02:46:56.6005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vraDW7hgaJbnNuaFuZBg9MtYjNvp968u7vaA3+VmKKXLgMeHbh+SNYyvlsIYeqne
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7652
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

Sorry for the late reply.

On Mon, Dec 05, 2022 at 09:55:40AM +0100, Krzysztof Kozlowski wrote:
> On 05/12/2022 08:54, Chester Lin wrote:
> >>>>> +examples:
> >>>>> +  - |
> >>>>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> >>>>> +    #include <dt-bindings/interrupt-controller/irq.h>
> >>>>> +
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_AXI
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_PCS
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_PCS
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
> >>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TS
> >>>>
> >>>> Why defines? Your clock controller is not ready? If so, just use raw
> >>>> numbers.
> >>>
> >>> Please compare v1: There is no Linux-driven clock controller here but 
> >>> rather a fluid SCMI firmware interface. Work towards getting clocks into 
> >>> a kernel-hosted .dtsi was halted in favor of (downstream) TF-A, which 
> >>> also explains the ugly examples here and for pinctrl.
> >>
> >> This does not explain to me why you added defines in the example. Are
> >> you saying these can change any moment?
> >>
> > 
> > Actually these GMAC-related SCMI clock IDs changed once in NXP's downstream TF-A,
> > some redundant TS clock IDs were removed and the rest of clock IDs were all moved
> > forward. 
> 
> This is not accepted. Your downstream TF-A cannot change bindings. As an
> upstream contributor you should push this back and definitely not try to
> upstream such approach.
> 
> > Apart from GMAC-related IDs, some other clock IDs were also appended
> > in both base-clock IDs and platform-specific clock IDs [The first plat ID =
> > The last base ID + 1]. Due to the current design of the clk-scmi driver and the
> > SCMI clock protocol, IIUC, it's better to keep all clock IDs in sequence without
> > a blank in order to avoid query miss, which could affect the probe speed.
> 
> You miss here broken ABI! Any change in IDs causes all DTBs to be
> broken. Downstream, upstream, other projects, everywhere.
> 
> Therefore thank you for clarifying that we need to be more careful about
> stuff coming from (or for) NXP. Here you need to drop all defines and
> all your patches must assume the ID is fixed. Once there, it's
> unchangeable without breaking the ABI.
> 

Please accept my apologies for submitting these bad patches. We were just
confused since we thought that this approach might be acceptable because
there were some similar examples got merged in the kernel tree:

https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml#L57
https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/usb/intel,keembay-dwc3.yaml#L55
https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/sound/intel,keembay-i2s.yaml#L73
https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/pwm/intel,keembay-pwm.yaml#L39
https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/watchdog/intel,keembay-wdt.yaml#L46
https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/pci/intel,keembay-pcie.yaml#L75
https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/mmc/arasan,sdhci.yaml#L282

The defines in these yaml files are not actually referred by kernel DTs or
drivers so I assume that they should be provided by firmware as pure integer
numbers and the clk-scmi driver should just take them to ask firmware for doing
clk stuff.

Regards,
Chester

> Best regards,
> Krzysztof
> 
