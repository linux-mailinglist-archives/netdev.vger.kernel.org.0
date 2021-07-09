Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235493C291B
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhGISld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:41:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:50624 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhGISlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 14:41:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="197027788"
X-IronPort-AV: E=Sophos;i="5.84,227,1620716400"; 
   d="scan'208";a="197027788"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 11:38:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,227,1620716400"; 
   d="scan'208";a="428866603"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 09 Jul 2021 11:38:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 9 Jul 2021 11:38:38 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Fri, 9 Jul 2021 11:38:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 9 Jul 2021 11:38:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 9 Jul 2021 11:38:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoSSncqRqqrIfviFOjKBQTBCp3IMXjv0bTTZB5Kn+cshZSpeUWs41L1eR8RdEznL3C/GbxPgPlC/p2r0Ix47FZ4s6Xs10XcueoxXxaaKE0yuEyK20TFC6OTJSU3fH/ocva0YOicR4xMsnKhfi0Rt4unV0kpyEztXpTSSfzUUQtjpsQ/PJQe3fZeCRIHRhPrNdRUAFjBFk8Qq77rNujkEAaM/gMp5qIv9IG8uZem2GiMCv2LGXVV58A4HRzql1V7AoC50G6Ru3DNt71JPW+e3YkF4JRnXfVpoyix6ywmsYIfRjX5RMVD68SXUHZrybb5FxD8zEYqXaZbUhdi6rCEVAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+S1GC4iEmwwKuRN0HhDckyvaZDsmJQrI1mfq3R9fAi4=;
 b=FWEaIN6QqEFaG3C8THm+6nJ5IgIvjXw0hrcso5iODlsJMfWR3swPg9j2md5/L2ojAnG5ZMKbeQqzceXsLxwqOsEo9tlxx2Vlm627VeZTQEc6VRe+5oEyeVajKD8uvOwtvyxqaba2dUn7892bRKqqMREeVYNi8+tBsURwwdhqkakPNXuemYibZ8LOQSjcvX9atpwOOH7zMQsH9Q09G1GspSzeLicbx3qQZ1ALNuZSm/bWTE50PMiYYzO5ei/jyLLQDO/eWa0Ft7QUOjrXHBPVhDy/so2h6ehfThApGJTQQQn8zQV+Tc8FfOBHLfSw1VxCR29GfvurWZntoheIacZ72w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+S1GC4iEmwwKuRN0HhDckyvaZDsmJQrI1mfq3R9fAi4=;
 b=MrJHOK7dkEjgRiFzENPKcvQXeoJ2EvomjMucnurHHjzCV0Lg/sUkAzwfPoQLZyjZ0VXFyt0MReYcUyXNg2NhysfvHLwtpL7LM7E4UUMgIuTFM5fRtadmJbyu5G7O+CoqWAoFVhGRoPxd+6tO+9ZyaP696YFIB4HTu9sgcVh7WzE=
