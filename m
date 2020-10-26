Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1112985EB
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 04:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421925AbgJZD3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 23:29:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:19866 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1421905AbgJZD3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 23:29:19 -0400
IronPort-SDR: 6HKJXm2oxkI4hGygVYH18DSbVNYOGfON0FPcE2675/SntJ67p5srm8WBG4LJwVOpG5LtpWAid8
 Mwfdj5Xepv2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="232064036"
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="232064036"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2020 20:29:14 -0700
IronPort-SDR: WENN8gG3d06biB5jaPNiouyWPv4ioycP4cyt0V9UCO3l/gOhk1M8jmadzr1RjjZWxuKoz5KSJ8
 9BMe83YfRoIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="349965160"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 25 Oct 2020 20:29:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 25 Oct 2020 20:29:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 25 Oct 2020 20:29:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 25 Oct 2020 20:29:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 25 Oct 2020 20:29:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3rxiR6Cnn7RkBIeThq0L1AiNOAlTPmFtk/oLC6d8o+mN3icVXnBPHm0ORdyj1ZpUEG6kr2azOeobv2pQc/N/BXqoPzHVMIjSSi3NFBWkA9wplQggTH0DFNfGHFzNQSC5eD+8b5bVMU0uZkB+QR20ZdkjBbgXElSzH7e8jSCOHD4OKN3H3+Q+9av7qpP9aiy/ObVQoJe+6U8g9saf6JllF3Gw3LzziNmvYwv5GjIIHoHudQnSAa4/c3rUFWyRzDXywut3dmC1s2zTfqzBe4kWlZVmFo8kWZj9en0w7wN3h5QPpU3GNguPlLAFuTNdJg9aFBd6wXL62s1lxp5TTc+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZLBuD8jdpxWjo4s3ba5YX1dGF9+v26rUE2s74jxrVA=;
 b=ZORLqGosMIWH+Y0sVsfI3eCs6xff+hx0ZLCOz7zBSPQ+dl1+igIgsnGXy1A5kmQ2umb1/Ay71Mu4kCdJvPhsWZz/7/naxR8Q5p8fqPMtLJYbcHck+q0xYyCVVm6GpBrTBKL99aWPfjEV0h0n/RDeIVLkyEkS8OLF2VCGE+XSQfpv18RqQaumPStdL8GZKlxwc1KqSKMp3YzGPeWvaG0vDGpxgUGanx6PGGakYNPEp1NWd+4VyMsz034kvYhDTGcGh9gGgvsiQ61ACCdFZC+vWS1NyxlPLPSM005Hh9xXrWktZto5Nk9XkTCCpyZLq1F0MvATnjW5+VbKjyDl5U0JJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZLBuD8jdpxWjo4s3ba5YX1dGF9+v26rUE2s74jxrVA=;
 b=q5TCE4RZ18PzefMxylY5emyb+hLdtRfOEQ9pWiaCSFstCu0gL3YoVwxckW/nkneEmpMUyeMSbqkcET6bpdBP9g9LmR/iOGQhWvykXBHQwkswFhc1bie8MO1LrWZZ5MIfWe1/lNOk628F4vaOAp+CumIQ2uFRZaZks0sQZfRUl7w=
