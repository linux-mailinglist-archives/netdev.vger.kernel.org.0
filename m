Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902846EA632
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 10:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjDUIrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 04:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbjDUIrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 04:47:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B530C170
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682066718; x=1713602718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5mr9Of1DY8s4Yr9QWTBTpmSWV1OUNnHN3YQoBNtIKSc=;
  b=MXYYooUSEfawB+nWBdSWulmJlJRz6CmQG7KKDW5NgJKuhaWY8yIV5pt1
   xroOuLIIGneYTWOr6m+M8P4elSMCP3uj3rSSlCmdFfGHEo44ujuPX8Hix
   ktUeJpSUFOKTwqidn2T/JmeOILtUEHSEmLNGQOjltDkWKmuN4+8SsCPGv
   kB5ooi4YTEO+7ElJwFFcU9U0IZ+nbnVzo/GTR43XwFb1ir4GL7ZLW/9Wf
   I2Hg/Bdn+q2brHdW0EcVWg7llHjK6qMz4B3wvWWx4zjuq18EIdc5GzzvP
   tKEPj6WNOtl+s5ljCQQXEPfAZM/YaAznD+MrstGAnbf43wEoChpQYNvoM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="334822627"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="334822627"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 01:45:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="761501252"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="761501252"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 21 Apr 2023 01:45:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 01:45:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 01:45:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 01:45:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 01:45:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYR5xGgyQiE3n+CSAYbJLeXf/NM7vcEDHA4Tl5yG8z0rr0r7rKyT/Z6GxUnmqDZ/YjxPS7paKQHuOJXBs4CNzSqW9ttRhR8qTaTUstsRqUv7JiNIpO8L5DPOvMet1LNS8OUVsHxNyM6CE1RZDMRmGq4xeuMyFHFfY9S1V7a3B+AvyIuvfALKhmPt55YdZU6FuoJMvfYWhDlKZFS8SasrVgPNsf+GS5nPlmQR9Z71N3D8GWZpFIqVmQyEMWvGWSuVFwXs9CI261SG5vyYG1qNIecl2AA/GaeKhZqLty6dObnEIHP3TUPuZWe+Ix73el7s3DQenPiybqm5goa9+DMupw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mr9Of1DY8s4Yr9QWTBTpmSWV1OUNnHN3YQoBNtIKSc=;
 b=GkHh4C8teRCa3BMyc0QIJ4VrrGXC6A6cJwlF8GQiArvAcCA0EaJ57gD6fPdyN35NZDlwPKVKC75Y/llAi056QJwHn6TEZ7uEIExOsg51aS+eyQ6b1YdonuckVzdzcC01smYW3IbZIiUrN1jgYeRR+ploeB96rDdFZZwu+SrhSD1UJ0Bwrr2MpirCX0ixE9RVxnp7pvM+jbGn9Jnj7hHo5RaRVe7Wpy3grzp0DlLE56BE1pevj+PmgO+fqLtxsvNHdv9eP5PTLLmXMtC5iJknX3XJFxQSWmx3YkKdAfpCyIE9ldCNPHyweJDYpzPkFYNioWU13vOJYzIE4h5iNgWB2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by SA1PR11MB6920.namprd11.prod.outlook.com (2603:10b6:806:2bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Fri, 21 Apr
 2023 08:45:09 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%6]) with mapi id 15.20.6298.045; Fri, 21 Apr 2023
 08:45:09 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 05/12] ice: Switchdev FDB events support
Thread-Topic: [PATCH net-next 05/12] ice: Switchdev FDB events support
Thread-Index: AQHZctUzhpsg98+ihkmiMm0VAX7gla80Bg4QgABnSICAAQYgEA==
Date:   Fri, 21 Apr 2023 08:45:08 +0000
Message-ID: <MW4PR11MB577650306451574B5160E5CEFD609@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-6-wojciech.drewek@intel.com>
 <10045539-91eb-cdb1-0499-1c478d87870e@intel.com>
 <MW4PR11MB57760F836B7714BC22A26FC7FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
 <92c09efa-7e47-f580-4f60-19f9bb0f045d@intel.com>
