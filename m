Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6159B4F8C80
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbiDHCYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 22:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiDHCYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 22:24:11 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915E22B45BA;
        Thu,  7 Apr 2022 19:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649384528; x=1680920528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YmMKZ390+NzK0h9PLnMQGnDc9ELWqBacmVUyT9UjaNc=;
  b=Uk4Kq0xdAdCUnJAD+s360hnfj4DfbXk+4qedlVJNQuNaKde+bV7L/IC0
   VyMV4R7WlZOSiylJdMHqokskKLAkvsy8+kAd22M+WNhf9ZP4+Vp4rRmSX
   iXn5lcLzdTQ1VTOBVxwT6gRp6ZYNYUNwMDREFCGaQT5bcfPYAoOMlesv8
   dAqT31Ouqw1FM8a01EfenY04h3AmqbS7anhjT7gosn90jIMVfG6+OsYjN
   vhBtUtPRuKW+23UOP5vnZ7PSw4LSVpRFryl+1dMa/j9xTAdhQ/i0Sk/8h
   o6mUyb4XcfVE3B52sj1hljE5K5qf3+Yi1QGTw+xskZs5x9PCFQneL+/59
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="243624879"
X-IronPort-AV: E=Sophos;i="5.90,243,1643702400"; 
   d="scan'208";a="243624879"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 19:22:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,243,1643702400"; 
   d="scan'208";a="851909598"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 07 Apr 2022 19:22:06 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 19:22:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 7 Apr 2022 19:22:05 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 7 Apr 2022 19:22:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCpbPCmk+/7abOTH88DrJUTQNdHJTYpVvyRWqtDxF3lgmBG7Uyyhf1OunNDpATQeb81UvMTzhIvtaFEmroLnJ7DVQdbQFlcTG/lGvCc/vwT7WENzD6aCPJTFZ+8Lq4Xfm2rLUBnuuUvBPIhh6OIhSAEhIS5yzMErtBs3+b3tPt5HI1d4AIHtdEkHYKIu75C+xGzg0QJtk2Z1NhDy2gOutnoD+9Mw9hq+pY75vCU8zY6PlnMkcRUrKsccx5PtD5CVELdy/BM7BQ2fd3gI26t5AB35jnuEXnvyf53rUuNDEGyc/w6xzBasouH7+RcoOmvRNsRn1TZbpw6x6LlyoQBFrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmMKZ390+NzK0h9PLnMQGnDc9ELWqBacmVUyT9UjaNc=;
 b=H64uVWv84mg+4MQIAcrciHFtvcwgexuJ4aOLv+fC2+0WZWwKn6JvhaOLJysxK1f/Mxc/bxboSXXO0DvWqbQu1hkGbgjg1UUhzOkgzhixHQZ4ppiF0HM4MwOqW9sQGwDqhdUo968ZIdJnF7DtuXd3W9bq8hwDeMvLe9tFIzYaIaDHuxLZrQ26LXvsB9cVvRRH6x2vzfVInNUI3TlVDQ5bGKs5QaEEzrgrQ2C/b6lebXRV+3FwCBrLs4VkdPF/XsssoNuNgTbGuWtkiyaDk+fSHwhdERalAAM8NCpi5vbseMajCqmEo2qVrP2LLSPJbyRgAUknWgrQyo2+zvXk8DQCmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0029.namprd11.prod.outlook.com (2603:10b6:301:67::25)
 by CH2PR11MB4358.namprd11.prod.outlook.com (2603:10b6:610:39::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 02:21:59 +0000
Received: from MWHPR11MB0029.namprd11.prod.outlook.com
 ([fe80::ac0c:4806:934a:636c]) by MWHPR11MB0029.namprd11.prod.outlook.com
 ([fe80::ac0c:4806:934a:636c%6]) with mapi id 15.20.5123.025; Fri, 8 Apr 2022
 02:21:59 +0000
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     "duoming@zju.edu.cn" <duoming@zju.edu.cn>
CC:     Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jes@trained-monkey.org" <jes@trained-monkey.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hippi@sunsite.dk" <linux-hippi@sunsite.dk>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: RE: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
Thread-Topic: RE: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
Thread-Index: AQHYSkn4HJrzWeSt/0qrCBQuiFUlDqzkT6MAgAAY8oCAACnjAIAAHSXQgAB8/oCAABo6AA==
Date:   Fri, 8 Apr 2022 02:21:58 +0000
Message-ID: <MWHPR11MB00294A328036566B01917A5CE9E99@MWHPR11MB0029.namprd11.prod.outlook.com>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
 <20220407112455.GK3293@kadam>
 <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
 <20220407142908.GO12805@kadam>
 <MWHPR11MB00293D107510E728769874DFE9E69@MWHPR11MB0029.namprd11.prod.outlook.com>
 <7775f2d3.3fd15.18006994530.Coremail.duoming@zju.edu.cn>
In-Reply-To: <7775f2d3.3fd15.18006994530.Coremail.duoming@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3b9929a-92d9-4ebe-b9a8-08da19068f3d
x-ms-traffictypediagnostic: CH2PR11MB4358:EE_
x-microsoft-antispam-prvs: <CH2PR11MB4358F9236537F85A73F8F7AFE9E99@CH2PR11MB4358.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YBZ5MUWh5lXal+NOt06istpkQieGMR6GSiX1fH0qr6Y5Fl05I18rtgOPf12afa0nIfHvFL0DVOTzk6KZ6cKfoep2QQuj4tp7MjXVb0/eS4jr68jfLUL4PtTc+9sOceh5SjrmHHj0vFqmH3cBzx0aC56ZnW3yWuKBLjMElWR7pdAx1RDd5SG7emfB+lieEZ4rabvkz846w+Oh/aPVhUZmFcvEiohLOhYzas+21jdochP3l+u8IMQk3Zobv4jPUHoS/0MHICKMgKY6pB471rRri0fPT79WgTPEF21+0YnvcBGIef5zbhJs8fkjQb2xx8ddQLBGI0VBBf/VzdTWX/GUkWGHSpi7Axl+8obPnth7oT3IPXTmiLhkRV/4CafReaC16RypVpmYtj1cjJk4P740wY0rQ5AxiB183AUhCTJZnpjWfphD/K/yhR6zOrGnVtlVEFyidufJk37qNyVn0I2bdoKLn0RbzfQTlDGf6wtiMuwpOH/y7Pg0fczaSZ6pm5NrkMJko/hH6i4GsfDEfqXIsSQp51a6/cZYpRBsEkrE496nc9hoQyerEtUb+P7fRDW4fE+bHQ6SR8WjzKomQ9AF0BE7NcasMUwGPz8pcTsX5hOzxJRNvGnGeluoswmSv+wy0Y33/uB9mYC1IO1hfHqxPMZeaZGVgfBbdW86Ih1L1otHNpX84YCAonEvR36SlMl0LKa3QZEEvETzD8gd1Avw35M9Zqv/CSpixtBBsh831PuSQS9sW3aLXw32xDnM04Mice1AUs5MOjWeb8Eq9SYcSlcT3bZQplCs4CYvhqyiF4s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0029.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(508600001)(38070700005)(9686003)(2906002)(6506007)(7696005)(66446008)(64756008)(66556008)(8676002)(5660300002)(7416002)(4326008)(33656002)(76116006)(71200400001)(52536014)(66476007)(8936002)(86362001)(66946007)(6916009)(54906003)(26005)(186003)(316002)(122000001)(38100700002)(83380400001)(82960400001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXBCcnZqUWdFTVFER01iRjlZT2NWYjFlNFhkUXhUZG1xUXBuVlJQTWZjeWZu?=
 =?utf-8?B?dGRYTmRpaC9TSVlYZ1YwMVNzajJwcFFzbm12RnJBV1owc2djcnJFYWlKYU1B?=
 =?utf-8?B?QzlUbGRZSHJnVDdMdHM4WGF5UXpLNHJNSy9MK2JKVFh6SnJ2V0JpYjlsZlhI?=
 =?utf-8?B?NzgxaTdGNTc4MmlYTDdITVVZUE8yMElNOTlCSVN4MG84MVo4M3I4VkpFMTdT?=
 =?utf-8?B?eUdoSHNsbmh6clFteXROYVY4eUMrMXFJRzlGL1poeXlaclFwUDhmV1lvMDZQ?=
 =?utf-8?B?eUE3THFtczRvMXVYR0RuR0FsK1pZc3BCWHBFeUt5aS9KME42RjdwdVhEUVlW?=
 =?utf-8?B?UFQvbTdFWEhRc2xtcWJZdFBETWtMTW8xcTVmWHBBWEFMYTl1SVNYaHd0Tko4?=
 =?utf-8?B?Umw4a2tENnZDNXlYaVkwWjN4Z0pRa3B5ZytPQlB2bVkrNVdNYVJDN0RwRTZx?=
 =?utf-8?B?ajVZalJUdWl5Z2JZSDhxaUZydXBxOWEyUllPWGsyVkcxYkFjY3ZWWXZZTGFx?=
 =?utf-8?B?M2hOdUdIa1VWdUlNMkxqRDFnOFJESXZvY05lR05odmNLbTZUb3oxWU1oakNt?=
 =?utf-8?B?Znd4YXhtTWJxa3dVS1BvZS9ab0NDa2UwemxrZ1BQNWdpUlFxSFFHOEVhZUlZ?=
 =?utf-8?B?SXJMWHVSTEtaUHVibzVLUHNaUDZkazkvbkN3UjZqRzNHdTFzblU0MlVTRjlq?=
 =?utf-8?B?VEFrVzd6bEZRbzlIOHdFVkdkY1B4eEpPd0pJZlljaFVETFlJWXRzenhwZjJG?=
 =?utf-8?B?VmpFR2swTTMvditmUVVXMExLcHdleVl5WGExQnJpQllXbEdreTM1Q2thRFRM?=
 =?utf-8?B?Y205OHJWdXBMTlpJcEtzU2Z2enBZNTQ3UlBjbWh4SWpLek1yQU51OGtHRURW?=
 =?utf-8?B?cjNkTmdxYWVaWTBIdVJ6UXlXdmlYdVFYYmMwNUdhT0hjYlJySlFEeWRFaFF6?=
 =?utf-8?B?SlJpMWh0c0UxeElNQnhjYWR5enlobWhzeFRvcjc2RXdody9TaCtneDdJU1Y4?=
 =?utf-8?B?a2dQN3MzRUhlWFlwcUpaanYxbGZ6WUlVUm9jVnhxTjBzelpsU2tLOTg5eXJN?=
 =?utf-8?B?cmREMDg2WnVCZTk5UXdOd2lKVkFSYmVuSEM5Vk1KK1pKUXlLV25sMkxqa2Rq?=
 =?utf-8?B?akVpMW8wSVZ6RWh4SVA0dS90OHltcGZGbXJROVZad3VQdTdmRGJCaWlKV2p6?=
 =?utf-8?B?QlBtS0I1cEd5ZUJuWXZ4NVVlYWt6MEtuMWhkZm1VdW50ZUh3UUZaZXdyaUJ4?=
 =?utf-8?B?WVNWdWtuVlAvaFlGOG1vZWxNWHQyTE5pdXh5YWs2T2F1c1Y3UFpxZHpOczN3?=
 =?utf-8?B?OVFsLzJUUzgrV2duNnpwUmZXaFI2WWFPd2lQdEpzMm5pN282WnNmKzMrMnQ2?=
 =?utf-8?B?OEhlc3JaQVNTWFZZVTMwSnhZMk1JTjkxSkpnNit5RHYyVlRZNGRmOTMrREpq?=
 =?utf-8?B?UVBTZjZjdGNFOHJYTXh5WkZUMFdFSUNadGpSV1luV2dQMmdEaWlyeGhoaXQ2?=
 =?utf-8?B?cFQ2dHFQaFJidWhiSHMxbFVHc2p2QU9uT1lSL0ZqWVZSY1UwV0FnYktXeHFD?=
 =?utf-8?B?T1JYc0h6aVBFYjVJM2x4TCsxM1BVZjhGb1ZoTy9rRG5aUzF2bzZjbGoxSXZt?=
 =?utf-8?B?MHVCeHZaY2NOSUZTUVZLMUR1UnI2V1RyTU1WNlF5bzVYZW4rRmJveEN1Zm1i?=
 =?utf-8?B?Rk03K3p2WXlzTWtrUldFTkRDSENEVFNCNHRrNzF3UVdYaVFCNWh6cmNRNURv?=
 =?utf-8?B?cjAzckpva0Qyd2xzOEZOc2RhZHl0OGZIbTd3eE0yZjQza0k0d0dTclhZVlNE?=
 =?utf-8?B?MWVZeDlvdUF6NXJ2ZEZ0dVI0ckI4d0RyMHNpcEdSbWVhb25obkMxYVhsK0ov?=
 =?utf-8?B?VjlTcXBFa0ZkQU1qaVlNUkdvTVR0VExrQ1hEN3FYV2JmbnVHZXJPaUN4NUJo?=
 =?utf-8?B?d3NqZll0MSs3TWdsa0VXTnJ6ZnlEMlNYNTEzTy9lVE02YjBRQXlFTFVDMEgz?=
 =?utf-8?B?bHRyZVZBb1FuYVJIRHJiaEN6TndzNjROSnhDNkk1NmtobU81V21WRkNsNWI0?=
 =?utf-8?B?amVST01KZGxGWWN3cTh4bk9sSUlYK1pGelJVNjRyeHJ4aU9qSnB5UytGandK?=
 =?utf-8?B?SFFQeW5La2NIWmoyTHd4cjRmTmlWR1lzeG9jdWdnSFMrZUozZzNzZzFua2dz?=
 =?utf-8?B?M3I3QlM5ZGdIdjN6RG5ySU53RkgzaGZBS0c1ZUdBdm02Q3AwQk5KdWs4S2lP?=
 =?utf-8?B?czVVR2djak1sZVlDK25JRWZMQkNpbFhlWXdFKzNSU2hUQUYrUm54S095Rk83?=
 =?utf-8?B?TXBWRWY0dy95MDhVMXUrWEduL0lNb3g0dENMSWduSmR1Wkc5V1kwZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0029.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b9929a-92d9-4ebe-b9a8-08da19068f3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 02:21:58.7688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: emnmmR0jSzBp+7xOqIm+mecWv24Sxl4HX86aj7dKl1PBtW4kJ3uoF4mHChwlgQR5mDucuWK9dbB7rpsjoS+/sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4358
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogUkU6IFJlOiBbUEFUQ0ggMDkvMTFdIGRyaXZlcnM6IGluZmluaWJhbmQ6
IGh3OiBGaXggZGVhZGxvY2sgaW4NCj4gaXJkbWFfY2xlYW51cF9jbV9jb3JlKCkNCj4gDQo+IEhl
bGxvLA0KPiANCj4gT24gVGh1LCA3IEFwciAyMDIyIDE3OjM2OjEyICswMDAwIFNhbGVlbSwgU2hp
cmF6IHdyb3RlOg0KPiANCj4gPiA+IFN1YmplY3Q6IFJlOiBSZTogW1BBVENIIDA5LzExXSBkcml2
ZXJzOiBpbmZpbmliYW5kOiBodzogRml4IGRlYWRsb2NrDQo+ID4gPiBpbg0KPiA+ID4gaXJkbWFf
Y2xlYW51cF9jbV9jb3JlKCkNCj4gPiA+DQo+ID4gPiBPbiBUaHUsIEFwciAwNywgMjAyMiBhdCAw
ODo1NDoxM1BNICswODAwLCBkdW9taW5nQHpqdS5lZHUuY24gd3JvdGU6DQo+ID4gPiA+IEhlbGxv
LA0KPiA+ID4gPg0KPiA+ID4gPiBPbiBUaHUsIDcgQXByIDIwMjIgMTQ6MjQ6NTYgKzAzMDAgRGFu
IENhcnBlbnRlciB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gPiA+IFRoZXJlIGlzIGEgZGVhZGxv
Y2sgaW4gaXJkbWFfY2xlYW51cF9jbV9jb3JlKCksIHdoaWNoIGlzIHNob3duDQo+ID4gPiA+ID4g
PiBiZWxvdzoNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiAgICAoVGhyZWFkIDEpICAgICAgICAg
ICAgICB8ICAgICAgKFRocmVhZCAyKQ0KPiA+ID4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCBpcmRtYV9zY2hlZHVsZV9jbV90aW1lcigpDQo+ID4gPiA+ID4gPiBpcmRtYV9jbGVh
bnVwX2NtX2NvcmUoKSAgICB8ICBhZGRfdGltZXIoKQ0KPiA+ID4gPiA+ID4gIHNwaW5fbG9ja19p
cnFzYXZlKCkgLy8oMSkgfCAgKHdhaXQgYSB0aW1lKQ0KPiA+ID4gPiA+ID4gIC4uLiAgICAgICAg
ICAgICAgICAgICAgICAgfCBpcmRtYV9jbV90aW1lcl90aWNrKCkNCj4gPiA+ID4gPiA+ICBkZWxf
dGltZXJfc3luYygpICAgICAgICAgIHwgIHNwaW5fbG9ja19pcnFzYXZlKCkgLy8oMikNCj4gPiA+
ID4gPiA+ICAod2FpdCB0aW1lciB0byBzdG9wKSAgICAgIHwgIC4uLg0KPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+IFdlIGhvbGQgY21fY29yZS0+aHRfbG9jayBpbiBwb3NpdGlvbiAoMSkgb2YgdGhy
ZWFkIDEgYW5kIHVzZQ0KPiA+ID4gPiA+ID4gZGVsX3RpbWVyX3N5bmMoKSB0byB3YWl0IHRpbWVy
IHRvIHN0b3AsIGJ1dCB0aW1lciBoYW5kbGVyIGFsc28NCj4gPiA+ID4gPiA+IG5lZWQgY21fY29y
ZS0+aHRfbG9jayBpbiBwb3NpdGlvbiAoMikgb2YgdGhyZWFkIDIuDQo+ID4gPiA+ID4gPiBBcyBh
IHJlc3VsdCwgaXJkbWFfY2xlYW51cF9jbV9jb3JlKCkgd2lsbCBibG9jayBmb3JldmVyLg0KPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFRoaXMgcGF0Y2ggZXh0cmFjdHMgZGVsX3RpbWVyX3N5bmMo
KSBmcm9tIHRoZSBwcm90ZWN0aW9uIG9mDQo+ID4gPiA+ID4gPiBzcGluX2xvY2tfaXJxc2F2ZSgp
LCB3aGljaCBjb3VsZCBsZXQgdGltZXIgaGFuZGxlciB0byBvYnRhaW4NCj4gPiA+ID4gPiA+IHRo
ZSBuZWVkZWQgbG9jay4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBE
dW9taW5nIFpob3UgPGR1b21pbmdAemp1LmVkdS5jbj4NCj4gPiA+ID4gPiA+IC0tLQ0KPiA+ID4g
PiA+ID4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9jbS5jIHwgNSArKysrLQ0KPiA+ID4g
PiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
PiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3
L2lyZG1hL2NtLmMNCj4gPiA+ID4gPiA+IGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2Nt
LmMNCj4gPiA+ID4gPiA+IGluZGV4IGRlZGIzYjdlZGQ4Li4wMTlkZDhiZmUwOCAxMDA2NDQNCj4g
PiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9jbS5jDQo+ID4gPiA+
ID4gPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvY20uYw0KPiA+ID4gPiA+ID4g
QEAgLTMyNTIsOCArMzI1MiwxMSBAQCB2b2lkIGlyZG1hX2NsZWFudXBfY21fY29yZShzdHJ1Y3QN
Cj4gPiA+IGlyZG1hX2NtX2NvcmUgKmNtX2NvcmUpDQo+ID4gPiA+ID4gPiAgCQlyZXR1cm47DQo+
ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gIAlzcGluX2xvY2tfaXJxc2F2ZSgmY21fY29yZS0+aHRf
bG9jaywgZmxhZ3MpOw0KPiA+ID4gPiA+ID4gLQlpZiAodGltZXJfcGVuZGluZygmY21fY29yZS0+
dGNwX3RpbWVyKSkNCj4gPiA+ID4gPiA+ICsJaWYgKHRpbWVyX3BlbmRpbmcoJmNtX2NvcmUtPnRj
cF90aW1lcikpIHsNCj4gPiA+ID4gPiA+ICsJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNtX2Nv
cmUtPmh0X2xvY2ssIGZsYWdzKTsNCj4gPiA+ID4gPiA+ICAJCWRlbF90aW1lcl9zeW5jKCZjbV9j
b3JlLT50Y3BfdGltZXIpOw0KPiA+ID4gPiA+ID4gKwkJc3Bpbl9sb2NrX2lycXNhdmUoJmNtX2Nv
cmUtPmh0X2xvY2ssIGZsYWdzKTsNCj4gPiA+ID4gPiA+ICsJfQ0KPiA+ID4gPiA+ID4gIAlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZjbV9jb3JlLT5odF9sb2NrLCBmbGFncyk7DQo+ID4gPiA+ID4N
Cj4gPiA+ID4gPiBUaGlzIGxvY2sgZG9lc24ndCBzZWVtIHRvIGJlIHByb3RlY3RpbmcgYW55dGhp
bmcuICBBbHNvIGRvIHdlDQo+ID4gPiA+ID4gbmVlZCB0byBjaGVjayB0aW1lcl9wZW5kaW5nKCk/
ICBJIHRoaW5rIHRoZSBkZWxfdGltZXJfc3luYygpDQo+ID4gPiA+ID4gZnVuY3Rpb24gd2lsbCBq
dXN0IHJldHVybiBkaXJlY3RseSBpZiB0aGVyZSBpc24ndCBhIHBlbmRpbmcgbG9jaz8NCj4gPiA+
ID4NCj4gPiA+ID4gVGhhbmtzIGEgbG90IGZvciB5b3VyIGFkdmljZSwgSSB3aWxsIHJlbW92ZSB0
aGUgdGltZXJfcGVuZGluZygpDQo+ID4gPiA+IGFuZCB0aGUgcmVkdW5kYW50IGxvY2suDQo+ID4g
Pg0KPiA+ID4gSSBkaWRuJ3QgZ2l2ZSBhbnkgYWR2aWNlLiA6UCBJIG9ubHkgYXNrIHF1ZXN0aW9u
cyB3aGVuIEkgZG9uJ3Qga25vdyB0aGUgYW5zd2Vycy4NCj4gPiA+IFNvbWVvbmUgcHJvYmFibHkg
bmVlZHMgdG8gbG9vayBhdCAmY21fY29yZS0+aHRfbG9jayBhbmQgZmlndXJlIG91dA0KPiA+ID4g
d2hhdCBpdCdzIHByb3RlY3RpbmcuDQo+ID4gPg0KPiA+IEFncmVlZCBvbiB0aGlzIGZpeC4NCj4g
Pg0KPiA+IFdlIHNob3VsZCBub3QgbG9jayBhcm91bmQgZGVsX3RpbWVyX3N5bmMgb3IgbmVlZCB0
byBjaGVjayBvbiB0aW1lcl9wZW5kaW5nLg0KPiA+DQo+ID4gSG93ZXZlciwgd2UgZG8gbmVlZCBz
ZXJpYWxpemUgYWRkaXRpb24gb2YgYSB0aW1lciB3aGljaCBjYW4gYmUgY2FsbGVkIGZyb20NCj4g
bXVsdGlwbGUgcGF0aHMsIGkuZS4gdGhlIHRpbWVyIGhhbmRsZXIgYW5kIGlyZG1hX3NjaGVkdWxl
X2NtX3RpbWVyLg0KPiANCj4gSSB0aGluayB3ZSBzaG91bGQgcmVwbGFjZSB0aGUgY2hlY2sgImlm
ICghdGltZXJfcGVuZGluZygmY21fY29yZS0+dGNwX3RpbWVyKSkiIHRvDQo+ICJpZiAodGltZXJf
cGVuZGluZygmY21fY29yZS0+dGNwX3RpbWVyKSkiIGluIGlyZG1hX2NtX3RpbWVyX3RpY2soKSwg
YW5kIHJlcGxhY2UgImlmDQo+ICghd2FzX3RpbWVyX3NldCkiIHRvICJpZiAod2FzX3RpbWVyX3Nl
dCkiIGluIGlyZG1hX3NjaGVkdWxlX2NtX3RpbWVyKCkgaW4gb3JkZXIgdG8NCj4gZ3VhcmFudGVl
IHRoZSB0aW1lciBjb3VsZCBiZSBleGVjdXRlZC4gSSB3aWxsIHNlbmQgdGhlIG1vZGlmaWVkIHBh
dGNoIGFzIHNvb24gYXMNCj4gcG9zc2libGUuDQo+IA0KDQpObyB3ZSBkb27igJl0IGFybSB0aGUg
dGltZXIgaWYgdGhlcmUncyBpcyBvbmUgcGVuZGluZy4gSXRzIGFsc28gYSBidWcgdG8gZG8gc28u
IA0KDQpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92NS4xOC1yYzEvc291cmNlL2tl
cm5lbC90aW1lL3RpbWVyLmMjTDExNDMNCg==
