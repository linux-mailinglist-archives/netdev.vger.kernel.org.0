Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88A35B1F81
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiIHNop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiIHNon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:44:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D9A167FC
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662644677; x=1694180677;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=goTFDJe17wy+rq6DlOdy0+1OZVHkScZqvStWY8aN9jc=;
  b=liYmrTr2b8xNn/xj6OHa/xSjsEcltExnUYJcWKzWXWcPUAhyeUN4El60
   CLbt8K+iq4RtXHwJGHI3X4PKJCQ+mD2W3JjaXC7uq1lEEiIZYFkW1TM7L
   Mmu1C1NolsCy/LUOYsx/l7LF/jZKhlL6YSNfDqKCeplP3TIbqwFQ8NV1Z
   FAHc2moRvhkGNXxUM8VYDIEiX3grtGkYAqYtp2rezZYAqlV6FM6/KUdn7
   iQveQ9xuE1fxVrJB3dqIYU8Wz/Zh6sPg7VWkponcOmvrgddGGH7IYJeeY
   na6OZPTv5X6OYN7bzWoKCV3lHkvgbMsGM4Vt55AO+WWR6eRiud78xcFPU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="297170127"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="297170127"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 06:44:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="718563271"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 08 Sep 2022 06:44:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 06:44:36 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 06:44:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 06:44:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 06:44:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWDRTR4aGAtFBkKyteAqNIK32YWzR4irGlUozBtIYnZHld59QfBkdP+EbgQpwH+i9pRE3WVYp4WuASF6NzIJZehx626tK3qxPMMTupS4uykjpoTOa8rlgYZ16FbrPqw2izzI+kgIirhWW2K0qNhlC3/A1huv5bQI+Xv3AIhLEutQct8GZmMXg7usKvhjxMUC5j4hYZ6C1orKUm57julttAVFNrS7Acjz0nyk6/3WpnCW3joygGO0qhPDXkVkqY/dU/shitHDb6P8qZBUifOEsDW/PIaiqKEMVJ4FyH2f1TcRCi6he54akSCgpdOOwWMliTMTYwhscCJonN0SkYrrtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tV1XsxLEPad4bsPhL5e4A2IW4raypoNc5007VndPMRo=;
 b=FGc6odhRfYG191DdoxuKk52f/xzP4Jn/mtshsEe5Ip039CypCmW0pTf7k+TKtqd5bviyfF8vBlwKWHTGMRHIRGWG1cvPwRNo0NTClfGVLO0IFtqE3BYBWDksXyj2b5foBcuoIHliwXPxhVne3xhnzA8vr+qY85hvP5/4ZmsA0ZWrnQkwRlEWZGpk61vI/mEdsK+lHTMfbMU1OyEVAuybBrEbH4xsJbD9VdQNb7Y98OU+oHibvPyKBhcnXftzq90YEyGyFiEBQBcIERTN6BRdtXwiWY4wq5BziUa7+Ov6/7fv7NrPiX3g5ms/e1p3UrAl2KzeuMvbPzkT3rJp0VXing==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by BN7PR11MB2835.namprd11.prod.outlook.com (2603:10b6:406:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 13:44:33 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::f3ab:ab2c:fa82:efa9]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::f3ab:ab2c:fa82:efa9%5]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 13:44:33 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: RE: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Topic: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Index: AQHYu/L55I/9qMiXWE+dtrk9hjKUpa3JkKOAgACDzYCABy4K0IAAtccAgADy/KCAAJb7gIACFduA
Date:   Thu, 8 Sep 2022 13:44:33 +0000
Message-ID: <BN6PR11MB41779D79858C389A3D1E77A5E3409@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org> <YxBHL6YzF2dAWf3q@kroah.com>
 <BN6PR11MB417756CED7AE9DF7C3FA88DCE37F9@BN6PR11MB4177.namprd11.prod.outlook.com>
 <YxbliLlS9YU6eKMn@kroah.com>
 <BN6PR11MB4177F526AA1726DC0EF95E62E37E9@BN6PR11MB4177.namprd11.prod.outlook.com>
 <YxgwA9bTvdheeZUf@kroah.com>