In-Reply-To: <92c09efa-7e47-f580-4f60-19f9bb0f045d@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|SA1PR11MB6920:EE_
x-ms-office365-filtering-correlation-id: 063fd527-52e6-4c3b-d341-08db4244b678
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Mn26BMyUp8yzHhJtwxG+5lO0SegTVGMc4f0TTs05oaPkkuGH/JqMNTVeq+1u2YIkJ5HF2TiavdUPfyifm0m5bgPqNb6Ak+o2g9rmxopk7estwmXSTkjKablLFxh4oPv+j+Yf6Us6ZPWpSJ52rP5dguxxKMCCO83oX8ygn13LkB2zA+Kg/v6YcrQZdcbOfxy9mdIGV8xFHcBRDif7w0d6NT1vxPFB+y0uOlw0oSNN3DGxni0CumIiiLsc0nRgTtpq2pISonPsMvhOVd/MrU0hq8oP3GMCgC8fGPidX+ZFX4p1o1UIuyIQEQHMuZe7CDN4Mz2FXe5cOzLismk8wr86Y4hGDRuBJPXc01xmOZVDZww3X1//BngILB+/bvq29tkpdECK9Tyo91SH+xx7af9vNcYA8B4ldOJfFPUfXWRKyjs6R1BdwsP5O3abvQ0EczFf8VlekNmSGynlMBINeBgYKbJWeG2OFN1pqOA2dgi4dUFs5IiNAADZpdfnWTuPadNsN7+wcnV9WyMEP1IISOcPROdwt2a/P+dtu248eQ8kMdOo/Yzp6O6L0uHPuPZhCmNO2QD0Ng1aa4q/o+/fWXZ3tRgIWqppjD6dNVrFGCdk+w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199021)(38100700002)(54906003)(478600001)(9686003)(6506007)(53546011)(26005)(122000001)(966005)(86362001)(71200400001)(52536014)(7696005)(55016003)(41300700001)(82960400001)(316002)(5660300002)(8936002)(8676002)(33656002)(6862004)(38070700005)(6636002)(66946007)(64756008)(66556008)(76116006)(66476007)(66446008)(186003)(4326008)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFZZZ0NPcWlHK2ZlNHFtVEJzQ2xsTlpyUFRmNnlLbFV4NGkvUnFoaVRuZENM?=
 =?utf-8?B?cEFKY09oUWZ6Nkl4Zm9KK0ttTGtkcHB0eVpkczZIOHcxdFJSdE9TY2pRcGpx?=
 =?utf-8?B?WkR4RWNvUFlacW45QnlJV1VGakVjRFRLdWZvRHpTbUlkSTgxcUxTVTcrMHY2?=
 =?utf-8?B?bVhpU2tkakU1Kzlmdjl4eWlzM2JVNDRhaWIyQWFZRnQzNmpQbDJJTm9NTHFV?=
 =?utf-8?B?UG5vVVNzN1VJVkhsK1FXYW5ML0FOem8zQWVZL1kxUUhUNzZtWncwMS9FaHZv?=
 =?utf-8?B?WUNNSXNqaXRndVBxeFU4cCt2NU1JOHN5cWMxSVVSR1R1NjZOYzNUVlJoVytX?=
 =?utf-8?B?REljNW51emhYZUROZ2dWa0JTMkpOaC9XQjN0WHgxclF2bmV2OWRRNkN3Skw0?=
 =?utf-8?B?VHliVWQ4M0lmM2NOOGNYMGY5ajhjdEZrRjJoOTlJYW45cSt4b3JxT1B0dU45?=
 =?utf-8?B?ZjMrczd0ell3Qzc0NFZEN2pyWHlsaFFOQWFpS1dZNEtXbEIxMm0wUDZyNjhi?=
 =?utf-8?B?ZEQ5dlVBZGw2cHFBZytHNVVTRGQyejk3SWlhSDRDdkZWN3U1NGF6STRONVZ1?=
 =?utf-8?B?bTRaSWlLOUlGa2FxVmY4NlEyNk8zczZZenphcFJ5ZmdFZUp6eXlEdjNuNGt0?=
 =?utf-8?B?eEFweFdRdWV4UGVtTzcyUmpTdTNsOXd3TEM3c1hHdzNYeXNhTTFpRUEyWnRH?=
 =?utf-8?B?TG9ObWJBR2tFVFNuRmtHRjRFcjUvb05jbm5hSFhhZWNML3NTZVk4TlNlWGNR?=
 =?utf-8?B?elhEOHcybVFYcFg5ZmZqSmZGTDQwaXdma2tLam44YnBoTkVoU2l2VW5vK0Nq?=
 =?utf-8?B?NTUrYWlTMnBrSWtvYVVnSFZhakVEZzJOSWErOXBta3l1VFI4SkJNMkhVQnRr?=
 =?utf-8?B?bGtXYXdnK0FCcG1TUDhXY094YlNBUUdaOUgya3BGU0I4RFRPNjZNRTZpLzJ2?=
 =?utf-8?B?SURvbHNMdkhYald1RVpjQnpoRFF5VkxscDZDYmRacElIck5zajdxaVh6RkZC?=
 =?utf-8?B?Szk3a1VuREVzMkR2Q0I0bzhiZHdoTVBCZFp3SG1UZk4xVi9pcVpFcis0SlRR?=
 =?utf-8?B?T1lZZ1F0RW12MDVXVVBsTUVSeDE0S0VIaURRUnFEUTRnck8zNnNFOTg1a3po?=
 =?utf-8?B?ZUFteUh1UjIzd1REQWxZNWFjMmI0QnpBTFB3RUlUT0VMM2NONWJjVlZGT1VK?=
 =?utf-8?B?U2lqYVhFUlN4Uy9sQWFORFB4ODV2b0dqRk5YWkh2SmI4NCtIWUZJQ3dia0xC?=
 =?utf-8?B?OUN3UjF3Wm9iOW0yejVyK01vVkpGcVgyaVVva29Jdm9VNTE1SGtYQVowNFJy?=
 =?utf-8?B?Mmh3NFJLRXFGOFZWc2FiSGEwWXJlbTJHcVpsY2FBNVVYQ1V5NDlBbVZNRTRu?=
 =?utf-8?B?N1oyWEdDTzJUUEhJKzVYbmdWeEJnaWFGbWhkQWYwc3JJWmZocnBhaWg5dlox?=
 =?utf-8?B?YTZXQU5ra3dHbklUb0c3NXlsSHVUZU56cldhSjI0U0FrNzNKOEV6dUlvZFpp?=
 =?utf-8?B?eGRZZ2dHMzE1MnNuUmlhL0RSSEIwTlNJSTJDK2cyVWdnOHdiV1hvdjlsTk5q?=
 =?utf-8?B?Q3d5d2Q5VmZacWRsWFlPSVZEcm10NzNXYlpZSTJLWkZiWUZEUUFGcHNzdWdv?=
 =?utf-8?B?WnYrb2V0WlFaUjd2c3lrRDd0TXVycXdoZEpnQWhjdEp6TW5UbkMzZi9jNW55?=
 =?utf-8?B?QVVmTHJBNXFNRVQ3bjUwbjRmdzBVL3lNTTN1djVMc1BXdDdOWDM5aUlhS0Vi?=
 =?utf-8?B?UDB1R2EwOVNzU1g3eEpldmNmVGltazYrSkNWcDRGekozOFRFNWpTZit3R1g2?=
 =?utf-8?B?a3gybStFZkoyeUxSQWJoc1lER0Y2Q2NERUpSTEwyelgwcGVoaHhjaGNLRXYr?=
 =?utf-8?B?RHVic2wxd1Y3QS92bFZvL1Bjak02NHBUU3RJaUpoaUFPNzRvYVE3b0ZFZ2dJ?=
 =?utf-8?B?VkYzTmlqU1ZOVkpUWkJCZ2NzTDdnVUtRVVN5bC9FMm5ucjFQQnJlcVJwQlpE?=
 =?utf-8?B?RjBvWkpVNUEwcGFLbXZkZVI4cU9MU2Z6bU40emVXNVp5ZmdncVFpMEpFajQw?=
 =?utf-8?B?NC9BaTR0amNUbCtYSUtBQzNYVVp2d010dmhuKzRDR3g4ak9OL0ZQdlRHQXFt?=
 =?utf-8?Q?XsRAInUOvG2ZDdQa1997KYKCU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 063fd527-52e6-4c3b-d341-08db4244b678
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 08:45:08.9109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XR5Os6Tyr9kxX4got9rJUxvaDi2iATO6p0jXw7+gq85T7++G+hNnV+IL2CqCaRuuypIJ7VNSQFSMH2hVZf/nUVoPXmqxTD2luiHhxQ5zpVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6920
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwgQWxla3Nh
bmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gU2VudDogY3p3YXJ0ZWssIDIw
IGt3aWV0bmlhIDIwMjMgMTk6MDANCj4gVG86IERyZXdlaywgV29qY2llY2ggPHdvamNpZWNoLmRy
ZXdla0BpbnRlbC5jb20+DQo+IENjOiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgRXJ0bWFuLCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBp
bnRlbC5jb20+Ow0KPiBtaWNoYWwuc3dpYXRrb3dza2lAbGludXguaW50ZWwuY29tOyBtYXJjaW4u
c3p5Y2lrQGxpbnV4LmludGVsLmNvbTsgQ2htaWVsZXdza2ksIFBhd2VsIDxwYXdlbC5jaG1pZWxl
d3NraUBpbnRlbC5jb20+Ow0KPiBTYW11ZHJhbGEsIFNyaWRoYXIgPHNyaWRoYXIuc2FtdWRyYWxh
QGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAwNS8xMl0gaWNlOiBT
d2l0Y2hkZXYgRkRCIGV2ZW50cyBzdXBwb3J0DQo+IA0KPiBGcm9tOiBXb2pjaWVjaCBEcmV3ZWsg
PHdvamNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+IERhdGU6IFRodSwgMjAgQXByIDIwMjMgMTM6
Mjc6MTEgKzAyMDANCj4gDQo+ID4NCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+PiBGcm9tOiBMb2Jha2luLCBBbGVrc2FuZGVyIDxhbGVrc2FuZGVyLmxvYmFraW5AaW50
ZWwuY29tPg0KPiA+PiBTZW50OiDFm3JvZGEsIDE5IGt3aWV0bmlhIDIwMjMgMTc6MzkNCj4gPj4g
VG86IERyZXdlaywgV29qY2llY2ggPHdvamNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+ID4+IENj
OiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgTG9iYWtpbiwgQWxla3NhbmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT47IEVy
dG1hbiwNCj4gRGF2aWQgTQ0KPiA+PiA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPjsgbWljaGFs
LnN3aWF0a293c2tpQGxpbnV4LmludGVsLmNvbTsgbWFyY2luLnN6eWNpa0BsaW51eC5pbnRlbC5j
b207IENobWllbGV3c2tpLCBQYXdlbA0KPiA+PiA8cGF3ZWwuY2htaWVsZXdza2lAaW50ZWwuY29t
PjsgU2FtdWRyYWxhLCBTcmlkaGFyIDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5jb20+DQo+ID4+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDUvMTJdIGljZTogU3dpdGNoZGV2IEZEQiBl
dmVudHMgc3VwcG9ydA0KPiANCj4gWy4uLl0NCj4gDQo+ID4+IChubyB0eXBlcyBzaG9ydGVyIHRo
YW4gdTMyIG9uIHRoZSBzdGFjayByZW1pbmRlcikNCj4gPj4NCj4gPj4+ICsJCQkgICAgICAgY29u
c3QgdW5zaWduZWQgY2hhciAqbWFjKQ0KPiA+Pj4gK3sNCj4gPj4+ICsJc3RydWN0IGljZV9hZHZf
cnVsZV9pbmZvIHJ1bGVfaW5mbyA9IHsgMCB9Ow0KPiA+Pj4gKwlzdHJ1Y3QgaWNlX3J1bGVfcXVl
cnlfZGF0YSAqcnVsZTsNCj4gPj4+ICsJc3RydWN0IGljZV9hZHZfbGt1cF9lbGVtICpsaXN0Ow0K
PiA+Pj4gKwl1MTYgbGt1cHNfY250ID0gMTsNCj4gPj4NCj4gPj4gV2h5IGhhdmUgaXQgYXMgdmFy
aWFibGUgaWYgaXQgZG9lc24ndCBjaGFuZ2U/IEp1c3QgZW1iZWQgaXQgaW50byB0aGUNCj4gPj4g
aWNlX2FkZF9hZHZfcnVsZSgpIGNhbGwgYW5kIHJlcGxhY2Uga2NhbGxvYygpIHdpdGgga3phbGxv
YygpLg0KPiA+DQo+ID4gSXQgd2lsbCBiZSB1c2VmdWwgbGF0ZXIsIHdpdGggdmxhbnMgc3VwcG9y
dCBsa3Vwc19jbnQgd2lsbCBiZSBlcXVhbCB0byAxIG9yIDIuDQo+ID4gQ2FuIHdlIGtlZXAgaXQg
YXMgaXQgaXM/DQo+IA0KPiBBaCwgb2theSwgdGhlbiBpdCdzIHN1cmVseSBiZXR0ZXIgdG8ga2Vl
cCBhcy1pcy4gTWF5YmUgSSdkIG9ubHkgbWVudGlvbg0KPiB0aGVuIGluIHRoZSBjb21taXQgbWVz
c2FnZSB0aGF0IHRoaXMgdmFyaWFibGUgd2lsbCBiZSBleHBhbmRlZCB0byBoYXZlDQo+IHNldmVy
YWwgdmFsdWVzIGxhdGVyLiBTbyB0aGF0IG90aGVyIHJldmlld2VycyB3b24ndCB0cmlnZ2VyIG9u
IHRoZSBzYW1lDQo+IHN0dWZmLg0KDQpTdXJlIHRoaW5nDQoNCj4gDQo+ID4NCj4gPj4NCj4gPj4+
ICsJaW50IGVycjsNCj4gPj4+ICsNCj4gPj4+ICsJcnVsZSA9IGt6YWxsb2Moc2l6ZW9mKCpydWxl
KSwgR0ZQX0tFUk5FTCk7DQo+ID4+PiArCWlmICghcnVsZSkNCj4gPj4+ICsJCXJldHVybiBFUlJf
UFRSKC1FTk9NRU0pOw0KPiA+Pj4gKw0KPiA+Pj4gKwlsaXN0ID0ga2NhbGxvYyhsa3Vwc19jbnQs
IHNpemVvZigqbGlzdCksIEdGUF9BVE9NSUMpOw0KPiA+Pg0KPiA+PiBbLi4uXQ0KPiA+Pg0KPiA+
Pj4gKwlmd2RfcnVsZSA9IGljZV9lc3dpdGNoX2JyX2Z3ZF9ydWxlX2NyZWF0ZShodywgdnNpX2lk
eCwgcG9ydF90eXBlLCBtYWMpOw0KPiA+Pj4gKwlpZiAoSVNfRVJSKGZ3ZF9ydWxlKSkgew0KPiA+
Pj4gKwkJZXJyID0gUFRSX0VSUihmd2RfcnVsZSk7DQo+ID4+PiArCQlkZXZfZXJyKGRldiwgIkZh
aWxlZCB0byBjcmVhdGUgZXN3aXRjaCBicmlkZ2UgJXNncmVzcyBmb3J3YXJkIHJ1bGUsIGVycjog
JWRcbiIsDQo+ID4+PiArCQkJcG9ydF90eXBlID09IElDRV9FU1dJVENIX0JSX1VQTElOS19QT1JU
ID8gImUiIDogImluIiwNCj4gPj4+ICsJCQllcnIpOw0KPiA+Pj4gKwkJZ290byBlcnJfZndkX3J1
bGU7DQo+ID4+DQo+ID4+IEEgYml0IHN1Ym9wdGltYWwuIFRvIHByaW50IGVycm5vIHBvaW50ZXIs
IHlvdSBoYXZlICVwZSBtb2RpZmllciwgc28geW91DQo+ID4+IGNhbiBqdXN0IHByaW50IGVyciBh
czoNCj4gPj4NCj4gPj4gCQkuLi4gZm9yd2FyZCBydWxlLCBlcnI6ICVwZVxuIiwgLi4uIDogImlu
IiwgZndkX3J1bGUpOw0KPiA+Pg0KPiA+PiBUaGVuIHlvdSBkb24ndCBuZWVkIEBlcnIgYXQgYWxs
IGFuZCB0aGVuIGJlbG93Li4uDQo+ID4NCj4gPiBUaGlzIGlzIHJlYWxseSBjb29sLCBidXQgSSB0
aGluayBpdCB3b24ndCB3b3JrIGhlcmUuIEkgbmVlZCB0byBrZWVwIGVyciBpbiBvcmRlciB0bw0K
PiA+IHJldHVybiBpdCBpbiB0aGUgZXJyIGZsb3cuIEkgY2FuJ3QgdXNlIGZ3ZF9ydWxlIGZvciB0
aGlzIHB1cnBvc2UgYmVjYXVzZQ0KPiA+IHJldHVybiB0eXBlIGlzIGljZV9lc3dfYnJfZmxvdyBu
b3QgaWNlX3J1bGVfcXVlcnlfZGF0YS4NCj4gDQo+IE15IGJhZCwgZm9yZ290IHRvIG1lbnRpb24u
IElmIHlvdSB3YW50IHRvIHJldHVybiBlcnJvciBwb2ludGVyIG9mIGEgdHlwZQ0KPiBkaWZmZXJl
bnQgZnJvbSB0aGUgcmV0dXJuIHZhbHVlJ3Mgb25lLCB0aGVyZSdzIEVSUl9DQVNUKCkuIEl0IGNh
c3RzDQo+IGVycm9yIHBvaW50ZXIgdG8gYHZvaWQgKmAsIHNvIHRoYXQgdGhlcmUnbGwgYmUgbm8g
d2FybmluZ3MgdGhlbi4NCj4gSGVyZSdzIG5pY2UgZXhhbXBsZTogWzBdDQoNCkFub3RoZXIgY29v
bCB0aGluZyBJJ3ZlIGxlYXJuLCBzdGlsbCBJIGRvbid0IHdlIGNhbiB1c2UgaXQgaGVyZS4NCklu
IHRoZSBuZXh0IHBhdGNoLCBhbm90aGVyIHJ1bGUgaXMgY3JlYXRlZCBpbiAgdGhpcyBmdW5jdGlv
biwgY2FsbGVkDQpndWFyZCBydWxlLiBJdHMgY3JlYXRpb24gY2FuIGFsc28gZmFpbCBhbmQgd2Ug
aGF2ZSBzZWNvbmQgcG9pbnRlciBmb3IgaXQNCmNhbGxlZCAoZ3VhcmRfcnVsZSkuDQoNCj4gDQo+
ID4NCj4gPj4NCj4gPj4+ICsJfQ0KPiA+Pj4gKw0KPiA+Pj4gKwlmbG93LT5md2RfcnVsZSA9IGZ3
ZF9ydWxlOw0KPiA+Pj4gKw0KPiA+Pj4gKwlyZXR1cm4gZmxvdzsNCj4gPj4+ICsNCj4gPj4+ICtl
cnJfZndkX3J1bGU6DQo+ID4+PiArCWtmcmVlKGZsb3cpOw0KPiA+Pj4gKw0KPiA+Pj4gKwlyZXR1
cm4gRVJSX1BUUihlcnIpOw0KPiA+Pg0KPiA+PiAuLi55b3UgY2FuIHJldHVybiBAZndkX3J1bGUg
ZGlyZWN0bHkuDQo+ID4+DQo+ID4NCj4gPiBJIGNhbid0IHJldHVybiBAZndkX3J1bGUgaGVyZSBi
ZWNhdXNlIHJldHVybiB0eXBlIGlzIGRpZmZlcmVudA0KPiA+IFRoaXMgZnVuY3Rpb24gaXMgbWVh
bnQgdG8gcmV0dXJuIEBmbG93Lg0KPiANCj4gWy4uLl0NCj4gDQo+ID4+PiArCXN0cnVjdCBuZXRf
ZGV2aWNlICpkZXY7DQo+ID4+PiArCXN0cnVjdCBpY2VfZXN3X2JyX3BvcnQgKmJyX3BvcnQ7DQo+
ID4+PiArCXN0cnVjdCBpY2VfZXN3X2JyX2Zsb3cgKmZsb3c7DQo+ID4+PiArfTsNCj4gPj4gWy4u
Ll0NCj4gPj4NCj4gPj4gVGhhbmtzLA0KPiA+PiBPbGVrDQo+IA0KPiBbMF0NCj4gaHR0cHM6Ly9l
bGl4aXIuYm9vdGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9kcml2ZXJzL2Nsay9jbGstZnJh
Y3Rpb25hbC1kaXZpZGVyLmMjTDI5Mw0KPiANCj4gVGhhbmtzLA0KPiBPbGVrDQo=
