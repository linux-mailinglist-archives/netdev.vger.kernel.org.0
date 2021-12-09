Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E047946F296
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242747AbhLIR7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:59:54 -0500
Received: from mail-eopbgr30046.outbound.protection.outlook.com ([40.107.3.46]:62475
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231868AbhLIR7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:59:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEMpyJe8Vgx+PQfSc5XQP1O76JMTto6q2h0G59OQ4zfR/uGdPT5DkVqC8Z51D/o52beccgIMJjV7iqykgyyaZzfsFfvIE2K8NbiqXiX2+5sH7WMmLQPPIIVmRvxOKUyr1UClg2CnJoYw360mhEorOU8iXhfrlTM1owBwsJ6UN5Puh9pu/+7HJEdLWq+AAaVmMzRMjulduf3lbnIkhVjsEdVHkpy6crsjeqv9tiUjxfnaZYWUJF1rFkvzBv1GKfOVb0eivcPkFQp/ludoUUQTPEphnSnRXaAzV/5BVH3cm4RJnSvxCqC2u0ym66eI0zAxZ/lmEutNbJDhjd1GK6O+4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xrhv91KKIKKiJ+4M3f2aooC9ykJEM5aABYX0ills+4s=;
 b=B2ZXpLAN43AqvXs4/vxQ4mg5P6U5pBXypFIX1c90txX+qkVEJYXEOyt3vbW7/vnse1xbkLlCmTIfRhoFdm2CP+uY3pk0JDvRhkVzkkODYrGt68WW4g1z+VKsYGz2GLEIzNsz41+Yxqo3Onpryb8NfHx7NgJtx8PI38c8Ltg53usXH95syob0kyTmom2D7/5kgYmBMyCmuxSjh9jinFtsrqO+DnBvAOe4ieSsFKt3ZzxdAiczCRZ2C4/kKXNfOfQ9l71UWKE0QiNtZMIN/T1IlDgKgw2WYEmUipoS/z/kwa24iGQk961eLy4lPtWEAGuK1q4y01hjG978U2P3qoeAug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xrhv91KKIKKiJ+4M3f2aooC9ykJEM5aABYX0ills+4s=;
 b=CnejpUQrOhegy7m77v9F3ytZyfPDg/bx7ZnZKjPbRwV30+ZsCH6U29p9o+Imw8kFmXUaRS3sqWHPXz1k1KCp7BlApbsKwwwovCEZWUv3UL4mjPmW76Kud1Y9zWjdbRiSDQNQReUKo7tsTH6CxFa9bg424fvO8asBuiEjd9+9mH8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6125.eurprd04.prod.outlook.com (2603:10a6:803:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Thu, 9 Dec
 2021 17:56:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 17:56:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 0/7] DSA master state tracking
Thread-Topic: [RFC PATCH net-next 0/7] DSA master state tracking
Thread-Index: AQHX7IOEQ9VmgGohuU2xLWeadphC86wpelqAgAC+sQCAAARmAIAALzoAgAADLQCAAANBgA==
Date:   Thu, 9 Dec 2021 17:56:17 +0000
Message-ID: <20211209175617.652rdiidc6pfgdwz@skbuf>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
 <61b17299.1c69fb81.8ef9.8daa@mx.google.com>
 <20211209142830.yh3j6gv7kskfif5w@skbuf>
 <61b21641.1c69fb81.d27e9.02a0@mx.google.com>
 <20211209173316.qkm5kuroli7nmtwd@skbuf>
 <61b24089.1c69fb81.c8040.164b@mx.google.com>
In-Reply-To: <61b24089.1c69fb81.c8040.164b@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96ed7ad2-0a59-4afb-4a47-08d9bb3d3341
x-ms-traffictypediagnostic: VI1PR04MB6125:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6125C9349333D62C7B55E9C0E0709@VI1PR04MB6125.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hGPI+A+H8PNgsinr9gIpcwmamuYOYkFmixV/5Le4iqoWoTsFBkU4i0zrqQIEc6Jx3jy/OeeWhLIQzKvFJfBAuz9DFMAWJUIOQLUImNUSNPJX4mxLF59EEEVI13C2zUFTchpnlAKEk8IM+p66/hpFqVLfgkZbWCTCtLlz/j64uBilrz3cdeJveNcQDNSln6PItnSmy9ggiJmzSIIWZuhPzOZ+KW5XJz+oxiUObLWir6V3zar7W4xacc7EaT96qXzAR9l7Ks5BJG0uf0oCAPLlTmyxPmpfWy5lK59th5qLrjAf1Sc8nr5OKAay/EexNfTSrH0C2FRyBAmsq2XXjT/5zGzALu7NOqVfZDwjr/3GxaoKU0R0LcvihFSXoBJhueLAIsfqO47/vmf2Q3fpD7faLm/tsg8u4ucM1mNeF7/it5i+4RiP69l5aWNjlO/6qHdjhDK+xQ648DLtEHn8BVpy/+ZPMaBwt7QupyD47PONxWu1ITGaqWUuJ3y1ef58c8AUa1yj+rS9mD7GD5nrD+O0O69nwrZNBoZgwDlniXVFObY5lx/5ZFqX5Q0nauEthRBNlic0CKFlkZciFhTinuCMA9sVNBEm8BzbM3GBJhBhFFJGPuyqvfNDcx41piCYAcCq93uDjjoQIqT0bJdvt2zZVFHrv2xbDc86F2StAD1Lzc/XQ5eJ4sTG2Zfq+FXOumWHHqK0brdKCl5S3LOMCaRDKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(316002)(66556008)(6916009)(66946007)(26005)(64756008)(1076003)(8936002)(66476007)(86362001)(38070700005)(6506007)(66446008)(186003)(5660300002)(122000001)(8676002)(4326008)(6512007)(9686003)(38100700002)(83380400001)(44832011)(76116006)(508600001)(6486002)(71200400001)(2906002)(54906003)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rK6DaZP2OPGTs5uUJ7ZBu/HkO7xKBLMf5DMK8iTIgohiRHBJ+XoLxccsR/fI?=
 =?us-ascii?Q?hz5fOUyk60aweFoeqIPWnZ6JkHf6Rq2fE6QqGUJIlhUMsfX3F8IlHB2ND5gl?=
 =?us-ascii?Q?NBTDv7U/1XbIz3uE+UfOq1cjnpwvXH43vJxOZXNjFRIhMa+Z0kXlhV2Jlfhb?=
 =?us-ascii?Q?DTP+5ylbzYeE5vDlr2JYrjgF5NIV/8Y2P5HNZdUntn5NmXFoHqj2XdWGZIBP?=
 =?us-ascii?Q?fnXHlfQfblOptsoIhUIpATdYb1hIQGi71urRU2ZsvOiw5dNYyTHU9m28E7HB?=
 =?us-ascii?Q?csUZI7uDuU9RK7LPSbQwP53IVrKP/fWK/wS9XZCRFwyRf7Q87lTs/4KoMdgg?=
 =?us-ascii?Q?oh+tcWGHPErLWzxGgkXn/Kbl0n3UhQuYrUiMACAI9aScPi/UJeN9zIb6olnm?=
 =?us-ascii?Q?MMBRPEL8okukJW0qPVHa+JtHEQ1sInylqQjcRDcXmZb/VYg954mIPoE55e3I?=
 =?us-ascii?Q?c3zOFvSAbZCVm8dIqr1VdpMsEOe4AavIk3YZJyhpl+RdT2bA0q02YWCglOhN?=
 =?us-ascii?Q?xRkbQr+NxstX1tfxpQcvM7Onbw9Gmg4BulKEJK42+HiKUANqwQDSeVR5vOPk?=
 =?us-ascii?Q?5hEZjgUmACZEdIWsLmuBwWcPu3APYpbsInAELkoBS3wkpK3IfiXwWLFhBcHR?=
 =?us-ascii?Q?CI0EtqcsjEp4YIfrOdgk6USzhYdcORdOPX40/BWPzNU7YFPqM9g2xizt1I7Q?=
 =?us-ascii?Q?aIP0jaHIgvgu4OoZjO5xFHaMEQnvQa0Z71TZnw7cQlvlM7t/qMTkLJVEpynr?=
 =?us-ascii?Q?aS1MjOJ31dh7GOW2cx3jqpznwIdLCaIfNh46OedjySocnsEy5YFC1Oa5S6Wp?=
 =?us-ascii?Q?O+sdAEbysdKullM3rWl/mDyyOMMc5K33++xg8gRUix5+yPDqM9JBYsCq6am1?=
 =?us-ascii?Q?g3JQF/zvd0Pn/K+gGbhsDWnnA29PbJ1d0yq05fdJw4AtLc1jWEW53LywmAna?=
 =?us-ascii?Q?TrtFpmT8f24fGPZU8Q7M+rzWjmHFU4uxMwLHUSqpszpvGT3fwJigmIuq02Q+?=
 =?us-ascii?Q?WfsN2e5a/G2s6UcdUQzbwgZXddu8cMkxKmCHRRR2haD9LZmOKLO46EQW90Iz?=
 =?us-ascii?Q?JGyVKV6VwaHMxptIK/1xbR0HbgmXykpRargwrELiGnerDifGymwf2nvRwRAL?=
 =?us-ascii?Q?aOZVvYMwpcp6OiwUe0iNb/lb3XWQjK3gGFtzerp34IzqaF0cO9ZUDy3+hS2s?=
 =?us-ascii?Q?KOpmkHBclD4C7GvXeRKRxIN85UHvKH/ZMT5Ik44F6TIxu5QLqNWt7p+doHHu?=
 =?us-ascii?Q?O9/MBZxpnhTm8yKg5d9fJ+j9lty0dtX0PCOxbetcBD28BXeAz/5Dzl+ToJwH?=
 =?us-ascii?Q?yVmRIrqX+FQpaNPHtfmMlkcLl4fsJaM3ijUfyNFViru3p5LMAbnieiBBDg7Y?=
 =?us-ascii?Q?WGk8HYeJhfK+wTlS+zWi2kt5DzzAmC5g8rKZQio18i7jKs1WjzkmYthhtpIB?=
 =?us-ascii?Q?HpNAHL7An8vtnl51B2Nkpu1XY7gOTzzvgXVKSZpYQH174yzYaC0zUG+jDs0v?=
 =?us-ascii?Q?npU1n4rvTOAur5MzA1uaM19aBEac22MrhKaa230HWhx3bb5ECGqwE9OL9DJF?=
 =?us-ascii?Q?5m0OzyWLOgUePNV557i38wa5tkJE4vxF62EpnKIUj1l3ROghVMdR8pQbIVUr?=
 =?us-ascii?Q?q9sK3wA+rbxRjNV+zM/mEbE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62804CFA5BCAA34EBD6131ED56993026@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ed7ad2-0a59-4afb-4a47-08d9bb3d3341
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 17:56:17.5545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8rmb7EdSCXXo+2Iqqv4C1LU0jz3qQ5CfPaRdYnMukMVe5b4LTzh1gSBvmVRzbYjgCYeM+GwciPj9g9B4F4ldHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 06:44:38PM +0100, Ansuel Smith wrote:
> > I think the problem is that we also need to track the operstate of the
> > master (netif_oper_up via NETDEV_CHANGE) before declaring it as good to=
 go.
> > You can see that this is exactly the line after which the timeouts disa=
ppear:
> >=20
> > [    7.146901] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> >=20
> > I didn't really want to go there, because now I'm not sure how to
> > synthesize the information for the switch drivers to consume it.
> > Anyway I've prepared a v2 patchset and I'll send it out very soon.
>=20
> Wonder if we should leave the driver decide when it's ready by parsing
> the different state? (And change
> the up ops to something like a generic change?)

There isn't just one state to track, which is precisely the problem that
I had to deal with for v2. The master is operational during the time
frame between NETDEV_UP and NETDEV_GOING_DOWN, intersected with the
interval during which netif_oper_up(master) is true. So in the simple
state propagation approach, DSA would need to provide at least two ops
to switches, one for admin state and the other for oper state. And the
switch driver would need to AND the two and keep state by itself.
Letting the driver make the decision would have been acceptable to me if
we could have 3 ops and a common implementation, something like this:

static void qca8k_master_state_change(struct dsa_switch *ds,
				      const struct dsa_master *master)
{
	bool operational =3D (master->flags & IFF_UP) && netif_oper_up(master);
}

	.master_admin_state_change	=3D qca8k_master_state_change,
	.master_oper_state_change	=3D qca8k_master_state_change,

but the problem is that during NETDEV_GOING_DOWN, master->flags & IFF_UP
is still true, so this wouldn't work. And replacing the NETDEV_GOING_DOWN
notifier with the NETDEV_DOWN one would solve that problem, but it would
no longer guarantee that the switch can disable this feature without
timeouts before the master is down - because now it _is_ down.=
