Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B9F3B5514
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhF0UAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 16:00:54 -0400
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:42145
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231468AbhF0UAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Jun 2021 16:00:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNZOdPAMfLa0jjn5TSr+Lt7QOjbwPRTlSvAQC4b1j4fLTtR+t14cyE/EOZCKAwTv0K//O5ydsompC+8DXC4MNVmkqOGpT3QhGBJ9OBZqhKoyzWhe2Yh/2Sn9K/KThDseIMJ+u6t3CCFIpPinHe2kWtWyFDxQJqG4zRXrTkFbeFLVLKt4CgpbVM6m5RZsjm2BcjJDSKL+8G0X4cuRYSRqTlcx099Z6H9DBQTrMTVcSUjtTBWZ3M/LjzF9LZH/uFbbMalrT3g9kSLprrjOJl3MOtzfaBR2PkgbH7BR/L2clTC+1Z/1wDPVnqqTkCfK4bRfiTjIgPDDOyvRkDCVEMxJDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uhT14zOPURvGRpzOA4/6G9vDZbMD/TjLg+VTT05ZWs=;
 b=oEuBWmVtRhSKPhBTgYyqvl7+aoKlyVXQy9HqxJosAbeIRyYULec/jySFYLHfW+6swd4VkhRRhtjI9Ua+PPQcQ7wO1I0PdWsuflFS/LtmOtuDxhgbTlQpsWiXhtjyGb3V/0D6TVEPTRtaOTjAKg+pLONMQenknrr+w17ychdfegorUF82QGamZNymfn00zp688Cyv7/ryrvOeRCiUxQfMPIFxy3tR1wAz8nfHQdNYaSioMjDkSk4YDLIm8UiDZqsJ7kFzDteWNwhQRHpkA2/Pif7IebziB5XQstAv+wjkZMfNyyg+TQ9tp1Ns5/8fw10k5aaaQw6gwe+p4F/0d0NQmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uhT14zOPURvGRpzOA4/6G9vDZbMD/TjLg+VTT05ZWs=;
 b=HUVc4Bo8Iy8+4yJB+dJ+J8dVSvLww22bztohrx0cqb1UYFK1CUS2UAvDkdLdCuBHECoh4CYSFYfG13mIsqSH/wpERI2C17p6VFNhhmvJQ1sdbuucRdmyoQWyhaXFvNKBJgPg3Q+8aRzh1d9EF2hevrSO1eIryZdc7J3SroHHTqk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Sun, 27 Jun
 2021 19:58:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4264.026; Sun, 27 Jun 2021
 19:58:27 +0000
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
Subject: Re: [PATCH net-next v4 02/12] taprio: Add support for frame
 preemption offload
Thread-Topic: [PATCH net-next v4 02/12] taprio: Add support for frame
 preemption offload
