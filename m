Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEDF4A6EBE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343538AbiBBKcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:32:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:18522 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343528AbiBBKcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 05:32:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643797944; x=1675333944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kisgyZx+r6YHxPfLXxFt+dwXzncdWZBo6K/KqitlpPo=;
  b=S9DsRjgM9foTPEudzkndeWVOCa8xhBzmiJJyxdpNXHQxdpl1x+laOiuJ
   sDnMdKD3fFN2OYd3TIHk2hl7DJzA/tojacBGCZBlZP/MQ9NkVSwNULGAY
   qAJ9UKhEled5VD06h0VDd8EQ36nSwzu+P2J4Jq4Fy4xQD4H6mLuki4OgH
   7dwIjVE8ago7lfSWpmgHKew0azQ92CowWBT03GCi2UbpG37VrR4g3jma1
   OiiJVAQDQoBSwrjhlGEItirtCSP0J1IoYk+AX2z0pGgzJCf8rt2IQLvbB
   C2iY8KrNTs9lFBpE2qGRWfSQ74JivuLQrVJ6KUeCbwKJ1P5LAAiZwMDXU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="311197286"
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="311197286"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 02:32:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="480059413"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 02 Feb 2022 02:32:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 2 Feb 2022 02:32:23 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 2 Feb 2022 02:32:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 2 Feb 2022 02:32:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 2 Feb 2022 02:32:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COuewCyDUAv+vuI2POcZ/Ucf2gbYbdg668RFpaBey24ZTwEIu95gEtKYS9qyBDyKmnTEjPAjId6N5CxGI7uPdbnlcXt6Ch30+cSZbtewmN1RztE8PNXfQK7V8371nsh9H9j/gRyZ49tzaiWJfUKkRG2j7yMqO3t27kdB4PhbPm84UwA0Sa/KF4+JeaMLv8fri/ZG3LudZwIxfMmZytE94WmhtH4ibnPDjXIgVC+J76UXPnq+AtTM742zur69OIGpyxiL4b6qtfWWac0D2ORi7o+Hz2OhAV3i6fYYqbbggr+67FP4sPwupUyzqInUkjn0XnVQLjmnmujg9vcO9udlKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxEcX8pxuTEaPF8BR/61pClEYeRubNbBJRnI9e8lhYc=;
 b=JNo+7/ZVbbQiSykOZJt3dBx6jTxhJ/UmmcJ8Wvv5EddpNuAeUiiMNdJirOJBEUVB3jf3xfmVfj8VIJvYFLjFzKSNxtc4kHq4SE+Ih1T8WYeSX8OipJ95g53RB3nfnyPR6HWo6s4w7iAz2uee99YTBhw2WwDRY62t5+MaiQQ1quRC79LIXYQO+tysN8JndvdBEPPfB9c0ARWO2nyPZPvSvrqF8pxCfipYY/JggeqEAKlNjZ4iTVCXQ+T0rDL7MstNkklOLleynmT3xeCEG70PPhk0zartlg58Cu3H7QKKnxBgb8/Jk3JXCWIgUnl754KCtRj9DHwXPUr959N9K85cwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 MN2PR11MB4519.namprd11.prod.outlook.com (2603:10b6:208:26c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 2 Feb 2022 10:32:17 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::fcc9:90bb:b249:e2e9]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::fcc9:90bb:b249:e2e9%7]) with mapi id 15.20.4930.022; Wed, 2 Feb 2022
 10:32:17 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     "cgel.zte@gmail.com" <cgel.zte@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] ethernet/intel: remove redundant ret
 variable
Thread-Topic: [Intel-wired-lan] [PATCH] ethernet/intel: remove redundant ret
 variable
