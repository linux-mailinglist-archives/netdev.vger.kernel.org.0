Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6DA3B5B1C
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 11:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhF1JWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 05:22:33 -0400
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:57953
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230256AbhF1JWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 05:22:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YI35BVZ7I2F+nVzr8cv5tBTA0X1bz1mT6irdbJNN0rwmcMklSEY/nYaTXBpCb36l0wJ0As5shxJzfjCePDTyz7Y2U4+sRndzlHddQ+KxZaoOSmY+moVRWZbVcU7pV9mj6BTr36fsD0TrBzGloYOIhO2xX5MFMQVMLajulaM24sQZRkJj33+ZXmAoAjf4oNaXhX7r/KZ6IKAF015okgufzn7PhjM69jMO1dJ6IR4YXUSH9NUC60wVa8YHmdkulGX7OwTtI7XzaXrTZS8TtTj5sPRltqwbQUeJ7vIEhBQLsvBYolCbXPthBzmxQMmbcRDAJz693BxF0P3jJuOdbDcV1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRvettS5piH0O6Dklvy4Dggk0gTiAlGjqVEHeMGJqbU=;
 b=K3JDJoMZoZKsYHeSKpcW7ge61GL66Y0AFC4gJTDdU9uzKLxlLY+jdoZd1jLJljz14j9PZyu1buw3cB0qD6xa11hekFYrrBZWjAmBq3aCHIwQlp5XZszzpFwhQ2/wN4Bq86l6AsNsLt77TjpPaQMC+hTsr7TFliACBMO5wNdauelX28Wpwl3U3dnkcTq2+QkLtofjbF+c+CRSAQLJq93lfNeTFUHAGURIpdoATEc4piC4rVHfe8L5VY7BLeKdpzLVptoFXUSBdLkuDzM8ZY+axtwVG4hlbz0otnxn/ZSINfOQymyrqz3SGGF/WoJ7Qn05QexFs/AbMaB264A4VyWDGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRvettS5piH0O6Dklvy4Dggk0gTiAlGjqVEHeMGJqbU=;
 b=HF/8IStnsqV3VwJYalLtbnRuNFX4mUUVxzLZvroN+51XBnH86kRDPlHldcRjtkimB053Fishg+Hww8xP//TffwyhLZfyTtDt/yGiZ4VYVrKtV5W9LXqD9+HsJ84474rOoFsWu4fOzMgzLPHsK7f3GJhuP0nb66GJYmjLx2qcmDA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Mon, 28 Jun
 2021 09:20:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 09:20:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 11/12] igc: Check incompatible configs for
 Frame Preemption
Thread-Topic: [PATCH net-next v4 11/12] igc: Check incompatible configs for
 Frame Preemption
