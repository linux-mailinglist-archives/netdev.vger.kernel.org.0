Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5555F3F24A0
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 04:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbhHTCKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 22:10:44 -0400
Received: from esa17.fujitsucc.c3s2.iphmx.com ([216.71.158.34]:8839 "EHLO
        esa17.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234768AbhHTCKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 22:10:43 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2021 22:10:42 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1629425406; x=1660961406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cH7k4KOJB5rGnvD4pz+iWD6pi1irWA+ccxdzIkorXdg=;
  b=cxRgeSHHpV0Z2o/q0qi3/79oDUUzbikoME81I9SVhO8ctYSJ6axNSs8v
   ZZo3NIzMoK5l8D94DId1PCZ6myE+HXIDalMSgPM87R1jKeOdzdXoerBSf
   sXgKh2x76NNhG+2CmPaW8sHL5tESI9h5fG1SQoOc2AjjNr+5+LHo0zFQv
   uMzQQsJWiMVfBzbz0pRq+3s5znQx2USAw/pHo61vvawEN4ALFCmRkuXn1
   LusZaxYKQN/JXxAHT0ZhYu+J7w2hZhRmLeRxIhhlXNirTyE/Og41GCWsf
   UOjPpLcZRDbrzV4DGq6W+Sbyqsb3ec0lhIkH1fA0x5M2u0qoIFlnOSEDC
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="36996323"
X-IronPort-AV: E=Sophos;i="5.84,336,1620658800"; 
   d="scan'208";a="36996323"
Received: from mail-os2jpn01lp2055.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.55])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2021 11:02:50 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQFUNtDcHbXZQX1FolL5dFuK4CqnPqQKJsAPNMBT/txEfoQdrnQImsvIuoeYR8SamWBbKlriIkZxFslc68EIiJeKh5tyXeVdJzBTFY/el9Sn3W139JbTCiF/QvACUtEOF1PGaNec0TsEnGGl24HekLSrYBy7vvcGQENVD6h3qTzznsjfWPyAkUUJjze/YC+84PZQOggRFkp295fgpDwC9WcsBJAfLhM6cMGk1QztEml58h0bnJGv+OiUSIRqHKEwFLoZrOvF7plkRhbOa2x+Pe8auaMuc+Y00QQDVKkJZPDjaGvR/lVBjDUPzv7+Gq4gqNObFq/o8YjMSY4Vmgpvrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cH7k4KOJB5rGnvD4pz+iWD6pi1irWA+ccxdzIkorXdg=;
 b=mVRr/gbev0L94nChrN82subx6F5Fv6EG5Uq5UH2iRKUtyoIFlGRMsrZRzJZlnQYrzizc8hMpbUOBktWru4EwhZ3v7T7B7GMAXJelFyQwD5/kQqU44hBkqLUIiYXhbc3EtT3+ub4CFcm4fnxUGv1iDzQT+66l1xv0PKV1SG7rGWGZ3GdcX0K1ksRIuQotQ7l7R5N/NgqjBsIXTMiDBYkfz2z8FxJEk2y+TaX2TsG8bCfX6BHTyBZI09Dvpkh3w2QXLYa5jxtiv9Isbr1HfJPWrDA8q00dFo7NiBfz56q0KE72gvn/41i1Lvhp8U921tCUyJ7wX+ZzFJIVxcQH+7LbRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cH7k4KOJB5rGnvD4pz+iWD6pi1irWA+ccxdzIkorXdg=;
 b=GWidDYSSpsN2sIq4jzMuCI/b45ax64yGK4gezDm1i2TKumap63aocfAFFkQKH+THbnA5ZhRAij1eHWQOivfGg/YScT9+DBc1AQx3TAXdpvrk/HDvFv/UkvYemD5zrOACbZeATwaADqzTm3T2+sckOkUg7q6EWVAnWHQBKLgC07I=
