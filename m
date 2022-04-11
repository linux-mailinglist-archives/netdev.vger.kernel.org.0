Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801A74FC315
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348826AbiDKRXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245391AbiDKRXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:23:02 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40063.outbound.protection.outlook.com [40.107.4.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C8425E8F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:20:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaVeK9ZwcHHdftP+qmXkO3/NxK1+iA6CeR2DSWo23p3t+jY+RTlFGYXgEskZoEbLtJIi5+KkaI9ZqeiECU0L060FkNUQrkEPqaxi4mPq5S/0/wWBP6KnaeP0EkB9YxoBc20qEVOyhAA0zZfeG3NKg5fXTjcxv8OprbK94XmL5WoAhw6RkQloX45VCQ5wh7fENpY8IRN10axwjp0PnlySsSrFyp/BX2M7/UKe/5Zfu9HAbjCGRYcVrV8jOyTxpstZh8sYV38LV/G655EuSGjtTurHmcSZj5psvxgPS9UfjGoi199CVfl8vb56b1zCdpoMjmTghivbCZFLgAPbjz027A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yyCytTOz3zUDRFj1r8da8s5XHjZ589DIs83L3QOOL0=;
 b=WAdRl1Lh61iO9VjsNIqrvKgx2YCs4/DUkTIYEGzUtBiR4EH6hKZePY8ZOnps1/1PQyZQ32kMOLnY1s/djQgpguOje/aD5Ss4mJO0lx2A5LEYN0s1uyVJGrSHH96wkqBGTH4O3KK8tccIsmUlE69emWRtkzCb6ZFiVA9LN4CEd7KguC3mcu3dQxQGLUgg+Xq7MjmDuF7Hz+pqQj8L48UjlB0cRx7+vrXjoXnuXldoFdTRPDTsi/7PTMsfN09Q+udKHUMAPrqXhyzeraNdEyfvli5WRmFETnzEdejs5aJciw0ogJpEQTBNFnvqV5yQeA8l9qUOU/czpnn39Vj4RvBJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yyCytTOz3zUDRFj1r8da8s5XHjZ589DIs83L3QOOL0=;
 b=NbksI5KZJ6m3EZa3ZUZa4w4YDgPOvwJRycPSKSZsBYwRd0ns6jB1Sp8VjwzvB5qmv9xxayKqhBPfwRja4J33bz+2K5lwWNg9Ea1GBCk9UB5Yc0n1oMNMdtQvn2SFcuyyUiHQf4oL9VrvTQKg/ww2HVzy2eValePfifBDvh1vtsg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3866.eurprd04.prod.outlook.com (2603:10a6:8:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 17:20:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 17:20:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Joachim Wiberg <troglobit@gmail.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH RFC net-next 05/13] selftests: forwarding: add
 TCPDUMP_EXTRA_FLAGS to lib.sh
Thread-Topic: [PATCH RFC net-next 05/13] selftests: forwarding: add
 TCPDUMP_EXTRA_FLAGS to lib.sh
Thread-Index: AQHYTal/ZCoqBNKw5E6dzZgsszEWPazq9Z4A
Date:   Mon, 11 Apr 2022 17:20:42 +0000
Message-ID: <20220411172042.prh3hy7ehpc5o34f@skbuf>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-6-troglobit@gmail.com>
In-Reply-To: <20220411133837.318876-6-troglobit@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbcd43a1-8680-4c80-8876-08da1bdf9ba8
x-ms-traffictypediagnostic: DB3PR0402MB3866:EE_
x-microsoft-antispam-prvs: <DB3PR0402MB3866D94529925D8C6432752CE0EA9@DB3PR0402MB3866.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NvH+E8YsFoKgMGAuZciVqIWk0oqeTdR7x+2T+2CvCPuB9+lRAoge+5UTyPKrzwCrhX+wCSjBcnpUcMT1/ZudbWvhr1oP1zgQ1ekH7O788eVCSl9R5IsfXLYwuR2HuGETafMcCJvzahjqTdjx6T7j2vMYGs9wqr9FaqHXVeb1hT8DFWxwRXuGQcEUM4F3xRs6R0CjFmi/NqCQJMKcVs7U0vddePHt54dlB2XQnGQsjqjdCM0g+vpG2UUmSet5AIv+DFl+6y+5kV99oSM/uwowmv3uKljl/2FxukkaSN2Ri0pSB/sNkYV3K2XqKB+vJ49HSh7Rv3GgR4OsDdUqR1Paeg+T/Yps6RXqBtSl8QTD/ahYxPWCf/Dnebm4E8G8MMn0d6fgYOXstB53MmXK3XSMmFhMGGjSDKPUZWGSa/ApE6JMsa4HlmbwxIqhHKGk14cMlh8ya9UtA+32aBXh4/klE94bA2ssqMxpAyk69DalhqpvIUoJvOlzn0NDcOPPzyuZ2JZD3/H3By42vVLLPEjD9WetThrYy2B2nsltb4oFBpYcci8ENIxkDYj/PGw+d2rYeZRbNVwT1z/QRFqsUYOo+H8kGJLmajv8XqbPsOjUJ1ABmRUg1Dnf0NsxETy/tY59nv4HIKT80BUYFqu92bnnaUcYEqgPrM80jNPM2iVPg4zjt07/3llTDhY99RqZgFtW3vDG+Ka9b9OlHJA7YM6cHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(6486002)(76116006)(1076003)(4326008)(26005)(508600001)(54906003)(6916009)(71200400001)(66446008)(33716001)(91956017)(186003)(86362001)(38100700002)(64756008)(66556008)(8936002)(66946007)(8676002)(66476007)(83380400001)(9686003)(6506007)(6512007)(2906002)(38070700005)(5660300002)(44832011)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?roOJpBmfV0UBE0SVf6rIvFE7yy0a3DiIWZLAxPLzVRYdldAsgMfEJb7pBT2W?=
 =?us-ascii?Q?r+uRHKfr9yavZt4beMMaYBSBVvDa3+KjBpKFXPlS54+iXx/6mY2ws4K0ps49?=
 =?us-ascii?Q?kMCo0VLDh4C8uh1UcMnt9aNEngIUjxe1TItOSyfDj4NNYYCqkGv01YTthM7O?=
 =?us-ascii?Q?H3MUPxAZLWOsex/aa73G4QxrVW0A4Z678JN9RLmq5lMQNCmSqnbUNIF+8PN4?=
 =?us-ascii?Q?k356h0sifvvw3wmI9b071LDsAMZEkPONuquMAQVpIyzznbK/PBJEBf8WGrG7?=
 =?us-ascii?Q?YaUAhfwq49tzHDmi1Sl5zG070xSNfL/nSkm9A62zJpnpcSypqzvALN9vuf/M?=
 =?us-ascii?Q?DJbwoVGf1wWETqmTzRI5JZESEc/g/MH/SEbTbLiodUrw/b09yVmhcghGu3hG?=
 =?us-ascii?Q?SKW5U/5i+MQfBFphVSni9nwI/MnYNxUsKEubpoou2L4p5pxTHIBafViem0Vq?=
 =?us-ascii?Q?/pqtEJIEcRo4WZwIpclWkAmxI60suwFZ6fGqHwGfLxSeG7UMTZOMJ+4X1gaO?=
 =?us-ascii?Q?QRUVjVLeZzn4nSmYuVeLwa8jCNQfb9KU4sYv7eW/a+0pjUTJZij+rQwuTaDt?=
 =?us-ascii?Q?4LXD+oGUmCaGY6jWHAU1+XzgiM5B2ZCYlZhmL18VHTE3d84B9sYO8xayxewf?=
 =?us-ascii?Q?rdbxvsPClfC1ZA4kRrhs2W/msQGyb70wxUrsxwI4QZ/QqDc5k1XnDJBoGmEs?=
 =?us-ascii?Q?sFZLzcwm7chY2tMMbZ89nLkriQhQP9/RiPulpWj9SXBd2ZtQrIpbFrqjHXfC?=
 =?us-ascii?Q?Vdr44iXit9oF8ZBnOm8kLib62wsg1UfI5b/mLy3A8RpZheaR5eIeyCIwfCr+?=
 =?us-ascii?Q?uXxFUQJpiWTghw5KF3ZHyzcH9oiDamblfRrMdvKUTlIKUK6bQCv8fR8c4UJx?=
 =?us-ascii?Q?TWBOV/GsjL+SZgclhmWNsDq1l2aT0y4D+YOZY8947aAglEsTT1EivJ1Z3XbS?=
 =?us-ascii?Q?MrFtfsGn2KQXrVpsnl0Wxy7xTOlHZJ4lop5rx94LlIO2KUCN/CREFRAzcjLd?=
 =?us-ascii?Q?4T6pV4/gO9PnB7VduPG0op+da+RQq0WZg0/eqoZtSnIBnJ6yLXgSoi9rUkzT?=
 =?us-ascii?Q?fitCHuopJcIMT4c6Tmj1kjBz85CbXVhw3xu6ldQ1Izi6FkFyoSJ1Tr+wGNOG?=
 =?us-ascii?Q?ywR+EhviocECfwRHWX6JRDK/ReeAspXWIgmDbDznsIbsdKTTodCD9l9OQq9z?=
 =?us-ascii?Q?6HNWiCYzneeXW4uiE/FFdqhe+vRjx5lZ4OrV2q80pwqx3NOYer76eU69rWiA?=
 =?us-ascii?Q?VcNXg0IHuz+d0Ri3Y7vjiu02oKXt9X+Km9hIzKdUA4XX4WQzZNeydv+NfmHB?=
 =?us-ascii?Q?G9ryd1zjF9PZpDPEQoNUuANI+OOKk7OWLIJgQOW9O7ogoeinT6MmGb7Ehd/P?=
 =?us-ascii?Q?UIFY5h8DPBF1Tle9+4PP92RP5pP4kPkOnynbKWvbKFiEVgZbkUrRB5esSKbZ?=
 =?us-ascii?Q?EIjIbZxm8/NktKG87sL9WVgSeVEtvf2z8XDZ3kMC5jxU6J9z4d7rn8i9/3EW?=
 =?us-ascii?Q?ZQTRfeiO4ofLZoOXVls9IDF+dsTfeA8pvStmuNXIcMk0I7hLAdfhWfhSkUZ3?=
 =?us-ascii?Q?eynpWW/5iBpcidB2qkcIIOCn2P1T11MDVl/U2P4o1ICug9f6L3w59Uc8618m?=
 =?us-ascii?Q?8EOQBCWDkll/YD5ILg/v50TobXl8tVBaLZoJhDACLXnUota9Z4xW5FgmvI3N?=
 =?us-ascii?Q?BCeftKvtUkeY7vZlAxIB/D9PLueXqicprro2ra2VMLUYju4CxsbcdsSjGnIv?=
 =?us-ascii?Q?W23uPSY1HiQUmhs3tdxOkKXcXnTOdlo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2DDD7F5B57E7C649929B958CE877A162@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbcd43a1-8680-4c80-8876-08da1bdf9ba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 17:20:42.8735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2s3HZNnwXA6EGJXORe7QcErszjfNQIMX0nb93jGbLD6lmMnTI0SOq1fInnEEPaK7eAHj5vdJ3j56vvrbVFQ8oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3866
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:38:29PM +0200, Joachim Wiberg wrote:
> For some use-cases we may want to change the tcpdump flags used in
> tcpdump_start().  For instance, observing interfaces without the PROMISC
> flag, e.g. to see what's really being forwarded to the bridge interface.
>=20
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>  mode change 100644 =3D> 100755 tools/testing/selftests/net/forwarding/li=
b.sh
>=20
> diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testin=
g/selftests/net/forwarding/lib.sh
> old mode 100644
> new mode 100755
> index 664b9ecaf228..00cdcab7accf
> --- a/tools/testing/selftests/net/forwarding/lib.sh
> +++ b/tools/testing/selftests/net/forwarding/lib.sh
> @@ -1369,7 +1369,13 @@ tcpdump_start()
>  		capuser=3D"-Z $SUDO_USER"
>  	fi
> =20
> -	$ns_cmd tcpdump -e -n -Q in -i $if_name \
> +	if [ -z $TCPDUMP_EXTRA_FLAGS ]; then
> +		extra_flags=3D""
> +	else
> +		extra_flags=3D"$TCPDUMP_EXTRA_FLAGS"
> +	fi
> +
> +	$ns_cmd tcpdump $extra_flags -e -n -Q in -i $if_name \

Could you call directly "$ns_cmd tcpdump $TCPDUMP_EXTRA_FLAGS ..." here,
without an intermediary "extra_flags" global variable which holds the
same content?

You could initialize it just like the way other variables are
initialized, at the beginning of lib.sh:

TCPDUMP_EXTRA_FLAGS=3D${TCPDUMP_EXTRA_FLAGS:=3D}

>  		-s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
>  	cappid=3D$!
> =20
> --=20
> 2.25.1
>=
