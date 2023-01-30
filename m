Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC56681F98
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 00:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjA3XZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 18:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjA3XZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 18:25:01 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A33A1B54D
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 15:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675121087; x=1706657087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=26ijwO8tJh2xVvD1XS6LD9tn6JOwD9FZqkcR1kP5hv0=;
  b=Xwg1/EBO1kEjCuYKl+HRHrKP85+EZ6n5obx0bIozi+CTjsNp4oESXU1k
   L12Vd5xq/GtlF60D0oj7zORrBk0wbzYxqOLeo2pGTxyPxbi6K+IH9rTlV
   6MTM5Ffn9lmTrdPx8bpELM5lzhTeiyLeTFPN0Ncz8GK17Z36McguO4PaC
   OXwScC2FXmHzLsLY1+KCF5SVj/ragSOEdVyvZqdeOGeiKdFOV2gOEgMtY
   VrDk88GSKoS6QTIY+GoLWPa696qv8G/1bL5FOtR0gJl+uUmUyFa38+TGf
   MBu+nYr8l79GSOu60e8Dxlox6o9HvX7ZcyO/zo0+rZOI6/lP2gv+cD10Y
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="355023541"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="355023541"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 15:24:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="806874973"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="806874973"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jan 2023 15:24:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 15:24:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 15:24:46 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 15:24:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T41Hs3ukg2F29Zrx48mQtwZ4WLTMxVuTjFlYDiCBi5/oMW3af4iRQR6yIe5kLff4BVGf7vKF6eCR2pcSqHSzv5v9tS2cXETdvrpwFpCMDqbc7Esq/LNqjGGE/ugmuSdEXusx4I3AQe75cfMXRAkYHkKFwKGFPjtGbzPy3ijqMRd5VqtZYu9625p7l3Ny7NoH/1S18mAE9wcu8e5Tb56EupPbqZf9CoioBbzvaGlmghk2dnyV23+iO7wg046Pc+wuKjjuUbeH6lPxMFxJFg5PzkaPjaGtzfuECM8Ul2MZLjXGXvbQxB4CNpeIsjxvr/+9v+BSAZ44S7V+rDpE4Rby+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26ijwO8tJh2xVvD1XS6LD9tn6JOwD9FZqkcR1kP5hv0=;
 b=e4a6KgdzIj9bOye/IK9EgNBjjsDdHueEqXg3/ytrJqvkJEd0cDh0ZoWrVXYKNEPYTuE3uI0ondYJxn5UusLZLXt6p03zlZIUZpedi5Co8KpNFg64xHVoe2DTtgAvUeoLqqsVUXvNRNXiPmsO+pjGfWxU0/FDs+W64M6mVUwvq2LauxJHMPL1ZvnR5Xl3/BRsnqVMJWlAhjgRMa9d+gqRD6u2Oi+opRLfpOFxn26pdbCvzipEYjVMUrdE+Q+0TUKpQQ2kwwrS8sTFli7gjtz/iGWU545NDJmEUti4uEYSNttT0mF/PzGZqnluX6xY237ewFOQTSMExfqMkK9JYUeGbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4993.namprd11.prod.outlook.com (2603:10b6:303:6c::23)
 by DM4PR11MB5995.namprd11.prod.outlook.com (2603:10b6:8:5e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 23:24:34 +0000
Received: from CO1PR11MB4993.namprd11.prod.outlook.com
 ([fe80::be4b:926b:fa65:b5dc]) by CO1PR11MB4993.namprd11.prod.outlook.com
 ([fe80::be4b:926b:fa65:b5dc%6]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 23:24:34 +0000
From:   "Singhai, Anjali" <anjali.singhai@intel.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "tom@sipanda.io" <tom@sipanda.io>,
        "pratyush@sipanda.io" <pratyush@sipanda.io>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "stefanc@marvell.com" <stefanc@marvell.com>,
        "seong.kim@amd.com" <seong.kim@amd.com>,
        "mattyk@nvidia.com" <mattyk@nvidia.com>,
        "Daly, Dan" <dan.daly@intel.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
Subject: RE: [PATCH net-next RFC 00/20] Introducing P4TC
Thread-Topic: [PATCH net-next RFC 00/20] Introducing P4TC
Thread-Index: AQHZMBXdBcJIqoJZykarKF/C1TEweK6xXCUAgAE9coCAABtggIAAJ8uAgAAQ6oCAABZ4AIAA1vUAgAAZ6QCAAAZtAIAA7JKAgABcwoCAASIsgIAAX80AgAAUnwCAACyqAIAAMa4AgAAgzwCAABY0AIAADcQAgAAC1QCAABn0AIAABu3g
Date:   Mon, 30 Jan 2023 23:24:34 +0000
Message-ID: <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
In-Reply-To: <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4993:EE_|DM4PR11MB5995:EE_
x-ms-office365-filtering-correlation-id: d7ce9f0a-efc0-4486-e35d-08db031925e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RU3dgX+LvvyHy+bZ14HW1zTWYjvoNbz3CDdwPU6Ci1GJoBTSv1U+gf9yAAbCXO5yautz+yw8XZTUBZ9FCso9VAmMk43flyqPJPXH6Hx9PnrEYngk7YBMS6iq3a7jj7G+oEuaXdmJjn7lGGGf0eMFBXCun6o6OW5yLxLMHImqjeqU5G6/62UX8Q8sXmo/ICQYI+D0XomJw88GCNcMnF8zV58DMzPM6jbk+2aTIwpspSDkyQHGiUs2HXpGwG9wo2qsnzPjzDVEUK7A6Z5kYBhqe4yhIiZSihmrBHlYVFH1xofiUPZrO48SvEXF0BsWkTQtgy7F1dNL9zZtIWprWkwC9FRbjX2JeK6cSzpxRUxZG4fjZDN/for/C8eZU2QYC9mjPIwnf6hlkJ5CQK09tjsTcqTeUuZ7SmiR63PC+AJ5YjYe6iYAxKQDEEePc7D1C9LMViIb5vHWCA15EV84/fr3qMYOMqdpHoX1+BO53LqtRRLmfPTvcnGGcOCuPp3Ga76oDKuU6v7ey/Y3COw2rvNpwNR9IU5InWfWoP6Mxd2r8deGFZLwNZVi542yBXk/jCIhpzvg1w/Q+auBHU+zfgWwOmrD0FVcfEBL0dD2bRB8VwDgp730Hj150dGPuyVvpSpyQRQjeQiabQZK2L/B7xBcBQ215QhZ6M6m2Gqzo84pPufrEWK8UTFi2JAetQdndWrSDxkxZ++QtLvOfdyWcdj1fJAD2pWfjX7wQkack50seAz9h9yQ8z4cco6NNmtYHrDj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4993.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199018)(82960400001)(26005)(5660300002)(186003)(122000001)(38100700002)(9686003)(7416002)(2906002)(53546011)(966005)(71200400001)(38070700005)(478600001)(7696005)(6506007)(66899018)(52536014)(66946007)(76116006)(86362001)(4326008)(83380400001)(8676002)(66574015)(54906003)(66446008)(64756008)(107886003)(66556008)(316002)(66476007)(110136005)(41300700001)(33656002)(55016003)(8936002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWxTZjBzaEpHYlYvZGVjVmlTUUdNUTFFRTVuQTB6TnIvVUw0dHJhR2tJRi9N?=
 =?utf-8?B?cW1KcytOOTZ4NDBXYytNb3dzOUs0RlZsYlRTSE02SG9oUGM1OTBBbkViaE9a?=
 =?utf-8?B?UnRKbTBVUVBsY1dZWE5QSUhMUGxGTTdiUm81OTRzc2hRRHJ1ZVN6RWRhL1FH?=
 =?utf-8?B?Q0d1eXVvQ1QrdHA4NmFCYlNsYm9DSGJXQkt6SXVWcHByV3RIZ3ZtOWRTWVVs?=
 =?utf-8?B?NXNlOUFGSExLdE83eFdPSnRDUTBMM3F5NGhrTnp1QlNsOUFabVhldTc4a0JZ?=
 =?utf-8?B?cmgyenF1VGNLS0ZtOW1rYVhzdnY5dkZQWnFabVJnU3MxUWJqMDd4QTkxNjhE?=
 =?utf-8?B?bHZZMENMM1A5QW9SM2VCN1lCMGlZNkVlWWg4b293L04rT1NMSFZKYS9Tdmlv?=
 =?utf-8?B?d2FuME1tVEJrbms2QkJwSW1ESHpXcVhHRk14eG43S0V3TjNlRTJzbFVJMWFn?=
 =?utf-8?B?MkRhdkhWZmtnRWFCdFozQUZBR0Izd2VtdjVyUHNUTFRhUHJsRnhSc2xFZ0E0?=
 =?utf-8?B?VEVYVjdRTkpFb0R1UEJpMlBzNWx0TDJJdTRCTkx6YWtscGc2b0VDNzlFaHo2?=
 =?utf-8?B?TUFnV1lzNENLUUkrYzV1TUFhS2tvM2ovRGlWbWx1SEw5S0pBQTZ3SXAzTDBY?=
 =?utf-8?B?Vkt5VmN3bU1WZ0lNSDI1TUdETFhldVRMYlFRMzlFY1lrbWUvZ00zeWxHNC9z?=
 =?utf-8?B?em54SDZIZUhXalNYMUlZSVY1ZmxneklvUFFLMVJzS1VoOWRjZHpadjlIQ0dU?=
 =?utf-8?B?YVFGQkhVbnhLeUpueGRkc3ZqcDhEQlhvZlNQQVdqS1lVVFZVbjV4WkRIT2JL?=
 =?utf-8?B?WmdVTUhvOUQvRU5iNVFWdkc0RGJSZTdHYzA3c0VPQ3E5VzhWZnVDMTVGNXdS?=
 =?utf-8?B?a1ZTM0NpeWpyMmk1V25KTFN1UnZqYW5paFFRNVcxcDhyWFN4U2ZxR1NSTkww?=
 =?utf-8?B?RWg1aXNXR3BHelhNbFE0LzZjVklEalFNU1NVa3NMdjRLcHc2OVlwbjBwczJa?=
 =?utf-8?B?MFh6RmF2anN1RkY5NzdySUliUno3YTdManZGL1ZOTGIxUWxVWk1WZTk1TE80?=
 =?utf-8?B?cjZyZllKendxL1dTdG9XUy96SFBXeXNEMU5uZ1ZvNFlrMzM4R2ViZVFJSEZr?=
 =?utf-8?B?eHhGeWZnMHlkWWJYYTJFYjB5QXNHTU0xWTlzV1Y4NXJwMGNtOGdDQnRSMGF6?=
 =?utf-8?B?bUwzZEdCVjlISkhETWxiNjlqbXliY1E0cWNYbm1DamlCQTlNSTdhalRXaUFL?=
 =?utf-8?B?Sy96bjJuZlo1K3U4V2NkUkhLVkNYVDJOc0p0RU95dzNjMXh3RFFWdGRJK1F5?=
 =?utf-8?B?bVBMTFRtY09uMnhTUkw3NEhNUEF2d2U5UlV5UVZRUVFHL3YzWmNEWk4yUmpJ?=
 =?utf-8?B?cDN4bzJWZ3dVKzNxU0dYZWJSUXNicmh2eVUxYmoxOWR4ZFh4U29SV0VrdUF6?=
 =?utf-8?B?Q3l4ekFnMzBPNWdMZ2RYZUlqL3AzdHlmd3lPam45Y3Rndm1OV3o3cVhTL1dZ?=
 =?utf-8?B?Ri8wT0krd0h1V091Q09CYmxhK05PVTBwcFF4OEpPOTl1c2w0RjBQekRjeDZU?=
 =?utf-8?B?YjFlMUhuLzY4Zlo0c0pKRUs4UElzZ0xkeG9tamhTSlBMUm5Bdkh3cEFzejl0?=
 =?utf-8?B?U1FhSzhuelcrdEEvbFBneHF2T1NvSlhQeXI4WGE4MXZkR0MzMzFYT01RK3pU?=
 =?utf-8?B?enhGbFZrS3RqMk9jdFJnZG5sM1dmcXlwdCtZNEpmc0xDcFZFRGFNZ3pIK0lP?=
 =?utf-8?B?OEZnVm9MbUdnWWNtVFFWd21tTjZUVXp4WDdUN0FYc3pYdCtDZDQ5Z2RBWjJT?=
 =?utf-8?B?TktIYWhMR1ZNTVhrUXBvOVRlZEtPL0tQQW1XRkdIbDdGaU80TTdUb3h1RERn?=
 =?utf-8?B?TWJ0cjRyZHJkK2MwNExnSVNJUkVURThwOVJ2NGV3b3BiNW1yRFk4Zkg2Z2VB?=
 =?utf-8?B?bHNUaVd3UWRMdDNES05jWFVCaFJhem1zU2ZVeGtuRWQ5cC9GNGtUdmJ0RVBD?=
 =?utf-8?B?MkZsbGhpMndhN2J4VENHamlqWFhUTnZHM3lRV3UvajRjSUZ5VEZsM2xNS1JI?=
 =?utf-8?B?WTJ6Z0dUMC9hL05BTlBwZTJ6U29MajY3WG8zL0U5YkZ1NlF2OTNpVjI2VjVQ?=
 =?utf-8?Q?Vk0OY17En9/j43HdLCOIt6MDr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4993.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ce9f0a-efc0-4486-e35d-08db031925e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 23:24:34.7543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gei6CPgoyrepFv3QeGfv88KPs0ExVDahONGyXgjNB3H6HsKRLTAxvnMyNFbfv3viJwI9by0SA/bgSqcqEabx/vAzN9veT1WRfaSEQO7Bs6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5995
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGV2bGluayBpcyBvbmx5IGZvciBkb3dubG9hZGluZyB0aGUgdmVuZG9yIHNwZWNpZmljIGNvbXBp
bGVyIG91dHB1dCBmb3IgYSBQNCBwcm9ncmFtIGFuZCBmb3IgdGVhY2hpbmcgdGhlIGRyaXZlciBh
Ym91dCB0aGUgbmFtZXMgb2YgcnVudGltZSBQNCBvYmplY3QgYXMgdG8gaG93IHRoZXkgbWFwIG9u
dG8gdGhlIEhXLiBUaGlzIGhlbHBzIHdpdGggdGhlIEluaXRpYWwgZGVmaW5pdGlvbiBvZiB0aGUg
RGF0YXBsYW5lLg0KDQpEZXZsaW5rIGlzIE5PVCBmb3IgdGhlIHJ1bnRpbWUgcHJvZ3JhbW1pbmcg
b2YgdGhlIERhdGFwbGFuZSwgdGhhdCBoYXMgdG8gZ28gdGhyb3VnaCB0aGUgUDRUQyBibG9jayBm
b3IgYW55Ym9keSB0byBkZXBsb3kgYSBwcm9ncmFtbWFibGUgZGF0YXBsYW5lIGJldHdlZW4gdGhl
IEhXIGFuZCB0aGUgU1cgYW5kIGhhdmUgc29tZSBmbG93cyB0aGF0IGFyZSBpbiBIVyBhbmQgc29t
ZSBpbiBTVyBvciBzb21lIHByb2Nlc3NpbmcgSFcgYW5kIHNvbWUgaW4gU1cuIG5kb19zZXR1cF90
YyBmcmFtZXdvcmsgYW5kIHN1cHBvcnQgaW4gdGhlIGRyaXZlcnMgd2lsbCBnaXZlIHVzIHRoZSBo
b29rcyB0byBwcm9ncmFtIHRoZSBIVyBtYXRjaC1hY3Rpb24gZW50cmllcy4gDQpQbGVhc2UgZXhw
bGFpbiB0aHJvdWdoIGVicGYgbW9kZWwgaG93IGRvIEkgcHJvZ3JhbSB0aGUgSFcgYXQgcnVudGlt
ZT8gDQoNClRoYW5rcw0KQW5qYWxpDQoNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZy
b206IEphbWFsIEhhZGkgU2FsaW0gPGpoc0Btb2phdGF0dS5jb20+IA0KU2VudDogTW9uZGF5LCBK
YW51YXJ5IDMwLCAyMDIzIDI6NTQgUE0NClRvOiBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRv
a2VAcmVkaGF0LmNvbT4NCkNjOiBKb2huIEZhc3RhYmVuZCA8am9obi5mYXN0YWJlbmRAZ21haWwu
Y29tPjsgSmFtYWwgSGFkaSBTYWxpbSA8aGFkaUBtb2phdGF0dS5jb20+OyBKaXJpIFBpcmtvIDxq
aXJpQHJlc251bGxpLnVzPjsgV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtYkBnb29nbGUuY29tPjsg
U3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJh
QGtlcm5lbC5vcmc+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBrZXJuZWxAbW9qYXRhdHUuY29t
OyBDaGF0dGVyamVlLCBEZWIgPGRlYi5jaGF0dGVyamVlQGludGVsLmNvbT47IFNpbmdoYWksIEFu
amFsaSA8YW5qYWxpLnNpbmdoYWlAaW50ZWwuY29tPjsgTGltYXllLCBOYW1yYXRhIDxuYW1yYXRh
LmxpbWF5ZUBpbnRlbC5jb20+OyBraGFsaWRtQG52aWRpYS5jb207IHRvbUBzaXBhbmRhLmlvOyBw
cmF0eXVzaEBzaXBhbmRhLmlvOyB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb207IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IHBhYmVuaUByZWRoYXQuY29tOyB2bGFkYnVA
bnZpZGlhLmNvbTsgc2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbTsgc3RlZmFuY0BtYXJ2ZWxsLmNv
bTsgc2Vvbmcua2ltQGFtZC5jb207IG1hdHR5a0BudmlkaWEuY29tOyBEYWx5LCBEYW4gPGRhbi5k
YWx5QGludGVsLmNvbT47IEZpbmdlcmh1dCwgSm9obiBBbmR5IDxqb2huLmFuZHkuZmluZ2VyaHV0
QGludGVsLmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgUkZDIDAwLzIwXSBJbnRy
b2R1Y2luZyBQNFRDDQoNCkkgdGhpbmsgd2UgYXJlIGdvaW5nIGluIGN5Y2xlcy4gSm9obiBJIGFz
a2VkIHlvdSBlYXJsaWVyIGFuZCBpIHRoaW5rIHlvdSBhbnN3ZXJlZCBteSBxdWVzdGlvbjogWW91
IGFyZSBhY3R1YWxseSBwaXRjaGluZyBhbiBvdXQgb2YgYmFuZCBydW50aW1lIHVzaW5nIHNvbWUg
dmVuZG9yIHNkayB2aWEgZGV2bGluayAod2h5IGV2ZW4gYm90aGVyIHdpdGggZGV2bGluayBpbnRl
cmZhY2UsIG5vdCBzdXJlKS4gUDRUQyBpcyBzYXlpbmcgdGhlIHJ1bnRpbWUgQVBJIGlzIHZpYSB0
aGUga2VybmVsIHRvIHRoZSBkcml2ZXJzLg0KDQpUb2tlLCBpIGRvbnQgdGhpbmsgaSBoYXZlIG1h
bmFnZWQgdG8gZ2V0IGFjcm9zcyB0aGF0IHRoZXJlIGlzIGFuICJhdXRvbm9tb3VzIiBjb250cm9s
IGJ1aWx0IGludG8gdGhlIGtlcm5lbC4gSXQgaXMgbm90IGp1c3QgdGhpbmdzIHRoYXQgY29tZSBh
Y3Jvc3MgbmV0bGluay4gSXQncyBhYm91dCB0aGUgd2hvbGUgaW5mcmEuIEkgdGhpbmsgd2l0aG91
dCB0aGF0IGNsYXJpdHkgd2UgYXJlIGdvaW5nIHRvIHNwZWFrIHBhc3QgZWFjaCBvdGhlciBhbmQg
aXQncyBhIGZydXN0cmF0aW5nIGRpc2N1c3Npb24gd2hpY2ggY291bGQgZ2V0IGVtb3Rpb25hbC4g
WW91IGNhbnQganVzdCBkaXNwbGFjZSwgZm9yIGV4YW1wbGUgZmxvd2VyIGFuZCBzYXkgInVzZSBl
YnBmIGJlY2F1c2UgaXQgd29ya3Mgb24gdGMiLCB0aGVyZXMgYSBsb3Qgb2YgdHJpYmFsIGtub3ds
ZWRnZSBnbHVpbmcgcmVsYXRpb25zaGlwIGJldHdlZW4gaGFyZHdhcmUgYW5kIHNvZnR3YXJlLg0K
TWF5YmUgdGFrZSBhIGxvb2sgYXQgdGhpcyBwYXRjaHNldCBiZWxvdyB0byBzZWUgYW4gZXhhbXBs
ZSB3aGljaCBzaG93cyBob3cgcGFydCBvZiBhbiBhY3Rpb24gZ3JhcGggd2lsbCB3b3JrIGluIGhh
cmR3YXJlIGFuZCBwYXJ0aWFsbHkgaW4gc3cgdW5kZXIgY2VydGFpbiBjb25kaXRpb25zOg0KaHR0
cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbmV0ZGV2L21zZzg3NzUwNy5odG1sIGFuZCB0aGVu
IHdlIGNhbiBoYXZlIGEgYmV0dGVyIGRpc2N1c3Npb24uDQoNCmNoZWVycywNCmphbWFsDQoNCg0K
T24gTW9uLCBKYW4gMzAsIDIwMjMgYXQgNDoyMSBQTSBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4g
PHRva2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+DQo+IEpvaG4gRmFzdGFiZW5kIDxqb2huLmZhc3Rh
YmVuZEBnbWFpbC5jb20+IHdyaXRlczoNCj4NCj4gPiBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4g
d3JvdGU6DQo+ID4+IEphbWFsIEhhZGkgU2FsaW0gPGhhZGlAbW9qYXRhdHUuY29tPiB3cml0ZXM6
DQo+ID4+DQo+ID4+ID4gT24gTW9uLCBKYW4gMzAsIDIwMjMgYXQgMTI6MDQgUE0gVG9rZSBIw7hp
bGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+PiA+Pg0KPiA+PiA+
PiBKYW1hbCBIYWRpIFNhbGltIDxqaHNAbW9qYXRhdHUuY29tPiB3cml0ZXM6DQo+ID4+ID4+DQo+
ID4+ID4+ID4gU28gaSBkb250IGhhdmUgdG8gcmVzcG9uZCB0byBlYWNoIGVtYWlsIGluZGl2aWR1
YWxseSwgSSB3aWxsIA0KPiA+PiA+PiA+IHJlc3BvbmQgaGVyZSBpbiBubyBwYXJ0aWN1bGFyIG9y
ZGVyLiBGaXJzdCBsZXQgbWUgcHJvdmlkZSBzb21lIA0KPiA+PiA+PiA+IGNvbnRleHQsIGlmIHRo
YXQgd2FzIGFscmVhZHkgY2xlYXIgcGxlYXNlIHNraXAgaXQuIEhvcGVmdWxseSANCj4gPj4gPj4g
PiBwcm92aWRpbmcgdGhlIGNvbnRleHQgd2lsbCBoZWxwIHVzIHRvIGZvY3VzIG90aGVyd2lzZSB0
aGF0IA0KPiA+PiA+PiA+IGJpa2VzaGVkJ3MgY29sb3IgYW5kIHNoYXBlIHdpbGwgdGFrZSBmb3Jl
dmVyIHRvIHNldHRsZSBvbi4NCj4gPj4gPj4gPg0KPiA+PiA+PiA+IF9fQ29udGV4dF9fDQo+ID4+
ID4+ID4NCj4gPj4gPj4gPiBJIGhvcGUgd2UgYWxsIGFncmVlIHRoYXQgd2hlbiB5b3UgaGF2ZSAy
eDEwMEcgTklDIChhbmQgaSBoYXZlIA0KPiA+PiA+PiA+IHNlZW4gcGVvcGxlIGFza2luZyBmb3Ig
Mng4MDBHIE5JQ3MpIG5vIFhEUCBvciBEUERLIGlzIGdvaW5nIHRvIA0KPiA+PiA+PiA+IHNhdmUg
eW91LiBUbw0KPiA+PiA+PiA+IHZpc3VhbGl6ZTogb25lIDI1RyBwb3J0IGlzIDM1TXBwcyB1bmlk
aXJlY3Rpb25hbC4gU28gInNvZnR3YXJlIHN0YWNrIg0KPiA+PiA+PiA+IGlzIG5vdCB0aGUgYW5z
d2VyLiBZb3UgbmVlZCB0byBvZmZsb2FkLg0KPiA+PiA+Pg0KPiA+PiA+PiBJJ20gbm90IGRpc3B1
dGluZyB0aGUgbmVlZCB0byBvZmZsb2FkLCBhbmQgSSdtIHBlcnNvbmFsbHkgDQo+ID4+ID4+IGRl
bGlnaHRlZCB0aGF0DQo+ID4+ID4+IFA0IGlzIGJyZWFraW5nIG9wZW4gdGhlIHZlbmRvciBibGFj
ayBib3hlcyB0byBwcm92aWRlIGEgDQo+ID4+ID4+IHN0YW5kYXJkaXNlZCBpbnRlcmZhY2UgZm9y
IHRoaXMuDQo+ID4+ID4+DQo+ID4+ID4+IEhvd2V2ZXIsIHdoaWxlIGl0J3MgdHJ1ZSB0aGF0IHNv
ZnR3YXJlIGNhbid0IGtlZXAgdXAgYXQgdGhlIGhpZ2ggDQo+ID4+ID4+IGVuZCwgbm90IGV2ZXJ5
dGhpbmcgcnVucyBhdCB0aGUgaGlnaCBlbmQsIGFuZCB0b2RheSdzIGhpZ2ggZW5kIA0KPiA+PiA+
PiBpcyB0b21vcnJvdydzIG1pZCBlbmQsIGluIHdoaWNoIFhEUCBjYW4gdmVyeSBtdWNoIHBsYXkg
YSByb2xlLiANCj4gPj4gPj4gU28gYmVpbmcgYWJsZSB0byBtb3ZlIHNtb290aGx5IGJldHdlZW4g
dGhlIHR3bywgYW5kIGV2ZW4gDQo+ID4+ID4+IGltcGxlbWVudCBmdW5jdGlvbnMgdGhhdCBzcGxp
dCBwcm9jZXNzaW5nIGJldHdlZW4gdGhlbSwgaXMgYW4gDQo+ID4+ID4+IGVzc2VudGlhbCBmZWF0
dXJlIG9mIGEgcHJvZ3JhbW1hYmxlIG5ldHdvcmtpbmcgcGF0aCBpbiBMaW51eC4gDQo+ID4+ID4+
IFdoaWNoIGlzIHdoeSBJJ20gb2JqZWN0aW5nIHRvIGltcGxlbWVudGluZyB0aGUNCj4gPj4gPj4g
UDQgYml0cyBhcyBzb21ldGhpbmcgdGhhdCdzIGhhbmdpbmcgb2ZmIHRoZSBzaWRlIG9mIHRoZSBz
dGFjayBpbiANCj4gPj4gPj4gaXRzIG93biB0aGluZyBhbmQgaXMgbm90IGludGVncmF0ZWQgd2l0
aCB0aGUgcmVzdCBvZiB0aGUgc3RhY2suIA0KPiA+PiA+PiBZb3Ugd2VyZSB0b3V0aW5nIHRoaXMg
YXMgYSBmZWF0dXJlICgiYmVpbmcgc2VsZi1jb250YWluZWQiKS4gSSBjb25zaWRlciBpdCBhIGJ1
Zy4NCj4gPj4gPj4NCj4gPj4gPj4gPiBTY3JpcHRhYmlsaXR5IGlzIG5vdCBhIG5ldyBpZGVhIGlu
IFRDIChzZWUgdTMyIGFuZCBwZWRpdCBhbmQgDQo+ID4+ID4+ID4gb3RoZXJzIGluIFRDKS4NCj4g
Pj4gPj4NCj4gPj4gPj4gdTMyIGlzIG5vdG9yaW91c2x5IGhhcmQgdG8gdXNlLiBUaGUgb3RoZXJz
IGFyZSBuZWF0LCBidXQgDQo+ID4+ID4+IG9idmlvdXNseSBsaW1pdGVkIHRvIHBhcnRpY3VsYXIg
dXNlIGNhc2VzLg0KPiA+PiA+DQo+ID4+ID4gRGVzcGl0ZSBteSBsb3ZlIGZvciB1MzIsIEkgYWRt
aXQgaXRzIHVzZXIgaW50ZXJmYWNlIGlzIGNyeXB0aWMuIEkgDQo+ID4+ID4ganVzdCB3YW50ZWQg
dG8gcG9pbnQgb3V0IHRvIGV4aXN0aW5nIHNhbXBsZXMgb2Ygc2NyaXB0YWJsZSBhbmQgDQo+ID4+
ID4gb2ZmbG9hZGFibGUgVEMgb2JqZWN0cy4NCj4gPj4gPg0KPiA+PiA+PiBEbyB5b3UgYWN0dWFs
bHkgZXhwZWN0IGFueW9uZSB0byB1c2UgUDQgYnkgbWFudWFsbHkgZW50ZXJpbmcgVEMgDQo+ID4+
ID4+IGNvbW1hbmRzIHRvIGJ1aWxkIGEgcGlwZWxpbmU/IEkgcmVhbGx5IGZpbmQgdGhhdCBoYXJk
IHRvIA0KPiA+PiA+PiBiZWxpZXZlLi4uDQo+ID4+ID4NCj4gPj4gPiBZb3UgZG9udCBoYXZlIHRv
IG1hbnVhbGx5IGhhbmQgY29kZSBhbnl0aGluZyAtIGl0cyB0aGUgY29tcGlsZXJzIGpvYi4NCj4g
Pj4NCj4gPj4gUmlnaHQsIHRoYXQgd2FzIGtpbmRhIG15IHBvaW50OiBpbiB0aGF0IGNhc2UgdGhl
IGNvbXBpbGVyIGNvdWxkIA0KPiA+PiBqdXN0IGFzIHdlbGwgZ2VuZXJhdGUgYSAoc2V0IG9mKSBC
UEYgcHJvZ3JhbShzKSBpbnN0ZWFkIG9mIHRoaXMgVEMgc2NyaXB0IHRoaW5nLg0KPiA+Pg0KPiA+
PiA+PiA+IElPVywgd2UgYXJlIHJldXNpbmcgYW5kIHBsdWdnaW5nIGludG8gYSBwcm92ZW4gYW5k
IGRlcGxveWVkIA0KPiA+PiA+PiA+IG1lY2hhbmlzbSB3aXRoIGEgYnVpbHQtaW4gcG9saWN5IGRy
aXZlbiwgdHJhbnNwYXJlbnQgc3ltYmlvc2lzIA0KPiA+PiA+PiA+IGJldHdlZW4gaGFyZHdhcmUg
b2ZmbG9hZCBhbmQgc29mdHdhcmUgdGhhdCBoYXMgbWF0dXJlZCBvdmVyIA0KPiA+PiA+PiA+IHRp
bWUuIFlvdSBjYW4gdGFrZSBhIHBpcGVsaW5lIG9yIGEgdGFibGUgb3IgYWN0aW9ucyBhbmQgc3Bs
aXQgDQo+ID4+ID4+ID4gdGhlbSBiZXR3ZWVuIGhhcmR3YXJlIGFuZCBzb2Z0d2FyZSB0cmFuc3Bh
cmVudGx5LCBldGMuDQo+ID4+ID4+DQo+ID4+ID4+IFRoYXQncyBhIGNvbnRyb2wgcGxhbmUgZmVh
dHVyZSB0aG91Z2gsIGl0J3Mgbm90IGFuIGFyZ3VtZW50IGZvciANCj4gPj4gPj4gYWRkaW5nIGFu
b3RoZXIgaW50ZXJwcmV0ZXIgdG8gdGhlIGtlcm5lbC4NCj4gPj4gPg0KPiA+PiA+IEkgYW0gbm90
IHN1cmUgd2hhdCB5b3UgbWVhbiBieSBjb250cm9sLCBidXQgd2hhdCBpIGRlc2NyaWJlZCBpcyAN
Cj4gPj4gPiBrZXJuZWwgYnVpbHQgaW4uIE9mIGNvdXJzZSBpIGNvdWxkIGRvIG1vcmUgY29tcGxl
eCB0aGluZ3MgZnJvbSANCj4gPj4gPiB1c2VyIHNwYWNlIChpZiB0aGF0IGlzIHdoYXQgeW91IG1l
YW4gYXMgY29udHJvbCkuDQo+ID4+DQo+ID4+ICJDb250cm9sIHBsYW5lIiBhcyBpbiBTRE4gcGFy
bGFuY2UuIEkuZS4sIHRoZSBiaXRzIHRoYXQga2VlcCB0cmFjayANCj4gPj4gb2YgY29uZmlndXJh
dGlvbiBvZiB0aGUgZmxvdy9waXBlbGluZS90YWJsZSBjb25maWd1cmF0aW9uLg0KPiA+Pg0KPiA+
PiBUaGVyZSdzIG5vIHJlYXNvbiB5b3UgY2FuJ3QgaGF2ZSBhbGwgdGhhdCBpbmZyYXN0cnVjdHVy
ZSBhbmQgdXNlIA0KPiA+PiBCUEYgYXMgdGhlIGRhdGFwYXRoIGxhbmd1YWdlLiBJLmUuLCBpbnN0
ZWFkIG9mOg0KPiA+Pg0KPiA+PiB0YyBwNHRlbXBsYXRlIGNyZWF0ZSBwaXBlbGluZS9hUDRwcm9n
Z2llIG51bXRhYmxlcyAxIC4uLiArIGFsbCB0aGUgDQo+ID4+IG90aGVyIHN0dWZmIHRvIHBvcHVs
YXRlIGl0DQo+ID4+DQo+ID4+IHlvdSBjb3VsZCBqdXN0IGRvOg0KPiA+Pg0KPiA+PiB0YyBwNCBj
cmVhdGUgcGlwZWxpbmUvYVA0cHJvZ2dpZSBvYmpfZmlsZSBhUDRwcm9nZ2llLmJwZi5vDQo+ID4+
DQo+ID4+IGFuZCBzdGlsbCBoYXZlIGFsbCB0aGUgbWFuYWdlbWVudCBpbmZyYXN0cnVjdHVyZSB3
aXRob3V0IHRoZSBuZXcgDQo+ID4+IGludGVycHJldGVyIGFuZCBhc3NvY2lhdGVkIGNvbXBsZXhp
dHkgaW4gdGhlIGtlcm5lbC4NCj4gPj4NCj4gPj4gPj4gPiBUaGlzIGhhbW1lciBhbHJlYWR5IG1l
ZXRzIG91ciBnb2Fscy4NCj4gPj4gPj4NCj4gPj4gPj4gVGhhdCA2MGsrIGxpbmUgcGF0Y2ggc3Vi
bWlzc2lvbiBvZiB5b3VycyBzYXlzIG90aGVyd2lzZS4uLg0KPiA+PiA+DQo+ID4+ID4gVGhpcyBp
cyBwcmV0dHkgbXVjaCBjb3ZlcmVkIGluIHRoZSBjb3ZlciBsZXR0ZXIgYW5kIGEgZmV3IA0KPiA+
PiA+IHJlc3BvbnNlcyBpbiB0aGUgdGhyZWFkIHNpbmNlLg0KPiA+Pg0KPiA+PiBUaGUgb25seSBh
cmd1bWVudCBmb3Igd2h5IHlvdXIgY3VycmVudCBhcHByb2FjaCBtYWtlcyBzZW5zZSBJJ3ZlIA0K
PiA+PiBzZWVuIHlvdSBtYWtlIGlzICJJIGRvbid0IHdhbnQgdG8gcmV3cml0ZSBpdCBpbiBCUEYi
LiBXaGljaCBpcyBub3QgDQo+ID4+IGEgdGVjaG5pY2FsIGFyZ3VtZW50Lg0KPiA+Pg0KPiA+PiBJ
J20gbm90IHRyeWluZyB0byBiZSBkaXNpbmdlbnVvdXMgaGVyZSwgQlRXOiBJIHJlYWxseSBkb24n
dCBzZWUgdGhlIA0KPiA+PiB0ZWNobmljYWwgYXJndW1lbnQgZm9yIHdoeSB0aGUgUDQgZGF0YSBw
bGFuZSBoYXMgdG8gYmUgaW1wbGVtZW50ZWQgDQo+ID4+IGFzIGl0cyBvd24gaW50ZXJwcmV0ZXIg
aW5zdGVhZCBvZiBpbnRlZ3JhdGluZyB3aXRoIHdoYXQgd2UgaGF2ZSANCj4gPj4gYWxyZWFkeSAo
aS5lLiwgQlBGKS4NCj4gPj4NCj4gPj4gLVRva2UNCj4gPj4NCj4gPg0KPiA+IEknbGwganVzdCB0
YWtlIHRoaXMgaGVyZSBiZWNhdWVzIEkgdGhpbmsgaXRzIG1vc3RseSByZWxhdGVkLg0KPiA+DQo+
ID4gU3RpbGwgbm90IGNvbnZpbmNlZCB0aGUgUDRUQyBoYXMgYW55IHZhbHVlIGZvciBzdy4gRnJv
bSB0aGUgc2xpZGUgDQo+ID4geW91IHNheSB2ZW5kb3JzIHByZWZlciB5b3UgaGF2ZSB0aGlzIHBp
Y3R1cmUgcm91Z2h0bHkuDQo+ID4NCj4gPg0KPiA+ICAgIFsgUDQgY29tcGlsZXIgXSAtLS0tLS0g
WyBQNFRDIGJhY2tlbmQgXSAtLS0tPiBUQyBBUEkNCj4gPiAgICAgICAgIHwNCj4gPiAgICAgICAg
IHwNCj4gPiAgICBbIFA0IFZlbmRvciBiYWNrZW5kIF0NCj4gPiAgICAgICAgIHwNCj4gPiAgICAg
ICAgIHwNCj4gPiAgICAgICAgIFYNCj4gPiAgICBbIERldmxpbmsgXQ0KPiA+DQo+ID4NCj4gPiBO
b3cganVzdCByZXBsYWNlIFA0VEMgYmFja2VuZCB3aXRoIFA0QyBhbmQgeW91ciBvbmx5IHdvcmsg
aXMgdG8gDQo+ID4gcmVwbGFjZSBkZXZsaW5rIHdpdGggdGhlIGN1cnJlbnQgaHcgc3BlY2lmaWMg
Yml0cyBhbmQgeW91IGhhdmUgYSBzdyANCj4gPiBhbmQgaHcgY29tcG9uZW50cy4gVGhlbiB5b3Ug
Z2V0IFhEUC1CUEYgcHJldHR5IGVhc2lseSBmcm9tIFA0WERQIA0KPiA+IGJhY2tlbmQgaWYgeW91
IGxpa2UuIFRoZSBjb21wYXQgcGllY2UgaXMgaGFuZGxlZCBieSBjb21waWxlciB3aGVyZSANCj4g
PiBpdCBzaG91bGQgYmUuIE15IENQVSBpcyBub3QgYSBNQVQgc28gcHJldGVuZGluZyBpdCBpcyBz
ZWVtcyBub3QgDQo+ID4gaWRlYWwgdG8gbWUsIEkgZG9uJ3QgaGF2ZSBhIFRDQU0gb24gbXkgY29y
ZXMuDQo+ID4NCj4gPiBGb3IgcnVudGltZSBnZXQgdGhvc2UgdmVuZG9ycyB0byB3cml0ZSB0aGVp
ciBTREtzIG92ZXIgRGV2bGluayBhbmQgDQo+ID4gbm8gbmVlZCBmb3IgdGhpcyBzb2Z0d2FyZSB0
aGluZy4gVGhlIHJ1bnRpbWUgZm9yIFA0YyBzaG91bGQgYWxyZWFkeSANCj4gPiB3b3JrIG92ZXIg
QlBGLiBHaXZpbmcgdGhpcyBwaWN0dXJlDQo+ID4NCj4gPiAgICBbIFA0IGNvbXBpbGVyIF0gLS0t
LS0tIFsgUDRDIGJhY2tlbmQgXSAtLS0tPiBCUEYNCj4gPiAgICAgICAgIHwNCj4gPiAgICAgICAg
IHwNCj4gPiAgICBbIFA0IFZlbmRvciBiYWNrZW5kIF0NCj4gPiAgICAgICAgIHwNCj4gPiAgICAg
ICAgIHwNCj4gPiAgICAgICAgIFYNCj4gPiAgICBbIERldmxpbmsgXQ0KPiA+DQo+ID4gQW5kIG11
Y2ggbGVzcyB3b3JrIGZvciB1cyB0byBtYWludGFpbi4NCj4NCj4gWWVzLCB0aGlzIHdhcyBiYXNp
Y2FsbHkgbXkgcG9pbnQgYXMgd2VsbC4gVGhhbmsgeW91IGZvciBwdXR0aW5nIGl0IA0KPiBpbnRv
IEFTQ0lJIGRpYWdyYW1zISA6KQ0KPg0KPiBUaGVyZSdzIHN0aWxsIHRoZSBjb250cm9sIHBsYW5l
IGJpdDogc29tZSBrZXJuZWwgY29tcG9uZW50IHRoYXQgDQo+IGNvbmZpZ3VyZXMgdGhlIHBpZWNl
cyAocGlwZWxpbmVzPykgY3JlYXRlZCBpbiB0aGUgdG9wLXJpZ2h0IGFuZCANCj4gYm90dG9tLWxl
ZnQgY29ybmVycyBvZiB5b3VyIGRpYWdyYW0ocyksIGtlZXBpbmcgdHJhY2sgb2Ygd2hpY2ggDQo+
IHBpcGVsaW5lcyBhcmUgaW4gSFcvU1csIG1heWJlIHVwZGF0aW5nIHNvbWUgbWF0Y2ggdGFibGVz
IGR5bmFtaWNhbGx5IA0KPiBhbmQgZXh0cmFjdGluZyBzdGF0aXN0aWNzLiBJJ20gdG90YWxseSBP
SyB3aXRoIGhhdmluZyB0aGF0IGJpdCBiZSBpbiANCj4gdGhlIGtlcm5lbCwgYnV0IHRoYXQgY2Fu
IGJlIGFkZGVkIG9uIHRvcCBvZiB5b3VyIHNlY29uZCBkaWFncmFtIGp1c3QgDQo+IGFzIHdlbGwg
YXMgb24gdG9wIG9mIHRoZSBmaXJzdCBvbmUuLi4NCj4NCj4gLVRva2UNCj4NCg==
