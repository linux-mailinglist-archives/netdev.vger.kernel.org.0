Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E994CCC1F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 04:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiCDDSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 22:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiCDDSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 22:18:32 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2084.outbound.protection.outlook.com [40.92.99.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54831377D9
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 19:17:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzFpVMLxQCUqGGpwjTtnndEeTqoGx5unLSQj4i+16nqULrmVje1sLHxng+PFO+rXxRK1klxgcsK7vdpHta7gb6cmMRxp17aQKmOYrng1iN6trnskgGejVYIdeJiliopYFEKEH+SO5lw+iUnbpgEIhMbccKNbD75G7Z3aGeEy0KZcmu8M6K6J0wjKpm6sS2NzKp5/VMarPR4hMN21rmp0PSASE8FledTXPtaDhMvvXF5XeYiSBMSb22Pn76XoPZpnFh0fLy2dzplONDHkNNQTRyfBN9DgeeHLw2nNRj1Gzg/p/pvhWXOBUYwdq0MtNNao2zc6541+YQc6XlNXO0L0AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snX3PDXw5AYmztC6K543cRx1y4NoL7+fbs8hRWfvfSQ=;
 b=RcSvSMWkPdCVOffCElaQfqtjZ9WNDWQafxmFhzxnlVtQRqj/A40yk4CVlzTMWOaar5ceZBvE9WaSU3hiviJ+lT85IMu8pKFzecVVSkHOboSHK55WRkknnhHFX7SlDcVKbl3GZkw1RRB+fSRQN/WFMI39Qj3iGMTZ4LEdfcyLdYh5hovPPlS+Q4jrbxr7N1xjbdQR4Sf1vZ+EGomQiUmSs/AZn2iDxzlvqWFVXotXKTDHBV6FHtMcDI8zR6/ep52RZbfMzhGIbm/xPepZX0r/00iT4YQho3yQNg4bXxwaSjTGaaek17IG0bPdRkjEUhiqN0URyOymrCod/1ABHmoQVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snX3PDXw5AYmztC6K543cRx1y4NoL7+fbs8hRWfvfSQ=;
 b=UbgKmj0bAqPzEmYhec1rkXLOWi4Yf1NKkW85Sbo95DUx0ss85WVp1d6sP+b3J1L7WgWX3M2/hA1ND7L8jy1yaUropgjA1rRBFYZHVqR3SWD7dEx8wfoICyC17FTEiCn8PXp9Z8+/M//nEmmYSuzIO+BL6eZbayrIfbchqqkrlij6igKwnK4wErcxBp1b642X5jht9cRhiMcqDdT8UkHBv+mi32Ibk14XNQEGnrb9cCnt3YX4oVBLSCRc69QIxJfnPSMPHirCpx08Hxbv/gDHACJuKtIVe+eDXWFtaU1NQbeJhkDChypabGnVr7YCKk5It5/FTrMuuOfZP0eDnqrctg==
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com (2603:1096:604:147::9)
 by OSAPR01MB3938.jpnprd01.prod.outlook.com (2603:1096:604:5a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 03:17:41 +0000
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d]) by OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d%6]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 03:17:41 +0000
From:   Shangyan Zhou <sy.zhou@hotmail.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] rdma: Fix res_print_uint()
Thread-Topic: [PATCH] rdma: Fix res_print_uint()
Thread-Index: AQHYLeKZOum8s/EYpUytAKJkewQs8KyuAYUAgACMycA=
Date:   Fri, 4 Mar 2022 03:17:40 +0000
Message-ID: <OSAPR01MB75673C9BF3232C94E34D994CE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
References: <TYCPR01MB7578E54F06AEFE50785B771CE3039@TYCPR01MB7578.jpnprd01.prod.outlook.com>
 <YiEMcDbZAvSsFURj@unreal>
