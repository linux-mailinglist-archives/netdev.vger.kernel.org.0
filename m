Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D083998E8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFCERS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:17:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:62210 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhFCEQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 00:16:56 -0400
IronPort-SDR: DkcpFuEzzxihcTXTcK5hCFCHpek2M1QyOhWN/O18Ym1MxTijnkw8QnO1dNpkU932ElVQ2EMo+n
 QDNu8oUNXLYQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="203990118"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="203990118"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 21:15:12 -0700
IronPort-SDR: tTjodBf2m2WL543pYjL9EvoVUN0MmdaCH50jYAAa5bsuWmY17t4zV9hFLFnoGt+aLaF0ehUP3J
 ++1HM+Pzc5bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="417191603"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 02 Jun 2021 21:15:12 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 21:15:11 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 21:15:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 21:15:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 21:15:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlRt16d0jQ9dcrIkk9VNsZpeN8M9NAeM1zONfKzCsT0vkcQabOwQk7iaUF2N66BfFcU1k+DA73VNRhtr7gwexXMyfsC95fwlZPcYl4+vXPdKIBQQ0LIW2Ij3/HKQApTbulIPDNeRKtWoFFSsy2U40DuCoN9aQGSgv/VvsWGNs3MWQCFvXgC0ICKNuBlZaORkjSiNoV+fJhdjwqfXiD2kjbYEy00XQ1n4Jvzn1zIdPujCJYfzaxSGlFYITQHj/J7bcOj3KF72dWLwu71hnhzpJIJszYO1jfS4eZ9wq6GquariWd9F7AMNdKmAnJwtWyoKSvxtNtX1/90JngK4BwE+Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbIydgj9LQYyFo0rEwdxDUbtzTuonJfm5d/TAaZEbaQ=;
 b=i6Kiz91A3Yh6+JEXeFAbbRDxCGHo87UHqJDlM9cS44RQkL0FFVzgFVAPoUqee/PhKGQMh194lo3s41dLDzXqpTZ1o7ik9F2ojo7CcJd0lY8TBcQ8Rp/7P7aPlTDbw8+aDN83Dg/wy76Cke2rjeJqob2EqP8xE+73I/jPT4DSuc5CnujxKCiKeuh1orh0cFegjTAbX4Ovl65aZ1NrMtytUCaGXuHRyK3DDnIudtHanuQQ2OyxyeeekdI9eUKLP1sl27qfwaHaz2QkVB7HtgSmclIC+hu/xhBNLx8NY4HKJW1HidjGcgqN+s89MorK5BsNLl1t7hf9zCcMgUn3ZUs1MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbIydgj9LQYyFo0rEwdxDUbtzTuonJfm5d/TAaZEbaQ=;
 b=gswMfiSXTbJPJS7yFocCMXJe/lBGxQyJOW+/k4kfXBlkWXKG74iDSHOXbmpCybkwpQno2BbgPHnunNdPp+3RoSyno36YiDh1xAlv01dAAqqVFEsj0hXn674WO6//g+pyFGJqvVWX76ZDQTZ2zoRObYUa0+DH4J1CdeStjfunSUE=
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB3515.namprd11.prod.outlook.com (2603:10b6:5:6c::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.24; Thu, 3 Jun 2021 04:15:08 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::ac71:f532:33f7:a9d7]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::ac71:f532:33f7:a9d7%3]) with mapi id 15.20.4195.020; Thu, 3 Jun 2021
 04:15:08 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v2 intel-net 1/2] ice: add ndo_bpf
 callback for safe mode netdev ops
Thread-Topic: [Intel-wired-lan] [PATCH v2 intel-net 1/2] ice: add ndo_bpf
 callback for safe mode netdev ops
