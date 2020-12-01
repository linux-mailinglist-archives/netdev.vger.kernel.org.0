Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028802C9828
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 08:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgLAHbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 02:31:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:60751 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbgLAHbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 02:31:46 -0500
IronPort-SDR: KyhZtheU5S4NA59yZ7K0GJm/xPLDoZ2AZfGpEdeluZ0ourqUyWOMB0dsHS9lfrgLjjUmigtGbv
 Np9ll29Mcl0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="152613658"
X-IronPort-AV: E=Sophos;i="5.78,383,1599548400"; 
   d="scan'208";a="152613658"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 23:31:05 -0800
IronPort-SDR: FXGL6qRXaonHgejbJ21EmkoO3uaGEaDdrgsEZzx0N2XzzxGbF+c1W78zZI8z/2Dbu2b/V2VHs+
 FZzGTATQey8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,383,1599548400"; 
   d="scan'208";a="537328545"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2020 23:31:05 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Nov 2020 23:31:05 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Nov 2020 23:31:05 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.51) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 30 Nov 2020 23:31:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyKzFhpg27qm1OWXLwFNP05YBYq9s6CsWX1VGsfWdfAxkeDKODiitIwE4y/1/KFibSCOaXUeCtkWB/f7QnGtuV/lKBo7ASQrO0QRVlc5XeW21Dt8URz6qwH+SvCgkguVXaVgA8gQ76VACidI7UVPPy998oZg5eXVJCSvxuVul8hwcqKDlqteWrqvB01Scr6gRBFVv4vM/YAqya3k6br8xJ1smFGvR+tGUBYR/qMHbSw3/9Idzxx35hSm+AghXEkXxDLVFG2u1+l4e+i1KmaI58RxUqD8Jy6g34c5FrlwwbjELKlIHxDCzQ6QWmhzK43M+vajRqOIQRFxA9yd/Xf6cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8M1/UdKdSTIi8rIvHbhvmzUsPSk8PnIfF913rXGy2Q=;
 b=goyiimoj7Shlp5OUYkOuwxMNTJKKwpAOFECvc6jlSML+XzYUShfcnU6Oxico6g3k2layVXm6MeiJ9szDuT9A7ekIPQZUeOO7Zcp/EntmuVCOr7lA+CGcpdDTFNBffabzOs1yCHSd2Wy1wGXwznhsGMvB33+bGMs31lzpiz0CSOxvS8s8EFSN/n7pBBSc0i93FV0s5O2zzdmZ4KKGToLErX5qLkuadNNiGE0aeY56qVSfe5OLhz0Ztv05hm3iEfhkofkX6PaaqKHkBnwUjmPugJkqusrWhU9YwrCB4aVnfofWjxuRbRi1iWdvf3Q296ZBe9o92xW6GWFz/DS98F720g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8M1/UdKdSTIi8rIvHbhvmzUsPSk8PnIfF913rXGy2Q=;
 b=ujU4DiOB0ZZN0MCXCpWMonPbKJChjyDJgc023HJWE4xU6IEdYe/Vni0XtibuqJVJq09W7+UCGdPMRPuOqkbZSOpk7ix/T6/3gtiyPFjo2sXnMB4GFp1i45zaHi5YW3839fgbtMWkFaw2k/hZH9cs48f8dbdnqDlWUotwT0Mm1wI=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MWHPR11MB1984.namprd11.prod.outlook.com (2603:10b6:300:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Tue, 1 Dec
 2020 07:30:33 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393%8]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 07:30:33 +0000
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
Subject: RE: [PATCH v4 5/6] igb: use xdp_do_flush
Thread-Topic: [PATCH v4 5/6] igb: use xdp_do_flush
Thread-Index: AQHWuEzWRUNKferQhEmfzpoKnuF6zanh9o/g
Date:   Tue, 1 Dec 2020 07:30:33 +0000
Message-ID: <MW3PR11MB45544D6F549DAD89700D1CFA9CF40@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
 <20201111170453.32693-6-sven.auhagen@voleatech.de>
