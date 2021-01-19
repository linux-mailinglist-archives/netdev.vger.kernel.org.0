Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685E62FAE34
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 01:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404485AbhASAxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 19:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732808AbhASAx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 19:53:27 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5206C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 16:52:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beYRGSLNpVyqHyb5bS/fjj+wtLDaxRZu0U1a9XBKp4HFf2em8zOJ/Y7ZwS0YKq7D0x8cr77uoVj83deY0FRF1bE3wag7Ok2QBwMIn9/hMfwgGntWEAh+NAnLRrwyi91zopZQxWIeSgVGpoiIziGnlGEkmrb8DNNwHr+cdU41j6TvHG0SJI2B23gf2+oIgZrlw1LZbUvmBOYXITeh+EECULZ9oBFATX4j1uY10Byi40budBIxSA13g1p03j8Jb2i0yKOPycpbCO+yyfhfa1dnhgpo4/1gOiA3U0jPb2h7shZcPwvA3vj4ZeQt7/3IZF0MTWoWQ52PpPhHBqKhuqEWRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqvcXfbcZtYN9HizbTi0A3cQTfqkfff/M1h5dP6+KqA=;
 b=goUf1MVwgnL0/Y3Y3l0q14z3K9G9w1UfOvyzHTno0Ycej2apJAdJ2Fw58/W4X79lvzM0i/waM0eE/+i/gaxa8oEmTbHXtk0/7rh96aD4Ytjnt9GwjlHZJyLY0aI0d9DwhQc7h6vWBOl2BXlX8wD2gSPs+14xcW77Xsg6VkWmzeC7d/ExouSBJC/KcrFZdqydwvOBLyJX3EAGaXFnpzuc39iC159JTZOWcpxrRmiM0Uyf0rIoPoHbioPN45FlIJHlVMX+FCT6z+jshg0p18YQ8+WYRHtqSgEuZIb1ggSR2xD1gGhImSy1Zmdehscd2NB8JR3UumcUCL17BHWsFoUu0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqvcXfbcZtYN9HizbTi0A3cQTfqkfff/M1h5dP6+KqA=;
 b=B7C4A90Fkmd8ITajg803MkaqROYGOOdZnPjalGMqjSj075gqKkHvnQy7CrbbaqNmiR3H1y2Tmc85oPF6rC34O7SPB7bXAM1qHKvqEaQDaPDbLfYdbYdwo3MjC70hoTiQBysZhfvv9iXV49awTt3ju2iknt2Aa2HUyxZlqbzdLe0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5135.eurprd04.prod.outlook.com (2603:10a6:803:62::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 00:52:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57%5]) with mapi id 15.20.3763.013; Tue, 19 Jan 2021
 00:52:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v2 1/8] ethtool: Add support for configuring
 frame preemption
Thread-Topic: [PATCH net-next v2 1/8] ethtool: Add support for configuring
 frame preemption
Thread-Index: AQHW7fvAelNa2S9rckKKXPrUPJypvKouHrsA
Date:   Tue, 19 Jan 2021 00:52:24 +0000
Message-ID: <20210119005224.yqrpyr2d7xawhbtf@skbuf>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
 <20210119004028.2809425-2-vinicius.gomes@intel.com>
