Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA29734F547
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhCaAGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:06:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:11221 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232655AbhCaAFt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:05:49 -0400
IronPort-SDR: 1rnSrwGARC/Y0YU+syze+AVEvgRYm6CYGrDMjEdg+c9MBfkk/qXtUaOC3Yf+DhyTLtTZbaTO3m
 PgokgXyKYYBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="191910894"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="191910894"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:05:48 -0700
IronPort-SDR: eLT2m5iD+FisZxS6ekb72cCYalKSnxS796Cu+JU1/D8a2XDz/VFLi8y7ZrGVVFJFpugmK6gz+A
 hT/gKA9cyY3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="455241241"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 30 Mar 2021 17:05:48 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 30 Mar 2021 17:05:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 30 Mar 2021 17:05:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 30 Mar 2021 17:05:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKMWFjS0PAzVfSGCVvfaBJPgskJcptpeHvIX+0vpj4CG7tA9f9AbyEk+IXqI49uv/e19qmv1SoyG8t4Yul+Qq7dSnjoTUJfeeBQW+Ldl1FU1u302OHhK3dcag7O7UOGKnsE9m1Cc36z4AF+1BRAnkdCr2TJPanXIcwQPEVeDtzyPmualXOV9e/ODw+3mV2KNbnAeFtByiZfoBv8ajwhtLed3dYbcsFO8oxJaSoU/lsiF32hSxq2wLL9zlkkIg1l+oz32LetHH7ZHdPeIEDn3iYhFs8L4K5TCFsrVMIHUmdUq2LSK8MdQtmeDfTpy0dpx4ocwcTeq9mC0Nwb5wWmvAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2/aLw7EAYP1qIgnIQslB3X/p5sGMf631NFOKfgdw8k=;
 b=IQOJqMNgAVDzYhTqHJrb2/wOPyP/SpUnXY5Fn5W9k6tb3ahfVC1b8oG4HOQqTurDGz2WxI7bMKo4wRhQICT2kca1HtXzcaQjQExZ/VLpO/WA0uYJ5fYWPL5NzB5O0kjW6gEgc5jmRMB2q62RTABUI/SZrJti8DOK1GTcvLlwrUOt4Q3wMyo734+UbcULXoTOUavkHhEtGVSeB4RPFgUKipZK97+OeZx9gJVvTYO0eFNAE7sZEJkQG5C9fnkta5d68zsIksOh5Y86lJtDswSk6r9LBLDMTnSaT8Xgs5qN+h40wowJ6WPn/f974Fw3iCwnu9XtZXPJdlW38rJ6ktomUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2/aLw7EAYP1qIgnIQslB3X/p5sGMf631NFOKfgdw8k=;
 b=QNPmrBCPakX2sIsxyGYt3hB++QqgLsXl2kHRGSI/U4yHEr1rM3q5NfWbWF3cb7JOFL6TZ2ML3QRn00CZxAs7SBhpqdwYnea9KZAYIgIcRJFEkExo6LxV/AfcIqMPGNK/BznPTAg30G/fGfPuHeSOsjCBsYfhrrv281ma74pWVu4=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by BYAPR11MB3432.namprd11.prod.outlook.com (2603:10b6:a03:8a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 31 Mar
 2021 00:05:46 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608%5]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 00:05:46 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Subject: RE: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init
 methods
Thread-Topic: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init
 methods
