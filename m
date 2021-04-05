Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBCF3545BE
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhDERB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:01:59 -0400
Received: from mail-bn8nam08on2083.outbound.protection.outlook.com ([40.107.100.83]:35277
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232677AbhDERB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 13:01:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/8rPwUX89N4AXs8ajyQ7b3SZhfQY6rDJcITaCYALlk/G3V7sK8XAjFVslCXekhElCsYMP4JEbgACFzEy7mx0Ocb24rfbYXCruZ5/I7PrqRwAMGWFs1svhyie7GNSGlWY6EWqjts6oovFzifUfeDobZ6VkzMv4NHVJdCrtN3JCvDWKUTIIINUwPQ6CmaBpmfvLPne8v2XG3eHxjp5IJUSmcGkbdjKghjT3XsSea/ZvsUa8s7ZNLiI+wWuYgzf/3CdpTc20QV644tC3tb1A6lVuKkmc1lMpS9h6KRqonQwHNRbtI+Av7jetfZlgt4VD8+jQoCVxvqXyf9+YZ3vjxn5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crGBCZhTeBJy1ZIHfPftBoRvFiI9zENKOVVvb/HdE/I=;
 b=FXkG7n6XqtHpreSKvEN9iVMqq82p4qwyDoV07jqc4u1TgqQ4poc6ProhCIMgM8yAYaQDjY65xpLIHzSp22OPw3ViEVuUTBKxlqE6ZsHP5ZdRYf8exJwh09e337z5UFI6zhW12SOTTC3S4KzoCUuanM+ZVyE3grcA/peMnErQwikfKILxK3CtW57t3XcXy9WRj7Jlw+Xx+1aCMjXR/ahUg57Bfhwj9bRIkPjUtJwU852CzMgVa9ASNL7Qs537f84Ki8ObmL0CnfxypOQBf79dbzh2L3GOxViAnHtKA3S65ZJX+UCWrdm3R6xW1cgeM6Qj9LosxVdNiDeZeUVcCGuDEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crGBCZhTeBJy1ZIHfPftBoRvFiI9zENKOVVvb/HdE/I=;
 b=kUWvlF+4cY5KTZv0afjGSWC9z2e+05PKyFJD62RsvWsH0mqgphm5FWstgEnTRQQosBBfrujcPeR2lNCdNoSBuCkf3BGCHPCaWRT0wM+58B0KyoLXHV+WMtQUewtw8IILBEeaiExHkqJAdilzvRVZOYipyYxjtU8TDhP8ruA8r3BF3VjxwkRaEjfxLfSfGzzJRCAdPGMVvnjfeLtD1IALTTggmCvwAGAu12VeYj1MKDQFQkhfJLZQvqVv7kB395UiponPMo1veT00n7uC9G/hNDe+WXH2BzNWvfFeXBK6KX1rB5+uL2LZ606T/ZAkmWVObZ8CzFaPXB3XUzdSyVbCDA==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3689.namprd12.prod.outlook.com (2603:10b6:5:1c7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 17:01:51 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::8423:fe54:e2ea:7775]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::8423:fe54:e2ea:7775%8]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 17:01:51 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "acardace@redhat.com" <acardace@redhat.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>
Subject: RE: [PATCH net v2 1/2] ethtool: Add link_mode parameter capability
 bit to ethtool_ops
Thread-Topic: [PATCH net v2 1/2] ethtool: Add link_mode parameter capability
 bit to ethtool_ops
Thread-Index: AQHXKSqiy1NCZxxuWEyWWVUMq+pPVqqkje0AgAGXmpA=
Date:   Mon, 5 Apr 2021 17:01:50 +0000
Message-ID: <DM6PR12MB451678D11E9553D61C3304DDD8779@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210404081433.1260889-1-danieller@nvidia.com>
 <20210404081433.1260889-2-danieller@nvidia.com> <YGnqKFddCJGikOo8@lunn.ch>
