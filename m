Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D847C3B5517
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 22:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhF0UFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 16:05:01 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:20641
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231468AbhF0UE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Jun 2021 16:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dqy63q9xPcE23cc2nQ1fSLVXhUhNkBqCys5gCVgFWdXqQEh8zJX0AFWxAPRsIXhrRhQyr2c6byibwoU/jTGePHh7kOgXnso5knIZEna62gU9BSud8DLdOqGEVFifSae47O0zCJMP1NOqZMbPF4SxtknMljQlIEw1HQkClEESREJ7cMZLjzJmpXfUclAboWVidUeVhhNG/fiF9TyltioImUMYwmmSd40LfnjRawZE15asE2zfaxX9ybBdJi0+GrTgSlT4hXisC0Qay82xGab6n6Qir6K41hVtDduudphVtCSWWbKjFJnJMjgE1GsMznz6PoSfn9vMyIKTiep5qbtrYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UR32bD07GnclRmc/bST8YYhngYfq7i5x4Gi9Z96tlto=;
 b=WS/c9wzCj72XFKF3HNLsU2zCuCHQDiWGgVoc12DY0hyHXmJC5ipv8vcaeOU52xAopfGwl9IeSCwRvkxgmBcKkTg4pRo64/qoI+nLNug3Af1drerV5RVmI6aVoOu8AzMuZ6VUDc2BECQjtDSA2DZNECrx6DyxWEfu+kd8SaDVQPHPawnAO9K117hhdrOOCdLw529LZLwpP70a60CgZo5x/NonTtif8xqenWOhMlnH19g5Y90nkfXGonIh8y6JjYYmqRV70n8jvtBodXYQqG/CDWKTJ2+fHc1Br2pMiRec9N69+qGu3rLccDmiZA/avGx/JXVz7z3U2BeeE4J2aZCKLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UR32bD07GnclRmc/bST8YYhngYfq7i5x4Gi9Z96tlto=;
 b=ePTa6Agz43NBYIvCTFKwXnBcvFF6jxA0pr5wAZN/Rgfpz5mlTMwW7inludN1NVWwRHzTms2AaZeW0FS+wJR5zYtyaZ1/bR5SE00m6HzKw9doZ7PKfkNnW/3VHH3A1uB/mFue9N2yqkcyd0xvUk+/C03VVySHNt+exLHOYaTGn/4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Sun, 27 Jun
 2021 20:02:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4264.026; Sun, 27 Jun 2021
 20:02:33 +0000
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
Subject: Re: [PATCH net-next v4 04/12] taprio: Replace tc_map_to_queue_mask()
Thread-Topic: [PATCH net-next v4 04/12] taprio: Replace tc_map_to_queue_mask()
Thread-Index: AQHXaiLtLBtp8YSdqkCWRoF/g5fCFasoSnQA
Date:   Sun, 27 Jun 2021 20:02:33 +0000
Message-ID: <20210627200232.mq6bzsxwn25dmill@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-5-vinicius.gomes@intel.com>
In-Reply-To: <20210626003314.3159402-5-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.224.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c903f4b6-0cdc-411d-b91d-08d939a68062
x-ms-traffictypediagnostic: VI1PR04MB6944:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB694405A65F993B5A993416AFE0049@VI1PR04MB6944.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8P8SvqITxFvzR9yoK6/K9dl0IhSpmltc/K70CwkeklhgJPmR5IshGz1Us0PD/NaI2H7sjuppWxldVy7veToeka2tUc2L7EDOseyoorTl2F/nG0MTwfWBdvt2IgPQHS89EgrLPCXj0gY8pkeGr3aJUV4+jlLNbGFG/CMnmTA3p87HQ8Mld6/cuJIWFArd1L+29Bft74wPDf6vypKg0/Qadsoq1kWWQoEn7WFO2t9mTbPdOui87H/jKdA74KB0fvDzW6975vq++K+VJvgevEFXmaeQJKlkd9o+JISTPNMuKyh8P5g8bZcKjQ+QvpnwwkPSCBBd/3nI9SI9J19kWTEuybLbhXe/zcLOXAsfTaV4Kf63mEgeRVZlHj/cl/4oQiVEgDYBpEY/e//pZ9x1WT0a/4qG90NDGu8x8tHEzryg4bXIlDctd0E65PjzTxdfjeKb7J1J+3gXJ8psEely7OFU5q1Mb6z69AXejBkuC7DoUcVhfd8mFh56H7n5Sy7nMHrsAC8aUg1uRoDc1j+SohBN3U0ry0jeM/FUREyHudJ2JuVuiM3x7zqi4Q8lSNYTqJG4Cwx2dnBHWmEZMeaMZm308+rqK+dbnFUu2DYiEgfhZcY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(366004)(346002)(376002)(39850400004)(136003)(26005)(86362001)(76116006)(6916009)(8676002)(71200400001)(44832011)(6512007)(4326008)(9686003)(91956017)(2906002)(186003)(316002)(6486002)(6506007)(122000001)(83380400001)(38100700002)(1076003)(64756008)(33716001)(478600001)(8936002)(66556008)(54906003)(66446008)(66476007)(5660300002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UCpLwl/xn8lAA+pROfkYJGfsQ97CbRPwQVmsmdyGT6SlmVyRcN6O+STxVCFI?=
 =?us-ascii?Q?d3G0yC0yY886vUveEohlLVF1C6pvuzNYvaJkyL+r+L3fpGH5BEOMJ2mW+aaf?=
 =?us-ascii?Q?qWdSY2DDzIKAdG8bwI1odDbSps8NdaaGrW2YUJe3w01EhF9jC11JrCxTQWMB?=
 =?us-ascii?Q?tDCcG3YdOO1KjAzpQDNCXaqTNjXEz7KiTPhKwD6rGrcKjFIaCmCfxxRrZHHj?=
 =?us-ascii?Q?4p3Epp3YnoU6bjR7J1KRLZWH5Pii6SDNpIon+srMe1+htGEeuJmyJZgyIEYV?=
 =?us-ascii?Q?ptGjqGJfdWxwNuXkViSXSbpw0nxScBtBN3mJ/K9u0xJqq15/iJ8j95FXastK?=
 =?us-ascii?Q?2qrfyq3DuiYOzjTildiTapjzlKZslJUHAf8ebSqMDiaxz4zUmo8YywAxmx2u?=
 =?us-ascii?Q?8uzREc3IydgxYbX+4x5pwLko2ioHuX7q1buSmQ4BhGBDShF2dSxpSSyNvRhk?=
 =?us-ascii?Q?8L2ji3YvEsAk/nYG9ijpQ03KJGZ/yczse9Iv/RIcbTkuOQtX3rMrAloqhgjm?=
 =?us-ascii?Q?BSMwjrIEDTUL66cGpoRjjn1cICz7bYxJrPXKmva761GrXzdBDP+PeQuXUTDI?=
 =?us-ascii?Q?BZo5nTMiZ57gBnkWVfwxoQgB90ndj0yBwOhd0i7eC6kfp5Z/ftfX4nxY31bb?=
 =?us-ascii?Q?yqOu+0Rrw4WQLR0WpQfi4piwxEUTdB+Q2nNxmBfCeNYkJwHYdnkGiJWpjsKH?=
 =?us-ascii?Q?ndADhLGUcXcceT90K/QW9bLmzeV1opD+V38ApERRsRK9PPbAEGMiT1XKKLdY?=
 =?us-ascii?Q?TvvzD3Mnb9DdPNWNO10D3qLHK+svATq9qKGIZdQpL/UkYYI8PqFENIfzKxeG?=
 =?us-ascii?Q?tN42mYTQUMyOkH1i7Vh1k4qxFzn1ZePyNyizvMM0OBrSGWGnSDabJII1lyJl?=
 =?us-ascii?Q?8fKsGG/O6mcfHhw+uztNcE3KxWXx5xVAumRVQeje4TVxtBzO2HLN2nTI4Isp?=
 =?us-ascii?Q?eBfcNpeRgvWMAq5allrQAUfeX4RB/B/OAR2bA2s0Pdh1eZlnxS6AD5MQjh++?=
 =?us-ascii?Q?CoQLRKosp8vUvi56jAeMzjypsNaHGIjD1dj3wYu4LU2t5AbDLXZ8JR+GvVI+?=
 =?us-ascii?Q?BI82ywOaOnsswCAS2kN/waOEOx54IYrRpR04AVNXZdoy3936GW01lLbqpMt+?=
 =?us-ascii?Q?6lpK8W7b2915eLpd7v44TawG4cz3bAhhe5PNPWYeHmZ54s0QhUFNe6dlZhNC?=
 =?us-ascii?Q?cGwQn65oBMtV3vJiZvvEDGLM/Auev+aOJAXpvRW8hXE3hQ+wBRgckhafBlcA?=
 =?us-ascii?Q?k9sqAINvvsd1/OCFCo2QtmBtN4Sbf+SDEPEWv4YiPaQDYERBEST1XL5i0nyB?=
 =?us-ascii?Q?ah/rwOFXIngS987QfiaHB4dk?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <09C88D7662C91D40B123E9652AE890FF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c903f4b6-0cdc-411d-b91d-08d939a68062
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2021 20:02:33.0130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fiE8H6IHIKZ0uh1tjx717d++Eba+JH+2wKabII9efhH/U2SEIjAZoIfNUJZ3g9OpZdIZrwSUmPPzx0Ys0SKDEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 05:33:06PM -0700, Vinicius Costa Gomes wrote:
> Replaces tc_map_to_queue_mask() by netdev_tc_map_to_queue_mask() that
> was just introduced.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  net/sched/sch_taprio.c | 26 ++++----------------------
>  1 file changed, 4 insertions(+), 22 deletions(-)
>=20
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 58586f98c648..4e411ca3a9eb 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1201,25 +1201,6 @@ static void taprio_offload_config_changed(struct t=
aprio_sched *q)
>  	spin_unlock(&q->current_entry_lock);
>  }
> =20
> -static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
> -{
> -	u32 i, queue_mask =3D 0;
> -
> -	for (i =3D 0; i < dev->num_tc; i++) {
> -		u32 offset, count;
> -
> -		if (!(tc_mask & BIT(i)))
> -			continue;
> -
> -		offset =3D dev->tc_to_txq[i].offset;
> -		count =3D dev->tc_to_txq[i].count;
> -
> -		queue_mask |=3D GENMASK(offset + count - 1, offset);
> -	}
> -
> -	return queue_mask;
> -}
> -
>  static void taprio_sched_to_offload(struct net_device *dev,
>  				    struct sched_gate_list *sched,
>  				    struct tc_taprio_qopt_offload *offload)
> @@ -1236,7 +1217,7 @@ static void taprio_sched_to_offload(struct net_devi=
ce *dev,
> =20
>  		e->command =3D entry->command;
>  		e->interval =3D entry->interval;
> -		e->gate_mask =3D tc_map_to_queue_mask(dev, entry->gate_mask);
> +		e->gate_mask =3D netdev_tc_map_to_queue_mask(dev, entry->gate_mask);
> =20
>  		i++;
>  	}
> @@ -1536,14 +1517,15 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  	if (tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]) {
>  		u32 preempt =3D nla_get_u32(tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]);
>  		struct tc_preempt_qopt_offload qopt =3D { };
> +		u32 all_tcs_mask =3D GENMASK(mqprio->num_tc, 0);
> =20
> -		if (preempt =3D=3D U32_MAX) {
> +		if ((preempt & all_tcs_mask) =3D=3D all_tcs_mask) {

Ouch, this patch does more than it says on the box.
If it did only what the commit message said, it could have just as well
been squashed with the previous one (and this extra change squashed with
the "preemptible queues in taprio" patch. Practically it means that
these last two patches should go before the "preemptible queues in taprio" =
one.

>  			NL_SET_ERR_MSG(extack, "At least one queue must be not be preemptible=
");
>  			err =3D -EINVAL;
>  			goto free_sched;
>  		}
> =20
> -		qopt.preemptible_queues =3D tc_map_to_queue_mask(dev, preempt);
> +		qopt.preemptible_queues =3D netdev_tc_map_to_queue_mask(dev, preempt);
> =20
>  		err =3D dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
>  						    &qopt);
> --=20
> 2.32.0
>=20