In-Reply-To: <20210119004028.2809425-2-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9d1c9898-c54b-416b-01b8-08d8bc147cb2
x-ms-traffictypediagnostic: VI1PR04MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB51356FC787FC8C9EBA27FF8AE0A30@VI1PR04MB5135.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1dsRrAOnjZCzyUbDhjtCUL3dc4TfSWGxEXq7NBDksP3TuHeBbVC4Pfe+PuAeN3zl6G4Q0Z1nOAlq5h7wpQ5ZExs/IH6/JuJ2/44bx5QW6ybTdJrV3D/+zTpynbSEk45xlj0/v3LSDyAv9ejr9gLs1E+JJoimMRqJehizycrcLH4eoOzCmEqPn1rRPhr8mQUnV3QPYYyNYv/ZJ69A6vPh9dKNILgMo4lnJy9hpYmVOm0i4lX2+fNlFWmkZHV6YV8hMeh4n/l4w8N8R4cTZVEBrR+czbYpsKsraS0Fgu2FY/V4qjC0QvgNJyUDjFjhRmPNeeCizkwBEdMm2RvItbR5nki+/lizJImXFVcpOrnoV0vVNjjyFF6RXnx6t29T14rostwt4Gdd5CMeGqaPCD4/yQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(66946007)(66446008)(66556008)(66476007)(26005)(1076003)(4326008)(86362001)(7416002)(6506007)(71200400001)(76116006)(186003)(6916009)(6512007)(54906003)(5660300002)(478600001)(64756008)(316002)(8936002)(8676002)(6486002)(9686003)(83380400001)(2906002)(33716001)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YWy7TN7pSLpoajSqkcDeHCK9yiohkaLe4JszyD3vFROIL6VObhCidIlX32Hx?=
 =?us-ascii?Q?tuc12x/wWKFVNhGlsiaQ3uqMeYw/E2wJ2u9sXj+xThjZ849SE3NT//YdiLG1?=
 =?us-ascii?Q?+KcOB0d6F8DLFBYBseKhYD6EJ3M7tUgqmbMyqyjdo8Bnk8T8AKY5K6QGvKRF?=
 =?us-ascii?Q?dZSj6WyLsxxn7Zvn4wc65VzoStHoPLQaGnStsNEECa6aEUTEiBIWLkQ4Q/JL?=
 =?us-ascii?Q?ZcFuFyu+XqhVeLoka6kb96MLdqZV1ITojdU5xySNjgnaaQr48i4Kv2N/XKy7?=
 =?us-ascii?Q?8SmRG0Jvc2W37whBp5wijnVuaSobZ3BHZP747rkwCY23HPKffnqPSqGXypQq?=
 =?us-ascii?Q?jbWAuVcTbN1ydUe52AK0dKs5gm6Rsxt8II8w/43XuQpKV7fAfvpOLTB2x+ey?=
 =?us-ascii?Q?+oPnPztS0v34gLRXjMG5ovQ39eTV1i6GthLsAtKfOX6EkRidm3sa/9ypzRV8?=
 =?us-ascii?Q?k+LTiZpflX5P66s/ht0hZ+nXc0oAexDb/UjUtadVm8Z9AFuEZJ993JReID4i?=
 =?us-ascii?Q?/r4JOKWOg9EBVDQeiRjJSYpBdF7Tev8OgxO+L+CZbXakut0CSdTCuU7KSI3f?=
 =?us-ascii?Q?JKJltfDZWxp2reGPjxFi0FWPr+eh2by8kMUErpRckEEzlY9esIemm3gVNPc6?=
 =?us-ascii?Q?e8VEq1k2oDvNDIM7xYFf5KcDddS0Y1CUlLf0G8pn3Gqs2oI/LyRvDrTUTIvq?=
 =?us-ascii?Q?5mxBhMFlbUv8lS5XawpzqSBDw0+bVblgAzXtws7hwBFr2UJuMfLXZaE7gCMj?=
 =?us-ascii?Q?BvxEbpBJGkXaRqg62FZzBKoH1TvK3iJSpkQmaFhjPzn4l8Q1LWr0ORo0/gsb?=
 =?us-ascii?Q?Cu5Ntz19hytjfshmUqxOPbbO3GYHXf902ZgroYjFa2vzRbH+u0b+RJX48WKe?=
 =?us-ascii?Q?u2DxCfKqZ/1jnK+nt1dfLlBm15PybIVnXDNzrXSj3e9wIDiQ7VqopnzRIXAZ?=
 =?us-ascii?Q?UfVgZqUI7aNRt+uRT0t0FqjbYKEyIyVuQ5NZ+fSgrN+Pqqr9AXmxgcU0xb6v?=
 =?us-ascii?Q?pu6s?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <121E8EDDE169FF45BA7BDBB1624866C3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1c9898-c54b-416b-01b8-08d8bc147cb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 00:52:24.8904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6kJOpi9XTi3uTnwP+HWQ/Q0i1hEFjFh0UQ3pEENsIMWlsqgTnQZH46PsNIHnRU7Bcfp75Uo/6f1gMFimZAC6LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 04:40:21PM -0800, Vinicius Costa Gomes wrote:
> +int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct ethnl_req_info req_info =3D {};
> +	struct nlattr **tb =3D info->attrs;
> +	struct ethtool_fp preempt =3D {};
> +	struct net_device *dev;
> +	bool mod =3D false;
> +	int ret;
> +
> +	ret =3D ethnl_parse_header_dev_get(&req_info,
> +					 tb[ETHTOOL_A_PREEMPT_HEADER],
> +					 genl_info_net(info), info->extack,
> +					 true);
> +	if (ret < 0)
> +		return ret;
> +	dev =3D req_info.dev;
> +	ret =3D -EOPNOTSUPP;
> +	if (!dev->ethtool_ops->get_preempt ||
> +	    !dev->ethtool_ops->set_preempt)
> +		goto out_dev;
> +
> +	rtnl_lock();

I'm a bit of a noob when it comes to ethtool (netlink or otherwise).
Why do you take the rtnl_mutex when updating some purely hardware
values, what netdev state is there to protect? Can this get->modify->set
sequence be serialized using other locking mechanism than rtnl_mutex?

> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out_rtnl;
> +
> +	ret =3D dev->ethtool_ops->get_preempt(dev, &preempt);
> +	if (ret < 0) {
> +		GENL_SET_ERR_MSG(info, "failed to retrieve frame preemption settings")=
;
> +		goto out_ops;
> +	}
> +
> +	ethnl_update_u8(&preempt.enabled,
> +			tb[ETHTOOL_A_PREEMPT_ENABLED], &mod);
> +	ethnl_update_u32(&preempt.add_frag_size,
> +			 tb[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE], &mod);
> +	ret =3D 0;
> +	if (!mod)
> +		goto out_ops;
> +
> +	ret =3D dev->ethtool_ops->set_preempt(dev, &preempt, info->extack);
> +	if (ret < 0) {
> +		GENL_SET_ERR_MSG(info, "frame preemption settings update failed");
> +		goto out_ops;
> +	}
> +
> +	ethtool_notify(dev, ETHTOOL_MSG_PREEMPT_NTF, NULL);
> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +out_rtnl:
> +	rtnl_unlock();
> +out_dev:
> +	dev_put(dev);
> +	return ret;
> +}=
