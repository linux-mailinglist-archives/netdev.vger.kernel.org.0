Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFC93DD455
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhHBKwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:52:45 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:27425
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232553AbhHBKwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 06:52:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Brq+Ull+BZZOCvDUU8cvtyx0ECDtymphkSLETqdaV0XS0ESeao2z00X//zuHgTUaH0WXi61O6mLh7wRRykH5rOItt/zSwyrUZI3bxuI2bsA5VkRC8BuqEgmPhP0k4NryvmXwbWYU3i0q/agYKL+YqFfniVLY++aRrmYTEna31kWMBDXpE2Wku28WRl2jmNiNa1QxBKl8bvoWW0GPns4cK1P3E1lr1Ry3s9Awwhb78bxXfrBZuhSDcjsQeZWOcehUpYxl1BZZc66DlUZ7QURjapHzwFpbR1kFnsJWfyxHC82wohHvFK6RR8Rc5pcP/mJnxsPR+7hz3W7xHcIRhFc4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSUuVj92+VuObyRpQZSJYxDeRmhjpmInepr9vn4uIiA=;
 b=OvJU89TahEcDyCAd9qVYrkFePw6qGdiMneu4GQ6js/MJEa9iZdrxtd+uDQiGSOBzWQU89kJ2UDG5v1uabbKD7xsKrq4B6BeEXf3osW37QQuu77p+2UbvIOAJDN7KioEYE1lKV3AoAnCN5lX3W6Bpxiwm5GtYyQrmH90/LGL72UNXyxynjC4/3YR+wXgFh6DOli4h9BymjyBTCPerOG1NzI2oLoEqNZyTwzjmKQzDxSKf9Linbhfwh211yLgKh/Q7onkXEidTsxHC4gyCA0KvgNfvkX5PpuxMfbtnLYpgmkDwwCtKM3bXcjj63KmvYrSGESRvSrnQHBa51SioOMeJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSUuVj92+VuObyRpQZSJYxDeRmhjpmInepr9vn4uIiA=;
 b=XsGWne0A+WsjyCM21MbXkvE/wY65sy+x9fFd0qAMmMzbJWngB98Wjc9YxImCVDLkCGUv9igOkuCUp8S3FNhFsGFW2xwK1IRKBwFxKALPXizk2SMzxbjBVbkEJTb5Ts35BRxUuIJg8atPpIdhMOMlXmjW8UwYehLEINK6U72jtt4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2303.eurprd04.prod.outlook.com (2603:10a6:800:28::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Mon, 2 Aug
 2021 10:52:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 10:52:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Thread-Topic: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Thread-Index: AQHXhyttiQTxBmfp1EqsG/8ivlTylqtf1ZuAgAAbcICAAAX6gIAAE6KA
Date:   Mon, 2 Aug 2021 10:52:33 +0000
Message-ID: <20210802105233.64r23kucu4mjnjsu@skbuf>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <ff6d11a2-2931-714a-7301-f624160a2d48@nvidia.com>
 <20210802092053.qyfkuhhqzxjyqf24@skbuf>
 <451c4538-eb77-2865-af74-777e51cd5c31@nvidia.com>
In-Reply-To: <451c4538-eb77-2865-af74-777e51cd5c31@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe41cbe0-e0a1-465f-3f99-08d955a3a21b
x-ms-traffictypediagnostic: VI1PR0401MB2303:
x-microsoft-antispam-prvs: <VI1PR0401MB23038C6A17E1D416371B89AFE0EF9@VI1PR0401MB2303.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RPnjdOhqp3VZIwFwObRT4nB45Q/R8ULZIJXaSzh2p3nS2awLky1eZLmJq4XxBoMkuK5/KxilFYaNhgMvNbaDO4KhDZwj4w7Au9tHsX0DIaZTPpu4w/eiMB2azXFz3xOasrcxknUkJlPP0YUkt0geDgUGyTKUX9rC0HAO8K9xbEf5wcjg+jDD/bo5qsjrRGV17FXbUXz7ex4ga6Tt4KKHxLCGaWmVjNNeXBuIcnFHFilCZc6sXc9QLUwqsA6+FZjDXGQR6DQXPzvHH4VcDeuSBCYDuHZcC3TlHVwEwFRERnJS8kILpOM3+pLnCGBBXaFAqfcjUHYU02iRlgoRiovk0GriawK3S6x3Zuzkw1vCgoM1Ggh+c8/Xii7dp2jNEKbdinrMUkvSEBe17r4CluahmoYb9at2+86Jzw18cHZdRXIh/y6oyBm0TW1xv6abDpdDX8o5UNq45xx04hf0rJ9vrbM6znxWtEmkSlhN1dsSTSB6oDxzqbO1BcaxicwoccU9+MqTogGwEcvUY/0kG5wWh9FPj0WGi2k63EhFkWZFYQRMw8HLMbGmoAbqPr5k6g9RDe77c3LeCqcCovMULERxznTAuH3/GKkPh62xs54i1ep8nB+nC8LDBp1feH5+M5JtOtMg4gyklRdOXtWZDBKL5lV4rMqHaTb7d3rC1D28LfYLFq7EvhmYOOmDQ8QlJfMRGENasWexdxx5egh5jS8w0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(9686003)(71200400001)(66946007)(6512007)(64756008)(5660300002)(66446008)(316002)(66556008)(86362001)(38070700005)(83380400001)(54906003)(76116006)(66476007)(4326008)(478600001)(33716001)(6916009)(7416002)(8676002)(44832011)(2906002)(122000001)(38100700002)(6486002)(26005)(6506007)(186003)(8936002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5tPc+X9PrqqnrBB9YFnVnl+BzpBRWbJp1jOhEU6RyspTlidnJ82BnZRdYNh+?=
 =?us-ascii?Q?xSMEcZnowF1SJSm+zjci+0ucFKSUAaWzl8S+2ORAEsxUPY6v7X0AK/F/7rlB?=
 =?us-ascii?Q?pS7sp8L5zM+VjzGv1rnj2ZDQR2Rr15fPZeLMCC/d7HQAnFVpc+mBfo3STS0h?=
 =?us-ascii?Q?oeEF0s6vpESd7Xu68I5QCmOlcPBOfFWOGdn/5M+4Z1izwOwf1fGWvRoO+6bk?=
 =?us-ascii?Q?khNJGiouDuvuapS7+cHT9pAHcUYekxlrWf9Y9UgNqGZvoOQedew+pJCVnlHz?=
 =?us-ascii?Q?nBTgYzarPoVO6G3mPFIj16T2hSsE2fB+0UFTIFcXSjtzWETbQqBYhky5Zw9p?=
 =?us-ascii?Q?azT74PHDSco5zkyVyBVYchm5WcVPpXp8GYAF4oKDua9G2rH4JTKs/qLfMjEw?=
 =?us-ascii?Q?vTL2bzs4xmtDH8KeUfIcgd06r3U1hEjYB1nCsnjLltD0jFcfiNC+2aK5s9Wl?=
 =?us-ascii?Q?lvvufwVzqAQp80YrRMpKLCAg3cPlWlZR23cSJkrddSgLh5nY2Sl0V+9EGaN4?=
 =?us-ascii?Q?0LvXqdY9DEnL62DWbHTzrVFM8OpU750RmqMtB/52Ud8N7Fc/l6QkM2acCdoU?=
 =?us-ascii?Q?OremG6jwWa0e+2WWxvGRWWRMQZflu5qrqLGOqIab8w1+jRMYGhsGagYz+EQr?=
 =?us-ascii?Q?HkWhBdInRZn9zJ12DMrZvj9u1Wp3CKOwL/Dv8NKYgKK4xjbJFJG20RHUU9QY?=
 =?us-ascii?Q?ExsEREv+8WSUyyvMd+7m2z7srMa8rTCTZI80y4gFYI+wqtBe3gR0jXoZEkIt?=
 =?us-ascii?Q?3m/LqZCJqB7wy9fbv0amg6QD3TM1sQmhLLb2YVRxSCbB/1knKMxGrK3FBGvP?=
 =?us-ascii?Q?kmBW2aZt+J8Y+VG28h56L9NLldycKAASK+zmZJ11fMeyvfNBSbpfJpvDWlnT?=
 =?us-ascii?Q?EvW8uTwjHJHaJ4p0gne4sl5JUoMKJFiAvteXmGZRbW6sAP5haU0N1SygDAN4?=
 =?us-ascii?Q?fMCAXtR3OZhCOV6y4z7EZr1sDm54cqHOAp9ua0QQv642NWKOtI/wbZLpeZdK?=
 =?us-ascii?Q?350tcJj5ajkWibqlcuMjCfxL8KyXOaUesRCoxT9y44KlIL/9zevPYEOaFaju?=
 =?us-ascii?Q?X5FgJhVUIqwF3SY2FzYJ1cOp/qCdd3uZjVXUyVeFz3fcOwWWe6wzxjZVYVcR?=
 =?us-ascii?Q?60MAdeS70QVz3CQWwTTihTvoq5kBSyQ8ytvkI4F2cv5yjOM3F+CsXAof/10U?=
 =?us-ascii?Q?Hn1x63AnbobWceVwGZny2yO23Yl5rAyhS5E+Sbx7bTD6fQJdOkz0uYlcI+yS?=
 =?us-ascii?Q?GsY804o2ZjYq2TfQWzVrAR3RboxN/4xgX+CLZ0fONLBYO5kFHUQlU/jJpnXN?=
 =?us-ascii?Q?9oMqTpGQtY5Gw1gqGxtl5XzQ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8A74A5EF58A80546AFC031C8812AB8F4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe41cbe0-e0a1-465f-3f99-08d955a3a21b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 10:52:33.6321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G27QVkjF5Chs54gzJRurZUtgsxIZtj1bWFkXckiwCB1aUHUbfixLYNZg3r7lUCtc06LhDSCbEmqhoSRXj0FK0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 12:42:17PM +0300, Nikolay Aleksandrov wrote:
> >>> Before, the two commands listed above both crashed the kernel in this
> >>> check from br_switchdev_fdb_notify:
> >>>
> >>
> >> Not before 52e4bec15546 though, the check used to be:
> >> struct net_device *dev =3D dst ? dst->dev : br->dev;
> >
> > "Before", as in "before this patch, on net-next/linux-next".
> >
>
> We still need that check, more below.
>
> >> which wouldn't crash. So the fixes tag below is incorrect, you could
> >> add a weird extern learn entry, but it wouldn't crash the kernel.
> >
> > :)
> >
> > Is our only criterion whether a patch is buggy or not that it causes a
> > NULL pointer dereference inside the kernel?
> >
> > I thought I'd mention the interaction with the net-next work for the
> > sake of being thorough, and because this is how the syzcaller caught it
> > by coincidence, but "kernel does not treat an FDB entry with the
> > 'permanent' flag as permanent" is enough of a reason to submit this as =
a
>
> Not exactly right, you may add it as permanent but it doesn't get "perman=
ent" flag set.

And that is the bug I am addressing here, no?

> The actual bug is that it points to the bridge device, e.g. null dst with=
out the flag.
>
> > bug fix for the commit that I pointed to. Granted, I don't have any use
> > case with extern_learn, so probably your user space programs simply
> > don't add permanent FDB entries, but as this is the kernel UAPI, it
> > should nevertheless do whatever the user space is allowed to say. For a
> > permanent FDB entry, that behavior is to stop forwarding for that MAC
> > DA, and that behavior obviously was not taking place even before any
> > change in br_switchdev_fdb_notify(), or even with CONFIG_NET_SWITCHDEV=
=3Dn.
> >
>
> Actually I believe there is still a bug in 52e4bec15546 even with this fi=
x.
> The flag can change after the dst has been read in br_switchdev_fdb_notif=
y()
> so in theory you could still do a null pointer dereference. fdb_notify()
> can be called from a few places without locking. The code shouldn't deref=
erence
> the dst based on the flag.

Are you thinking of a specific code path that triggers a race between
(a) a writer side doing WRITE_ONCE(fdb->dst, NULL) and then
    set_bit(BR_FDB_LOCAL, &fdb->flags), exactly in this order, and
(b) a reader side catching that fdb exactly in between the above 2
    statements, through fdb_notify or otherwise (br_fdb_replay)?

Because I don't see any.

Plus, I am a bit nervous about protecting against theoretical/unproven
races in a way that masks real bugs, as we would be doing if I add an
extra check in br_fdb_replay_one and br_switchdev_fdb_notify against the
case where an entry has fdb->dst =3D=3D NULL but not BR_FDB_LOCAL.

>
> I'm okay with this change due to the null dst without permanent flag fix,=
 but
> it doesn't fully fix the null pointer dereference.

So is there any change that I should make to this patch?=
