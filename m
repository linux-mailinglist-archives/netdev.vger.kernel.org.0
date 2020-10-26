Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1016A2985F8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 04:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421944AbgJZDmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 23:42:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:45635 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411400AbgJZDmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 23:42:16 -0400
IronPort-SDR: 8+zpm4DIVwDL2KYLOiicNMYhOzFsa4kmsQgmpsGJSw9PZtOpMr3pGxpySkQrev4k3UHLdavPxj
 JOvb5jK2UAXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="155655394"
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="155655394"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2020 20:42:14 -0700
IronPort-SDR: F4M7fR9F0JvTRVfP6xXrFDZVUaZ5SH9tc11ejPiApYvCXf5ZqWWBaUuJMeIkEfupA+wdOSQC/2
 zOPx0Uevzi1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="333909332"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 25 Oct 2020 20:42:11 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 25 Oct 2020 20:42:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 25 Oct 2020 20:42:09 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.55) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 25 Oct 2020 20:42:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhSGrwoIRbJHLIwuPz9ANYFoZmmXiA29ItBsw0/gr67BcQwKbVRq/YCcQHWymgGnCK6MddV+O/v3fLADEgaZsjzsfLLhSvlNGoATDZiMX6a7cUModShPHhssbQub7I80P/fAp32B+usu214Dnm/8eKWkL+ej9rsH6J+jbBvSeGo40wczbT2RnX+8gluvjCo4zqqnD01IH6SyI2ygUfEk48Fmh7/i3Xo1tb9K/S6Cw98TIJUmFYvxmccw2GqHkKltZLW//dy1JI1wz1L5hmlcOAB6qRa3kdeGcxmga2hvrQO9oc0CA7NYXdIyKOJl9X8uQD+Xmgi+haRGU1bOqmZdsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dxv+anC08pq7Ksc+AlqNRyin+X4GCgxrhMzW24lfPU=;
 b=jN9TrwqtHSn5f3BCuFPYOrYbTwYBXdot2DzcD0/g9KhiVbNsVCx1PdpkalvoRUSwlSYwuepf8oXwTKJEemmgugTJtNyfFIfFBsbCY1JTvLo7qUqX+bK4SZ10JPCHGDddqC/rhwI+V9bavdq3L/2nQCaBTHW+70T/IHrCdIfzpKC6hvfCz3jRm3Lm6Mt6TrCg+bv5PWcru8+mfFi7fgQTp/+61zVx8oTr8/cQa8s5qmYWSTub6t3l/N/Cog16cN3MevxAezBkt1xqqkBl2owey8Yah875kbfHjB5pE0naSEIFMU71O6GDglPrMbyBHo5aYv5TyNNjSy49G5NSQuv4/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dxv+anC08pq7Ksc+AlqNRyin+X4GCgxrhMzW24lfPU=;
 b=LWzq865SpDW/vBeihuZklJ4olfjFmmCsEewkw+Q/l3meCmSUfNSfmWj2gF6OShw0ZNOdXntj5lJYol5pncknlgt9+inPTAb4NbVJK+aWW7jdvaIeI72li7XUEoGs7IEdgQwvfGcVLM3iJC4A4KKrz9uDDY58k8yTUYI1It5pq84=
