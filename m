Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9125D574897
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbiGNJWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbiGNJWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:22:34 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4452413D7D;
        Thu, 14 Jul 2022 02:20:28 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E6xW7S012172;
        Thu, 14 Jul 2022 02:20:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hhx/Iq/TnU0dsGFqGMVi7O5cOaXldowriQ04/T8OjGc=;
 b=PY+S6ewwPv70rtdWFu71HMs8aUmsinddkgiWLlt68CI8muIB0ruAtArBkci3W2EXAmJH
 7bDAwVDyy6fjj2jRbS0E1HE78ygI0jMTAPA1uu8+tyTMa9IElAVo225h5zOb4iBNVznq
 EH+G188SDnEv3N0Nna9cLDc29p2VvAbjFss= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5g1w1h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 02:20:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgEUYXq/XzGse1JQn/l46bkoAOyvZK1QY6HGeePhgl9+ogGeZMeRHHImgi/+4cOjPglK4OPFKII71CClnFYiNDRoaxM6t7MjbT2iJSujnyXkEgI1TfKMeeIweVo86RBQKYkY6lXCthRJDEJRjGGJPKerASFBgBCGEu2d2z8sjWxNIds6lOPm7zdH1c5qRJBQpYFt0s2507494BoCiLazkYnkrdNoKuXZBy6jwY88gBhaCYsMZoktZEv8Llk+XYTafwK58p2OLi6ioih+z4kw0fNq9VgIw2Z+mg9a/5QiS34cWYuq8YuQOfIju1vk9fxeKcQ4rig5pWAUfeVDXy41YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhx/Iq/TnU0dsGFqGMVi7O5cOaXldowriQ04/T8OjGc=;
 b=iXFGq69YK0lW1v73C2/jd6LxdiXR6i101rZdEGzTxF3yak8ExLdhFO7Ok6/CSCda9rNJCHi6GP19Wn3AguIN+sZKffT5bL+X7ez1r9IFHtgo8TjTCF1yMxAQkh/S2IjXeroHjSl6p1T0VR0fmyy/TkrPM/Lblrg/4g2BXsh+qGP5rnXdDK+zcoMSsLKTsNdtkh2yA+eNruXG3w2p/02otvq7ZEUD0TgJnCdLj4hzwfSr/L9ztwIinpywwLcP3vgRdI0ZlRcR8zFvLy7eBRj+pLzB2mRFDWyKyKZVn+m5OwZwLhwGpRhSGYTRdgCH3rCrolPzpp8E76lLJjIZr6YE8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SJ0PR15MB4392.namprd15.prod.outlook.com (2603:10b6:a03:371::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Thu, 14 Jul
 2022 09:20:24 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504%5]) with mapi id 15.20.5417.026; Thu, 14 Jul 2022
 09:20:24 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 for-next 3/3] io_uring: support multishot in recvmsg
Thread-Topic: [PATCH v2 for-next 3/3] io_uring: support multishot in recvmsg
Thread-Index: AQHYlpHmWVOaNfmJ10y+12UCzYe7e619fm0AgAAaU4A=
Date:   Thu, 14 Jul 2022 09:20:24 +0000
Message-ID: <bd096fecad204c2ecf831cf96ac84b1f82b853ce.camel@fb.com>
References: <20220713082321.1445020-1-dylany@fb.com>
         <20220713082321.1445020-4-dylany@fb.com>
         <27f219d07e4e4ce4bfb3263d8d94eae6@AcuMS.aculab.com>