In-Reply-To: <20201111170453.32693-6-sven.auhagen@voleatech.de>
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
x-ms-office365-filtering-correlation-id: c426d71d-bf99-4a6d-6fac-08d895cafce7
x-ms-traffictypediagnostic: MWHPR11MB1984:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1984339D3D2A6E24B221901B9CF40@MWHPR11MB1984.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AI4zNpAmfLGIFbe8TBe7D+TxLtOKfd4Yr8ayODfOwXnBnb5DrGG3VfXELt/TBSFOGZQvXo5futw0u12375NTlpgStmu6Hrv614ZcpBAr2SNfLcL1fupdglz5uw+I2Y97r9STc4Z8CWGpPjRdXhxRXWO4wPzYon3/1I9jfDHaUug/LlB8qof8Ms6YEzjijel/pUYUUnAr8avxhjLBMj0Pmxy9wuwhQLpBdaVxgj2asugRhotErVbWZEfIfynNubsx3dgkrEvFnCSVrsshdNj/y+oGXyaaeg6eoZPUVO1fYc2Odnhm52JaBMpmVT4Koaocztl0u+IemFrsfTZi4uXZRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(66946007)(5660300002)(186003)(316002)(52536014)(4744005)(71200400001)(9686003)(55016002)(26005)(64756008)(76116006)(66476007)(54906003)(2906002)(110136005)(66556008)(66446008)(478600001)(33656002)(86362001)(6506007)(83380400001)(7696005)(53546011)(8936002)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5UpWr1gsoW0wVY01kjcMfVO6Gf4sRYy6LxnExhNkw2fEHPtAt5uPXh2dpjXT?=
 =?us-ascii?Q?IaLaJu/fKSz64QhRxKIW9XvR+6PLSmoBnlERkknWe/J7HGQ7YNIcDNgasBQd?=
 =?us-ascii?Q?D3jB1CpRLtv83yKUySweOsGGYk/3GgH+td8Wk4QoOez0hwUZN84Q3+B4h8It?=
 =?us-ascii?Q?722J4DTkSxczYBYFxNM/2sNcxDdsgG41ZEVe3sMEOEGDKrviW8M+sclKBrno?=
 =?us-ascii?Q?GD/k//L+zqXZRLFjL1gxAxxo29NUpGvddmqUsKekqHGb0h1gVW3jP3pHYOBv?=
 =?us-ascii?Q?jCEUPIp708Qss1r4HAZDAPDwQHi4j5zEPE48GCp8j7gYLRsJfxWTlfVFc2TU?=
 =?us-ascii?Q?M+9XfgDFspPMd0Neun/n9JJ9NRanRyPg7r5ZJjPZ5uKaYj4URIP0vetPDOEh?=
 =?us-ascii?Q?ZZbQ0CX+ojGtwMXZwU4em8pTD1FJDrHd99rRjptRqYYIhlR+ibsHdQqbMSGR?=
 =?us-ascii?Q?nDZgkTeFy8PhkXWGRojTGdLNynhrj0kq6ZIbzJVtvGHoPNB8VTaZlsl96hj/?=
 =?us-ascii?Q?e3KrPezS6QNI8yp7ana6Fcr6ODlUQYOg6RPsxd6uo4mCju3/HXtHTPx1CSWx?=
 =?us-ascii?Q?0FhQ65TqtlFM3iNKgfL7G9niXJDTBUs18oEdakJmFf/ZPy8jOs85d0q6/W6j?=
 =?us-ascii?Q?jJKHnEfprjGu1zJnJFY4ldFpuohefmhRYOPTG6i1iBmnM34XbKcv91yw2ytL?=
 =?us-ascii?Q?eAoDuD9DuzjPmgRHqe/l3SNFmOVpdYhMfe26TY6x9rQkSf7LwKttBxrlVrjz?=
 =?us-ascii?Q?JfW9FILH2BNmi3P2Iof4u4Vsg2knMWgty7OPaDGpUuqnah4ouWkFkXRgwqnx?=
 =?us-ascii?Q?bnWxtLyXiXwIMc4hA2RwznRH3uhwJhdgDgiD8LuN3EWQPksBkmYpmjOm5QaK?=
 =?us-ascii?Q?WrkZZhYvmjnVjxVN1t2FwAB+Qh5zWiWvaW4hkbYVQksuGRSFsTHuO1zeW5ea?=
 =?us-ascii?Q?NYfiNhJPEXzJewTTw6pjiqPOmSQQZnhCNgPeGDa+ceI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c426d71d-bf99-4a6d-6fac-08d895cafce7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 07:30:33.0648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n4Sl+mDovrDutRAMFEwISNZQcH+rFLSu9fqIyP9lYqpiYxRIUXDnAprIsGiH5HhL/GYpniTkyZEoCm8NxzDzM+EAXWjLAJ4hI1muJne2JXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1984
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
> Subject: [PATCH v4 5/6] igb: use xdp_do_flush
>=20
> From: Sven Auhagen <sven.auhagen@voleatech.de>
>=20
> Since it is a new XDP implementation change xdp_do_flush_map to
> xdp_do_flush.
>=20
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
