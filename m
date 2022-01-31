Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA54A3D77
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 06:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiAaFkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 00:40:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:38141 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbiAaFkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 00:40:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643607616; x=1675143616;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yeJElFuWT6FuEkGgE7Mj6IqOiLW//OS8suwDonQfTJg=;
  b=D7fFlVfCNckjKNhf1R/DCC5KCmUlwLB6ddXVMTcMGEVOGBQAaEMX05Cf
   15SEUUIBqsGTHn1Iz72WmhfrWjiu445WgYoc8p8j1596BD/57kRiy04oG
   ypPrRjPNQcv6W3gLQtX2sjgirjkZM6yByf/TCn2GT635zXeeccpyZ1Rgj
   2kNJaj8zkNiONCv2ddGdTHxHxFlOzorcqe5YptjKUnWjQ1ji+NMTTZsrm
   fn+g7pPTOfIP5WLZxpGi83S7dYMKghS3tXmzn8iOlzYrBzlxaqp1OI+B8
   MP24yQDwiEIODNw5eYoEKCsBm+skCOXh3PYtrc4NAOHiotMi/Gkcjjply
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="234795491"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="234795491"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2022 21:40:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="697890316"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 30 Jan 2022 21:40:02 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 30 Jan 2022 21:40:02 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 30 Jan 2022 21:40:02 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 30 Jan 2022 21:40:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pv4DNWUOHpr2s+eejWv74Jf0QJItQq/bpR/IrvAHiCrFKUwmZOAK3390SfvDT0yx/bdWYSz1OQECwbKPVHTDonOA1O2Wgh1xUPb2bLUgd0fZbZreIedgnZ1+5UHF1TRn2zU0769kiK8V4kHQxeLLxwY3w0pg4oGuNeZOLDEk2sKsef9dUhmvVs+6wZos4Ui4NaTE7BO0lo7LjyIQx6XB93hP3n+MX9T9Qz5TnDgnGB4y80bto5VezGi0sT6VYB046BcMbcuFrBHZmnmqY1n3GMYrmgcZDhY1p0mWFsVweBKii2G8Q4895zyM7mvLqHASDG1LKGTOjua/8JsNEL4cGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thWJLu45BTB6DJ3hQ6OZxVRf0PY9KuLcQUSxoUAebOg=;
 b=AQAtbMkzTYsFQVKqoVd1mcEl4lyK7ehLZ2GSc64w00dPuNUCsqVSK509BLeYQ8qVRWw2L442fvPjvhbNWEuCQHO+o6Xd1eAzlT4VJdbcXb0WZklu9frIjYvstIf2z8GqJXEBGjyRNchrN6HgaM5u9HFWKOypy5z8zOhvg1CxD1l3Ptv0I03xI7xPVUL68fSdzyhiDRfqyZYYAvrovQhHs4v3dPdVVNWwKd0+ZrCKpwagH+Jx+VmoWfh6eMmAELVBGZumBhrDl6UgsqsX9Im6fNQvYM6yTJyOx9BmAEtB4dPVPWB9qI18HiRdZq1yOUIe71CYt5pY1xBtzVvn2pwqbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MWHPR11MB2030.namprd11.prod.outlook.com (2603:10b6:300:28::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 05:39:59 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4930.019; Mon, 31 Jan 2022
 05:39:59 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: remove enum i40e_client_state
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: remove enum i40e_client_state
Thread-Index: AQHYEua23+W8TcVWAE+31SuA3Et2zqx8o/MA
Date:   Mon, 31 Jan 2022 05:39:59 +0000
Message-ID: <BYAPR11MB3367D6CDC65D197042554D7CFC259@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220126185544.2787111-1-kuba@kernel.org>
In-Reply-To: <20220126185544.2787111-1-kuba@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0fd16413-400d-4b5a-b0cd-08d9e47c1ef0
x-ms-traffictypediagnostic: MWHPR11MB2030:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB2030AE90AE6C1C0C78981AB2FC259@MWHPR11MB2030.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:225;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WCv/DougXsp0Fa2tnehPmpQy/R/RwuCTjhSv+20cpmww9xY3b7kmKbFuL5/gDdX9nFpQSRha8g3trwQgsYrY/CPpfKurDTgPZO3tLDIVdt4fUQKTOQZ3y/fNohT2d+7lzWBl9U98Qg2keMMXP1rABp52LpXw98gF9OW7BzlGljOEkC6OIHD1EhkIKHbiZ8L9cXfz5o5HwazfgNGiaYvxgyH4lN+lZGT6yHvm6C8inIpwztXq4YirnVk/TPkcNk8+6FVlpm1L2Pu1yGGoztpy25H2j8znu8xOxvVaKxhIbSPYAJJsteLuL2XK4ZjCWFNxZqXnRtVmkNr7sHjgMHZfhwPgnk6uZYja2sY5ibWG1NU2h1YixhbzoE1+1eY4m+LzoSgRSVfvUfFDKUADAABWba8XjbPlWTqk3xEMQXQqNI/Yy8Y/VL9I2ajIojajbjdloNGiOIAzTxMmStNJbWL/74Bxka6GxdRMwXfjuYA6U3ItVqWS60CEEUx8TtLrfmXfJS61Z3Gha3zM8y7gYIRfNM/2SW/D+HpcGYRwubK80kBT327LbQ6tvPiv2kmKO5a84Xg7JcHwnRtYTHFhJ8E7iiEf8sM8CxWrTx25veyhN3J7MzTIc84pUTefV7k7hOsJMm1i2yb37VG6m4QbGmF/P7CjuCDS07zfRS/Vb/ocQXDXw2ZaKcH1y1ZUarR1eKji+UiXW7rO7rAkfx8KKiEUXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(4326008)(66446008)(8936002)(66946007)(76116006)(8676002)(55016003)(38070700005)(86362001)(82960400001)(122000001)(64756008)(38100700002)(66556008)(33656002)(71200400001)(53546011)(52536014)(9686003)(5660300002)(7696005)(6506007)(508600001)(110136005)(83380400001)(6636002)(54906003)(316002)(2906002)(4744005)(107886003)(186003)(26005)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WI2JoLQ4crWlFYGODoL44jsyhsgGeGrtenofOBbFdAjvnZf0xoBm5N3kvcqk?=
 =?us-ascii?Q?11duy4h0X86X0ISGQv4uGq74qRsxHW8YFny83WkzehTODI34Sihkj5cj9sUB?=
 =?us-ascii?Q?0WaPujXw5E6me37Qh+ng3hU0FfMH6aXtSchyiHSipp0NrvL47LO02GYFb1R2?=
 =?us-ascii?Q?Qd7l1AoEnBcfDS8Iwnz2UVZgl7nlYAUgl8pJ7srCBK+G3AiH86H4hur64bLF?=
 =?us-ascii?Q?XuskD1aRoKZPKskU3IbDx7E56oUwSqj1JkInZOexK0h4MkTBzWx8j77ClyXK?=
 =?us-ascii?Q?GUpBN6NPCqNJiwnxe6YHt1SYrlIObLC46e22/UFJtU/cQ09/zzXGqDBoA/xM?=
 =?us-ascii?Q?1vGURPX88/5LOWTu2hBZRWsXol5JfOHe2mst+cEiz4fURvtgKm2x3/wNk6Rk?=
 =?us-ascii?Q?8taJULmMc3OSsdhPUt4+YF0JoTM/XxU7bgX8D7EEYCVMk5lV0iSns/4moYVU?=
 =?us-ascii?Q?KgEmld0glgLjWmytfueqH5VwDxOZ/Z26L4MTWeDHhhpLX5LMgAHaRZKCN5Ek?=
 =?us-ascii?Q?BXkDG+P+wgYgR2Oc2NaRpWYmgFi0fAjTUwO7wRfxw/c7Qyu947y/eLBk1cgj?=
 =?us-ascii?Q?MyLpjcvRe7cfxGJv32N0XgM5hsBZw3Pv6vcpDA/0PSg6CiMcnullp/PPUsu8?=
 =?us-ascii?Q?3AdPv+Z/6tONIhej5HaSrRglW/P6iGzhgrq3ArX4qYpoAlymaEJtBrWHfoC8?=
 =?us-ascii?Q?BENz+cDNQFa4Qsr0Qiyz5TAWa5jejJKbwO1Z2IKkKIMs/AuXYTYulQUWB9j4?=
 =?us-ascii?Q?ATFim43C4m+mU1LiOHt7qKBgljHsFbmmst6nMdXV9P8NwjbHBp0Ffp+87Lan?=
 =?us-ascii?Q?CqZoAe6Z3J6xC1aC3t4kFr1uT4f4ElR0fpdrefk+y8kbzB+oqKAMJCx5B+TJ?=
 =?us-ascii?Q?YCV6N2cL42uXtnFY3RNh6ZFp92OmtiHWazJyXdon6JJkbaiFqVJsh2YXABvG?=
 =?us-ascii?Q?J1H6RBYj3LMZorVXAZxwonuiJBIzKU8wq2XVpVW7MZCtSxhExlwm0OhYmD6q?=
 =?us-ascii?Q?xpykOQrxqqfbLj6Cepy8O+vkIJZ+Yehlof6fybpQaNBXgs+wnw+PTYFXAkEn?=
 =?us-ascii?Q?od0MGZv1eJDmbdNEe5bqJsVEeIaLvn2RvEGvzsvR9VpFGudyQpGOqcOmARch?=
 =?us-ascii?Q?8PyRTqWo5ZisU//VD5NosdFFn922LO9sOJYLumyEBFudDcfkSb+ljFPBec8b?=
 =?us-ascii?Q?3LB3qR50XxXQC0zVAjRM/islmAq75VwHW+xzq4649f9cbQq+vpmjDTWmQj0g?=
 =?us-ascii?Q?h8UKbXJHyYl0z+KPsw1tGbfzh7rY5fWW6sSY4bxkoZ7XqIF34wUTXxyjH+qT?=
 =?us-ascii?Q?0bSGE1Q3wD0qKjhmnza2ArvJ+FH0vbRwACbG7teRMeO8czsfVPA35qMUI1qc?=
 =?us-ascii?Q?fdK6APAFVHFmY3lQK6JzkRfRo5iRLdlk4yBjTPD32JClAN96H2W2A26vGCfc?=
 =?us-ascii?Q?BLQsXqtbqU9Xf8z+8ruZbNGIfdDp5tg5bDkAZPIyHg5uFK3bz0g4PD8Vte75?=
 =?us-ascii?Q?6r5Z3lZ8VK6dp3RpCmwBeNT39+UPbTbYTlSlYMlqJmy9e6rPgT3vKNXyggl+?=
 =?us-ascii?Q?WkLdB5f4fKHh2f5uAuhWhWeDWUNS0bs5cbrkMqnvueMXnwbKcrcoI9fmGkSC?=
 =?us-ascii?Q?jQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd16413-400d-4b5a-b0cd-08d9e47c1ef0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 05:39:59.4710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5v4E9Q4ijd34h+TMrp9ly/iu4Pl7FCKHqvQy2MH3a6pbtwAHRkdu+48FLPXUHMsSXqVrAaT0h7+GlFg5ZYHHQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2030
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Jakub Kicinski
> Sent: Thursday, January 27, 2022 12:26 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Saleem, Shi=
raz
> <shiraz.saleem@intel.com>; Jakub Kicinski <kuba@kernel.org>
> Subject: [Intel-wired-lan] [PATCH] i40e: remove enum i40e_client_state
>=20
> It's not used.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/net/intel/i40e_client.h | 10 ----------
>  1 file changed, 10 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
