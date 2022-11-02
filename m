Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB234616500
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 15:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiKBOWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 10:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiKBOVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 10:21:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF041F9D3;
        Wed,  2 Nov 2022 07:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667398911; x=1698934911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=retV7GdxqEb0pUxQrkzguKcTO5briOZRQGZ+OOkTEXM=;
  b=QxLmjb77DeQmg39n28GyPj534PR72/X34LfgOVXrF9QKEhhZ+i+pSgCj
   U+oncv9DO4VctN9kdsICbp6zuDJ5bim76t0yCdP0VWLazA3BvdAQQ/SST
   WLIx364R9k8i45LHzqcaXZ8fqawnvp09ba5AfUc9OJ6ytnrb/DPHEurE5
   CHhNMYwkNzDk3ZqLxFPmdXIYd224zCIgw4XnCPdAVhlOZkepSqmb3qT8y
   jO32qpC7Tsj8t7xQD04SsqUNgzyYrUaREB9GOVi5PJdgxT7cPj+J8C1/A
   VCezASjDFNAju5oL+cJDusAeD6EShM8f3i+I3oqcrIYaE8GWMrOvJWwr3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="308136976"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="308136976"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 07:12:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="703279820"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="703279820"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 02 Nov 2022 07:12:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 07:12:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 2 Nov 2022 07:12:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 2 Nov 2022 07:12:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTWK4Jj4JVW/JAMWPqCX1BEf39Qq/F1GiNXYNXk1b0G1uHs7U+hDPEErTfSaUYhUqFZq3xTSQ75gKXGBgylmTTJ6rZLmw5hs1P0orzD7aBlYLKqjhldVVFnddcmqFBzlEAUA2cQRVEQ5HrtGY0LDZqTn/ChquhiXkGQbDZhQN+a9HFiIk2pCQTEox5odKpX0AqLnZH6VI0kSEZh0jNNmu1VCJZZhDpoTggeArV9hag5+ytYOFHu7WXC3Z6AYqPTQyLoKIl25pAIqoAEq6MLgLuqg1Tlp6+QGJdHdnxMPtK35zz137lw2UZXvSiN0DrslSj4/L6/FxegvY+WCqORbdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mib06KMeC8JMgIImcc338NJT7S4nFrlXi4Dl03XcuWg=;
 b=iNLuRgQ+33GgzaCmSuUn1qcb9+pEtvJMap9cuEEiHT/HbSAAq4RQu3qb231qLt5VyvWSkHsymvMzzv1hBxINPE142gh7uBpBk84k3begov+KuNNs1j8RSptMtuxwU+9J6YTYDEPemEs2E1E/ARfqAh2e2EEbASNUZdYVwmdMbiL/s5TIUUWJ/ZhPrBfYQVzfqOOgSLkP2mwSdoEF/awn4Lw+H8ub2pkFZOaMnSfA+9ak7Oxx/d9LMw3Lupxk+ufa7PZ4ktpdjv1ybeQV7SmGt0UmYrOUzkjudyndgdVNAmFzE/RsJXTkBDTclsLvsvMuUvApayCsuJs4sCOaDA8IrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR11MB1324.namprd11.prod.outlook.com (2603:10b6:3:15::14) by
 BL1PR11MB5237.namprd11.prod.outlook.com (2603:10b6:208:310::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Wed, 2 Nov
 2022 14:12:34 +0000
Received: from DM5PR11MB1324.namprd11.prod.outlook.com
 ([fe80::793f:3870:4550:8aee]) by DM5PR11MB1324.namprd11.prod.outlook.com
 ([fe80::793f:3870:4550:8aee%8]) with mapi id 15.20.5791.022; Wed, 2 Nov 2022
 14:12:33 +0000
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] igb: Proactively round up to kmalloc bucket size
Thread-Topic: [PATCH v3 2/2] igb: Proactively round up to kmalloc bucket size
Thread-Index: AQHY60UEuvCQ5/6nqkOEi2jDwjCFAa4o+uNAgAGizYCAARDSsA==
Date:   Wed, 2 Nov 2022 14:12:33 +0000
Message-ID: <DM5PR11MB1324EC38950CD47541E69EE1C1399@DM5PR11MB1324.namprd11.prod.outlook.com>
References: <20221018092340.never.556-kees@kernel.org>
 <20221018092526.4035344-2-keescook@chromium.org>
 <202210282013.82F28AE92@keescook>
 <DM5PR11MB1324802F3F2098CB3239CF36C1379@DM5PR11MB1324.namprd11.prod.outlook.com>
 <202211011433.A64BF17F46@keescook>
