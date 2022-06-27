Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E6455D997
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiF0LnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237189AbiF0Lmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:42:33 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7E5DF06
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656329790; x=1687865790;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f14RJhgBWjslYHTIce/LAV2vRW1GEBw7LblMpBvLJKo=;
  b=kDTN9E/Cj5Z5jFGiwJsxMBSDygRfgTkLc/oiQbGaEU8+pCQ3RLyDk7GU
   ltXd4ElxE6WIZEGuQZa3XfIDmwYALJpiUIXXDzi5jG95s3eeoEJMdwURu
   +R4isE/rZKikCC9z3rmvVD3pbECcy23YWbo+S7brdzNpx2+zt3oKrpP32
   SGiOblE0YtLBUvb+8WmJYQs/SP9lYrogkNXvlLPpBMqkUGlkpi3hijFqz
   pnaG76Cf4eTSxvJC2I0FKVoXqkYwKB80wyS6O5tsN5o41bUnzbE762kyr
   Ui8AfpOBoUIyeQ1CJ57XdRT/6BM5WOzKKrfJ7Giz8Lf3QVNpaOZItWc9t
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="343115614"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="343115614"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 04:36:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="717019217"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 27 Jun 2022 04:36:27 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 04:36:24 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 04:36:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 27 Jun 2022 04:36:24 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 27 Jun 2022 04:36:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blNgO2cgfyf3exCIOJc9A3ssBnJuCWGJGUETkRAs1MPi1iAEGJ+bGtBIrzxIL3fhNMZBalgw9UI0f8BHRXR1Z/Osk44TssOb0oEa7r7pMF8RI2KblHnz47JxLR3B4IW0M+TGnreRkfJcY10WCBfDBoS1943kXbPWDmB5ojl/mjBRvOujHd3gjXP6P1jOxjMT0vHOA42TBElUcnetz9WBQCSvx2EqUqzw2TM74XYBsMz1ISEZvVptoSuLn9jgNbuzuK4tUl6osCBxZoBnwfV10OMRMvraFwDW3qaFywsuvD8eJKJiKpyIfu8AiYjFrk7Oe78H2xclmsRu6l9EtbTx+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f14RJhgBWjslYHTIce/LAV2vRW1GEBw7LblMpBvLJKo=;
 b=nWQr2L9dDxvglUgw4hK+AgeRoIYfEcHw5U2UGf2c5IScOgtFJ6KefkU5pU2TuRt++HkyYjrNxS8Zqj6H+H5uC+YgjicPA0LYvNVVp0Rftq+/CJKqfrIziZT+A4QGszQ7gcWr4cGP2qDBMpxepPWRL7TVLSvGYGCQA04pWHdZeQAyPscgaMstZcQ4z9E+SeRQa2z2zUO7QA4/sz8tz5yYbZrOVU22NRIj3PsnBrWkAj5pK8TtDCeApVSVXIhFGntgcBIgnx2OfU/eElK02U0J3QB9RuDgaMqTbLeVJV4BxCEV+bLrukuTs+ge4fM3g0p6lhgtBk/AYPaG6ZLIWZWSZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by MN2PR11MB3918.namprd11.prod.outlook.com (2603:10b6:208:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Mon, 27 Jun
 2022 11:36:22 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c%3]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 11:36:22 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "elic@nvidia.com" <elic@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>
Subject: RE: [RFC PATCH net-next 1/4] flow_dissector: Add PPPoE dissectors
Thread-Topic: [RFC PATCH net-next 1/4] flow_dissector: Add PPPoE dissectors
Thread-Index: AQHYh9BDElYAHuMNC0u6wODYDa8kZa1hSr8AgAHZdUA=
Date:   Mon, 27 Jun 2022 11:36:21 +0000
Message-ID: <MW4PR11MB57765C5D5A1149515E3C6F97FDB99@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220624134134.13605-1-marcin.szycik@linux.intel.com>
 <20220624134134.13605-2-marcin.szycik@linux.intel.com>
 <DM5PR1301MB21725B441E51642967C8BB4FE7B69@DM5PR1301MB2172.namprd13.prod.outlook.com>
