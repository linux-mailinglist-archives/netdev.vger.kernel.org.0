Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BCB6EC38A
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 04:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDXCPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 22:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDXCPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 22:15:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A81FE60;
        Sun, 23 Apr 2023 19:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682302503; x=1713838503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zA5hWVbDlJUR9HpMdDH3HZlIOKkCKFd/hxlBvN2I8hE=;
  b=EcI2K+4G8xCjw6E9QQcMXiyagvoLLMCZeBVcCUaJFFhx6MypQl4BHWem
   C27U5HttERZ1tmtLLJ+hGZDMaGuCsUUpZlJG3SCeHf7JCJ3zpxHGL8riw
   sweDyPz7FgQIYTZ26XPX2k792laXKXj3lAnNvGYsP1NiLU8ubgGOxA70l
   RHvYF4YaEooe8Ba6ioazmw6WHy6jDs3lzwaKAxbDCHwZSWaV+MbqtPbsZ
   PyfrZGp7i0I0q6COCfVjjiyedylaFG+d10LBzjWF0tLJG0E2r7saIhmP1
   A9AnWo9cxhVtA2EQPcyYDmX2d7aWQoZBuv5HXC9Gu+b3PpjQMakJzRqRy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="335226011"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="335226011"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 19:15:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="723418389"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="723418389"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 23 Apr 2023 19:15:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 19:15:01 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 19:15:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 19:15:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 19:15:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4SPokvR6ttcpg8vcZmof/1YagH4Dx+JjlJT7vJ9SKgUJTCMpV4cllF0zBN0wIxUy8NCimFk/rCNpr4twoEJf+3Z5bn4jWV6qjEYAPrRyrc3mr+n6HozVNnsjKbhC3IQaWqGk9og16QSQTU4dF1JhGuGNOJYZ0NfYonHMkAi4ivL5zZebC6K9sgqqDZRnm9/0ENX3mVbjgGicK12LW3lYT0OfiLnc+8YONdIELzs4Zu646kCd8UKMo0ugPBRnL2xHtIfC3kzFlWKKwhZnca6PAqWnm0t9YyFVKUU1Ria4rWjVHjzZ/3VTx4dm0Qec/poAJm5b4loJ/Z3xYv5VbvZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zA5hWVbDlJUR9HpMdDH3HZlIOKkCKFd/hxlBvN2I8hE=;
 b=DJtAyCdlSxUC8Sl4qd2xCffq49Y1GnB6NCCVYV7oCW8tWgblU67F6OoMh10w8dm7sdTo3dhvT/5BOCoDd2qZ4Yvh1lCR6q8dYz6w+uIuN0aLmvOEa7VBpH1MnCdNrImJuj9NVGk4QLFQ1CzQrjM+DkklzM4NwKXIDX43YpyXpWbm8hkJRIUAz2GYUGdonxHpaV9x2cYc6mxc25LM0seBm3qOcHaEheVySLG080+vW6b+6oYulHwaRH1Jo/CGzsl3kGfdBbuRnNj3+utcjmT+u3BsONIcFTUE7MuRRzGbE7fi/6r2ophov1oC7YHt8l7sYRaDAZBx6CTt9hr9lu9nsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by PH7PR11MB5957.namprd11.prod.outlook.com (2603:10b6:510:1e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 02:14:58 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%3]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 02:14:58 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "Brouer, Jesper" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Stanislav Fomichev" <sdf@google.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.lau@kernel.org" <martin.lau@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "Lobakin, Aleksander" <aleksander.lobakin@intel.com>,
        "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [xdp-hints] Re: [PATCH bpf-next V2 0/5] XDP-hints: XDP kfunc
 metadata for driver igc
Thread-Topic: [xdp-hints] Re: [PATCH bpf-next V2 0/5] XDP-hints: XDP kfunc
 metadata for driver igc
Thread-Index: AQHZcfoI9V6NvnDgXkCLqXnH5km0Xq8xJpLggAS3TgCAA+LR4A==
Date:   Mon, 24 Apr 2023 02:14:58 +0000
Message-ID: <PH0PR11MB5830B61E6A081B1DDAD6FB05D8679@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
 <PH0PR11MB583075A0520F8760657FC4BED89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
 <f134a734-c67e-b546-b1ef-53da676acaf4@iogearbox.net>
