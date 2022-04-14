Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D8B500CDF
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243051AbiDNMS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242696AbiDNMSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:18:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6712759A68;
        Thu, 14 Apr 2022 05:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649938582; x=1681474582;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fhy0LintJF4P24N/Ofs9WWjbMqZqtuDXkxmrTJWivnQ=;
  b=UIcJFDTyiTKuCnMejoumEVjIvRL+nWl0mlbReqkxjD606fnQQLiaTFW3
   bKM2mvNWlpnqPjSe1SkoClFCwDWs5uXNYr52pPjVkk0TpiUE7S2BLnklU
   s3qPqOBZ0Ou28kMW80XcsKjTM4uuwaJKCaZ9yddq1OqrRg1Ks2z0xeaOc
   059q8ffzAjB7VqalK1+tiIobvEknSbn7WTyS1L0ooPYvw1IgJ/EdnzFPI
   qUpYwCjAAUPFnoJWtJKAb3cjYt+0Rgyu4GbLyqhSoS4q8KBlFoHtWN8Zz
   Iojxwv5FdcXdvQWu5giwFUn+LWcCzAySHzxZdZW3pw7wR5c93La+Jpj5r
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="262668059"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="262668059"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 05:16:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="552658200"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 14 Apr 2022 05:16:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 05:16:21 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 05:16:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 05:16:20 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 05:16:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j45MPkrPjN7ThFSITiJqNRf0hGcr3Qi8KCsq72RqPJVMqin7VAR6tyIV0rmkYz1aI5LlFdgahVV2tFvxfOl4auPT/m9KnxNGS1xp3xXWt7PSUIxd5JNH9YF6hE3ZKzdzjrMpl1wVOyAv1/6OJglJbCxFf/lLGOUIi52MAW206kD5zTC95pn8/aRrs0rtiL/U3Ymj9ZgzEMB2w5eYp5llARJdsB+TIoeQtHMXjp5/WaKlbj3beDw9SB+4tk1ofAxtbSgOBAxZR/JrijLkuTy3hha9eIVPi1mLZO14Mq+kE5J8T8si/5uZJeIIND+z01UPH9Tydmwe8C3IwvEwBAtAwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhy0LintJF4P24N/Ofs9WWjbMqZqtuDXkxmrTJWivnQ=;
 b=ROj4hN+UBIJepQHDTHsedAcG4Tf/2Sm9e2+tovpTm+MU5UN029cb3TEe7et6IAOf8uKjjsgRCqFJT1iLkNklPypK6fmVYHvl8JJqNMSYcsfQTg7IMAeJBHzsRNdLU6dIijSPwNS/XiTzEygtmabttjUgIbK2lp/4nAQ8tMAIKf5pIT27xkmuYy41CY06LQPRJk8Zm1oz1kj6nWs0Y3K2umWXstHkiV+7/luSQ5yjPfp27Xxvy6uVxtA0D32oIvWyBAffnOKSq+IGMWnsJD2YVafG7bqhGcsWmtBLP8XhBlVlmxQGeeXEp1rglIjySkJ4Ocl9F0psEjk/3bi+J6oYUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MN2PR11MB4495.namprd11.prod.outlook.com (2603:10b6:208:189::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 12:16:17 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::c8d9:8c9:f41:8106]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::c8d9:8c9:f41:8106%6]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 12:16:17 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     poros <poros@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     ivecera <ivecera@redhat.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v2] ice: wait 5 s for EMP reset after
 firmware flash
Thread-Topic: [Intel-wired-lan] [PATCH v2] ice: wait 5 s for EMP reset after
 firmware flash
Thread-Index: AQHYT0yUz+n1MgmMfEWvsxpRaRvO/KzvVA/A
Date:   Thu, 14 Apr 2022 12:16:17 +0000
Message-ID: <BYAPR11MB33671AA8F5947FEFB6FAA9F1FCEF9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220412102753.670867-1-poros@redhat.com>
 <20220413153745.1125674-1-poros@redhat.com>
