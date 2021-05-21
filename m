Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0791238C5EA
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 13:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhEULqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 07:46:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:16246 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhEULqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 07:46:21 -0400
IronPort-SDR: YcOzF6HcmOx6fUWZPHP6vdZZUI8RpgN9RH8Fb/hKiDbqGtX96/+CI2Myn4y2KqbUS7PP7K5pEk
 FO++skCZrvTA==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="188863448"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="188863448"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 04:44:57 -0700
IronPort-SDR: ps8Kw/qpN1zwaUj95t7q0gS4W9Ftr4nvtJBsJn6ZOezM/wLyeOIis+/fV7u3oJ9Aw5wp+koA9C
 DpdprSwnTwDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="544044382"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga001.fm.intel.com with ESMTP; 21 May 2021 04:44:57 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 21 May 2021 04:44:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 21 May 2021 04:44:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 21 May 2021 04:44:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwyLK3zZsMS9BwxOSFv8PYYO3ieLHpAUhM8c0Wgb9JceDRXFLiC8yjHfzd5WIMR0zZAMITzZqkP5fhO0GjpxZVVBYjcinBEy0LUtXTSvLkxAbC5cH2opjovOucL+27j89TKgeWhxhNMePMlyNRIaGE6vUGOn64CZ3Qm5zE4g/O7SepAlc9u3H2sS9RdtIawL58EBQeQPjqRd4SX5r+9Z+DLXX95hDhCnzzqHmATyc89MtGaeyhwqVsldCaOnX7KsEsHoHsD9LAtlxY6ftvpEuqqeo++LsNyMlx9qSJlxLeI09NzxiQFzJLwZeWin68x18JFJSNaKX6ww71ERekKfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7Q7zUNxTzej5xsNNerH04DeIvCW0wdrcKq1GD/VxOo=;
 b=Xpz86NxByA2npu+l2yxxaMHVCaiBqPWOArpNlRkClE8d3RrUlgrio4KHAeSYzyloX+U/fiwuV4jJPNzwEnbtGUVZRypln/HH7CzGzqi0irLNpTp3H+btp+9Lx+0MyiGIvyewuQN18A5SnrIrUdqkk3Ck2bh2ISuUQ98jNK8kyoikE/pZ6BFkQgCnqIPhuI/AhBuMXqOim0A4B7x+A/3cVDKcNJnSkwd8UfmIL+9O9Y3BoPj2J0krFS+mZE/ih53M6jgfhP/CS/Zqocx+rZPW/cL3wi76OLdf0wgB1UURSoqJYHWgWugqjkVvgY2eD7tVVgIEq+iLX0WVee4uRyb2tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7Q7zUNxTzej5xsNNerH04DeIvCW0wdrcKq1GD/VxOo=;
 b=Z/iGq/FW41Y7LH4dIuRps2EO1a+j5dYcFhlkNeWJUfwP0N54ouheZZJpmRkTuiPMFXMrfqShnCcMEtVlhpiZIakjEkeUL+woszDH9lFYkNGBEZd0ob2CvYDUv0xKF1XkXu2B+bm0inPtd6peAzmadYyL6Apy4mSi+/LLIe8Dglk=
Received: from SA2PR11MB4940.namprd11.prod.outlook.com (2603:10b6:806:fa::13)
 by SA2PR11MB5067.namprd11.prod.outlook.com (2603:10b6:806:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 11:44:54 +0000
Received: from SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::2852:d6e4:3f0b:b949]) by SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::2852:d6e4:3f0b:b949%6]) with mapi id 15.20.4129.035; Fri, 21 May 2021
 11:44:54 +0000
From:   "Jambekar, Vishakha" <vishakha.jambekar@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net v2 4/6] igb: add correct
 exception tracing for XDP
Thread-Topic: [Intel-wired-lan] [PATCH intel-net v2 4/6] igb: add correct
 exception tracing for XDP
Thread-Index: AQHXRYB12zfFzbB60Uq+ZDdev5yWp6rt4e5w
Date:   Fri, 21 May 2021 11:44:54 +0000
Message-ID: <SA2PR11MB4940856C4DD29124DACB6654FF299@SA2PR11MB4940.namprd11.prod.outlook.com>
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
 <20210510093854.31652-5-magnus.karlsson@gmail.com>
