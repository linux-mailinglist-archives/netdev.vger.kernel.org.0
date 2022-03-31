Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE074EE231
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 21:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241074AbiCaUBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 16:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiCaUBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 16:01:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B6215469A;
        Thu, 31 Mar 2022 12:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648756757; x=1680292757;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NDBX/O2RS4R/P5buebxYrPcrJNIe9vnx8EqQO8frmM0=;
  b=SAbKI+0TWCmMf0glud0Lri2YOEP0Tj1/xaXP5X0eoAjOlM//0YN4ux0y
   N87zoON9gsULPsT5vVZxalRCh9Yx2/XDbR2MLJ7iL393tHS+Hl0zzCtDG
   Kv9/Ul+t8gwrZnPAtjbuMhzSz5VthqAYtp/Ap7SEUNPEkvwBsTql3/NjT
   bKED93h9YmXdUphnOSCzJmDGKiUBLEjz0TWpJC8CeNFM8OkpcsKblLr+a
   SUy5pNYb7QnH18MckeilYz8msG3SKpQcXarkO/EowZ1vW2YdNGkVidAG7
   d+V3sTbJJ84MmU6WgkTc3QGJE1aOK9MBc/SdG/c4Tbc6XRnGYXTRV09da
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="259652998"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="259652998"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 12:59:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="655039995"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 31 Mar 2022 12:59:16 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 12:59:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 31 Mar 2022 12:59:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 31 Mar 2022 12:59:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbT5we0OrGqxrOnpObiv2Q8BJydx95BEMpKxT9CGChnMyZkkBaUtPt61MwAYrtAQUqX8zSNpIG6GXU+Y/lYQw87Y6pxCD+7A206kgruCbTpTVv2JsvVffpDzRJ/BUHQoSwFJYgYcVYMOK48QdmZ2MnoQKB7TrCefQkQXvFx5eYpabtwgPuxbFj5O8kFh/RdtxYB82N+6wsvdldtLQK/ewyRJRNNMMdgcwsELf65eJpSR3Zne17dgpogS5kMfd+yeZNLlCj5StPkoPXLKbAE9OBDkOm7ybY0ZKMFD2MEFfSVTtCzxYuAQmy+GbrdiYGPP3WBzSPUP9Rr7iSEG2QWYGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDBX/O2RS4R/P5buebxYrPcrJNIe9vnx8EqQO8frmM0=;
 b=BKXpQomJ5fO0RjFI/aA94AA6aY3MrwHB+2V/wYLe9YxsV1HJjrDrYETDezWO3LwQ/odlnT0efMJdsUQ1nIzekJ/wbAxQc/nPzxQqjzGopCv0W+pNd0/Ji5eL8LZF+bnqrH2Jql3gLk6+jxdHqKQOMWJa0xCazaO1tgZvrfKbPaW+nePUSR5vTtrCbg3kcoNmvNEro/xu35vr4aT5gOqD5o2h7fvjTSih8/qPlZh4i9GFp0amkXTI7wWU8ECEFsX5wrET6S4hZ7nBCO208ed+GRGlAfUKFaWWS9Mm1q/8h79uKi9XNVm/rCctld850w4UPTIQHBcauTNOCAxBKFZSeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BYAPR11MB2549.namprd11.prod.outlook.com (2603:10b6:a02:c4::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Thu, 31 Mar
 2022 19:59:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8%8]) with mapi id 15.20.5102.025; Thu, 31 Mar 2022
 19:59:12 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Brett Creeley <brett@pensando.io>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt <mschmidt@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        poros <poros@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
 ice_vc_process_vf_msg()
Thread-Topic: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
 ice_vc_process_vf_msg()
Thread-Index: AQHYRO057BJtvqZxeEyUMOJlKAIrPqzZeKaAgAAA0QCAADaEgIAAOT6g
Date:   Thu, 31 Mar 2022 19:59:11 +0000
Message-ID: <CO1PR11MB5089888D13802251F6830A8ED6E19@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220331105005.2580771-1-ivecera@redhat.com>
 <YkWpNVXYEBo/u3dm@boxer> <YkWp5JJ9Sp6UCTw7@boxer>
 <CAFWUkrTzE87bduD431nu11biHi78XFitUWQfiwcU6_4UPU9FBg@mail.gmail.com>
