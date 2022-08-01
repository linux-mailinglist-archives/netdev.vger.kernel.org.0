Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1855867F4
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiHALNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiHALNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:13:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB786245;
        Mon,  1 Aug 2022 04:13:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pe5ULWEbcd88vLFbOOqBofqt0cQB/TLa6SmSSxeIo0UimX9omHylHYBZqcFLtBfD6GxbbO2eeWaRsux1j+clLEQ+TF3aWa3GJGWHLsxvonbVOb5+HkSx1CQfOS2hg4I2wCzsJQAht4wIHDNM+RQobL2zRq2XWRn++9ZuFg2l1k7XtM7nPlkaEoK+XD0pZyqAKWZSH0cr6j1L0AQe4EjtAxbWA96w6vGTxegKWTFRmNQbBT6XDJgO/o0bFuUOi03Ju8jrTmaf7Sp2TF6LoQbG2rRMh1JwWiSb2PqYjwLGbqV9ytKuAGGg5X81mY9DoRWF9rE0NJjB4LeaXMneM0PJvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8B9t+fxWqnmLU6CpDmIg6OKbcRv/lncUzCROorkgHk=;
 b=b62237sh5Sq9X/UlicuR19GdBonFmuzOHJVth92yOpKMSyd1Yy3RwmQgv72vtkba/JeQPdrhUTxRN38iAAOWBNiiBo+ycPe4B9zvpJRjhAs0vybhwbJ7v8vK97dMgLLgpd+uT+WiVDiGqcoqhVuLvoxFy2Nna592Cu3F9NMkr72QRoXzOC6OvdwdS9pUAMUi0jSbKNVb19nS5npi6BYduU/iifgsj6ZdKNZxEv1rFPdmeSXDJ2EYRit6QyBinbz7Wv6Ad8WY25TyP+z9z+SxaugG5ZezAdG+L4FKroLoSeUpRtKN9gDcOdJC9fYLuX29GhtPnSfEjpxCAgB9Liazlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8B9t+fxWqnmLU6CpDmIg6OKbcRv/lncUzCROorkgHk=;
 b=qbt4dwKxXkdtWjYwZO4gE0ExEUF/FjjIVdURsafa5Hq+WLYKF8KnR0ar3x+JqXVAiLu0QYBMM33rFmmfvbiz7U8x15J29pYJnrmo4YUKLuKo09dee3jbDm8TDCh1sBpKyEJDW1qcX4BvDM0QKiSMynljUiKYxTusbZ7Dpuyeb5OkuUFlmbzrUGvQ4vnB+tObPrYtYvrHmjqBpOXBctKERHsRWYH7bwMtryJgJ4YLVlV6A74nTR/68YRetHNrajUCsxIGh13REJKAlG3+13oaiS4gtJ30bN19t6fsI84dvXfoV7/2hWd92lEy8G5sqhM/34Rp5HTASrWO9SQgWIXEKw==
Received: from BN9PR12MB5381.namprd12.prod.outlook.com (2603:10b6:408:102::24)
 by BN8PR12MB3026.namprd12.prod.outlook.com (2603:10b6:408:41::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 11:13:36 +0000
Received: from BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::e948:b801:9977:e44f]) by BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::e948:b801:9977:e44f%5]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 11:13:36 +0000
From:   Vadim Pasternak <vadimp@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [PATCH 1/2] Revert "mlxsw: core: Use different get_trend()
 callbacks for different thermal zones"
Thread-Topic: [PATCH 1/2] Revert "mlxsw: core: Use different get_trend()
 callbacks for different thermal zones"
