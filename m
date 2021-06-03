Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354E2399FCD
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhFCLcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:32:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:13976 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhFCLcj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 07:32:39 -0400
IronPort-SDR: CpAYgq3sk+S23GpKPdrkorlr3OhL4gCjANLs6tgWEo2RSnbMAVssvL7gXubPJQvWK4WYk8y7Zs
 /LnZY9dRBE5Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="204011066"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="204011066"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 04:30:48 -0700
IronPort-SDR: ASpbvUq28VHoG4bshPhtU49cGKs1K+EWohQvXrWGKpyP/1vGc51QszqrOevtIHW9sAUNl5KuuX
 gOoT0H194xzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="633665540"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 03 Jun 2021 04:30:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 04:30:46 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 04:30:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 04:30:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 04:30:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjDetrCqOOsvpvtesQVjIQddT7B/Ho00aX/fPRAJ0xK8f0An55DOIWZ21bNNmnyN1x++NHXDuwC3kmAAGajtvI4a7cVaVMGfyQ+NpEuoLoY4Sa20kVwVdwf3JZHb4Ty6LuJNJ59Rq9opFmJ8wjHYmVLuEhyytB1RjmnSSUTC+8Q7O7RH8bzbpu57I37k3e1AzW+4N13r9NjrQmonzQ688rIv0VZn2c6uM9toSqIAEQXTZIPCmkZO9eaPLG7qEk+GBdDKJYkK0ElARMSygTyM584tor7J1w3KE2xZMLJmWrilIhoz+IGM7jATGf4HOfvc3nwu98IPB7q8Mcfyj0PQFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYmbNuYze8neaXYnOyRE7p9RQx3TRycXZh+jfORisi4=;
 b=bBarHl/aW8UgEePJqlsXL8HgzCocWggq2uL+1qUnm2dMsnIhJWhFuxrHYuoOwLluHGPxsUc5nnb+M99H03dnsE2xQGApsnxBWsbVP7rdd/2MhGR1BpXiKK7sPEyjBLygQyHt1f9meRAQblkkWjHMkMA30td1rNX8v+++XtCS47F6tMroxVTPri50aRPGwvnEQ856qUm2lJThA1iiPE2Siag/XqyGySjGYRIg8xTURqt5Viyin4VsqQygtWprd4O42LyPjBCCo7ge3GNj9iLp1zYc68ySOnZJoZfsUh25KwcMLhjcUP2QUD5EqoN/nNBmldulw7Ijcl/NsCY6qzFgmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYmbNuYze8neaXYnOyRE7p9RQx3TRycXZh+jfORisi4=;
 b=PaPcp61ATkEj1XVIOgJLrukYslyeSy6ym7EWnoz0BA5jBmG1TUheHWE5Y6gd2eqnRm/4XsfCdeZQ/tLPADkF3Wy2d3cV3u9XD69r5beeDaZIX8UpLkvW9bPPWtTPJCU/U5vC8gq1Dog/AMVDFQPlx+IP8zTCwkns7JG06ppDd2w=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 11:30:45 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::4cf6:2087:5bb6:3518]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::4cf6:2087:5bb6:3518%7]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 11:30:45 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Tyler S <tylerjstachecki@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Subject: RE: [PATCH net v4] igb: Fix XDP with PTP enabled