Received: from OS3PR01MB7650.jpnprd01.prod.outlook.com (2603:1096:604:14f::5)
 by OS3PR01MB7552.jpnprd01.prod.outlook.com (2603:1096:604:14e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Fri, 20 Aug
 2021 02:02:47 +0000
Received: from OS3PR01MB7650.jpnprd01.prod.outlook.com
 ([fe80::d0b3:dccf:a218:f634]) by OS3PR01MB7650.jpnprd01.prod.outlook.com
 ([fe80::d0b3:dccf:a218:f634%6]) with mapi id 15.20.4415.024; Fri, 20 Aug 2021
 02:02:47 +0000
From:   "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To:     Song Liu <song@kernel.org>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
CC:     Shuah Khan <shuah@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "philip.li@intel.com" <philip.li@intel.com>,
        "yifeix.zhu@intel.com" <yifeix.zhu@intel.com>
Subject: Re: [PATCH 3/3] selftests/bpf: add missing files required by
 test_bpftool.sh for installing
Thread-Topic: [PATCH 3/3] selftests/bpf: add missing files required by
 test_bpftool.sh for installing
Thread-Index: AQHXlMuccLHKS6H320Of32bdLC3kO6t7ZioAgAA+pYA=
Date:   Fri, 20 Aug 2021 02:02:47 +0000
Message-ID: <f4324c85-8ac8-458f-01a0-04081e954510@fujitsu.com>
References: <20210819072431.21966-1-lizhijian@cn.fujitsu.com>
 <20210819072431.21966-3-lizhijian@cn.fujitsu.com>
 <CAPhsuW5J2dg+aiwbQC28YZkEYEstcCQKP7fY9e4i=OPuMMsSTQ@mail.gmail.com>
In-Reply-To: <CAPhsuW5J2dg+aiwbQC28YZkEYEstcCQKP7fY9e4i=OPuMMsSTQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e82f1b7-0ec3-4b3a-df11-08d9637e9b7a
x-ms-traffictypediagnostic: OS3PR01MB7552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB75526C74C3F282A535732FE9A5C19@OS3PR01MB7552.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o3anLDfo5VgBM9MFjNHNFrpuza3LYkmtxhoabmlWyYtE7CcUHEC0LEQjkTw6hb47bxzcFR9fggwCj4Ee1VVQC4hh1nL+FV7lOjJozd2YsWieMUyATTJ0nYIzGasf0xvNeZWtbOmN998rKlMwa1M+TWZDUoXUolBlx+4/ewDcTqAClgv6vxPZVhbYfyi+eEbwqQL8vJRM2e1gC3p8KBOgmK6PlcGKDjMp75wgY7rn5LcOT266yvSujKDR3V4uv+KELhQI3zU6Z1ZQIMuzBvJD34/dCj3klK6OnEwzWbYRYn3Y4aLGXIQJnpTmINmBHdVoOG2MQYwf69ucmRAtf6JnK/zudRO6XCG/64iaH37BBqDYCBT4KoiuWUUc7m8JyoN16+gLJmw/gMikekIhlDUeDxnXE5XlxGGIDvVqO2NG1sWap3yKd8HInBOWntsT5QesxcPr2Ezmjy5fESVKa2wGnkQwj7Orh5IhA3ilRlp9dvG1Tdlu4AICpcPSdtOBR1eduyIwF8NJTQ4z96myGdNQ4UZCyLY1U08gRl8xaMJ9hvY1vpY419b9HnlHsVwCn/sWNZRM/nwQu4kWMjKPmd7VL5YBTNrSNFteDiIfU58t7U9SEreq49O3rrGj16dN1z1wwoSJUs+EaElabSQDTFus6/8tnUGfCkRB9iWzHf631woR+1ZrlTw4IJhOFVcHwhURCbvLinjL1M30sGiaJaQ7enFkzoet8De6Jbx5HZjzj3pRg+e6hxVEAU9x6cZk6BQ42STobIHInMN8gdLdSId9hQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB7650.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(122000001)(86362001)(4326008)(26005)(38100700002)(54906003)(2616005)(2906002)(66476007)(66556008)(66946007)(316002)(186003)(85182001)(76116006)(64756008)(66446008)(110136005)(91956017)(83380400001)(31696002)(7416002)(6486002)(8676002)(36756003)(8936002)(6512007)(53546011)(508600001)(38070700005)(31686004)(71200400001)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjRRN3JteHRNNGF2R3dyL1ZZaVhqVkpzWnlnK3lFK0Z4WWgvbU9zTm9vN3ZX?=
 =?utf-8?B?TXE2bHZLdnFhdk9QRVc5NGl2N3BUVUFRTW5lVzQ0WGRFNFAycm50RTIybEli?=
 =?utf-8?B?UDVLZlJzNTZ1SkMyaEpTckliSXF1bTRvUmRmVGQ1ZmdjT3d4V202TXpxcktK?=
 =?utf-8?B?VjEvOURDZGlFS1VScFpsWHRuc005UDYzRlZERG85WllpbTA5VERZMFdpSE5h?=
 =?utf-8?B?cXplU2tFNEd3d2dpcktwR0U1dVJMRUlnL2dudXlQZXNZR0FsMjRxbjJndXUv?=
 =?utf-8?B?TWNQblk1Q3hJNUlqZk9lb0kwWnBKbU5XcUhPS2UweW9UUTdhaGhpWGdKbW1F?=
 =?utf-8?B?b09oUWIvcDlQODl0WlNSOTVDTFk1SzhZQnNQMHIyN0p1cjlTWTB6bmVCQW9V?=
 =?utf-8?B?ZGg0elJzZWI0eEltSzY4N2VEMUZFZW1Hd1JDL29oYnJHVTRkVDd6VnM2UEk4?=
 =?utf-8?B?YzhlYTVBYzg0RTJBWUhVMklVYmJhWktDcDhYbjVFZ2pvTHdJcFY3WGpaRGZ5?=
 =?utf-8?B?MXRJNmRLTUJDaUpNZzZ2VXpKTkR0aEFLR2lpMHBWelc1RTVRNS9kVGpRU3Jw?=
 =?utf-8?B?cDdEN29tZUNjTzA2OEpDZjBTbHIvc0FoWUtydW1PSHZJeWxPalJ1NlRtcitZ?=
 =?utf-8?B?bE14VHoxK05DTU1QNjZXbkVTQTBneDlxN3poTDlWd085NkdlMnVQOHJpcHRu?=
 =?utf-8?B?VDhMMTUzVS8yVXd0dC9MTXk2RTJtZDV6MmsvRkdlenBOTkNIOXd1Q2tCVVF5?=
 =?utf-8?B?QmFBOHJodm5vamtYTVZuK2dONk9ZK1h2UGp5bTM3UHdmdkwrUGN0WllWcXEy?=
 =?utf-8?B?cnhLVFpNc01uNjN1dmszc3lOTGpBTXUyZU5walJ1Ym1BdkMzT3dWbjhValhw?=
 =?utf-8?B?dHA1bGhPN1FGQ0hZQ2JCNUowSGJWdkNGRHdxMlBNTkx5VHV6OWcxYkl2ejNt?=
 =?utf-8?B?OUt3TXp0d2xZU0pGY3hkdFpmK1Y2RXgrbzVsNmRVT1lWTTBtNXNCdFovSGE5?=
 =?utf-8?B?YzJKd2hEV2QzYlJ3emI1Wjl2QWQvYSs3V3FSM0plK3dKaVptZmlzY09PMjhu?=
 =?utf-8?B?US9QR0ZtMHJYS3BaZUJOWEZCcU5YbFIwM1FoM2lOdDJmTGNDZnRSZWlxc3p6?=
 =?utf-8?B?ZmV2bjRHR3pOUU9ENlByYWdIS1FmanhyNzlFcWZpTEdBNVdNVWNaV0NjVnlS?=
 =?utf-8?B?eVJqaVBsQ3lhSHVGRDl6dVlYVmgxYXBKTlpNUGpLV05BR1JxM04vRW8zUmty?=
 =?utf-8?B?YjZIbXNmVFV2RVMrMWJCUk9TOW9xbEt6cldhZXNIcE5YaG5LNCt6S21xOW1S?=
 =?utf-8?B?Uit2OEZiMUtYV200THhOV0I5L2p3b3h0L0ZXNmFTSlNNNkgvT1lZcTVGMnA4?=
 =?utf-8?B?SUVtSW1ZTk51TjEwOVZsLzZXOTMyMEtRVitvNjYycGpFcFE2VVBYa1FUdG8z?=
 =?utf-8?B?MnJtdnF5UzJROXV1S0FpVVB2Z0hoam1OR1R6S3prUkU1bjZKMkt0TFRDeWpJ?=
 =?utf-8?B?aG12L3ZTL2txVktwWklKUmlzVHN3UWhqS0RkRnFUZEFBdy9Gb1FVRHBoVHFL?=
 =?utf-8?B?L3dmOHZpa1lnM2hFM0dDYTRIeDBUYi9CQ0xNTFJ1Q2NHSVluQkx6K3ZXVVlZ?=
 =?utf-8?B?TzM4VzBncngzZkJGd1Q0eWpwZGZISlpoWU5UT2FWVDlJRGVXTmdPVDVkeDBR?=
 =?utf-8?B?UjVMOWppOGdBN1BKR2dyUkt2Vk00ZTlBL0Z3NDZoUFZCUUg5M2NMT2Z1S2pI?=
 =?utf-8?B?anlvd1hFYng5eTVSV1BmaDhYS1JMUUxhMlN5eEhwVzE2SmpnMGk4K1VlSmJK?=
 =?utf-8?B?K3h2eXhvdG8yVHlHeGJXdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DDB8D1357F9074B9E4260726D48AB1C@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB7650.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e82f1b7-0ec3-4b3a-df11-08d9637e9b7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 02:02:47.3861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +x/rsIMGDtPklDq04OKnrIbMSMKy+XXW7KgmVFpfasBhI4OBJ0UyIIvF5eVwpkp2yDQoBub3MFdFvGr7Lg3/1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB7552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwLzA4LzIwMjEgMDY6MTYsIFNvbmcgTGl1IHdyb3RlOg0KPiBPbiBUaHUsIEF1ZyAx
OSwgMjAyMSBhdCAxMjoyOCBBTSBMaSBaaGlqaWFuIDxsaXpoaWppYW5AY24uZnVqaXRzdS5jb20+
IHdyb3RlOg0KPj4gLSAnbWFrZSBpbnN0YWxsJyB3aWxsIGluc3RhbGwgYnBmdG9vbCB0byBJTlNU
QUxMX1BBVEgvYnBmL2JwZnRvb2wNCj4+IC0gYWRkIElOU1RBTExfUEFUSC9icGYgdG8gUEFUSA0K
Pj4NCj4+IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBjbi5mdWppdHN1LmNv
bT4NCj4gQWNrZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+DQo+DQo+IFdp
dGggb25lIG5pdCBiZWxvdzoNCnRoYW5rcyBmb3IgeW91ciByZXZpZXcsIGkganVzdCBzdWJtaXQg
YSBWMiB0byBmaXggaXQgYW5kDQoNCkNoYW5nZS1sb2c6DQpWMjoNCi0gZm9sZGVkIHByZXZpb3Vz
IHNpbWlsYXIgc3RhbmRhbG9uZSBwYXRjaCB0byBbMS81XSwgYW5kIGFkZCBhY2tlZCB0YWfCoCBm
cm9tIFNvbmcgTGl1DQotIGFkZCBhY2tlZCB0YWcgdG8gWzIvNV0sIFszLzVdIGZyb20gU29uZyBM
aXUNCi0gWzQvNV06IG1vdmUgdGVzdF9icGZ0b29sLnB5IHRvIFRFU1RfUFJPR1NfRVhURU5ERUQs
IGZpbGVzIGluIFRFU1RfR0VOX1BST0dTX0VYVEVOREVEDQphcmUgZ2VuZXJhdGVkIGJ5IG1ha2Uu
IE90aGVyd2lzZSwgaXQgd2lsbCBicmVhayBvdXQtb2YtdHJlZSBpbnN0YWxsOg0KJ21ha2UgTz0v
a3NlbGZ0ZXN0LWJ1aWxkIFNLSVBfVEFSR0VUUz0gVj0xIC1DIHRvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzIGluc3RhbGwgSU5TVEFMTF9QQVRIPS9rc2VsZnRlc3QtaW5zdGFsbCcNCi0gWzUvNV06IG5l
dyBwYXRjaA0KDQpQbGVhc2UgdGFrZSBhIGxvb2suDQoNCg0KVGhhbmtzDQpaaGlqaWFuDQoNCg0K
DQo+DQo+PiAtLS0NCj4+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL01ha2VmaWxlICAg
ICAgICB8IDQgKysrLQ0KPj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9icGZ0
b29sLnNoIHwgMyArKy0NCj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi9NYWtlZmlsZSBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9NYWtlZmlsZQ0KPj4g
aW5kZXggZjQwNWIyMGMxZTZjLi5jNmNhMWI4ZTMzZDUgMTAwNjQ0DQo+PiAtLS0gYS90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvTWFrZWZpbGUNCj4+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2JwZi9NYWtlZmlsZQ0KPj4gQEAgLTg1LDcgKzg1LDcgQEAgVEVTVF9QUk9HU19FWFRF
TkRFRCA6PSB3aXRoX2FkZHIuc2ggXA0KPj4gICBURVNUX0dFTl9QUk9HU19FWFRFTkRFRCA9IHRl
c3Rfc29ja19hZGRyIHRlc3Rfc2tiX2Nncm91cF9pZF91c2VyIFwNCj4+ICAgICAgICAgIGZsb3df
ZGlzc2VjdG9yX2xvYWQgdGVzdF9mbG93X2Rpc3NlY3RvciB0ZXN0X3RjcF9jaGVja19zeW5jb29r
aWVfdXNlciBcDQo+PiAgICAgICAgICB0ZXN0X2xpcmNfbW9kZTJfdXNlciB4ZHBpbmcgdGVzdF9j
cHAgcnVucXNsb3dlciBiZW5jaCBicGZfdGVzdG1vZC5rbyBcDQo+PiAtICAgICAgIHhkcHhjZWl2
ZXIgeGRwX3JlZGlyZWN0X211bHRpDQo+PiArICAgICAgIHhkcHhjZWl2ZXIgeGRwX3JlZGlyZWN0
X211bHRpIHRlc3RfYnBmdG9vbC5weQ0KPj4NCj4+ICAgVEVTVF9DVVNUT01fUFJPR1MgPSAkKE9V
VFBVVCkvdXJhbmRvbV9yZWFkDQo+Pg0KPj4gQEAgLTE4Nyw2ICsxODcsOCBAQCAkKE9VVFBVVCkv
cnVucXNsb3dlcjogJChCUEZPQkopIHwgJChERUZBVUxUX0JQRlRPT0wpDQo+PiAgICAgICAgICAg
ICAgICAgICAgICBCUEZPQko9JChCUEZPQkopIEJQRl9JTkNMVURFPSQoSU5DTFVERV9ESVIpICYm
ICAgICAgXA0KPj4gICAgICAgICAgICAgICAgICAgICAgY3AgJChTQ1JBVENIX0RJUikvcnVucXNs
b3dlciAkQA0KPj4NCj4+ICtURVNUX0dFTl9QUk9HU19FWFRFTkRFRCArPSAkKERFRkFVTFRfQlBG
VE9PTCkNCj4+ICsNCj4+ICAgJChURVNUX0dFTl9QUk9HUykgJChURVNUX0dFTl9QUk9HU19FWFRF
TkRFRCk6ICQoT1VUUFVUKS90ZXN0X3N0dWIubyAkKEJQRk9CSikNCj4+DQo+PiAgICQoT1VUUFVU
KS90ZXN0X2Rldl9jZ3JvdXA6IGNncm91cF9oZWxwZXJzLmMNCj4+IGRpZmYgLS1naXQgYS90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9icGZ0b29sLnNoIGIvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Rlc3RfYnBmdG9vbC5zaA0KPj4gaW5kZXggNmI3YmExOWJlMWQwLi41MGNm
OWQzNjQ1ZDIgMTAwNzU1DQo+PiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVz
dF9icGZ0b29sLnNoDQo+PiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9i
cGZ0b29sLnNoDQo+PiBAQCAtMiw5ICsyLDEwIEBADQo+PiAgICMgU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IEdQTC0yLjANCj4+ICAgIyBDb3B5cmlnaHQgKGMpIDIwMjAgU1VTRSBMTEMuDQo+Pg0K
Pj4gKyMgJ21ha2UgLUMgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmIGluc3RhbGwnIHdpbGwg
aW5zdGFsbCB0byBTQ1JJUFRfUEFUSA0KPiBuaXQ6IFNob3VsZCBiZSBTQ1JJUFRfRElSLiAgICAg
ICAgICAgICAgXl5eXl4NCj4NCj4+ICAgU0NSSVBUX0RJUj0kKGRpcm5hbWUgJChyZWFscGF0aCAk
MCkpDQo+Pg0KPj4gICAjICdtYWtlIC1DIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZicgd2ls
bCBpbnN0YWxsIHRvIEJQRlRPT0xfSU5TVEFMTF9QQVRIDQo+PiAgIEJQRlRPT0xfSU5TVEFMTF9Q
QVRIPSIkU0NSSVBUX0RJUiIvdG9vbHMvc2Jpbg0KPj4gLWV4cG9ydCBQQVRIPSRCUEZUT09MX0lO
U1RBTExfUEFUSDokUEFUSA0KPj4gK2V4cG9ydCBQQVRIPSRTQ1JJUFRfRElSOiRCUEZUT09MX0lO
U1RBTExfUEFUSDokUEFUSA0KPj4gICBweXRob24zIC1tIHVuaXR0ZXN0IC12IHRlc3RfYnBmdG9v
bC5UZXN0QnBmdG9vbA0KPj4gLS0NCj4+IDIuMzIuMA0KPj4NCj4+DQo+Pg0KPg0K
