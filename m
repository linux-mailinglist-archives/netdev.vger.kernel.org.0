Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FFE471413
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 14:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhLKNv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 08:51:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:29344 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhLKNv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 08:51:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639230718; x=1670766718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pvEr81TQcHTgmwn1EZGOyqNqF8VjbiJVmkE5Ck64gek=;
  b=SY1xZsme+iJJ1sHImWIwXgSESY1Fc+ddLN6rHf/vmXey23Zy1TJMF7ky
   7bItCntOEeFVIyRwT/3j7ZTfOimLXWZHmXyFkceLvCyhVK+P9O2xW8Yvm
   Rk/qRaX7EXDbG7tU8Sqthg9DKjIo5MBgqolPFVkiEeZjq5UCGRR+t96Hc
   b5YKvAIBZ3JPjRsz7bvETnYKncGWPWAr0wA840kFws4P0wEfQF0hbEflh
   62lqh2pFemnMY06kLs685j9ST/vAhzATG8zOnRnoGe1X+vWJhhkx7vqpR
   NLKgurbdKmZBlkELH4kQ6mg9FjfPLDt2Bnd6TzNrf8MF/cQKWDPRLxapy
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="237269445"
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="237269445"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2021 05:51:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="602512617"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Dec 2021 05:51:58 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 05:51:57 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 05:51:57 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sat, 11 Dec 2021 05:51:57 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sat, 11 Dec 2021 05:51:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcKtXegnhsPfBrmm1eYRkYoJYkX2jayeiIkuGrm+cAO9zSFQbZPvCSrfmCuoLp2aaUONHVUNzHNRd08LESo7PbVy2GIM1gt3cBAjKbV0PZuDyUQZGNrQv5U6wEltqhzSqS+YEmou9q6riWubiQUfxWEaMwyZGlvKhzXrNHLIqB2ZCPJp4qF5bu1GitGXMYHLC2qFSQW/pRfmyJrilqZUiUTcyZRpkNfbUn6fcFsG/g3pC10PRdkVFXKeaiEwbJvrkhUH4D9/vvygNmLCBdWjfWFC7VOTl8npXvJntCAFYjKH/MLTEHOA9IzF49PNeNrQ7BA0xLOPuUE2KUylUyWWsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvEr81TQcHTgmwn1EZGOyqNqF8VjbiJVmkE5Ck64gek=;
 b=Nd5yLECMMpoVfJAzYuG61wiVF5lGgRTwNvBL/BpBBGZLW510qC0tQl7DEks2FUsWMednxHSXIgy32DyR/yyVZg4SZftygWsNXbHeP6FW9KYN/dBgtjSBV7QimsVT9REDAmB8HY6n65+m8FUWqoS0j06aI30775OPXaV+vr+hnb2HuSdOerCySHLaCdrHQuyc00e5BVODwwf5QCWr/yhMO7lBrJnE5Hw53kKovkF0S/Y/BwCrt+OdtBerE4oSZ30WQxZ479TbBA8XibCOMXlxBBrHXsbnU2jJxi1YmmDfcorvvkVOKwodRdjehYq4mlq2Uz6NCbVW11fl31ZmT8vMyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvEr81TQcHTgmwn1EZGOyqNqF8VjbiJVmkE5Ck64gek=;
 b=D+mryS56P28k0ZIgyzDwy+Un+ncwrLPN+OWPU2tDRZn13KSTt0IF5mCW/GEHYIYcGxjrUQ/N6im2iGKDzauHPeNs5onscFIjCXDMz+r+CfXuPYnH5emUDw1+qA3giraefBb+01ARpJ2UnigM8hVueDDmJYeB3pwdEghcUfthXKQ=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB3004.namprd11.prod.outlook.com (2603:10b6:5:67::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.16; Sat, 11 Dec 2021 13:51:50 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d%4]) with mapi id 15.20.4755.026; Sat, 11 Dec 2021
 13:51:50 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     "Kanzenbach, Kurt" <kurt.kanzenbach@linutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: RE: [PATCH net-next 1/2] net: stmmac: fix tc flower deletion for VLAN
 priority Rx steering
Thread-Topic: [PATCH net-next 1/2] net: stmmac: fix tc flower deletion for
 VLAN priority Rx steering
