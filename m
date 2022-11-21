Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6BB632C2D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiKUSio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKUSin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:38:43 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2084.outbound.protection.outlook.com [40.107.247.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CB9C6D16
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:38:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfI4lLXGnRlRo6lame8ke7uCFOaLk1nptztTz+ZAXy1iJBWMrvIqIB7ps46bTYgTYog1eP5thKfiHLOFLpGCYKJxyN6miJAhfxv1vqfuL9DlMGU49jRUsD108NPN34PPEGb4wBrPRFrB3efjcc3thBWCza3URY5vGOKIQ/5KzL+nlmrr+eQxGJfah6/ZHnsA6Htw/ivLQIamT0f32JmiB6h7QadWaECpcKlO+81gJdhvKuOBycHkHF2zX3K1az4m8ic2VFvqtj2ge+F2t4F9Ts7QE7+y5OPjSy3KmjiU2LRMkN0jNB/HbSCmWScqab4046ZFdRl3C/84Uh+Ghyl5hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxPCZahEqcXMoQRtfO0xqfjJNPYdcD2llR+tOpREmyQ=;
 b=J9lGSrPSL0lq/AEL3j8HZOnJnd70dOVXzYD2bSHHPebRmfpA7rHt2R8+G8Is+7NVxZ8d87bTFtly1gbqhe9tJkahOBWCONtjRig55Y857g4JZ0WWVFm335FM8rLMNeypaoWOT2wqEbEwRoy+hDKXjCmFLSbTVuoLPqMd1VTud3a7ibGmi1GBo5SKFCjZX3xy+NeC5Go3dVon4Y3B+hWSww0V7UaHWezMWND/ipcrEbQg/nZbGmdvZ7QEXTvenLmJLOTqQkzVNUXM2eXch5gLzJ/t69q9FTK/2a+xuHf5IGnnueE7Vg8OszP6VUXIbaRvZZymMdoJZP27XYTLpwUPQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxPCZahEqcXMoQRtfO0xqfjJNPYdcD2llR+tOpREmyQ=;
 b=w34AHTWX3r6kGGYKIJ1pGnk5fQ0lthzcI7L975WAJpgTBY0AMf3WXuEMTY/iOfSSD7zmh1424poMCN320VkCwe3cVObbZ+YwbJkPWsRvyl8mypOlP/Ejpi3ILnx9U6+pML7Bmmpnv5SRQFZEjolNU+CQ+GNb+f8SuXUenXD7DW2AxYcMxYj/qXUK+bzEdRSHsL59U+xymTm+xZYz667BBy32U8OsjDJ1fj17opLGj3ejKKNiP7QbbpSZA+uaNXPr/OaHem4HnipASRJxyTK0RuE71VwDk3ZoJCoM2zfaXf4k2ppZCw2F59YtK4esPR7heVTP/OnAR4tCV0gySHdFeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB7640.eurprd03.prod.outlook.com (2603:10a6:20b:34c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 18:38:37 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%7]) with mapi id 15.20.5834.011; Mon, 21 Nov 2022
 18:38:37 +0000