Received: from DM6PR11MB3819.namprd11.prod.outlook.com (2603:10b6:5:13f::31)
 by DM6PR11MB3001.namprd11.prod.outlook.com (2603:10b6:5:6e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Mon, 26 Oct
 2020 03:42:06 +0000
Received: from DM6PR11MB3819.namprd11.prod.outlook.com
 ([fe80::69e0:a898:de56:337c]) by DM6PR11MB3819.namprd11.prod.outlook.com
 ([fe80::69e0:a898:de56:337c%7]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 03:42:06 +0000
From:   "Wu, Hao" <hao.wu@intel.com>
To:     "Xu, Yilun" <yilun.xu@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mdf@kernel.org" <mdf@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "trix@redhat.com" <trix@redhat.com>,
        "lgoncalv@redhat.com" <lgoncalv@redhat.com>
Subject: RE: [RFC PATCH 3/6] fpga: dfl: add an API to get the base device for
 dfl device
Thread-Topic: [RFC PATCH 3/6] fpga: dfl: add an API to get the base device for
 dfl device
Thread-Index: AQHWqRnDpp6o9e1bVU+et9aqM1MRXqmpPqUw
Date:   Mon, 26 Oct 2020 03:42:06 +0000
Message-ID: <DM6PR11MB38196E62ADD3D94B4CFE65E785190@DM6PR11MB3819.namprd11.prod.outlook.com>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-4-git-send-email-yilun.xu@intel.com>
In-Reply-To: <1603442745-13085-4-git-send-email-yilun.xu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20579e2e-8c31-4c84-befb-08d879611c5d
x-ms-traffictypediagnostic: DM6PR11MB3001:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3001FE677914118B6802762585190@DM6PR11MB3001.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u9PmLdzpZ6ww8yL0GJie+dII4rfeL/9flmQBKnjfRRfqBYxaEOmYqRfW9+FpNv/yXJTCtW3TESNXSKGgvFxOxUTHUD8ve3Yz0bYS1L04yQ54xWutBWJne9VQXsxPxpX2cFuBDR7fSJZdbqoJ77nx8p5qVmSevkf7WhaKFOla11ZWm9R8hqy6HsdnVq/iaqxPD+RlInyqvgEuC3BHCxpphEZTPwh4MzjiInUu/glv6/RWuR306t+5/BZeiepdDG78Qlu4bAXfMx2ZfVqtqsdeLYPMsEIywzyA4ARc1WDbtqie2y1d3GXDpVrtF61DiX6bcSuFuPa+kbheFCjhaeDZ+3OhD6tapRL6PjiloukwGbDQAyE9Wy1PC0WSucnsDrAeH8l9PrKZZsBdiGMEtS8bKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(33656002)(55016002)(54906003)(7696005)(26005)(316002)(186003)(64756008)(6506007)(478600001)(76116006)(52536014)(110136005)(5660300002)(71200400001)(86362001)(8936002)(4326008)(8676002)(9686003)(66476007)(66946007)(66446008)(2906002)(66556008)(921003)(15583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vqYVSWdKPH4XKKXZHC0poT6IENHzuG4E66qvTNrbfC9Knqq/W6PY9PFHn2BsFYCZm65vfweomBe1SNiHtXccNVcQ+wH9dd3VDggwQ/wTkIdycmtWACBerNtfkYDPkz7sA2Y67dbJqzQUtPZ8IoxB0UYizY5aoN4L8NJ7wA4IRQRuQGUmpHUfpEnl1zIOylnI4vB30i5jXeQHNqPX1eMsWfbhBljtksqTcbbV8En4Y/eQc5KxC+EJbmdH8jiRO2oG9kKH/ezPRVe4EkFAjNpdIKA2Wt/kaw/kkdLWXBVjQTSUcKtpXbmgOedhbRyod4m7sCfcJ5E9QBcyt0pmv2UU0KMCVTKhTowfIKX1eTKeCtKC+98EvDuLOPICbGn4pEStCs4HcRFXOFIMktxsD8m0XX+0zf+ALuyjI+BJLbh9X0kzE/gkADlYwhaAfdr+exSDAJkaEMscPritERacZdnOFKvSUnLe1n2h79gLl3UIuhXOR7UG6KTltf/vLh6njwQX5exLgFIVsWtznGMJRlmmcS+KdDVFX/hjrclwP/zezMAq6ViR0duVaoyChgbeioziLKCQXDYkwaiO6pnnrMPREZJRUd4RTGuA1H9pWrHnQTObrjwuUIHBgZnHBAr07mb8timd8kDQ1BRBmXpuYEkJuA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20579e2e-8c31-4c84-befb-08d879611c5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 03:42:06.6640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o90tQ7Dz+JjqHcujGXI7HKboO8OHCuuKcM17WDBa3zy0nbd31tm2QSzUnYI+0Sz2CADMpXlmspEEC/Z6x3n21Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3001
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [RFC PATCH 3/6] fpga: dfl: add an API to get the base device for=
 dfl
> device
>=20
> This patch adds an API for dfl devices to find which physical device
> owns the DFL.
>=20
> This patch makes preparation for supporting DFL Ether Group private
> feature driver. It uses this information to determine which retimer
> device physically connects to which ether group.
>=20
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> ---
>  drivers/fpga/dfl.c  | 9 +++++++++
>  include/linux/dfl.h | 1 +
>  2 files changed, 10 insertions(+)
>=20
> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> index ca3c678..52d18e6 100644
> --- a/drivers/fpga/dfl.c
> +++ b/drivers/fpga/dfl.c
> @@ -558,6 +558,15 @@ int dfl_dev_get_vendor_net_cfg(struct dfl_device
> *dfl_dev)
>  }
>  EXPORT_SYMBOL_GPL(dfl_dev_get_vendor_net_cfg);
>=20
> +struct device *dfl_dev_get_base_dev(struct dfl_device *dfl_dev)
> +{
> +	if (!dfl_dev || !dfl_dev->cdev)
> +		return NULL;
> +
> +	return dfl_dev->cdev->parent;
> +}
> +EXPORT_SYMBOL_GPL(dfl_dev_get_base_dev);

It may confuse people that this get doesn't require a put operation on
the base device. could we avoid this by using a different name?

And why it needs to know the physical device here? DFL hides the
physical device for upper layer drivers, so this is not the same case?
or cdev can be used instead here?

Thanks
Hao

> +
>  #define is_header_feature(feature) ((feature)->id =3D=3D
> FEATURE_ID_FIU_HEADER)
>=20
>  /**
> diff --git a/include/linux/dfl.h b/include/linux/dfl.h
> index 5ee2b1e..dd313f2 100644
> --- a/include/linux/dfl.h
> +++ b/include/linux/dfl.h
> @@ -68,6 +68,7 @@ struct dfl_driver {
>  #define to_dfl_drv(d) container_of(d, struct dfl_driver, drv)
>=20
>  int dfl_dev_get_vendor_net_cfg(struct dfl_device *dfl_dev);
> +struct device *dfl_dev_get_base_dev(struct dfl_device *dfl_dev);
>=20
>  /*
>   * use a macro to avoid include chaining to get THIS_MODULE.
> --
> 2.7.4

