Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E136152E843
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 11:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbiETJGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 05:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347557AbiETJGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 05:06:17 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995FD38DB1
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:06:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4R6K27h6wICkppuWtZiCaN40snBAfyOyBJotaVGyGX/niGJZiTjzLUS1msjDmoqwBBDiBmL70oBXHxNrCXb7rMyPIPUg5icQ3KUf6eIHg94xlTk0EL6QLycoeysrldwBrvpCokOkQgLor16EY3p+rxauvY1ZVMFcEPJxtLqW7c/q08TlaUHtKQnM2WLN/ClphiMrc5IrLO2KwShwx03FXeZ5E/KhwrRYKkQxI4zohJDTpBP0kh6UJsDVBZXe0qbQbFKjbzRkXYXw1LGQ80Jso4XA0IBk20zZsX7+mcsMORMCWDxDhiXgPZpd2nKGXyoLwW+xEi1Ai+yco3Cp/MvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ADk6v+4182BpuHknvF3Npcmr9hcnY1ePkFQQqAQuJs=;
 b=KXX/j3l2L0HvsV1uQM4O8V46VSqFBGnQHR6yOqrV1mHnx/TDD4b7flHUABpg+/hTYqeaW6LCdv+83mi8U3NT0ImbvYSYaYbJpZhHhtyJtRq9+44fjBi9aNNzw4uHToJjsyuD4Ht9REAfgd+x5jw595GGEJFKCKbVQrYdWyzvM80GV3W2M3IX0Io6Yg0u9Yu1//zO/XSj59ev2KCtDGLCRPK+Ld9+gKZM3KwbSf6enIr9xluGzircC3yHpvBjrmZRVcxgt16EiZf3IU2M879aP8vIqbQVj/fpT3QE3JiBzG0YAgor8OxgcuakTaFGVaCc1ritYfDuMS79cYTVC0HUag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ADk6v+4182BpuHknvF3Npcmr9hcnY1ePkFQQqAQuJs=;
 b=EIvGgTTzxnJHUDFPNeFxtC8PxTzLHPkIrYiFd9+TOIy+eKxEXNppt5PFu9mWJiV4nwXGAF3QYb3uGZGZ1LWlStkdAwk5np8JlfxIbJnr2dgGlJOX9FZsnWZqnICD/9BnVCVRuLrA8W15xDTW7ENWTvSAU/H+x3naxudlUGA+mYU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6827.eurprd04.prod.outlook.com (2603:10a6:10:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 09:06:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 20 May 2022
 09:06:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v5 01/11] ethtool: Add support for configuring
 frame preemption
Thread-Topic: [PATCH net-next v5 01/11] ethtool: Add support for configuring
 frame preemption
Thread-Index: AQHYa+cuwI/D9jUrrkKPkYqGQR9M/K0neeSA
Date:   Fri, 20 May 2022 09:06:12 +0000
Message-ID: <20220520090611.5gcguajnucyj7uli@skbuf>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
 <20220520011538.1098888-2-vinicius.gomes@intel.com>