In-Reply-To: <f134a734-c67e-b546-b1ef-53da676acaf4@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|PH7PR11MB5957:EE_
x-ms-office365-filtering-correlation-id: 64399ae7-b987-4c41-2639-08db4469b40c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uIzchc+ynhRf9V+Y6YfufE7BZz7dlwhD9mHINRCa2kcTMurzZGhdUwUgmNf58Fb2lLgQ8eaEPV5Jy/NGHs+4Okvo5tihqiwSLib0RdMU4neJ637FJIVA/dqoSXtBlLrlkGb5xKydzdoiGjoSWZTnLdzJrsyxSYegbI443O1CZNqxJUIE+JsmEnkSdGiCLDbTKltiaCI6vfPBRgLyab4KkUaOG9/GA7RTqZdixwDERlURO2ICANixOVnnsLHmN8tq4vjtgzuhy6CFNUcwij70qExwNXhQiANbigVweMPlbXQhhebJHOm/TTIOh3plkAXmGGpCDhzQbfaXK6G/KzQjiT0WQz440QlJTv+ZWTxyyrdzvtGuR4jye6Wgbc95//VtKNt4QybKiyknUeln6rZvCKR/XvKc1suVIk3mNapZWWDE7R+BQLBXYs8TWswqeaTx17rd/HvvxQvrsIPVjcCZi4ZFWQeToJbmWGPcHtBgPu/d4P+cIFSAOZbeyOmsUqAfCB9gMNe6p2a8/aLBC0pq1nOc2AJQS/bypeeJsc28JK9Z69N/hzXXaRAUUh9b5neip5kLshqnUDj2YKfc3CvEy3bclWZNwNzf4z3zlcyZtitFza3sMKK5xAal7tlyX4XH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(478600001)(110136005)(54906003)(86362001)(186003)(53546011)(55236004)(7696005)(26005)(9686003)(6506007)(55016003)(33656002)(71200400001)(4326008)(64756008)(66446008)(66476007)(66556008)(316002)(82960400001)(83380400001)(66946007)(76116006)(2906002)(38100700002)(122000001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(7416002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mzd5OERQbGpSd2k1N1BQUmh5dTFaSmRXeWxlQ2ZiNEhxbkxMbmFuVGhWUXRa?=
 =?utf-8?B?QytsZ3hiOGdmT0tsZjMxMjBtVWorUEdJckZIdzNFUm9qamR3NzhqN3VLUTNw?=
 =?utf-8?B?eExxcmZMNzg5cThtWVZYUHBvd2ptckRadzI0T1lQcUFCck9wUkhwV1hJenJa?=
 =?utf-8?B?UG5yZ1FCU3V4NGNiNFBhN0RIdlI1cEpjNlA1dGMwdmk2VXYxNTNtWmkxalNU?=
 =?utf-8?B?TEI0eVJSVFA3R2xWVG50Q1NFNzNJeE5TclNIY3hHMUExSTNieGFYM01od0cw?=
 =?utf-8?B?Yk1TVllvOWgyS0dJL0dPaStmR1FPWTB1b2NlbjlwNENlY1BpNGlJSnBUNWY0?=
 =?utf-8?B?bmQycEIrR1VmTU9ib0ZiYWdMZXovL0VPcFdaOUlQWUxhQWd1TGxKUFRUVXRh?=
 =?utf-8?B?NnRhY1RsN1k2YW8wanVOdndWZXlpWUVmWWk1Vlo2SHZCank0ZWxGV29xdGZ0?=
 =?utf-8?B?Z2s4K0pTNmNXSVlwczdGOWxKa2VzTWswdnpWQkErdEQxWDdnbVNnODVuZldt?=
 =?utf-8?B?ZWdtUi92b2I3MXo2OGtNenlPZElCZWJGRHBhcERSNWtUbmhlSEEvMUJ1TVov?=
 =?utf-8?B?MnRyTittbFlkaEFpREJ4SUt5TUJQcTlNVkRXTFpLRUFaQ3dyUmEwQ0Jadk4w?=
 =?utf-8?B?SHl4RnBsZmFCOXNvZmYydE5YUWpkVHNoYVpUVDl6aTBWVUpaZlQ1R1o1ZjRS?=
 =?utf-8?B?b3dic3I0N3plRmxlVXc4eTZrSW4yTzN1V3ZhcGc5aFFZcTcwcDdQQjlvbnNl?=
 =?utf-8?B?RUJydUtOdkVsZjBhNXQzcFRMbytnQVk3dlF6U2NkaXN5Y25CblhnalJVVjhq?=
 =?utf-8?B?bUFDRjJsVzBBaDN2NHhnSkhrQWs3SmpSVFVKaXFqTmFDNkZoQVdrVWpwTGt5?=
 =?utf-8?B?Snp6T1pHRllLU0JWQUdudGR6bG9FL2d1TWdIamZnNUVJL1FlZE1sV25rMkxK?=
 =?utf-8?B?WGFtbUZ0dFE0b3I3WndDbnAvM2VtQU9adndXU2N0VWRTUUVTZkFEZDN6amdp?=
 =?utf-8?B?NmxkQ2piQStSekcvdFZGVlhLc2pPN0pva3RMaUtIdnJWYnNZNG5kcjFHQXo2?=
 =?utf-8?B?NFFHczBVOTZmd1FoRXhac1J0TTlBdWRBWGhINndEZmRmUEx2RndodnQ4dHAy?=
 =?utf-8?B?RnBZaCtJREdBUEJuWm1sOTFGcTJiQitMcklrckpSSGdSRnA0UEpGQUNFKzEv?=
 =?utf-8?B?T0lCYnoyM2M0dFQwVm5DMENiZ1FjWGVWOWVhYi94aC9veU54eE44Qit5b3dY?=
 =?utf-8?B?L25HRUNhMm42MW9pdGE1Q3J3dFBiRzBTOXVOTW5hcmx3aVJUaVpYY09hdEFT?=
 =?utf-8?B?Ulp1bmtjKzNlRlA4cEk0YURUOW1Cb2s3ZzNWYUdranRZSmtKV2J0MWFaOWhY?=
 =?utf-8?B?ZWk1TjQ2Rzk1VDdHWlhQamM1M21LWndiSHZOMmgyeE85VDVVK2l5WjRGZzEw?=
 =?utf-8?B?T1ptaFcwV3gwNnc1NTVZTm9nZDFUWGx2WHc2WEg2bitDcFhHcUo0MVE0dVQy?=
 =?utf-8?B?NVZDaEhHTjdVOHU0enoza1A4S1o4QndKbzdydWFwMVdTTzNtenJLVjEwejZr?=
 =?utf-8?B?Y3JaSzhobWNjZ1E5RURjK25KK2JlR0lDZnhRb2VZb2VhcGdEbDNMTSs3Tzdx?=
 =?utf-8?B?elBUYUppUXZ3UzBWUEpQaTN3ZnNDMU1IbThBUFg3bVRya3MwVWlGVHRNNWFa?=
 =?utf-8?B?MWdLTENJZk9UeEpjME1EUVM1cFRCeXcyd0tsd1ZReFpZYkRreVlIN1pud01o?=
 =?utf-8?B?bllTWkNtN05Vb3VXaTdRZmNZdVVadUhFUXhiOHZ5SDliZjBhOXY1dXZSYmlt?=
 =?utf-8?B?d2xEUFRBM3kwYkRqTURLTys0VzR1aHMyTHQ5NXhHL2pkNG9DdzZsYjJUYk1u?=
 =?utf-8?B?NkJyNmp6cjA3Yk83d3JIV3BQZXpQVmNqd1lPSW5GNzhlVTFjZVdJSDl6RDNv?=
 =?utf-8?B?L0UwMzM3d0dOYUR2eWxSZkZINVAwcVNZOXFwUTdCR0xLdUgzckQ4SHRyeGhB?=
 =?utf-8?B?NmpiQ0o4WWRHM3p3U2hFV1RQRExIZ0R0UHFVVTlJUmFWRWdHd05RMERDb0tT?=
 =?utf-8?B?d09Xa245SzZIU0ZNVmhLc2pHeUFxa0JRRFBQL3pSL29pb0hHK1hnWWNhaC9n?=
 =?utf-8?B?dVozM2FMT1Vqb3EwWEtpNzliUXRMNys5TFdhS3NLazNxSDZiTENaSkJXYTNU?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64399ae7-b987-4c41-2639-08db4469b40c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 02:14:58.5707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: udsajuRZV/ZVNCz9KMic1QRYkZcs7N7syFd0kn8zfSzLsm0HxRt980YYblVNZbOudqyNa5vh7gUQ3sR/jcz6blkekD7fSsODYrdQELKF/p8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBBcHJpbCAyMSwgMjAyMyAxMDo1MyBQTSwgRGFuaWVsIEJvcmttYW5uIDxkYW5p