Thread-Index: AQHYBjIJR9l9yAesv0K+q/Tr2nRQ5ayAM8sQ
Date:   Wed, 2 Feb 2022 10:32:17 +0000
Message-ID: <DM8PR11MB5621F1AA3A53025D348243C9AB279@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220110104656.646861-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220110104656.646861-1-chi.minghao@zte.com.cn>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a4ae482-df71-4689-663d-08d9e63748eb
x-ms-traffictypediagnostic: MN2PR11MB4519:EE_
x-microsoft-antispam-prvs: <MN2PR11MB4519CB0045DE335B80D3FCBBAB279@MN2PR11MB4519.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:389;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W5cu/KEBgYTm+tvTYi/xOf+cYZ6x0/kWUT4z63o5EvlFpkrzeNz+UXwTcBNedAnGGqgNDKfnBQqMvXBYmuBRmuO489TY4imSd83X89AL/nm3TGEMf8AyylCnQ/qYqlntMKMIhpKL7IblqdT5mmYM39iZDGpgPaoKQSG6x9LXzBJIvdZGF6rUzAs6lqkV3guC2H25G9VHd1Mq5UCGyIJdQ1SuzVjbuM3WF0WgHRrU8H8KbQdDeUvNlV0EtD/UUhR630neFbPZtS8aOtbJ16iRPi9IUHesZ5uSSy6k8/zIGQug9giNUGiWKu4vPUsZfVoRI/72+SHkjU9bsSMEgU5H920Gh2EVyo5/I06gwMIsUeeQwzWVpfvVKnF0dC4HQblBmp3a30R09mbScddVwxZS2TjcvAPCDNuow33uRqv0e2KKkvChfWk1QKu+269cfJbWZcVvlAWm5uO3vwWBIa42rdDXwSzoAtWgWVRTN0kEUxMvcwh/mp+gmdDEmw7WJj+c5Th+bgUQ6FiB3wl2pk6q8jzdWVjKgP3yenQm7vguwdSkrLXF2fckRodx+G/SRB2InY7f8wXH2hbzwzHMXm+aG/EfxB2kUp83cXaC0KLaST7M1BqRGoOKZkuQVgh/MVBj7gXh6Pxivs4NdC64ZahK6dJehEQbXSxvH68Qe9bBqMPwOMrv6AFvNhyGS9d3U1NcwZFXcG/kHieaiiitYrEFdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(38100700002)(38070700005)(52536014)(82960400001)(122000001)(5660300002)(4744005)(6506007)(7696005)(9686003)(53546011)(6636002)(316002)(71200400001)(110136005)(8936002)(54906003)(8676002)(83380400001)(66556008)(66476007)(66446008)(64756008)(26005)(186003)(4326008)(66946007)(76116006)(33656002)(55016003)(508600001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C0LyXBIdYEJQRhyr6h/wAwUf1KeZlwvYwxcvCsTd3QIodkewYqg8CIwp+eDP?=
 =?us-ascii?Q?Z8tiseerNnzefbLAi5P1LLZZDDXdyLEdXFXcwoCpehtgRU0PqzOUTo2LxQ01?=
 =?us-ascii?Q?8SXLYDF4oDCCLhLI+j8lNz8zdyPyg/EEY8eKuZbqDh6N8CLzGHfnJUkRspYg?=
 =?us-ascii?Q?AKXeGW8hkqgzGDezyTLrXfNG1sSregtKDL+doce6kZ4uokHMvvod/aBT3295?=
 =?us-ascii?Q?qYeiE1YT9gUVQbTvIlyy2gbantmxyjWsNDmuuj1hdxFiFzCMQx+pwmKRCpIR?=
 =?us-ascii?Q?hFwPY9Udr5lN70lbJQ9ldV6HbblwwMP+4e7Ec1cEnCix9Pi+MldjlelnrS97?=
 =?us-ascii?Q?J+RS4RwTEv+dSk/zfYi6dUhQdGlKHzjDMXOw4U7EVop67K135QgGc5AA6Y92?=
 =?us-ascii?Q?vxQEBKFHKsSR1l62wFqWXQ9MlLJqwgzh5SOCBa5z5y9Ca9yQPnl3Kv2F9Ghu?=
 =?us-ascii?Q?F26OVbeE1t+qYGD6PDCUbmxJMxRXLpDxVqZ4pttfWnTw0l5ayBOf51kTZMvh?=
 =?us-ascii?Q?ZS9TjSA2PIo/3XUT+RYtZ9sMavfu0Q+0F4az3n2ZgLQ1nwKA4nvM3d0UWenA?=
 =?us-ascii?Q?4Jk69hv+q7AdpXLuN9foMWWLrfkZhChdJbGLd87Qnc0B/nrhP0nE3XIiK9vA?=
 =?us-ascii?Q?UdVIxOKOb0qFzrRnHW+YwwvWD4fgdxalhk2rTz49wbDPplTvCEjOrWh/tuda?=
 =?us-ascii?Q?Ujym+GUYloVbmxqZzxfr66sa9vUCnUv0qewR/tjRljDJjUPnn6TH/lPL3atu?=
 =?us-ascii?Q?eQi59TpN7O4pEuyG8xOHkUoHFSqTDvYgd3FuC+i4yyEeu4fWt5bhBsRYBDXC?=
 =?us-ascii?Q?Z1FsziirR6nu11NymCj1UgsRuOi/++fRv0asU989rMqUjtgtG/mbEt5BqSlh?=
 =?us-ascii?Q?PwstucDnRcvrebVL35xAclC/ohqo596NDaIszggznpkx5fxLmfSerK2ipkOW?=
 =?us-ascii?Q?DlSPlgt3HEFfSMAhGsUgw8eomaenO4u7boKtvF3CN6A1JOYIekQbrerW9iVr?=
 =?us-ascii?Q?O0Ds/kQ6IjGx94fQtSodD5T1Yu7GmcLWX1O4xd+UMaQRlFfMQ6jCHCbQPljz?=
 =?us-ascii?Q?9MSBwwBIuZCQ5HavBH9uacDAG0o9zU/JTZ8sG8BSPUuaPJZS9muf8ZO77oe8?=
 =?us-ascii?Q?shM3FvjSJ+ouCrWFkwHGJhUPHAuRbJgoK5+XOVg9VU1I5erzmPgATsxKe/NV?=
 =?us-ascii?Q?rqI9IRf4KH6mSDoQCi7reGyJZw0x4jgayI6MUdi/754y33LkQkloFhoEU/A+?=
 =?us-ascii?Q?/89Fxwo86LfDP1tizkAQitGt+eb0/mYNubLH1oKfdY7ueLcyZC/hE0jHAWtA?=
 =?us-ascii?Q?QtUDcIL7AGfGC2KaylWcq1hsDNaSc94YZgQZF0iL5kjsHdbsuFafqcX7Peqg?=
 =?us-ascii?Q?D0d1FY5ZJFXT/ZqO5v0Y70ZoNh1F9jcxd5gN4nS3CMxXbZuJQ5fSN1NMlzp2?=
 =?us-ascii?Q?hMSuCgopQNlWYdkkpkU7WAdxDnCN9+VyOJHkVnLis5D5zy6jHviaFpFr301m?=
 =?us-ascii?Q?py4aoiWZZkJ3mJgKR/3KLVggA/g6O3ACxOhtOxpnSHIovdQ+7aj2/a+EvZZM?=
 =?us-ascii?Q?wMf0pStSBvqeLC/4wn4UJa7mY/clYEqk5pTMojB3yV0TCgG41UVSkTazsW7O?=
 =?us-ascii?Q?zaaP5CXk0BfrUpwFa0G+1ZH2eqxRoL/OuuAwtqCsEBl73BBjKfTc0dhyKyc+?=
 =?us-ascii?Q?gEtvsA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4ae482-df71-4689-663d-08d9e63748eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 10:32:17.0143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kmbShR3VVZ4X5Y8/LL56TarNvTKLVecyL9ebcK0FUFP44vpMwspNLDOLPLfCyHqME2TGhY0JQGxpGAgLLYUFZTsdkQ8Gql/D7Bno8xOrFic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4519
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> cgel.zte@gmail.com
> Sent: Monday, January 10, 2022 11:47 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: netdev@vger.kernel.org; Zeal Robot <zealci@zte.com.cn>; linux-
> kernel@vger.kernel.org; Minghao Chi <chi.minghao@zte.com.cn>; intel-
> wired-lan@lists.osuosl.org; CGEL ZTE <cgel.zte@gmail.com>;
> kuba@kernel.org; davem@davemloft.net
> Subject: [Intel-wired-lan] [PATCH] ethernet/intel: remove redundant ret
> variable
>=20
> From: Minghao Chi <chi.minghao@zte.com.cn>
>=20
> Return value directly instead of taking this in another redundant variabl=
e.
>=20
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 504fea4e90fb..a138dc64b8b7 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
