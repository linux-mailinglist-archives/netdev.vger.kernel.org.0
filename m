Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A1925E2AE
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 22:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgIDUWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 16:22:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:9745 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbgIDUWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 16:22:09 -0400
IronPort-SDR: TsX/z+G/ZIURnOUY64okZJfLAjwfKVGvhB8ekrmysOXcj+fPpnfQAcmzFcEmf1AsdmlGKKXLpj
 qvfazN9jxkbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="157820581"
X-IronPort-AV: E=Sophos;i="5.76,391,1592895600"; 
   d="scan'208";a="157820581"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 13:22:07 -0700
IronPort-SDR: vXn0+lmcXipaBvDYZLwTjlsGd34etSIDFRy7MAJYYA9GMecbkAOVaPr3KpeEpzccWmOp1Nd9bI
 VTiEXc43J3cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,391,1592895600"; 
   d="scan'208";a="503631125"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 04 Sep 2020 13:22:07 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 13:22:06 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Sep 2020 13:22:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 4 Sep 2020 13:22:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 4 Sep 2020 13:22:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVaTNK/+QZwzaSXlGOKDUUDXxrFdGts1C2rPk7oqtKjJQS/sUe+wC0N7o5dVKCZaoXtUqh68Jy+gvTmvBKVd7Q6pzvpgaAhJ6sz0Ap1qs32A2Pme/MVfwea4N3N0B3hm1V0/2hmX3nqH2DF0dhZPR6EZak0T5On9iBBl9xYnuaXmiWzQDVpAc/nfJqGXPMT8jndTaPzQAgIba0jBw3REm9Vwp8perSCgFHhXurS/khatEiLWpuiGjurw7hNhJba4ZRFXOFRanoxg5NPKmaBlQgurbuPw/21BbGlzid8lKBQ2VmUC34S73Tmne2EKB39oceIqmhjrZQaOE/G1KkbyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILDJtu5YC7A+S4WyCkPwAoqtLhhoRWR1mgEfigOUKdw=;
 b=NgB8EJ63msJ4A8lmzpfxyW0Ku4hjB3KDVw0UCQR4dPe1a1Q49QMi4s6YeJ3lIfXtc2mE1AqDCqoMwpVJjIga6L/PeaqzRP1aXUpfUn/0ZUDpfwyY2/WuAzEOsSwnbnlUX8CkVPoNfBl3xKazejYTpvu8AZk1CpTehmsSEcrV2Pd1zFlb5gl9tDRh7CUYpuBV5khwifaEooBiFDxrF5Kd/Tpio5lTu4VTtb1OrDVu8xUeG9qrHeWsZkOx5w0EV/eD6ZZb/Nxy+3VQImbJqwCPyul6vk85UignH4wXYheODsIf1O/eueyLLAU6oYOJJ7PR1VMHuLuq0iVYNwb3sojEzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILDJtu5YC7A+S4WyCkPwAoqtLhhoRWR1mgEfigOUKdw=;
 b=M07TCORugOtpUjYza8Zc0ndY6NqtzxovXk0m/a2MbADWFscX86HTU6A3x08HRUYfaCwwomrL9RMV2oVeqzt1YIfDwHo8W85/qBaDk2ICRVm8SDkGmlJOc/dgyY/gxn97cLCKCe+0GTd1nj1TnOxnspulexiRYCnSz4D78gB8C2Y=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB3547.namprd11.prod.outlook.com (2603:10b6:5:136::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Fri, 4 Sep 2020 20:21:32 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f%7]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 20:21:32 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Gal Hammer <ghammer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Marcel Apfelbaum <mapfelba@redhat.com>
