Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9381D270B58
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgISHEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:04:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:56512 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgISHEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:04:42 -0400
IronPort-SDR: NMoAJwyPzIugnC2NRjSaiRmAiig3C3NSjLndzpb9NQS6flRE+57msMVXlWxEQx7BFb7i4vkatp
 F/M7w4uRwKXA==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="160154766"
X-IronPort-AV: E=Sophos;i="5.77,277,1596524400"; 
   d="scan'208";a="160154766"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2020 00:04:36 -0700
IronPort-SDR: od4GCUH/9EHhnECtsYmv+2P4dAJJZIy9UozmHSIj3J4cBURaffzQsNlPktGUme5Bqv7acMy6I2
 Db9xGdv5Y5iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,277,1596524400"; 
   d="scan'208";a="484529876"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 19 Sep 2020 00:04:36 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 19 Sep 2020 00:04:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 19 Sep 2020 00:04:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sat, 19 Sep 2020 00:04:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cbx/nBPr+XkDlnJWZSzSBVvaBbxeP17XvbCwwgZVcgc7jT31pcOtgcE6ILnpHrmsfXYLUoCXEeBUxHRE1lAjTv9bgjdBatvWWlABijxz0/YzQ3/V7bZx8Rc1la/jKlM7QLWOT8dVb//ID9SCblGlgsKB6BXB4er0FsRj3tENAxfkUUstT8twPk5ATLS+243/HEVlXwOtaDTbrVeeQqKdd7ptQ5YJMZq9NkW6FeUhAmu+B4JLGz98/z5T6etBsJJAYdqOWxaFtTBjmtDo3c9CwjK9t7j2iOfgi33MJFegx9USk7aNabR9nOSChEYRJlNM+w1qGI4a5QJlsSoyWzeE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6E3240t53XqIF4gJ3qjwWs8PBM4I7/XRyTX58n+cNU=;
 b=lJmS6H2Ri+YH++kCbrWlG/7dXlmyai7C+68ho2TdMRmO5PTE7IJCjcPv8bGaAdWWYYCK5vKw0VjRB9mR5bM6ltNSQqxPzx1RZElm+YKKwI86K6YbLklcbqWBj8EkmlnOsbvhgpAImRP2Hll0nmg01a5q/DQRV23rpaRruvKJkVvAe5DqZCxNcJEihePt1iUskC9bxibd52Oa4sEPM0mr/qE07gJ3ICBnF9brNeoa2a/kWsP4EAix1Ozz8gsauHAVolQVyFPKVYaSHXw0DQ3lXzZBBELUOVk3wTEtlySY5VD8PXRsQzDrD/AG8jy0O+/I1DrqjgJR/WLSkO1Tsavf1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6E3240t53XqIF4gJ3qjwWs8PBM4I7/XRyTX58n+cNU=;
 b=b9pFUbyF4rHTBMok91Srgv3RYTGJkxZPslbhPvF8izx5d1rpqeELKPWERKF0Pl2cuQpkDyJTB+pdibOuhLhXsA1Yn+7KxPHg8yTgvTw3jz8VjsycVkO4SXnb29dpTgE4OpL9Sc1CHDoK4t7tyaHcLI7xz/luY2EN/yUB0XEqmJE=
Received: from SN6PR11MB2896.namprd11.prod.outlook.com (2603:10b6:805:d9::20)
 by SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Sat, 19 Sep
 2020 07:04:34 +0000
Received: from SN6PR11MB2896.namprd11.prod.outlook.com
 ([fe80::c9a8:3bb2:d3cd:a5fc]) by SN6PR11MB2896.namprd11.prod.outlook.com
 ([fe80::c9a8:3bb2:d3cd:a5fc%7]) with mapi id 15.20.3348.019; Sat, 19 Sep 2020
 07:04:34 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v1 5/7] i40e: convert to new
 udp_tunnel infrastructure
Thread-Topic: [Intel-wired-lan] [PATCH net-next v1 5/7] i40e: convert to new
 udp_tunnel infrastructure
Thread-Index: AQHWX8dPxpv52Vn3VEuICFC/0WaU/6lv5eVw
Date:   Sat, 19 Sep 2020 07:04:34 +0000
Message-ID: <SN6PR11MB28969A31367ECAB8B0452FACBC3C0@SN6PR11MB2896.namprd11.prod.outlook.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
 <20200722012716.2814777-6-kuba@kernel.org>
