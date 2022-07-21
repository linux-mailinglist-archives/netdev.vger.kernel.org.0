Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BF757CB02
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiGUM64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiGUM6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:58:55 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9DE4B0F8;
        Thu, 21 Jul 2022 05:58:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KE99F7kCAKaeAZ7SCQZV8tgBX/UyPY3LAmsmdZsdjeCr84q30kwXymTYTj6XHGw9kRoDVc7Eqwja8ETJQRZmRzrNq8/2BNorFX1uoJK3CIDh5dABDey/3RhjtOp/YFLBj0Z8NXOlcmiwqLK7+lWuE8P3Jas5w0NiA+OFWzZwz7OpSuCZNt3B7OTOfraVc0AscOg+4qcnrQAl0xK+GrQ/+lLyD1a8qqVwY/1X/28NIGxmTjMYrv7knVnpt1nLFAEgyAoOAA+di7bt5xFA08tSXGroiX71hAZGm3s0NZR54YpqCAAP4g/RVgzEDe5ZtbON0I66gjvP/2RfNf8xnXY+6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLhXpWfd1x3KCSnEWL+GzFqBhuI9IDSbMD7ZW2Po2b0=;
 b=J5Rc3hiiLg/hTjQ3GsLyHpxtVck9V9EPuauz8fURUfmtHvbvZiYFjGCrB9kMDkAoyzu3S5OpwPr8WzgSusOFQYjbOgEe2FEdQkAbfA7hnfGlUzjCFHZxD7mEl+VOhsv9q0Y3Qncom+gZXHGLHAVJvgCt6oFLFaG2lmoCOH7SJ+eCCOVsxjQbWAX+n6hcNEQI3zMVLYqaHeteBTgZ1qxbmMwH8ntpObIkx7/nZcDpXEegnWF6yYeTkk3B6wpLszmlfZR25I1wFs6dAMjdh3ox8VDGZw4CyHQeQ9/CHth4a3koX3O0XeakZJGYSUXVlOmKfvrmhtTLs9ngIvUAe1N7Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLhXpWfd1x3KCSnEWL+GzFqBhuI9IDSbMD7ZW2Po2b0=;
 b=KY+xK+HqlSQ+OuswAqokB/3Huv7tQ8NDccqR7qptW4uXy28qlbP8ifHkJXEdXGrrDDMr2dp5JZVQV7JiAqwOVqwlmDoH0hP3bMQZf6qd06NsS/wrUyk+5IY6A6A8BYffeUlUE6KZoDZLymmm+gkdjHToK9ATRzTsDj6OyRSvlcI=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6671.eurprd04.prod.outlook.com (2603:10a6:803:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 12:58:48 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:58:48 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 24/47] net: fman: memac: Use params instead of
 priv for max_speed
Thread-Topic: [PATCH net-next v3 24/47] net: fman: memac: Use params instead
 of priv for max_speed