In-Reply-To: <27f219d07e4e4ce4bfb3263d8d94eae6@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ebecbfa-17d6-4999-f84b-08da657a155a
x-ms-traffictypediagnostic: SJ0PR15MB4392:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8hhmJxlLXh8/d9kI0zvckdxDT23d43FM+WEGLKnPa8lXZLQTi5WeqWf6VNDwDXWgjeCw+hZQGL65ZKD2qu7rCqAMM5G1eTT487NJ3Fdl9M05tXsAfEQXdCwHZuzhhiyofJC+VAL9vtHbROHh0hdiCK5S1swXQzZQWFVy9GRExN0PXsf1yQJs6iOzVoEsKReWoqtQyKgVBAeEOOYzyS6DKbI2oWVH3vtL6oKGhbZKRwpHvCufTJlNPSthSRswZ24WFBM19ZQgSXSLWobLlqXvTZvk0EW8lk05+p1CnCZSyXetifX5gZX8cQtomrk/mAp9MakVb20A3bzcwwPMrhvXgE5ip7bE7Az7UnzDpjVkHkidrLxbZgGKsoJo+X9YXjfafq9Fv69zEvt06nEsad0c9nAHfut9LAc4A8OfTUl0TJwis1/xSoFOLqLUIRUD1xruVGWgZHnCpFQzfCeEVvtif3sUwQSFtAPw7jSlwb9O/5MSbqkfUWCzAvHj5PMgW8vOiSlkg65F965c0Aa2VnsMXpv+oXtr0QCXw3BJnseR5gYiTb2uzqzvrwb2PulQdkHko+dXPMPHzH9u2FTCz0JGyj6PTvEhnGUXs/tQxHO8sT9mXBchpSRLXIT+ql/dvHawXxSGDC8WvTtFLkChUFBhJkqI3XmN/QgPppWDj7S1qIq1kcpvL6MhXAf/c/bUw9Z2L60AGbNGgEvBvFrWxGtji/8qLRh7u3A5zRHUfDm0CZgqifh06GRyZY9QKKjerqLSKedv/A0MOGbtwY/7TRBURRRa8NY2sO6ZM/lthBd70INbuufkTt+/r3zTHNIBL57N
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(8676002)(478600001)(76116006)(6486002)(83380400001)(36756003)(2906002)(38070700005)(122000001)(64756008)(4326008)(8936002)(86362001)(2616005)(38100700002)(66556008)(66446008)(54906003)(66476007)(91956017)(6512007)(6506007)(71200400001)(316002)(41300700001)(66946007)(186003)(26005)(5660300002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmZhdkkvKytMSUZGbjZNSVI5dGladEVaTERBRS85ZTdvcmFtOWg2ZGQzY1Rn?=
 =?utf-8?B?NTYwcjVQdGF1TGk1TkJUbnk2RTZNd0VXV0o2YXZ3VEFXQUl3aXBQcElLemlk?=
 =?utf-8?B?L2oreUVPTHhHSUlFUnBMbktqMXEzWnRObjAvYmZ0UGVDRlpuSGJIU25YclFG?=
 =?utf-8?B?YTFwRnc1RGpxVm9uNTBUbk1rSnR4TmVmblo1UmZkaFhUQVZSSzg2U1pLRnYr?=
 =?utf-8?B?cmNLeUNWSWxZU3BBaGgzT2ZEM0pwbzd2RzE1MVdFM3FOM1p3OG9Gekp4dWlm?=
 =?utf-8?B?YTV2clRKRnpEamRyWE5LaXZwa0N6TjRxYXY1dFVNWWlBTnZLLzQ5RndUSzNs?=
 =?utf-8?B?V2hTMFhtWVpYQVBqSlEyVEJ4QVZURXlQZ2RXdnk0eDBGUy92aUFiRlJRUXBh?=
 =?utf-8?B?ZkNyUWZvb3VJZ1I0TEVJeFlCSjNMWEZqWkZmbDd2MjhmU2hFejNYUDFzcVBl?=
 =?utf-8?B?K0oyeno1UzdtTDdEWDJBaGhZeXpZcG1yUVV2RFcybmxkVisreSt3OTY0QlJR?=
 =?utf-8?B?SUl2YVFRK2p4TXBEc0p1a3c1QjNBczcyazlxYmdTS3BtaENqc09tSVEzbTBs?=
 =?utf-8?B?ZnpCVzdaOTdsdzcrQU1HNWJxVVBSWFp0WVlmamhzTDJlVy9rRDRINXpEYTBq?=
 =?utf-8?B?aTE4NUNUeDR0eW1LQ3JhZUcyMldpWnUraU5ISytrL2hadGdkRnZodVVyT3I3?=
 =?utf-8?B?MjJVZDNSclQrR1FWMWcwWTdFUm9oWExjb2IwMDk4RWNNdEJxLy81aEc2Ym55?=
 =?utf-8?B?d0lYODVEZU53QUx3czM5NDNGcVRTeUVWdUVmSWJ2T0xJdFppNm5kVThqRmdi?=
 =?utf-8?B?SS9PY0hJVy90VGVvbE1QMUpvRTg3Mk1hWXY2UmprcDFjQWVRSXkxTzM1UzdL?=
 =?utf-8?B?MWJkcEFha0xPcUhDbDV5SjNsR3RxTEhYd3gxV2NwTlZXTnlJSmEya01RcHI5?=
 =?utf-8?B?ZW5LVi8wUjlyM2syOVFuNUxUdFh3TjVUSENkdmZQbjZQZGwwSzRWS3U4L2Mr?=
 =?utf-8?B?YzlXNFBWR0RsVUVvaEgwKzB4YURWN0tiSUU5NTZQTFNVMWNROGlORGR6UXNJ?=
 =?utf-8?B?eGxsNFFTWWY2VFF2UTVwS3ZRYndheVQ3WVRKamJaU1cxSzc5Y09ncFN4eGdB?=
 =?utf-8?B?UG5xZFE4RXhETnRTVkcyVTFib2t3M2RiVzFib2ZJcSswTm5TNXBhWDhHa1Vh?=
 =?utf-8?B?SWZPMkQwbHlHUzdIN1l6N01ncitrT0xpNkxoNDJiOVVmSkVOdHNpR29kNDFZ?=
 =?utf-8?B?Z0Q2Z0JDaWV1dWxhaVZrakZkMWsrWUZvRHdMdHBmcUFZTDVZMW9BZ2xZN3hT?=
 =?utf-8?B?Z0NobkV6NUpyYnk1NTBJSDF0RWI4NHYwaE9GNHhFVm01ZUdQZDBZd0hzZVF3?=
 =?utf-8?B?aEMybGFIOHdMcWxsV1Z0anBsRWlIK1BXT2tFNTdDRGdmN3hSdlBZNWkyQjNG?=
 =?utf-8?B?QnNZRjhqTkFRejVJZzJCbzF4RzEvWHphdExZOStSSzdWNWtSQzNBRy8veVJ0?=
 =?utf-8?B?cHJKK01kaytHNUJONnkxc1FaaW1CUGkvcE15aWVRdC9nemM1Y296d3VLM1FZ?=
 =?utf-8?B?YktGLzF1SVQzM3EwUzA5cDNIZG50ZXRrNUY4NjJhTTY2SjJUVHVyUzlhSXVj?=
 =?utf-8?B?TmR5MkJZNE9TUllTeWdvUDhNSmx2WHNmK0piaUx5U0ZEbDFqU09UbWpPOUhm?=
 =?utf-8?B?SlduR1RTMSs3c0lkQU1FYTlzeUhKMEtMQzBaMEthOTk3NUFDVDNoNjYyaVBN?=
 =?utf-8?B?SVdsYlR5dlNjOU1zVWducTQ5QjB3Uzl0blRPalROSjFhL0o4MDE1Y2liUXR3?=
 =?utf-8?B?Y0pnOXN6aCtYVG5ZV2N6bVJJWlVZYmZaNEdUeW11RWQ3T284cGl2T1RNY25X?=
 =?utf-8?B?Nmp2MzZLVWZQYkliVlIzVlhGTGZpbFlYSnlaYzhEV05sZWhNeHpFR2NOSFg3?=
 =?utf-8?B?aTVnSUdteHNYMU15aVBGRGl1OS80Y0RPN0tGYmJnWEtZR0ttdHVBTEgzVmZS?=
 =?utf-8?B?eFArZkJWM3ltMGZwdHI1cVkyWlhBNGxYZU85K2h0dGZ6NE5QUzlRdkJXd3Bt?=
 =?utf-8?B?QjBGQVM1V1h6aWhaT0N3bC9nTmhkMk1UMmNaR2JGUk5rdlA5SjJxWjdhWGhU?=
 =?utf-8?Q?XiOXAwQZ5WuHt6qcU0e2gfDdy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FBAAEDE32DE9B42AE9CB4FA4C94A90E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebecbfa-17d6-4999-f84b-08da657a155a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 09:20:24.4732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 72pOHWgrqNXl2QI0W0C2b4RGbvS9fdMdqAKTQHzcY8n6QewN3DZUWLabyV7DuI06
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4392
X-Proofpoint-GUID: LYpOeAwivHeBQxwX7agfKsvLVcEUPrWJ
X-Proofpoint-ORIG-GUID: LYpOeAwivHeBQxwX7agfKsvLVcEUPrWJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_07,2022-07-13_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA3LTE0IGF0IDA3OjQ2ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
IEZyb206IER5bGFuIFl1ZGFrZW4NCj4gPiBTZW50OiAxMyBKdWx5IDIwMjIgMDk6MjMNCj4gPiAN
Cj4gPiBTaW1pbGFyIHRvIG11bHRpc2hvdCByZWN2LCB0aGlzIHdpbGwgcmVxdWlyZSBwcm92aWRl
ZCBidWZmZXJzIHRvIGJlDQo+ID4gdXNlZC4gSG93ZXZlciByZWN2bXNnIGlzIG11Y2ggbW9yZSBj
b21wbGV4IHRoYW4gcmVjdiBhcyBpdCBoYXMNCj4gPiBtdWx0aXBsZQ0KPiA+IG91dHB1dHMuIFNw
ZWNpZmljYWxseSBmbGFncywgbmFtZSwgYW5kIGNvbnRyb2wgbWVzc2FnZXMuDQo+IC4uLg0KPiAN
Cj4gV2h5IGlzIHRoaXMgYW55IGRpZmZlcmVudCBmcm9tIGFkZGluZyBzZXZlcmFsICdyZWN2bXNn
JyByZXF1ZXN0cw0KPiBpbnRvIHRoZSByZXF1ZXN0IHJpbmc/DQo+IA0KPiBJSVVDIHRoZSByZXF1
ZXN0cyBhcmUgYWxsIHByb2Nlc3NlZCBzZXF1ZW50aWFsbHkgYnkgYSBzaW5nbGUgdGhyZWFkLg0K
PiANCg0KSW4gcHJhY3RpY2UgaXQgaXMgbW9zdGx5IHRoZSBzYW1lIGZvciBVRFAgKGFwYXJ0IGZy
b20gdXNlcnNwYWNlIGhhdmluZw0KdG8gcHJlZGljdCBob3cgbWFueSByZWN2bXNnIHJlcXVlc3Rz
IGl0IHNob3VsZCBhZGQpLiAgVGhhdCBhcHByb2FjaA0Kd291bGQgYWxzbyBoYXZlIGEgc2xpZ2h0
IG9yZGVyaW5nIHJhY2UsIHdoaWNoIHByb2JhYmx5IGlzIG5vdCBhIHByb2JsZW0NCmZvciBwcm90
b2NvbHMgdGhhdCBkb24ndCBndWFyYW50ZWUgb3JkZXJpbmcsIGJ1dCBtaWdodCBiZSBhbm5veWlu
Zy4NCg0KRm9yIHN0cmVhbSBsaWtlIFRDUCBpdCB3b3VsZCBub3QgYmUgcG9zc2libGUgZHVlIHRv
IHRoZSBvcmRlcmluZyBpc3N1ZXMNCihjb21wbGV0aW9ucyBvZiBzZXBhcmF0ZSBTUUVzIGhhdmUg
bm8gZ3VhcmFudGVlZCBvcmRlcmluZykuIFlvdSB3b3VsZA0KaGF2ZSB0byBsaW5rIHRoZSBTUUUn
cyB0byBwcmVzZXJ2ZSBvcmRlcmluZywgYnV0IHRoZW4geW91IHdvdWxkIHN0aWxsDQpoYXZlIHRv
IHdhaXQgZm9yIGEgYmF0Y2ggdG8gY29tcGxldGUgYmVmb3JlIHN1Ym1pdHRpbmcgYSBuZXcgYmF0
Y2guDQoNCkFwYXJ0IGZyb20gdGhvc2UgcHJhY3RpY2FsIHJlYXNvbnMsIHBlcmZvcm1hbmNlIHdp
c2UgaXQgaXMgYmV0dGVyIGZvciBhDQpmZXcgcmVhc29ucw0KICogdXNlcnNwYWNlIGRvZXNuJ3Qg
aGF2ZSB0byBzdWJtaXQgbmV3IHJlcXVlc3RzDQogKiB0aGUgaW9fdXJpbmcga25vd3MgaXQncyBt
dWx0aXNob3QsIHNvIGRvZXNuJ3QgdGVhcmRvd24gdGhlIHBvbGwgZWFjaA0KdGltZQ0KICogaW9f
dXJpbmcgY2FuIGFsbG9jYXRlIHRoZSByZXF1ZXN0IGFuZCBhc3NvY2lhdGVkIGFzeW5jIGRhdGEg
b25seQ0Kb25jZSBhbmQgcmV1c2UgaXQNCg0KUmVnYXJkcywNCkR5bGFuDQoNCj4gwqDCoMKgwqDC
oMKgwqDCoERhdmlkDQo+IA0KPiAtDQo+IFJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLA0KPiBNSzEgMVBULCBVSw0KPiBS
ZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0KPiANCg0K
