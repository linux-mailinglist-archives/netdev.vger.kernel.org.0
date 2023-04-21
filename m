Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063486EA347
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDUFl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDUFl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:41:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E455959C4
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682055715; x=1713591715;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pWfLF5IvPwAU3nt2GVfPJ4gDnx5nCsTyYmqQFeXY9Pg=;
  b=b/4iGGQZGl5ag1OPBnQ8BtKQdusoCLmFXXkbUXNvRhPGhP7nxnm37MKo
   TzNn4znYhOx2z+cWgNkaycHqelqplZgv365oHnnZj0V81ZTQV7ys6IYSB
   d6F5GxPrheF/rOnBMZbiPVkfWTC6/ZuSmjd2Pe9K6V3tAryGaoyPxfZkm
   kndTRC2IEPg9HqqfKEPD2fyWr8lbEsZdWbyGbaSzQAryd0PhgVvPAaMDe
   /Jv8DzWLxXrTboEpm392sQRyIym9xUYr6QXS54yoKJJu0jgmJyC12QSmD
   rv0IIkfOGDjffRpEUH3H6TDzffZ3yZQbeOH+aDR92LfQ1d3JAvVsM+DF/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326247738"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326247738"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 22:41:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="781484184"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="781484184"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2023 22:41:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 22:41:55 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 22:41:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 22:41:55 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 22:41:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQEJKRzmEOuWLcHgk5WcLqt1lP3luf1OOYO6jbfaXxWuCrhe0CqLoterT2N0YvyCz7WGT8x/xfAqg/AdZVMspNlAi0KDP+84Y4090FUN4242D+s6sGT7En90oyYxByLwoL0eh6SSF7u+rupN1PG7unYMx6B1ui92Uy2rAaULPOo7DyB+PBJODgQvJDR/bFscRq7VcmLv7HyAjfcmaBEoMiFFbQGE9YQb1Ow0osVaihRL4vSEuOK1Ln/gPvK5iCSjJPCBEfUjrlsVFz8KkjI7aVouNp5xzqpwryGUfPRwqcYCdRbTmsjbwzzWSWCVNQheXWo5QNFhkBXaQCXazLBwHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIWA6AXgy708DtKq9dP7lwzCVPggUkMMybMwZaSoc/s=;
 b=CJiN/nmtrTdvaXef5vhZS6vJWMT9SXKKOAomkBrpi3HsoKpK+7W89k6zqP3f4ypBCRhgS06cMLtG7vE2eXsUWA+kmsTX1QDz/Z5kgvqrMslTrSiuYwkQKLSzhufAMeLJ190OoPPVIDocr3PqCSrijfM7AMxjDZr8yiY9eF8YEVZ4tgGvQeYM2ln+S9l5nLwH2x/uSgjfyhcigPdjVG/36hB0CwYCLPzD9qSnTsPo2jSSnDc59X0oo2utSiP3GL7EdApzcSHp3mshD/gOSDINa6Nb97thL/PnODzC1j0ZdHpO7C6SA1JdL4XR5DO/1SzJHxYT5izBl9xDfpeCDUMonA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by SA3PR11MB7556.namprd11.prod.outlook.com (2603:10b6:806:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:41:52 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41%6]) with mapi id 15.20.6298.045; Fri, 21 Apr 2023
 05:41:52 +0000
From:   "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To:     "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Swiatkowski, Michal" <michal.swiatkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v3 2/8] ice: use pci_irq_vector
 helper function
Thread-Topic: [Intel-wired-lan] [PATCH net-next v3 2/8] ice: use
 pci_irq_vector helper function
