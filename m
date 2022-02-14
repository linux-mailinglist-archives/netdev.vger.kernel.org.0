Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE214B5B2F
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiBNUpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:45:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiBNUpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:45:02 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2046.outbound.protection.outlook.com [40.107.22.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3F5243A2D
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:43:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OW3MFPi7p5D6lpX0SVi0hMxuAYGqHASF3j24VnQdgi4JZP1SsTgIfjqk//2c1lrnpMOTrCTFXAmQ9cqlFoOT/qP8r4ZpyEC84SvuVyy0zMMQqDKPIcGcMKjeKP1myw1VYM/qwnfvHwI4lpCJotprQHS7wPV3fDMPKCIOK9uKeMcj2ftlpMbc35f1FV+G2AWcXDnMwG6IMaCGtthbNHCtehKgQ0/hTt/QD81hvJQkgfrtVRZDYs4MheNz99Y48T68qPUWluY8GZS5ufu5JQNxaZ1e/DuAErnGTlaCKMCpRCu2UrlsqXVp2MDioPuV//vl9v/2Ods3PUK+a98kVkU8mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuzTDioUaPrZfZDb5x2i8IKHHUCM1q8ScEPIlpLZwZ4=;
 b=lsJAJ1yxM5swlT2cgDW3qwqDci1ddjYIYxxt4V74Gmc6HXu+DuNXHyi0hTdrylM651J4nmBojPV9951ZN5CKOvlL4vb9eBea2a2Hy5FHNfRaBn+x9KLAXZtg0aT3g8lxvKJAuUiSC43UZn7WUXyOsZqoaDgPRFppoh09KTyP/G3OCAbF5QbC263Ix7hCXjQtAsn0tzTXaMSMSMti9GazOMcTg4hTJO6jLcmpnXEeYqUy6OkBbEN82tZaok6eUUD2wN1yKh5x/B+LjznywKZMNklnVzuCgyVAme3kwf3zMFJxE5SUiCWVY5Df7dfcjeWAMmYRUsbLzyDX81+uksF2bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuzTDioUaPrZfZDb5x2i8IKHHUCM1q8ScEPIlpLZwZ4=;
 b=fNIa/oPZ4G1u48xyaNHr9qrCGr0dgrilXhKTLeyZlY9cZWoaCbUfcKuukqI6xlsv7OhJxo5oKiYoWq9NARq4oOFGdMqHUmR3K/37doPqVguAJzNnyGW8JVdxppYUcBFgItiBPDfpXQdAHvFDpK177qiRxFkGgSlrBQqRapOcYCM=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DB7PR04MB4537.eurprd04.prod.outlook.com (2603:10a6:5:35::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Mon, 14 Feb
 2022 19:18:34 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%8]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 19:18:34 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Radu-Andrei Bulie <radu-andrei.bulie@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Y.B. Lu" <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 0/2] Provide direct access to 1588 one step
 register
Thread-Topic: [PATCH net-next 0/2] Provide direct access to 1588 one step
 register
Thread-Index: AQHYIbyG9F+owtaSS0eHu32q6Tvgp6yTa9gA
Date:   Mon, 14 Feb 2022 19:18:34 +0000
Message-ID: <20220214191834.3xmv44htevxpkztn@skbuf>
References: <20220214160348.25124-1-radu-andrei.bulie@nxp.com>
In-Reply-To: <20220214160348.25124-1-radu-andrei.bulie@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aac226f7-5054-4b07-1cb4-08d9efeecbc3
x-ms-traffictypediagnostic: DB7PR04MB4537:EE_
x-microsoft-antispam-prvs: <DB7PR04MB453738B91C1BF7111081DD2BE0339@DB7PR04MB4537.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nZzoIj+6M3eFRc2GMXyv9s1Ojm544SLTG722JulIqH3QN1pcXtiaFZoPB+QPonOGKbFik+FGbga2cQtv6NCm95xrCLHEr0C96IHOG5lSHu2RQOqO81T/tvKZudsdUJU1SIx2E1U3G5OpVfx+jH1vC87rdpd3PytTuHaFaugor229T+ybOB0Mjw7PTRptmLxVUYUyidywqWWiNc1I27B0Rn4OqoiForyeg/hWGDLi8EzB9VJR2HKP/07HATAonoh2HygSV7hDtOq7HSDNjPaYrHr7j80TThZ6WyBIKB/AxvmXsczGws/SQKL5/j5j76hxj261f4P8WrY3GuVnUCjlJlufCUsU49oRYBN+E/VfBR4u+gW2a87RT+BIlSdndAYGXul7wa/x3qZsnPgx0uOwFOuSOiq9zJJ+WzU/FuWNpjAKeEQjB1WZQI7Tu1f5GFBYPDO3QQYgkldt9aIYgtJOpzcAx2k74ooNngxPpl4XbVb3rZvyeD4Y0ooV3CdUefwLFZW8HT3crqlEKBe1cVtTQNH3TEw3lJLpVai1eQnIGCrzYLuSMZuvEIMWWln5cC9wdSeZAAth2LvhAT+EfFleAtzbwtNa4RHkiGvdVvl+dCY+ACnogw0RzznKaE7nfKb++ThStxdGih+yTPIpV/Wd4eFX897lsugFjYcr1/2kmU29ndQ9ttpSsP6ZngXQXoHwNayw/XHuI7M8NKjno4azeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(64756008)(26005)(76116006)(33716001)(66556008)(66446008)(186003)(66946007)(1076003)(508600001)(66476007)(8676002)(6862004)(6486002)(4326008)(38100700002)(316002)(6636002)(6512007)(6506007)(54906003)(71200400001)(9686003)(122000001)(2906002)(5660300002)(86362001)(8936002)(44832011)(83380400001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9NzK/Ho5H8UZiYAMXTxbPVRqZtRbetzWWnMzcXGV0cdTUEz564fprFQOdHlT?=
 =?us-ascii?Q?qeAvCyrn71xpYtH+JmhP1oyzrTdzb42X7jwW5KmqGLGwaKTbcCONGYMOQQaN?=
 =?us-ascii?Q?v+UtnbLC3wWy1L7oIQyu9hvHG26Kpv41MHQRhdAt+LWPkVJBxIAZky5eYcj1?=
 =?us-ascii?Q?m2P4O5uKf+MIiyTZQFNgbNqFgEVHSvBpAU5iiWuns+rs5dQacOzgcxpnA4dc?=
 =?us-ascii?Q?sSnAbVlyBtHBpangOQlhnTiO1OMKTNGgLeRVMrbUmE/Tke+e3kTl/u2eav01?=
 =?us-ascii?Q?Rk+I5SkP0cAL9U53hWavPi17KbKks4BOPZNrTMUvUooa5wl6dIkS+5NDggvi?=
 =?us-ascii?Q?yP3x2tQ5ZLSowvWcSdWia6L/gEYxQI6Oci44HTLnumoNBJ8guN2lY8nS9PB+?=
 =?us-ascii?Q?GnUaI1Zev9ujnITQ4Y6zRAVrM9YWGElwAaPj52t6Zkfi1yTIWnh3BlUT9afG?=
 =?us-ascii?Q?IPd3Bt+8gtVHG3ReM42Ag3+pF5Lfa57yczdeyiZ7QxKrfqoRQjoIXu9QYWtg?=
 =?us-ascii?Q?Xv6Ra6pbtlEVylpSRAnpBTLAXtPdEARym3DfzCe/NZ46l/zG/4dE5q+UhgoF?=
 =?us-ascii?Q?YXAyIbhrcf7793AvRS09iHP9tTGjAG7gbVQ0cs4HaqVsW1eaKhltKFUG8UFx?=
 =?us-ascii?Q?LJBCghwB0R4ESfkG77Y1T1BjfPAbrr/cLNgg6pKYP0LNLRNkTWuypeE5/5Cw?=
 =?us-ascii?Q?ip+2qDBz/WIBMFS5sxt2eSnWOk0EF9QJp1maAOMQbq3fdaUDXwv3Jw5fJgmg?=
 =?us-ascii?Q?PVeTHjPGc1HsI688aln8SzG6Z1ZsAnzEakxShjs+3Ffk+QRaftDOgAjSn0TB?=
 =?us-ascii?Q?gJXvs8DKEkH7ECruiQx43VGn2WBFgoOu3P5qsgZA1ah03t6cYd/nNI64zC47?=
 =?us-ascii?Q?zdx/Nn+LeuvbyjmjMic2Z9eQrgBTqc29C4TD7aPjeaviVUak7QriAuT9aYXP?=
 =?us-ascii?Q?t+qlc6H66q7YPBTd2KABCVB9o5tHgqI4h/XUUIgU9sLE5QSvkPGyVzGb311H?=
 =?us-ascii?Q?20sDw4qv7oVeXCIRrHONz2LvyNR4Q7pf321cPDJuherbfZS4pSm31McZiWvY?=
 =?us-ascii?Q?NCmEv7DdfzlC0tTlWFAs3TqMAP3xZvs+AkKpF+Stlf8+BUEPvISOWie1y4Gt?=
 =?us-ascii?Q?gIljwbyHC1mwqHDc/kQ/pre2dWM0IOkDsXySp3fDb80gdQcFkeZuXzaV0nCl?=
 =?us-ascii?Q?XksOqymfy1sWouQdLiHDaxiMmBVZJeuWsXmvRqeg0ZGstTs998E2Ck58SOfq?=
 =?us-ascii?Q?O2NwsqMM+xsd0ptFXSido0lh2xQRjYQhDe7QDOFVWJn+hkE+ndXmBsGmC3pT?=
 =?us-ascii?Q?C3WTBa2KwI6381trJnV+E2sg3vbheB0W6Keslk7r83JCi2jnqPpXc+lGSQo3?=
 =?us-ascii?Q?S3zm4/itMSKpiCZBWVq+Ue/KvQ2Ucg2Oq6nVGOWqwcAavDeiAKDxdkbay9Hy?=
 =?us-ascii?Q?mOin36jnP4nCqNasLXrsMnRzlUrjONy0Tsz6CXblBMoZwZcgi5XJAoPlS909?=
 =?us-ascii?Q?AkNUyiQq4Gg3eK1lxmAHQF5HlYYP32lk4dkJ4S4YVp1yHQ6Z8uKgJyHIw0sz?=
 =?us-ascii?Q?rFSVSKgXWQgAYg7iNs3GhgUXc1a2FSKj1T3V3dbFr2biJaekh0b62A22haOr?=
 =?us-ascii?Q?s38RXU4M20c+jvH9u6bhODc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D236F823634414D9EFA003B325DC297@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aac226f7-5054-4b07-1cb4-08d9efeecbc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 19:18:34.8515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYr8rMfDvAgcDUPwd/YYUw+c+WZORufMA/6Dmk38SkHeCg+SenfOdWxN5wxTsim/2tY050bJSwZ35UxMLIMoPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4537
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 06:03:46PM +0200, Radu Bulie wrote:
> DPAA2 MAC supports 1588 one step timestamping.
> If this option is enabled then for each transmitted PTP event packet,
> the 1588 SINGLE_STEP register is accessed to modify the following fields:
>=20
> -offset of the correction field inside the PTP packet
> -UDP checksum update bit,  in case the PTP event packet has
>  UDP encapsulation
>=20
> These values can change any time, because there may be multiple
> PTP clients connected, that receive various 1588 frame types:
> - L2 only frame
> - UDP / Ipv4
> - UDP / Ipv6
> - other
>=20
> The current implementation uses dpni_set_single_step_cfg to update the
> SINLGE_STEP register.
> Using an MC command  on the Tx datapath for each transmitted 1588 message
> introduces high delays, leading to low throughput and consequently to a
> small number of supported PTP clients. Besides these, the nanosecond
> correction field from the PTP packet will contain the high delay from the
> driver which together with the originTimestamp will render timestamp
> values that are unacceptable in a GM clock implementation.
>=20
> This patch series replaces the dpni_set_single_step_cfg function call fro=
m
> the Tx datapath for 1588 messages (when one step timestamping is enabled)=
=20
> with a callback that either implements direct access to the SINGLE_STEP
> register, eliminating the overhead caused by the MC command that will nee=
d
> to be dispatched by the MC firmware through the MC command portal
> interface or falls back to the dpni_set_single_step_cfg in case the MC
> version does not have support for returning the single step register
> base address.
>=20
> In other words all the delay introduced by dpni_set_single_step_cfg
> function will be eliminated (if MC version has support for returning the
> base address of the single step register), improving the egress driver
> performance for PTP packets when single step timestamping is enabled.
>=20
> The first patch adds a new attribute that contains the base address of
> the SINGLE_STEP register. It will be used to directly update the register
> on the Tx datapath.
>=20
> The second patch updates the driver such that the SINGLE_STEP
> register is either accessed directly if MC version >=3D 10.32 or is
> accessed through dpni_set_single_step_cfg command when 1588 messages
> are transmitted.
>=20
> Radu Bulie (2):
>   dpaa2-eth: Update dpni_get_single_step_cfg command
>   dpaa2-eth: Provide direct access to 1588 one step register

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
