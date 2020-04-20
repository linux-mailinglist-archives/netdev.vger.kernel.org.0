Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A1C1B170F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgDTU1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:27:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:58735 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTU1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 16:27:44 -0400
IronPort-SDR: HpECctyJuHToKaYf+LrjpHWA4vyt3whEAYnA65yzV4dm5fRmGAMeszfPncpbVmRmMwDyd3+v6l
 9UOcul7pEiQg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 13:27:43 -0700
IronPort-SDR: tVLifL0TMehNj1g431MDsXUpEasX5cgYZXC1emapeqha5wEeB37vX/r5pIf2nHANdmTnkSbrx3
 irWPEl3DqFQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="245478792"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2020 13:27:42 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 13:27:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 13:27:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vy2CtMogI0RgLdIhkRCw+As/8gYfbr6FxxEzffYnnKjEljwZ3VE1H9AbR7EmhE6lYM+2beq3pJjWc41e8RXWA0Xw+WPJ7xU3Kujv7nXdjKFvBLZDQ/wGZtnJzI0obQYx5zEk/rgH03rrB4JnCIJe8JPWPO3DQWAp56Uf2Q6GbFHEPNlOv9+H+s2zmOM3u+Tw6SgY7hX7xX4KLAc6K/qtg1bj2oTYMQlp/EYLK5DJObVptn0+KgLqFgml74Zg2JIlEujQQQcrEloh18pWMOzfO94WTPuUseCEmw6/SxrNuPOFbwsRlh6miWCSLRqrFLXEetPeB0enuczf0aR0hCxf7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTaBsf8cC9KkazSh/ne37W484wpbAWQUNs/le6U4ipo=;
 b=kAivCaCwnsSOfdmoPOo7TSrYMuAOdazXGhzdJe17Rrdr3tb6+2UczVOEmdkq7LwnhnGIA+qOW/cV49Mmu7JAn7wIvnVo/nlxD35O7A1GmXU9PLxWM+0Bgg3HCze2klksbmKk5kP9U6jnozqX0ruCMLREzbLP/rvo8hdkwM2Oraa8EEE0cpbO9gfoeW7etr7CK/tpFUSN8mVhu7kGtQ/RdJ9QnONXZp3iYtSzAa9Gk3NYirGBib/Je0ROkF59jOi2scPaTZZ4NC8gtRkwDsni4XTh2CkGyHWrH0KDsIEenWHpSgOQHZXv1I9gTEx+wVVFXIMzRmrD7/Jst3qV5TtDMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTaBsf8cC9KkazSh/ne37W484wpbAWQUNs/le6U4ipo=;
 b=zRKuZBkjt2vfEbciGM0wxb6vMXgiOjhzgl1fMvi3rTRZ9xPDRLN5WxD3ll8q2hT+KmPTiDpmFzaMYYe5Sh+9SAy1Lu1wQbkwyidneSODSnyRdcaRZgqlV0X4DMmuyKPnrbUkCf61J/42B4Pfs3PEq4TKl2slRKLSqUCsYyhrE8s=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB3771.namprd11.prod.outlook.com (2603:10b6:5:13f::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.27; Mon, 20 Apr 2020 20:27:39 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 20:27:39 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH 1/1] e1000e: Disable s0ix flow for X1
 Carbon 7th
Thread-Topic: [Intel-wired-lan] [PATCH 1/1] e1000e: Disable s0ix flow for X1
 Carbon 7th
Thread-Index: AQHV/a8PVM8h+1P/RkaXQ/UmmFEy2KiCqHcQ
Date:   Mon, 20 Apr 2020 20:27:39 +0000
Message-ID: <DM6PR11MB2890E32FBCE91DF33D252087BCD40@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200319052629.7282-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200319052629.7282-1-kai.heng.feng@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=aaron.f.brown@intel.com; 
x-originating-ip: [192.55.52.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b63364b4-465b-4b2f-322a-08d7e5694581
x-ms-traffictypediagnostic: DM6PR11MB3771:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3771E122F38C33F1CA6DE90EBCD40@DM6PR11MB3771.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(376002)(396003)(39860400002)(366004)(136003)(81156014)(8676002)(52536014)(55016002)(9686003)(8936002)(66556008)(66476007)(66446008)(66946007)(64756008)(316002)(86362001)(76116006)(2906002)(4744005)(966005)(5660300002)(478600001)(4326008)(26005)(53546011)(6506007)(33656002)(7696005)(6636002)(186003)(54906003)(71200400001)(110136005)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xpmWH2HboTeUv1DR/3zfzXWx7ZQbJshA/XX8wExfCxRMzcC5p9I+0XA1JuTSTO/Qxzar0IjA8w1GB481+NB1CoUpq7uBXvqfsnk7ZcIzvm1gHtYdS7+JZBSdESMLoUjeFQogkxL99pZXw35w/5FGEQca4souPbpf1Jdw9XbynnPlnCvwFGeF6eizd+nZ4kc++XvEYdj2HCG0Z6JZxrOCvzZ51XFhSikS2BoTvYUDbTXDzynh5nOtF/2lLh11sNLoa/zxWcj5hUaKLlGLQJQUwxBtqHdYTaodXTgcHi9a3bZvK2yTpMCcznNN+HnkT96hlg9CojeL666tNKvil7lKwJcksFvhDd+0vUPves9rW0Ne+Q1CenRfP8M0nMi1dXEJGJXsT8C52F0ECx9gMy63u10aT3Clx+KoA8RXBtQLWXxlvbyFGYeYPrMQpKjygyA09EP3N3iLjeEXZ4uWisgSaYVCGuzOkrixkNTDCreF2N+/UODbLMfRqWrCGssWri29WYWRmohtl7ico5b7f6732q2LE7spulbYrZ41NX7prP3EO5+C2xHQhANzbLArlVcW
x-ms-exchange-antispam-messagedata: fSkbC9muQIRXx+PFg46mWBCAiPijDWejiIrDcVNfw38xLn9ISWqBnxxm7KrMOCX098RTCjcOz9gjcdnwenkU+av5wASBa9Y1qCRfBJ0KY25kg6Xfigohw1X+aG+t/iftzi6xVVMiB8ep44/4nZNolQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b63364b4-465b-4b2f-322a-08d7e5694581
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 20:27:39.5746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jv4OYtQfeb9M9zHAm81IuXU9kf3/fDbovrE62YapY88vvNbPhg1SjpBS4jvPb2qiPx45OfgbinLrUlVEHMoD6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3771
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of K=
ai-
> Heng Feng
> Sent: Wednesday, March 18, 2020 10:26 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: open list:NETWORKING DRIVERS <netdev@vger.kernel.org>; Kai-Heng Feng
> <kai.heng.feng@canonical.com>; moderated list:INTEL ETHERNET DRIVERS
> <intel-wired-lan@lists.osuosl.org>; David S. Miller <davem@davemloft.net>=
;
> open list <linux-kernel@vger.kernel.org>
> Subject: [Intel-wired-lan] [PATCH 1/1] e1000e: Disable s0ix flow for X1 C=
arbon
> 7th
>=20
> The s0ix flow makes X1 Carbon 7th can only run S2Idle for only once.
>=20
> Temporarily disable it until Intel found a solution.
>=20
> Link: https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-
> 20200316/019222.html
> BugLink: https://bugs.launchpad.net/bugs/1865570
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)

I do not have access to the "X1 Carbon 7th" this patch targets, but from a =
regression perspective against a number of other e1000e based parts:
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