In-Reply-To: <202211011433.A64BF17F46@keescook>
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
x-ms-traffictypediagnostic: DM5PR11MB1324:EE_|BL1PR11MB5237:EE_
x-ms-office365-filtering-correlation-id: 82403c92-d89a-40b0-e08d-08dabcdc4988
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MMTZNsJOnyR3BwG/4ugpQqbbuz5Rc+4RMcOgOTGvTD/ZudBbwX8UbTQYDbYqk02/96Z8bPf0yhYeaMT0F43IWSHZgtdtZKjdn+1Qdj22aUEBcrm+t71IXuPwrQhnHXL0JIfgs5oB5V7ml63c/p7IuT96T05wyax471zYOUy8953YE6C9UlOusmZj9Skx4VlBcmpTPoGe+GCOiQqrR5SFBdgvIblXDEdosNDJPSBCqX6S0hzEE5uCn0OojH1dQfALWhjl1Z1WEy4KQQfgADYomeRRf1EP2K+EPK9y/QoBMSkAE3SB7dz5rGY3uLNnZjwz1foa/iL+5iptyZlJ+KVAnkHq2lQ/YilLMzMzxkD5A5MOxLLkOxNSgLrMirfxowsfxFCVLqPjNnSb0Mg26Emf7ic6PDWBxWlCS4ypzYH0FP8Iu2wSORJ7OJX2MNPUtPQynFOV1FnTctZIu3WRNhccUW7qlWnXIMuz0wt4CDggsc7ql9fC1C2p3Gjjh79DvDiq/zKtExtSGxBLznvoVCJWRA3bkOL+sc8nDu7UMdcYERkMACNj0Umi8+VV4mWiMZQnIS1uQTc1/4pwK3Ej5Ud6EKIXBDy5HIPQ409dvB/+wJ7Xx96xhgBYMAkt4qFgtUW0mLSQdIeznmWGIB8xf8fFtbYMIV1bCUyGXiORiqR/xvbFQOQutp4yby55nG2iscHtMSwXO1Jx6Tj3hSyj0XQNsSnXjofoTnwOlH7lJg8qrYgvGS7fxlrL2zfQuS8YsN8atggM9LaGFna/IoE23IUHJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1324.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(122000001)(83380400001)(2906002)(71200400001)(478600001)(82960400001)(38100700002)(9686003)(66946007)(38070700005)(64756008)(66556008)(76116006)(66476007)(4326008)(8676002)(66446008)(7696005)(41300700001)(55016003)(186003)(86362001)(6506007)(6916009)(33656002)(5660300002)(52536014)(316002)(54906003)(26005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5DRUZsBrwLWpq0POZNu7gUJ/VDIWkmj4U2UT63069JcpRn6Pd08H2QyvtkqL?=
 =?us-ascii?Q?qlWqT3VAzhpWZ2mlIokIuC+qiO2enEqq94uhOCcxmhQjcJpVFmNt8KA1A4Ld?=
 =?us-ascii?Q?jvht6UNYGSqzGH1/7QO+eEgDb0gi/73+SU5GO0PIErnrWHdx/mUv02ouPmmh?=
 =?us-ascii?Q?RxDx5TP4WRu6OH7K5417t2XUGQZcHRprvGZErcxleRd7o5yRwDpZoF26wanS?=
 =?us-ascii?Q?ZjGT3lYkl9jr6RSSmHWfhHEiPtZveFYOeQF29fsKqTrAQPjcJKcS10F931oK?=
 =?us-ascii?Q?Qb1/lhvlSvlBLIod1wgMnU048m+jjzWq49zhF59rf+Y6ttbicoPH7b8JBqLz?=
 =?us-ascii?Q?h9uNxG+ihiYVp8zolayzlfsIndREXngs7fzas9m51Z9MvnP8DrlmuSeCEdtC?=
 =?us-ascii?Q?F2sOHfYY7jiE/nMi/pLQBu6/iM0l4XuLoil9oBDbaG2h34AGkXnP3TBCtS2c?=
 =?us-ascii?Q?AyilW0+fEeK0nmiALEy94Q0wkaQKn2zAggON5tOA0aK9YIVIe+/usOFzCQfB?=
 =?us-ascii?Q?YbNeuNNd84W23ACCqMc7gPXauAzhVsij2k2UQCLHkejeBn2RwaczNzt0ddR6?=
 =?us-ascii?Q?tJO351g0G4JSAcaBAyvLQUNQCZz+Bpog/WKQfBjiFdiZnXwopNl4ZctSDJd7?=
 =?us-ascii?Q?kZTDuq/DkSH5PNKklaJvmw3aeJhUlnowLmBpqkJ39U3C7q5zzFfddZ8uRTfD?=
 =?us-ascii?Q?ctA5CwGQVnljaoeaT5HwjL7nNnAJ5StMdw7h9Gq2JtAqwjsr/XqgTXUa1pEc?=
 =?us-ascii?Q?jUv2m7AmsGbQWtLXlt4pMdgNbcyQb0GtGtNNPHiaB9yx+mowlq+SS8QzWQKo?=
 =?us-ascii?Q?eBWoGJi5hCnuGjHUYX12gv7kdz4RQWqlxYbGI8rfHtFQUaNk+0JUv987TJZl?=
 =?us-ascii?Q?8ixn042MgXW8pkuDcLbGHHCZ2indEHmEV6xZamsZgI8Q3+siO6atyCVVCwJd?=
 =?us-ascii?Q?u0hj2qMJEpBJx77OBDquRe3JQBf0LgC2xksnTpSf7Il/t2y2TLtT02m9QlOB?=
 =?us-ascii?Q?ncqJN06on1NjMyPQMzWXuL0QakeTTheOnZ1qVSGVKk0KgZqmNS5oBpUu0C70?=
 =?us-ascii?Q?3PclfbO8Q9bixZTCRQEkOrI7u01CmqIH0wHpwmTOXqrAHmZegRcNf7G0V7yJ?=
 =?us-ascii?Q?UsYN6I7zOdjNSOLp94J7nQyct6vDuEbuSkFWpiPg7NsPfmklnRGRyeQVKDwm?=
 =?us-ascii?Q?Uq9JkbmvB+AVDPK/exmVKCGpE69QpqT2qG8fJYFpkmT9IAaJ6NhuRAf3lg0b?=
 =?us-ascii?Q?O5f92lW3aUsomftEGj/Lr94aApH3f1dsb5RYxOigjgAMilFvj6UMARyT6qdY?=
 =?us-ascii?Q?ZAHH4xNNHhmJPI0KnFzgQut1XJ6BDoM/f3KXlSjGFor7ti/Znz/dW+qN6zzv?=
 =?us-ascii?Q?rHActq8IwOC9zUvZRlAHP0s2NrRvFCJgujzkrTb8JjC6OTkHWIqUcM73+YZg?=
 =?us-ascii?Q?Ni66Qhf4OZ4AqDSI3C40M3Pp4OxJUEQ0odCZ5grRenWuvqrPEk6/Jrep19x0?=
 =?us-ascii?Q?wKQP4C8hji5TJUsWZMeoBArszbXg/yQxi+hp6UZ9Nga6X0G8cVLlkVZLr83p?=
 =?us-ascii?Q?R4W2T8dbxLtOoxBqfSBiZfCrJNfWDRcipsewv3jp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1324.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82403c92-d89a-40b0-e08d-08dabcdc4988
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 14:12:33.8255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yLsdh5FPRDaD1PP32O+y9N+e7COoiyA1nPBDVyzqmZaF+AnEXHM2YcmThZN4iLgM/Qb27+nqZM2UnCHohn6NrIXMqIrXw8rDx8vOzU5pEfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5237
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Kees Cook <keescook@chromium.org>
>Sent: Tuesday, November 1, 2022 5:37 PM
>To: Ruhl, Michael J <michael.j.ruhl@intel.com>
>Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
>Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
>Paolo Abeni <pabeni@redhat.com>; intel-wired-lan@lists.osuosl.org;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>hardening@vger.kernel.org
>Subject: Re: [PATCH v3 2/2] igb: Proactively round up to kmalloc bucket si=
ze
>
>On Mon, Oct 31, 2022 at 08:42:36PM +0000, Ruhl, Michael J wrote:
>> Looking at the size usage (from elixir), I see:
>>
>> --
>> 	if (!q_vector) {
>> 		q_vector =3D kzalloc(size, GFP_KERNEL);
>> 	} else if (size > ksize(q_vector)) {
>> 		kfree_rcu(q_vector, rcu);
>> 		q_vector =3D kzalloc(size, GFP_KERNEL);
>> 	} else {
>> 		memset(q_vector, 0, size);
>> 	}
>> --
>>
>> If the size is rounded up, will the (size > ksize()) check ever be true?
>>
>> I.e. have you eliminated this check (and maybe getting rid of the need f=
or
>first patch?)?
>
>Hi!
>
>It looked like igb_alloc_q_vector() was designed to be called multiple
>times on the same q_vector (i.e. to grow its allocation size over time).
>So for that case, yes, the "size > ksize(q_vector)" check is needed. If
>it's only ever called once (which is hard for me to tell), then no. (And
>if "no", why was the alloc/free case even there in the first place?)

Ahh, Ok, I missed the fact that size is based on ring_count.  When I saw
the "struct_size" I assumed that size would be the same every time and
missed this point.

So can vary over time, and this ksize check is needed.

With that in mind these patches look good to me.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>

Mike

>-Kees
>
>--
>Kees Cook
