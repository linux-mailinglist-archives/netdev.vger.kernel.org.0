Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C1449B482
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 14:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575155AbiAYNBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 08:01:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:15268 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1574505AbiAYM6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 07:58:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643115518; x=1674651518;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=et9+ZqkMxNyaIinPs3rLA/T1shewefofFV8LdQgNIlw=;
  b=JkAgogLMCBZ0XoBcH8KYXjMDv5f6i5Xx24RVdrAO7gCrTSlJNG4I8tjL
   hw/CUF51rR8aoGmOjMwFELrRmiNPkzciuCEVRXH+nN9Jg8FVmxB2IdQn+
   0U9AnlOudqKlcUZF63tWMSJZ6A29mZu5rvIafz0/MgqFd0kPE/qJn0q6h
   A+fnfsmB3rjKM+ygcK6bJDKVNb7CxJ62kJiPj3w9A15AR9mSJtYFkQxbV
   rjbTCXujBiNVP0LEcwPDdx3vmUbVRyLFe2szuL33Y1lQQEGlhTdWMZG5e
   Lq9PoSLqY7Wlcg00glGNCw3kKCaWntJpIMZCdMXDxOguZwiGY/KSCvab3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="246073891"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="246073891"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 04:56:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="627918605"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 25 Jan 2022 04:56:53 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 25 Jan 2022 04:56:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 25 Jan 2022 04:56:52 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 25 Jan 2022 04:56:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiORTeM0ByWEbS5LwZElUP87ak84FkFyevl7ZvVTz7k6iOkVCm/uGuKUBlrJpDRmm18AUwU0V0hTOP2Z5n+aDXR3lrlhBPDKPMmhkSZvhkOFRQ0sE8JJTQxJ1eGvMSnpi9YOa+XVKlf7FV7D03o/vnN5C5ccEP5RRied/LGTUu8+GRTHXmAvHbk8XqlKVdHVnuqHimGgqyuOzMLgQyy7dMiD022wXltehdlh8RWTrSXavSnhG+yyt5Fke7e/x/QnWsypfrMwcmLEUYJVtkQKuB/Nai8WIrB0nA0Q1arTkIMEvhegCpXULPmaltu75Zb3M79FVvKZjc+IB/DxPXL0Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoONrviKz6vG5zQ/UkX5bzbT6WkMkSWgzx/0kJBMnwI=;
 b=NwAWZiS8ybQud206MGr5x0JhbdBkx955KXv2Ja8xt1Q8WVjHTH8l4VSh9h/XLenrkFfhyuBGe0mRWY6yuHuxs/vPkbOoAkBKbdLuIoVVHnP1xg+JKvaYR9dWUIHbsKEw9GMwRkO26wxoVguV+ZLfWTT3sjt09vny+LqflUdDnoDKlhuZsRAUM+9Mrki3HjV/cNFvFteeOcyH2JyOD3iw95dibaQKKpTuOOEnxE0NH5bvrtTJ9s+QtSkfbshY7IDF+ES9zPoyFVO5shHK/EIewCOlKY3aLqJa0mKBZcJAj+gNkPqwQRs7DKuTgE89JfPySUIhPLTUqMiIVStMPiEfww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM6PR11MB3660.namprd11.prod.outlook.com (2603:10b6:5:13c::17)
 by CO1PR11MB5011.namprd11.prod.outlook.com (2603:10b6:303:6d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 12:56:50 +0000
Received: from DM6PR11MB3660.namprd11.prod.outlook.com
 ([fe80::753b:f9a6:9c93:278c]) by DM6PR11MB3660.namprd11.prod.outlook.com
 ([fe80::753b:f9a6:9c93:278c%3]) with mapi id 15.20.4909.019; Tue, 25 Jan 2022
 12:56:50 +0000
From:   "D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "Tobin C. Harding" <me@tobin.cc>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Build regressions/improvements in v5.17-rc1
Thread-Topic: Build regressions/improvements in v5.17-rc1
Thread-Index: AQHYEPfSFpmDnQzpgkifGWSL3krxPKxzsmGw
Date:   Tue, 25 Jan 2022 12:56:50 +0000
Message-ID: <DM6PR11MB3660804C821D7CA7329B6CAFC45F9@DM6PR11MB3660.namprd11.prod.outlook.com>
References: <20220123125737.2658758-1-geert@linux-m68k.org>
 <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
In-Reply-To: <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
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
x-ms-office365-filtering-correlation-id: 8c2a41c2-48eb-42e3-3acb-08d9e002278e
x-ms-traffictypediagnostic: CO1PR11MB5011:EE_
x-microsoft-antispam-prvs: <CO1PR11MB50119942373926B13B967E76C45F9@CO1PR11MB5011.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TSOxQ8EjKVAuiKHG9e/SKn+DuA76OZBOHZoRNhGzANCWUEUo/3RbCZtp+pYe76uNAyZEiJgEBIOr2/VUItaPbWpJj1+4j2VQheR2dEHy65kc2bXfGe5U1KLrpwHOMxtVu6RM5iwt3tlgEIpvExLdLT6deuBbFSpG8Ot6Y3Ng8S0ouGymtW2H5i2MBH/lJ19EWHtSj04GsGKyVNy14MwK0JUilppfL/RgzaKumfckUr2lhFVyjRM1sfiScgcuQlMjf74hM6MA6MTzkYUhZfztvtdAsw1XXi95fV6xwt70IMv+H4HSaGqoN2wMfG8HzhbRoOg/lLNnTxeEnywWdfCKzGetnkPc/d7mdbicr/8lbrrTGXskicrPOXtCCmIbwjdZoEdMW3vGEJ2OT08XgQ3pW2AIznzTU9mV1YqFUPxHPCx8HlrnQvCi/P60WD7rNcDsgD8BKOAPTRoHaKXEcvmQlGzNThIpvIPFy1fmdLl7uX//m+lMY+iyu5xN8PFvWVGTudADmCoabfzBoo4mO1+Sp6T44oDQvW5mc0TT3WpbaOS6//RwcvFtyvzjaR55tXTZ4yn6NpyQwKUail/QtMRbJUmgQFlYE6DfM+auznAhNPClF19DR0WHWqJ8ML4NhC5y0RcEH749zlomRMNzY7FfI54YrnLOTBwP1Pk9buFttbvVj4tYxewc+4tgEUSQqBD46c1bvXCO6zuj6qU0ieboFzY8GZ5+c4Xeln1LRw2Zx52NZrrwT4bVQ8ii3ZScKDF5BjZVk1vRil0XukQkipYXPwrOtdt5WLz4irz/nyeLOg0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(66946007)(110136005)(8936002)(2906002)(966005)(38070700005)(66574015)(508600001)(38100700002)(52536014)(54906003)(76116006)(8676002)(186003)(86362001)(9686003)(5660300002)(4326008)(71200400001)(33656002)(26005)(66556008)(316002)(6506007)(7696005)(83380400001)(7416002)(55016003)(66446008)(53546011)(66476007)(64756008)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?fUk/DrnQ8TNg8PT0qbnVaCbMpNxKN1Xauy6bLbJY/zuWKBENB/8jTyrFxL?=
 =?iso-8859-2?Q?mFyHcaB4Ho/5/6T+v9L4PgBQGNzy2/AC+NTCAZOSQ6Ryl4NFAbaQyL/a03?=
 =?iso-8859-2?Q?ly0U781i4qhwqLKk9Ood3EJF3zABFPukaN0NaRN6aQU+emZL06t2DY97PE?=
 =?iso-8859-2?Q?ZshVHce6vU12nrp+k77qW3d9MyV0/iOGjcyyWjTkshm5AzkfV4Vyymit2J?=
 =?iso-8859-2?Q?JiL8GY5Nh5ASP3/KpCPUls8iR0xJYLWwXtzcpyZ76+kpSUfYs25lEezUfB?=
 =?iso-8859-2?Q?+DVwTv8i70OjyA5jCujEq/MwjTcx3Be+X3E8xmesIWCSOuOq9u6mo2oP1H?=
 =?iso-8859-2?Q?vKER5rleLoQHKkgEPtfwU0ChFVCOZjCNbQu/Hcmr6MhKWOaRngwRXKCZG2?=
 =?iso-8859-2?Q?1uTQAfI8Lazi8azj9eiwMKyTQE7CO4WQtnD+O6QOJS72zA80STFQox/KKG?=
 =?iso-8859-2?Q?nqX6X+D21cvmBOcJx55WhdCRAavE5EA+jxHC/LlJ2QNU7upc/n7rf2vqFf?=
 =?iso-8859-2?Q?sNx4p7pgPpBZXcLpsvxyIAdvtFhcL2e9qFI+qfEMjjAfTYZnQNRzCPDN7W?=
 =?iso-8859-2?Q?8J6fGuhabzOPCzNjVbgYoe4azea56wBJ069lADAnTzTGBfkszrbAOgkzd8?=
 =?iso-8859-2?Q?Qjnf9fKKJ2JhhFtSdN4jnlQDexUns4P3ad2stAuXJLiVyH5WK+STVtk2Fi?=
 =?iso-8859-2?Q?Q9xQE9oZe33ElQKSdFWUpQelyij67yaV9CfLGu5ERtKDQLjxOWFq5Vizph?=
 =?iso-8859-2?Q?1JuFcW2yQGURrszcDwwglo5xsQX5VF/gHBC+Z4U3myvzJyESB6SWLEQwxy?=
 =?iso-8859-2?Q?/2Jqod4Q9IpLdcWhK6oeOdsjui2UXCKcE93WYA+kExCCiTC5Lx3aLi0hhR?=
 =?iso-8859-2?Q?Qo7j9UKMf69uX54jWPCw11z0NRU2aZnKCEXLR1rc+rV0QMJttqL1YjzlMF?=
 =?iso-8859-2?Q?ssn1KCc2RCFdkqk126s+pg34i4c0XRYIEkFT227UJKsHloVND80HGv09b7?=
 =?iso-8859-2?Q?rBDEl+ZiK5gLmkoRHcZSjh5YSu1EkQ3rp5mP0lUaoTsqRsK8WgPNXuA6Sx?=
 =?iso-8859-2?Q?ioh4bzVSehS+o2S8N9S+X5lLS7298Mtcun1HWiKE4wcX6fSVxX20IdXr4m?=
 =?iso-8859-2?Q?bJn6FjPuZTtvGLzZ5DuaIqHvnOLn0lKlcbERck0jwbx6kAQ62dOHHWDahe?=
 =?iso-8859-2?Q?+4ggTxXk6nr6yHaTQAzdXzA7FYZTKRcUu4u9lUMaAuOe3nWhLP/TZHM5ih?=
 =?iso-8859-2?Q?K/cNNuQI6igzarCHfQGupU4/gD9YJMqQUNHBZTe8zsplhmjNWbPHrUMiPn?=
 =?iso-8859-2?Q?/r/NxkpcNdKiDLm4XLjrBs9Ig3T7phHVhgLctqwEtRaA6BpHLffIqjt7uR?=
 =?iso-8859-2?Q?wyOaPnLYPi7lolnAsf3sfFnRrhJsbrxyEjL7QtOC94lzKupY+S6H7gA1d7?=
 =?iso-8859-2?Q?c38Mm42mEdTuyHLlsAZKigmBfxIf7CzP6r6YrcQrxm347N3Y2K/7HAu+vy?=
 =?iso-8859-2?Q?0dWm5ARlTZgxfChpv2lTWZyh9D4+fuEM8CPz5W5XFajOXtmtJWr/f9WLjt?=
 =?iso-8859-2?Q?FquoCejYxqMMB+9QghdX3ae+XKkEQvrNHcdohJKEnugRfk2jeUrChEOJe/?=
 =?iso-8859-2?Q?byy4uQdhMbv1lqHjpkraYALlflfD4gtEFKbDkF3YmPxR596G37ttrsRUOj?=
 =?iso-8859-2?Q?6wO21sJA9KlJ7YvMO8T5S/kmRKXQB+oNWzuqUrLTbcbDIn86U8aL0NkTte?=
 =?iso-8859-2?Q?G0sg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2a41c2-48eb-42e3-3acb-08d9e002278e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 12:56:50.6731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0aLZFmIS/Ikp1vMUBSaHHcYeEvITtt9hICbp8N854aPuAM4V68wOPmFIPJvKukHOD2oPbydxyCdOtOPsKwOEgt0n3hYJRp8B4yuuf+Ok+Lw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5011
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Sent: Monday, January 24, 2022 1:26 PM
> To: linux-kernel@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org; sparclinux@vger.kernel.org; linux-
> um@lists.infradead.org; D, Lakshmi Sowjanya
> <lakshmi.sowjanya.d@intel.com>; kvm@vger.kernel.org; linux-
> mips@vger.kernel.org; Tobin C. Harding <me@tobin.cc>; alsa-devel@alsa-
> project.org; amd-gfx@lists.freedesktop.org; netdev@vger.kernel.org
> Subject: Re: Build regressions/improvements in v5.17-rc1
>=20
> On Sun, 23 Jan 2022, Geert Uytterhoeven wrote:
> > Below is the list of build error/warning regressions/improvements in
> > v5.17-rc1[1] compared to v5.16[2].
> >
> > Summarized:
> >  - build errors: +17/-2
> >  - build warnings: +23/-25
> >
> > Note that there may be false regressions, as some logs are incomplete.
> > Still, they're build errors/warnings.
> >
> > Happy fixing! ;-)
> >
> > Thanks to the linux-next team for providing the build service.
> >
> > [1]
> > http://kisskb.ellerman.id.au/kisskb/branch/linus/head/e783362eb54cd99b
> > 2cac8b3a9aeac942e6f6ac07/ (all 99 configs) [2]
> > http://kisskb.ellerman.id.au/kisskb/branch/linus/head/df0cc57e057f18e4
> > 4dac8e6c18aba47ab53202f9/ (98 out of 99 configs)
> >
> >
> > *** ERRORS ***
> >
> > 17 error regressions:
> >  + /kisskb/src/arch/powerpc/kernel/stacktrace.c: error: implicit
> > declaration of function 'nmi_cpu_backtrace'
> > [-Werror=3Dimplicit-function-declaration]:  =3D> 171:2  +
> > /kisskb/src/arch/powerpc/kernel/stacktrace.c: error: implicit
> > declaration of function 'nmi_trigger_cpumask_backtrace'
> > [-Werror=3Dimplicit-function-declaration]:  =3D> 226:2
>=20
> powerpc-gcc5/skiroot_defconfig
>=20
> >  + /kisskb/src/arch/sparc/mm/srmmu.c: error: cast between incompatible
> > function types from 'void (*)(long unsigned int)' to 'void (*)(long
> > unsigned int,  long unsigned int,  long unsigned int,  long unsigned
> > int,  long unsigned int)' [-Werror=3Dcast-function-type]:  =3D> 1756:13=
,
> > 1639:13  + /kisskb/src/arch/sparc/mm/srmmu.c: error: cast between
> > incompatible function types from 'void (*)(struct mm_struct *)' to
> > 'void (*)(long unsigned int,  long unsigned int,  long unsigned int,
> > long unsigned int,  long unsigned int)' [-Werror=3Dcast-function-type]:
> > =3D> 1674:29, 1662:29  + /kisskb/src/arch/sparc/mm/srmmu.c: error: cast
> > between incompatible function types from 'void (*)(struct mm_struct *,
> > long unsigned int)' to 'void (*)(long unsigned int,  long unsigned
> > int,  long unsigned int,  long unsigned int,  long unsigned int)'
> > [-Werror=3Dcast-function-type]:  =3D> 1767:21  +
> > /kisskb/src/arch/sparc/mm/srmmu.c: error: cast between incompatible
> > function types from 'void (*)(struct vm_area_struct *, long unsigned
> > int)' to 'void (*)(long unsigned int,  long unsigned int,  long
> > unsigned int,  long unsigned int,  long unsigned int)'
> > [-Werror=3Dcast-function-type]:  =3D> 1741:29, 1726:29  +
> > /kisskb/src/arch/sparc/mm/srmmu.c: error: cast between incompatible
> > function types from 'void (*)(struct vm_area_struct *, long unsigned
> > int,  long unsigned int)' to 'void (*)(long unsigned int,  long
> > unsigned int,  long unsigned int,  long unsigned int,  long unsigned
> > int)' [-Werror=3Dcast-function-type]:  =3D> 1694:29, 1711:29
>=20
> sparc64-gcc11/sparc-allmodconfig
>=20
> >  + /kisskb/src/arch/um/include/asm/processor-generic.h: error: called
> > object is not a function or function pointer:  =3D> 103:18  +
> > /kisskb/src/drivers/vfio/pci/vfio_pci_rdwr.c: error: assignment makes
> > pointer from integer without a cast [-Werror=3Dint-conversion]:  =3D>
> > 324:9, 317:9  + /kisskb/src/drivers/vfio/pci/vfio_pci_rdwr.c: error:
> > implicit declaration of function 'ioport_map'
> > [-Werror=3Dimplicit-function-declaration]:  =3D> 317:11  +
> > /kisskb/src/drivers/vfio/pci/vfio_pci_rdwr.c: error: implicit
> > declaration of function 'ioport_unmap'
> > [-Werror=3Dimplicit-function-declaration]:  =3D> 338:15
>=20
> um-x86_64/um-allyesconfig
>=20
> >  + /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:
> > error: control reaches end of non-void function [-Werror=3Dreturn-type]=
:
> > =3D> 1560:1
>=20
> um-x86_64/um-all{mod,yes}config
>=20
> >  + /kisskb/src/drivers/net/ethernet/freescale/fec_mpc52xx.c: error:
> > passing argument 2 of 'mpc52xx_fec_set_paddr' discards 'const'
> > qualifier from pointer target type [-Werror=3Ddiscarded-qualifiers]:  =
=3D>
> > 659:29
>=20
> powerpc-gcc5/ppc32_allmodconfig
>=20
> >  + /kisskb/src/drivers/pinctrl/pinctrl-thunderbay.c: error: assignment
> > discards 'const' qualifier from pointer target type
> > [-Werror=3Ddiscarded-qualifiers]:  =3D> 815:8, 815:29
>=20
> arm64-gcc5.4/arm64-allmodconfig
> arm64-gcc8/arm64-allmodconfig
>=20

These errors are fixed with the patch set by Rafa=B3 Mi=B3ecki:=20
https://lore.kernel.org/all/CACRpkdYbR-hpLTcvN1_LuxEH_mgHLqDmopDqo1ddui9o8Z=
vSPQ@mail.gmail.com/t/

Regards,
Lakshmi Sowjanya

> >  + /kisskb/src/lib/test_printf.c: error: "PTR" redefined [-Werror]:
> > =3D> 247:0, 247  + /kisskb/src/sound/pci/ca0106/ca0106.h: error: "PTR"
> > redefined [-Werror]:  =3D> 62, 62:0
>=20
> mips-gcc8/mips-allmodconfig
> mipsel/mips-allmodconfig
>=20
> >  + error: arch/powerpc/kvm/book3s_64_entry.o: relocation truncated to
> > fit: R_PPC64_REL14 (stub) against symbol `machine_check_common'
> > defined in .text section in arch/powerpc/kernel/head_64.o:  =3D>
> > (.text+0x3e4)
>=20
> powerpc-gcc5/powerpc-allyesconfig
>=20
> Gr{oetje,eeting}s,
>=20
>  						Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-
> m68k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But when
> I'm talking to journalists I just say "programmer" or something like that=
.
>  							    -- Linus Torvalds
