Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1950675CD9
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 19:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjATSgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 13:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjATSgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 13:36:41 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCCBAA7F3
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 10:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674239801; x=1705775801;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=srbub7QnTTZ5Q8E0H/ntPHK3MT/AdqVUvy54dI+rxCc=;
  b=kfkdXXEbMFilsNkHz0clrl/efg/zKluG4az6CEwBTFH3Y4GiDavmFAuo
   rxw3pNegTGKk2rPlIxtO4XIBvNi5WAZH2QVblHmrJ1GgxaoM6JfpJQw9W
   wE5WBNXCoPOODqqaaCwJlWRxwVelvZJszeS4qST2XKzHmGoOMjJUqilTn
   wkNOkDUoBV9eIbGqrJn1/rl9NxkM7YiSU7MVYBnSt0S8mOtfJa1hpQcXa
   Q+Z2msXwr4+2Qq/t9ExK3fENpN5sMidcJ+HiApmoTQ//maDaYionRQnqa
   3PTCA3J2ycO0WobICx5sd5qgmomfKLra1M+ytSsjA9mP9E9bnhqy3JqIg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="306020164"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="306020164"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 10:36:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="784609597"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="784609597"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 20 Jan 2023 10:36:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 10:36:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 10:36:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 10:36:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bO5OhpD28L0P3I7yTIQ7zlMlxW4I5V4SDVVpY0adv56Eea5LNeLbsrOkz3tPH9MchtAi3GOXDgEYC8H1tc1F051ApA4gUNx1KNljQpvVqcOdsXqx0KQoyPp+vVRHfTQdLW3ik1DnYioJMRTJ/nJo4hcYIzc8wbiiJnV5dqdMfsRukPak3vp4iVxzXZKuP9l4seY6rQhV/fUtY28gObeoq8FZPwp6/uS87ymb43Dgq2LgSJJTcBBvT+9pjRvjuu1FO0ab4Q2O1U1CSNpFRsYhhTUNw9i8/40A22QXBF2ThpIIj0EdyOUQcbolS9dLpE8WzubE++4aep5WI5TQZksvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srbub7QnTTZ5Q8E0H/ntPHK3MT/AdqVUvy54dI+rxCc=;
 b=IN8/bo9DE+sUUUa+dRkmfQgcFAvNxJXUjuuIU92boaKSe+BnCqCub38j6kE+MJBikfoGEX6LEH0Q5CcDMSG0vyjEY/COtSbPSBeoKODm34Gujg4ByfGiGxRj0Y8zB+9duO4xtVTvnvQT636Oh48sdZc5dWTOcL9PmfGSYuWk8GUw/e0h5v+KxzOzjBn0CDWxjCODyfnPtG49+XjXZQ92XZzBwqp3sEupXce5yvYUfQI6s+4sUillHiOrGmFfFEseH0EnCQ2NzB6RlTwx52U1TZok5+bG0Ke/vo9GwXO9xgoP1zxqcR51OgLCnwcj9sm20ry6QEVyE5y8lE+y0wjokQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5544.namprd11.prod.outlook.com (2603:10b6:208:314::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 18:36:36 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 18:36:36 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm@gmail.com" <habetsm@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: RE: [PATCH net-next 3/7] sfc: add mport lookup based on driver's
 mport data
Thread-Topic: [PATCH net-next 3/7] sfc: add mport lookup based on driver's
 mport data
Thread-Index: AQHZK/nVBvef9cBxKkWy9R7J0unQPa6ma70AgAChGgCAAJcl8A==
Date:   Fri, 20 Jan 2023 18:36:36 +0000
Message-ID: <CO1PR11MB50896ED5BCA48756B04B2458D6C59@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-4-alejandro.lucero-palau@amd.com>
 <1a3387e7-dbe3-905a-4b7a-ef2cd776cb33@intel.com>
 <9240b567-7dcf-202d-57f9-226a9de097ca@amd.com>
In-Reply-To: <9240b567-7dcf-202d-57f9-226a9de097ca@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|BL1PR11MB5544:EE_
x-ms-office365-filtering-correlation-id: 4ea6151d-db16-4fa3-1524-08dafb1542fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LH7HOLr0WyJPyATP96QC4M+im0MW1jl60R8OcQ2PaB8lY1PmJG8/aAMQN7qNA76Y0I/7MNVI1arPTVcDJW08ta+LPOdtqovPsjjeZM8haTllPPQlDZKkcklxKqfc5u6U2e6LE1frlF6p6RrZDvHHsQUdSffsm/Ann6rgqe74X5mWF7WffYhhwQhQKtbweJ9r2Ss+jSbbMsiqhteHDjvIb40h4Abhg219B/Y5yrx3T/3pPZRYnOYci7up7p662gllo+yI88Tjl7fjx0v03N1o/1FuTUqw04yjdbD+AQPecPYXwJDpeojjSNv1DlrRJyIrgmM6qHnuQoA6siWaEKl8uoEya8H2c8Qr/OtqEzwfeTQcQ1WDlZIrcUqxHp1oSV+bPfyov2UnTIarVMz8F5HVN4vszfJajHzv3EGttGhMbFPmvd29Xb71UMFv3pHRK0R64sdqE6jfE4jWtgnoJjrBDFsWes3TnixCv9sI5/lq+zLzUyyxkklp3lwCA9hR9VZ2YCy9+qNE0ajrfXh8tv3pb3LUC3SVNQQqzlIS5JXr0BEfLTagIOSofhKXYQi2VBjyhnEDA2cBRB9CRu+pT5I35Z3dJbRDd5jGwmlgq5tDk+1QyM/O9jb0PbMQsTM6XEvCVIhCZFXuOTdTm5nI+wmW7qou8fybukpBdaQpV3IckgsSM8WWUD1ip+paDyLPh7B4bOztfFEHEAyYGoXpNv2GsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(5660300002)(82960400001)(8676002)(4326008)(66476007)(64756008)(66556008)(316002)(66446008)(53546011)(7696005)(71200400001)(52536014)(6506007)(33656002)(8936002)(41300700001)(38070700005)(122000001)(54906003)(110136005)(38100700002)(9686003)(478600001)(86362001)(2906002)(83380400001)(26005)(186003)(55016003)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFZZa0E1M2U0U0V4cGlqMUlsRjIyT3l3eGZGcVRPbkZYZGxQTHNLYXR1bDJT?=
 =?utf-8?B?Y2xSczJ6bzB5YmxKWDNyTThmYXZzd1docmpOYUpvL3JzVlMvcWFrRC92S3Ay?=
 =?utf-8?B?RU5SdHVWd1ZDTlpVL25Ca3pvREZhQklOWmtyTzRPaHR5R0FBOU1CNWVxWlQz?=
 =?utf-8?B?YytWelZtUkNucC9YWDkyVjNzYzVZR2xNSkRSRHpmQ2cxdng0WFFkWVA0bllw?=
 =?utf-8?B?bzdhVEVZTGVVdkluNlNKcU1SQkVlcThERHUxTmo4MmpyQkV3MlpPbm95Rnc3?=
 =?utf-8?B?WGQyZkQ4aldPcUx1azNYVG8vVHlvclBmQ2l1dnMrL1h5ZFZCSUNUbHc2WDBD?=
 =?utf-8?B?RGMyVTBzTzNYTmgyYXRHKzE3bmdZbUcxWlpuOU9qUWFmeHhFZ1dXdWZLQTBD?=
 =?utf-8?B?MXhwQVBFNUgvWW52ODlLdnZxRWZ2ZVdpb0JQeFdRZ3o0RWZmM2praGtGNDVr?=
 =?utf-8?B?MjllN3ZzQmN3K0dGcFJkSWJnOVJtMmxxc3JKSCtBUFNyUXJZVWMweXJpdVd4?=
 =?utf-8?B?NkpPODgwZWtrUjUvVk1hay9rcTBPOXlLTlFmaFVLbEJVcitUTE45MGUvMjFk?=
 =?utf-8?B?cy8xQ2oyQXFYem1laFdGWUp0OVhQQk56VWtVVFNsKzJYRXJheER6NjJtVU8v?=
 =?utf-8?B?Rkx0MmFoQTFCVyt2OW43QnZLWDVCZEtCQjRhakNFWHBqM2lTUm0xRFR4Z2ta?=
 =?utf-8?B?R2o5b2pVaFMyblhCQTdBTnp3OFFGaHpYYURJUHNkMGNSMnFHaGJxTm82RktB?=
 =?utf-8?B?NTByaHE4VW9TMldpU3JDWTZ2RHp0RU9GVFA2cU9wc0RJK3V6bjNPQVVwVmY1?=
 =?utf-8?B?UmNHZ2hOazRvd1Z4VWlFcXZOb0pRMmdhVnFIZldYN1lGbFhrWW5ZTXFQdzBM?=
 =?utf-8?B?L0VNaGgyWmk2K3pTTW5XNVVDc1piN1pSYjBPcDVnMUc4NkgyR3lFZ21yeHAr?=
 =?utf-8?B?V2szYnpxdDhRaFE5cnkxWGZXeFZnSUx1RW5FMm5qVzlGck1xcnp4TzlZRE1m?=
 =?utf-8?B?MTZDNUd5TVpBcVR2QlpwMlJ2NUF3ZDlsNlBjYlhTM3JDL0h5V3FadDVJM3hN?=
 =?utf-8?B?UjI1QWdmMjUxdkprcWNhZ1E0RkUyTHIxUGpXZndDQ1NjdjlPcm11cTRSNVVz?=
 =?utf-8?B?dTN0aTRuYStQTXBOc3ptZUppSHRjNFY5SkhiSlo4azRrU0RWTlVCRWlLMWFC?=
 =?utf-8?B?eEM2WkRzcGswMGI3ZG9vK3UzQnl4aWlxNHE5ZGUrU3lSWllmYndwZlVLc1dU?=
 =?utf-8?B?eEg5MTFCTzRCZG5jV3VBYUMyKzV3SjUxWEtiQ0hwcTE4QmtjREo3UTR4ZVZw?=
 =?utf-8?B?QU9tbU9rMldlZ0J2NGdvMDFEdnErN1JnSVBDdWtuaHp0cHJySHpHcmwyaUZY?=
 =?utf-8?B?THk2T2d6Yi95TnFncEVwb1ZrcDRHdnJrb3Q3SHBJT3ByV0s3S3FacDVrWTdK?=
 =?utf-8?B?bStrcXJDd05IR3ViU3FZdDcwa0l4OUFSN29yRHlxaThLSFZTWHA4QTBtYUJX?=
 =?utf-8?B?OC80UDJXYVBJL01zeGRzNDhOVTl4SmE2OTcyd0tWY2tLNkJNWmd6WXI0aVI4?=
 =?utf-8?B?NlFBVjRhdDhrVUN0dWJialVBclFxa2R3QVNUUGp3dmZudFlSdkFydjJqUG1q?=
 =?utf-8?B?dE1kbHBocVBiT0MyaXA4K1pyRHhjMlN3MmxrRnVLUGxSM0hpL2ljS0g1cnlL?=
 =?utf-8?B?YzI3dkVtQW1Fczd5b0lEZlYvZy9EdVkyd1Q5MzVjWDQwYSt5VXRnOFZmazBY?=
 =?utf-8?B?QUdOTXdpbk14bDczdlpMTVF3MDlHRmFiMm5VSVRzQnRMRXpWRk1xWXhyV2h6?=
 =?utf-8?B?UzVXb0tiaDZmVjUvdlZBVHppMy8zdDFxWmhYbEROVGhrSGRNNGFlUVdVS0NT?=
 =?utf-8?B?dGN0Sm5yKzI2UTVPMFYyRjVYd0dTK2wwVHpWSFN2cXpVWmxyS0xqd3VqREJB?=
 =?utf-8?B?R0FlWi9INWd3QkkxOUFkNWdPTS9DOWRONCtPUVZFQ29iMmcxRitXVVRObXlh?=
 =?utf-8?B?Y0pDVmNJNWZYelE2Ri9QaEVaRXdBRW1wSEl5NjZUa3JDWCtTSmdFQ3ZJSFNB?=
 =?utf-8?B?MjczVnZQQjU1WlVFWEphemdGZWdCSFgxN2ExNUVhSzF1amV4MjEvM2lhd2Rt?=
 =?utf-8?Q?j444esw+MjlVxYiNvDlloUmWG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea6151d-db16-4fa3-1524-08dafb1542fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 18:36:36.2710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FUC6TG/ancNhxyHKKjHexTa/yHYL8oTcXK4bfw9DCdXK3ph/BA7SzJ3D/GMURLdslavcdtDQ+0NLU9ftImpWz8P46sZ3odDPrkNqBRYGdEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5544
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTHVjZXJvIFBhbGF1LCBB
bGVqYW5kcm8gPGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbT4NCj4gU2VudDogRnJpZGF5
LCBKYW51YXJ5IDIwLCAyMDIzIDE6MzUgQU0NCj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2Iu
ZS5rZWxsZXJAaW50ZWwuY29tPjsgTHVjZXJvIFBhbGF1LCBBbGVqYW5kcm8NCj4gPGFsZWphbmRy
by5sdWNlcm8tcGFsYXVAYW1kLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW5l
dC1kcml2ZXJzDQo+IChBTUQtWGlsaW54KSA8bGludXgtbmV0LWRyaXZlcnNAYW1kLmNvbT4NCj4g
Q2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5j
b207DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGhhYmV0c21AZ21haWwuY29tOyBlY3JlZS54aWxp
bnhAZ21haWwuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMy83XSBzZmM6IGFk
ZCBtcG9ydCBsb29rdXAgYmFzZWQgb24gZHJpdmVyJ3MgbXBvcnQNCj4gZGF0YQ0KPiANCj4gDQo+
IE9uIDEvMTkvMjMgMjM6NTcsIEphY29iIEtlbGxlciB3cm90ZToNCj4gPg0KPiA+IE9uIDEvMTkv
MjAyMyAzOjMxIEFNLCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6DQo+ID4+
ICtpbnQgZWZ4X21hZV9sb29rdXBfbXBvcnQoc3RydWN0IGVmeF9uaWMgKmVmeCwgdTMyIHZmX2lk
eCwgdTMyICppZCkNCj4gPj4gK3sNCj4gPj4gKwlzdHJ1Y3QgZWYxMDBfbmljX2RhdGEgKm5pY19k
YXRhID0gZWZ4LT5uaWNfZGF0YTsNCj4gPj4gKwlzdHJ1Y3QgZWZ4X21hZSAqbWFlID0gZWZ4LT5t
YWU7DQo+ID4+ICsJc3RydWN0IHJoYXNodGFibGVfaXRlciB3YWxrOw0KPiA+PiArCXN0cnVjdCBt
YWVfbXBvcnRfZGVzYyAqbTsNCj4gPj4gKwlpbnQgcmMgPSAtRU5PRU5UOw0KPiA+PiArDQo+ID4+
ICsJcmhhc2h0YWJsZV93YWxrX2VudGVyKCZtYWUtPm1wb3J0c19odCwgJndhbGspOw0KPiA+PiAr
CXJoYXNodGFibGVfd2Fsa19zdGFydCgmd2Fsayk7DQo+ID4+ICsJd2hpbGUgKChtID0gcmhhc2h0
YWJsZV93YWxrX25leHQoJndhbGspKSAhPSBOVUxMKSB7DQo+ID4+ICsJCWlmIChtLT5tcG9ydF90
eXBlID09IE1BRV9NUE9SVF9ERVNDX01QT1JUX1RZUEVfVk5JQw0KPiAmJg0KPiA+PiArCQkgICAg
bS0+aW50ZXJmYWNlX2lkeCA9PSBuaWNfZGF0YS0+bG9jYWxfbWFlX2ludGYgJiYNCj4gPj4gKwkJ
ICAgIG0tPnBmX2lkeCA9PSAwICYmDQo+ID4+ICsJCSAgICBtLT52Zl9pZHggPT0gdmZfaWR4KSB7
DQo+ID4+ICsJCQkqaWQgPSBtLT5tcG9ydF9pZDsNCj4gPj4gKwkJCXJjID0gMDsNCj4gPj4gKwkJ
CWJyZWFrOw0KPiA+PiArCQl9DQo+ID4+ICsJfQ0KPiA+PiArCXJoYXNodGFibGVfd2Fsa19zdG9w
KCZ3YWxrKTsNCj4gPj4gKwlyaGFzaHRhYmxlX3dhbGtfZXhpdCgmd2Fsayk7DQo+ID4gQ3VyaW91
cyBpZiB5b3UgaGF2ZSBhbnkgcmVhc29uaW5nIGZvciB3aHkgeW91IGNob3NlIHJoYXNodGFibGUg
dnMNCj4gPiBhbm90aGVyIHN0cnVjdHVyZSAoc3VjaCBhcyBhIHNpbXBsZXIgaGFzaCB0YWJsZSBv
ZiBsaW5rZWQgbGlzdHMgb3IgeGFycmF5KS4NCj4gDQo+IA0KPiBUaGUgbXBvcnRzIGNhbiBhcHBl
YXIgYW5kIGRpc2FwcGVhciAoYWx0aG91Z2ggaXQgaXMgbm90IHN1cHBvcnRlZCBieSB0aGUNCj4g
Y29kZSB5ZXQgbm9yIGJ5IGN1cnJlbnQgZmlybXdhcmUvaGFyZHdhcmUpIHNvIHNvbWV0aGluZyBy
ZXNpemFibGUgd2FzDQo+IG5lZWRlZCBmb3Igc3VwcG9ydGluZyB0aGlzIGluIHRoZSBuZWFyIGZ1
dHVyZS4NCj4gDQo+IA0KDQpSaWdodC4gWGFycmF5IGZlZWxzIGxpa2UgaXQgd291bGQgZml0IHRo
ZSBiaWxsIHRvby4gSSBkb24ndCBrbm93IHdoYXQgdGhlIGFkdmFudGFnZS9kaXNhZHZhbnRhZ2Ug
d291bGQgYmUgY29tcGFyZWQgdG8gcmhhc2h0YWJsZS4NCg==