In-Reply-To: <CAFWUkrTzE87bduD431nu11biHi78XFitUWQfiwcU6_4UPU9FBg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9010273f-aea0-487d-43c3-08da1350ecfc
x-ms-traffictypediagnostic: BYAPR11MB2549:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB254938885D748351AD3E283AD6E19@BYAPR11MB2549.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qt9WF0Sv+CDs/jZR6wd1e2ySi4w0zwsIKh2HBH7Z7nluf1J9dBqa/DiSfn0WmDiwi07aHRJH6c+a41b5t9AZscILl/170UWRZtEdnbTn325O4l3a4RgNll3KKJ6pYRYtmeNfPFUtB0vDKaiqrooeiUyMyU0wpcrAImgHwumrYjXImg21pMgRdKAaV9YxB/fok75jWHlpDCCgsTGcM7rFWSgpQLsdeKgvpiHfAtWXSgWgoGehdWgnkCwsxX0mJueQFSOLGDIkwmngtQ3i7M+AIkvLKpndtFqoS7Ylpp33ePHltn4YySdPCk8DBrgl33fn3RTrPGzGotNI0sbnncPNoID7VdJtxnr0GxIU6wLjplyhfH2I59nIEk7L4zwFv3Wv3jwk0fT51+Czw9W+TGvz2q9hGkUZ+7ma5z65CpfFgwu6DZlTndv/Ar1lcQgx0ZZclRLTU9iHRmoMw2E7itLsmIaBywDicpBRM9By1aNoFn+6pMeByCV/tS6PxfB/cEJme1orRcnQLCsv6AS98P4pUWknBgKXonjRRcUZSKlfRce2NsyPeXAF/Yw0s3ebTPOfbx8OdbL36lR9cX2oNHPAynPKDghAirBIUP8tZdZ2E91dzPbFm7lMdd0s+5+4X215kFG/JKrP1zfvJhI6QB7UDRjMPu7pvewIfi6wAZOaJL3HMt4KlfT/itLtdccA5jozFIkw7QvaizD5EiP/vEBzOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(83380400001)(26005)(186003)(4326008)(55016003)(33656002)(52536014)(7416002)(8936002)(5660300002)(2906002)(6636002)(66946007)(66556008)(316002)(71200400001)(82960400001)(9686003)(66476007)(7696005)(6506007)(54906003)(64756008)(66446008)(53546011)(110136005)(8676002)(76116006)(38100700002)(38070700005)(86362001)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXJVcmR6b1AvQ3hKYWF2b2NKMm8wcGk1NWk4cDY2ZjBBY0c0N2gzOXd2dFJG?=
 =?utf-8?B?dVFMdjFBbXhDWUZEcmJlays1bkpNeDYxeHVscUhzWERnQys3ZHJkWjVZdzhj?=
 =?utf-8?B?VGl2OEtUb01pR3Rsd3ZnZWQzdlZkRjRQTTh1Ni9VNEJqaDlWNWJFc0l3bTZo?=
 =?utf-8?B?MnFuQndva2NmNmVjeFJnY1RmaGhtYWxQZW5IcFN2dTNSQkNpdHRnYm5Yb1NU?=
 =?utf-8?B?RVlrSHZRWFhEK0RxWjR0M3lEMlZVbUJINXZ1aE8zUnJEV211Rjhxa1Bmay83?=
 =?utf-8?B?elhoZVVkSmNxeFQ5TGxyT0xMWUxKZ1JrWUJVMFB4Q3FIZWRHU1Z0TzdCeDlw?=
 =?utf-8?B?bVBkM0xHdCtBVElCWFBGUW5DMEhsM2dyc2RydENyd1pGbDNVSFIwUzdZRTdX?=
 =?utf-8?B?MVEraDd3S2k2K29oSVA5VSs2L0pJUWNOenl4NDhWKy9EWE1DcE5CWGdEYmRK?=
 =?utf-8?B?NjA1YlN5anlqSTFSR2laU0xlY3EwbURCRzU1dFFHdFhHTVBEcTQ0UVgyTm1B?=
 =?utf-8?B?Z29lbXROR28ybzNlS1VqbXluamNha3h4ZmdHT0FVYXdvQnR3V051cy9WS0wz?=
 =?utf-8?B?ekFDNGtydE1vSkY4M0JaTDBUWGtqWjRFUFphN3hEa1ppdEt5WlVDaytSbTFU?=
 =?utf-8?B?Rkx0cmcyU1FmSEc4aEFGTzFObEJlM2YwVnVGQkFKYVFMMlFjL1h5RnBPQWtT?=
 =?utf-8?B?NjV3UFNJcFN2VlJ3ZjR5bG15cDlxME1ySURpR3p6QkRsZGJmVEVFRWEvclJW?=
 =?utf-8?B?NmtJcVlWSXh3U0pBWnNpcGxOeXgvaWU0aFFOUFhHVlp1Tk8yYW1VWG4xaUFP?=
 =?utf-8?B?dFpBc3Jsb2JwQ25EL0RtSkVGQnJIM29VNjU2QWpodVI2NlNkclkvTU0xUzV6?=
 =?utf-8?B?RFlMNWQ2NE5NWERnRjh3VUcvOXRVRVRTUTcwU29DNW1SdTZkWnhMQ0d0a3hH?=
 =?utf-8?B?T0xGNzE1TUlJMTE4M3NZdks2MDBjQlNvV0RiNmFkQllrRi9wM214SW1JNDRo?=
 =?utf-8?B?eE1LN2ZpdW05czNBSWJDOWVVVlhrRFdHZHZrbCtxMERmWnFhbjlLcHA3QVRP?=
 =?utf-8?B?Wmp5ajFmaFhCV2wxUkdDN24rWTEzbUhvY2pucW5qVVloRnJWYTVkcjFWMGhZ?=
 =?utf-8?B?VDJMMFQ4TysrSzNOQkZrb3RwV2Y2UW1xS0kzbG9oYTN6SWVaS0FiUGswWmR5?=
 =?utf-8?B?NXI3dDgyWlZhSEhZLzhXNzBrL0lUUkdjZjhpQ1NDRk9oSFhETFN4T2FvN1Qv?=
 =?utf-8?B?ZTU0SGt3eGhDTHM0V1kwbUhuWWR3OGdiRmdDdFpJbUpJR2RidjdvTUFsZjNm?=
 =?utf-8?B?bGltRnBjOG8rRWJnNzBiWXZxbmMwYWV2Tm9Vcnh5WmNPZ1ZFTElzTERuRUVV?=
 =?utf-8?B?NDlaeUt4cjJiNDJqZVlmTi9sVTdyYzUyUGQzekJjVTNVUENxZUJaVndNd3Nn?=
 =?utf-8?B?U25tLzNTMXhOYXZNelkrazIvTXZ3ek1PV05xVnhPak1HZXJVMXdEY2c4N25n?=
 =?utf-8?B?Q001QVVGSW9SUUt1WDhKcWY4eUhKbTFpUHNLc1BDYXZoa1E0MXA3dEdFOFoy?=
 =?utf-8?B?Y01IWXB5bFp1TVprUmRXUU9qNGpXaDEydHdkYXUyRWNIY0JEeGZkWVY3dm1m?=
 =?utf-8?B?dGpRYTVuU3BhR0MvVnRVVzBKUHl6TWNINDZPcUlpRW5Qd2lrMktWaXlYL3ZE?=
 =?utf-8?B?aVhsSjBZbk1kRmhTNmd0YnZRNU56djVRNFhhOW9PeUN6UnZpVUMwTDNJaGUz?=
 =?utf-8?B?azFSTnJnN0drcnhTUlpNNHg0SHkyMWZjaUI5NnhCZ0hwdjVxbU1wbTZIRksx?=
 =?utf-8?B?alRKSTFWZVk2c1JxYS9lYkJFK2oraGhBd3E3YWNzMEpJVktaWW9CN1gvcjFk?=
 =?utf-8?B?MWxVSTIvd1dkT3haREVQNWY3NURDS2ZtRzBNMm1Kc2l4clhqWFBmVVMzazF0?=
 =?utf-8?B?MWRjQ3ZCbFh1Y1dDWk5VVEp1bGl3cWJCeTMxbFZ0ZUk5Wk1sdFFSTzlEL3A5?=
 =?utf-8?B?UVFXWkphREE5TXhkZURjTnJzM1pYZ0pyVlZxdDdSandCWExXeGdzenFvNTBE?=
 =?utf-8?B?L2NvOW1rZzZ0dENKNERIVzg2UGhvckhFaGFwNjFGNVBKTWlWbzFpeVdyNUQz?=
 =?utf-8?B?aXhOdVI2UnowdmdEbGM3OVZreUtzbFJYK0U1eGRMZUdjOE9nU1Z5dkhOTTdJ?=
 =?utf-8?B?MDVrMHFLT1BYNWhhbnhUc2pPcmphRVhRSlBPbklqZEZJekgrQ256SVZPRlV0?=
 =?utf-8?B?aGFrSGNXMlZtOXRLTHpXQldTMUdCT3pnVXBjZnkyRURJVnpFN1A5NFVsMEll?=
 =?utf-8?B?ejdyckUwTzJHRjZRb2QydEtqcGJxOVZvMURzQld4MWYwZHJRM1dLdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9010273f-aea0-487d-43c3-08da1350ecfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 19:59:11.9207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b9140jOOG+CXLyNbdVq1yEZTr6rW8c7t6X7neARabj6TfYWdH/Lnn/f29N/rXFd1DYLfIi94M7N/W9YH+KV2jpV+PtmMZxJuWP+CYsnIkcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2549
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnJldHQgQ3JlZWxleSA8
YnJldHRAcGVuc2FuZG8uaW8+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAzMSwgMjAyMiA5OjMz
IEFNDQo+IFRvOiBGaWphbGtvd3NraSwgTWFjaWVqIDxtYWNpZWouZmlqYWxrb3dza2lAaW50ZWwu
Y29tPg0KPiBDYzogaXZlY2VyYSA8aXZlY2VyYUByZWRoYXQuY29tPjsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgbW9kZXJhdGVkDQo+IGxpc3Q6SU5URUwgRVRIRVJORVQgRFJJVkVSUyA8aW50ZWwt
d2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc+OyBtc2NobWlkdA0KPiA8bXNjaG1pZHRAcmVkaGF0
LmNvbT47IG9wZW4gbGlzdCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IHBvcm9zDQo+
IDxwb3Jvc0ByZWRoYXQuY29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBh
b2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldD47IEtlbGxlciwgSmFjb2IgRQ0KPiA8amFjb2IuZS5rZWxsZXJAaW50ZWwu
Y29tPg0KPiBTdWJqZWN0OiBSZTogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIIG5ldF0gaWNlOiBG
aXggaW5jb3JyZWN0IGxvY2tpbmcgaW4NCj4gaWNlX3ZjX3Byb2Nlc3NfdmZfbXNnKCkNCj4gDQo+
IE9uIFRodSwgTWFyIDMxLCAyMDIyIGF0IDY6MTcgQU0gTWFjaWVqIEZpamFsa293c2tpDQo+IDxt
YWNpZWouZmlqYWxrb3dza2lAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIFRodSwgTWFy
IDMxLCAyMDIyIGF0IDAzOjE0OjMyUE0gKzAyMDAsIE1hY2llaiBGaWphbGtvd3NraSB3cm90ZToN
Cj4gPiA+IE9uIFRodSwgTWFyIDMxLCAyMDIyIGF0IDEyOjUwOjA0UE0gKzAyMDAsIEl2YW4gVmVj
ZXJhIHdyb3RlOg0KPiA+ID4gPiBVc2FnZSBvZiBtdXRleF90cnlsb2NrKCkgaW4gaWNlX3ZjX3By
b2Nlc3NfdmZfbXNnKCkgaXMgaW5jb3JyZWN0DQo+ID4gPiA+IGJlY2F1c2UgbWVzc2FnZSBzZW50
IGZyb20gVkYgaXMgaWdub3JlZCBhbmQgbmV2ZXIgcHJvY2Vzc2VkLg0KPiA+ID4gPg0KPiA+ID4g
PiBVc2UgbXV0ZXhfbG9jaygpIGluc3RlYWQgdG8gZml4IHRoZSBpc3N1ZS4gSXQgaXMgc2FmZSBi
ZWNhdXNlIHRoaXMNCj4gPiA+DQo+ID4gPiBXZSBuZWVkIHRvIGtub3cgd2hhdCBpcyAqdGhlKiBp
c3N1ZSBpbiB0aGUgZmlyc3QgcGxhY2UuDQo+ID4gPiBDb3VsZCB5b3UgcGxlYXNlIHByb3ZpZGUg
bW9yZSBjb250ZXh0IHdoYXQgaXMgYmVpbmcgZml4ZWQgdG8gdGhlIHJlYWRlcnMNCj4gPiA+IHRo
YXQgZG9uJ3QgaGF2ZSBhbiBhY2Nlc3MgdG8gYnVnemlsbGE/DQo+ID4gPg0KPiA+ID4gU3BlY2lm
aWNhbGx5LCB3aGF0IGlzIHRoZSBjYXNlIHRoYXQgaWdub3JpbmcgYSBwYXJ0aWN1bGFyIG1lc3Nh
Z2Ugd2hlbg0KPiA+ID4gbXV0ZXggaXMgYWxyZWFkeSBoZWxkIGlzIGEgYnJva2VuIGJlaGF2aW9y
Pw0KPiA+DQo+ID4gVWggb2gsIGxldCdzDQo+ID4gQ0M6IEJyZXR0IENyZWVsZXkgPGJyZXR0QHBl
bnNhbmRvLmlvPg0KPg0KDQpUaGFua3MgZm9yIHJlc3BvbmRpbmcsIEJyZXR0ISA6KQ0KIA0KPiBN
eSBjb25jZXJuIGhlcmUgaXMgdGhhdCB3ZSBkb24ndCB3YW50IHRvIGhhbmRsZSBtZXNzYWdlcw0K
PiBmcm9tIHRoZSBjb250ZXh0IG9mIHRoZSAicHJldmlvdXMiIFZGIGNvbmZpZ3VyYXRpb24gaWYg
dGhhdA0KPiBtYWtlcyBzZW5zZS4NCj4gDQoNCk1ha2VzIHNlbnNlLiBQZXJoYXBzIHdlIG5lZWQg
dG8gZG8gc29tZSBzb3J0IG9mICJjbGVhciB0aGUgZXhpc3RpbmcgbWVzc2FnZSBxdWV1ZSIgd2hl
biB3ZSBpbml0aWF0ZSBhIHJlc2V0Pw0KDQo+IEl0IG1pZ2h0IGJlIGJlc3QgdG8gZ3JhYiB0aGUg
Y2ZnX2xvY2sgYmVmb3JlIGRvaW5nIGFueQ0KPiBtZXNzYWdlL1ZGIHZhbGlkYXRpbmcgaW4gaWNl
X3ZjX3Byb2Nlc3NfdmZfbXNnKCkgdG8NCj4gbWFrZSBzdXJlIGFsbCBvZiB0aGUgY2hlY2tzIGFy
ZSBkb25lIHVuZGVyIHRoZSBjZmdfbG9jay4NCj4gDQoNClllcyB0aGF0IHNlZW1zIGxpa2UgaXQg
c2hvdWxkIGJlIGRvbmUuDQoNCj4gQ0MnaW5nIEpha2Ugc28gaGUgY2FuIHByb3ZpZGUgc29tZSBp
bnB1dCBhcw0KPiB3ZWxsLg0KDQpUaGFua3MsDQpKYWtlDQogDQoNCg==
