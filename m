Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D41699C65
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBPSga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBPSg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:36:29 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2098.outbound.protection.outlook.com [40.107.6.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E917A4C3F6;
        Thu, 16 Feb 2023 10:36:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtHgB0iLR8c1Vj3Sgc7e3DS6GzjxKTA57+i2Mtio6XeXSHl1o4g0ehDmaD1ecbEGSSa5Cx05cFPfNR+Mygux5WNrH+QHn8Nd20UkZ9hiXXV4cSk8osmclzzK/NCBI9/sEqXsP7VBD7W1fLSZB0JImSM4KlQVHodHQGVLJsXnsjHpWGVT9rf+OT2eaap8cUA87xBVfalN4gMbFCzwK7PIq3O1aHroNq8UXx5a/5Tp0t4Nq/hOhvkx+TBk/CJ88fiysZ9pNzad7z8SaxQECMGjZSORlYgz8tFwvNo0oT7LGWB3XRISBH1aapq02XPeMNlA5OJ+bl+wLUcScv88RxoM4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApvXXlacK68D92N/g/lry1LUN9AISzXIhQGJT1Vydgs=;
 b=kBAWI49ZeM5GEOzvS57qfEABsFNm3b9g6PvGG5CFLNOlBy8UzDZR6kOg+VqTiN/pchnWVbieQBoNJEYkHAahUErBtdqrxiZKGMOgZD6g1aWrkAfaWaaU2xnYk8fcpi2/BIeXwdw0o9kpNwb7bbpVr8u0aq99LhqfzohntY3WMAxN3E+BiAVcM/E6FaGi5UQd+P4pkT/KJtL3uTXk5FqhIt7bZevtBaR1hx9fMKRhmLxLegvD7AFU5m4IKri2/G6dz3dkG/F6UX2MjPG5m4mJFL6osYabE9pFQ3u1bhD5GoaC5O/rh6RxknGjQZTr8bqnMZ/ojkMUgVxgCB66eHYb8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApvXXlacK68D92N/g/lry1LUN9AISzXIhQGJT1Vydgs=;
 b=V5Frj679PV8jf3CY/aL/EpOGpDH+tLAz2tu5irAU/JaIUMa7WCp9dMW97ezeE4M5iHldD4lF1vjG18kWAJNgs7V2qJfUHW8bdpKagHBJMP5iCbWnx6o2X7kHjFKxnJm3DhZ2xEu2sMUZGb2sLiN5+DTemG7pYFG18c2WQYtW1KE=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 AS8PR03MB9745.eurprd03.prod.outlook.com (2603:10a6:20b:61e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 16 Feb
 2023 18:36:22 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::e7f7:70e0:d33:df60]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::e7f7:70e0:d33:df60%4]) with mapi id 15.20.6086.024; Thu, 16 Feb 2023
 18:36:22 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH v2 0/3] can: esd_usb: Some more preparation for supporting
 esd CAN-USB/3
Thread-Topic: [PATCH v2 0/3] can: esd_usb: Some more preparation for
 supporting esd CAN-USB/3
Thread-Index: AQHZQI3AHq+50zbsy02NehykOhMEJK7PtIyAgAI1eAA=
Date:   Thu, 16 Feb 2023 18:36:21 +0000
Message-ID: <12296b28afc0848f1989d3eaab06946471de5077.camel@esd.eu>
References: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
         <20230215085227.sqpqtzprsmpzdthu@pengutronix.de>
