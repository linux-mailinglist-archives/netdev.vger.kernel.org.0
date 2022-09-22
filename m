Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F8F5E6EA7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiIVVk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiIVVkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:40:53 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70071.outbound.protection.outlook.com [40.107.7.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A89110EDB
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:40:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lARcrNEGa4krCSWlRoV+kCfidoEpBMigm93z94A8Ohn/VjFEKVMMvFEiLdXQuAoyR5ay6X9EiBsx7M+vTVM9Bz5geCtM35+Bz2O3A/vTOS6AdCZYMDxfRr6kCMrXCZCg5irarwK9UyVr4XRiMnxEyj2OqP7Iy5PSOfMtm0at7QbngcbSTyNLtAiYyHL3W+OD3TErQQY6+sEqXHd7m2GGz/e+9xsZSZgQF49Evv8nn/bjG7Z+Mvh1U1mJ75wPiqkSoUdAF4tNAVqrUEz2TMCJn2nqi7GIXNaHyyXLNoxXc7Hsw+il4dsPLxQaxP/1Z8kbA1oFDiFxXH97WFiR036pfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/RY5fhCa5qnKj7wgP+mUV/iypiWq+2P9nFpuESjhfg=;
 b=iBjc6Pw2++vgKRPfVxE2OhGCY0P0FIXy8YtA212Pm5yhikm+RR+aaLuY4oJtrjyvXnAnoaNt3Qpp7SJ/X+szY7izkN+mJjuBM7wctsKkeLnPqZABM6vqX2iPArxpQGryBhdM7RB5SSQn5QsLdmwfl37EIW0l21KDw5jr/p0r0u9lD2FXk2t7kcIDjqTjWpCtDsl5U/5pYiI4s2Lh365s4f8MvKgbIPPzbdJ61IJhe4LTilGoN6XVxMb19UttNr86xnV77r1SUSCW/rvAWtM6xEqAq3GcdUZagSerpLrl5zRlm4YsGj0hrb1YULzYsoxWbAicU4D9OxUi9oaBVeUwYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/RY5fhCa5qnKj7wgP+mUV/iypiWq+2P9nFpuESjhfg=;
 b=bKrUN3vfni/ESeRLEhlltp7aGvvT4Sv+y2OUnBqwdh3y2B9wPGGgAWb31eHN7/28xFiiM0EMT8o3LCIKXJoNHlEl2x5blspQNAgNOm3inaw3gysBlPiTtyMU9O7QetdYO88gDNv2gQGREt6C4KaPtlFtPrkNBwiLNWR1w+XmcW0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9573.eurprd04.prod.outlook.com (2603:10a6:20b:4fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Thu, 22 Sep
 2022 21:40:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 21:40:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEHDgIABDlWAgAARNICAADKKAIAABd2AgAAI7wCAABAEgIAADnaAgAAAo4CAAACwgIAAAtmA
Date:   Thu, 22 Sep 2022 21:40:49 +0000
Message-ID: <20220922214049.rjjghrne6at7yurt@skbuf>
References: <20220921153349.0519c35d@hermes.local>
 <20220922144123.5z3wib5apai462q7@skbuf> <YyyCgQMTaXf9PXf9@lunn.ch>
 <20220922184350.4whk4hpbtm4vikb4@skbuf>
 <20220922120449.4c9bb268@hermes.local>
 <20220922193648.5pt4w7vt4ucw3ubb@skbuf> <YyzGvyWHq+aV+RBP@lunn.ch>
 <862fa246-287f-519e-f537-fff85642fb15@gmail.com>
 <20220922212809.jameu6d4jtputjft@skbuf>
 <fa76bef5-50c5-d9d7-c2ed-e743dcbdcf2c@gmail.com>
In-Reply-To: <fa76bef5-50c5-d9d7-c2ed-e743dcbdcf2c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9573:EE_
x-ms-office365-filtering-correlation-id: 6787f5af-8966-4005-f63e-08da9ce31dd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CsDRXr0rjsaLJZz3RamaeKpo9iaFD23/l2nvVfOX9R3Jl91AJwCn+/fY70cs3MeDEQrIoD09TDDM8BNRX8lm1wsoix04g5MQYjJNPc7DGh7s8aO6oR5d9Xef/AX55MzTQKd/YdyknceJlM/YztyAaWqS0NKfVgkeCQOcNxCip7hJZDfOg/zzcYwm1FEwsQfotrEmO7yVJ/hGzOn1UnviLDlV+mynTk+8KpDc4rb3OSh3XKDqdleEo4JhCQZ5BVBxAUa9MMsrb7/GK6IbhtR7nn6cPWiECmY36x+PFb0eCMzfP/nF8nJEWiqg0wKcIKtumK8RPdJFi1FnRAmNKgWPr27/0kNZjwar/VeZhS8ajTsYPA1PsN9AOYppjeWU8bKemyQhoGfMx7iNbJeKADSDDNB6x5X3fcUAGvGjkX0u7lAdelXEFPPc3hXmd/SarzVTa5i1cv6WQqwdRV3j2boFhzdThC/lfuE9d6JkM9gnzlGyvlSS92rG0kdrQEo/eUE3MYwecAzgSu4rZEGuKd5KFp7OJhOwN8J0tP8rF9L3ig3Imo2i2MR1wcHeqjm0VR7w5aP7oWSrS+BXqcqsNN2qy9TljFFfFVWmWtsfJUoiCtew5St/iP4UYDoNLqYuPYt+KRi4qHpD7TTOSdBUb+vGQJjCNrFkDDVn5X1iL3/o3h2SKljDmCu2TqteP/eWfORpenSGyUHhAVcqrcR6jLaQl1IHYQ8T9Esl2Wm2PIz4Ry+Qe2vLJGVN6XxQ3VaMJ45Thn0bzzek48K5gJCdAAI+TA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199015)(186003)(8676002)(91956017)(6512007)(33716001)(76116006)(9686003)(4326008)(66476007)(66556008)(66446008)(66946007)(26005)(64756008)(8936002)(71200400001)(6916009)(6506007)(41300700001)(38070700005)(2906002)(53546011)(6486002)(1076003)(478600001)(316002)(122000001)(5660300002)(38100700002)(44832011)(54906003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?47fuaVAQcVnb4wZw6pG/fs3AaKl4p96N3GzvLsg8+MmNGNs5ka5i8zW2LCTg?=
 =?us-ascii?Q?HeQ1zwmzFGAFUbse/Dy3bHdWULxIgrdpycdtYEFlPJku6CojRLyEVvd0G7/o?=
 =?us-ascii?Q?F7hTO98hgjUOgsoDjExgz4nZIuRG6s+rCpD4MWYm+SWiCf+Hht1wSlr+bKbp?=
 =?us-ascii?Q?nz8VrnlVmpv9x5guopbimhJFCeaF6+XQ/TLS+zRdkXzAEu3GscUnJPUB+/Vl?=
 =?us-ascii?Q?wXJA+Tbfa9jUj6hsR6BYXgvhdSpyuuk1qZvaQXSp4PBqW2PQ6DvCV3vtrPZX?=
 =?us-ascii?Q?dPHvuZt9FMzBB2qA6ItaMX6zK/TGOYVzlZ24YBCxDU9pipwG1/zlDvHnZ02O?=
 =?us-ascii?Q?JZ/hJZ2tO4FUHW1BFHfCA+BYUPhKnABzE2bfoRZEOGKhVgw0lBffiWXWTQd/?=
 =?us-ascii?Q?ATQA3SxMy7N4fIw6Mk9YjoZwXns18TbuouL20JUBImA8ESUJ9npA7c2j3RuI?=
 =?us-ascii?Q?Eq9pOEs3fmWqQWGiSYVHsGeqMxNWQ1bchEb8SBRQRZpZ3hJtFteqRiaxndG3?=
 =?us-ascii?Q?E58yTF68d26PuXGtDiI2Evj7phag6ymvOtakF90Qf8ViZry7JEXPM4ttUd+7?=
 =?us-ascii?Q?c6Gq3n36ngEUjUMRzJzd4Sc9Rhqp/pMyULxdANR5j/rsGV7QlOOrUTydWSfs?=
 =?us-ascii?Q?0Q5QKx7du6boknPsu3PdzaVowCDKzh5qkSceImDhbS9H/6iuZWJg7Fa24Aid?=
 =?us-ascii?Q?M+scP8MKoLSSaGNKGVQfwpEccUgtxI3lv1oppSjBrcQ0xfnH46qtTwOIY9+4?=
 =?us-ascii?Q?el2S5xxnaLQ2B/p9Ocax79d4rnaLZDh1aux1eMjDtzZDxOpJyHt4QYtwJy/J?=
 =?us-ascii?Q?Npo+PZxFOIIiLjDLvDrzqgxNKMG2Ag9IukBg6M0DSbkKbCXxWqfleEseXG3B?=
 =?us-ascii?Q?23wsm8B16Tsvn1S0O24/45R4F5CpHhm/38tsr2LsKT96CFheN8bGlzNz9jzY?=
 =?us-ascii?Q?NGh4329dKETm37J2Y68SjRUj0HGhvte9pfc2hyjIuBCeCKpQRcN/PkLElxj6?=
 =?us-ascii?Q?+A/FnTngwoTavyEUT+k4T5jURObDc+CRV21GbgD8ivUTHbd6Dhe3FzltCtci?=
 =?us-ascii?Q?CdWdwNHPvxBQKMbwpmJQUuuulmAzfs2ed9H+g+6sk952o6RcIoJEu2evxBwn?=
 =?us-ascii?Q?/pm/V7LAOiYrIcGQxlHy78XYTfE9tKYfb8/+T82VWDx5E+4h0J3m0u/Tzzzn?=
 =?us-ascii?Q?fKGzWbkZ15o4258Q3FZuCXFqYs04rh5yCDkuwyeINgI2woPhkysv6HtFQdj0?=
 =?us-ascii?Q?8lsONeKKDX24cTeL8qzw+DzRQW3rs76ovVmJ+VamHWwQFNJKnC2QAqTlvC3e?=
 =?us-ascii?Q?IByXRRdV4iOPcYAlgKKdoS6lmt1Ue++c0HFxxdhdyRb6IgiyXTv1QBePntmr?=
 =?us-ascii?Q?/C/uy6iDQTcv2lwnz5uQYXphT2aFpeNMYnf3fd7UjN7JcIaKRGbnHEC5c1ym?=
 =?us-ascii?Q?ZIiuwyJyW/1O+9/N8tKKwmCjQto5VifM9jSPaHqPQut7Ouc20cxek5T094DC?=
 =?us-ascii?Q?K8UzyGXky0vhzlWoGrYGQQrJQcz3uhSqKZw1UwCI0eLPC5vm3lh49y6sDWm1?=
 =?us-ascii?Q?NeswO15CwXTjbjN7HKvWE/YhbzVdMkd+nEikuO/iNfYb5LHNBymCiFdVD5Hs?=
 =?us-ascii?Q?lQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2B6BB0537F23E43944BE5B54652A64C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6787f5af-8966-4005-f63e-08da9ce31dd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 21:40:49.7857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7G4OJfIkpH3z7tRMw4+d4NxoA/S2nvM/1YcA9jbsiD2mJklwEGHrhFNtwaVPPNX5mVYXeSEKiXA0lmz1V8SIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9573
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 02:30:37PM -0700, Florian Fainelli wrote:
> On 9/22/22 14:28, Vladimir Oltean wrote:
> > On Thu, Sep 22, 2022 at 02:25:53PM -0700, Florian Fainelli wrote:
> > > On 9/22/22 13:34, Andrew Lunn wrote:
> > > > > Ok, if there aren't any objections, I will propose a v3 in 30 min=
utes or
> > > > > so, with 'conduit' being the primary iproute2 keyword and 'master=
'
> > > > > defined in the man page as a synonym for it, and the ip-link prog=
ram
> > > > > printing just 'conduit' in the help text but parsing both, and pr=
inting
> > > > > just 'conduit' in the json output.
> > > >=20
> > > > Sounds good to me.
> > >=20
> > > Works for me as well! Thanks Vladimir.
> > > --=20
> > > Florian
> >=20
> > Hmm, did you see the parallel sub-thread with Jakub's proposed 'via'?
> > I was kind of reworking to use that, and testing it right now. What do
> > you prefer between the 2?
>=20
> Emails crossed, I just responded to the parallel thread and do prefer
> "conduit".

Ok, voting is at 2-2, so conduit wins.=