In-Reply-To: <20220520011538.1098888-2-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b397739-d748-46c6-bba0-08da3a3ffcf5
x-ms-traffictypediagnostic: DB8PR04MB6827:EE_
x-microsoft-antispam-prvs: <DB8PR04MB68273B2C7F528DD3BA51C77CE0D39@DB8PR04MB6827.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eYu1OUoI49uFOsDPT1NiP0zzhBXku6420q89nk5HqSDjoTeDrNjudkyand7siaSkcEF7242RHM7BYXcNlDjAMkb5DG9RaHNoeWbsjlMeOHD+9sA6SOCLOgiEONkz1JkXseAnaO8Xr8O+HlidqMaJhje1DnVFDsXXY5+uoL2WnFgRP4Yw3ljUFCKY1fm9z6PINQQevS1C7unzfHZsVe0Ry6w0wxlJ+XdYjm7oN8Y242lFNNV5BOA4EdNjWo4jRzCYuHGU2Iu7KPRcUU7O6hZhRHm1xiFFQMZhpg1pOlOO9SYjweC9y2Zb0xQaRS+LJYk7K0Ner/lPKO12XQ+I1egeq547798xY5RC9CfyyKZ7NvsoFKIC6PdtH0nNwhNA7F9uykVe+SAAKlhl/tzzA8CJSY0gFRPcvxo+7jkqKAx5XLcakWNqiBWWUphmr8I2HRt1cBicGXk3GDJ2Q6LcXUUqFCgM2sxpxJ3u99m9NkNnA3dBFJ646+/89oD0chb8cZi8tNcOgqfJUgqRsttCsbbFZRC1jJtktoU/s6OoZjrxzQtponO9bG0RcAhAkJXHjXFyJHuaHUNcAW7kyioIXcImuiVtLXsfsO2uBL9EoHAC7C6nsQHdAIFtNrRUYxgXfotjWcRthHDx8uIgH7gMnNrV1qPseAYR9tnQVmSeRnqNfbbGK7WMzfcZE2tPwAJq0ZX/XxEiS1IwKQCHQ6EANo0qsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(186003)(8936002)(122000001)(508600001)(6506007)(1076003)(6916009)(54906003)(33716001)(83380400001)(4326008)(38070700005)(38100700002)(66946007)(71200400001)(64756008)(91956017)(66446008)(66556008)(66476007)(76116006)(8676002)(26005)(6486002)(44832011)(86362001)(6512007)(9686003)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I77QrgKXDy3h1FQHwh9AgWYFChTGZnkanfaK6csPAOD3xLE0TbsyOst5nBDM?=
 =?us-ascii?Q?70EgZZw6UGZaw24rdgppo/3Uh5nCEZFxBcvRQcPWA/hU76V4SLOGXqxjbIyQ?=
 =?us-ascii?Q?yTdFzCcizlP+n+2kI8/GqyL88QALxmYSr9lYn42TOK6Zj/fquT1UQZTozUKC?=
 =?us-ascii?Q?xFikxvAmFS/FIzyjypKckDOn5+dHysjA9vfyeBNHm246wAbbefFCGVbB2X7x?=
 =?us-ascii?Q?NUgkInp8UNFpFI1fmguRhKWey9ubI6u7sajs6EUkVOGARaOKdojlZ7Y7ISFz?=
 =?us-ascii?Q?EYUeexFcB3CxIfMGR+souWmRwuBroPP2s9RcY+4VJde0LsdAF8PePOkmg4T7?=
 =?us-ascii?Q?B8h93BhFkrEB2dhvUB7Kg6h2N93k16VtmHeeLl0HTWx2x1BQuWaDAlwIes1R?=
 =?us-ascii?Q?ZjunREPWQeMIJ8URBZ6bBW3VmaNO2lDMz+NWBqCXab3XEWq3DknjK2y4sjPt?=
 =?us-ascii?Q?L/+54twG1hZTIG7gDB5BNiYL8L768mfnyZrqOZMW9QZmPC73nS+teDnaTk8B?=
 =?us-ascii?Q?Rjwq7yG77Sl28422/RogkeQgstw/cW6D0CryxVzlzjLMgNT/9EFT0qiKk+pH?=
 =?us-ascii?Q?XQh0OJocrB7KJIA7971bVedQRdZAfMq+WrTzj82tA8SNKfy5480ShYqs7tl+?=
 =?us-ascii?Q?q/OnyL30VHqD85YM622A9Zh7QKogQVrxUdDyjBQSg3E1+1W5Cr34CKLcdj1R?=
 =?us-ascii?Q?3rhCurq+iCQkRKRL6KQ+LUu8h6FMzmKnf5/MYB944iPD3l5Mv5F8SjRB+pht?=
 =?us-ascii?Q?TfLMKO/H/bWSLSDuCY7uXwaD2PuiOUNUi1eNX+S2JHu9RSEHft2WtFrWKezh?=
 =?us-ascii?Q?79EzjWobPWe3OP9SURt/HETaSEnUdNGROYjr7Fn+YIJXeHOXY+SVdUWJwTkd?=
 =?us-ascii?Q?ofyw3Z0N90+E9CsBom2nB2dDcvHga8toZbLXHWmLJ7Upep2nV44/lYg9+q57?=
 =?us-ascii?Q?d1bv+JTgXBv2khe73zNDeWSLVU30LC9q2aPG+1aOO4cWPvvQJhQl5jj99rBj?=
 =?us-ascii?Q?NRRtLQBpLrMjeb6gJJ2MlO0Vk82mDxCeR4GVRfazTivrXJLtzy5i4kYgTdTy?=
 =?us-ascii?Q?hWR2PENFA/AOHE3qVr3xmWEOFFEA9h9cJM8dk5Q6acZytJjRb9XqnhPv4cRU?=
 =?us-ascii?Q?u25Snuuem2d7udZq54af64/tktQwLDw4KMzuXj5d4ZctVxIwqajIButEMNbk?=
 =?us-ascii?Q?POunPGVLkmF4roqUdgE1gcwuWECyHB22EhKXSHLZkHHMEYAwWS5+c+FN5L6l?=
 =?us-ascii?Q?AvmmBmDHYUwYYVzrTsgcofJ2L/5nbd3417KcrF3B2D8IZIsh1cjhLzIanHKm?=
 =?us-ascii?Q?GWB11/qclVmACRthimf5YTAajM1TGiWgaZF1jSIogp+slBqeWgOD4i15LFlL?=
 =?us-ascii?Q?xlNAyKLUy/vIrhKrygc7g7/s81HTMcUyvoBEalcvYNpyHPDV/lCL489GN8GD?=
 =?us-ascii?Q?S2LorZ/+VbWSD5pLMaMeAyVsS2OfqdOASRf3Ch5MvPAWk4PSw4wB62hEaRLk?=
 =?us-ascii?Q?qY5fLqU9fahdRWU0qqxTdcMZq/jiUNiuT19kXpZOlakB0kcPDUtXnew0OQZ/?=
 =?us-ascii?Q?kGrGe65pWrKaeN0IfcKFsClzznbCUXrjKwamcvckdykrRWt2wW8V9xayBapu?=
 =?us-ascii?Q?qEzOMamqXebQBb8KuwJfkvYCWjN5vX0Hk5HrVDrpwS3O3RJBNgeZhlKqCkk8?=
 =?us-ascii?Q?PSPKMAjYGbswZ4AhpX2qt27LnUiCPYNNMyxAldXVfLo6e1/J9lCgUNL6gQTu?=
 =?us-ascii?Q?63YgZCXwD/PBG4RafM/6j5DuEi5V0SU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0F08D51A3F5C24D9FB093CBF0E397A4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b397739-d748-46c6-bba0-08da3a3ffcf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 09:06:12.7347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xLnsF2GSn26Wq2Epso+qShao5e0zkAQlcU7Sq2715NDFPXP1tchO6Hvk8othJIvR7ShBQO8jo2lhlCbs9JXb2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6827
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Thu, May 19, 2022 at 06:15:28PM -0700, Vinicius Costa Gomes wrote:
> Frame preemption (described in IEEE 802.3-2018, Section 99 in
> particular) defines the concept of preemptible and express queues. It
> allows traffic from express queues to "interrupt" traffic from
> preemptible queues, which are "resumed" after the express traffic has
> finished transmitting.
>=20
> Expose the UAPI bits for applications to enable using ethtool-netlink.
> Also expose the kernel ethtool functions, so device drivers can
> support it.
>=20
> Frame preemption can only be used when both the local device and the
> link partner support it.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

