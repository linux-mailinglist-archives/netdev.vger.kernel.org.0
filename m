Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FB66EAE1A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjDUPfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjDUPfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:35:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2137.outbound.protection.outlook.com [40.107.93.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00D2527B
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWbRcvW/r/ccfvSnphS1mhJzyWG3+PQ/oUODnOdXnHXhBbdXDwU0RywR5UWFgyp7o12AVtHy0GoqiUqelM10zHIo9NxUUF2jfeBgEAA8f4RNfdyvsWi2JgUUEtPHrtZT5/hdZx+mFOdFWWrDd9NW7c+aeoTU/PJ7hG6UZ6aqU94VN7+5v1WXX237ONNDj6nqw9wU6JeG7LwuNjOHEtR0K9u1CDUfwlGY21P+mpYpX5FOAu4SMDH51PbeyAPRhNb1Wpkcbw8IjLSAws0DCq9ixn2O62QKA96pSnNiA2C3EeyChv99e+LPfvISXX/wgN44+C7IulZ0GD+NSalyRJvniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vOjo2/XWnqzUljGxlmIDZBf2FsVttd65iDat/mrlO0=;
 b=WacrPMFs6/3j15nJyuqq+4W9KG7pfxeYATkno9CVEi5Igw6LZXxBOIbwvfata9PoRb/WnmmrCZHCRWqo1QLgGZu+W/bIzeTeYEJ+FaL5ksfhSXEUUqFnD5tbweBK/AkVgVWNdqtLdW1yTWsgXFIkKMOkcjLAm0KUvZTgX7trVzat9kPWpgo95vba9UXtRsuLpxzqga20fYA1omJPxFxtmBIgDXvH/QroX8HNEAMgAJ0muH0TF7raWQNY2U2XFgLX9NxVN5MInJTD1w1AJC3ak7Q80IFYnWuHcfPmFBANDgB1WqPbNMwy/dbk/8rrZIcI1uchgim/7g5dmJ8N5edEjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vOjo2/XWnqzUljGxlmIDZBf2FsVttd65iDat/mrlO0=;
 b=PWJyfSl7/Up7Uq1twlh85LJAFXUJa+LAYzRYYp0O0CZ8f0oeakzVA24o5BvLuNaLDGlkRilQM9YupHlwWoR1G3s5tyjb3feIk1/s8mEaPu/AQ7r+dwAGoO90pzbZgwvNw0Qaa4en48Cq8Q9zk8c/ZajG/j7jUVCICU5A9QzdcgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5383.namprd13.prod.outlook.com (2603:10b6:a03:3d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 15:35:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 15:35:00 +0000
Date:   Fri, 21 Apr 2023 17:34:53 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?UmFtw7Nu?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v4] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <ZEKtHbO+gPcakNur@corigine.com>
References: <ZEFqFg9RO+Vsj8Kv@debian>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZEFqFg9RO+Vsj8Kv@debian>
X-ClientProxiedBy: AM4PR0902CA0001.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5383:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fb78cf4-915d-49ce-c0e9-08db427df817
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dD7dtNZfA/W+RO+ct6cmLuEDrW6lbOfIKelTzkPnKwu/uZaKgpkWXFhovgqOX5HQCq9tYg458R7ousys5w7SXYmigdd6bkfIUG/IKjqfceN+yn8G9ThX3CrhwMprqIrf6a1ZV5VFOT+zgF87sBH/OBqRxKs4DvkHovphjGp63NM+T6wgxB5+gTAUpmoY/H0aoMtp4OC6tVUqtbMAc54uHIsjLVKa2dW7d06QOHrdOPM4V1wAacRxusWbZ0ytoMX7Bl10izWxmyvQOfzts/S8rF45Ev95F9iR8WSMXZOe3ajEseF/DxN0R9k2wZsrbgBcFrfMY4Bx0JXY7raz5Ja3CvuXjjJDHomvYyw8XcGwUZbY97QajUoJzceYmVc/8NxWZb7POerP8ETX/ZH107IT//RnmyleY07bl5iCR+MLmgO/2Mdayod7nInCwhtHeVWr3frfilNV1ACzX5DkYMEC/I92AzSJ/u4hSeXOgjLTqz5OGytH8gj7ZWVM3o7x6tv+GWi0dqvBgRM6ZoF3XjG91liRyGubr93fMvC5mY8zaju99GZNL5dCfMvyICuOgVqaTJkCZQMYFUjKbzjJMBfMp2lvGI6xC6DB/KDTVVLelSVGCOr/GfDVcc6jsa3jwBUCdXx2oQAXbPI413Z6k1zFtCulyFUvK320CPKqE8P+1cE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39840400004)(366004)(136003)(451199021)(38100700002)(66574015)(83380400001)(2906002)(86362001)(2616005)(6512007)(186003)(6506007)(44832011)(6486002)(7416002)(66476007)(66556008)(6916009)(66946007)(478600001)(6666004)(36756003)(316002)(4326008)(5660300002)(54906003)(8936002)(41300700001)(8676002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlVtdGtXSDZqRkEvNjJEY2I4MWdNcEhHWVV3ZTY3S2ZhNzZwZWdMWEpKcUE0?=
 =?utf-8?B?Z0VIeVJKc0Q2aCttSzJ6TUJSbWtvaXYzTW03blBaQVlFQWE0OURaMDFwNlhq?=
 =?utf-8?B?eG96ZTZCSURLMUdyYnNLcVBhMlNPR3prbGxMUlUyTW9OejRrUnh2UzBQVy9D?=
 =?utf-8?B?cW5CQ1JWdXF1K1kxNGYxcjQyT2tQNzJDV05xNUdWZk9zZGM0eDN2UCtjblVh?=
 =?utf-8?B?aE00YXczVDljMUd0T1YvMlY2MzREc3cxOHJTMlhKMW81R3ZUekNnUW5iLzFj?=
 =?utf-8?B?dm5QZncyRlBGY3Noekt3UmlPdW9tV2szN0NSZ0tqc0UxOUwvLzFjOTZkTUF2?=
 =?utf-8?B?aGh1K20xRC8xNUc2cjNrRG1vN2Y5RW56ejBTTy93WEw1RDZrZ3crUDdNa2VJ?=
 =?utf-8?B?UVRhcmxBV0JmNUVwTjlzVkVsUjNIajl2NjRYcm45SlZWdTRNdk12YTEwMVpW?=
 =?utf-8?B?T3g1ek9IU0M5Y3JSbmNuZlZjL0wxVEUyZHBhb0F6RCtGTjc2YWF0aDMwMkJr?=
 =?utf-8?B?eGJuL3ArT2VldEc3QlZiYmp2dEJwNjF3UTVmQUpCMmw3UVpRWUVrVitLdzNL?=
 =?utf-8?B?amlnbUd6R1I3SHBlOHNjSkVvSVM0dG9mRG4zOXJFRDAvSDZrVW5HbFZYR3Ey?=
 =?utf-8?B?Nk1CenNrVmFYczUzYUl2NDFNeFpIUjdzQ0xtY2RuNmNwRFFrZnFXQis1RXox?=
 =?utf-8?B?TnYxVGJlR0FWWkJybkJIMnBOOEIvZjBhUkQ2L2lwa1RuWnVZRW1IKy82ZE9R?=
 =?utf-8?B?YXlBNjFKWXZCb2lEMVpPcTdSSDRZczR4MUJubGJyRlJxK2xCZDBnYkRhVU81?=
 =?utf-8?B?SVloUE4zR0dSV3dwQ1hpakZnVUU4SUxha2E3bW1VZW9vM0ZoeThHdEVhVG1C?=
 =?utf-8?B?VGdyTFlLeVNyank2K3NEMXlMMnNYaTRBUHVNMVJXK0FpOVE0dTU4TmNndFY3?=
 =?utf-8?B?ejJmYUNOcCsrQzhJSXk3OXhLVGlXSk5weEJEK1ljMWJ1RDVNWjBicmQ4K25V?=
 =?utf-8?B?c29BSGx3VkZmbTRpMVNQdjZ1REhMbU51VnBjY2k4YmYxMDV2anF3TmdrYmJp?=
 =?utf-8?B?eFVNcGhXR0dIajhpcVVWMVd6U3RYZzJNNFdkdXV5QWNtaTdwcWtLdDFnbFZL?=
 =?utf-8?B?bXF3M09VYnlYWjlkblJIVk0yMmd1TWdTSlRHUEQzTVR0UVJNcXU5TjVma1Ux?=
 =?utf-8?B?MHFoL09CVEVUa2psSEN0NWlrZGVFWXN1NFc2T0ZIMXlSdW9IVlZjK1B6L0s2?=
 =?utf-8?B?SUJjRVJTK3oyd3d6Y05ibUxpdVUxdWFuelJyRC93d0VqOHNEbndEVnNHVkMz?=
 =?utf-8?B?MHJOUDZNR2xNNlE1L2p4RHYvbzF2Y1YxdFVRcmtBZllEOExCVDQwYW4yUnZH?=
 =?utf-8?B?VUFUa2hBNUpFSVFtd2JCM0FGSmpMK0NuYkQ2dHFITlV0QU1aZk9DQ1A3MXg2?=
 =?utf-8?B?SHBuMThrdFVlNXN6YjR0T1RGbHpTQTFRRlZVRFU3NDJPaml2dG5vYklRdjVi?=
 =?utf-8?B?bjFLUzNmamwva3BqckQ2dG9KbFlacURpUG4xOERudkZEdW92L1loVDhONTBk?=
 =?utf-8?B?K0QvYksreUVPL2lmY1huWFIzajQ2L2JtWWJweWthS2RvWW1rNDhEOXB6bjd2?=
 =?utf-8?B?aFFRcFhZOVhYaXF6Q2ZOenF5eGNvbzlrdGN5NTV3YVh0VjhUblZrZUhWVXBK?=
 =?utf-8?B?ZTFxVGh3ellUU0MyT3hBTm9oVUhIT25YSXphTkhWREtYc1ZhRy9lSzJxNE5N?=
 =?utf-8?B?ZnExNm4ybG42QmhFTEpCTUg1NTlBZUVFQUlMWG02angrbENwR2FLTmlVTERJ?=
 =?utf-8?B?YzdCdEowYU9KQTR1RUVMaWhibFAwc2pNcm1IS3VlUytJY083ek1GMWpLUlhw?=
 =?utf-8?B?VTVIZFU1Y3lVamh0bjhiemxSZWdVR283WVZKQnlUbklTVW9sRWJSYXJwVTRI?=
 =?utf-8?B?MXhyaTlnYW5DTE1EYUUzZGY2QnBRZ3NXelFuTXNiOFQ1VFNHVEZkSERwbXZL?=
 =?utf-8?B?Rk1oa3RNdnJCanh1N1FtbEN3UUtNeDFGUTlmTU9CNmdLNjlJV3VkYmxSQnBC?=
 =?utf-8?B?TjIzbit1MTd4dXFTSE1GS3lkZ2ZBTlN0NlYrMEs2OWdpRit4VThQa01GYkZB?=
 =?utf-8?B?cXAxY2pUTlZZMUg0NWxXMTNGNVF4bGEvRXB3Z3dqOEIyb2pQblBVLzJzSGJZ?=
 =?utf-8?B?RUhYTjFYRFYzbklldnR1RFJ2MDZqNU9pYUFKOVdnczJrdE5qRVE4NUZ1OGx4?=
 =?utf-8?B?SHdGRVFOZzB2cWI4ZkhEVXhuYmlBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb78cf4-915d-49ce-c0e9-08db427df817
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 15:35:00.6879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oQ0u5n82xwI4j5OTc/1a2uOPdyZIUFqfQNgeP+7jlzVFul2Hx4DV/2iPsC4+MRRrYt2iwBUeCGGqYWawplRoZ6wd/gKYbsYPdgYDivngmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5383
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 06:36:38PM +0200, Ramón Nordin Rodriguez wrote:
> This patch adds support for the Microchip LAN867x 10BASE-T1S family
> (LAN8670/1/2). The driver supports P2MP with PLCA.
> 
> Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

...

> +static int lan867x_config_init(struct phy_device *phydev)
> +{
> +	/* HW quirk: Microchip states in the application note (AN1699) for the phy
> +	 * that a set of read-modify-write (rmw) operations has to be performed
> +	 * on a set of seemingly magic registers.
> +	 * The result of these operations is just described as 'optimal performance'
> +	 * Microchip gives no explanation as to what these mmd regs do,
> +	 * in fact they are marked as reserved in the datasheet.
> +	 * It is unclear if phy_modify_mmd would be safe to use or if a write
> +	 * really has to happen to each register.
> +	 * In order to exacly conform to what is stated in the AN phy_write_mmd is

nit: s/exacly/exactly/

> +	 * used, which might then write the same value back as read + modified.
> +	 */

...