Received: from MN2PR11MB4173.namprd11.prod.outlook.com (2603:10b6:208:137::20)
 by MN2PR11MB4256.namprd11.prod.outlook.com (2603:10b6:208:17b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 18:38:37 +0000
Received: from MN2PR11MB4173.namprd11.prod.outlook.com
 ([fe80::4830:43ae:7d53:36d5]) by MN2PR11MB4173.namprd11.prod.outlook.com
 ([fe80::4830:43ae:7d53:36d5%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 18:38:37 +0000
From:   "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: How to limit TCP packet lengths given to TC egress EBPF programs?
Thread-Topic: How to limit TCP packet lengths given to TC egress EBPF
 programs?
Thread-Index: Add08YrrJTQHjCMDQUqDNnOXswNLbA==
Date:   Fri, 9 Jul 2021 18:38:36 +0000
Message-ID: <MN2PR11MB4173595C36B9876CBF2CCFA1A6189@MN2PR11MB4173.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77611235-8637-451f-a956-08d94308c3a1
x-ms-traffictypediagnostic: MN2PR11MB4256:
x-microsoft-antispam-prvs: <MN2PR11MB425648B40CF4264815B29B80A6189@MN2PR11MB4256.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8ynthUQPrb9QNXxvEnaPnzfP2NNZHkgrs8GZUjNo3fvCXXYwn1DN2fVp+uvTRGAaexhqOVIZIqUGkjJpOX3TKKabhnwjMp6lXNZbbWW37j0QCai2iNSsdJuAA9y/6DmnR21XYSrsLE69AHfcXxHjzN8DLtr2WWxmohqK/Q0PaYe7dTYz5I9k6LYiW+8lKFZv6eafqLnP/ahq59R0xMjHVa7NZ+GmAoSlrlEBvuFwyvAV/pvnNdua28i/5JoYPTuvb9/8/FZp5JEtAZpn8d450NQGpxccAmMME0GnAlMigilfSRSkT9ouj2h90oDFUZqWBBPM/UJkRSjZtmCd/S2/1PvNTqLlBgVJqOuqRy4yVJEeNwXp8sdGvPkkNEM7Fcl5L6QWUKd1D+zUMogyPfSH6ffkDhGE4Q5ik0YTduTfiMCxZodtvsri9foEjxjb3m93XUan4m/Eu0StrD0MlpEDPot8LS0VH7bDo0DmhjjuwnxYC2lI6zt/lvgYd3IwkCtip546wfygmHB3Fmzfs5/UdX2bmHYAT6OGIoGHNGgWduD7raReMTJP6PdtAYxUEuz6grN0kxY73dc1UEu7o8d+t7mQWrMnLv6KzpPnESdn7aSUEMyMMS1AGCI2WAf7PWJzx3MDhU1I0yNR6eij5ktcPzxPFrUebQ82wWJTg6My043EZaIYRvHvUxm8v8NHVEeanBis1wBoYi2MaHSn71Ywu7YohAvv461IC/Cy3HUIAC4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4173.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(366004)(396003)(71200400001)(9686003)(52536014)(55016002)(2906002)(5660300002)(186003)(478600001)(38100700002)(26005)(6506007)(86362001)(76116006)(33656002)(66556008)(64756008)(66476007)(66446008)(122000001)(7696005)(66946007)(6916009)(8936002)(8676002)(966005)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iusCDMokcfHJbiiS5HkmFmSb+FO/b/D6K/4PFH0iS5ddKR7lqqq60E4Sx8v/?=
 =?us-ascii?Q?i1sNo+j4LX4gchhNXXyJyItEsC/FxUDAaZviypH1YmyBls5BwTuTvoGJxza6?=
 =?us-ascii?Q?FUHMIKXR1LI2pHp3SFEVOm5qN2A/OvHq6GEvZrJqNtJIOPp1oUHds8NZ3RwA?=
 =?us-ascii?Q?E9D2P0SNbS3huglt7aD2TnLI+wD8sK7FNn5G+hQZHYP+TzJB2F4+UCrJ7fZ0?=
 =?us-ascii?Q?wdWVUHYG9J3F7fea6GWmUkOuiQY8fDO3436GO4D6ZJi+b/sVqMhjT40KulS+?=
 =?us-ascii?Q?u73TXWQSW/NQ42PVn8IZpVo3W7RncG5Djm+jPmdXFz+IihHiPd29ColFcp/N?=
 =?us-ascii?Q?koSlVRtNfxk3TYGRbiYsACi6VDiHStn/xFo3MjAuBLpyGmgM5U2OY29OtduJ?=
 =?us-ascii?Q?58u9jwR2G+EMhkXuag1M0BG+htBjI2PSx1Hu5dJE5XMwfCUtWHo6RcLmIONE?=
 =?us-ascii?Q?SgToiq+E8YO17NjbLJdAzavFwXHdzFZBOmS6Vsad0CT3MbE+xbmpCL8AdvPI?=
 =?us-ascii?Q?Car/Ns7gmX7u58lcR9zz1g683WRUGdT8PaGr0NOpBTpkNghHsEhP5It4oQ79?=
 =?us-ascii?Q?fy9zHWe43u9EHTyITD38CyQxCyc++QwSferDTtv/8Df/fptQgCpmwyCl2CoY?=
 =?us-ascii?Q?kQ+iYtQ0TSLfIn0ColBQHFdEv1F+CzBgCbYJaJ9Qq9c2ehmGi7boL9x5DKWM?=
 =?us-ascii?Q?VAs35RxUn6R+84c58Fg2P+NpqUMfiRvDIJZc9NRIX66poyoG6jUMuuWTtT/I?=
 =?us-ascii?Q?6B+6fxP8K+blXqFJE6gA1m00nErarS9YCd9raMQqW9v5Dt/lziV9d79YUaCG?=
 =?us-ascii?Q?vN+t2mCOyaAYfwuXuRgGDo8q7rdloqCs1xHiJacr5mrqU/7wGeuRBs0VSI95?=
 =?us-ascii?Q?z6VKmpHF04NHblshf/9YTJCY1oUMMPuJqI7RH6HTZx3jsUzUt5PRdWcA+C3y?=
 =?us-ascii?Q?bNsiTaZrHlBUunmyMCV8lQ14lSqb2x6+zgiTvZWJ074gZ3wP7z3YO5ckkrpV?=
 =?us-ascii?Q?Cy3lfIKwvlIHB/E11ap9MaO6CHbPsulmmrt6+swix6ePIr5zKPua05jj0ll8?=
 =?us-ascii?Q?GbckWmg0zSnlHyjICVrIq4G7ts7EZpCu84Yja/cVTyUzbvlGDwviBiGeQ13E?=
 =?us-ascii?Q?aFOSK8SK1CMnwXKxZ0Ml22acDNlawmwDdDQ+tXqhl0BTobPgr0N0+TcSSk23?=
 =?us-ascii?Q?TuGIq0IAZ9BHsu4zVyrWHLCA812xnNhEWTDIv2O19y5L4bbXSSLwVzKgpizM?=
 =?us-ascii?Q?b7QQP4i9awFdItW7ywbpDIAEmZHDv28pM6YKQxxDoHUoV2CPqKDOaQ/aqdHN?=
 =?us-ascii?Q?syXW43bSZ1kQ3cRqNRTyjH1i?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4173.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77611235-8637-451f-a956-08d94308c3a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2021 18:38:36.9537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /kc1g74ahS1DmCJ7itQtd2MOcQNFTSuzbkTUG2fo/yUF6tSSEh5YUR7whScuvCtircmhREWpwLyaT+HMjsY4OBgSK4YNwPn+m3aEqAAyF+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4256
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

I am working on a project that runs an EBPF program on the Linux
Traffic Control egress hook, which modifies selected packets to add
headers to them that we use for some network telemetry.

I know that this is _not_ what one wants to do to get maximum TCP
performance, but at least for development purposes I was hoping to
find a way to limit the length of all TCP packets that are processed
by this EBPF program to be at most one MTU.

Towards that goal, we have tried several things, but regardless of
which subset of the following things we have tried, there are some
packets processed by our EBPF program that have IPv4 Total Length
field that is some multiple of the MSS size, sometimes nearly 64
KBytes.  If it makes a difference in configuration options available,
we have primarily been testing with Ubuntu 20.04 Linux running the
Linux kernel versions near 5.8.0-50-generic distributed by Canonical.

Disable TSO and GSO on the network interface:

    ethtool -K enp0s8 tso off gso off

Configuring TCP MSS using 'ip route' command:

    ip route change 10.0.3.0/24 dev enp0s8 advmss 1424

The last command _does_ have some effect, in that many packets
processed by our EBPF program have a length affected by that advmss
value, but we still see many packets that are about twice as large,
about three times as large, etc., which fit into that MSS after being
segmented, I believe in the kernel GSO code.

Is there some other configuration option we can change that can
guarantee that when a TCP packet is given to a TC egress EBPF program,
it will always be at most a specified length?


Background:

Intel is developing and releasing some open source EBPF programs and
associated user space programs that modify packets to add INT (Inband
Network Telemetry) headers, which can be used for some kinds of
performance debugging reasons, e.g. triggering events when packet
losses are detected, or significant changes in one-way packet latency
between two hosts configured to run this Host INT code.  See the
project home page for more details if you are interested:

https://github.com/intel/host-int

Note: The code published now is an alpha release.  We know there are
bugs.  We know our development team is not what you would call EBPF
experts (at least not yet), so feel free to point out bugs and/or
anything that code is doing that might be a bad idea.

Thanks,
Andy Fingerhut
Principal Engineer
Intel Corporation
