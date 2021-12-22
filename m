Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8CB47CC07
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 05:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbhLVETY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 23:19:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:2038 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242328AbhLVETX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 23:19:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640146763; x=1671682763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cGC1vGvG3mhWot5plY0H9Y7GuGsHzarJ9Yp+cJLXk/8=;
  b=Or0Mjb6Gqq8h/zCbONQzNU6fvtdUPqCVoTGmr4yhmfcmpQcxLZWrDwoh
   /i8Iu1bMTMoXbGJlGqOZmRk9Abs12ZAmHjsyPRIA7re74vbdZ/dcnCKge
   maCSLvaeGxR69c8St/jxEs+AQop+c/jfd1UXBdn61f+lh92YGv+FIKWju
   JcJA5Lx9Ezno+YimLxwR46QZG0dn1Cji9uIXZr7r67WnrCy3pWh9xSSBN
   YfF++4UBcZlxmh9IY38PxfCP8+K8nYeOR9rKz9/v6ut687z8RdgbTJqQ0
   JlmuUusaGdTCq5boiDThH15BVOmPDxs6v5tplHr3w4tnhg72t3TdRTdSN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240766752"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="240766752"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 20:19:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="617002323"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 21 Dec 2021 20:19:22 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 20:19:22 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 20:19:22 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 20:19:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpivK02MjxwoRnMUsn5s5YcJ0/ebVdMT2AtMM97Z6iky6Ab9kwaFFS6EEXFA8t5oAJFN2avCpQfsxnasjLjgJwkEInq+r6yWhrrNF6B1ofD/+4/xal9TuwIHlvpm3UI3zUqsyxTWjagTKqNuCxnnnxq3ZFgh1hQYMpKbUgRUyQ+nlTSWyHcpklO73f325VgrwkhfykibiBgCT1YhpZ6lHqP9Htf3PC6jWMgfXIBfdW7tkB4pinWVWLZLiHFTvTHKvzlOOixyeAhvTuj3CqHhI2eE/qlGHuprVN/m6DXL7ZQ8XSQ6oO7QNHV6/4SfsXuAHp0rQQnaH49DU92FjK1cuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxuUz9DiJcUAi47RjvGcK7hgc63p1MOh08bolpF/3iw=;
 b=VtNP2wL8LZyDmgNeG/hUGixLpCMNSqo6HF49TUEiyVcqn9YV4Sua9dr1SWloXweZcXPRaCl3XHTRWgXOs0CluGS3PQktNBsV0n8D4L4RxoMDHyo2rGXbOs6D0GF9aeqkM9h1bvc0M+BihbFe1+8n8rk7+Dsd1Z7pDF5J17aHUyJA/wDSTtw3/Cb9Qtvg76HG2kx/eBX7KV02f1MeIw2bVglqpkoPznF592tsMRhOpvjSQeSPDRm6/z8PNNZRO8xzVUvLHe+K7wb5k8PJC53hyQvCUgAG2JhCYmz4CUhQDMVwnZJvpFuqvOtSKpdJlIQos1MB04on2pIhRZ9gqKJZ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3574.namprd11.prod.outlook.com (2603:10b6:a03:b1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Wed, 22 Dec
 2021 04:19:20 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::bc02:db0b:b6b9:4b81]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::bc02:db0b:b6b9:4b81%5]) with mapi id 15.20.4801.020; Wed, 22 Dec 2021
 04:19:20 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Ruud Bos <kernel.hbk@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 2/4] igb: move PEROUT and
 EXTTS isr logic to separate functions
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 2/4] igb: move PEROUT and
 EXTTS isr logic to separate functions
Thread-Index: AQHXzAmYrMQJS5tjo0uSzn04JlDm2Kw+Pfyg
Date:   Wed, 22 Dec 2021 04:19:20 +0000
Message-ID: <BYAPR11MB3367641744302F850356B0F5FC7D9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211028143459.903439-1-kernel.hbk@gmail.com>
 <20211028143459.903439-3-kernel.hbk@gmail.com>
