Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397FC28C49B
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388667AbgJLWUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:20:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:38586 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388218AbgJLWUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 18:20:11 -0400
IronPort-SDR: UkP5M55ANNnUk0EtSMPFIullhsWXJCsOWxnXKbR5kbNVBqKD6d9jdMuRTnYoq5Ue3x+XwYUOVH
 4Vf2qBgTCWDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="250507322"
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="250507322"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 15:20:10 -0700
IronPort-SDR: 94+zPiI4fYjNit7h9CwxSPjI1vreefKJxOPjiqSMCarNLDpgFA+kOhml1S+mSjpKYFHz0pvWkD
 oBORqfmBAB7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="519758648"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 12 Oct 2020 15:20:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 15:20:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Oct 2020 15:20:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 12 Oct 2020 15:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jb+XEiT/6liC1jO/s1vGl9TZl9hsVWZ9I37TS1Vn1Ym0Ki/XuP1p50kP4xyrSHslc54KcNeOkeErzQHswDgwEos7aILTbNUnQCC84E8/Bh6rO/v3m3BcSwCXzVK2yTdFNYOkC14jZO1MxfrbVI+jpOHWwY508wI3yM0koEtelvMRDgxKQo8w4EPK5NIP1DYK5yy8J/AIbAWKX99cijbmj+U7rKRfBxiNGYMQkpr4cbh+Nsqbk6aoUnnmuWKMg52VEBC7FFzkEPoiUkURyAyLzsWnfdizDhfVRXz8KEuVageVbjqU1l03TebvXR8E2wEdg04m2ioVeIF7ApGGtfVVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIyoqcFPAaQu9ts0AfcyVnuwIcreV+uO/KyREqI3rF0=;
 b=jqEZY5SHFo3XVIwuBC52nKSr1/BdhMrd0riwgnY04BcSw24MVsLX7MYWLoyFScZnEepJNB3rZnYyv8UoOivBv6sxuVXiC2v4YKhXKrhaI5tjU+Z9Wmh2GeZwTavwxXa8fQ9/wTljumq6O3N3OZe/7OeKZTcFtUHa/ALmUhLedIvbs587jzr/S9dgW5196ZQDZFwaEIfwafcRE29xP6x0nNxUm/J3EW4aNEWd67B6ORT4RA74Eg6eLUSrwGuBN7u8G3F+kgEfuFQO8SOElDjLY49nl2zK/ORTwjuAIRdlr6lNoYfqSl/z7DlFBfb+IVepYQ6YAhoxuSVJiwg7xDwrhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIyoqcFPAaQu9ts0AfcyVnuwIcreV+uO/KyREqI3rF0=;
 b=os/RaRDWK7j0hvlNZ3CHwkJNaTODBq25+bV/nHxrYllSz8id7Q0o8/AckmpTmbmZ8FOvFFb4q1O/Ef/GrmCeS4IJHPTv5v80E6b0VHTFR3K7XTUjb5R3f8+yhbRgn81m1HEyBWlVFBA7GpvyzEbb/BpJYA0vvKE39yFuknmmOgE=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB2649.namprd11.prod.outlook.com (2603:10b6:5:ce::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23; Mon, 12 Oct 2020 22:20:08 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::2472:44fe:8b1d:4c6c]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::2472:44fe:8b1d:4c6c%5]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 22:20:08 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Yang, Lihong" <lihong.yang@intel.com>
Subject: RE: [PATCH] i40e: report correct VF link speed when link state is set
 to enable
Thread-Topic: [PATCH] i40e: report correct VF link speed when link state is
 set to enable
Thread-Index: AQHWhoJvq//KXcz/JEy/UGyFLDs3+amUvoNA
Date:   Mon, 12 Oct 2020 22:20:08 +0000
Message-ID: <DM6PR11MB2890AC827D2F779D985D2513BC070@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200909082212.67583-1-sassmann@kpanic.de>
In-Reply-To: <20200909082212.67583-1-sassmann@kpanic.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kpanic.de; dkim=none (message not signed)
 header.d=none;kpanic.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.179.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 277a48e1-870b-4327-f71e-08d86efcfa48