In-Reply-To: <20210510093854.31652-5-magnus.karlsson@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [103.241.226.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b48ad192-cfe0-4b99-f4e3-08d91c4dd9d6
x-ms-traffictypediagnostic: SA2PR11MB5067:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5067A2559C02C09316647B25FF299@SA2PR11MB5067.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X5V9J9skA+MbqA4PbXdN1G3P9M1Jl6fHifRrrMumk87T3vxBWJU+1bX2PHpwrnclUF/X+5fHA+QUnZGvp9VZzeFGwc6OYlvPhcQI480J3raNWt65FtFB5i9Gz26zgwDDYtrk/LbVEr0baCfm0iXHcp6zNw1Y//m31wQr8oKbIVg6D30tBWO+lqpbO/uzLOfi2A0lEUc61LRyN+OepNQeLw0y2K/EVIEWjsrXdrwcurDkGsIIMcZpJWzzuzpV4awW/IgBkttehe4KhocJxYa0zk3IGK+vjpCGkHiDwyB2EFULbaf167mb+VoRKqAIkPKfMucxHlpi1DD4keBoCNEfqhbmfuBBO8TGZWS8MfW1h+xF3rn3J6MGm7371uO/YXVPjoIc6tBmIoWBw/nXOhmEmCAca83kiibcoDKCs4I26igTN0t7k1ztzEo28o6fo/TOQCql01Vw3VljqCx811reoOjOcsVEExnU+2IwkmqhIqlBVifpJn6NufHQSE8qPEr4iYv2T350vG4kpMbaM9WKDseDNHFYJJtEF4ihIuOIyOTqdqF/vWYYTDWIJ8ym864seW48N3iXUj9AJvObTBAKiBufra8s82Rjqx3cxCAg+RY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4940.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39860400002)(366004)(4326008)(55016002)(9686003)(478600001)(66476007)(52536014)(5660300002)(33656002)(4744005)(76116006)(66446008)(66946007)(186003)(6506007)(7696005)(316002)(8936002)(66556008)(122000001)(38100700002)(86362001)(71200400001)(83380400001)(6636002)(2906002)(54906003)(110136005)(26005)(8676002)(53546011)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZKDXjzU2IrwVZcnLvxb5buw2G59mV88XdcoVs46h8EaeK0vlymbZkDssmwi5?=
 =?us-ascii?Q?7PXH9Oa1YJnjioTtbqng8cg/4HggKWGxEaGUnbi9UI3Jtk3s6rAFhRVbpWzt?=
 =?us-ascii?Q?cphMVu4O0vny2jCcYhqK0hkahHlCubFmMG69xq3whYhRX9bexhpI7MI8omlQ?=
 =?us-ascii?Q?Jk/G76lDVjfbsyyLohg1sv2xJQIpwQn5jDnDMInkHFAYDFIt0XDCOr7jx1h+?=
 =?us-ascii?Q?ophLRkBWUj5u4I2D4Rc/mYObYZeKZcX/M5Jy+97VvR9ZFqujuULzYhW86gTC?=
 =?us-ascii?Q?lwwxQvYZg1UAY+DTrNbWRgA8AH/PmEcejIm/GZ2Kj3DOLdBu/8t06GN9aJ65?=
 =?us-ascii?Q?qQtpTbm+cWMm3+1XiHQASwViKEE8KVYC5SpVJ1jeSJs28447x2+C2D9PHKHj?=
 =?us-ascii?Q?CNTP8NoxCWof6z5dups9t4UD+KKspLnXmuG/6ToZCKvQ/b+Uyr7wPqam/wva?=
 =?us-ascii?Q?v9R2cU2f1cH90f92J1VrX0yRMBilT+1n7Pg0d+xDhHoUXqcDNrA9Rhu3bopo?=
 =?us-ascii?Q?RnPGMpF9frB9fxrHPbrvU817h3SoGCalA6ZWB37bo+CPlRLBIBSgRiKuXbWp?=
 =?us-ascii?Q?f0tfRWswLerBxS0Nz8BXZ40LHksQ6SVPV3Kg6onaDsngqzSx9JNrchACIe7w?=
 =?us-ascii?Q?/j9SceHINP2koU/vkyX5utkLlh+QYeH2x1NLfO74R2ulYsE5BqqLLCD4RwqG?=
 =?us-ascii?Q?QHIZjwWqt8OwxtzicfDnluJkCPs+DWOcZdcK+oTo6lpctVYC85KQp/J3czL0?=
 =?us-ascii?Q?Mm6syB2zYtwL/WYje5ACuctV3u6JkhUnszmpMppct+rhOcRDTP/ls9qFKyOl?=
 =?us-ascii?Q?gtVc74wSTqdCyZxfZfCRkWSi9admFAJvKgx+MfdXNbhH90E6XE9WbDtAK7PM?=
 =?us-ascii?Q?F7/8hSR8ufkHc/CJ76KAAKAwE1nQv+Ko70yfJK1/D7lnIagtg7s1ZrnP+366?=
 =?us-ascii?Q?mTZ5cYjDWJdObVHBBrxxgCyM5L3ZD20pE8YtTn2fx7TlqgHFaUzJ9E0fQYgS?=
 =?us-ascii?Q?eB/E5AMGOp0CNTi0aZ39LpnuWxx5BChd/V6v/fP6EXo5zvN6wNwp1G8Byajp?=
 =?us-ascii?Q?C0zm55G2LVgoVK9L+kJ+/aQH7N9Bx3aQKMezXfiE14TqSmwYmkWR3bmVAEgI?=
 =?us-ascii?Q?nhdUaNAw4vQcqYXGF+jIx20ee1mIZHix0clCsjMY8ffo+cbEEnZ2JRqsu9UA?=
 =?us-ascii?Q?dEx4vryPq64Dm5F/yCVwTJ6VFXspuYOYZleyaJl/3badZA1qWowivHmcYKwZ?=
 =?us-ascii?Q?toMQGVCj7yZXWHgqG8HBqBqTw3Lg1s8fXAhdfebki0VxREFIUy1q2vcukv5b?=
 =?us-ascii?Q?Tz0rbQTu46KPrD+9hGnJBKlC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4940.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b48ad192-cfe0-4b99-f4e3-08d91c4dd9d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 11:44:54.1602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jk8dszDewMR8aiUmAa/FnweA4gAqutgKuqmLbpKUrZgXF4tYdTnGj7h0p4iSWV+RH9H2skjKVFwZOy1mWDIFmEJcF5xh8ZH9N1BMsauCUds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5067
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Magnus Karlsson
> Sent: Monday, May 10, 2021 3:09 PM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; intel-wired-
> lan@lists.osuosl.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Cc: netdev@vger.kernel.org; brouer@redhat.com
> Subject: [Intel-wired-lan] [PATCH intel-net v2 4/6] igb: add correct exce=
ption
> tracing for XDP
>=20
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Add missing exception tracing to XDP when a number of different errors ca=
n
> occur. The support was only partial. Several errors where not logged whic=
h
> would confuse the user quite a lot not knowing where and why the packets
> disappeared.
>=20
> Fixes: 9cbc948b5a20 ("igb: add XDP support")
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20

Tested-by: Vishakha Jambekar<vishakha.jambekar@intel.com>
