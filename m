Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6ED2C9968
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgLAIYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:24:09 -0500
Received: from mga18.intel.com ([134.134.136.126]:37803 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgLAIYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 03:24:09 -0500
IronPort-SDR: PQwxnEiRUchl1gpZIhMT+ebSBplQepzERkkEU1m4xbMOGAbpsu9SfvBvDL1CyIUfRZ3qi2UXaT
 8VWZfujic+Mw==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="160557823"
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="160557823"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 00:23:27 -0800
IronPort-SDR: DdYF4X4j57fowg3d/Oj/ID+PTWs5va+xPDJsumpo/5sfuwwUv2RqK5/Vkiyi9mecAAy9k6Xywp
 dd8BjmMDQ5Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="372817182"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Dec 2020 00:23:27 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Dec 2020 00:23:26 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Dec 2020 00:23:26 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Dec 2020 00:23:26 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 1 Dec 2020 00:23:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4oESyUSiGPo1TnE+qqx85q4LYvNMEOCzMCHUaqdZR/mCCzFIAbFDsTh3oDgZZr4H4RV2om3qdQuOxO/K8lmDsLRiKZ0BBMDXUzO+p0ueP1I2qSpfh9mU4NdBz6nPadxJKK6ohWFntu953KsXaTOcEBnZH3yTQ9+xSQRT9+yfAFsHkqIAaBBMVUEOgUK3EiVyuWDHCiNJVlrTxUga0AtF/RmwfIzvN0SEhz34gwgY25JrunOAID2UMy0KxIYCv3kmS1SXOnksGlaW4DSlg+FhcV78QEEK2kIkcwaqHujszmJwldfajKGohz3C/1rzd+7YOWSL/EM6LRDN8a0jVxaVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRL+t09VedaOLdEch7kfcv4f/U/Xgb/30bVuAchBpKA=;
 b=Z7xh+OZK8E+yH3qdLyMq5mKM6S5Rxk4F3lLm3ZZV9ksvmaRkj6MKTbjAGWlwILrxRGS62IaKY7F+Tzc1Cm2QETf+9Gu4lmzPgg/YBe58ObRzryTEWqY+HmackpSqy9S1ck//jfcOYNbCTyPNlwwG1s764tlDOuxNRgAWpNO4nK9WMRsmmhKXdvQNlYmrswwSsDUch77e74LM9wxSvvtO4tZhaZeykE0Vem1M5X/SMlHTkIKW8K21ov0goF3iHzZEsTY3Rv+jm1x050H1W0UdC4u/a98aaSD5ixDvuyFCL/l2QnwHuZopIhaZA9g1NZbqUBx5uKftq/yxHaVzgnrt7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRL+t09VedaOLdEch7kfcv4f/U/Xgb/30bVuAchBpKA=;
 b=HnfEI3rb0YvIo/12WB5OTVTGWeWzi4GKOt/FfhUIN4R8WXR1fIj4P5ONTUuwSxHbfK0n441MAUUGBlJ5wcMmy0N9IqU3+kCiwPkIgadlBmFPMRHbjXIJtr35QD0RE5MYuzQbFAlBvBGlW9ldcBJsKZIxjugPKzkjmh9n062o6RU=
Received: from DM6PR11MB4546.namprd11.prod.outlook.com (2603:10b6:5:2a7::24)
 by DM5PR11MB1883.namprd11.prod.outlook.com (2603:10b6:3:10b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 08:23:23 +0000
Received: from DM6PR11MB4546.namprd11.prod.outlook.com
 ([fe80::c18a:50b8:bdff:2fa0]) by DM6PR11MB4546.namprd11.prod.outlook.com
 ([fe80::c18a:50b8:bdff:2fa0%6]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 08:23:23 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "sven.auhagen@voleatech.de" <sven.auhagen@voleatech.de>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: RE: [PATCH v4 2/6] igb: take vlan double header into account
Thread-Topic: [PATCH v4 2/6] igb: take vlan double header into account
Thread-Index: AQHWuEzm1HVTLNMKWkWhDxMz+yb+g6niBYrg
Date:   Tue, 1 Dec 2020 08:23:23 +0000
Message-ID: <DM6PR11MB454615FDFC4E7B71D9B82FA29CF40@DM6PR11MB4546.namprd11.prod.outlook.com>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
 <20201111170453.32693-3-sven.auhagen@voleatech.de>
In-Reply-To: <20201111170453.32693-3-sven.auhagen@voleatech.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: voleatech.de; dkim=none (message not signed)
 header.d=none;voleatech.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.79.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d079af72-521c-4e35-2a24-08d895d25e6b
x-ms-traffictypediagnostic: DM5PR11MB1883:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1883EAD8BB988D99A8E41BF19CF40@DM5PR11MB1883.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E70dlnWXs4NEGc9Cj8HYjP2cOU1Be1j+4Daxii+i3L/krif4gvOL5OO6McLTn0xxtxqAyj3COrB9uvlIvzcqdh7Xr9U8bv3sxe9hdE4HJMCZL7BtExgjWoHVzYU1cPVjsXBLm8Sj13GrKwoHvFfvd7eeW5oboBXa9tLwbD11ZElfRukbtCri4R4WztOF1+61ddoNuQyTHeoTCbEx7f+FDsi8BQ2NPPcKChQMnHDBnYD8TWdMndC2pD9pR5dQbozcSfOV6kKwgSK/0B3p52XL5vmSemhk/xxYUMLLc5j4n9WxTtJ5y0PDJ5q0QO72kQOIJfniY5H2vxstrJtwLX3wuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(4326008)(83380400001)(55016002)(53546011)(110136005)(316002)(9686003)(15650500001)(26005)(54906003)(33656002)(6506007)(86362001)(186003)(76116006)(5660300002)(8936002)(52536014)(7696005)(4744005)(2906002)(66946007)(8676002)(71200400001)(66476007)(64756008)(478600001)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HEC1aI+ozbnaogSbKF2qdDSZGpClZ4Bq92Vb4ulb2ltteLvffbA1hF4o1HYR?=
 =?us-ascii?Q?eos5romxLzfUas1F+0ZW0KghL4EG5czL6M2N9A6O/Io1LoNQV6TXU5Jl2oGJ?=
 =?us-ascii?Q?YJCqoi6blhVC3z1IMbsBv13GXfle4bKW9d47/VR8pjfBIHt1FVs/5hkhCES3?=
 =?us-ascii?Q?ddExCUA4bw50XFdcQyNgEWeEIvnR8J/zzAEgsbCNx+GgmrbhgV8yYdCHhMAX?=
 =?us-ascii?Q?MlPpzvHJpFymrj83gH49wd0DBHyufxF5aVsVPUrNOpp/3bxsqXAkQ09bKPs+?=
 =?us-ascii?Q?b+0Whcg1Mky8MD64+aui73w00cmjJofybf32tkQGIYCFF5dJcMUQrS74wpny?=
 =?us-ascii?Q?IJLrVcwyo0bMSqjGY99XsXupEejVw10+3kZ+jcoMklBTII4CZjPhBi/xSp2I?=
 =?us-ascii?Q?erX/OmdlEKgql3kphRGLcC3ASB5lAZY/And+H94nJkXp8thO2E/1pct+w9YB?=
 =?us-ascii?Q?HRbWCf2K8FjGmsp9yyASSiTQtKtu+t+kfAn6CTyFbh5DYbsFQ0a0LvhcddHv?=
 =?us-ascii?Q?v+ywVUDx/cfG6epm3dAQefnuLQKeC15jUXKEU1lJm3wgltfX/wkD2CmZcZtB?=
 =?us-ascii?Q?Dideqbkt5YR/VN2Z3L5jYWA3nfPNgS39/pG6Ft5mMSuTec+a6HJMnVRmV3Sn?=
 =?us-ascii?Q?4JW9ralbB9g6p652KMnPuexDbg/9DLUYJUcJr/xlMYaa9wu20Xotzt70SuSr?=
 =?us-ascii?Q?JnG5edWm4kjnE2z3/p3ImBho74TYfWf6yul0r+60M7X7TT+fcxaWAKp9ZNM5?=
 =?us-ascii?Q?/c8nM09E34Ahxu+2A9pgDU9lD+8IEzRLBeJSejAc7OlRZx/eXmuSeEFRYPpn?=
 =?us-ascii?Q?MY4m40Iq7BXrjvTvVglzmMgS4OsvuVVolzUwDu9/Z+NirtPsx1bHA2lD65ki?=
 =?us-ascii?Q?oh+SALHX7kq3ATL/2cQnW5Sh9aH8pCHal3xBMUgCL2zGZAat0km15KVcQfiZ?=
 =?us-ascii?Q?v3MRh7Wa6k/Gj5fiuv+FT2kOMwrCWj1UriBk8fLbiVU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d079af72-521c-4e35-2a24-08d895d25e6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 08:23:23.2169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tr6Heul63QsTIuJTMzATlEKGPFOwo4eyWcPeNIqEg3A8Tcv8M+Dm8jqFHqQfCFlbSMZJ0/xOMlh83TSIZujna5jy6rnBxMfhqUEKpxs99PY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1883
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: sven.auhagen@voleatech.de <sven.auhagen@voleatech.de>
> Sent: Wednesday, November 11, 2020 10:35 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Fijalkowski, Maciej
> <maciej.fijalkowski@intel.com>; kuba@kernel.org
> Cc: davem@davemloft.net; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Penigalapati, Sandeep <sandeep.penigalapati@intel.com>;
> brouer@redhat.com; pmenzel@molgen.mpg.de
> Subject: [PATCH v4 2/6] igb: take vlan double header into account
>=20
> From: Sven Auhagen <sven.auhagen@voleatech.de>
>=20
> Increase the packet header padding to include double VLAN tagging.
> This patch uses a macro for this.
>=20
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/intel/igb/igb.h      | 5 +++++
>  drivers/net/ethernet/intel/igb/igb_main.c | 7 +++----
>  2 files changed, 8 insertions(+), 4 deletions(-)
>=20
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