Subject: RE: [PATCH] igb: read PBA number from flash
Thread-Topic: [PATCH] igb: read PBA number from flash
Thread-Index: AQHWfpDiRbLgLmN77kmbno2nW3PsbKlY9NCA
Date:   Fri, 4 Sep 2020 20:21:31 +0000
Message-ID: <DM6PR11MB289033DD7B7C778FA977F617BC2D0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200830054529.3980-1-ghammer@redhat.com>
In-Reply-To: <20200830054529.3980-1-ghammer@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.215.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bf8821d-25ba-4316-9836-08d851101d11
x-ms-traffictypediagnostic: DM6PR11MB3547:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB354741E5D56392049FB6B162BC2D0@DM6PR11MB3547.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 63hs91Zn3rjAYFuvkxY9XX3/N5WQILO9qbVfUDCtlkBpWB+XfgtCB0ZHvtvPBctNvoiFBkkIahhZ//jWkALwU4R+xjwcAqyvrCsS9j/Jbk2MXlwj4mgjbMjrIT++4uRgAK8906yU6yd8XZGTAicTUsWZT43H6jfNHsHKB8fChFwlsm0Iv2+2btDK0NIHuApgz4Xw3iFczLbscRixNLN2QubvUnxV6nWIN5VhMlEzHd8/aHhH7qJ8LQ09U80CEEREVfWHoqJ0Z4MDKbuZiDjfkUjnrmoy9SwOoxjIAB26x3+czI8+FE+F4gCCRQ8RF+A+0pxlt20icgQeMdn+LfpqjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(8936002)(7696005)(6506007)(83380400001)(316002)(4744005)(53546011)(71200400001)(5660300002)(2906002)(52536014)(110136005)(8676002)(33656002)(478600001)(54906003)(186003)(76116006)(64756008)(66446008)(26005)(86362001)(9686003)(66946007)(4326008)(66556008)(55016002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: L92g2eSnkKANf0PEZx2nGpYXirDrKHgl+g5+2EVC9nnUMxODq3SxHzyw5+YIM4MYit6FXMeHrogNghOcOc1h8m2Ow+c8Z0d6GQOh0CWShbiieZa5yxIyXI46VHMOY7IX7exkjQOYY9pf3lGp9oni63c2poH4UuEBi0UA9g56BQ675pWAfV82hnAKSmVvAuce65WJRL2VeiZvS/095HJaF4GXPrRrttz43iExAbAUiI8e9fo3JaOb4LtlPd/UiibCCsonUKKqVn+JdLnuZdn4sh1v/cd3GCqycBnmlZdcJRm9FjjyMuRWTSklb9SpPf4S8ZEynBnWMzh/Vi8i0cs3qdu+OxPsjX/FL+KLXADBkCmHwqkaFKH9oWUU1cxbboO8xJ9ShXJz3vYeo7bJ63S54kJcSiVjj7FnKJa66YRFFt0zb4BX2kCpKbyJ1K/DJmhOQiglRDO4qBViMDTRWdenzIHxbJzVcWmPtsmpfLIq9C9TVQJfvsnMUYLj5GIyQjMmNjX68JeavL1h+hyPHXG3DAhhMj531Rzc2pbiulFxHMaZKrA5J/QDzD9lfxdR6Cq0WrwbYktI+W9SYKj4Nxq4UZiRMzpCQjUI1pebgXYDNcZkvLtghZzjjNG6Ap+dHrKL06HJzOu210XLk9wm1oKCDg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf8821d-25ba-4316-9836-08d851101d11
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 20:21:32.0854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dhYXo7diLqN01Zet1/4MhVZOXgDaAVQfb/Thr8Wnf083QSi7IkCvk+Ra8IHF1+D0QgTmSFuz/CqZkEcW8V6rBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3547
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Gal Hammer <ghammer@redhat.com>
> Sent: Saturday, August 29, 2020 10:45 PM
> To: linux-kernel@vger.kernel.org
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; intel-wired-
> lan@lists.osuosl.org; netdev@vger.kernel.org; Marcel Apfelbaum
> <mapfelba@redhat.com>; Gal Hammer <ghammer@redhat.com>
> Subject: [PATCH] igb: read PBA number from flash
>=20
> Fixed flash presence check for 82576 controllers so the part
> number string is read and displayed correctly.
>=20
> Signed-off-by: Gal Hammer <ghammer@redhat.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