Thread-Index: AQHYmJcaAMyQhHLWQ0K8sdqiuHlhqa2I0fEw
Date:   Thu, 21 Jul 2022 12:58:48 +0000
Message-ID: <VI1PR04MB58077EED1B6AC4DE6E483706F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-25-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-25-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2e5aa55-05b6-4fdb-6682-08da6b18c103
x-ms-traffictypediagnostic: VE1PR04MB6671:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3+XiPPdgyHsORxPMKlECNPJGsrXUvOgUZxOAPsP/Q2AYZr2owX1KSawOhW2qxhsYrCVSiJICdst6BawYKMmg1c/4eseNZgAsezQ67sXjxavOkNjZdm2wJKg2g5FGhiNV3tvt4wqJIy1YEOPVUEKbbfeD4UEoHx8KyD4j/jIZfSmcpdF8DWRHSKzcXg/U3+wNTdZrwEvMtq1soLCX3xMFGZBOVfVcm2gXWhp3K6yXppHkYc0zJacF1iRCU1uEgXMHv+x8I3vZgSFmW6ls/iwNBmQPl9gtuNbbA51wnxVa2jWzRJnPyQvjJjYJxdRr5hvHON20pNzJGKmcMU8ccQYrDnFlmsM9YrSw94RWhovPF1lrela1GXDlfwH9STtekB0W3tjZ/9SXF9atvPvoHR2Oozh+nIAkyQf7yJrCogZSyEV6p7pHiwps8y9cyGmNOOuqBhuybtewfx8bhGCs2qsGe8y25DMunURgKcwdMcTy6P7Bp06bX5w2Q3MAzyT78J+W4MbApW/rb8R1MopgS+vZN4yZS7Kz1821U3Xmss1ML2GadQrD6h/DGRiflfad2OJuteMtFAi63HceZptAUitPB4c1/dTfUXJrLUOhUPgu1cYNZRvT0gxk45FDaDA7SA/NdOmGGaMR922quT7/c2FyavxLEBIovAWv+RPdt1eT4Cdr33pzkQlnfJfLRqoaCZaMY7IX8TI81PhDAOq6Yvy19W83hkJFHHKc92sF3JMjMi9hL7SLe1dHfc96AwEPoWpVNGcmZ0uSo1QKiPHA9kMTwkQEuIdUKOBo/X/WkWvXp9dMRd3Bsd1S5k7yUeSZqFTd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(38070700005)(86362001)(83380400001)(38100700002)(33656002)(66476007)(64756008)(8676002)(122000001)(66556008)(66946007)(316002)(4326008)(55016003)(66446008)(54906003)(76116006)(8936002)(52536014)(4744005)(6506007)(26005)(9686003)(7696005)(53546011)(5660300002)(2906002)(55236004)(110136005)(186003)(41300700001)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GxbT4aOAQDC/2oS0FyCYTkQabFK94XpVKjUqvKjF/q8E+E+r6dvcTQqXwF9S?=
 =?us-ascii?Q?JR50wpadJkoiAv2QKd5Haobc1gmkA6UYWA30oeFVdjcme9HOns49abE1RvMg?=
 =?us-ascii?Q?o5lX+P6ycOTN/hVrdle/Lx5lcEfrbNfTRbCBivVnJBBYpf+2zRDn8c2zvAVu?=
 =?us-ascii?Q?JAsgknFsg9X8oMm+OxFr+8RvtlZ9RhvByrxICPMONvmwHF6CA3lrlJyvXz33?=
 =?us-ascii?Q?Y1ceCArlBSIbTI/eO4m7C8tFy5TN66w9t1J2ICzIjN2jy4oYtNGTAhi0ATn+?=
 =?us-ascii?Q?y8GcQCFMFLpx3RZatmz//V/jeJaGoOQtEG9nL7Bbd+OFScbmRs4XXF8OgMgM?=
 =?us-ascii?Q?+2GQFo6HjTPtXxOSi6YiAeGvOvx6ce7oYOo56PmfcUZFgWvDC5KiWCts13ov?=
 =?us-ascii?Q?FFpi/AOrZi0V3jdBX/GawL5nKCLdopKu3H9XMBlTyDpdCp74trjdkGIvhkm0?=
 =?us-ascii?Q?T+7FN9momqIGxWk9ePOHuGr+6HvEjZJ74zVOgkoGf6CiYdTNJk9XcfXe0FHj?=
 =?us-ascii?Q?G/AY/xxEXfpGFV7SZt1o7CIEbToHn353HP3Mnr1TUrr19AcIVjy61hA/RF/N?=
 =?us-ascii?Q?Ru7qhIBV80SA4/FpYb4Mak6qoBarwtCih7ZfVP7CFcNH7MAQtlFPLKdM4UY+?=
 =?us-ascii?Q?GmmIMtMZ54EPmFoJBcZG1unMGXRJbeCgVRUN6mK0JKz7A46CGQu1TrmdniI9?=
 =?us-ascii?Q?28tHi7L25MRgb1ZxAhiYD/RXkUxxg9U0TaO0ybSGquF3r7wqJEQly5T1ikN9?=
 =?us-ascii?Q?kQIANzLvtuyQbcF+A0C4B4lWgLcvISRducQMuYHKIzhWDm59qQlNyx6LFrGs?=
 =?us-ascii?Q?SsQEqa/aX6AsvhJ5NyeaLVAqEdrI6FeayslS9s01IJkTT7KSPL7MWJfZoch3?=
 =?us-ascii?Q?iKMN44wOjWAo2Xk9AKpkqu55tmrTGfeX0FI9LgSe8h7AMqcU+tpsMlektX1y?=
 =?us-ascii?Q?7pipXMlqjboexAhF0fFDhuKy6lltwogXvhprylbEGTUXm4fuenjiMT6Xy040?=
 =?us-ascii?Q?GdzUOvnnclzK7zzRJkE/0XeXVY+/pV57d0EQbxUZVnmPXzOdH60H6ZDIqE5H?=
 =?us-ascii?Q?EE2JF43Ezn87i5NY8eHt3+3QLIaVHKxr3i59XDTN8vpDJIps+/ciN2QmEujA?=
 =?us-ascii?Q?/6i12eJnIH/7Ic1FcsE9MnnNadjbUIeza32LHLhMBogeytLQcBLIxewHW2dn?=
 =?us-ascii?Q?0VxZtWTOtPjYzIeeIRhFRFPy2knlp99HdcsY6JSnH9B7GAveaQgPjPaWS8jo?=
 =?us-ascii?Q?6DTis9aptAK34wZkuHaRd4ZJClMyRPmiJbhrKzV8ybq17VebWoNRT9Mbnald?=
 =?us-ascii?Q?e2pwUjyI4h4rXQyvI08ba4SC+xorK5ZFY8fTQu072kGcpxkXomdoS/EN2QuM?=
 =?us-ascii?Q?3qFJWw+GT9TBdOYN2sc89sznhVimFxLR2soS6fuybs1URH/r37flMNUeZxn6?=
 =?us-ascii?Q?VUpslnMtrLmLPIsdQ+k8VKr4d9jCobtoBGuZwobv3e2qHqePKul6qvDBxgGu?=
 =?us-ascii?Q?By6oxRmXR+pzKfpvz10z1Uur3KjNeJMRmb+jVA+hL0bzZGbG3/kk/DCcJaZq?=
 =?us-ascii?Q?MrwYyaWMgRcWW+UOxIal2sRixO/MHsFGSJxXPzS7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e5aa55-05b6-4fdb-6682-08da6b18c103
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:58:48.7334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tdmrtz7VknmUg0iCOE9aGVnwIr8/y6/uaGtxewNbUZ2itQlygF96sIu+cXkKVE1gIfCmdo6WeWi5b5DZ9IfFfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6671
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 24/47] net: fman: memac: Use params instead
> of priv for max_speed
>=20
> This option is present in params, so use it instead of the fman private
> version.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

