Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9A13A424E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhFKMtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:49:01 -0400
Received: from mail-dm6nam12on2083.outbound.protection.outlook.com ([40.107.243.83]:29024
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230349AbhFKMtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 08:49:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOT4NgztunPrwKfrduD9IBNMNI2MBXk2BYgIpwanBzkQXn9rMSIL+Bt6iARw3iTFRk1U3X593EY5NExf5isg6wpz7efROppuV3zFyQsc2hysWQCpnpEJiT0Jyzsq3c2uKxJztaalrxTXl6Kpn81UtrumXNLXLKWzuQJEE4EMP/M2htY5yVzGGYcJU7I0Scz1bcEzLRSdMvmwyqCF7be9C/zD0klGKvPDXnr50Qir/WA02cqXucKO36SekjyRxqSYo+3cK8AqbOyavzwXmwBVce5h/I5eyREbK+H+veqOBqt4NQE0BtxqdwRaNKVy7hF0PxvyKCPh8EARDIl8DQ/1Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUGOKoDtVWXmEjBI9qBoZX/DLUp+ZhHTHCStRk0AiMQ=;
 b=BjyK/g7lbQAxjI696rt4zXapOCuF6q9deHpf3E24bFeFYNlWsyNrMf2wwYHiVdoN1X1/DLjmsM+ThDXS0kFeYAQOqUrUuT+jFrGXXGneAzd9oPovClYH10uN22YNAqUTuwEIABLANGd2FqeIezCKud4ozBASneiQ4KnLd74tDa/5NcLGAgdiqpJDFkhxcd3Is6MpB5H/dusFimDOtKqm/Og4wLmebSyA5n4cSaGM4F6g79yuD3Lb7ZiJW856A9ZfNbcMUP9uPOjTq3vABwd5X1X0AS7L7MU66VLnPrxT/aFcICH7ljZAwozGu4sYEO66fiGPUzZ4Revp+2e2C61lJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUGOKoDtVWXmEjBI9qBoZX/DLUp+ZhHTHCStRk0AiMQ=;
 b=iIIASxAuRw3i2nnyNp0YP9PL8A5f2L6qhvyS5FmhD5KU8scZ/0wVa9JCYa4BUP4ccgfzanxbtIgU6YU8o7W5C6E+6ziviERXIC0J7fELwc20M8D2J5L8nwi1rLtNmjB27DqatNmukJYus+4Xrjnbwdc9vNqkUUZP6Vz2BsyIoUgjdD9jvCi6y7UB7pHG7MyGXqLYdlZ8/tqbD2kBZ+LFX59zTin+eBhrsBFQ+WufU8wl2NoL4GJ8PDJybLFrP2S7sFTBUXordYWGSxmA/hNQoVuOTqp9P3o6lWEiyRJ05rC7ziJdumsXgjPvCXeMYa1IKmpBvzkSa+e05/YoM5M95g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5468.namprd12.prod.outlook.com (2603:10b6:510:ea::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 12:47:01 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb%7]) with mapi id 15.20.4219.023; Fri, 11 Jun 2021
 12:47:01 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: RE: [PATCH net-next v2 3/3] wwan: add interface creation support
Thread-Topic: [PATCH net-next v2 3/3] wwan: add interface creation support
Thread-Index: AQHXXh741hTOpAdGh0yoZDhy0bj4h6sOv7lw
Date:   Fri, 11 Jun 2021 12:47:01 +0000
Message-ID: <PH0PR12MB54819C2433775DDD833B9F08DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
 <1623347089-28788-3-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1623347089-28788-3-git-send-email-loic.poulain@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1dfc0fc-97a1-42ae-2f06-08d92cd70243
