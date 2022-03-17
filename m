Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912724DCAE9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbiCQQNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiCQQNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:13:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D155521544A
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647533549; x=1679069549;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hw6H1Xv4ec5bmvwMaIJhKmNWsI+helognqXnDZp+YBc=;
  b=NorstbixRuZ0sbfB8UNflfNAgsaeFYWsondTDD4CkUHuWCLKD2VTCzbv
   xRgDEc4z1gmxHdfsLNyqHcOkn+irXgTcFD/tbWu+5HjBd/5cJife7075v
   So+lq+YTLAjCnaVHJinPvv9/ti+WqS5iNgOWAr1Ug9J3YIWsjO9R7USkw
   H5Kgr+QbdDDf43YYqh0LmHYQxvnaJgSKX/JYyEnTEgfPkpBoLjfqTdfIh
   nqvwppjmenQwpUisjFKBnL1Ryjdl5WTGcqz2yyUMo5Q4FwjlpfweR4OfA
   5gnph0YWodOuEaj0zabw9Ddr2MdZt67btX12/ol0ZTf76gTDSKTWjunxy
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="281696484"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="281696484"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 09:12:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="783884761"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2022 09:11:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 09:11:56 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 09:11:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 17 Mar 2022 09:11:55 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 17 Mar 2022 09:11:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQWK7jGepmCkQyoQyLKlGrjdnL8dwg7SCPr42o/pBErS1mt83GeGf/wTxvDBK9KYza5TVZeqjGsbhVZl05C+VyFaUbUpA9B7/tarIuIiWy0PCtYnVYIuGhMCjDlcTL3mG6zcEW2/w4I84UyXOKcfhaY/JeU/yTQyZJhtZnOqz1jHYSSKNe4lbp1xczJtKwl2Lho+NwwhUB090ZCLEMFJjzmpWPkwozbK896mb39lkFpkv0gNcJCNu/jbknPulm+phIpZL/g7TyzZUz0Mve+u37+drcZyaWfo/NPhu+1btr1NZKC1JS0I6Ypr9W269GZIprpa6eGKDXqGN/VRpDlczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hw6H1Xv4ec5bmvwMaIJhKmNWsI+helognqXnDZp+YBc=;
 b=U1DJctsba+IGh4pv9wtbLPc1sQamu+As+DYlZaz2a7Dn6Wdksn0QTeuBmvXkBw0AWQgUpuKYInvBIkCxPuXQJzqGibmjY4vIf5vLrsObMyWRaMiyo9j0r1TFgWvnwnNF/uvybr3XkBOu/tp5GUaRDRcnlD57pxHdVIkawqfBl271a7xlm5sEFv7SKJitHPdX6LJBUh1DbXj+ev9Fpz5pXK+zDPQPY8iP00WpgMdNEMUXIIuLDhXglYS6XvEUOggr0x/M+gv458DLxKpXyHlLzAyYlss9qwl/+5W9w1i5QNAQERrMlln1mJ1Mvk756jHXmzrhclGi+4jM5GFPEFixew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DM6PR11MB4121.namprd11.prod.outlook.com (2603:10b6:5:199::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 16:11:51 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739%6]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 16:11:51 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        Harald Welte <laforge@gnumonks.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE: [PATCH iproute2-next v5 1/2] ip: GTP support in ip link
Thread-Topic: [PATCH iproute2-next v5 1/2] ip: GTP support in ip link
Thread-Index: AQHYOZnniFoImQzIbEWyeBYJ0JTO86zDa22QgAAwwoCAAAyNAIAAF01w
Date:   Thu, 17 Mar 2022 16:11:51 +0000
Message-ID: <MW4PR11MB57763617C193C52BB0C05E43FD129@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220316110815.46779-1-wojciech.drewek@intel.com>
 <20220316110815.46779-2-wojciech.drewek@intel.com>
 <c1cb87c2-0107-7b0d-966f-b26f44b23d80@gmail.com>
 <MW4PR11MB57765F252A537045612889E4FD129@MW4PR11MB5776.namprd11.prod.outlook.com>
 <YjM/jXnaCDaBrTNX@nataraja> <5d2d7c77-2c08-7c6e-b816-bbab21c36171@gmail.com>
