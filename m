Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751C26264B4
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiKKWiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiKKWiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:38:20 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2081.outbound.protection.outlook.com [40.107.104.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087B6716C9
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:38:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nys+pKsuTwPr7sCp78f/JEO8qB6BKlys4kEQiYER78Oml2xi9qRrZR4TAm3ou4EUy88z/xsxAP3vMz5PrEVwxs6UwqDw6tX+3+h4Oa2tn2Ej/2DDnkEcEZlhZSHVhSlEJtRgwll/j3KcoD5qlcEGGpx/AjxbL8tfDkUNtQU3w5waqmPuDhdX/U4898dJ+pYPMJPZ2FD7HOD9dKU+e5dSw/FGf/pezsF8XRiaF11BhyM/Iqdl06FgGT2Tp6lGLkymu/HcoKPXQBHfI5Vr1EOVdbOcxIlf+58K3JQO8+bUJkjYTjUeM93s/xP9vGIzOfmC1PNM3v6Q5F/Lu/svqxsKFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRxw81LAcTGd59gjatb+z55FEQReLYmRwS0yzwKH2XQ=;
 b=b6nrDtpj0NybS/FaK4Xuyu6KWCFlgINUfiFgCzzGN2vz8E/53/CfsT6tU6KCx10ZqvnZK4orbkNcQLcmhKm2D3Fcc7jCOV8F/xG4gKGSrbFU1cqNcWZLs+fcLNoQDXuU0Lq+Omu/L1j6M3I6p81r4F4sw/XTh2TbSR2tGJg6u9kDfAp8UvBqPDN+8t33PHJAMtDv+DxU1enxzvsLfCZb3Zo10CO6PXqsvl8PpSaQEuYOiyZ/ua/eUOxlvclW1+ktm5+5vOSaCc1wNCmWiPJHfpUK3WYmQfKmoUhhmPzrMzkJts6k2SJNW8fhaLPnWBR8Sjs5qY1Jp1DlUYOsCbxIBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRxw81LAcTGd59gjatb+z55FEQReLYmRwS0yzwKH2XQ=;
 b=gOZOCmcxMLxTf5T6MvAD6WTlTpXn11tm8Y8OYUAqnDwPA84n8UyK5kGZG4AOX+cGPF2v06GCkqc81dJNNA+H5mtYZdUTQgzqee+50GzD+M6cTTJmvPEIL3q7LK/O9n6Zn1yh5xoKfclf4srlPWjvRMUaXI+cjH4kGWabh/O+D9gskE2Hig+ajNgPfgJUZ0nTp+1igyzEfvjeNjCEPij+diQYfjaMCVawb3z35uT+zXdJEK6wG2CoSwlrUTwmTuF655fbaaV0POqjVE+KP1RDGGUE9sQdG0grO5/veAwQosXj1YMrzhEFuShP6sixDTiL4Sri5rVhW1Nz95mA6PiJEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB9862.eurprd03.prod.outlook.com (2603:10a6:20b:563::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 22:38:15 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 22:38:15 +0000
Message-ID: <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
Date:   Fri, 11 Nov 2022 17:38:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: status of rate adaptation
Content-Language: en-US
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
 <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0005.namprd12.prod.outlook.com
 (2603:10b6:208:a8::18) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB9862:EE_
X-MS-Office365-Filtering-Correlation-Id: 490ddb68-730c-42eb-bebf-08dac4356c1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LB+lHj29LQW/c5w3bLeIw1PGAfkpzg49ZYr20Tc6XTXB1yvlH31Bljw1FQJgnhgrUxTT0R1j8NIfaUeyPopO9IcGLfZqYrLg0kHnRNDukZcMVYLD7nXTBj5TV4DFQqvYqg36QQ8LxFANnUJqLcSlMCFa1N3JUFZhX7zhjMTtWYHzI9WmXpKEbfxlY+wakp8L8H+Kb8oYi+FH4FGpsDp29nxPwcwV0SSbbisj8R5Ble5/LdwzRLCEJ0BNsn4G0lQFJybTuX+y/mcUYeJe1kytwuNRMLGd+sujIKUq6oGGsvxFeDI5lwrNrzjjBgIMoNwBZLSGIG03QNfnLpqo9mK1gWAmk/s72FfVRvBAH1BRZ+ir4R+x2o4OeCE7LVsX1JzwLYON3jFcOBHSuL8ERMkYy1W4sdJsj7wePLJwXnGJPR09KobsslOaYU1bDsyzOEjdwWXyJeK2d5sblVhbj5VgFQXQhhuIgLpT+pw5QSgnbqNBmNNR3q3UF/GzJrJhvbQDNnpEhf1xABWCWW+XXXW9bA3DyVocHidy3rF99DWTP3Wp/eD4oeex4nOJlDEDBZix/bnXKSIemGWvKaPjjPzNQ6iSs33HKLfBOCKiKE+11/25uRC8i5eaKb9XmFgHRq1+9SnRCnWXzl2lHnt9pm6ZMohm+w6fnoRWxxRFcIHreBu+v3Acf1XroMhy4zSfDURqFuTalsvKEhDHw1137JynQ4NLkgLjb4yNcmUxNe0usln8z28Ji66705v3Q/I0oT5Y+gwKHLN477q4lqz+T/IV3bf8BfaNVz4fhnwQav1PJEMVjUyCDLZacEl395hOCz71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39850400004)(136003)(396003)(376002)(451199015)(4326008)(54906003)(8676002)(66556008)(6916009)(186003)(66946007)(316002)(66476007)(31686004)(19627235002)(44832011)(2906002)(36756003)(41300700001)(5660300002)(478600001)(8936002)(6486002)(6666004)(31696002)(26005)(53546011)(52116002)(86362001)(6512007)(2616005)(6506007)(30864003)(83380400001)(3480700007)(38350700002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEZKc3FIbjN4UzlPL2pUVFJzWWpWMzlvVlN4ZStCbnI1VkpRZ1pwZmpTV3Jx?=
 =?utf-8?B?bVZRRXhKZ1ZGY1pITG9XZ3hkMUpZSnhpd2dhMHg5Q3hLVVZJc2xST3RuM1Ey?=
 =?utf-8?B?RWY0U0hUd05wQTk2MzJoV2ZDZEMyYkg1eE1rK1pjNUNBM1pBR0RmRzh2YWNt?=
 =?utf-8?B?blJRY3Riek9WVkpyTXdvbTRJb2RRZ2NKcVpJZVFlZ2NzKzljZFkxanM2bXYw?=
 =?utf-8?B?NUZ2aXBvSWdEd0hOUFBHVHA2L0NrUE1tTkV2dzJmNitqdy93bWpjd3ZnbUJu?=
 =?utf-8?B?NVRRUVZLc3B5TjQrbGViZEpkMVR0cEN1bUViQW80UGVucDhKcGhSSkZKT3U3?=
 =?utf-8?B?Qm5MMWFlaDhjL2JRWUdBZFpyRnFmVE93S2paazdEeFRXMDRoMG55QzRHTnpS?=
 =?utf-8?B?SEthUURiTkRod3QrbHJPSGVVNDhGOThGMlNyL2NDNGJiTmJWOXg1UkN3U21w?=
 =?utf-8?B?dUh5VXJUenN1OFJOaVNEdmtvT2NMZDNWVmVuK243bDYrZjIvdUlCUUhRUlBa?=
 =?utf-8?B?U3g3ZnFMd3BnU3RXYWFzMGdHbDdJL0FVSVp3RzhUcGNFZ1Ywd0hhK1BsZmw1?=
 =?utf-8?B?anJFVzlLbmgvWStmdk1qTlFya3BIcWFySFh6YU9MN1BaV2RQQWExbnBDanZs?=
 =?utf-8?B?T0c1NzAzWXo2a2tKbXVrYzhEbUcrYUxiek4xVndwSXU3WGlndHFSc0E5ZE0w?=
 =?utf-8?B?b2xaa2RFL0RrMzJodW9rSHhsSVJSNjVpK3dtRnZNTkNYd2JSQUErbG5LTnJ4?=
 =?utf-8?B?WEk0azBtWHp5UDR5Q1YxdTltZkxicmJNdnh0d2pUbkp0WHZzaEF5enJuQnVI?=
 =?utf-8?B?TWtBN0tiY1JBV1p1d0k0bGZJNTdBUVFWbC9JVkZYNXBsS2FzUGo1RGl6ZG0v?=
 =?utf-8?B?TnBVbWpjdTdTeWUyYVZEUHZiM3ozN3QzVnlKTllNQlNyQ2g2YytBTzFWSWVj?=
 =?utf-8?B?cllScmwweFdwMFlQOCs1dWhTNE1JM3h3OVdkMXBGNFNJTWttdVAxZ0JHQmZz?=
 =?utf-8?B?UDlqN1RmS1BjVTB0cnJiYnBUdHJKd2tPcER0cmNtbW1ERjE1cFRHRDE1SWgz?=
 =?utf-8?B?NVVuYVVRNjNaWTZ2K1BtZVNFNFp2UFFiMWliZm1CRzRJUE01Zkd4ek9RRW9k?=
 =?utf-8?B?K3BXVmJHVWtnN2U3c0M4U2hHSU95Qlp1VHlOQkRWQ1piVXRvZ1JjamZacVRl?=
 =?utf-8?B?RjMwNmFxY21taVdUbUVUdEU5c0w0WWx6RW9NaU5wNWhhWkhETzJuY3J6SnlI?=
 =?utf-8?B?elpTUWd3aUxJZDVoRWlTeHB1RmN3blg3U2VGNEx4dXNuVEJ0ZnV4U0JPZ3lD?=
 =?utf-8?B?dlJwS3pvc0VvczMvZlBmVmJRb1hFd3lGRmdQdFduOEVBcmZ3NTBtSzFoSVcx?=
 =?utf-8?B?MXJaK2VtNmFGbFdCdGhLaG9UQUlSNXRKZFJsSWlmc2FBb0MxV0FNUmpKbmpR?=
 =?utf-8?B?RUxpL3Z1TTVoZWZkS3hFSlczeG91NERDSVdxZ3NGOVZJZVdYdExUVlMxSkpq?=
 =?utf-8?B?dUh3U21BYm9pTGFYRTY1Y2hkN2M2SzNYNmpPQnpCUloyTGNQU2NMM1BBc0p4?=
 =?utf-8?B?cnBtUGFZZmlQNUdzUG9lSGhETG8wcDl0dDZ6Qkd0eXk1V3NnLzBQZ05LL0dR?=
 =?utf-8?B?c0hGYnZQVDl3NnVEVGhUOVZyR2ZMKzViaHJRV1F2OWdpb0JVLzBCcCtXMlJr?=
 =?utf-8?B?WGZiRURjZ1F4ejg0aW94a0lOQkdod3lWNzh6eTlFWVlzVkJ0bE5wSkFDbDZQ?=
 =?utf-8?B?ODNoQzdIVXpGYUY0K0s3cnd6S1ZpZGhzSkY5QzZoMndFNjNUMlVkenUwem9a?=
 =?utf-8?B?Z25xaEllL1VWVkhOSUpHOFp6NFlzZDZQQXZJVjVUcDFNS0doQ01sVCtxUmdG?=
 =?utf-8?B?QnNnYU5aR2NtTGk3eEZhTHhXS2twcHFYS1RFWU9NcHJ0ellUN25EVXZQQnh0?=
 =?utf-8?B?UDE4bGVDazIzd3QydFNSekUyVEFOTklmTlNqVUhKVGRvcmErbk4xZmRMTThV?=
 =?utf-8?B?QkY1SXBCT25Xamo5RmdGQ0RvbE9Rc3VkZ29VRFpyeitWWFRQSzRNSUV3SmFo?=
 =?utf-8?B?MFlMbW9ub3A3U2lKVHMxME9OU3cwNVZaQlM3emJJRUJ2SzVER3RRbUdXeU5Y?=
 =?utf-8?B?QUpRVlBiRWNTclkvbHViZm8yRXJFa2dXeG15N1Y4QzNURmF5SnJYbDFPY2Z0?=
 =?utf-8?B?SVE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490ddb68-730c-42eb-bebf-08dac4356c1d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 22:38:15.4733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTTAPpI4Ok+l2EH7NgLQK2ueorfEIyG1LzMCkTHgDydwGMKmm02ga/DIhfgLGNjnwu9AdSej3ZFNil/w1QCMQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9862
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 17:14, Tim Harvey wrote:
> On Fri, Nov 11, 2022 at 1:54 PM Sean Anderson <sean.anderson@seco.com> wrote:
>>
>> On 11/11/22 16:20, Tim Harvey wrote:
>> > On Fri, Nov 11, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
>> >>
>> >> On 11/11/22 15:57, Sean Anderson wrote:
>> >> > Hi Tim,
>> >> >
>> >> > On 11/11/22 15:44, Tim Harvey wrote:
>> >> >> Greetings,
>> >> >>
>> >> >> I've noticed some recent commits that appear to add rate adaptation support:
>> >> >> 3c42563b3041 net: phy: aquantia: Add support for rate matching
>> >> >> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
>> >> >> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
>> >> >> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
>> >> >> 0c3e10cb4423 net: phy: Add support for rate matching
>> >> >>
>> >> >> I have a board with an AQR113C PHY over XFI that functions properly at
>> >> >> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
>> >> >>
>> >> >> Should I expect this to work now at those lower rates
>> >> >
>> >> > Yes.
>> >
>> > Sean,
>> >
>> > Good to hear - thank you for your work on this feature!
>> >
>> >> >
>> >> >> and if so what kind of debug information or testing can I provide?
>> >> >
>> >> > Please send
>> >> >
>> >> > - Your test procedure (how do you select 1G?)
>> >> > - Device tree node for the interface
>> >> > - Output of ethtool (on both ends if possible).
>> >> > - Kernel logs with debug enabled for drivers/phylink.c
>> >>
>> >> Sorry, this should be drivers/net/phy/phylink.c
>> >>
>> >> >
>> >> > That should be enough to get us started.
>> >> >
>> >> > --Sean
>> >>
>> >
>> > I'm currently testing by bringing up the network interface while
>> > connected to a 10gbe switch, verifying link and traffic, then forcing
>> > the switch port to 1000mbps.
>> >
>> > The board has a CN9130 on it (NIC is mvpp2) and the dt node snippets are:
>> >
>> > #include "cn9130.dtsi" /* include SoC device tree */
>> >
>> > &cp0_xmdio {
>> >         pinctrl-names = "default";
>> >         pinctrl-0 = <&cp0_xsmi_pins>;
>> >         status = "okay";
>> >
>> >         phy1: ethernet-phy@8 {
>> >                 compatible = "ethernet-phy-ieee802.3-c45";
>> >                 reg = <8>;
>> >         };
>> > };
>> >
>> > &cp0_ethernet {
>> >         status = "okay";
>> > };
>> >
>> > /* 10GbE XFI AQR113C */
>> > &cp0_eth0 {
>> >         status = "okay";
>> >         phy = <&phy1>;
>> >         phy-mode = "10gbase-r";
>> >         phys = <&cp0_comphy4 0>;
>> > };
>> >
>> > Here are some logs with debug enabled in drivers/net/phy/phylink.c and
>> > some additional debug in mvpp2.c and aquantia_main.c:
>> > # ifconfig eth0 192.168.1.22
>> > [    8.882437] aqr107_config_init state=1:ready an=1 link=0 duplex=255
>> > speed=-1 26:10gbase-r
>> > [    8.891391] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
>> > [    8.898165] aqr107_resume
>> > [    8.902853] aqr107_get_rate_matching state=1:ready an=1 link=0
>> > duplex=255 speed=-1 26:10gbase-r 0:
>> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
>> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
>> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
>> > supported 00000000,00018000,000e706f advertising
>> > 00000000,00018000,000e706f
>> > [    8.934349] mvpp2 f2000000.ethernet eth0: mac link down
>> > [    8.948812] mvpp2 f2000000.ethernet eth0: configuring for
>> > phy/10gbase-r link mode
>> > [    8.956350] mvpp2 f2000000.ethernet eth0: major config 10gbase-r
>> > [    8.962414] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
>> > mode=phy/10gbase-r/Unknown/Unknown/none adv=00000000,00000000,00000000
>> > pause=00 link=0 an=0
>> > [    8.976252] mvpp2 f2000000.ethernet eth0: mac link down
>> > [    8.976267] aqr107_resume
>> > [    8.988970] mvpp2 f2000000.ethernet eth0: phy link down
>> > 10gbase-r/10Gbps/Full/none/off
>> > [    8.997086] aqr107_link_change_notify state=5:nolink an=1 link=0
>> > duplex=1 speed=10000 26:10gbase-r
>> > [   14.112540] mvpp2 f2000000.ethernet eth0: mac link up
>> > [   14.112594] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
>> > - flow control off
>> > [   14.112673] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> > [   14.118198] mvpp2 f2000000.ethernet eth0: phy link up
>> > 10gbase-r/10Gbps/Full/none/off
>> > [   14.139808] aqr107_link_change_notify state=4:running an=1 link=1
>> > duplex=1 speed=10000 26:10gbase-r
>> >
>> > # ethtool eth0
>> > Settings for eth0:
>> >         Supported ports: [ ]
>> >         Supported link modes:   10baseT/Half 10baseT/Full
>> >                                 100baseT/Half 100baseT/Full
>>
>> 10/100 half duplex aren't achievable with rate matching (and we avoid
>> turning them on), so they must be coming from somewhere else. I wonder
>> if this is because PHY_INTERFACE_MODE_SGMII is set in
>> supported_interfaces.
>>
>> I wonder if you could enable USXGMII? Seems like mvpp2 with comphy
>> should support it. I'm not sure if the aquantia driver is set up for it.
> 
> This appears to trigger an issue from mvpp2:
> mvpp2 f2000000.ethernet eth0: validation of usxgmii with support
> 00000000,00018000,000e706f and advertisement
> 00000000,00018000,000e706f failed: -EINVAL

Ah, I forgot this was a separate phy mode. Disregard this.

>>
>> >                                 1000baseT/Full
>> >                                 10000baseT/Full
>> >                                 1000baseKX/Full
>> >                                 10000baseKX4/Full
>> >                                 10000baseKR/Full
>> >                                 2500baseT/Full
>> >                                 5000baseT/Full
>> >         Supported pause frame use: Symmetric Receive-only
>> >         Supports auto-negotiation: Yes
>> >         Supported FEC modes: Not reported
>> >         Advertised link modes:  10baseT/Half 10baseT/Full
>> >                                 100baseT/Half 100baseT/Full
>> >                                 1000baseT/Full
>> >                                 10000baseT/Full
>> >                                 1000baseKX/Full
>> >                                 10000baseKX4/Full
>> >                                 10000baseKR/Full
>> >                                 2500baseT/Full
>> >                                 5000baseT/Full
>> >         Advertised pause frame use: Symmetric Receive-only
>> >         Advertised auto-negotiation: Yes
>> >         Advertised FEC modes: Not reported
>> >         Link partner advertised link modes:  100baseT/Half 100baseT/Full
>> >                                              1000baseT/Half 1000baseT/Full
>> >                                              10000baseT/Full
>> >                                              2500baseT/Full
>> >                                              5000baseT/Full
>> >         Link partner advertised pause frame use: No
>> >         Link partner advertised auto-negotiation: Yes
>> >         Link partner advertised FEC modes: Not reported
>> >         Speed: 10000Mb/s
>> >         Duplex: Full
>> >         Port: Twisted Pair
>> >         PHYAD: 8
>> >         Transceiver: external
>> >         Auto-negotiation: on
>> >         MDI-X: Unknown
>> >         Link detected: yes
>> > # ping 192.168.1.146 -c5
>> > PING 192.168.1.146 (192.168.1.146): 56 data bytes
>> > 64 bytes from 192.168.1.146: seq=0 ttl=64 time=0.991 ms
>> > 64 bytes from 192.168.1.146: seq=1 ttl=64 time=0.267 ms
>> > 64 bytes from 192.168.1.146: seq=2 ttl=64 time=0.271 ms
>> > 64 bytes from 192.168.1.146: seq=3 ttl=64 time=0.280 ms
>> > 64 bytes from 192.168.1.146: seq=4 ttl=64 time=0.271 ms
>> >
>> > --- 192.168.1.146 ping statistics ---
>> > 5 packets transmitted, 5 packets received, 0% packet loss
>> > round-trip min/avg/max = 0.267/0.416/0.991 ms
>> > # # force switch port to 1G
>> > [  193.343494] mvpp2 f2000000.ethernet eth0: phy link down
>> > 10gbase-r/Unknown/Unknown/none/off
>> > [  193.343539] mvpp2 f2000000.ethernet eth0: mac link down
>> > [  193.344524] mvpp2 f2000000.ethernet eth0: Link is Down
>> > [  193.351973] aqr107_link_change_notify state=5:nolink an=1 link=0
>> > duplex=255 speed=-1 26:10gbase-r
>> > [  197.472489] mvpp2 f2000000.ethernet eth0: phy link up /1Gbps/Full/pause/off
>>
>> Well, it looks like we have selected PHY_INTERFACE_MODE_NA. Can you send
>> the value of MDIO_PHYXS_VEND_IF_STATUS (dev 4, reg 0xe812)? Please also
>> send the global config registers (dev 0x1e, reg 0x0310 through 0x031f)
>> and the vendor provisioning registers (dev 4, reg 0xc440 through
>> 0xc449).
> 
> yes, this is what I've been looking at as well. When forced to 1000m
> the register shows a phy type of 11 which according to the aqr113
> datasheet is XFI 5G:
> aqr107_read_status STATUS=0x00001258 (type=11) state=4:running an=1
> link=1 duplex=1 speed=1000 interface=0

That's pretty strange. Seems like it's rate adapting from 5g instead of
10g. Is SERDES Mode in the Global System Configuration For 1G register
set to XFI?

>>
>> It's possible that your firmware doesn't support rate adaptation... I'm
>> not sure what we can do about that.
>>
> 
> I will enquire with my Aquantia FAE to see what they say about rate
> adaptation support
> 
> Something interesting is that when I configured the xmdio node with an
> interrupt I ended up in a mode where 5g,2.5g and 1g all worked for at
> least 1 test. There was something wrong with my interrupt
> configuration (i'm not clear if the AQR113C's interrupt should be
> IRQ_TYPE_LEVEL_LOW, IRQ_TYPE_EDGE_FALLING or something different).

NXP use IRQ_TYPE_LEVEL_HIGH on the LS1046ARDB.

--Sean

> While I can't reliably reproduce this and I believe I was on the 6.0
> kernel at the time without the rate adaptation support a debug log
> when I was in this mode shows the following:
> [   27.700221] aqr107_config_init state=1 an=1 link=0 duplex=255
> speed=-1 26:10gbase-r
> [   27.709694] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
> [   27.716457] aqr107_resume
> [   27.723551] aqr107_get_rate_matching state=1 an=1 link=0 duplex=255
> speed=-1 26:10gbase-r 0:
> [   27.733075] mvpp2 f2000000.ethernet eth0: PHY
> [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=40)
> [   27.752939] mvpp2 f2000000.ethernet eth0: configuring for
> phy/10gbase-r link mode
> [   27.760508] aqr107_resume
> [   27.769781] aqr107_link_change_notify state=5 an=1 link=0 duplex=1
> speed=10000 26:10gbase-r
> [   32.670293] aqr107_read_status state=5 an=1 link=1 duplex=1 speed=10000 0:
> [   32.678642] aqr107_read_rate state=5 an=1 link=1 duplex=1 speed=10000 0:
> [   32.686405] aqr107_link_change_notify state=4 an=1 link=1 duplex=1
> speed=10000 0:
> [   32.686628] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
> - flow control off
> [   32.702981] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> ^^^ 10gbe link; ping ok
> # force port to 1Gbe
> [  945.918132] aqr107_link_change_notify state=5 an=1 link=0 duplex=1
> speed=10000 26:10gbase-r
> [  945.918193] mvpp2_port_isr 10gbase-r
> [  945.919186] mvpp2_port_disable 10gbase-r
> [  945.935304] mvpp2 f2000000.ethernet eth0: Link is Down
>  [  949.509595] aqr107_read_status state=5 an=1 link=1 duplex=1
> speed=1000 26:10gbase-r
> [  949.518562] aqr107_read_rate state=5 an=1 link=1 duplex=1
> speed=1000 26:10gbase-r
> [  949.527112] aqr107_link_change_notify state=4 an=1 link=1 duplex=1
> speed=1000 26:10gbase-r
> [  949.527166] mvpp2_port_isr 10gbase-r
> [  949.527176] mvpp2_port_enable 10gbase-r
> [  949.527306] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full -
> flow control off
> ^^^ 1gbe link; ping ok
> # force port to 2.5Gbe
> [ 1024.518112] aqr107_link_change_notify state=5 an=1 link=0 duplex=1
> speed=1000 26:10gbase-r
> [ 1024.518187] mvpp2_port_isr 10gbase-r
> [ 1024.532897] mvpp2_port_disable 10gbase-r
> [ 1024.536880] mvpp2 f2000000.ethernet eth0: Link is Down
> [ 1029.295136] aqr107_read_status state=5 an=1 link=1 duplex=1
> speed=2500 26:10gbase-r
> [ 1029.304070] aqr107_read_rate state=5 an=1 link=1 duplex=1
> speed=2500 26:10gbase-r
> [ 1029.312611] aqr107_link_change_notify state=4 an=1 link=1 duplex=1
> speed=2500 26:10gbase-r
> [ 1029.312638] mvpp2_port_isr 10gbase-r
> [ 1029.325584] mvpp2_port_enable 10gbase-r
> [ 1029.329564] mvpp2 f2000000.ethernet eth0: Link is Up - 2.5Gbps/Full
> - flow control off
> ^^^ 2.5gbe link; ping ok
> # force port to 5gbe
> [ 1060.401209] aqr107_link_change_notify state=5 an=1 link=0 duplex=1
> speed=2500 26:10gbase-r
> [ 1060.401272] mvpp2_port_isr 10gbase-r
> [ 1060.402274] mvpp2_port_disable 10gbase-r
> [ 1060.419006] mvpp2 f2000000.ethernet eth0: Link is Down
> [ 1065.167937] aqr107_read_status state=5 an=1 link=1 duplex=1
> speed=5000 26:10gbase-r
> [ 1065.176865] aqr107_read_rate state=5 an=1 link=1 duplex=1
> speed=5000 26:10gbase-r
> [ 1065.185415] aqr107_link_change_notify state=4 an=1 link=1 duplex=1
> speed=5000 26:10gbase-r
> [ 1065.185456] mvpp2_port_isr 10gbase-r
> [ 1065.185474] mvpp2_port_enable 10gbase-r
> [ 1065.185597] mvpp2 f2000000.ethernet eth0: Link is Up - 5Gbps/Full -
> flow control off
> ^^^ 5gpbe link; ping ok
> 
> Thanks,
> 
> Tim
> 
>> --Sean
>>
>> > [  197.472504] mvpp2 f2000000.ethernet eth0: major config
>> > [  197.472614] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
>> > mode=phy//1Gbps/Full/pause adv=00000000,00000000,00000000 pause=00
>> > link=1 an=0
>> > [  197.479561] aqr107_link_change_notify state=4:running an=1 link=1
>> > duplex=1 speed=1000 0:
>> > [  197.484972] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full -
>> > flow control off
>> > # ethtool eth0
>> > Settings for eth0:
>> >         Supported ports: [ ]
>> >         Supported link modes:   10baseT/Half 10baseT/Full
>> >                                 100baseT/Half 100baseT/Full
>> >                                 1000baseT/Full
>> >                                 10000baseT/Full
>> >                                 1000baseKX/Full
>> >                                 10000baseKX4/Full
>> >                                 10000baseKR/Full
>> >                                 2500baseT/Full
>> >                                 5000baseT/Full
>> >         Supported pause frame use: Symmetric Receive-only
>> >         Supports auto-negotiation: Yes
>> >         Supported FEC modes: Not reported
>> >         Advertised link modes:  10baseT/Half 10baseT/Full
>> >                                 100baseT/Half 100baseT/Full
>> >                                 1000baseT/Full
>> >                                 10000baseT/Full
>> >                                 1000baseKX/Full
>> >                                 10000baseKX4/Full
>> >                                 10000baseKR/Full
>> >                                 2500baseT/Full
>> >                                 5000baseT/Full
>> >         Advertised pause frame use: Symmetric Receive-only
>> >         Advertised auto-negotiation: Yes
>> >         Advertised FEC modes: Not reported
>> >         Link partner advertised link modes:  1000baseT/Half 1000baseT/Full
>> >         Link partner advertised pause frame use: No
>> >         Link partner advertised auto-negotiation: Yes
>> >         Link partner advertised FEC modes: Not reported
>> >         Speed: 1000Mb/s
>> >         Duplex: Full
>> >         Port: Twisted Pair
>> >         PHYAD: 8
>> >         Transceiver: external
>> >         Auto-negotiation: on
>> >         MDI-X: Unknown
>> >         Link detected: yes
>> > # ping 192.168.1.146 -c5
>> > PING 192.168.1.146 (192.168.1.146): 56 data bytes
>> >
>> > --- 192.168.1.146 ping statistics ---
>> > 5 packets transmitted, 0 packets received, 100% packet loss
>> >
>> > Best Regards,
>> >
>> > Tim
