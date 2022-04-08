Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEE74F8DAC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiDHFW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 01:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiDHFWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 01:22:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDE11DAFA2;
        Thu,  7 Apr 2022 22:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649395222; x=1680931222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WOpSMVMG9PC9ywFDoxndEWeVGDqjfY4fdVgVwW0YArw=;
  b=Efy4OeVLwWwT7XJT+ONOZkTzld6mGFd6cTt0ppTa5GAJ1SyD7fnHafxM
   OdxUTt1GzD/fdmW2I8da9D9NNUuOUlfjFOOsWUiE2wRzaC9TpllY/S+MC
   1HJZfxaIB19YBZGuW6POem6Oc97qNv9hrVIFFKH19TQV4MAEJJoDUDPU6
   2oJFOiNso2+zp7dZTaq5g49ThTKtGcVkWPlXeasKKr8WD8ACkHBezP+BF
   Os9aCshnM0MHx79imdlxmO+ym3aRHanZRiI6KQT6/FqXkxPB/fc9AiEsc
   34g5BHPq9OQRhiZy+2xujUl0AUYDlCeCclUT9xbgxYKh48OCRhTa8l3zI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="347952384"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="347952384"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 22:20:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="524655611"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2022 22:20:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 22:20:21 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 22:20:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 7 Apr 2022 22:20:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 7 Apr 2022 22:20:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBNZDaNBBLIoXxpdiyECuL+zJRZp5mQjKyFl75a1hHTEyzzsVnktdJcWDh5VkGB4JXZT2ZxVJ6ACuLRIvPz9FoI+YIRh2lldfooV90kkgo/ct3hVbtExbtcahDphT2mBbEgx/eH+Qw9spjGEV44Ig/8PpJFZABJJruf87TECSBs8D4aMxTlt8uJ/8nK9IHg6Vo4NhowkNJ1HyMijxwub+wlU7E03tg/NoNKLxvcM2TIVPOBmgBRIhqS7T67ialnQZbksJoOJRpKqAu7R7RllpE0s7N/essIEiweYd5QV0P1ndfEdKKEaqTUyFAI/UPb98Xpn450IzGwuFJD7qYZQSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOpSMVMG9PC9ywFDoxndEWeVGDqjfY4fdVgVwW0YArw=;
 b=ZAjbP8o3QKjYTHjxnCi2zV726W7144GZX79OIoXXvwU7oCRCYB/BJm798HU1/7/Oo/vFDktPkV+QEzgHcqALBxID8ROJLtDYJGka1ZDxpQwDkugR2bevWY9b4uERUfxLNrNNJBu58FzcIVUfL+4wbRvSjSkuCaUMPBts3ZKYDjCYqTU5rEo8cXv8tMxyiPX0Zd3BlUMLTPhALd588cvmAjAFdHvn2ON0TYXDblN7geP1TAlOM8uFc/Z2fEa+Rvnn2/rLNjgmsR9poM9YM7e89l0m5C1m7LkwlhCipgdeEBpPKqoqDyMOFef/6f2wSN9rZoifGdyxfgJcW7V5bDynRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by MN2PR11MB4445.namprd11.prod.outlook.com (2603:10b6:208:18a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 05:20:19 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::a428:75b3:6530:4167]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::a428:75b3:6530:4167%7]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 05:20:18 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "linux@roeck-us.net" <linux@roeck-us.net>,
        "Greenman, Gregory" <gregory.greenman@intel.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Thread-Topic: [RFC PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before
 freeing
Thread-Index: AQHYScvOzaVNf8b+Vk2Bkz9YQJCSUazk3dqAgACfOIA=
Date:   Fri, 8 Apr 2022 05:20:18 +0000
Message-ID: <f233cb842303e121338e2d881eec88762068d324.camel@intel.com>
References: <20220406153410.1899768-1-linux@roeck-us.net>
         <5b361192-6fd4-e84d-d6fc-e552a473c23e@roeck-us.net>
In-Reply-To: <5b361192-6fd4-e84d-d6fc-e552a473c23e@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.43.3-1+b1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1524d71-2a72-478f-b577-08da191f78be
x-ms-traffictypediagnostic: MN2PR11MB4445:EE_
x-microsoft-antispam-prvs: <MN2PR11MB4445CAD09DAFF8FBFB41EDF090E99@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QtpPSDomPnTItBuQnU+/hVjrj538FjY6wmwd7QIqEkgE+Jkuyq39oBdrgUX3p4LhWXcGjW21YYoifqzINioSpKPOkXcPR5WHc6ii3Oj6BdxEEBXse2DpY7lcifGJMZfjnNd0lmiIyAG2bcefXuEoPRA9VK+yfAmwuiPJz/t5laZ4KF1VoQbq7D2SkRcoxkBlHtuoraWhiuzlXAKGfqqNgKwXO4ziENDub77PmUIzbIUWJWjAMqlqDEDMoA4dOIDra9QHqMW+cLVy+6Fos1qVWoe06z45XesiHfkIE6g26Jnvsh67kBVQc24VlC1CO2mW7cWQSW0f1Z8x9K40u5NOWiRAUAyIdvqZ/92kB47XO1tqtziCKgG2t16WVtziRZeN8jGSQZttfqAD4+lAWvY1CIy+jcuqhb4YsLk3GeieAJTvCrp9YqLuNA8L6R3vUBR9rPYaNR0ifS7j14yYvSG4Lo8ApKbDrfB5c58XAOIiFXQYe90lLS0uGmg1K6Q8xXSXoLb5Gx03ZwHdsNQguvkAic1F9mRY6ibzL36PoHKb+JZSehevrsfLHc6ZMnpzJXg+AiwTxoS+bcjuv6Jcmaxb5o8TJ8XwagmJ/LC7iBCD7g6fBOxwYBYlrzX8pzpa3fy5VocWHKEJLyzBQKD9UJ02iHFvPde7QgLeKEm6QTDNGADOyL7jh73UGMeJSnpxXi9Tb2AXMzFdmoBX1H5tULNifw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(316002)(8676002)(64756008)(82960400001)(8936002)(6636002)(186003)(6512007)(86362001)(6506007)(38100700002)(2616005)(508600001)(83380400001)(26005)(110136005)(2906002)(76116006)(71200400001)(5660300002)(36756003)(6486002)(38070700005)(53546011)(66476007)(66446008)(66556008)(66946007)(91956017)(122000001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWduUGY5VER1dkU5R3BRQ29pbUVCaTc2MXcrWm96NTdpVTY5MTI3dkI5Y2xS?=
 =?utf-8?B?UkZicTBLOHcxSnZhU2xGdmZZb2tzb3BKdCswOVZyMEZQUzNyeVZML2E5dXBX?=
 =?utf-8?B?amdURTFlNEZpZlhlOVFZdlVOd2hwcFo5L2hWQmJWekRGOCtNenN2STBuOFRE?=
 =?utf-8?B?bUFBb0lEdG90dTN0N3pPT2prMVpLVXZzM2ROSmxraHoyQkpWMlFpTTEzbUl3?=
 =?utf-8?B?QmNDZVhvZ2hRZjlETU1hZzVQQmN5OFJqNmkxVkFkUExObzlpRW1KbVM4V2JZ?=
 =?utf-8?B?elIzREIwcy9TZTJ6OGhRU0MydzNuUWdzU1VvbE9EemhxS2JoWm9JaEhzcDI1?=
 =?utf-8?B?TTN1amFsTFZBVEt4R1VOVDcvWVlvazN3ajRDSTBTMkhHbVZYdW10Q3hXalkr?=
 =?utf-8?B?UGtHcFZqcnZHQUVVUjhOOEtIM1BZWmpJQ2VkdVBzRnhuOFV0ejZORlg3NlZL?=
 =?utf-8?B?Z2dFS2RoTjF4NVdPMU5qNjdRY0wrOEc1dXJEVEcrWXJUMmY0ekpwZU9XNk5k?=
 =?utf-8?B?OG80bTd3U3VBdTJXeTZFMWtZUFBpSlg2dHI5eU9QUlRYVVVxMHBKcWt0STdS?=
 =?utf-8?B?UjFXaHhsY29iSm1WY1FCeHdMc2dQYzg0MzlRcGxMUlNRaGFjTmsxWGhKV2J4?=
 =?utf-8?B?SmJyWG9xa2ZEbkJzTUhlVWdMeEk5dHBNcmFuYS9YcFAxYlQ1b3RQK2UzUU5I?=
 =?utf-8?B?OWJNUUczMkVtZmc0a09hMmIwNklqd1N5WmhMNHR0L21sRXBVY3o0azJzQnNh?=
 =?utf-8?B?bU5WbE9JSExGN0QvQmhUNE50ZnQwUndzalJJWkpyamVuTEx5OUN4Y3JUNXZZ?=
 =?utf-8?B?bTNWOUl6Q3pTOSticzNNVCtOS05xZlozaHRvTEZmSkdJQ0lSeCtQTDc5c3BT?=
 =?utf-8?B?cG5NbXJHblB5Uzk5OXp6cTNDQXJnY1E2M1BEQ054Y0Qway9VeEgwcy9kZWdV?=
 =?utf-8?B?d1FzclV5NFRFeVEramkxN09kdFpvVlJ1V3JvV29KWjgyQlZBL1NCc3ZkOFQw?=
 =?utf-8?B?cVg3VHJIMWdkSG9sYTBDUzNyWXhwdEJESG11S1FVcitCOFJrT0NpWENoQkZI?=
 =?utf-8?B?L004MFZheU9tcGJsVmtwZHlDeGhhWnhZcDB6MkFqSmpOeGNrTXlGbFhwalR5?=
 =?utf-8?B?V3ArR0Z2U2VmVGJrc2ZzalBRS215cVZLU05MbGxIVGthT0RtNDNkQy9YRFFR?=
 =?utf-8?B?TzVUZHZKSFZJcU50M293YVhsdTg4aWo4MkZNeVU5allqRVE0R1BKekVUaGVH?=
 =?utf-8?B?cVRIYXdHZ3BuTmkvNWQ5UHhiRG5CTlZ5ekhveTRabTdFeGNNNTB2eE14dDM1?=
 =?utf-8?B?c0tKakZvcDVuK0czampjbitSY0txRERBdkYyS1dxUEFMMm50QUZ3Rm83V1h4?=
 =?utf-8?B?TS9Ra00wZ1BLWHZPNUw4dnRKK0phSWdIaUlFek85U0ZGNis2S3dBdWhmQ0tX?=
 =?utf-8?B?OVpBTFl5d01tVzNQTkJLbUsxbXRuQmxkakZpVlhqcE1tZGhYMUg3clNmcmNR?=
 =?utf-8?B?M09YWEwrL21BVlBDTHdwcU5SVTNYbk0vZFFvb0E4YWo3cWhySkRWc1RzNThU?=
 =?utf-8?B?TFJBc1U5ait5emFHaEZ2VkxiU0hMVmd2VGFGK20zWVlERG9NZGZDY3YzN2s1?=
 =?utf-8?B?UzRoeEFuR0R3V0FmNUw2UnB1NkZCZHdLeW5JQVBZdmFiMmZWbjc4YUtpVXdI?=
 =?utf-8?B?MmVDSnB6dEFucWF3VE9qdmNVNE9SVWRuejBPR2pyazJuMWxmZStOaDd3YzNo?=
 =?utf-8?B?ZzVTSlBabkJmQlQ1d2N1RzkxWk9DT0tqcHRnNVNXbUpCK3VtdU5OTXdxaWNL?=
 =?utf-8?B?SFFxcmt1VXc0MUMyRSs4bFZZYUdTcm5KVU1RODNtRjFuQXRSeHdYSUdndWlk?=
 =?utf-8?B?RDhOTVhVQlo2RzNiUzFuTVJMVlV6bXZlRnFMNXAzMzR6VFVMbWVpR1RCNm5q?=
 =?utf-8?B?WHNEZFdEZ2I3LzJPODVrN0t3RDhDWS9SeHR1TTB3QVZOMnB4WVF2NWtqM1po?=
 =?utf-8?B?b1NBa3ZWWU9RdEZPenlJMGR5K0Y2RTdESE9sRVorRU5SaGNsMWo1eGttTkJx?=
 =?utf-8?B?SGJHODU0TlljQVY2VThERnlGc3FxcVppTkprZG5kS2htRzNjNnpYRW1iRWRU?=
 =?utf-8?B?YUYzay9aQW9oaFJRQzlkdHNxVndZN29zTWZxZENWSTBXdXQ1YzI0WUQvOTB1?=
 =?utf-8?B?U3BSck1CSkRKRTZ0MFQ5ZndyUitaUjloUytBaXpEeXI2UlI1QmdnVHIzb3Nn?=
 =?utf-8?B?U21oZzRMNHpweE42ZXdHWk1OTm5RK29MZC81Yy9ZZnE0WkxQM3BRZVFuUkdU?=
 =?utf-8?B?cWhEZHl6RFR2cXJKeUwxMGlwOU1ZeW5nK2FWeWh4cEFsSjhZdjVDbnMxVldQ?=
 =?utf-8?Q?5o+Kq4kegMKt2VFE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6E9DAE10F9CE8489E432ED9D9540751@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1524d71-2a72-478f-b577-08da191f78be
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 05:20:18.6010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OQekTotgMK1x8bvXjExlpBYmGRBK2+kS4dkJDwsDP5Oh5fxFwqqGRoFaTAI2wVQUD5RlZURPo+C0g+TV4N4/12N5/nB+1OamkbDGCeE6Jtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA0LTA3IGF0IDEyOjUwIC0wNzAwLCBHdWVudGVyIFJvZWNrIHdyb3RlOg0K
PiBIaSwNCj4gDQo+IE9uIDQvNi8yMiAwODozNCwgR3VlbnRlciBSb2VjayB3cm90ZToNCj4gPiBJ
biBDaHJvbWUgT1MsIGEgbGFyZ2UgbnVtYmVyIG9mIGNyYXNoZXMgaXMgb2JzZXJ2ZWQgZHVlIHRv
IGNvcnJ1cHRlZCB0aW1lcg0KPiA+IGxpc3RzLiBTdGV2ZW4gUm9zdGVkdCBwb2ludGVkIG91dCB0
aGF0IHRoaXMgdXN1YWxseSBoYXBwZW5zIHdoZW4gYSB0aW1lcg0KPiA+IGlzIGZyZWVkIHdoaWxl
IHN0aWxsIGFjdGl2ZSwgYW5kIHRoYXQgdGhlIHByb2JsZW0gaXMgb2Z0ZW4gdHJpZ2dlcmVkDQo+
ID4gYnkgY29kZSBjYWxsaW5nIGRlbF90aW1lcigpIGluc3RlYWQgb2YgZGVsX3RpbWVyX3N5bmMo
KSBqdXN0IGJlZm9yZQ0KPiA+IGZyZWVpbmcuDQo+ID4gDQo+ID4gU3RldmVuIGFsc28gaWRlbnRp
ZmllZCB0aGUgaXdsd2lmaSBkcml2ZXIgYXMgb25lIG9mIHRoZSBwb3NzaWJsZSBjdWxwcml0cw0K
PiA+IHNpbmNlIGl0IGRvZXMgZXhhY3RseSB0aGF0Lg0KPiA+IA0KPiA+IFJlcG9ydGVkLWJ5OiBT
dGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4gPiBDYzogU3RldmVuIFJvc3Rl
ZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+ID4gQ2M6IFNoYWhhciBTIE1hdGl0eWFodSA8c2hh
aGFyLnMubWF0aXR5YWh1QGludGVsLmNvbT4NCj4gPiBDYzogSm9oYW5uZXMgQmVyZyA8am9oYW5u
ZXMuYmVyZ0BpbnRlbC5jb20+DQo+ID4gRml4ZXM6IDYwZThhYmQ5ZDNlOTEgKCJpd2x3aWZpOiBk
YmdfaW5pOiBhZGQgcGVyaW9kaWMgdHJpZ2dlciBuZXcgQVBJIHN1cHBvcnQiKQ0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEd1ZW50ZXIgUm9lY2sgPGxpbnV4QHJvZWNrLXVzLm5ldD4NCj4gPiAtLS0NCj4g
PiBSRkM6DQo+ID4gICAgICBNYXliZSB0aGVyZSB3YXMgYSByZWFzb24gdG8gdXNlIGRlbF90aW1l
cigpIGluc3RlYWQgb2YgZGVsX3RpbWVyX3N5bmMoKS4NCj4gPiAgICAgIEFsc28sIEkgYW0gbm90
IHN1cmUgaWYgdGhlIGNoYW5nZSBpcyBzdWZmaWNpZW50IHNpbmNlIEkgZG9uJ3Qgc2VlIGFueQ0K
PiA+ICAgICAgb2J2aW91cyBsb2NraW5nIHRoYXQgd291bGQgcHJldmVudCB0aW1lcnMgZnJvbSBi
ZWluZyBhZGRlZCBhbmQgdGhlbg0KPiA+ICAgICAgbW9kaWZpZWQgaW4gaXdsX2RiZ190bHZfc2V0
X3BlcmlvZGljX3RyaWdzKCkgd2hpbGUgYmVpbmcgcmVtb3ZlZCBpbg0KPiA+ICAgICAgaXdsX2Ri
Z190bHZfZGVsX3RpbWVycygpLg0KPiA+IA0KPiANCj4gSSBwcmVwYXJlZCBhIG5ldyB2ZXJzaW9u
IG9mIHRoaXMgcGF0Y2gsIGludHJvZHVjaW5nIGEgbXV0ZXggdG8gcHJvdGVjdCBjaGFuZ2VzDQo+
IHRvIHBlcmlvZGljX3RyaWdfbGlzdC4gSSdkIGxpa2UgdG8gZ2V0IHNvbWUgZmVlZGJhY2sgYmVm
b3JlIHNlbmRpbmcgaXQgb3V0LA0KPiB0aG91Z2gsIHNvIEknbGwgd2FpdCB1bnRpbCBuZXh0IHdl
ZWsgYmVmb3JlIHNlbmRpbmcgaXQuDQo+IA0KPiBJZiB5b3UgaGF2ZSBhbnkgZmVlZGJhY2svdGhv
dWdodHMvY29tbWVudHMsIHBsZWFzZSBsZXQgbWUga25vdy4NCg0KSGkgR3VlbnRlciwNCg0KVGhh
bmtzIGZvciB5b3VyIHByb3Bvc2FsIQ0KDQpJIHJlY2VudGx5IG1vdmVkIGZyb20gdGhlIEludGVs
IFdpRmkgdGVhbSB0byB0aGUgR3JhcGhpY3MgdGVhbSwgc28gSSdtDQphZGRpbmcgR3JlZ29yeSwg
d2hvIGhhcyB0YWtlbiBvdmVyIG15IGR1dGllcywgdG8gdGhlIGRpc2N1c3Npb24uDQoNCkkgZG9u
J3QgcmVjYWxsIGFueSBzcGVjaWZpYyByZWFzb25zIGZvciB1c2luZyBkZWxfdGltZXIoKSBpbnN0
ZWFkIG9mDQpkZWxfdGltZXJfc3luYygpIGhlcmUuICBTbyB5b3VyIHBhdGNoIGRvZXMgbG9vayBj
b3JyZWN0IHRvIG1lLg0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