Thread-Index: AdclwZex17722I4GTTKsQn4BXAqDDQ==
Date:   Wed, 31 Mar 2021 00:05:45 +0000
Message-ID: <BYAPR11MB2870AD12F9EB897A6B81DC50AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [218.111.199.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41e7340d-b688-4885-79fd-08d8f3d8bbb7
x-ms-traffictypediagnostic: BYAPR11MB3432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB343210AAAA079DEF9E1FDCCBAB7C9@BYAPR11MB3432.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1q4sXs9mdpbH1pTMjAFdkCl4s7jVUgr5iZGDz/nqSJO0Srmql/VDcJVUIFPGjcNqdGYVpnT2GG6yM1wAlc3ZznUzYutTGbBoSzdR6RvfsQydjIRhhbT5n3RIxHmb6YaLR4R7cVzs1oD9dCiJu6dXTJEZPXDONXbVeVH8IO8KJ57jPp+BaRVSJE/j08l/gue87Aa+H3zLmPzHt5Zemmw8XgvPqEKY/nXc9epSJeND1YqI/Y2WeCHQ6YmdkRu3DodZrghtky/zCulD0izHGBjeM/5SooMpGnxA+t61jwHFkj7/2n5d9ZMAzTgfLPmRxpiX7/y0yzByMHNjQyAIGLLQxhn2XMpSRIUnuNHzoatiX8FIje17Pisg+SFP8XwRykMKCMbk//tgXAj0WIVZHCfGEFbgGcYiv5AZgSA+U0KvzH2f5UPzSGatd/6M8SbLEbL4agOHO/uF388uDOJFOdmPlU+XQH6bgwyexY/iJgCiY2azNBUWIup84X+YTBmNG/02v0BXoKeU6s/HvlKHWvfkexMPZ5qZ8A2JOQI4TpqQ3HnEh5YubJK4FSRP/10h/BGQgbTat4dHsezEk1DQS5Z+KlPfYkpu95OIdH6ks1umWn2m+sKqcUJSYY/CRuqBpTemYAW7psVuMwFHz2+QDbbp6J+3MmVGVv15QfDkxXv8DNs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(346002)(366004)(39860400002)(83380400001)(9686003)(55016002)(7696005)(5660300002)(8676002)(66556008)(8936002)(107886003)(478600001)(6506007)(186003)(66476007)(86362001)(64756008)(66946007)(316002)(66446008)(76116006)(6916009)(38100700001)(54906003)(2906002)(33656002)(71200400001)(4326008)(52536014)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?SmHD2856CiTY8ZxysU4qnRg7VadtuerbBce8ytN5Cs6oobMMVRF1KPNU9V?=
 =?iso-8859-1?Q?Wjiw7CzOEsSqXX8m1jQOJdvV0ZyXB8NUPyZgZkwOmI50DMDQ8m0xDrzaKG?=
 =?iso-8859-1?Q?phKsQj9igVQi41we0By9SoGw7nViXSopaYvl7BbT6ykCbXy85/UA9Wsmnu?=
 =?iso-8859-1?Q?myHmqTii49NRv2aT04//V64LVNlEVXN7ruDYUSGKOJeNZY/afMFjdFPOx2?=
 =?iso-8859-1?Q?p9cpsub/bqSr7VgL5DOMswsRx9p7+WL41/lk2r14vf+/gkOXhdA6NygGsP?=
 =?iso-8859-1?Q?JzqXQRW7/tQtXBYjqhCJJ823/fdgbBCofMa788mNLimyh2cl+lKZGPXpx1?=
 =?iso-8859-1?Q?ItMeQ8indch672d92xOoEVwflnFbksidOPDpUrXQEwxYJDlQUCkP9X/g4F?=
 =?iso-8859-1?Q?zdulrI2LoD/DSvTTrkQNHPFEnccKQJ0QiffSAa9kviu52lf8mUSx5h42R1?=
 =?iso-8859-1?Q?wKxO6pJFOlIscqWSouhfml0I++kHzQFIwHtoolXwWu4oqzHzd7IPXFBZVV?=
 =?iso-8859-1?Q?zwb8iVOQY6pIMJHREa9CNlzK+qorARtlF722Fn7K84XuGIUc3C5jL34sFe?=
 =?iso-8859-1?Q?bb0CFkndS9OAllo7m0NKJhO/PGK2D/Z28s6TvxhCYkU17LnGbUsQrCPnMI?=
 =?iso-8859-1?Q?gfaTTaKUD2bJLiGe2OfwgJL3n9NVYmKw6qa+V/DXV2NwmVtFuHjo3fA3Lq?=
 =?iso-8859-1?Q?tUGCBGpeKKh6t/QL+QEznQbrL9aBqZsGlKZpfbaCoDi6dyX30twajhZ8sB?=
 =?iso-8859-1?Q?EWRAoX5g05dMhWsdEUD0BA5LABHVmCQGjQ6I8VQEyI607fBlJ8pDuw2oiy?=
 =?iso-8859-1?Q?KouQX+Csh2FlTqOcYxw8fWMoyOmrt7izH6zTXPA7fwWLkOuO592OU7TLlr?=
 =?iso-8859-1?Q?bNR476Dx90WbGHYnd2lZH9hptN26YiWQkmf9YCOQKhjsKliAy4KXxwlYL7?=
 =?iso-8859-1?Q?hkd7NJm7Z9IjpTVbRhvv1qgqZ0sAJ60akO6q5oGa4VKlCmTAvQ+F6vcnuC?=
 =?iso-8859-1?Q?Zd83SUlFbYG/aoa5ZCoF+BFQdfpvqhRgWP+xazdwnISdh+eRFPmjb2dtbO?=
 =?iso-8859-1?Q?EWoQb5Y/Ovj9+2u0olhxQTxIhpFwvB8Q320WU4q/Mhf+9mDl4S/NAQB6GC?=
 =?iso-8859-1?Q?XBjJsbEiPokIlg6e8RnnHs31KN7SVACBTN5uO4Ly17aa7Nl/PtWduNY7LC?=
 =?iso-8859-1?Q?0ShrYfglneDwUb0D2LGtjUtoyIa4W4PwbqlwtKmg+eF//erqPCam9LkQUN?=
 =?iso-8859-1?Q?arJsW5Kq2WC6aS3nJPfwayEDv4vf2IXrJILN2frFiu2d+4jCmXsThbMQ8S?=
 =?iso-8859-1?Q?CZAAkFI81D9TzSiUgZ6isf/UZ2Db9wDn3AKq5LHPXItTgVnlgXcrSc/lyK?=
 =?iso-8859-1?Q?5DADS/FGUB?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e7340d-b688-4885-79fd-08d8f3d8bbb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 00:05:45.9655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+giRxYD1rDWpRKCXR2e4wir57CwH7DVKNlgug5Ytc2bSCdT4t9cg48n6XyO1Zx2mOQ5ldjOrsmqIV9dNl8YHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3432
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch introduced the following massive warnings printouts on a
Intel x86 Alderlake platform with STMMAC MAC and Marvell 88E2110 PHY.

[=A0 149.674232] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 159.930310] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 170.186205] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 180.434311] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 190.682309] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 200.690176] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 210.938310] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 221.186311] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 231.442311] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 241.690186] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 251.698288] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 261.946311] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 272.194181] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 282.442311] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 292.690310] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 302.938313] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 313.186255] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 323.442329] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 333.698309] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 343.946310] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 354.202166] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 364.450190] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2
[=A0 374.706314] unregister_netdevice: waiting for sit0 to become free. Usa=
ge count =3D 2

Is this an expected behavior?

Thanks,
VK
