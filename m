Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46636E19BE
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 03:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDNBd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 21:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjDNBd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 21:33:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCFC1707;
        Thu, 13 Apr 2023 18:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681436036; x=1712972036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wbNBBcI/JI0xgJYdKZj5Lzk39FXHiUUByEF8YHZHV/M=;
  b=bAzfV05ailzZWoScCAlMrn+GQHZU8HlGS9YgVD3jZpbQmoQ/Mzac9kLU
   doM5dP+j9k9k0w1o4+WF0U8dVt9BZDN0ZIjZYzz5n4NgSdSM+e+e5zC0P
   mOnErPI4b6qaOfNQ+TyA088+gqCvxIdEMMQwwBsnBGEE0x1hoWii2DdYY
   Mgss7G7hFw1b+W3GUkJ/J8leN11KrVE5xWF2nGiarwBEFCA0dvfwFE0eV
   fdeWNEXbw/RP7P4lJlLiy6Os2eQNcRRe0n2Ft6Fv52X3QPsR0j9uWzcir
   VelvlpbvKReqjv8mzS0o46sExuChHg68ug3YqV8IlE2cmZ74qM1oRfOhZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="344353928"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="344353928"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 18:33:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="864022389"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="864022389"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 13 Apr 2023 18:33:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 18:33:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 18:33:22 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 18:33:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7GOIWkksv9GsifY3rHgfhSnRnYC5dPIRI0sUWNVRTgn2PqE0eySs48s6X6eCEPCGxPOAlUDxujGbjIVYCCzAGlLTC8AQiJJRvyo5bstnVVQecvSp8zP9im9QTT189XH4BE22ODodkMOg9ZQHtDVQ03vfc9hsc9ZeP3Z5sAhKLgiQRU9Cyglx0oaIKIjvkoq5h+qMSQb7BmRyJ09hsYTOglfJVjbyb+2MUjQwTTU+zkNCU030fLoaezoOEHPWWUUhe2heD8fTFqbLKs30K24ryyQr+Kh79MSFbFXLi11UX3BF5jfOh1vQtDJdQvMjYwd+wsH2cySmNt5zw1Pix98yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbNBBcI/JI0xgJYdKZj5Lzk39FXHiUUByEF8YHZHV/M=;
 b=PHrgtyRrwzM219sbOUJWm5GpCYPDXnVgamM7JbOFM0c6IFum1PYhi+wi16rRVDqLkKWW7Ng4TMEEx3i6tbcHRD0gDeYSClN21xlPVvqKjrTmz0rCHyYJkw1+tO1CM5Rj/KNSyGf3x84mKkUiy8u/sMHjJ1WVyL4wcZIll9wh7GG+fykCnWHTFUi5egrD73Sv/Hco33pBWzQ3tcTMZ4r7BPqPX+QJrPUZfxIh7QQByisnfIk6uLyW2/DkrYAeedAmTe1xQhjwzfkeEQpUcBIAPZAisAMANtt9mVB12rscndzrPmCc77LuRHEyE2T2I5vWrrZ7e3jR57+AzrtKfjUmvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 01:33:15 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Fri, 14 Apr 2023
 01:33:15 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Stanislav Fomichev <sdf@google.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net 1/1] igc: read before write to SRRCTL register
Thread-Topic: [PATCH net 1/1] igc: read before write to SRRCTL register
Thread-Index: AQHZbhp1VdIm3fVCg0ugMsk8Zltg9K8pkyEAgABse+A=
Date:   Fri, 14 Apr 2023 01:33:15 +0000
Message-ID: <PH0PR11MB5830186580A5A1AD15AD5961D8999@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230413151222.1864307-1-yoong.siang.song@intel.com>
 <07a88087-bee8-e549-c069-63d52268aef1@redhat.com>
