Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C8E4DC48B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 12:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiCQLNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 07:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiCQLM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 07:12:59 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8611DBA89
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647515503; x=1679051503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wknt8febJxk5V3nod0LFzq9Zq/xG4NtQlMtIqmpQNZA=;
  b=CZMx1YPLcJPhdMherRMdQgZOYqzVZMAe8LLY8HRfeQHvrUKaLFe6GI3r
   lG83dpcymG7qtzEz4uaKod00CIsXqhzlqqpxkvxMnW7hdPYtwgncOCRBq
   HKdlvBIzmxnLVoW9Rjdx+FaVwago+56tpduwFPKK/rMNzQ4u/wpgAPLh5
   t048XG7+hFDZBfVqvgt59YembxZeSaRXeYWDxw5BBBPdEJRXin6v+2BZh
   8bpKioE0c2OsW7Up61mBkaevNNGQ+wB273OBzm5ca4+7klgc0jFkT/jdU
   6QbEYxkdkKscJk5cF0kIZFOy4fr1XyqbU7/MjnpOh1doFdOgcHJ3W3Vrq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="281629404"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="281629404"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 04:11:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="599068234"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 17 Mar 2022 04:11:43 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 04:11:42 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 04:11:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 17 Mar 2022 04:11:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 17 Mar 2022 04:11:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtrSGiHdzhbc2PfpJdByCHcjQqf7Fl+YM0r2iS4iEDV7TkSdusdOMZxjUZK/1by+Lm9zvKj+7AFfH79BpwqAt1IGrNKN6mC+x5u0vysNN7W21bCeZzvru9FNvV+35ZCaqVe0UfWr58/f13h72XUrNOhp5NtNMbZbXfJOdLZLlIHdPDRQgaXAfMWvsfV/ja9uvcT/bNB92d8cnlxzAzb6zLaUX4jCP/Y9iiJIPiETQQ41yjd8SOPR8/4npr0pzZkKgIngb1HKziSBH3e1cN4SoLQeVkBCWavCTtOb2Bu7F7jGYNr2waF70pBPDhx61LsYc89M/wWVXSMIkCvyW93S8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wknt8febJxk5V3nod0LFzq9Zq/xG4NtQlMtIqmpQNZA=;
 b=BWkhdBGNYpXlzKIsasTJJCSRx2SHLy4tNwSFmyupG4p/cFBgmR9LUhokXNtHOYF8mobg69tpbr0tne8gqq1OewHSUQYxIUvYzgO1l4OOfadoXh2zg5yqUp/ciYZtACwFcw6bm9M3lRywLCwexv7nD/D7U+CycqY/hN6VdS7apkqfezsHKEyjCvs48Qhn3n7LtzN6bvNIf9whOKOexjS9PnMkx9yJoNdWk2CU8BuKO22D38rQVANecXQjCdTA2GrJYxivv1W0YXi5SdY683tVoF9VB2y4nClIBZrP2I16zg93jkVE5DnkHAJhfYKicTNbOcH8heclg86O4I3Gvtz7AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BN6PR1101MB2114.namprd11.prod.outlook.com (2603:10b6:405:57::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Thu, 17 Mar
 2022 11:11:40 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739%6]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 11:11:40 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Harald Welte <laforge@gnumonks.org>
Subject: RE: [PATCH iproute2-next v5 1/2] ip: GTP support in ip link
Thread-Topic: [PATCH iproute2-next v5 1/2] ip: GTP support in ip link
Thread-Index: AQHYOZnniFoImQzIbEWyeBYJ0JTO86zDa22Q
Date:   Thu, 17 Mar 2022 11:11:40 +0000
Message-ID: <MW4PR11MB57765F252A537045612889E4FD129@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220316110815.46779-1-wojciech.drewek@intel.com>
 <20220316110815.46779-2-wojciech.drewek@intel.com>
 <c1cb87c2-0107-7b0d-966f-b26f44b23d80@gmail.com>