x-ms-traffictypediagnostic: PH0PR12MB5468:
x-microsoft-antispam-prvs: <PH0PR12MB546846A4D1AED064CF0D5D1CDC349@PH0PR12MB5468.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yTWLGs4uHxukLmAUAeIO9ogySDYEEFbtoVxYbXXmC+19SwIF9xiQPGR1pGfSALskf7qJTvZla/6O3bT3C1WUt16sOzf7kGL9OBr/AXacHNFpdvNZhPcTotvfYiQ1aGfWDIGWhs9smVXPv7u9ubbT23cCLyinKaqCUi62nUXEVyUxv5x1nVNG68xqINDxKaKbCkSqicXrxnq9KwtKt2JEwPfGQMI4mAsSNfadoT8sjDqaiPlDvQO2o3AurNDYQBPbfy2125ZmNhyKr0hOHLc8EZpSZhkiyYFsLRHwfjoxj3U5nPg9Q0AzSBIKxaE1Dwr8YbjhGTqPFtlFOfMoK3ZsiGpf8XEPHmHM01PLNNJvMts7bk3MEdyWxqTN4IBcpDhTh2y09fjdEUQ1Z9mtDkBYnnSZSIBCiQ2UgYQ7xBLYMPFIm1fuuVaTm9Li/v/48yJWdQqQXijS4d6Cs5fL8pG+PMVNSV/PvJJdghLVKt4N7DXekfw2jq7yE02Ox1TSBTfPtvyakLNEv5WFqz0Iul8Rj//zoFtOUHHJnQxCHP6o9GZnkzsGI0b0S4XPlQxwBrnlawgpxAsWXwB3K4NQYkYihXaxduofB5kQgGWk4GgcR4A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(86362001)(6506007)(66446008)(66476007)(66556008)(76116006)(66946007)(64756008)(52536014)(186003)(55236004)(316002)(122000001)(2906002)(33656002)(4326008)(9686003)(55016002)(478600001)(54906003)(5660300002)(8676002)(110136005)(8936002)(7696005)(71200400001)(26005)(83380400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3WElzKNBNyKS4dnqSQsNYucrtT/4ducNQp6Rwtsa84aGlzJWX8XxgDMQB7ui?=
 =?us-ascii?Q?zG77bk2OttsGFxpfPmCx8SqPOoPNJzoVhVEfPkPc9trF5nwW5PiE8XR8H80U?=
 =?us-ascii?Q?a13pSW+gnSxG+BM1Xf3yAAFDrkrgoQm/4sPDGehjXGrgml7z28AJAe1U5dN3?=
 =?us-ascii?Q?KaTI8EstVaqLMr9EEdwggajGsiBIB/Z9HDSwUMrEM+6ys/brfp30Vgw3Vlmv?=
 =?us-ascii?Q?nNPg7Yqua+4v9s8aKLjRqsXluYLjaE9XZP2O1fUAPzwpa7JiT0w6WwhGVlzH?=
 =?us-ascii?Q?kksYSRspHUXzLndu6zl4mPbFoO5SCp7tYDMh6K01LGCBE3zr+VXkAsL1HnPO?=
 =?us-ascii?Q?VGc3BdBHdwGxvS96qC5ozFj5znQpWDa9GOBpY7pL3lEZQWOEqKW2a25aDN85?=
 =?us-ascii?Q?C11YzzzDCKnBS6KQWG8EHLwzwsZ+9tuLFjKzdE+s+xUQM2D3nbRGkKymA5RK?=
 =?us-ascii?Q?aKcJC5+LZGbH66gEZq5TZwJ/Mh0b/1h5jlQtwg+WNNfij61HW6pGcXazKr6h?=
 =?us-ascii?Q?IEEu9y3eIA1UjWqsCVeqbl6LjsnqJnda8BYsZE6iWoQ3W0eOcYy3OfyliEiq?=
 =?us-ascii?Q?Ib80ZWP2EloW17li3bt3DCXWBZZf49DPJh5v+HdmLUUDaFVc5TTdhEY1YVof?=
 =?us-ascii?Q?UmWJ8QUFAROHrlMcGfCiGf8I7zrjEopzOKXHuYqZFXf/uXdNoDlJCSDzy2NQ?=
 =?us-ascii?Q?E9oAeKccV7O0uWvOO8Py4yRCrbRnhM2OpS0Mw/QXil50033NUdjk+u2bSbzx?=
 =?us-ascii?Q?0FpX7/ASqM5ZzOT7sa1VndyOZcNUPcqt9xOYpCWAAHrWdw2/w2wxgALocDE1?=
 =?us-ascii?Q?QVVwK1i+4nvqKy+PTMZPDIetJfU29fUT0QoInnGiopem5Hf71akHkg5lmFzz?=
 =?us-ascii?Q?nyHsFCF1xCuvNCxpYnS07e72aYs8KpYeZOQmRXgmy4O+uS9waYfOZMCCOsCH?=
 =?us-ascii?Q?v2jm5rR9tfmPc3DYXolsSb46NAmULX4zB3L0hm90OWDwLzXgCYSxQ+qrniIg?=
 =?us-ascii?Q?dQSA7lif69P2yH+HK9d8Pl2wxIhwOjLGSsCpXvzycD1Dy9EqDbxPvzXye7OE?=
 =?us-ascii?Q?ZjqGoiV7Gd+ZLBZKy0qPMQyNqY9hJiRZNj17avuL4+gTfrmtiRDmfSaoennw?=
 =?us-ascii?Q?CiyaJog4cEDyEkgE8DT7JhQZkQqa84cPATXbFxrJq2a1AH7r+R43fXnsqBod?=
 =?us-ascii?Q?GfiWIuyhAlTCmAzAiOT3gQ5DECHPe7P1uuh951sz/kf7ZwkllclyUe6sXxeF?=
 =?us-ascii?Q?JP67KlYFUEUuEZ+DqLPLqqfq8QfF0v8nJ9qm/HzeWEt36jCqQZK+LzTgIyrp?=
 =?us-ascii?Q?Mae4zNGyCmaXosuUAPZfv2A8?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1dfc0fc-97a1-42ae-2f06-08d92cd70243
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 12:47:01.5889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WCv3vsI9dN7x65XgjlupxLc/+KL4ShgPvkV79D3+kCSN+hIRamKGv/C8PMJtQR9dxRs10UZgvjDckluwqaUGcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5468
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Loic Poulain <loic.poulain@linaro.org>
> Sent: Thursday, June 10, 2021 11:15 PM
>=20
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> Add support to create (and destroy) interfaces via a new rtnetlink kind
> "wwan". The responsible driver has to use the new wwan_register_ops() to
> make this possible.
The responsible driver must be in same series.

