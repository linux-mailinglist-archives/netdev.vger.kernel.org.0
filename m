Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A239747CC04
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 05:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242323AbhLVESh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 23:18:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:45652 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242314AbhLVESh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 23:18:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640146717; x=1671682717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vqSvHsvEtkOLo2eMvDWk9mjko4aue/heNKqFP5oltXs=;
  b=YgD23AI7m2OPXtuVSxBfe5RwkJfzV55EkA6RWg0DQQ0jc+7yUjjWR2tB
   gbHaFddtpg349ZNmE2OpiBbJr2gRvSgNvQWCnlxpPkikdDRzz2nPpltrq
   yJBNJL6FaizLSRqpNR663Oq1x6iN+3gRFnK3ifOZ0Gd0xOPioBtAwVKG8
   gY9zA5r0V0+sP9D1Z0+o8HI6HjZk15hIX/7vr4dbU5uirmV2J71J93MdH
   HSP3+incDcgvXTcR4OkLu/q0g3jzdmrI+jbcMn4yv6TdGhP+WcfS+1jnO
   I2h/OiaN3ARlo9G+DpkJ1Uu85zFRG8cmDT5LC9xEY3g2tlo6WvJiNEHwK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="220553189"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="220553189"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 20:18:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="617002193"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 21 Dec 2021 20:18:36 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 20:18:35 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 20:18:35 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 20:18:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODfBN7z5Bm+Khj7NXVSjqAvgdLD1UztWhOv8+s59udGr7IWQrErgPs0+ifw9jwOIigHsdd2tejoJTBC/0NLOetqpV6+8vyyM+H6+kpzZN+CKG+qDlIyfBTR6nU9/Opd92UlqgehKI6zc2brGZh+6+qEWsifVAtv5j0NVSwszGbdkHtB50s9/UUKQXsDJ8qQCRHn9r28cBeTW5UGUH4tCcr1KyAwvvXupgK3MwpjZ3OsPQjt07Ws9AyJW6P9jZc2g+nzFRyrfMrnAMdFcoSclwZiCVa9G7xXw1vkdF2GX1KWemXr4KcSJLr/W/ndwdM+/7NHZZ/5GGRo/znuKQL153w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxOeZXSnLoGA85jqnfFBRjVCOhGMKnEjv3YC/y0NVv4=;
 b=GuQBEoX6SXUE/BeKsnEibzKAm6TeiFACdbQ1HrRNnpttqk8U+U4Db/T1A/MhCujb7q8hyWPZDeIM0rloLOmknkXN+Q1ad/2GP+ZGmONZXZJI7fb1cKNPyG08U/5VpEEXGsU1jJgiLaXPUImpzOAORRfDOCQW+p/2HQdW0HT+D5mvf8SRyjKO8dILPRdKGj3GW/tUySlODisvdXYXiu/1fO7VdMCKLnha8ggSFh2XhwKzJxGEx2GRo52miVYns99vIroxTqX9EaW4ipmR71PUptNPHbh11qDE4H8haSoCdAVzkWkCPV11IQ0tKMiXXCMWSJ8CaSkSD01IfZp6s1gm5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3574.namprd11.prod.outlook.com (2603:10b6:a03:b1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Wed, 22 Dec
 2021 04:18:34 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::bc02:db0b:b6b9:4b81]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::bc02:db0b:b6b9:4b81%5]) with mapi id 15.20.4801.020; Wed, 22 Dec 2021
 04:18:34 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Ruud Bos <kernel.hbk@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 3/4] igb: support PEROUT on
 82580/i354/i350
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 3/4] igb: support PEROUT on
 82580/i354/i350
Thread-Index: AQHXzAmZiyO2uDXQgk+NIigN5eL1I6w+Pbzw
Date:   Wed, 22 Dec 2021 04:18:34 +0000
Message-ID: <BYAPR11MB3367FA42221280DBD9ADDDC4FC7D9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211028143459.903439-1-kernel.hbk@gmail.com>
 <20211028143459.903439-4-kernel.hbk@gmail.com>
