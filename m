Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746F16287DC
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 19:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbiKNSIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 13:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbiKNSIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 13:08:13 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D082C113;
        Mon, 14 Nov 2022 10:08:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVHzzYWfFoXEHPu/J+KcYy7gpOGoREaXL88NsnbQBaqPKfcx9J3V2R2ZseiolruaGZGmYPAa9tKbR168dyWJl3d/0Z/UsREHIy1eO6cEG7mV+a+WWsXZNtu2x6DvKsSeXrTpQ5cANbl0CkNQB1dIwlheHwS/KoiY1fEz9Xnhxfxi8MYTmjeebY7DoT/xi10HV+A61xX+EPxDaSmNlji+O6QdE7yoJCB5TOjt5iVMcL0YV5shjdWxNOJ71ebWG0/6M1UEEzh3uFzZuv49elz3EthhIs9NtEi5ACAmflthGG6qHla2cGMPxc5K2md5SYa7W6ty+6SV11s9ZIS+MJuVaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Qe63/XL2tY15GcppDUor8oU33ES+37rqU28xLY1igg=;
 b=WQP35cBBEyAs3xSvj9ukUCAB0oS1UvER1+OJ9YhZ/mNPn68o3lx7gQTCwJvQ2QEoNwHntvihhFb6mG9pRi+RwykmZgNioN5fFQhdzhrCsXUa7ycATkue5D2p8creAGbdDa2aLaexhkwlwLn5yi1wa1EZ2+ucOwSg5R3mznvVwMdsLQrzkHhaLvQNdkPT+m8LEGGAteYd32XcfcJ4PtEroR2/KWZybbZe/JI2L3gfykdgvMJqd9aJ+NxKWUxRPOvJ3KpXKks6g5hTUwT05L9le2eEQp5h+i7VzpdWUmH77pKquxYwfd/gYvOjBKjfA/fmMrZCXgJ3g/6A0RfljRkUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Qe63/XL2tY15GcppDUor8oU33ES+37rqU28xLY1igg=;
 b=AJF8wy3l2Qe+CqGkv0Xs2z+T+Ehfa8JowS4aYgX8jwFHlBXHWftImb157E/C8BruaKl6TH1LfRU3Pcjr3hRH2SjJEY22p4CVoBsfk9GG623BA8qwMLzqmSgZmGDDK3kogg7edqiHuUPkeztrELJdo5ZzhIqHIsHCT8QFSDSrGdDQe5PSNuh3IJGWniixcV5f6KfS4JIAG9US3iq5R/5wB7OW3XLiqz9i982xlSA5RXUbGy9SPVfXLxfB/IRUPXgmvYTe5Ky9IGaKTlgAKSxVOIexy2Q7QYW+OPdIMxekg1k3Bk6ug4o1Nosdn6BUyO01W0s5ZE0tf6RaofN2oEJ2fA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAVPR03MB8921.eurprd03.prod.outlook.com (2603:10a6:102:322::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 18:08:09 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 18:08:08 +0000
Message-ID: <209a0d25-f109-601f-d6f6-1adc44103aee@seco.com>
Date:   Mon, 14 Nov 2022 13:08:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
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
 <ce6d6a26-4867-6385-8c64-0f374d027754@seco.com>
 <20221114172357.hdzua4xo7wixtbgs@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221114172357.hdzua4xo7wixtbgs@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0041.prod.exchangelabs.com
 (2603:10b6:208:25::18) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAVPR03MB8921:EE_
X-MS-Office365-Filtering-Correlation-Id: eb840486-16ff-436f-f38c-08dac66b2f5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qgzrKB2mvfQ/INaJ8SBon7lqIGhHaTGqbiiqzIBy0ScY7ZzEVAHpEJ2ucTIjPE0Rdm3bB/k2QLWlDT2weVcjsvDnGzOk7jkmnLk8r1k1i9VjkcgFm+byntZSZ4LfuscNxalEP7HIG1XWKv8+nu6wxtU/7ukd9GDjBgfXhr20AITN0tptrIhSDGhBPfT1NpAgyC7Zf6kYt0U24p+2skYCxRDhsz1EEMoGYnvUuSvfHWnML8ZpNvcWD5lkRMLPMSosUoL8VlJH2yw/7XL/bRn9zYGhPt4I4dutd9Bl+i5U9l/hC4BNjU5z3/MFC4oGhBIOWkYFiJ7Vfpd/oQfr7BY5trpsoalS/IVnYQTRmM7fcpVwGcEGIDhXXpI+qv2QSt5OK5fyrlNpY4YOblTsFZIN8x4Rp1naOkbuDRIQ9+ttWK5LjXowpw/psAE2XnpRAl4UnAw+wND4pnIdm8cEEnCmIONTf6fY5OpE6WhIYRhrwEHk96K8thkVaof0mvNYa3mtZG4rk5UPvKEitwKjISdEGrFDF3v7ppF10yCU8UXkiaQKeVnsXEdcOozwNvcQPR0N1NSBaPHDagm/52xrvPrCR02pXqo461AibXXwYAQEgJvBcleYFILZtvXHa285PnqI9fPM8GAk2vS18nVnglnZXRACAanlPXhYn1S8nJo9L+VnWHed9cJgmx3yN/DlmnBi99VjYieugUVKP7KZWuUe/XhQaZkvlSsGd+6HJwPUcpHJihREBu5OfIoU+esMUDGO/Gz/V9VsQDGFDBNqQmpQJCgrqyhSgV5/SBJ09770wdaVnxHYozqeUROCn8VihpoI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(6506007)(6512007)(31696002)(86362001)(52116002)(2906002)(6666004)(53546011)(44832011)(26005)(5660300002)(6486002)(38350700002)(41300700001)(38100700002)(478600001)(4326008)(2616005)(66556008)(186003)(8676002)(66476007)(66946007)(7406005)(7416002)(83380400001)(8936002)(316002)(54906003)(6916009)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFVBOCtjaTYxejNNM2VYUTJITmZkejRLUlhPbXFZM29HTXEvTDhOSE8xQzZl?=
 =?utf-8?B?dkREcHZ6anJaaUtrNWgxQnVsSDVqMzgycWIrOHdvYVNxVjYzMHI1RzVLelB5?=
 =?utf-8?B?OTdOclRGOG1obzlud2tPbUpHRUUxTlNwRnZUWEVJbXJBRjN4Z3ZTQllZNFh3?=
 =?utf-8?B?SllTdk9LNTBoMHpVQTVtVW5SRHZwK0dpV1JXenZSb2FEVXloMUxlRXFLS0dH?=
 =?utf-8?B?bEJnTnVFaW00OEJDM21qZEtiekZPbmc3dUNheEtZU0FHaG13VG13anlSOW5P?=
 =?utf-8?B?OHpQdzl4SU1MUWRycEtERWRCZ21YTjJCQzd2amhxVVovbTZWdGYxb2hDK3Uz?=
 =?utf-8?B?TnIyQ1RnbEp1ODlWU1ROSlN4S0U4eFRZSDNBbkg5bjhnV3EwWmsvaVVFdVlJ?=
 =?utf-8?B?ckh3VTlKdVBNb1FUUHR1bjBOU3FkVnU0bWhrTTNOeHVGQU9lcWpMazNDLzhI?=
 =?utf-8?B?R2pFRERiMWtsRXBUYklUTXFqeTBKei82aDRPb0hab2Q5YXF6S01jL1ViMVhw?=
 =?utf-8?B?YkRRZW5NVkFxZUREcFNpaC9HVlNDZWZVbndnOWRqWFJTUlRVUkdOUTJ2T000?=
 =?utf-8?B?YjlNb3pSZ1dGNVNQWDcvemRFYmpMVHNIRzFna1IxOTVBa3Z3cWJRenEyZldz?=
 =?utf-8?B?Zmk5MFlSTU51amZRc09FdGE4MHE3RkllektZdE1xQkdSN2JsYTgvTWNwVk1h?=
 =?utf-8?B?dWlmTXo3bG8waTd0SHFHcGpIdmZjZUo4aFo2ZXNTYkpNaThxTHE1WG1VeGJ6?=
 =?utf-8?B?OUV0NDY2RTVjUXhidlN3d2NxdExBYjl6VTUrcDFYSjE1ckNZSjBMVkJPcXFS?=
 =?utf-8?B?dDF2bGpNaEM1SXVpRlgwQmorYlFTc084U2t0TkRVTTh0ZHNwYjZYVDA4enVN?=
 =?utf-8?B?S29LbGpEa2Fha1FSN1UxV3VVaCtlWE9FTWNVTzlOY21aaGJ6STZOUXBlclAw?=
 =?utf-8?B?bkxFMjZkR0N0cHhKcFordGVtVlJSeHRVVms1RVVySmpvOEZDVERObk1WbE5n?=
 =?utf-8?B?S21zaW9MNEZlQy9oWFZPTHMreHZaK0ptWS9ad3ZlZ3VHL1dSWGswVjJibW1R?=
 =?utf-8?B?a1JId0NPZkM1ZjIyczFLR3hjdjB0NUtRc2hIU1BqVDMvRytqV1NyOFcyUTMz?=
 =?utf-8?B?SXBqaVJJQXhheUdjakNEZWpnR3N3MnpuWGlZd0ZWUVdrT2F1TmFRVmwrQVZ0?=
 =?utf-8?B?VnlSY2NjQm4vS1FUK2JWd290TitHVmlUQUJNNjF3QWxjYS9XV1BtS3FTOUMw?=
 =?utf-8?B?VEN1d2NHZ1BUWFQzdHlZblNESDNIaDlneGV2b1FMcTlCSmtoRVlTMTlZNGJN?=
 =?utf-8?B?RGRsbUsxejhGL085c1RSMmQ3SFNFVlN5alh3anl6Tjc4SVhNRnZJRTRDTlNM?=
 =?utf-8?B?Z0lWQldpMk1XTkdwSjRjVmU1NmV1QWRXTG5zcDUxVFBRN3A2enRJRUdGNVZx?=
 =?utf-8?B?QXlqbmwzMWMySDBiaWY0UXhoZy9DOEZtcUlsYXlNMUF3Sit5ZmFDM3o4d2hI?=
 =?utf-8?B?a0VkcGFxQXFVN1U1eGFINlBuZk5YMzYvRzM2UmJnRG9ybXA2c2xsd1pJZlU0?=
 =?utf-8?B?ODZVTmd0eVRBd2lvY3pHUWhHSnBGVmJObGNsdDV6UGp5dENrTmcydU93b2dU?=
 =?utf-8?B?MzJhOTk5YkJqWWJsekx6Z3pwajZQdmJUVkFGNjUrd0MvdWY3TU5Jc1ovTUlT?=
 =?utf-8?B?VVNlb3dUZ1psWDFlQytQenlEam1Fdld6VmdtMTFhNDlaWXU1RUszeHEzNDg5?=
 =?utf-8?B?WmhlWjRCNzk4STRQVlF5Zit0ZkhhVVRxWmZzTWVkcWtqZFYyRjgwWi9Mdm42?=
 =?utf-8?B?MFBJeDB2UnpHTllhb2ZsNTJTZ0Z0TnV4NzBMcmdTTFFUeUtGdklaUHkwSm9y?=
 =?utf-8?B?eDVJN1RBZUlPcyszUGVZQkVRZWcrMjZ3WTd3dUh6TVoySUUwdzhDYXhoK1V4?=
 =?utf-8?B?QW5XbUhheUErV3VZa0VWaWljYVBHc0pySlg1T08xYWtPVnpRL3lMV1dyZk0y?=
 =?utf-8?B?VDh4bE8vRDJscVhwVUtlV2NSODZ2M1pJZDFlUVJIQ3Y2bHUyRnpTS2ZiaVds?=
 =?utf-8?B?OEpFSEZjaG9xM2RCN0NVSCt2MW5Na0hseWNtZjZ1dE41Um9pcE5Oa0NHMkI2?=
 =?utf-8?B?TDRRY29WMVphVk13NWw3c1hBZVV3djdDVzdTMWovbEhTTzJuSHdGZGR1K2o0?=
 =?utf-8?B?aUE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb840486-16ff-436f-f38c-08dac66b2f5c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 18:08:08.8048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yqfv7DEaXlIAQmAq2X7ATUGougL9M1gHx6nhW+u/9YNqbIJnv982ze/cN3tPXs6slvlAqokHcjbli1GQobwFYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB8921
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/22 12:23, Vladimir Oltean wrote:
> On Thu, Nov 10, 2022 at 11:56:15AM -0500, Sean Anderson wrote:
>> these will probably be in device trees for a year before the kernel
>> starts using them. But once that is done, we are free to require them.
> 
> Sorry, you need to propose something that is not "we can break compatibility
> with today's device trees one year from now".

But only if the kernel gets updated and not the device tree. When can
such a situation occur? Are we stuck with this for the next 10 years all
because someone may have a device tree which they compiled in 2017, and
*insist* on using the latest kernel with? Is this how you run your
systems?

We don't get the device tree from firmware on this platform; usually it
is bundled with the kernel in a FIT or loaded from the same disk
partition as the kernel. I can imagine that they might not always be
updated at exactly the same time, but this is nuts.

The original device tree is broken because it doesn't include compatible
strings for devices on a generic bus. There's no way to fix that other
than hard-coding the driver. This can be done for some buses, but this
is an MDIO bus and we already assume devices without compatibles are
PHYs.

In the next version of this series, I will include a compatibility
function which can bind a driver automatically if one is missing when
looking up a phy. But I would really like to have an exit strategy.

--Sean
