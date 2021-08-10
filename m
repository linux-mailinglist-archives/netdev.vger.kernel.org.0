Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18A83E5C28
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241930AbhHJNue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:50:34 -0400
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:63457
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240212AbhHJNud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:50:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkJ3yytTj5zzjRHitwjsGdC/oDCEdQ1LI438M+jmXkz/9h5e3hr5S+7jd7WFdOxsA8lUHPxjZfEN2E3kxBKVmun+nuWcWbDZ7Zsr18LjcnGg8aZYfSKdeEW+35jvEY/qX2gC8Yme3THaiq1Rs+bkgF0+5fQ9P/DJ2a/Mg2XIkvS1NiNxWGuRf0cIqC34YkFCLTDnAEjQY+CKmnA8OW21CqMjAGhvLycSUzZE3RT0/7xX3fb+mlgmwyWiRJNG2gW+YJ1O10b8s9mjL2w30eoi+IXHHJUUIVRKLf9BYD0KH3oFcql0AoAWrJzJSnCY9++ju6w4k7HGNTQBPpjmNQStpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLb2dFaA/i+r10mugho/BSKWmbLC5ufz+fTQ5w2O9C4=;
 b=GIOVQ4sJMpkMh79FNw4ioDdVEscwuvQE9tOBDmaUqZGTTXmcR3vC06LS+n9NmF9ogQrcfhKdweZ18QhvnLGtbKHMiE0zOM0VMGddjdxLo/XhdTYS4EtuFE78WelmAnbwjT3jnpxfp6rIljWjfZh9Iw+FblLs+YZqIwX4UZbs5Pi+Mub5ergSdFMA8DH6oOGOkLqBVpHB9AOZDZksJHjTUrWMmoR/qV/xSup/wfXfzxut5tZ7syM7azeYe14Js1oBOdIKc5SG8snVNkK9ZIRP8lao1H2LYasz3KTZdxNrsoD6ifDsYo66wpHMWz0LpLedMqHj09FuLmjgN8pYnLxsjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLb2dFaA/i+r10mugho/BSKWmbLC5ufz+fTQ5w2O9C4=;
 b=IP02/TwcEpgNSF/OS+TW0++1iVOBwv1YFQWgyxbIDb6isnvSWxD5sLqc3WRPD0k66tH2Py1XXr453a4xivXWcBZMQbPtdVlqVYDxKrKz5ldV5seM3ppFhtIYGVsnBnKTJSL8OtY7Vjd8BA6kxyHvFd16F1sB6DvGfoDWKupoPOo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 13:50:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 13:50:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net v2] net: bridge: fix flags interpretation for extern
 learn fdb entries
Thread-Topic: [PATCH net v2] net: bridge: fix flags interpretation for extern
 learn fdb entries
Thread-Index: AQHXjdbqTcGtG93500uVnZ+jLFXWA6tswZaA
Date:   Tue, 10 Aug 2021 13:50:09 +0000
Message-ID: <20210810135009.tn435h75r24qslgh@skbuf>
References: <20210810072139.1597621-1-razor@blackwall.org>
 <20210810110010.43859-1-razor@blackwall.org>
In-Reply-To: <20210810110010.43859-1-razor@blackwall.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: blackwall.org; dkim=none (message not signed)
 header.d=none;blackwall.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ed1eee6-bb0e-451b-5543-08d95c05c510
