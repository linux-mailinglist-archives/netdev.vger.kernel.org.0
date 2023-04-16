Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064D46E34B5
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 04:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDPCTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 22:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDPCTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 22:19:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44072212E;
        Sat, 15 Apr 2023 19:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681611574; x=1713147574;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QKD1UOJuatQpubXWeizwbaVs8yUswmSPdYNKZ65U8Yw=;
  b=nZs+0fYHJPnr5vZGDHxcgj01rJ1AhFw4KrB01CPHmhEgZL5qOfUwzOq4
   Q8c659HeCVMRda5ktjjpqu5sjT1uXXYaRexa7O5orIpDmM8/cZb/+4NAK
   IwHsfGMZbv1fpqmbkBj+pDfZzWq1H8BUxjvTGj75zkajkSxxJUJWLwuDm
   K1plNb4sgSIYiaJtLD+3L0988e2EoHXyr/YrONFEMpANiasSgUTsHCi3J
   kW6Rqun+raCVs16tWg0jjNJK9hkJwWvmvCbQAyNXZViqAjaaKIj1ajvcc
   0FUM3QenbAsP9R5AcIrbt24UpioySKJZj65RS/N1qEsy43CiozSZXU+pT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10681"; a="372571732"
X-IronPort-AV: E=Sophos;i="5.99,201,1677571200"; 
   d="scan'208";a="372571732"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2023 19:19:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10681"; a="690258380"
X-IronPort-AV: E=Sophos;i="5.99,201,1677571200"; 
   d="scan'208";a="690258380"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 15 Apr 2023 19:19:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 15 Apr 2023 19:19:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 15 Apr 2023 19:19:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 15 Apr 2023 19:19:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 15 Apr 2023 19:19:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZRzwYq/g8H1Gk08Or1vTmb6n8D74b0OeGDXnzmQgQ9MGhXrGhqCqlWWYRqG1i+UutHa2PYXykdP5GPWLp8sauRo+4MXUBFQNwITNwdA7CLlltVp5qOcqy1x7ve2cyAMwEyUiJIvhwFEmxw7+lUGXWDy3Aabva/e0Z3F58pJi1fjbMUZBFnUVn4UG0HYHqTBc2k4PSyOq0oKBWusuX3E1FY98pLaMKhMgP82qzVX042p5wq9Pvo1U0lail6Um73UPGviZh88pUC8G2oy/acLdoKdlPipcycH5J6YqfDy2Fii5lDeUU8+xmrEnHmPyWqFJyZmeLYelD0jY7I9EFiEog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QKD1UOJuatQpubXWeizwbaVs8yUswmSPdYNKZ65U8Yw=;
 b=LWUKNDupUGteoDnzRrBGFJcQsYQfb1Jj6X8Poga3+X796SGVGUl7HW0elomvUQ6FUKoLOkr6uzuCA1yDdk2ydZsj2DYxih8veFmtGQxFTJSIS2nk4dQLkAItO6Xz6OHPWB2nPETpOKNCfwPDXXs5utEVnwpgZMtsqSggs49VX43kmXFxIlfBJMvPViqIfkKK9fZuVHIxrK/OcfraSM01zjuZBPKKlurJ0c4UYDkXU6Z9ZMkFi5b/Qlx+vn4BGVOzIcASpdm0jgzKh8Ff8RfhUgoFSh6xQt6crhgPvhRBG5Hz3F7I/w3hg3jJKIvFKxKwmwHhxn6eaeQt9Xn9m3dbWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by CH3PR11MB8383.namprd11.prod.outlook.com (2603:10b6:610:171::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.49; Sun, 16 Apr
 2023 02:19:26 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Sun, 16 Apr 2023
 02:19:26 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
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
        "Brouer, Jesper" <brouer@redhat.com>,
        "Stanislav Fomichev" <sdf@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        David Laight <David.Laight@ACULAB.COM>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net v3 1/1] igc: read before write to SRRCTL register
Thread-Topic: [PATCH net v3 1/1] igc: read before write to SRRCTL register
Thread-Index: AQHZbujC4ewv1e0L1E6tM68Rf5TZ1K8sGQAAgAEWu5A=
Date:   Sun, 16 Apr 2023 02:19:26 +0000
Message-ID: <PH0PR11MB58306BDB63286338EABAF61AD89F9@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230414154902.2950535-1-yoong.siang.song@intel.com>
 <ffa2551d-ca04-3fe9-944a-0383e1d079e3@siemens.com>
