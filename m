Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0A12FFE51
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbhAVIhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:37:45 -0500
Received: from mail-am6eur05on2100.outbound.protection.outlook.com ([40.107.22.100]:13760
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727039AbhAVIgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 03:36:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOimxrCsTpEHlKEvG7ZM++Y9tp93AIcs9BgDfC2eQy84BlJ7G5gP0k9aCSBrFg0htBLK+8pOD7prvwRbc5snzyJkoVYohwZXqUrcnP7PTlvF1VsRjTfCyq9Upj3tRnulemFbrGO6BNLBOHJlLsNFD1PREF+htZzW9AFfauoviUMy9FJo3dxOOEIylRrEO3dywooHkPc0J3TCW9zBSQEFAIitgX5zr/jp31g/3Ac8OlSBPB5FN1dhQZ0iSt9POPwY8wxOPh8NxkN6akQ9ZKmMRboyFotV7kzRwOQET8NOcdkwLvg5Ce88jnusghUJmCZ66zPhooDFpd/lfq6btY8kFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBamk3jV1e/20yiEnGTjwutAMzMw5XXQAkypQaXFuPU=;
 b=OdmFequtekOwigIixcls4zBMpoAXllESKDOY+D/22BnIfUZcWUrDRUSLKO9/ztlmasZTWXrR8qT5nEmBUvi6H65O+pabaXiBTM+PXV1fme+atOdnkQnH0i0G2zBL/dYbnwTyGE/h/LzWhvJZKarMx5KySTzq/xzbadP1ogE1+TlQNO36sb98q48Bd6iuCJAI93hRfBoG4CAmgKmEJSouj+UrXrPbDk3HEM8pOjnHZl3RH3wDGbq/RPrxpbsVR0Tp6Fk2IjKJjoeVnu+2yMdC7/KjcFVSYofCcdi0EjSa8NIybD1AeiXpXHxGZh+QBsKSMiPepNv0v9mJ7KrxOXU9fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBamk3jV1e/20yiEnGTjwutAMzMw5XXQAkypQaXFuPU=;
 b=egv+xOzym1fNWHea0auWZwz3tHVoMpasdndV4AieG4i6n28VfxZfBt9nLO7Pje6htT+7mh/oD5dmptYg6KoEkpzH8ULlSCg+83t51M2e7gQaZqLgFePU95NOwnewW9/iTA1hj+xXrS+h3IhHsyno0Cv4qcu2J8E+M3ATpU5F4Nw=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1282.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 22 Jan
 2021 08:36:02 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 08:36:01 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Thread-Topic: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Thread-Index: AQHW8JmdV3Ghn6zeuUSyZ1aU9R+t1A==
Date:   Fri, 22 Jan 2021 08:36:01 +0000
Message-ID: <AM0P190MB073828252FFDA3215387765CE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [185.219.76.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be2114f5-1d15-45d4-bc5e-08d8beb0c01e
x-ms-traffictypediagnostic: AM9P190MB1282:
x-microsoft-antispam-prvs: <AM9P190MB12820EBB625D32EB82B71857E4A00@AM9P190MB1282.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6e8nBM6RTMvP4/biXl6xdqmbL0+8G3pRnlCZdccNkCzw9E9TjGNdzcOVVATbeTZyj7Pc0CF/U4DS4bwKmonkpt2LZ1ll1o54+5E2lEYH5RGaAJ+zv/+fxyQyyrkqoFRprh8mVp7KCYiKNdDC/SknW6N2RicBFsn2CySudoJllKriJkFbQgsna1nOKwrqWfrlSVFKvyKf0TceWluM3MrEOmnuWG+hakVYW4tBB/68ffPbN6h0UmcO2NxT+51y+/yDNMyJ5cPeR/YnFc7zQyOVv1kLUF53wreJ06J1YS4VCrbJtnRnjkOiMtDUoqf9Cr6fNLs8UNhJZ/UGPcQyiw/1z1xVtyENvtfJ9m1rwvxCXD+8Lkf55JxKUFD3hFYOnkQppieDIdsUN1zFwJs0CIB0sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(39830400003)(396003)(136003)(376002)(186003)(8676002)(8936002)(83380400001)(66476007)(91956017)(4326008)(26005)(5660300002)(7696005)(54906003)(66446008)(71200400001)(316002)(64756008)(6506007)(66946007)(86362001)(9686003)(44832011)(76116006)(478600001)(33656002)(66556008)(55016002)(110136005)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?gIAVVpzC8h+arLBE/1B7sm/bI0wZWN7IzjUOfoFXIMdklinM3m9jb3sHMa?=
 =?iso-8859-1?Q?+PHYuDcTqmTwv4AD6JTE7jGAwTYgS6FttdKYIaJpDVTNZNng4O1P3/DU5k?=
 =?iso-8859-1?Q?3B6ggJ/UfrNp76e5UU39ExP8l0eM3EZw1ao1xKd/D5YME9r5Z3UGCHITE6?=
 =?iso-8859-1?Q?KjAPwHnLv6eHmUfoYe+wGJsqSkgllhX7Bu/YvcMPb69x8T3K6ncjSW63lY?=
 =?iso-8859-1?Q?z/FdAX0bT4YS2BcnH61c/GdlaEsE5jlRuPoUrOMk9DRL92egXJDeGXaRcx?=
 =?iso-8859-1?Q?jzZg0MKQtgnV5GTsLc8R+u4Z6WI+Tc8irug+NXap79im86YfgELZ/BEL4B?=
 =?iso-8859-1?Q?VEpAIE8RBbFV9GUI0ELcaK6dAzSTJ8JcPQPC92wqgJBSyCiz5NjDTZoPhA?=
 =?iso-8859-1?Q?SdWRaWr/GPPoc7cwXQovM1FJgpeWWnedJ8Vd2lvnFPGC/8O/onmaOBY3Sn?=
 =?iso-8859-1?Q?RQDYr59T6tBr03u8dspvY6GVyt2oGz4FF2dymyHPLmHavCgt9aHSEQir8t?=
 =?iso-8859-1?Q?I/ahCOM7o9HyEzH42laMDZsMdetAJ4W7NT0vKr6WsYGAmHRTKafnd+3M/N?=
 =?iso-8859-1?Q?mUPyG/KmWbQ+tO/ZVA7Pyg8eCFG/q6aANpjb6z6JKmhIR3KWjsdbYFFuYl?=
 =?iso-8859-1?Q?BLe1j5/2qrTh46WzeOpvrGqDn3yz+Nlkkn+LDTpx6SU8QtZWmT+fSc86MG?=
 =?iso-8859-1?Q?DJWR44T5Y2xPSKhMRlqYe4LYQrNqpa+sluIPo/yjVZ1LxaMZBTjyGdWY+O?=
 =?iso-8859-1?Q?gTjGbt6jbLsEfWV6Upu51nwwLmV2/R3BlNf74UjzWYgTyXuMWZB94mFpJy?=
 =?iso-8859-1?Q?O0n6oZ9vWvRSoIliJn6IQ0u23BONBbyjoLDQuonSepvzo1NCegAWia+BXX?=
 =?iso-8859-1?Q?gvmb0y0g6gwhT7FOgsUX8vWkTgMZS61NhEQl+cW5dt5aRk2TqWnlVMhK9k?=
 =?iso-8859-1?Q?IJWo2t6P3+SKdAMgAShPhLRJiJh+e8GEOyYVTd4J6gT7ad7QVh9BUTrC2/?=
 =?iso-8859-1?Q?9Jmj9iokd7jG8NYjBPM3BOD1A6RODA75yBwFeGvp7y3l4QfrrqcIE8KkTl?=
 =?iso-8859-1?Q?XcUW7d7u+Hh1kiSFho4u+jeeH5zRwE5dfFzZh1nSNxUa?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: be2114f5-1d15-45d4-bc5e-08d8beb0c01e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 08:36:01.9268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fIJU33ap4k12tLFOpjx+5v2yYNEf/KDB5dXOwh5gcOZJOjvtykHimVyarl/J30GjCo7X1NpuzG1bAsBUDKEESO+2cX+iOVwNFT505fGMdLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 14:21:52 +0200 Ido Schimmel wrote:=0A=
> On Thu, Jan 21, 2021 at 01:29:37PM +0200, Oleksandr Mazur wrote:=0A=
> > Add new trap action HARD_DROP, which can be used by the=0A=
> > drivers to register traps, where it's impossible to get=0A=
> > packet reported to the devlink subsystem by the device=0A=
> > driver, because it's impossible to retrieve dropped packet=0A=
> > from the device itself.=0A=
> > In order to use this action, driver must also register=0A=
> > additional devlink operation - callback that is used=0A=
> > to retrieve number of packets that have been dropped by=0A=
> > the device.=A0 =0A=
> =0A=
> Are these global statistics about number of packets the hardware dropped=
=0A=
> for a specific reason or are these per-port statistics?=0A=
> =0A=
> It's a creative use of devlink-trap interface, but I think it makes=0A=
> sense. Better to re-use an existing interface than creating yet another=
=0A=
> one.=0A=
=0A=
> Not sure if I agree, if we can't trap why is it a trap?=0A=
> It's just a counter.=0A=
=0A=
It's just another ACTION for trap item. Action however can be switched, e.g=
. from HARD_DROP to MIRROR.=0A=
=0A=
The thing is to be able to configure specific trap to be dropped, and provi=
de a way for the device to report back how many packets have been dropped.=
=0A=
If device is able to report the packet itself, then devlink would be in cha=
rge of counting. If not, there should be a way to retrieve these statistics=
 from the devlink.=
