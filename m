Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E18A35C351
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239495AbhDLKEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:04:09 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:38118
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245009AbhDLKCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 06:02:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfahW3klZeomsClH4smRcelbtjlfUYdt9OK7AQ5eLRe/X8kOVjBdrITvaPY0mdBZuxcFLstWVTMvZAtSVHpZnNFcUbk27fOHujG2ui8sSAF28VXKTuf1iEj5GutLrH3J8kCfJUHXMXOw4K/jNQkLiCwk5NCe3e9eZ5LcMNtyANvhb6Pahs127gBjJYTkDZlRJoP+OUugxw8zlRqu5rVc+Yc+RBNiEVTcdvvJ/H9c46V7KMEBnDaf/JNGe3vPhv3/iyFk8+m0dWX5CKT+J5htLPJQNL4MXR5vDA4xUtrw2mng3jwFZSFPwqb/iIqLkPBiBHu8jMTVcUOjQX+s4pSslw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hldA9HZgHQMMdI5xwCyXQwbcGEw+SA60BTr2p4MGWP8=;
 b=HDaqT+U1SEAyh84JJ/RwbR4avrLdxue1AMEK0rswWdOfqGCSrL8NhL6FfVeczjjVkLM1jT5D/0+hFP9Vh5EF09UFSULy9lNQwK7bKJDJGTvKUYiKi3WOezZSXCNYAgmxWQYtZGvFBigfU0qp+8Cj2sQw/R1qaBA0gzauWFVf6+EdguBef9nyIv/IPbi9Vx2upeZkj0A2goj/1Cp1KR/zlb1noBLko+66ghfQj943tVOt1T/tBMieqj1taAyGSmsUnBUyNybhbZIvLeZxhVSEf60oMjggUztW9t2Of5VZKjqt7ViOgiRpuY9XmKdUoXWSuuRCW+ERfXWFMX7GfplDuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hldA9HZgHQMMdI5xwCyXQwbcGEw+SA60BTr2p4MGWP8=;
 b=G4X+DrPJW2IlhkQE0Jrl2P3tR2zTLs5Q/e2YhKzogXhiTsfYsScY/4N8DYNHIygpa8mVKIkoe1BaaHbXiPPF+vUHHcGBKxj10ECwohAURiEogU89BkUvO/W+5mhW6R6lXoqnTAN8EWHbamd7qgwIeCBweN/m+Mh7qOWkL6yc1uY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB7198.eurprd04.prod.outlook.com (2603:10a6:800:126::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 10:02:12 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 10:02:12 +0000
Message-ID: <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
From:   "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 12 Apr 2021 13:02:07 +0300
In-Reply-To: <YHCsrVNcZmeTPJzW@lunn.ch>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
         <YHCsrVNcZmeTPJzW@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR06CA0132.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::37) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.141] (89.45.21.213) by AM0PR06CA0132.eurprd06.prod.outlook.com (2603:10a6:208:ab::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 10:02:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dffd3ed-f1b1-4b52-7f9e-08d8fd9a0b06
X-MS-TrafficTypeDiagnostic: VI1PR04MB7198:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7198DFD71C48953EAABAF3BB9F709@VI1PR04MB7198.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4sqGU6RaZO2+mHvApAVUhRhwYPZQndIXLapChNj3KmPQyDZNUJrtJxicvT5IrDKX10569/cDWNxfzn/wod8dzwKPu9jr+0cUztsQVgu5gKY9NJo4kuscz4HQZWzJlBUe4+6CFqft2Bl/97HRiX2gr7C0/Ytm/7sQHxGbwxoJ1prqHlYcJo/7kB1vQXK9lksWXHVsKO8oIAU7/TMcOe7YB/8CtwcSzwlrXhId3q4ZQWXu6jGwU8Q8TPhqRLoP56xnZYVSKBvdOtZEj5mYJ/jEnibDmGAjCT3GntRhpcPXJED5XB8rj9yF2urH4Y9kLfZI7VwD2Y0ouJaxnFZYeuNVFDbPyJW5jQGeNU/ydByVtLuEK7rx/klbiZXmnbKw6zL6toh5KE6+rm2wcxUHQttUay1cTvizj/650fsVssCvzn0OnfahDHCqvvb/tNptR7mfaY4B211iESWY5leZAr3o84vIP4+cQaLT0Gk/77rjPO2Ex8mhyWtKEylLtBLarEnZwfzH3FIa2Cu1ozE+CY6xnyaG0ruUgH//49TcqIPT0AcOFV16oTOP2Z+fDPclS7QXQr69z9xhxjIS7y4THix2u3naoIyiPBvplictQvopOvtGVotVr4jmHFJo31JYjJFDxz1h89k+eM9izA7ROfE3hVAaoSNJlkb28hTwUVkXnPNKGGjWpJYHTMi2UO8oA3wZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(6666004)(956004)(6916009)(38100700002)(52116002)(4326008)(2616005)(86362001)(4744005)(16576012)(5660300002)(186003)(66946007)(8936002)(478600001)(66476007)(6486002)(66556008)(8676002)(38350700002)(16526019)(26005)(2906002)(316002)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V0pKWWI2NklPK3R4Ym1VL1hnTFVtaDZxaXZQTHdDZFduRDkwK1RiSXZVKzVr?=
 =?utf-8?B?RDhHcXF0YkFmVmF2MEtGNUNuNFloQVhwbXJqY0RjZkUrYUxsUXRkY05CZjRL?=
 =?utf-8?B?cE1qRGoweXlGelFua3RVZVN1TVhsZmRZRG81akREWEREeVNPRm01NWY3SGJv?=
 =?utf-8?B?ekZrU3A3aEtyU0MvSEZ6WEJXWFgrWTR2cEdXZEdIZ2cwdGw2a0R6ZGNuaE5L?=
 =?utf-8?B?MGtnV2ZXLzlrMjkzQ1piRkJsQlBRU2JESFBaT2tLSDluWnlVN1FyV20yL1E0?=
 =?utf-8?B?THZ1dkxudlJRTHNvUkRCMXUvMENaZ1pnYjRENVlrWlN5ZXdNcyswQkdrdURv?=
 =?utf-8?B?UzFrYWYvSHIxVkdPZzhkVkVsbnBFZENnUGE4OGlyVUorRmVzZDZxUXBGUnRL?=
 =?utf-8?B?QmpkS1N6RkNkV2RqbzU4Q2pQWmxjWjMwa3lkcG8zSUx5OU9USFc0cnBoM3Nj?=
 =?utf-8?B?L2cxZ3oxQ291cTVsUmRNeGhMQTZEaWFCRTVVempEYlhMb3RWVE9PZ3Y4Mzk0?=
 =?utf-8?B?dll3Y3U3Q3crNXcvMGl5SjZ5blpqZUZDMVEzYTZsSFA4VDZBT3JQd1QzRk5l?=
 =?utf-8?B?ZjFQU0xvNFVHaWwrS3lTZjBlUjRXbGlpaUQ5aENNS2lpdlEyMllYM1hQdFFB?=
 =?utf-8?B?cVdVTmlUbklNK1RpUkVCMU0xTWVyODllWHBpSC9KWlRxOUtuZ2RnWGNMSWhX?=
 =?utf-8?B?RzVucDY5YXNuLy9kR2xpU0VCM1JUQnZwTWJocmpPSE9qaFkrOFVTS0ZhQXJP?=
 =?utf-8?B?UVkra09UbE9XUE9sY1pkTzViM2RxSWVnYi9JdUZqSi9BV1R3NFhKM1cycGVP?=
 =?utf-8?B?UC9UL25PR3ZUVDBVYzJjT21HQmt5MklQVVJad1pXQVB5eXE1cnYxTWZWL01i?=
 =?utf-8?B?UEFzSmd6bFQyMHZqSmdQVHZXMTRJYmJ4M2c0WEZZeUxsdXNoU3hqaEZNMXVx?=
 =?utf-8?B?MmFVaENZeFNBdVFSckd1cVFjYUN6WGJRU1I1eWxwV0doRnJkaW9KY2txZWtQ?=
 =?utf-8?B?cy9TUUlOZTBsTTdZT3Q1a080bUJNZHp6VENzaWtYdSs4OXVJbXpVSHEreEZJ?=
 =?utf-8?B?OGo5RmZOTjladWY1czNrbDFRZndUTlZtWkxjdXY2VitNVlZndm1GQ0Y1dHcz?=
 =?utf-8?B?YW52R2NKdkJVUlJXcTRxbStZbkpwSHdiWjRsaUtIZnBNdGJEZUROekNBREQw?=
 =?utf-8?B?TjV6MnBxcjZGd0FPMEdodUpKWDJSc0htVGVoN0FHNlBlQkVUWWUyd0IyenBX?=
 =?utf-8?B?dm5seFptdVFnUjRWaG9BSzNyK084WU9MRjBEclBtSXMxZUthMGJyemtZR2tN?=
 =?utf-8?B?LzUxOG95MWE0RDZEenlENVpRUFVEcmNXVElyUFFlaStid0g1bmRpeGVNOWZH?=
 =?utf-8?B?a3dHK2FtZU5lQUl0M3Ntei9wSjVlaFpuSDNkc0src0E0UW5BQVJXR1ZrNENv?=
 =?utf-8?B?UnZUUFhmUG5oU3F4NmZUbXNpVGU1ZkpDR2tvdzB1TjcxckV6QSs5OUZlSVk1?=
 =?utf-8?B?Wk4wVlZpTGJMd2FLSXpCbGF6TjM3VXoyemcxRUJ0Y1k2c3pRcjBDbWhKNXNn?=
 =?utf-8?B?UFN0Q3p3UGlqS0d6QVhVdjRuTHpHQ2NZM2hDNksrZklqVGdFa2g5QTkxb2Yw?=
 =?utf-8?B?TURENTA0WHdNTi9seG1kMGlNd2JuQjg1ZnRFQS9UbmJnSTBrN21VamVhOU5R?=
 =?utf-8?B?SnBEU0hOSitMdTM4dThQNFJ1amJuL3hSTGp3T0J0LytySkp0NzNRdk55Mkxy?=
 =?utf-8?Q?CPS+QOndRPwnZ7Gmmeagx4KBoGhXYONoTGBylXo?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dffd3ed-f1b1-4b52-7f9e-08d8fd9a0b06
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 10:02:12.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SGlm8OibnU+mbGHC0NB/Ufm53NO18go+tR27ZNJWC6QvgYBg3+8IT0Y6MP7kq2QBdH/QPsZbFUdukEdGE056nVcDvk4Tu4uZqXWYAFRSyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7198
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-09 at 21:36 +0200, Andrew Lunn wrote:
> On Fri, Apr 09, 2021 at 09:41:06PM +0300, Radu Pirea (NXP OSS) wrote:
> > Add driver for tja1103 driver and for future NXP C45 PHYs.
> 
> So apart from c45 vs c22, how does this differ to nxp-tja11xx.c?
> Do we really want two different drivers for the same hardware? 
> Can we combine them somehow?
It looks like the PHYs are the same hardware, but that's not entirely
true. Just the naming is the same. TJA1103 is using a different IP and
is having timestamping support(I will add it later).
TJA is also not an Ethernet PHY series, but a general prefix for media
interfaces including also CAN, LIN, etc.
> 
> > +config NXP_C45_PHY
> > +       tristate "NXP C45 PHYs"
> 
> This is also very vague. So in the future it will support PHYs other
> than the TJA series?
Yes, in the future this driver will support other PHYs too.
> 
>      Andrew


