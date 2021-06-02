Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48233986FB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 12:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFBKyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 06:54:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:4419 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhFBKyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 06:54:05 -0400
IronPort-SDR: JCF7ANrP5EOvLLwZ5Yr5U2hEt8ETdF08I0zzJuGrfo/+3TVG3bWFxcTNSaWdVwWA+LMUIBUbru
 VHa61FqmVqug==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="264940115"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="264940115"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 03:50:55 -0700
IronPort-SDR: z2oSm2uJ/Pafrk6aj+N1NHr+lvLcbSqGX1fG+s1hKGRQMrtp+u24/3+n/7H+ZrEB1c8CQB5DzE
 w291SEVjRezA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="399976190"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 02 Jun 2021 03:50:55 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 03:50:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 03:50:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 03:49:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IibIBv88GhjLF3/6ZuA1VeSU7d71G1mVIvfzOwVYWRhwLmwXq53/3kYWqQtlLhFRS29cSjb+95clhoeQUOElr8TRQ5jJL2ffsBq0mi+/SRrezA8tTR2NargfabynPE3Tkd0iR38+OI25Qc3fNR7mFZGq8r+eFJ4P2NMbqj3fe8+BWp1BWk/q4Pmzeme+mqgE4IemzX5UC5DY1DUNr1V0GSqT3EwgShiqruORy/4+lHoWd8dZxEQBgGQOWSaRzDnQo/CoNmiyL0HpzBe1b3WmFHbhpv76eU0cW3AKe2JNl5WqeCgpwty2ebOI1PNsii2QHVGYyIuDFHn0RXzDpiOQlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rREChZldu+JdXrDb81r7hCSeg9l1Vx4ncNiEK/sazsU=;
 b=ezK6ag6PnIpCo9PVH2ADJLZVp48+oVNXZTkHfAOIvGdfcFFkXy5nXq7QTGIfBBcqzm9uNrMuFuvKZyqztXYlkWlwnqLgEsl+ijLLkHk9B1/4mSw3Qtst02sKJYMMjRy5ieuSQHKNz1uMNbXxZoOw2v9D6UALivHl5rAZogQyaXSVio2kuzSzVGfUMMPLHEVFXA3P8Sv0p55uE1b2j9gIco4vs4bQsIgqLcXxKuZXy3r8d1QgOj8XQoOa3PC0lHnd3y+BkR3qf1UaYI589mMOUojmYbNl3j81frYekGYRdd/oiefv0PIQc3QQJ12ArubzNOfWwbXTaZZhuIovMSk+PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rREChZldu+JdXrDb81r7hCSeg9l1Vx4ncNiEK/sazsU=;
 b=pLMcxhI/fxA+fg6g+g4iBr1orMQELeQRidkx5FZmSFpspHNKLYQCJqXYFrxmSwJ2xYMV1mKEvIzoDN9pwtIzHDHR2jQG2RFa884ndzej+mJDplzCE/PDveul+0vUibhpzR8y9BrChPcM/usVlcaCLmWmJkKKzLugbYn9hcouTjo=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MWHPR11MB1375.namprd11.prod.outlook.com (2603:10b6:300:23::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 10:49:15 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::4cf6:2087:5bb6:3518]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::4cf6:2087:5bb6:3518%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 10:49:15 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH RFC net] igb: Fix XDP with PTP enabled