Thread-Index: AQHXaiLuC1gW4iDox0yz7Q8gS7SibKsoSU8A
Date:   Sun, 27 Jun 2021 19:58:26 +0000
Message-ID: <20210627195826.fax7l4hd2itze4pi@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-3-vinicius.gomes@intel.com>
In-Reply-To: <20210626003314.3159402-3-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.224.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a4c9b15-1083-4f8c-c9a9-08d939a5edd4
x-ms-traffictypediagnostic: VE1PR04MB7216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB7216391CF6BE0727BC442F2AE0049@VE1PR04MB7216.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: syXjwmUZ9/dRr3YILBCKrx+E+8OLlFiZ1lrWwGzNnPl0VYUD3OOPzmZ9o0y64Vc6GwaJiKwqlK3bY9y+a+tFoNAeJYwTxPdBROCdH9FA7ual/L7vfuT07ChKGBOlJ+qkbMMXLqINkQfudlbqNMxR1HQG1MfkKRn/L2etG1ytItLyNRcQCWUugQeyQtqDu+ATmUJ4LDU4ZVLps+NLwlV4ZJxEj695WphT0CklKIkea1qQutbkiEFN8J4jbYIvSGLOgh7j80f/UREefHzk8ztDRVXInEsCPJ1JMJH318hyH2KtRuBgQmwunQD6MvV+1eFRsNH+1Wd1EFWlbNITDR1izfhsGQ0iSnMKNl0PMN+wuCJztA4zbY+Jr0JSQ/BOjAsQ2jCp/kaG2A2vMfqDLqOROEvgQRIAaBVLGWMyzoLfySjIEqEb/mlFgpVf4OucXQbu6iLTgKrkhGG9tRVkOzmWz0Albyo8yjnKuxAmnOIyqTzsCecGGiuQAs6NY7klRAecrLQWHF/H5mrENUgGH7Mq57qnIWoZHDky7v0dPWda3ApHnYf9SnMPRzZH0T9Z3KCCIQ/BxeU28otGryaEsdEQHrTxKBwGoCcQy3v2Z0jsXqY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(396003)(39850400004)(366004)(136003)(346002)(83380400001)(6916009)(26005)(186003)(66446008)(5660300002)(54906003)(6486002)(86362001)(4326008)(8676002)(71200400001)(44832011)(66946007)(66476007)(1076003)(9686003)(6512007)(91956017)(2906002)(316002)(8936002)(64756008)(66556008)(6506007)(122000001)(38100700002)(478600001)(76116006)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cd0jxAFEuHD2nTZCpkADsWdYsHCJIJQFLBwZhMciw6rZoMq5a8WmkXN6YAgy?=
 =?us-ascii?Q?7MjnqgVq+EdiHfuEkpXT+9nwiU/26xvSuIXDvr5i8hhweKo4KRdDVIITgkUR?=
 =?us-ascii?Q?FSOq8Xu2J5xbScQB7gfQFQ0RgZp14AzvmGIFh9nxUe/EiQP2716bAoY1Xzrd?=
 =?us-ascii?Q?ZGGqkkTwIfSlvc6FWXiPPDsvAPdpp9W2Ta8XzsKwG5UuWT6BL8BZeNlAJozt?=
 =?us-ascii?Q?wcLH/bF3tyaN56sbZ4JooUM+Ze64+UQnsfgyn2jzPoDFinQ4EJnqcb4LVd4H?=
 =?us-ascii?Q?pAR3C231Jzvsx+Pflrxq8DTXJ0yWmJ8WWvNlRR2UcwVh60FIzjlOaHZOb4kF?=
 =?us-ascii?Q?JEb2RDvoSUIl1RnMjDHQ9xZ6DPkWG9xpcJ3kdvaWdZG7OlplEqE8QoECA/VQ?=
 =?us-ascii?Q?ILqjqj4R5at+RdrtPiSX98mDY/UyBuoxxMZylLfznNv/ZWWxJmqi4mSxY7Hx?=
 =?us-ascii?Q?Zwrb5/0Rrlhc1Xp2+BBvDCAXGszk5NkBrg6w8fSh1MnMuErgmCfnV5lFEuuq?=
 =?us-ascii?Q?RB8NIfXJMlYkDJkiTWtGKWTsT8EXpKx6pzPSOuyqbRAvdDfZtlsr2GqyDR/A?=
 =?us-ascii?Q?EdAXTymVdU+Jh9TgcU0Z0Cotb2nhh6rGbar9CTQGaXPLW5QkQ9mTqF8d07hs?=
 =?us-ascii?Q?rw9AMdB9/tmcPWmZX+LeDtyRSSz9Hl6jGn/860rafpO7TCYzKXeZkV7XV2c3?=
 =?us-ascii?Q?PdvlvYpijBAPaMUI2nPqHZyT2+aNai5YBfnoouj3yqnpbciq6Q20ePinepfE?=
 =?us-ascii?Q?d0dkSjLini327hRMuUuBsTDPZIlwWzR85qzuczHR81enGEMLzlmBvH1Gi8oV?=
 =?us-ascii?Q?JtoG26UqEBZs4hf0+9DRqkN1rDZA5HgIEqzWupIS7nhegVnp71fvLtW6Wrfj?=
 =?us-ascii?Q?SAxem7fZzZGdQS40i5536uxUMTvgcnVMIi4XdKhdZjLpMvVprII6L1dgeUed?=
 =?us-ascii?Q?GLL/gOmiihFT6PDvXo1gYHF48hBBN+hBbsTQh8bk0zjTU/0L5Ak7q7UehKjJ?=
 =?us-ascii?Q?fEUwPVCDgkEvfGUU9HbT+5ux7GqNZ7dgxKmUFnz2DSkxXz1uBtlP+/nrbzAq?=
 =?us-ascii?Q?qBfJ1WuusRBkhluALYR3hhXeHDFhu8Mx+IxFC2E+xRCtDFww94ZMTgl/3Lf0?=
 =?us-ascii?Q?xr9LNZ7n7ypgDaKgniWpAwDnj5/PLCLlElkCufQCNGr5lzNi7s68r18DyWyz?=
 =?us-ascii?Q?Llep6RpTofae7wQ6y/sodswWioryqshBLKSmo9FuTBBVUXe8qH4/psiF9Y+G?=
 =?us-ascii?Q?/h+aZOj6x6N51CpniSZx0DbGqaFV84Qonep4ahr4LtrDXP/hvdbjXinjIRpL?=
 =?us-ascii?Q?gTD7QG6Yip4FSEFsUio4v8LW?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF5E2ECE22CD8F4BA9F48919754D66C0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a4c9b15-1083-4f8c-c9a9-08d939a5edd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2021 19:58:27.1220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18rEciLX6Lxiqe2GreVIN2WzycrDjFvwvPGuEH46ApNpV3YeyElpElXWN7X54B8LknJZ1RoTFmcOKOWwbCJnKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 05:33:04PM -0700, Vinicius Costa Gomes wrote:
> Adds a way to configure which traffic classes are marked as
> preemptible and which are marked as express.
>=20
> Even if frame preemption is not a "real" offload, because it can't be
> executed purely in software, having this information near where the
> mapping of traffic classes to queues is specified, makes it,
> hopefully, easier to use.
>=20
> taprio will receive the information of which traffic classes are
> marked as express/preemptible, and when offloading frame preemption to
> the driver will convert the information, so the driver receives which
> queues are marked as express/preemptible.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  include/linux/netdevice.h      |  1 +
>  include/net/pkt_sched.h        |  4 ++++
>  include/uapi/linux/pkt_sched.h |  1 +
>  net/sched/sch_taprio.c         | 43 ++++++++++++++++++++++++++++++----
>  4 files changed, 44 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index be1dcceda5e4..af5d4c5b0ad5 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -923,6 +923,7 @@ enum tc_setup_type {
>  	TC_SETUP_QDISC_TBF,
>  	TC_SETUP_QDISC_FIFO,
>  	TC_SETUP_QDISC_HTB,
> +	TC_SETUP_PREEMPT,
>  };
> =20
>  /* These structures hold the attributes of bpf state that are being pass=
ed
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 6d7b12cba015..b4cb479d1cf5 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -178,6 +178,10 @@ struct tc_taprio_qopt_offload {
>  	struct tc_taprio_sched_entry entries[];
>  };
> =20
> +struct tc_preempt_qopt_offload {
> +	u32 preemptible_queues;
> +};
> +
>  /* Reference counting */
>  struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_=
offload
>  						  *offload);
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sche=
d.h
> index 79a699f106b1..830ce9c9ec6f 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -1241,6 +1241,7 @@ enum {
>  	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
>  	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
>  	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
> +	TCA_TAPRIO_ATTR_PREEMPT_TCS, /* u32 */
>  	__TCA_TAPRIO_ATTR_MAX,
>  };
> =20
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 66fe2b82af9a..58586f98c648 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -64,6 +64,7 @@ struct taprio_sched {
>  	struct Qdisc **qdiscs;
>  	struct Qdisc *root;
>  	u32 flags;
> +	u32 preemptible_tcs;
>  	enum tk_offsets tk_offset;
>  	int clockid;
>  	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
> @@ -786,6 +787,7 @@ static const struct nla_policy taprio_policy[TCA_TAPR=
IO_ATTR_MAX + 1] =3D {
>  	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] =3D { .type =3D NLA_S64 },
>  	[TCA_TAPRIO_ATTR_FLAGS]                      =3D { .type =3D NLA_U32 },
>  	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     =3D { .type =3D NLA_U32 },
> +	[TCA_TAPRIO_ATTR_PREEMPT_TCS]                =3D { .type =3D NLA_U32 },
>  };
> =20
>  static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
> @@ -1284,6 +1286,7 @@ static int taprio_disable_offload(struct net_device=
 *dev,
>  				  struct netlink_ext_ack *extack)
>  {
>  	const struct net_device_ops *ops =3D dev->netdev_ops;
> +	struct tc_preempt_qopt_offload preempt =3D { };
>  	struct tc_taprio_qopt_offload *offload;
>  	int err;
> =20
> @@ -1302,13 +1305,15 @@ static int taprio_disable_offload(struct net_devi=
ce *dev,
>  	offload->enable =3D 0;
> =20
>  	err =3D ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
> -	if (err < 0) {
> +	if (err < 0)
>  		NL_SET_ERR_MSG(extack,
> -			       "Device failed to disable offload");
> -		goto out;
> -	}
> +			       "Device failed to disable taprio offload");
> +
> +	err =3D ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT, &preempt);
> +	if (err < 0)
> +		NL_SET_ERR_MSG(extack,
> +			       "Device failed to disable frame preemption offload");

