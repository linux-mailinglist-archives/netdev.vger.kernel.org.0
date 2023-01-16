Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B1366CF30
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjAPSyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjAPSyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:54:32 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2109.outbound.protection.outlook.com [40.107.96.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DB25BA9;
        Mon, 16 Jan 2023 10:54:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WG0/ACm1hfPcr13g09B2nFxgvi10BLsDWJhwDqZ7XQKw2clVA8yRbc8IH45z0QNiOQ2vSN7k9wzQjRuKHD0eq9ud86Ywl6BKsCPB2jikof2M85gFXJ6r4mOJNi6bFpsV6p302dLRE6uqinus713pYeC8W7MgfvgwqifzTKnAtJjXqIEfTrdBhYETI4dgfHnvGXaaEy9Tfrw0IronaJ6wREWy89st/++9G1zAnw1j9u/5/8GQLx05q+k0Grk8VWfnhnSuQhUvW895+8B1WBblV40XDKnGATP2C770RTFCst1dMUJG2KrhuMnzBGUS3sfqU5H8Ual9wbpNDj6VouGmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+bbvyh8P1ePEApUS/FkMPzfz0fOeb8dT073bhFdS1k=;
 b=alEhEmx+94rwsBfmMKrkv2r5soXKbF3yDPdukuppuRne5ZAYjvXP29MJZ0+L+fXM8yRFMvJ+DNnOS569bRuFG9EsGu5w06PwGKl+AutJozk4v06DrQE7ht57rR6eeFHRPqaXXauB+U8XdJpUuovj2fmm7O9R/cNf+KbVcqv+4KtiU1d7NbeTGUlJt7HsyapJ8tYKG+DP9woFkqF3JMNM3gh3tt7bu3u6j4UlBqZWkVoXbauggIDZ8ktWHpk2suzx68r3rZQ1HL6ukaPfy76OwAfgp2sSuEtZJQkOMZHhRRatcTzo0g+zDJYycyFIWRvmkwnlEys8Saj7BRqdguNeQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+bbvyh8P1ePEApUS/FkMPzfz0fOeb8dT073bhFdS1k=;
 b=yj+og6qg7whEdIt7z2RD7jr59zfHpxvWPk4FHjPpGmJmvHyJnH5aK8B77g63a1LEG0s8s5XWzh3esjMSFyVLTdMS6T4cVE8fLLMYQ9ECMf/4AcOtTR3AIxWWyoYspFChD+Jn1Hfcd72DtkEndzH1bpH/SrBGh/oT07bDbJY7C3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB6765.namprd10.prod.outlook.com
 (2603:10b6:8:10f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 18:54:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 18:54:28 +0000
Date:   Mon, 16 Jan 2023 08:54:28 -1000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        john@phrozen.org, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, marex@denx.de, sean.wang@mediatek.com,
        dqfext@gmail.com, Landen.Chao@mediatek.com, arinc.unal@arinc9.com,
        clement.leger@bootlin.com, alsi@bang-olufsen.dk,
        linus.walleij@linaro.org, UNGLinuxDriver@microchip.com,
        woojung.huh@microchip.com, matthias.bgg@gmail.com,
        kurt@linutronix.de, robh+dt@kernel.org, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        olteanv@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        george.mccollister@gmail.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH v7 net-next 00/10] dt-binding preparation for ocelot
 switches
Message-ID: <Y8WdZPxZncx9E5Qz@MSI.localdomain>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
 <167389501875.8578.15890444041722037565.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167389501875.8578.15890444041722037565.git-patchwork-notify@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: 22bf56b4-4605-4788-8608-08daf7f3185a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSOt4lMNkzcKR5CoVmSvPyV7Yhi5D4Ex2W3+l6kPE7JaKb0sCUlFTpDtvtX65s7CaE3qYQiM1zvAzgqpnR47XgmrL7ZfaGR7Ma5rFQjkV2gMbEU7U0njSxPC8qjd9W3e3V7HUAjPSkqf7A9nqYogG24hFqaNzglbcLIiHb2FFjMVIDW0yHTLtQUmheXn/zY0GMTMz9+WlEFIqdbP3KEbXgWtspoXaEBYroQr6u2VWv0Ktfv0JIdsJlNNLzWdLEuitJEd1FpjmJ8ltEB4xMTWRMuMqnlg2nyfDvozMi60k7CkSXSTYQuoQLOasLrLhcP1D4YOcHAHr3Fg6q6qopR8iVJVlzkPozD0QswC8kXxpvfl26igIqPlafGjPgR8gRmrTqP7wzJr0/KgGyqVZRAoEepATRX+wndwblt+qlELOzYrY3+pSMdLO5Uj85aQQts7BlXAPKikU9KraDWSgiJRgbSFQVOnHpJaEYQXRCs+l75w8EAwmO7obgXbPJ31c8dFYGgXqv1PenXxIRrwRfX0Wb49bqnxVWYiw1ER/lvlShJ4PJMaHsP587iU92CVqqTWckEhlkzwvxSGjfeKza6tSSPTNXg4QXJCi+rteC3p/SK1ZLxf7ytKdjCB+DPBIUQ9WQI84FsNTIgXscUnTBq8pqgBi3bMEVdXGqZyplxnVn8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39830400003)(346002)(366004)(376002)(451199015)(86362001)(66556008)(8936002)(66476007)(44832011)(8676002)(66946007)(4326008)(2906002)(7406005)(7416002)(83380400001)(5660300002)(38100700002)(966005)(316002)(6486002)(41300700001)(478600001)(6512007)(9686003)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TIzXxeyVHO+jo8JEurwwywYUmEbQAn/McZ9yB21pr/uoqbDY9jIKCFEw4A7c?=
 =?us-ascii?Q?36Ypv3G/AAG1YilIEL0iCeBC3jad15lmWkG5BQfNb33IdDBwqV3beNFcXGZ4?=
 =?us-ascii?Q?Tpr24acqCrnzLL0rW6chI5gZSAa6h+8zv9a2D2AuTZpy3AVxztbQFQX8E5M6?=
 =?us-ascii?Q?H2WIUD05XMjvsz/kq1hgSMWFup7jVOlGWeJytCVw2sbcngSdkxQG3fd1jaSi?=
 =?us-ascii?Q?4L0cjc8YJTVx96jNusqD6X0GaVJLfR/DHWQMp6xz0cIQVlDCpMz5rBMp15eW?=
 =?us-ascii?Q?eSxD1XlraVR4qKv/DJmEwlgsZA20X1VFJgMi6ss502z/jrwzQzAgYklAiYdw?=
 =?us-ascii?Q?O1isBxhmhEuh0nPGld3Bv4dzRaQQEqnQMsyESUFzGoix6WMGzjI0Q2Esa/AS?=
 =?us-ascii?Q?Hetw6nM2FGujykMIhdrM6YKpxM0OJuKGrl1O3BnX+FunuFCuu5WzpCE9VwM2?=
 =?us-ascii?Q?k6PiHaNs+GG4vTIHuDA0McVCy69su63fksxaga4PuaYAdcJZd6HziI1LzJ6Q?=
 =?us-ascii?Q?3Mq7MdSnLShPIZc7q7QY545xit8Dx/e9xEodYpY251QkYpRxvB3cath7nbKt?=
 =?us-ascii?Q?cJfhz36AYJTfQJn/duYOlu3EMO/ThQT7C+lgcScFDDrsOT1NnNl5UNHsrMgi?=
 =?us-ascii?Q?aF23gF8tY24VDwzvTmErP1KEPTgpxlK3LwiCzX4FN8LAvDMV6Vl6iqX+YKb7?=
 =?us-ascii?Q?YZDBiO4pjrvnVjDUqouMEJDR0zyti3bP5jPcdMbd9Dk0uwgWm5o1DaxzEUGt?=
 =?us-ascii?Q?rf9s+nHOZttgKkg0+J/zQ8GyL8qgm4sS6r97UTA8yEX8kgjx2WMWRPzE8l5C?=
 =?us-ascii?Q?/KzJfm2hx2UM4cRTROPSoR5/Z/amhCtTtvGdgAl9j5885yWMre+5EJqPQEN5?=
 =?us-ascii?Q?0r30o875eZlcelKbr0LalH9MIBpGWxurLBHL+nENM7QQcjZCmK/B0RS29Ysa?=
 =?us-ascii?Q?yGIPT1lmRS5yPnPxcaW+gXDWAPQjYf/HnI4imiDh08TtWUwVutaxragEOujS?=
 =?us-ascii?Q?mC8DV3x0fBkFxL1jgCz7V2oL5wHlg9drC6LLAVVoHL0kZ2YysiWPJ31N1l8b?=
 =?us-ascii?Q?VNWkvrsvhQK590Td1H/IEQ9oS2baocQ/xm2GwOxx+2ASmgFr3E5LmjHpBbnV?=
 =?us-ascii?Q?k67W5FgiAImnaJWwCZVly/ylxHnm+lzNflmrRysdDsrUfdnqs/nWokUKmpQf?=
 =?us-ascii?Q?oZELc3fG5M1uz67xw5nNXzokhqLGgTPNevbAHm7R1/LRN6+RPWGf8kEJCbOO?=
 =?us-ascii?Q?Lm4EZQ6XDsJqkq+4RayAbv2c50Iv1iaY9aewp0kTVPjKkQlB0DlydBjS0SZv?=
 =?us-ascii?Q?ePkVzqHeNqM80fqvN5dJxUrUUH5Jw5h1XXLzXqTYg1IU+EMIWV6JdHmNWSXQ?=
 =?us-ascii?Q?+k0QtxewdmOCznYianD+gWuPaY8fnTJFevCNBWLoIFBHWYpeDFTIc4eqBJFj?=
 =?us-ascii?Q?Kme2+TgNK8sJU5KOapwtR1deRNrEhFpT30kudo4crV+xXdPjxMMYD8UV+5d2?=
 =?us-ascii?Q?y38ZGQVJqvaCbHXxBEVUIMVBVdS7IeicsSAvPfBEImGAQ4imO89VWYRQeGyB?=
 =?us-ascii?Q?mh9lEAq8FG08PuVKAO88//fiYZ/7W3CTgpoxO2k3HhYPAZJxi8GGBgsCM/rZ?=
 =?us-ascii?Q?Zr2ZKIp151ogUgfe7aMFwqIveEsrK1RVEOqQfms+YIr6uT28Ja5e6zHS8uxu?=
 =?us-ascii?Q?Jr73YKsdLvjXNTkyftS9QOky91s=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bf56b4-4605-4788-8608-08daf7f3185a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 18:54:28.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ziJzGSpsPnOVm7qhTKcV8EEM2G1G2Zik2JCK6uNjmDRjDuY7wnpdLiNPqfk0cpRTDbOuRVxOsb/YWTYXIyum/VcsbAitOY99risujrMabvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 06:50:18PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:

Thanks David, and everyone who helped in this series!

> 
> On Thu, 12 Jan 2023 07:56:03 -1000 you wrote:
> > Ocelot switches have the abilitiy to be used internally via
> > memory-mapped IO or externally via SPI or PCIe. This brings up issues
> > for documentation, where the same chip might be accessed internally in a
> > switchdev manner, or externally in a DSA configuration. This patch set
> > is perparation to bring DSA functionality to the VSC7512, utilizing as
> > much as possible with an almost identical VSC7514 chip.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [v7,net-next,01/10] dt-bindings: dsa: sync with maintainers
>     https://git.kernel.org/netdev/net-next/c/4015dfce2fe7
>   - [v7,net-next,02/10] dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
>     https://git.kernel.org/netdev/net-next/c/afdc0aab4972
>   - [v7,net-next,03/10] dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from switch node
>     https://git.kernel.org/netdev/net-next/c/54890925f2a4
>   - [v7,net-next,04/10] dt-bindings: net: dsa: utilize base definitions for standard dsa switches
>     https://git.kernel.org/netdev/net-next/c/3cec368a8bec
>   - [v7,net-next,05/10] dt-bindings: net: dsa: allow additional ethernet-port properties
>     https://git.kernel.org/netdev/net-next/c/16401cdb08f0
>   - [v7,net-next,06/10] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
>     https://git.kernel.org/netdev/net-next/c/956826446e3a
>   - [v7,net-next,07/10] dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
>     https://git.kernel.org/netdev/net-next/c/000bd2af9dce
>   - [v7,net-next,08/10] dt-bindings: net: add generic ethernet-switch
>     https://git.kernel.org/netdev/net-next/c/7f5bccc8b6f8
>   - [v7,net-next,09/10] dt-bindings: net: add generic ethernet-switch-port binding
>     https://git.kernel.org/netdev/net-next/c/68e3e3be66bc
>   - [v7,net-next,10/10] dt-bindings: net: mscc,vsc7514-switch: utilize generic ethernet-switch.yaml
>     https://git.kernel.org/netdev/net-next/c/1f4d4ad677c4
> 
> You are awesome, thank you!
> -- 
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 