In-Reply-To: <20200722012716.2814777-6-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.208.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55da681b-25ee-4018-19aa-08d85c6a43d1
x-ms-traffictypediagnostic: SN6PR11MB3504:
x-microsoft-antispam-prvs: <SN6PR11MB35046AE9DAC1EDCB7C305E18BC3C0@SN6PR11MB3504.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kaRO4Wgc63eXk2B9qPcwlezXsZe+4FtBzD+gKhwI9Eny0BC0/mFfWeUxs1OkLiFIQ1hWT/E04Ytn6obieBTpaYIbSujfudWAyhAGrSlkjpsEqX8LdETwYdb2Vhu9UxcGkELTyRmGsKWFR5ojc4ODYnfZ7ANXjQpUXKhQkuZ3CT6LJSyixPXlun2gVrg+th49HR2PZCCzCxOPhrPTyNpnBFtdvxWMGZeXIqBoAsj7ECMuvF4VTiu/l5iH143T9Qn1vDV0Tx1mGXHs5w4spJSON+aiU1GWeKtGyxGwmLo6+B62V2CnpHGp7QD7pV9Ixy7VPhZxXolNa7I/hoLsQReMWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(52536014)(71200400001)(86362001)(316002)(66556008)(54906003)(33656002)(66446008)(66476007)(6506007)(53546011)(26005)(478600001)(186003)(4326008)(55016002)(76116006)(9686003)(2906002)(8676002)(110136005)(66946007)(7696005)(83380400001)(8936002)(4744005)(5660300002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sbOMVRD0sO303BqZ9PHimgA6BKDepdVTXk5/fhs6sk+1yDr8OVRVtupYlotjlE7uLZd+mBVbUhlejGkSNeE7rembse36MS9Qw+JYUoF45211ac1dQUr0ld2fMU/1sko6H/tYyiZ3+ngy0jH4gVQuk6o77Pay4tRr408hIlvN3x6KlThN42dFP9TbownACq9t7ys2UHXa4Njrk4eqx/kO6UIxdGhsUOsen/0M20F2sFjAQrOPV2NEdKR1toX2M6kafuSwymvLeUUIc+xqdv1K3M/FWZL7ee2pLxe9EyISa2aOhTtQlBWNG8Fe0nUbsi2eaC2G2J1vrLQDKkP+sSYSLnPBHqOarUFw8mnq+qqQ8ngiRnysiaPQfKyluAPh0lO/AWuzrxQaiW0S37J/8XLp9DuxR9RnykWpyOcsmxVCYqKdiXognYAo+sUpd3LVg5KdKgHmaY5KN78zevPOnxeQulhyTlTfcACixdjqkEGPzBg5hzgDxmPzbkjhFZF2Jpq8DAJLrd7CseR4J9CE5X6nCBhbvIWJBEjF3K46rNSuD+Z14ZMyooL5zsyVxF7xl7baY6SO7T/C2u984pTe4j+auMXshp8IuM7P+3ZGVOofISyQRj9b96womgjL/c01m7hIBH0yNKSY+KYK4tP2+3XOEQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55da681b-25ee-4018-19aa-08d85c6a43d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 07:04:34.5252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+06LufilpRXyj8W4Ll453vr7wcOOttA4eU6KS8PyNnUH7GJLxJXsdJh0clhdLcjSpm4SZGBWV2Hat5nKhrrlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3504
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of J=
akub
> Kicinski
> Sent: Tuesday, July 21, 2020 6:27 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Jakub Kicin=
ski
> <kuba@kernel.org>
> Subject: [Intel-wired-lan] [PATCH net-next v1 5/7] i40e: convert to new
> udp_tunnel infrastructure
>=20
> Make use of the "shared port table" to convert i40e to the new
> infra.
>=20
> i40e did not have any reference tracking, locking is also dodgy
> because rtnl gets released while talking to FW, so port may get
> removed from the table while it's getting added etc.
>=20
> On the good side i40e does not seem to be using the ports for
> TX so we can remove the table from the driver state completely.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/intel/i40e/i40e.h      |   6 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 264 ++++----------------
>  2 files changed, 51 insertions(+), 219 deletions(-)
>=20
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
