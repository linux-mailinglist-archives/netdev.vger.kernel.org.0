Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846206A2ADC
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBYQr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYQrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:47:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2125.outbound.protection.outlook.com [40.107.244.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934B14EC4
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:47:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BI/J7payzoMIIFagnXBK71IitHCCBFQxP8qbd5PNwa0HVcnz6nfTGTSbHApuHWCocpVOAaBiYAX/mQSHNwS576h7AW9owdOWKswBzwol/x1MI7GgYkqx7f6tlUZ84EDJMiepoYHTWgzOQUjKaujFuQ7t2D6S3WJYLBeC4ovbaN7AWraLrZYKHJggJhwqx1IMrExsoancqhv86Jmvw1YlUVifz0jaX6u7HUkZyTrdfd1MD6ptfsspQv+6IzVxvH4mwaOJegJJ3QcFUvgV9Z0Bj7ZA7tnq0uRgfUZfewKxSvsCOWBw36sSla5u6QEfuEp0GGpeEtfqLSKIyjIGZJPBLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfDz2OBi3CRPZ3ZSUvplNInJUIiN+LKPUGM3U50zz60=;
 b=FimMfPzTgV3Aitg2rzIAozasXj5/zUL3htnFodMQtuyKrJaVP4H5+91typx+9OQ+e/acPMCS51FE7i4Ajqw2T0nC2/ILCvGvUIiz6xJwzGnrLUwgLp2T5vurmMRMxOx5AvLN/zWiW7rSboU5DhXJLdRxTNF2GQ9MuQoXJFrqt6xhWhn1PazF2AhCbnEz9WGyvQIFOaGabtdhcc1mwktxXYnhUWdNyrwupVl2KDIde7F2r4UsxLrlRi6PlBQBNmeLZMKMoUcP3VkyGT2PPQqrPXNqVKTzBBZ4QH31MNA7iudb4Wb2/vZJfv6P4u8RhMofw6VuRRfwEWv2QDONvKcIBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfDz2OBi3CRPZ3ZSUvplNInJUIiN+LKPUGM3U50zz60=;
 b=O2v4j+ilGS6ITV84Gf7TBJQmV1JFZ28bsHW7Itqnyub0fD1qPaNfAAZpSi2FGOEzPXbKQVTU+0hKzMG2VMLExvIz1ZlxEj4Sib/qmWdSJlfPmhfQEkNrFylHdu/i+bW6SgNlrXB9BdMVu2zrgiqk+XJVrRLPqKMD5l/Glxaxlao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5682.namprd13.prod.outlook.com (2603:10b6:510:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 16:47:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:47:51 +0000
Date:   Sat, 25 Feb 2023 17:47:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 3/4] net: mtk_eth_soc: remove unnecessary
 checks in mtk_mac_config()
Message-ID: <Y/o7sJ8YZZqI09U0@corigine.com>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJF-00CTAf-Qu@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pVXJF-00CTAf-Qu@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: 5157177e-914b-4993-26da-08db175008d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KP1U/YtmMMDw8ANRP+Pi3gN8xSUCbbAJ2w3XZ9TTR/UMUYqG7D1Bom9UMdh/6crdyMB+LbThthh/HOTnJCJcwuUptjDLedQ3d/QQyl/QCuiMdpgUGd/NhQnNgkyAbXEiPl7Qp9041wvMY8VMwJreZkosABeCaRM46BQYPddie6Ks0x5j/lA7wOBwpyI6tvXXjdqUOBbVPimbvhj+tqkhEezngkjE4fVO59gFEbyAPlk9NP8U2tGOQrpX+oJls6F6Op//C0NxmWBVK0fWkccsFuGS5hRECLZon7krYs3Ds5Zi1vxEAv7sefw6VCmQGpDOUi70agnmAHLfd/MhRyH9xwQLWjjjtBKYGL3ucQrtldoSVz183drKPNnpw2EUe11qoAqNADs8DMM3vvGfctUW3NaWgZDUTALvY9THpcZYYRuFZIGyhgC+89y+XMEHJzO5hsVlG1bNDMy3vrzUfzNIhznWfJ9le7xzmNt+le7ScOBnZJ4RacgXbmcaOnooXkrojtPqddeJxzJd1q8b4EMNms+UdHdlXXyBulodIu1jcVlleauQrZNdz+0iP8AEIh484yHTmsy+v80ppxlvIbsJv4GtJQdWqEQXFwm7MI56+7o0V46vc8vAXftV/O1jTPTDRFa7Io7OLklUM1RH5EEZsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(39840400004)(396003)(376002)(451199018)(7416002)(41300700001)(8936002)(44832011)(4744005)(2906002)(4326008)(5660300002)(66946007)(8676002)(66476007)(66556008)(6666004)(54906003)(6512007)(316002)(478600001)(6506007)(36756003)(6486002)(186003)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wZW1ni//Imo5qACK0iRcCNB/+l0b2idgNKfFww8tNk+kanmGgf4KgCtux+jm?=
 =?us-ascii?Q?HDTjGS7JNJ2VGMpj4Jsw9YJooqHou5ihTEH4imq03z6QAZu/c1D/tU7R9THr?=
 =?us-ascii?Q?vxCtY4VoKBIyrHmlswOR1WDtjIPATN0+y8QUTaZwCWKzDD+eUF9pO4lt7ZS8?=
 =?us-ascii?Q?6BnaEYkluclfv4uu5qyhAVscrq0frcUldxfsMdmHcHkA4A8lUh1D+Fe8WiaW?=
 =?us-ascii?Q?orzESYpRjGRaZzaTsyT5xiNgndbIZT0Uos+r3ShfUkgGTRAIXkENWtLvI6Mb?=
 =?us-ascii?Q?ll2jveuicVdOhUZVXbzz3unBRJ4cmFbVOx+QLqNfg9pX9Gyb6pGNoFrbjC/6?=
 =?us-ascii?Q?giB/oYZghlgm64aZ0dU4pgg7xcoClTLTBWseQ6PV5i/JCGtzIn2bYCi1fDTf?=
 =?us-ascii?Q?/bjRGonedn+FP1Hu4/E6s+OSpGVa5XmQ4BA3Ml8muZJEzlEE+QYvFOOe/ygY?=
 =?us-ascii?Q?1kvardTAIqDSSOMWE4mQJJwVbJgHtjYktYgVlvpxyPvFQKtXcJ2BOpqJACCm?=
 =?us-ascii?Q?NjXjpB98LAItnvlWJdF8krq6isePGEH4aPO+4tugeTDQzh30spSTogUFo3If?=
 =?us-ascii?Q?FSIgZbIy6mIq4yzPeu9wgF0x//5O9hbZ1JyyoKTHaAvBzy6p3dQfVuUZJCTQ?=
 =?us-ascii?Q?B8tmtFDor9MNSIzxnCPUNyrccwsTaARf2BSVUKSbPYC0NHrmdo5Z/QoUSZ/f?=
 =?us-ascii?Q?6F9mb0yJ1X4txPq12AoMADNp6LOhPzdRpKIQMjbxEpVystdtkymiM0RWNwMO?=
 =?us-ascii?Q?UVEkXjRmY7MSnp864eYQCTOgNSatn+Qz1JdOnmrcoi82ZsGq1nFLqSoM8uFW?=
 =?us-ascii?Q?3f/NObmprM14C+q3Mc2oBuJ3okrWlRiYU34/x/fn7ltLyKoEYYS1ITd56OJ4?=
 =?us-ascii?Q?DDNjkVtbLggjCSbFtDek6qi+iZltJ2xJ5WIfk3FFds8V7na1IYStNsE8/aXz?=
 =?us-ascii?Q?g156aB2zggZ9qCekslGL83dHUd8hNrM4U7l9R7oQF1tl+V//9ILm4bramjjw?=
 =?us-ascii?Q?s7l1LucniDpORth1LtVylhH5Sj8lbJ4jZBJF/geCHbIqd1mQA5wP2/Yr9ppM?=
 =?us-ascii?Q?PdPulMsZ0Z1U3Hf5OH36gjzetK74P1YlewMxpNsCYrco5w0xQ99BmHe98zLu?=
 =?us-ascii?Q?+vpf/pPTZ4GIzSyaPx3y5eKLMTZRXC0Ky5zttUAMg8qnyhpIFRzvZiR78NgO?=
 =?us-ascii?Q?xNex/8hePcWV+ac6KhW0X769CtaHhvG0GAiFSMI7bzxCnAs34kX7TBUXjdFK?=
 =?us-ascii?Q?DZJ3P8jF24XLEzld/YMzoDZmhYp3qBkGHxhl2RomfucGH8GulhKSa+LkTgEn?=
 =?us-ascii?Q?tT06GP17/2oslaWVYlMc7+cEsct8REVZmJ8EjvYlek3C7byKTtfBNCiWhWuM?=
 =?us-ascii?Q?Kq9xPvde+x4hkielVtbGUMqrbrfdm/8G4mktJfkpspNI7/mIPiGAO1uci257?=
 =?us-ascii?Q?lHenVshzYnnUeYykg4RpUY8LNBdUtZYaF3KViXghIrNeOVLA1g7aYNPQYWq2?=
 =?us-ascii?Q?MoHlqUfX3mgAqrrwTN+3EhjHmb0ce4BB1pYoRhMDa5uI+VQ1NWt28QNkF9l7?=
 =?us-ascii?Q?Z7YxF6jamaOkvIGqZb+a6LOXYaGIRzioYtvWnbvUm6M9JHYRvlpjrC08B6FO?=
 =?us-ascii?Q?NrcdnBqcE8QQdjEZnq260rOs+5LaQWV8uFV7PBSx1Q3/DyZSF6+/3CC9v04J?=
 =?us-ascii?Q?IHDWiw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5157177e-914b-4993-26da-08db175008d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:47:51.7588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p++l/G/RVxrDmKlgKxXRnvYSFTXAaqrooAyl9ndIb1EtQK6G5/YBElnEAyPWZALvS9UKB27FMnOPswq5eOJzaXL1XxjA7Z3gYtX5Vx043EU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5682
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:36:21PM +0000, Russell King (Oracle) wrote:
> mtk_mac_config() checks that the interface mode is permitted for the
> capabilities, but we already do these checks in mtk_add_mac() when
> initialising phylink's supported_interfaces bitmap. Remove the
> unnecessary tests.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

