Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDA343D1EB
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbhJ0T5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:57:11 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:8709
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240344AbhJ0T5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:57:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0IBqAy7vD/p0aH/MmIUUeH1+CpP2lyZnfhgVzu5BnWKc57L5UIBYttWVrKVvEB1lMw1Qh1GHjmvDsTXciGOvBPg7raPK20c6OHGxMFplu1b/UJ2wrqSwQzmQKPRm4JabiAjM7gPHrpR4VNA9xw24E/Zp8zePNHtBI2B+lS4C2Q0xKVDpga3WJTj+KbFp3ZxM/9omjhZxXVO/D5QFhfopioSrAfrVel5HRiM6BlAQtKkye8ZtzNwOzGDPM+GVkfZZOFKky8VNqXmC5tTT3L3IAHxCrBC0r4gH8u47PLmX0haWR4+Qy7hqYGm8yuCpHGlUsFOTWyU7LtK6I6Qthm9XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ch49ad18ru6lhUNERfMnv45zIdk2XPpm8AUdgxTOAN8=;
 b=BEfUWV8C7OcnYC5BcBrhN+ul9Jq6b5b/zcYc9DQ+m5ofpgfR2IN9YqFnBWTtsxuWZiEB+TxvKhUGhMn5a2d4+FddQhMApAWUXwtYWBWtx0j5tGuVaJl8NIXeUV9f0yNsnt9OSljKUPs93jVnRLk9xp+9otJ2ILXbWlp/4uW2Pv4XT8zqvFByrMBq1HaxG02qvsOmBN+nggim424VIYEtUmrD2diXwFvFDbZ6Hx8uAcvNSyV3YcHFr4ehMj6nw+bPsAJ5QXuMJRRgmJvMd4wfdAC3tsibSJucqur7A9s4yQj4NDiBWEpzJqYLmpIL1MkAL4SL92s2HpXdVIt55NZa/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch49ad18ru6lhUNERfMnv45zIdk2XPpm8AUdgxTOAN8=;
 b=L9lyMjL2UimlxtpTNMlvvq21p/yg3G22YP5rrsxYJ20HIIXVSKLGpO2U9vDwHHaLNKEDZEP8TAMXmJOINi9DaIy5vFmNNpxrSafVvtTvMAIlNzgbv7e3Gq2NgabnUQSpfgVwCV55kNcw47zug+x359ANoI/P9xnVZr7VplC8dpI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 19:54:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 19:54:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/5] net: bridge: provide shim definition for
 br_vlan_flags
Thread-Topic: [PATCH net-next 1/5] net: bridge: provide shim definition for
 br_vlan_flags
Thread-Index: AQHXy06zYKcVsip7T0mT7OBKW9nN56vnOvIAgAAE7wCAAAFggIAAARgA
Date:   Wed, 27 Oct 2021 19:54:43 +0000
Message-ID: <20211027195442.mwlyvrokj6ygpv7m@skbuf>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-2-vladimir.oltean@nxp.com>
 <a8d9df33-408b-a2a0-2e77-754200ff7840@nvidia.com>
 <20211027194552.3t4l5hi2ivfvibru@skbuf>
 <97a4088c-ba81-229b-0f7c-088a0069db41@nvidia.com>
