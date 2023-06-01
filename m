Return-Path: <netdev+bounces-6957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 510127190AB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 04:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF2C3281669
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 02:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498A91C17;
	Thu,  1 Jun 2023 02:46:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA3F1390
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 02:46:51 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10942101;
	Wed, 31 May 2023 19:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685587606; x=1717123606;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6lkHEhE1iWiSAPWDY236zin8IEdNUDC3ULf1sDxObno=;
  b=TeVXpZw+eVugnY7RaPGPxCtSEYvi0R1kYXyEWZce3AtaA+zhgpt7uglM
   5Z02CNimsyAWMXREHrknpzvdCr/aotXHwKVn8df3D2THM+oZTnBilR8Yd
   5Z0wxVfusnwQNDOMBelESGQNIbVEIz1927bvnKekktGEel0oa6uw9QAdG
   KL92nvBTxfrWWKhFqEWdBKeZoWlVZP1/knXQJwN7/WSWFSoIZXr8udAP5
   DU3nvyaL8y4hITrADdroa4zydGunleDA+GbLxV+a0FObe1Nh7SUVbzT2U
   tBdm9mgXmwp4mu5MjgdsDzrKNPdgkAH7Hnh8MDuL6jBPz7dTnBp1ut5mZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="335782632"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="335782632"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 19:46:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="772221066"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="772221066"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 31 May 2023 19:46:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 19:46:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 19:46:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 19:46:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 19:46:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNkcNIuxKziqJy+cD2E7pKD35hSryW+WABveSrE6FCxZwoBTpNCooe+FWjlAW/zRtRpqHqjuA3Mt+5FmRFXV0oA1WDmr7m9TBLjDZi8M8w9rak7SUZj0aABn6ZbHnwP2Q9XctS8vRlB+clmNyaheUluR9fdODZ6IcLvoqBzS6evB3YUmOcmdqfnQ+xu3YbdxeRi5w+PWp4OYj1o6mr2IaseWP1TgKDdmFgg6YS2GV72ET59+eKXeKF05WTCohOC3z6mbOFtVWnF8gkRPj5nw0KTe8P16PLOWcq/uEl8vDcsDQ8Zp229/Q5uixWEuDcJ/ii4tYKFZHki7OAEuNTUaWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVwOMdZN3hOOk9RGi0CE0NgJjCkq7JbDMIdTJhwQlWQ=;
 b=VlSL2yJL8ZCoi4HUkffmVNyUS/rgxKXiqsGr2zYpfYzwObwAHCmzJ8Lryr7tA+yG5f4s1OMlATrEgoe38QiyLetUL+OYgcN/1LyFdazA8ia6F65f+YoM6vHEOuj9k9riE05tjsB4nwqST3/GE+b8gS2U4R3v7/n6RkOYHp/jGBmBzVlW6KIMmfGOjrT5RF3DBY8BVzpt9jAcmL5Rr6dM5su1K4IBHZOvp1Te3+GCbB0mCbjfbx3UicfWAseA0WP0nq7lSnczcKX4/rpDYWsUoTEnE2REaD4YOJawlWAJD2UbHGzriHz2JA3aFW5aqjGcGdmAyP+slmUlYnwxFy2geA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by MW4PR11MB7056.namprd11.prod.outlook.com (2603:10b6:303:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 02:46:32 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%6]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 02:46:32 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: "Sang, Oliver" <oliver.sang@intel.com>, Shakeel Butt <shakeelb@google.com>
CC: "Yin, Fengwei" <fengwei.yin@intel.com>, "Tang, Feng"
	<feng.tang@intel.com>, Eric Dumazet <edumazet@google.com>, Linux MM
	<linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Li, Philip" <philip.li@intel.com>, "Liu, Yujie"
	<yujie.liu@intel.com>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAIAAMNEAgABhfVCAAGbfEIAADugAgAATvZCAAM4SAIAAWFPwgAANFgCAAB1pgIAAB41ggADEcICAA9Lr8IAACR4AgAAk3qCAAOD6gIAApqKAgAJEjYCAFYB+AIABLblA
Date: Thu, 1 Jun 2023 02:46:30 +0000
Message-ID: <CH3PR11MB7345B6FD9B9512BB8913440DFC499@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
 <20230517162447.dztfzmx3hhetfs2q@google.com>
 <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020>
In-Reply-To: <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|MW4PR11MB7056:EE_
x-ms-office365-filtering-correlation-id: a94af3dd-960a-4320-a4ae-08db624a67b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Gd5aXH9vAsNRqfuuCYMDiuSc4rk0l+ZC7gM2j3GdE2/nRhwQdHSaVkHQj4DV2qlhZlDnaoqUf5II+TuZCUKqYE+AdJFYaO3d9yoIFqS9I1XaFUKALiI8eT9HvMUC1So1GcfomShIrfsjZn2Zm7h15wGtA0t87kLdDkF3qZI+4zZJBiIIyN1Mc8tt3d9Bx1hr/XnYKiQR8oAOGpGSqMIJMqdsKYK+rC/QoSSsOLYQWF7Nx53XZJPoZ/IK2RTgUNg06Nw6wubJSLlcJ1cn3KNa3yBNgtQ0H7xkTcmkHwUrTEM+Pigetqi0g91oi2YGpS5WQwIqSvLa1IigK7J5jki4aJZ/eXOO2j+CYApobxQbmlMcbt9a3HWq+8naoLosSgR5pjFDHZXSLlGZNTyEpDpJLFos/mUJFQMwXOQtB95YZboZvZ0h2PwSYpCw/dBX0Pu+PIs1JSxEGOqhqx5tQPPZDTOhpzLxCxuPNgZbsEHLZN2f6vO1fRRA2CmOJioYapceT4S7n6u1giHa7TFPhxfqF3Fba32MKDMa6T7ZkdIL9EcATKBaPRE0ySunD18RD7ZAqKbRz2M2rJUcsSHnfp9l7JplEgET2bcp7jxhLNnMwkjzspEk5sqjPwsKSxyitArUkm2dOPLSCTcqKiabZ2uLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(38100700002)(83380400001)(122000001)(86362001)(4326008)(45080400002)(478600001)(76116006)(64756008)(30864003)(66946007)(66446008)(66476007)(66556008)(2906002)(54906003)(19627235002)(110136005)(186003)(7696005)(966005)(53546011)(9686003)(6506007)(71200400001)(316002)(107886003)(82960400001)(52536014)(26005)(5660300002)(55016003)(8676002)(38070700005)(8936002)(33656002)(41300700001)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?D0Z2Iqu5F9FByHI0qk/yUoMzfiGTi2x6jK4GNJ8MTW5OkjPn5laPk7C31P?=
 =?iso-8859-1?Q?v2lAP3Dim8s0jQ9axD0ixy7ctIe9+2aawRnjfR8LjNnW+0F73eJY6izaT4?=
 =?iso-8859-1?Q?tJ/6qYtJkkJgUuTzjJs3MgF4twxNhHvL2KlluMX6kifdlzBqEyQvkyRQNp?=
 =?iso-8859-1?Q?6Vt61uF2vB6GkXqpRCKshhH/ZXhGk6SFOE6ZYnlFX3xWdmzOBflI3lyUis?=
 =?iso-8859-1?Q?xKqvSGN8yKXQjIEGf5duPWe5//SP187uhaYMOi63h7GKPcIO8dg0oucte1?=
 =?iso-8859-1?Q?bH+sxlRP+FetrSOlIUBEYALFSaENu7pVD0Ji8t8tW33r1NhChhjr5zt1re?=
 =?iso-8859-1?Q?I/8ivZBuNjImJ2KCh+7o8Tf1JTP1YwjOXKVCMjQxoku2fjqxjEuKKwW+3z?=
 =?iso-8859-1?Q?ACWzuJoG6tow4G0If2Tob6yFU2CiM2FxHdYUhe/FIB44f8VzWwJk0n7d4Z?=
 =?iso-8859-1?Q?nNJAbAftkTw5XPqF1zODfpNzKBn1DgNs4EBmPR1fartx7BtWt3wXXPubpQ?=
 =?iso-8859-1?Q?jWD4jsATBaY8OkwEOg62Ydb7XiOz/Akh/PNlc85RqMyvGzUx2kedRSfmQR?=
 =?iso-8859-1?Q?GTg3O9LTxZh+yIHvnye+JcaObps83rdliPQGGMeGmrrz+1GQqy/dQaTr4l?=
 =?iso-8859-1?Q?CzQCHFDjIN0o3/qKj8+Yssj4yaYjk6kP7U4He0uWPXpz149cAT/jtp15su?=
 =?iso-8859-1?Q?xepbAfeucDAYNFi/ZO1Z1bOHqBF7l9s1K5fa+Ky3WkwpKMdmLvuWsvIiqj?=
 =?iso-8859-1?Q?Yyy90tVuXtpvrpDAgilJe9I0HzOotLRp8TSTpIwEM6gNEBNocL9tlNuzlR?=
 =?iso-8859-1?Q?+3tj9FGGwRrq4MjToz0L40qoGZlDYuDEYCpC/Lw7r5po8f6AOo7THeHMne?=
 =?iso-8859-1?Q?es5s/5j/jOOqqowGZMsI30bZm+LvbCeAVQDUUh4x+zGcYUhtvyX+ou9vsx?=
 =?iso-8859-1?Q?ouYCAi9Q9QA6ozRtfP/bg76RNCzTePqOsECjQrtgX9pD8juvzw2UXiI+nW?=
 =?iso-8859-1?Q?NRXro82GVR5f0GCFDhqqQhIEfVsMqMYtd5iT0ShZdQrrLPljtETnKluxXD?=
 =?iso-8859-1?Q?+n3CoXDQxvaWE9PV0XTFQUtVXc7v/KN95Hp6j1dLPaRig7XXXcD5iTKCVP?=
 =?iso-8859-1?Q?aJzWd3eKMYJHusaw5UtM928Khnzi+gg/ybOGifdJFGeheuKmImMcxArfqh?=
 =?iso-8859-1?Q?/Z3TgHrNzZWC0dmm4IwwWRM9k2IOwuI25s+Mn3w4BOPI8JOFN3781wV+qZ?=
 =?iso-8859-1?Q?fbh4MKi1GpAde6vk3Fqv3ru9jkx4rFz77fWF9wBxrKGPcu1XV5zsPqmgRe?=
 =?iso-8859-1?Q?ddMC0VW4CpsYIWcSQmZO9WavWsgSJbOGITo5QgITzjcB1/qH2S60ewNjNW?=
 =?iso-8859-1?Q?T6ZE3hib74RwA5Pdjzc79HQEFCR8gcYQC5mjIs6+n+femMd1LapAesvsgQ?=
 =?iso-8859-1?Q?1yYFbeK//Q95UEM7Rq1lrJ8M0s9ue2UyX626HOyK8OpQcA8VV45u4v1S3J?=
 =?iso-8859-1?Q?qZMIazeqZQedxI8teNn2gKJ1Fkt2CgrW0o6Iyh1cEoF7W8qpEFe8di4O1f?=
 =?iso-8859-1?Q?rxlmHDkzQFFyIkvUoKUF/bniaSVp+t5243VB/dzZGdVDmwcmRaRYUgGkpR?=
 =?iso-8859-1?Q?ZAPLwi4YpzFgnWsQIwC3xd4fHnvk8pYYU3?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a94af3dd-960a-4320-a4ae-08db624a67b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 02:46:31.0283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p0PVpzXPnNH58jKtSzSdW92Engiqj7mZJzCv8sV/HFSY/KUHjnbYhDw57vapsGCMaXGA9oqyyb2FgfnlygLPCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7056
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks for sharing the data, Oliver!

> -----Original Message-----
> From: Sang, Oliver <oliver.sang@intel.com>
> Sent: Wednesday, May 31, 2023 4:46 PM
> To: Shakeel Butt <shakeelb@google.com>
> Cc: Zhang, Cathy <cathy.zhang@intel.com>; Yin, Fengwei
> <fengwei.yin@intel.com>; Tang, Feng <feng.tang@intel.com>; Eric Dumazet
> <edumazet@google.com>; Linux MM <linux-mm@kvack.org>; Cgroups
> <cgroups@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> davem@davemloft.net; kuba@kernel.org; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Srinivas, Suresh
> <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org; Li, Philip <philip.li@intel.com>; Liu, Yujie
> <yujie.liu@intel.com>; Sang, Oliver <oliver.sang@intel.com>
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> hi, Shakeel,
>=20
> On Wed, May 17, 2023 at 04:24:47PM +0000, Shakeel Butt wrote:
> > On Tue, May 16, 2023 at 01:46:55PM +0800, Oliver Sang wrote:
> > > hi Shakeel,
> > >
> > > On Mon, May 15, 2023 at 12:50:31PM -0700, Shakeel Butt wrote:
> > > > +Feng, Yin and Oliver
> > > >
> > > > >
> > > > > > Thanks a lot Cathy for testing. Do you see any performance
> improvement for
> > > > > > the memcached benchmark with the patch?
> > > > >
> > > > > Yep, absolutely :- ) RPS (with/without patch) =3D +1.74
> > > >
> > > > Thanks a lot Cathy.
> > > >
> > > > Feng/Yin/Oliver, can you please test the patch at [1] with other
> > > > workloads used by the test robot? Basically I wanted to know if it =
has
> > > > any positive or negative impact on other perf benchmarks.
> > >
> > > is it possible for you to resend patch with Signed-off-by?
> > > without it, test robot will regard the patch as informal, then it can=
not feed
> > > into auto test process.
> > > and could you tell us the base of this patch? it will help us apply i=
t
> > > correctly.
> > >
> > > on the other hand, due to resource restraint, we normally cannot supp=
ort
> > > this type of on-demand test upon a single patch, patch set, or a bran=
ch.
> > > instead, we try to merge them into so-called hourly-kernels, then
> distribute
> > > tests and auto-bisects to various platforms.
> > > after we applying your patch and merging it to hourly-kernels sccussf=
ully,
> > > if it really causes some performance changes, the test robot could sp=
ot
> out
> > > this patch as 'fbc' and we will send report to you. this could happen
> within
> > > several weeks after applying.
> > > but due to the complexity of whole process (also limited resourse, su=
ch
> like
> > > we cannot run all tests on all platforms), we cannot guanrantee captu=
re
> all
> > > possible performance impacts of this patch. and it's hard for us to
> provide
> > > a big picture like what's the general performance impact of this patc=
h.
> > > this maybe is not exactly what you want. is it ok for you?
> > >
> > >
> >
> > Yes, that is fine and thanks for the help. The patch is below:
>=20
> we applied below patch upon v6.4-rc2, so far, we didn't spot out
> performance
> impacts of it to other tests.
>=20
> but we found -7.6% regression of netperf.Throughput_Mbps
>=20
> testcase: netperf
> test machine: 128 threads 4 sockets Intel(R) Xeon(R) Gold 6338 CPU @
> 2.00GHz (Ice Lake) with 256G memory
> parameters:
>=20
> 	ip: ipv4
> 	runtime: 300s
> 	nr_threads: 50%
> 	cluster: cs-localhost
> 	send_size: 10K
> 	test: TCP_SENDFILE
> 	cpufreq_governor: performance
>=20
>=20
> To reproduce:
>=20
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         sudo bin/lkp install job.yaml           # job file is attached in=
 this email