In-Reply-To: <YiEMcDbZAvSsFURj@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tmn:  [d8sAe5vRVOM5dWUWa7TMg3yE7S31FdTS]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 894f1380-cc58-460e-d385-08d9fd8d8ac9
x-ms-traffictypediagnostic: OSAPR01MB3938:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u6qknD3R4K/1qGRiTzpDdU0Q7uJMmWDE5KyZl4p4u5Z116SsILJnWCAEEfeYTm6sqck9dIJqv92E3usbTAFiCWW2PLZALI3vFHkZJ1Jar08AAUKqnEQ8YeAorkz7c1jOlFsjVPNw6iRUA5sZTylaLfAZTtl/2jQlO2L6xc24TbCh+voqoSZkp8u3F49gRo3S2uy1T9un2nZQITGR93fu0cv68YxNZTP/FGVWYQveJSyQ4wkrutt0Lyc8IFst27Xr6K1rA7dM11opgO5IpTGG781qsDJ6UWUhHQme69ZLACTtxWmofCE0qTDO732sRzjcAUuioAOTmJ3TvbPCRdDzQh5ZHen5huH+2mV2DrKo4O1xt+QSYnDaMCsaX8iy5ea6BouHoLMT0m+xx7/E3YcINCIucFNUrp7uj95T/aY8muLUWKRGOmUwVvw6q+9XCwM8YWzYli8/yYFPLOhz5RZdi7p+vdd25NjiWwXGLG2RLGyDsFBEBakKm8dleZNaaSQBYimbIQbho2QJaLmE9rN+L97RnTaW2PViDfOjBud42ukh1iIghKQaoDr6KWGlDis2NZMHz+YoEUts0nGJvileTQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: gBj/x0PezNJTeXolwYWQ/S9IgzBUVpDokLJ7kJ4f91cdQcZxj7BBlCG247beLa5drqDVUEbh9nvF0IEFLUewnJZF1ECeRu5Vg5y6OjI0WvqaMBGSLIWklcbMr/5MFKibqKVkeKxme8qHaNxklySf8Mc+Ey1z2kRWBljip5P8s6FxJPAU/QG6nHy+b7a0pWi+sO2KERFN3qaC/bPqg1GKkpOIHPIqvInU7jJt9IRhBZh6Mh1KJjxziZ7vyeVbY1YxP8KFtKSvh1B1BGcFZn74xuhARn3g5Oa/G7xjpwgjMdlp5dQfUWvAdnKCYE+FOUdEepl5Zr0MpS/gVQ1oXDGIgKCGB+Z3XPXGYIIZC0XVu5sI2Yv2HIt+uV4RRYj0gGhNHXVK+2H+alcHEDPjrGmxPoKNowE/nu9YDNbdavxPaiQg4iV9dW9NsJtJQJoQlMaDFnIWyFylqSUilaEwxef8a+pX1xzbHRSx1p3QMzMATA2R660EpIqF0k4YTCC1MM7EMYarjOD2mEHBwlFCPvmVop04Ki52bieZgvoL0FLn4ln/SzEd4gW9kKHqefumpxWT5z9NvtNAZKz3PeAXV8iS9M1A/zykzJXYkrh4Kr44S+nOXAMZg51b4hA3diVe6X3mMs6wrO3yL5pW93R3XjDGjoyfMwBFe/8S+mQBHH3GK//LJ9mjb4iNFiyexMg/0KHTJMSggVIxqQYO36zrd2lVEqWVPtsQojwKTVEjolUnlrJ+lOHKDFTFwqq0Af9lcIqGd2yiDsSxTDGxJG9oFdhGNm38lbR47tAkF/BeKulNhO2BiGFjAFHXn2S7F/v5QLKPMsPR1vQYmWGiGQGY6LZLP1NIzrE/7q1z0QclSikEZFL1MHf87TIbGQTZBqTxnOmCjlydcEinhg+dKjFEjmS1noNxRrFCN56LEyiU0BvTdWyzEn3i8Xsy/204OKIU4uzx
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9cf38.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB7567.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 894f1380-cc58-460e-d385-08d9fd8d8ac9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 03:17:40.9709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3938
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm also confused by the uint64 and %d at first. Since I encounter this pro=
blem on a 32-bit hw_counter, I thought it may assumed the input val is 32-b=
it.

I checked that the _color_ variant for u64 does exist, and changed my commi=
t.

I'm a newbie to submit patch by email, I replied this email and found it cr=
eated a new patch. I don't know if it is the right way. if I'm wrong, pleas=
e let me know.=20

Thanks!

-----Original Message-----
From: Leon Romanovsky <leon@kernel.org>=20
Sent: Friday, March 4, 2022 2:44 AM
To: Shangyan Zhou <sy.zhou@hotmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH] rdma: Fix res_print_uint()

On Wed, Mar 02, 2022 at 11:06:41AM +0800, Shangyan Zhou wrote:
> Print unsigned int should use "%u" instead of "%d"
>=20
> Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
> ---
>  rdma/res.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/rdma/res.c b/rdma/res.c
> index 21fef9bd..832b795d 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -214,7 +214,7 @@ void res_print_uint(struct rd *rd, const char *name, =
uint64_t val,
>  	if (!nlattr)
>  		return;
>  	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
> -	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
> +	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %u ", val);

val is uint64_t, so the more correct change will need to use print_u64(...)=
 and "%"PRIu64 instead of %u/%d, but I don't know if _color_ variant exists=
 for *_u64.

Thanks

>  }
> =20
>  RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true, 0);
> --
> 2.20.1
>=20
