Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3D220A393
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406574AbgFYRE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:04:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:22034 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406413AbgFYRE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 13:04:27 -0400
IronPort-SDR: 5omGOTWz0L8L67ELw18lQ1FpZaInqYlfXofoLPnkdmPR/r/m2OyaBxOZ5Og3QR8HQvewI/pwo4
 J5h9r1/Ejd9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="124633609"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="124633609"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 10:04:25 -0700
IronPort-SDR: hWXY3jfWxPZj4y5971Rl2jqzH+jLwvk18q8vFhyxGN0cJdAHfvG5u2QLpm4dfMp0YKx2mcEByO
 R7+k6nlAp0DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="385524376"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga001.fm.intel.com with ESMTP; 25 Jun 2020 10:04:25 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jun 2020 10:04:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 25 Jun 2020 10:04:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLXMZn9hxqYa2Cm4UcBMKHCd/LhsorUtfdgNjwcgdsddXXnchj+NCsp2/K4YX6jHdILF+4DXrkPnBdNLCMCq3o0sSg+DQErK4j4G1ncXzF4LmvEM51p6qpuN/NfPteGj2h8YbkfIWPNkMK47Pn9CTD3E/hNBpy19Kggy+SdATdfiRFTYnt4C0CUiD40YCUhamnjL9rbkxLe9aNBF2I8n2aUHh6eH/E22I4PDpLdHfUoGy4tjK1ajJzzax0h2iSHnJqoUlO7/ISnIvAjiMwwJRAn//Jmq6G8EQMSACBOc0GsZ8vMncQ92QSpuHRhle0rAAY2JeNEnZBvfdOqWbC6hNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRKdXEWWnuBLIs5MooQsgFtsLDmYHI6Gdd5rnha1Ygw=;
 b=mueL5t251RtVX7kn83hycbrVrFBIbst9cWOuYN+tAHcG5rwJrSkpAMr1/aDhLIcouhjRLNQWRAmuXaDiMVk/5sgK3I2+f0DLR7ypul5ynQsFJY9phAoiJnj5+tCA2AYNCRzAvqlZsAqKI9KoBKgkarNibgGLRHIWeh4LmT6ptV6uSEV4+0EdrDrGNe9JKvTGHWr964pAoIiK67SxSkTZsXGxBaFWVXZiJ2JetKmnlE+cqSgVB8Y90v4emyRC4Kx/h3n3AFehQEv9wqWwC3mS0/0zZ8WZijJs9UJQl9Utr7KLGkJuVQjXWHnov9ISgY3ZysXXJCrPxVe4ZaKGy/k8Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRKdXEWWnuBLIs5MooQsgFtsLDmYHI6Gdd5rnha1Ygw=;
 b=yKn/UYmy6iUWJk9cnWjDYYnn7dHYR+JG3PXmzujCsFVn2sog9gYDJE1Mq89P43/BImV1RkJlA0LpEMtiAC/ZtpkoHGpSt/YhO7PwSlginu8aTmxK0CWH9KXlCfGm8usI4Kl8hBXfaDcmwbRnSy8P07YJeiCef80X8OSd7Adi6Ng=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN6PR11MB1700.namprd11.prod.outlook.com
 (2603:10b6:404:47::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 17:04:23 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 17:04:23 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 3/3] i40e: move check of
 full Tx ring to outside of send loop
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 3/3] i40e: move check of
 full Tx ring to outside of send loop