Thread-Index: AQHXaiLx4z85e3aMeU++l1bzHpMXYKspKUeA
Date:   Mon, 28 Jun 2021 09:20:03 +0000
Message-ID: <20210628092003.bribdjfaxwnpdt5f@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-12-vinicius.gomes@intel.com>
In-Reply-To: <20210626003314.3159402-12-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.224.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b37a21d-5deb-44db-6a78-08d93a15e9cb
x-ms-traffictypediagnostic: VI1PR0401MB2304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB23040C67FB402401F7BD4785E0039@VI1PR0401MB2304.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NE5VDEQMQD2jTybI+eN/XOK7LPujqrv+EBvoRzSyzwzFWg7/kznWyFPAdfKjs65yZS+5F0b5OpNK1D0RCwh47hlUZmCFyqwMG/RuiJnZ/sB3E0FktiVIGD45od8vKanH/XwEhvn0X1rqWUSjx13r2wdT0hxY50UCm/A4e5S9zwfj3xvQwmocOlh44elAUmy8Le7eQj/YzC4wy25+ekU4ZNYG4IW93SExtP8eMVJKSoclCpIl70Iu5JA4NwG7N3VvyS10nbo/xdeIATtXojdSPj8DQspM2m2M9+MF9KnT9++IU8xjbtYtqecguhihaXqBbVsT+dX7uwvCpzbq/OL9tMNCNgkXgFI01OGZROsSBb4ML4gsqEjV+Odd9egL4wRMTSrohKNRHNYXMlDaZCtigmhtb45n+0RMre/W6LQdiyed6JrkI3PDGdHMtQrZUdbQnqqQLW6eTEmueAyoDQ2GF5/uivaCwrXcbHHOKR50GX1KK1uKPhZ4xjf+WwqBC+hnCQhq3w7mi6Zo/zv/a4sec4AN3WP7Thg7jZf4wbmfVgZclKb+BZy2uONquEiqoia2bJNmjIRJ66smsVRRWv4ajIvTCU9z6olrU0ULgyQZ3aWZBzekZIIzEvZhgC/HbOK25XmqRVABNTpTrbhBV2/gXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(4326008)(8936002)(71200400001)(316002)(38100700002)(5660300002)(6916009)(26005)(44832011)(186003)(122000001)(8676002)(76116006)(83380400001)(6506007)(33716001)(2906002)(66446008)(66556008)(66946007)(64756008)(66476007)(86362001)(478600001)(1076003)(9686003)(6512007)(4744005)(6486002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3UYjzzv0E4lt7jhakU+0CSYxiaTl6ewAcyyCPAxZ85I27h4roVjZB1b2W2M5?=
 =?us-ascii?Q?OZ0cdpZSlAhSNYBM01MMGGcre8FbiGaRX4bwprCIbHaqRPpkR9t1IWozEJbg?=
 =?us-ascii?Q?ZwjJk1auc/GB7STNB4utBW51+4LjLxl0q6zrtobTZlcETt3pXc7+JJyt0SVs?=
 =?us-ascii?Q?gi7JwZeuSUu08WmyXCu3nh9/Wc4CfMynZ/ikXJ9yG3NPTsbitcZVon1Sd0WB?=
 =?us-ascii?Q?c2nMANF+Dw1R4PaRJXF9r5o4ILiHsoXjAIKcIGPIUkzlc7QUsS0n1TPLUXbA?=
 =?us-ascii?Q?mNs8U/VayV/OZNs6SY9ZKKsrQlQv0Q4/aScr+5WNqbdwc9qOAqaJAyEleqki?=
 =?us-ascii?Q?j3K9em2VjSrcPHJk4HEfCZBy7dKt/FSa9AW+ZR5GD7YPiuze8TIODTivqyN3?=
 =?us-ascii?Q?IEwRdWKViO4ETm9i+4C0IHYzJrbWvLMX9JoMndZsrCIOeZ6Cg4kXtOh5JA6F?=
 =?us-ascii?Q?beippaXMsxD7l3svP5fqQkomgkyBB2r1WpvJwcz9nOdWzxLSlill4wKWRSzV?=
 =?us-ascii?Q?rO7+myWPBuJlIHbE8y4Bke3/3TllzMXXJMEY6KGfqAARdX6kcEu3JcT3zqDn?=
 =?us-ascii?Q?pihVTs0BUK9RUkyNvzPakfQ+vFOc/wXoHHpr5W/CWLR7xpuIZws/IBAfqUCW?=
 =?us-ascii?Q?DdIx+RO/gXQEUOb+VC3+lDaNQ6DCb91jDoYZpb4+88zoJVdbZrwpT/ovCGpq?=
 =?us-ascii?Q?8PUue7cr4mFJolWPI9eto6b0Q3SYqvm0HbdXT7Q11+UUqDZH0QQ7xwJTsYMJ?=
 =?us-ascii?Q?fdYKI4tMSiKsyuz/dES4JrOD9pS5UE/bjU1964JyLArAMYJem2HZM06vNDm+?=
 =?us-ascii?Q?Bu/a8fOttZlV4UANs2klNd0y/jyQGoR3lJUDFw480LeBwGSwhJIrtBXs+EKH?=
 =?us-ascii?Q?G1dDHKNuXJtUmu9HO/LluU+KmMoc3ytM9vK7DMJ90uJnQ6Wv1MRMtl8U9H2+?=
 =?us-ascii?Q?Mf2gXxMIJy32rawnRGgAvTU1f3F0k14rOf2f/XsH44nXdQn/pxj2nZ9gMhL/?=
 =?us-ascii?Q?K+hh6SMjs8Hq9B1IdQcZJWGcQ/MXxW4Hww9g2Tbdujrl5mdQbT97Q/qnUr+k?=
 =?us-ascii?Q?XsBxHB/T2I9APEP/irVF8J32F/JCgJzCF6Wfuky+P+sf1FLYuj/DCJz0eGV0?=
 =?us-ascii?Q?qt8JmXnlkjv0Ql80JOrzIxM2QZ2R0V/Oie/CfjaHqMMvY4eLhwcSl1whymD0?=
 =?us-ascii?Q?qmo329MKtGcf6dFnU13q971HhFLnwmq9UFkA+bqShgtTkC6SOyDQATa7OU99?=
 =?us-ascii?Q?3u6JLnXE9ms0btKLviwsLRg1KDiGav5wdZnd+SFPl1duQ+jyYawz140Sf4pP?=
 =?us-ascii?Q?lHHtZkIu5orIjj0fMv8KdbG/?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6654AE83CDE050419F804D9E8CE73329@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b37a21d-5deb-44db-6a78-08d93a15e9cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 09:20:03.9759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4wi+FEm3PBppD3LOzb9C5puDXXDVyIf+p50e/vwkvjXDOXJX7Xs9kFEy0XJUOVTAcvnTbxvG8ejcqyE4u4SuNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 05:33:13PM -0700, Vinicius Costa Gomes wrote:
> Frame Preemption and LaunchTime cannot be enabled on the same queue.
> If that situation happens, emit an error to the user, and log the
> error.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

This is a very interesting limitation, considering the fact that much of
the frame preemption validation that I did was in conjunction with
tc-etf and SO_TXTIME (send packets on 2 queues, one preemptible and one
express, and compare the TX timestamps of the express packets with their
scheduled TX times). The base-time offset between the ET and the PT
packets is varied in small increments in the order of 20 ns or so.
If this is not possible with hardware driven by igc, how do you know it
works properly? :)=
