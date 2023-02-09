Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B28690B8B
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 15:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjBIOUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 09:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjBIOUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 09:20:23 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2074.outbound.protection.outlook.com [40.107.241.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5504C2BF06;
        Thu,  9 Feb 2023 06:20:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GToO2QSYJ2BmTRgppcOxwXmmsrsf9Fj2GTzoRQQLJ2vDGZDdgN5PalHiyqcBnTX7/T+2D/EyPFbrno8jj9Xl4KU2ybdNlNX4Y5s1EMBC14LSr/ZQJTXrjM+OwTwj7Dj635aTibBJLkXBW/s6HYNFiip+cyVLr4TFLJvfz6Z4u1KhIrBH0sIyxC+R/yhSOAS/nZWb3X9PAb35bFEQAV4F3VCMc/dIpYttEYtvmuJiEyuD1B+P8KF2ipegoDpacRxgYuZH6Bj2w46TwWKkalNidFQ+nJ3oI2MYEINSSwT9UbvE8DkIXvQO78UGZ4jRT6tNscZl/c5Sis+wEntdo8YW9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1j77rC9ljxmh9HzAvg89Is3S4wsVgFguGs40n36Ilc=;
 b=cO7jEi7DXgGcKnoVxEXzViHT4rpHWFjkHQtFBl8foSJi15fn4y9FipSDomSn1jBEXrH80y05HybEf2A2GG3wQGgeCZCxrHZELKmNGuv6BEg609lrMf7eGKXr2EKBlhGUozzKv15thGeP5lOiQPXG3flDB6oUw/Hty/B2CG/5o91Qo8uOdiIA/TJtYt98D2NnHS7oX4+yzdfV6vsM/XX0QBxDDj5mfqJnfyHNoMZzvFe+CkSmXyP+0zSOozmMmu1SFDNItz1Q5Ubq1ZTkrX7PWPZpcQy1LZlr7iUtwxzFCsX3PRxFYPueCAN+/kzKG9Pcff/IygmopyrjuUIRShDN7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kococonnector.com; dmarc=pass action=none
 header.from=kococonnector.com; dkim=pass header.d=kococonnector.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=KoCoConnector.onmicrosoft.com; s=selector2-KoCoConnector-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1j77rC9ljxmh9HzAvg89Is3S4wsVgFguGs40n36Ilc=;
 b=dKP726niU/LxnMin0+vGfr1ZFmpRI99lNOrSDE8fZarHM8kSOSdds3ArrlK4Yki2mt+DgJEzcwVVdeWTLaeiHQAHFZu8mNmzwG6BqL1yC6AKj1WIJGsfpsGjYGxglTLPi9ya7i8Ko+k7LWKF7bbUPFg3t67FnpYtsAU6FOf6fbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kococonnector.com;
Received: from AM9PR09MB4884.eurprd09.prod.outlook.com (2603:10a6:20b:281::9)
 by AM8PR09MB5242.eurprd09.prod.outlook.com (2603:10a6:20b:3d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Thu, 9 Feb
 2023 14:20:19 +0000
Received: from AM9PR09MB4884.eurprd09.prod.outlook.com
 ([fe80::e9ab:975f:f6cf:e641]) by AM9PR09MB4884.eurprd09.prod.outlook.com
 ([fe80::e9ab:975f:f6cf:e641%3]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 14:20:19 +0000
Date:   Thu, 9 Feb 2023 15:20:10 +0100
From:   Oliver Graute <oliver.graute@kococonnector.com>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com
Subject: Re: [PATCH RFC] linux: net: phy: realtek: changing LED behaviour for
 RTL8211F
Message-ID: <20230209142009.GB1550@optiplex>
Mail-Followup-To: Michael Walle <michael@walle.cc>, andrew@lunn.ch,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com
References: <20230209123917.GA1550@optiplex>
 <20230209133002.180178-1-michael@walle.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209133002.180178-1-michael@walle.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: FR0P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::13) To AM9PR09MB4884.eurprd09.prod.outlook.com
 (2603:10a6:20b:281::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR09MB4884:EE_|AM8PR09MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: dc0996ea-64fd-40c7-a22b-08db0aa8c5fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ggtDeXBS770E1hUk3RQEgxbeYLhbl+A3HzjAkrq89i+v4orA6m5WVtSSoEtvf7AmSoRwMagMQaQk1DEij7mZLpp/sprVFsjCqRnELuP+qwtqXY3FQtIG44KeQS4tT1GBJGfbe2K7GjZgtBya57F0BfxnHzZWi/GnRsrSTi5AkY5gd+bzg0y2qWIUBjZR7yVmSz84toQeUvn0yoX7fY8+amL/LlVFtvQhgrD+w6dgMw/hWv1L/+4yxaPacCXej2ZLkxOT96OvfEaZ+g37vNfDw2QwLm8Fi82b8Uhz90RbkG4v07Hr7oJ5noUgP5YVMkUQzDuS9ZBjVvcG4/RqCdWCXFrKQmxtm/lTwyKFBu5oSzKt2vkif1nUOXSQhKkgLcrwTECuCG5POvzMjBxfVewTNIyefEIJ5q1iCgdYQ/aEw/MsGRhq8wRKLA6Q+OKmq1FKhwXfcyUTt4Hxm/l0zY4g3gWeuKXo1tzhA7ViX6nRclentG7K1dlGpYk8qOfLBTMLVLl6vBmB/1kIuRumUsIzRhfDiptKoFJ7boSgbwD6E+XrQCMYFn16ejtz1tOcPKX+ujPTuTGG7LFsqFpeqLz3GbTr+ji7D1BC8EZ0QoyDF2udCno/UtOb4gr1l5+UtZXtvW2f7LBfk/xjlUrARgJxTqsIge8NUtG7F5xZ5LfkTTMVJbx3POvhxQNHRRr4xlIvYOlMRrWDI/0A49WhiuBx2Ok8J7sGy/q0nbeIlfUTPC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR09MB4884.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(136003)(366004)(39830400003)(376002)(346002)(451199018)(38100700002)(38350700002)(52116002)(4744005)(316002)(966005)(44832011)(33716001)(6486002)(33656002)(6512007)(9686003)(186003)(478600001)(66556008)(66476007)(66946007)(2906002)(8936002)(7416002)(6916009)(5660300002)(86362001)(8676002)(4326008)(26005)(6506007)(41300700001)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3K/C4gIvfyJGoV9prmpGfPM+87FMlrznABcCVMLAS5fnxEQSpfMbDC8/dvvN?=
 =?us-ascii?Q?oBRFwICCifrwWKr2SdsyMN2mScnTkslkG9na8LkmdZH1VBEz2PTVuUw1VZUS?=
 =?us-ascii?Q?kPgpdCmrzgwLhHDnYsw+CjNBlCUD6d7TRP5QMUImmQcq3sloQY1g5AWAi95W?=
 =?us-ascii?Q?qdhrGvgxQ1zihdrtfVLZoUeOrCtjTmnepUaaxS+Vp2nDGjmwW7UeFAchkddB?=
 =?us-ascii?Q?rmbU2BZAsG/WSc7QS1y2i7gV8kF+oQ+4V6lxwkyqnKwgP1OQflFq/DT/VXEW?=
 =?us-ascii?Q?Kj/7ZXGZ7JwDZLqh+SU/cPzQmJi65qSD6j0NIL+IbYPjcBw2N/Si7xl0ofmQ?=
 =?us-ascii?Q?KhK+CmHIMxtdEe8maeBKgi7h6eXl8TJBUEN0s+t1sGWseUeDf+7GOJjfnJGV?=
 =?us-ascii?Q?QyTaCqKsHS0ONRpticWZlLbywykCKHTM3K/7jWBrZv8zTzAekjfHexOF4htn?=
 =?us-ascii?Q?iCUw6VHp2hjNJKV2wKpLMpnwT5lzWlNZEKd0QFw8MuDprJ0P5XfgEBA8z/Ui?=
 =?us-ascii?Q?rq2Y5qXSIMTAyQmSP6b/DEH4J5y/LjK29pyP/w5Scu59/ZNmgaBA4jKdrg5V?=
 =?us-ascii?Q?Ye76sGpgUOgN1UtSaBFCVmWESQPUdqYP5guz/GYPPHPrw3hmRyb4e1gqxc41?=
 =?us-ascii?Q?26YnFRhLNuiYR9f92kIHS666uCtLKyXuD1lqe0qFeJ3N6GA7SKaKGNUV1SW4?=
 =?us-ascii?Q?fgctBf/0FLrFbG1Jw0jdsDVnyOZL82F5sS4nuqj5UBb33QGudvb3tQva5Ryc?=
 =?us-ascii?Q?oY/yR9CAE4mi5Z+9wQ7DzF7FnZ+b3Q5jShAc/k3WBUv86aAWXsWlrzEapnbb?=
 =?us-ascii?Q?tGBOc9PfeeMZIm+nmcz850VILLZimtutA0aG0LVKF1TYcHZcDLP9KlSRr/An?=
 =?us-ascii?Q?ASX8T0nC9jrqDXTMn3UQcg32bIKtz0oW1JLiYoKEXSp3M9AdS+mcH2EGIaJZ?=
 =?us-ascii?Q?RkBOFBfnMRkyeZiLEeA1JfXrDJkYWSseNsVSG+iW88gDP+piEfyFEoL7gW4R?=
 =?us-ascii?Q?GyUqzbzNvYBll0UNMxOiJI6RZxj+pjv4KQjpHydLdrTe+e9q9AaOt8H8StAD?=
 =?us-ascii?Q?hg755ZPKNthkt+EcefHTUQLsuZZ7VDvmCOWaK8gc6XoFrTU8hi3fDxK1htl1?=
 =?us-ascii?Q?90/mFudXgHmyiefrPcAcs3+GYjist615uRUFd0Q+q2xNmxJXGBYuMWL1yAv6?=
 =?us-ascii?Q?qmmFqMSbkSiH+/cGOuiACRbD1klo3GwZBxJnxSEEHRVzwY6SO5MIbxAXXEJg?=
 =?us-ascii?Q?VOzKhovMQ1WoXex1Cgi2u9MEB/2Hldd/UFHDbswdIZ0gx+67K3vnpZ7KyvM7?=
 =?us-ascii?Q?WXYGEV19Ku/Z2Qg3VVXVFyhHOVRuj9xYDnXx416cRrm3GSvY7C69bJ16JODV?=
 =?us-ascii?Q?jZsGiSHWiHwPRGUiaHM2/ypibTn0BEYh6qkS+Dar7IP3uQddnAGfCd0xn4VF?=
 =?us-ascii?Q?2YsJx2tnsCuAIt5sf/VAFh+hQ7l2agmucf5mhEqmB3XKYzkLktpReTBgCaZH?=
 =?us-ascii?Q?yo7ck9sD94DWO0C0SKLH4QgQocZbJ9Hcr1MY5q4zOE2pqL5XcGCAut5Zc70u?=
 =?us-ascii?Q?GTnGMGbv6EujFC9cHp+AcNVHxsZWRS7m7XINpEubq/Nw2YTouIYfkelM2OzM?=
 =?us-ascii?Q?z5OTWoZB+G+Jg9hEK4iViS0=3D?=
X-OriginatorOrg: kococonnector.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0996ea-64fd-40c7-a22b-08db0aa8c5fd
X-MS-Exchange-CrossTenant-AuthSource: AM9PR09MB4884.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 14:20:19.7761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 59845429-0644-4099-bd7e-17fba65a2f2b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PyavM0x0DsLk8W1KJwvCdF6m7PVI3Fc6PHbaY8sCjY8/hw5MXczn9g4Aj4C1z5bN6a1upI4W6acSuBN4Qe580iAsdoVE62n1YHU0MywV2R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR09MB5242
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/23, Michael Walle wrote:
> > is this the right place to turn on the realtek phy LEDs for RTL8211F?
> 
> Probably not. There are a few issues. This will only work one particular
> board. Therefore, you'd need some kind of runtime configuration to also
> support other boards. But lately any LED related patches for PHYs were
> NAK'd because they need to integrate with the LED subsystem. See [1].
> 
> -michael
> 
> [1] https://lore.kernel.org/r/YyxOTKJ8OTxXgWcA@lunn.ch/

ok thx for this information.

Best Regards,

Oliver
