Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810894D2B1E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 09:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiCIJAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiCIJA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:00:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4666C45510
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 00:59:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEKNpwfkFJ5v/PDYImVpPbryOJv9CZai+UGBJ3gaNM4HcV8Y0frRW8Jzm1aV2vAgLdSdPB7FSpeW5OKjwIPH/CMhDAIBj7zAS4x5lsZw5o8mi4N6W6FLOYXmP9kl0QZakJOBdrkPgD5DqtcCyY/bfE075prRRLuIKykEnVaQAjgznVCiu2xqLJYeak3AgJadTHsqGlBVbrpe/J4bWkurHORO/GQ1HCC4kyg9IRTL3B5KWWm1+UKckFxFJIGy/+leuE+5wUODHzYjuNtScBud5TcgmeA09MhQwEFnk/R9jQ+5WNbxHweuvn+O0XVrvZGt32L5Z8lsFcQN+Oo53jekHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8PqOSDb7rH8ZMGaTPPcYxajqJLmsixG/dCt6BXAG0xk=;
 b=nONEgCLhknc97HmkrVbvK+sqvDcBnwQKvaxyLRvYZEUT7VpBNxzPI4oOXVwPgehPnmI4g7ZfVO3qWLHME4SwmTYy44xLZG2muj9Nhy4PKG2b8QVqUZyZ7M5hwOcczTppPD2OlPfdrh2KMCcu7VjebhKyutWjde97dfi2OiGv3w8wfxU5GpXb8aYF0Lz/4a70C+67kpB2KzycW7y58Q2VDZHprD1UefkQIrvOaBFDV0AV4dIVhyr9M02xjEoDzbtFa6igGThFm62JRfnA93czKjKNiHYr/Pj3sp5J7XMOIkzhF712MKQfd0pkHyzsTAsU51v+4Vo5hjdaCDmM7aFyog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PqOSDb7rH8ZMGaTPPcYxajqJLmsixG/dCt6BXAG0xk=;
 b=b+Om5g5oAMSB4Jkg83PQX4EbRWeb6XOzglaxbHpo8VIEuVGuNMHS/opLeoNW4sWAMBf8rdsVzyoi3PEAIo+FzK3XvnU0CuNs1f9aiNXORVRoyHiJ9ER82+QfbBZ3fA3ABMgfaQqHPRh8PEE11UejBM5FkTGNAcNgigc+p/UbtNbQElBDuw/M2SYVxRT+G5/4uqKEh7s9GjXtGfx7enKqgx4GecUYWEYkhQ6ozGa8bdLsJ2prPBC9HKNdrd81Ci1Cj090fBx4P51IJx5uoyV7YDSgUHuJz5vX90pVP1L5vuuQFc/msCcCfhlZ63ePXDaNG7MS55zB8gedV6vgoIh+qg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5482.namprd12.prod.outlook.com (2603:10b6:510:ea::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 08:59:27 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8527:54fa:c63d:16b]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8527:54fa:c63d:16b%8]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 08:59:27 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Eli Cohen <elic@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: RE: [PATCH v4 1/4] vdpa: Remove unsupported command line option
Thread-Topic: [PATCH v4 1/4] vdpa: Remove unsupported command line option
Thread-Index: AQHYLgKUWNq4zU1nfkuFHvtdhignkay2y8/w
Date:   Wed, 9 Mar 2022 08:59:27 +0000
Message-ID: <PH0PR12MB548171F052AC55F08612394BDC0A9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220302065444.138615-1-elic@nvidia.com>
 <20220302065444.138615-2-elic@nvidia.com>
