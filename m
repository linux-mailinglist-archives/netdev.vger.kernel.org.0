Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3FA2879CA
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgJHQOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:14:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:19148 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgJHQOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 12:14:42 -0400
IronPort-SDR: rU7RkC4xof2EG9H+16MzopLnFxRQmcOlCOygZcq3eFwvkuMo39iBxvcLM4UdhihuPvRePSvdL6
 bj8ZbvZzwIiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="250057524"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="250057524"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 09:14:42 -0700
IronPort-SDR: oUgCTqKl77SUSPg/XciwHSeH5vxX2HDQiwhyfHNMzlXWNe2Sc5YFg7oEyb5fGYGf+llTXRmD2X
 1EsKm3vKzP4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="388843881"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 08 Oct 2020 09:14:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 09:14:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 09:14:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Oct 2020 09:14:40 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.57) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 8 Oct 2020 09:14:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i34XDh5OgjPkZ3Lcd/C8uy5q8mqRn2bf9IXLLutWSZuB/18r5NIKZ+BADaeGJ2MWL5u/Bu4TdD49XlzgO0RvWrXSn7+yTnhUkE3oUjEwjqG3uquv4v+0JkO+a8Kz4LYgBMlY9wDHmwH5YTMqC7JFhEetxe2rGdlnfG3du2uP0tA5c8gnKWRq0kEWTk6u+9cUCYMXeDUsWeB3kvk63OilkwzKDinXm1l4QqCOXUocwQ1MbYl4/FwGTQOAtBD4c0wFubKBLTQWn92ODC+CQdFLlWGKV0OOfis8nYgP9VrUUSu2QpgWOp0odbUeRM6NBaqook3EGEDgLFZVvWV7hxmscg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUHDesTl1SnG1fkY1eM/A5OnH6JCzLpstV6NNKa/YEU=;
 b=WTMQoa0nziw+TjDkN0aJiwIWjSrDuHF+lNbythCr5EVDb3vWhhms/nOmh6a2Fc7IxcftL6/0TPmOIFoHCScB3Sp2vIjaMyqtXl4Nyl80hBkBURp8QlzfwB6aXNA9SWGRTh+2fZAzzfbCIQ0JFjyPvSYW7wiKbScQwVEMifUe5EIeqC9Zh//7XOJtlYwRUh3w9vtxr19/JYYarGRHqNWMf8LWKC4DKfB8shedLT10uX/J3Oo2ae/q0JerDpwa4E93A+qeY7/pR/ifEBMMi7yYah1EnG11FK2dy8Pg7vdhmYYf4wsms/7chKL7j+qmLo/Nut2PJw1/B3QomEpT2linzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUHDesTl1SnG1fkY1eM/A5OnH6JCzLpstV6NNKa/YEU=;
 b=wmVzWPYczXOPCP/6FN5yQxw2flj/zlnXCBs3EJ2/AMUyFV4kbs9AgSGTQER9f4M0cbcfHablgoJ0BQtju13ujwKoz+A1OqiJKWKVVdPNz01Xe6UFxuM346q41FinmqLuS/T5zZEqX+0FcweNEUUu2AXqhA1aeKRLYc3G/4DUiMs=
Received: from SN6PR11MB3136.namprd11.prod.outlook.com (2603:10b6:805:da::30)
 by SA2PR11MB5082.namprd11.prod.outlook.com (2603:10b6:806:115::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 16:14:36 +0000
Received: from SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::a5be:6abd:8ad0:37db]) by SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::a5be:6abd:8ad0:37db%6]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 16:14:36 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Seow, Chen Yong" <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [PATCH v1 net-next] net: stmmac: Enable EEE HW LPI timer with
 auto SW/HW switching
Thread-Topic: [PATCH v1 net-next] net: stmmac: Enable EEE HW LPI timer with
 auto SW/HW switching
