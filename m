Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF656DF3EE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 13:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDLLl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 07:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDLLlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 07:41:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D19272B8
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681299690; x=1712835690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I1YosRDmxT+f6YAv6u6M3oAym2aRgfISogj4CDIdK4A=;
  b=W90tAbbXFQzROLOzchJe1vdjcq8nbrNJk6yg04TJT5btdNQleip+jqpb
   CeyAIUKY1R/rpUl4tpB00YY3O0l/Odef2JLLZI/BO6lv3yFSb2qtI2fav
   ndAbTRiXrJ8iLHPEW4ogwxG6FN/T2opHtB7UyDz9lH0qJtv6dXxC3be4l
   mPw8CH0JVa9ospqXXjrpp+UFywUnrK5YDdvm0ZBl2Pv7iWMEnuDEH4Gnp
   kjtNie1Y7VKEFCbrpGIgZ006Jk4BdwqeWXqW1/oPL4FgTjvufSvBQW0ny
   T6PCfcglDd+wvofFZoiyC6AjztWnNIdQEq0Nvc2+nnM9IdfL+EGTivejE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="323492651"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="323492651"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="639188499"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="639188499"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 12 Apr 2023 04:40:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 04:40:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 04:40:46 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 04:40:46 -0700
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Wed, 12 Apr
 2023 11:40:43 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 11:40:43 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     "Brouer, Jesper" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "martin.lau@kernel.org" <martin.lau@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Lobakin, Aleksander" <aleksander.lobakin@intel.com>,
        "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH bpf-next V3 5/6] igc: add XDP hints kfuncs for RX
 timestamp
Thread-Topic: [PATCH bpf-next V3 5/6] igc: add XDP hints kfuncs for RX
 timestamp
Thread-Index: AQHZXNeuS7IymFh/rkioE9W/4bejnq8nrPug
Date:   Wed, 12 Apr 2023 11:40:43 +0000
Message-ID: <PH0PR11MB5830A6488CD7AB8AB0C89A42D89B9@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <167950085059.2796265.16405349421776056766.stgit@firesoul>
 <167950089764.2796265.5969267586331535957.stgit@firesoul>