In-Reply-To: <20220302065444.138615-2-elic@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e98db58-1b40-4644-8448-08da01ab1dbc
x-ms-traffictypediagnostic: PH0PR12MB5482:EE_
x-microsoft-antispam-prvs: <PH0PR12MB548283FDB04E7B376EA45C4EDC0A9@PH0PR12MB5482.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y5fFP7QAXZD1OGSa24iRUjL/76ZM5YjENizrpOoFiqKu1XNf9HcQ06eeUxUKVxMU/PI3FghudtfrLGd5vcrgDdokkRxj5XaqmJoDTnGHehwxdYmyGnu1w5l9dX6aTnnEMsHh6F9v5sF1vbdqElrebMY/h0rrFVVdoqDTVo667bRhsqbKOZt5xtehIbDbrzZtKfRj9NxCjol2WI6/6lG4cARFGKTXb6P9RruyTtuQgCTr1+QZqYh/K8wYhifvZCjG0lW8lh02M02/AZN22Zru/otXOOKYMONMV1AjI53BK+i+0isPrMhG3KyLyXlSnexqVrtDjZOgNFVn48ik1hw+8FrhTQh8QycGKU5ZGHOkqCXl5c49/t5ctEvlsspr8pLgk+rONmaL96Qtxe3PUk3d5Zxw1Tauap9XTr6YyLNuJmMFNnCIfvvxLAVIKvjXWGEfwgrAJ1SYzfwlPEw5r0H3unTeMaZm3pyZvstTsX5QeNErMpIbfbwS77tqKK/249bBFVY7KSlbd3rd/6jOvpTNxc3qF3A5NcwbuYbu0kZhfvY3AffAxRyhUPHCjQw3uO45DemawSpn0ET4JfuH7nRZ0wMev5fnM/+7G5hXRvnZl3DLepGKnwKIZy4GtH3MMhPIJcJy5JX6nOs62pyjbheM/+Bv4ZmBMuKFrcxBBGiEVQjkD6Ck8DcE/M2lx+c+kLGokXEZEPwoB8y8I8gN4sAJoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(66556008)(66946007)(64756008)(66446008)(8676002)(4326008)(66476007)(122000001)(54906003)(71200400001)(52536014)(4744005)(38070700005)(110136005)(8936002)(55016003)(5660300002)(316002)(508600001)(86362001)(33656002)(7696005)(6506007)(186003)(9686003)(83380400001)(26005)(55236004)(107886003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y9rHVmGbo3R+mmlgiPgV0Sk7lHZ76grGA4BsW2GcUSiC9sl/ocuNw1+DPjWl?=
 =?us-ascii?Q?IQDKVwXA6nANuWWE8Dq5z+lNG9hdybGoJ35M0sDXdxvnRNqpxqC0GG33Z3Sb?=
 =?us-ascii?Q?YGP2PGD+VQb7/9yONLfPOh9yl0U0bXu1Z2HIkxVaTt7wH45GQDtc3JKHL8DX?=
 =?us-ascii?Q?8ISxnRTroEI3wlehRtbWwdYv+L4g3IyMgxnY90a3yFD35Zg0J2BZvXmWxAM5?=
 =?us-ascii?Q?MaA1t9aQeOxEuAHxDSmUn425WwPvo3LMYYHhC+Rq7oqtSTagYdnybd9H43CA?=
 =?us-ascii?Q?kLyeTM3MgFLGwDCmooO5WC+FCCYmoqpNpc5DMkJAWF65/NTyM5zjOU4hVm64?=
 =?us-ascii?Q?D7yxqzLztUTvPBSkQQ3X6i/AyQmE9BvISQEkRyrd3Hh9fVE3bWEdekhb1RIM?=
 =?us-ascii?Q?fBBZJ82yTDDDoJvyNGHJwYR4xZUp74MU9tVXpf/w3RF2kyO5L8jHNc9VwSe6?=
 =?us-ascii?Q?V1Mbc+qBcuspzVdv3y4U3+DRb3G84weGhMPxABQ1qNkDhlUglajJLif1lG90?=
 =?us-ascii?Q?sNw+z2Fvs8FdK5htPH+S9TKZHkMabbuvXZDKFZrcwXZlOglHNBrPCvv+tPS8?=
 =?us-ascii?Q?VEu3pQgWVdi5OmxvK53geImlNeRlLZuhc7Lu6J/6J8Q3wUirxfb1ixihVGjB?=
 =?us-ascii?Q?MJe2gzxWHLoNkd9Y3mbVS6UcLrHvhBvNDcS/VuYG86USeP+OWUHhff1pNy5u?=
 =?us-ascii?Q?LhekuLIScW5TPKrgPHmm4DgwKO/tdljSOp+9xmnPvlBVD0zP+1+xIAQE/f5B?=
 =?us-ascii?Q?a1TTGaLGb6aGqcahuSIIiFaggZtLlNvy5YpUDnxc+vZ/7quGGRTFbEfj0Vdk?=
 =?us-ascii?Q?ZCGTAvw2itV3VREvb7ZlQKHhGUVbjp0WpYOdb3R1IR+Qa2k6Jps1ARZcESmE?=
 =?us-ascii?Q?sVbIbmGvXtQTJ+1RD71jlTgJhh2i8j5YpQRh2snQ2eKwlz1W1XoShwWD76eu?=
 =?us-ascii?Q?9DxF47h1ZWOuOSs0Vhva6ah++ynWZaPemekbe0FQzs3cJTxRaSCrWohEFyUm?=
 =?us-ascii?Q?5ScqgdXqGBOpCDx2xqDPLVxxkOgGMVgvMrjHtoAvQI9lrJ91mmcYbMIz70ux?=
 =?us-ascii?Q?akgNHvE7l0PFKDiVSvzkoSJHoi/VXVRmRlpBFTMGwSdLhxQDC7XXejRE3MH2?=
 =?us-ascii?Q?ZB0EXDwf++t7wBVPo/dQR1/U64eUpubkZ+8+dR5Z/Jv0qmaYKJEVepuuoPYG?=
 =?us-ascii?Q?y34ERP1rfHWdJFEsaU0QbAM6VzT0S+62iA76iY0e4bktBIfK7G8/4WXHmmj8?=
 =?us-ascii?Q?c/cXrbErm2kY2V1bBSoLAMygzzGZ6dXrkt0bqJ7XEUC5rRFt6zxJJojyGfh9?=
 =?us-ascii?Q?VUgHefOfb6ooj7EB55y+o9EoWbH7KyXpA/lq1T7X7VHhZ9liIbU3EhoZojCr?=
 =?us-ascii?Q?sGgAyZzAUnMTa7FZx/3X//jFSZT09RThu6LcjnxlX60lFJLlQ3Sj6efyzXEb?=
 =?us-ascii?Q?P/c5/jAfj4kD8qWSnfBtXWK2Ul63r971b/leLsNz1p1OxIpFBrvWeSqzdKsf?=
 =?us-ascii?Q?UYS4EQLWaJ4MRVYAJzOsdiZeKCmJcdRjlVyyisc+xXsqRg24iI9VDJksfy4Y?=
 =?us-ascii?Q?ZESsAcXsY0oGU4dxVXTb2j0c6ZzeY7qPxBQp0K1T8MrwIIClpkNmoMVIeg6W?=
 =?us-ascii?Q?exoxsvf34hpKXhBZ/GuM6SE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e98db58-1b40-4644-8448-08da01ab1dbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 08:59:27.5338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 85OEdVXxXcFDjareu0BOBamNXsx3uH8yI1yRyODe4EQE8+4YbewMvV+rcK24DA/WAV8bHyB+GGn7UjDuoZEphg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5482
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Eli Cohen <elic@nvidia.com>
> Sent: Wednesday, March 2, 2022 12:25 PM
>=20
> "-v[erbose]" option is not supported.
> Remove it.
>=20
> Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>  vdpa/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index f048e470c929..4ccb564872a0 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -711,7 +711,7 @@ static void help(void)
>  	fprintf(stderr,
>  		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
>  		"where  OBJECT :=3D { mgmtdev | dev }\n"
> -		"       OPTIONS :=3D { -V[ersion] | -n[o-nice-names] | -j[son] | -
> p[retty] | -v[erbose] }\n");
> +		"       OPTIONS :=3D { -V[ersion] | -n[o-nice-names] | -j[son] | -
> p[retty] }\n");
>  }
>=20
>  static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
> --
> 2.35.1

Reviewed-by: Parav Pandit <parav@nvidia.com>

