Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E55698B7D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 05:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjBPE40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 23:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBPE4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 23:56:24 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C176BC165;
        Wed, 15 Feb 2023 20:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676523383; x=1708059383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cx83NzUZfIIFuonucq7C/BEzi8Ew7ykdjpOXgyv4U+c=;
  b=jOOYCBlZHOnuAQRNEwkA8Fiq8KTUlqH3tC5VVfybgnSvqfgBdb0/aQg6
   px6js5I9ZbAyiL7KmweL80KBnVrklHUmh9d1D4z3tOZ3OOSGyEfnsN+Rh
   u+j0ZhazvtBuTO835WMAw8p4rZMomTtaULpn6kzUn022lHwgCIcWEFyyi
   hBaGZ3vbzHc7AUfTi4pl0QUNBQtYr2uWanIEUe9RprpxB+7sWkf7tBxSg
   Y991zOK0YxlAw0TWatb/C+kr13+kuFiz80FDIaxZPkzFrtOkNIOERhAdZ
   1QCQMCiwXRawobv13xlU0opc2vbq+b33D9qJatAfgh9KDzwpmh/F0q4AI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="359054090"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="359054090"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 20:56:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="779218417"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="779218417"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 15 Feb 2023 20:56:23 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 20:56:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 20:56:22 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 20:56:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9XZZT1WPa2BFHLn3ZyYuXPPFHzkjk1ZoRtXSMAUaFQrVBZ4Qe0O0XstGTCCdf3fBhw2OBWtPETD7DL8a3OMUK/PR5qD5KlSNtuf/uaMWPScqqd0HSOlQuI6gRAaGyOQe9aOCJxrZfWW0QJ8/glgFJVR17/mBQSq5t/EAaEhwDQwkW4Jlf+OKhdLYaVLhww2Q/HjpbFhXKdgRVz1v49abZALHO+ceOLuSVvoItUZUnnCimQnofBO1QenQDX8wZaQq8WCCLMpQ8yZGCt02ZiA3PiBEUtdA8W74ToAPG6/d9k1lZEP9RbJM32iO/KDHids0BNUCHOwXT6nO26+NSTMlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cx83NzUZfIIFuonucq7C/BEzi8Ew7ykdjpOXgyv4U+c=;
 b=cGhH7L8I8ZtNz3cIGp16QQ7D7UJFLbBsyqdWtEB43gNeF9L769bjkgALp/E7X16zMwnWk9Mjz0xRdV8+nY8oC59qtYj7chy7n5qAKBsKtFQMS8tfRFSW2YJ9uqd97QYBm42BwaPnzbUtt+jFaKJYlF+C752qTuo/JsvwNSWz4H8qXEpx37e0rrnw8f02tRGbH7VhW/HMWZNAdHGA2qcwb8elw6MUgcNEFu9prMoeynXZcR7IC6C8ron2/TolvD+xSwIxBaaAj70jzZ2nxJxZMOWwIah5N2/9UioKvjMZxV2qHYl1kGwH6KrIM+Y21OS2xEZhmZIsc/jFFwgLjTwkUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com (2603:10b6:903:b9::9)
 by DS0PR11MB7406.namprd11.prod.outlook.com (2603:10b6:8:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 04:56:16 +0000
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::ca4b:b3ce:b8a0:f0da]) by CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::ca4b:b3ce:b8a0:f0da%11]) with mapi id 15.20.6086.026; Thu, 16 Feb
 2023 04:56:15 +0000
From:   "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Subject: RE: [PATCH intel-next v4 8/8] i40e: add support for XDP multi-buffer
 Rx
Thread-Topic: [PATCH intel-next v4 8/8] i40e: add support for XDP multi-buffer
 Rx
Thread-Index: AQHZQT0hbpGdu3N3TEq0KQ5WGv+W/q7QF22AgACaFoCAAFFJ8A==
Date:   Thu, 16 Feb 2023 04:56:15 +0000
Message-ID: <CY4PR1101MB23604F7E72CD838A3A4CBC7390A09@CY4PR1101MB2360.namprd11.prod.outlook.com>
References: <20230215124305.76075-1-tirthendu.sarkar@intel.com>
 <20230215124305.76075-9-tirthendu.sarkar@intel.com>
 <Y+zxY07GZ8aI7LrV@lore-desk> <c78c5e12-1c5a-5215-812c-b10d4b892a1b@intel.com>