Thread-Topic: [Intel-wired-lan] [PATCH RFC net] igb: Fix XDP with PTP enabled
Thread-Index: AQHXL4UBJtMpr/LOekqiQ1AfTtdcmqsA2lNg
Date:   Wed, 2 Jun 2021 10:49:15 +0000
Message-ID: <MW3PR11MB45542D3E8343264F0160BF6F9C3D9@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20210412101713.15161-1-kurt@linutronix.de>
In-Reply-To: <20210412101713.15161-1-kurt@linutronix.de>
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
x-ms-office365-filtering-correlation-id: a932c82b-4775-469a-75e6-08d925b410d9
x-ms-traffictypediagnostic: MWHPR11MB1375:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1375D70769355A6953EFB1C49C3D9@MWHPR11MB1375.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: isQCdytGclAu/oJUncqloDGr97yuQjxvaKOE6Z2AnNXZe4c6J1TZwGrVm2OJvPgPw31oTCce3mZ+MCyboPzC7oviUspF3SxElIuuHPRb9BY/89U3O+X/j6p2kUyo3clOrw99uk443q/BDHPhsKgiXZDTM4knbQ735f68BzmlpXScIz2QCyVCRLky3oHcj8qSM86KrKLD8d2N/xmarvDNeOH4SPjucUFnRMWQ99PXMEDe6gPdWBFFM0xw8qKCHud0UEUMPB4dugEf7mQyOfjWI9vqqPBtz0TCZYowXSOOAEEs46aIqzBq+wJP/asjuGpm+kq5eLFn44pweKkaMu9H7fKMKkdSju8s2aPJ15zUwFgLSm+yCvztyfNHLzPuYRpayuw1ElyATqdfj4oWI/7NBdwCfjoyi84Qht7VHwGQ4HsXtOI3qQgOTVCVU1gRzJdrATqtZwMi1PljinMPgEVu5u4r3dGwAc4Wd6dtt+33lhghzyhIQOxUj0i8n+HuRz7qgPR2QCalGuDq5+CbVDWjY0IGlp/v1LUHEP17LJNZ5lXnciIy3cVQXJfqdwxGc0LdSstwmAvstHDTNwSiM80sD9U+PdpfEs8bT0vjD7RzQpA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(55016002)(26005)(8676002)(478600001)(186003)(9686003)(316002)(83380400001)(6506007)(2906002)(7696005)(71200400001)(86362001)(66476007)(66556008)(76116006)(7416002)(5660300002)(52536014)(4326008)(110136005)(66946007)(66446008)(33656002)(54906003)(64756008)(8936002)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TQpGj+GHpAEIYqvAnK28jJeBhoRRRHfC3x53rJDQ2852I0O8XAiSeU8aNpfx?=
 =?us-ascii?Q?ju7rJt4RFmdOnsmXAI7udH4pL/EfRthcdqV5cu7sViLSVkqRxEezooZKZhJ+?=
 =?us-ascii?Q?WNGMux/Lu9R1fiy6Lh4tuQ9r4bSyJpu2vXjgE09sy/nikCUsyV4XbBRgI8oW?=
 =?us-ascii?Q?unACYvrdmE80prVU9t32ZFZvzac3g+4vDhRfTNltuZ3g3QnaY2DluE3Ruzyv?=
 =?us-ascii?Q?o3CjIUewo2UITMBBija9HDm+ze628UqKpUKUFl9XzWiFks6adjCKOpEAfpEn?=
 =?us-ascii?Q?pr0EWwjc/0aRXCoAaVGu20jOrliSlAfZEwMrESUoYovmsAUjNe1CqEoIbvxH?=
 =?us-ascii?Q?LZZbv6LeqFHsw0Uzb5t4duaJO+9VkDHTjIb/dGIbca0+cD9JRGNKC294n13B?=
 =?us-ascii?Q?tqunj5tgy81uXBkXaSBvHZPX8/im2UvQYhhXqX3hh9c9HBadj7A2xfKDG3Mg?=
 =?us-ascii?Q?lAJknsY6cttCvohLtKv87ynmVkMk4MEWNdnzbQUgKzBzHEBbMjBU5ziGbzFn?=
 =?us-ascii?Q?P/dV/w8TNW8g9WYC7ymJPCY3VVmjR8SueH853+a144cKtqfoRbUT8DgU+TBq?=
 =?us-ascii?Q?BqjZoDjYqcF8qTK+5hVvF1uSTkgyv/1i8mFlP6waetzrrVrEwi+sNounsMYz?=
 =?us-ascii?Q?qmv91250TzZWOq5Zd3agjwhJG36o13C1rRzyd/XupxszupYxVx50ehzS+2MS?=
 =?us-ascii?Q?lnyt5/02rXNze5xKV6ISoMcCOK7xi8jdnwOcEeCVR+A7hNm+lAJXAyblbWWb?=
 =?us-ascii?Q?wvWINUgF08UaJpzdgR0c1/daDMWdRFdZEN1Z2hfjvLJ4mgK4ITqQC1FQzuHF?=
 =?us-ascii?Q?INCUYXhGZgd3W5r1DTjW8fT5WFfx6RkEsKCXG4X4q54ZpIxXNc/hp+cW8n89?=
 =?us-ascii?Q?JypgzFGD7v3FbRnN1GIRpRu05PYinBxb42WpPjE/aF8zAqLvvkR9yxh0xnJH?=
 =?us-ascii?Q?VjiId5bZcvNcQ2ppfn67b8G4WVlX7SCMpssdXJiYKfpIM3aRtWZuTLhYF1YD?=
 =?us-ascii?Q?6HLApRRCBrz0QKNrLS1kiR26ebJcV/rPEHewq+tcw0DFgyPLknTeeNjOfWuo?=
 =?us-ascii?Q?G5zSXsoDxzCUpLhph1t0SxwddcRFKW11NX/NuH9r1NjiFfKXzvmsm9Es2sdM?=
 =?us-ascii?Q?u8F1EpZI6Hg++zaHbrLFWlQzNEuLCcR/qfpyuz9r2HoQyyIwLJYSqe3eGJK1?=
 =?us-ascii?Q?Ja3e0eIdHlhXV8Lgrafs1kobvoJ9qKmj/ulGrE1uyot4bWUc3920hVjlNXaP?=
 =?us-ascii?Q?XR6MNHtffOSjZVHIkqAYIAw30HfZMYQm2PZ25IZ8+KFBr7S3XFJGRtGaGi3B?=
 =?us-ascii?Q?3rQB6984FNb+lOM4S1EEDL/O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a932c82b-4775-469a-75e6-08d925b410d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 10:49:15.5508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: URvDfjMP4R/AfQOO8tDeFu5PcTmUP3G3rhJVYYtyzyzyALUpKGM+DErta8iCsv2/ryFxr4MEaZMvkPrvZdrYhYeQ247oKO9V4Ai6NPIG/y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1375
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Kurt Kanzenbach
>Sent: Monday, April 12, 2021 3:47 PM
>To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
>Jakub Kicinski <kuba@kernel.org>
>Cc: Kurt Kanzenbach <kurt@linutronix.de>; Jesper Dangaard Brouer
><hawk@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
>netdev@vger.kernel.org; Sebastian Andrzej Siewior <bigeasy@linutronix.de>;
>Ilias Apalodimas <ilias.apalodimas@linaro.org>; Alexei Starovoitov
><ast@kernel.org>; intel-wired-lan@lists.osuosl.org; bpf@vger.kernel.org;
>Lorenzo Bianconi <lorenzo@kernel.org>
>Subject: [Intel-wired-lan] [PATCH RFC net] igb: Fix XDP with PTP enabled
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
> drivers/net/ethernet/intel/igb/igb.h      |  3 +-
> drivers/net/ethernet/intel/igb/igb_main.c | 45 ++++++++++++-----------
>drivers/net/ethernet/intel/igb/igb_ptp.c  | 18 ++++-----
> 3 files changed, 32 insertions(+), 34 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
