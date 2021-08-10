Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20F63E596E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbhHJLtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:49:42 -0400
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:9952
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234975AbhHJLtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:49:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jd4FioUb7MbV79A6qafNXg3ENnPRIkKPzUrG6VuFGT89zHCUvgxyDy9+AtTOQ4Hq+04Ejlf3RjuzauFWrhKcKnpCTKczXfYGr81oU7qHvFlhCsroQnXe5U4AJf0bP/jKvoC2EXWiOPS2pH6owGrqgVQLz6K/zzzW6WBwxwWg6wfEI2x6ryyUjC9t8nCTi4rA3q66duKbaom8Ep9Gy9OJNMMjC7nZhDYKaJq2RnDvuvanraBNjq2+6uTQB1Ofx4nuwVPcO1sODDh9UYMAYeM1IebgoiKuMhSdChi9dRmW2S1i494xxyfAhL48ekYzW7h3kAqn/yofIeNjDqWpEvoOiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RX9nL6LwSjAAGy76AoDI41C0uRwASaL7z6EUYCi9F8=;
 b=KGh85JFsPfezipQUT82Recho8AKytQ9v+TC7L8K97MSvZq72pX1T/ICvLFfwnUojm2TS92b6XotczDqAOF5Dkqd3WsEMzV23QWlQ3ZnPwMh/LHUhzWKiZC2IRfH5foMgsY3xXamHIw/qHz1jPBhCrzTsTxMmJhnL88p11RzFZzfOVYBC/AcHs8Jl587P7zj51EzOeiv3Cj7zOSOgYou2i2pGx25E5V805S/7RBPq0TwO2DbMywHNt+UcVTgTaTFPbk4J/P+FLrm30U/9JGRDPtuKJAeJIuFR0PqRf9YA9Zy2/W3MnPouDtaL+1Dr6wDeltmBLPFZDwfyrvQ390y+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RX9nL6LwSjAAGy76AoDI41C0uRwASaL7z6EUYCi9F8=;
 b=gUZkQroo/ZDEVt4uxztyhF9VjNLMHHZ7iWXHVuX1pCORqCl2+E+sbmel5v7V2hxRhfPwaMTC23e9uyRhJi/aYuHlaOFPqQ1wfPxt4huUYO6Dy7UzlA2dmVu3H4zY6zxEw2QAZSma/pHPaiVUhpu9Zekbni3psdNCCxRG0/czHpUch6uNQ/CYrYuGPrD4ZVEOFBJa3V6VbXogDajkP5WB6DS2ThviSEvtgK3DTD8Jl0OzWJlBaI30nQym7YhWxitKJ272TzdVlFNJN4FGkwEJviUen/5if/63PXv9dAzAjapx7/+n2k7IKcVckYhQewqCU8yDJcfTDIuR3A+qArwB8A==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 11:49:18 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::249d:884d:4c20:ed29]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::249d:884d:4c20:ed29%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:49:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH iproute2-next] devlink: Show port state values in man page
 and in the help command
Thread-Topic: [PATCH iproute2-next] devlink: Show port state values in man
 page and in the help command