Thread-Index: AQHWSULvquXirsrXPkuc0QV7kgCXP6jpkrZA
Date:   Thu, 25 Jun 2020 17:04:23 +0000
Message-ID: <BN6PR1101MB2145E97EE9FE44B7BA49F75D8C920@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <1592905458-850-1-git-send-email-magnus.karlsson@intel.com>
 <1592905458-850-4-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1592905458-850-4-git-send-email-magnus.karlsson@intel.com>
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
x-ms-office365-filtering-correlation-id: 13478923-4bc6-4b00-238a-08d81929cf84
x-ms-traffictypediagnostic: BN6PR11MB1700:
x-microsoft-antispam-prvs: <BN6PR11MB1700741A22834BF0A880A7C38C920@BN6PR11MB1700.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: toylwgBjN0xy+L0/BYW1sCD9aku5VFm9RYWEddvEVoGZAPXqrIO8qAUyy2ZpqLvicS3JN43v/TNaZNorQ+aDnIeqyZTJ675utLTz/ML5L8DcUIQEwaXzW2KskrjAVAUa0hBoFatv6O2n6lyLcqhpcGSHLPx5yGhoswAwexX3kwcCvt3vlzttnhmOTNmJ8N2GHPvWe0yeZ2Vo0NbORcGiM8rWzIVmHlpcv7VmjG6lCKCqkPHB7jCEMZM+1WIm0p6PEV6uRX7BBUOiAsTVZUZbRGBgKiBjkISAaxY4TbrVPViquFBihDTbtDAFTK/7Vdy2YWDDuxUf8fHZ+64/NzMmhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(64756008)(66446008)(66556008)(71200400001)(33656002)(4326008)(83380400001)(26005)(6506007)(53546011)(7696005)(478600001)(186003)(2906002)(66946007)(8936002)(316002)(52536014)(9686003)(6916009)(8676002)(66476007)(86362001)(5660300002)(55016002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Heq3w6nCks5d6Pp8fp4HQyhy9/QBIzdnAabQYwgq3Sr8nrvz/Yikj9xz6NvD7104Zlx+9yRte4uOnX+zulJTFCFRU9OwFSxJaiF33KeuuuTbdklUYtm8cMXzr/ooGcN5bKY5qTKYnTdoEjvbIy0SWoE053hcBV0q7tK0uFo1Q67SyX0y8NDjN12GBnO1hIE1vW/KfXNfGOpT+pUcvYVGDWftLOlt/k2ZuiiOyWNsuzshKisv0NdikpO71aSXoahFvm5NvMr5Vv++ibSpuYbDm7ngHwINFv4iLCwnbYmA0hN6tFDQ9nPQr8ADnVMqX8o6iZa10rRBnPCuKlclYtvhQknGBUgdgZA7B2pBTwwrLnB7kR7G/lCeou4v2E2vZIVU+9KztbZLTakACKMml+4cyc/29l/8Q9I3zmgSfPy8QDj8goyDKHlfZ78QYQBFrPHrmJkDizCXDGqbhWuIqXPyFQ0DgpRTPSN7GeDac/n85rE7Bt6nyiUyT9ZiJgQuEOTy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13478923-4bc6-4b00-238a-08d81929cf84
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 17:04:23.7812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bAvveotTrt8h3nX0Zrbj1Vil+viLJTXqyNyU8XYpW/MmMenH6wEfBwSiRL1Fydea6A2rY3N/0h+EKehwPa6dZWSBcp20Bj+QnhRdd2hENvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1700
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Magnus Karlsson
> Sent: Tuesday, June 23, 2020 2:44 AM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn
> <bjorn.topel@intel.com>; intel-wired-lan@lists.osuosl.org; Kirsher, Jeffr=
ey T
> <jeffrey.t.kirsher@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Cc: maciejromanfijalkowski@gmail.com; Fijalkowski, Maciej
> <maciej.fijalkowski@intel.com>; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next v2 3/3] i40e: move check of fu=
ll Tx
> ring to outside of send loop
>=20
> Move the check if the Hw Tx ring is full to outside the send loop. Curren=
tly it
> is checked for every single descriptor that we send. Instead, tell the se=
nd
> loop to only process a maximum number of packets equal to the number of
> available slots in the Tx ring. This way, we can remove the check inside =
the
> send loop to and gain some performance.
>=20
> Suggested-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


