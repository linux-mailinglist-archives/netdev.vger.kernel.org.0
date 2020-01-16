Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381A413DCE8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgAPOEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:04:07 -0500
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:60511
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbgAPOEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 09:04:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLpUNbz3qp/2UJTdRhdA9SlDDotm9nhu+Ng0kmkYmipzMT1ikRvx1gK2kgpvnHL0FQxGe78SC5tFgSRKAv6dOuOeW7/o5mNGXSirXw8oKKsLt8m5FIX0xPhpXRgYnP9fr7J6HlLY9NqEl4rFBrMoEcvjHIUFxEAop+EEsVIfll4rWEzcG0Gdv/cSEjS4d46JoE/JcM0Q+CwMX2wQTsnl/OO3rhZxEDpLgdQCIHV9p5Owi6OAhSA68OD49prK+5wBTLL9d4IcDA0QlGCx+ERhNTdm7r00TdQADU7v4lSRlwtbK8Z+9h1aRKOj3eeq5OnIkLhcLZquFLkwjdIcsV/7ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBv4s5Sicp/TC4bsH33ENHqHSIl8QPZNmUVyT8oxnns=;
 b=DhSvUtGTk7GQ54T9m67W00aak3xwiRJ0Wrp4hO3Z90saPna43sXAhWqBvsUjahQ9GvhI9rrOYtfO8q/tJjnTnQkhwdAVcNo7pR1Uw/y58Vz0QemC5uCJEtBF+Iu7jH6I6SCz31hIw0fJ8QZRiW3d9+wsebszMfk8iQUPOYFt0dUpfyrHllZo6jElwAwCB3JgVMQ0VTXSOWwwBTPZW8Sbb+Z/U3i6ANvtLYc5Ya4kodvyN5R42UDlM4+gAK5271FgkNaVpgnpuAi8/WTJU4AIh6tszvucicpQ+QtDtZjNyIrg6nmTM6tpWgyfHLbsZSloF3kUJdpWy8vJooTt6KQekw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBv4s5Sicp/TC4bsH33ENHqHSIl8QPZNmUVyT8oxnns=;
 b=qq8j5p3ytRVTtLPx2DagNHnNF+MmM7BDiZAH9D3iG8sT/m7AwAMUeR95xsxlxwIxB8KMGtuFdGCGZuuPuwJXKIgj+vgk1ygA8n8FFDJktxHW+BzX17gVJphBWcjC/A1lAv7kDViYM7dAq8WaY/KoqfKiWPMHWPgM1IHtl8F4xEs=
Received: from VI1PR05MB6734.eurprd05.prod.outlook.com (10.186.163.17) by
 VI1PR05MB6302.eurprd05.prod.outlook.com (20.179.25.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 16 Jan 2020 14:04:01 +0000
Received: from VI1PR05MB6734.eurprd05.prod.outlook.com
 ([fe80::5d57:f705:a027:9cb8]) by VI1PR05MB6734.eurprd05.prod.outlook.com
 ([fe80::5d57:f705:a027:9cb8%3]) with mapi id 15.20.2623.018; Thu, 16 Jan 2020
 14:04:01 +0000
Received: from localhost (193.47.165.251) by ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Thu, 16 Jan 2020 14:04:01 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Hongbo Yao <yaohongbo@huawei.com>,
        "chenzhou10@huawei.com" <chenzhou10@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [PATCH v2 -next] drivers/net: netdevsim depends on INET
Thread-Topic: [PATCH v2 -next] drivers/net: netdevsim depends on INET
Thread-Index: AQHVzHTPN7Ek1rcIXU+yWLBjnF5Mj6ftUq+A
Date:   Thu, 16 Jan 2020 14:04:01 +0000
Message-ID: <20200116140359.GA1817679@splinter>
References: <20200116131404.169423-1-yaohongbo@huawei.com>
 <20200116053137.4b9f9ff9@cakuba.hsd1.ca.comcast.net>
 <20200116135412.GK2131@nanopsycho>
In-Reply-To: <20200116135412.GK2131@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::15) To VI1PR05MB6734.eurprd05.prod.outlook.com
 (2603:10a6:800:13d::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2d81cef4-9ed5-4db8-649e-08d79a8cf03b
x-ms-traffictypediagnostic: VI1PR05MB6302:|VI1PR05MB6302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6302DEEEF8692762C2743D28BF360@VI1PR05MB6302.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(189003)(199004)(478600001)(4326008)(107886003)(16526019)(6486002)(186003)(6916009)(33716001)(9686003)(2906002)(54906003)(316002)(71200400001)(33656002)(66946007)(66446008)(64756008)(66556008)(66476007)(81156014)(8936002)(8676002)(6496006)(52116002)(956004)(26005)(5660300002)(81166006)(1076003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6302;H:VI1PR05MB6734.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7w/L4pqVw04aOungub9/plI71Nt3wBQjfcKao1qre96o9McWRC4mS/KOtym5Mr9cvltVJGcq14r0PqSpMo/wV4FkuI1yrxfHe2+wbdqEiv2knQYj1OJsUMIJHJqwokJodCKnScV0NRVO/ermUmEL/8rZfClAAy2QUKgz8vGUNnEmefajP10voV4A5AqPUMdDv5koHweWmK3IncDDV18kW1Wob7Usx2KmQhBwWfKeU5n3vWPXD2zYOWF+vCNgiRG3sQFtTSf6HInNN4o2fGCHxteRl1CdYV1euzbSyk7SL8vakuBeeBVXuVxTUbSKmZIoZ3G1i3eXdvFe69SQbncL5DjOwa+0YEKQvj1+QnL6GTB99zNceFy4KGkjhWZ4aBI2WNMjcKG6xPfl2kSOmpflW3WU4sRpsnJEn1idh4o505rutfksnq4TND/mOmEmJaCu
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1AE8C3AB23E8BE4F8DD74189171C3DE7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d81cef4-9ed5-4db8-649e-08d79a8cf03b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 14:04:01.6112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B/KcBbR67Y35xXT9NJUcWVjkMkpN0NQ/ZqZkDgX1TRF3wLqJ87/sedpaenoDMT+K2Lo3HkctBwwmbQHnQQ+80w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6302
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 02:56:50PM +0100, Jiri Pirko wrote:
> Thu, Jan 16, 2020 at 02:31:37PM CET, kuba@kernel.org wrote:
> >On Thu, 16 Jan 2020 21:14:04 +0800, Hongbo Yao wrote:
> >> If CONFIG_INET is not set and CONFIG_NETDEVSIM=3Dy.
> >> Building drivers/net/netdevsim/fib.o will get the following error:
> >>=20
> >> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_hw_flags_set':
> >> fib.c:(.text+0x12b): undefined reference to `fib_alias_hw_flags_set'
> >> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_destroy':
> >> fib.c:(.text+0xb11): undefined reference to `free_fib_info'
> >>=20
> >> Correct the Kconfig for netdevsim.
> >>=20
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Fixes: 48bb9eb47b270("netdevsim: fib: Add dummy implementation for FIB=
 offload")
> >
> >Looks better :) Still missing a space between the hash and the bracket,
> >but:
> >
> >Acked-by: Jakub Kicinski <kuba@kernel.org>
> >
> >While at it - does mlxsw have the same problem by any chance?
>=20
> Looks like it does.

MLXSW_SPECTRUM depends on NET_SWITCHDEV which in turn depends on INET
