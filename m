Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DC13A42A3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 15:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhFKNDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 09:03:47 -0400
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:25601
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231161AbhFKNDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 09:03:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzfjlqIXHFMR1tocH9HyMDITGFuWItqzk7kDJk2crfX0+ePA/Aux6s13Dn7qlJRalpLkVZ6KMlcGVoyDBeItL4t9ZaYsPxhbAF9jemzUDyPpimbmWJcIHVnhq8Czib793XtBUeWe2boRC2mq7Qgt8hfuxz2Tp4QSDao2zplSWxvJ40SWRxpROW/FTk18uI888WWn1E2uyRPoRLjsFkjtOf1rFRAE7ZJHpdqHLsuanFX7J4jULiwBM4f8RVD8Nis8KJqbOCMhatWnXuKZam3QDmEtG401sPTQDuBTID/MD+Jbtd88Evg1dMsCtteUcS5D7H6M8n9vMXJXqdAZubrCoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAFuAeZQD0MYAsnT4vEHia9wjbSNx6is1dGgHlUS/8A=;
 b=la3k5mIhUNCPtOBZFscohYgscXzWlCLfimO5lKf19za38AQ59cSlljfwJF3qW1QRGeeoqoD6sazgM/RqHW+FrSh0e+iQ9xfgNiCySXf7CpvnJ0KzwaWoIvaBJflcJfrqkP6sSw3sMKgfJ69GXoYvo92z3r1USfCV3BkI6AM40Y/Orn0JQJvaE//ZiV0be5+OXm3gCPgyMl1Gvr8jJh0uvDwesd89INPqCxAtJQkw5LjfSkYIyqm0jIVwhq4r+XE9R047JCLBFwmC8xA0CANNaKjI6rD3ZRCUtkOuip6LeEnrJP2L3ZzWT1xPFtH/GlynRcpZ92m/GZsa7PoLhMXTtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAFuAeZQD0MYAsnT4vEHia9wjbSNx6is1dGgHlUS/8A=;
 b=M9YNuoL9zxIuWqIwMFZ5VhTJJMVL3BvRkImbb/GAsSOIcj+MwPwO5C+Betl3V1t0gZKSe7oeG1cKkrZlc0TN2wYXglK2Y+X3qVIeRRQDAuM97z6tdD1ryYdN1TTa09ZlSI/SROin4OYjdo+MCtokXzlRqIPr6zKqdBtOhjdMocLsm8BvBO+CyrJhupUfDAYv8ujevKYcx3pdSlELTW/cNy4HMHNvzm/DmLaB4L41U+sFpDlXoQz8SPq9oJNtoR+21745Sn66jToX4tCD3NRNdSvvoQfJ7WB4mSNAVUyCoBS0uBi997PQNIAbcCmYEiOFxkgo4ysD8cR2A5d5OfS4iQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Fri, 11 Jun
 2021 13:01:48 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb%7]) with mapi id 15.20.4219.023; Fri, 11 Jun 2021
 13:01:48 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: RE: [PATCH net-next v2 2/3] rtnetlink: add
 IFLA_PARENT_[DEV|DEV_BUS]_NAME
Thread-Topic: [PATCH net-next v2 2/3] rtnetlink: add
 IFLA_PARENT_[DEV|DEV_BUS]_NAME
Thread-Index: AQHXXh74CfJ1JCE4JUaG6m7m5f+1aasOw8rw
Date:   Fri, 11 Jun 2021 13:01:47 +0000
Message-ID: <PH0PR12MB5481986BF646806E23909CD7DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
 <1623347089-28788-2-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1623347089-28788-2-git-send-email-loic.poulain@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d839d01-bcac-477d-ee58-08d92cd91287
