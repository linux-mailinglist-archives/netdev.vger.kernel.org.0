Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C424A58CEC8
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243906AbiHHT6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbiHHT6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:58:07 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20085.outbound.protection.outlook.com [40.107.2.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370DCA196;
        Mon,  8 Aug 2022 12:58:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3svzi8GKHiO5kn/g7U+nTIZ1G1u/Ihmxyf0Y/3U2kU0Gm6GeVrJX9S1XEn7cch7qFjSsnfbVkhF6MuTtruGTq16Ca5qy5cwhFYharXbx8KC+hYZx0huohgnaUXFPQusvjNcxQ6mW2bJwGs/mAzR9gYuBiUv/gZePS05mC8ztns00pfkLHTZ23OIlPbrnUjsQsxBJvjogA30zTbwtw4anFZwXDwkhxbp8YehMGaE+qL3tPMB3z3MT0b9Wuz+ZjgonBWiBOh0LXx02VVfMpj91OEJakpjG1/BbSlBPa9/4vqL2EeiasTBAGB28uZPqHeIVNrE3X86GZklbks/Z9YdeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIHxZU0l0ww7S9LUuaDW4HGoqQ/9/6m18PyEX46ycxo=;
 b=UZ5RIEgYs7eHotVLuO6CF3xkotKKc5bTwUgtGmEh2XW9g8ur9F+CETvCrhTgGGTdP1TgESK36j7vT1s5jpVitiMRh59p9270fV/KQQvOJwxUugqFCCvSrrng8htWQFk3vR0EfMgcmCUEmbD2n0wSGG08r1PuPup0w+nuUW3Oy6ekBUn9adx/CbDsmjCEiLMt2p3C86hs/8ehGUvPmvkhf4ZDb2VfBqCl8VzWDNBgTM2nUd8gFrd6QJkj1hd8J7ctpv7yclrbitfaRdwWg1aQUxBtQ7KNykJ130ZBNNPUVGR6s8e3z8OCzvmQRjPqPsHB0HkdKsy4TuYsG1V1zoJNzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIHxZU0l0ww7S9LUuaDW4HGoqQ/9/6m18PyEX46ycxo=;
 b=bIFiN06lSPtaCHqOefODGURv10TmJ8F+lNxuFwesrD0+4J+0zY0pDUh+YZ0VFPmXkHjnj/2QPedZh8jd3t6Nv242R6/Cet6OGMxEZbwlMFDj40MveH87i0OJy+lZx/FqIw5IUR30eEopBixnu5B5l63XyHr2lJikZ96gPBsCVIbJJT0IT983IWD2G4t2rOwUI3JTrGV6NI8LYRdYIJiu9MAfj5ei/oc6v/6ithw+a1I0Y/rXsx7nX4r0CMUXETNgofm3chSKWQZoe05e53+sruyGcr4/aBoqpwZTwFcK8ahiPqxcpaonNt0Jt3DS9X8rPYL+QAUP7IH2b3YPp+7Zlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB3767.eurprd03.prod.outlook.com (2603:10a6:209:31::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 19:58:01 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Mon, 8 Aug 2022
 19:58:00 +0000
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
Date:   Mon, 8 Aug 2022 15:57:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:208:236::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8087bbfa-2815-48b3-1469-08da79784bf2
X-MS-TrafficTypeDiagnostic: AM6PR03MB3767:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EBQnCWcMZPM+pIlY4YlUAGMSdu55aSU7/9bKk4c2PJvsiohFoSKggXezbAxmCkkWfRytfUTmsouZ7ulMZtLkL4b0ef5OQvVlSqQRLrfT1yfxRfDYdh2kx22AlNmmQPMKaDj+wHjnVe1OtULr0vNvIIvNzZ70zXTkL0/trXDUWhqdI/+5aHuzK/HDSokP8EJPjovNcOy7BxImOnmrYetHU63agbzki+3KPkWUx0xp8dCdhKqTe08MaV652g68DqfNcT54G1OZtx2MaQG7M38PAwYWTwIcucqJ0Xj6iMgP1nkrYsb3wY51ORvRgPUQKJzZ/WP5G6kOS41Yvc09gKsiagQGZ4yeqOVKRYDKswkuorkQX2LaLDCBlI8iCBQcY3dSRYPHxNap/8SsM4nJeJEh3GTSKh9J0iWPY3Hw1qWn/oYNBBctb9tf65vuSzLYsaGpOSewntKuImm2UrmhvV4wdV5lMOgg33fxSFBZ5zPihswiwXWbiziLUG4eLK3v5Y2jLGl59rVw8kaXR1+xjfYEtekCgqP8RUFIEJjhmXQ8bW5yLT8SwfC0xNeogAwWsoY7+RE2EgloiVCv5tqfRssn4kmJ8TEG26Ni1mK+hyTrhoApy2WAme7VD/0hnDW3ow6QDwsrKFzJwcjaebC7eRAT/PA+bTxo1XNQz5sRKwyXG0F7h01ogMZ/IUrXpPF5DCFq+R88ek1aluXGQtYZovAW7jZYkJcg0rN5k5FqITYTRfUsi0g9eF/Z/yzZ9X1dN+uAnj5Eg/KwjYV2r0s8mFtiRhULgwjAiRyoJCcGOM0x6tXB0WSDf2gHwkyaaPwZzWKXsZlVfFv0e/N4yMFoK2T1QYP4Oa05YxkSkeFdlIH0/Lw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39850400004)(396003)(366004)(136003)(41300700001)(478600001)(83380400001)(6486002)(186003)(86362001)(31696002)(44832011)(6666004)(36756003)(38350700002)(38100700002)(53546011)(6506007)(52116002)(6512007)(2616005)(31686004)(110136005)(66556008)(316002)(66946007)(66476007)(8676002)(5660300002)(26005)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVA2dDZNVEQ0ZkttcDc4VjdBVU9qdjNkUDFWQ0tHWVp3SmoyTGVYTThsOGZa?=
 =?utf-8?B?dDIvVE44M1E0RTJXVGtlOC92d0R5VlFWRlJuNmp1Yzl3Mzg2YmJRMUVXY0FC?=
 =?utf-8?B?RG5OaTg1T1dsQjJld0NOckpUZUNTZFBJQ0RwTWQ4Y3dRR0Ixd1lsWGwyWUZr?=
 =?utf-8?B?NW5XdXpjUmJMRENBbU1QbWx6T21KS29VRDJ0ODREYUFkcCtVVXVSa2xhT1R3?=
 =?utf-8?B?NlNyN3Q4cnJORi9lSldtNEVsNytFNW5xTnB5RERGWVo0cTY0TDkzRHR0Y3JW?=
 =?utf-8?B?Tno3Tk9BUEtXdUJVWFFrQ0tKZno4STF6dzRIQ2Y4MmxhYm1zWWJLQ2pySEw0?=
 =?utf-8?B?akx2Z2tFbm13dEZQcUhLcGlGOHFhNnZ1azFoOVFlL2dSREJsK05wOUhiVEgr?=
 =?utf-8?B?eGlNMVV4RGhzNDhOU0NVaGVyQ3g3ZGsvQW5TU3h4OWZJazJkbDF3ZndWUnoy?=
 =?utf-8?B?Q0RiajI4cmVtQWVUbXErYVNWeTlVZThodU1yUzhET2VDOUxPWWtRNnlRaldo?=
 =?utf-8?B?WVd5YkRiaEpnaU1xQWd0bXA5ejEzMzAycmJnamlxSWVBdHBGOFFxT3JtV3Zu?=
 =?utf-8?B?MzRKN255ZERzZHVRalV4NFdPWGFMeklCRmk1a1hiMlgwSWFSYzRIUnMyYUxD?=
 =?utf-8?B?cXF4c1VydmNkNThkUldCN0Q5b1lFUFNkdjBPSTJmUmtsbzZWQWNRQk15dVlq?=
 =?utf-8?B?VTFxOXFOb3oyL3lHZWFLVkcyaFV0U2xFWmZ5cFJ4Z1lJcmt2UXUvQnJrend5?=
 =?utf-8?B?czNremJZdGdZY2IwWjd4Yy9MZWNlemVFQlZVbWRKRlByY05Cb2dNTXVwQjdE?=
 =?utf-8?B?NUpzcHpETzNOWlhNRCtUNUdRbnYzSjhqRkNyRFFMWi9QREs3SmhRRFdHYWxn?=
 =?utf-8?B?T255VHpSSzN5UXB6Q1RoQVdvY2lVSENQYUNjV1lpTjB1SWVFakRDYk92T0VI?=
 =?utf-8?B?MWgrV0t2Z2RwR095TDd0anZzNk51djYzUlgwTzBhMFdDVTBvTmdPbjBKYkNT?=
 =?utf-8?B?VFZvZ3ZHN1V4dGZSOVhOZ3JueWpiUkx4L2FIVnBvRTZOUURBbEZYY24yb1or?=
 =?utf-8?B?YzFBamRTMzdRR2p0OGg2YVhKa0hVWnFnUHlaRUIwM21kL09QQzBLYkcyZm9R?=
 =?utf-8?B?eTE2aTZBTU8vdGt1dFEyWHcvTEdCMlVOM0llN2VmS0V3ekdZU1E0SGl5SG1O?=
 =?utf-8?B?MUd2SmRHb0JNUlpoRFc2dFluWFI1cVFrdjFBaGo0YkR5SzBpOVJkQWZiN0g3?=
 =?utf-8?B?MTZMYUgydFZhVGpIU005em84UHR4aDc2RTY4ekNLbCtuaUJzQksyOG5lTkhl?=
 =?utf-8?B?dnp0dUZSQVJtWUE3Y0luNFhTQ1Z0dlY1Wk9JU0U5b25EYmJrOTJ6THk4TnBa?=
 =?utf-8?B?YUZxQlJSTnBpUktPYjdZUEpuWDg3YlpXYWpKcVVHWHNsMTBDNkhFcE9ZcDZW?=
 =?utf-8?B?ai9ZemgrN216MEcvcWEvc3VmNStWdDNjZ2xhWnIwSExoVXl2K3ZVaEtzZ2Zm?=
 =?utf-8?B?M1Roams3OGs3elQyYTRKdkFBVzBTS3VGcUpobmxBYW1YVTZMNzA3ZTQyY041?=
 =?utf-8?B?SlRtYzBMNWVKR01OVnNJSUtLTm9DZkgvS1pENEtFbGNqcExuS3ArU0NQOCtp?=
 =?utf-8?B?aDRqamFkcTB6dkZPRnZTZ3dPdlVDd2IrT1p1NVRZaWdzdllVTHFUQmxSNjBS?=
 =?utf-8?B?NXNwYi9aZUJlbjBER2wwYjNoajQ3bm50WGNHTWhyNUJRTTlVYlpzVFVBTmdF?=
 =?utf-8?B?V3BIVHJpT0IzN0F0TzBMS1c5RHFrYndRZGwrSFM5R3Bsb3g5QzlndWQ4WkFz?=
 =?utf-8?B?cVZoM0EvbVpFUnhuWG93eUVjYURCT0UweXJPUWNkdHFEL2NNMlNpOWZSQWJR?=
 =?utf-8?B?ZVBucDA2bVR0eTYzeEFDemxlYmV3SldURTJaVnl5SGY3ZHZSNTFEYTkzWTBx?=
 =?utf-8?B?VEVsTlNVSDgvb1BsRXQ0SGtremsxQmZtOWVDQ3pROEhXSnNaM3k1VGFjZk5m?=
 =?utf-8?B?OXN1Z0k0SElKUU1GK2tnem4wRTBRaHZ3MlpPc21vSmQxajBjanZJbm11aEgz?=
 =?utf-8?B?dHgwOE1qWms5MjgrTUlwMXlud0t1QzVUK0ZUZVlyc21tZ3hTV1E1Yi83NS90?=
 =?utf-8?B?QVZPcUZWZ2d0ckNqNXI2MVI3ODk0TEJSQTJUZ3NFTlNySVo0WFZaVThBWUxs?=
 =?utf-8?B?R1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8087bbfa-2815-48b3-1469-08da79784bf2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 19:58:00.5101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IS9e9OpaplWoNF4z37nOQQq/h5dgm/nRIaXQ7Ls/z/yKn57H8QT6eaKfjjEloBHr6odwWx7eXlHh4wQwGRzd8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3767
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tim,

On 8/8/22 3:18 PM, Tim Harvey wrote:
> Greetings,
> 
> I'm trying to understand if there is any implication of 'ethernet<n>'
> aliases in Linux such as:
>         aliases {
>                 ethernet0 = &eqos;
>                 ethernet1 = &fec;
>                 ethernet2 = &lan1;
>                 ethernet3 = &lan2;
>                 ethernet4 = &lan3;
>                 ethernet5 = &lan4;
>                 ethernet6 = &lan5;
>         };
> 
> I know U-Boot boards that use device-tree will use these aliases to
> name the devices in U-Boot such that the device with alias 'ethernet0'
> becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
> appears that the naming of network devices that are embedded (ie SoC)
> vs enumerated (ie pci/usb) are always based on device registration
> order which for static drivers depends on Makefile linking order and
> has nothing to do with device-tree.
> 
> Is there currently any way to control network device naming in Linux
> other than udev?

You can also use systemd-networkd et al. (but that is the same kind of mechanism)

> Does Linux use the ethernet<n> aliases for anything at all?

No :l

--Sean