Thread-Index: AQHYpYz823UbypK34UGkFNMWE0pI2K2Z49oA
Date:   Mon, 1 Aug 2022 11:13:36 +0000
Message-ID: <BN9PR12MB5381C2B144840EB0D7390610AF9A9@BN9PR12MB5381.namprd12.prod.outlook.com>
References: <20220801095622.949079-1-daniel.lezcano@linaro.org>
In-Reply-To: <20220801095622.949079-1-daniel.lezcano@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05956978-bc84-40a8-1947-08da73aee101
x-ms-traffictypediagnostic: BN8PR12MB3026:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HTMYFHdCYOoxD0j59YZ46EuYn7Fq71ZMJN39tImhmDxvdP+3C66amsaQxhU6i/ymsA87ASix1oOyM/A+qs3TKND6lt3nzT/uDm68wzPcpTTghqNExX0pLUFtsX8PyIqiDypwV8uW9k4UEDF+f6+u9NY0UWuymCK02t9txYDuLARozvuOky6XvGv42diVcptHOAoUNKxYyutWypsMJL+v+jaj0YIaeaR+QNo03KDjHBtmDbgzJMvBq5i/XFdHt1zeKDAMPK+/+UEQHocavw9ktdXGDiEAlyZ3EVmYSIPkekQRMSFEEBV+9/+t8+8F/aQRRh9EWsplclu9NZZ11MFPZf1PuYtmcCM8eSURxzD5kIUDLt5sR5AACTiToGRgLKNTfqkx+kOOrV3BqWF4wJGdpB5O+q763pQtdcWSqI5AXwzXnDiv7i0ezYU5L4gPvsoE3jKvZaislcB90kPKtAnqT+/bGlpNKXamvNIn6IgLhabkDlCmWK7aMKwRjzD3dmPqcWsLn2bM9HKbXouQryQPrIY8WuKQph4nKfwGaTWf0+t8y4xm2g2NKQI0tmcRb4HsnOfP/u9E+y36E4PqoaXhHdxK+OFf7f3GSkuozPYBtauaT6XHdQ6sbPVNMSioXaawOFP3ls0/MPUUChRggTIFAb4VRnGG6DVHE1gfoFh5VVNnC1I87JNvicI5VN1/OoCfB6ZRNOUeyb5ZuBdVd/joOtNT3DlrfYLYK+p1XAVcn0xzk3qU/PigljVwB86Cbw8/vciaHKdqIJ/816GB98UOtMz+oDA8HBqr3K8Ux1TJWbUYYUboExIE7YFsKJ2NDQR8mRlFWLMTr4NWgrbiWuVBteDK7wDXNmRYlbzqZvVERsgEBenuPkvNRlhEMAZ/SAAH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(478600001)(71200400001)(110136005)(86362001)(33656002)(41300700001)(966005)(7696005)(6506007)(54906003)(38070700005)(9686003)(26005)(83380400001)(53546011)(186003)(316002)(2906002)(66556008)(8676002)(55016003)(8936002)(66476007)(5660300002)(52536014)(64756008)(4326008)(66946007)(76116006)(66446008)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UEqGmrCS7+DsCQU3hFnGjYoatLJUFpH5pPwDNdlPsuGunsD28zCu6VSy0mjD?=
 =?us-ascii?Q?bb17mtVndTnr4DCdJ0xDd4WMNVcW6v+9IMyzMZRolEjDpYt5cUF8G8n083h7?=
 =?us-ascii?Q?BavTlkooXcv8qWkoVFursPvtCXMx1rnkzI6IPCJTpZdan3nFRVRJLYgNDI/3?=
 =?us-ascii?Q?z4Vp0Ds5M78sQlgETy/x9KkqPetISAw8Rp7U6CU5trlMNjX+DlVtQ1JHJYlT?=
 =?us-ascii?Q?fcvXgLf9P59Wu0FYENHI7tSPwEL/7Be7WKjAeaZe2eMvRh8H4QcRqv5vmLwZ?=
 =?us-ascii?Q?0C9XbtxzhzSibpKYZieLNwithUCLEhLEWzFpNSdjwqTMsoT2Id6cI0LCDdLz?=
 =?us-ascii?Q?3WcEOKbY9lFYUE9zJk4Z69aMv1tdgGRknpcm76cksOKcdGA8McXnQ1qlNs1Y?=
 =?us-ascii?Q?Ahd0XkTIjQjLuWzcMWQ3sMeZWC0h89cpgsQuVKFhzMXp2df+NHT7ndRWyl3p?=
 =?us-ascii?Q?t0NSMTDLUD778EQAlnjMGgXY1PgcYKeZYCi/68iscq2ryIMekZ8CeQ9OiOmd?=
 =?us-ascii?Q?tOspJ5LO35rQqn6FMfMsIaqhi6n381bxsIjZlJspxEUErKbQjCB2A4ukvuot?=
 =?us-ascii?Q?I/lDvmb6EkJI7PqVXWGviEwRrFFp5cH7C124l7bkgcVWlxUvaKy2HiA/y2R7?=
 =?us-ascii?Q?WDN/UXKxsusdtG3IuVrRjhyje+4wR3MwXSEdjrjHX1J+P6g/CCLv1ZvHrsIF?=
 =?us-ascii?Q?O0xxYdhRXUGhSqrAZT+PTOc4p2YzlAOARpr/kIV5LLy8ueTxPAOluQiN1WLB?=
 =?us-ascii?Q?pbaVlBhKh+NT0PBxCuAlY94nwDiNe40RMubbl6zt/dB02zC0uxPgfmiNc16j?=
 =?us-ascii?Q?/f6hlGEcMhNYsQd8Gcw9HTfo5MQltwo7N62rnsLKZyA+A3vbjx874Fpsn6DV?=
 =?us-ascii?Q?/glZeYqcTZNvZGobR5EWPY/Uzwt2Obktres1MYh/yzuIwMXC04oS4TuDsDk5?=
 =?us-ascii?Q?Bgr+/76w30EfHeMfQlpB8yCZI5FHgFJ8QZE+7Yv/bINyvEdKdZ8r5BMuOE10?=
 =?us-ascii?Q?9u2Mj+imf9ZCfHQnI5KqH+QGVRlMeU5L/lFkOuPxVYlhuuwAbBiWjH/gC5sM?=
 =?us-ascii?Q?eBbvh7kMexs7ACv3DyOKgNaZkGq4f5mtOyazG/iLiQT45jKs13VVuNAA1EBb?=
 =?us-ascii?Q?Gei6ZJWevJOx/Ik51YUz4Ew7ltWx3XFfBFd3D0mKNtU7v7hKRblYnuQxjiSf?=
 =?us-ascii?Q?dsvK25aWJ8jSsbP1zQNKklH5BdT5zklygu0FhREJeTD0kKyazcnB+y4KoSvc?=
 =?us-ascii?Q?WwAsJrOzH1mWa8UfKmLcM5WoZSSVO+PGvlW2JUG8+uBM5BA+1saYhR6fTa5E?=
 =?us-ascii?Q?XI5OzGFipxbqwZxyUgGZ4M1R69/DlIEYPr7p7WZlk33cUj3YQd6koTAhC3xL?=
 =?us-ascii?Q?eyIC7kZVqyOYEn2YgIvuRHz4N3BU/+vzz++M4rxRPbrYyLZL6wy6iF80DbkI?=
 =?us-ascii?Q?X9dGusuyxGT7YulbqEL4RmpDGehvCl6jcerrb4LEm40Jt6iMAzLCeOJfnl2S?=
 =?us-ascii?Q?5NgIJd/3br3/fug+Zqfjs8kVm+a013hr1iuSCi1y/WSvQGrvPADu4iNIifqz?=
 =?us-ascii?Q?aVklBW8huyzOSJun37dXlJjHT4ijnEzYmrJEU1In?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05956978-bc84-40a8-1947-08da73aee101
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 11:13:36.2383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aAXvlhJbxsAgBjR1DxJqdHY3kwwHuOVW4ae6qGWlQ5NxYXAK0Iip1y6XERRxpWvC6oYBMBbHQLtK2fIzZr5uiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3026
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Daniel Lezcano <daniel.lezcano@linaro.org>
> Sent: Monday, August 1, 2022 12:56 PM
> To: daniel.lezcano@linaro.org; rafael@kernel.org
> Cc: Vadim Pasternak <vadimp@nvidia.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Ido Schimmel
> <idosch@nvidia.com>; Petr Machata <petrm@nvidia.com>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>
> Subject: [PATCH 1/2] Revert "mlxsw: core: Use different get_trend()
> callbacks for different thermal zones"
>=20
> This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c.
>=20
> As discussed in the thread:
>=20
> https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-
> bff366c8aeba@linaro.org/
>=20
> the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
> actually already handled by the thermal framework via the cooling device
> state aggregation, thus all this code is pointless.
>=20
> No conflict happened when reverting the patch.

