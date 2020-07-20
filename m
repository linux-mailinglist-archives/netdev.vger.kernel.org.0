Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197E122636A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgGTPer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:34:47 -0400
Received: from mail-bn7nam10on2136.outbound.protection.outlook.com ([40.107.92.136]:6753
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726012AbgGTPeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 11:34:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kV1LKvQQ4+R9LcyIL/zxLeBujFMO+0S/K5c+c9D34UuA76YHtdneZHF7w+q0al4MVMm4Mfnux3VycjPZRpAj+Q9/FxQQABQa147MqN43EDajk8bVm6TxoD2eFwmpR0LOe7ZaGXA5A9tSxv65vBZJqnyj9jKZ/v9yicTr1eb6xtWAxwS3XDPHR5GrRiodKmGT2QsItRE7D/B7dKQQ/Obv/IOkGA0+3+IS9T+UUVOrdNdb7+HR+wHdcdHIDvRp7ixGqr4RE5JEkQfHB0aeSK/7L+Skj8ZFSGN4jSqi275HUHF4qhVtw2ZjNJFoUF5khk/nIageLDhecBOr+yw/KSB9sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qwAEurXmja79MC21O56Etup71punKIWAVmkXaxxzZQ=;
 b=GfVn0XB0gQYudB3qlHVF39UZkdDvXGVhmZan03KJSMzta2qav5z5Tij4ncikhQWaA9YIDPF8QqAk50gAIifMlUb1WL/+koFRB9nFB50dbgh9UcDQiPp+q3AjAN3wz/MlJ82W7mmwrUrXkzjaZVvLWSw5qS2eqSQI49JZevGpx8DkVv8yDBN59WxJ610iXpkTUC6wjnmDQFrlZHJpIj0m0rmn3ZPjMCxHoR9p9L4k/Yng+cL4IDbPNuSom8xICruWT3M223PmiQ0H4Hwh7e9mwSnEnhn+NcvdLuzGDW3Ct5A6BQKeoVdwiT3//DYg2TSRG2SlCkpoTNiV3wlx0tkxrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qwAEurXmja79MC21O56Etup71punKIWAVmkXaxxzZQ=;
 b=J8pHEjx83p3ZWjgug2it6mwN77BpFspfMLntn4pzetwwDnXf53ckqtosUyrnELnnqQURcb+MacZ/pbaLjNQVH8QQXmd5fX7jE+1UQaNO7x4hXRk19vq15ZOFj+Lp+VsDUKJrEboYN2px0KXXJg0vUOofAHYd38hwmNh9uOiKgYc=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com (52.132.20.146) by
 BL0PR2101MB0932.namprd21.prod.outlook.com (52.132.20.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.0; Mon, 20 Jul 2020 15:34:44 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%5]) with mapi id 15.20.3239.001; Mon, 20 Jul 2020
 15:34:44 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Chi Song <Song.Chi@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Topic: [PATCH v3 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Index: AdZeZbrV+t5rWB2ETh+y8GF8jKdgPAAQ7v2g
Date:   Mon, 20 Jul 2020 15:28:20 +0000
Message-ID: <BL0PR2101MB09304D80A094F616253EF2F7CA7B0@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <HK0P153MB0275B086FDE4B26D39E41059987B0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <HK0P153MB0275B086FDE4B26D39E41059987B0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-20T07:16:58Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=04b9772d-b507-4872-a4fc-786c63f4656c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 36d18edc-e094-437f-0be6-08d82cc26d45
x-ms-traffictypediagnostic: BL0PR2101MB0932:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB09321495F21CCC47FEA8B31FCA7B0@BL0PR2101MB0932.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xTKTi8A+AqgfPCi3dB5FBxOdpI9l9odilCPraSqkUZlxwECeNJ/bPLiwG5XgEbqYjGhtRXyivUEm1H1pVTYX5Yc0q8Vwf1Nrm8VPnfA2Oxyc6vISE0MN+fAjFP9puPqf0Gup9U/gCVTImV3UPucBmCa5bwu1iYsOIPTavgGufBC7FaonhD++RdDmjAMfAx9k5c5MYPYMbzRdRfc09gEqWMa6fhrPgeea4j8E9JukdCoMuGXOxqY86IoFbezFzuLxaF2bT7tIfOm1p+bym3I8u8mK4om+TsrTlvnXikIqvBbW5AIEn+IiCxcCJz67SM9keFwquzZSwguzaiWNDsxceg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(82950400001)(82960400001)(52536014)(110136005)(5660300002)(10290500003)(83380400001)(4326008)(86362001)(316002)(54906003)(7696005)(8676002)(53546011)(55016002)(71200400001)(6506007)(8990500004)(8936002)(9686003)(66476007)(66556008)(6666004)(66946007)(64756008)(76116006)(2906002)(26005)(186003)(478600001)(33656002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OmQ7nMFZuSsXPysUM6umVZBn9UHJiUKqldOvkMjHbZ7NfAT3sbVhSKWqNBFV+C89RujBTpyRTelkYGzjJis3tLG08lxllM4s/9QUeohluNsfHltWUVM1B/iF9NoE56OUntoCNQH1DZPagxxiZnFJroD5MrKRIredndGvWmbHfsBrKEj4MVa5x0+OJiUdFQWwdcvSOJr6Rrx2/Nfb49RSr1WRxMZWTZs1sgD4HvC1eZ9ZcrMvcoYhmlxXVgh409Roza511a1tq9gCcO2vgpiOT01v6w8srVvXElwVeNqddUathu/UXBxHKjy5ZAq/fBKdh1uhLbHcg1eaHIMpZpwnCoscL6OUmnJ9CBqnh5+aphB5jCVJn2nJwbu9e2NqQBDvQnyOZx9jK7dj8Nj8870vjNeRoRnxH3lUukAS08UIPN3ZpIjgrur/ZSyjXnDh06VBdW4uNWcE9NPnxnwo8SdEut9N1QQkaQTKDDybFNH9h4SUk1bsaXj7Idi1DUrsgve0EUku2rRVAtE7mQmUwIXCKpeggiRUjrFwV5LkwakhUYqsb6RophaX3Z71wsjxmh8ZhKxlIMdtKnj/dnO2WgmgfEhFsYE8gOYKd3WTHy1Fd9zKYkas4THzOVEdKAOUxdXjWzLZZSLVrjmAVrO9bEagJg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d18edc-e094-437f-0be6-08d82cc26d45
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 15:28:20.4515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yaPD+Ae2kcwjLQfG7XPy7A4WVUSaLrQq8Qb+5VyA7/nX/oHeymYTXmpEMc7rrv5z0L7TTl3IWz80oJyewLhG4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0932
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Chi Song <Song.Chi@microsoft.com>
> Sent: Monday, July 20, 2020 3:17 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH v3 net-next] net: hyperv: Add attributes to show TX indir=
ection
> table
>=20
> An imbalanced TX indirection table causes netvsc to have low
> performance. This table is created and managed during runtime. To help
> better diagnose performance issues caused by imbalanced tables, add
> device attributes to show the content of TX indirection tables.
>=20
> Signed-off-by: Chi Song <chisong@microsoft.com>
> ---
> v2: remove RX as it's in ethtool already, show single value in each file,
>  and update description.
> v3: fix broken format by alpine.
>=20
> Thank you for comments. Let me know, if I miss something.
>=20
> ---
>  drivers/net/hyperv/netvsc_drv.c | 53 +++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index 6267f706e8ee..222c2fad9300 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2370,6 +2370,55 @@ static int netvsc_unregister_vf(struct net_device
> *vf_netdev)
>  	return NOTIFY_OK;
>  }
>=20
> +static struct device_attribute
> dev_attr_netvsc_dev_attrs[VRSS_SEND_TAB_SIZE];
> +static struct attribute *netvsc_dev_attrs[VRSS_SEND_TAB_SIZE + 1];
> +
> +const struct attribute_group netvsc_dev_group =3D {
> +	.name =3D NULL,
> +	.attrs =3D netvsc_dev_attrs,
> +};
> +
> +static ssize_t tx_indirection_table_show(struct device *dev,
> +					 struct device_attribute *dev_attr,
> +					 char *buf)
> +{
> +	struct net_device *ndev =3D to_net_dev(dev);
> +	struct net_device_context *ndc =3D netdev_priv(ndev);
> +	ssize_t offset =3D 0;
> +	int index =3D dev_attr - dev_attr_netvsc_dev_attrs;
> +
> +	offset =3D sprintf(buf, "%u\n", ndc->tx_table[index]);
> +
> +	return offset;
> +}
> +
> +static void netvsc_attrs_init(void)
> +{
> +	int i;
> +	char buffer[32];
> +
> +	for (i =3D 0; i < VRSS_SEND_TAB_SIZE; i++) {
> +		sprintf(buffer, "tx_indirection_table_%02u", i);
> +		dev_attr_netvsc_dev_attrs[i].attr.name =3D
> +			kstrdup(buffer, GFP_KERNEL);
> +		dev_attr_netvsc_dev_attrs[i].attr.mode =3D 0444;
> +		sysfs_attr_init(&dev_attr_netvsc_dev_attrs[i].attr);
> +
> +		dev_attr_netvsc_dev_attrs[i].show =3D tx_indirection_table_show;
> +		dev_attr_netvsc_dev_attrs[i].store =3D NULL;
> +		netvsc_dev_attrs[i] =3D &dev_attr_netvsc_dev_attrs[i].attr;
> +	}
> +	netvsc_dev_attrs[VRSS_SEND_TAB_SIZE] =3D NULL;
> +}
> +
> +static void netvsc_attrs_exit(void)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < VRSS_SEND_TAB_SIZE; i++)
> +		kfree(dev_attr_netvsc_dev_attrs[i].attr.name);
> +}
> +
>  static int netvsc_probe(struct hv_device *dev,
>  			const struct hv_vmbus_device_id *dev_id)
>  {
> @@ -2396,6 +2445,7 @@ static int netvsc_probe(struct hv_device *dev,
>  			   net_device_ctx->msg_enable);
>=20
>  	hv_set_drvdata(dev, net);
> +	netvsc_attrs_init();

dev_attr_netvsc_dev_attrs is a global array, so it should be initialized=20
and cleaned up in netvsc_drv_init/exit().=20
If there are multiple NICs and possible hot add/remove, init/cleaning it in=
=20
netvsc_probe/remove() will cause memory leak, and/or use of freed=20
memory.

Thanks,
- Haiyang