In-Reply-To: <20230215085227.sqpqtzprsmpzdthu@pengutronix.de>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|AS8PR03MB9745:EE_
x-ms-office365-filtering-correlation-id: 7df335b6-d28d-404c-bb78-08db104cb3b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y9E05Jq4ieEr2XVzt7CxhXFcRA5JYOpIH9ftIiBcIK0x1F/n/rUFcDfhBHs5r+9GQgP4Wxi4GNhLaWSjNmGNfIMvrkjXyrQd1vJafeE4I7WKRZram4DlozuiSaDnfhBp4encIH+A9bu7bcLUHFBx1r1p232imms9tkXSizgpbUeM/K2pRanmZ/p7hWdTJGDX/4SlbwUx1kruBbzDXAPzKivtDrZWBebQ+QwMwURKLNI6MlAu8+GUGPgXm1O/fr+ZS2RSg7iIMtJik7XxtZsrHma+7Ve2CFq/CAdgFWZ6fHrgg6CiSipCaArktN9c3jobRK+VTFgXSg9uL/hY4twnlPnT80w7guN+5Sx0x2fTUA6W0ZCy05esT8jZw30YKSTKkpUPLqDovoM738qBt1SvLCAlxk2Pisjmnk0UCp2zoveJ2ViCqXU8n8yO7t+DgoNIYajwRUw4HLpeqFH8orZ+nhQC9WLvsmuzq9/5JNSuvAjv3v/TlT0Cg/cTCD50NxvHujyVPMJbUF8kQ7mFW0JaOOmQB6MsQETvuR6Tl3BF6rIcOLXuEknTA9QR5q5ktFx4C5aXWIThRv3/IDXZu5tBFSerAlY2ZA485rXUGPPHpntmVEwGz1MFBSVcG6zqdYqBYh/y077nLVC1Zv9TN/T1WD7mn2i3v9BqADh1leLl7pecMTMf4VaCpAgeEfjwZvHIynEszPB5df6qUQfIoIkLtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(366004)(396003)(39840400004)(451199018)(6486002)(71200400001)(478600001)(122000001)(38070700005)(38100700002)(86362001)(36756003)(2616005)(26005)(53546011)(6512007)(186003)(6506007)(66556008)(316002)(66946007)(64756008)(4744005)(5660300002)(6916009)(66476007)(66446008)(8676002)(41300700001)(54906003)(8936002)(76116006)(91956017)(2906002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?wjce4WjdvkhLl3jXPH+7ETRyV/dzhTen3UG61yf7PA10cudw/OkTyje9x?=
 =?iso-8859-15?Q?oGPK34jIifwvMyHQMJ8/5rmiKpWne7KUp12qymV+rtY7rGdwxCrnkmtUf?=
 =?iso-8859-15?Q?7J7RZDFD9QD+eUSfK/5mVDxJZ0SkTB8Kup3lCTEKh9vL4bQoknOspjHJP?=
 =?iso-8859-15?Q?kUNWIOOWd2bJC3ibnM2TcIZTj7da2PwkjfuytpSzHnLfTs65b38AbzOuJ?=
 =?iso-8859-15?Q?FnfDvJHlwvubinXSmJNXt8J9MfNUFiO25nc7JaQJA4h743X7jT6LzF+gF?=
 =?iso-8859-15?Q?9JQNCliGXwsau1a79XVDNRltyTDp7Vl4VG1x6Ai24N/WiMg9JSz4yawWQ?=
 =?iso-8859-15?Q?Y5I/7hw97pbpYKmVLbBJnR2Uwsvu1CLj/ka7y4fWuHsgppWoaiUYCO7wf?=
 =?iso-8859-15?Q?/dLklH4dOpS83RFCl1zTZt2ITq3Ozz0w0/R1Du0e2sQiBoz1Yp1tyEN0k?=
 =?iso-8859-15?Q?FZ77rM2kbTJUL5JiySR9RgsLX6Pf+mYdyZ22G3MdsdjMeMaBohoRKEUAE?=
 =?iso-8859-15?Q?8/Bcoalpvn56Knpi20k58dzULINiTNaigwrL0OhuIF14WHmdNwG1uy/QU?=
 =?iso-8859-15?Q?ydsNzb2KOgx8p4HmPC/T7nXNddxWnoef3c8tVibbQkNm9+lGCbDWzh4d4?=
 =?iso-8859-15?Q?ZQB2oxwOvNcxqjrW6VTYRJuPXrCtC/tOQQgT6yA5uKn22PCELZyeWRZgH?=
 =?iso-8859-15?Q?9QLg4KcsqSo8PdZ/T1CqZmpu8oYMNcolGjMUxkFt9TABQ+O9x4seTyLPY?=
 =?iso-8859-15?Q?TRIsYcBArbbxi7qSHJ6q0LaOMFnn5zUc/uA+Pb892emMMld2PP2WwK4AL?=
 =?iso-8859-15?Q?4kshPie3eAlF5kb//EENl/Mrkb99dmfdpIdoAvaQ9OOCgKNRh1IS82+FB?=
 =?iso-8859-15?Q?nqglfqMizRcCCPObb5Itr6o5+jT+lq5BQi0d2nmIUxd/P32+ALPAA9s+2?=
 =?iso-8859-15?Q?qvYW2GL+s8f3dMIuibf7fFX7MJzoW8OWA/DzUGNVj4htzyPoO/MoZp2/w?=
 =?iso-8859-15?Q?R3+ASOU+ji7A+pYXjytYLvLnO0ALpiSOgc7l8AT8KykFsPabt669z0VRt?=
 =?iso-8859-15?Q?mAC1/Mi2yqClZe/UmQ7uYmeY2oaP5bRDOB6YndVjjvTvgvOo1bRze78Wt?=
 =?iso-8859-15?Q?NYOw/rp/2eiLZJvne1pjHSJS/BRPPvgesBTDKoVccFuSm7i1hP1S2vppa?=
 =?iso-8859-15?Q?cQivwQ5wzJQgCemLTnVI8xcM1Vf2Mb1J4oti0hKJIeJh0bUPWS7748wuu?=
 =?iso-8859-15?Q?LCPG5HrUM99q3XCYql36wG2Yjds5RLrGrrrWYz0ed5dPmnjz3RucDo5aU?=
 =?iso-8859-15?Q?WiN/liYsUcqaUIXCCxdgLSc/IIik3p3vcaIPL67wBIv/PPYkoy3p7KBqX?=
 =?iso-8859-15?Q?L0XmnYT93GOhlhy87LnhbRIBrIk+BweDKVnDVi80pkA4mlLd5id0WuikE?=
 =?iso-8859-15?Q?je5cWnP1p+RNim4hWdvihU+nKHxPwp1/Ns8/hg1ydXtZYnCYmjeNKVAVP?=
 =?iso-8859-15?Q?6k6A/yR3rsmiCQN6TerUriFdowlOUIDVnlULAlzwTVJ4SMXMXjMCFVds5?=
 =?iso-8859-15?Q?S4eGFFdPpUK3TEMY4tG8NNDS4tvqWFWkVhZ3Ez8Tz/MqS+pWavdaCP1ha?=
 =?iso-8859-15?Q?urFjU6MbtJcbq9wY3dUtz9F9xdmFSWAM3UKWmQuBq+Tzrwo5BwNLLe3We?=
 =?iso-8859-15?Q?dEuDeNRVfvoyEufyyf5b6852qA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <330ED70570372247A73A86F8EDDF359D@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df335b6-d28d-404c-bb78-08db104cb3b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 18:36:22.0772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4WM3rZlvDG+CYg8q1rfaVuU1tWIqhQDdqSYHjoki/33SxHKloEUNd0tcFIyfu7P/JRALF4RkUK9ON4dBR/EqFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9745
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-02-15 at 09:52 +0100, Marc Kleine-Budde wrote:
> On 14.02.2023 17:02:20, Frank Jungclaus wrote:
> > Another small batch of patches to be seen as preparation for adding
> > support of the newly available esd CAN-USB/3 to esd_usb.c.
> >=20
> > Due to some unresolved questions adding support for
> > CAN_CTRLMODE_BERR_REPORTING has been postponed to one of the future
> > patches.
> >=20
> > *Resend of the whole series as v2 for easier handling.*
>=20
> As Vincent pointed out in review of a completely different patch series,
> bu this applies here, too:
>=20
> > For the titles, please use imperative (e.g. add) instead of past tense
> > (e.g. Added). This also applies to the description.
>=20
> Further, the subject ob patches 1 and 2 can be improved a bit, e.g.
> patch 1 could mention to move the SJA1000_ECC_SEG for a specific reason.
>=20
> regards,
> Marc
>=20
Hi Marc,=20
ok, I'll resend this series as v3 soon to address your comments.

Regards, Frank