ZWxAaW9nZWFyYm94Lm5ldD4gd3JvdGU6DQo+T24gNC8xOC8yMyA0OjUzIFBNLCBTb25nLCBZb29u
ZyBTaWFuZyB3cm90ZToNCj4+IE9uIFR1ZXNkYXksIEFwcmlsIDE4LCAyMDIzIDk6MzEgUE0sIEpl
c3BlciBEYW5nYWFyZCBCcm91ZXINCj48YnJvdWVyQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+IElt
cGxlbWVudCBib3RoIFJYIGhhc2ggYW5kIFJYIHRpbWVzdGFtcCBYRFAgaGludHMga2Z1bmMgbWV0
YWRhdGEgZm9yDQo+Pj4gZHJpdmVyIGlnYy4NCj4+Pg0KPj4+IEZpcnN0IHBhdGNoIGZpeCBSWCBo
YXNoaW5nIGZvciBpZ2MgaW4gZ2VuZXJhbC4NCj4+Pg0KPj4+IExhc3QgcGF0Y2ggY2hhbmdlIHRl
c3QgcHJvZ3JhbSB4ZHBfaHdfbWV0YWRhdGEgdG8gdHJhY2sgbW9yZQ0KPj4+IHRpbWVzdGFtcHMs
IHdoaWNoIGhlbHBzIHVzIGNvcnJlbGF0ZSB0aGUgaGFyZHdhcmUgUlggdGltZXN0YW1wIHdpdGgN
Cj5zb21ldGhpbmcuDQo+Pj4NCj4+PiAtLS0NCj4+PiBUbyBtYWludGFpbmVyczogSSdtIHVuY2Vy
dGFpbiB3aGljaCBnaXQgdHJlZSB0aGlzIHNob3VsZCBiZSBzZW50DQo+Pj4gYWdhaW5zdC4gVGhp
cyBpcyBwcmltYXJ5IE5JQyBkcml2ZXIgY29kZSAobmV0LW5leHQpLCBidXQgaXQncyBCUEYvWERQ
DQo+Pj4gcmVsYXRlZCAoYnBmLW5leHQpIHZpYSB4ZHBfbWV0YWRhdGFfb3BzLg0KPj4+DQo+Pj4g
SmVzcGVyIERhbmdhYXJkIEJyb3VlciAoNSk6DQo+Pj4gICAgICAgaWdjOiBlbmFibGUgYW5kIGZp
eCBSWCBoYXNoIHVzYWdlIGJ5IG5ldHN0YWNrDQo+Pj4gICAgICAgaWdjOiBhZGQgaWdjX3hkcF9i
dWZmIHdyYXBwZXIgZm9yIHhkcF9idWZmIGluIGRyaXZlcg0KPj4+ICAgICAgIGlnYzogYWRkIFhE
UCBoaW50cyBrZnVuY3MgZm9yIFJYIGhhc2gNCj4+PiAgICAgICBpZ2M6IGFkZCBYRFAgaGludHMg
a2Z1bmNzIGZvciBSWCB0aW1lc3RhbXANCj4+PiAgICAgICBzZWxmdGVzdHMvYnBmOiB4ZHBfaHdf
bWV0YWRhdGEgdHJhY2sgbW9yZSB0aW1lc3RhbXBzDQo+Pj4NCj4+Pg0KPj4+IGRyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2lnYy9pZ2MuaCAgICAgICAgICB8ICAzNSArKysrKysNCj4+PiBkcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4uYyAgICAgfCAxMTYgKysrKysrKysr
KysrKysrKy0tDQo+Pj4gLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MveGRwX2h3X21ldGFkYXRhLmMg
ICAgIHwgICA0ICstDQo+Pj4gdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3hkcF9od19tZXRh
ZGF0YS5jIHwgIDQ3ICsrKysrKy0NCj4+PiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYveGRw
X21ldGFkYXRhLmggICAgfCAgIDEgKw0KPj4+IDUgZmlsZXMgY2hhbmdlZCwgMTg2IGluc2VydGlv
bnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KPj4+DQo+Pj4gLS0NCj4+DQo+PiBUaGlzIHBhdGNoc2V0
IGxndG0uDQo+PiBUaGFua3MgZm9yIHRoZSBjaGFuZ2VzLg0KPg0KPlNpYW5nLCBjYW4gSSB0YWtl
IHRoaXMgaW50byB0aGUgcGF0Y2hlcyBhcyB5b3VyOg0KPg0KPkFja2VkLWJ5OiBTb25nIFlvb25n
IFNpYW5nIDx5b29uZy5zaWFuZy5zb25nQGludGVsLmNvbT4NCj4NCj4/DQoNClN1cmUuDQoNCkFj
a2VkLWJ5OiBTb25nIFlvb25nIFNpYW5nIDx5b29uZy5zaWFuZy5zb25nQGludGVsLmNvbT4NCg0K
VGhhbmtzICYgUmVnYXJkcw0KU2lhbmcNCg0KPg0KPlRoYW5rcywNCj5EYW5pZWwNCg==