In-Reply-To: <ffa2551d-ca04-3fe9-944a-0383e1d079e3@siemens.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|CH3PR11MB8383:EE_
x-ms-office365-filtering-correlation-id: eecfda88-841d-45b0-ad29-08db3e21006f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: smhoyYQeB7K/FMb3zy5W0ZhAlgXpRP+JJ7mocmzvzYBpjlYQkELEgsxkqJEPEpL2FyLVSdrXMl1w+MAd120+JaiAiUMbnRrMqKDWAdTEijMkuYaRzFU4FQjBBNKyJbD5eXyHMSGIxmbsyQ2/29HR9SZx7xJ/uRYtnEkUxpFOAz0cs2tGGt5GoZMDZE9tbaNPSE5KJRvd1hNnnuX57wujbJXVRtTTfXkRfvIjlCD+sfg5vDr6AF4R1nhgbHWdHbti7CDSELorf7z/provEnpvt05jbF3G1bKeKsaHtJJlcGAioAXJy3iOjSIl2s6x8uqAEBEeDCpmHsYWZwqXnNQ+AVkTt03g0Vhon1Q0tERH2ITs88eAbGD0nLXCCgVnACZPRUoejRIgPTlA6ebDn57yYHtqVrTQYZ6EMNwiaV9Kjz/PGXqUAVH7J/57crkLnbU6+U0Zfr+MYsHTTBDH2/XOtOuxzucaU/jKUNkvIjDid8IsiNH2eoYAo8jIZgMAaVwwLg+Nt6UhKRdsz/PgfH46vsq6FZW1dThlfYgt4f1q3FXd8CjeaAiFTYEhuMOMjCG/K0gVL7/TXyIJvYfrlkc6/L36LXxo3WWvP9vDiiV+IQri4tvFDb7zlRRkexxhdNZ0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199021)(41300700001)(316002)(38100700002)(64756008)(186003)(66946007)(110136005)(9686003)(86362001)(66446008)(76116006)(66476007)(66556008)(7416002)(6506007)(8676002)(4326008)(26005)(55236004)(53546011)(38070700005)(83380400001)(921005)(122000001)(82960400001)(33656002)(8936002)(54906003)(2906002)(5660300002)(55016003)(52536014)(71200400001)(478600001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzFsbm93ZlNkTzUrQWozNktiWVNaUXV0cWFOTGJCTkM4bnUydVI1dkZZZzVP?=
 =?utf-8?B?WnU4OU5hWS94bExJUmM0S2JjMDVOUVgrSTljTHRWL1Rtems5RHlGR0lnbjN4?=
 =?utf-8?B?Mjd3dzlSbXNhTC9UdktxQ0sxa0ttYUVyblFMcmlVQzlPWWxNai8wWm9STU84?=
 =?utf-8?B?T1JFLys1VWJ3YmU0RVBRQXdRSk1ZQVFGUGRaQlQzeEJDWnNFVzFzRWRXSVcx?=
 =?utf-8?B?cjVYeXBkMVl3SFVyWTZkOTlkajVhVHNLTmFJVXFkNXVJYVFoWEdyUTFqMXVW?=
 =?utf-8?B?YUl1WUV0dVhFUjYySGhSaGM2Vm1xa0M2eXM3NHd1NXViWEVxMFMvbHFHZVRx?=
 =?utf-8?B?MStjaysxWURUYWt1UjdzRkFqM2FKK0ZEWnV1Vjl0dWxxT0R2MW85OW9yY2g3?=
 =?utf-8?B?QjhaWmlyYlNhcHdzUjg3NFpQU2pNczJ0V0lXVjUvMWpqVWRkaGpYQzg1MTF3?=
 =?utf-8?B?UnAzaGVjam5vUWRSeXhyYkd0WStSNVhoV1lCcjE4RUZINmY3MU5aZUJQd3pZ?=
 =?utf-8?B?V3NYUThlNDIvNEtBYTJGWU15WHVuUnNvTzJSdk0yaENnb2FGbElzZHlIZmo0?=
 =?utf-8?B?OXdVY2h1Zzg4K3ZYazloLzIrYll4WGdSWUNaVmdFa3ZkZXY0ZDhCZWRoRVBm?=
 =?utf-8?B?MmNueWkxaGhpNkMwK0JReEgyZ0JPSXlaS2Q1V0R1bWU1MmVjVzFqdks4eHRn?=
 =?utf-8?B?dW9vSnM3WUd4dlZVY0JtaUlMMkgrd1MzRHFkMGU4WXFIbmFhS29vOWxjMEpC?=
 =?utf-8?B?K1RMVGRPeGZXUXEydTdheERkVUF6bUNmdHB6cm9UVTdVZmRmQ2phQWpYaVVT?=
 =?utf-8?B?T0JFd3hQMUpCU05vcmZBQVRGV2x6cWdaV0JsRFdmWGxJU3dGL3dEY1IyMVFp?=
 =?utf-8?B?WUt5dmR2ZXk0QWFGZjZaSjNIOUpUWHRwdkJuTzJkL2FIdWJYN1ZzUm4vZkJS?=
 =?utf-8?B?SzJ3VDFteloxMTgybCtPZlZGUlBmRnplMEpZQ3BIOSs5akdCQVE0em1ZVEhY?=
 =?utf-8?B?aHlqWEVrM2lhV25ZcEZqWEpsbzRTd1RCU2NMeWRxYm1IVWIyT3M5dnQzOVVv?=
 =?utf-8?B?cDZnYzRKU1J2YVdCWGRyeFVkMmtyci9wbTdUUmZEcE5NQ0tSL2VOTnFmSm5J?=
 =?utf-8?B?ckx3Qm5UT2loQnk1MjF3b1R2MjUrUUhOMWlsNEFtMVZsWlhFa1FrQXdweFJk?=
 =?utf-8?B?MitlNDRnMmF3Y0FvU05BT1IrNlowWjZRdW1Qd0ZSMmVScFZ6dHE0QkVYU3Z1?=
 =?utf-8?B?OEJLdmptaGlvajQ5dXFXUU9aQTNWOUR0WmtDOWdWYnJua0NRTE9tWGxCNm9B?=
 =?utf-8?B?NzhGbHVYc0Y5VW8wSkFjOXhaMWZ1QzdPR2psK083bUYyMWN3aElyTStDQ1lN?=
 =?utf-8?B?ZXgvcXl5SE5nNlB2SXhTa3duWTNmZXJQamZKNUMveDZMbEVENGNjdG85T01r?=
 =?utf-8?B?cHp1VkVva0ZzVWVGWndHRjk3OFA1S29XSExpdkVYZEgzTmlETm1NZXpsRXdv?=
 =?utf-8?B?NHNDcnB0NDNqOVdFWExmRlpJY2ZJTXlRUnJCK1FEMlFTSmcvSUJqaHpsWVp1?=
 =?utf-8?B?U29peXZHS2xHTTB5K1Y0ZnMxRUg2NkxaV2x1L0tKNjdUcGRWL3dtYzExamda?=
 =?utf-8?B?eXExamk3Vms2T0pQa3pHdUNSZ25HUWRsMC9mMnFBZnZobGJhWWV5SmZ6ZjRo?=
 =?utf-8?B?OEVPYjNyZk84Vy9RQ2MzeWw3S2ZnbmFkbFMyaUthWXRjdjAxV2E0bUVJemxx?=
 =?utf-8?B?MHlsT2pQajh5dEhkSVlTZTN6QmxPWWNRaGtBWUk3MUlrTlZvQ29QRkh6M21t?=
 =?utf-8?B?OU1zbTc4YmNoejJaNVl2TDlRSWVqeHUvVUdiMGlaMWRnZm1KbTdYZEpyM255?=
 =?utf-8?B?TlFweVViVFNXejRvNUV2MUxmbmtBeWJ1b3NWeDlZUHZrb09PVzlzNE9ocFoy?=
 =?utf-8?B?NUNyalZkWHRwd1Y2RGlqSzhMRjVDM0hzVTM5K0hXUGZsY21HUVJmdkZ5dllY?=
 =?utf-8?B?ZnZrTG12M2Jsd3pZTmNEeSsyQm8xb0dKMVVaNnlIVE1vNlNzMWpnb2hwR1Rx?=
 =?utf-8?B?UlpGWDNoOEJ1dkVWbjRtWlhyeDl1Y3ByR0YvNjFHQ1VuWk56cXVxZzJMTExu?=
 =?utf-8?Q?hYTg/RLW/mqaOz57JLlzQnyKK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eecfda88-841d-45b0-ad29-08db3e21006f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2023 02:19:26.4781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AUMlsaQlr87C8HSJX/0mnzYuwhK1gHjtmTSlTMqavE+cjfHhPNpjyh5vtt/jcWE00Wjjwz4GiOKP9HsEjVKbom7hy5Vjczu4N0N1i9cG3j0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8383
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0dXJkYXksIEFwcmlsIDE1LCAyMDIzIDU6MjAgUE0sIEZsb3JpYW4gQmV6ZGVrYSA8Zmxv
cmlhbi5iZXpkZWthQHNpZW1lbnMuY29tPiB3cm90ZToNCj5PbiAxNC4wNC4yMyAxNzo0OSwgU29u
ZyBZb29uZyBTaWFuZyB3cm90ZToNCj4+IGlnY19jb25maWd1cmVfcnhfcmluZygpIGZ1bmN0aW9u
IHdpbGwgYmUgY2FsbGVkIGFzIHBhcnQgb2YgWERQIHByb2dyYW0NCj4+IHNldHVwLiBJZiBSeCBo
YXJkd2FyZSB0aW1lc3RhbXAgaXMgZW5hYmxlZCBwcmlvIHRvIFhEUCBwcm9ncmFtIHNldHVwLA0K
Pj4gdGhpcyB0aW1lc3RhbXAgZW5hYmxlbWVudCB3aWxsIGJlIG92ZXJ3cml0dGVuIHdoZW4gYnVm
ZmVyIHNpemUgaXMNCj4+IHdyaXR0ZW4gaW50byBTUlJDVEwgcmVnaXN0ZXIuDQo+Pg0KPg0KPkhp
IGFsbCwNCj4NCj5JJ20gYWN0dWFsbHkgc2VhcmNoaW5nIGZvciB0aGUgcm9vdCBjYXVzZSBvZiBh
IHNpbWlsYXIgcHJvYmxlbSAoUlggdGltZXN0YW1wIGxvc3QpDQo+dGhhdCBJIGNhbiByZXByb2R1
Y2UgaGVyZSwgYnV0IHRoZSBzZXR1cCBpcyBzbGlnaHRseSBkaWZmZXJlbnQuIFRoZSBzZXR1cDoN
Cj4NCj4tIGlnYyBkcml2ZXINCj4tIGkyMjUvMjI2IG5ldHdvcmsgY2FyZA0KPi0gV2hlbiBzdGFy
dGluZyB0byB0cmFuc21pdCBmcmFtZXMgdXNpbmcgWERQIHdpdGggemVybyBjb3B5IGVuYWJsZWQN
Cj4gIGFub3RoZXIgYXBwbGljYXRpb24gKHB0cDRsKSBjb21wbGFpbnMgYWJvdXQgbWlzc2luZyBS
WCB0aW1lc3RhbXBzDQo+LSBMb2FkaW5nIHRoZSBYRFAgcHJvZ3JhbSBoYXMgYWxyZWFkeSBiZWVu
IHJlbW92ZWQgKG5vdCBuZWVkZWQgZm9yDQo+ICBUWCBvbmx5KQ0KPi0gcHRwNGwgaXMgdXNpbmcg
dGhlIHRyYWRpdGlvbmFsIHNvY2tldCBBUEkNCj4tIFRoZSBSWCB0aW1lc3RhbXBzIHNlZW0gdG8g
Y29tZSBiYWNrIG9uY2Ugd2Ugc3RvcCBzZW5kaW5nIGZyYW1lcw0KPiAgdXNpbmcgWERQDQo+DQo+
VGhlICJ6ZXJvIGNvcHkgc3VwcG9ydCIgZW5hYmxlZCBwYXJ0IGlzIGltcG9ydGFudC4gSWYgWkMg
c3VwcG9ydCBpcyBub3QgcmVxdWVzdGVkDQo+ZXZlcnl0aGluZyB3b3JrcyBmaW5lLg0KPg0KPkFu
eSBpZGVhcz8NCj4NCj5CZXN0IHJlZ2FyZHMsDQo+Rmxvcmlhbg0KPg0KDQpIaSBGbG9yaWFuLA0K
DQpZb3UgbWVhbnMgdGhpcyBwYXRjaCBkb2VzIG5vdCBoZWxwIG9uIHlvdXIgaXNzdWU/DQpOZWVk
IHRvIHVuZGVyc3RhbmQgbW9yZSBvbiB0aGUgc2V0dXAgYW5kIGJlaGF2aW9yIHRvIHRlbGwuDQpB
cmUgcHRwNGwgYW5kIFhEUCBaQyBUeCBhcHBzIHJ1bm5pbmcgb24gc2FtZSBxdWV1ZSBvciBzZXBh
cmF0ZSBxdWV1ZT8NCkkgc3VnZ2VzdCB5b3UgdG8gcnVuICIgc3VkbyBod3N0YW1wX2N0bCAtaSBl
dGgwIC1yIDEgIiBtdWx0aXBsZSB0aW1lcyBpbiB0aGUgbWlkZGxlDQp0byBjaGVjayB0aGUgYmVo
YXZpb3IuDQoNClRoYW5rcyAmIFJlZ2FyZHMNClNpYW5nDQo=
