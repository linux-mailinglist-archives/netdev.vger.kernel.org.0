Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC923F2204
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 23:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbhHSVBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 17:01:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:5376 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235429AbhHSVBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 17:01:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="213525832"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="213525832"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 14:01:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="641851314"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga005.jf.intel.com with ESMTP; 19 Aug 2021 14:01:09 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 19 Aug 2021 14:01:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 14:01:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 14:01:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3Ikw2dawIDRgWgxu5eDdiQrIRQ6l2aIc4TG0qpznylV8iJZOzSqe+Syim0Yn1bIwDmtlpivOlbs96xPP4EQHEyec2cs3iNA2mg7n+IqlqcuHQTHAECMJ6jacJq+oc/Rtqt9mrWjM2z2Xv/U3JdTDRxe8o70TarwT2VowifK9BSqFZdrpSvshDID2hU6Cld372XRIMkAHjh46fQBgsgq8UHHv/Z/hBONXw3Dnt3cbuu4C668W7ufaY928uo0tXqp3/jbzw8pIkq1vmtc/tUzJDMQdhF9nexqoC6uvN98fZo1aRYtZeKi1nYXSPxBt1Tp8rf9qrOd7hxLJJ1NjqLnRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUohrfstm+vknV9xmr83MngBjZEK+3aDvbSmwubFdjw=;
 b=CSf9BIqQ1N+JaGzCn9GVDCQ0br1VZOhUPBjd7gve5JSHYjE5YmhK32wd1PPocMX/9HHuCA56n57BnXNiTQrpRqn3kAHwKb96c4L/xvBUS9acF/msgbKeiksmn/vg1nmInR2Bxb7xjlh5U8Uxusuurt2nOwp5BaSltApnyiJY9m70YAROou1K2R4DodMLYusZ8kTou+CPD723K3ITiAbKibCM9n10iUfYM5KRw+GPwd9zbnI11YDdCmaOV3a+m50k4XNO3MHFBZWWuAHtfHQqeCigMQ2dK7Jmum9rBSZeyMuUOA6woACtN6BucxJJQTXWx8IHybIHHwQ++FhXWj4AXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUohrfstm+vknV9xmr83MngBjZEK+3aDvbSmwubFdjw=;
 b=e7h46HrbZcZANHIDdu2gGXsG+0zOY+YVKSCO5dWXko4ysoU2XZZPpqBzZdeVuWIxQtvqbUG14ZeUTQqdthwxX2RXpaZo7+9I8neL2EOYpwJgZoCJatCUDy+wGuwtN+O1Xbsg6nSTBIFKr+GedbJpQe4L8cqJVHSVahGX5QAstFg=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1279.namprd11.prod.outlook.com (2603:10b6:300:2a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 21:01:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.025; Thu, 19 Aug 2021
 21:01:07 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: RE: [PATCH net 1/1] ice: do not abort devlink info if PBA can't be
 found
Thread-Topic: [PATCH net 1/1] ice: do not abort devlink info if PBA can't be
 found
Thread-Index: AQHXlFiQ28+ySjTD00KL5o5CwjrgSqt7DI6AgABFT1A=
Date:   Thu, 19 Aug 2021 21:01:07 +0000
Message-ID: <CO1PR11MB50893B937F44EA4C455A666FD6C09@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210818174659.4140256-1-anthony.l.nguyen@intel.com>
 <20210819095241.502dac9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819095241.502dac9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cffb9ea8-e739-4eaa-dece-08d963547709
x-ms-traffictypediagnostic: MWHPR11MB1279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1279F660E91650DB3798965AD6C09@MWHPR11MB1279.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VMyuLBp46wEKJCH3fYXdD+ffe8GH80i7aVJ34au5lRV2chrBowl5Q8mSso2sTh7G6YB9GljEQFy46gYoHf9KgnipEGR5TOT7JJJqm82m8bX6SoE9Q4AGNxYnwA70ac6Owsk74gwoXB03D6ahaTlD24poNQolPwbq/gXeKD8LZharJ/OffJBHdTYGCBH3FpfgyUQbFRGb6dwZXA41ZZs5ydNkXzP4hUH7uUfrEpSws2Fv8uuadK9LH9eOifWK54kiKQ8Xi1XF6pZoYDMcqKc/RP26vNvct9SmWtdUHxjd05kJlQg75TK5zq+sGQaQW6uLK1yve9cq91QYrtMCZnKHOjoODq/y/sNNJ6Y5uiSWzpcrALwohyCAed+j2wK49EtHAAKC7UhWRF1NEnPSTQzjHyPoKdaicTa7SRraIHh+fRPvf46k2W4kRwcuAxIa9sYB52y16zfRKcL+Lx17rYfwE7SuxaZ4Sj2MoToEstbGPSgk1uRnIKlj9KgKwcsMSQ5oVVQPmaCDjb5Lh7cv1PHNx3awsEaU1p+eEJf1DAakkKRZps6Opv18uC+1KNCOBaXK0U/ml7CBKkRexeIABVvHX+UHNEmwbC8BYU/Hhk7VuccNfqBEvlluoelx3EWYpmJrYGStcGNB/5bjCMLKrbvqPVYQOh8Wdpyc0jwX0JirvCA4eRTQqK3kiUER0LEQvu/9H0qJiCV37abVc1vfNcLbqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(26005)(122000001)(478600001)(86362001)(55016002)(64756008)(2906002)(83380400001)(4326008)(38100700002)(9686003)(110136005)(107886003)(54906003)(8676002)(52536014)(66446008)(38070700005)(6506007)(53546011)(71200400001)(66476007)(5660300002)(66946007)(7696005)(76116006)(316002)(33656002)(8936002)(186003)(66556008)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z+Pi8XRAMUL4OVxxSoUSuhlg4JBo7m+QyKIyyEkTVzZUPdGa5vKjM6c/CiiG?=
 =?us-ascii?Q?L+1wejTm7J01+gX5eqqPlmL5luQqwFiUsmvzC42GTJJM/PSzcE/5xQ0i79p8?=
 =?us-ascii?Q?RP38hqTem2+iWzLmqB98jQUlO3aCRssqpCYAZyPPtAzLwZIfuVcNHRVwC5FI?=
 =?us-ascii?Q?0gfWBpzinLM0ij11JEuytqmCcBIg9mtF2+N3P0yva+WAtbdodIkwFK8HNj+g?=
 =?us-ascii?Q?A4iv2Vh6lky1KVkUOYdELxmpTgbh13ir9N3MqPtJckrxpoy6+A4Hmtwkvim1?=
 =?us-ascii?Q?aYgLQZVxIlpCQLCnNBZY7028juJZ/4ldBVELQYfBTbjpc48OxOisqBQvqywt?=
 =?us-ascii?Q?vcz5fcLRVTnyzVkYuRZZP3HlsJlYLN298TQY2Cq2Mgu5wNdaj7GUKd/INKwQ?=
 =?us-ascii?Q?ib8vtkdVdIFErzZ1vteXzZJFwWjiV2y4q9LQ24Rs3lo8atIBLnTvM8aqE0oB?=
 =?us-ascii?Q?Lp4v9Kj0YFMh+vOOq3G0kM2Nn9qYL2XNAGEOtuF9K6jpE9hAIEXgAwGFDssH?=
 =?us-ascii?Q?BmqPc3I8G0w65vLzs4N4Fm3im6gKwkyXfxhIahRlCUpHAvNWZ+xa/569s4VM?=
 =?us-ascii?Q?danakK4Cy4tw8+JQBAOHRu9vViIil+5qiTYtRzRaFL8ABczT4PnKXWSm0Npy?=
 =?us-ascii?Q?VrNqjMSEVGrhccTKmrPQ6ZPf3+f4A+LmmGlct2+2jqdiDVKbGBZuf/bm9FaU?=
 =?us-ascii?Q?XeMf0MHPQvtiu66KxwNf2xCM9scZcJC+UNoYwZVwCaLpMnASSbddZL3sGArf?=
 =?us-ascii?Q?ieFjPRmJereghkriDOkSnDI6qW5dmudSvaoW5yCrr5VKaAOa2bxwkWvv9pmR?=
 =?us-ascii?Q?ewHlH7OZ1fvHurus5JQaNCAvpyGefZLDeXYzBrTjNIAzMr1eGjrLrovN1qa3?=
 =?us-ascii?Q?nFVuEg9PnEegFpUjvqGYfXaGkqzcDlM0nafRZLFJ7OR39zC5Eyv110g7AawA?=
 =?us-ascii?Q?dpNyTmZZMuI9vO4+ONOzzL6vH5wAJUN/wlwRe4adLPGHHD0k++yoDJRgZe2L?=
 =?us-ascii?Q?TScnMkWx/KAs8OTYerupsSRS5Hc8JtjXWbv6+Tx92+qrgJoj1ACCIK6zR2Q2?=
 =?us-ascii?Q?PRFQ9MLcriiIJzaJAdqomIZpOmTcLO1Eagiu+qi6Vq2GWU71rMHeN7UrfdQv?=
 =?us-ascii?Q?SVlcloMlj5EnzGR9OGLIa0FfeHtyjKDHZpwn4DL1ZEmdMGdDcLUTKLeWcaXv?=
 =?us-ascii?Q?XOxwAfIJiD+knlqq/xb3PCRas3RKRTkevRqORn448NvjwjFjlZWh3x2wQ/Qx?=
 =?us-ascii?Q?Xb0LQMJcUKZrEkJ0w8bhFJxs/Qy7yCBy0regOEg4ph8n/+dNhKGnNRc9JKkP?=
 =?us-ascii?Q?/bk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cffb9ea8-e739-4eaa-dece-08d963547709
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 21:01:07.3591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fxyrM54kSqnBJwS1AQRbfdxk/T6F2npwhwJEIPxCjKsv6hnloqoRgxmoKE8yEsRiN6hRS/S3Z0FJ4QF5wdtgR6zPgxQIIBn6z+Buk5ZjK74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1279
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 19, 2021 9:53 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Keller, Jacob E <jacob.e.keller@intel.com>;
> netdev@vger.kernel.org; Brelinski, TonyX <tonyx.brelinski@intel.com>
> Subject: Re: [PATCH net 1/1] ice: do not abort devlink info if PBA can't =
be found
>=20
> On Wed, 18 Aug 2021 10:46:59 -0700 Tony Nguyen wrote:
> > From: Jacob Keller <jacob.e.keller@intel.com>
> >
> > The devlink dev info command reports version information about the
> > device and firmware running on the board. This includes the "board.id"
> > field which is supposed to represent an identifier of the board design.
> > The ice driver uses the Product Board Assembly identifier for this.
> >
> > In some cases, the PBA is not present in the NVM. If this happens,
> > devlink dev info will fail with an error. Instead, modify the
> > ice_info_pba function to just exit without filling in the context
> > buffer. This will cause the board.id field to be skipped. Log a dev_dbg
> > message in case someone wants to confirm why board.id is not showing up
> > for them.
> >
> > While at it, notice that none of the getter/fallback() functions report
> > an error anymore. Convert the interface to a void so that it is no
> > longer possible to add a version field that is fatal. This makes sense,
> > because we should not fail to report other versions just because one of
> > the version pieces could not be found.
> >
> > Finally, clean up the getter functions line wrapping so that none of
> > them take more than 80 columns, as is the usual style for networking
> > files.
> >
> > Fixes: e961b679fb0b ("ice: add board identifier info to devlink .info_g=
et")
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_devlink.c | 137 +++++++------------
> >  1 file changed, 53 insertions(+), 84 deletions(-)
>=20
> This is on the 'long' side, please just fix the bug and leave
> the refactoring for -next.

Makes sense. I think Tony already picked up the work to split this apart.

Thanks,
Jake