Hi Daniel,


I am sorry, I didn't run emulation yet to validate this change.
Will do it in tomorrow and will send ACK if it is OK.

Thanks,
Vadim.

>=20
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 23 ++++---------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index 05f54bd982c0..f5751242653b 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -345,7 +345,8 @@ static int mlxsw_thermal_set_trip_hyst(struct
> thermal_zone_device *tzdev,  static int mlxsw_thermal_trend_get(struct
> thermal_zone_device *tzdev,
>  				   int trip, enum thermal_trend *trend)  {
> -	struct mlxsw_thermal *thermal =3D tzdev->devdata;
> +	struct mlxsw_thermal_module *tz =3D tzdev->devdata;
> +	struct mlxsw_thermal *thermal =3D tz->parent;
>=20
>  	if (trip < 0 || trip >=3D MLXSW_THERMAL_NUM_TRIPS)
>  		return -EINVAL;
> @@ -537,22 +538,6 @@ mlxsw_thermal_module_trip_hyst_set(struct
> thermal_zone_device *tzdev, int trip,
>  	return 0;
>  }
>=20
> -static int mlxsw_thermal_module_trend_get(struct thermal_zone_device
> *tzdev,
> -					  int trip, enum thermal_trend
> *trend)
> -{
> -	struct mlxsw_thermal_module *tz =3D tzdev->devdata;
> -	struct mlxsw_thermal *thermal =3D tz->parent;
> -
> -	if (trip < 0 || trip >=3D MLXSW_THERMAL_NUM_TRIPS)
> -		return -EINVAL;
> -
> -	if (tzdev =3D=3D thermal->tz_highest_dev)
> -		return 1;
> -
> -	*trend =3D THERMAL_TREND_STABLE;
> -	return 0;
> -}
> -
>  static struct thermal_zone_device_ops mlxsw_thermal_module_ops =3D {
>  	.bind		=3D mlxsw_thermal_module_bind,
>  	.unbind		=3D mlxsw_thermal_module_unbind,
> @@ -562,7 +547,7 @@ static struct thermal_zone_device_ops
> mlxsw_thermal_module_ops =3D {
>  	.set_trip_temp	=3D mlxsw_thermal_module_trip_temp_set,
>  	.get_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_get,
>  	.set_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_set,
> -	.get_trend	=3D mlxsw_thermal_module_trend_get,
> +	.get_trend	=3D mlxsw_thermal_trend_get,
>  };
>=20
>  static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device
> *tzdev, @@ -599,7 +584,7 @@ static struct thermal_zone_device_ops
> mlxsw_thermal_gearbox_ops =3D {
>  	.set_trip_temp	=3D mlxsw_thermal_module_trip_temp_set,
>  	.get_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_get,
>  	.set_trip_hyst	=3D mlxsw_thermal_module_trip_hyst_set,
> -	.get_trend	=3D mlxsw_thermal_module_trend_get,
> +	.get_trend	=3D mlxsw_thermal_trend_get,
>  };
>=20
>  static int mlxsw_thermal_get_max_state(struct thermal_cooling_device
> *cdev,
> --
> 2.25.1

