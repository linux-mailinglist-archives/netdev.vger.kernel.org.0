Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E945A3A55
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfH3P2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:28:19 -0400
Received: from mail-eopbgr140052.outbound.protection.outlook.com ([40.107.14.52]:17430
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727751AbfH3P2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 11:28:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW0d4YJuQq1k1Nn3OXVRVCEBMvFkBhgMP48QMzkba/nvvHKWvaUmh5oGNQHYqdF3aqtx2lAccEgFcQpp43EkEqDr12cDo7nARyrioYobhB+IwefbztxccCIpU3UPuSMQtbTM37HqcnzBUJw6xQRuvWvG7AAUS50fxEqGfj+VEh4Uu9PPyXsbwnI00WvfXVsdYs+H0GlEn4tics0BHprHTzHXvr9tmGnXV75GgAdFlEBT836LAajP9ruiE0UBHU40tX/96HojnjGX7KFGbIVbH4d9ojTSuOPYJxYjCOVq4XOPY6nOGd4kq/TbPv6tZSJsvPbJQ1xbMUxO7c12Vsbv9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VQa6E3CkgJHtgcuxvbRig10SLCRmq8eVgnjz5maXkw=;
 b=BnJAcr4uyg7N5LBQlFaUwPmA+eSd7vdks18JJNuIdeFYcOG1ZPfM6l6VuSqP88K8TAcqo8Ec53eCyKDFLklmxMYHi/ajeshRF8UcqmjDArp3AnQ3cOwiTdXaoCsEdu7e3Wd3GgZjnDt7LDPCM80TJOYsXuWsDXVE3a1fL31QzAUbrAEevXI00XZqGVKmsw33/MFaz+Rn92TPfrLz0teQS4VtHfvoxSBqt5HaKqk7t+f5wFmYBg0cGb1+j+8ZXMBHXmqzGlqM0uG5lGnOAmW8tzFVUr8CFEOQJ5snFELerRpl3TvPYbhDVrTpAQEEl87bBlBUrrRvVF5Za7a0frHpLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VQa6E3CkgJHtgcuxvbRig10SLCRmq8eVgnjz5maXkw=;
 b=GRN0MrRachArF7iumLM6J6km+HmfhzqqWk74xr0R/UK5YoWsOOzWZt/09+jaXpBd+xTP5MFBiCliqGzI+/FRAlfujSA45YBBL4alOcePeiUgGC6m5/Q0WhMGlEbbN3luC9AvxovJQjsnz/C8NcAwmvz3iW9x8AwFPp6DkEauMqE=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4381.eurprd05.prod.outlook.com (52.133.13.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Fri, 30 Aug 2019 15:28:13 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 15:28:13 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: Re: [PATCH net-next 3/4] net: flow_offload: mangle action at byte
 level
Thread-Topic: [PATCH net-next 3/4] net: flow_offload: mangle action at byte
 level
Thread-Index: AQHVXs1uWgEKdBtxq0ahSHv/bMZOiacT0W0A
Date:   Fri, 30 Aug 2019 15:28:13 +0000
Message-ID: <vbfzhjqu0zf.fsf@mellanox.com>
References: <20190830005336.23604-1-pablo@netfilter.org>
 <20190830005336.23604-4-pablo@netfilter.org>
In-Reply-To: <20190830005336.23604-4-pablo@netfilter.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0468.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::24) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64eaa532-ca69-4e18-38f0-08d72d5eabd1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4381;
x-ms-traffictypediagnostic: VI1PR05MB4381:|VI1PR05MB4381:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4381E36F55E1EAD983F35B02ADBD0@VI1PR05MB4381.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(199004)(189003)(446003)(25786009)(316002)(6506007)(102836004)(6916009)(66066001)(6436002)(256004)(386003)(14444005)(53936002)(8936002)(5660300002)(71190400001)(8676002)(81156014)(81166006)(66476007)(66556008)(186003)(6512007)(66946007)(26005)(6246003)(64756008)(6486002)(71200400001)(66446008)(4326008)(305945005)(508600001)(2906002)(14454004)(99286004)(7736002)(3846002)(229853002)(6116002)(36756003)(2616005)(476003)(76176011)(54906003)(11346002)(52116002)(486006)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4381;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BICmo0N+hmbx/blR8FB95evGiy1+Ej4iY+VwMv1ML3xphedPyBPaOcmw57UQWlGa9iWEspUpeLw/YAXJmL6ZQ2CEwKcvezYzgvk3TEh18ad5ONN0HAx80YEV+BYsvNtg2dcA7QKORjZ8Dp+9oTzFkMoM2dB/g0AE/inev2DVsAeVvGmla/x2nxeO9aAIYjD1IZIg0qyO2/uBG7B+D0Ycs3uh/YQReIk+8S37DjUIcmaaNm68JU+y9bkbJThSiE8YeDFMl7y6PWr0tljuTIg0vo0Xlo4ZnpfKRlMLLSJ24V2sl8bKtffD3/KoPinuY7m7AEslioTbFjVp7zhkBHo+RqqN9ZLVdzGZNkfPlV38fXPS8AmCTT64XiXdWD6CWeK56J7t6MGKTbWeNtMOgTi7sd8Qvt6T3FUoAT+yo0W/dCA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64eaa532-ca69-4e18-38f0-08d72d5eabd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 15:28:13.1754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: etNbVR6wK4zkNr/fqbBpTyydNtLn3c3uPTYP516XFmO0g4GBHeYAiH0NbDEBiDssSMdhmEOaZfRepvDyraJPjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4381
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 30 Aug 2019 at 03:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The flow mangle action is originally modeled after the tc pedit action,
> this has a number of shortcomings:
>
> 1) The tc pedit offset must be set on the 32-bits boundaries. Many
>    protocol header field offsets are not aligned to 32-bits, eg. port
>    destination, port source and ethernet destination. This patch adjusts
>    the offset accordingly and trim off length in these case, so drivers g=
et
>    an exact offset and length to the header fields.
>
> 2) The maximum mangle length is one word of 32-bits, hence you need to
>    up to four actions to mangle an IPv6 address. This patch coalesces
>    consecutive tc pedit actions into one single action so drivers can
>    configure the IPv6 mangling in one go. Ethernet address fields now
>    require one single action instead of two too.
>
> The following drivers have been updated accordingly to use this new
> mangle action layout:
>
> 1) The cxgb4 driver does not need to split protocol field matching
>    larger than one 32-bit words into multiple definitions. Instead one
>    single definition per protocol field is enough. Checking for
>    transport protocol ports is also simplified.
>
> 2) The mlx5 driver logic to disallow IPv4 ttl and IPv6 hoplimit fields
>    becomes more simple too.
>
> 3) The nfp driver uses the nfp_fl_set_helper() function to configure the
>    payload mangling. The memchr_inv() function is used to check for
>    proper initialization of the value and mask. The driver has been
>    updated to refer to the exact protocol header offsets too.
>
> As a result, this patch reduces code complexity on the driver side at
> the cost of adding ~100 LOC at the core to perform offset and length
> adjustment; and to coalesce consecutive actions.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