x-ms-traffictypediagnostic: PH0PR12MB5420:
x-microsoft-antispam-prvs: <PH0PR12MB54204484F5BF4CB7F9B56B69DC349@PH0PR12MB5420.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:73;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DFZyJ7XdqvqyHHHtcfz+Gx5NtvvA2eIsaipgzLkXDBz1OJrjka6USw3Hp2DW2ohoo7qPAnMuSYl2KYwrGchHNMUqFT55Xw1yHcbATDN7eMMgYFKjIybHpORvyHc6tjKHv2pqnDztetpfDVkwDwoSucuNWAW33mmHmn/tAUsuQOecYg+W1PkgC9+SOa4BhvGwgBbzHl4KkVC7OfEFg1CyR8vb3euoTP5foQYYcfNpyfba7p6czfqiaXN+KU212h661pYTK6ZmzbbWQviUoNJ76KY0O33/srp60jZhKJDXRPJNVKppOyY1GxFD8MHTfUgCYDW8ip/Wqb54AWh1iuiKlwZZ/ROW+8ETi6fjrN2jWR4KUVn0e5G8tr51FEj9Nd94jRgN4HibI8b/2x4+sIwkz9dJ61n9eKAmtgK50MIq4/zBcmMkZwFojcctwZk3lYT8sot3scX1qMuzFqU8tsvSON8K8a11+bKSeJFjHjJ1c5WKRZ6K0mxV9fjDq0duNle1beL5Miek/QQX4alLDLI7dhmXuEid3Brzh8UxqzxrqWZT7e9WaFwvmRiFa6aJvpIJP1PmeYAKRqUV48OSxL2abUMjETCbqs7vC3+lTfmopFNHA1c2HcEFshHs6J8EfP8ytaV0oVbqGrZTsEp72E8mQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(86362001)(55236004)(110136005)(52536014)(54906003)(316002)(9686003)(6506007)(71200400001)(83380400001)(38100700002)(4326008)(122000001)(7696005)(8936002)(186003)(26005)(76116006)(33656002)(66946007)(478600001)(55016002)(2906002)(64756008)(66556008)(66476007)(5660300002)(66446008)(8676002)(83133001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b//Ff90aDTewegWAJDtupqbf6gSKEOe0fegVEQoFKZv5swpu83JWe/Q7YN3c?=
 =?us-ascii?Q?TtZEzP5kz+c06JMLlBLS780MoWjv2qU4ZiBdzvcLlZQayJdBI0Yr1W1FjcuX?=
 =?us-ascii?Q?tazEpF3IUj4z/fHnl7pspwdhnMm2yBr8c5+mCtNfizh1MKJvMLERdy95WqtM?=
 =?us-ascii?Q?HWxR0pm6E66XWqCZ4GQFOl3WoGZxDyuLScZGJDBBtyXQO3gAn1RB0Bjy3fQH?=
 =?us-ascii?Q?NnHwDVOMK/w0odOKJTxb80zm/TJHCfl/M02NOPRvtbCJ+mZTJno8wKU5QW+z?=
 =?us-ascii?Q?RVxnP6BsiCD4yrTkKtNR6tSNJghpZeNxR21xl7/JQqY6TosV1V/279y33tfh?=
 =?us-ascii?Q?4xfEq7I6jaa0bw5De+LiCeKBGfp01C/1Sb4BSDugTKZxQXrpJCd72+BvV39f?=
 =?us-ascii?Q?OhvaskFNvDFdw+IIT0CSmDEAZFLlZ61Skak6tn3uVbLbT9nXSgZ3bLwUK09x?=
 =?us-ascii?Q?nB30bCFFhCfrhwDj5jcQDwgE5AaF8BjQWXds3LxTv1sxnXNQytjx04gUv3pC?=
 =?us-ascii?Q?LlQG/nW6ZmlwxLvl47L9mw8iGUnLhhLRvOiNvywqs0Qh2pYnAJDvBCOi8G7R?=
 =?us-ascii?Q?Vn9pXUHPOD7qPM4AcYboupH9qy1kYj4yvNXMuWeMO7/jIa5jt67iUS4b+Trj?=
 =?us-ascii?Q?lxk8/AHpbYGW+7E613FBl6BxFJVa+bpNbFgd6diKCCKKPYdB5WmIolFxaoUC?=
 =?us-ascii?Q?XB9hgeT9mYkS/wQdj8O5HcaV6f6BzpjbzW0nbimgNAx9ApqNXY21YHvFD5NW?=
 =?us-ascii?Q?OxxZc5i5GHDXnQRMJZtHmu1xTXjoWIN81JCYVvkS1YANQzkdxs+wPuRUT9Ht?=
 =?us-ascii?Q?vrdwcjcriTNFTtqcoDryjdBVve7DimEoYQz7BXFz80S0s9YBi4nl0r/7E+sM?=
 =?us-ascii?Q?eqWi5hlqTf4Q7pPecgK9/6anv4nuiToBLxGxKE0L2beQJT4FVfOq5jQ0Yyoi?=
 =?us-ascii?Q?jxVdEpdGu7mU/6M87coHH17utasaxSRR8YNud3qhRtHXMNPVrX5wUsI66zwZ?=
 =?us-ascii?Q?bSH131uNLhsWdLoEwaFUJYcSlQHUJIATeoIQHBJ583xoKfNRME6yN7ZEUHdN?=
 =?us-ascii?Q?qCdN7f7BHOjNHvNuXyndrTsyzVzMtkOJKmHkKZuOyw4908McH6Cq1t1g6JDm?=
 =?us-ascii?Q?4cipuXn0Jb8T+eNTU1EMeWnyQKe3LwLpu/jPT71ouWXPCLPZaLw6GJDka4GD?=
 =?us-ascii?Q?BRyq+d61EV5h1kZSLs320rK18qt965dGZKXa0vMQNXzm+HAJFrxsQ8wIQHoI?=
 =?us-ascii?Q?L1uOamNBvfcHc9zG1pozKxP5Bss4Bk6rT84I0MANAoSEhcgMlFMH4RPqXH6y?=
 =?us-ascii?Q?sbfQWHwYQUuzh+gjRVXwwrkw?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d839d01-bcac-477d-ee58-08d92cd91287
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 13:01:47.8108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V0oNiOoExFdHl41NpFXbtGnAXAPcRQeCVMGcRSn/eVQoxgKjrJ7TgYQpNu+lDTPEn61KkGZ2vwmMeFoOUNbGxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Loic Poulain <loic.poulain@linaro.org>
> Sent: Thursday, June 10, 2021 11:15 PM
>=20
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> In some cases, for example in the upcoming WWAN framework changes,
> there's no natural "parent netdev", so sometimes dummy netdevs are
> created or similar. IFLA_PARENT_DEV_NAME is a new attribute intended to
> contain a device (sysfs, struct device) name that can be used instead whe=
n
> creating a new netdev, if the rtnetlink family implements it.
>=20
> As suggested by Parav Pandit, we also introduce
> IFLA_PARENT_DEV_BUS_NAME attribute in order to uniquely identify a
> device on the system (with bus/name pair).
>=20
> ip-link(8) support for the generic parent device attributes will help us =
avoid
> code duplication, so no other link type will require a custom code to han=
dle
> the parent name attribute. E.g. the WWAN interface creation command will
> looks like this:
>=20
> $ ip link add wwan0-1 parent-dev wwan0 type wwan channel-id 1
>=20
> So, some future subsystem (or driver) FOO will have an interface creation
> command that looks like this:
>=20
> $ ip link add foo1-3 parent-dev foo1 type foo bar-id 3 baz-type Y
>=20
> Below is an example of dumping link info of a random device with these ne=
w
> attributes:
>=20
> $ ip --details link show wlp0s20f3
>   4: wlp0s20f3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
> noqueue
>      state UP mode DORMANT group default qlen 1000
>      ...
>      parent_devname 0000:00:14.3 parent_busname pci

Showing bus first followed device is more preferred approach to see hierarc=
hy.
Please change their sequence.

You should drop "name" suffix.
"parent_bus" and "parent_dev" are just fine.

>=20
> Co-developed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  v2: - Squashed Johannes and Sergey changes
>      - Added IFLA_PARENT_DEV_BUS_NAME attribute
>      - reworded commit message + introduce Sergey's comment
>=20
>  include/uapi/linux/if_link.h |  7 +++++++
>  net/core/rtnetlink.c         | 12 ++++++++++++
>  2 files changed, 19 insertions(+)
>=20
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h =
index
> a5a7f0e..4882e81 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -341,6 +341,13 @@ enum {
>  	IFLA_ALT_IFNAME, /* Alternative ifname */
>  	IFLA_PERM_ADDRESS,
>  	IFLA_PROTO_DOWN_REASON,
> +
> +	/* device (sysfs) name as parent, used instead
> +	 * of IFLA_LINK where there's no parent netdev
> +	 */
> +	IFLA_PARENT_DEV_NAME,
> +	IFLA_PARENT_DEV_BUS_NAME,
> +
>  	__IFLA_MAX
>  };
>=20
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c index 92c3e43..3=
2599f3
> 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1821,6 +1821,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>  	if (rtnl_fill_prop_list(skb, dev))
>  		goto nla_put_failure;
>=20
> +	if (dev->dev.parent &&
> +	    nla_put_string(skb, IFLA_PARENT_DEV_NAME,
> +			   dev_name(dev->dev.parent)))
> +		goto nla_put_failure;
> +
> +	if (dev->dev.parent && dev->dev.parent->bus &&
> +	    nla_put_string(skb, IFLA_PARENT_DEV_BUS_NAME,
> +			   dev->dev.parent->bus->name))
> +		goto nla_put_failure;
> +
>  	nlmsg_end(skb, nlh);
>  	return 0;
>=20
> @@ -1880,6 +1890,8 @@ static const struct nla_policy
> ifla_policy[IFLA_MAX+1] =3D {
>  	[IFLA_PERM_ADDRESS]	=3D { .type =3D NLA_REJECT },
>  	[IFLA_PROTO_DOWN_REASON] =3D { .type =3D NLA_NESTED },
>  	[IFLA_NEW_IFINDEX]	=3D NLA_POLICY_MIN(NLA_S32, 1),
> +	[IFLA_PARENT_DEV_NAME]	=3D { .type =3D NLA_NUL_STRING },
> +	[IFLA_PARENT_DEV_BUS_NAME] =3D { .type =3D NLA_NUL_STRING },
>  };
>=20
This hunk should go in the patch that enables users to use these fields to =
specify it for new link creation.
