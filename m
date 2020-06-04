Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8D21EEAFE
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 21:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgFDTQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 15:16:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:47658 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgFDTQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 15:16:41 -0400
IronPort-SDR: Vt6zg0W/jyxzeMkyWc8Ui/ZBjgM8pZ3dP9Sq2fp9ljFc0orYSvl0OtsQO5mfvrF7OstNregeHm
 3kDEafLA3aWA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 12:16:39 -0700
IronPort-SDR: uv9cUDw8Zk6fikDiNZaplWYf7Eo5VRGo1QrIxpQAFrLlRdUqIJ+mRx3Yuuog1pCIufHdk7ZwPR
 OPAH3dyncynA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="471640645"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jun 2020 12:16:39 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 12:16:39 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 4 Jun 2020 12:16:38 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 4 Jun 2020 12:16:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 12:16:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeKwHF56C01Y4VyJYgakjtAGNTEtZe7UV0ZK/KAWjfRYGkYt7Z3jBVrs31+Nenp+1C6fEaonCjx0HPE1fda1oAjSxMJaEPPxHxEKSgwvCC5mD9jIShfGFsQz7Y8dbmcl0H1Uo6TWbvCnIAcTjUNMRyf9YdD+TFeSEdZ1AC56w8V0E4Era73QSRZc9SdsBkoKv+c4XNtW3IPTxt1TaiBodfl6nQR7YIuodZFMr7sdFqMiHFiU7ozn/yfrOeMLAKK39qIn1UV3FunM3R6P1n7LlBeqyw3JiZP/Smv6QKcB2i6yXVwnZ3BjWRycDGZIE6EpEklaS9VdARitbv+nLRajgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ny4/83fmanaKWIRTBBbtEsXpeK0vQPiJpGGN+NKKYE=;
 b=iYnry22qYXb5sT5cofNByc5543q7Zn0YmtElgGPgikgHwStYz05FLo0PurSctFxYbolAHiXuicw2NKzJfZbS+G8OTU07s3Fm7H5quodOoqivNFJRLEoymMG0k/y7UT0wRkun2GUA7nbzbs2/UYcjYxoDWBCo0flqbHl5CJxMtDqJDuhfZmYLnAYSNSWLbLZDBXRrXPL4ReDt8+V0Ge1FaIITS36zDCvu3jBNKZ6ZsvRnU6UbP07EL7HEbU99vb8rhkKHEQh10OQX/A0D50v2WSsVnZor3EiEYJc0JHL8Ij05mtKz9vwvRgJcYFcwANoZ3goesH6dV4LyTbBhYkSmsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ny4/83fmanaKWIRTBBbtEsXpeK0vQPiJpGGN+NKKYE=;
 b=DSDaeFx+SVeVUhTsMOC0N09fWOp/rwu/jTF6S6Ns+aXkvXNR6r93238+yLZl2/4dSXhI2Ex0XqranZxxHrjB5DCGLivl0XdW5XQAJiLqviUCXe71z1BfwJt1fO/rXTKRYotPV7aISsrhzEeulWo40ZrOGPoAVzwMJmAW5BO8Bl0=
Received: from MWHPR11MB1663.namprd11.prod.outlook.com (2603:10b6:301:d::15)
 by MWHPR11MB1552.namprd11.prod.outlook.com (2603:10b6:301:e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Thu, 4 Jun
 2020 19:16:11 +0000
Received: from MWHPR11MB1663.namprd11.prod.outlook.com
 ([fe80::fd6d:2fa7:3dcd:30]) by MWHPR11MB1663.namprd11.prod.outlook.com
 ([fe80::fd6d:2fa7:3dcd:30%12]) with mapi id 15.20.3045.024; Thu, 4 Jun 2020
 19:16:11 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] ice: Fix error return code in
 ice_add_prof()
Thread-Topic: [Intel-wired-lan] [PATCH net-next] ice: Fix error return code in
 ice_add_prof()
