Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19515F2D07
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiJCJTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiJCJT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:19:29 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E61B2937C
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664788768; x=1696324768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qQ0FZMxa92Bggvh9Bc8ddV6Vah6Zo36MdlUwSkRE6Qw=;
  b=NFNlTnj//YBWmVHABNQT5keA1d0F1MWdzFE4UrmGRCg1xfeqS/CuifIK
   ytyUmOXxO2GGHwF7sdmGm43PbDGmn9kFxVtIVMLOBcd3KeMKxoLLR7SGp
   vChdRmRxabBJ4cYPIhM6N4M75Ip9v7pI15349HckMFgcCyLThFrobw0tH
   ywgduS8eN4yyZxI6y/tGSQGCSuujlxglXOz8OeuVc630LfFEWdnZcDlmv
   3OGm+4CzReDsNSvYRRMvWVaU9HrgQnjjkL+/FiGRSTBtu2q4hxhFCb6Xn
   R22rSiKV3lFKkDFN2lAop10xOZ2GVEZPIOLfUj3AGhHC5PI5q1V1CVu1h
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="303493256"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="303493256"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 02:19:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="952269846"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="952269846"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 03 Oct 2022 02:19:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 02:19:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 02:19:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 02:19:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fq2Xi8ibreKpVIpvc5lIx3APNdeb2PFEibcgwSER8RM58In28HT0BXuCjIGJbTns/J9D5Qt4FVzeGJGe7mwlxIoPEOEFYkMWBJj6KnOr0i9N8Il6hCeeKWtYQv0fLpGaMdf7KydITiBL9SbfeHe/Q6+YjVaU1wX428x15AQEt8JDBilm5tT4iN2JQe4l/SiAFcONYbDiLTpEGwoNV8itT2vr9vMyBfExTUAweTamjfB53p0TiaXPHfG1pHgErmErMm11lS8/HHDI5+XqbfBWUij40g+RiYxKDzczWxcpKHnrB2duxXETNK9KtX+u4PyahceQEVdqxgll3EgTafdUnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQ0FZMxa92Bggvh9Bc8ddV6Vah6Zo36MdlUwSkRE6Qw=;
 b=QcodepM1DcbwKWIZ9lPBIyt2uJ+DgUKCGBqzOo33GuBbxyn7BMpYRodMW4MXehY1yR5lBqOWGn0Y+hFzH7/1b6Xq26b8DpAdkYXAK8CKvp0WJqNFeWf0OlxVsSWbugk0FpaI9UBX/V6Nr406Z46xijNYkL0//ivDMbUQk2sMz6hLQ5uCVZFmH2vbQvYjge12l01xPKXe/higEaN4hCdt/3Ez/0AQuF6VW2iCZgYEHoPyWoFTEA3GWdnjNb5m3MPi+YaEW/pqT53a64pj80/c6PJXxBICd93bOjwvHMvZHJaPV8lLaDDNZtcDy1f1PLLjuHvwhbou63C//KXHGc3sUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DS7PR11MB6128.namprd11.prod.outlook.com (2603:10b6:8:9c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.28; Mon, 3 Oct 2022 09:19:25 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::e951:548d:f636:1367]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::e951:548d:f636:1367%7]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 09:19:25 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "gnault@redhat.com" <gnault@redhat.com>
Subject: RE: [PATCH iproute2-next 3/3] f_flower: Introduce L2TPv3 support
Thread-Topic: [PATCH iproute2-next 3/3] f_flower: Introduce L2TPv3 support
Thread-Index: AQHY1rF2nZXC2dtZI0eEA2zK+EY+ZK38Xp8Q
Date:   Mon, 3 Oct 2022 09:19:25 +0000
Message-ID: <MW4PR11MB57769E48533C7CC9BCD453B0FD5B9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220927082318.289252-1-wojciech.drewek@intel.com>
 <20220927082318.289252-4-wojciech.drewek@intel.com>
 <06112b64-39c5-0dee-b419-872e94263457@gmail.com>