In-Reply-To: <20220413153745.1125674-1-poros@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b1b13e3-5f5d-4b73-f0c4-08da1e10940b
x-ms-traffictypediagnostic: MN2PR11MB4495:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MN2PR11MB4495618A47E200BDD4F1288CFCEF9@MN2PR11MB4495.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZxM6mMwVfi3I2869ia3kqfF7/KakMN0ANvHLnWPaOlB0RHqrqyuz8wtpkm0+q6SMgYMsk/5kJEuXNvRBAzSfu10jgRO1dtNz9Dhe91CL3y7C/3110hLi8UZbvXTHgIq6/WLFyHLLckkkDHMVvmEzZqB475fK85gwvth3eHr+yBxwcx20R0s29TmmSlVUGEE4FfhWTCvxC782hPvtFrAhcfiHKNAOEabwigTMxS2L7SCoJ6Z7Ecxn7sgqFvPvtB88G7xriBdvP9p9hYE/q13Tr/ne1GYpyVkn0Q1wijPSWVbcl/5JCo5BvuY/+vW99aI2WKgtgRMUZPY14sjLf2Djs9paL7jgC3aHkd16/VVbZgr4fXXe8t9JRBWA/uG7PcT82dID6pu068wo+0j9p/YZqvN4lbY9lh63Kou/4XFHFKuWaygc6ZPODS5T+uXK1jWQsG2n+J6/bkRC1XYS6uiEsb0hE8aEyMjP1taosZNF41CKguJWrsVy7w+zdd0HkLRlka2rHzjMIs4SD32om9qfM36h7xt4QePA2cntWofTxdAObevvGd+eHL+BP2Sv1I8+MS7zB1qyYZNKbu0kn5OrVyUDT0Q8NTEmp/jR8IEJeiOlOahOeU66OHGARXhddZe5h+ii/ilRhZ5zwVwfie/2rIeU1DlGfWzq7NgAO87fxGG6Aqz/1VzJs2NuKDk/DdgSmISjWpsTXBTwCkBqXKpmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(52536014)(2906002)(26005)(186003)(9686003)(7696005)(6506007)(38100700002)(82960400001)(55016003)(122000001)(33656002)(8936002)(5660300002)(86362001)(53546011)(83380400001)(38070700005)(4326008)(66556008)(8676002)(76116006)(66946007)(71200400001)(316002)(66476007)(54906003)(110136005)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y09YOStKWUlvaVRpKytiajRQK2Y0am1qcllhc25rQlV2cnY5ZHkyYitoVXcv?=
 =?utf-8?B?QVBxOE8rT2lYTFNWY3dxeDV3bXRwMkhyakJnZmZnYnN2Rk5VUWk3Qk5sZzJq?=
 =?utf-8?B?NklvdE9jLzJuclgvR1I2YnlMRUNZcTNGRkovWDIxK1RlNUUwRk4wTTREVVJV?=
 =?utf-8?B?RjJKN3oyOSttTnMxWkZZRytvSmJVNDY2eHpUTHdyajNLVkdLN0w5NklxSUl1?=
 =?utf-8?B?ZHVDcXA1aWJUOERSdnBvNktBY0FobG5iVWlJZWxmVzF2bkk2c3FrR1huMW1i?=
 =?utf-8?B?MTVyZnYyMCtlMndRcGZBRmk0RUFINnZOcm1wSFhSR3B2bTdTcXBabWVGVXdW?=
 =?utf-8?B?NTVieEJwTDBTNG11dVZ0c3g1UDN2ckFTZlZaRjRCb0s3Mk5pTXdJQTJVSWR3?=
 =?utf-8?B?SE1CYTJ6ZjBSSzBJd0RCVit4SzUySFVoZldkMS9HVmp6NVNhRmIrQlJUWDJt?=
 =?utf-8?B?YXA3UHh4MHhmNEl3OUJTUDZEMVhuM0NxaFdzNXdyNFlvZjhZTU1pa0N0VDMy?=
 =?utf-8?B?cU9UN1c3YWJBS1ZQMk90UmxNQy9FMG9pWlVBMUdDWXZOTmZUZVphU3FRaUxF?=
 =?utf-8?B?T29uVmIwM0pJb1B2YS9rVkMyQ2RUV1pyNHhGcUhvT3dZN1JqbmZESVIwbWs1?=
 =?utf-8?B?ZHZXWjFzTmhwd0RIeG00RFlwOFJ6djNvaXFoRGpRZUc2eHV5Wk9YODYwZlRw?=
 =?utf-8?B?UVlEbnRzdS9tRDhnbUp4aDZpd2pGMklIb2VEcUE0dTRQd3dlK3VGMDhqTGl0?=
 =?utf-8?B?ZVREY3FoTkpFQWxJbUVOOEo0OUpwdDdSUG9ab3ByUzlsZ1pYeGNHWlYrQXZK?=
 =?utf-8?B?d3RPbCtYcldDN2RsOU1xQ29qaXNCSXYxWXBHdE12anZRbnFyMXpjODVNMkl5?=
 =?utf-8?B?SkNiekV2VEd3VVhLaFBOTGxjeDQyem9aZ1FzZWtkQk1panBSaGR4OUgvaldM?=
 =?utf-8?B?Qk1NWndpcVZHYnFRdmZaTDRzWVVsWUdSYVRrSEV3SnFvNlJlYVQ3WWRqL1pp?=
 =?utf-8?B?U29hc0E2L0R3azZwNVNMT1NRSlpQWkZ1QVVLSE5oWm5vQnFXbmJXcWtQWThk?=
 =?utf-8?B?Y2FyRmNXUG9aYlpWMWZYUUpSdis2cGZCNTBpaWI0cXZaa3QvK0E4RlFVS2VL?=
 =?utf-8?B?SGJTM3BRQTBGaC9rUkFsOHBPRzVHZ0Y3RVR1UUozdktURFJUTTN4dENrMisw?=
 =?utf-8?B?bXJBL0R5SWVPejBKWUMvNDBqak1VamZlSlVUVjEyeFNSMHNKWTN6cVNaSDR5?=
 =?utf-8?B?aDdPbWJva0hLaWRYMXVxeVdQYnk1UDNiSnF6N090YlNzRFVQNFUvZzNkTjRC?=
 =?utf-8?B?RWVja3Rrd01mQTk1SkFGTFRZeFM0VENtay9PNzI5RlBRbXNoVXFNd0lYUDJt?=
 =?utf-8?B?QUNUWnI4cU1EbzF0UTNaWkF1TXBsd0lEQUVsSkhabDdVdzY0U1NEeXdIRk5v?=
 =?utf-8?B?MHZrL2QwaiszcjVoditkN2RlV0ZsQ0ZlQ1JJZ01aR2cwdGF0dzdNc1JVY1J3?=
 =?utf-8?B?amtycTNGdDNXTEJack80V3BjWElXYStxazFhSDZJa3ZmanNVSExXTVhkcWZ4?=
 =?utf-8?B?dkFESzEybTN6TUloNlM3anAzdlAzYXBEUk9jOFhRVStabWNHWG1WVzVtbWE1?=
 =?utf-8?B?ejNZYW0vOTZLUTM3VXo3TFlJR01TYVdScWtMalUzZ2ZvUXcvTFVmQnBJQzFh?=
 =?utf-8?B?UEIydVd1MmpyajhkeFF4b0hkY3ZhVjFna3p6elRtZ3NUUHNmbFFxU3EveVI2?=
 =?utf-8?B?WFlVOHp3eVNVRjJRKy9DZWt0RHZlOU5tRkhFOUV5YnlyRXR2WnhBTEgzb21W?=
 =?utf-8?B?M2hiMUFobDhQZnlQUFVyd0ordURJNnNKUDEycW1vMU1kRXFoOE53cExzUWxT?=
 =?utf-8?B?V2VzZ2I3ZDNwWGM5QVErWVJ3b3NzMEdTQkF3UTFZcGphVjJwcVJWOWlXUklh?=
 =?utf-8?B?RTlaZ1hUb3l4TjA1QTlPbXdPdy81Y1lDRkdUcFNwejQvbSs2eDhhblBJSVE0?=
 =?utf-8?B?R3dYLzd6a05wV0tGYjhiUFdNK2tiYTJIM0JXcjlVYWhwaHFKVk9oMTZHQnV4?=
 =?utf-8?B?Q0NySDNrU1g4azdIYmZxbXVIejcvdUVSaUk2NWdsYlc5VzcvODN3SjJOb003?=
 =?utf-8?B?QjB2MjlXeTVxNFptTGdFV29HUzNxOXI0K3VmTnN6aDYzdStDQm1uNmQ5Sys3?=
 =?utf-8?B?U2JJK0NRZ3haMlloVUlweFc2aGRDMnNDWnlWekJBMUN0TGl3ZVhabTRHTWZ1?=
 =?utf-8?B?ajJ5WHVYUTB6UkpZd1RJTExjLzRSZ0NISlNGR09Zb1podnlxM1Q3bXpHZ3Iw?=
 =?utf-8?B?US9nN3Q4VUdJWnJXa2plRFdhUkovejBBN1ZPRDVGN2F5Wklza2dEZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1b13e3-5f5d-4b73-f0c4-08da1e10940b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 12:16:17.7373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dCjJe41zBGqW1C1d7UaTHorJIPe62mmIPdP0zOcUdaK+oldd8mrCtI7/tKNklw5BCmVyUZkRY0doYvj1iXmxKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4495
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSW50ZWwtd2lyZWQtbGFu
IDxpbnRlbC13aXJlZC1sYW4tYm91bmNlc0Bvc3Vvc2wub3JnPiBPbiBCZWhhbGYgT2YNCj4gUGV0
ciBPcm9zDQo+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMTMsIDIwMjIgOTowOCBQTQ0KPiBUbzog
bmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogaXZlY2VyYSA8aXZlY2VyYUByZWRoYXQuY29t
PjsgcG1lbnplbEBtb2xnZW4ubXBnLmRlOyBpbnRlbC13aXJlZC0NCj4gbGFuQGxpc3RzLm9zdW9z
bC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGt1YmFAa2VybmVsLm9yZzsNCj4g
cGFiZW5pQHJlZGhhdC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gU3ViamVjdDogW0ludGVs
LXdpcmVkLWxhbl0gW1BBVENIIHYyXSBpY2U6IHdhaXQgNSBzIGZvciBFTVAgcmVzZXQgYWZ0ZXIN
Cj4gZmlybXdhcmUgZmxhc2gNCj4gDQo+IFdlIG5lZWQgdG8gd2FpdCA1IHMgZm9yIEVNUCByZXNl
dCBhZnRlciBmaXJtd2FyZSBmbGFzaC4gQ29kZSB3YXMgZXh0cmFjdGVkDQo+IGZyb20gT09UIGRy
aXZlciAoaWNlIHYxLjguMyBkb3dubG9hZGVkIGZyb20gc291cmNlZm9yZ2UpLiBXaXRob3V0IHRo
aXMNCj4gd2FpdCwgZndfYWN0aXZhdGUgbGV0IGNhcmQgaW4gaW5jb25zaXN0ZW50IHN0YXRlIGFu
ZCByZWNvdmVyYWJsZSBvbmx5IGJ5DQo+IHNlY29uZCBmbGFzaC9hY3RpdmF0ZS4gRmxhc2ggd2Fz
IHRlc3RlZCBvbiB0aGVzZSBmdydzOg0KPiBGcm9tIC0+IFRvDQo+ICAzLjAwIC0+IDMuMTAvMy4y
MA0KPiAgMy4xMCAtPiAzLjAwLzMuMjANCj4gIDMuMjAgLT4gMy4wMC8zLjEwDQo+IA0KPiBSZXBy
b2R1Y2VyOg0KPiBbcm9vdEBob3N0IH5dIyBkZXZsaW5rIGRldiBmbGFzaCBwY2kvMDAwMDpjYTow
MC4wIGZpbGUNCj4gRTgxMF9YWFZEQTRfRkhfT19TRUNfRldfMXA2cDFwOV9OVk1fM3AxMF9QTERN
b01DVFBfMC4xMV84MA0KPiAwMEFEN0IuYmluDQo+IFByZXBhcmluZyB0byBmbGFzaA0KPiBbZncu
bWdtdF0gRXJhc2luZw0KPiBbZncubWdtdF0gRXJhc2luZyBkb25lDQo+IFtmdy5tZ210XSBGbGFz
aGluZyAxMDAlDQo+IFtmdy5tZ210XSBGbGFzaGluZyBkb25lIDEwMCUNCj4gW2Z3LnVuZGldIEVy
YXNpbmcNCj4gW2Z3LnVuZGldIEVyYXNpbmcgZG9uZQ0KPiBbZncudW5kaV0gRmxhc2hpbmcgMTAw
JQ0KPiBbZncudW5kaV0gRmxhc2hpbmcgZG9uZSAxMDAlDQo+IFtmdy5uZXRsaXN0XSBFcmFzaW5n
DQo+IFtmdy5uZXRsaXN0XSBFcmFzaW5nIGRvbmUNCj4gW2Z3Lm5ldGxpc3RdIEZsYXNoaW5nIDEw
MCUNCj4gW2Z3Lm5ldGxpc3RdIEZsYXNoaW5nIGRvbmUgMTAwJQ0KPiBBY3RpdmF0ZSBuZXcgZmly
bXdhcmUgYnkgZGV2bGluayByZWxvYWQNCj4gW3Jvb3RAaG9zdCB+XSMgZGV2bGluayBkZXYgcmVs
b2FkIHBjaS8wMDAwOmNhOjAwLjAgYWN0aW9uIGZ3X2FjdGl2YXRlDQo+IHJlbG9hZF9hY3Rpb25z
X3BlcmZvcm1lZDoNCj4gICAgIGZ3X2FjdGl2YXRlDQo+IFtyb290QGhvc3Qgfl0jIGlwIGxpbmsg
c2hvdyBlbnM3ZjANCj4gNzE6IGVuczdmMDogPE5PLUNBUlJJRVIsQlJPQURDQVNULE1VTFRJQ0FT
VCxVUD4gbXR1IDE1MDAgcWRpc2MgbXENCj4gc3RhdGUgRE9XTiBtb2RlIERFRkFVTFQgZ3JvdXAg
ZGVmYXVsdCBxbGVuIDEwMDANCj4gICAgIGxpbmsvZXRoZXIgYjQ6OTY6OTE6ZGM6NzI6ZTAgYnJk
IGZmOmZmOmZmOmZmOmZmOmZmDQo+ICAgICBhbHRuYW1lIGVucDIwMnMwZjANCj4gDQo+IGRtZXNn
IGFmdGVyIGZsYXNoOg0KPiBbICAgNTUuMTIwNzg4XSBpY2U6IENvcHlyaWdodCAoYykgMjAxOCwg
SW50ZWwgQ29ycG9yYXRpb24uDQo+IFsgICA1NS4yNzQ3MzRdIGljZSAwMDAwOmNhOjAwLjA6IEdl
dCBQSFkgY2FwYWJpbGl0aWVzIGZhaWxlZCBzdGF0dXMgPSAtNSwNCj4gY29udGludWluZyBhbnl3
YXkNCj4gWyAgIDU1LjU2OTc5N10gaWNlIDAwMDA6Y2E6MDAuMDogVGhlIEREUCBwYWNrYWdlIHdh
cyBzdWNjZXNzZnVsbHkgbG9hZGVkOiBJQ0UNCj4gT1MgRGVmYXVsdCBQYWNrYWdlIHZlcnNpb24g
MS4zLjI4LjANCj4gWyAgIDU1LjYwMzYyOV0gaWNlIDAwMDA6Y2E6MDAuMDogR2V0IFBIWSBjYXBh
YmlsaXR5IGZhaWxlZC4NCj4gWyAgIDU1LjYwODk1MV0gaWNlIDAwMDA6Y2E6MDAuMDogaWNlX2lu
aXRfbnZtX3BoeV90eXBlIGZhaWxlZDogLTUNCj4gWyAgIDU1LjY0NzM0OF0gaWNlIDAwMDA6Y2E6
MDAuMDogUFRQIGluaXQgc3VjY2Vzc2Z1bA0KPiBbICAgNTUuNjc1NTM2XSBpY2UgMDAwMDpjYTow
MC4wOiBEQ0IgaXMgZW5hYmxlZCBpbiB0aGUgaGFyZHdhcmUsIG1heCBudW1iZXINCj4gb2YgVENz
IHN1cHBvcnRlZCBvbiB0aGlzIHBvcnQgYXJlIDgNCj4gWyAgIDU1LjY4NTM2NV0gaWNlIDAwMDA6
Y2E6MDAuMDogRlcgTExEUCBpcyBkaXNhYmxlZCwgRENCeC9MTERQIGluIFNXIG1vZGUuDQo+IFsg
ICA1NS42OTIxNzldIGljZSAwMDAwOmNhOjAwLjA6IENvbW1pdCBEQ0IgQ29uZmlndXJhdGlvbiB0
byB0aGUgaGFyZHdhcmUNCj4gWyAgIDU1LjcwMTM4Ml0gaWNlIDAwMDA6Y2E6MDAuMDogMTI2LjAy
NCBHYi9zIGF2YWlsYWJsZSBQQ0llIGJhbmR3aWR0aCwgbGltaXRlZA0KPiBieSAxNi4wIEdUL3Mg
UENJZSB4OCBsaW5rIGF0IDAwMDA6Yzk6MDIuMCAoY2FwYWJsZSBvZiAyNTIuMDQ4IEdiL3Mgd2l0
aCAxNi4wDQo+IEdUL3MgUENJZSB4MTYgbGluaykNCj4gUmVib290IGRvZXNu4oCZdCBoZWxwLCBv
bmx5IHNlY29uZCBmbGFzaC9hY3RpdmF0ZSB3aXRoIE9PVCBvciBwYXRjaGVkIGRyaXZlcg0KPiBw
dXQgY2FyZCBiYWNrIGluIGNvbnNpc3RlbnQgc3RhdGUuDQo+IA0KPiBBZnRlciBwYXRjaDoNCj4g
W3Jvb3RAaG9zdCB+XSMgZGV2bGluayBkZXYgZmxhc2ggcGNpLzAwMDA6Y2E6MDAuMCBmaWxlDQo+
IEU4MTBfWFhWREE0X0ZIX09fU0VDX0ZXXzFwNnAxcDlfTlZNXzNwMTBfUExETW9NQ1RQXzAuMTFf
ODANCj4gMDBBRDdCLmJpbg0KPiBQcmVwYXJpbmcgdG8gZmxhc2gNCj4gW2Z3Lm1nbXRdIEVyYXNp
bmcNCj4gW2Z3Lm1nbXRdIEVyYXNpbmcgZG9uZQ0KPiBbZncubWdtdF0gRmxhc2hpbmcgMTAwJQ0K
PiBbZncubWdtdF0gRmxhc2hpbmcgZG9uZSAxMDAlDQo+IFtmdy51bmRpXSBFcmFzaW5nDQo+IFtm
dy51bmRpXSBFcmFzaW5nIGRvbmUNCj4gW2Z3LnVuZGldIEZsYXNoaW5nIDEwMCUNCj4gW2Z3LnVu
ZGldIEZsYXNoaW5nIGRvbmUgMTAwJQ0KPiBbZncubmV0bGlzdF0gRXJhc2luZw0KPiBbZncubmV0
bGlzdF0gRXJhc2luZyBkb25lDQo+IFtmdy5uZXRsaXN0XSBGbGFzaGluZyAxMDAlDQo+IFtmdy5u
ZXRsaXN0XSBGbGFzaGluZyBkb25lIDEwMCUNCj4gQWN0aXZhdGUgbmV3IGZpcm13YXJlIGJ5IGRl
dmxpbmsgcmVsb2FkDQo+IFtyb290QGhvc3Qgfl0jIGRldmxpbmsgZGV2IHJlbG9hZCBwY2kvMDAw
MDpjYTowMC4wIGFjdGlvbiBmd19hY3RpdmF0ZQ0KPiByZWxvYWRfYWN0aW9uc19wZXJmb3JtZWQ6
DQo+ICAgICBmd19hY3RpdmF0ZQ0KPiBbcm9vdEBob3N0IH5dIyBpcCBsaW5rIHNob3cgZW5zN2Yw
DQo+IDE5OiBlbnM3ZjA6IDxCUk9BRENBU1QsTVVMVElDQVNULFVQLExPV0VSX1VQPiBtdHUgMTUw
MCBxZGlzYyBtcQ0KPiBzdGF0ZSBVUCBtb2RlIERFRkFVTFQgZ3JvdXAgZGVmYXVsdCBxbGVuIDEw
MDANCj4gICAgIGxpbmsvZXRoZXIgYjQ6OTY6OTE6ZGM6NzI6ZTAgYnJkIGZmOmZmOmZmOmZmOmZm
OmZmDQo+ICAgICBhbHRuYW1lIGVucDIwMnMwZjANCj4gDQo+IHYyIGNoYW5nZXM6DQo+IC0gZml4
ZWQgZm9ybWF0IGlzc3Vlcw0KPiAtIGFkZGVkIGluZm8gYWJvdXQgZncgYW5kIE9PVCBkcml2ZXIg
dmVyc2lvbnMNCj4gLSBhZGRlZCB0aW1lIGluIHRoZSBjb21taXQgbWVzc2FnZSBzdW1tYXJ5DQo+
IC0gYXBwZW5kZWQgdGhlIHVuaXQgdG8gdGhlIG1hY3JvIG5hbWUNCj4gDQo+IEZpeGVzOiAzOTll
MjdkYmJkOWU5NCAoImljZTogc3VwcG9ydCBpbW1lZGlhdGUgZmlybXdhcmUgYWN0aXZhdGlvbiB2
aWENCj4gZGV2bGluayByZWxvYWQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBQZXRyIE9yb3MgPHBvcm9z
QHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9tYWluLmMgfCAzICsrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiAN
Cg0KVGVzdGVkLWJ5OiBHdXJ1Y2hhcmFuIDxndXJ1Y2hhcmFueC5nQGludGVsLmNvbT4gKEEgQ29u
dGluZ2VudCB3b3JrZXIgYXQgSW50ZWwpDQo=
