Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3032191CC
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGHUq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:46:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:18722 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgGHUq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 16:46:56 -0400
IronPort-SDR: VXPwOe3iBaZ14K1HXp1/Fqpt2rgqbbXZJqsNmQ8ExQfBHTX2G2PmaNLGB5djWnnJHMuqGFTYkO
 TdvGRPFgZHRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="212818962"
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="212818962"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 13:46:56 -0700
IronPort-SDR: 8CPknOuesFw7csX1wr3gVnPlMxlpJsgLMlg/dF3iUCPyXw+OYQ1S2Quq8IUS2g+nyknkm38Fa5
 UwORfAeyQQYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="268564441"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jul 2020 13:46:55 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:46:55 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx156.amr.corp.intel.com (10.18.116.74) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:46:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 13:46:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWm6jxW1UJCQ8q2Ev7voALnyZX56WgBzodiAtVQ32Aew2RthI2RsZXLFerIV/ZVsaQiG4gkFZKJ/wlJeOj3aHNeZhKxR704p2+NqS/yeJLUzN2LCSKKBsmRxrtzk7kcxHHkePu2lqW0yBz/FrkSu0+iFQqTWhAVLN4qMnI5zG2oC1hBte6DxqHuRwLkVRnfbv56xH9ZVLcUmuUnMCBKnsPum6i9xZKnz09/ZidKKiYiYheT34eIbC2Q/EP6/sE43dg8J7kiM3I4Vi0kRLN8rsgytY51HDiHAdRVk9aZpacHHNXPHkcG52zwarVOoh/YLUvSvZCJsHibm0qNcLxPXew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfRffqrgg3R+SdDGE73dOS9Vy9pWGRZRGDSB+IxWToA=;
 b=dXBUXlrY0VYqKO+f0+x4KHlHgzQbDxWq/gU/oBQecgCW/0ryxYYU++SAkafY4H+k+QF3yy0gcyWmHMv2idaXDVdCZ17TDTY/8IJyk8zHvLXtF6sFGad0F+NUpbHlEH55wErHGtEpi1vc4dmLVc3MuLSmsoVuD+jStiL49dAizC2MMFxsu0X3OnbUeSwLL/Dd/Ey0hO7cQQaIiGvjVZdtbTRjsiK1SE/TDO/pn+Au7x6OFS8ZRg28szFLHdAGhWLUpPgwJ7f1zzVLa6qwJXyUuYohm36IEjyjXt75nWvPSg99aRTKyYkUKttwItai8M7BsuYjE9KHdLmyWKmVhucFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfRffqrgg3R+SdDGE73dOS9Vy9pWGRZRGDSB+IxWToA=;
 b=ytzK04cW88huSOm/ssR3Pcaitkj6A9ZXCb8N0+RI5/1bp4SDlJ3itTDOEntpL8nZs02RJqvuWG527F/yXM4m35PXZGFvyNGwngM1aIIOeXdj26dzZmsiogKaXujfKx1LZXwIWW2ZWtuDCju1RJOoYQQ24nOxTdc1OCOO7r9T1y0=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN6PR11MB0052.namprd11.prod.outlook.com
 (2603:10b6:405:69::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Wed, 8 Jul
 2020 20:46:53 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3%9]) with mapi id 15.20.3174.022; Wed, 8 Jul 2020
 20:46:53 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH][net-next] i40e: prefetch struct page of
 rx buffer conditionally
Thread-Topic: [Intel-wired-lan] [PATCH][net-next] i40e: prefetch struct page
 of rx buffer conditionally
Thread-Index: AQHWUDtqYh5fYn8bckeL76QBwyrVv6j+MUpQ
Date:   Wed, 8 Jul 2020 20:46:53 +0000
Message-ID: <BN6PR1101MB214501BA0231A0EF89CD66C78C670@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <1593671885-30822-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1593671885-30822-1-git-send-email-lirongqing@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5150682f-9350-4037-54ea-08d823800c28
x-ms-traffictypediagnostic: BN6PR11MB0052:
x-microsoft-antispam-prvs: <BN6PR11MB0052B51B7D695EAD1E59B0528C670@BN6PR11MB0052.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZHUfxvwpLhQ1+4K027vghJbebAuCTOP4o8GjAYl+pn0tyZCkw5Zj+DnIgmg6JdRhIHGWJ5bnlzjx9Qds3fdZsVpUQHe8lGW03FpdlHeJVN5K0thVYdXYU/aix9rQLfdY6UaSQ/uvDNeZAsFviXNIn0/cHMA2qU/Ae0QdI5DZstyCWGudokmCBUZD3Xq2YTR9Dx7OzWIlUgjE2x7AjR59qolbVhWNil7sp0QaSL4/+410HvfCPLcrea94TRYcNCJ1BnQanNI7Iz4KLUovfj2NoYZrWn1297ezOA0tB1u2NEkpGQY2ktVXdLnL9SDtQVrx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(86362001)(53546011)(186003)(7696005)(6506007)(71200400001)(83380400001)(66476007)(66556008)(66946007)(76116006)(64756008)(66446008)(8676002)(4744005)(478600001)(33656002)(5660300002)(26005)(9686003)(55016002)(2906002)(8936002)(52536014)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yGk9SBha75eWkES9+0WXe0YVmybFvGdSGx7UkPYO9otw+I5G5ccthVcK/chUvxBQszk3A/JInOTxGDt5XB/GZ78+Lep8xffKYHLtuWxtakHsmVS+lGUKT17Jx+qD9znksTHzke0THWxKerBKvnlMJom4gh16mxnyMBHJk34Tao62JUvxBfhd2M+uV9xIpnFflj7qwPQHEksNQRy8Spxf4dX4wh9LbV0C2CTQhyVTBwmqOGJlDeHd4fDOlnzuRZYvK0IBUEUWkQzUqzwSCMCkZuxSqG6J7j2fBjdflRXa7ft8ZtTpuYtH4TICF34KqgU6upFTME2AC5QlB/DneEtjtzX5Nosptpq5uPvj/ZPcUNvAPrBZBrYh4/jrBuoHKwtkGlJSsloao3cpGKWH6agjJ8jUBjjGZ99WM2xdQ+dA+3TqHff2kn0iktgQMx9XLQCvbPCqT8ojUZcRNOfTDgR79gKepM1hUFNoARcd7DMtZbk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5150682f-9350-4037-54ea-08d823800c28
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 20:46:53.8031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lrSuuUhXvSzSWoTQANG/+YLKsveOUa4LKbD6JqPy2ReGzTDsm4wi4PIDq9VORc5jACQH4xAhq9KcNUjHTG8BLsHy2hMTomjrCixIjEM4weY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0052
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of L=
i
> RongQing
> Sent: Wednesday, July 1, 2020 11:38 PM
> To: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH][net-next] i40e: prefetch struct page o=
f rx
> buffer conditionally
>=20
> page_address() accesses struct page only when WANT_PAGE_VIRTUAL or
> HASHED_PAGE_VIRTUAL is defined, otherwise it returns address based on
> offset, so we prefetch it conditionally
>=20
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 ++
>  1 file changed, 2 insertions(+)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