Thread-Index: AQHX7RBbS77e6pkAekizP9E4vauzMqwrdbWAgAHbyHA=
Date:   Sat, 11 Dec 2021 13:51:50 +0000
Message-ID: <DM6PR11MB27809EA3B9840D49F3377B8CCA729@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
 <20211209151631.138326-2-boon.leong.ong@intel.com> <87lf0szu8y.fsf@kurt>
In-Reply-To: <87lf0szu8y.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76e7507d-618d-45bc-9e47-08d9bcad61d9
x-ms-traffictypediagnostic: DM6PR11MB3004:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB3004FC6B389B3F4DA7F57A61CA729@DM6PR11MB3004.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P1cJE+nGzUldXc4mVdBQX/S31iCIIcLaBzuy8YpkJEcRYjSRrWUG6+raHx34eqGsNmSkPqVDTH+G04uAbhbHByW/6ERxpzB1EG0qFulneCy5sqhjpiU8dnB+aOcgcJxd1nf4ccXSGH9psmYAG2AETYvXkpLfUIP4xXTq0oqWp4jTLwtzKV29D3oNMLAkrbuVQ9g2NEzZnHLrzVkPHMYyvKxGLwMX2Yrd1kB27gJiRhJjs7a3HvDzdPY72eDB+FCbcaI5R6vVodc1VbDvF57qiNRijxl2ULN7rOfLnzK5UdGioQIE4q4cSBFsyHVjh5E8kryGHm7Kkfv1qRqoGMsg8uDnmrjFDO3DyZbvTEH1PJq+0ZlmK7/2CtqBlOP3pyRZOXLorG8pnR90oofNttcNtXPOs30DFJ+IstlDbc8VzSzkoqTztgdEIL9Fvf8vyK1xZIV4fo61dVWyKBkvktA/JxOPg0R91ZqZLzV24Fxqpg8RDv3SIc+5H7lMXFjoQsnCWEMOy1SF2AXEh18rd9S4nq8x9XetKmIrBVY0gaLN7U/jCEIda/fARoHjZ5OqynPr1tVt8BrkPeJ6ird6jZiIl6cvptEWnwKl8QR4odoFbWzrqO4U/HE9lEWSyqUU8ZhiklX3KFt7Hl6qESWzlodV9uv3/YIAVSf7Ia1tREDAYqvQwfQ/SbayT1ob8wQ5ioxoVBPJYkCZjkoa6/oRvDBPlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(55016003)(316002)(122000001)(8936002)(71200400001)(54906003)(4326008)(66946007)(26005)(110136005)(66476007)(76116006)(8676002)(508600001)(64756008)(66446008)(4744005)(33656002)(7416002)(82960400001)(5660300002)(52536014)(7696005)(6506007)(86362001)(9686003)(2906002)(38100700002)(38070700005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NxBM8k8zKGBFU3K7IE89Pow5JZo7BvSEOdKtz7hvJkJ0i/zRHIa6L3x3PHdS?=
 =?us-ascii?Q?DFRkDKvjIebkjlEsnv5Cg4KvEPaRRhss0Kjd4lH96FXbS8tL8bqXvn8F2lgt?=
 =?us-ascii?Q?O30j3/P5DMpqHFMsoYPalGV+nI1oeObDZVUz72tL2uJeIuYBBlqvHOyLLZDd?=
 =?us-ascii?Q?vVIb97UJpqPx6CMEmCzcLT7R6YRfWJ85ECwYGdsbHPALOzP8yqfbbj9hVBzV?=
 =?us-ascii?Q?wW2MgfOgL0YJWPLoknmD0vaNc+b3XkloNdxB0/hOuwD9VYSJywND1oiSwLZ3?=
 =?us-ascii?Q?/d4SmgrPXI2RGe7RlwPyZzn82Ye50qiiejvwGZ68fLjmNjCothLBIalF36P1?=
 =?us-ascii?Q?7t5C/MYMIQAG9IjSmE658VGHEc3cNYvKu1Nk86wCRUWlttDFo0O1CGZzqQvK?=
 =?us-ascii?Q?9LK3hluxPbVNo7H+yVZCrFTRvdkya7yIegr32gvCMygGzobImCBDpSHxzrQe?=
 =?us-ascii?Q?yJCiEYvpBR+ODsU+7vRWk17eYbZRBHgY31k3z3O/ZWRkM5TUWGxwnypZJVVa?=
 =?us-ascii?Q?WMR/SnSCPG+cQQgxxj2SMQqVe7RVqBwov++Zu2qETQUXwLvQZARIIBg4ynfc?=
 =?us-ascii?Q?DjyKX5o8D/qfxQtnvnjeNJWlo18KHa8anHaWtk+GJR6odqjy04FXvNAnlhtz?=
 =?us-ascii?Q?lVmp+jN79+4gJh2PFcIDDZetNj6Tmi/moMevyCwmv7gsj/5VPI0zQr+54rN2?=
 =?us-ascii?Q?g7H1A6gutK7dxZQ3BSzYqhSAUKRISNQ6SlmZ20TgiYfAFLvuDAYspOH+dnRb?=
 =?us-ascii?Q?29n8buXUiTvvbaKJ1b7ogeFAxSXE0Ciuontsu08Mxo+zuWIfSDW3yYIp8T88?=
 =?us-ascii?Q?8VAiVlZ71CmNtuSxXZRrxs5bmBIjIYh9voEK81xSVopqSX1lDsPUd+c9pnyy?=
 =?us-ascii?Q?ETp2taq70+f3yNenXD5cZ4eN00Kp4thql0NSdEVNo2NDcbHoRs2EtEdpPqoL?=
 =?us-ascii?Q?+iaDU8xOb63hRRBM9UEHEyZP+Yjpc2gTbMC36Ua/CcXcpaE4MShgATx6RYbW?=
 =?us-ascii?Q?YY2/jNZPqjxvHhpN0+7MFaym1j3wXNsrBj8HWgsYTjtcD/xxhpewvoi8hxp4?=
 =?us-ascii?Q?t47dfNY2tjDO2yIBnsXidqD54OKJU0L63Jvyeaj8OlJDmXEu/hD3xJ2mGYdr?=
 =?us-ascii?Q?Mf5PkaoSystSvF3J01roJRvIq2zlVi0+ETi9+6eKmuEHQyrK2EkDIxwLN/kE?=
 =?us-ascii?Q?GP/h0T2wEdOUZAFYZKSyMVelf+p2jt5ZzKxlemTm1JeBDH5fGMD+iGbXIiau?=
 =?us-ascii?Q?nnC3rlRAi5UFFkoXOqsXKcsRRb3xluXDeXE7eE6bCa/bug/0Ke2eN+cQTVxM?=
 =?us-ascii?Q?v0ubItgU52KIQDwFuDxzBm9AERRaTwsm7aMX05X0aI3p6Kl5jVwKOkNBVaHL?=
 =?us-ascii?Q?c+H8j+7wbAuLqoCUk0Oz9i6j9lEMhNsv6/Yr46BUuxx8QJwovy6KiYFEOeMJ?=
 =?us-ascii?Q?gW6ZATrkWf74CiHUvUW6kje5KKMassA3Z70BTvwW7k6Um1fAECbx7E+iWCka?=
 =?us-ascii?Q?QDudY0YeRGhktfr6WnBifH81o3yxLoZqAcyzzVIF7fEwI1JyF/mUd0x3jsol?=
 =?us-ascii?Q?wJToAzll75E2HU/WSO39EufmKcTncM00Moi7orcTCsRLZLa6HiwXS2oqxsmT?=
 =?us-ascii?Q?QprqKs/C4Jw0naBvwnDH9sRsUT+bweIGLJB6/UtNMwcZobeCeqJ9yUVJk143?=
 =?us-ascii?Q?rb0ajg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e7507d-618d-45bc-9e47-08d9bcad61d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2021 13:51:50.5870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1i5m6mFZ04Xke0fscsEitDErUvZduqa/jsUvu18wm3DqVOwODTn2uPJX1smvCfHVUAdwRmvp07yF+x8V+VIiZA9PhBRL4nWg+4htPMM9FEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3004
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>You submitted this patch to net as well. I guess, it should be merged to
>net. After net is merged into net-next we can proceed with the EtherType
>steering?
=20
Yes, my intention is to make sure anyone who wants to the EthType steering
will be aware of this patch. That is why I am sending the patch in both=20
net and net-next with a cover letter to inform about the dependency.