Thread-Topic: [PATCH net v4] igb: Fix XDP with PTP enabled
Thread-Index: AQHXWGvk5WHQhefeNEGUtzjHPvJYDw==
Date:   Thu, 3 Jun 2021 11:30:44 +0000
Message-ID: <MW3PR11MB4554208E081D4DD08EADD7669C3C9@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20210503072800.79936-1-kurt@linutronix.de>
In-Reply-To: <20210503072800.79936-1-kurt@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [203.192.251.142]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8e8dcec-f93b-4c1e-5052-08d92683071f
x-ms-traffictypediagnostic: MW3PR11MB4683:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4683B4B85F33F4B3F9C7362F9C3C9@MW3PR11MB4683.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uv8RpoY6ZDRW/qjRTBzRSmDx4Kp/ePzfdVS77YMWL3oBUatH5e9BJqzJ3l8By09z1TyXKfGVZG7q8aXA8rl9UX/2pfqrBVhgXxw8BSwnVLPJgGSEgHjuDYkWE9fuSw+UiWlFWHfpsCZvPsMdyHkELmOcSQWA4XAEEydb6ceZSGApxUBVRFMuE8Jka5JB7XdlOdTxkRsxOvI81m3L10RkuHl4/f69piepfK/54NN0QeYwd6kbD41jXHlF/j2SsLVrE/Evtcbk4/KNvuHSlP9O0/2Zo0diY5JzHB+5dTVefm0Vhs9iqqMc7KZOo+pWMdcEFMDWo9LTcMbb13m1KjynoKHXC2un6AGjHztAnMDZDBQh4vbi4qOpm10nhWGxluI8tReV3PBC+JcdFVMq0P9mAKr1Xk/EEvlRt4+31pSz8xhZRAg9EStr6dxEIQYK8MxEpKDU4C9iiHuq+jGZolcOOJa1eqrvXS90MboYXj/+lcezxljQ1SnvJ6AMT59d/qEquerSCf1RNxcn/ZVv3iQQJDLEh+l780dD87DLfxQgwQxkQN/wz0kCfWPuoUobe0BXIhap6AdOQvCLf8zmPJ03sOJ+nk4OcFo03zN+Nj7Ve3NpBw9cXOtUb9d1uNn1lWxVwJ7AJFImPygYYRKvlaFM2PiIPd0Shq3AwPHgahEsPpEasO2TiugGuR43tGtH8m8lr7miuzOj4WJkE5LsYy8zINqAYZzJA29O++0q9iYfcGqTj5IXJg4IWmiU7F8cW4Aw2DwjzGcIw94UxVE1/TsX5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(396003)(39860400002)(83380400001)(86362001)(7416002)(122000001)(38100700002)(966005)(316002)(54906003)(110136005)(52536014)(2906002)(8936002)(66446008)(66556008)(5660300002)(8676002)(66946007)(76116006)(66476007)(478600001)(64756008)(6506007)(9686003)(4326008)(26005)(33656002)(55016002)(71200400001)(107886003)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vHKYPiaW+HFBsow1MQzN11Mmf1Hi4j6dpTkv+urMKL8xeCNOdcC+kwLHONgo?=
 =?us-ascii?Q?5InlwjfxNEWfxfp8cQP3y8xTrnBB+UvoLjpaR+EAk8nejhv0N0DbCJJWJOU1?=
 =?us-ascii?Q?rPHoO9PezVFr0A3rfT6PmiIggN+WxHROpDXhHIVAfYQ/v1jl/qMQoz3lhyFt?=
 =?us-ascii?Q?nZRHQxlbkPPmNhpUhIHCLO2X0zxIHXqmCsR9UTlg+TtU2naUdpskVabTB2kx?=
 =?us-ascii?Q?lvKk5minaYN7s/cg6RUVSS3ss1T1juxub/QbVmgqImvQXEEZ4EaLPO2ehQJL?=
 =?us-ascii?Q?PyFAjUIf+P9QoYlmjuM1nw/9rd6uW40k/foaonS6XfOuy9YdW7Iud1q5RtbO?=
 =?us-ascii?Q?WbxvDS35lpFj3OZ1CTRWzeQrf6yZUHIkclmdjueeZ97Wm1mKfDKX6yd/f+p3?=
 =?us-ascii?Q?M/Lqe2C2cHPT7kbDgiukf2hO9e4E42N9MKKzGmTkRKrXnjoINvwH9zagulNI?=
 =?us-ascii?Q?R9xr1wNJt4FGG/GAKJwO0LvySXeavujNdvoY7+aBhG8HtnDCrWuodoIlPurQ?=
 =?us-ascii?Q?fmYMzNRAwzJpzpDmAXe7nqMR4mEQvdlyQcHEQXYubYAtMqGoJgsHemLNNonX?=
 =?us-ascii?Q?RJa1KLG4UrBGyF6e7dsUhp6ihhu8gcnPRbY2gNwU7WHxQ9A/Z761QSaNDUIn?=
 =?us-ascii?Q?4rzNxQyOK8TOSG06CmugR49h/fDzE1zU6nOIiSSpdFkbhLWf8d+C/gc0hIug?=
 =?us-ascii?Q?Nu699deOH8aO+CRSUApL6YdbvbOvuHxe+/b2Mpfo8UUB3qISDSLGfuwTSnsM?=
 =?us-ascii?Q?JoT/WETnh3YPg8sqFMJjp+Ce+Cu7Bf/aWRzvh4Iy6b3+eF+1jAxB2SsIUE2F?=
 =?us-ascii?Q?WrNlvpgMpWV0xGDTg8JJHCWX3F9ol1aZNVrz67qfFq1JVDG9AIY8G9zihaPr?=
 =?us-ascii?Q?FmvrWht/9c0fFsD7kj7tk47GcNf/6MJE+xIHdpp+spwZ55r9v1qSFT1oAFDQ?=
 =?us-ascii?Q?bTZaayA64vXBS4AJrPqnCmtjoY9xi6ODEbOlEkdlgh2MTTY/3QFO5VF2Ld6P?=
 =?us-ascii?Q?Xre6nPGDIrlHW9xjOtVSYDpBaacEPXBlq0cPxfkMtWDGyz+0c5RgNkCYHYED?=
 =?us-ascii?Q?eC3cZvcbRpfprisd36ihO/iQOAZ3UBUHcrgGzOlnzmim0utqemK471TTfytA?=
 =?us-ascii?Q?nzWARlawvkiSLv00NAgF2wfk/pv3NsDVVgIMFno6YL2vfzi1b1R5yuHYW/KB?=
 =?us-ascii?Q?LwJR3UUVqcipwDFPSDTlsVPj3g5nJbuRW52VmdZNWoSV+z2EnBFHkus9rQXf?=
 =?us-ascii?Q?QWGTMXmgwp0CpAza3DuZ3fLKeqE+D1ODVkqX55bYbOXplR0RbAXqZ3kCFHof?=
 =?us-ascii?Q?wJ590Br1tcDD2vg4yB9xJ5iN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e8dcec-f93b-4c1e-5052-08d92683071f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 11:30:45.0783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6YJuGsAVaxJVlKhxilk4Ycid2H/wtIBS41DfU6nR5+Yy0LgC68p4HI/cUVjUzpo+v8x8MGSQsagSwdM0HJKxcLkqIMsrbHZJdfSk5xv4Gl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4683
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Kurt Kanzenbach <kurt@linutronix.de>
>Sent: Monday, May 3, 2021 12:58 PM
>To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
>Jakub Kicinski <kuba@kernel.org>
>Cc: Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
><daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
>Fastabend <john.fastabend@gmail.com>; Sven Auhagen
><sven.auhagen@voleatech.de>; intel-wired-lan@lists.osuosl.org;
>netdev@vger.kernel.org; bpf@vger.kernel.org; Ilias Apalodimas
><ilias.apalodimas@linaro.org>; Lorenzo Bianconi <lorenzo@kernel.org>;
>Sebastian Andrzej Siewior <bigeasy@linutronix.de>; Richard Cochran
><richardcochran@gmail.com>; Alexander Duyck
><alexander.duyck@gmail.com>; Tyler S <tylerjstachecki@gmail.com>;
>Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; Kurt Kanzenbach
><kurt@linutronix.de>
>Subject: [PATCH net v4] igb: Fix XDP with PTP enabled
>
>When using native XDP with the igb driver, the XDP frame data doesn't poin=
t
>to the beginning of the packet. It's off by 16 bytes. Everything works as
>expected with XDP skb mode.
>
>Actually these 16 bytes are used to store the packet timestamps. Therefore=
,
>pull the timestamp before executing any XDP operations and adjust all othe=
r
>code accordingly. The igc driver does it like that as well.
>
>Tested with Intel i210 card and AF_XDP sockets.
>
>Fixes: 9cbc948b5a20 ("igb: add XDP support")
>Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>---
>
>Changes since v3:
>
> * Get rid of timestamp check in hot path (Maciej Fijalkowski)
>
>Changes since v2:
>
> * Check timestamp for validity (Nguyen, Anthony L)
>
>Changes since v1:
>
> * Use xdp_prepare_buff() (Lorenzo Bianconi)
>
>Changes since RFC:
>
> * Removed unused return value definitions (Alexander Duyck)
>
>Previous versions:
>
> * https://lkml.kernel.org/netdev/20210422052617.17267-1-
>kurt@linutronix.de/
> * https://lkml.kernel.org/netdev/20210419072332.7246-1-
>kurt@linutronix.de/
> * https://lkml.kernel.org/netdev/20210415092145.27322-1-
>kurt@linutronix.de/
> * https://lkml.kernel.org/netdev/20210412101713.15161-1-
>kurt@linutronix.de/
>
> drivers/net/ethernet/intel/igb/igb.h      |  2 +-
> drivers/net/ethernet/intel/igb/igb_main.c | 45 +++++++++++++----------
>drivers/net/ethernet/intel/igb/igb_ptp.c  | 23 +++++-------
> 3 files changed, 37 insertions(+), 33 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