In-Reply-To: <YxgwA9bTvdheeZUf@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB4177:EE_|BN7PR11MB2835:EE_
x-ms-office365-filtering-correlation-id: db99cf19-efed-4ca0-7e96-08da91a0430f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NeJUnREYFs7UNlm2NM3bJ+jiiEMpchG1Bzdr/hCoxctnxA3SyGzjYk25ZRE+zCvr9S4IQW6ZMiI4QvRPd3BUgCSrrxO9GoBhJvPV9cA0pDVy07DblMWU5pAbfoItMaV4X8kGJvVNCcF3YV8F2oiTWqBAHDA8SktxgAS9vCsVDgbom1HkuoSUUi2BhTcgJKo3RMPI4eVNnWpOY77PBGFUEHagyHDiPlJIZCbxztrujmeoAb/YpzrIER6Nv4ipwCJG58wWR3a6BZqbo0z804Ndj5z5bh4GgVlnA6EQIWgbcoioyYUelF92S5wAVUgg+3NBdYrC5wz0L9Zgj5orWPwULrXgy+PnCrKsGUGiebQz6HJWzszMneTTmPcA2wxiH/nuQKX1CaoITZQh8JGcfo9eY7SY0rzIgkCiL/yE/2CN3lQEA+xpPDYzHFMU8BWdzvd6mwE3rsy3GbvOhmZZ0pIXMrWO7gAgAeMY8SbL5+ZL5FYsFqkCQrMXL4j8ovlVBT+7tFXvZcLBDToaZaFk4H6+nMAfvZ80VfOzA6+hILikb50Zb7nxIoIxUHMI/5X4DF9JEbH/61aLzqdEn42z/9Q09e82a9sYeGRdpeii9ymnVMYCUeiEj4dwg3vOtPu8as3MDUhH0JNKNJZ2TLQbDxJJToNJrWlcEqJWVrhwX8XiOJPb0aVUtOuYqLXBKvk6o52y8G+HVsOd2wCSEVLf+mqK2d1Dipsd5iET30VR2X7zxkvbawaM2O1uZ0ZgdAJ0NDdb/Cuq5bzzXIvTsQjKeYn/gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(366004)(346002)(376002)(83380400001)(6916009)(55016003)(26005)(7696005)(54906003)(53546011)(9686003)(6506007)(478600001)(38070700005)(52536014)(8936002)(33656002)(86362001)(5660300002)(2906002)(64756008)(8676002)(76116006)(66476007)(66946007)(4326008)(122000001)(316002)(66556008)(71200400001)(186003)(66446008)(41300700001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+DRNiKeHRkcecHxDIQtkJ9c8oBQiM1Mszd6TfkksLNndhscrIKdGgLPZC0+R?=
 =?us-ascii?Q?yFc8xDRb6Kh74lsvIbVRkShnYiwOlhp1/3VxLrDnHt4HSvi4P5xnyDt6TQj/?=
 =?us-ascii?Q?U//oeBeBvZEhMXfswTRlLizMIg4cdA1prVqCU2xgcZE15Xdlw5o0AcA9WsUP?=
 =?us-ascii?Q?Yt3QdKxoahMYkWjXEiz+z/1N7m8VMcXh0r3w+GfNqiNcLtAazsTVc1NnSVqK?=
 =?us-ascii?Q?5mFXMcf4oFC8njDeX6zjCltI8rKd9AF4+RY7t3GwJy9V4pr2Exdo4B4JMe4G?=
 =?us-ascii?Q?aevGw6oCDgi9cbYUXRnlU+rrpQ1IOwZudbueiaBJTU0dHuuTjHgZxwF3lbIg?=
 =?us-ascii?Q?EvvPUTgtlcWTmdEfVazkNYs1yJ2D5BiMSNq40VxmnHu3sj+W69g9i3gFArJU?=
 =?us-ascii?Q?xB3NqmIV6If7P3oYAkzxBNW0z9WGlrxbV78vjjO3w8qLXxtXyos09CPjFLKA?=
 =?us-ascii?Q?YEjmdZM82eIDUJsVaI3A1gaUNtPxEHMvqRyLPY0Kmr5+ribDZUrUkYVjRTpC?=
 =?us-ascii?Q?5frCiJ1ieZCPEvDEpP1OeoryXMSz5o0CvDbWfSxf/9NzkWxQ+3G1ITsJPMU7?=
 =?us-ascii?Q?/+pl28Swy19kJhoswAlOwYvbylM9aWgf8nDCGMOIFZWLi0+BbsFBJ3rqqLtx?=
 =?us-ascii?Q?19JgJa7qP03laN99dv+ehZTtsPsIfK16E+upPKdtfxzdr3FVfl/u9jiM0G3t?=
 =?us-ascii?Q?Kl8VAo+XlQmjKqr3VfVukD4ICatGvRbew/sA5X9yU4JjNv6bQCkXCJGxFBD9?=
 =?us-ascii?Q?3aCqLQFdiEkMwZkVkGWw6qAUIQtBGH2bYwhclk4kSF5D4771Ss621SXMRefU?=
 =?us-ascii?Q?tT+3qxmrzHjX+5IzXwLHLArjIzWajfBzVbvnel7Q6k2fhJvEF5RffEWW3mvg?=
 =?us-ascii?Q?pSIQpPB/PCeRTN02/289Qqnr1QZUN2IkL3g6ocsRE/UOotrHYJ6FYTQ80/Pv?=
 =?us-ascii?Q?6mkVS+ON3B7Bico7TMShk9+YVQ1Pd3STVFDg+9N7H7sftxiu/CRXCy4LIMms?=
 =?us-ascii?Q?UNtapULzrQjZ0vz37nMPA1/k8ucFJRR3tXq2B8eqEPpfBvo3QWc1Ta5k66Vk?=
 =?us-ascii?Q?Gv4KCTEVWw9zGDq7S0Vtb/B2PgGS3m51ZZDsCgFBcqYCJEPzKJLhRYMboF/2?=
 =?us-ascii?Q?osku+W8dc97ksGCv1p7GCC6ff1hGs9kbiUilXeUtcJjbvtNYd6S9ROCCxtIe?=
 =?us-ascii?Q?gdCtFAxxR/KC2kxIio22L0iTj/k00lYBofATT7ZcgXNJYQz4j4EhyyprrkFZ?=
 =?us-ascii?Q?KrZtPe9og8PdvTYVuKlxpKOovkdNUfO7+HbgEWNvjsca/bsI6mJpeCkpCJ5P?=
 =?us-ascii?Q?K9ou9/nP7SHIuzJG0AdBw0oiJNDTOW+55GDGrJXkxminL5z/CKPrChWrfd0k?=
 =?us-ascii?Q?XrQvHF379LisWCbJS+fX4yqMo1k5kwGfCy3rTX1SPkhbYqBX2mN7G27v6GkJ?=
 =?us-ascii?Q?wu1TBLs+mc9xa6VJ0P4o+vP6PsxlpdYhx1eR0c/I4RvxGy9vfUbM/IxrOSRF?=
 =?us-ascii?Q?4X++64kw1DqtXqCv6Q4w2g7m6aUJvzL87gjOvF4LvidLV+LUWinL+Ha9wiS4?=
 =?us-ascii?Q?nCV6W1vSo+/khmag0vvvRO33taSk4niAGz4MLXMQJu7RjRPyUdJxC4ACIiIN?=
 =?us-ascii?Q?7Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db99cf19-efed-4ca0-7e96-08da91a0430f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 13:44:33.1605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NNJjwliDfG05MI3RL6KqIP1eMKYtCyrxk8s0mtdU3PBE4vBq3rU3BPDXO0t2YgczQzz1bqaYEX7GVyIRAxHdhYMe7kQamWGyzQ7kCjhSryA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2835
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=20
> Sent: Wednesday, September 7, 2022 7:46 AM
>=20
> On Tue, Sep 06, 2022 at 08:55:59PM +0000, Michalik, Michal wrote:
> > Greg,
> >=20
> > Thanks - answer inline.
>=20
> As is required, no need to put this on your emails, as top-posting is
> not allowed :)