Thread-Index: AQHWHI0AU/4Hcp/qn0KoJYsUf7CVyqjJD/jg
Date:   Thu, 4 Jun 2020 19:16:11 +0000
Message-ID: <MWHPR11MB1663790302E561B81C8767078C890@MWHPR11MB1663.namprd11.prod.outlook.com>
References: <20200427121228.12241-1-weiyongjun1@huawei.com>
In-Reply-To: <20200427121228.12241-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33d814cb-44a3-458a-ff5e-08d808bbbe1a
x-ms-traffictypediagnostic: MWHPR11MB1552:
x-microsoft-antispam-prvs: <MWHPR11MB1552075E12C363E016F729F28C890@MWHPR11MB1552.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 04244E0DC5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mYPQE+NKeOoI2jiWnEdWC/HoAaZ7xFxGIrXyr9Yp8ytVtYHIBnhC7bR5hWeOw4L4dLO1704TKnskGK3Mp7Oi2n0gM7FMzjp6NV16S3eqFYkgTc6ma5QtHmz/hrXdxue/lPEUwMvNNrl8xOCNQXGcx6TQhUM22lnzHSCjZ4XpGYEfdk5bi5HFfWQ4g7xduj0BRy4r9s7ElATrwnOGKqocEHeVFni1HPsQ99tFbNRqiXuz6Z3hzjwBJ3qWEUEPxYNbCjc1norXWWS7njRfsMoeZqFU7D7aC+TXi/zL3UALT1+0uxsCnt/eDAKDNo1cEHJiEVM/uszYNp5Lg5xiQ0naXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1663.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(4326008)(6506007)(9686003)(478600001)(55016002)(53546011)(4744005)(71200400001)(66946007)(2906002)(66446008)(83380400001)(26005)(64756008)(8676002)(66476007)(66556008)(316002)(86362001)(33656002)(7696005)(52536014)(186003)(76116006)(8936002)(5660300002)(109986005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: v3zmepSsb8+NmzvM6vUOJTva0xBP44g4fNM/SJT+5BvEjU/aPlAKGE00KlYMsfsg4FUqGQ1zFfRaZrV3ebTvIxC9vBJnRlWTSmoXi55lfBuRDh28SR7auEsG9mrxvJv2XAS+mzF62ve43E+Kon9z8l7MML+xmC+kD8AJvy/a+L/hbZP+Uie4KT/pwiBEEAHR9LRYEQ8MZuYgojIjgDA8EbRITLLGGLIYIXqIT7jhKmADbfE77oQYAdLSi2cMA7WY0+SIJSRpkdmCsDdk3kJy9FZjkm+B/YSfODe0eopU/QeoXR2LIKFQtRoiiVqxhOZbZQMGYSsJzmMm7DgswlNOE8oq482Myyd7nxDflqcNQ+aUIGxp17+bFpKjx5AV+29BFT5JZO1RrrWd3sd4WL6QXO1oYnN6MOAia9MZqkqk7lwUTOcJ1tWi2ohQONbHqkegoFb55uJRYR4XH0ZRh1R0A4BmaJWMRuYguTJCGLJRE0E=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d814cb-44a3-458a-ff5e-08d808bbbe1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2020 19:16:11.2272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yqIw1ku/rwIQLaiICJXhSky05WGNQclr8J7Z3FVIOXsGNw+ejDX3/45ElnDJ28+tfYZ2r0cvOCKuSO87fYjAYIRgoJvTxJQqcjmXStwjigc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1552
X-OriginatorOrg: intel.com
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wei Yongjun
> Sent: Monday, April 27, 2020 5:12 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; kernel-janitors@vger.kernel.org; We=
i
> Yongjun <weiyongjun1@huawei.com>; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next] ice: Fix error return code in
> ice_add_prof()
>=20
> Fix to return a error code from the error handling case instead of 0, as =
done
> elsewhere in this function.
>=20
> Fixes: 31ad4e4ee1e4 ("ice: Allocate flow profile")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


