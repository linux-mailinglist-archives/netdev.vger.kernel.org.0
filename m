Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C275A303EA8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391746AbhAZN0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:26:24 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8796 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391851AbhAZNZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:25:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601018030001>; Tue, 26 Jan 2021 05:24:19 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 13:24:18 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 13:23:38 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 13:23:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLQEGf5xRaYFOy4DtvdD/8f8yocB6ir5o4+nIAGOzPLCuGJkKefJbkLaTcgqE/lUNp+wWkimgpOf7iUHise4r7PJD/xuh6Rw6lbReYxNOeS055VbH0AX1ueIR807exWsB2rRd1xbdCgxFAtgeNk7qwnYRvLYCNY6g2U5B3deGg3yiGQQGjRQQ+qUyGhN4gJL5Xb8WWUH0QsShSWf2kf7ZAuZ6UeRkzXjMUD1Net1yQ6yFHWhi9GZHdPEmA2b5g2cDaUGggv3Tb9t7s2ZxVTLxXU0hvRORIJEQmpP76meUQo3GKwFM4R/7tdpEuFriu+XyyNHfMyY7I+z/ttXvPO5Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRztiFzp8iSr41NdS6Z73cQ3SLnokha1bFKKunqOHOY=;
 b=PnWzWYfB1W9SM6Jp5d9jaedGnqb79JUKGuK5VbynhcgWHl2ggAVdeEQiSGwM9jc7cHrWWfMtb1c4avxADS4zlj/wIkM6oRqfeQeH/PZ+a7h3RCTqb82ayXv6TyuHz+l9sdHHZLmpQb4WiBhlODSkTu/ujVfbDcOQaSMSo/xiN56kqZyL6vF2j6tS8oOW33IqW1cljkT93T9d5v0EsqHCz8d1KOEnjStTzhdUc08BINUntG2n8a/UbjAWwv74LrCb/414gNzGcNuvFFxXrj+7sLRGO/6VdX1086gIFg2fB0i3Gqly+X5nM+cLvvjpjWGa3dZCecEO8kBnsKk2vqSJeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4819.namprd12.prod.outlook.com (2603:10b6:a03:1fd::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 13:23:35 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 13:23:35 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH iproute2-next RESEND] devlink: Extend man page for port
 function set command
Thread-Topic: [PATCH iproute2-next RESEND] devlink: Extend man page for port
 function set command
Thread-Index: AQHW8HvBtBaI3iJgI0SqHWpiDnoWGao567kw
Date:   Tue, 26 Jan 2021 13:23:35 +0000
Message-ID: <BY5PR12MB4322F470143709A0294F1463DCBC9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164712.571540-1-parav@nvidia.com>
 <20210122050200.207247-1-parav@nvidia.com>