Thanks - lesson learned.

>=20
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=20
> > > Sent: Tuesday, September 6, 2022 8:16 AM
> > > To: Michalik, Michal <michal.michalik@intel.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>; Nguyen, Anthony L <anthony.l.ng=
uyen@intel.com>; davem@davemloft.net; pabeni@redhat.com; edumazet@google.co=
m; netdev@vger.kernel.org; richardcochran@gmail.com; G, GurucharanX <guruch=
aranx.g@intel.com>; Jiri Slaby <jirislaby@kernel.org>; Johan Hovold <johan@=
kernel.org>
> > > Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations hand=
le to GNSS
>=20
> Please fix your email client to not do this.
>=20

Thanks, I will no longer send it.=20

> > > > Adding this empty function solved the problem.
> > >=20
> > > That seems very wrong, please work to fix this by NOT having an empty
> > > function like this as it should not be required.
> > >=20
> >=20
> > I don't get one thing, though. You are saying, it "seem" wrong and that
> > "should not" be required but I observe different behavior. I have prepa=
red
> > a very simple code to reproduce the issue:
> > 	#include <termios.h>
> > 	#include <unistd.h>
> > 	#include <stdio.h>
> > 	#include <fcntl.h>
> > 	#include <errno.h>
> >=20
> > 	int main()
> > 	{
> > 		struct termios tty;
> > 		int fd;
> > 	=09
> > 		fd =3D open("/dev/ttyGNSS_0300", O_RDWR | O_NOCTTY | O_SYNC);
> >=20
> > 		if (fd < 0) {
> > 				printf("Error - TTY not open.\n");
> > 				return -1;
> > 		}
> > 			=09
> > 		if (tcgetattr (fd, &tty) !=3D 0) {
> > 			printf("Error on get - errno=3D%i\n", errno);
> > 			return -1;
> > 		}
> > 		tty.c_cflag |=3D CS8; // try to set 8 data bits=20
> > 		if (tcsetattr(fd, TCSANOW, &tty) !=3D 0) {
> > 			printf("Error on set - errno=3D%i\n", errno);
> > 			return -1;
> > 		}
> >=20
> > 		close(fd);
> > 		printf("Done.\n");
> > 	}
> >=20
> > In this case, when I don't satisfy this API, I get an errno 22.
>=20
> You get the error on the first get or the set?
>=20

On "set" - I'm doing get only to prove interface is working and read curren=
t
attributes to change only one of them.

> > If add this
> > empty function and therefore implement the full API it works as expecte=
d (no
> > error). In our case no action is needed, therefore we have an empty fun=
ction.
> > At the moment, I'm not sure how I should fix it other way - since no ac=
tion
> > on HW is neccessary.
>=20
> This should not be needed as I thought the default would be "just ignore
> this", but maybe not.  Can you look into this problem please and figure
> out why this is required and fix that up?
>=20
> > Of course in the meantime we are working on investigating if we can eas=
ily
> > align to existing GNSS interface accroding to community suggestions. St=
ill,
> > we believe that this fix is solving the problem at the moment.=20
>=20
> Let's fix the root problem here, not paper over it.
>=20

Ok - now I understand what you mean. If I get it correctly in your opinion =
the
kernel should not return error 22 if this handler is not set. I thought it =
is
an expected behavior, but I will take a look if that might be a bug.

Thanks,
M^2

> thanks,
>=20
> greg k-h
>