Received: from DM6PR11MB3819.namprd11.prod.outlook.com (2603:10b6:5:13f::31)
 by DM5PR1101MB2316.namprd11.prod.outlook.com (2603:10b6:4:5b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 26 Oct
 2020 03:29:07 +0000
Received: from DM6PR11MB3819.namprd11.prod.outlook.com
 ([fe80::69e0:a898:de56:337c]) by DM6PR11MB3819.namprd11.prod.outlook.com
 ([fe80::69e0:a898:de56:337c%7]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 03:29:07 +0000
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
Subject: RE: [RFC PATCH 2/6] fpga: dfl: export network configuration info for
 DFL based FPGA
Thread-Topic: [RFC PATCH 2/6] fpga: dfl: export network configuration info for
 DFL based FPGA
Thread-Index: AQHWqRm2xvkvlV63606UZYHA6IV6z6mpLZeA
Date:   Mon, 26 Oct 2020 03:29:06 +0000
Message-ID: <DM6PR11MB381919A632F4A9948B82F92885190@DM6PR11MB3819.namprd11.prod.outlook.com>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-3-git-send-email-yilun.xu@intel.com>
In-Reply-To: <1603442745-13085-3-git-send-email-yilun.xu@intel.com>
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
x-ms-office365-filtering-correlation-id: b3b7ac7e-1753-4886-82aa-08d8795f4bd6
x-ms-traffictypediagnostic: DM5PR1101MB2316:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB23165FAD743C246053218D9185190@DM5PR1101MB2316.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GrXnqGVP3sdeku6miPXLjWeihpC45B1QxGTMPRA2yUZSVEKkSJf5Je1/R0yc/d1UCVFKrlEeSLN535AGcNXAOBwENuAh5vCKBo4kNTgmXby1/x8UXEfuAjU4t+gOZ91E5XGiXP5BwZDKtI2jQzuegjqu9Ir34HS9xsozb3BLCP7LLcioiTe+Dkgi+jguwDntc2G5ear73XipwBbnCiwaq58/nQo5HtGEcAFPMt5xgmveRu7pqpa4hbXCajk+rOW/Gsc9iuZZ8kfkIGK/yML0Q+ZfJanhXQPli2cT0qzA5frDx0YT9MT7qMQrUmUMGX76sXj2fodY0T+GNEorA5JbmReXhrv53vcXOrNkkUAqyL2TbmCl8wJ84v/M/MhB/dbk6TUSrVr5fyuQ8MGYtMkyTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(71200400001)(316002)(2906002)(7696005)(55016002)(5660300002)(54906003)(4326008)(6506007)(186003)(110136005)(26005)(33656002)(83380400001)(86362001)(66446008)(478600001)(66556008)(52536014)(64756008)(8936002)(66476007)(8676002)(76116006)(9686003)(66946007)(921003)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 48lJSNp1TCa9X1teu0V0LS3T6ub4qm1rjhxp8c4Sp+iqMGoEIH+tM6+bWeU1BNS3EVcis/0TYYDxrYSAsoVW+jkS0vNzDdDU4ep/YuoMwLu6Gl1OF+WDlLQppakS4en9IQD4iYkj/m5nI3dttylhbNpgYZytq3UdjZNHGtCtSO0c0RvmtjqtR50kyKQpIvXsuEV6EjT4fnEIbLngezW8q6iE4wZ26jMHb/L5FwcEMj2C2tPPBwHMsNlA7n7e5HjxKs8Ae7Nom4ki4aBltMiXatiXo6qPyW4O4XOqBNGXdyC736XOy+YL7Z6rZuuTtZhhpMFt8uH3sgIozS+33RpHO1Hn25gUvoIq2rI6A54Y+SNeDYbjNIbfPlPgMSSe9Kz02QtLiLSO3IbFCaFfr5pqIrNAXHv1Bvl9sOE3YBPtoAJCu0dHGfj+mNJRdUSEfgJ8qd0r71fjxaMspknyT3SOrSZD4uYOj1NIh+YhLFSjmf8nb+XsHzcM9bl0diWP70wxC5KUEnkKnWM7gOhN93dWVJKNbbbNPN/FrmV3F/McYZo+uqoZQnYMjHWPw2D+TKBKZDwJ05d57cYQfGQOt9e53dRaf8xB0xqpfkfwsJjcSlcnRJyD06txdW5xGt5SYBRh4PTnByTKqrtr37yMoswajA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b7ac7e-1753-4886-82aa-08d8795f4bd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 03:29:07.1500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xeNv0PKr1i+jsL16ly1DmBSheVUsEMCvFXOHPauGi7nN3TiPNXjx0RDRfDkZmRJZC2wd4sY4omHXWQT9km84gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2316
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [RFC PATCH 2/6] fpga: dfl: export network configuration info for=
 DFL
> based FPGA
>=20
> This patch makes preparation for supporting DFL Ether Group private
> feature driver, which reads bitstream_id.vendor_net_cfg field to
> determin the interconnection of network components on FPGA device.
>=20
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> ---
>  drivers/fpga/dfl-fme-main.c | 10 ++--------
>  drivers/fpga/dfl.c          | 21 +++++++++++++++++++++
>  drivers/fpga/dfl.h          | 12 ++++++++++++
>  include/linux/dfl.h         |  2 ++
>  4 files changed, 37 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
> index 77ea04d..a2b8ba0 100644
> --- a/drivers/fpga/dfl-fme-main.c
> +++ b/drivers/fpga/dfl-fme-main.c
> @@ -46,14 +46,8 @@ static DEVICE_ATTR_RO(ports_num);
>  static ssize_t bitstream_id_show(struct device *dev,
>  				 struct device_attribute *attr, char *buf)
>  {
> -	void __iomem *base;
> -	u64 v;
> -
> -	base =3D dfl_get_feature_ioaddr_by_id(dev,
> FME_FEATURE_ID_HEADER);
> -
> -	v =3D readq(base + FME_HDR_BITSTREAM_ID);
> -
> -	return scnprintf(buf, PAGE_SIZE, "0x%llx\n", (unsigned long long)v);
> +	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
> +			 (unsigned long long)dfl_get_bitstream_id(dev));
>  }
>  static DEVICE_ATTR_RO(bitstream_id);
>=20
> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> index bc35750..ca3c678 100644
> --- a/drivers/fpga/dfl.c
> +++ b/drivers/fpga/dfl.c
> @@ -537,6 +537,27 @@ void dfl_driver_unregister(struct dfl_driver *dfl_dr=
v)
>  }
>  EXPORT_SYMBOL(dfl_driver_unregister);
>=20
> +int dfl_dev_get_vendor_net_cfg(struct dfl_device *dfl_dev)
> +{
> +	struct device *fme_dev;
> +	u64 v;
> +
> +	if (!dfl_dev)
> +		return -EINVAL;
> +
> +	if (dfl_dev->type =3D=3D FME_ID)
> +		fme_dev =3D dfl_dev->dev.parent;
> +	else
> +		fme_dev =3D dfl_dev->cdev->fme_dev;

All of them have cdev, is my understanding correct?
If so, why handle it differently here?

> +
> +	if (!fme_dev)
> +		return -EINVAL;

ENODEV?

> +
> +	v =3D dfl_get_bitstream_id(fme_dev);
> +	return (int)FIELD_GET(FME_BID_VENDOR_NET_CFG, v);
> +}
> +EXPORT_SYMBOL_GPL(dfl_dev_get_vendor_net_cfg);
> +
>  #define is_header_feature(feature) ((feature)->id =3D=3D
> FEATURE_ID_FIU_HEADER)
>=20
>  /**
> diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
> index 2b82c96..6c7a6961 100644
> --- a/drivers/fpga/dfl.h
> +++ b/drivers/fpga/dfl.h
> @@ -104,6 +104,9 @@
>  #define FME_CAP_CACHE_SIZE	GENMASK_ULL(43, 32)	/* cache size
> in KB */
>  #define FME_CAP_CACHE_ASSOC	GENMASK_ULL(47, 44)	/*
> Associativity */
>=20
> +/* FME BITSTREAM_ID Register Bitfield */