[...]

> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index e30a151d8527..e8827fa8263a 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3289,11 +3289,128 @@ void tc_cleanup_flow_action(struct flow_action *=
flow_action)
>  }
>  EXPORT_SYMBOL(tc_cleanup_flow_action);
>
> +static unsigned int flow_action_mangle_type(enum pedit_cmd cmd)
> +{
> +	switch (cmd) {
> +	case TCA_PEDIT_KEY_EX_CMD_SET:
> +		return FLOW_ACTION_MANGLE;
> +	case TCA_PEDIT_KEY_EX_CMD_ADD:
> +		return FLOW_ACTION_ADD;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +	return 0;
> +}
> +
> +struct flow_action_mangle_ctx {
> +	u8	cmd;
> +	u8	offset;
> +	u8	htype;
> +	u8	idx;
> +	u8	val[FLOW_ACTION_MANGLE_MAXLEN];
> +	u8	mask[FLOW_ACTION_MANGLE_MAXLEN];
> +	u32	first_word;
> +	u32	last_word;
> +};
> +
> +static void flow_action_mangle_entry(struct flow_action_entry *entry,
> +				     const struct flow_action_mangle_ctx *ctx)
> +{
> +	u32 delta;
> +
> +	entry->id =3D ctx->cmd;
> +	entry->mangle.htype =3D ctx->htype;
> +	entry->mangle.offset =3D ctx->offset;
> +	entry->mangle.len =3D ctx->idx;
> +
> +	/* Adjust offset. */
> +	delta =3D sizeof(u32) - (fls(ctx->first_word) / BITS_PER_BYTE);
> +	entry->mangle.offset +=3D delta;
> +
> +	/* Adjust length. */
> +	entry->mangle.len -=3D ((ffs(ctx->last_word) / BITS_PER_BYTE) + delta);
> +
> +	/* Copy value and mask from offset using the adjusted length. */
> +	memcpy(entry->mangle.val, &ctx->val[delta], entry->mangle.len);
> +	memcpy(entry->mangle.mask, &ctx->mask[delta], entry->mangle.len);
> +}
> +
> +static void flow_action_mangle_ctx_update(struct flow_action_mangle_ctx =
*ctx,
> +					  const struct tc_action *act, int k)
> +{
> +	u32 val, mask;
> +
> +	val =3D tcf_pedit_val(act, k);
> +	mask =3D ~tcf_pedit_mask(act, k);
> +
> +	memcpy(&ctx->val[ctx->idx], &val, sizeof(u32));
> +	memcpy(&ctx->mask[ctx->idx], &mask, sizeof(u32));
> +	ctx->idx +=3D sizeof(u32);
> +}
> +
> +static void flow_action_mangle_ctx_init(struct flow_action_mangle_ctx *c=
tx,
> +                                        const struct tc_action *act, int=
 k)
> +{
> +	ctx->cmd =3D flow_action_mangle_type(tcf_pedit_cmd(act, k));
> +	ctx->offset =3D tcf_pedit_offset(act, k);
> +	ctx->htype =3D tcf_pedit_htype(act, k);
> +	ctx->idx =3D 0;
> +
> +	ctx->first_word =3D ntohl(~tcf_pedit_mask(act, k));
> +	ctx->last_word =3D ctx->first_word;
> +
> +	flow_action_mangle_ctx_update(ctx, act, k);
> +}
> +
> +static int flow_action_mangle(struct flow_action *flow_action,
> +			      struct flow_action_entry *entry,
> +			      const struct tc_action *act, int j)
> +{
> +	struct flow_action_mangle_ctx ctx;
> +	int k;
> +
> +	if (tcf_pedit_cmd(act, 0) > TCA_PEDIT_KEY_EX_CMD_ADD)
> +		return -1;
> +
> +	flow_action_mangle_ctx_init(&ctx, act, 0);
> +
> +	/* Special case: one single 32-bits word. */
> +	if (tcf_pedit_nkeys(act) =3D=3D 1) {
> +		flow_action_mangle_entry(entry, &ctx);
> +		return j;
> +	}
> +
> +	for (k =3D 1; k < tcf_pedit_nkeys(act); k++) {
> +		if (tcf_pedit_cmd(act, k) > TCA_PEDIT_KEY_EX_CMD_ADD)
> +			return -1;
> +
> +		/* Offset is contiguous and type is the same, coalesce. */
> +		if (ctx.idx < FLOW_ACTION_MANGLE_MAXLEN &&
> +		    ctx.offset + ctx.idx =3D=3D tcf_pedit_offset(act, k) &&
> +		    ctx.cmd =3D=3D flow_action_mangle_type(tcf_pedit_cmd(act, k))) {
> +			flow_action_mangle_ctx_update(&ctx, act, k);
> +			continue;

Hi Pablo,

With this change you coalesce multiple pedits into single
flow_action_entry, which means that resulting rule->action.num_entries
is incorrect because number of filled flow actions entries will be less
than num_actions. With this, I get mlx5 rejecting such flow_rule with
"mlx5_core: The offload action is not supported." due to trailing
unfilled flow action(s) with id=3D=3D0.

> +		}
> +		ctx.last_word =3D ntohl(~tcf_pedit_mask(act, k - 1));
> +
> +		/* Cannot coalesce, set up this entry. */
> +		flow_action_mangle_entry(entry, &ctx);
> +
> +		flow_action_mangle_ctx_init(&ctx, act, k);
> +		entry =3D &flow_action->entries[++j];
> +	}
> +
> +	ctx.last_word =3D ntohl(~tcf_pedit_mask(act, k - 1));
> +	flow_action_mangle_entry(entry, &ctx);
> +
> +	return j;
> +}
> +
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts, bool rtnl_held)
>  {
>  	const struct tc_action *act;
> -	int i, j, k, err =3D 0;
> +	int i, j, err =3D 0;
>
>  	if (!exts)
>  		return 0;
> @@ -3366,25 +3483,9 @@ int tc_setup_flow_action(struct flow_action *flow_=
action,
>  		} else if (is_tcf_tunnel_release(act)) {
>  			entry->id =3D FLOW_ACTION_TUNNEL_DECAP;
>  		} else if (is_tcf_pedit(act)) {
> -			for (k =3D 0; k < tcf_pedit_nkeys(act); k++) {
> -				switch (tcf_pedit_cmd(act, k)) {
> -				case TCA_PEDIT_KEY_EX_CMD_SET:
> -					entry->id =3D FLOW_ACTION_MANGLE;
> -					break;
> -				case TCA_PEDIT_KEY_EX_CMD_ADD:
> -					entry->id =3D FLOW_ACTION_ADD;
> -					break;
> -				default:
> -					err =3D -EOPNOTSUPP;
> -					goto err_out;
> -				}
> -				entry->mangle.htype =3D tcf_pedit_htype(act, k);
> -				entry->mangle.mask =3D ~tcf_pedit_mask(act, k);
> -				entry->mangle.val =3D tcf_pedit_val(act, k) &
> -							entry->mangle.mask;
> -				entry->mangle.offset =3D tcf_pedit_offset(act, k);
> -				entry =3D &flow_action->entries[++j];
> -			}
> +			j =3D flow_action_mangle(flow_action, entry, act, j);
> +			if (j < 0)
> +				goto err_out;
>  		} else if (is_tcf_csum(act)) {
>  			entry->id =3D FLOW_ACTION_CSUM;
>  			entry->csum_flags =3D tcf_csum_update_flags(act);
> @@ -3439,8 +3540,7 @@ int tc_setup_flow_action(struct flow_action *flow_a=
ction,
>  			goto err_out;
>  		}
>
> -		if (!is_tcf_pedit(act))
> -			j++;
> +		j++;
>  	}
>
>  err_out:
