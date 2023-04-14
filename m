Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E296E21E3
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 13:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDNLQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 07:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDNLQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 07:16:22 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0DC768D;
        Fri, 14 Apr 2023 04:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681470980; x=1713006980;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i/k6LKcSkDiZ5Qi48ejRjSuRbkEZtMUC1l4ddpvgj9M=;
  b=Lnyvp9a1VBZ1Lcis8i12ti6clxaSWQXO76bgUr00RjnCVP2OAEFYviIr
   WA4d7k0hS5CsqGgP2GsIFVstB7ApuTAgXSBgeN8rjt9PwYZakJM7ARtT7
   o/NGufwjM8PBK15nte3YgUGEUbb6h5gRNsD59nIIJbI5NBP328wncP1G1
   mKztqLS4Q114fu1DjNj2VovEoXGSY4KcAJwgHcojuO07SCidPnIrbkC7M
   AjIFybZILaUwcxm/g/egH3YZvmCmR8yiR4JcLcuYGXLivsgSDhcM4Lssl
   7kyi1NgeQX/weHULLk2hdYFaewWbbjsUtA/NfvyI1OATCcygZgEniINIe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="328589207"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="328589207"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 04:16:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="779157637"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="779157637"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Apr 2023 04:16:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 04:16:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 04:16:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 04:16:18 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 04:16:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXNXyq0ZCAzkvolmUTnFapsmiDT2ieoRiep1A2GrbM0u1U9UOt9zrhE+IXOVCi4MXNor/nC1bH2Hclr6kftRk8CEXYsvvVGX6NpIM+V8EUFHx9b7wQpF5q4cyfTeDpBOoFD6enM4Q/RJwU+dIcPt7XQH3QUWvgQ/JxbHd08HOv3wB80wDe6aCNaoEVUXHsO9dYsUZ+gWFPVi6miiRJSAEkOAflOXLO/A9wLCAg0xfHrmzLnrqQ3E83exY+i5yEQXrOohcHBPW8rlTvMijQU1nrNtD60HZCv1QZ2kOxha4FeBBS0Byn3MpVhv1v9qqbcqqCTziHAt6vaapfAWBzcUQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/k6LKcSkDiZ5Qi48ejRjSuRbkEZtMUC1l4ddpvgj9M=;
 b=Mw9mRfxGlKyzG8dWGneDQMmto6lga8T2T4Zsm83lxpmDeOE+xiYeBwVnIJ8y3VigL5U1G5fbXOFu0UMMPaNahFjNDvRp37vWvVUSuTmsa+hvRKffLozdhdrcjcMX/n8AZUi3BmYUzbRiJZE5j9BfYXNF6gMaVTcegaJnRXX6GQ4rC+yObmiBex6mLVXLSMDtuboJKppfpxqJnpUOwb/k4+Bypy0TykhreiGFpIcEEAtbed1Q2GUPA6oVc7yTlSb1E2APUZazMVYTmXkKhGjheWOisjnzItsDbZRFOD5YPV9alpch5pI06Uz0oz5uOLkdfg23RY/aA4db4QH0XwwCYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by SA1PR11MB6943.namprd11.prod.outlook.com (2603:10b6:806:2bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Fri, 14 Apr
 2023 11:15:45 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Fri, 14 Apr 2023
 11:15:45 +0000
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
        Stanislav Fomichev <sdf@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net v2 1/1] igc: read before write to SRRCTL register
Thread-Topic: [PATCH net v2 1/1] igc: read before write to SRRCTL register
Thread-Index: AQHZbnY42u7Gz9ET40eYzbfYWKvVVq8qkCGAgAAQJMA=
Date:   Fri, 14 Apr 2023 11:15:45 +0000
Message-ID: <PH0PR11MB5830D3F9144B61A6959A4A0FD8999@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230414020915.1869456-1-yoong.siang.song@intel.com>
 <8214fb10-8caa-4418-8435-85b6ac27b69e@redhat.com>
In-Reply-To: <8214fb10-8caa-4418-8435-85b6ac27b69e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|SA1PR11MB6943:EE_
x-ms-office365-filtering-correlation-id: 54a8203d-51ec-4271-8697-08db3cd997d6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KLiq7BvJc+dmZ+CUXbc59ft2bRqPtz0cotwqh/RbRxzpB3BPxn2eYbB2BJdYJjJOuJakBOuIHOczWR+0ir4C/1EspBQX3EcM8FSnEEhcMni0v//2QBrkzuUZPxRWS+W7SByeiVNtA1V8XmxPvfgE8+WeSBux49NUEebW4T9U6DuJq4DwwZ4NePf+krSFhtADZ27pYNjIhuhqQ4u9/ToZBrDYBUKnsib7vCX7sGXhThM4blLlA8VIjJmkRrOsTYn2YSFb3+uESvpxwU5zwu20nWncb1zb+daXZx8ydom0qx69jO/4lUwpdW54OS60GlpeXxCeokkqDfK36QxkqQ96Xz3VPGtZK09H7m2drm2FCywLV9gfIMkD0ib7QtRrQp5bW5RKovo/gkpR8uFDOmBZqT0YM/bWDFOD+8k0SrGeB3dcCcXIzPV00Cxwvki0vwc44Ds6+KMsQeiXhprACdS1UoYudiAeHvfJUQEQLsHQeSRNKlseL6QsEgb4RNyqFS/YZTBhzFLsxofRuqfQ0J4HEe9kePNCtZ1qlwODiPxlR/9j+6xJebXaGbXAZ8YD1sz9LbOmKm+7e0x7roYhULG2QV4RdlQtZZ2kqFYH8jF5RCAYm6okvU70nwW3mQTcmumo1Lhs1atcCWaopIwl8eV/OQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(38100700002)(7416002)(921005)(71200400001)(7696005)(55016003)(52536014)(5660300002)(83380400001)(2906002)(38070700005)(6636002)(55236004)(54906003)(110136005)(6506007)(186003)(478600001)(33656002)(53546011)(86362001)(26005)(9686003)(66446008)(4326008)(122000001)(76116006)(66556008)(66946007)(66476007)(64756008)(82960400001)(8676002)(8936002)(41300700001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2hhTTVlL2pmUmhhN2VGc0Y5Z0d0RHhWVlVDTlR2TjFDZ285a2ZURXNyeDFT?=
 =?utf-8?B?VDBXdTZwcHRXQ0R5emxlVHNNdkNocHQ5d3lqYUZlMGNjN2cvUzFEdEU0UkJs?=
 =?utf-8?B?Z3lBbks2bkM0REpTUGw4d1hlSUdDc0VsMHY1RU9kTDMyeVg2UDNuK0hEbWJS?=
 =?utf-8?B?UUJtVHEwTVo5L0Q3dThWUG12UkVJWG5zM3c4c2o3VEcrcU9MVy8zeVROTlIy?=
 =?utf-8?B?QlgrcXUySGJwR2xHeUN0UmtHL0VWSWtlL1N4WnkrZCthZU9nZU9MellZSTc3?=
 =?utf-8?B?R2t5citJaHgzOURrc29WTFJjU1JjcHJTSEMzem1weC9uaTlGRjJ4VmtLU3Z0?=
 =?utf-8?B?aWwxUndwUENkUDdQUTd1WnE0K0dKczRMZVg2Q3EySTlrYk5PWEhSY2FYS2Z0?=
 =?utf-8?B?UnpacDFkcTJwbllZMHJlNGIrVG9QdjEyU1d4QnYzSzR6M2hmblRqZHQyZEJH?=
 =?utf-8?B?UllnS2JXakw5cUpYYVVYREV4V2hlSGw0U051Z2NSOHdieXZIVG5lbTM2YzRi?=
 =?utf-8?B?enhvanEzSzdTdVEzakJQdEY4cGFLQUc0K016K0doWk1aUlpRODBMUy94Skxa?=
 =?utf-8?B?UzhSeEkzQ3g4aWdnNWRPMkVKaUlMaUxEZVBEa1lJOXBJdXJ3a3FaYlVyTm9q?=
 =?utf-8?B?bVJCVWtTZFQ5dHZ4Tk9ZVnZodjZsYWl1ZmlDVmw4cHdjUEJOZlpNSXN4U0xN?=
 =?utf-8?B?M01GcFVEL0U1eVVhNi9lVDhiNUtZaHBpL2RqVzg4Ni9LcWdMTkQ4N2QwM0hW?=
 =?utf-8?B?cU1POG42bGE3TWcwZWZRUFFFajJTeGFEV2poMDArazd0dExZcU1QUWNWMFRz?=
 =?utf-8?B?Y1BVZ1BrMWRXUWY5M1hJWkhVY2FDMVE0b1NiSzBpSHpncXNDZU42cWdwcFRT?=
 =?utf-8?B?S09qdm03b0J2Mm16NU1iLytqNElUYUdHUFRRYTJWRTVZcXZrajZVeUZNYi93?=
 =?utf-8?B?NzhPNnhzSWdNbVM4Z1pqQlJVYzVsNk53VjdJa01vWFQ2UHlWdFdBM0FhRDFV?=
 =?utf-8?B?RjVFZXlLMGlucDdpalNvUGc4bWZncUwvdGRLM1VBWXBpTjhrVFJOQy9UcFE4?=
 =?utf-8?B?bHRIcTZpM3ZKZjlZUUFjRGZVaHN3NUgvWUJNcDJZelpDTmVyeFFWeHZxY05V?=
 =?utf-8?B?K3BqajdxZWlKcnRlZEh1RWcwSnEwVEQxWUtZNWVLS1pnTWtLZ3lxcXhITVV3?=
 =?utf-8?B?YVBGbXU0NGltSnh4MFNCUkxxQWNCU3I4TDRMTFJOYVZSVS9VVkpOTitOWWdK?=
 =?utf-8?B?NXBTOXZ6aVlXOHZUclY2bEdxTm1iSFM0ekwvdXNHdU1MeFFuWjFtQXdsZFdP?=
 =?utf-8?B?emFCQ29oamVhcU93RFlWcGEwRVpMTFRwSGFGclI2T3BnaDZZdnNoTUdhWnJW?=
 =?utf-8?B?U3pVK0V5V01xSGY5OGdxU0NqSmRiWk1UcWpuMmdVV1BhWld6N3ovODQzNFFn?=
 =?utf-8?B?NXZsWEwxVmViSlhnZUlUZHIvakVzMDFEOFRvZ0pyL2E2TE54b3R6VElOMjFM?=
 =?utf-8?B?bmtEQW8rRDNiS3BhSytjRkNhRzBrZU5ZMEJjMll0OUpaL0U1NlpXY1VsWWg2?=
 =?utf-8?B?bVpreTVsclp3MktoNkpiUHdkMVdhQTRZM21xMUF3L0VpU05OQkZwUUtoTnVh?=
 =?utf-8?B?RDdQL0FlQXJkdWx1ZlNhNGlaUElnNy9TK1FNclo2R3poYmFJLytQOFNYZGlS?=
 =?utf-8?B?eXNDZDBQemg3QXpkYzAyell5ZkJTN1lNSldhWjkwQ2xsaDFvNnp5cU1RRlpC?=
 =?utf-8?B?ME5oT2Z1Y1VZTW0zN2JsZC9UaEp4Y2ZINVFqSS9IelhrdlowRk95a3hETXR0?=
 =?utf-8?B?L1JVdmtKblVKL2tVaU1xck1LQnZrcmUyRzZMb3BTZFNlbTFZWUl0NlljN01M?=
 =?utf-8?B?eHptZG84ZHJsSDQzZDIyMVAxcHVZU0xtQlRIVUZ4M2piVjZyUDJVd1hsdGlC?=
 =?utf-8?B?LzlvTndDWHE4dFNyRlJ6djRFYmcrOGY1QkdBWnR4TnN1dUR5YitXbm81RjF0?=
 =?utf-8?B?VlJHa1hkcU5DVnduMGd2YnhvckpzSi9NNzIybFp1T2dPbCtGR3NLRFBJWjVH?=
 =?utf-8?B?WXNTZGwyUVVSN0ZTWWpVSG9NS1VtRFUxcFJsSUpkMTBsTGw5NHZiMjloMEFY?=
 =?utf-8?Q?6sCV5lmvzP6OupK/gG5hbEIlz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a8203d-51ec-4271-8697-08db3cd997d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 11:15:45.5901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y/JA4gB92QfvBFMlFr3Kr+X4CmrAVZrYEbfV4tCAKpv+0+jpstHJHvjd41Wy/q4kkashijyAjN8raNlwCPj4pclflsPSCboSrkOMYULPZJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6943
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBBcHJpbCAxNCwgMjAyMyA1OjUwIFBNLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IDxqYnJvdWVyQHJlZGhhdC5jb20+IHdyb3RlOg0KPk9uIDE0LzA0LzIwMjMgMDQuMDksIFNvbmcg
WW9vbmcgU2lhbmcgd3JvdGU6DQo+PiBpZ2NfY29uZmlndXJlX3J4X3JpbmcoKSBmdW5jdGlvbiB3
aWxsIGJlIGNhbGxlZCBhcyBwYXJ0IG9mIFhEUCBwcm9ncmFtDQo+PiBzZXR1cC4gSWYgUnggaGFy
ZHdhcmUgdGltZXN0YW1wIGlzIGVuYWJsZWQgcHJpbyB0byBYRFAgcHJvZ3JhbSBzZXR1cCwNCj4+
IHRoaXMgdGltZXN0YW1wIGVuYWJsZW1lbnQgd2lsbCBiZSBvdmVyd3JpdHRlbiB3aGVuIGJ1ZmZl
ciBzaXplIGlzDQo+PiB3cml0dGVuIGludG8gU1JSQ1RMIHJlZ2lzdGVyLg0KPj4NCj4+IFRodXMs
IHRoaXMgY29tbWl0IHJlYWQgdGhlIHJlZ2lzdGVyIHZhbHVlIGJlZm9yZSB3cml0ZSB0byBTUlJD
VEwNCj4+IHJlZ2lzdGVyLiBUaGlzIGNvbW1pdCBpcyB0ZXN0ZWQgYnkgdXNpbmcgeGRwX2h3X21l
dGFkYXRhIGJwZiBzZWxmdGVzdA0KPj4gdG9vbC4gVGhlIHRvb2wgZW5hYmxlcyBSeCBoYXJkd2Fy
ZSB0aW1lc3RhbXAgYW5kIHRoZW4gYXR0YWNoIFhEUA0KPj4gcHJvZ3JhbSB0byBpZ2MgZHJpdmVy
LiBJdCB3aWxsIGRpc3BsYXkgaGFyZHdhcmUgdGltZXN0YW1wIG9mIFVEUA0KPj4gcGFja2V0IHdp
dGggcG9ydCBudW1iZXIgOTA5Mi4gQmVsb3cgYXJlIGRldGFpbCBvZiB0ZXN0IHN0ZXBzIGFuZCBy
ZXN1bHRzLg0KPj4NCj4+IENvbW1hbmQgb24gRFVUOg0KPj4gICAgc3VkbyAuL3hkcF9od19tZXRh
ZGF0YSA8aW50ZXJmYWNlIG5hbWU+DQo+Pg0KPj4gQ29tbWFuZCBvbiBMaW5rIFBhcnRuZXI6DQo+
PiAgICBlY2hvIC1uIHNrYiB8IG5jIC11IC1xMSA8ZGVzdGluYXRpb24gSVB2NCBhZGRyPiA5MDky
DQo+Pg0KPj4gUmVzdWx0IGJlZm9yZSB0aGlzIHBhdGNoOg0KPj4gICAgc2tiIGh3dHN0YW1wIGlz
IG5vdCBmb3VuZCENCj4+DQo+PiBSZXN1bHQgYWZ0ZXIgdGhpcyBwYXRjaDoNCj4+ICAgIGZvdW5k
IHNrYiBod3RzdGFtcCA9IDE2Nzc4MDA5NzMuNjQyODM2NzU3DQo+Pg0KPj4gT3B0aW9uYWxseSwg
cmVhZCBQSEMgdG8gY29uZmlybSB0aGUgdmFsdWVzIG9idGFpbmVkIGFyZSBhbG1vc3QgdGhlIHNh
bWU6DQo+PiBDb21tYW5kOg0KPj4gICAgc3VkbyAuL3Rlc3RwdHAgLWQgL2Rldi9wdHAwIC1nDQo+
PiBSZXN1bHQ6DQo+PiAgICBjbG9jayB0aW1lOiAxNjc3ODAwOTczLjkxMzU5ODk3OCBvciBGcmkg
TWFyICAzIDA3OjQ5OjMzIDIwMjMNCj4+DQo+PiBGaXhlczogZmM5ZGYyYTBiNTIwICgiaWdjOiBF
bmFibGUgUlggdmlhIEFGX1hEUCB6ZXJvLWNvcHkiKQ0KPj4gQ2M6IDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPiAjIDUuMTQrDQo+PiBTaWduZWQtb2ZmLWJ5OiBTb25nIFlvb25nIFNpYW5nIDx5b29u
Zy5zaWFuZy5zb25nQGludGVsLmNvbT4NCj4+IFJldmlld2VkLWJ5OiBKYWNvYiBLZWxsZXIgPGph
Y29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4+IC0tLQ0KPg0KPlJldmlld2VkLWJ5OiBKZXNwZXIg
RGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4NCj4+IHYyIGNoYW5nZWxvZzoN
Cj4+ICAgLSBGaXggaW5kZW50aW9uDQo+PiAtLS0NCj4+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWdjL2lnY19iYXNlLmggfCA3ICsrKysrLS0NCj4+ICAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaWdjL2lnY19tYWluLmMgfCA1ICsrKystDQo+PiAgIDIgZmlsZXMgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX2Jhc2UuaA0KPj4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pZ2MvaWdjX2Jhc2UuaA0KPj4gaW5kZXggN2E5OTJiZWZjYTI0Li5iOTUw
MDdkNTFkMTMgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2Mv
aWdjX2Jhc2UuaA0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19i
YXNlLmgNCj4+IEBAIC04Nyw4ICs4NywxMSBAQCB1bmlvbiBpZ2NfYWR2X3J4X2Rlc2Mgew0KPj4g
ICAjZGVmaW5lIElHQ19SWERDVExfU1dGTFVTSAkJMHgwNDAwMDAwMCAvKiBSZWNlaXZlDQo+U29m
dHdhcmUgRmx1c2ggKi8NCj4+DQo+PiAgIC8qIFNSUkNUTCBiaXQgZGVmaW5pdGlvbnMgKi8NCj4N
Cj5JIGhhdmUgY2hlY2tlZCBGb3h2aWxsZSBtYW51YWwgZm9yIFNSUkNUTCAoU3BsaXQgYW5kIFJl
cGxpY2F0aW9uIFJlY2VpdmUNCj5Db250cm9sKSByZWdpc3RlciBhbmQgYmVsb3cgR0VOTUFTS3Mg
bG9va3MgY29ycmVjdC4NCj4NCj4+IC0jZGVmaW5lIElHQ19TUlJDVExfQlNJWkVQS1RfU0hJRlQJ
CTEwIC8qIFNoaWZ0IF9yaWdodF8gKi8NCj4+IC0jZGVmaW5lIElHQ19TUlJDVExfQlNJWkVIRFJT
SVpFX1NISUZUCQkyICAvKiBTaGlmdCBfbGVmdF8gKi8NCj4+ICsjZGVmaW5lIElHQ19TUlJDVExf
QlNJWkVQS1RfTUFTSwlHRU5NQVNLKDYsIDApDQo+PiArI2RlZmluZSBJR0NfU1JSQ1RMX0JTSVpF
UEtUX1NISUZUCTEwIC8qIFNoaWZ0IF9yaWdodF8gKi8NCj4NCj5TaGlmdCBkdWUgdG8gMSBLQiBy
ZXNvbHV0aW9uIG9mIEJTSVpFUEtUIChtYW51YWwgZmllbGQgQlNJWkVQQUNLRVQpDQoNCllhLCAx
SyA9IEJJVCgxMCksIHNvIG5lZWQgdG8gc2hpZnQgcmlnaHQgMTAgYml0cy4NCg0KPg0KPj4gKyNk
ZWZpbmUgSUdDX1NSUkNUTF9CU0laRUhEUlNJWkVfTUFTSwlHRU5NQVNLKDEzLCA4KQ0KPj4gKyNk
ZWZpbmUgSUdDX1NSUkNUTF9CU0laRUhEUlNJWkVfU0hJRlQJMiAgLyogU2hpZnQgX2xlZnRfICov
DQo+DQo+VGhpcyBzaGlmdCBpcyBzdXNwaWNpb3VzLCBidXQgYXMgeW91IGluaGVyaXRlZCBpdCBJ
IGd1ZXNzIGl0IHdvcmtzLg0KPkkgZGlkIHRoZSBtYXRoLCBhbmQgaXQgaGFwcGVucyB0byB3b3Jr
LCBrbm93aW5nIChmcm9tIG1hbnVhbCkgdmFsdWUgaXMgaW4gNjQgYnl0ZXMNCj5yZXNvbHV0aW9u
Lg0KDQpJdCBpcyBpbiA2NCA9IEJJVCg2KSByZXNvbHV0aW9uLCBzbyBuZWVkIHRvIHNoaWZ0IHJp
Z2h0IDYgYml0cy4NCkJ1dCBpdCBzdGFydCBvbiA4dGggYml0LCBzbyBuZWVkIHRvIHNoaWZ0IGxl
ZnQgOCBiaXRzLg0KVGh1cywgdG90YWwgPSBzaGlmdCBsZWZ0IDIgYml0cy4NCg0KSSBkaW50IHB1
dCB0aGUgZXhwbGFuYXRpb24gaW50byB0aGUgaGVhZGVyIGZpbGUgYmVjYXVzZSBpdCBpcyB0b28g
bGVuZ3RoeQ0KYW5kIHVzZXIgY2FuIGtub3cgZnJvbSBkYXRhYm9vay4NCg0KSG93IGRvIHlvdSBm
ZWVsIG9uIHRoZSBuZWNlc3Nhcnkgb2YgZXhwbGFpbmluZyB0aGUgc2hpZnRpbmcgbG9naWM/DQog
DQo+DQo+PiArI2RlZmluZSBJR0NfU1JSQ1RMX0RFU0NUWVBFX01BU0sJR0VOTUFTSygyNywgMjUp
DQo+PiAgICNkZWZpbmUgSUdDX1NSUkNUTF9ERVNDVFlQRV9BRFZfT05FQlVGCTB4MDIwMDAwMDAN
Cj4NCj5HaXZlbiB5b3UgaGF2ZSBzdGFydGVkIHVzaW5nIEdFTk1BU0soKSwgdGhlbiBJIHdvdWxk
IGhhdmUgdXBkYXRlZA0KPklHQ19TUlJDVExfREVTQ1RZUEVfQURWX09ORUJVRiB0byBiZSBleHBy
ZXNzZWQgbGlrZToNCj4NCj4gICNkZWZpbmUgSUdDX1NSUkNUTF9ERVNDVFlQRV9BRFZfT05FQlVG
IEZJRUxEX1BSRVAoSUdDX1NSUkNUTF9ERVNDVFlQRV9NQVNLLCAweDEpDQo+DQo+TWFraW5nIGl0
IGVhc2llciB0byBzZWUgY29kZSBpcyBzZWxlY3Rpbmc6DQo+ICAwMDFiID0gQWR2YW5jZWQgZGVz
Y3JpcHRvciBvbmUgYnVmZmVyLg0KPg0KPkFuZCBub3QgKGFzIEkgZmlyc3QgdGhvdWdoKToNCj4g
IDAxMGIgPSBBZHZhbmNlZCBkZXNjcmlwdG9yIGhlYWRlciBzcGxpdHRpbmcuDQo+DQoNCllvdSBh
cmUgcmlnaHQuIFVzaW5nIEZJRUxEX1BSRVAoKSBtYWtlIHRoZSBjb2RlIGNsZWFyZXIuIA0KVGhh
bmtzIGZvciB5b3VyIHN1Z2dlc3Rpb24uIEkgd2lsbCBzdWJtaXQgdjMgZm9yIGl0Lg0KDQo+DQo+
PiAgICNlbmRpZiAvKiBfSUdDX0JBU0VfSCAqLw0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jDQo+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2lnYy9pZ2NfbWFpbi5jDQo+PiBpbmRleCAyNWZjNmM2NTIwOWIuLjg4ZmFjMDhkOGEx
NCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFp
bi5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4uYw0K
Pj4gQEAgLTY0MSw3ICs2NDEsMTAgQEAgc3RhdGljIHZvaWQgaWdjX2NvbmZpZ3VyZV9yeF9yaW5n
KHN0cnVjdCBpZ2NfYWRhcHRlcg0KPiphZGFwdGVyLA0KPj4gICAJZWxzZQ0KPj4gICAJCWJ1Zl9z
aXplID0gSUdDX1JYQlVGRkVSXzIwNDg7DQo+Pg0KPj4gLQlzcnJjdGwgPSBJR0NfUlhfSERSX0xF
TiA8PCBJR0NfU1JSQ1RMX0JTSVpFSERSU0laRV9TSElGVDsNCj4+ICsJc3JyY3RsID0gcmQzMihJ
R0NfU1JSQ1RMKHJlZ19pZHgpKTsNCj4+ICsJc3JyY3RsICY9IH4oSUdDX1NSUkNUTF9CU0laRVBL
VF9NQVNLIHwNCj5JR0NfU1JSQ1RMX0JTSVpFSERSU0laRV9NQVNLIHwNCj4+ICsJCSAgICBJR0Nf
U1JSQ1RMX0RFU0NUWVBFX01BU0spOw0KPj4gKwlzcnJjdGwgfD0gSUdDX1JYX0hEUl9MRU4gPDwg
SUdDX1NSUkNUTF9CU0laRUhEUlNJWkVfU0hJRlQ7DQo+PiAgIAlzcnJjdGwgfD0gYnVmX3NpemUg
Pj4gSUdDX1NSUkNUTF9CU0laRVBLVF9TSElGVDsNCj4+ICAgCXNycmN0bCB8PSBJR0NfU1JSQ1RM
X0RFU0NUWVBFX0FEVl9PTkVCVUY7DQo+Pg0KDQo=