Thread-Index: AQHXf9Kc8/l2o5ruJkWZP85tSCRlK6tsu66w
Date:   Tue, 10 Aug 2021 11:49:17 +0000
Message-ID: <PH0PR12MB5481796816B64C41F8230E0ADCF79@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210723145359.282030-1-parav@nvidia.com>
In-Reply-To: <20210723145359.282030-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99e8821e-469b-4a8d-5598-08d95bf4e28b
x-ms-traffictypediagnostic: PH0PR12MB5500:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB550098E6534C6964ACECEEF9DCF79@PH0PR12MB5500.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iBmjELDf3cUZ0vu2T7JZzAIunW8E8sXnz0BQfxrG2421oeFR3NmTQpDQdyuhxMac8zmtyaigYKsAHTpaw0ng3+C9cYcp+LjCpS54V73ip1O+e1SWyPWXm9Vr4dS1Td16gQneAwX6NFBdHtEogy+pyoJXywA3I/7Q+Jjg3gvRNORcxfnvuo1Q//mTjop9EAt4kAwFF6I5pv3PReAsgfUAtlmUPZVz/RlhgrQtNTsmBIRQ3XKCFbN/ALuGuDBj1dCP0z4bwpKqG/A5hc97900wwcYw9O4iyPOlgNRDUC0eXBdWQYfsU7gOWCnFC1UTQW9hz07pbxeDMKsS5mj8XXMEGGr8Ueh3dVvOvAupRi2aA8rNB96HH6om6Q+6uVeq9aqN8IeVyb7sZmV7WWoG3H1FAfnKqIwR29HTehrB3T5KI+505PH0Gcm+bI/2Uf6kREFmswAfA5Xa+u/DA5zLgtZ3Cb8HNjx2K2EoqRmmr63l3Rdlt3uZUChl5F/GbOM0JWabwDPy09d0NZ466iAbaFE0eMPRclQ9hRF3YEeB2ZRCwx2xiGDzNq/Mi9TAJWWx9dt/sOsABMFfPPnJ7+uwBjOUbuiL/gL6VkpHMimolskgU/d0zn/Sh+V3Vz0oUGX/U4us7IAf1WOE6nCxOVpgs69kPpnUM8Ek6cMoWduPuHXmlKCQFKN3WwlhaRsgCVxjUlResQ4f+fZ6N1wB0cV17uS49Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(26005)(478600001)(2906002)(316002)(52536014)(38070700005)(66946007)(5660300002)(66446008)(66476007)(66556008)(38100700002)(64756008)(7696005)(122000001)(55016002)(4326008)(76116006)(186003)(9686003)(8936002)(33656002)(107886003)(71200400001)(6506007)(55236004)(110136005)(86362001)(8676002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XszPkS2zFAk5gZrwV3YyeVbppQ++1z49MQqmr7edw8HmtvFTsBg/87cBEnr8?=
 =?us-ascii?Q?H3dau/HRErYAlg9Yjt+EEMX+RVb7iWbtHQKN32mCZwpvbwBk0tgssVQIXH3h?=
 =?us-ascii?Q?TTL6L4c69h4Dr/8SQjSNDLaQ/rtu0KxRGqn/BEwzgAr1vDDB7bq2tIoYdavm?=
 =?us-ascii?Q?1Gc9dmXineU5XYtSTFPWACAXRfFv2rbULyPY0Q3msVB4kgsU3DtxroYBolKw?=
 =?us-ascii?Q?U6jP18FpiQga99XJyPMjZAFjx7CFKwwPjfx3G4/KghhHAoA+BJH0TzzTdzbB?=
 =?us-ascii?Q?18BmaDWTq7eljEL2TnHa2EXaFHRvjXPCGUz4N+y6LyuCz/qTsj9qcWVVRmZ3?=
 =?us-ascii?Q?2AVFFed7Wgq+4gdWJU+jkhAcnQCc2TpQBqB41soqXsF2o/8F0br/5bFDeTrC?=
 =?us-ascii?Q?CAtLhs922chDcKC7oGXwLUBNW0c0AQuUgWq8ekqcKqwbnVBEcDiG/1IoFEMZ?=
 =?us-ascii?Q?FlK6PQe5Ld7r6KEFqh6Wrz4eH0cZllrgcB94dgNfyEvSXAXzwKpVo+smNsYw?=
 =?us-ascii?Q?FWufSQGNISxhhhEkrs27AeeZZe0O5KR0G5iQO5ZjJKnrTqBl5dFwqxq4iMil?=
 =?us-ascii?Q?YfEKmmqfvdPTXBt3q4rcZd3mG4zYAOLzHzzwEpjFMZtCJs20o1tLC+WWOt+r?=
 =?us-ascii?Q?IXO+irfCT+8kJKEb3fbGF8DSxhvcvjinvJ7U8nwIB0jjWRCEiH4QK1xTwiVN?=
 =?us-ascii?Q?NRHi5zhHmYUfe1btOe57+OHgkzhtDzfaXhi91maUX5E/1ASIiqkrIulw6l4s?=
 =?us-ascii?Q?VfYZu12bag1lE9xN/dIIDUUfbtjXTFLaZ9QJPZ2SBKD5zmYeK27eWIXMdTbV?=
 =?us-ascii?Q?ua4n+GTpOTeUrgYXblBp0NuqR4i6BBGFRCfn9VTaO663rCH8LzC4D29JMXnT?=
 =?us-ascii?Q?JuigM6eWWsLEIKBR3UQhfEzm+Yyiep1Cl1oWfQcEO13W8ZEg17Nh8LFOXjXB?=
 =?us-ascii?Q?I4+OCCIkwDDnm2lFBJMjcrNyVZqdSDxxbUCVeOlgM1mKvoqeQ1voJXuH/J8U?=
 =?us-ascii?Q?sWj3+mOu9HHGk+eSaiYXShNleqwhaVlriln1RrvHalw0I4PJfzFIBhAWNLaz?=
 =?us-ascii?Q?tMBh7OsUYvScG+qpuyKcXyklPTT8XKf9C2KJzNuanuf+oIj92jhL0PWQjgWO?=
 =?us-ascii?Q?Puoy+7UDDFI9Kuoa7MDTzh1aFUnHr/cFhhBjIWx7CR2wc5RsGCD6gClyrs6L?=
 =?us-ascii?Q?kQI2zqh1QBQ0sxDa6Ot3DWgRegodak0fmaYz8HJ563e5ZWEH2iku02RzKxvE?=
 =?us-ascii?Q?AGkU8CPMhXvyeSKqv2EMn8Fgf/lNjTsUQ4H6Qd9XCeXVoaYEetFwqjWt3SbK?=
 =?us-ascii?Q?DI0HuaR73ys4aQGRIs2WGbsC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e8821e-469b-4a8d-5598-08d95bf4e28b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 11:49:17.9440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VgmCW6uVjEZ955uHcyc+mdvl1NNrEnaSjbrbA/5CVbMKXhRHsh63qbsQ4VeXCUkJcrmYWe5pWoKs4zCt130Iuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Stephen,