In-Reply-To: <167950089764.2796265.5969267586331535957.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|CO1PR11MB5154:EE_
x-ms-office365-filtering-correlation-id: f92cf011-5cb4-4b29-ae6d-08db3b4abfe9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SKFmDWfgtakT3kUPbX3lP/MxkFGQJ/bS9DyK29inRQ0m5SobrkTEn61vClnzkoz2c2c5f9cm4dZxctFy7e3vDAtvOOp8M7ej5llwweNiz93RxuO5gJcC5ehYvxUm07UAZaDAtWY5l5LHyuyPnmdCiEl+ua4LhwbSRsxAStVtwj+zecfD1QH7idLXhLEJGoEKmuLPDX9D6FCd5uC6LyrACVimTPejqwKWQ/2dH7pv6lxKaYybjSjdE6vi5CnOgu57JVi8ePbjYoN4FZ6fcnwXAw8XPxMnPdetPOF9ebiEdEecuPKySLsLK8l68sbyeD9nGfkvCt9jSMJXxdrBqr5B4a+pFqO/EwzQe8ZyNUmc2aqdqJjL11tkavhhYbEdI98u0bNwBGekhM2nG0OgwgCgulHOIgeZaMBoOj2S8Xc4kg03xOpuSpSbC5DuwU6ZvpZDouiJVhwBH1jizrKgc/iXnZyhqxE+tUPnnDi/YiLgoTf6d6g2G6+F+eTpPVZYiLUXUhfvowUy30TM0HkDpaQP9EiLtgkC9Uff8H98J3R3js88V1MJNVQc4hNG1ZMHN/fQQU9z7Z4ZGnetEppWKCQqJA0sJB82ZQFZqsvgmoWFQ198XMt5r0LH2LaBCbgG21XmB+ak3tZAYYByMQYE25aJFpaWYRpetK+z6VV7vcYEGss=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(86362001)(186003)(33656002)(82960400001)(4326008)(55016003)(41300700001)(66446008)(64756008)(55236004)(9686003)(53546011)(316002)(26005)(6506007)(7696005)(71200400001)(83380400001)(478600001)(110136005)(38070700005)(38100700002)(8936002)(8676002)(2906002)(66556008)(76116006)(66476007)(66946007)(122000001)(52536014)(54906003)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTRlWEdva1FGNWxURHhJU0kyTUkyUWs5QkdvOW04d0FPSXIyV3J2Q3k4SXVK?=
 =?utf-8?B?ai9uOVoweldaODJRYytHUHBmbWdRLzdoNGVORTJ2VlUyb2NuNnU3NlA4ekU3?=
 =?utf-8?B?c3k0NzkzUlZkSDN4NWZBdHhmMThyVGRkNzgyQ1FpMkJCOFRXZW9hd1kwcncw?=
 =?utf-8?B?WDd0WVhST2lrK2lrbW16UVpIWEQwQXBacS9sMGJRVmowblNaTzBPYmpEZjI5?=
 =?utf-8?B?eFhoek9yYXJHdjlhbFJsU04veDBGcXl5SFMzSnJGOE5LSUdBRndiZXBadlcv?=
 =?utf-8?B?ZmNncVZwWFVSdlJwUUdvd01iL3JXNG4zWFpPVGtEenZZcHBvdVh6T1FiamRJ?=
 =?utf-8?B?QWFiTERxaVZqOHNPVlFYZlc0TUIrK3grQlpGNTNLOHhXOGdUNzB6WjJVNy9Q?=
 =?utf-8?B?NFVRZkVKZGlHVzNFVFhLR3JZaVVsSCtMdCtRcFRRRkdLZGtpeDhzUG9KNk1H?=
 =?utf-8?B?TWRacXQvUjNqcVhsZjd0NGs5OUlGUjZtZGxNeXBtSFJuR25LcUhLRTZFVmMy?=
 =?utf-8?B?ditiM3M2MXZlRHBNNlNFbDdFNjhOa2p1SGkyRGNSSGI0ZHBoc0V5Z0s0UFdx?=
 =?utf-8?B?YWFhWjg0QkVCYnFVc1RxOTM1TG53RDlzZmV4cjNPSTVIK3cxYjBTSHlPYlhT?=
 =?utf-8?B?bzF5N0lacyt2V1BPVHV4L2lQZlZEaHFvT0gyM1ZCUW9SZmRyLzVVYTJ2SmhG?=
 =?utf-8?B?RmRXMkRZY3M3RDg2a0p6cm1EMXBYaHJHQzFTeEhIZmNjOXZLZnFzdzVydzJr?=
 =?utf-8?B?Vk04WVdlOFV3dWNtV2xMZk5ZcWpHQVUzR0R1T3hvZEtuT3NWV0o3UTNVU3M2?=
 =?utf-8?B?UllFdGVoek1SZC9EQ2lYTFpLT0dROE13bUdsRFIzZzljTExleFRqOENRdE1w?=
 =?utf-8?B?RThuZ0ZZSkkzK1BkOXdIZXE0WkNObFQxM243Sll0SUN3TE52cXBvcFZlckRi?=
 =?utf-8?B?b0JEWlRubzZaazJVSHhDRk42MitvenZGOVpZWmJGS01UQ0Z6N3Q1R28zdVVi?=
 =?utf-8?B?cmE5QWlsWkFUM091cUs0NGQyMmFMWi9JMzRCc0xGK0VPNEMzTUpRUmQyUG1V?=
 =?utf-8?B?THYrVVZMSFRwdFJPbXlXQXV4NlhOR0RmS2JWYUh2RUNpeE9KcDkrVUZBdTF0?=
 =?utf-8?B?ZGJldGE3elVqKzNzTnl2K1RwdmRRTGY0YTV2eE5xd1J3em00ZHRqMkM4Ykls?=
 =?utf-8?B?TCtzUExyL0tGenVFcitOOTMwTXNGTmpUNFlVaFFaK2dyR3lQRFdsd2VGK3B6?=
 =?utf-8?B?am9VeU53QlV5bW5DRUJXcm9TRVVCODVZNE9MaVhucjN6QVZhbWhvZFd0dnRh?=
 =?utf-8?B?R1BvTDMzTlA0YXJNUFkxVGhEay85UXd6VkZTUy8wZlcyRGlVZks1ZVkva3JP?=
 =?utf-8?B?ZzQ2aUpJWXJaYWc4K3YzWXBQelczTWQ3bEhwRmhjaWNEWU1XZ3ovUTQvNGlt?=
 =?utf-8?B?RUVIZ05Bb3lzR1BsR1NNUmpteHlJNXdDYWN1LzFrV0tkcE54NkJCUERRWDdZ?=
 =?utf-8?B?eEMySDBkNzVFb2ZpRFQrdFl2Ni85WmdzUWhLb2YxbEhpS2tGNVhEVlU1TXk4?=
 =?utf-8?B?VStuZDJWamFiT1hwalZmZDV5QWV4SzF1YVBHVjNMYmJmeGMwOUUrd3VhMW54?=
 =?utf-8?B?WGZ2UDBCVXhaakFPK2pETjhrY3AvNUlKRjF2MkZ0eUJwT1k4K3FZQjFCS2Vk?=
 =?utf-8?B?a0w4dmcxWFY3UEFyajFDYmRyMStrdDByUHhoL2Q5a3IxdDVxZkZCakE0WjVv?=
 =?utf-8?B?R2xSbVBFaEdncExZUTZwYmUrcWZlbTk4emNwaXdFWVFvb21QcFJrbjlEWllj?=
 =?utf-8?B?WVhLamtyS0RCY2t0S0hra2xFb3lXLzE3ekVFVkxscnpMR1dWWmh5NFYzekJB?=
 =?utf-8?B?UmRtbFhZNlBwTlRVS3hyVjN6OHJBUzM1VjVNQXlGbFduTkp5ZXMrNnBLaWQ0?=
 =?utf-8?B?VUoyTmtoazV1WHJlbFkzdnFnOXZkcDR0VUJRbHlIVGdlZ1ZUOVdscHltMVlC?=
 =?utf-8?B?RG1LazJKWVFtTUtUUFV5Z3pDdGNHclYyUUNqQTNib3FVdGQ5WFJMcVNrZDFP?=
 =?utf-8?B?Qi9GUG9ReTQwN2hhcCthbmRVZ1Z6QUJvZ2NOTjlNRVlCM0pZSERCT3pTRlNW?=
 =?utf-8?Q?QB4VCpEFnfOGkodDnIcyccLB7?=
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDwBfBBkdY0CkcxbgEXPpIrHMVnm0EWL9rFaU/v4yjEZNJOnWLNw9FmuOzuioIk6kQkrZgU0ttg2PxKreF01uGto5wa0724c0ytwWTf6KJuVfbH1sQ/LTCDFTwzaeEUYMfNvzznJVSkYolvXWctvK374UibT3t0HuQt7vB2VXaGrZDdwd/wpnW1+1eEtfOvzBQCkDR3w0W30ZTom/XcU0o36w44nAkqXxBcElqulwqw7vqToLpz3+6qjIxRWGasoe/kO2n0risPVDx0GT9z0tDlzAyPMMNmkII0xD4BNizeLyimiZFoyghgDtGJFVrjT1dNkgnpUsM6X3S6Que8SSA==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cuvxz5A9Hm8O0n8j4UH1u4n4wzypypfySdaVuw2gEoU=;
 b=YJypp4XXRmCpFGPLWzbRwlxkWoIZs1Gy/KC+4Dynkk4cSNJG0AeObI+YBA/pLtehQv8FlUV4psE+jqVFi4Wkh6R/Ipbl4Bt7gL/Zl+dILQX4qhW73nxYe687cOnwdHOPpjQZFgLT40wvPDWPKmDY/0mDM0eMRR6WkXakgMkPDFjLau/vHUJJPiYiSGXCOj1PQc+r7p+n2xbGYUltkuheW1I4fDXo7VtI3YT5Rl7kRobbr5NLY6tCQ1OQ+mgJjSRh5lclLeVM++lVlan6XAK2TNofxxrNDdXBq7F3W0eAHGsLzVdeTa4o/g8n8Bo6ZPNoDPaPbOdN0YpF6cGYUCmaKg==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: PH0PR11MB5830.namprd11.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: f92cf011-5cb4-4b29-ae6d-08db3b4abfe9
