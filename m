Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDDC4FF43E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiDMJ6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiDMJ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:58:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BD7517C8;
        Wed, 13 Apr 2022 02:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649843787; x=1681379787;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BgoxzHZiX3u0f+VtqBgNiQS3E8memeWl/4vNOQUkhKo=;
  b=JhdyO1/BMpgVKJjJbf0Z4GvuqlKWLFBblGJD9HnQS8jYrey/xNbAV3yQ
   iw06OJtj1LGTyQ8B03Dgp1PmH6IL0quLi/RONbkMJY4bEgfBMzkQyC+7y
   67NOOnUVAhslcC7/f1x8sVJOQZxnxLyBQecoOFGReLAQuoN+QVssr2zF/
   EacoMYFCGfQItUGGyRpgDTmSlDOEoO/dEgyEHauJXMDI9oQTSeSgWV1Hh
   tCv6siABO/ZDFBETZAkzbWtztElDFN4ah/mpjbiw1YmMnkdqYzGEmlxul
   H5/QZAfnjTLQ2W86mxSraZ/SHtoM/BoDYTPLOv0ewpY8S/fuAjphXGCZz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="325531899"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="325531899"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 02:56:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="526882738"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 13 Apr 2022 02:56:26 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Apr 2022 02:56:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Apr 2022 02:56:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Apr 2022 02:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+XwAkDeyJ+/7WxUVSh7hDSiGdK0QJ8E99Fx1XuGghSij4exHCMlpmU+iuRQLrwnV5lxmg0ifyHntFsoil4XHB3cvTZPXe7Fby3SBZ+zztbjIBTIdQcRiG+xNpWq6+/B77OZC8c0BuR6ljquLyLiAWqF6/SjhtU/3+ZWL47Kjj8PTnOGtvpGb4G9JQlPBsVtQRIlAjep/nV3Ja5H1WgtrcbU1ui0737hNvLWT3XLFsnTmO+iGuVaoS//Q1JazfhYRDE4Q63jL2jBrTjYK93Mca7VEElTG/68YeYE9hKP6dYkauWVU+fll3mo7PTi9vC8uilVnOQtj+//OUyLlDkK3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgoxzHZiX3u0f+VtqBgNiQS3E8memeWl/4vNOQUkhKo=;
 b=O54Rf9XFGaMbIWrhOLRerXC3/5dedGkDBMrZv+KTef4P3vXS+Dq9Ohfwa4IMC7g4aWUcQfPGf0oDkih0esNWdNAAzkthZ6+anORR+u14bkRus6p/FpgcSR2Fo/+ZsK9v6TwfTfF4LiOObvbFoAUl7eqXPEMJv9tBh+dd8AV6OtTjLlOIW7RgrIJBDmtorzI9GnSzWOXamoCMGC+/vTQ2STkOxXhYxSE7zgAh/56/KH3YcDt6FP3++FRQ0bXE2tNHd/ZXy3uYtS/Io/QQimbamhrwbQ9+we9Htcpf8uyVOdNz8aQqaCZK3DRzL8vDdbnbU8IAhDAj1293JiC1oHwQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DM5PR1101MB2219.namprd11.prod.outlook.com (2603:10b6:4:4d::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.30; Wed, 13 Apr 2022 09:56:18 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::793c:fcd5:74e:2ef2]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::793c:fcd5:74e:2ef2%8]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 09:56:18 +0000
From:   "Greenman, Gregory" <gregory.greenman@intel.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>
CC:     "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Thread-Topic: [PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Thread-Index: AQHYTbrClJspDTIH1E+7CAw4kZooEKztnfeA
Date:   Wed, 13 Apr 2022 09:56:18 +0000
Message-ID: <afd746404a74657a288a9272bf0c419c027dbd06.camel@intel.com>
References: <20220411154210.1870008-1-linux@roeck-us.net>
In-Reply-To: <20220411154210.1870008-1-linux@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bda4ea02-a57f-401c-c750-08da1d33db26
x-ms-traffictypediagnostic: DM5PR1101MB2219:EE_
x-microsoft-antispam-prvs: <DM5PR1101MB2219B357DE583B3EE7D9DC328BEC9@DM5PR1101MB2219.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cq7Y5JS70iTPHiHrPLSm1qfZYqJSByl1dm69XPcfqkZl1cPVnCJYM6VDlStoTButjwR1axubWa0Y5jL6V+SE9R5A9R5hGepI2oh7NBS3FmmfKnMPgrdwgLtKHo4XBE2W9lB48Yh1jeA5mlvX/LMP6u1ULAn08RTE0WTDEV6ZHI6XPqH5xulFtAYHQplHdBCzysU2MXCnbZ7RYEeAwMtMgM1tdoPFdGb8iVFWg1hNJLlZWAmTCRWk4zwaI41yUnJCfOwYa+EV3DF7+tUFbKFFQDlD5tgXEYnJJQgf0/q6HDkMlBl8voTLKQPBMzwnwDDFYR/38drfdNDay7epTYG2aSUkhDAjtJCSYeNx6zrJW4tXtTUGZBjmxlGvLi3xECZ+KjCBsRDTcgdmIbFPbmmEEcMnOFoh5cdjys7eJur8brsKa/CYZQf5HspGAi2VR2E7rSX8/mhlEGjMn//s28+LZJX8/Fm3u8fDdhhNLBMepjSXNfQufW84HTnEN6eZF6HMcXZen/OBuOeINs6N1mWjoIAphRT/Z0ZmqxzRVm8OC4MhglwCndx2iwKxVPN+yHuiwOUk+i/q5ooxThSJw9ZdbXScEJs+Lgg1pFgM7IC+x/8V/ZSNm7hV3HQDWJK+5UJrp1q5swBPzvH+jwhPNDI6SCiAvGkaTShk7SoISbkodeuaoB9LuRYLNbcFW7J/J7DhIEZLV7Y1oVGMKe4YJDROWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(26005)(6506007)(64756008)(66446008)(66946007)(4326008)(66476007)(66556008)(8676002)(71200400001)(86362001)(5660300002)(508600001)(186003)(38100700002)(6486002)(38070700005)(122000001)(82960400001)(8936002)(2906002)(36756003)(316002)(2616005)(54906003)(6916009)(83380400001)(6512007)(107886003)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1R4ZGxTVlNobEt4eWdTakViQTRjT2RtQSsxVHRjWjlQc3ovcnMrWEhyckhl?=
 =?utf-8?B?N3o3d3B0SWhWUk0yQVVpRmUrdGFycXlKZ2x5Z2o5WGNRZWFvY1pWb1hkdE1O?=
 =?utf-8?B?QW00empkWm53YjlLUktWVUV6clhKN0xMWS9iL3JPWTFGTnFzSloyTTN6eTRP?=
 =?utf-8?B?M1F1aWs1OFhaNmtxaXBIVThpZG5wUXNia2p2cGE4MFg0Z3R3cTFSa3lGSHpu?=
 =?utf-8?B?QW9kLytxVy9Ca2JTREJXaFpSUWZ0VkJqa3UwYjEvaEwwQmFXd0tZSkkzWVR3?=
 =?utf-8?B?dDR6NVVsM2VFcEZsMzFNd05JTmU3Wi80ZGtFRmE3Z2U3K0hob1ZnS2l6RU9o?=
 =?utf-8?B?bk1jd0EyWmRUTDNpZVg0K3p2N1BFMFlncWxyaW1FWmVKWnltOU40Y285STNY?=
 =?utf-8?B?RXduVFMrbXJTdCt2RXc2Z0J6cmc5cmYySjBCSUF4c0k3MXZBeEorUytVMzly?=
 =?utf-8?B?RUQvMU1TMnBDQ1hpTHorelY3cjlKWTFucEtIUXF5dFU1RzVPbFNxNTFHNUw0?=
 =?utf-8?B?ODNDZENaMm90dDc4c285UkJ6bkxtb2h3cHNhSXVmT2pmVkk0MENGZU9mYkJL?=
 =?utf-8?B?RzBQUTN4M1BXMmFHQkVKaFZhV3BncmEwSW1wb1VDYUhPbjlhazdwUWNVYTA5?=
 =?utf-8?B?M2VEY0xRd0NEd0NSSTFEaG0yaGhxc1IvWHZJMlAyNTdZdVMrRGJmSjgyb01O?=
 =?utf-8?B?eGFadC83M3poM0VQblVEN2llWkE3ZnRYTUFMbDVJS2pEUnlaMmd4ZnB0RVkw?=
 =?utf-8?B?aXNQSHBVaHFDSDVzT0picG45NW94VkVGb2U4UUJwOEtCVEswQUdqM3VCUno2?=
 =?utf-8?B?bzkwZFMzSmg4UndsZ3lrTjZLYjFWMDh4MmpnakxkK0JMZGVmS0xLSFNWR2hC?=
 =?utf-8?B?VW81eVZYbDcvYnp0S01HYUNVczJKdGp5L3VoaTRrMGhEaGN5MGx6aWYxWHFY?=
 =?utf-8?B?SWVrQkFETElmVDVTSFpKVktLTktPbm5yRldGVUI1bGMyMXFYdzVxOFRnb2Vw?=
 =?utf-8?B?cTJjVUpxd2dVa3NwU21mNmFBVVVoZHlYV0VDWkNQaDkyOEhlN3BXanJTakxp?=
 =?utf-8?B?YXRxOFFVaGtwWUQ5UFpZcUtFUitvaExjU2FWRU5MeFhRUXFaSmM3Q29OQm9m?=
 =?utf-8?B?eDYwVWxoZDBxVmpBNWNPYXM0dzF1a0dQVGVRMWxoQWZVWHNBOUxOcW0yczJr?=
 =?utf-8?B?RnRCOEVvY1ZIOUZlOWNkOUJqNzcyT1ZVc0V5OWh0YnV3Z1d0QmxaTlJXNXVu?=
 =?utf-8?B?MzUxRTBIcXNkWklTN3hKWlprWHA1TjR0ZjBOc3hDdnZnd0syNEg2S1pCZ25J?=
 =?utf-8?B?OWxnbmdsQnpxYmhmSFhZU1hyYkZBUDg5SU5uZTg0d2R5dTJlbHZWenpIcFRB?=
 =?utf-8?B?bmhGeTBwN0txaTArQmo3YnZENWRaWWIrZGFlNmVORXdtVkM1c0k1dU95RU4r?=
 =?utf-8?B?S2x6Z1lUQ0xtWW5RZllVWS9zNGZ1MjhCRXBMUXZNS3A3cXNBekhaZEFmajBJ?=
 =?utf-8?B?ZGUraWUxWjZ0d0ExeFVwbHBneFJ5QzlDa0FuUXMvYlNKdmFYeEhJaUVCcU93?=
 =?utf-8?B?bTg0TmMwbm4zc2QzRG96bk9lSHY2K2E1ejcrUmFTMGFxUEhYd2dYZG1IZkIy?=
 =?utf-8?B?eFhwUG1VWHo5MkpMZ0ZmK0ZPcllMbkFsKytMSUJXcm9KeVBoSmxjTVZ1L0RH?=
 =?utf-8?B?eS85c0puUkgxaXJ5WCt3YXp0MVh2QmlKaGp6QW5lODdzNFFnWkc1RGZUNURT?=
 =?utf-8?B?VVJpRlVYTXM1eVVGY0V3VlUvaHd4REgyR1FuSFhVclVzMzJVWGlGMVpFZTgr?=
 =?utf-8?B?aXl0N2Fjb25RS05XcFN2YzA1c2I2UGtHSFk0OVFxSC9idHpJVXpDUVdwUk14?=
 =?utf-8?B?TmMzZG02UllSejlLUWpLaEhQZEVvWU5tamNqTUZUejRpSkIzdDIwVVBmc0pt?=
 =?utf-8?B?Qlhvd1VRZ2h6QVg4cEdPSWQ3SEl4NW1QWGJOUjVkZW5RN3BsY1hQdGZnTHkw?=
 =?utf-8?B?bmFCb2Y2SWNWVXJBalZCVjBXSVREZmJudHBnMk1pcUZuOUYyUE1aZjlYL3Ev?=
 =?utf-8?B?V05ReFM4bGY0VUJ4Z3JsbGgxVXJTWTZNeE43U3VxV1IyNTJHOW9iS3htRTU5?=
 =?utf-8?B?NVdLZ2NaUnl2NjYwcmFtQnJzYmJEcnF6bVBIZmNSckhLNk1GeUR0TUpiZHg0?=
 =?utf-8?B?Q3dlN213WjMrQngvZzYwUVNrVi9rU1FuQnU5R2UrdThnd2JMTmp6ZW5ucVQ2?=
 =?utf-8?B?V0JMdkJPQnU1NmFITVFqbDFiTkxMaTBSVnUvU0pBNDlOZThJNU5XOHl1MmpN?=
 =?utf-8?B?T05UZWR5NmZJV2g5K0wwOWpSNTc1M21YS1NYbTRQdCtQT3U3Q3lDTEI0MUtv?=
 =?utf-8?Q?s4Esc5IOcmNhdzm8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36D622762E403E43A96CFD5B4F941F06@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bda4ea02-a57f-401c-c750-08da1d33db26
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 09:56:18.2854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9s08CetCGCcHoX535Kr5Omzy+Ov1p2+oym75jsI1H2QVsTpU4Kl8b1nhJuV5eVRECInNtAWCQIKFOJJi4dR7juIvwEkQ8b/UfnzuhgnEvBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2219
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