This looks good to me. Just one comment below.

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
> +
> +	ret =3D -EOPNOTSUPP;
> +	if (!dev->ethtool_ops->get_preempt ||
> +	    !dev->ethtool_ops->set_preempt)
> +		goto out_dev;
> +
> +	rtnl_lock();
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
> +	ret =3D ethnl_update_bitset32(&preempt.preemptible_mask, PREEMPT_QUEUES=
_COUNT,
> +				    tb[ETHTOOL_A_PREEMPT_PREEMPTIBLE_MASK],
> +				    NULL, info->extack, &mod);
> +	if (ret < 0)
> +		goto out_ops;
> +
> +	ethnl_update_bool32(&preempt.enabled,
> +			    tb[ETHTOOL_A_PREEMPT_ENABLED], &mod);
> +	ethnl_update_u32(&preempt.add_frag_size,
> +			 tb[ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE], &mod);
> +	ret =3D 0;
> +	if (!mod)
> +		goto out_ops;
> +
> +	ret =3D dev->ethtool_ops->set_preempt(dev, &preempt, info->extack);
> +	if (ret < 0) {
> +		GENL_SET_ERR_MSG(info, "frame preemption settings update failed");

If you pass the extack to ->set_preempt, would you consider not
overwriting it immediately afterwards on error?

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
> +}
> --=20
> 2.35.3
>=
