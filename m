Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E52584DBE
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 10:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiG2I71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 04:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiG2I70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 04:59:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0944140AD
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659085165; x=1690621165;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AmYzQ4Wcz+wlS5qYnwh6KbVIwBIOs6bb9tkUb3mD7dc=;
  b=U+OY9Ernkvb7QqWgQxhXQWeqAk74bH8XbbQzRpZ3GXp8jAcNUXG/ol8C
   KyHLDOH4byCbg4ATJ/ZC0byK0esiGGRt4uYu5CaABWAenZFn4kRpdU8uA
   Kcm5HrE0FYWaRqX/cAKKFyRe50PSXRpIqa5Q04XhsCNdizva9o/dVedGN
   UlNg4NaB75g5EPq4dUnUq7C6pWbqIluviHuVmzNmRn56b+fA7l36zXxNE
   70MJcZjINq7bvj5PyuKnC152iw7CJF6sxN/djfJZmHKXcJaVZ8Hnl7f2A
   j5+SjFvOZ1q/wXH6aW4FtQWyrZZQQLhO7s2kbKreP95C+Y42eovT1yvTa
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="269110737"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="269110737"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 01:59:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="604907153"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jul 2022 01:59:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 01:59:21 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 01:59:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 29 Jul 2022 01:59:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 29 Jul 2022 01:59:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVt9Hmd2PrmFGdX3c7t1+dAFDt706DyRez44ivfGrux7jJMn9lH38FX42r6MbWWEuD/kcidNHhZ0fQtTZ2z6xRVkThnT6l9KdcDqvLRASCGfDocroXRSwbuqUU1RVq8EUE2sIh/1FbDpu+ispbGBdJ14EezkFGvCwrAX+MvQr59eoc2m/vjmuXXgy0DkKIQ3I2jB7MWj1rL34h2AqjoNb1cWlGCoTLDdvAsdR3ok6EobdoPo0Vfyjr568cXX/tY7jjKG3cLxZI6qm32/T0YzvIuZPwbUl6SvRUQWFTUBJ00q7f6mqITTUoPlc7Myz2c+QtPY1yVhGHDY8rG/47446w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmYzQ4Wcz+wlS5qYnwh6KbVIwBIOs6bb9tkUb3mD7dc=;
 b=jwTprRonu62mmfjvsh1Z27cVK6KlBhs6QyMNPcrAL1iCAeE6awLRogkqXhDibrN1Jx5/Gt37yvoRDO158Ih2b7SY7Hhb2Fndhtzjt8g52+VBvTxxFZzaonO9Fvd7hOkbl5E1yc9pRkAosqC1U2v5PHaCmEXRsG6LN8ottOBhX/e2KoR0b0ONTkp9+Hzp9I0+kn19LKzElze1PAXxbhbXlKNYJnzNMRJikKD0JQQXwe/DF4XcnXnDtMAS1GFeYw7dKAxtx/9f9QcryfDuvc/Y43IfAhK+Ht5zHR6UI9bhfQ1tvuubEia0305fmpuq2eCspxK9MALS5MrLpNB++luNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Fri, 29 Jul
 2022 08:59:13 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::d9cc:2f38:4be:9e8f]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::d9cc:2f38:4be:9e8f%4]) with mapi id 15.20.5458.022; Fri, 29 Jul 2022
 08:59:13 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "gnault@redhat.com" <gnault@redhat.com>
Subject: RE: [PATCH iproute-next v3 2/3] lib: Introduce ppp protocols
Thread-Topic: [PATCH iproute-next v3 2/3] lib: Introduce ppp protocols
Thread-Index: AQHYotCXsLykyoPX70GXXbgCJUU0+K2VDKyQ
Date:   Fri, 29 Jul 2022 08:59:13 +0000
Message-ID: <MW4PR11MB577651A1E86058570D617CB0FD999@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
 <20220728110117.492855-3-wojciech.drewek@intel.com>
 <4cc470f9-cfed-a121-ccd0-0ba8673ad47d@gmail.com>