In-Reply-To: <5d2d7c77-2c08-7c6e-b816-bbab21c36171@gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 157fffd8-6cc9-4b3a-a297-08da0830d8af
x-ms-traffictypediagnostic: DM6PR11MB4121:EE_
x-microsoft-antispam-prvs: <DM6PR11MB41210CDE2FADCC798AE873ADFD129@DM6PR11MB4121.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKY+NVXM+05IFX//w78K4AZCiobgf2ZpqMF/5spXBA88yGs8VxqraVKoXleBXAwlIK1udynNXnCpIe1ZKPxJiA9C5+8peSL9HliFbjk1G3pd2d27DqmzyXXX4mum/JyQ2KlfLG7oEbeC0iba1DzAEuZi7V+dB+3olw0TjvK7pLkqun5NZIIngox5GccE+a8o3iwleo/u2xCWQUl9TaXMQaPI3z4hjmCg0lnDdIlQgMwkFXVmNE7/CiZS3mnrn/VpExoi5LQjCO2Ev8L1mARtuGdDW7ecU9eYlzrh3zkb65a9Lne8tERIT6dFClPFQFYKTIH9aTCzv7wL9Oo3Hn0v6uhlXR7u/AwrzOgGVV94xruoj2gVmkaaTPmxPlBjQKWZXlhJ/iK1024ahHIoF2FtcyFu31WcKRoQ/PYkY8l9hmrz9ab2KnC7WSXBHCLfBbeKNrpe3V9Q8WRP6gFyp6iXSj8ccfNZCoCJqVJ/XSlT2/pJ2RU1UjgZRmOUsja36StumwaS0pRWgnGO8/gzjxKsNpRkwWKMqbqAGh+W9iJAK4rNCq0txXNLExA91bcYBoWLSp6vLEuSi26lmmCodJlzUpCri8FjxrqJ3KZbyGllQqZ1kzHVAKCwfVh65Dfg2ktAvoT4WOfGtfXAGedDmym044c71oN0cr/U3BYQAiKSN8E/vsE3h/VeYTT44IcuuTOhx2MoNgknXLeJMKagMPKaZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(4326008)(8676002)(66476007)(64756008)(66446008)(76116006)(66946007)(86362001)(38100700002)(9686003)(71200400001)(508600001)(55016003)(186003)(53546011)(38070700005)(26005)(7696005)(6506007)(110136005)(33656002)(54906003)(8936002)(5660300002)(52536014)(2906002)(122000001)(83380400001)(4744005)(316002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0ExdXlueVFvYnRtUXRmZmZIZEMvU0ZiYU95VkNDd3AreEpLdXdLdTBNajZP?=
 =?utf-8?B?ZmRZSDFYMlFxbUQ3VWNTZE5hMGZjYW9uZCtvb3V5bnl1NEZ4dzl0MTEwbStE?=
 =?utf-8?B?SGs2bDRSUWtmM1p0MHFidkFEbjVLcS9oYlg3bC9jeGZhZHpEek8vVFdHeGc1?=
 =?utf-8?B?UjErdmt0RnBoRWNqcWZqTDBTZ2FPeHVJRUlVR01uTmRwRUJZOHNqY1BqSCtB?=
 =?utf-8?B?K2JmTWRkeHFaZW5iNlIySWIyeVU4N1BwekplYXZIRzMva2xQdnkrMFpaQjBH?=
 =?utf-8?B?QnVEMHBwOWY1MXRlRUVpejMrSXdKdStiQ2RWYVIvMTgxQkI4MWtFdFFsMXh3?=
 =?utf-8?B?b1c4REJXUVdoSlN5cEMwL1UyY2lwbDhUVFY5c09kWmlYdmRnYTVBcnFZdndS?=
 =?utf-8?B?NzM1dEgvUkVwbG1iUlBKck8yUmlQVzNBSzQ1Slh0dW9ianB0UUFZd1J4TmQ2?=
 =?utf-8?B?U3NrcHNScU1USlA4MFRRUUhFOWpVdER4S0pZbjErSXZIR1pNTFVYS3kxakI5?=
 =?utf-8?B?dWI2SVlOVmVoSVNnZUdjY0lXZGZnanE2aTVCeHdKOFZQdFhnTEVGdG5YY0JI?=
 =?utf-8?B?bHgvYXlNbUJYdTR2eGlkVEhMS0FJaDZ4Yk1qYjNYMnkvY2Q1OXlTamJ1NElF?=
 =?utf-8?B?S1lUTGllN292M2NHSFdPWDR2TUtyVDRjZitrZnprMnAydnN1cXZoaWZZbllM?=
 =?utf-8?B?VzJQZHovS2dPQ3RDR2YxMGtSbDFkVWN4SEdBUzUrR2h6S0NMNlJTWlQxdElC?=
 =?utf-8?B?RTUrTVdBMUtoSFF6b05GL3UxNXNNdm1UQThVWnVDSWI1NGN1eTV2NENCR1R1?=
 =?utf-8?B?S3ZYRnlwM3Z0SWhKOHkwWHpLdXl0K1dHY3IyRDFIeER3SElCV0JsQnIyODVZ?=
 =?utf-8?B?SGl1UG42blJrS2tFWTJmUFN6NXJjNG4ybGx2VVdJT1c0SUJPR1FwbGdQQ0ls?=
 =?utf-8?B?NjhWYnh1WFpKWHFxaWw3R0pVOERUU2hpNStheHYzblVpY2g5S3ZnVkNPR2pt?=
 =?utf-8?B?QUtTNXJ6TitZOXZ4L1BpS3ZqeU5KY0RyVGQxWnNORG5wL3Yyb1dtM28zWnQv?=
 =?utf-8?B?RlRZOGg4Z1hjbXZjek1WUDdhSWp2Sm5Zcm5YREFwZmJzT3R2Q0N2R3NrRldZ?=
 =?utf-8?B?dlRMbm81a2pQUXk4VXFYK3lWK04zcXUydjhDNkpXNkdwbGtuVmx1VGFVREY3?=
 =?utf-8?B?SXM1NWVLSWVNK0hhUVJDSzZ2a1d5bDdKcXovUXdnV2xqUjNMb2ZEK2JBL3pX?=
 =?utf-8?B?MG8zV2hmNTFlakViNlBPa3NkT000ODFXZWM2Rk8zd2RoeVpyRXFKNDdOd1Rz?=
 =?utf-8?B?WDdka3BBVXFxY3BmL0pkYitQYzhaODhWYW1ZOVJ5SDVrWTRROVBFNkkzN3hL?=
 =?utf-8?B?TE1qWE1ndVZDWHhGVzd5OTZJNlh1QWZWWVR4WGYwM005WDY2aldGTVp3QTVw?=
 =?utf-8?B?RlJkZmlFaWIyTGFQZ21uUjdvdDFURTlVeXBFZHFyd25NQ2NFV0RNeFRTUGRz?=
 =?utf-8?B?MS93WkloWnQ4VUZWZGtlNUJTOG90d0lhSm5oV3ZCQjlLN2hVeXNCc3ZQa1JI?=
 =?utf-8?B?ekltZ3lZVTlhN2R0V3VNMy9IMnE4SU1MZGE4ZVNVTXVRb0Y4Rml2VE1ZWlJm?=
 =?utf-8?B?dm53UDBqc2xVQUZjbmxTdXFKdTJvZHFNNERQRzJhcWlUVkdsS3gvc3B0Wmxz?=
 =?utf-8?B?YUl2aWJMaEloNStRMkVZa1ZHVUFPYmhZS2R2ZFNmVExBTGs4NlhHeFBKREU5?=
 =?utf-8?B?aHpSOHArYVF4VzJONG5mVVRBNEdaKy92cGkwVHA4YVNFTXRLRTFXZmFNNytG?=
 =?utf-8?B?emFZSE5YRk5DVm4wc0NHQW0rU3FsNG5yb3BUMzF0UzRhOEc4dStLenVuYkh6?=
 =?utf-8?B?MW9MVWhDR2lOUTk1Q1BsL2o4Q29aUTI4OVNMWHZaM3ZuWUx3SGRBeHRVNzM4?=
 =?utf-8?Q?u0LKkvzm8e1jukX8GBEua0fx/DiA1K3Q?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157fffd8-6cc9-4b3a-a297-08da0830d8af
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2022 16:11:51.2094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yAWhdztdByRf8vPgU0G+Dzo42U9F1kHhG2/zkP+AAdVNVBDuTonUIKBQ1u2g8oyZz+boI5PTomGHW7ZCcQKN7P1S8diIZ4fdIjPxAWLSy5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4121
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRz
YWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBjendhcnRlaywgMTcgbWFyY2EgMjAyMiAxNTo0OA0K
PiBUbzogSGFyYWxkIFdlbHRlIDxsYWZvcmdlQGdudW1vbmtzLm9yZz47IERyZXdlaywgV29qY2ll
Y2ggPHdvamNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGlw
cm91dGUyLW5leHQgdjUgMS8yXSBpcDogR1RQIHN1cHBvcnQgaW4gaXAgbGluaw0KPiANCj4gT24g
My8xNy8yMiA4OjAyIEFNLCBIYXJhbGQgV2VsdGUgd3JvdGU6DQo+ID4gSGkgV29qY2llY2gsIERh
dmlkLA0KPiA+DQo+ID4gT24gVGh1LCBNYXIgMTcsIDIwMjIgYXQgMTE6MTE6NDBBTSArMDAwMCwg
RHJld2VrLCBXb2pjaWVjaCB3cm90ZToNCj4gPj4+IGFzIGEgdTMyIGRvZXMgdGhhdCBtZWFuIG1v
cmUgcm9sZXMgbWlnaHQgZ2V0IGFkZGVkPyBTZWVtcyBsaWtlIHRoaXMNCj4gPj4+IHNob3VsZCBo
YXZlIGEgYXR0ciB0byBzdHJpbmcgY29udmVydGVyIHRoYXQgaGFuZGxlcyBmdXR1cmUgYWRkaXRp
b25zLg0KPiA+Pg0KPiA+PiBJIHRoaW5rIG5vIG1vcmUgcm9sZXMgYXJlIGV4cGVjdGVkIGJ1dCB3
ZSBjYW4gYXNrIEhhcmFsZC4NCj4gPg0KPiA+IEkgYWxzbyBkb24ndCBjdXJyZW50bHkga25vdyBv
ZiBhbnkgc2l0dWF0aW9uIHdoZXJlIHdlIHdvdWxkIHdhbnQgdG8gYWRkDQo+ID4gbW9yZSByb2xl
cy4NCj4gPg0KPiANCj4gQmV0dGVyIHNhZmUgdGhhbiBnaXZpbmcgdXNlcnMgd3JvbmcgaW5mb3Jt
YXRpb24uIEkgd291bGQgcHJlZmVyIGlmIHRoaXMNCj4gYXR0cmlidXRlIHRvIHN0cmluZyBjb252
ZXJzaW9uIGhhbmRsZSB0aGUgMiBrbm93biByb2xlcyBhbmQgcmV0dXJuDQo+ICJ1bmtub3duIiBp
ZiBhIG5ldyB2YWx1ZSBwb3BzIHVwLg0KDQpTdXJlLCBJIHdpbGwgaW5jbHVkZSB0aGlzIGluIHRo
ZSA3dGggdmVyc2lvbi4NCg==