> From: Parav Pandit <parav@nvidia.com>
> Sent: Friday, July 23, 2021 8:24 PM
>=20
> Port function state can have either of the two values - active or inactiv=
e.
> Update the documentation and help command for these two values to tell
> user about it.
>=20
> With the introduction of state, hw_addr and state are optional.
> Hence mark them as optional in man page that also aligns with the help
> command output.
>=20
> Fixes: bdfb9f1bd61a ("devlink: Support set of port function state")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  devlink/devlink.c       |  2 +-
>  man/man8/devlink-port.8 | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>=20
Can you please review this short fix?


> diff --git a/devlink/devlink.c b/devlink/devlink.c index b294fcd8..cf723e=
1b
> 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -3988,7 +3988,7 @@ static void cmd_port_help(void)
>  	pr_err("       devlink port set DEV/PORT_INDEX [ type { eth | ib | auto=
}
> ]\n");
>  	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
>  	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
> -	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr
> ADDR ] [ state STATE ]\n");
> +	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr
> ADDR ] [ state { active | inactive } ]\n");
>  	pr_err("       devlink port function rate { help | show | add | del | s=
et
> }\n");
>  	pr_err("       devlink port param set DEV/PORT_INDEX name
> PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
>  	pr_err("       devlink port param show [DEV/PORT_INDEX name
> PARAMETER]\n");
> diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8 index
> 053db7a1..12ccc47e 100644
> --- a/man/man8/devlink-port.8
> +++ b/man/man8/devlink-port.8
> @@ -67,12 +67,12 @@ devlink-port \- devlink port configuration  .ti -8  .=
BR
> "devlink port function set "
>  .IR DEV/PORT_INDEX
> -.RI "{ "
> +.RI "[ "
>  .BR "hw_addr "
> -.RI "ADDR }"
> -.RI "{ "
> -.BR "state"
> -.RI "STATE }"
> +.RI "ADDR ]"
> +.RI "[ "
> +.BR state " { " active " | " inactive " }"
> +.RI "]"
>=20
>  .ti -8
>  .BR "devlink port function rate "
> --
> 2.26.2