Message-ID: <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
Date:   Mon, 21 Nov 2022 13:38:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:208:335::22) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB7640:EE_
X-MS-Office365-Filtering-Correlation-Id: e77005ed-828e-4bbb-e0a5-08dacbef9993
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJdmch2H0Kx8W4Yp3vK28cEmh51Y5ulU5YR6vB9mE4lQtmRMMP2JFhFq8KuJ+jat1sZWyuRqRV9Iq0Pp88YGsND6yl7l21pLkw+jJ67fyoW0kB7eUyowVphRoP1yxebYYeiBefChiMc9ECMcPNv/fGq4K3ODwSG3j5U1m0tKeq1Nqp1DxKew4QWorys3uZ2QbIAYIJMLsyYWSpyQXTqGr4VBnS1ZuCYUEtKhcNnUpzMKPsuXmUFU9NOHIvaG2XGsBwhK1j0B53ZOpQE89bE9n007BGAMeRsT9AYOA0hXRJmu9cWzq6P2j4SsclqmtRC9QhLE2dCPdRlisKjwMqrVCqzzvIgKpXX4CB4zDBdqIrs6po7dNisGBiILwAQaC768vNkPLtRzq55UmdQKgIEoT6YmKh+Cxf9oqlO2QYIb3YAbwHd4OTeAcfGLsyxp8HyGqFaxvjbWw9oGEcr108Vl0kUsdPXFwCJgxyfCwTroUaXjDFov+5G3N4A7l+qgNL5QLKF5T9dItDPkemz6rUMYOJrHSlAqevMuiLcOX/fJ72oUnrzdf0KA+4ZPaHQQYHLSFl5cE5dOh8nVvopyLXyU5Ju5w10KBMqpopA/B1mOAaoWFsJuWNUs8bT6No6mUotG00690eC2DGaGz0TAkb/KNBr8GKYK2L2AehVKoB6SnLIFo1RRwRCqUXhWXh+JaSy8Ztz2BmX1MAtGhSZrNjyWdJsjR4WVy53j4QlwBmHPwmUQIiFRAT8dhCER1O3ukwLCoBdKpINPjKiDbIdJHJ4j+HmCwPEo0MOKlgXP14UkIMY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(396003)(136003)(39850400004)(451199015)(36756003)(31686004)(54906003)(31696002)(86362001)(38350700002)(26005)(38100700002)(186003)(6512007)(83380400001)(2906002)(44832011)(2616005)(5660300002)(8936002)(53546011)(6666004)(52116002)(6486002)(7416002)(478600001)(966005)(6506007)(66556008)(316002)(41300700001)(66476007)(19627235002)(4326008)(66946007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHdaY3ZGM1Z4aEdiRTcvb1Jyc0tBN1JsUWE2MmUyaW5jekZ4dHo5dzU2bG5o?=
 =?utf-8?B?NW1vZE0xYkNyZUg5eFVhSVZlNmxtcVZiRklKdmd1V0ZPNkhrTlpoOHlBV0gx?=
 =?utf-8?B?NENLdTVkdHR4THlvUnI5UWVqZWFudFBxaU5rQm9yMFYydmxMRE91WEFLaVo1?=
 =?utf-8?B?ZFE5WkNOem5jZmd6SjFteVF5R1Rqb0tpYmlmWncrMm1YVituQVF3Y1Y1R01Z?=
 =?utf-8?B?eGVDNEx0NUNpWlppK2ttWCsyRVZqbXFmdUxmbjQ5TjIxUTNUR3lKVXhvQy9G?=
 =?utf-8?B?M1hJanNZVEVUZ1FLR1dVUy9jMlErNE1SVHl0azdKVW9sNEdIdEVzZkFLdStW?=
 =?utf-8?B?SGF0ZTYyWnFTbk4xcnVURWZvT205QnFCOWp4MElOanYrMU83N0NUQzdWREE1?=
 =?utf-8?B?THlzRklSNit3U3h3MzNTbkJ5ZU1QMEZtR1NoWW9ITWtQbGxwNGRIWG82Zkw3?=
 =?utf-8?B?U3AzOW9MM0FWQUFaNTk3RzkrMnlJOHNzbTRlTjhkeE1GZ0ZLWWVISVVhV3JW?=
 =?utf-8?B?RnR6MmRZcGVMWGtoUlhBVUltOU95ZXJneTFqeUZFTEpMZm5oWmFsU2NXaUJy?=
 =?utf-8?B?MnQrYlZnWHVLbGd6eUg2QzZqYlFvZCtUSzhtL0xLUTNNbTFOZHNQcWlYQmdI?=
 =?utf-8?B?YkgvQUU5Q2RxMU5iNkowQnQrYjZwSDM5Q3pINURuMXBoZGQ4R2ZCcmFHbG1R?=
 =?utf-8?B?ODNMQjBUTTBobTM0UExyU0d5emFkYmszUVZYRDlBZDE5QnNMVk11T1BkZUJ5?=
 =?utf-8?B?dmxjMXVlOFlPa2hTVU5aNTYwZmNxdk9CVzVaSU85dURMZnBMVkt2VWl1WWFE?=
 =?utf-8?B?TjBUR2ErSE9OeW5lUTNkMmYwNnNkSjZrd3VTS0Zvc0JKL2drQ3RGb1FhRFhX?=
 =?utf-8?B?MlA5eHpEa1FoRi81R1J4VHg0SjVRMVJsYTJWRXdJeUx3aXplMjJVRFBQb2s4?=
 =?utf-8?B?dDFxRTVVdU80ZHZkSjh1Y09WaU5yZTdtbkgxa2I3M2NNSXhqUDYrUDgvVFNO?=
 =?utf-8?B?TnJ5dWFNL1A3SVNaem9rMmtBeGNaUWl5RUZuQ0NIUjUvSUU5Uld1bjZVTFU0?=
 =?utf-8?B?NkROOXZBL0xFNlI3YkF4SzhRNTg2VXpWOVVQWC8wOGpqY0tKZEtFWDNxNnNH?=
 =?utf-8?B?Q3VlL1VlbGlIMm5wQ0tYVm96U2hWR2N2RlAwVVRHQXJ1QVU2T3BlZkxaL2R5?=
 =?utf-8?B?YzZzQ2lCeXJvMmtqWFFmRHVTZUZlTVgyRDJ1czhqblNaY1FzblFXUW9oMjBX?=
 =?utf-8?B?MGVZQ0JBMDI2TlZhTEkyU2NyWDhzdlpWZkE1ZE9pZFMzeDkzY2YxazlYZWgy?=
 =?utf-8?B?cVF1SUpMZXdHTFZpeXVvcGx6RmRxRFRxNmpCcUZhRjlvR3NMZUJST213U2hO?=
 =?utf-8?B?alRLcXNzeEppa0RrWEFRQk82bmFYZGJ0VUlNa0VDUklLejBWL1Q1Y29leHlR?=
 =?utf-8?B?L1NOb1AvclRoSzFXNkRkRFVSbmt2S1c0TEdzQUsyNERpMlBmZVhVZFppZkVj?=
 =?utf-8?B?TkxXei9oVG9mOEdnb3FOK0Y1bVptL1NROEM5bndjNnFwVXJFTzdFdmVGQkZh?=
 =?utf-8?B?aXpGcVYwaTFJSFMrM3lKQ3orM1orUmRWYjloNEd4Nnl6VGxrenRBZjFTTWp5?=
 =?utf-8?B?RUJLOVpTWW5sM3NQay9pNGZ5cHR4UEh3a2pIWm9vdDZUSlQrMm5UMTZmWlRk?=
 =?utf-8?B?d0E3cWdaN2ZrUTN5MEZmRzIxN2RGQzdEOHUwUEphUStlaWxpcHFneXFXcXhV?=
 =?utf-8?B?TXVIT29FOVFuRTlzWjk2R3VlRDZSTVgxL3YrTFBwU1JCelcxV0M2R1JqNnRH?=
 =?utf-8?B?ZFMybzlNeWYyKzBjbmxoVGFGeWptME9zL2RIQmJETlN6NGdaYS9PWFYxdHUy?=
 =?utf-8?B?MWRaeHR6blBrNGlFdS9XbXhzMUFhVjVnT2l0eko5RjdoZFl2VkxEeW5YYVJu?=
 =?utf-8?B?RDJONW1kMXgwbjVBazFQK1pEaUhUL2FBeDcreHlJNjdQbmxBUnN3U3djMlpZ?=
 =?utf-8?B?UDJzcmNrUXNwR0o1WnZBNWhhT0dGR2FBNjNucUs5allINXpRa2xIcjA0Z0Jk?=
 =?utf-8?B?SHlHZVJPNlp6ZnpxNkRkZXdFbDZvTmZHNmFDK2xzM1BCQ3hUSk1sbXo1UWFV?=
 =?utf-8?B?WERVdUU3b3ZHekdDSTFHY05tTVgwcnZZTEJNV24vVWtldjZzWTgwZmQ5V2RD?=
 =?utf-8?B?NVE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e77005ed-828e-4bbb-e0a5-08dacbef9993
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 18:38:37.7134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RyE9aKhhjpBTx7fpSOcrDAi6YekcjgozzS+zQdtQeaN0vN8NagEtjAV9RP2emzpkYFlaBswyrPc+pyopSb8hEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7640
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 11/17/22 19:01, Vladimir Oltean wrote:
> Problem statement
> ~~~~~~~~~~~~~~~~~
> 
> The on-board SERDES link between an NXP (Lynx) PCS and a PHY may not
> work, depending on whether U-Boot networking was used on that port or not.
> 
> There is no mechanism in Linux (with phylib/phylink, at least) to ensure
> that the MAC driver and the PHY driver have synchronized settings for
> in-band autoneg. It all depends on the 'managed = "in-band-status"'
> device tree property, which does not reflect a stable and unchanging
> reality, and furthermore, some (older) device trees may have this
> property missing when they shouldn't.
> 
> Proposed solution
> ~~~~~~~~~~~~~~~~~
> 
> Extend the phy_device API with 2 new methods:
> - phy_validate_an_inband()
> - phy_config_an_inband()
> 
> Extend phylink with an opt-in bool sync_an_inband which makes sure that
> the configured "unsigned int mode" (MLO_AN_PHY/MLO_AN_INBAND) is both
> supported by the PHY, and actually applied to the PHY.
> 
> Make NXP drivers which use phylink and the Lynx PCS driver opt into the
> new behavior. Other drivers can trivially do this as well, by setting
> struct phylink_config :: sync_an_inband to true.
> 
> Compared to other solutions
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Sean Anderson, in commit 5d93cfcf7360 ("net: dpaa: Convert to phylink"),
> sets phylink_config :: ovr_an_inband to true. This doesn't quite solve
> all problems, because we don't *know* that the PHY is set for in-band
> autoneg. For example with the VSC8514, it all depends on what the
> bootloader has/has not done. This solution eliminates the bootloader
> dependency by actually programming in-band autoneg in the VSC8514 PHY.
> 
> Change log
> ~~~~~~~~~~
> 
> Changes in v4:
> Make all new behavior opt-in.
> Fix bug when Generic PHY driver is used.
> Dropped support for PHY_AN_INBAND_OFF in at803x.
> 
> Changes in v3:
> Added patch for the Atheros PHY family.
> v3 at:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210922181446.2677089-1-vladimir.oltean@nxp.com/
> 
> Changes in v2:
> Incorporated feedback from Russell, which was to consider PHYs on SFP
> modules too, and unify phylink's detection of PHYs with broken in-band
> autoneg with the newly introduced PHY driver methods.
> v2 at:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210212172341.3489046-1-olteanv@gmail.com/
> 
> Vladimir Oltean (8):
>   net: phylink: let phylink_sfp_config_phy() determine the MLO_AN_* mode
>     to use
>   net: phylink: introduce generic method to query PHY in-band autoneg
>     capability
>   net: phy: bcm84881: move the in-band capability check where it belongs
>   net: phylink: add option to sync in-band autoneg setting between PCS
>     and PHY
>   net: phylink: explicitly configure in-band autoneg for on-board PHYs
>   net: phy: mscc: configure in-band auto-negotiation for VSC8514
>   net: phy: at803x: validate in-band autoneg for AT8031/AT8033
>   net: opt MAC drivers which use Lynx PCS into phylink sync_an_inband
> 
>  drivers/net/dsa/ocelot/felix.c                |  2 +
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  1 +
>  .../net/ethernet/freescale/enetc/enetc_pf.c   |  1 +
>  .../net/ethernet/freescale/fman/fman_memac.c  | 16 +--
>  drivers/net/phy/at803x.c                      | 10 ++
>  drivers/net/phy/bcm84881.c                    | 10 ++
>  drivers/net/phy/mscc/mscc.h                   |  2 +
>  drivers/net/phy/mscc/mscc_main.c              | 21 ++++
>  drivers/net/phy/phy.c                         | 51 ++++++++++
>  drivers/net/phy/phylink.c                     | 97 +++++++++++++++----
>  include/linux/phy.h                           | 27 ++++++
>  include/linux/phylink.h                       |  7 ++
>  12 files changed, 212 insertions(+), 33 deletions(-)
> 

I tested this on an LS1046ARDB. Unfortunately, although the links came
up, the SGMII interfaces could not transfer data:

# dmesg | grep net6
[    3.846249] fsl_dpaa_mac 1aea000.ethernet net6: renamed from eth3
[    5.047334] fsl_dpaa_mac 1aea000.ethernet net6: PHY driver does not report in-band autoneg capability, assuming false
[    5.073739] fsl_dpaa_mac 1aea000.ethernet net6: PHY [0x0000000001afc000:04] driver [RTL8211F Gigabit Ethernet] (irq=POLL)
[    5.073749] fsl_dpaa_mac 1aea000.ethernet net6: phy: sgmii setting supported 0,00000000,00000000,000062ea advertising 0,00000000,00000000,000062ea
[    5.073798] fsl_dpaa_mac 1aea000.ethernet net6: configuring for phy/sgmii link mode
[    5.073803] fsl_dpaa_mac 1aea000.ethernet net6: major config sgmii
[    5.075369] fsl_dpaa_mac 1aea000.ethernet net6: phylink_mac_config: mode=phy/sgmii/Unknown/Unknown/none adv=0,00000000,00000000,00000000 pause=00 link=0 an=0
[    5.102308] fsl_dpaa_mac 1aea000.ethernet net6: phy link down sgmii/Unknown/Unknown/none/off
[    9.186216] fsl_dpaa_mac 1aea000.ethernet net6: phy link up sgmii/1Gbps/Full/none/rx/tx
[    9.186261] fsl_dpaa_mac 1aea000.ethernet net6: Link is Up - 1Gbps/Full - flow control rx/tx

I added a `managed = "in-band-status";` property, and this time data
transfer worked:

# dmesg | grep net6
[    3.826156] fsl_dpaa_mac 1aea000.ethernet net6: renamed from eth3
[    5.062654] fsl_dpaa_mac 1aea000.ethernet net6: PHY driver does not report in-band autoneg capability, assuming true
[    5.089724] fsl_dpaa_mac 1aea000.ethernet net6: PHY [0x0000000001afc000:04] driver [RTL8211F Gigabit Ethernet] (irq=POLL)
[    5.089734] fsl_dpaa_mac 1aea000.ethernet net6: phy: sgmii setting supported 0,00000000,00000000,000062ea advertising 0,00000000,00000000,000062ea
[    5.089782] fsl_dpaa_mac 1aea000.ethernet net6: configuring for inband/sgmii link mode
[    5.089786] fsl_dpaa_mac 1aea000.ethernet net6: major config sgmii
[    5.090951] fsl_dpaa_mac 1aea000.ethernet net6: phylink_mac_config: mode=inband/sgmii/Unknown/Unknown/none adv=0,00000000,00000000,000062ea pause=00 link=0 an=1
[    5.118325] fsl_dpaa_mac 1aea000.ethernet net6: phy link down sgmii/Unknown/Unknown/none/off
[    9.214204] fsl_dpaa_mac 1aea000.ethernet net6: phy link up sgmii/1Gbps/Full/none/rx/tx
[    9.214247] fsl_dpaa_mac 1aea000.ethernet net6: Link is Up - 1Gbps/Full - flow control rx/tx

I believe this is the same issue I ran into before. This is why I
defaulted to in-band.

--Sean