x-ms-exchange-crosstenant-originalarrivaltime: 12 Apr 2023 11:40:43.6303 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: vEWzd9YZ8iRXPwkr/kLq3eFLUezAzWNbQfUZxJxTBVds0O6jYiuQfOiFxG9q/GIpPSjvR/+tqlqC/5E1UQe4eCl127Dt1aA34kkJQF/YpHE=
x-ms-exchange-transport-crosstenantheadersstamped: CO1PR11MB5154
x-originatororg: intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1cnNkYXksIE1hcmNoIDIzLCAyMDIzIDEyOjAyIEFNICwgSmVzcGVyIERhbmdhYXJkIEJy
b3VlciA8YnJvdWVyQHJlZGhhdC5jb20+IHdyb3RlOg0KPlRoZSBOSUMgaGFyZHdhcmUgUlggdGlt
ZXN0YW1waW5nIG1lY2hhbmlzbSBhZGRzIGFuIG9wdGlvbmFsIHRhaWxvcmVkIGhlYWRlcg0KPmJl
Zm9yZSB0aGUgTUFDIGhlYWRlciBjb250YWluaW5nIHBhY2tldCByZWNlcHRpb24gdGltZS4gT3B0
aW9uYWwgZGVwZW5kaW5nIG9uDQo+UlggZGVzY3JpcHRvciBUU0lQIHN0YXR1cyBiaXQgKElHQ19S
WERBRFZfU1RBVF9UU0lQKS4gSW4gY2FzZSB0aGlzIGJpdCBpcyBzZXQNCj5kcml2ZXIgZG9lcyBv
ZmZzZXQgYWRqdXN0bWVudHMgdG8gcGFja2V0IGRhdGEgc3RhcnQgYW5kIGV4dHJhY3RzIHRoZSB0
aW1lc3RhbXAuDQo+DQo+VGhlIHRpbWVzdGFtcCBuZWVkIHRvIGJlIGV4dHJhY3RlZCBiZWZvcmUg
aW52b2tpbmcgdGhlIFhEUCBicGZfcHJvZywgYmVjYXVzZQ0KPnRoaXMgYXJlYSBqdXN0IGJlZm9y
ZSB0aGUgcGFja2V0IGlzIGFsc28gYWNjZXNzaWJsZSBieSBYRFAgdmlhIGRhdGFfbWV0YSBjb250
ZXh0DQo+cG9pbnRlciAoYW5kIGhlbHBlciBicGZfeGRwX2FkanVzdF9tZXRhKS4gVGh1cywgYW4g
WERQIGJwZl9wcm9nIGNhbiBwb3RlbnRpYWxseQ0KPm92ZXJ3cml0ZSB0aGlzIGFuZCBjb3JydXB0
IGRhdGEgdGhhdCB3ZSB3YW50IHRvIGV4dHJhY3Qgd2l0aCB0aGUgbmV3IGtmdW5jIGZvcg0KPnJl
YWRpbmcgdGhlIHRpbWVzdGFtcC4NCj4NCj5TaWduZWQtb2ZmLWJ5OiBKZXNwZXIgRGFuZ2FhcmQg
QnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4tLS0NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWdjL2lnYy5oICAgICAgfCAgICAxICsNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaWdjL2lnY19tYWluLmMgfCAgIDIwICsrKysrKysrKysrKysrKysrKysrDQo+IDIgZmlsZXMg
Y2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKQ0KPg0KPmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pZ2MvaWdjLmgNCj5iL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ln
Yy9pZ2MuaA0KPmluZGV4IGJjNjdhNTJlNDdlOC4uMjk5NDE3MzRmMWExIDEwMDY0NA0KPi0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2MuaA0KPisrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2lnYy9pZ2MuaA0KPkBAIC01MDMsNiArNTAzLDcgQEAgc3RydWN0IGln
Y19yeF9idWZmZXIgeyAgc3RydWN0IGlnY194ZHBfYnVmZiB7DQo+ICAgICAgIHN0cnVjdCB4ZHBf
YnVmZiB4ZHA7DQo+ICAgICAgIHVuaW9uIGlnY19hZHZfcnhfZGVzYyAqcnhfZGVzYzsNCj4rICAg
ICAga3RpbWVfdCByeF90czsgLyogZGF0YSBpbmRpY2F0aW9uIGJpdCBJR0NfUlhEQURWX1NUQVRf
VFNJUCAqLw0KPiB9Ow0KPg0KPiBzdHJ1Y3QgaWdjX3FfdmVjdG9yIHsNCj5kaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19tYWluLmMNCj5iL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jDQo+aW5kZXggYTc4ZDdlNmJjZmQ2Li5mNjYy
ODVjODU0NDQgMTAwNjQ0DQo+LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2ln
Y19tYWluLmMNCj4rKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4u
Yw0KPkBAIC0yNTM5LDYgKzI1MzksNyBAQCBzdGF0aWMgaW50IGlnY19jbGVhbl9yeF9pcnEoc3Ry
dWN0IGlnY19xX3ZlY3Rvcg0KPipxX3ZlY3RvciwgY29uc3QgaW50IGJ1ZGdldCkNCj4gICAgICAg
ICAgICAgICBpZiAoaWdjX3Rlc3Rfc3RhdGVycihyeF9kZXNjLCBJR0NfUlhEQURWX1NUQVRfVFNJ
UCkpIHsNCj4gICAgICAgICAgICAgICAgICAgICAgIHRpbWVzdGFtcCA9IGlnY19wdHBfcnhfcGt0
c3RhbXAocV92ZWN0b3ItPmFkYXB0ZXIsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHBrdGJ1Zik7DQo+KyAgICAgICAgICAgICAgICAgICAg
ICBjdHgucnhfdHMgPSB0aW1lc3RhbXA7DQo+ICAgICAgICAgICAgICAgICAgICAgICBwa3Rfb2Zm
c2V0ID0gSUdDX1RTX0hEUl9MRU47DQo+ICAgICAgICAgICAgICAgICAgICAgICBzaXplIC09IElH
Q19UU19IRFJfTEVOOw0KPiAgICAgICAgICAgICAgIH0NCj5AQCAtMjcyNyw2ICsyNzI4LDcgQEAg
c3RhdGljIGludCBpZ2NfY2xlYW5fcnhfaXJxX3pjKHN0cnVjdCBpZ2NfcV92ZWN0b3INCj4qcV92
ZWN0b3IsIGNvbnN0IGludCBidWRnZXQpDQo+ICAgICAgICAgICAgICAgaWYgKGlnY190ZXN0X3N0
YXRlcnIoZGVzYywgSUdDX1JYREFEVl9TVEFUX1RTSVApKSB7DQo+ICAgICAgICAgICAgICAgICAg
ICAgICB0aW1lc3RhbXAgPSBpZ2NfcHRwX3J4X3BrdHN0YW1wKHFfdmVjdG9yLT5hZGFwdGVyLA0K
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBi
aS0+eGRwLT5kYXRhKTsNCj4rICAgICAgICAgICAgICAgICAgICAgIGN0eC0+cnhfdHMgPSB0aW1l
c3RhbXA7DQo+DQo+ICAgICAgICAgICAgICAgICAgICAgICBiaS0+eGRwLT5kYXRhICs9IElHQ19U
U19IRFJfTEVOOw0KPg0KPkBAIC02NDgxLDYgKzY0ODMsMjMgQEAgdTMyIGlnY19yZDMyKHN0cnVj
dCBpZ2NfaHcgKmh3LCB1MzIgcmVnKQ0KPiAgICAgICByZXR1cm4gdmFsdWU7DQo+IH0NCj4NCj4r
c3RhdGljIGludCBpZ2NfeGRwX3J4X3RpbWVzdGFtcChjb25zdCBzdHJ1Y3QgeGRwX21kICpfY3R4
LCB1NjQNCj4rKnRpbWVzdGFtcCkgew0KPisgICAgICBjb25zdCBzdHJ1Y3QgaWdjX3hkcF9idWZm
ICpjdHggPSAodm9pZCAqKV9jdHg7DQo+Kw0KPisgICAgICBpZiAoaWdjX3Rlc3Rfc3RhdGVycihj
dHgtPnJ4X2Rlc2MsIElHQ19SWERBRFZfU1RBVF9UU0lQKSkgew0KPisgICAgICAgICAgICAgICp0
aW1lc3RhbXAgPSBjdHgtPnJ4X3RzOw0KPisNCj4rICAgICAgICAgICAgICByZXR1cm4gMDsNCj4r
ICAgICAgfQ0KPisNCj4rICAgICAgcmV0dXJuIC1FTk9EQVRBOw0KPit9DQo+Kw0KPitjb25zdCBz
dHJ1Y3QgeGRwX21ldGFkYXRhX29wcyBpZ2NfeGRwX21ldGFkYXRhX29wcyA9IHsNCg0KSGkgSmVz
cGVyLA0KDQpTaW5jZSBpZ2NfeGRwX21ldGFkYXRhX29wcyBpcyB1c2VkIG9uIGlnY19tYWluLmMg
b25seSwgd2UgY2FuIG1ha2UNCml0IHN0YXRpYyB0byBhdm9pZCBmb2xsb3dpbmcgYnVpbGQgd2Fy
bmluZzoNCg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19tYWluLmM6NjQ5OToz
MTogd2FybmluZzogc3ltYm9sDQonaWdjX3hkcF9tZXRhZGF0YV9vcHMnIHdhcyBub3QgZGVjbGFy
ZWQuIFNob3VsZCBpdCBiZSBzdGF0aWM/DQoNClRoYW5rcyAmIFJlZ2FyZHMNClNpYW5nDQoNCj4r
ICAgICAgLnhtb19yeF90aW1lc3RhbXAgICAgICAgICAgICAgICA9IGlnY194ZHBfcnhfdGltZXN0
YW1wLA0KPit9Ow0KPisNCj4gLyoqDQo+ICAqIGlnY19wcm9iZSAtIERldmljZSBJbml0aWFsaXph
dGlvbiBSb3V0aW5lDQo+ICAqIEBwZGV2OiBQQ0kgZGV2aWNlIGluZm9ybWF0aW9uIHN0cnVjdCBA
QCAtNjU1NCw2ICs2NTczLDcgQEAgc3RhdGljIGludA0KPmlnY19wcm9iZShzdHJ1Y3QgcGNpX2Rl
diAqcGRldiwNCj4gICAgICAgaHctPmh3X2FkZHIgPSBhZGFwdGVyLT5pb19hZGRyOw0KPg0KPiAg
ICAgICBuZXRkZXYtPm5ldGRldl9vcHMgPSAmaWdjX25ldGRldl9vcHM7DQo+KyAgICAgIG5ldGRl
di0+eGRwX21ldGFkYXRhX29wcyA9ICZpZ2NfeGRwX21ldGFkYXRhX29wczsNCj4gICAgICAgaWdj
X2V0aHRvb2xfc2V0X29wcyhuZXRkZXYpOw0KPiAgICAgICBuZXRkZXYtPndhdGNoZG9nX3RpbWVv
ID0gNSAqIEhaOw0KPg0KPg0KDQo=