In-Reply-To: <c1cb87c2-0107-7b0d-966f-b26f44b23d80@gmail.com>
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
x-ms-office365-filtering-correlation-id: cab8f125-d83f-4eb1-5b41-08da0806e97f
x-ms-traffictypediagnostic: BN6PR1101MB2114:EE_
x-microsoft-antispam-prvs: <BN6PR1101MB21146C25B9E68289774A1160FD129@BN6PR1101MB2114.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7z53/6JWIpBZ5rcLA0KhFgzIvl/FlRusogGTcZI6BNz021d/unUy91JCJRCVGXj6VpYYiR0IYJ0mXaJWxAdLnkSlTHyddhcHA8r/hnzQjQgctgDEC5frkiqUKi45x1hNXQkw5vV0pXgQ+CTLIo7rtqIxNM8MOafZOxYaS22ikMAWWQmLtNw8nsJS1UvCW6Gos5KB99z9lN9zFFB0JDMBb3uYvKiVRTas4PJgAcfXDjatus+NZq96r7fx3jyWq2CrnmF7aYBAbttup3gO9Nzj6qDGZwaek+vQFOQ/cHwNqQRrE42WYtUtOJL15tVnmRqohDv4Iw6cAhxrAtDlOzIp9Yd+/5gE6YRBYlUlykmwj75TkX3Zs9U5jRnahb/odAzsj4Zw6COXJWBq1j1e7nV10XINHkKNGJAeepgmEF9a+7kCgxxnC1IvADz0vE0BS80UDwpfioBJSZpfqJR/KSs3DbKdp7qXgdppEbpJmPCaJMW5ZBztS9TL+SxYguHsYnOKDrec7YCSf6tUPh0oG+dfMS+TfeWVYrvMmUDMVZMelRovTSTBRKsM8rQLPMCFAh2kwux+I8IJsxWk3jh6Wom8zylCZt1WsusCJJBc/5IRw70nRyyGuDYqxT5JcQapBgX0Ar6o2sJb6DMQFp/bp8f978Xjb1CRKuwtyEk7pk8blAXhy7EZo9GjqWtKejjX+N7Rar1xSSP4t6A3v1cUS+SEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(26005)(186003)(83380400001)(4326008)(82960400001)(38100700002)(122000001)(8936002)(52536014)(5660300002)(4744005)(66946007)(66556008)(64756008)(66446008)(66476007)(55016003)(2906002)(76116006)(508600001)(6506007)(7696005)(53546011)(316002)(9686003)(54906003)(71200400001)(110136005)(86362001)(8676002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2lTY29LdHI5YXhZNk5XMkV2UkVTbVZNaE91UlVPOU85cjhtTDBHOWJnZ3NN?=
 =?utf-8?B?enFJTWswcmxkb1g2czBUck05MTY4WTFMUVFjTmJZRDIwR2VMNU1qZnloaHM4?=
 =?utf-8?B?WWx5WEdLbWZKTE9KY2I1QlllOWJYeGRJQ3JYY00yT3ducDZKMmVOaEduUUdk?=
 =?utf-8?B?aGFxd3R6SmNrWFpKOThiYVB0TzZXRGh1VmNzeGo1QW5ISHYxSWE1SVNWV3cx?=
 =?utf-8?B?bUI5Ui9ibTFiSjdtbmlKcllkNXJSN0lRdkFPY2lKbktkb0NIbktZSU5pWTdQ?=
 =?utf-8?B?ajcvemNYZUFDb0RrWlN3MFhjd0NHZGhzdVM2SUNHdXA1RW5XckcxeXB1QU9n?=
 =?utf-8?B?UjBCUWRiWERmT0dFYVJ6d2tTYmhESXBXalRjZnJLUmNJWVlNS2JPTFRDZllv?=
 =?utf-8?B?WVBDQzMyRzdYQVdoeElaMjlJOHZzZ05lZVpYb2V2VS80WGwvNHc3eHM3RG1K?=
 =?utf-8?B?U0tHQjNKV3RVK1BldkJQOFpoZ1c0alUwV21KL2hQeFFQNlhCa04yYytidzk3?=
 =?utf-8?B?bzgzWmVlQ2M4clZzaE96YXBINFp0M0dqQ3g3N2Nzd1kxVmFMTUlBdEN6SVg0?=
 =?utf-8?B?R0N4dUplZFpHclRicS8wWkNETFltZGFPRGExUjIyN3ZhTGJFRmdMWmpVQS9P?=
 =?utf-8?B?NWdYY1NkRU5FRExtRWZLS3RQeXNmWDdUaXFTcDA0Z3NsOVFLMDMwRi92RTRj?=
 =?utf-8?B?alBkWHc2VWxWN3dNdStPcFlpZ2UyTWZHa256MzZQUGN5V2w4WGwraFdkS29p?=
 =?utf-8?B?VVp3TEJrTTN5WXFrVXAxalhxU2lkY1hvd244VFZxZE1iRHIycVBFVEtBMlIv?=
 =?utf-8?B?TnNpeTdOdUk1c3haV2xPd3lKaHcraFZqYWpFNUxVMDhqMkgrcnh1SmZ6OUF5?=
 =?utf-8?B?SWNnYW1FZlE0bE1naW5jMXczVjFtaUxsL0FQNHJYWElTWG1YRGZCck03dnZC?=
 =?utf-8?B?U0RXY1ZabDFWcmYrVW9GMmdKRTBrOG1xTGlGVm1QcTAvV3VST2V5UENRQjVs?=
 =?utf-8?B?TGVjU0tFTmRPTDVGTHplbHh1VjBxRUlCZUh3cThYWFFrd3BtMWZ2aTdSaHVO?=
 =?utf-8?B?b2tYL1ZpcGdKeUw5OFU3Y0NFTStjNTdlUVYzejBQL3RLZVhSQU84TlMxYVlr?=
 =?utf-8?B?WjFiWFhaL2dQOTJZc0JteGd3eGwyNTNUbmZ0YU1nOUNuSmtoMGlGTFZBT1Z1?=
 =?utf-8?B?dExoL2M4clovYVA0bTJVbXZNKzdlWG5PQjc2RWFzOTVNSEs1bTdEVitXNElS?=
 =?utf-8?B?MTlGbjExaTJXSWhDbUZNTWNPd25SVUFhM012UkZhTWRzM2t4akZibHF5LzJk?=
 =?utf-8?B?NGoyWlh3ZVgzeVBrbWgrT2U0Z2x6WUFMVk54VndQTCtlTndId1hocDhUakh4?=
 =?utf-8?B?N0JObEZQYzhTdG1XK2JCd2lHME9ZdWxRTjdFdjJXVWlRY3dNRUozUGtiNUpR?=
 =?utf-8?B?azlOUVdtQTkwL2p6clg5Slcwb2RPOFlUVDk5a1pLY1dWdXVoT0ZZVTJRQytD?=
 =?utf-8?B?OHF0dzU1MkZDU1pCek1zVDhMVnhBcTdQb0kvSks5cDBhT1UzR3RweTRuZUdX?=
 =?utf-8?B?bjRqWi84Sk12K1NJUnk3UEJLbXpweUZWSFFVeFp3Zkl5bTZsRDNIa25PZTZm?=
 =?utf-8?B?Mys5NEhnT3FQQkdweU5zeW9RZDQxbG9oVktMS2l2R0F4eW9Gd1JMZFlEVW1U?=
 =?utf-8?B?b1EvV3ZFNXJvQ3paYWRWNWRBM3pNSGxCazNRaTIwaUNyQnFLdWRiTktwbFhQ?=
 =?utf-8?B?TWFaZXJwbkljK1BJa3lVaEt0U0JxNlQ0VnVMdHp4ZEVHdlRJYTBGZGh5MzlN?=
 =?utf-8?B?amlaZVNiMHBWci91Q2NPUE1PcTdqSm03VUQzN3RnemN0M2ovV0RMUndaOG0v?=
 =?utf-8?B?WWhCNEVtNmVHa2hCVnk1QnBwQ2JNY1hXY3U2M3FBanFFOURYUFBBWU14VFVQ?=
 =?utf-8?Q?s5C+QT7y1e8nMd5Qrye8ree8cclMgnE6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab8f125-d83f-4eb1-5b41-08da0806e97f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2022 11:11:40.5516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iteUfXR9sASKbV23VMshdAxBMaKbanOsrRgd8GT3wU+UHagKFMwPiqxEqTHRYfARcsGyZ2CE5vecBWc/u7Bmq6ye9tU/Hv7Y+El1arJUy18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2114
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

SGkgRGF2aWQsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQg
QWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBjendhcnRlaywgMTcgbWFyY2EgMjAy
MiAwMTo1Nw0KPiBUbzogRHJld2VrLCBXb2pjaWVjaCA8d29qY2llY2guZHJld2VrQGludGVsLmNv
bT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggaXByb3V0ZTItbmV4dCB2NSAxLzJdIGlwOiBHVFAg
c3VwcG9ydCBpbiBpcCBsaW5rDQo+IA0KPiBPbiAzLzE2LzIyIDU6MDggQU0sIFdvamNpZWNoIERy
ZXdlayB3cm90ZToNCj4gPiArc3RhdGljIHZvaWQgZ3RwX3ByaW50X29wdChzdHJ1Y3QgbGlua191
dGlsICpsdSwgRklMRSAqZiwgc3RydWN0IHJ0YXR0ciAqdGJbXSkNCj4gPiArew0KPiA+ICsNCj4g
PiArCWlmICh0YltJRkxBX0dUUF9ST0xFXSkgew0KPiA+ICsJCV9fdTMyIHJvbGUgPSBydGFfZ2V0
YXR0cl91MzIodGJbSUZMQV9HVFBfUk9MRV0pOw0KPiA+ICsNCj4gPiArCQlwcmludF9zdHJpbmco
UFJJTlRfQU5ZLCAicm9sZSIsICJyb2xlICVzICIsDQo+ID4gKwkJCSAgICAgcm9sZSA9PSBHVFBf
Uk9MRV9TR1NOID8gInNnc24iIDogImdnc24iKTsNCj4gPiArCX0NCj4gDQo+IGFzIGEgdTMyIGRv
ZXMgdGhhdCBtZWFuIG1vcmUgcm9sZXMgbWlnaHQgZ2V0IGFkZGVkPyBTZWVtcyBsaWtlIHRoaXMN
Cj4gc2hvdWxkIGhhdmUgYSBhdHRyIHRvIHN0cmluZyBjb252ZXJ0ZXIgdGhhdCBoYW5kbGVzIGZ1
dHVyZSBhZGRpdGlvbnMuDQoNCkkgdGhpbmsgbm8gbW9yZSByb2xlcyBhcmUgZXhwZWN0ZWQgYnV0
IHdlIGNhbiBhc2sgSGFyYWxkLg0KT2YgY291cnNlIEkgY2FuIHN0aWxsIGltcGxlbWVudCB0aGUg
Y29udmVydGVyIGp1c3QgaW4gY2FzZS4NCg0KUmVnYXJkcywNCldvanRlaw0K
