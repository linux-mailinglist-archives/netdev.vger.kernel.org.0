Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D0220A37B
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406413AbgFYRBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:01:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:2215 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404011AbgFYRBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 13:01:07 -0400
IronPort-SDR: DfD1GwKMVKMIsjOb1AAuwcXP46KWYcTZHcskvvJK9DfbHEHCRgA4ZHI73mKDvozYZueQZIKt5J
 QrsF5t18/CzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="132425328"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="132425328"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 10:01:06 -0700
IronPort-SDR: Zs3eebouPWBoTlVWjBsLXcBvojLLGDhFvVuQ2qgPElu2lbAV7tnAVqaiGrG9SPPIXw5aWoEh+7
 FxBQ8kBcxDUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="479536655"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jun 2020 10:01:06 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jun 2020 10:01:06 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jun 2020 10:01:05 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 25 Jun 2020 10:01:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 25 Jun 2020 10:01:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O75zDGOuw3qUTTy0Qsea5n/eTMWDH2Bp+/GMOp5Xc1Kns0GQgC38/qFzjx90Ff/M8da/ufuyDaOdjQdm8V6Qh8rp/fK8xR9F5/5yd3+1Jdcm14CAZKT4aobPOnYJKc9U3/lLjQu27PLON5F/o8AmH4WY28kKgTz7Gf7Yd9I6mDbJLQz482FuySoqEDQopGmBqsa9oS9fYTzxb5NHv0RAvZvqasZbB/6b08Nefu/qxPOaEyqu1M5Xtl1lVgrOsgAH63x8uXM7QTQdT7bvEK6sghCsnFT/WQRf3RnA2HATZLGXTZO7rbo1nAJoHx9p02514HBqynnwseTaEE+XYrB58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlTneSaOhzPyXCS4VfpS/YLxTIiSEM2pGfKhhqiNSIk=;
 b=BIaC5O6oIU4tLdLEH6ChMRgE91ywrApV1RyDdJ0i0QABAYukD0qlcfP7he3RSSYxavMJCPcHY32ENTbQ4H6tWIhqCuZzabymQUTnhJds5KIx6ziwpw8mW5DWKrteoVUhCLeNVhFMhSe4xvv9+8kIfUMVtj3yh9a2C6WuYt/xWKnh3rHrTyNaP8KhUW4RSABKCXQnxJ/R3+XReV6/z2yBPN+5qRsMJw1P7JA6QM6mYDNbevJvT0po4fiw/u5Jkk9nRQe4JlSy1EzKll4xZ23uo96D/NF7TSrD62X1G9VxQeRX0rnWeNoFk9MabhwPv4oWdd/84QbsoFnQuzQ4bg6dFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlTneSaOhzPyXCS4VfpS/YLxTIiSEM2pGfKhhqiNSIk=;
 b=ZinL6Jr4GLJO7Mn1/C6KTFtIlNULv2+F/HHLgjY4vOilKHJV+Acc2Ky1C0I2Qx6p75AkjN4fvns7mi5DuKyQEEhm2XMaouwENnw7mtYc1QfWFEeY70W/D+1HkKevVQpFkPHUjrGgjP2EHtIUJlgtwWZKjBHvqGQQjk+nfHodsuY=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN8PR11MB3697.namprd11.prod.outlook.com
 (2603:10b6:408:8e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 17:01:02 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 17:01:02 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 1/3] i40e: add xdp ring
 statistics to vsi stats
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 1/3] i40e: add xdp ring
 statistics to vsi stats
Thread-Index: AQHWSWIxSah42tp6a06cYSM5Ghv/m6jpkY1w
Date:   Thu, 25 Jun 2020 17:01:01 +0000
Message-ID: <BN6PR1101MB2145DFAAF9A8BDC5EA0EC0588C920@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200623130657.5668-1-ciara.loftus@intel.com>
In-Reply-To: <20200623130657.5668-1-ciara.loftus@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 317a3a60-3971-4028-ff2e-08d81929573c
x-ms-traffictypediagnostic: BN8PR11MB3697:
x-microsoft-antispam-prvs: <BN8PR11MB3697B6B639945787D9F438558C920@BN8PR11MB3697.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gf44XiAFY2B+siU+e9t1KD8lZY+Fo1nH2KKpNG6voBtD3uD+KEcQc/SuyOiVaKHTyMiAK0gys0eemXxPLZHzjFI/MHaEqEwuh7JzKRA/eEY/yzLLQZdd8cZJbfhEpwpkZcL4MxRV+QaYZVJFGS48AEBvjcaBs7urNjFk9iKHc6wFKPPfKvVCfHEaKtaDRJAf8/U4kMhm+Ot326is4FOkhn16ICC5K3zmWK0nvHvj/drvZ+p+gYTkxIau7Pcpb6IxGA1AWIr51Q2S/QYGFcxcYFOyoab29nEpNe8lcikuhY7YOn8kw5qeEco4XzxwPjQ1GQI0sfKykr+D5phNtKN1Sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(26005)(4326008)(52536014)(478600001)(53546011)(55016002)(6916009)(6506007)(8676002)(33656002)(9686003)(66446008)(71200400001)(76116006)(83380400001)(8936002)(316002)(66556008)(64756008)(2906002)(86362001)(186003)(5660300002)(66946007)(66476007)(7696005)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TWQIlQpKwFg9A1qopuLwIKsdmmCF/mFusDm8oXlYCvabYLCTOOF3yBAZR2B8THKXVPd/qrGvoMd+IrfPLOp5YsDUODFkXwvXt2i4rLYHBliYb/E5PfGH/6hwsJSpGdNaQG/q2Zf+o/JaB6YITRLLGuHEBJrUxUqQB0jA28VU1ejFQsNLkq65pI4vn45CdPgfkJIjT++tZiOt62fGkWpe5tK2K05TVGILqXLyHVR7mez3jUb0rXWHjcZ10qN5x4EhLIGLYqfgDeGYFC6AbHHoLOh16ek8/0kLXyOl9F1GJV7y68OHuc+N1mp1D6zMIISp0n17gQNkOBHe3+t9nkSpWBG8qEzhaZGqKyk3UCX+ZjtAUmmw/GBx1XSvYOWN0OyhwLowd/5GSNmDvZuBBFHgq9RuQvGMEquRjqa16Y3HQlEnKGtrxXqLKOXCtXzNs8tAwoNPSEXNOKu/wI/7P4N4R8CCkT/6IB8TTwr7/rGWLxvYBEqfcYT86Fp8O8RjJ1r7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317a3a60-3971-4028-ff2e-08d81929573c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 17:01:01.9314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z1TOjJsnAvm7UGWrtebSytEExpwvZ6BYdpUi2n1kgY+OwkNQNyE+b3YKGAKE8U0t/rSZSDMLEoPY6aQbjfL/tC1l9Az0vH7yqupM2ZhxZ6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3697
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Ciara Loftus
> Sent: Tuesday, June 23, 2020 6:07 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH net-next v2 1/3] i40e: add xdp ring sta=
tistics
> to vsi stats
>=20
> Prior to this, only rx and tx ring statistics were accounted for.
>=20
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