Thread-Index: AQHXTUQCKCum9GkL/UCCn2uSiqT6BKsBwztg
Date:   Thu, 3 Jun 2021 04:15:08 +0000
Message-ID: <DM6PR11MB3292CA01DB8F9EF78A704DFEF13C9@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20210520063500.62037-1-maciej.fijalkowski@intel.com>
 <20210520063500.62037-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20210520063500.62037-2-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [2401:4900:502a:ef07:d47b:7870:98e1:edeb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6fcf7b45-ab05-47ba-7631-08d926462c4f
x-ms-traffictypediagnostic: DM6PR11MB3515:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB35159082E5DC8DA82BAEE4D3F13C9@DM6PR11MB3515.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TsqdjDdyTwYMoDR3IM0kF1yW12AOJaPEXtFSpzMCcweHQwdt0o/YeR7LUzLuGl0kHRYgssLVVq5jt6Hhiv7VymVaYUSpm3QnFXI6SEliY5CZYZYDW2kvc9aT3vr7PQ17YxW8oZSQfqHjNuHX5Bl5CGwr3UcbK096r/syrBRtfgFib/wyXMj7U/KJvEYJWrwfK9bLKR8ONTL6GIo94s3okm1RzF31BATN039wepBkl+EQYNjDafc6ei5Xjf6jWFtP1FhOeeJLB/hr5cwmJZoOhtkWe530N4s5eBIfBnmq7Nbqowd/QScVn7KOOJ7H5a0PsYauNaR9Uwy7/qCqMreWVi8JT5IePFInq0YgHc7sm23H+B/xYceI1ml7M18XhzaNTbpRFSOm59k/jH1FcV0zj/0EIfkbfpu3hTYg+Tw1fTBv58qSi0JGm/mrZiDvb7DTfvW3mdX6N1Pe9RaUtajBFh9t9IOH3D7ma5sQnD957576pWiww1Y3gqQSveNtiCTP6x0gnJ98/S2s9YrANIMSZ427s4mte4munIXRhD8Oi5CU4RBYl/7QlL71+nf8EoPycRFxGeE/2BQl2hEmnwuqNxI+MxGrI7pSPPBrgl/YtP4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(86362001)(2906002)(186003)(83380400001)(4326008)(8936002)(33656002)(64756008)(66476007)(66556008)(76116006)(5660300002)(9686003)(66446008)(107886003)(7696005)(66946007)(122000001)(316002)(6506007)(110136005)(55016002)(54906003)(38100700002)(71200400001)(52536014)(53546011)(478600001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HOKLYvq1rIyjH1NG6dXfZ7Z0Pcx/+BxhKmyfHnha6TWzp8wyIc7JaIi7VjtT?=
 =?us-ascii?Q?FWUy/KFJyYjFn1Cx0x4mT1q6c8iEVMjZ81r+e5z7VivJ2ZTZKj9wpoDg1DG3?=
 =?us-ascii?Q?XoVU95a7pdvKjGDPvxhF51mNJohtbGrfx+aSskb5Zu3QRTTMyDuTDNEdEaVo?=
 =?us-ascii?Q?swR6axZMuOrn1Ocvcf/YohQxksUYd6mSRySECnvNLNY30d81jtIosU+jpDXX?=
 =?us-ascii?Q?CSI7Oz8nrm1ZNlvS0Ce7+HYbnT7HQwRw0JojYX1WYLc4R6uzuOOQJ4wWxD4X?=
 =?us-ascii?Q?OtrHVY7DnFpin4WvHRj//cpkkZ7IyS5IFZVjVvOI9tlIBZ24YZ/ZLINiBu8S?=
 =?us-ascii?Q?4+JBFj5xP/MadwhG1M7FsiPecRihQZ63jF9Y1U9QaFO+bt/86Srs9KUIaDCo?=
 =?us-ascii?Q?eovmBtC5lnKhBTm/W48ZMDwaGGKvRq69sE38NMWQljdPLZ8gIVqXO/g2Ds58?=
 =?us-ascii?Q?kKNTeRsBXln9sw1MjmsI2ejRkGz26Dwy6i65Xp4t1i5g+woFDcCsB+2Rlzdu?=
 =?us-ascii?Q?52Q7M4zeVVpN8q2NXJfvC7Pt5nZyVZXmf4F0w1gyi/3t1KZvw3h4ZftOhvoo?=
 =?us-ascii?Q?B4MNV1A8RI4Pu6WtXa/ztveNaWqsA3lHNGatlSQv0QxHaqvqDbjToa5MEuTF?=
 =?us-ascii?Q?SIv5gY1JqfIKIUiqCUtWzy+I7i+fGpVbfPLdZqATZ0ZdvgI6+NvoAkcWS/oY?=
 =?us-ascii?Q?LkFAvCFYzCmhZqeR2q5FyFPXivVANv5Y8HGkDBJ3K0HadkrRbqKXM76kprr+?=
 =?us-ascii?Q?KZ2Rd1sl3kPvVru6A96uIHUnaXIl3ps8VhgLYUtHJ4N6aUj7T1WplsM8YlYa?=
 =?us-ascii?Q?hb88XTuCxy2wFkKArTRPd+djc82y1YNtB0TrLY3GebPc4yAn6XGSPy3bNuXS?=
 =?us-ascii?Q?I2IgkUaEZiQhfX30X+70H9SgvJRuq+Mc+aMeQe1MLhmGJ5Ce0brw3smbmFpe?=
 =?us-ascii?Q?VM2P+boVefN2d3Y9jB+z1pNK+hrt+GmUHho7KwKAtKcYRI8pwInXRUWs8ey3?=
 =?us-ascii?Q?dCm4RktlLJ3n1tAnJU/cSaUvXu/GFUUTQ9NX3HKcZ1lwIOgo1lOZOZ62meGd?=
 =?us-ascii?Q?3ohUys2rysgTScIGZ8b2D4h/miKDgucfrSfDJ8i8Sfzku6R/C9LLG23sORSX?=
 =?us-ascii?Q?6toEVZQll4P45rNJwIBwhc4Tq09DgpRkI4ZPV7ecocjGki5Nq3Q+mi6KgxYY?=
 =?us-ascii?Q?LQ2odNs2zZhOHUUGQc61vR4R5KmosnajRfkBDN6XeIsjd53KP5Bzj6Z0mmJr?=
 =?us-ascii?Q?g9V51o+IhlgAbChDzY3xT67qaeoM5wpobPAlmtW/tt4Rsc9Gi6AU+YQHSPYT?=
 =?us-ascii?Q?gCC7k2kUGXvB+th5NprJXaysJwoVqZsREcYjyTS1ikuag7LgTdK7YxlmWYU1?=
 =?us-ascii?Q?SRyHfonjH88zHdfibZdRa2x1GEqX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fcf7b45-ab05-47ba-7631-08d926462c4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 04:15:08.1883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZV6c6jxe1WpNEzzx6Cx91H3rkkhM1Z0cdpvIdh6f2nU+zrxgDfzrLNDHvTb87vZ7BaoPmZlAo/xcFQNas35sdlLuqAJQTHOFSRxdqYVHB/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3515
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Thursday, May 20, 2021 12:05 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Jamal Hadi Salim <jhs@mojatatu.com>;
> bjorn@kernel.org; kuba@kernel.org; bpf@vger.kernel.org;
> davem@davemloft.net; Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 intel-net 1/2] ice: add ndo_bpf call=
back
> for safe mode netdev ops
>=20
> ice driver requires a programmable pipeline firmware package in order to
> have a support for advanced features. Otherwise, driver falls back to so
> called 'safe mode'. For that mode, ndo_bpf callback is not exposed and wh=
en
> user tries to load XDP program, the following happens:
>=20
> $ sudo ./xdp1 enp179s0f1
> libbpf: Kernel error message: Underlying driver does not support XDP in
> native mode link set xdp fd failed
>=20
> which is sort of confusing, as there is a native XDP support, but not in =
the
> current mode. Improve the user experience by providing the specific
> ndo_bpf callback dedicated for safe mode which will make use of extack to
> explicitly let the user know that the DDP package is missing and that's t=
he
> reason that the XDP can't be loaded onto interface currently.
>=20
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Fixes: efc2214b6047 ("ice: Add support for XDP")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