Bitstream ID, same style as others.

> +#define FME_BID_VENDOR_NET_CFG	GENMASK_ULL(35, 32)     /* vendor
> net cfg */
> +
>  /* FME Port Offset Register Bitfield */
>  /* Offset to port device feature header */
>  #define FME_PORT_OFST_DFH_OFST	GENMASK_ULL(23, 0)
> @@ -397,6 +400,15 @@ static inline bool is_dfl_feature_present(struct
> device *dev, u16 id)
>  	return !!dfl_get_feature_ioaddr_by_id(dev, id);
>  }
>=20
> +static inline u64 dfl_get_bitstream_id(struct device *dev)
> +{
> +	void __iomem *base;
> +
> +	base =3D dfl_get_feature_ioaddr_by_id(dev,
> FME_FEATURE_ID_HEADER);
> +
> +	return readq(base + FME_HDR_BITSTREAM_ID);
> +}
> +
>  static inline
>  struct device *dfl_fpga_pdata_to_parent(struct dfl_feature_platform_data
> *pdata)
>  {
> diff --git a/include/linux/dfl.h b/include/linux/dfl.h
> index e1b2471..5ee2b1e 100644
> --- a/include/linux/dfl.h
> +++ b/include/linux/dfl.h
> @@ -67,6 +67,8 @@ struct dfl_driver {
>  #define to_dfl_dev(d) container_of(d, struct dfl_device, dev)
>  #define to_dfl_drv(d) container_of(d, struct dfl_driver, drv)
>=20
> +int dfl_dev_get_vendor_net_cfg(struct dfl_device *dfl_dev);

It seems the vendor net configuration can be provided by a
vendor specific method. So bid_vendor_net_cfg maybe a better name?

Thanks
Hao

> +
>  /*
>   * use a macro to avoid include chaining to get THIS_MODULE.
>   */
> --
> 2.7.4

