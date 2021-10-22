Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7343714C
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 07:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhJVFYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 01:24:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:15971 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhJVFYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 01:24:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="226680592"
X-IronPort-AV: E=Sophos;i="5.87,171,1631602800"; 
   d="scan'208";a="226680592"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 22:22:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,171,1631602800"; 
   d="scan'208";a="527801546"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 21 Oct 2021 22:22:29 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 21 Oct 2021 22:22:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 21 Oct 2021 22:22:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 21 Oct 2021 22:22:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 21 Oct 2021 22:22:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQyU/xrSklZSWaDbydgnWNwX89VHzbO/+bVnJI0hqGwjnbESO18MKANFx2LauVEStSYGTj1eq0pO055y8q4M9lJ+EgnszxkvcvnSRBmjPkTGLH35kkDEYLluj0wEWzQK3cEz8dpLgghw7UDeooszgFKMWwLy3PQSraiQMryhB2LwxjK+/DstNnfvLqu95byMzmFzEsNocLqN5s5pDGpHkNXBTmju9Jk3DCBjzKbCsDdKyZybkF9Q9tOrRGcikt2HKAchAAYXPAhnsZw21/R5VPPDHB3dXUI2POahR4bCs7xjNS24IDDiV0FNGcq0Vudpw+Q8hUg+e6E6RuEFwb7ZJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i41tqNjyvSlPsntpvyEk8FR5bhDIDz71GiJyGt1CNjY=;
 b=CuuvWxvIdRCptXvmM2PX4aNyTgfSmCA61ybdQOQJhpVA/NvsjgQ2tZU/A4Z0Uny/wP30QUDiE/cIcK9ecZE/9jUMwvm04o1k7xNE7F8IRzXRjGsPIm24gOM9rMENUkZ3m4UFyjkBGVjzcWFHrK6cKFw/megIUmy6H3fMWBMHFOAhNFKrBVl+W7ZiCaL8TH/lIuJogVUUGWogU4fj66IAP2BcwcGZz7ii8NN7ApaV+nqONbinlsichlrJtze67ejgQ3wBonoDlGG/wAdgGx55JuwKpCFZR+Zd1R+j3wVlru7kX3pryNbTXTe+Ma3tuE1jIVIIBIOxm0lrhvzow0fh4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i41tqNjyvSlPsntpvyEk8FR5bhDIDz71GiJyGt1CNjY=;
 b=IHArxix7tf8sFdV6kdfxLsFhn+kPYhYfTVkZexok+2n1cw/clTUT37V3oMImvkJxz4XOWhciiYPqEZcjPz0VdSPDUAmviBxky9RVyp7SThgXuozeKRFUCfN60551JgZrUa4snlg3jdBEwhN4ktI08h6Cv2YZtCHnoxhQrHpNkVo=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3094.namprd11.prod.outlook.com (2603:10b6:a03:87::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 05:22:27 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce%7]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:22:27 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Yongxin Liu <yongxin.liu@windriver.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net] ice: check whether PTP is initialized in
 ice_ptp_release()
Thread-Topic: [PATCH net] ice: check whether PTP is initialized in
 ice_ptp_release()