In-Reply-To: <c78c5e12-1c5a-5215-812c-b10d4b892a1b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR1101MB2360:EE_|DS0PR11MB7406:EE_
x-ms-office365-filtering-correlation-id: 2d7a1be3-6fc3-4225-0cb3-08db0fda2276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8VcW2wVwmy2dZvJssL+cfRkDfZu2edBKKzksrA5W5ot7q1rw0CnVWNqlT2oB07KO8T1QHn6yRuPXxzd78+Gz2zrnvK5W01xDNToy3eemZCRJKSKAsqokbAdyDbZK/YD0IzuYpwgxMt+CJYZ2JAm0BpvPVYbdH7GXVLoR9j3ElEHDr6yMEbg5Q57M/VEAfR2FBm9QdmHyLW5HdaIq+pqTyCz9alG3cKifN8onKnQBwzHEuGd4+Z6KUE5ez7pyXBPYulD7MQj3cuEIk1eVEo5DX5YNmJzWMa8WQEQ9TMpGLbVX5O6vx66mwVNSjTrp4xzOjK9h7OPmJJSt+d9qJZZufckBOaE473c6ovqeUut0T4bFiOSm7FT/bg324AjWIKZWGl0JQ9C20S2rPhEBcWM0yy3L3pUDbju3jGqppTvuK52pwbW15IBXOmeOjnY9AL40lHh/xEanpbLxK57mkHBm0XdvfBTl4cJ4dLA3BYSAQZi9coPu83IOiSRctwbW2neiMiMIbWg10otsCCFdo1DrG/V3f9DLbH0PfUZW+8EEri5gfTgHXBVKrLD6780ObSSK55plM6QjfZumNToRTdRpFTo/DX4DxJt3KABjMRzVBHeTOF9rJDP/QfF/iiVQf3TcosA5djQaXnsCrn1tHw7F+zXKqmaGzWTgfTInbsJukS0Gczy2QpHRZivbikgvBol8YUvGIqjmZLM2rq47VN28PbYl1gRh6cdqmE20CJPrsbJUkM0FLwK4I9m5hxJzvSr1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199018)(82960400001)(8936002)(5660300002)(33656002)(41300700001)(478600001)(966005)(52536014)(71200400001)(54906003)(76116006)(66556008)(7696005)(64756008)(8676002)(66476007)(86362001)(66946007)(110136005)(4326008)(9686003)(66446008)(6506007)(26005)(53546011)(2906002)(38070700005)(55016003)(107886003)(186003)(316002)(38100700002)(122000001)(83323001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MisvRUdnYUVlaGdFQVhGMHB5MEVmOVBCOS83cFNQTENLcUtGZkxsTzM4K0Rj?=
 =?utf-8?B?UUVsYXpJeUVMRWJvSDlXY0IyT2w2ZjRXbnF6ZkluRm8rbVJxb2NsZGNrbnM3?=
 =?utf-8?B?YzZpcDhEK05LQUVibE52eElRZURiVEd6YzBpZmlrRndCWStyaGc1cklRRDRz?=
 =?utf-8?B?TTR3NkxmKzEreC9mS3JMeGRadnRtNVF5RGduV0JlYUtPblhzR0VGT0prZHVI?=
 =?utf-8?B?dGVQQlZVT090R0VZb2FydEJ5dzh3bGZjbGppUDYrcTZpdEZxNDhybDh4ZXBT?=
 =?utf-8?B?ZG8xNDlvVXUwejZNdmZxQWdkcUdsTXFiQk9QUVdrTElyUXBXSWF3Vzh1NGZr?=
 =?utf-8?B?M2J1c0xZMHdGWnNpODJnL1lQOW04dlA0ZTVlQVdmWStzTFBCcnd0QWNRUkZx?=
 =?utf-8?B?MEJkR0ljU0JyTkttMmUzMHFxOC9tTmZuQWo0YllvUFVwdU9RcUJ4allWRFpn?=
 =?utf-8?B?N0NEdmR2SW8zbTg3ckNROWRlL2s3Qnl5bkpRSGNURkZKS256ZStpWUliVUE0?=
 =?utf-8?B?TTliamg2VE45SktreEtVTnVEZk13ZnpvYy95dzQ3MmwrTHMxOWN3bkE0L05N?=
 =?utf-8?B?dEtnNTN4RlhXL1ppSjVQWjJrV29tK0d5b3MraWRPZitMcytPcFA2USt2d3ZJ?=
 =?utf-8?B?cHp0Q3E0c3ZYTlljNzVQb2pQNGFDYWxKZzFXMlU4elpmV1BXVGVzT01KYUVl?=
 =?utf-8?B?eVBZcXNEUVBXdWdwbWxtL25aNFFUUE8vTmkrYkR3bXBwNUluaE9iY0VMeity?=
 =?utf-8?B?ZWN5a291Y3RKRFJOQnp4L2ZGMWtMYUJVVUZreFVtN1FiT2FnclhHek45R1lk?=
 =?utf-8?B?SGtET2JkVDdXT1pUZ3R2WW5XYXJYa3A4eEM5Yk9NNExYNnY2ajVBc0xPaHB3?=
 =?utf-8?B?K1hzbEYwMGFCcFhYcndPa0ZNblgzS0hmYWJQY3hZYllXVzJwZ0Zma3QyZzRt?=
 =?utf-8?B?c0c4enh4emtBOWk2QVY1VC8yV3NmTHBWeWozd3F6b2FvYzQ3S1MvaWNEd1N5?=
 =?utf-8?B?TlNUN2ExZk5NSjErTVpJd3VmUXdTY282cTA4aGVxbi94NTBFOVFwTHdaRXBq?=
 =?utf-8?B?RlEvU3VFWmZST2E5TWZadWpBRXA3VTByMXZ3K3VESk5lNnFUNmFaSjR0UDhj?=
 =?utf-8?B?Z0oxaTI4ZDNzdUs5ZzhzUzVBM0NHN1FHQlZKZkNZZTRXZ0gwQ0ZmTUsyRk9s?=
 =?utf-8?B?S1l5UmtDTjJLa1FjZGs2cEpnMFl3VXZoVFRlK081cUZVSFBMc3NpRXFLSTJZ?=
 =?utf-8?B?Snc2MlJmd08vZ1Mzc3dhOW94a1VFYnE4WlBlSXY1QlhKZGwvbE8xUzFuWnpt?=
 =?utf-8?B?WVZpN0lSQUJUd0UvTmpZRmIrTDVkV0hQTHdVTnMrei9oKzhROXpOVDRBZVpC?=
 =?utf-8?B?YmhQSlZxUTlQanlDNlZwcmJjWXJkNGZqL2lJZFREbGtSdE0xWCtzOFc4MzQv?=
 =?utf-8?B?TWFlWGNCT0tPM2syZnE0OUJuUkpnVDRKeTdsOVB6NjFqdzY5bXBkRjVRVTJZ?=
 =?utf-8?B?d2hieGMzclJVaWRDdTkvYVFuQW1vbHpYN0JzUkZZUkJiWnpRbnV1TVM3RjNQ?=
 =?utf-8?B?NHFkNTVSSUxLQ2lsVlZsV1pKNW1uUVRqZHNIbGIvWFZneTJnQ3FtaWxrQ3Fu?=
 =?utf-8?B?T2FhZ0R4aGRQdTVJZXI5bW1ZRmUyUFB5c005U3Bza2M4dWVtd0gzYUdIdjNY?=
 =?utf-8?B?RjBSTmRDWVIrN0JDR2JTUWtUbTRvRUdyd3NVcE9tR3puS0p4Z3BodGJ1ekc4?=
 =?utf-8?B?MEk2cGwrak9yK2ljZVpPbUF3WVgvZVZVc2hzVnVKL2ltTEsyU0lFQ2hXTE5C?=
 =?utf-8?B?WmVGK2xTUTNhWXlKZHQ3LzVwRW1Vc2Qvc0dFU3kwdEZUOXQ1ckhMRElFSVhz?=
 =?utf-8?B?K3ZQbXJ4RjRNa2kvenZJVFI3WGFscmhPL0VCcVNEMkgweXkvc1AyRjBHZmRS?=
 =?utf-8?B?ZmhxOXc4dGRvQTEwVm5JZ3pFRzBKbzByTEdwb2dsbmZQbm5oVzhKZHB0aWE4?=
 =?utf-8?B?bmhJOStIeHFuYXdzVG41bFhlaTBBOEJaeDV0ODFPT3A4eDF2VlV4SXdrbzFu?=
 =?utf-8?B?cmJJSzNCMmduV0NTeXpiNEcvOFBqc3RkVFZxekdZMUs3RVJYVW5BajhjcjUz?=
 =?utf-8?B?dHJTdDd4NHdqSlhYb1ZVMGQrOHNaczlEZ2htd3hFR2s2VFRIWm5PWjJ3cEdy?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7a1be3-6fc3-4225-0cb3-08db0fda2276
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 04:56:15.8037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Q9uOOvjdhcJgjLyfIXJfDy9yKbscvHWDgS3zjo1sL94p2Ob+hglD8dSdtGUyQQ3fY+ACeYcsXBFmk7yow89DC9Abk/4GSi+wEx90nyZ8NM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7406
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

PiBGcm9tOiBOZ3V5ZW4sIEFudGhvbnkgTCA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+DQo+
IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSAxNiwgMjAyMyA1OjMzIEFNDQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggaW50ZWwtbmV4dCB2NCA4LzhdIGk0MGU6IGFkZCBzdXBwb3J0IGZvciBYRFAgbXVs
dGktYnVmZmVyDQo+IFJ4DQo+IA0KPiBPbiAyLzE1LzIwMjMgNjo1MSBBTSwgTG9yZW56byBCaWFu
Y29uaSB3cm90ZToNCj4gPj4gVGhpcyBwYXRjaCBhZGRzIG11bHRpLWJ1ZmZlciBzdXBwb3J0IGZv
ciB0aGUgaTQwZV9kcml2ZXIuDQo+ID4+DQo+ID4NCj4gPiBbLi4uXQ0KPiA+DQo+ID4+DQo+ID4+
ICAgCW5ldGRldi0+ZmVhdHVyZXMgJj0gfk5FVElGX0ZfSFdfVEM7DQo+ID4+ICAgCW5ldGRldi0+
eGRwX2ZlYXR1cmVzID0gTkVUREVWX1hEUF9BQ1RfQkFTSUMgfA0KPiBORVRERVZfWERQX0FDVF9S
RURJUkVDVCB8DQo+ID4+IC0JCQkgICAgICAgTkVUREVWX1hEUF9BQ1RfWFNLX1pFUk9DT1BZOw0K
PiA+PiArCQkJICAgICAgIE5FVERFVl9YRFBfQUNUX1hTS19aRVJPQ09QWSB8DQo+ID4+ICsJCQkg
ICAgICAgTkVUREVWX1hEUF9BQ1RfUlhfU0c7DQo+ID4NCj4gPiBIaSBUaXJ0aGVuZHUsDQo+ID4N
Cj4gPiBJIGd1ZXNzIHdlIHNob3VsZCBzZXQgaXQganVzdCBmb3IgSTQwRV9WU0lfTUFJTiwgSSBw
b3N0ZWQgYSBwYXRjaCB5ZXN0ZXJkYXkNCj4gPiB0byBmaXggaXQ6DQo+ID4NCj4gaHR0cHM6Ly9w
YXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC9mMmI1MzdmODZiMzRm
YzE3NmYNCj4gYmM2YjNkMjQ5YjQ2YTIwYTg3YTJmMy4xNjc2NDA1MTMxLmdpdC5sb3JlbnpvQGtl
cm5lbC5vcmcvDQo+ID4NCj4gPiBjYW4geW91IHBsZWFzZSByZWJhc2Ugb24gdG9wIG9mIGl0Pw0K
PiANCj4gSmFrdWIsDQo+IA0KPiBJIGJlbGlldmUgeW91IGFyZSBwbGFubmluZyBvbiB0YWtpbmcg
TG9yZW56bydzIGljZSBbMV0gYW5kIGk0MGUgWzJdDQo+IHBhdGNoIGJhc2VkIG9uIHRoZSBjb21t
ZW50IG9mIHRha2luZyBmb2xsb3ctdXBzIGRpcmVjdGx5IFszXT8NCj4gDQo+IElmIHNvLCBUaXJ0
aGVuZHUsIEknbGwgcmViYXNlIGFmdGVyIHRoaXMgaXMgcHVsbGVkIGJ5IG5ldGRldiwgdGhlbiBp
Zg0KPiB5b3UgY2FuIGJhc2Ugb24gbmV4dC1xdWV1ZSBzbyBldmVyeXRoaW5nIHdpbGwgYXBwbHkg
bmljZWx5Lg0KPiANCg0KSSBoYXZlIHJlYmFzZWQgaXQgYW5kIHdpbGwgc2VuZCB0aGUgdjUgb25j
ZSB0aGUgMjRociBjdXJmZXcgb24gc2VuZGluZyBwYXRjaGVzIGlzIG92ZXIuDQoNClJlZ2FyZHMN
ClRpcnRoZW5kdQ0KDQo+IFRoYW5rcywNCj4gVG9ueQ0KPiANCj4gPiBSZWdhcmRzLA0KPiA+IExv
cmVuem8NCj4gDQo+IFsxXQ0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvOGE0NzgxNTEx
YWI2ZTNjZDI4MGU5NDRlZWY2OTE1ODk1NGYxYTE1Zi4xNjcNCj4gNjM4NTM1MS5naXQubG9yZW56
b0BrZXJuZWwub3JnLw0KPiBbMl0NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2YyYjUz
N2Y4NmIzNGZjMTc2ZmJjNmIzZDI0OWI0NmEyMGE4N2EyZjMuMTY3Ng0KPiA0MDUxMzEuZ2l0Lmxv
cmVuem9Aa2VybmVsLm9yZy8NCj4gWzNdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIz
MDIxMzE3MjM1OC43ZGYwZjA3Y0BrZXJuZWwub3JnLw0KDQo=