In-Reply-To: <YGnqKFddCJGikOo8@lunn.ch>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a1227ac-f3df-462f-1e4f-08d8f85481c2
x-ms-traffictypediagnostic: DM6PR12MB3689:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3689E70ECA4D973CBCD2F762D8779@DM6PR12MB3689.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vQx/qRdRBz5hQAgXeX9DbfrQWNyyPyoJmgq6OJgf12qkiaP7wrLcjQ7c2tqtjmVpQyzJA3GF/DEe8amZ+ErqmcduK6MOP0MqPxqfkGdA5THQ+fmbBuu15ykJG5lNLz1FQ4n5LJnUBtng6AavK56odsO8wMtkaxZbQZ5a3nYzroHYhqrEkNU4yjLM0bajM9Xh4ONsHyIqxuPcj+YZRFJENJUET5L/micJxZgwY3Q5ZQhMNbS8NAnP9AsRr+iieNp0eRBGp3JNbwQ0nz+bktjp+rw124dmWgKuqjhgrEleg3e8ShbWUtgJgrt4QNJ2EpoRq3L2s+or3/582oS/GbU3Kb4pMc4ZX1itocHAQJmZNCKg1x6KPRf9z0Hdk1AcmFBUp6koS+GicQWK4oRPMLK47HcCWHy2PBOyysz/lijllToeh5VKWJOU8gwUsTTjXF5PTLhQkYtA7BkeTAmkvIy6a4uXcbpygy9XNGpzi2+9RF33f7Xai9Lpd2zqwA9fP3LsEmjck0P+53C4wuc2qvTR+K6glMRmJRxONckWT3Sbykn851XkM6+N7eAZa89Fn3Fk1/BrbrcBfIFYPCZKA/ZA/DpsCabafCCeWZFVQft7f7fVTBbWtIArR1lVv3rvtHaiDm4dWn4L3SkcEmhCMzWUZWbWjwueg+VQdARs2I5FxIrYkYhPRGamcN5n1J+Nea90RRRLaOBh+Yjh9hewugNxKEQCYtZ81eLDhzyQiKtHmCjbuw8hoSc+nLClRbfkbE4F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(7416002)(38100700001)(71200400001)(316002)(5660300002)(8936002)(64756008)(9686003)(2906002)(8676002)(76116006)(966005)(4326008)(66946007)(54906003)(55016002)(107886003)(6506007)(66446008)(53546011)(66476007)(66556008)(186003)(6916009)(52536014)(86362001)(7696005)(478600001)(33656002)(83380400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qlSufW5XzQHS5GCxX2Y0R/D6UMaCK8/5nkhrQI5aUdQGDp55yPbCl6OMlPT5?=
 =?us-ascii?Q?e/oAJzFKo414cpoQQ25pdCtfrVMeBSQeYHeL4p6LazljwNE+zdCernY3blj5?=
 =?us-ascii?Q?4NsYSqN1xzQbcpDxXLs7qAENpff46JoHXeE3iNNcnxds+YOXDHTAl3GS4Nh0?=
 =?us-ascii?Q?32zzCB9NA2oV+fm+3AoF1ID4RgnKY1GUAdy9SzGbS1SUOPLfEv3WSqAKG02G?=
 =?us-ascii?Q?hDf4qQqENSdlgnSAc0f+L+eSINbW9JZhPFU9yjcn1VV+4VWwLuJJDi3PTaoI?=
 =?us-ascii?Q?zzWafrAzwREiuo2A4bTjU/9tdoh0HZDaWbcWA3rh8F7PxPLBIzmwWJwtchLt?=
 =?us-ascii?Q?zUopV+27qD88iuAEcbq7fnpZwwZHxb2S/sGUAcWMxbkutYv0gBhJMJED2gEr?=
 =?us-ascii?Q?JISCDB6DsRMAmVjrsFEqQ8FsEYzLE1CnLjHQ6aHH184oAibcKVfLRn+OsZtt?=
 =?us-ascii?Q?VwZhtkd7+HtmWxUt3ooARjT6cOaJEQPchr0wh3+Q1ypbAUySSDaEu636v7Zp?=
 =?us-ascii?Q?8nsITW7Wjh+0hDpfSFRHd5PXv7Ss7iqvoJteVMsPGHXQE33zceumUgc1VYq3?=
 =?us-ascii?Q?FlBK3DEJ1DVWg0KHb0avl9SYsyEvMnMSSfDz0NOIGtCM+7SWGVDjZ9vQsmOl?=
 =?us-ascii?Q?Ru1Rua3tJ4GwvkrjdNrZzYoewO99K0qq0UOVBGUNJzQXXsJVfyBCdQTp6DTU?=
 =?us-ascii?Q?aXfameT5MRqbRG+tyKYruGcQvJ3c1GdNTlD8Fh+5tJWbT8WBrUW3fFwtBbOU?=
 =?us-ascii?Q?BEXNo+483hl8Fkb0XJW7JBIQyzRX+IahOe8wcByQ8WsmnN+hyL5e+8ODDk/p?=
 =?us-ascii?Q?RqxyOa5lbaJMigwlyaWoiMyub+OHWZczFzUG1evQtmdQXtAWphgzic1w4N1p?=
 =?us-ascii?Q?o/BmyqYCim/yaMKS0eJUMjr9oUfjtNuvJJgYwhSmBJTrDcz84A/eeetvnke6?=
 =?us-ascii?Q?92F7Xo4ZqQmO7naz5Q938yW+tdddUdzkcu5NHvgq1wCUzDKzfpH3BAHKVkLW?=
 =?us-ascii?Q?d6C6SNUDApmi4MuSxABE0m/0VgmjSZTSlsUwTiLz0Vfysgb4XSgk/C1GJzVy?=
 =?us-ascii?Q?90y86Pg/8RfOP2zYDm2RcYn57negPrWOeEfacZiAIHQjC37/R73bPSMW+uWB?=
 =?us-ascii?Q?j6FfU/AAa1W4gacZcf+4XDwAughj5tM6Qy+TkBgD1qIKBRLZc6O850zdoE86?=
 =?us-ascii?Q?efLgpZE+EPTZTWpEOQNwfkG0fxC2s4yfHQme5m5/M9aXK8aC7VZZVxf9Ss5a?=
 =?us-ascii?Q?wn1Xl1rGoldmCtIL3tbXEo5UStmSeIyBVoU8nFLqqlubeo9HxXJEhdYqIdPu?=
 =?us-ascii?Q?6EVkWrfS+g8vFyagKmPsgQse?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1227ac-f3df-462f-1e4f-08d8f85481c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 17:01:50.9843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rSOqSsou+yI2l1Dj0+B0Ef8lZkcBWlI0aXT88v9u1lZeHMKGFkc6x2vH8JXV8K5jwU0Og7KbXKJO3h+3SMgBDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3689
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, April 4, 2021 7:33 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; eric.du=
mazet@gmail.com; mkubecek@suse.cz;
> f.fainelli@gmail.com; acardace@redhat.com; irusskikh@marvell.com; gustavo=
@embeddedor.com; magnus.karlsson@intel.com;
> ecree@solarflare.com; Ido Schimmel <idosch@nvidia.com>; Jiri Pirko <jiri@=
nvidia.com>; mlxsw <mlxsw@nvidia.com>
> Subject: Re: [PATCH net v2 1/2] ethtool: Add link_mode parameter capabili=
ty bit to ethtool_ops
>=20
> > @@ -436,12 +436,16 @@ int __ethtool_get_link_ksettings(struct
> > net_device *dev,
> >
> >  	memset(link_ksettings, 0, sizeof(*link_ksettings));
> >
> > -	link_ksettings->link_mode =3D -1;
> >  	err =3D dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
> >  	if (err)
> >  		return err;
> >
> > -	if (link_ksettings->link_mode !=3D -1) {
> > +	if (dev->ethtool_ops->cap_link_mode_supported &&
> > +	    link_ksettings->link_mode !=3D -1) {
>=20
> Is this -1 behaviour documented anywhere? It seems like you just changed =
its meaning. It used to mean, this field has not been set,
> ignore it. Adding the cap_link_mode_supported it now means, we have field=
 has been set, but we have no idea what link mode is
> being used.
> So you should probably add something to the documentation of struct ethto=
ol_link_ksettings.
>=20
> I wonder if we should actually add ETHTOOL_LINK_MODE_UNKNOWN to enum etht=
ool_link_mode_bit_indices?
>=20
> > +		if (WARN_ON_ONCE(link_ksettings->link_mode >=3D
> > +				 __ETHTOOL_LINK_MODE_MASK_NBITS))
> > +			return -EINVAL;
> > +
> >  		link_info =3D &link_mode_params[link_ksettings->link_mode];
> >  		link_ksettings->base.speed =3D link_info->speed;
> >  		link_ksettings->lanes =3D link_info->lanes;
>=20
> If dev->ethtool_ops->cap_link_mode_supported && link_ksettings->link_mode=
 =3D=3D -1 should you be setting speed to
> SPEED_UNKNOWN, and lanes to LANE_UNKNOWN? Or is that already the default?
>=20
> But over all, this API between the core and the driver seems messy. Why n=
ot just add a helper in common.c which translates link
> mode to speed/duplex/lanes and call it in the driver. Then you don't need=
 this capability flags, which i doubt any other driver will ever
> use. And you don't need to worry about drivers returning random values. A=
s far as i can see, the link_mode returned by the driver is
> not used for anything other than for this translation. So i don't see a n=
eed for it outside of the driver. Or maybe i'm missing
> something?
>=20
> 	Andrew

Hi Andrew,

Please see my patch here: https://github.com/daniellerts/linux_mlxsw/commit=
/72ca614951418843aa87323630c354691d9e50d4
Since a lack of time until the window closes, please see if that is what yo=
u meant and you are ok with it, before I am sending another version.

Thanks,
Danielle=20