In-Reply-To: <DM5PR1301MB21725B441E51642967C8BB4FE7B69@DM5PR1301MB2172.namprd13.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: b64dc91b-be1b-4cd8-2078-08da58314291
x-ms-traffictypediagnostic: MN2PR11MB3918:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rd416+S53PJb3eW9G7NFGwYNXCtUFp0EJf7u4GA5QTVp6qoOU28RK/c2EcZUE8mojvockcfyOEwvthBX7boue+i/rhOHBK1F4Uu9WrOTrIGM1qeg3zMAXQxjRToCopLXdyh4JwiFiJDrjaDOSqu4Ty6yor7yhecwXS9pMaxv1gvl+1wrYHkkW1F+ZbeySD7NtuhYFpDeTarTsyBuk/2z06JggHjWHI6gQhjDNcTzbmKxgblhXpFlioYwAuFcQ7QePBWPeujvHjphn1Jq8fp92PvdGou2knhDdjVbqvLVR3VL+JPzVDcowl1AMt5R9HJVM6742rXcC1oJRVcKzn2w+EqENFyv2WQuxybOoDyRUrGzfcDfMYiBwNYk2xJVm7o8gio1rSreTuxFG93AOjmSZH3KyU4XWmX0wzrhnSgWCBypPEvGSHQb0JKTbtKiDMKQcBFcTL9stlXUntMsCbF1BAz/1xEYP9OnDQAjPbeIbxQdzRhys1kxMs7wUHNuqjCQVodwXapYnhqdwFN3eLE3LW0IaLIYoqMK/HWs1w5t6zZ7/lfEHk0oj/oP/88LB9fgs+fya7F5crp8RylOROpZx1Hm4lM9u5mjUbzD/8h1V9ZGSfcdF7YGheukuJFt2zYTcX5+jYHQaZremEGoKJ5D+cAWSoJ8FD6frhC5iN38i0FcB4Ft0GUFWfUNv1OQ09fEWUYiOfhiB9cFeSE8smlRqTtJVD7GgKL13a/eqdr7UFSdl5N5QZeJTmsDlTGxCgm4gxqzlACRYFI8B/WGQ1dQ9ljxCFYoyVcCyKl5lrJEwe0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(396003)(346002)(376002)(136003)(38100700002)(55016003)(186003)(122000001)(316002)(33656002)(86362001)(7416002)(110136005)(54906003)(83380400001)(5660300002)(52536014)(6506007)(4326008)(66946007)(9686003)(8676002)(64756008)(66446008)(66556008)(38070700005)(66476007)(71200400001)(26005)(7696005)(41300700001)(8936002)(53546011)(76116006)(82960400001)(2906002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnlDMUJFcGtUNjYvWkpIcFZUanBNdzJacVQ0UmY5WjJxK1dVd2xZZVdMOWlY?=
 =?utf-8?B?OCtxVUtTUWFGbUo5T2hLRUEzTjFINUZkdUdzR0tNT2lNTWZIcjJiS1ZYVDIw?=
 =?utf-8?B?K0tQYmloTHdXVDMvaFpGUWpYanh3ODZ2Q1QvSVRnNXJpQXJ4Y0lveGNWL3Bp?=
 =?utf-8?B?cDBtMHBVNlIwZm1EU2FKVEEyZzQrNFVaRVZwQjRjVUxScVJRRlc2VlhoVFhm?=
 =?utf-8?B?UmhsVFlibzczbzZ0YlMxWVVTeThiUnVKcXBYdFhZbER6UjVtaEdkN2Ftc0l2?=
 =?utf-8?B?VXFrWjMvZGc1VFByZnRXRmJzaVdadXFwa2R4WTRvRmVRS0grMnBTSzlCZlB3?=
 =?utf-8?B?cmtjNTRWT0JuelA3ek1hQmdsRlBDMzlvUVJyc2tvdGJpeEkwckI0a0s5dExm?=
 =?utf-8?B?K2RJN1IrL3JadnZCTzRPdXZ4UWZzN2ZyZEtyNXVNYXJyei9sNGVNYTJWKzE5?=
 =?utf-8?B?SGtGOWNtQUVwdmcrbUxGK0FMN2pyU2VZQUJwQy9XM0k4bllpOVdJbnlYb051?=
 =?utf-8?B?blRxZXU3cEdHcGhhZVhvWEc1MmpmbDBzQ1EwVUc1cDBFQXQ0UzJGK3dmaUU3?=
 =?utf-8?B?QUJHaEFKTWhNc2hzQ1pNZW9uRjZwZzZjU0poQ2JjWVpmUmlTSzV6TnZpeTQ3?=
 =?utf-8?B?ZWc5cklIZllPc2x6N0dlaUw5RmFwaWdoaWxsTG4zUDRBdFQ4WC9yZlFZckhX?=
 =?utf-8?B?Z2l2THB4dnh6TXdKN0VCcjBxOUtyRXd3ZVJUdk95UmtSY1lMMDJXRXhhOHJH?=
 =?utf-8?B?dFNGbXoxWGtBV0JaeUVIWkRRRURUamJIVjVjeHczVFdjbmwzWmJLZUZaRmRz?=
 =?utf-8?B?eXZ1T0EySEFrVG9hMU5CT0ZtWnhyQW0zRDF5dE1QYUQ0VlVYTld6S1ZqenhZ?=
 =?utf-8?B?VysxVlV4Q3VvdWJ4empwUmlXdDhoa0ZzZC8xUFZsUitxWHowWGZNUERITXI3?=
 =?utf-8?B?Sm8yMExWUkI4MXM5YUl5aytsODlvRXQ3UnZuc1dlYTk3TFM1VlRMc1J2Wmlu?=
 =?utf-8?B?eTN0dGYyMFo4ckVSbDVJL09hYmJ5OVVYM2ovdlFzS2VFOHB4ZVhkNGdXMFl3?=
 =?utf-8?B?ZWhCT2VHb2lQYnR4a1RRWCt1ZkxhWWpsRHJnL25tNGlHOFZrZ2F0NzI5S25x?=
 =?utf-8?B?OVB5MlR6ZmhNQUdnZ2V2cldRUTY2ZE9ZdEZEeHRxbVlqNXV4NXhiK2RZaCsx?=
 =?utf-8?B?WWNRbWthVFRrV21UQmpMbUo5RktWdlh4WGNoZWR6Wkd5d0xmRWtvbGRWbStz?=
 =?utf-8?B?R1hUWDhvRXYvaElHSlFMUm1xNmxybGNEQ3hFWFJsQXdiN29XdzBhVXZKSnp1?=
 =?utf-8?B?QkhURDBlWVpVVGN2RDgwMHF3YkhQTndDMHRnaHUzM1ozMTBNU0MyZWFneTU4?=
 =?utf-8?B?L04zUzNWVXU2bEZlOVA5R2xncVZlQitrZEs3UlJPV2dPU3lrVU42TzlFN2lq?=
 =?utf-8?B?cGlSWEt5SDlvM3B5eTlJWjdwZHZhK2N5RExKWDlxRlNSYzBiOWpEdHZaUHR3?=
 =?utf-8?B?RWlrYUozTlB5b09lS05UMXpiVEx3YTBlZ1owU0pKQ2ZiZUVzT2JjR2xOZ3V6?=
 =?utf-8?B?MUlNN0xTank3YWRiaVVsQjh5NUpWZG5GZmtTUGxzNkpaREdUZzdSWkhiU256?=
 =?utf-8?B?WGZvT0Y0eHQ1Q1B6Z2hLekc3cXAzajhOUWxraDNGR3JxMmJNWEVrT29uSy9U?=
 =?utf-8?B?eGFnNTU4aUFGTW13SWJxY1VsYWpZQzZLVXFDdDRUSkg0SHYxNEhXWWZNU1lz?=
 =?utf-8?B?Y2crVjJ3M0pBSnAzSjNRMUIyMkYyY2VWZVYrSVZIZ3dlUjNwZTdpOWJMWkRj?=
 =?utf-8?B?NGF5NUdJOTNOMzR0OHFIY0dnREFuTnNSZGlKWkNSVUxLL3lXN2x1ZzlobHoz?=
 =?utf-8?B?VHloZWplRHlsamhBZ2t6RzAxMUhkY2ZPd21DbzFJazE4OXBzSVFxQTE4d3Zq?=
 =?utf-8?B?WW5UZi9BWncvQUhwR0lHejFxU3hsMEJ2OUErRWxXdE95dU51OURMYjROZnNC?=
 =?utf-8?B?MldKdHdoSVdKOWpIcWpJR3pIUktjd3R6NTRUcVV3emRlWU5Dd0l5L0hBREJw?=
 =?utf-8?B?WXJZSk5rQnRrakRPcTlERDlzeVBBL05FTkNFVmQzTlFPd0Vua3dtTTFQMXZm?=
 =?utf-8?Q?SnCsA0Wb863mKf7IMFL5QmRww?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64dc91b-be1b-4cd8-2078-08da58314291
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 11:36:21.9326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6WNbcULR5KA525TqtqgiCJXMK3VFdWog3RwubYoevsKeBwI6IuH8bIMUCp1aoDh59FhunWhXM839yspm8IdTelR8c9qGA5EqS820+Y74BdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3918
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB0aGUgcmV2aWV3IQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
IEZyb206IEJhb3dlbiBaaGVuZyA8YmFvd2VuLnpoZW5nQGNvcmlnaW5lLmNvbT4NCj4gU2VudDog
bmllZHppZWxhLCAyNiBjemVyd2NhIDIwMjIgMDk6MjANCj4gVG86IE1hcmNpbiBTenljaWsgPG1h
cmNpbi5zenljaWtAbGludXguaW50ZWwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBD
YzogTmd1eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPjsgZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsgeGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tOyBCcmFuZGVidXJnLCBKZXNz
ZQ0KPiA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBndXN0YXZvYXJzQGtlcm5lbC5vcmc7
IGJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tOyBlbGljQG52aWRpYS5jb207IGVkdW1hemV0
QGdvb2dsZS5jb207DQo+IGt1YmFAa2VybmVsLm9yZzsgamhzQG1vamF0YXR1LmNvbTsgamlyaUBy
ZXNudWxsaS51czsga3VydEBsaW51dHJvbml4LmRlOyBwYWJsb0BuZXRmaWx0ZXIub3JnOyBwYWJl
bmlAcmVkaGF0LmNvbTsNCj4gcGF1bGJAbnZpZGlhLmNvbTsgU2ltb24gSG9ybWFuIDxzaW1vbi5o
b3JtYW5AY29yaWdpbmUuY29tPjsga29tYWNoaS55b3NoaWtpQGdtYWlsLmNvbTsgemhhbmdrYWlo
ZWJAMTI2LmNvbTsgaW50ZWwtd2lyZWQtDQo+IGxhbkBsaXN0cy5vc3Vvc2wub3JnOyBtaWNoYWwu
c3dpYXRrb3dza2lAbGludXguaW50ZWwuY29tOyBEcmV3ZWssIFdvamNpZWNoIDx3b2pjaWVjaC5k
cmV3ZWtAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSRTogW1JGQyBQQVRDSCBuZXQtbmV4dCAxLzRd
IGZsb3dfZGlzc2VjdG9yOiBBZGQgUFBQb0UgZGlzc2VjdG9ycw0KPiANCj4gT24gRnJpZGF5LCBK
dW5lIDI0LCAyMDIyIDk6NDIgUE0sIE1hcmNpbiBTenljaWsgd3JvdGU6DQo+IA0KPiA+QWxsb3cg
dG8gZGlzc2VjdCBQUFBvRSBzcGVjaWZpYyBmaWVsZHMgd2hpY2ggYXJlOg0KPiA+LSBzZXNzaW9u
IElEICgxNiBiaXRzKQ0KPiA+LSBwcHAgcHJvdG9jb2wgKDE2IGJpdHMpDQo+ID4NCj4gPlRoZSBn
b2FsIGlzIHRvIG1ha2UgdGhlIGZvbGxvd2luZyBUQyBjb21tYW5kIHBvc3NpYmxlOg0KPiA+DQo+
ID4gICMgdGMgZmlsdGVyIGFkZCBkZXYgZW5zNmYwIGluZ3Jlc3MgcHJpbyAxIHByb3RvY29sIHBw
cF9zZXMgXA0KPiA+ICAgICAgZmxvd2VyIFwNCj4gPiAgICAgICAgcHBwb2Vfc2lkIDEyIFwNCj4g
PiAgICAgICAgcHBwX3Byb3RvIGlwIFwNCj4gPiAgICAgIGFjdGlvbiBkcm9wDQo+ID4NCj4gPk5v
dGUgdGhhdCBvbmx5IFBQUG9FIFNlc3Npb24gaXMgc3VwcG9ydGVkLg0KPiA+DQo+ID5TaWduZWQt
b2ZmLWJ5OiBXb2pjaWVjaCBEcmV3ZWsgPHdvamNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+ID4t
LS0NCj4gPiBpbmNsdWRlL25ldC9mbG93X2Rpc3NlY3Rvci5oIHwgMTEgKysrKysrKysNCj4gPiBu
ZXQvY29yZS9mbG93X2Rpc3NlY3Rvci5jICAgIHwgNTEgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tDQo+ID4gMiBmaWxlcyBjaGFuZ2VkLCA1NiBpbnNlcnRpb25zKCspLCA2IGRl
bGV0aW9ucygtKQ0KPiA+DQo+ID5kaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvZmxvd19kaXNzZWN0
b3IuaCBiL2luY2x1ZGUvbmV0L2Zsb3dfZGlzc2VjdG9yLmggaW5kZXgNCj4gPmE0YzYwNTdjNzA5
Ny4uOGZmNDBjN2MzZjFjIDEwMDY0NA0KPiA+LS0tIGEvaW5jbHVkZS9uZXQvZmxvd19kaXNzZWN0
b3IuaA0KPiA+KysrIGIvaW5jbHVkZS9uZXQvZmxvd19kaXNzZWN0b3IuaA0KPiA+QEAgLTI2MSw2
ICsyNjEsMTYgQEAgc3RydWN0IGZsb3dfZGlzc2VjdG9yX2tleV9udW1fb2ZfdmxhbnMgew0KPiA+
IAl1OCBudW1fb2ZfdmxhbnM7DQo+ID4gfTsNCj4gPg0KPiBbLi5dDQo+ID4rc3RhdGljIGJvb2wg
aXNfcHBwX3Byb3RvX3N1cHBvcnRlZChfX2JlMTYgcHJvdG8pIHsNCj4gPisJc3dpdGNoIChwcm90
bykgew0KPiA+KwljYXNlIGh0b25zKFBQUF9BVCk6DQo+ID4rCWNhc2UgaHRvbnMoUFBQX0lQWCk6
DQo+ID4rCWNhc2UgaHRvbnMoUFBQX1ZKQ19DT01QKToNCj4gPisJY2FzZSBodG9ucyhQUFBfVkpD
X1VOQ09NUCk6DQo+ID4rCWNhc2UgaHRvbnMoUFBQX01QKToNCj4gPisJY2FzZSBodG9ucyhQUFBf
Q09NUEZSQUcpOg0KPiA+KwljYXNlIGh0b25zKFBQUF9DT01QKToNCj4gPisJY2FzZSBodG9ucyhQ
UFBfTVBMU19VQyk6DQo+ID4rCWNhc2UgaHRvbnMoUFBQX01QTFNfTUMpOg0KPiA+KwljYXNlIGh0
b25zKFBQUF9JUENQKToNCj4gPisJY2FzZSBodG9ucyhQUFBfQVRDUCk6DQo+ID4rCWNhc2UgaHRv
bnMoUFBQX0lQWENQKToNCj4gPisJY2FzZSBodG9ucyhQUFBfSVBWNkNQKToNCj4gPisJY2FzZSBo
dG9ucyhQUFBfQ0NQRlJBRyk6DQo+ID4rCWNhc2UgaHRvbnMoUFBQX01QTFNDUCk6DQo+ID4rCWNh
c2UgaHRvbnMoUFBQX0xDUCk6DQo+ID4rCWNhc2UgaHRvbnMoUFBQX1BBUCk6DQo+ID4rCWNhc2Ug
aHRvbnMoUFBQX0xRUik6DQo+ID4rCWNhc2UgaHRvbnMoUFBQX0NIQVApOg0KPiA+KwljYXNlIGh0
b25zKFBQUF9DQkNQKToNCj4gPisJCXJldHVybiB0cnVlOw0KPiA+KwlkZWZhdWx0Og0KPiA+KwkJ
cmV0dXJuIGZhbHNlOw0KPiA+Kwl9DQo+ID4rfQ0KPiA+Kw0KPiBKdXN0IGEgc3VnZ2VzdGlvbiwg
Zm9yIHRoZSBhYm92ZSBjb2RlIHNlZ21lbnQsIHdpbGwgaXQgYmUgbW9yZSBjbGVhbiB0byBjaGFu
Z2UgYXMgdGhlIGZvcm1hdDoNCj4gCXN3aXRjaCAobnRvaHMocHJvdG8pKSB7DQo+IAljYXNlIFBQ
UF9BVDoNCj4gCWNhc2UgUFBQX0lQWDoNCj4gCWNhc2UgUFBQX1ZKQ19DT01QOg0KPiB0aGVuIHlv
dSB3aWxsIG5vdCBuZWVkIHRvIGNhbGwgZnVuY3Rpb24gb2YgaHRvbnMgcmVwZWF0ZWRseS4NCg0K
U3VyZSwgd2lsbCBiZSBpbmNsdWRlZCBpbiBzZWNvbmQgdmVyc2lvbi4NCg0KPiA+IC8qKg0KPiA+
ICAqIF9fc2tiX2Zsb3dfZGlzc2VjdCAtIGV4dHJhY3QgdGhlIGZsb3dfa2V5cyBzdHJ1Y3QgYW5k
IHJldHVybiBpdA0KPiA+ICAqIEBuZXQ6IGFzc29jaWF0ZWQgbmV0d29yayBuYW1lc3BhY2UsIGRl
cml2ZWQgZnJvbSBAc2tiIGlmIE5VTEwgQEAgLQ0KPiA+MTIyMSwxOSArMTI1MCwyOSBAQCBib29s
IF9fc2tiX2Zsb3dfZGlzc2VjdChjb25zdCBzdHJ1Y3QgbmV0ICpuZXQsDQo+ID4gCQl9DQo+ID4N
Cj4gPiAJCW5ob2ZmICs9IFBQUE9FX1NFU19ITEVOOw0KPiA+LQkJc3dpdGNoIChoZHItPnByb3Rv
KSB7DQo+ID4tCQljYXNlIGh0b25zKFBQUF9JUCk6DQo+ID4rCQlpZiAoaGRyLT5wcm90byA9PSBo
dG9ucyhQUFBfSVApKSB7DQo+ID4gCQkJcHJvdG8gPSBodG9ucyhFVEhfUF9JUCk7DQo+ID4gCQkJ
ZmRyZXQgPSBGTE9XX0RJU1NFQ1RfUkVUX1BST1RPX0FHQUlOOw0KPiA+LQkJCWJyZWFrOw0KPiA+
LQkJY2FzZSBodG9ucyhQUFBfSVBWNik6DQo+ID4rCQl9IGVsc2UgaWYgKGhkci0+cHJvdG8gPT0g
aHRvbnMoUFBQX0lQVjYpKSB7DQo+ID4gCQkJcHJvdG8gPSBodG9ucyhFVEhfUF9JUFY2KTsNCj4g
PiAJCQlmZHJldCA9IEZMT1dfRElTU0VDVF9SRVRfUFJPVE9fQUdBSU47DQo+ID4tCQkJYnJlYWs7
DQo+ID4tCQlkZWZhdWx0Og0KPiA+KwkJfSBlbHNlIGlmIChpc19wcHBfcHJvdG9fc3VwcG9ydGVk
KGhkci0+cHJvdG8pKSB7DQo+ID4rCQkJZmRyZXQgPSBGTE9XX0RJU1NFQ1RfUkVUX09VVF9HT09E
Ow0KPiA+KwkJfSBlbHNlIHsNCj4gPiAJCQlmZHJldCA9IEZMT1dfRElTU0VDVF9SRVRfT1VUX0JB
RDsNCj4gPiAJCQlicmVhazsNCj4gPiAJCX0NCj4gPisNCj4gPisJCWlmIChkaXNzZWN0b3JfdXNl
c19rZXkoZmxvd19kaXNzZWN0b3IsDQo+ID4rCQkJCSAgICAgICBGTE9XX0RJU1NFQ1RPUl9LRVlf
UFBQT0UpKSB7DQo+ID4rCQkJc3RydWN0IGZsb3dfZGlzc2VjdG9yX2tleV9wcHBvZSAqa2V5X3Bw
cG9lOw0KPiA+Kw0KPiA+KwkJCWtleV9wcHBvZSA9DQo+ID5za2JfZmxvd19kaXNzZWN0b3JfdGFy
Z2V0KGZsb3dfZGlzc2VjdG9yLA0KPiA+Kw0KPiA+RkxPV19ESVNTRUNUT1JfS0VZX1BQUE9FLA0K
PiA+KwkJCQkJCQkgICAgICB0YXJnZXRfY29udGFpbmVyKTsNCj4gPisJCQlrZXlfcHBwb2UtPnNl
c3Npb25faWQgPSBudG9ocyhoZHItPmhkci5zaWQpOw0KPiA+KwkJCWtleV9wcHBvZS0+cHBwX3By
b3RvID0gaGRyLT5wcm90bzsNCj4gPisJCX0NCj4gPiAJCWJyZWFrOw0KPiA+IAl9DQo+ID4gCWNh
c2UgaHRvbnMoRVRIX1BfVElQQyk6IHsNCj4gPi0tDQo+ID4yLjM1LjENCg0K