Thread-Index: AQHWnY2zojJcsTCzn0OHgYdrcYf+OKmN4HQA
Date:   Thu, 8 Oct 2020 16:14:36 +0000
Message-ID: <SN6PR11MB313657B3D8D271DA75351B1C880B0@SN6PR11MB3136.namprd11.prod.outlook.com>
References: <20201008161123.9317-1-weifeng.voon@intel.com>
In-Reply-To: <20201008161123.9317-1-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [161.142.255.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3b7d38b-9652-4c5a-89dc-08d86ba54027
x-ms-traffictypediagnostic: SA2PR11MB5082:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB508241176D2757AFEA0D0D61880B0@SA2PR11MB5082.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m2xAanlJeEpm6E2uMsodaXriog0F0hfYKK+f7KNBkNZ7eP2LK3JGOnO73OuaJOxlD+K1czf5/+BpT4utQCANgaybXPgkB+VDJgjMOEdAiUGe6/icxSwrjcDpxFvwU+mWX0EgUepvxv67BsvWglCNlxe6nITMBHKJhKy6T3XYjffH+Y/fbTVhuRkhBXBYKrR5wFuWwe37i12/ngtdA/6E/jJm4kKyZw9xtdxWmhYlGmr3vegGQmI/oQQeYftQQgEHz7WuoemOiV7eAKS+3jq50V1Oaia3HmLviHK3BGdzDSfvKfHbVU7L0igkH3HwOIEZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3136.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(52536014)(2906002)(66446008)(4326008)(7696005)(186003)(71200400001)(64756008)(66556008)(66946007)(5660300002)(316002)(9686003)(66476007)(4744005)(76116006)(26005)(54906003)(86362001)(55016002)(8936002)(33656002)(8676002)(478600001)(110136005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vrVVzT0/TVZX3f6DoDGnHFniUh78LJRMGvY6d+u4SfvSNr605vxo0URrTvD/Ktns9AXv831IdojIYULiDeWq6gpMOl2x9m7xzzl8beQDnaF3U7LhzC82PqqHxYRTKp+vHBy5fVTgxyAx+zvm5T59nz35Fl5TyTvtVcwZYSxYVw2twCXezP19tfL4DOjcNGtxt7pS7nsZUikTxjhsF1/UjXxn/xz8HXgxihJl0w4Ankv4/n0zKy6HuDIBXv4NdHIkFa3k7KgeroBDFpcNjFm62QfcFWVQqVDgi6f7wtkinu7P4+ad0KYVz89N1zfXInd43CVnDEjm7w4QyvJRbZl0Qh5kI+PeN1/GLcpPXtlyPce7VpBrIcdrFcFjUts4QuDBIMbNdeFZKPSNBKw4y5GXyZ5uyL+o8qsHMkB/bkdm7xnh8gsQdOBwfgdvT70dH3qSn53TN4xNBGxzgzArpvjQcw6i6+gxE0bDMPp9Gjrm2xnpt5JVtvkF7S8EUEmEZCuI8L9vKHAtvciGrYjvXiOAH9DAM8CAFNilzmvSIGUjAfkL/D1NypqeR8h1SZeADVkwCiJm6pfUS6zq6/2b6BqHOXDymmpWwTU65u7CfMidIFeJvvmWnA+NHhs39KFvbCE89J80Ni+Wwi7FdKBXhxROdw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3136.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b7d38b-9652-4c5a-89dc-08d86ba54027
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 16:14:36.1494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8hcR1ttP/WnfX7WcYadgj3jA3VMnvEphocIWmYI8dDP3hz+Mou++mzmWNfk7hMeoIdA3O8e5ClYADPi4kkexXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5082
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH v1 net-next] net: stmmac: Enable EEE HW LPI timer with au=
to
> SW/HW switching
>=20
> From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
>=20
> This patch enables the HW LPI Timer which controls the automatic entry an=
d
> exit of the LPI state.
> The EEE LPI timer value is configured through ethtool. The driver will au=
to
> select the LPI HW timer if the value in the HW timer supported range.
> Else, the driver will fallback to SW timer.
>=20
> Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.co=
m>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Please help to review and comment. Thanks.=20
Weifeng