First line in taprio_disable_offload() is:

	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
		return 0;

but you said it yourself below that the preemptible queues thing is
independent of whether you have taprio offload or not (or taprio at
all). So the queues will never be reset back to the eMAC if you don't
use full offload (yes, this includes txtime offload too). In fact, it's
so independent, that I don't even know why we add them to taprio in the
first place :)
I think the argument had to do with the hold/advance commands (other
frame preemption stuff that's already in taprio), but those are really
special and only to be used in the Qbv+Qbu combination, but the pMAC
traffic classes? I don't know... Honestly I thought that me asking to
see preemptible queues implemented for mqprio as well was going to
discourage you, but oh well...

> =20
> -out:
>  	taprio_offload_free(offload);
> =20
>  	return err;
> @@ -1525,6 +1530,29 @@ static int taprio_change(struct Qdisc *sch, struct=
 nlattr *opt,
>  					       mqprio->prio_tc_map[i]);
>  	}
> =20
> +	/* It's valid to enable frame preemption without any kind of
> +	 * offloading being enabled, so keep it separated.
> +	 */
> +	if (tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]) {
> +		u32 preempt =3D nla_get_u32(tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]);
> +		struct tc_preempt_qopt_offload qopt =3D { };
> +
> +		if (preempt =3D=3D U32_MAX) {
> +			NL_SET_ERR_MSG(extack, "At least one queue must be not be preemptible=
");
> +			err =3D -EINVAL;
> +			goto free_sched;
> +		}

Hmmm, did we somehow agree that at least one traffic class must not be
preemptible? Citation needed.

> +
> +		qopt.preemptible_queues =3D tc_map_to_queue_mask(dev, preempt);
> +
> +		err =3D dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
> +						    &qopt);
> +		if (err)
> +			goto free_sched;
> +
> +		q->preemptible_tcs =3D preempt;
> +	}
> +
>  	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
>  		err =3D taprio_enable_offload(dev, q, new_admin, extack);
>  	else
> @@ -1681,6 +1709,7 @@ static int taprio_init(struct Qdisc *sch, struct nl=
attr *opt,
>  	 */
>  	q->clockid =3D -1;
>  	q->flags =3D TAPRIO_FLAGS_INVALID;
> +	q->preemptible_tcs =3D U32_MAX;
> =20
>  	spin_lock(&taprio_list_lock);
>  	list_add(&q->taprio_list, &taprio_list);
> @@ -1899,6 +1928,10 @@ static int taprio_dump(struct Qdisc *sch, struct s=
k_buff *skb)
>  	if (q->flags && nla_put_u32(skb, TCA_TAPRIO_ATTR_FLAGS, q->flags))
>  		goto options_error;
> =20
> +	if (q->preemptible_tcs !=3D U32_MAX &&
> +	    nla_put_u32(skb, TCA_TAPRIO_ATTR_PREEMPT_TCS, q->preemptible_tcs))
> +		goto options_error;
> +
>  	if (q->txtime_delay &&
>  	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
>  		goto options_error;
> --=20
> 2.32.0
>=20