>         bin/lkp split-job --compatible job.yaml # generate the yaml file =
for lkp
> run
>         sudo bin/lkp run generated-yaml-file
>=20
>         # if come across any failure that blocks the test,
>         # please remove ~/.lkp and /lkp dir to run from a clean state.
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/s
> end_size/tbox_group/test/testcase:
>   cs-localhost/gcc-11/performance/ipv4/x86_64-rhel-8.3/50%/debian-11.1-
> x86_64-20220510.cgz/300s/10K/lkp-icl-2sp2/TCP_SENDFILE/netperf
>=20
> commit:
>   v6.4-rc2
>   5e32037c50 ("memcg: skip stock refill in irq context")
>=20
>         v6.4-rc2 5e32037c5065d2058264d41cd4c
> ---------------- ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>      23165            -7.6%      21414        netperf.Throughput_Mbps
>    1482569            -7.6%    1370534        netperf.Throughput_total_Mb=
ps
>=20
> detail data as below [1]
>=20
>=20
> at the same time, we tested Cathy's patch upon same test, found
> a 29.4% improvement of netperf.Throughput_Mbps
> just FYI
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/s
> end_size/tbox_group/test/testcase:
>   cs-localhost/gcc-11/performance/ipv4/x86_64-rhel-8.3/50%/debian-11.1-
> x86_64-20220510.cgz/300s/10K/lkp-icl-2sp2/TCP_SENDFILE/netperf
>=20
> commit:
>   ed23734c23 ("Merge tag 'net-6.4-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>   05d72a8bed ("net: Keep sk->sk_forward_alloc as a proper size")
>=20
> ed23734c23d2fc1e 05d72a8bedfacfc46f300ab38e0
> ---------------- ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>      23218           +29.4%      30043        netperf.Throughput_Mbps
>    1485996           +29.4%    1922763        netperf.Throughput_total_Mb=
ps
>=20
> detail data as below [2]
>=20
>=20
> [1]
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/s
> end_size/tbox_group/test/testcase:
>   cs-localhost/gcc-11/performance/ipv4/x86_64-rhel-8.3/50%/debian-11.1-
> x86_64-20220510.cgz/300s/10K/lkp-icl-2sp2/TCP_SENDFILE/netperf
>=20
> commit:
>   v6.4-rc2
>   5e32037c50 ("memcg: skip stock refill in irq context")
>=20
>         v6.4-rc2 5e32037c5065d2058264d41cd4c
> ---------------- ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>    5106608            -1.3%    5040930        vmstat.system.cs
>     246222 =B1  4%     -21.9%     192291 =B1  8%  sched_debug.cpu.avg_idl=
e.avg
>     269582 =B1  6%     -24.9%     202436 =B1 13%  sched_debug.cpu.avg_idl=
e.stddev
>       2556            +0.9%       2579        turbostat.Bzy_MHz
>      15.01            +0.8       15.76        turbostat.C1%
>      30.63            +4.2%      31.90 =B1  2%  turbostat.RAMWatt
>      23165            -7.6%      21414        netperf.Throughput_Mbps
>    1482569            -7.6%    1370534        netperf.Throughput_total_Mb=
ps
>     670.10           -11.8%     591.36        netperf.time.user_time
>  5.429e+09            -7.6%  5.019e+09        netperf.workload
>       6.93            +6.4%       7.38        perf-stat.i.MPKI
>  4.404e+10            -5.4%  4.167e+10        perf-stat.i.branch-instruct=
ions
>       0.88            +0.0        0.90        perf-stat.i.branch-miss-rat=
e%
>  3.823e+08            -2.7%  3.721e+08        perf-stat.i.branch-misses
>       6.54 =B1  2%      +0.4        6.90 =B1  3%  perf-stat.i.cache-miss-=
rate%
>   1.05e+08 =B1  3%      +6.3%  1.117e+08 =B1  3%  perf-stat.i.cache-misse=
s
>       1.29            +5.8%       1.37        perf-stat.i.cpi
>      27150 =B1  6%     +14.9%      31203 =B1  5%  perf-stat.i.cpu-migrati=
ons
>       2897 =B1  3%      -5.7%       2733 =B1  3%  perf-stat.i.cycles-betw=
een-cache-
> misses
>       0.01 =B1 12%      +0.0        0.01        perf-stat.i.dTLB-load-mis=
s-rate%
>    6712601 =B1 12%      +7.8%    7237514        perf-stat.i.dTLB-load-mis=
ses
>  6.874e+10            -5.4%  6.505e+10        perf-stat.i.dTLB-loads
>       0.00 =B1  5%      +0.0        0.00 =B1  5%  perf-stat.i.dTLB-store-=
miss-rate%
>     940096 =B1  5%     +15.3%    1083508 =B1  5%  perf-stat.i.dTLB-store-=
misses
>  3.753e+10            -5.5%  3.547e+10        perf-stat.i.dTLB-stores
>  2.332e+11            -5.4%  2.207e+11        perf-stat.i.instructions
>       0.77            -5.4%       0.73        perf-stat.i.ipc
>       1186            -5.3%       1123        perf-stat.i.metric.M/sec
>     706578 =B1  8%     +33.2%     941322 =B1  5%  perf-stat.i.node-loads
>    2812685 =B1  8%     +15.6%    3250382 =B1 10%  perf-stat.i.node-stores
>       6.93            +6.4%       7.37        perf-stat.overall.MPKI
>       0.87            +0.0        0.89        perf-stat.overall.branch-mi=
ss-rate%
>       6.50 =B1  2%      +0.4        6.86 =B1  3%  perf-stat.overall.cache=
-miss-rate%
>       1.29            +5.8%       1.37        perf-stat.overall.cpi
>       2878 =B1  3%      -5.8%       2711 =B1  3%  perf-stat.overall.cycle=
s-between-
> cache-misses
>       0.01 =B1 12%      +0.0        0.01        perf-stat.overall.dTLB-lo=
ad-miss-rate%
>       0.00 =B1  5%      +0.0        0.00 =B1  5%  perf-stat.overall.dTLB-=
store-miss-rate%
>       0.77            -5.5%       0.73        perf-stat.overall.ipc
>      12903            +2.4%      13208        perf-stat.overall.path-leng=
th
>   4.39e+10            -5.4%  4.154e+10        perf-stat.ps.branch-instruc=
tions
>   3.81e+08            -2.7%  3.708e+08        perf-stat.ps.branch-misses
>  1.047e+08 =B1  3%      +6.3%  1.113e+08 =B1  3%  perf-stat.ps.cache-miss=
es
>      27021 =B1  6%     +14.9%      31054 =B1  5%  perf-stat.ps.cpu-migrat=
ions
>    6672234 =B1 12%      +7.8%    7195318        perf-stat.ps.dTLB-load-mi=
sses
>  6.852e+10            -5.4%  6.484e+10        perf-stat.ps.dTLB-loads
>     935167 =B1  5%     +15.3%    1077856 =B1  5%  perf-stat.ps.dTLB-store=
-misses
>  3.741e+10            -5.5%  3.536e+10        perf-stat.ps.dTLB-stores
>  2.324e+11            -5.4%  2.199e+11        perf-stat.ps.instructions
>     704145 =B1  8%     +33.2%     938240 =B1  5%  perf-stat.ps.node-loads
>    2802795 =B1  8%     +15.5%    3238090 =B1 10%  perf-stat.ps.node-store=
s
>  7.006e+13            -5.4%  6.629e+13        perf-stat.total.instruction=
s
>      11.29            -0.9       10.42        perf-profile.calltrace.cycl=
es-
> pp.skb_copy_datagram_iter.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.
> sock_recvmsg
>      11.22            -0.9       10.35        perf-profile.calltrace.cycl=
es-
> pp.__skb_datagram_iter.skb_copy_datagram_iter.tcp_recvmsg_locked.tcp_r
> ecvmsg.inet_recvmsg
>      29.43            -0.7       28.74        perf-profile.calltrace.cycl=
es-
> pp.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.sock_recvmsg.__sys_recvf
> rom
>       7.04            -0.5        6.51        perf-profile.calltrace.cycl=
es-
> pp._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.tcp_recvms
> g_locked.tcp_recvmsg
>       7.36            -0.5        6.86        perf-profile.calltrace.cycl=
es-
> pp.generic_file_splice_read.splice_direct_to_actor.do_splice_direct.do_se=
ndf
> ile.__x64_sys_sendfile64
>       6.56            -0.5        6.06        perf-profile.calltrace.cycl=
es-
> pp.copyout._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.tcp
> _recvmsg_locked
>       6.45            -0.4        6.03        perf-profile.calltrace.cycl=
es-
> pp.filemap_read.generic_file_splice_read.splice_direct_to_actor.do_splice=
_d
> irect.do_sendfile
>       2.95            -0.3        2.61 =B1  7%  perf-profile.calltrace.cy=
cles-
> pp.__check_object_size.simple_copy_to_iter.__skb_datagram_iter.skb_copy
> _datagram_iter.tcp_recvmsg_locked
>       2.58 =B1  2%      -0.3        2.29 =B1  7%  perf-profile.calltrace.=
cycles-
> pp.check_heap_object.__check_object_size.simple_copy_to_iter.__skb_data
> gram_iter.skb_copy_datagram_iter
>       3.22            -0.3        2.93        perf-profile.calltrace.cycl=
es-
> pp.simple_copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.tcp_r
> ecvmsg_locked.tcp_recvmsg
>      10.00            -0.3        9.75        perf-profile.calltrace.cycl=
es-
> pp.__dev_queue_xmit.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_s
> kb.tcp_recvmsg_locked
>      10.15            -0.2        9.91        perf-profile.calltrace.cycl=
es-
> pp.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb.tcp_recvmsg_loc
> ked.tcp_recvmsg
>       2.89            -0.2        2.66        perf-profile.calltrace.cycl=
es-
> pp.filemap_get_read_batch.filemap_get_pages.filemap_read.generic_file_sp
> lice_read.splice_direct_to_actor
>       3.12            -0.2        2.90        perf-profile.calltrace.cycl=
es-
> pp.filemap_get_pages.filemap_read.generic_file_splice_read.splice_direct_=
t
> o_actor.do_splice_direct
>      10.47            -0.2       10.25        perf-profile.calltrace.cycl=
es-
> pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_recvmsg_locked.tcp_recvmsg.i
> net_recvmsg
>       2.66            -0.2        2.44        perf-profile.calltrace.cycl=
es-
> pp.tcp_write_xmit.do_tcp_sendpages.tcp_sendpage.inet_sendpage.kernel_s
> endpage
>       2.42            -0.2        2.22        perf-profile.calltrace.cycl=
es-
> pp.__tcp_transmit_skb.tcp_write_xmit.do_tcp_sendpages.tcp_sendpage.inet
> _sendpage
>       2.48            -0.2        2.29 =B1  7%  perf-profile.calltrace.cy=
cles-
> pp.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_
> rcv.ip_protocol_deliver_rcu
>       2.46            -0.2        2.27 =B1  7%  perf-profile.calltrace.cy=
cles-
> pp.tcp_write_xmit.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_
> do_rcv.tcp_v4_rcv
>       2.23            -0.2        2.05        perf-profile.calltrace.cycl=
es-
> pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.do_tcp_sendpages.
> tcp_sendpage
>       2.14            -0.2        1.96        perf-profile.calltrace.cycl=
es-
> pp.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.d
> o_tcp_sendpages
>       1.27            -0.1        1.17        perf-profile.calltrace.cycl=
es-
> pp.tcp_send_mss.do_tcp_sendpages.tcp_sendpage.inet_sendpage.kernel_se
> ndpage
>       1.17            -0.1        1.09        perf-profile.calltrace.cycl=
es-
> pp.__tcp_push_pending_frames.do_tcp_sendpages.tcp_sendpage.inet_send
> page.kernel_sendpage
>       1.10            -0.1        1.02        perf-profile.calltrace.cycl=
es-
> pp.tcp_write_xmit.__tcp_push_pending_frames.do_tcp_sendpages.tcp_send
> page.inet_sendpage
>       0.91            -0.1        0.84        perf-profile.calltrace.cycl=
es-
> pp.tcp_current_mss.tcp_send_mss.do_tcp_sendpages.tcp_sendpage.inet_se
> ndpage
>       1.29            -0.1        1.23        perf-profile.calltrace.cycl=
es-
> pp.copy_page_to_iter_pipe.filemap_read.generic_file_splice_read.splice_di=
r
> ect_to_actor.do_splice_direct
>       0.77            -0.0        0.73        perf-profile.calltrace.cycl=
es-
> pp.tcp_stream_alloc_skb.tcp_build_frag.do_tcp_sendpages.tcp_sendpage.in
> et_sendpage
>       0.81            -0.0        0.77        perf-profile.calltrace.cycl=
es-
> pp.activate_task.ttwu_do_activate.sched_ttwu_pending.__sysvec_call_functi
> on_single.sysvec_call_function_single
>       0.78            -0.0        0.74        perf-profile.calltrace.cycl=
es-
> pp.enqueue_task_fair.activate_task.ttwu_do_activate.sched_ttwu_pending._
> _sysvec_call_function_single
>       0.55            -0.0        0.53        perf-profile.calltrace.cycl=
es-
> pp.enqueue_entity.enqueue_task_fair.activate_task.ttwu_do_activate.sched
> _ttwu_pending
>       0.93            +0.0        0.96        perf-profile.calltrace.cycl=
es-
> pp.try_to_wake_up.__wake_up_common.__wake_up_common_lock.sock_d
> ef_readable.tcp_data_queue
>       1.05            +0.0        1.08        perf-profile.calltrace.cycl=
es-
> pp.__wake_up_common.__wake_up_common_lock.sock_def_readable.tcp_
> data_queue.tcp_rcv_established
>       1.10            +0.0        1.13        perf-profile.calltrace.cycl=
es-
> pp.__wake_up_common_lock.sock_def_readable.tcp_data_queue.tcp_rcv_e
> stablished.tcp_v4_do_rcv
>       1.20            +0.0        1.24        perf-profile.calltrace.cycl=
es-
> pp.sock_def_readable.tcp_data_queue.tcp_rcv_established.tcp_v4_do_rcv.t
> cp_v4_rcv
>      15.73            +0.2       15.97        perf-profile.calltrace.cycl=
es-
> pp.__do_softirq.do_softirq.__local_bh_enable_ip.__dev_queue_xmit.ip_fini
> sh_output2
>      15.13            +0.3       15.38        perf-profile.calltrace.cycl=
es-
> pp.net_rx_action.__do_softirq.do_softirq.__local_bh_enable_ip.__dev_queu
> e_xmit
>      13.50            +0.3       13.82        perf-profile.calltrace.cycl=
es-
> pp.__napi_poll.net_rx_action.__do_softirq.do_softirq.__local_bh_enable_ip
>      13.45            +0.3       13.77        perf-profile.calltrace.cycl=
es-
> pp.process_backlog.__napi_poll.net_rx_action.__do_softirq.do_softirq
>      13.06            +0.3       13.38        perf-profile.calltrace.cycl=
es-
> pp.__netif_receive_skb_one_core.process_backlog.__napi_poll.net_rx_actio
> n.__do_softirq
>       2.23 =B1  2%      +0.4        2.60 =B1  3%  perf-profile.calltrace.=
cycles-
> pp.release_sock.tcp_recvmsg.inet_recvmsg.sock_recvmsg.__sys_recvfrom
>      12.08            +0.4       12.46        perf-profile.calltrace.cycl=
es-
> pp.ip_local_deliver_finish.__netif_receive_skb_one_core.process_backlog._=
_
> napi_poll.net_rx_action
>      12.02            +0.4       12.41        perf-profile.calltrace.cycl=
es-
> pp.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_receive_skb_on=
e_
> core.process_backlog.__napi_poll
>       1.12            +0.4        1.51 =B1  3%  perf-profile.calltrace.cy=
cles-
> pp.tcp_clean_rtx_queue.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv.__relea
> se_sock
>       1.31            +0.4        1.71 =B1  3%  perf-profile.calltrace.cy=
cles-
> pp.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv.__release_sock.release_sock
>      11.73            +0.4       12.14        perf-profile.calltrace.cycl=
es-
> pp.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_rec=
eiv
> e_skb_one_core.process_backlog
>       1.34 =B1 13%      +0.4        1.76 =B1  6%  perf-profile.calltrace.=
cycles-
> pp.__sk_mem_reduce_allocated.tcp_recvmsg_locked.tcp_recvmsg.inet_recv
> msg.sock_recvmsg
>       1.73 =B1 14%      +0.5        2.19 =B1  7%  perf-profile.calltrace.=
cycles-
> pp.tcp_rcv_established.tcp_v4_do_rcv.__release_sock.release_sock.tcp_recv
> msg
>       1.38 =B1 14%      +0.5        1.85 =B1  7%  perf-profile.calltrace.=
cycles-
> pp.tcp_data_queue.tcp_rcv_established.tcp_v4_do_rcv.__release_sock.relea
> se_sock
>       5.62            +0.5        6.11        perf-profile.calltrace.cycl=
es-
> pp.tcp_rcv_established.tcp_v4_do_rcv.__release_sock.release_sock.tcp_sen
> dpage
>       5.61            +0.5        6.10        perf-profile.calltrace.cycl=
es-
> pp.tcp_v4_do_rcv.__release_sock.release_sock.tcp_sendpage.inet_sendpage
>       8.89            +0.5        9.40        perf-profile.calltrace.cycl=
es-
> pp.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_fini=
sh
> .__netif_receive_skb_one_core
>       8.74            +0.5        9.26        perf-profile.calltrace.cycl=
es-
> pp.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu.i=
p
> _local_deliver_finish
>       2.86            +0.6        3.46 =B1  3%  perf-profile.calltrace.cy=
cles-
> pp.tcp_data_queue.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protoc
> ol_deliver_rcu
>       0.58 =B1  3%      +0.6        1.19 =B1  9%  perf-profile.calltrace.=
cycles-
> pp.mem_cgroup_charge_skmem.tcp_data_queue.tcp_rcv_established.tcp_v
> 4_do_rcv.tcp_v4_rcv
>       1.29 =B1 15%      +0.6        1.94 =B1  8%  perf-profile.calltrace.=
cycles-
> pp.__sk_mem_reduce_allocated.tcp_clean_rtx_queue.tcp_ack.tcp_rcv_estab
> lished.tcp_v4_do_rcv
>       7.18 =B1  2%      +0.7        7.87 =B1  2%  perf-profile.calltrace.=
cycles-
> pp.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.tcp_rcv
> _established.tcp_v4_do_rcv
>       6.06            +0.7        6.76 =B1  2%  perf-profile.calltrace.cy=
cles-
> pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pendin
> g_frames.tcp_rcv_established
>       0.35 =B1 70%      +0.7        1.07 =B1 32%  perf-profile.calltrace.=
cycles-
> pp.refill_stock.__sk_mem_reduce_allocated.tcp_clean_rtx_queue.tcp_ack.tc
> p_rcv_established
>       6.02            +0.7        6.75 =B1  2%  perf-profile.calltrace.cy=
cles-
> pp.tcp_write_xmit.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_
> do_rcv.__release_sock
>       6.05            +0.7        6.78 =B1  2%  perf-profile.calltrace.cy=
cles-
> pp.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_do_rcv.__releas
> e_sock.release_sock
>       0.39 =B1 70%      +0.8        1.20 =B1 22%  perf-profile.calltrace.=
cycles-
> pp.page_counter_try_charge.try_charge_memcg.mem_cgroup_charge_skme
> m.tcp_data_queue.tcp_rcv_established
>      16.80            +0.8       17.62        perf-profile.calltrace.cycl=
es-
> pp.do_tcp_sendpages.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_s
> endpage
>      46.63            +0.9       47.53        perf-profile.calltrace.cycl=
es-
> pp.do_splice_direct.do_sendfile.__x64_sys_sendfile64.do_syscall_64.entry_=
S
> YSCALL_64_after_hwframe
>       0.53 =B1  4%      +0.9        1.46 =B1  9%  perf-profile.calltrace.=
cycles-
> pp.page_counter_try_charge.try_charge_memcg.mem_cgroup_charge_skme
> m.__sk_mem_raise_allocated.__sk_mem_schedule
>      46.04            +1.0       47.00        perf-profile.calltrace.cycl=
es-
> pp.splice_direct_to_actor.do_splice_direct.do_sendfile.__x64_sys_sendfile=
64
> .do_syscall_64
>       0.00            +1.0        0.98 =B1 33%  perf-profile.calltrace.cy=
cles-
> pp.page_counter_uncharge.drain_stock.refill_stock.__sk_mem_reduce_alloc
> ated.tcp_clean_rtx_queue
>       0.00            +1.0        0.99 =B1 33%  perf-profile.calltrace.cy=
cles-
> pp.drain_stock.refill_stock.__sk_mem_reduce_allocated.tcp_clean_rtx_queu
> e.tcp_ack
>       9.51            +1.2       10.67 =B1  2%  perf-profile.calltrace.cy=
cles-
> pp.release_sock.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_sendp
> age
>       8.17            +1.2        9.34 =B1  2%  perf-profile.calltrace.cy=
cles-
> pp.__release_sock.release_sock.tcp_sendpage.inet_sendpage.kernel_sendp
> age
>      10.68            +1.3       11.98        perf-profile.calltrace.cycl=
es-
> pp.tcp_build_frag.do_tcp_sendpages.tcp_sendpage.inet_sendpage.kernel_s
> endpage
>       0.96 =B1 15%      +1.4        2.34 =B1 11%  perf-profile.calltrace.=
cycles-
> pp.try_charge_memcg.mem_cgroup_charge_skmem.tcp_data_queue.tcp_rc
> v_established.tcp_v4_do_rcv
>       7.84            +1.5        9.30        perf-profile.calltrace.cycl=
es-
> pp.tcp_wmem_schedule.tcp_build_frag.do_tcp_sendpages.tcp_sendpage.in
> et_sendpage
>       7.60            +1.5        9.08        perf-profile.calltrace.cycl=
es-
> pp.__sk_mem_schedule.tcp_wmem_schedule.tcp_build_frag.do_tcp_sendp
> ages.tcp_sendpage
>      36.91            +1.5       38.40        perf-profile.calltrace.cycl=
es-
> pp.generic_splice_sendpage.direct_splice_actor.splice_direct_to_actor.do_=
sp
> lice_direct.do_sendfile
>      37.04            +1.5       38.53        perf-profile.calltrace.cycl=
es-
> pp.direct_splice_actor.splice_direct_to_actor.do_splice_direct.do_sendfil=
e._
> _x64_sys_sendfile64
>       7.41            +1.5        8.91        perf-profile.calltrace.cycl=
es-
> pp.__sk_mem_raise_allocated.__sk_mem_schedule.tcp_wmem_schedule.tc
> p_build_frag.do_tcp_sendpages
>      36.49            +1.5       38.02        perf-profile.calltrace.cycl=
es-
> pp.__splice_from_pipe.generic_splice_sendpage.direct_splice_actor.splice_=
d
> irect_to_actor.do_splice_direct
>       1.47 =B1  3%      +1.6        3.11 =B1  7%  perf-profile.calltrace.=
cycles-
> pp.try_charge_memcg.mem_cgroup_charge_skmem.__sk_mem_raise_alloca
> ted.__sk_mem_schedule.tcp_wmem_schedule
>      34.61            +1.7       36.26        perf-profile.calltrace.cycl=
es-
> pp.pipe_to_sendpage.__splice_from_pipe.generic_splice_sendpage.direct_s
> plice_actor.splice_direct_to_actor
>      34.29            +1.7       35.97        perf-profile.calltrace.cycl=
es-
> pp.sock_sendpage.pipe_to_sendpage.__splice_from_pipe.generic_splice_se
> ndpage.direct_splice_actor
>      34.10            +1.7       35.79        perf-profile.calltrace.cycl=
es-
> pp.kernel_sendpage.sock_sendpage.pipe_to_sendpage.__splice_from_pipe.
> generic_splice_sendpage
>      33.73            +1.7       35.46        perf-profile.calltrace.cycl=
es-
> pp.inet_sendpage.kernel_sendpage.sock_sendpage.pipe_to_sendpage.__spli
> ce_from_pipe
>      33.24            +1.8       35.02        perf-profile.calltrace.cycl=
es-
> pp.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_sendpage.pipe_to_s
> endpage
>       4.46 =B1  2%      +2.0        6.42 =B1  2%  perf-profile.calltrace.=
cycles-
> pp.mem_cgroup_charge_skmem.__sk_mem_raise_allocated.__sk_mem_sch
> edule.tcp_wmem_schedule.tcp_build_frag
>      11.28            -0.9       10.40        perf-profile.children.cycle=
s-
> pp.__skb_datagram_iter
>      11.30            -0.9       10.42        perf-profile.children.cycle=
s-
> pp.skb_copy_datagram_iter
>      29.47            -0.7       28.77        perf-profile.children.cycle=
s-
> pp.tcp_recvmsg_locked
>       7.09            -0.5        6.56        perf-profile.children.cycle=
s-pp._copy_to_iter
>       6.70            -0.5        6.20        perf-profile.children.cycle=
s-pp.copyout
>       7.44            -0.5        6.94        perf-profile.children.cycle=
s-
> pp.generic_file_splice_read
>       6.58            -0.4        6.15        perf-profile.children.cycle=
s-pp.filemap_read
>       3.26            -0.3        2.97        perf-profile.children.cycle=
s-
> pp.simple_copy_to_iter
>       3.16            -0.3        2.88        perf-profile.children.cycle=
s-
> pp.__check_object_size
>       2.93            -0.2        2.70        perf-profile.children.cycle=
s-
> pp.filemap_get_read_batch
>       2.65 =B1  2%      -0.2        2.42        perf-profile.children.cyc=
les-
> pp.check_heap_object
>       3.16            -0.2        2.93        perf-profile.children.cycle=
s-
> pp.filemap_get_pages
>       1.32            -0.1        1.22        perf-profile.children.cycle=
s-pp.tcp_send_mss
>       1.33            -0.1        1.23        perf-profile.children.cycle=
s-pp.touch_atime
>       1.22 =B1  2%      -0.1        1.12        perf-profile.children.cyc=
les-
> pp.security_file_permission
>       5.62            -0.1        5.53        perf-profile.children.cycle=
s-
> pp.lock_sock_nested
>       1.08            -0.1        1.00        perf-profile.children.cycle=
s-
> pp.atime_needs_update
>       1.08            -0.1        1.00        perf-profile.children.cycle=
s-
> pp.tcp_current_mss
>       0.96 =B1  3%      -0.1        0.88        perf-profile.children.cyc=
les-
> pp.apparmor_file_permission
>       1.35            -0.1        1.28        perf-profile.children.cycle=
s-
> pp.copy_page_to_iter_pipe
>       0.57 =B1  3%      -0.1        0.51        perf-profile.children.cyc=
les-
> pp._copy_from_user
>       0.52            -0.1        0.46 =B1  2%  perf-profile.children.cyc=
les-
> pp.__fsnotify_parent
>       1.06            -0.1        1.01        perf-profile.children.cycle=
s-
> pp.__inet_lookup_established
>       0.41            -0.0        0.36        perf-profile.children.cycle=
s-
> pp.tcp_rate_check_app_limited
>       0.52 =B1  2%      -0.0        0.48 =B1  2%  perf-profile.children.c=
ycles-
> pp.netperf_sendfile
>       0.74            -0.0        0.70        perf-profile.children.cycle=
s-
> pp.__cond_resched
>       0.48            -0.0        0.43        perf-profile.children.cycle=
s-
> pp.tcp_event_new_data_sent
>       0.64            -0.0        0.60        perf-profile.children.cycle=
s-pp.__fget_light
>       0.97            -0.0        0.93        perf-profile.children.cycle=
s-pp.__alloc_skb
>       0.60 =B1  3%      -0.0        0.55 =B1  3%  perf-profile.children.c=
ycles-pp.ip_rcv
>       0.78            -0.0        0.74        perf-profile.children.cycle=
s-
> pp.tcp_stream_alloc_skb
>       0.38            -0.0        0.34 =B1  2%  perf-profile.children.cyc=
les-
> pp.page_cache_pipe_buf_confirm
>       0.59 =B1  2%      -0.0        0.55 =B1  2%  perf-profile.children.c=
ycles-
> pp.__entry_text_start
>       0.23 =B1  5%      -0.0        0.20 =B1  2%  perf-profile.children.c=
ycles-pp.xas_load
>       0.48            -0.0        0.44        perf-profile.children.cycle=
s-pp.sk_reset_timer
>       0.42            -0.0        0.39        perf-profile.children.cycle=
s-
> pp.entry_SYSRETQ_unsafe_stack
>       0.74 =B1  2%      -0.0        0.71        perf-profile.children.cyc=
les-pp.__kfree_skb
>       0.69            -0.0        0.65        perf-profile.children.cycle=
s-pp.read_tsc
>       0.45            -0.0        0.42 =B1  2%  perf-profile.children.cyc=
les-
> pp.current_time
>       0.57            -0.0        0.54        perf-profile.children.cycle=
s-
> pp.kmem_cache_alloc_node
>       0.40 =B1  2%      -0.0        0.38 =B1  2%  perf-profile.children.c=
ycles-
> pp.__virt_addr_valid
>       0.81            -0.0        0.78        perf-profile.children.cycle=
s-
> pp.enqueue_task_fair
>       0.43            -0.0        0.40        perf-profile.children.cycle=
s-pp.__mod_timer
>       0.38            -0.0        0.36        perf-profile.children.cycle=
s-
> pp.tcp_established_options
>       0.21 =B1  2%      -0.0        0.18 =B1  2%  perf-profile.children.c=
ycles-
> pp.sockfd_lookup_light
>       0.35            -0.0        0.32 =B1  2%  perf-profile.children.cyc=
les-
> pp.__put_user_8
>       0.30 =B1  3%      -0.0        0.27        perf-profile.children.cyc=
les-
> pp.aa_file_perm
>       0.48            -0.0        0.46 =B1  2%  perf-profile.children.cyc=
les-
> pp.__tcp_send_ack
>       0.49 =B1  2%      -0.0        0.47        perf-profile.children.cyc=
les-
> pp.kmem_cache_free
>       0.28 =B1  3%      -0.0        0.26 =B1  4%  perf-profile.children.c=
ycles-
> pp.ip_rcv_finish_core
>       0.11 =B1  6%      -0.0        0.09 =B1  5%  perf-profile.children.c=
ycles-pp.xas_start
>       0.24            -0.0        0.22 =B1  3%  perf-profile.children.cyc=
les-pp.tcp_tso_segs
>       0.25            -0.0        0.23        perf-profile.children.cycle=
s-
> pp.copy_page_to_iter
>       0.30            -0.0        0.28 =B1  2%  perf-profile.children.cyc=
les-
> pp.__netif_receive_skb_core
>       0.24            -0.0        0.22 =B1  2%  perf-profile.children.cyc=
les-pp.sanity
>       0.78            -0.0        0.76        perf-profile.children.cycle=
s-
> pp.page_cache_pipe_buf_release
>       0.28 =B1  3%      -0.0        0.26        perf-profile.children.cyc=
les-
> pp.tcp_schedule_loss_probe
>       0.27            -0.0        0.26        perf-profile.children.cycle=
s-pp.rcu_all_qs
>       0.30            -0.0        0.28        perf-profile.children.cycle=
s-
> pp.syscall_return_via_sysret
>       0.23            -0.0        0.22 =B1  2%  perf-profile.children.cyc=
les-
> pp.set_next_entity
>       0.16 =B1  3%      -0.0        0.15 =B1  5%  perf-profile.children.c=
ycles-
> pp.skb_release_head_state
>       0.15 =B1  2%      -0.0        0.14 =B1  2%  perf-profile.children.c=
ycles-
> pp.folio_mark_accessed
>       0.08            -0.0        0.07 =B1  5%  perf-profile.children.cyc=
les-pp.aa_sk_perm
>       0.20 =B1  2%      -0.0        0.18 =B1  2%  perf-profile.children.c=
ycles-
> pp._raw_spin_unlock_bh
>       0.07            -0.0        0.06        perf-profile.children.cycle=
s-pp.rb_next
>       0.05            +0.0        0.06        perf-profile.children.cycle=
s-pp.skb_push
>       0.07            +0.0        0.08        perf-profile.children.cycle=
s-
> pp.cpuidle_governor_latency_req
>       0.33            +0.0        0.34        perf-profile.children.cycle=
s-
> pp.prepare_task_switch
>       0.07            +0.0        0.08 =B1  5%  perf-profile.children.cyc=
les-
> pp.switch_fpu_return
>       0.11 =B1  6%      +0.0        0.12 =B1  4%  perf-profile.children.c=
ycles-
> pp.resched_curr
>       0.14 =B1  3%      +0.0        0.15 =B1  3%  perf-profile.children.c=
ycles-
> pp.check_preempt_curr
>       0.21            +0.0        0.23 =B1  2%  perf-profile.children.cyc=
les-pp.ip_output
>       0.49 =B1  2%      +0.0        0.51 =B1  2%  perf-profile.children.c=
ycles-
> pp._raw_spin_lock
>       0.59            +0.0        0.62        perf-profile.children.cycle=
s-
> pp._raw_spin_lock_irqsave
>       0.76 =B1  3%      +0.1        0.90 =B1  4%  perf-profile.children.c=
ycles-
> pp.mem_cgroup_uncharge_skmem
>       0.31 =B1  2%      +0.2        0.47 =B1 10%  perf-profile.children.c=
ycles-
> pp.propagate_protected_usage
>      84.35            +0.2       84.55        perf-profile.children.cycle=
s-
> pp.do_syscall_64
>      16.48            +0.2       16.68        perf-profile.children.cycle=
s-
> pp.__local_bh_enable_ip
>      15.96            +0.2       16.20        perf-profile.children.cycle=
s-pp.do_softirq
>      15.84            +0.2       16.09        perf-profile.children.cycle=
s-pp.__do_softirq
>      15.20            +0.3       15.46        perf-profile.children.cycle=
s-
> pp.net_rx_action
>      17.63            +0.3       17.89        perf-profile.children.cycle=
s-
> pp.__dev_queue_xmit
>      18.00            +0.3       18.29        perf-profile.children.cycle=
s-
> pp.ip_finish_output2
>      18.93            +0.3       19.22        perf-profile.children.cycle=
s-
> pp.__ip_queue_xmit
>      20.12            +0.3       20.43        perf-profile.children.cycle=
s-
> pp.__tcp_transmit_skb
>      12.38            +0.3       12.69        perf-profile.children.cycle=
s-
> pp.tcp_write_xmit
>      13.56            +0.3       13.87        perf-profile.children.cycle=
s-pp.__napi_poll
>      13.51            +0.3       13.83        perf-profile.children.cycle=
s-
> pp.process_backlog
>      13.12            +0.3       13.44        perf-profile.children.cycle=
s-
> pp.__netif_receive_skb_one_core
>      12.12            +0.4       12.51        perf-profile.children.cycle=
s-
> pp.ip_local_deliver_finish
>      12.08            +0.4       12.47        perf-profile.children.cycle=
s-
> pp.ip_protocol_deliver_rcu
>      11.84            +0.4       12.24        perf-profile.children.cycle=
s-pp.tcp_v4_rcv
>       3.87            +0.5        4.34        perf-profile.children.cycle=
s-pp.tcp_ack
>       2.89            +0.5        3.40 =B1  2%  perf-profile.children.cyc=
les-
> pp.tcp_clean_rtx_queue
>       9.78            +0.5       10.31        perf-profile.children.cycle=
s-
> pp.__tcp_push_pending_frames
>       1.54 =B1  4%      +0.7        2.26 =B1  7%  perf-profile.children.c=
ycles-
> pp.refill_stock
>       1.26 =B1  5%      +0.7        1.99 =B1  8%  perf-profile.children.c=
ycles-
> pp.drain_stock
>       1.24 =B1  5%      +0.7        1.96 =B1  8%  perf-profile.children.c=
ycles-
> pp.page_counter_uncharge
>      17.03            +0.8       17.85        perf-profile.children.cycle=
s-
> pp.do_tcp_sendpages
>      46.66            +0.9       47.56        perf-profile.children.cycle=
s-
> pp.do_splice_direct
>       2.92 =B1  2%      +0.9        3.86 =B1  3%  perf-profile.children.c=
ycles-
> pp.__sk_mem_reduce_allocated
>      46.08            +0.9       47.03        perf-profile.children.cycle=
s-
> pp.splice_direct_to_actor
>       4.41            +1.0        5.43 =B1  4%  perf-profile.children.cyc=
les-
> pp.tcp_data_queue
>      10.88            +1.3       12.18        perf-profile.children.cycle=
s-
> pp.tcp_build_frag
>      16.59            +1.4       17.98        perf-profile.children.cycle=
s-
> pp.tcp_v4_do_rcv
>      16.36            +1.4       17.77        perf-profile.children.cycle=
s-
> pp.tcp_rcv_established
>       7.93            +1.5        9.40        perf-profile.children.cycle=
s-
> pp.tcp_wmem_schedule
>       1.52 =B1  4%      +1.5        2.98 =B1  8%  perf-profile.children.c=
ycles-
> pp.page_counter_try_charge
>      36.96            +1.5       38.45        perf-profile.children.cycle=
s-
> pp.generic_splice_sendpage
>      37.07            +1.5       38.56        perf-profile.children.cycle=
s-
> pp.direct_splice_actor
>       7.75            +1.5        9.24        perf-profile.children.cycle=
s-
> pp.__sk_mem_schedule
>       7.59            +1.5        9.10        perf-profile.children.cycle=
s-
> pp.__sk_mem_raise_allocated
>      36.59            +1.5       38.12        perf-profile.children.cycle=
s-
> pp.__splice_from_pipe
>      11.95            +1.5       13.48 =B1  2%  perf-profile.children.cyc=
les-
> pp.release_sock
>      10.33            +1.6       11.89 =B1  2%  perf-profile.children.cyc=
les-
> pp.__release_sock
>      34.67            +1.7       36.32        perf-profile.children.cycle=
s-
> pp.pipe_to_sendpage
>      34.34            +1.7       36.02        perf-profile.children.cycle=
s-
> pp.sock_sendpage
>      34.15            +1.7       35.84        perf-profile.children.cycle=
s-
> pp.kernel_sendpage
>      33.84            +1.7       35.56        perf-profile.children.cycle=
s-
> pp.inet_sendpage
>      33.40            +1.8       35.16        perf-profile.children.cycle=
s-
> pp.tcp_sendpage
>       3.31 =B1  4%      +2.6        5.93 =B1  7%  perf-profile.children.c=
ycles-
> pp.try_charge_memcg
>       6.82            +3.0        9.82 =B1  3%  perf-profile.children.cyc=
les-
> pp.mem_cgroup_charge_skmem
>       6.66            -0.5        6.15        perf-profile.self.cycles-pp=
.copyout
>       2.88            -0.4        2.44 =B1  2%  perf-profile.self.cycles-
> pp.__sk_mem_raise_allocated
>       2.69            -0.2        2.50        perf-profile.self.cycles-
> pp.filemap_get_read_batch
>       2.14 =B1  2%      -0.2        1.95 =B1  2%  perf-profile.self.cycle=
s-
> pp.check_heap_object
>       2.01            -0.1        1.88        perf-profile.self.cycles-pp=
.tcp_build_frag
>       1.30            -0.1        1.22        perf-profile.self.cycles-pp=
.filemap_read
>       1.04            -0.1        0.96        perf-profile.self.cycles-pp=
.do_sendfile
>       0.70            -0.1        0.63 =B1  2%  perf-profile.self.cycles-
> pp.__splice_from_pipe
>       0.52            -0.1        0.46 =B1  2%  perf-profile.self.cycles-
> pp.sendfile_tcp_stream
>       0.75            -0.1        0.70        perf-profile.self.cycles-pp=
.do_tcp_sendpages
>       0.55 =B1  2%      -0.1        0.50 =B1  2%  perf-profile.self.cycle=
s-
> pp._copy_from_user
>       0.42 =B1  4%      -0.1        0.36 =B1  2%  perf-profile.self.cycle=
s-pp.sendfile
>       0.67 =B1  3%      -0.1        0.62 =B1  2%  perf-profile.self.cycle=
s-
> pp.apparmor_file_permission
>       1.11            -0.0        1.06        perf-profile.self.cycles-
> pp.copy_page_to_iter_pipe
>       0.54 =B1  2%      -0.0        0.49        perf-profile.self.cycles-
> pp.entry_SYSCALL_64_after_hwframe
>       0.48            -0.0        0.43 =B1  2%  perf-profile.self.cycles-
> pp.__fsnotify_parent
>       0.80 =B1  2%      -0.0        0.75        perf-profile.self.cycles-
> pp.__skb_datagram_iter
>       0.81            -0.0        0.76        perf-profile.self.cycles-pp=
.tcp_write_xmit
>       0.95            -0.0        0.91        perf-profile.self.cycles-
> pp.__inet_lookup_established
>       0.62            -0.0        0.58        perf-profile.self.cycles-pp=
.__fget_light
>       0.36            -0.0        0.32        perf-profile.self.cycles-
> pp.tcp_rate_check_app_limited
>       0.34            -0.0        0.30        perf-profile.self.cycles-pp=
.inet_sendpage
>       0.47            -0.0        0.43 =B1  2%  perf-profile.self.cycles-=
pp.netperf_sendfile
>       0.49 =B1  5%      -0.0        0.45        perf-profile.self.cycles-=
pp.net_rx_action
>       0.48            -0.0        0.44        perf-profile.self.cycles-
> pp.atime_needs_update
>       0.67            -0.0        0.63        perf-profile.self.cycles-pp=
.tcp_v4_rcv
>       0.43 =B1  3%      -0.0        0.40        perf-profile.self.cycles-=
pp.do_syscall_64
>       0.41            -0.0        0.37        perf-profile.self.cycles-
> pp.entry_SYSRETQ_unsafe_stack
>       0.36 =B1  2%      -0.0        0.32 =B1  2%  perf-profile.self.cycle=
s-
> pp.page_cache_pipe_buf_confirm
>       0.46            -0.0        0.42        perf-profile.self.cycles-
> pp.__local_bh_enable_ip
>       0.48 =B1  2%      -0.0        0.45        perf-profile.self.cycles-=
pp.tcp_sendpage
>       0.45            -0.0        0.42        perf-profile.self.cycles-pp=
.tcp_current_mss
>       0.31 =B1  2%      -0.0        0.28        perf-profile.self.cycles-=
pp.kernel_sendpage
>       0.34            -0.0        0.31 =B1  2%  perf-profile.self.cycles-=
pp.__put_user_8
>       0.66            -0.0        0.63        perf-profile.self.cycles-pp=
.read_tsc
>       0.40            -0.0        0.37 =B1  2%  perf-profile.self.cycles-
> pp.__check_object_size
>       0.33            -0.0        0.30        perf-profile.self.cycles-
> pp.generic_splice_sendpage
>       0.31            -0.0        0.28 =B1  2%  perf-profile.self.cycles-=
pp.tcp_send_mss
>       0.66            -0.0        0.64        perf-profile.self.cycles-pp=
.tcp_ack
>       0.28 =B1  2%      -0.0        0.25 =B1  2%  perf-profile.self.cycle=
s-
> pp.__sys_recvfrom
>       0.44            -0.0        0.42 =B1  2%  perf-profile.self.cycles-=
pp.__cond_resched
>       0.39            -0.0        0.36        perf-profile.self.cycles-pp=
._copy_to_iter
>       0.34 =B1  2%      -0.0        0.32 =B1  2%  perf-profile.self.cycle=
s-
> pp.tcp_established_options
>       0.24 =B1  2%      -0.0        0.21 =B1  4%  perf-profile.self.cycle=
s-
> pp.tcp_wmem_schedule
>       0.48 =B1  2%      -0.0        0.46        perf-profile.self.cycles-
> pp.kmem_cache_free
>       0.33            -0.0        0.31        perf-profile.self.cycles-pp=
.pipe_to_sendpage
>       0.11 =B1  6%      -0.0        0.09        perf-profile.self.cycles-
> pp.check_stack_object
>       0.36            -0.0        0.34 =B1  3%  perf-profile.self.cycles-=
pp.release_sock
>       0.26            -0.0        0.24 =B1  2%  perf-profile.self.cycles-
> pp.security_file_permission
>       0.23            -0.0        0.21 =B1  3%  perf-profile.self.cycles-=
pp.tcp_tso_segs
>       0.44            -0.0        0.42        perf-profile.self.cycles-
> pp.kmem_cache_alloc_node
>       0.31            -0.0        0.29 =B1  2%  perf-profile.self.cycles-=
pp.current_time
>       0.20 =B1  3%      -0.0        0.18 =B1  2%  perf-profile.self.cycle=
s-
> pp.do_splice_direct
>       0.25 =B1  4%      -0.0        0.23 =B1  2%  perf-profile.self.cycle=
s-pp.aa_file_perm
>       0.25 =B1  3%      -0.0        0.23 =B1  2%  perf-profile.self.cycle=
s-pp.touch_atime
>       0.19            -0.0        0.17 =B1  2%  perf-profile.self.cycles-=
pp.process_backlog
>       0.11 =B1  6%      -0.0        0.09 =B1  5%  perf-profile.self.cycle=
s-
> pp.__get_task_ioprio
>       0.21            -0.0        0.19        perf-profile.self.cycles-pp=
.sanity
>       0.06            -0.0        0.04 =B1 44%  perf-profile.self.cycles-=
pp.aa_sk_perm
>       0.33 =B1  2%      -0.0        0.31 =B1  2%  perf-profile.self.cycle=
s-
> pp.splice_direct_to_actor
>       0.30            -0.0        0.28        perf-profile.self.cycles-
> pp.syscall_return_via_sysret
>       0.22            -0.0        0.20 =B1  2%  perf-profile.self.cycles-
> pp.copy_page_to_iter
>       0.16 =B1  2%      -0.0        0.14 =B1  3%  perf-profile.self.cycle=
s-
> pp.tcp_stream_alloc_skb
>       0.11 =B1  3%      -0.0        0.10 =B1  5%  perf-profile.self.cycle=
s-
> pp.ip_protocol_deliver_rcu
>       0.09 =B1  6%      -0.0        0.07 =B1  6%  perf-profile.self.cycle=
s-pp.xas_start
>       0.15 =B1  2%      -0.0        0.14 =B1  3%  perf-profile.self.cycle=
s-
> pp.__sk_mem_schedule
>       0.65            -0.0        0.63        perf-profile.self.cycles-pp=
.tcp_rcv_established
>       0.25            -0.0        0.23        perf-profile.self.cycles-pp=
.__mod_timer
>       0.15            -0.0        0.14 =B1  3%  perf-profile.self.cycles-
> pp.tcp_tx_timestamp
>       0.30            -0.0        0.28 =B1  2%  perf-profile.self.cycles-
> pp.__netif_receive_skb_core
>       0.75            -0.0        0.74        perf-profile.self.cycles-
> pp.page_cache_pipe_buf_release
>       0.18 =B1  2%      -0.0        0.17 =B1  2%  perf-profile.self.cycle=
s-
> pp.sock_sendpage
>       0.13 =B1  2%      -0.0        0.12        perf-profile.self.cycles-
> pp._raw_spin_unlock_bh
>       0.12 =B1  3%      -0.0        0.11        perf-profile.self.cycles-
> pp.folio_mark_accessed
>       0.12            -0.0        0.11 =B1  3%  perf-profile.self.cycles-
> pp.simple_copy_to_iter
>       0.06            -0.0        0.05        perf-profile.self.cycles-
> pp.splice_from_pipe_next
>       0.11            -0.0        0.10        perf-profile.self.cycles-
> pp.exit_to_user_mode_prepare
>       0.25            +0.0        0.26        perf-profile.self.cycles-pp=
.__switch_to
>       0.06 =B1  8%      +0.0        0.07 =B1  6%  perf-profile.self.cycle=
s-
> pp.switch_fpu_return
>       0.44 =B1  2%      +0.0        0.46        perf-profile.self.cycles-=
pp._raw_spin_lock
>       0.33            +0.0        0.36 =B1  2%  perf-profile.self.cycles-=
pp.__schedule
>       0.58            +0.0        0.61        perf-profile.self.cycles-
> pp._raw_spin_lock_irqsave
>       0.34 =B1  3%      +0.0        0.38        perf-profile.self.cycles-
> pp.__x64_sys_sendfile64
>       0.16 =B1  8%      +0.0        0.20 =B1  2%  perf-profile.self.cycle=
s-pp.do_splice_to
>       0.65 =B1  2%      +0.1        0.73 =B1  2%  perf-profile.self.cycle=
s-
> pp.__sk_mem_reduce_allocated
>       0.71 =B1  3%      +0.1        0.84 =B1  5%  perf-profile.self.cycle=
s-
> pp.mem_cgroup_uncharge_skmem
>       0.30 =B1  2%      +0.2        0.47 =B1 10%  perf-profile.self.cycle=
s-
> pp.propagate_protected_usage
>       3.34 =B1  3%      +0.4        3.72 =B1  5%  perf-profile.self.cycle=
s-
> pp.mem_cgroup_charge_skmem
>       1.08 =B1  6%      +0.7        1.74 =B1  8%  perf-profile.self.cycle=
s-
> pp.page_counter_uncharge
>       1.72 =B1  3%      +1.2        2.87 =B1  7%  perf-profile.self.cycle=
s-
> pp.try_charge_memcg
>       1.36 =B1  5%      +1.4        2.73 =B1  8%  perf-profile.self.cycle=
s-
> pp.page_counter_try_charge
>=20
>=20
>=20
> [2]
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/s
> end_size/tbox_group/test/testcase:
>   cs-localhost/gcc-11/performance/ipv4/x86_64-rhel-8.3/50%/debian-11.1-
> x86_64-20220510.cgz/300s/10K/lkp-icl-2sp2/TCP_SENDFILE/netperf
>=20
> commit:
>   ed23734c23 ("Merge tag 'net-6.4-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>   05d72a8bed ("net: Keep sk->sk_forward_alloc as a proper size")
>=20
> ed23734c23d2fc1e 05d72a8bedfacfc46f300ab38e0
> ---------------- ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>   5.95e+09           -12.7%  5.193e+09        cpuidle..time
>       3328 =C2=B1 22%     +96.7%       6547 =C2=B1 21%  numa-
> vmstat.node2.nr_slab_reclaimable
>      13.95            -2.0       11.93        mpstat.cpu.all.idle%
>       2.69            +0.6        3.31        mpstat.cpu.all.usr%
>    5106176            -6.6%    4769081        vmstat.system.cs
>    2629481            -7.3%    2436543        vmstat.system.in
>   11284480 =C2=B1  9%     +23.7%   13957802 =C2=B1 11%  meminfo.DirectMap=
2M
>    1726173 =C2=B1  2%     -17.6%    1422506 =C2=B1  2%  meminfo.Mapped
>    7247621           +11.2%    8061423        meminfo.Shmem
>      13314 =C2=B1 22%     +96.7%      26192 =C2=B1 21%  numa-
> meminfo.node2.KReclaimable
>      13314 =C2=B1 22%     +96.7%      26192 =C2=B1 21%  numa-
> meminfo.node2.SReclaimable
>      71128 =C2=B1  5%     +28.0%      91013 =C2=B1  8%  numa-meminfo.node=
2.Slab
>      15.26            -1.9       13.33        turbostat.C1%
>      10.41           -15.8%       8.77        turbostat.CPU%c1
>       0.26           +11.5%       0.29        turbostat.IPC
>      30.71            -3.2%      29.72        turbostat.RAMWatt
>    7854382 =C2=B1  2%     +10.3%    8664074 =C2=B1  2%
> sched_debug.cfs_rq:/.min_vruntime.min
>     708120 =C2=B1  2%     -15.5%     598098 =C2=B1  3%
> sched_debug.cfs_rq:/.min_vruntime.stddev
>     708203 =C2=B1  2%     -15.5%     598191 =C2=B1  3%
> sched_debug.cfs_rq:/.spread0.stddev
>       5317 =C2=B1  2%     -11.2%       4722 =C2=B1  5%  sched_debug.cpu.a=
vg_idle.min
>   10037310 =C2=B1  3%     -15.9%    8440803 =C2=B1  2%
> sched_debug.cpu.nr_switches.max
>    1290083 =C2=B1  2%     -22.0%    1006686 =C2=B1  3%
> sched_debug.cpu.nr_switches.stddev
>      23218           +29.4%      30043        netperf.Throughput_Mbps
>    1485996           +29.4%    1922763        netperf.Throughput_total_Mb=
ps
>     160215 =C2=B1  3%    +107.9%     333022 =C2=B1 15%
> netperf.time.involuntary_context_switches
>       5567            +2.5%       5707        netperf.time.percent_of_cpu=
_this_job_got
>      16093            +1.2%      16286        netperf.time.system_time
>     669.70           +34.0%     897.24        netperf.time.user_time
>      35419 =C2=B1  3%    +160.8%      92374 =C2=B1  5%
> netperf.time.voluntary_context_switches
>  5.442e+09           +29.4%  7.041e+09        netperf.workload
>    2481590            +8.1%    2681600        proc-vmstat.nr_file_pages
>    1892119           +10.6%    2092306        proc-vmstat.nr_inactive_ano=
n
>     431915 =C2=B1  2%     -17.9%     354649 =C2=B1  2%  proc-vmstat.nr_ma=
pped
>       3064            -4.5%       2927        proc-vmstat.nr_page_table_p=
ages
>    1813072           +11.0%    2013082        proc-vmstat.nr_shmem
>      35384            +1.3%      35861        proc-vmstat.nr_slab_reclaim=
able
>    1892119           +10.6%    2092306        proc-vmstat.nr_zone_inactiv=
e_anon
>     491137 =C2=B1  2%     -20.0%     393067 =C2=B1 17%  proc-
> vmstat.numa_hint_faults_local
>    5593417           +10.7%    6193714        proc-vmstat.numa_hit
>    5431644           +10.5%    6001135        proc-vmstat.numa_local
>      44132 =C2=B1  3%     +18.1%      52128 =C2=B1  6%  proc-vmstat.pgact=
ivate
>    5733229            +9.9%    6302633        proc-vmstat.pgalloc_normal
>       7.00           -22.1%       5.45        perf-stat.i.MPKI
>  4.405e+10           +13.7%  5.007e+10        perf-stat.i.branch-instruct=
ions
>       0.87            -0.1        0.78        perf-stat.i.branch-miss-rat=
e%
>  3.795e+08            +1.6%  3.854e+08        perf-stat.i.branch-misses
>       6.39            -3.3        3.09 =C2=B1  7%  perf-stat.i.cache-miss=
-rate%
>  1.038e+08 =C2=B1  2%     -57.7%   43877506 =C2=B1  7%  perf-stat.i.cache=
-misses
>  1.633e+09           -12.0%  1.438e+09        perf-stat.i.cache-reference=
s
>    5163294            -6.8%    4814691        perf-stat.i.context-switche=
s
>       1.29           -10.0%       1.16        perf-stat.i.cpi
>  3.016e+11            +1.8%  3.072e+11        perf-stat.i.cpu-cycles
>      27516 =C2=B1  3%     -34.8%      17931        perf-stat.i.cpu-migrat=
ions
>       2930 =C2=B1  2%    +153.5%       7428 =C2=B1  7%  perf-stat.i.cycle=
s-between-cache-
> misses
>       0.01            -0.0        0.01 =C2=B1 13%  perf-stat.i.dTLB-load-=
miss-rate%
>    7226907           -11.0%    6428694 =C2=B1 13%  perf-stat.i.dTLB-load-=
misses
>  6.872e+10           +13.4%  7.791e+10        perf-stat.i.dTLB-loads
>       0.00 =C2=B1  3%      -0.0        0.00 =C2=B1  2%  perf-stat.i.dTLB-=
store-miss-rate%
>     954320 =C2=B1  3%     -33.0%     639153 =C2=B1  2%  perf-stat.i.dTLB-=
store-misses
>  3.753e+10           +12.5%  4.221e+10        perf-stat.i.dTLB-stores
>  2.332e+11           +13.2%  2.639e+11        perf-stat.i.instructions
>       0.78           +11.1%       0.86        perf-stat.i.ipc
>       2.36            +1.8%       2.40        perf-stat.i.metric.GHz
>     263.06 =C2=B1  2%     -45.6%     143.14 =C2=B1  5%  perf-stat.i.metri=
c.K/sec
>       1186           +13.0%       1340        perf-stat.i.metric.M/sec
>      95.18            +2.5       97.70        perf-stat.i.node-load-miss-=
rate%
>   15047143 =C2=B1  3%     -50.7%    7421607 =C2=B1  7%  perf-stat.i.node-=
load-misses
>     736992 =C2=B1  4%     -79.2%     153436 =C2=B1  5%  perf-stat.i.node-=
loads
>      76.94           -13.8       63.13 =C2=B1  5%  perf-stat.i.node-store=
-miss-rate%
>    8866276           -61.9%    3375324 =C2=B1  7%  perf-stat.i.node-store=
-misses
>    2808107 =C2=B1  7%     -34.1%    1851536 =C2=B1 14%  perf-stat.i.node-=
stores
>       7.00           -22.2%       5.45        perf-stat.overall.MPKI
>       0.86            -0.1        0.77        perf-stat.overall.branch-mi=
ss-rate%
>       6.36            -3.3        3.05 =C2=B1  7%  perf-stat.overall.cach=
e-miss-rate%
>       1.29           -10.0%       1.16        perf-stat.overall.cpi
>       2907 =C2=B1  2%    +142.1%       7040 =C2=B1  7%  perf-stat.overall=
.cycles-between-
> cache-misses
>       0.01            -0.0        0.01 =C2=B1 13%  perf-stat.overall.dTLB=
-load-miss-rate%
>       0.00 =C2=B1  3%      -0.0        0.00 =C2=B1  2%  perf-stat.overall=
.dTLB-store-miss-rate%
>       0.77           +11.1%       0.86        perf-stat.overall.ipc
>      95.33            +2.6       97.97        perf-stat.overall.node-load=
-miss-rate%
>      75.97           -11.3       64.69 =C2=B1  4%  perf-stat.overall.node=
-store-miss-rate%
>      12891           -12.6%      11262        perf-stat.overall.path-leng=
th
>   4.39e+10           +13.7%   4.99e+10        perf-stat.ps.branch-instruc=
tions
>  3.782e+08            +1.6%  3.841e+08        perf-stat.ps.branch-misses
>  1.034e+08 =C2=B1  2%     -57.7%   43735005 =C2=B1  7%  perf-stat.ps.cach=
e-misses
>  1.627e+09           -11.9%  1.433e+09        perf-stat.ps.cache-referenc=
es
>    5145798            -6.8%    4798160        perf-stat.ps.context-switch=
es
>  3.006e+11            +1.8%  3.062e+11        perf-stat.ps.cpu-cycles
>      27426 =C2=B1  3%     -34.8%      17883        perf-stat.ps.cpu-migra=
tions
>    7190273           -11.0%    6397079 =C2=B1 13%  perf-stat.ps.dTLB-load=
-misses
>  6.849e+10           +13.4%  7.765e+10        perf-stat.ps.dTLB-loads
>     950808 =C2=B1  3%     -33.0%     637446 =C2=B1  2%  perf-stat.ps.dTLB=
-store-misses
>  3.741e+10           +12.5%  4.207e+10        perf-stat.ps.dTLB-stores
>  2.324e+11           +13.2%   2.63e+11        perf-stat.ps.instructions
>   14992384 =C2=B1  3%     -50.7%    7391904 =C2=B1  7%  perf-stat.ps.node=
-load-misses
>     734606 =C2=B1  4%     -79.2%     153010 =C2=B1  5%  perf-stat.ps.node=
-loads
>    8837267           -61.9%    3364441 =C2=B1  7%  perf-stat.ps.node-stor=
e-misses
>    2799494 =C2=B1  7%     -34.1%    1845425 =C2=B1 14%  perf-stat.ps.node=
-stores
>  7.015e+13           +13.0%   7.93e+13        perf-stat.total.instruction=
s
>       7.88            -6.8        1.06 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_wmem_schedule.tcp_build_frag.do_tcp_sendpages.tcp_sendpage.in
> et_sendpage
>       7.64            -6.8        0.84        perf-profile.calltrace.cycl=
es-
> pp.__sk_mem_schedule.tcp_wmem_schedule.tcp_build_frag.do_tcp_sendp
> ages.tcp_sendpage
>       7.45            -6.7        0.76 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__sk_mem_raise_allocated.__sk_mem_schedule.tcp_wmem_schedule.tc
> p_build_frag.do_tcp_sendpages
>      10.74            -6.3        4.41        perf-profile.calltrace.cycl=
es-
> pp.tcp_build_frag.do_tcp_sendpages.tcp_sendpage.inet_sendpage.kernel_s
> endpage
>      33.39            -6.1       27.33        perf-profile.calltrace.cycl=
es-
> pp.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_sendpage.pipe_to_s
> endpage
>      33.88            -6.0       27.93        perf-profile.calltrace.cycl=
es-
> pp.inet_sendpage.kernel_sendpage.sock_sendpage.pipe_to_sendpage.__spli
> ce_from_pipe
>      34.25            -5.9       28.39        perf-profile.calltrace.cycl=
es-
> pp.kernel_sendpage.sock_sendpage.pipe_to_sendpage.__splice_from_pipe.
> generic_splice_sendpage
>      34.43            -5.8       28.61        perf-profile.calltrace.cycl=
es-
> pp.sock_sendpage.pipe_to_sendpage.__splice_from_pipe.generic_splice_se
> ndpage.direct_splice_actor
>      34.75            -5.8       29.00        perf-profile.calltrace.cycl=
es-
> pp.pipe_to_sendpage.__splice_from_pipe.generic_splice_sendpage.direct_s
> plice_actor.splice_direct_to_actor
>      36.66            -5.3       31.34        perf-profile.calltrace.cycl=
es-
> pp.__splice_from_pipe.generic_splice_sendpage.direct_splice_actor.splice_=
d
> irect_to_actor.do_splice_direct
>      37.08            -5.2       31.85        perf-profile.calltrace.cycl=
es-
> pp.generic_splice_sendpage.direct_splice_actor.splice_direct_to_actor.do_=
sp
> lice_direct.do_sendfile
>      37.20            -5.2       32.00        perf-profile.calltrace.cycl=
es-
> pp.direct_splice_actor.splice_direct_to_actor.do_splice_direct.do_sendfil=
e._
> _x64_sys_sendfile64
>      16.95            -5.1       11.89        perf-profile.calltrace.cycl=
es-
> pp.do_tcp_sendpages.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_s
> endpage
>       8.23            -2.6        5.67 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__release_sock.release_sock.tcp_sendpage.inet_sendpage.kernel_sendp
> age
>      46.36            -2.5       43.86        perf-profile.calltrace.cycl=
es-
> pp.splice_direct_to_actor.do_splice_direct.do_sendfile.__x64_sys_sendfile=
64
> .do_syscall_64
>      46.96            -2.4       44.58        perf-profile.calltrace.cycl=
es-
> pp.do_splice_direct.do_sendfile.__x64_sys_sendfile64.do_syscall_64.entry_=
S
> YSCALL_64_after_hwframe
>       9.59            -2.3        7.24 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.release_sock.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_sendp
> age
>       2.87            -2.1        0.76        perf-profile.calltrace.cycl=
es-
> pp.tcp_data_queue.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protoc
> ol_deliver_rcu
>      51.58            -2.0       49.62        perf-profile.calltrace.cycl=
es-
> pp.entry_SYSCALL_64_after_hwframe.sendfile.sendfile_tcp_stream.main.__li
> bc_start_main
>      49.43            -1.9       47.48        perf-profile.calltrace.cycl=
es-
> pp.do_sendfile.__x64_sys_sendfile64.do_syscall_64.entry_SYSCALL_64_after
> _hwframe.sendfile
>      51.31            -1.9       49.37        perf-profile.calltrace.cycl=
es-
> pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.sendfile.sendfile_tcp_st
> ream.main
>       6.07            -1.8        4.22 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_do_rcv.__releas
> e_sock.release_sock
>       6.04            -1.8        4.20 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_write_xmit.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_
> do_rcv.__release_sock
>      52.41            -1.8       50.64        perf-profile.calltrace.cycl=
es-
> pp.sendfile.sendfile_tcp_stream.main.__libc_start_main
>      50.66            -1.7       48.91        perf-profile.calltrace.cycl=
es-
> pp.__x64_sys_sendfile64.do_syscall_64.entry_SYSCALL_64_after_hwframe.s
> endfile.sendfile_tcp_stream
>       1.99            -1.5        0.48 =C2=B1 44%  perf-profile.calltrace=
.cycles-
> pp.tcp_v4_do_rcv.__release_sock.release_sock.tcp_recvmsg.inet_recvmsg
>      53.77            -1.5       52.28        perf-profile.calltrace.cycl=
es-
> pp.sendfile_tcp_stream.main.__libc_start_main
>       1.88 =C2=B1  2%      -1.5        0.42 =C2=B1 44%  perf-profile.call=
trace.cycles-
> pp.tcp_rcv_established.tcp_v4_do_rcv.__release_sock.release_sock.tcp_recv
> msg
>       5.64            -1.5        4.19 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit._
> _tcp_push_pending_frames
>       6.14            -1.4        4.71 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pendin
> g_frames.tcp_rcv_established
>       5.67            -1.4        4.24 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_rcv_established.tcp_v4_do_rcv.__release_sock.release_sock.tcp_sen
> dpage
>       2.08            -1.4        0.68 =C2=B1  8%  perf-profile.calltrace=
.cycles-
> pp.__release_sock.release_sock.tcp_recvmsg.inet_recvmsg.sock_recvmsg
>       5.66            -1.4        4.28 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_v4_do_rcv.__release_sock.release_sock.tcp_sendpage.inet_sendpage
>       2.22            -1.4        0.84 =C2=B1  8%  perf-profile.calltrace=
.cycles-
> pp.release_sock.tcp_recvmsg.inet_recvmsg.sock_recvmsg.__sys_recvfrom
>       7.37            -1.3        6.07 =C2=B1  3%  perf-profile.calltrace=
.cycles-
> pp.__tcp_transmit_skb.tcp_write_xmit.__tcp_push_pending_frames.tcp_rcv
> _established.tcp_v4_do_rcv
>      12.84            -1.2       11.64        perf-profile.calltrace.cycl=
es-
> pp.asm_sysvec_call_function_single.acpi_safe_halt.acpi_idle_enter.cpuidle=
_
> enter_state.cpuidle_enter
>       7.52            -1.1        6.41 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__dev_queue_xmit.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_s
> kb.tcp_write_xmit
>      11.36            -1.0       10.31        perf-profile.calltrace.cycl=
es-
> pp.start_secondary.secondary_startup_64_no_verify
>      11.35            -1.0       10.30        perf-profile.calltrace.cycl=
es-
> pp.cpu_startup_entry.start_secondary.secondary_startup_64_no_verify
>      11.47            -1.0       10.43        perf-profile.calltrace.cycl=
es-
> pp.secondary_startup_64_no_verify
>      11.32            -1.0       10.28        perf-profile.calltrace.cycl=
es-
> pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64_no_ve
> rify
>       9.96            -0.9        9.02        perf-profile.calltrace.cycl=
es-
> pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.secondary_=
s
> tartup_64_no_verify
>       9.10            -0.9        8.24        perf-profile.calltrace.cycl=
es-
> pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_second=
ar
> y
>       9.03            -0.9        8.18        perf-profile.calltrace.cycl=
es-
> pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startu=
p_
> entry
>       8.78            -0.8        7.95        perf-profile.calltrace.cycl=
es-
> pp.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do=
_i
> dle
>       1.03            -0.6        0.43 =C2=B1 44%  perf-profile.calltrace=
.cycles-
> pp.__wake_up_common.__wake_up_common_lock.sock_def_readable.tcp_
> data_queue.tcp_rcv_established
>       1.19            -0.6        0.59 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.sock_def_readable.tcp_data_queue.tcp_rcv_established.tcp_v4_do_rcv.t
> cp_v4_rcv
>       1.32            -0.6        0.75 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv.__release_sock.release_sock
>       1.08            -0.5        0.54        perf-profile.calltrace.cycl=
es-
> pp.__wake_up_common_lock.sock_def_readable.tcp_data_queue.tcp_rcv_e
> stablished.tcp_v4_do_rcv
>       1.12            -0.5        0.59 =C2=B1  3%  perf-profile.calltrace=
.cycles-
> pp.tcp_clean_rtx_queue.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv.__relea
> se_sock
>       2.46            -0.5        2.00 =C2=B1  8%  perf-profile.calltrace=
.cycles-
> pp.wait_woken.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg
>       2.24            -0.4        1.80 =C2=B1  8%  perf-profile.calltrace=
.cycles-
> pp.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked.tcp_rec
> vmsg
>       2.19            -0.4        1.75 =C2=B1  8%  perf-profile.calltrace=
.cycles-
> pp.schedule.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locke
> d
>       2.08            -0.4        1.65 =C2=B1  7%  perf-profile.calltrace=
.cycles-
> pp.__schedule.schedule.schedule_timeout.wait_woken.sk_wait_data
>       3.07            -0.4        2.65        perf-profile.calltrace.cycl=
es-
> pp.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.sock_recvm
> sg
>       1.69            -0.4        1.32 =C2=B1  8%  perf-profile.calltrace=
.cycles-
> pp.tcp_clean_rtx_queue.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_
> rcv
>       3.56            -0.3        3.27        perf-profile.calltrace.cycl=
es-
> pp.acpi_safe_halt.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuid=
le
> _idle_call
>       8.87            -0.3        8.62        perf-profile.calltrace.cycl=
es-
> pp.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu.ip_local_deliver_fini=
sh
> .__netif_receive_skb_one_core
>       2.17            -0.2        1.96 =C2=B1  8%  perf-profile.calltrace=
.cycles-
> pp.tcp_ack.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliv=
e
> r_rcu
>       8.73            -0.2        8.51        perf-profile.calltrace.cycl=
es-
> pp.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_protocol_deliver_rcu.i=
p
> _local_deliver_finish
>       0.69            -0.2        0.53 =C2=B1 44%  perf-profile.calltrace=
.cycles-
> pp.dequeue_task_fair.__schedule.schedule.schedule_timeout.wait_woken
>       0.60            -0.1        0.46 =C2=B1 44%  perf-profile.calltrace=
.cycles-
> pp.dequeue_entity.dequeue_task_fair.__schedule.schedule.schedule_timeo
> ut
>       2.34            -0.1        2.23        perf-profile.calltrace.cycl=
es-
> pp.sysvec_call_function_single.asm_sysvec_call_function_single.acpi_safe_=
h
> alt.acpi_idle_enter.cpuidle_enter_state
>       0.99            -0.1        0.92        perf-profile.calltrace.cycl=
es-
> pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.secondary_star
> tup_64_no_verify
>       1.78            -0.1        1.70        perf-profile.calltrace.cycl=
es-
> pp.__sysvec_call_function_single.sysvec_call_function_single.asm_sysvec_c=
al
> l_function_single.acpi_safe_halt.acpi_idle_enter
>       0.93            -0.1        0.85        perf-profile.calltrace.cycl=
es-
> pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.start_secondary
>       0.60            -0.1        0.54        perf-profile.calltrace.cycl=
es-
> pp.menu_select.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondar=
y
>       1.21            -0.1        1.16        perf-profile.calltrace.cycl=
es-
> pp.sched_ttwu_pending.__sysvec_call_function_single.sysvec_call_function_
> single.asm_sysvec_call_function_single.acpi_safe_halt
>       0.95            -0.0        0.90        perf-profile.calltrace.cycl=
es-
> pp.ttwu_do_activate.sched_ttwu_pending.__sysvec_call_function_single.sys
> vec_call_function_single.asm_sysvec_call_function_single
>       0.69            -0.0        0.66        perf-profile.calltrace.cycl=
es-
> pp.napi_consume_skb.net_rx_action.__do_softirq.do_softirq.__local_bh_en
> able_ip
>       0.78            -0.0        0.75        perf-profile.calltrace.cycl=
es-
> pp.enqueue_task_fair.activate_task.ttwu_do_activate.sched_ttwu_pending._
> _sysvec_call_function_single
>       0.53            +0.0        0.55        perf-profile.calltrace.cycl=
es-
> pp.enqueue_entity.enqueue_task_fair.activate_task.ttwu_do_activate.sched
> _ttwu_pending
>       0.58            +0.0        0.61 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__alloc_skb.tcp_stream_alloc_skb.tcp_build_frag.do_tcp_sendpages.tcp_
> sendpage
>       0.79            +0.1        0.90 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_stream_alloc_skb.tcp_build_frag.do_tcp_sendpages.tcp_sendpage.in
> et_sendpage
>       0.77            +0.1        0.90 =C2=B1  3%  perf-profile.calltrace=
.cycles-
> pp.page_cache_pipe_buf_release.__splice_from_pipe.generic_splice_sendpa
> ge.direct_splice_actor.splice_direct_to_actor
>       1.04            +0.1        1.18 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp._raw_spin_lock_bh.release_sock.tcp_sendpage.inet_sendpage.kernel_se
> ndpage
>       0.96            +0.2        1.12 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_current_mss.tcp_send_mss.do_tcp_sendpages.tcp_sendpage.inet_se
> ndpage
>       0.71            +0.2        0.89        perf-profile.calltrace.cycl=
es-
> pp.do_splice_to.splice_direct_to_actor.do_splice_direct.do_sendfile.__x64=
_s
> ys_sendfile64
>       0.41 =C2=B1 50%      +0.2        0.64 =C2=B1  2%  perf-profile.call=
trace.cycles-
> pp._copy_from_user.__x64_sys_sendfile64.do_syscall_64.entry_SYSCALL_64
> _after_hwframe.sendfile
>       0.41 =C2=B1 50%      +0.2        0.65        perf-profile.calltrace=
.cycles-
> pp.security_file_permission.do_sendfile.__x64_sys_sendfile64.do_syscall_6=
4
> .entry_SYSCALL_64_after_hwframe
>       1.32            +0.2        1.56        perf-profile.calltrace.cycl=
es-
> pp.tcp_send_mss.do_tcp_sendpages.tcp_sendpage.inet_sendpage.kernel_se
> ndpage
>      15.63            +0.3       15.90        perf-profile.calltrace.cycl=
es-
> pp.__do_softirq.do_softirq.__local_bh_enable_ip.__dev_queue_xmit.ip_fini
> sh_output2
>       1.10            +0.3        1.37 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_write_xmit.__tcp_push_pending_frames.do_tcp_sendpages.tcp_send
> page.inet_sendpage
>      15.79            +0.3       16.06        perf-profile.calltrace.cycl=
es-
> pp.do_softirq.__local_bh_enable_ip.__dev_queue_xmit.ip_finish_output2._
> _ip_queue_xmit
>       1.18            +0.3        1.45 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__tcp_push_pending_frames.do_tcp_sendpages.tcp_sendpage.inet_send
> page.kernel_sendpage
>      15.88            +0.3       16.16        perf-profile.calltrace.cycl=
es-
> pp.__local_bh_enable_ip.__dev_queue_xmit.ip_finish_output2.__ip_queue_
> xmit.__tcp_transmit_skb
>       0.31 =C2=B1 81%      +0.3        0.60 =C2=B1  2%  perf-profile.call=
trace.cycles-
> pp.touch_atime.splice_direct_to_actor.do_splice_direct.do_sendfile.__x64_=
s
> ys_sendfile64
>       1.29            +0.3        1.60        perf-profile.calltrace.cycl=
es-
> pp.copy_page_to_iter_pipe.filemap_read.generic_file_splice_read.splice_di=
r
> ect_to_actor.do_splice_direct
>       2.14            +0.3        2.48 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.d
> o_tcp_sendpages
>       2.23            +0.4        2.60        perf-profile.calltrace.cycl=
es-
> pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_write_xmit.do_tcp_sendpages.
> tcp_sendpage
>       2.42            +0.4        2.86 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__tcp_transmit_skb.tcp_write_xmit.do_tcp_sendpages.tcp_sendpage.inet
> _sendpage
>       2.66            +0.5        3.20 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.tcp_write_xmit.do_tcp_sendpages.tcp_sendpage.inet_sendpage.kernel_s
> endpage
>       0.00            +0.5        0.54 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__fget_light.do_sendfile.__x64_sys_sendfile64.do_syscall_64.entry_SYSC
> ALL_64_after_hwframe
>       0.00            +0.6        0.56 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__entry_text_start.sendfile.sendfile_tcp_stream.main.__libc_start_main
>       4.35            +0.6        4.96 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.native_queued_spin_lock_slowpath._raw_spin_lock_bh.lock_sock_neste
> d.tcp_sendpage.inet_sendpage
>       0.00            +0.7        0.74 =C2=B1  3%  perf-profile.calltrace=
.cycles-
> pp.try_to_wake_up.__wake_up_common.__wake_up_common_lock.sock_d
> ef_readable.tcp_rcv_established
>       5.15            +0.8        5.93 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp._raw_spin_lock_bh.lock_sock_nested.tcp_sendpage.inet_sendpage.kerne
> l_sendpage
>       0.00            +0.8        0.84 =C2=B1  3%  perf-profile.calltrace=
.cycles-
> pp.__wake_up_common.__wake_up_common_lock.sock_def_readable.tcp_
> rcv_established.tcp_v4_do_rcv
>       2.47            +0.8        3.31        perf-profile.calltrace.cycl=
es-
> pp.tcp_write_xmit.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_
> do_rcv.tcp_v4_rcv
>       2.49            +0.8        3.34        perf-profile.calltrace.cycl=
es-
> pp.__tcp_push_pending_frames.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_
> rcv.ip_protocol_deliver_rcu
>       5.49            +0.9        6.34 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.lock_sock_nested.tcp_sendpage.inet_sendpage.kernel_sendpage.sock_se
> ndpage
>       0.00            +0.9        0.88 =C2=B1  3%  perf-profile.calltrace=
.cycles-
> pp.__wake_up_common_lock.sock_def_readable.tcp_rcv_established.tcp_v
> 4_do_rcv.tcp_v4_rcv
>       2.61 =C2=B1  2%      +0.9        3.53 =C2=B1  3%  perf-profile.call=
trace.cycles-
> pp.check_heap_object.__check_object_size.simple_copy_to_iter.__skb_data
> gram_iter.skb_copy_datagram_iter
>       0.00            +0.9        0.94 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.sock_def_readable.tcp_rcv_established.tcp_v4_do_rcv.tcp_v4_rcv.ip_pro
> tocol_deliver_rcu
>       2.98            +1.0        4.00 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.__check_object_size.simple_copy_to_iter.__skb_datagram_iter.skb_copy
> _datagram_iter.tcp_recvmsg_locked
>       2.91            +1.0        3.94        perf-profile.calltrace.cycl=
es-
> pp.filemap_get_read_batch.filemap_get_pages.filemap_read.generic_file_sp
> lice_read.splice_direct_to_actor
>      10.13            +1.0       11.17        perf-profile.calltrace.cycl=
es-
> pp.__tcp_transmit_skb.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.sock_
> recvmsg
>       3.14            +1.1        4.21        perf-profile.calltrace.cycl=
es-
> pp.filemap_get_pages.filemap_read.generic_file_splice_read.splice_direct_=
t
> o_actor.do_splice_direct
>       3.24            +1.1        4.32 =C2=B1  2%  perf-profile.calltrace=
.cycles-
> pp.simple_copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.tcp_r
> ecvmsg_locked.tcp_recvmsg
>      10.38            +1.3       11.66        perf-profile.calltrace.cycl=
es-
> pp.__ip_queue_xmit.__tcp_transmit_skb.tcp_recvmsg_locked.tcp_recvmsg.i
> net_recvmsg
>      10.07            +1.3       11.41        perf-profile.calltrace.cycl=
es-
> pp.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_skb.tcp_recvmsg_loc
> ked.tcp_recvmsg
>       9.94            +1.3       11.28        perf-profile.calltrace.cycl=
es-
> pp.__dev_queue_xmit.ip_finish_output2.__ip_queue_xmit.__tcp_transmit_s
> kb.tcp_recvmsg_locked
>       6.53            +1.6        8.18        perf-profile.calltrace.cycl=
es-
> pp.copyout._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.tcp
> _recvmsg_locked
>       7.02            +1.8        8.79        perf-profile.calltrace.cycl=
es-
> pp._copy_to_iter.__skb_datagram_iter.skb_copy_datagram_iter.tcp_recvms
> g_locked.tcp_recvmsg
>      31.73            +1.9       33.63        perf-profile.calltrace.cycl=
es-
> pp.tcp_recvmsg.inet_recvmsg.sock_recvmsg.__sys_recvfrom.__x64_sys_recv
> from
>      31.85            +1.9       33.77        perf-profile.calltrace.cycl=
es-
> pp.inet_recvmsg.sock_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_sysc
> all_64
>       6.52            +1.9        8.44        perf-profile.calltrace.cycl=
es-
> pp.filemap_read.generic_file_splice_read.splice_direct_to_actor.do_splice=
_d
> irect.do_sendfile
>      32.06            +1.9       34.00        perf-profile.calltrace.cycl=
es-
> pp.sock_recvmsg.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_
> SYSCALL_64_after_hwframe
>      32.54            +2.0       34.54        perf-profile.calltrace.cycl=
es-
> pp.__sys_recvfrom.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_af
> ter_hwframe.recv
>      32.63            +2.0       34.64        perf-profile.calltrace.cycl=
es-
> pp.__x64_sys_recvfrom.do_syscall_64.entry_SYSCALL_64_after_hwframe.rec
> v.process_requests
>      33.81            +2.0       35.82        perf-profile.calltrace.cycl=
es-
> pp.recv.process_requests.spawn_child.accept_connection.accept_connectio
> ns
>      32.95            +2.0       34.96        perf-profile.calltrace.cycl=
es-
> pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.recv.process_requests.s
> pawn_child
>      33.11            +2.0       35.14        perf-profile.calltrace.cycl=
es-
> pp.entry_SYSCALL_64_after_hwframe.recv.process_requests.spawn_child.ac
> cept_connection
>       7.44            +2.1        9.57        perf-profile.calltrace.cycl=
es-
> pp.generic_file_splice_read.splice_direct_to_actor.do_splice_direct.do_se=
ndf
> ile.__x64_sys_sendfile64
>      11.23            +3.1       14.38        perf-profile.calltrace.cycl=
es-
> pp.__skb_datagram_iter.skb_copy_datagram_iter.tcp_recvmsg_locked.tcp_r
> ecvmsg.inet_recvmsg
>      11.30            +3.2       14.48        perf-profile.calltrace.cycl=
es-
> pp.skb_copy_datagram_iter.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.
> sock_recvmsg
>      29.26            +3.2       32.47        perf-profile.calltrace.cycl=
es-
> pp.tcp_recvmsg_locked.tcp_recvmsg.inet_recvmsg.sock_recvmsg.__sys_recvf
> rom
>       7.77            -6.8        0.94        perf-profile.children.cycle=
s-
> pp.__sk_mem_schedule
>       7.95            -6.8        1.12        perf-profile.children.cycle=
s-
> pp.tcp_wmem_schedule
>       7.62            -6.7        0.88        perf-profile.children.cycle=
s-
> pp.__sk_mem_raise_allocated
>      10.92            -6.3        4.63        perf-profile.children.cycle=
s-pp.tcp_build_frag
>       6.86 =C2=B1  2%      -6.2        0.62 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.mem_cgroup_charge_skmem
>      33.63            -5.9       27.72        perf-profile.children.cycle=
s-pp.tcp_sendpage
>      34.07            -5.8       28.26        perf-profile.children.cycle=
s-
> pp.inet_sendpage
>      34.39            -5.7       28.65        perf-profile.children.cycle=
s-
> pp.kernel_sendpage
>      34.58            -5.7       28.88        perf-profile.children.cycle=
s-
> pp.sock_sendpage
>      34.90            -5.6       29.28        perf-profile.children.cycle=
s-
> pp.pipe_to_sendpage
>      36.86            -5.2       31.69        perf-profile.children.cycle=
s-
> pp.__splice_from_pipe
>      37.23            -5.1       32.14        perf-profile.children.cycle=
s-
> pp.generic_splice_sendpage
>      37.33            -5.1       32.26        perf-profile.children.cycle=
s-
> pp.direct_splice_actor
>      17.14            -4.9       12.22        perf-profile.children.cycle=
s-
> pp.do_tcp_sendpages
>      10.36            -3.9        6.49        perf-profile.children.cycle=
s-
> pp.__release_sock
>       4.40            -3.6        0.78        perf-profile.children.cycle=
s-
> pp.tcp_data_queue
>      11.99            -3.6        8.40        perf-profile.children.cycle=
s-pp.release_sock
>       3.34 =C2=B1  4%      -3.1        0.26 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.try_charge_memcg
>      16.59            -3.0       13.62        perf-profile.children.cycle=
s-
> pp.tcp_v4_do_rcv
>      16.37            -2.9       13.46        perf-profile.children.cycle=
s-
> pp.tcp_rcv_established
>      46.40            -2.5       43.91        perf-profile.children.cycle=
s-
> pp.splice_direct_to_actor
>       2.93            -2.5        0.46        perf-profile.children.cycle=
s-
> pp.__sk_mem_reduce_allocated
>      46.99            -2.4       44.62        perf-profile.children.cycle=
s-
> pp.do_splice_direct
>      49.52            -1.9       47.59        perf-profile.children.cycle=
s-pp.do_sendfile
>      50.71            -1.7       48.97        perf-profile.children.cycle=
s-
> pp.__x64_sys_sendfile64
>       1.54 =C2=B1  5%      -1.5        0.06 =C2=B1  6%  perf-profile.chil=
dren.cycles-
> pp.page_counter_try_charge
>       1.56 =C2=B1  3%      -1.4        0.16 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.refill_stock
>       1.29 =C2=B1  4%      -1.2        0.06        perf-profile.children.=
cycles-
> pp.drain_stock
>       1.26 =C2=B1  4%      -1.2        0.05        perf-profile.children.=
cycles-
> pp.page_counter_uncharge
>      52.89            -1.2       51.68        perf-profile.children.cycle=
s-pp.sendfile
>      11.36            -1.0       10.31        perf-profile.children.cycle=
s-
> pp.start_secondary
>      11.47            -1.0       10.43        perf-profile.children.cycle=
s-
> pp.secondary_startup_64_no_verify
>      11.47            -1.0       10.43        perf-profile.children.cycle=
s-
> pp.cpu_startup_entry
>      11.45            -1.0       10.41        perf-profile.children.cycle=
s-pp.do_idle
>      53.93            -1.0       52.92        perf-profile.children.cycle=
s-
> pp.sendfile_tcp_stream
>       3.85            -0.9        2.91        perf-profile.children.cycle=
s-pp.tcp_ack
>      10.07            -0.9        9.13        perf-profile.children.cycle=
s-
> pp.cpuidle_idle_call
>       9.19            -0.9        8.34        perf-profile.children.cycle=
s-pp.cpuidle_enter
>       9.13            -0.8        8.28        perf-profile.children.cycle=
s-
> pp.cpuidle_enter_state
>       2.87            -0.8        2.03        perf-profile.children.cycle=
s-
> pp.tcp_clean_rtx_queue
>       8.84            -0.8        8.02        perf-profile.children.cycle=
s-pp.acpi_safe_halt
>       8.87            -0.8        8.04        perf-profile.children.cycle=
s-pp.acpi_idle_enter
>       7.77            -0.7        7.11        perf-profile.children.cycle=
s-
> pp.asm_sysvec_call_function_single
>       9.79            -0.6        9.14        perf-profile.children.cycle=
s-
> pp.__tcp_push_pending_frames
>       0.75 =C2=B1  4%      -0.6        0.14 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.mem_cgroup_uncharge_skmem
>       3.07            -0.4        2.63        perf-profile.children.cycle=
s-pp.__schedule
>       3.09            -0.4        2.67        perf-profile.children.cycle=
s-pp.sk_wait_data
>       2.47            -0.4        2.08        perf-profile.children.cycle=
s-pp.wait_woken
>       2.25            -0.4        1.87        perf-profile.children.cycle=
s-
> pp.schedule_timeout
>       2.20            -0.4        1.83        perf-profile.children.cycle=
s-pp.schedule
>       1.10 =C2=B1  2%      -0.3        0.82 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.pick_next_task_fair
>       0.73 =C2=B1  4%      -0.2        0.48 =C2=B1  6%  perf-profile.chil=
dren.cycles-
> pp.newidle_balance
>       0.28 =C2=B1 12%      -0.2        0.09 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.cgroup_rstat_updated
>       2.39            -0.1        2.28        perf-profile.children.cycle=
s-
> pp.sysvec_call_function_single
>       0.30 =C2=B1  4%      -0.1        0.20 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.load_balance
>       1.01            -0.1        0.93        perf-profile.children.cycle=
s-pp.schedule_idle
>       1.68            -0.1        1.60        perf-profile.children.cycle=
s-
> pp.sock_def_readable
>       1.82            -0.1        1.74        perf-profile.children.cycle=
s-
> pp.__sysvec_call_function_single
>       0.22 =C2=B1  5%      -0.1        0.14 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.find_busiest_group
>       1.51            -0.1        1.44        perf-profile.children.cycle=
s-
> pp.__wake_up_common_lock
>       0.20 =C2=B1  6%      -0.1        0.13 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.update_sd_lb_stats
>       1.27            -0.1        1.21        perf-profile.children.cycle=
s-
> pp.try_to_wake_up
>       1.43            -0.1        1.37        perf-profile.children.cycle=
s-
> pp.__wake_up_common
>       0.14 =C2=B1  3%      -0.1        0.09 =C2=B1  7%  perf-profile.chil=
dren.cycles-
> pp.update_blocked_averages
>       0.61            -0.1        0.56        perf-profile.children.cycle=
s-pp.menu_select
>       0.70            -0.1        0.64        perf-profile.children.cycle=
s-
> pp.dequeue_task_fair
>       0.15 =C2=B1  4%      -0.1        0.10 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.update_sg_lb_stats
>       0.63            -0.0        0.58        perf-profile.children.cycle=
s-
> pp.dequeue_entity
>       1.25            -0.0        1.20        perf-profile.children.cycle=
s-
> pp.sched_ttwu_pending
>       0.24 =C2=B1  2%      -0.0        0.19 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.tcp_check_space
>       0.98            -0.0        0.94        perf-profile.children.cycle=
s-
> pp.ttwu_do_activate
>       0.06            -0.0        0.02 =C2=B1 99%  perf-profile.children.=
cycles-
> pp.irqentry_exit
>       0.30            -0.0        0.27 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.native_irq_return_iret
>       0.52            -0.0        0.48        perf-profile.children.cycle=
s-
> pp.ttwu_queue_wakelist
>       0.43            -0.0        0.40        perf-profile.children.cycle=
s-
> pp.native_sched_clock
>       0.08 =C2=B1  5%      -0.0        0.06 =C2=B1  9%  perf-profile.chil=
dren.cycles-
> pp.raw_spin_rq_lock_nested
>       0.22            -0.0        0.20 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.__switch_to_asm
>       0.48            -0.0        0.45        perf-profile.children.cycle=
s-
> pp.sched_clock_cpu
>       0.27            -0.0        0.24        perf-profile.children.cycle=
s-pp.__switch_to
>       0.21 =C2=B1  2%      -0.0        0.18 =C2=B1  4%  perf-profile.chil=
dren.cycles-
> pp.___perf_sw_event
>       0.11 =C2=B1  3%      -0.0        0.09        perf-profile.children.=
cycles-
> pp.ct_kernel_exit_state
>       0.19 =C2=B1  2%      -0.0        0.17 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.native_apic_msr_eoi_write
>       0.29            -0.0        0.27        perf-profile.children.cycle=
s-pp.update_curr
>       0.06            -0.0        0.04 =C2=B1 44%  perf-profile.children.=
cycles-
> pp.update_irq_load_avg
>       0.14 =C2=B1  2%      -0.0        0.12        perf-profile.children.=
cycles-
> pp.update_rq_clock_task
>       0.11 =C2=B1  4%      -0.0        0.09 =C2=B1  7%  perf-profile.chil=
dren.cycles-
> pp.resched_curr
>       0.13 =C2=B1  4%      -0.0        0.11 =C2=B1  4%  perf-profile.chil=
dren.cycles-
> pp.check_preempt_curr
>       0.17 =C2=B1  2%      -0.0        0.15 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.__x2apic_send_IPI_dest
>       0.17 =C2=B1  2%      -0.0        0.15 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.__update_load_avg_se
>       0.12 =C2=B1  4%      -0.0        0.10 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.finish_task_switch
>       0.25            -0.0        0.23 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.set_next_entity
>       0.09            -0.0        0.08        perf-profile.children.cycle=
s-
> pp.__wrgsbase_inactive
>       0.06            -0.0        0.05        perf-profile.children.cycle=
s-pp.ct_idle_exit
>       0.10            +0.0        0.11        perf-profile.children.cycle=
s-
> pp.tcp_chrono_stop
>       0.07 =C2=B1  5%      +0.0        0.08        perf-profile.children.=
cycles-pp.rb_next
>       0.05 =C2=B1  7%      +0.0        0.06 =C2=B1  7%  perf-profile.chil=
dren.cycles-
> pp.__fdget
>       0.08 =C2=B1  5%      +0.0        0.09 =C2=B1  4%  perf-profile.chil=
dren.cycles-
> pp.tcp_rearm_rto
>       0.06 =C2=B1  8%      +0.0        0.07        perf-profile.children.=
cycles-pp.rb_first
>       1.08            +0.0        1.10        perf-profile.children.cycle=
s-
> pp.dev_hard_start_xmit
>       0.11 =C2=B1  4%      +0.0        0.13 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.inet_ehashfn
>       0.07 =C2=B1  6%      +0.0        0.09 =C2=B1  4%  perf-profile.chil=
dren.cycles-
> pp.demo_interval_tick
>       0.12 =C2=B1  3%      +0.0        0.14 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.netif_skb_features
>       0.28 =C2=B1  2%      +0.0        0.30        perf-profile.children.=
cycles-
> pp.ip_local_out
>       0.09            +0.0        0.10 =C2=B1  4%  perf-profile.children.=
cycles-
> pp.tcp_queue_rcv
>       0.05            +0.0        0.06 =C2=B1  7%  perf-profile.children.=
cycles-
> pp.__tcp_ack_snd_check
>       0.16 =C2=B1  3%      +0.0        0.18 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.ip_send_check
>       0.07 =C2=B1  7%      +0.0        0.08 =C2=B1  4%  perf-profile.chil=
dren.cycles-
> pp.tcp_rtt_estimator
>       0.06 =C2=B1  8%      +0.0        0.07 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.iov_iter_pipe
>       0.24 =C2=B1  3%      +0.0        0.26        perf-profile.children.=
cycles-
> pp.tcp_rcv_space_adjust
>       0.25            +0.0        0.26        perf-profile.children.cycle=
s-
> pp.__update_load_avg_cfs_rq
>       0.15            +0.0        0.17 =C2=B1  5%  perf-profile.children.=
cycles-
> pp.ipv4_dst_check
>       0.06 =C2=B1  7%      +0.0        0.08 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.splice_from_pipe_next
>       0.12 =C2=B1  3%      +0.0        0.14 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.tcp_update_skb_after_send
>       0.60            +0.0        0.62        perf-profile.children.cycle=
s-
> pp._raw_spin_lock_irqsave
>       0.08            +0.0        0.10        perf-profile.children.cycle=
s-
> pp.__list_add_valid
>       0.11 =C2=B1  3%      +0.0        0.13 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.__get_task_ioprio
>       0.36            +0.0        0.38        perf-profile.children.cycle=
s-
> pp.enqueue_to_backlog
>       0.11            +0.0        0.13 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.syscall_enter_from_user_mode
>       0.12            +0.0        0.14 =C2=B1  2%  perf-profile.children.=
cycles-pp.tcp_push
>       0.21            +0.0        0.23 =C2=B1  3%  perf-profile.children.=
cycles-
> pp.exit_to_user_mode_prepare
>       0.10 =C2=B1  5%      +0.0        0.12 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.xas_start
>       0.10            +0.0        0.12 =C2=B1  3%  perf-profile.children.=
cycles-
> pp.tcp_update_pacing_rate
>       0.06            +0.0        0.08 =C2=B1  5%  perf-profile.children.=
cycles-
> pp.tcp_event_data_recv
>       0.12 =C2=B1  4%      +0.0        0.14        perf-profile.children.=
cycles-
> pp.tcp_downgrade_zcopy_pure
>       0.17 =C2=B1  3%      +0.0        0.20 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.syscall_exit_to_user_mode_prepare
>       0.20 =C2=B1  2%      +0.0        0.22 =C2=B1  4%  perf-profile.chil=
dren.cycles-
> pp.sockfd_lookup_light
>       0.10 =C2=B1  4%      +0.0        0.13        perf-profile.children.=
cycles-
> pp.is_vmalloc_addr
>       0.10 =C2=B1  4%      +0.0        0.13 =C2=B1  6%  perf-profile.chil=
dren.cycles-
> pp.make_vfsgid
>       0.10 =C2=B1  3%      +0.0        0.13 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.make_vfsuid
>       0.39            +0.0        0.42        perf-profile.children.cycle=
s-
> pp.netif_rx_internal
>       0.28 =C2=B1  2%      +0.0        0.30 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.recv_tcp_stream
>       0.13            +0.0        0.16 =C2=B1  4%  perf-profile.children.=
cycles-
> pp.check_stack_object
>       0.13 =C2=B1  3%      +0.0        0.16 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.tcp_release_cb
>       0.12 =C2=B1  3%      +0.0        0.15 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.demo_stream_interval
>       0.26 =C2=B1  2%      +0.0        0.29 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.tcp_add_backlog
>       0.11 =C2=B1  3%      +0.0        0.14 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.tcp_ack_update_rtt
>       0.21            +0.0        0.24 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.ip_rcv_core
>       0.18 =C2=B1  2%      +0.0        0.21 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.__sk_dst_check
>       0.07            +0.0        0.10 =C2=B1  3%  perf-profile.children.=
cycles-
> pp.__tcp_cleanup_rbuf
>       0.41            +0.0        0.44        perf-profile.children.cycle=
s-pp.__netif_rx
>       0.17 =C2=B1  2%      +0.0        0.20        perf-profile.children.=
cycles-
> pp.__tcp_select_window
>       0.14 =C2=B1  3%      +0.0        0.17 =C2=B1  3%  perf-profile.chil=
dren.cycles-
> pp.tcp_mtu_probe
>       0.34            +0.0        0.37        perf-profile.children.cycle=
s-
> pp.kmalloc_reserve
>       0.09 =C2=B1  4%      +0.0        0.12 =C2=B1  4%  perf-profile.chil=
dren.cycles-
> pp.lock_timer_base
>       0.17 =C2=B1  2%      +0.0        0.21        perf-profile.children.=
cycles-
> pp.tcp_tx_timestamp
>       0.15            +0.0        0.19 =C2=B1  3%  perf-profile.children.=
cycles-
> pp.folio_mark_accessed
>       0.20 =C2=B1  2%      +0.0        0.24        perf-profile.children.=
cycles-
> pp._raw_spin_unlock_bh
>       0.40            +0.0        0.44        perf-profile.children.cycle=
s-
> pp.tcp_mstamp_refresh
>       0.15 =C2=B1  3%      +0.0        0.20 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.inet_send_prepare
>       0.37            +0.0        0.42        perf-profile.children.cycle=
s-pp.__skb_clone
>       0.14 =C2=B1  2%      +0.0        0.18 =C2=B1  5%  perf-profile.chil=
dren.cycles-
> pp.ktime_get_coarse_real_ts64
>       0.27            +0.0        0.32        perf-profile.children.cycle=
s-
> pp.validate_xmit_skb
>       0.18            +0.0        0.22 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.fsnotify_perm
>       0.17 =C2=B1  3%      +0.0        0.22 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.skb_clone
>       0.19 =C2=B1  2%      +0.0        0.24 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.rw_verify_area
>       0.23 =C2=B1  2%      +0.1        0.28 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.xas_load
>       0.00            +0.1        0.05 =C2=B1  8%  perf-profile.children.=
cycles-
> pp.tcp_rbtree_insert
>       0.28 =C2=B1  2%      +0.1        0.34        perf-profile.children.=
cycles-
> pp.tcp_schedule_loss_probe
>       0.24            +0.1        0.30        perf-profile.children.cycle=
s-pp.sanity
>       0.32 =C2=B1  2%      +0.1        0.38 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.dst_release
>       0.58            +0.1        0.65        perf-profile.children.cycle=
s-
> pp.kmem_cache_alloc_node
>       0.31            +0.1        0.37        perf-profile.children.cycle=
s-
> pp.syscall_return_via_sysret
>       0.24            +0.1        0.31        perf-profile.children.cycle=
s-pp.tcp_tso_segs
>       0.25            +0.1        0.32        perf-profile.children.cycle=
s-
> pp.copy_page_to_iter
>       0.48            +0.1        0.55        perf-profile.children.cycle=
s-
> pp._raw_spin_lock
>       0.28            +0.1        0.35        perf-profile.children.cycle=
s-pp.rcu_all_qs
>       0.32 =C2=B1  4%      +0.1        0.39 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.sock_put
>       0.50            +0.1        0.57        perf-profile.children.cycle=
s-
> pp.kmem_cache_free
>       0.34 =C2=B1  2%      +0.1        0.42        perf-profile.children.=
cycles-
> pp.__put_user_8
>       0.29 =C2=B1  2%      +0.1        0.37 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.aa_file_perm
>       0.49            +0.1        0.57        perf-profile.children.cycle=
s-
> pp.syscall_exit_to_user_mode
>       0.69            +0.1        0.77        perf-profile.children.cycle=
s-pp.read_tsc
>       0.16 =C2=B1  4%      +0.1        0.25 =C2=B1  4%  perf-profile.chil=
dren.cycles-
> pp.skb_release_head_state
>       0.38            +0.1        0.47        perf-profile.children.cycle=
s-
> pp.tcp_established_options
>       0.41            +0.1        0.50 =C2=B1  3%  perf-profile.children.=
cycles-
> pp.__virt_addr_valid
>       0.48            +0.1        0.58        perf-profile.children.cycle=
s-
> pp.__tcp_send_ack
>       0.42            +0.1        0.52        perf-profile.children.cycle=
s-
> pp.entry_SYSRETQ_unsafe_stack
>       0.99            +0.1        1.09        perf-profile.children.cycle=
s-pp.__alloc_skb
>       0.52            +0.1        0.64        perf-profile.children.cycle=
s-
> pp.netperf_sendfile
>       0.43            +0.1        0.55        perf-profile.children.cycle=
s-pp.__mod_timer
>       0.46            +0.1        0.58        perf-profile.children.cycle=
s-
> pp.tcp_event_new_data_sent
>       0.80            +0.1        0.92        perf-profile.children.cycle=
s-
> pp.tcp_stream_alloc_skb
>       0.47            +0.1        0.60        perf-profile.children.cycle=
s-pp.sk_reset_timer
>       0.46 =C2=B1  2%      +0.1        0.58 =C2=B1  2%  perf-profile.chil=
dren.cycles-
> pp.current_time
>       0.51            +0.1        0.64        perf-profile.children.cycle=
s-
> pp.__fsnotify_parent
>       0.59            +0.1        0.73        perf-profile.children.cycle=
s-
> pp.__entry_text_start
>       0.54            +0.1        0.68        perf-profile.children.cycle=
s-
> pp._copy_from_user
>       0.41            +0.1        0.54        perf-profile.children.cycle=
s-
> pp.tcp_rate_check_app_limited
>       0.39 =C2=B1  2%      +0.1        0.52        perf-profile.children.=
cycles-
> pp.page_cache_pipe_buf_confirm
>       0.62            +0.1        0.76        perf-profile.children.cycle=
s-pp.__fget_light
>       0.79            +0.1        0.94 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.page_cache_pipe_buf_release
>       1.02            +0.2        1.19 =C2=B1  4%  perf-profile.children.=
cycles-pp.ktime_get
>       0.97            +0.2        1.14        perf-profile.children.cycle=
s-
> pp.napi_consume_skb
>       0.78            +0.2        0.95        perf-profile.children.cycle=
s-
> pp.__cond_resched
>       1.14            +0.2        1.32        perf-profile.children.cycle=
s-
> pp.tcp_current_mss
>       0.74            +0.2        0.93        perf-profile.children.cycle=
s-pp.do_splice_to
>       0.76            +0.2        0.96        perf-profile.children.cycle=
s-pp.__kfree_skb
>       0.94 =C2=B1  2%      +0.3        1.19        perf-profile.children.=
cycles-
> pp.apparmor_file_permission
>       1.38            +0.3        1.65        perf-profile.children.cycle=
s-pp.tcp_send_mss
>       1.09 =C2=B1  2%      +0.3        1.36        perf-profile.children.=
cycles-
> pp.atime_needs_update
>       1.44            +0.3        1.72        perf-profile.children.cycle=
s-
> pp.skb_release_data
>      15.09            +0.3       15.40        perf-profile.children.cycle=
s-
> pp.net_rx_action
>       1.20            +0.3        1.51        perf-profile.children.cycle=
s-
> pp.security_file_permission
>       1.34            +0.3        1.67        perf-profile.children.cycle=
s-pp.touch_atime
>       1.35            +0.3        1.69        perf-profile.children.cycle=
s-
> pp.copy_page_to_iter_pipe
>      15.73            +0.3       16.08        perf-profile.children.cycle=
s-pp.__do_softirq
>      17.54            +0.4       17.89        perf-profile.children.cycle=
s-
> pp.__dev_queue_xmit
>      15.84            +0.4       16.20        perf-profile.children.cycle=
s-pp.do_softirq
>      17.91            +0.4       18.27        perf-profile.children.cycle=
s-
> pp.ip_finish_output2
>      18.82            +0.4       19.20        perf-profile.children.cycle=
s-
> pp.__ip_queue_xmit
>      20.03            +0.4       20.41        perf-profile.children.cycle=
s-
> pp.__tcp_transmit_skb
>      84.38            +0.4       84.81        perf-profile.children.cycle=
s-
> pp.do_syscall_64
>      16.35            +0.5       16.81        perf-profile.children.cycle=
s-
> pp.__local_bh_enable_ip
>      84.91            +0.5       85.42        perf-profile.children.cycle=
s-
> pp.entry_SYSCALL_64_after_hwframe
>       4.52            +0.7        5.21        perf-profile.children.cycle=
s-
> pp.native_queued_spin_lock_slowpath
>       2.68            +0.9        3.62 =C2=B1  3%  perf-profile.children.=
cycles-
> pp.check_heap_object
>       5.69            +1.0        6.64        perf-profile.children.cycle=
s-
> pp.lock_sock_nested
>       6.77            +1.0        7.80        perf-profile.children.cycle=
s-
> pp._raw_spin_lock_bh
>       3.19            +1.1        4.26 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.__check_object_size
>       2.94            +1.1        4.01        perf-profile.children.cycle=
s-
> pp.filemap_get_read_batch
>       3.29            +1.1        4.38 =C2=B1  2%  perf-profile.children.=
cycles-
> pp.simple_copy_to_iter
>       3.16            +1.1        4.29        perf-profile.children.cycle=
s-
> pp.filemap_get_pages
>       6.68            +1.7        8.36        perf-profile.children.cycle=
s-pp.copyout
>       7.06            +1.8        8.85        perf-profile.children.cycle=
s-pp._copy_to_iter
>      31.77            +1.9       33.68        perf-profile.children.cycle=
s-pp.tcp_recvmsg
>      31.86            +1.9       33.78        perf-profile.children.cycle=
s-pp.inet_recvmsg
>      32.07            +1.9       34.01        perf-profile.children.cycle=
s-
> pp.sock_recvmsg
>      32.56            +2.0       34.56        perf-profile.children.cycle=
s-
> pp.__sys_recvfrom
>      32.65            +2.0       34.65        perf-profile.children.cycle=
s-
> pp.__x64_sys_recvfrom
>      33.95            +2.0       35.97        perf-profile.children.cycle=
s-pp.recv
>       6.63            +2.0        8.66        perf-profile.children.cycle=
s-pp.filemap_read
>      34.18            +2.0       36.23        perf-profile.children.cycle=
s-
> pp.accept_connections
>      34.18            +2.0       36.23        perf-profile.children.cycle=
s-
> pp.accept_connection
>      34.18            +2.0       36.23        perf-profile.children.cycle=
s-pp.spawn_child
>      34.18            +2.0       36.23        perf-profile.children.cycle=
s-
> pp.process_requests
>       7.51            +2.2        9.74        perf-profile.children.cycle=
s-
> pp.generic_file_splice_read
>      11.31            +3.2       14.48        perf-profile.children.cycle=
s-
> pp.skb_copy_datagram_iter
>      11.29            +3.2       14.46        perf-profile.children.cycle=
s-
> pp.__skb_datagram_iter
>      29.29            +3.2       32.51        perf-profile.children.cycle=
s-
> pp.tcp_recvmsg_locked
>       3.33 =C2=B1  3%      -3.0        0.32 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.mem_cgroup_charge_skmem
>       2.89            -2.6        0.29        perf-profile.self.cycles-
> pp.__sk_mem_raise_allocated
>       1.72 =C2=B1  4%      -1.5        0.18 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.try_charge_memcg
>       1.38 =C2=B1  5%      -1.3        0.05 =C2=B1  7%  perf-profile.self=
.cycles-
> pp.page_counter_try_charge
>       1.10 =C2=B1  4%      -1.1        0.04 =C2=B1 44%  perf-profile.self=
.cycles-
> pp.page_counter_uncharge
>       5.95            -0.6        5.30        perf-profile.self.cycles-pp=
.acpi_safe_halt
>       0.69 =C2=B1  4%      -0.6        0.12 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.mem_cgroup_uncharge_skmem
>       0.64 =C2=B1  2%      -0.5        0.16 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.__sk_mem_reduce_allocated
>       0.25 =C2=B1 13%      -0.2        0.08 =C2=B1  8%  perf-profile.self=
.cycles-
> pp.cgroup_rstat_updated
>       0.27 =C2=B1  2%      -0.2        0.10 =C2=B1  3%  perf-profile.self=
.cycles-pp.refill_stock
>       0.67 =C2=B1  2%      -0.1        0.55        perf-profile.self.cycl=
es-pp.tcp_ack
>       0.15 =C2=B1  3%      -0.1        0.05        perf-profile.self.cycl=
es-
> pp.__sk_mem_schedule
>       0.28 =C2=B1  6%      -0.1        0.20 =C2=B1  5%  perf-profile.self=
.cycles-
> pp.newidle_balance
>       0.22            -0.0        0.17 =C2=B1  2%  perf-profile.self.cycl=
es-
> pp.tcp_check_space
>       0.24 =C2=B1  3%      -0.0        0.20 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.enqueue_task_fair
>       0.12 =C2=B1  3%      -0.0        0.08 =C2=B1  8%  perf-profile.self=
.cycles-
> pp.update_sg_lb_stats
>       0.06            -0.0        0.02 =C2=B1 99%  perf-profile.self.cycl=
es-
> pp.update_irq_load_avg
>       0.30            -0.0        0.27 =C2=B1  2%  perf-profile.self.cycl=
es-
> pp.native_irq_return_iret
>       0.34            -0.0        0.30 =C2=B1  2%  perf-profile.self.cycl=
es-pp.__schedule
>       0.11            -0.0        0.08 =C2=B1  4%  perf-profile.self.cycl=
es-
> pp.ct_kernel_exit_state
>       0.22 =C2=B1  3%      -0.0        0.19        perf-profile.self.cycl=
es-
> pp.__switch_to_asm
>       0.41            -0.0        0.38        perf-profile.self.cycles-pp=
.native_sched_clock
>       0.19 =C2=B1  2%      -0.0        0.16 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.native_apic_msr_eoi_write
>       0.22 =C2=B1  2%      -0.0        0.19        perf-profile.self.cycl=
es-pp.menu_select
>       0.26            -0.0        0.23 =C2=B1  2%  perf-profile.self.cycl=
es-pp.__switch_to
>       0.22 =C2=B1  2%      -0.0        0.20 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.loopback_xmit
>       0.18 =C2=B1  3%      -0.0        0.16 =C2=B1  4%  perf-profile.self=
.cycles-
> pp.___perf_sw_event
>       0.11 =C2=B1  4%      -0.0        0.09 =C2=B1  7%  perf-profile.self=
.cycles-
> pp.resched_curr
>       0.13            -0.0        0.11 =C2=B1  4%  perf-profile.self.cycl=
es-pp.do_idle
>       0.08 =C2=B1  6%      -0.0        0.06        perf-profile.self.cycl=
es-
> pp.pick_next_task_fair
>       0.17 =C2=B1  2%      -0.0        0.15 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.__x2apic_send_IPI_dest
>       0.14 =C2=B1  3%      -0.0        0.13        perf-profile.self.cycl=
es-pp.__release_sock
>       0.15 =C2=B1  3%      -0.0        0.13 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.__update_load_avg_se
>       0.10 =C2=B1  3%      -0.0        0.09        perf-profile.self.cycl=
es-pp.dequeue_entity
>       0.08 =C2=B1  4%      -0.0        0.07        perf-profile.self.cycl=
es-
> pp.cpuidle_idle_call
>       0.17            -0.0        0.16 =C2=B1  2%  perf-profile.self.cycl=
es-
> pp.sock_def_readable
>       0.07            -0.0        0.06        perf-profile.self.cycles-pp=
.cpuidle_enter_state
>       0.07            -0.0        0.06        perf-profile.self.cycles-pp=
.__sock_wfree
>       0.11            -0.0        0.10        perf-profile.self.cycles-
> pp.ttwu_queue_wakelist
>       0.10            -0.0        0.09        perf-profile.self.cycles-
> pp.asm_sysvec_call_function_single
>       0.09            -0.0        0.08        perf-profile.self.cycles-
> pp.update_rq_clock_task
>       0.09            -0.0        0.08        perf-profile.self.cycles-
> pp.__wrgsbase_inactive
>       0.08            -0.0        0.07        perf-profile.self.cycles-pp=
.finish_task_switch
>       0.06            -0.0        0.05        perf-profile.self.cycles-pp=
.cpuidle_enter
>       0.14            +0.0        0.15        perf-profile.self.cycles-
> pp.enqueue_to_backlog
>       0.07            +0.0        0.08        perf-profile.self.cycles-pp=
.tcp_v4_fill_cb
>       0.05            +0.0        0.06        perf-profile.self.cycles-pp=
.iov_iter_pipe
>       0.06            +0.0        0.07        perf-profile.self.cycles-pp=
.__sk_dst_check
>       0.06            +0.0        0.07 =C2=B1  5%  perf-profile.self.cycl=
es-
> pp.demo_interval_tick
>       0.06            +0.0        0.07 =C2=B1  5%  perf-profile.self.cycl=
es-pp.rb_next
>       0.07 =C2=B1  5%      +0.0        0.08        perf-profile.self.cycl=
es-pp.tcp_rearm_rto
>       0.12 =C2=B1  3%      +0.0        0.13        perf-profile.self.cycl=
es-pp.tcp_wfree
>       0.18 =C2=B1  2%      +0.0        0.20 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.process_backlog
>       0.07 =C2=B1  5%      +0.0        0.08 =C2=B1  5%  perf-profile.self=
.cycles-
> pp.tcp_chrono_stop
>       0.05            +0.0        0.06 =C2=B1  7%  perf-profile.self.cycl=
es-
> pp.sk_filter_trim_cap
>       0.23            +0.0        0.24        perf-profile.self.cycles-
> pp.__update_load_avg_cfs_rq
>       0.06 =C2=B1  6%      +0.0        0.07 =C2=B1  5%  perf-profile.self=
.cycles-
> pp.splice_from_pipe_next
>       0.08 =C2=B1  5%      +0.0        0.10 =C2=B1  6%  perf-profile.self=
.cycles-
> pp.tcp_event_new_data_sent
>       0.11 =C2=B1  6%      +0.0        0.13 =C2=B1  5%  perf-profile.self=
.cycles-
> pp.exit_to_user_mode_prepare
>       0.15 =C2=B1  4%      +0.0        0.16 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.syscall_exit_to_user_mode_prepare
>       0.10 =C2=B1  4%      +0.0        0.12        perf-profile.self.cycl=
es-pp.tcp_push
>       0.10            +0.0        0.12 =C2=B1  4%  perf-profile.self.cycl=
es-
> pp.direct_splice_actor
>       0.10            +0.0        0.12 =C2=B1  4%  perf-profile.self.cycl=
es-pp.inet_ehashfn
>       0.19            +0.0        0.21 =C2=B1  2%  perf-profile.self.cycl=
es-pp.recv
>       0.07            +0.0        0.09 =C2=B1  5%  perf-profile.self.cycl=
es-
> pp.demo_stream_interval
>       0.14 =C2=B1  3%      +0.0        0.16 =C2=B1  4%  perf-profile.self=
.cycles-
> pp.tcp_add_backlog
>       0.15 =C2=B1  2%      +0.0        0.17 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.ip_send_check
>       0.14            +0.0        0.16 =C2=B1  5%  perf-profile.self.cycl=
es-pp.ipv4_dst_check
>       0.08            +0.0        0.10 =C2=B1  3%  perf-profile.self.cycl=
es-pp.make_vfsuid
>       0.06            +0.0        0.08 =C2=B1  4%  perf-profile.self.cycl=
es-
> pp.tcp_rtt_estimator
>       0.10 =C2=B1  4%      +0.0        0.12 =C2=B1  4%  perf-profile.self=
.cycles-
> pp.syscall_enter_from_user_mode
>       0.10 =C2=B1  4%      +0.0        0.12 =C2=B1  4%  perf-profile.self=
.cycles-
> pp.__get_task_ioprio
>       0.09 =C2=B1  4%      +0.0        0.11 =C2=B1  4%  perf-profile.self=
.cycles-
> pp.inet_recvmsg
>       0.10 =C2=B1  6%      +0.0        0.12        perf-profile.self.cycl=
es-
> pp.tcp_schedule_loss_probe
>       0.04 =C2=B1 50%      +0.0        0.06        perf-profile.self.cycl=
es-pp.rb_first
>       0.07            +0.0        0.09        perf-profile.self.cycles-pp=
.__list_add_valid
>       0.08 =C2=B1  5%      +0.0        0.10 =C2=B1  6%  perf-profile.self=
.cycles-pp.xas_start
>       0.08 =C2=B1  5%      +0.0        0.10 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.make_vfsgid
>       0.06 =C2=B1  6%      +0.0        0.08 =C2=B1  4%  perf-profile.self=
.cycles-
> pp.tcp_event_data_recv
>       0.13 =C2=B1  3%      +0.0        0.16 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.tcp_recvmsg
>       0.10 =C2=B1  4%      +0.0        0.12 =C2=B1  4%  perf-profile.self=
.cycles-
> pp.check_stack_object
>       0.08 =C2=B1  5%      +0.0        0.10        perf-profile.self.cycl=
es-
> pp.is_vmalloc_addr
>       0.09 =C2=B1  5%      +0.0        0.11 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.tcp_downgrade_zcopy_pure
>       0.10 =C2=B1  3%      +0.0        0.12 =C2=B1  4%  perf-profile.self=
.cycles-
> pp.tcp_release_cb
>       0.22 =C2=B1  2%      +0.0        0.24        perf-profile.self.cycl=
es-
> pp.do_splice_direct
>       0.10 =C2=B1  7%      +0.0        0.12 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.ip_protocol_deliver_rcu
>       0.10 =C2=B1  4%      +0.0        0.12 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.tcp_update_pacing_rate
>       0.30            +0.0        0.32 =C2=B1  2%  perf-profile.self.cycl=
es-pp.__alloc_skb
>       0.58            +0.0        0.61        perf-profile.self.cycles-
> pp._raw_spin_lock_irqsave
>       0.23 =C2=B1  2%      +0.0        0.26 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.recv_tcp_stream
>       0.13            +0.0        0.16 =C2=B1  3%  perf-profile.self.cycl=
es-
> pp._raw_spin_unlock_bh
>       0.10 =C2=B1  4%      +0.0        0.13 =C2=B1  8%  perf-profile.self=
.cycles-
> pp.inet_send_prepare
>       0.20            +0.0        0.23 =C2=B1  3%  perf-profile.self.cycl=
es-pp.ip_rcv_core
>       0.13 =C2=B1  3%      +0.0        0.15 =C2=B1  6%  perf-profile.self=
.cycles-
> pp.tcp_mtu_probe
>       0.13 =C2=B1  3%      +0.0        0.16 =C2=B1  2%  perf-profile.self=
.cycles-pp.xas_load
>       0.06 =C2=B1  7%      +0.0        0.09 =C2=B1  5%  perf-profile.self=
.cycles-
> pp.__tcp_cleanup_rbuf
>       0.13 =C2=B1  3%      +0.0        0.16 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.validate_xmit_skb
>       0.12            +0.0        0.15 =C2=B1  3%  perf-profile.self.cycl=
es-
> pp.folio_mark_accessed
>       0.16            +0.0        0.19 =C2=B1  3%  perf-profile.self.cycl=
es-
> pp.__tcp_select_window
>       0.27            +0.0        0.30        perf-profile.self.cycles-pp=
.__sys_recvfrom
>       0.15 =C2=B1  2%      +0.0        0.18 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.tcp_tx_timestamp
>       0.15 =C2=B1  2%      +0.0        0.18 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.do_splice_to
>       0.31            +0.0        0.34        perf-profile.self.cycles-pp=
.__skb_clone
>       0.12            +0.0        0.15 =C2=B1  3%  perf-profile.self.cycl=
es-
> pp.simple_copy_to_iter
>       0.14 =C2=B1  3%      +0.0        0.18 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.rw_verify_area
>       0.18            +0.0        0.22 =C2=B1  2%  perf-profile.self.cycl=
es-pp.sock_sendpage
>       0.12 =C2=B1  3%      +0.0        0.16        perf-profile.self.cycl=
es-
> pp.syscall_exit_to_user_mode
>       0.24            +0.0        0.28 =C2=B1  2%  perf-profile.self.cycl=
es-pp.__mod_timer
>       0.09 =C2=B1  5%      +0.0        0.12 =C2=B1  6%  perf-profile.self=
.cycles-
> pp.__tcp_send_ack
>       0.16            +0.0        0.20        perf-profile.self.cycles-pp=
.fsnotify_perm
>       0.11            +0.0        0.15 =C2=B1  7%  perf-profile.self.cycl=
es-
> pp.ktime_get_coarse_real_ts64
>       0.17 =C2=B1  2%      +0.0        0.21        perf-profile.self.cycl=
es-pp.skb_clone
>       0.20 =C2=B1  2%      +0.0        0.24 =C2=B1  5%  perf-profile.self=
.cycles-
> pp.__entry_text_start
>       0.39 =C2=B1  2%      +0.0        0.44        perf-profile.self.cycl=
es-
> pp.__ip_queue_xmit
>       0.17 =C2=B1  2%      +0.0        0.22 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.generic_file_splice_read
>       0.18 =C2=B1  3%      +0.0        0.23 =C2=B1  6%  perf-profile.self=
.cycles-
> pp.lock_sock_nested
>       0.47 =C2=B1  2%      +0.0        0.52 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.tcp_recvmsg_locked
>       0.22 =C2=B1  2%      +0.0        0.27        perf-profile.self.cycl=
es-
> pp.filemap_get_pages
>       0.00            +0.1        0.05        perf-profile.self.cycles-pp=
.tcp_options_write
>       0.00            +0.1        0.05        perf-profile.self.cycles-pp=
.tcp_rbtree_insert
>       0.00            +0.1        0.05        perf-profile.self.cycles-
> pp.skb_network_protocol
>       0.20            +0.1        0.25        perf-profile.self.cycles-pp=
.rcu_all_qs
>       0.00            +0.1        0.05 =C2=B1  7%  perf-profile.self.cycl=
es-
> pp.__tcp_ack_snd_check
>       0.43            +0.1        0.48        perf-profile.self.cycles-pp=
._raw_spin_lock
>       0.25            +0.1        0.30 =C2=B1  2%  perf-profile.self.cycl=
es-pp.touch_atime
>       0.46            +0.1        0.52 =C2=B1  2%  perf-profile.self.cycl=
es-pp.net_rx_action
>       0.16 =C2=B1  2%      +0.1        0.22 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.tcp_stream_alloc_skb
>       0.23 =C2=B1  2%      +0.1        0.28        perf-profile.self.cycl=
es-
> pp.copy_page_to_iter
>       0.33 =C2=B1  2%      +0.1        0.39        perf-profile.self.cycl=
es-
> pp.splice_direct_to_actor
>       0.31            +0.1        0.37 =C2=B1  2%  perf-profile.self.cycl=
es-pp.dst_release
>       0.21            +0.1        0.27        perf-profile.self.cycles-pp=
.sanity
>       0.26            +0.1        0.32        perf-profile.self.cycles-
> pp.security_file_permission
>       0.25 =C2=B1  2%      +0.1        0.31        perf-profile.self.cycl=
es-pp.aa_file_perm
>       1.04            +0.1        1.11 =C2=B1  3%  perf-profile.self.cycl=
es-pp.do_sendfile
>       0.43 =C2=B1  2%      +0.1        0.50        perf-profile.self.cycl=
es-
> pp.kmem_cache_alloc_node
>       0.40            +0.1        0.47        perf-profile.self.cycles-pp=
.do_syscall_64
>       0.30 =C2=B1  2%      +0.1        0.37 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.syscall_return_via_sysret
>       0.31 =C2=B1  4%      +0.1        0.38 =C2=B1  2%  perf-profile.self=
.cycles-pp.sock_put
>       0.49            +0.1        0.56        perf-profile.self.cycles-pp=
.kmem_cache_free
>       0.22            +0.1        0.29        perf-profile.self.cycles-pp=
.tcp_tso_segs
>       0.64            +0.1        0.71        perf-profile.self.cycles-pp=
.tcp_v4_rcv
>       0.34 =C2=B1  2%      +0.1        0.41        perf-profile.self.cycl=
es-
> pp.generic_splice_sendpage
>       0.32 =C2=B1  2%      +0.1        0.39        perf-profile.self.cycl=
es-
> pp.kernel_sendpage
>       0.33            +0.1        0.40        perf-profile.self.cycles-pp=
.__put_user_8
>       0.57            +0.1        0.64        perf-profile.self.cycles-
> pp.tcp_clean_rtx_queue
>       0.34            +0.1        0.42        perf-profile.self.cycles-pp=
.inet_sendpage
>       0.67            +0.1        0.74        perf-profile.self.cycles-pp=
.read_tsc
>       0.34            +0.1        0.42        perf-profile.self.cycles-
> pp.tcp_established_options
>       0.33            +0.1        0.41        perf-profile.self.cycles-pp=
.pipe_to_sendpage
>       0.31            +0.1        0.38        perf-profile.self.cycles-pp=
.tcp_send_mss
>       0.32 =C2=B1  3%      +0.1        0.40        perf-profile.self.cycl=
es-pp.current_time
>       0.33 =C2=B1  2%      +0.1        0.42 =C2=B1 12%  perf-profile.self=
.cycles-pp.ktime_get
>       0.36 =C2=B1  2%      +0.1        0.45 =C2=B1  2%  perf-profile.self=
.cycles-
> pp.release_sock
>       0.38            +0.1        0.46 =C2=B1  2%  perf-profile.self.cycl=
es-
> pp.__virt_addr_valid
>       0.55            +0.1        0.64        perf-profile.self.cycles-
> pp.entry_SYSCALL_64_after_hwframe
>       0.71            +0.1        0.80        perf-profile.self.cycles-pp=
.__dev_queue_xmit
>       0.41            +0.1        0.50        perf-profile.self.cycles-
> pp.entry_SYSRETQ_unsafe_stack
>       0.45            +0.1        0.54        perf-profile.self.cycles-
> pp.__local_bh_enable_ip
>       0.64            +0.1        0.74        perf-profile.self.cycles-
> pp.tcp_rcv_established
>       0.41            +0.1        0.50        perf-profile.self.cycles-
> pp.__check_object_size
>       0.46            +0.1        0.56        perf-profile.self.cycles-pp=
.netperf_sendfile
>       0.47            +0.1        0.57        perf-profile.self.cycles-pp=
.__cond_resched
>       0.39            +0.1        0.49        perf-profile.self.cycles-pp=
._copy_to_iter
>       0.51            +0.1        0.62 =C2=B1  2%  perf-profile.self.cycl=
es-
> pp.sendfile_tcp_stream
>       0.42            +0.1        0.53        perf-profile.self.cycles-pp=
.sendfile
>       0.48 =C2=B1  2%      +0.1        0.58        perf-profile.self.cycl=
es-
> pp.atime_needs_update
>       0.46            +0.1        0.57        perf-profile.self.cycles-pp=
.tcp_current_mss
>       0.49 =C2=B1  2%      +0.1        0.60        perf-profile.self.cycl=
es-pp.tcp_sendpage
>       0.95            +0.1        1.06 =C2=B1  2%  perf-profile.self.cycl=
es-
> pp.__tcp_transmit_skb
>       0.35            +0.1        0.48        perf-profile.self.cycles-
> pp.tcp_rate_check_app_limited
>       0.47            +0.1        0.60        perf-profile.self.cycles-pp=
.__fsnotify_parent
>       0.60            +0.1        0.74        perf-profile.self.cycles-pp=
.__fget_light
>       0.36            +0.1        0.49        perf-profile.self.cycles-
> pp.page_cache_pipe_buf_confirm
>       0.77            +0.1        0.90 =C2=B1  2%  perf-profile.self.cycl=
es-
> pp.page_cache_pipe_buf_release
>       0.53            +0.1        0.66        perf-profile.self.cycles-pp=
._copy_from_user
>       0.71            +0.2        0.86        perf-profile.self.cycles-
> pp.__splice_from_pipe
>       0.65 =C2=B1  2%      +0.2        0.83        perf-profile.self.cycl=
es-
> pp.apparmor_file_permission
>       0.81            +0.2        1.00        perf-profile.self.cycles-pp=
.tcp_write_xmit
>       0.77            +0.2        0.97        perf-profile.self.cycles-pp=
.do_tcp_sendpages
>       0.81            +0.2        1.05        perf-profile.self.cycles-
> pp.__skb_datagram_iter
>       1.00            +0.2        1.25        perf-profile.self.cycles-pp=
.skb_release_data
>       1.11            +0.3        1.38        perf-profile.self.cycles-
> pp.copy_page_to_iter_pipe
>       2.20            +0.3        2.52        perf-profile.self.cycles-pp=
._raw_spin_lock_bh
>       1.34            +0.4        1.69        perf-profile.self.cycles-pp=
.filemap_read
>       2.01            +0.4        2.40        perf-profile.self.cycles-pp=
.tcp_build_frag
>       4.49            +0.7        5.18        perf-profile.self.cycles-
> pp.native_queued_spin_lock_slowpath
>       2.17 =C2=B1  2%      +0.8        2.99 =C2=B1  3%  perf-profile.self=
.cycles-
> pp.check_heap_object
>       2.71            +1.0        3.73        perf-profile.self.cycles-
> pp.filemap_get_read_batch
>       6.63            +1.7        8.29        perf-profile.self.cycles-pp=
.copyout
>=20
>=20
>=20
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are
> provided
> for informational purposes only. Any difference in system hardware or
> software
> design or configuration may affect actual performance.
>=20
>=20
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>=20
>=20
> >
> >
> > From 93b3b4c5f356a5090551519522cfd5740ae7e774 Mon Sep 17 00:00:00
> 2001
> > From: Shakeel Butt <shakeelb@google.com>
> > Date: Tue, 16 May 2023 20:30:26 +0000
> > Subject: [PATCH] memcg: skip stock refill in irq context
> >
> > The linux kernel processes incoming packets in softirq on a given CPU
> > and those packets may belong to different jobs. This is very normal on
> > large systems running multiple workloads. With memcg enabled, network
> > memory for such packets is charged to the corresponding memcgs of the
> > jobs.
> >
> > Memcg charging can be a costly operation and the memcg code
> implements
> > a per-cpu memcg charge caching optimization to reduce the cost of
> > charging. More specifically, the kernel charges the given memcg for mor=
e
> > memory than requested and keep the remaining charge in a local per-cpu
> > cache. The insight behind this heuristic is that there will be more
> > charge requests for that memcg in near future. This optimization works
> > well when a specific job runs on a CPU for long time and majority of th=
e
> > charging requests happen in process context. However the kernel's
> > incoming packet processing does not work well with this optimization.
> >
> > Recently Cathy Zhang has shown [1] that memcg charge flushing within th=
e
> > memcg charge path can become a performance bottleneck for the memcg
> > charging of network traffic.
> >
> > Perf profile:
> >
> > 8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_canc=
el
> >     |
> >      --8.97%--page_counter_cancel
> > 	       |
> > 		--8.97%--page_counter_uncharge
> > 			  drain_stock
> > 			  __refill_stock
> > 			  refill_stock
> > 			  |
> > 			   --8.91%--try_charge_memcg
> > 				     mem_cgroup_charge_skmem
> > 				     |
> > 				      --8.91%--__sk_mem_raise_allocated
> > 						__sk_mem_schedule
> > 						|
> > 						|--5.41%--
> tcp_try_rmem_schedule
> > 						|          tcp_data_queue
> > 						|          tcp_rcv_established
> > 						|          tcp_v4_do_rcv
> > 						|          tcp_v4_rcv
> >
> > The simplest way to solve this issue is to not refill the memcg charge
> > stock in the irq context. Since networking is the main source of memcg
> > charging in the irq context, other users will not be impacted. In
> > addition, this will preseve the memcg charge cache of the application
> > running on that CPU.
> >
> > There are also potential side effects. What if all the packets belong t=
o
> > the same application and memcg? More specifically, users can use Receiv=
e
> > Flow Steering (RFS) to make sure the kernel process the packets of the
> > application on the CPU where the application is running. This change ma=
y
> > cause the kernel to do slowpath memcg charging more often in irq
> > context.
> >
> > Link:
> https://lore.kernel.org/all/IA0PR11MB73557DEAB912737FD61D2873FC749@
> IA0PR11MB7355.namprd11.prod.outlook.com [1]
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > ---
> >  mm/memcontrol.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 5abffe6f8389..2635aae82b3e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2652,6 +2652,14 @@ static int try_charge_memcg(struct
> mem_cgroup *memcg, gfp_t gfp_mask,
> >  	bool raised_max_event =3D false;
> >  	unsigned long pflags;
> >
> > +	/*
> > +	 * Skip the refill in irq context as it may flush the charge cache of
> > +	 * the process running on the CPUs or the kernel may have to process
> > +	 * incoming packets for different memcgs.
> > +	 */
> > +	if (!in_task())
> > +		batch =3D nr_pages;
> > +
> >  retry:
> >  	if (consume_stock(memcg, nr_pages))
> >  		return 0;
> > --
> > 2.40.1.606.ga4b1b128d6-goog
> >