In-Reply-To: <20211028143459.903439-3-kernel.hbk@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 605fa98a-520e-4c6b-c3e6-08d9c5023a1c
x-ms-traffictypediagnostic: BYAPR11MB3574:EE_
x-microsoft-antispam-prvs: <BYAPR11MB35747D7BD10E3F9A0CA655B1FC7D9@BYAPR11MB3574.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h0Q6sCH9sqDTeqSi8oy+myP8khr+Noz8/iRoujaIRtV43ow2TivLbJOSZa6joTRJGV+hbcZA7DJDr/D8ZVSSUZ4q8+UygfeLFO3Hwxa74EFtMsHDfKQvZEchhB9YmHPro+O/j/J2teLs5IcX7lFFF/r8XYVRLDcV00C2bNWwwVwibbrDS1oKFc4r3s2cpKlqQ7/LS6TOq8a+e7OdJnmBLTYKfcs/Kq9/uVybQtbVlQBDkIJ6G/v0KxXpa3u0sgIedWpnAkZPpmq24zuBx5dMI6NRzR4ecJaA2EEQSd9C0ekDOxrydesG0Iy2kS6kzaq/psoKepOAciABW6elHcurEAT2Xsbmcp6nNrHnNzppMQxlsnhBn7Kn0cPRyGyAwuyJ/PwcEnuI70amS1nUNN/NaiWdvw24VYfKwJEeHoehHXHtXrvWmHQuthjtCweDy64HaqndR25x7U1Vc5SBAGMODIW6oIaNEiCihZR3kEPZ3TtI5ln3jMoITeXmQy8EukOAMYDxHKqPTvqXUuWRTtwXgtavsgM2TMS5ZXT113DSKvcccKr386bbrh/uy7emevrwYjV9dCtsvbisfQiCJamtPIcO2atirovnSf/L/yspPe7hk38wa4dDzwsF14O7e/5AkkZ80xrBYPapZFn/tt2FDNrzPa+rKQ7CMIkwMpTCBWU+tWUJjZVuxFH9Alo25/eFQdIEVXl+Qb8gUMnZe2behw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(26005)(4326008)(2906002)(53546011)(82960400001)(38070700005)(52536014)(316002)(6506007)(9686003)(110136005)(5660300002)(71200400001)(8676002)(7696005)(8936002)(76116006)(33656002)(66556008)(508600001)(38100700002)(66946007)(66446008)(64756008)(66476007)(86362001)(4744005)(55016003)(54906003)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BYbRFAZsWRXg1hhinZ01AqOf+2Dyqjcrc22l9qesMqWzHCuRqBKIQoQg6EMo?=
 =?us-ascii?Q?qOpLyuQgWj+iOgxye6ULpthuSkUp9siMpXE5tF7p4UepydKNVQcm5KnGTfDT?=
 =?us-ascii?Q?Dt+/2pMU1XjO0A0vWnO9u9q19gXGMjQ9Qb84ARZG9J8VCPceQdDBrz7NHixk?=
 =?us-ascii?Q?qMBLAQiv5+gkITlyP9l4tlSmvpRMVR8Ud9VT4+5ERPo50CTcoV9E14ZDik/T?=
 =?us-ascii?Q?b3vejPX3jTNFggN1vDz11AeRAnHHV4HT1qr7yyxPKWsnBAdflvZlL8aikd8S?=
 =?us-ascii?Q?NXi8nbOhLVOUtvCZupECHM5v9OO+ZZCcPj3hJ7XBpmJNrirF2lEwKyZOfYV4?=
 =?us-ascii?Q?ADvBRUs+GirscYaTr4+htuHIOkZk2jWPBOge0SFvFY6/91dfrTuWcozAy6ev?=
 =?us-ascii?Q?Jmxe30idVgpJaIDk0pjFWdrhL0N+l2DMWecNovGHEUZ1+bbJjEgjTCaYsBNW?=
 =?us-ascii?Q?0WwOsoLJDSuurGzLU8Q2AEFusyVPUzKDtR0+DVzZcPLKzI/mdvMwYXe2ff7N?=
 =?us-ascii?Q?j2HUivUch8yXqPvrJhQC6SaosbNhVUsehh9oiqgzkOlYM7E/AIDt3keVg4i5?=
 =?us-ascii?Q?IfQ9az8LnzVV7+cMne8wnOUFlJuFzOSke06+0Wn6TY0YrqLUw9aOsKyCLHZt?=
 =?us-ascii?Q?utMu9sEQKXKw+jG6xi7Z19XORyUW12Qg47gH8msrxmAQjU/Ezo781pZULCvE?=
 =?us-ascii?Q?e9cMpbFuUEQoLKSyL1Jb9j5oG+pN2lVp24dpN0kkHm9yT4f2BXdCUmy3qQ8J?=
 =?us-ascii?Q?u7tyFIJ2TAVaYuRvVjyqAOeh10IvJMxPFmDUFxi0wLW08ZFO4JV5pjimoFv0?=
 =?us-ascii?Q?10InionyIrHhW5PswakHsmYHl5wEjRuh+6pCGpUw4xDvBhg8cIVn5ZcMgUUS?=
 =?us-ascii?Q?jsXVlnhDzZs1n6SsN/sCvDJwamQsTt0TneIdfOvoMa+27hhZYr7cJXHYlcTa?=
 =?us-ascii?Q?x4mzW6bySypT0PvLvm8aZSZkpeqUgDHdyGzs8M5TNCUADsuhCNhqYqe6IKBz?=
 =?us-ascii?Q?9bvKeFrgNkahEjy8qtrV39doD05+MzN8519B1kjj8GeSoxZe8s8YU15SSCz4?=
 =?us-ascii?Q?PI+usGLxmyjG8lbebCtjN2DXzWCQ1rht/OghVKY5nmu0xf2VrjcgpDdel8qb?=
 =?us-ascii?Q?/pbzslsFxmftHzAUgopJeY2wwUVSLRZocdpmA5p/l8Wb82Dms7evpXBbIZsK?=
 =?us-ascii?Q?7FGRTgQNTKcfzScWWlBWOz988z2k5DfkDAEkf+JvVEyJOV6HpAW+YfivMiI8?=
 =?us-ascii?Q?Nn3IIWJ+DS3utPqXnTPOTRaPjSsyL3Q5zAYXmpcO+jd+i8lJai542X7F9KH1?=
 =?us-ascii?Q?t8lq6Zxcjct7w5X7GrCXwItOPPoNIS97mm4xJPVHUls6gt+pEDqhXFMR7WDq?=
 =?us-ascii?Q?ui7jqBQw/44O7zF2mUgIo+SM93HwnoSrE498NcPZd9yh5pw0mBPRyD22cy8G?=
 =?us-ascii?Q?nxiC4L5oTJC9cNJsUKO0chbTgn/jaXOgDq0IaNDI3WkgCJSzHlMb18MEUiuH?=
 =?us-ascii?Q?C+2hwppX5uMBfFzhQgPR+Mmak6M6UkS8eR6ndiuty9OV0aQ/wmdFLthJdiLm?=
 =?us-ascii?Q?1q2FtMllFcQnMtYfjP+0ERZwkkGA5vltaVE8qUUzdPbDYQxO/Uz9Bd9BG8xs?=
 =?us-ascii?Q?Eg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605fa98a-520e-4c6b-c3e6-08d9c5023a1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 04:19:20.4112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9S1XVNp1G+tnpGdh06C7ChKTHPOufMBHXHuR+IWug398S2p7A8MZ7yCs0ntt1+6T2PAdb4VsbvuFmqA+0QS4aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3574
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of R=
uud
> Bos
> Sent: Thursday, October 28, 2021 8:05 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; richardcochran@gmail.com; Ruud Bos
> <kernel.hbk@gmail.com>; davem@davemloft.net; kuba@kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next v2 2/4] igb: move PEROUT and E=
XTTS
> isr logic to separate functions
>=20
> Remove code duplication in the tsync interrupt handler function by moving=
 this
> logic to separate functions. This keeps the interrupt handler readable an=
d
> allows the new functions to be extended for adapter types other than i210=
.
>=20
> Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 81 +++++++++++++----------
>  1 file changed, 46 insertions(+), 35 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
