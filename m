Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB8F20A380
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406507AbgFYRB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:01:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:14808 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403979AbgFYRB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 13:01:58 -0400
IronPort-SDR: sYJzLJ2x6ktjrwLw9QEdnytYECGulIlnR+Ev/SHyEEW5Nqg2sD/sPy3F607SWtOd5eYL815kVp
 s/r17TtTTYtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="210075228"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="210075228"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 10:01:44 -0700
IronPort-SDR: BdMfqP0PmT8saGU2AU50ENSN0oQ0b7digXzJD4etY9AwHO15iWY1hUpd5aTWJKwJE5gYokBPX7
 INzpXjAegn4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="354523276"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga001.jf.intel.com with ESMTP; 25 Jun 2020 10:01:41 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jun 2020 10:01:40 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX113.amr.corp.intel.com (10.22.240.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jun 2020 10:01:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jun 2020 10:01:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HApyIbH3/VzqhR1SXlBBpeE8inbpk4WGqdB8WmHzKBqX97RE8MIbvioKZQsTsojXoUk1OHObkTn18pGj0jRnir168zYAk5LMyRPkAWotav6mQeCbIZnu4rEi4WuaqaYB+UmfSaAFIdT7Hh8BF7nqKE2bEJwrqorpFVYFoCeSS2eYFnnV3zsMIWzhyrLujufJGViI/Dq4jdyoQkUY2QaUxTPSfvbSKNjxUZnNNi+ZHhUozs1Hmh2sSO6TgfPx2z0qYM6bcLg+HvCKY0srFR5znhnm2YemDi0pixswzHPlwDxntfvA3sH6o66Up+maQSAmdS9/saazPEfqZYJ+5pqrhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIznqOFJe1Wn73vRtvt2GWkkBx6WqUEpn9K7wlUSSfo=;
 b=Fvhav7OuJmlmnLp3JbNpjA1y17m28FP8iiVwdDLIHHUfTR64Gr9CNOjwR1UYuOMp3AqLm0uszuhtymOJfw8TF2ObDFTAos9EWvb4803RCASTUJX222Vngrsvl4no4kQCET54nS7IssnXDN99wW1HN2TW07hL3Nk61igP0YwZiaTXSaOEb3fRsFuGvflCvuz6iLd3VMFQ5mGoSAOkarBz6eWHxmSqWW58KR9GUBhhr0aieXIalng3AhQJbo9dEkjzLuYJ3GuJXvdcsn/XO3nc0Gxz0lhQogy+h8Ac4V6IHYK3GkI0qquJrN1wdInpGCMKvpCCc+ZoF6HRunHD9hE/4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIznqOFJe1Wn73vRtvt2GWkkBx6WqUEpn9K7wlUSSfo=;
 b=MdXrPvZbu4+WzPFgQotLlWzxnaOgC6AlE7q2nf9Tn6ivjNLGzo763QvGC0A8vcaHiLfOYQTlxvBxHrfxgGrzKZmihBSbxlx0+me3C1fCF0toe3CgQLR9j9l0urMF1FX1MhnJSRlNnk5iA4SU5kIE6rtvds463+dYmWY1Qe8RXxk=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN8PR11MB3697.namprd11.prod.outlook.com
 (2603:10b6:408:8e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 17:01:37 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 17:01:37 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 2/3] i40e: add xdp ring
 statistics to dump vsi debug output
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 2/3] i40e: add xdp ring
 statistics to dump vsi debug output
Thread-Index: AQHWSWI4xSuS1iCawUOz8FE0kPRxy6jpkbmg
Date:   Thu, 25 Jun 2020 17:01:37 +0000
Message-ID: <BN6PR1101MB214566D9A528A8835E4476238C920@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200623130657.5668-1-ciara.loftus@intel.com>
 <20200623130657.5668-2-ciara.loftus@intel.com>
In-Reply-To: <20200623130657.5668-2-ciara.loftus@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0bc2911-dc53-4c13-5965-08d819296c30
x-ms-traffictypediagnostic: BN8PR11MB3697:
x-microsoft-antispam-prvs: <BN8PR11MB3697D67290D677847FEDEAC88C920@BN8PR11MB3697.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:473;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OHC9ZF7eAyqSSgIPwJzzAuotXHhusirwLyD0ZpeHk1W6oYvoqYMiPc7xaXLxu6noYwWbSSxoMcGmi/7hvHIM4MWaY1Ynof81RLSCoNswOFl5AgmUA40T+GX05vuCY647/DEoZCkWvKzeGn0vcE53Aw3bda3wDJPlO/aL8W3GWzuh0OX2mX2tn258+gFNj7wTbSmlKRCb1cNPvsie3OccI5UdFqs1IHqgA7yZtafZJ/IYo5SBofRSAeskpvyxycUl4T3oHPQbAWjjj/i2T8zebp5zN+lGGTHYz0i9hBg+mYPMW1t8eXMJ39EpqU60sNrO8BcWeVkYoqP+whFm5s2SQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(26005)(4326008)(52536014)(478600001)(53546011)(55016002)(6916009)(6506007)(8676002)(33656002)(9686003)(66446008)(71200400001)(76116006)(83380400001)(8936002)(316002)(66556008)(64756008)(2906002)(86362001)(186003)(5660300002)(66946007)(66476007)(7696005)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4AkaC5Fk0UKM4EwBtExxaHiQOY6PhXl/G3WAoE76UcJOzqSF/iy1ycLId+DlU+sf2KsA6CQGt6HeBzi6+q8L+OtTAhlO79y67kmmU5GpLcp5cb0appNcnBwWrErdfOxgaEsPnOwZulSzI9vVTcXrXKsuVtzgF5h/KnNdx5LJ7XAF2UbW2Ln4ZGjkAOGNAlYHlubyqJ86/KiTzT3dy3WlAs+v545KawTpXpatj33MDF2t67Z37sN5kAKRx5T6rkWS67LY0n1cbtFWnRSWbckj6Y046ZeH2NZSgKpjsFifa/JgSosdYwS+dkwIReU2tW+NP2/f35MNQEcXN9Vtb5FvYFxr7cPlCfpYXmpU2ChJgGyrAlMPkglBonkPDlMxh/oXajFYhyl866asUbgxl+XX7R5+OPKtXqc1+qTtRk56t8Qj6vfeV/z70Q+ST3DdkhD+13e5L9FGp9SnTWgCOxq0zkbv9r4GK0TFtzHvCyW3fpT1mlpFBD6KWGHwcJSBtbJu
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0bc2911-dc53-4c13-5965-08d819296c30
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 17:01:37.0987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TvdIJ1ACgzimYr0kr5R4uVICsrCJxsKZqxRo/jtHzsnEm1HYVC/1e6tn9nx2k3PbEp0nSBgdd+xoEzE3KLpH5aKRbKll9uGHvqePVEQwNRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3697
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Ciara Loftus
> Sent: Tuesday, June 23, 2020 6:07 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH net-next v2 2/3] i40e: add xdp ring sta=
tistics
> to dump vsi debug output
>=20
> Prior to this, only the rx and tx ring statistics were dumped. The xdp ri=
ng
> statistics are now dumped as well.
>=20
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  .../net/ethernet/intel/i40e/i40e_debugfs.c    | 41 +++++++++++++++++++
>  1 file changed, 41 insertions(+)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