x-ms-traffictypediagnostic: VI1PR04MB6941:
x-microsoft-antispam-prvs: <VI1PR04MB6941A83AFFCB6BE8920E686CE0F79@VI1PR04MB6941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DBhTFcMzUWkSIbYj56OqHhvDKsMsMMX+JgS7ovUmLVoGptrAItSwb03u2cRdwxzX68dW1cK27/qQxVjluE4uOFwo9QX9Blf73tph+5r3d6iXT9DzRKU7BqIyB2zPcBhN80mgrfKFR+dGu+wAENzBDVsDfE69+JBYZZUjwysA4FDNnNsU2K8FxH64mzP2GjfrNtBZDJ1LmRYrsOIOWgMuPUT5byLQIhl//I6Od3vuPxHSLZU8Zb2cDW4nTdI1DO4fpLPa7jfqpOl7vSv/tQMBRt2kDcVubPVc9CDKwZ6dT9YXLPFlF2DpoDdJW/+/iHg+SdQ42kPkoJR03LtEYo41UPK4hYwdVEgYqDz++jA18WHXtcuWsss/M+CRmHlFqi254DLtWyjxShu7jBOfyPR04/PqdI7O2b6+iN5LtBx6VZI4Z7st+ABViF/v0jiM8zEYJe+Ld0He36qkFsOjWteIa9Y/7zmwEXHYIiaA5Z501qGEIXHah/YLoijRlQBMF9KTcL1B4JYVhxlsx1PJZBtk9CofY06eVb454Hl7pdBh4fKbs3k6hcx3tFNlUr864c+yPZDSxNA3xngDekm1jGB1HqXDlZuCLm3gRMOXLgufPRjP77bmuMnGrnTaBcb3tJg9wIk8MXqTqOnTOF3/EGQxqr0IzHorCxtI1aNQ3Vv8OC5jM3d+apqMLFngcqVfjeodPMBOUN3kYlQV01A2zwxX/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(33716001)(8936002)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(91956017)(9686003)(5660300002)(26005)(6512007)(2906002)(4744005)(6506007)(44832011)(8676002)(86362001)(6486002)(38100700002)(71200400001)(83380400001)(186003)(478600001)(38070700005)(316002)(4326008)(54906003)(6916009)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XjHH2iekBiGa2FSXOmZ08NgxuRMKXrKRaVq65PZeQutQ9V30CRtNQaTRqSaH?=
 =?us-ascii?Q?I18UcM4tU9hPYJNGAuTpeRJz9Unab9erXZWBuKZ+QQyrzAeLsx0Q44A17IQJ?=
 =?us-ascii?Q?BiUUMO9GdoUCLRfYTx97XW4Kgt2yOQEuxq2IY5TzToZNXBxVylPP6A+epOea?=
 =?us-ascii?Q?9b/jeYOWz5pUCVVtDsoX53jyPiuqVpcmJUghz+ZgRkTLEAAQpz69x9LW29sk?=
 =?us-ascii?Q?dflYWlKhl51+/gnNv3IBEA5sz3dJ/29v+GcEuc7NugyEcqDUsFGvF73xGjGc?=
 =?us-ascii?Q?kbQPVAbV3zwFKdgIHRFOzu2w+3wjvd+s898S/dXrQZiZ5pmnOiSuP8ccZqNh?=
 =?us-ascii?Q?AooTQbVuLPTV4u4J5iyxhU6ZZBDhCr9O8of3PPwKS4xLDfyIcPBd7ZIFyrXe?=
 =?us-ascii?Q?ERjW5DZtMzsD73G6kLk320sn9DjV05FwskSDxMoyzBOWC+Tb4uZBuN4AZBj9?=
 =?us-ascii?Q?s+3dXK2M83MAuSFj/9Tu4W3FP6nycixoHfQ1JxDjafiyJRbI31dR4JDRh7Av?=
 =?us-ascii?Q?JIv7NdLtgEonzrIqIcsUO2vA3uoFjk/EjkdykGpFgprRIinlJM81hwydkqmo?=
 =?us-ascii?Q?ZSkn0lVPcE9VDHBdPsg1oBFU9fp94L0VB7mbEvtXb7E6EpjnDbOs8Y2WZMdq?=
 =?us-ascii?Q?+Ap2mQdL9PB22/Z+v2xhvwW2uLLHNaAL1I1ERvLvau6xkMOil/08/rgABt5E?=
 =?us-ascii?Q?otPXxUKYmFxc5DU/EoFkJCWZWF3yQBlu3U8JSIIpxdFHIaKVaMWFiHQajf+d?=
 =?us-ascii?Q?5jWB2e85nh6M8zLGxt0b59PR6lbYBSTzrfX7rvrH9eGrlgnHzPemsjvCe7l1?=
 =?us-ascii?Q?L+C0/LegeMkJo6/hvsoezTZI0l5gIIKKcoVsyk/8sxbsizD+hw4o+DKByXhd?=
 =?us-ascii?Q?hQmoGGo1NOXRU/Nz6wZNAWmvsNvVtJu/zOfsGOJmfNZT8WDyf3ghcXmCP2+C?=
 =?us-ascii?Q?NXqXnWKYD+pgRZunHDsnXs7SLjlwkYKHvZLccVRghQgrmQ55/UPft8P57RTp?=
 =?us-ascii?Q?nAqxiLDfsT0DpoaiWWGLwGExZtnc73YQujHAt9jzEccMLFGt3rRoVG/BQ1gf?=
 =?us-ascii?Q?jBjTgnL5uW61zBR1MJc4edtKipT8iFx/PaImqPMTFU3OTxI21r+E99bgCo76?=
 =?us-ascii?Q?JySwyMQ0RDHTFQwHF+DRXJ59fjrYt5F0WXQyODQGtX2FjUFltyj4LtlJ8lKR?=
 =?us-ascii?Q?feAH2+gK3sJEefJ0tODPjwDo4EoqlIEGD/Ee3mi6b/EjhSurtY3i71hptiry?=
 =?us-ascii?Q?MaEbbziV0SmasakfdbShGfL7NiFHltt9w77J9ktg/N8tChBN5ejAAOl2ca+w?=
 =?us-ascii?Q?4OIhE+IfORJ+emSzMbDGigbu?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35E3BAAE9FBE9B4494ED82EFA5EE2C96@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed1eee6-bb0e-451b-5543-08d95c05c510
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 13:50:09.9370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R6uaYAWbpcaal3DyZFtbmgL6Fj4IFFsIHT6hgttjrBoWNB7CzT29Cv5fdvQFMzRlj+XoaE9B/dxhn+uf7lcIsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:00:10PM +0300, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>=20
> Ignore fdb flags when adding port extern learn entries and always set
> BR_FDB_LOCAL flag when adding bridge extern learn entries. This is
> closest to the behaviour we had before and avoids breaking any use cases
> which were allowed.
>=20
> This patch fixes iproute2 calls which assume NUD_PERMANENT and were
> allowed before, example:
> $ bridge fdb add 00:11:22:33:44:55 dev swp1 extern_learn
>=20
> Extern learn entries are allowed to roam, but do not expire, so static
> or dynamic flags make no sense for them.
>=20
> Also add a comment for future reference.
>=20
> Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entrie=
s from user-space")
> Fixes: 0541a6293298 ("net: bridge: validate the NUD_PERMANENT bit when ad=
ding an extern_learn FDB entry")
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