In-Reply-To: <4cc470f9-cfed-a121-ccd0-0ba8673ad47d@gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc2e3f9a-fdcb-486f-ad07-08da71409c2a
x-ms-traffictypediagnostic: SJ0PR11MB6791:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z6PXGhlUoQhyDLM6CaZd0W2kXpyXP4Kfm/VRLnw9SGHh1Vh8+oPGKSpc11vXkZ0UkZgSb3pFHNX4Xt8zUzDGsZn9NPqxW6mOolJp1cJVLN8/MOITaXSrK2UZyIBX9wmFgmz6V6gbnFq2MIq8H8IBT0RbghyLptexu2bbb2U46WtZpiGCRvlA+597Chw51DwlDDmVSRRoI5c/ENTTw4DBw4GJZtjfcVdsMqG0TUyx1uLGGJLTNp8KPMjQIK9V0gz9GuT3xyDM30lPelC7gUPcZ0xKmfrdNYS1eL2T8dEQvsEoEXRKxo5embaOkuNNrfKpaxAA8xpxGCFQ0xuTbRQuJLDB9pycoyPvMPcGcrTiH4aSQAwvK3Buqv3ISM16sXOovGjHmAVROolIgIFnC22hsfgiXourySmaRGWlcfWgc455XvT0J6L8QCx6wtFKUUDeuwCNmpZ8ty+NbbY6KM+4ExP49+uBIZl6YWrK9NwnMXVm9bRzVDThftWwo6ss+7BbhGE1TSgaTSSJofvyoTUJjDGpsPTaRYU2O5wcIx3UdV9do1KNwGlOS7bmU/ZODas8UHoVzFkkxAvZrYDZpbdWhVigIhjKS2BisV2XUL4CTs+l71pU1uWn6yi4LAVwUCVpAjCg1O/+blaQ3+akFtWud5MrGxTKT34pVRuSlANmLAZBwj9axTE5uM2hoEPiGGdISP96uTCrbaH+HrZozjpB0X3Y3bacutY6yRK8NacE6jQVapaejw9z8AQdV0Qn8haz451bK5ia0JahtANULYLO7JAjkTYkZIyDH9UL5PSOIsdphlOoGop5Ci4bafj6PS1BjflCJ4m/N3+YwB2b91MIJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(136003)(376002)(396003)(366004)(122000001)(38100700002)(82960400001)(66946007)(66556008)(38070700005)(76116006)(66476007)(64756008)(4326008)(8676002)(66446008)(478600001)(186003)(66574015)(53546011)(26005)(7696005)(6506007)(9686003)(71200400001)(316002)(41300700001)(110136005)(54906003)(83380400001)(5660300002)(33656002)(8936002)(86362001)(52536014)(55016003)(2906002)(2004002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkF0ZGFZU1hiM0tNbllyTmtTRFRkSWtmVTcyUlQ4LzJVdnNTSjduUlJiSmdr?=
 =?utf-8?B?U2VIbXNBTjExc0JzYm00UGR1OFFTV25Ib1hPUGFMR0tzbFJ3VmxkNXlKZ2I1?=
 =?utf-8?B?d29Fckw5bEJYbFo4SjdrdE5CZk0wUmUrVVBhSTNLLzVFSTZNSXAvNC9zdkd6?=
 =?utf-8?B?ZXk1cGNuZnZEVU8zV252VG1MZ2hRdGJIbm5YZ2JPSzdCMVFSeGVXVVJZUXd3?=
 =?utf-8?B?eWtMRm5WQ2I0NE9tamI3UEFoTTR4QzBlMjcybjZzS1c1OXAzVVRaekhUVnlI?=
 =?utf-8?B?Y0k3TnQ3TS94ZHVpaVo1dk9JZitOVTNBeTdxYmRaY1dsUktsRTN3SVJmSDAv?=
 =?utf-8?B?YnIxd1BVZ1F2ai9PaDdFY3NTbFU1REVIN090L3ZNeVRJTFhKVzR6WThOc1ZP?=
 =?utf-8?B?NTdadG5pWHZZYUlyMmV3YWlZN3NvcmxBWFNLZHQrQ1NWMzhaeFJjWEI4ak5r?=
 =?utf-8?B?d3FUaFhyRU5Oc0lQNUFXWE4vN3ZBN095Ymhlc2JGK0dHT3grbVFNYXhYZm0z?=
 =?utf-8?B?VDJzZ3A4d1ZlK0pEdG5uMUZlV2JlNWxVQzhTNWtVR2UzbVhQeE0wcmtMTnBX?=
 =?utf-8?B?am5pT3drK1lMb1ZyWk4yS2NKbHFQeFZjTlFRUmg0L0lyeXNVaTk3cUFBazNH?=
 =?utf-8?B?N2R5bmJobTF3OWMyWkYxNng2eHRHVUhNWHU2eEM0amJTUU9Dblc4MG5Mb2c5?=
 =?utf-8?B?NlJzZjZhZTFZVmtZZjJ1L2oyL2txYXk3cXZyRCtjQys5MEp1NmJ1Mm85dCsy?=
 =?utf-8?B?QWhiT2ZWNFFtM01RcktRS1FIWTVpZFpqMWNEM3d0cDh2aGpLbm83L1UwdWxt?=
 =?utf-8?B?dXFrZEFCUk16a0VZTmRWeDNhNVE3TVBuRW5uY1VpaHBmM0QzbnNUZU13cXFO?=
 =?utf-8?B?dk9uM21DK3NxRWdpcGR6bnJkL2ltQ0ZpdzZkenZ1UnVKZEtZRm14ZnlvM0pn?=
 =?utf-8?B?dlNwSk5udjJNYnNNL29aYlVXSHZxdVZ6MjZUZzFzTFBFeVlkWHR6UU1LY3lh?=
 =?utf-8?B?SHFhMjE1bnZnTEZUZnZKUTRyMEM2ZTZKSXdCeUJNSk1VUE9CbjV1d1NpbURC?=
 =?utf-8?B?cGlGMTZVWWJPM1BqRGdzL2x4dXRWOUdsS2I2Y1krRGZVS3Z0QklIYjhXdEJ0?=
 =?utf-8?B?UmRJVkExRWVYQzQzQ0dZS1lOQ3VMN3kwblJCREVCZ3hxQ05VTjlRK2xLSXB6?=
 =?utf-8?B?dDlyb1dtY1JmNE1PWWx3dmhnV25vWldXUTlBTVhkRk4raW1XOVc3T0ZWWkdS?=
 =?utf-8?B?NXQ0MG0veHJTK2pVTjJhYWdlM0lrTVNOWEFmTEU2MjYwSXhZZWMyOGkvNm0x?=
 =?utf-8?B?dEl4NVFRd2VjODlpVk43VUEvcFpCWFpRZjNGN2JxTk9Rc0VvejBPVWZBa1RU?=
 =?utf-8?B?ZHllK1A5dHJwWHhsT2FORjN3aUd1K0hPR05qMWI1a014YjZsb2dXZXFidmF3?=
 =?utf-8?B?R2NvcHZhUkd5TWZ0RUlvM05CQnpOV2JIR0xKZWV3VzZHUFRNbHpWcXhoa0Uv?=
 =?utf-8?B?UENYYmRoYTl5YzdFVmxjWXlhM3VQaFROalFNZWF1dzRNVXltUm5SSEMzTWp3?=
 =?utf-8?B?L1UveVNhQWZYUU5hZjhyUmNjbncrWDV0RkdrcGtJVWdiUXV0dTkzV1Znb1Ja?=
 =?utf-8?B?M2l1QjI2MzRscmFwYncyeGUzd3dMRzZnb1NRbXZWVFg3WVp0aG0rclBJQkMr?=
 =?utf-8?B?OTJnTkdEWjUzWFRtbyt1ZFdpWll1R0RjRzFaZ2NpNXpsOEc1YkxlcW1ocU1Z?=
 =?utf-8?B?UDNOUnJDQ3BpLzF1VVVHRk5PTDk1QnBTTmdKMnN3OEdxSVFOd3MxSjh0d0ZR?=
 =?utf-8?B?ekVlN1I5TUZkL1UzV3JoVHUvazZFYjBjV09JMkkxR2x1SkZzRTl2WnNVZXkw?=
 =?utf-8?B?cGdraUpyUm9QYjl1dzdraGRYK2FLaG90bWF2VkJHOTZoRitRVTFCK2ZiNlNK?=
 =?utf-8?B?b3BRdzRVSVFPdFFjd0oycjUvOUFXM1p5WFVyelRoNHU5d1Juc1JCTUg5d2VW?=
 =?utf-8?B?WlA0TzJYZzZNY3lUcnVIN1ZhOERsZ2MvWUVmNjBtTzBoc1duREdEVVpaRnhD?=
 =?utf-8?B?SGlLb29jU08ranNiR3hjTGRNdjZKTEVWWlQ3OGVzWWQvcm5lV0ZmcDFZbSt0?=
 =?utf-8?B?Z1hjN0k0WE5uOHl0MEV2b2tHQVI1Sm42bzEwN3JrZ2Rwd2RIN2VQSXZOVGdW?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc2e3f9a-fdcb-486f-ad07-08da71409c2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 08:59:13.7609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uER6oaBGVnzhTDN24I70MbV1PzvB6RUxnKcYk0PmCG4kyTBLKsBP4gA1AekVjXNgOG1tgOLkPiSQY2uYnNfWyzPzjwJiAzEHSve8qZPcdJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRz
YWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBwacSFdGVrLCAyOSBsaXBjYSAyMDIyIDAwOjIzDQo+
IFRvOiBEcmV3ZWssIFdvamNpZWNoIDx3b2pjaWVjaC5kcmV3ZWtAaW50ZWwuY29tPjsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiBDYzogc3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc7IGduYXVs
dEByZWRoYXQuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggaXByb3V0ZS1uZXh0IHYzIDIvM10g
bGliOiBJbnRyb2R1Y2UgcHBwIHByb3RvY29scw0KPiANCj4gT24gNy8yOC8yMiA1OjAxIEFNLCBX
b2pjaWVjaCBEcmV3ZWsgd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51
eC9wcHBfZGVmcy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3BwcF9kZWZzLmgNCj4gPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uMDAxM2RjNzdlM2I5DQo+ID4g
LS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9wcHBfZGVmcy5oDQo+
ID4gQEAgLTAsMCArMSwzNyBAQA0KPiA+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BM
LTIuMCBXSVRIIExpbnV4LXN5c2NhbGwtbm90ZSAqLw0KPiA+ICsvKg0KPiA+ICsgKiBwcHBfZGVm
cy5oIC0gUFBQIGRlZmluaXRpb25zLg0KPiA+ICsgKg0KPiA+ICsgKiBDb3B5cmlnaHQgMTk5NC0y
MDAwIFBhdWwgTWFja2VycmFzLg0KPiA+ICsgKg0KPiA+ICsgKiAgVGhpcyBwcm9ncmFtIGlzIGZy
ZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcg0KPiA+ICsgKiAgbW9k
aWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UN
Cj4gPiArICogIHZlcnNpb24gMiBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91
bmRhdGlvbi4NCj4gPiArICovDQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBQcm90b2NvbCBmaWVs
ZCB2YWx1ZXMuDQo+ID4gKyAqLw0KPiA+ICsjZGVmaW5lIFBQUF9JUAkJMHgyMQkvKiBJbnRlcm5l
dCBQcm90b2NvbCAqLw0KPiA+ICsjZGVmaW5lIFBQUF9BVAkJMHgyOQkvKiBBcHBsZVRhbGsgUHJv
dG9jb2wgKi8NCj4gPiArI2RlZmluZSBQUFBfSVBYCQkweDJiCS8qIElQWCBwcm90b2NvbCAqLw0K
PiA+ICsjZGVmaW5lCVBQUF9WSkNfQ09NUAkweDJkCS8qIFZKIGNvbXByZXNzZWQgVENQICovDQo+
ID4gKyNkZWZpbmUJUFBQX1ZKQ19VTkNPTVAJMHgyZgkvKiBWSiB1bmNvbXByZXNzZWQgVENQICov
DQo+ID4gKyNkZWZpbmUgUFBQX01QCQkweDNkCS8qIE11bHRpbGluayBwcm90b2NvbCAqLw0KPiA+
ICsjZGVmaW5lIFBQUF9JUFY2CTB4NTcJLyogSW50ZXJuZXQgUHJvdG9jb2wgVmVyc2lvbiA2ICov
DQo+ID4gKyNkZWZpbmUgUFBQX0NPTVBGUkFHCTB4ZmIJLyogZnJhZ21lbnQgY29tcHJlc3NlZCBi
ZWxvdyBidW5kbGUgKi8NCj4gPiArI2RlZmluZSBQUFBfQ09NUAkweGZkCS8qIGNvbXByZXNzZWQg
cGFja2V0ICovDQo+ID4gKyNkZWZpbmUgUFBQX01QTFNfVUMJMHgwMjgxCS8qIE11bHRpIFByb3Rv
Y29sIExhYmVsIFN3aXRjaGluZyAtIFVuaWNhc3QgKi8NCj4gPiArI2RlZmluZSBQUFBfTVBMU19N
QwkweDAyODMJLyogTXVsdGkgUHJvdG9jb2wgTGFiZWwgU3dpdGNoaW5nIC0gTXVsdGljYXN0ICov
DQo+ID4gKyNkZWZpbmUgUFBQX0lQQ1AJMHg4MDIxCS8qIElQIENvbnRyb2wgUHJvdG9jb2wgKi8N
Cj4gPiArI2RlZmluZSBQUFBfQVRDUAkweDgwMjkJLyogQXBwbGVUYWxrIENvbnRyb2wgUHJvdG9j
b2wgKi8NCj4gPiArI2RlZmluZSBQUFBfSVBYQ1AJMHg4MDJiCS8qIElQWCBDb250cm9sIFByb3Rv
Y29sICovDQo+ID4gKyNkZWZpbmUgUFBQX0lQVjZDUAkweDgwNTcJLyogSVB2NiBDb250cm9sIFBy
b3RvY29sICovDQo+ID4gKyNkZWZpbmUgUFBQX0NDUEZSQUcJMHg4MGZiCS8qIENDUCBhdCBsaW5r
IGxldmVsIChiZWxvdyBNUCBidW5kbGUpICovDQo+ID4gKyNkZWZpbmUgUFBQX0NDUAkJMHg4MGZk
CS8qIENvbXByZXNzaW9uIENvbnRyb2wgUHJvdG9jb2wgKi8NCj4gPiArI2RlZmluZSBQUFBfTVBM
U0NQCTB4ODBmZAkvKiBNUExTIENvbnRyb2wgUHJvdG9jb2wgKi8NCj4gPiArI2RlZmluZSBQUFBf
TENQCQkweGMwMjEJLyogTGluayBDb250cm9sIFByb3RvY29sICovDQo+ID4gKyNkZWZpbmUgUFBQ
X1BBUAkJMHhjMDIzCS8qIFBhc3N3b3JkIEF1dGhlbnRpY2F0aW9uIFByb3RvY29sICovDQo+ID4g
KyNkZWZpbmUgUFBQX0xRUgkJMHhjMDI1CS8qIExpbmsgUXVhbGl0eSBSZXBvcnQgcHJvdG9jb2wg
Ki8NCj4gPiArI2RlZmluZSBQUFBfQ0hBUAkweGMyMjMJLyogQ3J5cHRvZ3JhcGhpYyBIYW5kc2hh
a2UgQXV0aC4gUHJvdG9jb2wgKi8NCj4gPiArI2RlZmluZSBQUFBfQ0JDUAkweGMwMjkJLyogQ2Fs
bGJhY2sgQ29udHJvbCBQcm90b2NvbCAqLw0KPiANCj4gdWFwaSBmaWxlcyBhcmUgcGVyaW9vZGlj
YWxseSBzeW5jZWQgZnJvbSBrZXJuZWwgcmVsZWFzZXMuIFRoaXMgaXMgYSBuZXcNCj4gb25lLCBz
byBJIHB1bGxlZCBpbiB0aGUgZmlsZSBmcm9tIHRoZSBwb2ludCBvZiBsYXN0IGhlYWRlcnMgc3lu
Yy4gVGhlDQo+IEFQSSBmaWxlIGZyb20gdGhhdCBzeW5jIGNhdXNlcyBjb21waWxlIGVycm9ycy4g
UGxlYXNlIHJlYmFzZSB0byB0b3Agb2YNCj4gaXByb3V0ZTItbmV4dCB0cmVlLg0KDQpEb25lDQpX
aGF0IGlzIHRoZSBzdGFuZGFyZCBwcm9jZWR1cmUgaW4gc3VjaCBzaXR1YXRpb24/DQpTaG91bGQg
SSBjcmVhdGUgc2VwYXJhdGUgY29tbWl0IHdpdGggdWFwaSB1cGRhdGUsIHNob3VsZA0KSSBub3Qg
aW5jbHVkZSB1YXBpIGNoYW5nZXMgYW5kIGFzayB5b3UgdG8gdXBkYXRlIGl0Pw0K