In-Reply-To: <06112b64-39c5-0dee-b419-872e94263457@gmail.com>
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
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|DS7PR11MB6128:EE_
x-ms-office365-filtering-correlation-id: cf2bdb2d-9d78-446a-277e-08daa5205d87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: csCdgAJfnP0T63ZKwZhOFOfYsorfzwso3UsJGaDXeljq4bUKb02q0OwONjTPOAbjaERK/AMfYZYxqHxRoGOs1ZUPqLPmXYZBT0QXRhglUBm4t/Yd3AnKw8mAWI/R72YmgpTe9XPBLbndF4U3OJyWSgYglLoti056hQwC9ZG/iCEAG7Nq+GYFA7l1yqJHRZm+e4e46Q8SWcdjRIW8gVSY1mGCQfuQJAuiUFzlMcO63BnNwX08uv77L4eITf4KEydBFlO2mgP8pkwGbMqn2TTTa1tTpADreirIl9VX23+qYorwqm7RtdwffryheEG2y+CwVS+5HClE6uBR1nST6hbiJ01GVBkqadCdzgSNiZu/wHl/s1je8wy5O1zmR9jExuXc14WhnmFuK4MGClXvDPOEPeuSw+/sARULGPpx5k7dgk6dKoO8iMQugeSgM4hTdZo/q8QQdF+o4b6fZtZ9U2VWZH2niEQVy7l5LSBbhm57823UbxODOfehpPQk2qSqG9e6CbbSdtJjpGCPVl/idBAuKRNKIXTiPZorwsAbjaVDBjHNMglOFPYmVy0ITSAjt6chLsac4eA7OC7/pWSJ7fenr9DRN/Uol6c+5YPQNWDL5Ekt/Tzi7zjRpw+O4qwHB3BlkZZhvAbck6bzn2rY0QZClleRVbY96xISPneSYGshs1LzG+QIRKSizhvubYRJ2/tD7xEhZJLSxElUJBqqblM8fLLs9XuvzClJQj5rT3ldFcGsNh4l1MebjW30WMY5NMmp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(55016003)(33656002)(86362001)(9686003)(26005)(53546011)(7696005)(6506007)(82960400001)(71200400001)(478600001)(186003)(54906003)(2906002)(83380400001)(110136005)(316002)(41300700001)(5660300002)(8936002)(52536014)(38070700005)(38100700002)(66946007)(4326008)(64756008)(66446008)(122000001)(66556008)(8676002)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U29PUVd3RHAwSWFSZjNYNDJWSlN4UmxFYk1vc05VSHlKd2IwU0J5QVQydlZt?=
 =?utf-8?B?WUN1eTlpQVJTZmRTN2hCeUJMUWxBSlZOL3owSzZFc0t5dWg0TUFNSTM3L1Vj?=
 =?utf-8?B?MC9XVjU4M0NNWll2WXRKaXAxdW02SDlqdUQ2NVpxL3BFUExMMktYV0h0NFBT?=
 =?utf-8?B?dW5lR1oyWEZYaEtrbllwN3B4K3VTc3ZJdHMxZVNXQnI1eWZhV2ptYU1iZFEx?=
 =?utf-8?B?OTIrUnZmbmRmWlQvUlZFU2dNNmsxR05IeHhyYVJCL216Y012YUE3MkFIbjdp?=
 =?utf-8?B?MXBmb3Ftb1BYLzlROWFHRTZNeUxnL0hVRW40UTV0UXc3ZndRVlN0SitkR0tN?=
 =?utf-8?B?QXlNZHE4bU9KOW8xeXpwZXR6L2VBcjh6clgxWlF2T3gveG05TUFmUGl4dmpP?=
 =?utf-8?B?dm1YNEluUWR0TE1sSzNldlcxbTQreVFvcnBKSHVJTklyUDRLMzkyaDFSN0x0?=
 =?utf-8?B?THFQb0ZBWE9mVzA0a2FoblZQbTl4cUZRcWxrZ0xjbVFvN1ZIdEtPN1hBUkxl?=
 =?utf-8?B?S0Yvc3I0QkFUenh6TUZJb3BVZWovbTgyTmwyd01oc2dWaGFIQW9xazBOVDJ1?=
 =?utf-8?B?UHlSR3VFNzlBNlUycEpPT256bFV6cFVXbUI0Y2V4TE1TZWxGYy95VlpNbG9O?=
 =?utf-8?B?MGJWbVVodmxMYnNLMkVCMkowb1R6WStSVTU4dHV6bjgwb1ZQYmdrZUF0cVBu?=
 =?utf-8?B?cU90MHI3Q2VkZVZLd3I3YzI1akpRS1JiKzhnQzBTSGJNNGtMVXBwdFpMd0FU?=
 =?utf-8?B?a2xvWGlJKzlSZlNLSEZmS3pMaER5TGdCR1BsQmZmdTFIenJIMmNxNWNGa1g1?=
 =?utf-8?B?dVdFSjdXclM3VDBOcVZJNlRRTHZCWG1scWpRQTRyNExIVVM3Tm9kYlYyT24z?=
 =?utf-8?B?YmZUM2ZVZzZDUGFrTkVDRVVhV3ViTGFPOEtZRm8rU1ZHWHAyZFpRNU5hQko4?=
 =?utf-8?B?K09OZnlCaHdBVkNWWWMyVlFJUmNhNjQraGo2dkRzQVNxRnNhd0JaVWdGclgw?=
 =?utf-8?B?cnZhTysyNkl5OEdVeERZSEFLUmF3VHhQYm9NbS9VOENmcWpzMkowaWRUaFVL?=
 =?utf-8?B?NjdGY1kvVXFvWFZSNGtENjVML0I2VmI0TVJpT2NiTmM3OWdXajZPL0JBbENB?=
 =?utf-8?B?dTNvSEpKYVcxRjJ4M0FGWVh1USt1YnUzTjFEZHNTUUtGR09ab2UwMG1Rc3hV?=
 =?utf-8?B?RjlKY2s2bXVycHF3dG1GdnZXRHVtRHFJWFNEb3YvRkVodTl3NFg1ZFRLMm1H?=
 =?utf-8?B?YzJtUUNHa0xKUlBzbnNPbjRMSFMxcGZXTlhNWUlpeVJOdy9seHk5QUpUYm9n?=
 =?utf-8?B?VUpPUWxMSDJuM1d5SUl6bE9zZHp1Y3NmdGFWS2lTUHhFVXJSdU9ma3ZFVzlF?=
 =?utf-8?B?Y2lqMFR5T1pyVTVMdVh4Mm43UFJjc1hTcERZd3h2Z01zeWpYc1ZYVFZzemZE?=
 =?utf-8?B?YVdJanB5SnZwNGFxTXhucTVjUFZMdDBKUEFEMEdqNUlzdFdlQmgyTnBpRnRV?=
 =?utf-8?B?TXJYOTdJYytXZVcvb05KQWlkdlBhcnA3dEdFTkE5UUFPNGxVcUp3RXdVek1K?=
 =?utf-8?B?NlN0ZE1hbDBuWW9vL0xKRTBlZmx4cnNjQU9BZUk3THBaMVJ3aDBuRXpUdVRp?=
 =?utf-8?B?THRIZm1EWUxidytzMUZsQVVFV0lyOGJqN0RhYURaVit0Z2E3YzN3ejB3UWR6?=
 =?utf-8?B?OE5iTkpwdzB6QThhWUMxWTVFdHgyZzVjZE5ieElDM2p4STUzOUY3R2FBQ2Iy?=
 =?utf-8?B?bE4yV1FiaDNoaFNjdGNYYlg2emFjMVVIUW9Gc1M1cC9EK2UxUmdkUkpIc1FL?=
 =?utf-8?B?UGd6M1Iwenhid1Z5T2RxRDZyaWdaZGlUdUtva0I2bE1uZitPdGtEWlQwaWpy?=
 =?utf-8?B?bkdJd3VPcEltbmVGVVZOdHJmbjJzZkZOOHpNV1VueWpCMFhrOExvdjQyT3o4?=
 =?utf-8?B?QzR4RjdXRVZQQ2IzaERDWnZycHdsQndhRzFKZUNzbUptNUd5dWRQdEZTU2l6?=
 =?utf-8?B?RUZ2VHNBOS9ySnJOYzRhR0pLY3BBYXU2c0oxeEZZeFB6QjN3clNPYXpKSHYx?=
 =?utf-8?B?Q1NVUlEzTm1ZMUcrYTlLaFcvMU9Ec1hqb29pekJVNGZiU0M3UTNycFVzdy9T?=
 =?utf-8?Q?yixh4lsvVSkjKpOc7oEAXcxJj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2bdb2d-9d78-446a-277e-08daa5205d87
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 09:19:25.2396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rwPqDtOWeH1BqmxVhWmY0x40fddx3t0jJrqyRCWFMOSysilSVSMqHh7G89xjz/proMOmuf7u3T8f12qgTJIIU2gaeT5ZZDSryK9ScgxK6K0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6128
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRz
YWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBwb25pZWR6aWHFgmVrLCAzIHBhxbpkemllcm5pa2Eg
MjAyMiAwMDo1MQ0KPiBUbzogRHJld2VrLCBXb2pjaWVjaCA8d29qY2llY2guZHJld2VrQGludGVs
LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHN0ZXBoZW5AbmV0d29ya3BsdW1i
ZXIub3JnOyBnbmF1bHRAcmVkaGF0LmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGlwcm91dGUy
LW5leHQgMy8zXSBmX2Zsb3dlcjogSW50cm9kdWNlIEwyVFB2MyBzdXBwb3J0DQo+IA0KPiBPbiA5
LzI3LzIyIDE6MjMgQU0sIFdvamNpZWNoIERyZXdlayB3cm90ZToNCj4gPiBBZGQgc3VwcG9ydCBm
b3IgbWF0Y2hpbmcgb24gTDJUUHYzIHNlc3Npb24gSUQuDQo+ID4gU2Vzc2lvbiBJRCBjYW4gYmUg
c3BlY2lmaWVkIG9ubHkgd2hlbiBpcCBwcm90byB3YXMNCj4gPiBzZXQgdG8gSVBQUk9UT19MMlRQ
Lg0KPiA+DQo+ID4gTDJUUHYzIG1pZ2h0IGJlIHRyYW5zcG9ydGVkIG92ZXIgSVAgb3Igb3ZlciBV
RFAsDQo+ID4gdGhpcyBpbXBsZW1lbnRhdGlvbiBpcyBvbmx5IGFib3V0IEwyVFB2MyBvdmVyIElQ
Lg0KPiA+IElQdjYgaXMgYWxzbyBzdXBwb3J0ZWQsIGluIHRoaXMgY2FzZSBuZXh0IGhlYWRlcg0K
PiA+IGlzIHNldCB0byBJUFBST1RPX0wyVFAuDQo+ID4NCj4gPiBFeGFtcGxlIGZpbHRlcjoNCj4g
PiAgICMgdGMgZmlsdGVyIGFkZCBkZXYgZXRoMCBpbmdyZXNzIHByaW8gMSBwcm90b2NvbCBpcCBc
DQo+ID4gICAgICAgZmxvd2VyIFwNCj4gPiAgICAgICAgIGlwX3Byb3RvIGwydHAgXA0KPiA+ICAg
ICAgICAgbDJ0cHYzX3NpZCAxMjM0IFwNCj4gPiAgICAgICAgIHNraXBfc3cgXA0KPiA+ICAgICAg
IGFjdGlvbiBkcm9wDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXb2pjaWVjaCBEcmV3ZWsgPHdv
amNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIG1hbi9tYW44L3RjLWZsb3dl
ci44IHwgMTEgKysrKysrKysrLS0NCj4gPiAgdGMvZl9mbG93ZXIuYyAgICAgICAgfCA0NSArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICAyIGZpbGVzIGNo
YW5nZWQsIDUzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4NCj4gDQo+IA0KPiBJ
IHVwZGF0ZWQga2VybmVsIGhlYWRlcnMgdG8gbGF0ZXN0IG5ldC1uZXh0IHRyZWUuICh1YXBpIGhl
YWRlcnMgYXJlDQo+IHN5bmNoZWQgdmlhIGEgc2NyaXB0LikgVGhpcyBwYXRjaCBvbiB0b3Agb2Yg
dGhhdCBkb2VzIG5vdCBjb21waWxlLCBzbw0KPiBzb21ldGhpbmcgaXMgbWlzc2luZy4gUGxlYXNl
IHRha2UgYSBsb29rIGFuZCByZS1zZW5kLg0KDQpPaywgdGhlIGlzc3VlIGlzIHRoYXQgSVBQUk9U
T19MMlRQIGlzIHVuZGVjbGFyZWQgYW5kIEknbSBub3Qgc3VyZSBob3cgdG8gcmVzb2x2ZSB0aGlz
Lg0KSSd2ZSBtb3ZlZCBJUFBST1RPX0wyVFAgdG8gaW4uaCBmaWxlIGJ1dCB3aGlsZSBidWlsZGlu
Zywgc3lzdGVtIGZpbGUgaXMgaW5jbHVkZWQNCigvdXNyL2luY2x1ZGUvbmV0aW5ldC9pbi5oKSBu
b3QgdGhlIHByb2plY3Qgb25lIChpcHJvdXRlMi1uZXh0L2luY2x1ZGUvdWFwaS9saW51eC9pbi5o
KS4NCkkgZ3Vlc3MgdGhlIHdvcmthcm91bmQgd291bGQgYmUgdG8gZGVmaW5lIGl0IGluIGZfZmxv
d2VyLmMgbGlrZSB0aGlzOg0KI2lmbmRlZiBJUFBST1RPX0wyVFANCiNkZWZpbmUgSVBQUk9UT19M
MlRQIDExNQ0KI2VuZGlmDQpJIHNhdyBzaW1pbGFyIHNvbHV0aW9uIGluIGNhc2Ugb2YgSVBQUk9U
T19NUFRDUC4NCg0KTGV0IG1lIGtub3cgaWYgaXQgd29ya3MgZm9yIHlvdS4NCg0KUmVnYXJkcywN
CldvanRlaw0K