Thread-Index: AQHZXYKJyOOxLWiK1UKKOp7+idqtgK81bCUw
Date:   Fri, 21 Apr 2023 05:41:52 +0000
Message-ID: <BL0PR11MB31220553452F5C409B373F30BD609@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-3-piotr.raczynski@intel.com>
In-Reply-To: <20230323122440.3419214-3-piotr.raczynski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|SA3PR11MB7556:EE_
x-ms-office365-filtering-correlation-id: 8469161f-9ff3-4d53-7b06-08db422b1beb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pThRs7VWZeA6vxVgfiRjsL3vegVM0PVuOVLgXhPpc4agMme4/qvVlkzNnhvoRL9Tt7ETR2Jylp/ssm1AqP9qxrU94mmDabs2mYpGsBcN6fpxHdaU+jAoYIjo2G5z1FIWey/pm6FDonPrN8yeOMwQ05T+6VoDfwm5hjpVg+vsFNTOL2Pq/E+gq9EI079SQ1C61X7NSKSXjgQOmRHK361BJZ1CJbP7QGtPtWGpKgJX7ISWVND1UB5TiuKV0vJ3rkAgf7WzH3oPWi5634gTsmQzjyej+2kh/y6Uc7qQXpxXIkCK1XrE4Uwvr7WZ4fTDM0satKTVzOHR/NhEIp6KIX5lf6ER/IkLDGCaD8Gdc4m0H15xb6R+WIrmG396tOt7sWXfZptu9WFCCa7Ty6PPAdWDmMgwRDTZQraUjiE0eBxgbASIYCFuzXDwyspwZTXdM7NaZf53ZE0om3ZbeRVxeC29rtbZ6/VOZwVLdbhn+0YcV9W51yarPzMUS/THuAFOoJL6ZPqL1t/cPiUO9GEVrLlf53Fcv1rKz7+YI78r8PNQrqVRhCxXnxCJJskfsuI55mGgkCPd8+0HYU7+z1i2ZR4nR8z8tLBm0M0Ce5NAT7zd9rSF8NqMAxqVNCt8lgPeWbkb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(38070700005)(8936002)(2906002)(38100700002)(8676002)(52536014)(5660300002)(33656002)(86362001)(9686003)(6506007)(7696005)(55016003)(71200400001)(107886003)(26005)(110136005)(54906003)(478600001)(83380400001)(4326008)(53546011)(186003)(316002)(82960400001)(66556008)(64756008)(66446008)(76116006)(66476007)(66946007)(122000001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QNLiKq1tfE6Vd87Hgh2Xwm/tLIQ4GZoodyFZUbh58Y6EimYECZVdPb8Tm3wa?=
 =?us-ascii?Q?cMAnCDk7WkGnOef6AQoTFB7On2QtJLLR7x1jp0ycAeRu7y6EiNHF++wm2xUy?=
 =?us-ascii?Q?AeiL/bg4JXXLWGHy7vAi9RwFu1qGNcw5sLXesUslSZr+FhYRdC0CMbt354zr?=
 =?us-ascii?Q?lMilKYL6RsZjelmrnJYo1U1wXeVKFFWVyMnnzzQSrSwA5524vAdvponP8TYz?=
 =?us-ascii?Q?t/e7v+U2NGhtja1nZqpFtC3Wnd/Y0KENyQ6sLzPu49tlE7rpyWc63UCZi5aM?=
 =?us-ascii?Q?rs2ZTKPUySsfP2WEZ16yFTyuepsVaIFwitDbQFmmDDYMzXc8qxsn/FBEDV4k?=
 =?us-ascii?Q?ZEIlbXnAo7jKXw08AltnBJfvgUegnxtSiIsLFbQntu33wjc25nwnc3k0hjws?=
 =?us-ascii?Q?XkRpvp2IVXUG0umI5B7cEs9dm+QH5AcajEif7Irsi6kF3BIjvk0C6ONBp0bx?=
 =?us-ascii?Q?zUGPiQWgV+wSlswfT+SWyhtC6K1GavIwXwQaYnDWPbfIXKqtfLBbvuRhPBpt?=
 =?us-ascii?Q?9Zwot516ermnt93WmMJu1B2ee4rPx59wobblTJMW0Xmprw8QAN4neqB5RqNO?=
 =?us-ascii?Q?MbhSGjiS8m8h213vhLHIrajn5XgiscYZLF2qTK9epXODQck2f40nXyjxyQ34?=
 =?us-ascii?Q?4L6ixE1pkitPUAqI7RyyqFGm3MfVDiovfTdPge1B5CwMTiw3Qkwd8IHFufEq?=
 =?us-ascii?Q?hYCRf3nFKL6FVQZldudcf3H7a7wj6RKKM5o9JbKLgaSXWV2g8FyxN7QeeFNI?=
 =?us-ascii?Q?wMIZ0YqSAXLYq8bBN0QwG9Lv/is2KPUFB7g6cjCRRzf57j2I3+qSV2Cayp28?=
 =?us-ascii?Q?0E44Ib62FlnoyuVssytjVtpaWUGWXHNft8+YOKOAof8ZYKaO3Uq4gAGva/vX?=
 =?us-ascii?Q?MkTRaM2EY873wj4z0KNPX/J1wEbzIo2uJcbFLP/s5FO3ghxh2mfE1GaBNEUb?=
 =?us-ascii?Q?FxLFJJUvavYcKP1/ZuqAzIdCJcP6K4N2jMVV7hBfKmN9tJ58w2qRlgOJ05eP?=
 =?us-ascii?Q?UBx4VjtyvRbdpmXlyjwT4yb5PCXuHoyGM+t9ihIL8FiXr3i28TIGBkk88WlT?=
 =?us-ascii?Q?aumPHmxy5175taunDf2EJVpCKIPnQDCyh9onjmMth2ZjH1L36keEVE9jsh90?=
 =?us-ascii?Q?lWAU3wfGAkhtPKHfUltiIu/zpbdCyZi57XrfioNgDb2Y4d5p+FwaShim0GFM?=
 =?us-ascii?Q?q3XF4gCs1MN4WGFHHr1wLGpbYaNJk6aTvwvwfL5qw+4XaXhOaB8DXvNEzyMT?=
 =?us-ascii?Q?jS/OcpX1ZhaE7U8o1xuzlXLaCkn/MyoMOEmjJpyjfwd+knqBGiru7oi28O2/?=
 =?us-ascii?Q?42fAErRMShZjG+U7P/2t9UNcig/ha/CURVIWDM5J6l5y1K5YslEFeDLMhZ+3?=
 =?us-ascii?Q?cUDRw+/epdZj7U3GQBxmftCYvbK/3v2TwnSkfgaShZX07MMHEZXD5SDOzpQc?=
 =?us-ascii?Q?mjphrzLxtSMIcxer/GHqua4CBvqhzSDWAy/JrlUMFBqf1wTrPbVY4gkLMLgS?=
 =?us-ascii?Q?9JUzH/OD+pi/YXO+Avw0ZCYTq2LZ3qyw6aDdbpsNBDfiqvrBCkZKJuvyGb4J?=
 =?us-ascii?Q?D4QCrGvJcvpebkPUGIo3o90cMeXQ9+ad6fF3FyIzqOSzC4xUbxnJS316NXv9?=
 =?us-ascii?Q?wQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8469161f-9ff3-4d53-7b06-08db422b1beb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 05:41:52.2468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3F/o3lCO+BBcqneJ4GQExmKi2feZ1Tz5a/zUZ5j/REHD/V6601mSbSb8cYjCpKPCIGeDXY/xeuK/t0iYMovmdIvbp2cxqrzOSHnzYVad/wx1LXZohx1p462MgzOUugar
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of R=
aczynski, Piotr
> Sent: Thursday, March 23, 2023 5:55 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Swiatkowski, Michal <michal.swiatkowski@intel.com>; netdev@vger.kerne=
l.org; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Saleem, Shiraz <shir=
az.saleem@intel.com>
> Subject: [Intel-wired-lan] [PATCH net-next v3 2/8] ice: use pci_irq_vecto=
r helper function
>=20
> Currently, driver gets interrupt number directly from ice_pf::msix_entrie=
s array. Use helper function dedicated to do just that.
>=20
> While at it use a variable to store interrupt number in ice_free_irq_msix=
_misc instead of calling the helper function twice.
>=20
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_arfs.c |  2 +-  drivers/net/ethernet/=
intel/ice/ice_lib.c  |  4 ++--  drivers/net/ethernet/intel/ice/ice_main.c |=
 12 ++++++------  drivers/net/ethernet/intel/ice/ice_ptp.c  |  2 +-  > driv=
ers/net/ethernet/intel/ice/ice_xsk.c  |  2 +-
>  5 files changed, 11 insertions(+), 11 deletions(-)
>

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)