In-Reply-To: <20210122050200.207247-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 880a7ce6-5152-4637-29c7-08d8c1fd95d9
x-ms-traffictypediagnostic: BY5PR12MB4819:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4819CB68C789BB76ECE297A6DCBC9@BY5PR12MB4819.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NoCr7jGfbNfbGkoB3Ybg/XD7U8Uw//dq8m2XUOzYvh4ypa7FlhbFBNKGUgzwCuhsqzApqwqQdswJLL4N4bMC92/V4g0jF9s2urqJQBvu+wDla+vxiBIirpN6yV4XUahEKb/2/nLCc3E4AicBti0zao/bamrtsZUxdgKbi/Dx3QbJOYdQPrwjhVj8QU9wnyAh7+pFGq30QOPqvIbb8PH3EwK9N/MFnYsDZ+WBYp8ygzDBLzxztWQ49zNjq3Pv9ABtAdrDrptz64GTiqBJfLjSFStNKKJNPEv5wn2XPop2PF8MYlliGy4JW5/tG5TMJ1zz53Bo4gFleWukrjmsFZ3A+A7ivICYMYLRS/sbk1HIvH+pAdYXQ5ybrUzOe9JzQ+qpyl7y3OoHRBMnubgAy9P/AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(86362001)(9686003)(316002)(5660300002)(107886003)(7696005)(8936002)(71200400001)(33656002)(6506007)(110136005)(8676002)(66446008)(64756008)(66556008)(66476007)(66946007)(52536014)(76116006)(4326008)(2906002)(83380400001)(26005)(55016002)(478600001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LWKX+NIPx/R4sP+0oA0n1CSb67qM3TxU+AmZVAO1meCs3xoJv2n7CarUilEv?=
 =?us-ascii?Q?KKlFQvVasvEP8PAm611Fyseb8Hkoq5JgwQI/Qzk4pAFgrQAPnMyqS+fQbnr2?=
 =?us-ascii?Q?0BqTi6DmRcVZeSkqrrI+0VUUsVo1rvR54Hc5vfgyFH1Rl/TzXxpaxOWljaoe?=
 =?us-ascii?Q?fC1zkNt3kB/MlorKqbjCtHFrFca/f+kG5MCBtsV0V6qLz5608QeR4s37gqLx?=
 =?us-ascii?Q?PmdE49PWZa2EMaGIymE1X5a264RV4Kc7uhMcV5QmEaMMaLClnuLTb2gCjnBN?=
 =?us-ascii?Q?PPsq0JN4Lp9HpwE6Gz/xhj9MNB/6wzFSFTOW7s01RwQx4Gp14auuEcJ6gQ74?=
 =?us-ascii?Q?usMgGedZM6mtZZbYre791aAus5Q/3/rfklYF2WcKp0Q+IN/uEyAaS+NiCdtc?=
 =?us-ascii?Q?ElsSiOkgekz7mdHYv7tmzc1f2CUT15Zc4Htin6YcS1lMMLOiO9E4H7bwB6RK?=
 =?us-ascii?Q?HzX/yLhTzDUwCKXc9l8ZmrfLuqbTUELkxwKAlLvB0rqL/gIGInzQYmHpCXK3?=
 =?us-ascii?Q?mRgWC9ct4CTDJSiajIp+B31+iqYWbhwaOIVnS7WETSk5HHc+tegBXbLI3wNg?=
 =?us-ascii?Q?shuikXTYqZxVi/e5Egj2oHAxj3WeycTHrb24CCXFyRy2hZlvzZ7gzZlhamsn?=
 =?us-ascii?Q?LmELdSgqFmlK9dEPzFnCi3HBqSwX2OXQ42DgcQGZvSxO5PElvzQm94s/7gG3?=
 =?us-ascii?Q?SlhdwW62TW8o1nIdy5Rqqp1/YTX9UHvE1WYNg6mS5Yu9I8Krs57a1KO9qoCs?=
 =?us-ascii?Q?MzgYROx8wSIFojNOLVnbhN4XgOnu2HPXkJeI55qJifoEwQw27LaWaN/JHCqA?=
 =?us-ascii?Q?YbxeV3Yp3GZlKJGLBnIs5OXcO5Zkyf/Y5zUqr/Gsf4Rc4Uz8JSY86fg+odHp?=
 =?us-ascii?Q?r26pS06nppbtMwl8+6STUE6zNOFo9xtr0+68zAGY3JXqAv2aM6gp/ODRmfJA?=
 =?us-ascii?Q?i7h0e7kexsd6JSEE7GvL1xy1sDwGfS9xc8OoKCT50BqkXAGh/mW+RenBCVui?=
 =?us-ascii?Q?mEpAQsftObTNlbO5mAM0LYsmRfoV9j+ad9WLCYmaTRMALvNYUcIqZos5oNue?=
 =?us-ascii?Q?fF/3VEOM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880a7ce6-5152-4637-29c7-08d8c1fd95d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 13:23:35.6246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xuB6o95gom3USxflf35S6uV5dSJrD96L9o16jN8f3Fs1+GHITsDbk1BQ49D9eNrH8wtIfqrTlI3qviJbTeZIng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4819
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611667459; bh=bRztiFzp8iSr41NdS6Z73cQ3SLnokha1bFKKunqOHOY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Tx9E9o70w8aCffThiwjrxMgqYA1CL++qaY5YFHU1vLFK3ARnnt2i27qcCthgzoBAs
         vsuK4Kxx1/zrONAPKlHKNqtNyxrrBCmfAVP/Rdq38C6yeGTfUeyDtf2jGIxsPwuNii
         WE/J/6MMVIc1g6XL9a1JlYUUQ6TZGzLA2hDw7i5tEAbm3dOohiOKjJXIY3LwVsz/UR
         ww4+8j6AF/6/YZfYhlCiQ21wtbwBp9FHYLpCd04mUFVhpaDDHS968oIPq8aI/X60tt
         xM6hFSZfHqO0EBVH/lWpWWl3wG1aaDoo4XCJkFQUE3onlBwZ/Y0yfTX+jqAwlTLniW
         PNio1AzgabNCA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

> From: Parav Pandit <parav@nvidia.com>
> Sent: Friday, January 22, 2021 10:32 AM
>=20
> Extended devlink-port man page for synopsis, description and example for
> setting devlink port function attribute.
>=20
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Can you please review this short update?

> ---
>  man/man8/devlink-port.8 | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>=20
> diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8 index
> 966faae6..7e2dc110 100644
> --- a/man/man8/devlink-port.8
> +++ b/man/man8/devlink-port.8
> @@ -46,6 +46,12 @@ devlink-port \- devlink port configuration  .ti -8  .B
> devlink port help
>=20
> +.ti -8
> +.BR "devlink port function set "
> +.RI "[ "
> +.BR "hw_addr "
> +.RI "ADDR ]"
> +
>  .SH "DESCRIPTION"
>  .SS devlink port set - change devlink port attributes
>=20
> @@ -99,6 +105,16 @@ If this argument is omitted all ports are listed.
>  Is an alias for
>  .BR devlink-health (8).
>=20
> +.SS devlink port function set - Set the port function attribute.
> +
> +.PP
> +.B "DEV/PORT_INDEX"
> +- specifies the devlink port to operate on.
> +
> +.PP
> +.BI hw_addr " ADDR"
> +- hardware address of the function to set.
> +
>  .SH "EXAMPLES"
>  .PP
>  devlink port show
> @@ -135,6 +151,11 @@ devlink port health show pci/0000:01:00.0/1 reporter
> tx  .RS 4  Shows status and configuration of tx reporter registered on
> pci/0000:01:00.0/1 devlink port.
>  .RE
> +.PP
> +devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33
> +.RS 4 Configure hardware address of the PCI function represented by
> +devlink port.
> +.RE
>=20
>  .SH SEE ALSO
>  .BR devlink (8),
> --
> 2.26.2