Thread-Index: AQHXvm71BKbovgK8dUSOJ9AjphaGYqvejHmg
Date:   Fri, 22 Oct 2021 05:22:27 +0000
Message-ID: <BYAPR11MB33676CD4ED95DC1EADB6BC0DFC809@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211011070216.40657-1-yongxin.liu@windriver.com>
In-Reply-To: <20211011070216.40657-1-yongxin.liu@windriver.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1b9ac08-bb74-4d05-03f0-08d9951bf02e
x-ms-traffictypediagnostic: BYAPR11MB3094:
x-microsoft-antispam-prvs: <BYAPR11MB3094F672EA741596B5863E52FC809@BYAPR11MB3094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oTBnXB6Nqbx1yTCIbtB1W41wTzzktpoV2JMW0+b6eAIhNfr34YgTLuzWOGzO1aO6fUC7xpg4RDg0vcil052ctd6wR8gmqA2w2257bnTfjuHF/wgDNiVZMEWajhryCOzhA+w3tuvYYpDObrkBOeCXM9bnujkOn32xrJSwgA0+rPhbep2CI6MddOMP4+PUQZoNP04HByRQFCZn8Kbd3JSBS9lkKtyqdqIDdE0fZQ8zcVyVNwui/MvtCOXVwvxJaLNFw7so7h5bqpTVaGXlVIM+uXk/mC+nNozcPL2kXdPQ7xVAyjijzd7cuhlH3t+unn+9lKCzdR5gsCO40CEHcmV1ChrDubdG9l/M1h3FERVIZBb8MIyk1DCrobkyd6yhhAKQiRU+hxecfF3qdzttLC4TZzkyO4/odVKxFz54tHSOOloOttB5M8de1TA7n/qpqWqhZPCYgRLtxh/i+pw7KudleFLQrQDyJlxDtC+Ww5yIud97BF/mDUlwEhY+9OgUMYymIzE/P4P8/cz0aJ/IFq0MOYJgtiZqNt+jxP7x73bF09Blzm7LCte0TB/zgNw9hV3g0hWtT+tkbqVN2fJostwO3w0R7kvrvhXjJCXOaPZdEgjH3JFHGpP690rx5wlkQn7iZCDbJUg/TXiWLGkWZvMmwR6bCeIZU448NwfMpRcyeo2Jf/QsLzR/jaOhdOuCiqfQfs2nhHYnlXkJvXyhLJ9pLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(26005)(186003)(9686003)(6506007)(2906002)(53546011)(5660300002)(55016002)(38070700005)(6636002)(82960400001)(86362001)(7696005)(64756008)(66946007)(54906003)(316002)(66556008)(122000001)(8676002)(8936002)(110136005)(52536014)(76116006)(38100700002)(4326008)(71200400001)(66446008)(66476007)(33656002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KiKgco4iYSNmco7C8X1bqDTvPnQt/hPSY78dj47TNV+c5YKsjEfIpwmUanm5?=
 =?us-ascii?Q?ZL99ja6w1TPbqXlsD799oktKk86P63wRsx6ue9u4+VrKyHoXKl34j/ywDogO?=
 =?us-ascii?Q?i6XXaRsjQykMZGzohRms2b7Nlbl3szf0f8pLB3XpwQl/nKATziXeCzcPEl8M?=
 =?us-ascii?Q?YIwX8E5WLz/810mfOiapBUqQ7f4ObM/lQZLR7Ja6ibsJOofc/kz6+U+GOdv+?=
 =?us-ascii?Q?d8Y8NvLzYGAxxjWDW4/Jhuq3605E/NBydepTe19Cpcdp/Gg9VuasncgpPxgc?=
 =?us-ascii?Q?pBPhEPXsSmkEJqCoQAGTepEZBeuXA3g1ldctZfs86n883LreTshj+kA62Uz3?=
 =?us-ascii?Q?7tVIjnwbR2Rxi9qSrhZa6inFWPwycDndg3O9dqVC04Opn6ksCAN/a8BKGARW?=
 =?us-ascii?Q?HDWVUmSf9ctJjhb4AoI3Haxb/9rKwXQ6xivPahX/hX7acZ02QpIID+wzTP3V?=
 =?us-ascii?Q?8kSPPTd4sqCgCLD9wQq6z020B84f+BoQ6FqBc18MMpjfRN5OrNRxrDWDP8+n?=
 =?us-ascii?Q?GpgvXuXMi7ICw9be5AjPTbDLti35FyWJu50W4cfM9raF0jgR0lTLnuDwdHWc?=
 =?us-ascii?Q?sQOAQ5vkBuzGR5zB412JzG92PW16s4SgEHjJyE/27Ej4thclo+Y/dzJojMkg?=
 =?us-ascii?Q?Dq+A8Zhncd+E8IyTz/Hv5MLS5xqwAwkkOWpSCaD7f5F2oQ2oHx8jK4EOYW5a?=
 =?us-ascii?Q?ulSG+WliU6Fmwl1mUEonu2g5V9HjOZIKSwVL/6rR3OqBz8NzIGGI5OTNsGVx?=
 =?us-ascii?Q?4HkqOzxlVG1I6DAwnJ8FSnMuWROuSW2w1h95UfnkM75mdtCt9PXbl64F3hlQ?=
 =?us-ascii?Q?aA5BTjtSvUkV4+osIswPj5wtr9gKyQdunOMl9T9Gi1APX5oqWkjrJBK9Jupp?=
 =?us-ascii?Q?gR/cJhHzIv0CTfbJ3OFoy/BtRJFdb6AIkGwISxT1e5RbscTK3QPP1ns4WwIf?=
 =?us-ascii?Q?JS/YS+rdbkMrnqoCNBUju4hVJJ/TKf3I4vBO8VhXW7g84ka/QsboIjWVOmT+?=
 =?us-ascii?Q?vOwnDxoPbwwo6WxuWd65nI+6niZyzHQXqhRt5lI1yNPqVJ3J73lLqVmtnzK8?=
 =?us-ascii?Q?zpMk541qM+JWn9yeqYcDiyLWt816TWIczHSPRBkzsBJlioeisx7VcZs3bExd?=
 =?us-ascii?Q?598yYVqEWb3AkG/nV0OpvHQ/rlA/vDFoT2RGdPOFpzqf092pKH5vkUdgugLD?=
 =?us-ascii?Q?yX0QSN9uisQfq9XQnSuTrVhLh4uZeSpbLisTopv5WD9KVkYd13PhJ16s1qPJ?=
 =?us-ascii?Q?HtzapC5O3J8ooo/GMJ3iEzIsMYZJ4S9wctoC/LS3cS63g3I/kJPhP8dXOj5P?=
 =?us-ascii?Q?tsL1C2YgYzjV+ZnLR6slYwOAH+tbtnkk3SNN6UP/w1IlxvV6XgJ1RhIc/map?=
 =?us-ascii?Q?YlqEf5ECnUMzDXt9UeAgPyOrsJGfIAQ6Y99uxzFWjCHyx8YVQp9YZ874kK04?=
 =?us-ascii?Q?eOeVjGM+H+Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1b9ac08-bb74-4d05-03f0-08d9951bf02e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 05:22:27.4339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gurucharanx.g@intel.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3094
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Yongxin Liu <yongxin.liu@windriver.com>
> Sent: Monday, October 11, 2021 12:32 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>; G, GurucharanX
> <gurucharanx.g@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> intel-wired-lan@lists.osuosl.org; kuba@kernel.org
> Subject: [PATCH net] ice: check whether PTP is initialized in ice_ptp_rel=
ease()
>=20
> PTP is currently only supported on E810 devices, it is checked in ice_ptp=
_init().
> However, there is no check in ice_ptp_release().
> For other E800 series devices, ice_ptp_release() will be wrongly executed=
.
>=20
> Fix the following calltrace.
>=20
>   INFO: trying to register non-static key.
>   The code is fine but needs lockdep annotation, or maybe
>   you didn't initialize this object before use?
>   turning off the locking correctness validator.
>   Workqueue: ice ice_service_task [ice]
>   Call Trace:
>    dump_stack_lvl+0x5b/0x82
>    dump_stack+0x10/0x12
>    register_lock_class+0x495/0x4a0
>    ? find_held_lock+0x3c/0xb0
>    __lock_acquire+0x71/0x1830
>    lock_acquire+0x1e6/0x330
>    ? ice_ptp_release+0x3c/0x1e0 [ice]
>    ? _raw_spin_lock+0x19/0x70
>    ? ice_ptp_release+0x3c/0x1e0 [ice]
>    _raw_spin_lock+0x38/0x70
>    ? ice_ptp_release+0x3c/0x1e0 [ice]
>    ice_ptp_release+0x3c/0x1e0 [ice]
>    ice_prepare_for_reset+0xcb/0xe0 [ice]
>    ice_do_reset+0x38/0x110 [ice]
>    ice_service_task+0x138/0xf10 [ice]
>    ? __this_cpu_preempt_check+0x13/0x20
>    process_one_work+0x26a/0x650
>    worker_thread+0x3f/0x3b0
>    ? __kthread_parkme+0x51/0xb0
>    ? process_one_work+0x650/0x650
>    kthread+0x161/0x190
>    ? set_kthread_struct+0x40/0x40
>    ret_from_fork+0x1f/0x30
>=20
> Fixes: 4dd0d5c33c3e ("ice: add lock around Tx timestamp tracker flush")
> Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