DQpPbiBNb24sIDIwMjItMDQtMTEgYXQgMDg6NDIgLTA3MDAsIEd1ZW50ZXIgUm9lY2sgd3JvdGU6
DQo+IEluIENocm9tZSBPUywgYSBsYXJnZSBudW1iZXIgb2YgY3Jhc2hlcyBpcyBvYnNlcnZlZCBk
dWUgdG8gY29ycnVwdGVkDQo+IHRpbWVyDQo+IGxpc3RzLiBTdGV2ZW4gUm9zdGVkdCBwb2ludGVk
IG91dCB0aGF0IHRoaXMgdXN1YWxseSBoYXBwZW5zIHdoZW4gYQ0KPiB0aW1lcg0KPiBpcyBmcmVl
ZCB3aGlsZSBzdGlsbCBhY3RpdmUsIGFuZCB0aGF0IHRoZSBwcm9ibGVtIGlzIG9mdGVuIHRyaWdn
ZXJlZA0KPiBieSBjb2RlIGNhbGxpbmcgZGVsX3RpbWVyKCkgaW5zdGVhZCBvZiBkZWxfdGltZXJf
c3luYygpIGp1c3QgYmVmb3JlDQo+IGZyZWVpbmcuDQo+IA0KPiBTdGV2ZW4gYWxzbyBpZGVudGlm
aWVkIHRoZSBpd2x3aWZpIGRyaXZlciBhcyBvbmUgb2YgdGhlIHBvc3NpYmxlDQo+IGN1bHByaXRz
DQo+IHNpbmNlIGl0IGRvZXMgZXhhY3RseSB0aGF0Lg0KPiANCj4gUmVwb3J0ZWQtYnk6IFN0ZXZl
biBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPg0KPiBDYzogU3RldmVuIFJvc3RlZHQgPHJv
c3RlZHRAZ29vZG1pcy5vcmc+DQo+IENjOiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJnQGlu
dGVsLmNvbT4NCj4gQ2M6IEdyZWdvcnkgR3JlZW5tYW4gPGdyZWdvcnkuZ3JlZW5tYW5AaW50ZWwu
Y29tPg0KPiBGaXhlczogNjBlOGFiZDlkM2U5MSAoIml3bHdpZmk6IGRiZ19pbmk6IGFkZCBwZXJp
b2RpYyB0cmlnZ2VyIG5ldyBBUEkNCj4gc3VwcG9ydCIpDQo+IFNpZ25lZC1vZmYtYnk6IEd1ZW50
ZXIgUm9lY2sgPGxpbnV4QHJvZWNrLXVzLm5ldD4NCj4gLS0tDQo+IHYxIChmcm9tIFJGQyk6DQo+
IMKgwqDCoCBSZW1vdmVkIFNoYWhhciBTIE1hdGl0eWFodSBmcm9tIENjOiBhbmQgYWRkZWQgR3Jl
Z29yeSBHcmVlbm1hbi4NCj4gwqDCoMKgIE5vIGZ1bmN0aW9uYWwgY2hhbmdlLg0KPiANCj4gSSB0
aG91Z2h0IGFib3V0IHRoZSBuZWVkIHRvIGFkZCBhIG11dGV4IHRvIHByb3RlY3QgdGhlIHRpbWVy
IGxpc3QsDQo+IGJ1dA0KPiBJIGNvbnZpbmNlZCBteXNlbGYgdGhhdCBpdCBpcyBub3QgbmVjZXNz
YXJ5IGJlY2F1c2UgdGhlIGNvZGUgYWRkaW5nDQo+IHRoZSB0aW1lciBsaXN0IGFuZCB0aGUgY29k
ZSByZW1vdmluZyBpdCBzaG91bGQgbmV2ZXIgYmUgbmV2ZXINCj4gZXhlY3V0ZWQNCj4gaW4gcGFy
YWxsZWwuDQo+IA0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXdsLWRi
Zy10bHYuYyB8IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVs
ZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9p
d2x3aWZpL2l3bC1kYmctdGx2LmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3
aWZpL2l3bC1kYmctdGx2LmMNCj4gaW5kZXggODY2YTMzZjQ5OTE1Li4zMjM3ZDRiNTI4YjUgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXdsLWRiZy10
bHYuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2l3bC1kYmct
dGx2LmMNCj4gQEAgLTM3MSw3ICszNzEsNyBAQCB2b2lkIGl3bF9kYmdfdGx2X2RlbF90aW1lcnMo
c3RydWN0IGl3bF90cmFucw0KPiAqdHJhbnMpDQo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaXds
X2RiZ190bHZfdGltZXJfbm9kZSAqbm9kZSwgKnRtcDsNCj4gwqANCj4gwqDCoMKgwqDCoMKgwqDC
oGxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShub2RlLCB0bXAsIHRpbWVyX2xpc3QsIGxpc3QpIHsN
Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRlbF90aW1lcigmbm9kZS0+dGltZXIp
Ow0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGVsX3RpbWVyX3N5bmMoJm5vZGUt
PnRpbWVyKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsaXN0X2RlbCgmbm9k
ZS0+bGlzdCk7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKga2ZyZWUobm9kZSk7
DQo+IMKgwqDCoMKgwqDCoMKgwqB9DQoNCkhpIEthbGxlLA0KDQpDYW4geW91IHBsZWFzZSBwaWNr
IGl0IHVwIHRvIHdpcmVsZXNzLWRyaXZlcnMgZm9yIHRoZSBuZXh0IHJjPw0KSXQgaXMgYW4gaW1w
b3J0YW50IGZpeC4NCkx1Y2EgaGFzIGFscmVhZHkgYXNzaWduZWQgaXQgdG8geW91IGluIHBhdGNo
d29yay4NCg0KVGhhbmtzIQ0KDQpBY2tlZC1ieTogR3JlZ29yeSBHcmVlbm1hbiA8Z3JlZ29yeS5n
cmVlbm1hbkBpbnRlbC5jb20+DQo=