>=20
> +int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
> +		      void *ctxt)
> +{
> +	struct wwan_device *wwandev;
> +
> +	if (WARN_ON(!parent || !ops))
> +		return -EINVAL;
> +
> +	wwandev =3D wwan_create_dev(parent);
> +	if (!wwandev)
> +		return -ENOMEM;
> +
> +	if (WARN_ON(wwandev->ops)) {
> +		wwan_remove_dev(wwandev);
> +		return -EBUSY;
> +	}
> +
> +	if (!try_module_get(ops->owner)) {
> +		wwan_remove_dev(wwandev);
> +		return -ENODEV;
> +	}
> +
> +	wwandev->ops =3D ops;
> +	wwandev->ops_ctxt =3D ctxt;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(wwan_register_ops);
> +
I am not familiar with wwan so cannot comment much on code correctness.
But I know for sure that this series is in complete.
Above wwan_register_ops() and below symbols are exported and never used in =
this kernel.
This practice is no longer in use to have dead code.
Please remove this dead code or have the user of these APIs in same series =
along with cover letter.

> +void wwan_unregister_ops(struct device *parent) {
> +	struct wwan_device *wwandev =3D
> wwan_dev_get_by_parent(parent);
> +	bool has_ops;
> +
> +	if (WARN_ON(IS_ERR(wwandev)))
> +		return;
> +
> +	has_ops =3D wwandev->ops;
> +
> +	/* put the reference obtained by wwan_dev_get_by_parent(),
> +	 * we should still have one (that the owner is giving back
> +	 * now) due to the ops being assigned, check that below
> +	 * and return if not.
> +	 */
> +	put_device(&wwandev->dev);
> +
> +	if (WARN_ON(!has_ops))
> +		return;
> +
> +	module_put(wwandev->ops->owner);
> +
> +	wwandev->ops =3D NULL;
> +	wwandev->ops_ctxt =3D NULL;
> +	wwan_remove_dev(wwandev);
> +}
> +EXPORT_SYMBOL_GPL(wwan_unregister_ops);
> +
> +static int wwan_rtnl_validate(struct nlattr *tb[], struct nlattr *data[]=
,
> +			      struct netlink_ext_ack *extack) {
> +	if (!data)
> +		return -EINVAL;
> +
> +	if (!tb[IFLA_PARENT_DEV_NAME])
> +		return -EINVAL;
> +
> +	if (!data[IFLA_WWAN_LINK_ID])
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static struct device_type wwan_type =3D { .name =3D "wwan" };
> +
> +static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
> +					  const char *ifname,
> +					  unsigned char name_assign_type,
> +					  unsigned int num_tx_queues,
> +					  unsigned int num_rx_queues)
> +{
> +	const char *devname =3D nla_data(tb[IFLA_PARENT_DEV_NAME]);
> +	struct wwan_device *wwandev =3D
> wwan_dev_get_by_name(devname);
> +	struct net_device *dev;
> +
> +	if (IS_ERR(wwandev))
> +		return ERR_CAST(wwandev);
> +
> +	/* only supported if ops were registered (not just ports) */
> +	if (!wwandev->ops) {
> +		dev =3D ERR_PTR(-EOPNOTSUPP);
> +		goto out;
> +	}
> +
> +	dev =3D alloc_netdev_mqs(wwandev->ops->priv_size, ifname,
> name_assign_type,
> +			       wwandev->ops->setup, num_tx_queues,
> num_rx_queues);
> +
> +	if (dev) {
> +		SET_NETDEV_DEV(dev, &wwandev->dev);
> +		SET_NETDEV_DEVTYPE(dev, &wwan_type);
> +	}
> +
> +out:
> +	/* release the reference */
> +	put_device(&wwandev->dev);
> +	return dev;
> +}
> +
> +static int wwan_rtnl_newlink(struct net *src_net, struct net_device *dev=
,
> +			     struct nlattr *tb[], struct nlattr *data[],
> +			     struct netlink_ext_ack *extack) {
> +	struct wwan_device *wwandev =3D wwan_dev_get_by_parent(dev-
> >dev.parent);
> +	u32 link_id =3D nla_get_u32(data[IFLA_WWAN_LINK_ID]);
> +	int ret;
> +
> +	if (IS_ERR(wwandev))
> +		return PTR_ERR(wwandev);
> +
> +	/* shouldn't have a netdev (left) with us as parent so WARN */
> +	if (WARN_ON(!wwandev->ops)) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	if (wwandev->ops->newlink)
> +		ret =3D wwandev->ops->newlink(wwandev->ops_ctxt, dev,
> +					    link_id, extack);
> +	else
> +		ret =3D register_netdevice(dev);
> +
> +out:
> +	/* release the reference */
> +	put_device(&wwandev->dev);
> +	return ret;
> +}
> +
> +static void wwan_rtnl_dellink(struct net_device *dev, struct list_head
> +*head) {
> +	struct wwan_device *wwandev =3D wwan_dev_get_by_parent(dev-
> >dev.parent);
> +
> +	if (IS_ERR(wwandev))
> +		return;
> +
> +	/* shouldn't have a netdev (left) with us as parent so WARN */
> +	if (WARN_ON(!wwandev->ops))
> +		goto out;
> +
> +	if (wwandev->ops->dellink)
> +		wwandev->ops->dellink(wwandev->ops_ctxt, dev, head);
> +	else
> +		unregister_netdevice(dev);
> +
> +out:
> +	/* release the reference */
> +	put_device(&wwandev->dev);
> +}
> +
> +static const struct nla_policy wwan_rtnl_policy[IFLA_WWAN_MAX + 1] =3D {
> +	[IFLA_WWAN_LINK_ID] =3D { .type =3D NLA_U32 }, };
> +
> +static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly =3D {
> +	.kind =3D "wwan",
> +	.maxtype =3D __IFLA_WWAN_MAX,
> +	.alloc =3D wwan_rtnl_alloc,
> +	.validate =3D wwan_rtnl_validate,
> +	.newlink =3D wwan_rtnl_newlink,
> +	.dellink =3D wwan_rtnl_dellink,
> +	.policy =3D wwan_rtnl_policy,
> +};
> +
>  static int __init wwan_init(void)
>  {
> +	int err;
> +
> +	err =3D rtnl_link_register(&wwan_rtnl_link_ops);
> +	if (err)
> +		return err;
> +
>  	wwan_class =3D class_create(THIS_MODULE, "wwan");
> -	if (IS_ERR(wwan_class))
> -		return PTR_ERR(wwan_class);
> +	if (IS_ERR(wwan_class)) {
> +		err =3D PTR_ERR(wwan_class);
> +		goto unregister;
> +	}
>=20
>  	/* chrdev used for wwan ports */
>  	wwan_major =3D __register_chrdev(0, 0, WWAN_MAX_MINORS,
> "wwan_port",
>  				       &wwan_port_fops);
>  	if (wwan_major < 0) {
> -		class_destroy(wwan_class);
> -		return wwan_major;
> +		err =3D wwan_major;
> +		goto destroy;
>  	}
>=20
>  	return 0;
> +
> +destroy:
> +	class_destroy(wwan_class);
> +unregister:
> +	rtnl_link_unregister(&wwan_rtnl_link_ops);
> +	return err;
>  }
>=20
>  static void __exit wwan_exit(void)
>  {
>  	__unregister_chrdev(wwan_major, 0, WWAN_MAX_MINORS,
> "wwan_port");
> +	rtnl_link_unregister(&wwan_rtnl_link_ops);
>  	class_destroy(wwan_class);
>  }
>=20
> diff --git a/include/linux/wwan.h b/include/linux/wwan.h index
> fa33cc1..7071f95 100644
> --- a/include/linux/wwan.h
> +++ b/include/linux/wwan.h
> @@ -7,6 +7,7 @@
>  #include <linux/device.h>
>  #include <linux/kernel.h>
>  #include <linux/skbuff.h>
> +#include <linux/netlink.h>
>=20
>  /**
>   * enum wwan_port_type - WWAN port types @@ -116,4 +117,41 @@ void
> wwan_port_txon(struct wwan_port *port);
>   */
>  void *wwan_port_get_drvdata(struct wwan_port *port);
>=20
> +/**
> + * struct wwan_ops - WWAN device ops
> + * @owner: module owner of the WWAN ops
> + * @priv_size: size of private netdev data area
> + * @setup: set up a new netdev
> + * @newlink: register the new netdev
> + * @dellink: remove the given netdev
> + */
> +struct wwan_ops {
> +	struct module *owner;
> +	unsigned int priv_size;
> +	void (*setup)(struct net_device *dev);
> +	int (*newlink)(void *ctxt, struct net_device *dev,
> +		       u32 if_id, struct netlink_ext_ack *extack);
> +	void (*dellink)(void *ctxt, struct net_device *dev,
> +			struct list_head *head);
> +};
> +
> +/**
> + * wwan_register_ops - register WWAN device ops
> + * @parent: Device to use as parent and shared by all WWAN ports and
> + *	created netdevs
> + * @ops: operations to register
> + * @ctxt: context to pass to operations
> + *
> + * Returns: 0 on success, a negative error code on failure  */ int
Kdoc comment section goes in the .c file.