In-Reply-To: <20211028143459.903439-4-kernel.hbk@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ee5bdb9-3bf2-4ca3-5b58-08d9c5021e9a
x-ms-traffictypediagnostic: BYAPR11MB3574:EE_
x-microsoft-antispam-prvs: <BYAPR11MB357442736C4F72A9C9D0CB25FC7D9@BYAPR11MB3574.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WU4TV+hiZuRNhvrvw3qvt/ughigl5Mw9ES9L7zxp0ZjcrAK8did9JnSd8fgOjZz63sLKUxYqUguQ2Dngnbvs36o+ZhPPbm3B+4FDLRLcu/XHlg8T2RBOfzbgGBRTmXgd2z2OSeJklnbGAOC/0NYat13IR8W4BBdHpm2+jHNmRR46ebZ+RFg2BM5d+ImQGDc4FyW0iUZqTAdxQapTKrsKopDHcp20PPTD/QiQ64e0GWah13AtsG1UdrVGKp+rzghL8KfDrgo9ZQY/gGtGaVdcKuuFca+DnL0tT4UpAivfKImXdBogp0vqy4MbcGkECP2+AeK0TIc/M3Ky6DotwoH8kcdYSEQV3J/ACFtIhh2PS97meKrGpMK/GbHkl/il937h5mVUwVcCIFZGHX/LGDllilFXv05OvpfSUNbX1iu0fcDqp0t9fsjwbADW5fzCeTzf+hGRvonXuhXV+gMTNon5J5CaVTutjH4NJV0n4YHdZ735RJG/dRpq0yxR6Pgft/GKDXOa2lFcGBjozjNme3Zh+X+vOelqDmMS7jAGvYi3/lpl6+uXlUErDIuX0li8BcRKOkRPNCpOZ207urvQ+wAefbrOLCAGlAlp2COLuq1rrYn3t2wdbnjq+dhJFW49ahdvNlidZwWHvuosm8GSUJ2DwOrjpad3GHBL4oG0vNGsOaFzGSxca9Vum2h749MkXxj9NuPmZNC51Vv1UQHGYIARGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(26005)(4326008)(2906002)(53546011)(82960400001)(38070700005)(52536014)(316002)(6506007)(9686003)(110136005)(5660300002)(71200400001)(8676002)(7696005)(8936002)(76116006)(33656002)(66556008)(508600001)(38100700002)(66946007)(66446008)(64756008)(66476007)(86362001)(4744005)(55016003)(54906003)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IFMKRlbIpu1jTFRt0AqD20m+P5r6p/jkL5CKJauXweh1gZErzTjOgyeEilpI?=
 =?us-ascii?Q?asiYJ1IoaJLHjxgVrbUuyEIYJ8DdAoI6vq0mEGQNFYdVd4+ATdQUnMYbOcxv?=
 =?us-ascii?Q?YfRjwKX7j3MvSNzww6HWaVEaV9t4/hGbJT/20hwBdLss6+97RrMz591V4ADa?=
 =?us-ascii?Q?V8hYDSz8W1Jr9SQd44xQfGREJYgrAwhMbX/D0tAFaZyAPSjgrZlAnL9dnrtX?=
 =?us-ascii?Q?MI/vhAbqxuDsPSHFcGmyAFC+dbVc5knb23629eNkNVBPXWbgvOnOpzkXdZu1?=
 =?us-ascii?Q?KWC0dUvoFigKGBYEg5fh7BuSJrknEW+d0Adh2nbDfP7bOmOh6ChOg+WvYxM5?=
 =?us-ascii?Q?Irxb1xeXFcU53c5ODcw6J505VJWKMVW0GSdFGOvAoME7QmyOUSVNPauOzkD0?=
 =?us-ascii?Q?b9OGOQb8/BR3qsZtnAonsr/RqD9PM9pDAiotZQaprPSnenWNn1nK8zTw5Q4s?=
 =?us-ascii?Q?LumofNsXqgKOnRvIt8DwTEnP+bi5XHMXSyMzjKEV4vDOGtD82fgJAopMMBv9?=
 =?us-ascii?Q?3kONZUPxSfTW9b2shOx0Su0yFa/1QdSVrZAMmd+4cgU3F24UNZihyXwKJiN8?=
 =?us-ascii?Q?GFbMyDesH8kZvkl1GF1ABjZ1QXRwr2IMc+nUyHAbQmWSeH87fdKR8y3lEAO3?=
 =?us-ascii?Q?TZS3nD1PAPexApKav4IEISX2BdOChLzr7Umr83laS/XMWGuHuV1psVAsn+dU?=
 =?us-ascii?Q?NZt5mcoPtQfHgYXfV7/GcmRjPRrT7zcwOgJWqObVMqz/TJENbeaeKMuoiRn+?=
 =?us-ascii?Q?aDYNj6LeZJ0kp0xZ3c8Zyeabq8VHMYYkl7NLBpGgGbKhjf6YhSGp8xICvWsd?=
 =?us-ascii?Q?k5XQLqmBj1UFG9Mjhsw0aGByGQqKJR1wSgw7WG5+mkjE7IY1ohJi81GkrEN6?=
 =?us-ascii?Q?FTAiLeyovkpKsaos4QTKrwcqLPKeC+VUJoUaZuAmQIZWVy3d1fuodX0sDgZ4?=
 =?us-ascii?Q?sanpra52BaxVBqM8ZcOeL3ACfiqklu6KVKYLTJLXuCks2gYwEpXSNCh44VBf?=
 =?us-ascii?Q?yGCD9t+8GFNfiif8a/0lKhkfNVjmUoEvFH5hKFbthkycDmDXgHdtyPPtElUh?=
 =?us-ascii?Q?Qngt05wdP20RchbwQmTq7rr55Zv2iyt8HSFvdJYi163i5AnaWMRn5kvombqE?=
 =?us-ascii?Q?NUzVE41BPG1d9SQJMOd4PSa3XdUHkzukhiprA0DfP5gmgJnt1geq3T7hAyF0?=
 =?us-ascii?Q?WTSQkjFMuNQTTGf28os1mBy/GCVLxO52xaxuNQsrEwz6O2PB2HhHaHpkM6IF?=
 =?us-ascii?Q?aSXlWNriIBeHB2i855gll7T7XEKpJXb83KEXXFSE6g3mD7NpsIU2Imvh9zOQ?=
 =?us-ascii?Q?SNLsKWC1Q9pfxMHGs5xqLLDfB4xOhEPDl79O3RkrPzGXZ6Df229xM7h2nfmo?=
 =?us-ascii?Q?QH6GMjsmalkcxyC4ge2gVvDnlogHlS9rlwa4cvA3zy84XL2EAZUz0BDTSrfo?=
 =?us-ascii?Q?bGF44nuxCYdOzPMDDkNGDW8gGObrlDkM2y3OHy5cGVelRRC6pj8mh8hUWM6p?=
 =?us-ascii?Q?8caIYcuEhlna2AK8eNzw7IMK0QH2ZncTOh+aFX0NOnYJ4xUR298EDZWLKcfP?=
 =?us-ascii?Q?5b0JSUd0g1vLhaHgYEG5M8ST9HKugQUVtUM0+4xSmUo7Q4ypzvW8OT20vWK+?=
 =?us-ascii?Q?zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee5bdb9-3bf2-4ca3-5b58-08d9c5021e9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 04:18:34.2424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 71DEE1NfoI7fMrHCXFN7XaC1UMR+lSkzY1lWuZutku1UFymrrSHu2oK8V3P+1rxNw1jBeeCSPCPLOCw08R9mNg==
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
> Subject: [Intel-wired-lan] [PATCH net-next v2 3/4] igb: support PEROUT on
> 82580/i354/i350
>=20
> Support for the PEROUT PTP pin function on 82580/i354/i350 based adapters=
.
> Because the time registers of these adapters do not have the nice split i=
n
> second rollovers as the i210 has, the implementation is slightly more com=
plex
> compared to the i210 implementation.
>=20
> Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c |  59 +++++++++-
> drivers/net/ethernet/intel/igb/igb_ptp.c  | 127 +++++++++++++++++++++-
>  2 files changed, 182 insertions(+), 4 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