x-ms-traffictypediagnostic: DM6PR11MB2649:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB2649F78EDD8C575EB7A851C1BC070@DM6PR11MB2649.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:161;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xlQSQC3o2yywkHlAMeMB9sddoCIBO/32n4nsDf+MEt5GefX9sJPsguLKXKlMw0OcUH7J9UyJMpdw/4kul9RL/yd8gUnmplQGXRPMXhMOVZHrC1GRFE4uS5DgkXCYnvtqyIDXztMof+F7WGnwc/4h9zUtwaYuiRrz5By9N7Bj/l370v64zMHNaBQdtNlr4ddDWUgmivFcHGUzq40hl33C6kNRvcZdKKdcvQ5z79aPSze9YWXX0iHeLEGQ32oCKlfjz850q2nrUjqkQaEJIyBSV/XhzxWaIkkZCf6bkSo+u6HOe3j0yt048A00L5YLbNlDPx27PauLTGCRO+C1Vtcupg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(9686003)(5660300002)(64756008)(66446008)(478600001)(186003)(66556008)(66946007)(52536014)(66476007)(7696005)(33656002)(76116006)(54906003)(316002)(110136005)(107886003)(86362001)(4326008)(71200400001)(8676002)(6506007)(53546011)(2906002)(55016002)(8936002)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PMeZRYm2DENGERgPXwvNmI5QSJ1v0uL9TmFUAXHB0adcU2lq4cogiXuddQuqDS0N+R78H0sb0niYHqn9NeufVYReG/zFoOY1ne8sind6iQeU0EBZQjcV9+6P2DI11ixOTun7IaJDLYKpHjWaSGB/gQar1vvW5HJVMfbxjLmxp0eSvd3AMk19WkbIrhcdm1ioAgLmZyL41jaL0sVyrC1d9jE6tAn3WWqmr7f4bRXrWhkJddswLtzDchCWjojial9G9ZVbTavs8mOtebihyhYo77LlsT5obo8DU9dP1vvTj79wDAuq9sC4BuFY2hj4G/cQ7gin3OdM6SjKUlUNFQMG5eo7iFDUI1SS5IwRIoJf8J35YgzmlFMjOlU4MczPoYpIYA0suR7QQxll6Qs8Q3OmKOrBjvB9CEyxG6cHt3466AyzSEh1pz6uTvIN9/Y7OAaRabXwwNuLxg1pjpgfWj9paAOhK9B+v5QPeL312to/SOp2F/Alal2I3eUhtbTVcWpqczj/kbTIMokSLISZUKSqe7uIW9ajk+jtbT3VC725W532hH5XVmW65iWGdTJUhA6QaIRdJPeqEWADgrNrKWpk0tAwAc6v5I1HEBRP6WpqcBtrg5exzlOWYUFMOGLVoqjdxB0ah5bJCg7ut3v3CcZffQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 277a48e1-870b-4327-f71e-08d86efcfa48
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 22:20:08.1495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QtwGnE4rcd/fWjGUZRV1eifw/crnG5kfmWTfw8baHx2pzqXLoVWQiYkgqN0qH5LRzu0Nf+CxBc3IbDGyamqRnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2649
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Stefan Assmann
> Sent: Wednesday, September 9, 2020 1:22 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; Yang, Lihong <lihong.yang@intel.com>;
> sassmann@kpanic.de
> Subject: [PATCH] i40e: report correct VF link speed when link state is se=
t to
> enable
>=20
> When the virtual link state was set to "enable" ethtool would report
> link speed as 40000Mb/s regardless of the underlying device.
> Report the correct link speed.
>=20
> Example from a XXV710 NIC.
> Before:
> $ ip link set ens3f0 vf 0 state auto
> $  ethtool enp8s2 | grep Speed
>         Speed: 25000Mb/s
> $ ip link set ens3f0 vf 0 state enable
> $ ethtool enp8s2 | grep Speed
>         Speed: 40000Mb/s
> After:
> $ ip link set ens3f0 vf 0 state auto
> $  ethtool enp8s2 | grep Speed
>         Speed: 25000Mb/s
> $ ip link set ens3f0 vf 0 state enable
> $ ethtool enp8s2 | grep Speed
>         Speed: 25000Mb/s
>=20
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>