In-Reply-To: <07a88087-bee8-e549-c069-63d52268aef1@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|PH0PR11MB4790:EE_
x-ms-office365-filtering-correlation-id: 5b3f69e1-36d2-4ebc-d675-08db3c8837b1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qAm098mLSumby8WtiSW1LAzMa8wxPDe0JcPwpFOqTlMRrOLb6nRcTtUoZaYnnURbLyLIiF/ZaA7897sLuC98ysc5Dv+xMbMW9O/ZErw2GFpZG4gJrDE2YRHhFHMUUZYCYi4hEBilktLqKYkl7UuwYA+eyOc/yluuEoK0/o+cY/oPzNZWE5qw9Q4UADREtxa32mq3no2X0BBxoEPzsZkiGXBmvCoYG2eJ0SfYp+/u813E8m9QfJ5Bo17o4p0ylZYeINHNSv6RZi3R5HjhvPZD4sHsN9jkqvKtDWom6YCgOY+eD6fKZwWGrhq/HxjfSuhv9s+iPr8wGtZxe7ZFjaThbndEFgm+oNRXNGaYlL6mBNU0iywOrQuDaBeSyzr32Lb/mpmqBzC17gdAMzZLQj2gq2xv2YI4RWGsvH6KtN9YfjHEcOemX9TvbyTEU7sDoy7DlETMuPFaZUDlBhO0E5v8CLYyfCpqht5ixw2nJxp2VFoagdewWcYYsN0k8Dd9sU15KKntSBUC+58m8OmSDSQrEw/3D06HaIR0WasHHLUFTLYj9qTi0KwUEPGvcDZzKWvQIVv4nmN0bFm894eguDNZEwbfKkd4NysOMRIVdV7Xt+qz+gMlsWJWzQDK5pSdQSkfPQPF3RFJGGNboLJ+WpH7RQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199021)(38070700005)(55236004)(9686003)(26005)(186003)(6506007)(53546011)(54906003)(33656002)(478600001)(55016003)(110136005)(122000001)(921005)(2906002)(7416002)(8676002)(8936002)(83380400001)(41300700001)(5660300002)(52536014)(38100700002)(316002)(4326008)(66946007)(66556008)(76116006)(66476007)(64756008)(66446008)(82960400001)(86362001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWp2dWYwNVRFeDhsMWcvaTZLeTZxYWNnZU1iMENMQ1VkQ2JpT01iWEpLNWM0?=
 =?utf-8?B?a2RkRTRldUtKVzJSekZOTExwVDIrMCtVbDNVeDJNbVFzMU9rc1lWOVhzVTA4?=
 =?utf-8?B?dGVsUTVjMmxmZmFuQ1c5ZEExKy80YjA2NDZJMUdsbmFrblRMNi9aVjNkTEw3?=
 =?utf-8?B?VThrUVQ0TllITkJQdEErbGFGK1o3QlhCcWFIeFNTcm1jdDZ0ODc4OWh2ZkQz?=
 =?utf-8?B?Y1JMUjZnZXR0RVo5NGd4ci81blJsb29Jb1VQVHllQ1I0bXJldU8va0o1RXo4?=
 =?utf-8?B?N0dnTlFmUHJwWU1VaTE1WUhhblBYM2x2TUdPS29GYmdOVWJuNmZmMDkrZnBY?=
 =?utf-8?B?d0V0bDJ5ZHFaL0w2WUVQZlFYVExFMU40c2x6NWJKdUhjSE50L3YrYUo4cUVp?=
 =?utf-8?B?U3pCVXoxblA2N3NDK1JKYnI1L1ZRTVlRbDNMMjZHeThONTZYTlJOV3ZRTlRm?=
 =?utf-8?B?azgreEVmQVNtRkltUnZ3Si81bDlkVmVDYlppK0diekZGdDFQUVdpcCs4K1Jn?=
 =?utf-8?B?S25UTzB0WEhmSzQ2dk5mVitxa1FpcUZQSWZROVJ5aDk3ektuUmNlaHJNcFA2?=
 =?utf-8?B?SWhzTWU4NDZHcjVMZ3N0ZkdOeEc1eUJleEFVSWlzUVowSmdMOGV0M0RsK1Y5?=
 =?utf-8?B?bVh2ZzVDRUFkMkFHRTkxRVJmRXFrK1JnMDg5Y1QvbGdiZHUxYzQ1QWNkaGZo?=
 =?utf-8?B?ck5IN1BWTDJwSXI0K1M5VER5SmlFTmgrVkppSE5EbmY2dGkzUGJ1T0NwUmg4?=
 =?utf-8?B?SXE5SlZOcGMyZm10L1FETkVESW9KMk0ydndkc0s2L0FVVDlQdkdpcVlkaUNP?=
 =?utf-8?B?RFk1eTdIZUpNZTUvRGlqOUZVbjdMTitIUyt6aVNOd2NLUXg2RW9MWWNHQ0dW?=
 =?utf-8?B?SjVsbUQ4aHYzVG1pU3pISytDNE85SnBtckJxTFhKZWZ6LzNZSUxCUjJ2NnFj?=
 =?utf-8?B?RnFreHJhT1hhVWd6bXlsaEczMFZwcjNtNXBzazAxaHdlT2kwTms4aTExZXpS?=
 =?utf-8?B?dHFTZ3oxMVlOVEVIcmphWEtrMXZONWdIWjhKRW5Ld2pydmJMeWVqaUtmOHBz?=
 =?utf-8?B?enJ3bkMvOEFIL1NxeW9FeURSaFVOMlhTcEQ3SGZJSVFROG5OM0syc2hqdFdZ?=
 =?utf-8?B?VGhDM3hYaTFLOStrVmZPVHNZaklmbHNWV2FlbERHcjkyZ0hUNk5tdDdKaEM2?=
 =?utf-8?B?b0MxOEVkcmVuOUExL1JLNnJoYU1nVnlUOStyUng0d2FldkpkN0g0Rk9LRjN2?=
 =?utf-8?B?M1JEa2FKQjMvUGp4dEdhRzRvYUFSV1Z3Wk5rak5Ubk0ydnZYUHBVUlUrbk4y?=
 =?utf-8?B?THNqUWVQS0J2NnN5NTB2K2tVU1g3VlpiYlp3c0Q5SXVlTVdPbUdyQSt0eGlI?=
 =?utf-8?B?WlZPYUxiaFBXcktWamNLazhZVjFXT2FkMkREOUtMc09raWFuc0hyaXhCSzRR?=
 =?utf-8?B?ZXh3NVBSWUViUFZuN2Foc1c0TFd1TXlkbDBoYk9yN1QxUWFteXk0RWFxc3hC?=
 =?utf-8?B?NGltOFVPbU80QUR4YUVxU2VUVFhpR0pNSkV5R3BoYWdPbkRrZmpQUkNEUzMw?=
 =?utf-8?B?SVp6UWlCd0Ewb2RNcEhwV2dFS1ZtVUZNUlBSMDFOdlBxenBFQVpWQW05cWQ4?=
 =?utf-8?B?OWtJQWRoZ09iSjNGOVRuVitoSXR4VDgyK0R0K1REOEFmNmZtdEhpM1d4M1o0?=
 =?utf-8?B?RElVYjdhWEltdUJXN056b1hwbEZFd1RQZ2lKcHg2TTh1OWpJN3JFdUdpbm5y?=
 =?utf-8?B?dk43UGVGMFI2NFovbVZSaVZXcStLSlhvQmk2blNIanpxcGJ5OW5FZm5PTTRj?=
 =?utf-8?B?MkZ0aWlPaUd2bWtOL1pRVzFMOHY0K0NTdlhob3c1OVJrTnBpK1MvUVdKdG9G?=
 =?utf-8?B?YUpvNVh4dUNxaTltbCtoVjY3eExCcWRDOW4yN2IwNW10L0V4aytCb1p0Q0Rs?=
 =?utf-8?B?YkJadzlUbW1CTytoaGRRVDRtejNVa2JyMFZwT3FXdnIxTTE1MXp5bExTalVP?=
 =?utf-8?B?VlNIeUtXTUZHOE1BdTBDdUlkSGU5eFh5TDcwSjZuUnVpTHZ6d1ZRRXZ1aFRV?=
 =?utf-8?B?RjZYZ0NJSytaZDdmNm1ZejdhV25oZko3cHhHRGdsS1l5M0ZkT0xBRmdZOFhx?=
 =?utf-8?Q?B/uyc1aDcz+XehlcbqKM86hdu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3f69e1-36d2-4ebc-d675-08db3c8837b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 01:33:15.0340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6nnHCtaMNGZTba7gNJ3GXiu3SYA2RonHl6KRsOlbd95mzpB1/J/58lExXZbUM5LQaRKV7qLn2ph7+YS5Z3YS3kr27UDqRe++Hul5Z5uW6os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBBcHJpbCAxNCwgMjAyMyAyOjQyIEFNLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IDxqYnJvdWVyQHJlZGhhdC5jb20+IHdyb3RlOg0KPk9uIDEzLzA0LzIwMjMgMTcuMTIsIFNvbmcg
WW9vbmcgU2lhbmcgd3JvdGU6DQo+PiBpZ2NfY29uZmlndXJlX3J4X3JpbmcoKSBmdW5jdGlvbiB3
aWxsIGJlIGNhbGxlZCBhcyBwYXJ0IG9mIFhEUCBwcm9ncmFtDQo+PiBzZXR1cC4gSWYgUnggaGFy
ZHdhcmUgdGltZXN0YW1wIGlzIGVuYWJsZWQgcHJpbyB0byBYRFAgcHJvZ3JhbSBzZXR1cCwNCj4+
IHRoaXMgdGltZXN0YW1wIGVuYWJsZW1lbnQgd2lsbCBiZSBvdmVyd3JpdHRlbiB3aGVuIGJ1ZmZl
ciBzaXplIGlzDQo+PiB3cml0dGVuIGludG8gU1JSQ1RMIHJlZ2lzdGVyLg0KPj4NCj4NCj5BaCwg
SSBiZWxpZXZlIEkgaGF2ZSBoaXQgdGhpcyBidWcgd2l0aCBteSBpZ2MgcGF0Y2hlcy4NCj5UaGFu
a3MgZm9yIGZpeGluZy4NCk5vIHByb2JsZW0uIEkgZm91bmQgaXQgd2hlbiB0ZXN0aW5nIHlvdXIg
cGF0Y2hlcyB0b28uDQo+DQo+PiBUaHVzLCB0aGlzIGNvbW1pdCByZWFkIHRoZSByZWdpc3RlciB2
YWx1ZSBiZWZvcmUgd3JpdGUgdG8gU1JSQ1RMDQo+PiByZWdpc3Rlci4gVGhpcyBjb21taXQgaXMg
dGVzdGVkIGJ5IHVzaW5nIHhkcF9od19tZXRhZGF0YSBicGYgc2VsZnRlc3QNCj4+IHRvb2wuIFRo
ZSB0b29sIGVuYWJsZXMgUnggaGFyZHdhcmUgdGltZXN0YW1wIGFuZCB0aGVuIGF0dGFjaCBYRFAN
Cj4+IHByb2dyYW0gdG8gaWdjIGRyaXZlci4gSXQgd2lsbCBkaXNwbGF5IGhhcmR3YXJlIHRpbWVz
dGFtcCBvZiBVRFANCj4+IHBhY2tldCB3aXRoIHBvcnQgbnVtYmVyIDkwOTIuIEJlbG93IGFyZSBk
ZXRhaWwgb2YgdGVzdCBzdGVwcyBhbmQgcmVzdWx0cy4NCj4+DQo+PiBDb21tYW5kIG9uIERVVDoN
Cj4+ICAgIHN1ZG8gLi94ZHBfaHdfbWV0YWRhdGEgPGludGVyZmFjZSBuYW1lPg0KPj4NCj4NCj5X
aHkgcG9ydCA5MDkyID8NCj5UaGUgLi94ZHBfaHdfbWV0YWRhdGEgcHJvZyB3aWxsIHJlZGlyZWN0
IHBvcnQgOTA5MQ0KWWVzLCB5b3UgYXJlIHJpZ2h0LiBCdXQgdGhpcyBwYXRjaCBpcyB0ZXN0ZWQg
d2l0aG91dCB5b3VyIHBhdGNoZXMuIFNvLCBpZ2MgUngNClhEUCBtZXRhZGF0YSBzdXBwb3J0IGlz
IG5vdCB0aGVyZS4gV2Ugb25seSBjYW4gdGVzdCBYRFBfUEFTUyB3aGljaA0KdGhlIHRpbWVzdGFt
cCBpcyBwdXQgaW50byBza2IuIHhkcF9od19tZXRhZGF0YSB0b29sIHdpbGwgb3BlbiBhIFNPQ0tf
REdSQU0NCnNlcnZlciBvbiBwb3J0IDkwOTIgdG8gZHVtcCBvdXQgdGltZXN0YW1wIGluIHNrYi4N
Cg0KSSB1c2UgeGRwX2h3X21ldGFkYXRhIHRvb2wgdG8gdGVzdCBiZWNhdXNlIGl0IGNhbiByZXBy
b2R1Y2UgdGhlIGlzc3VlIHdlbGwuDQpUaGlzIGlzc3VlIGhhcHBlbnMgb25seSB3aGVuIHdlIGVu
YWJsZSBodyB0aW1lc3RhbXAgYmVmb3JlIGF0dGFjaCBYRFAgcHJvZy4NCk5vIGlzc3VlIGlmIGVu
YWJsZSBodyB0aW1lc3RhbXAgYWZ0ZXIgYXR0YWNoIFhEUCBwcm9nLg0KPg0KPg0KPj4gQ29tbWFu
ZCBvbiBMaW5rIFBhcnRuZXI6DQo+PiAgICBlY2hvIC1uIHNrYiB8IG5jIC11IC1xMSA8ZGVzdGlu
YXRpb24gSVB2NCBhZGRyPiA5MDkyDQo+Pg0KPg0KPkFnYWluIHBvcnQgOTA5MiA/DQo+DQo+PiBS
ZXN1bHQgYmVmb3JlIHRoaXMgcGF0Y2g6DQo+PiAgICBza2IgaHd0c3RhbXAgaXMgbm90IGZvdW5k
IQ0KPj4NCj4+IFJlc3VsdCBhZnRlciB0aGlzIHBhdGNoOg0KPj4gICAgZm91bmQgc2tiIGh3dHN0
YW1wID0gMTY3Nzc2MjIxMi41OTA2OTYyMjYNCj4NCj5JIHVzdWFsbHkgdXNlIHRoaXMgY21kIHRv
IHNlZSBpZiBudW1iZXIgaXMgc2FuZToNCj4NCj4kIGRhdGUgLWQgQDE2Nzc3NjIyMTINCj4yMDIz
LTAzLTAyVDE0OjAzOjMyIENFVA0KPg0KU2luY2UgdGhpcyBwYXRjaCBpcyBmb2N1c2luZyBvbiBo
dyB0aW1lc3RhbXAgZW5hYmxlbWVudC4gU28gSQ0KdGhpbmsgY2hlY2tpbmcgb24gd2hldGhlciBS
eCBIVyB0aW1lc3RhbXAgaXMgdGhlcmUgd2hlbg0KcnhfZmlsdGVyID0gSFdUU1RBTVBfRklMVEVS
X0FMTCBpcyBnb29kIGVub3VnaC4NCg0KVGhhbmtzICYgUmVnYXJkcw0KU2lhbmcNCg0KPg0KPj4N
Cj4+IEZpeGVzOiBmYzlkZjJhMGI1MjAgKCJpZ2M6IEVuYWJsZSBSWCB2aWEgQUZfWERQIHplcm8t
Y29weSIpDQo+PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgNS4xNCsNCj4+IFNpZ25l
ZC1vZmYtYnk6IFNvbmcgWW9vbmcgU2lhbmcgPHlvb25nLnNpYW5nLnNvbmdAaW50ZWwuY29tPg0K
Pj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfYmFzZS5oIHwg
NyArKysrKy0tDQo+PiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5j
IHwgNSArKysrLQ0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWdjL2lnY19iYXNlLmgNCj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19i
YXNlLmgNCj4+IGluZGV4IDdhOTkyYmVmY2EyNC4uYjk1MDA3ZDUxZDEzIDEwMDY0NA0KPj4gLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19iYXNlLmgNCj4+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfYmFzZS5oDQo+PiBAQCAtODcsOCArODcs
MTEgQEAgdW5pb24gaWdjX2Fkdl9yeF9kZXNjIHsNCj4+ICAgI2RlZmluZSBJR0NfUlhEQ1RMX1NX
RkxVU0gJCTB4MDQwMDAwMDAgLyogUmVjZWl2ZQ0KPlNvZnR3YXJlIEZsdXNoICovDQo+Pg0KPj4g
ICAvKiBTUlJDVEwgYml0IGRlZmluaXRpb25zICovDQo+PiAtI2RlZmluZSBJR0NfU1JSQ1RMX0JT
SVpFUEtUX1NISUZUCQkxMCAvKiBTaGlmdCBfcmlnaHRfICovDQo+PiAtI2RlZmluZSBJR0NfU1JS
Q1RMX0JTSVpFSERSU0laRV9TSElGVAkJMiAgLyogU2hpZnQgX2xlZnRfICovDQo+PiArI2RlZmlu
ZSBJR0NfU1JSQ1RMX0JTSVpFUEtUX01BU0sJR0VOTUFTSyg2LCAwKQ0KPj4gKyNkZWZpbmUgSUdD
X1NSUkNUTF9CU0laRVBLVF9TSElGVAkxMCAvKiBTaGlmdCBfcmlnaHRfICovDQo+PiArI2RlZmlu
ZSBJR0NfU1JSQ1RMX0JTSVpFSERSU0laRV9NQVNLCUdFTk1BU0soMTMsIDgpDQo+PiArI2RlZmlu
ZSBJR0NfU1JSQ1RMX0JTSVpFSERSU0laRV9TSElGVAkyICAvKiBTaGlmdCBfbGVmdF8gKi8NCj4+
ICsjZGVmaW5lIElHQ19TUlJDVExfREVTQ1RZUEVfTUFTSwlHRU5NQVNLKDI3LCAyNSkNCj4+ICAg
I2RlZmluZSBJR0NfU1JSQ1RMX0RFU0NUWVBFX0FEVl9PTkVCVUYJMHgwMjAwMDAwMA0KPj4NCj4+
ICAgI2VuZGlmIC8qIF9JR0NfQkFTRV9IICovDQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19tYWluLmMNCj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWdjL2lnY19tYWluLmMNCj4+IGluZGV4IDI1ZmM2YzY1MjA5Yi4uZGU3YjIxYzJjY2Q2
IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19tYWlu
LmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jDQo+
PiBAQCAtNjQxLDcgKzY0MSwxMCBAQCBzdGF0aWMgdm9pZCBpZ2NfY29uZmlndXJlX3J4X3Jpbmco
c3RydWN0IGlnY19hZGFwdGVyDQo+KmFkYXB0ZXIsDQo+PiAgIAllbHNlDQo+PiAgIAkJYnVmX3Np
emUgPSBJR0NfUlhCVUZGRVJfMjA0ODsNCj4+DQo+PiAtCXNycmN0bCA9IElHQ19SWF9IRFJfTEVO
IDw8IElHQ19TUlJDVExfQlNJWkVIRFJTSVpFX1NISUZUOw0KPj4gKwlzcnJjdGwgPSByZDMyKElH
Q19TUlJDVEwocmVnX2lkeCkpOw0KPj4gKwlzcnJjdGwgJj0gfihJR0NfU1JSQ1RMX0JTSVpFUEtU
X01BU0sgfA0KPklHQ19TUlJDVExfQlNJWkVIRFJTSVpFX01BU0sgfA0KPj4gKwkJICBJR0NfU1JS
Q1RMX0RFU0NUWVBFX01BU0spOw0KPj4gKwlzcnJjdGwgfD0gSUdDX1JYX0hEUl9MRU4gPDwgSUdD
X1NSUkNUTF9CU0laRUhEUlNJWkVfU0hJRlQ7DQo+PiAgIAlzcnJjdGwgfD0gYnVmX3NpemUgPj4g
SUdDX1NSUkNUTF9CU0laRVBLVF9TSElGVDsNCj4+ICAgCXNycmN0bCB8PSBJR0NfU1JSQ1RMX0RF
U0NUWVBFX0FEVl9PTkVCVUY7DQo+Pg0KDQo=
