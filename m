Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66146635E2
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 00:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbjAIXwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 18:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237341AbjAIXww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 18:52:52 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78122DFCC;
        Mon,  9 Jan 2023 15:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673308371; x=1704844371;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+aLfBni3CSUa29CwIRuVCkmg6A6jYvNGao/19LgPp1Q=;
  b=KdN8GDNf4uuEVeIqZb5I84D/S2Aul7RWNpF4Kg9Ge3R6BHlzstcBalBU
   8Qlg5n3spyJV9XsFySwM37+PWsrSJGyIxPYWWIIHNv+nNc/fJLlHPidgo
   NDHYM+o/5n89XT534Xa6mtK38gHbz1+EuyNw9A9VymXi43Vg9LUCZszWz
   JV8jtEdCRpVKDIIBCdXUOTHJ95vu8pHrEZMCxskwCLA9q9FfeXExzN6/p
   p+cwfmIIOl3Z4s/F2OIAQTX+QsYc50hF3SIvBp0dN+MgJ1VuuTQBPmtvu
   faEY8f0UpuF7jZAZUwEciCBJ2fFeivn2q+fTH/77Lg4lIotLBGbGtkmQm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="302711844"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="302711844"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 15:52:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="764498593"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="764498593"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2023 15:52:50 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 15:52:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 15:52:50 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 15:52:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLARbMoVwnXboLkB0ZnBIh7z1cIpZMGkOu2n4XVScNLBa3x6dNc+uhV3EeDlfAHvpepjEiUoJAqW3CFaos8PCKpNLydtq8iBrR9A0Z+Yp+d9ypZUQ/XfW7RkjZz2dmC+pflQRMfRJ4yi7uaDAiWe64P1b/i3rP16fa8vxFPtrJ+NzH8KzO2O/icAORMTym+S5/kIMSPxTh1Ej+GB/VIxvoYlKVB2Qp1MxxaT5Q4wL2NxMpuJGc6/8xbprwdydDg7woyOpE2tl8jlYVEy8GoGSmrRwRSP09wqM3OtWTuVZ1xbG2T9l1LOVqneUSv2B6tOo1jHF89koemFfgmJdF4Iow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aLfBni3CSUa29CwIRuVCkmg6A6jYvNGao/19LgPp1Q=;
 b=Z8a8Gj+FFGHtxcticH94ClY+bOzN0O6ESt4So0cGEC9NICZ8bDXrMkkEsVZ88DqjbzmQGEyQp2UWrpAQzUzrWs8W/9ZIlEvP/pCuaZX3zPyUX3nbsN6Jw6hvDVWf/H88+sT2nABFuBxvIzmYtsd9zMIkVrfyE0VzRHieIOsuev912rSPDA0f58/xylipkY5k2dAaTsE42PqruwXiDk6ckSzNx0qVYbGuc6Sz3s9pz5ratbodsTzOhdfcmZbCGPxFOot8HfbcAvEf8aTo3Lvd5slN8IchPRtS3hifuao8xO9dFRiEQLpa0ZlZfaLwfGBJOuOFHwh/Pgf2/ii12IQqVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3495.namprd11.prod.outlook.com (2603:10b6:a03:8a::14)
 by BL1PR11MB5237.namprd11.prod.outlook.com (2603:10b6:208:310::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 23:52:43 +0000
Received: from BYAPR11MB3495.namprd11.prod.outlook.com
 ([fe80::9a46:6994:1603:2a2d]) by BYAPR11MB3495.namprd11.prod.outlook.com
 ([fe80::9a46:6994:1603:2a2d%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 23:52:43 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     "sdf@google.com" <sdf@google.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH bpf-next v1] bpf: Remove the unnecessary insn buffer
 comparison
Thread-Topic: [PATCH bpf-next v1] bpf: Remove the unnecessary insn buffer
 comparison
Thread-Index: AQHZI3OD14/WELzGC06pmhJHJUXGMa6WW7kAgABn3BA=
Date:   Mon, 9 Jan 2023 23:52:43 +0000
Message-ID: <BYAPR11MB34954944702CEA4F29A989CCF7FE9@BYAPR11MB3495.namprd11.prod.outlook.com>
References: <20230108151258.96570-1-haiyue.wang@intel.com>
 <Y7xRLsOD1l9FpnC5@google.com>
In-Reply-To: <Y7xRLsOD1l9FpnC5@google.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3495:EE_|BL1PR11MB5237:EE_
x-ms-office365-filtering-correlation-id: f78bd76b-f167-4323-f264-08daf29c99d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 87BODmyD0/P1lQ76+pzTTFNhpQQ9icqD8x7LtsxFcahdsHsK4INqLSkSjZ8GVKw58aW/wPXp0BkYu4hs1gArRRc7CaVv4vF6UBGz65XXqS6bcIrI1XZxW4QmFs/3XrXfIFpi9q3OBYbgyhKnemJMZZiY+NulL97qfon1/hn9wFKNE5RdFNU5bqBJrfdeWQEdgu5803p7D1CD6DBEo/qr06OeSWEOYxXcCznsA9hz2DgNbyFDgebLYEhXx3Odz8nqROvnlUTy/b6x5BD4iIiOsxgm4e1OatwMTGw6ky0hqrG98VovQugdkmBriqCHt5trB/zsqwB+av6gdGHVDH1CKM5ueQLrj52Z6ipKG53W7otVcMS/Ev9zmd6JzL9VqrrHK4UP70vy9BDAJXzR6jRmxwkJEd+x2QNVec8r0n9h+3OlZSbXLCr7k96EMNFq4N/4Jsh6eE/DmGqG+aaUX9hlwLhDGtf5FoFe3Ynndx+aAbeiHds9isjLarBckOgeo6adHFkJJSIsX+drOfP8LKHdhB6nzwigVkcDWQrubg0wBTDKHInXoOWeiRdsnyL6t8xCGLG1YsXplm+hXA0qg0q/sBj4gCZi9EWUcQwMzJ8O0OaT3GYqVsx/yQzrDAyQxBE/OgXROA6tk/I57a/1dEkF0ZJrnnayFTpPJmta/W6vVUvPD3d7d0WC2mqWqXbu3wCz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3495.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(8676002)(76116006)(6916009)(64756008)(316002)(66946007)(66476007)(66556008)(38070700005)(66446008)(4326008)(7696005)(54906003)(2906002)(5660300002)(8936002)(7416002)(71200400001)(41300700001)(52536014)(83380400001)(33656002)(82960400001)(478600001)(6506007)(53546011)(122000001)(38100700002)(9686003)(26005)(86362001)(186003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEQ0eVY2SWpBd2R0S2JMOVZQeUJXYU5VWi9JS05tSkVEVUFMM3MvQWt5TzhG?=
 =?utf-8?B?WjRqUEd6Mk8vanAxYzBSTFdBektGMXBKSG9CbldiNVJqUTF5QmNnZ3I1VGtr?=
 =?utf-8?B?TnhIVmVtdnJ2YzlhV1ExZm5pSGVqQUFhNnRtR21QeXphdkJEY3YwYmFlVC8z?=
 =?utf-8?B?cnJTc0M3WGxEM2xzNEVOM3BYRTRFNlowanEvUVlEQ2FNZHYzOWttS04zeHU5?=
 =?utf-8?B?c1BlN2pGc1JheGxVamdCUzI0am5aRmthUWwzajhiVmwxUkhnZEFrQWw4L3FM?=
 =?utf-8?B?cFVTK3h0S2Z5K2lvb3dReXg4dGNRT2VVUUkzT2NiWS9wU2kzYjBkSDFvSWw5?=
 =?utf-8?B?RXdrWmpqbDc3Z0M5NTJtY0FoUnMrUCtLOEZVcHdGQk9UL2ZaREtEUGFFdnU3?=
 =?utf-8?B?VmhIQVRyY3ZjSjVRODM1QSsvcWZRM3VjZ3U5L3J0VEU4NEsyN3ZTY0FTV2dn?=
 =?utf-8?B?M3YrZkZsT00vZ0RiVS9zbDVsckJPa3J4TjVadDhJcDRpVGVObDRHdUM0aG9F?=
 =?utf-8?B?L0NUS25vS0VqMHFxb3Ewczl2eVoxbkpIRnZ0L0NqNjV3Z0FybkdtTXRjV2di?=
 =?utf-8?B?MHF6Sm9KV2JiTmVGbTFFcmlTTnQ0NzZsdU1lYUlwV1RGRGFjZFZieE9pdnhC?=
 =?utf-8?B?UERhUVMvNC84Y2Z1UHpxeXVrUlVWb3pEZFlER2hQaU5VSWR5T0NjNTNTR3U5?=
 =?utf-8?B?dlpndTU2YXdOYXhybzYrY2xBS0pEL09mVDZsZlAyOWlPKytWeHRJaUErcDFB?=
 =?utf-8?B?a3ZnVy9wbE92ZUMzcGlnMUE4SzBPR1l3a1JVcUZrRjVoVGVQNmpwL1JJZEQ3?=
 =?utf-8?B?SmV2UE01ZlR2QlFQTUgrSElFQ0N4YmJLU1VnbVUzODlqTzcrZVFZQ3cwN2wx?=
 =?utf-8?B?V2hvZzR5OGRzSWFvc2w4RGZDZndQdDZobW1ZQzc2cUVhU0hYdU4xV2s2TDFw?=
 =?utf-8?B?MG9ZWklJY241L283a29adWlPVEVoaTFDMEZieC9acXV5NHRiL0ZOa1NQQmFn?=
 =?utf-8?B?aUNobU8yRjkxdjVUNzF0WlY4WEp3RXVmSi9kcUZ6VTR4aHBXUElSRVF4S2cv?=
 =?utf-8?B?WXJ3dDkva3ViU2dlSmJ5YlpsK3NLbE1QK2lmTkFmcW5aYkwrQmtBS1RmeTlL?=
 =?utf-8?B?aTdtZWxwQ2ZwTXRJNGwrbVl2amFTMU9nTTJSbGtsZGlaUkdMSHZkYUcyNHE1?=
 =?utf-8?B?R3BqaCt4T1krQ2x0WmZGcjdUbG1PU2ZORHF6ZDNCbCs3K1pNMGpyY1QvRnEw?=
 =?utf-8?B?TWZzWCtWcVU3eWdSOFJrRS83cXVLeHcrdExOSUwwb2ZFVVZudm5NTlNjSG52?=
 =?utf-8?B?UUhheUdNRFF6UXRIK09VT0NicjlOODh3RHg2czF5cFlPa01sWkxHQWh5QlNH?=
 =?utf-8?B?M1pDS0FJVUFIM1Rqc3A4RkdjYXBNVVRPNHo5OG8zaXd3T2JYZDN6dVFuS056?=
 =?utf-8?B?WGI4NlAvM2xoTVZENWMwYng2WDJvaTFDeG9UczFrYm1zV3R1Ymc3c1UyQUFE?=
 =?utf-8?B?Y3FIa0FidVUvT0pqM0JoZWNYZGRUMjJzY2RFY0hhM3VsNTVyS3N1K1VVNWpw?=
 =?utf-8?B?ekVCUDMzNXdsc2U0dU81aHBQcXRjZ0wzN2QvUG5laDVSOVgvL3gwLzlteC9B?=
 =?utf-8?B?WmJJSEJ6QnY4WEJaaFFDOXk3clNWeGU0SEpiNXlxL3Uzc3lBVDJaZ2tBeE0x?=
 =?utf-8?B?a3dVK2I0aFF2cTZLNEZtKzZiKzBocUlEeFIzRmxQQm1xRTRRSmpUZCthN2J2?=
 =?utf-8?B?UWtpT3FXaGQvcEZJLzB4QXJJdEpCSDlMKzY2eFNHWTkveCtmcHZVU3NZd3Nt?=
 =?utf-8?B?V0VydU5mQmlTa0pTRXRQY1NmSUJxaWxkejA2SG5vYUZDUm5RVWQ1dnFzMlg0?=
 =?utf-8?B?b0R3dWg5dVVQSHR1NmJ5bmtYc3AwT2ozNDVkWnYyQkZCR2J5K2ZFcUlPSUs5?=
 =?utf-8?B?Nm9VdzRWQzJQZzN1d3RtWG1kYWI2QkZaVHpGNEF5ZFdtOWRRTndBN24vUFN1?=
 =?utf-8?B?NlI5b1B0Nm16SkV1MzkveXhUM3ZmRnQwc1FYRjdSZTdlbnBaN2FpQUdLY21P?=
 =?utf-8?B?S2NDcGEybEs5dHNQaUNNR1VIRHZiVVVTeDg0blVoTHJxSk91ekRHM2UyQ3JD?=
 =?utf-8?Q?/zPiOByL2qs/Y15HMxyDvfCRt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3495.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78bd76b-f167-4323-f264-08daf29c99d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 23:52:43.5214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BFgeR6fpyA4a3VmDbEc2RMIwvDsg9ezEOUHM2iaBwiM1HHJUxEoh1Kp/iIAcTyxj5vKpfMn9SvTgPrErBjYHyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5237
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBzZGZAZ29vZ2xlLmNvbSA8c2Rm
QGdvb2dsZS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgMTAsIDIwMjMgMDE6MzkNCj4g
VG86IFdhbmcsIEhhaXl1ZSA8aGFpeXVlLndhbmdAaW50ZWwuY29tPg0KPiBDYzogYnBmQHZnZXIu
a2VybmVsLm9yZzsgQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz47IERhbmllbCBC
b3JrbWFubiA8ZGFuaWVsQGlvZ2VhcmJveC5uZXQ+Ow0KPiBBbmRyaWkgTmFrcnlpa28gPGFuZHJp
aUBrZXJuZWwub3JnPjsgTWFydGluIEthRmFpIExhdSA8bWFydGluLmxhdUBsaW51eC5kZXY+OyBT
b25nIExpdQ0KPiA8c29uZ0BrZXJuZWwub3JnPjsgWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT47
IEpvaG4gRmFzdGFiZW5kIDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+OyBLUCBTaW5naA0KPiA8
a3BzaW5naEBrZXJuZWwub3JnPjsgSGFvIEx1byA8aGFvbHVvQGdvb2dsZS5jb20+OyBKaXJpIE9s
c2EgPGpvbHNhQGtlcm5lbC5vcmc+OyBEYXZpZCBTLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8NCj4gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBSZTogW1BBVENIIGJwZi1uZXh0IHYxXSBicGY6IFJlbW92ZSB0aGUgdW5uZWNlc3Nh
cnkgaW5zbiBidWZmZXIgY29tcGFyaXNvbg0KPiANCj4gT24gMDEvMDgsIEhhaXl1ZSBXYW5nIHdy
b3RlOg0KPiA+IFRoZSB2YXJpYWJsZSAnaW5zbicgaXMgaW5pdGlhbGl6ZWQgdG8gJ2luc25fYnVm
JyB3aXRob3V0IGJlaW5nIGNoYW5nZWQsDQo+ID4gb25seSBzb21lIGhlbHBlciBtYWNyb3MgYXJl
IGRlZmluZWQsIHNvIHRoZSBpbnNuIGJ1ZmZlciBjb21wYXJpc29uIGlzDQo+ID4gdW5uZWNlc3Nh
cnksIGp1c3QgcmVtb3ZlIGl0Lg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBIYWl5dWUgV2FuZyA8
aGFpeXVlLndhbmdAaW50ZWwuY29tPg0KPiANCj4gQWNrZWQtYnk6IFN0YW5pc2xhdiBGb21pY2hl
diA8c2RmQGdvb2dsZS5jb20+DQo+IA0KPiBMb29rcyBsaWtlIHRoZXNlIHNob3VsZCBoYXZlIGJl
ZW4gcmVtb3ZlZCBhcyBwYXJ0IG9mIGNvbW1pdCAyMzc3YjgxZGU1MjcNCj4gKCJicGY6IHNwbGl0
IHNoYXJlZCBicGZfdGNwX3NvY2sgYW5kIGJwZl9zb2NrX29wcyBpbXBsZW1lbnRhdGlvbiIpLg0K
PiANCg0KVGhhbmtzIGZvciB0aGUgaW5mb3JtYXRpb24sIHllcywgaXQgd2FzIG1pc3NlZC4gOy0p
DQoNCj4gPiAtLS0NCj4gPiAgIG5ldC9jb3JlL2ZpbHRlci5jIHwgNiAtLS0tLS0NCj4gPiAgIDEg
ZmlsZSBjaGFuZ2VkLCA2IGRlbGV0aW9ucygtKQ0KPiANCg0KDQo+ID4gLS0NCj4gPiAyLjM5LjAN
Cg0K