In-Reply-To: <97a4088c-ba81-229b-0f7c-088a0069db41@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 827f91e0-5c22-4573-7019-08d999839ee6
x-ms-traffictypediagnostic: VI1PR04MB4816:
x-microsoft-antispam-prvs: <VI1PR04MB48165B903D130E0C9C64DDA2E0859@VI1PR04MB4816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +GssbhmzAx9A9j6zDOB6I1Gb6Vp+QDSfPHy5ZE/SOPCWzUdqzi/SXiokcUzviFOVpyn0IJHaNzU3huD0sKgYqhMNLyCIqcLU/iWHOSNs/p/3mRfcXOF85bh6FPurC6EJ74jhXBXp91bmp4pbz+pINHEi0qRD2UPDK+T8MJkrWXt4ZEfIWw+grpackMgkxid1hXES5bhu90JJonYd0nMB6yHKySxLeGebv6TqEbvl9iuTlM55lO5Dgm33BIXJcpUWiDPRsDvnUJBe//8mUVh7O/ozNUPdZcItYP0M+OYBh9N4QRh50NMtLwNp68W02bvqdV9BFCO+kplj4fkVKzMqRP7aFtNj94yBUvapiljTO+AQEUldavIdREm4y6rz/gJbK5c0WvOSh3qkS2NXSIGUihrsATBh7oXi0Kf4H6C9rdHbbsJaoUNMh9JtYUSCPOt8glcCkHA9ChX+I0DuqDqCRjJ/MqXYVrtsS7TuxpXfQxrp62k9U7o0siYcx3rjySL10QYtwuKmcUjq+6sV1FrhBwV1PIFWwpWo2Jj4YlCr8CaSBx4TE7MUdJUtQSe6weWV/X8AzsYzoq5FbaZR8NGVqF/GwOkxJ/ilFFHU6Kq8SyWgcC1YKhLqKEHErZGjaQvaXLr5OGxGzWvurwPiF25R2LqRMpbk7S4rbCgwgYUKYNAOtLr/02/wv9qjkI1UNA1nDAQJGB2EPmozALvR5yQ6yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(186003)(1076003)(66446008)(6506007)(508600001)(2906002)(91956017)(5660300002)(316002)(4326008)(54906003)(122000001)(53546011)(298455003)(38100700002)(26005)(6512007)(44832011)(83380400001)(6916009)(38070700005)(9686003)(76116006)(8936002)(66946007)(86362001)(71200400001)(33716001)(6486002)(66556008)(64756008)(66476007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lDUa008xaiXbwbGp2X+Iuh4SunrVOmczsNzj74/Anp0C4w1RgvX3IcIeN277?=
 =?us-ascii?Q?5IJUHKEwgqwf9M2pKpI/ZQXvcFbZyIlCfAatCeFHA2RwGH5qKSDzj8IBSj8Q?=
 =?us-ascii?Q?obXei/lJMgNT+Etx/pgU9T9laU9tmaD4QiYmahkUN9CiqMihxAevjpb2D292?=
 =?us-ascii?Q?GPH5J+EP2cANnhGw21SwdGH1iuUDlzrAYzh01/actyGjSQ+kYNdQWMFG2z13?=
 =?us-ascii?Q?tkOogSEjfihYER/uHbbzvXQPcz/Em88Nl6KDo2liwCiRS90JWjGTXIrixF5y?=
 =?us-ascii?Q?za4wJzb1o/LefI1eEEZDSlJBJue6VF96p/Nha8skarhBEL8YnjT/SQLgpuRF?=
 =?us-ascii?Q?Leb2iQlJnJDeocbBJmuMy0sO3w8afOIkeXKFY20niYhYHqrnl9bpbPtJie8c?=
 =?us-ascii?Q?EMWAgGUJlfnjN7if05mXX/O7euUHgRrIGl+wQch0DhuPZe3FPkYjIBJaxRGD?=
 =?us-ascii?Q?7DLwa8lU5u38jUk2zmHjzvt2b47GHcj/X+1WuD0vO/dgc3B4NHYLI439U0QO?=
 =?us-ascii?Q?FsvUIu+dnTk49uWmAXIYpmLYwugI5Vhh+ZhK5jSwsx1/B8GGAus0cfdC5LL2?=
 =?us-ascii?Q?QNN/eRzriNzew30/AcpsR6meTIFzmfiNBwz29/3Lu+fvO4Fv7JJoKUs2QFHS?=
 =?us-ascii?Q?zuT908UDqW+k4ndSsB4lKqTD98rK19UvjJtd9+EmcY7fTHDuzYAfMxn+CRGY?=
 =?us-ascii?Q?Z6sVl9ZsE51uge3nh8rQObie9g+LuOJtUn5sZtLMPvZRqI1gj+e58WF4x54j?=
 =?us-ascii?Q?dZczF3wRojyKJXDVqCUpFdHtDbDjQLKs5mhniskj1cnFzYdxbH5zlgPx+Fgd?=
 =?us-ascii?Q?p/HjHMa2Jyl3I+c+YPoBonkbFL4qBf4veDLUW1wOXB6opdzG4+HwjbEvpJWa?=
 =?us-ascii?Q?mw2wKsob4a2n/o+2Hgic61bsPgdflA7iiWNvJA7GYagYfmbzt7GCXEy9zs15?=
 =?us-ascii?Q?tLBmeT1sxE/oAsmGuKvtw4j5LtUk86iJk0tMnJVeaRgUqU0ied6bXXYnMf0A?=
 =?us-ascii?Q?v/ctNhX5eYlJTi9bp+zycj5o2O6uhi3mtBO9osiHj7YX7Xz8Cfc01nYWYTGM?=
 =?us-ascii?Q?wsFEo+a7W81ywFKyC4cYlm8VGFFNBXqiB44oKc6Oi03mFwAno+AiD3QVChZg?=
 =?us-ascii?Q?ah3DJKBg7t62+28+SWGRrOaibiOAmialEK8efCwo2Cmz1ODggcY4mduY1GyC?=
 =?us-ascii?Q?1qszjq/nbrBTIYKpsjyde7r9ub1LpwYUVnatEkSN/t4sHmxBGNzllb3jhsPh?=
 =?us-ascii?Q?GycpJ/oGyM682g5k3K/J8wS78Hd8Vv5WYo/OOFSEzTz88RrwIxu0T1svHr1F?=
 =?us-ascii?Q?/9YQ+Z23BXaxt122SZqCWCaDxzNg45RwNjdLV5XvnFbyKYT0kvYydou5YAYK?=
 =?us-ascii?Q?7ra3+sOobwiZkP2A6YRUrTOHTGK+xS0tjhDcu77xXf2MrdzZyeV/yaYWGVa1?=
 =?us-ascii?Q?9tvokFOtQpYnesz6NwDaQAux1GUNerYYIPTK7+rJPGEsw3H3Tm6x9rjznEnT?=
 =?us-ascii?Q?irvmv5f/yXi5z1rmrriLNlbgGmSr/fG6RKsf+qmNCgHjW/U3blzhKY9v4yLs?=
 =?us-ascii?Q?rtzazqRuOYhdmFFAfGVseL8b+39EdakF1rbcW/ZtaRTi+bW9kwWF/G9NKd7x?=
 =?us-ascii?Q?+KL1umbQwIgDCVEuGRc6F4ElIDGbSgc8BxytUC4yVIV8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A7C7C68576C8974F9C8D272192CA0EA3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 827f91e0-5c22-4573-7019-08d999839ee6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 19:54:43.2674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KfIl7CaC4bqUvAxvp6ZtYQ78Sm4TXpBogMuf2TY6AVXZZdBYuWS24CwI6fDadsUea9h1IZWFcM1wQhwqxPageA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 10:50:47PM +0300, Nikolay Aleksandrov wrote:
> On 27/10/2021 22:45, Vladimir Oltean wrote:
> > On Wed, Oct 27, 2021 at 10:28:12PM +0300, Nikolay Aleksandrov wrote:
> >> On 27/10/2021 19:21, Vladimir Oltean wrote:
> >>> br_vlan_replay() needs this, and we're preparing to move it to
> >>> br_switchdev.c, which will be compiled regardless of whether or not
> >>> CONFIG_BRIDGE_VLAN_FILTERING is enabled.
> >>>
> >>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >>> ---
> >>>  net/bridge/br_private.h | 5 +++++
> >>>  1 file changed, 5 insertions(+)
> >>>
> >>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> >>> index 3c9327628060..cc31c3fe1e02 100644
> >>> --- a/net/bridge/br_private.h
> >>> +++ b/net/bridge/br_private.h
> >>> @@ -1708,6 +1708,11 @@ static inline bool br_vlan_can_enter_range(con=
st struct net_bridge_vlan *v_curr,
> >>>  	return true;
> >>>  }
> >>> =20
> >>> +static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16=
 pvid)
> >>> +{
> >>> +	return 0;
> >>> +}
> >>> +
> >>>  static inline int br_vlan_replay(struct net_device *br_dev,
> >>>  				 struct net_device *dev, const void *ctx,
> >>>  				 bool adding, struct notifier_block *nb,
> >>>
> >>
> >> hm, shouldn't the vlan replay be a shim if bridge vlans are not define=
d?
> >> I.e. shouldn't this rather be turned into br_vlan_replay's shim?
> >>
> >> TBH, I haven't looked into the details just wonder why we would compil=
e all that vlan
> >> code if bridge vlan filtering is not enabled.
> >=20
> > The main reason is that I would like to avoid #ifdef if possible. If yo=
u
> > have a strong opinion otherwise I can follow suit.
> >=20
>=20
> Well, I see that we add ifdefs for IGMP, so I don't see a reason why not
> to ifdef out the vlan replay in the same way too.
>=20
> I don't have a strong preference either way, end result is the same.

Since the caller and the callee are in the same C file, shimming out is
not as clean as providing a static inline function definition with an
empty body, and if I could avoid doing what I did for

br_mdb_replay()
{
#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
	<some other variables>;
	int err;

	err =3D <body>;

	if (err)
		return err;
#endif

	return 0;
}

I'd do it. For br_vlan_replay() I could avoid it, so I left it at that.=
