Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56A84930A6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349914AbiARWXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:23:50 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.142.165]:59607 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349928AbiARWXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:23:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1642544623; x=1643149423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lH9LSTh6zZvOZjb3fnj3iQ/y8Dngc9JzbJhYiVBf6i4=;
  b=OZxnknkLeICvMX9JfWmwhAf75ltnEwGq/LpnUp08V5YYw5sxV8o+X0D4
   bT/M+Q3eT6pgR5Ex/+N/BvbagnBycd9bn33O4FO7odG4DhR5HbCXxU3nm
   S+gk/eF1HAdF7WDqn+V8t11kORJg969Ny0DVhUSLKwAVaUmH/SGnwLDV1
   4=;
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 22:23:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtNjCrBQGa4RVIyvOwUE+clvfhvql6rsxFqp7gdr6szynB1tsf1VZ5bOKFQMFdBbB26QanviTHBuuYxHv4ZdRVLpMO9AzG3+WhaHZrpwU9HCnXqTFNvd6BAHLUcf4lwLu0WtW2pmzDArQigfKHaHDxjSKE79IhHewbahsSUDib4uF36Qqz0kEWa91UDrOunxKKHo8Y3/eDTuKrF6T9T0dLIQBeAblr01iHfi74QZFKm9p/rX/yvtSWFJeovobfvhrhuWJF8Hv/C5Ct1fEBH8iRKt5IvD2Qpt/RrneLDr1fmSk3kDrAC6eqf86kDZl4cZwSeb27O5tKOLFL55DR2XPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lH9LSTh6zZvOZjb3fnj3iQ/y8Dngc9JzbJhYiVBf6i4=;
 b=UQzPaj1aCHwfCwGtzsaIQp9ch2EcGohcOXCqgiyV03SXcKlqGsAthxCMtN2UnMyg20PdO5NEyOdjT/+ijqV+lXgXX4eyJxBFstUuJWwogD4bYvBLuOSxsuVjSC1dWbjbT4PLikSr4K4DYhhowRR6lV4HA4LPYBpnxS7OBEosi3ocYNIjKbqdjgILW+SlcyyDep1hTDybbHR85Jdq9z5H/7D/uIN1dOaG/PJHvf2nGhi7MCk8zW6JTV41ukqj9CIsfafWvH4OAVHKeuz9zoSNNUaaBaLaUYA/Dc2oBc34omABmCTzpeCQhKS7z0NiY6qqTr/aT3KZXohUu4MuO74/Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by DM6PR02MB4234.namprd02.prod.outlook.com (2603:10b6:5:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 22:23:36 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::b5e7:2f58:f245:30ec]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::b5e7:2f58:f245:30ec%5]) with mapi id 15.20.4909.007; Tue, 18 Jan 2022
 22:23:36 +0000
From:   Tyler Wear <twear@quicinc.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?utf-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>
CC:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Subject: RE: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Thread-Topic: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Thread-Index: AQHYCBF+ZP8hLSSObUirLFFwasTGhaxgNl8AgAAxUjCAAao8sIAABVgAgADxNgCABj3pAIAAG7CQ
Date:   Tue, 18 Jan 2022 22:23:36 +0000
Message-ID: <BYAPR02MB523881040F40526ED9795993AA589@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20220113000650.514270-1-quic_twear@quicinc.com>
 <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
 <BYAPR02MB523848C2591E467973B5592EAA539@BYAPR02MB5238.namprd02.prod.outlook.com>
 <BYAPR02MB5238AEC23C7287A41C44C307AA549@BYAPR02MB5238.namprd02.prod.outlook.com>
 <CAADnVQJc=qgz47S1OuUBmX5Rb_opZUCADKqzqGnBruxtJONO7Q@mail.gmail.com>
 <CANP3RGfJ2G8P40hN2F=PGDYUc3pm84=SNppHp_J0V+YiDkLM_A@mail.gmail.com>
 <CAADnVQ+5YbkVOHqVGgusGYYYc0sB0uLKNJC+JKZu5Hs07=dgvw@mail.gmail.com>
In-Reply-To: <CAADnVQ+5YbkVOHqVGgusGYYYc0sB0uLKNJC+JKZu5Hs07=dgvw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9df3173d-fd05-4bd7-0ec8-08d9dad12b8d
x-ms-traffictypediagnostic: DM6PR02MB4234:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR02MB42349E99310F8EF560D809B4AA589@DM6PR02MB4234.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wvlSmWiPQCaoRad+VI3RhNINBhKBxq35HFNveJg9rmVZn3z7aupY8WWQ5F7+ECp4aNMklYMlLn9pZapxTAtZfNpQrCCLJp6iSJechgCgbgjZZ6Hudg/UZ+yWA248RAZEfm2v3G0G4DekZqVbWsKhMG9OiHKGUUAJlq8p3JykKwtq5r8k63snRTZ//SvxRcExije9AU9D06HNIA7lGVsT+QITqOXzu2U+f5gq6VDuo20Yv3esamXtAAfT0JQYQ54eEMSSqFuAn3QCVChgZe/WXoMR4ELSEv7RxLaNyKqFmX0mVe0qEkZXyJvY/TEVzQL8S+e8nbxNZ89ue2kSYGN1dMTn9XPwOgsWtmK5MUHSb0EkW6H3nSR7dnXOTid2QtBd/Qlg97G9kr2ma6/ECjH4AqxSXVU1Sa95JE0P+u8rDcc3K2RQ+MnQOdN6ERB+zufnKqab1hIU3ged7nZgR+Xs6ZewdSecffMQ4VG6QwZ1Ca7Rz9mWrb10MW18yfRuS120bmHa6TRR+UPCrbyOO3yj95LmaeI16y/b2i0+i4GQLpvIPwTgxrd00B8MldWX+JJ6nIfGD2uKTQPsSRKsGYn7rbU2RPF12c1oyWg8DsKksNv/c3vc7m8Jl0MB3aUiEr7MWxYTnknYp/Y5ASGT2C9hmi9R3HPfM9G/7A+nRCy7K44iVf+DFDEY7i6CMDRIHPX20y9xM9xQa/1091QxLX9nBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(5660300002)(122000001)(316002)(38070700005)(6506007)(8676002)(7696005)(508600001)(66556008)(8936002)(86362001)(54906003)(110136005)(71200400001)(33656002)(38100700002)(26005)(52536014)(2906002)(53546011)(76116006)(66946007)(66574015)(9686003)(83380400001)(4326008)(55016003)(66476007)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmNZajZTSTh6REc0a3RMTXJRL0ozMERTOVZsVlkrNTd0bFlyU293b25vRTJ0?=
 =?utf-8?B?ZlluMGZVMlcrKzdZdFJqYzhmR3JVV2hIQUt3bTFwNHJ2VTc0b0kwUTcrdG02?=
 =?utf-8?B?NWtCU1VCSEdGYlBRWWlWZzh1TUFKUlJibjN1OWlXWXVHV3F2NkVZSUhnU1FL?=
 =?utf-8?B?M2I1ankvTmJWbm5OUEorVm54RFNFRDlnU2tnN2FRV3pSeEk1dmRrZmxMQXRu?=
 =?utf-8?B?Y1JRUWpobWQ3NDZzeWlMNDZUNkF5STk5OUIwUldHTEx6OFRZdDRmSkE5MjlJ?=
 =?utf-8?B?bFdWcU1hN1Fab1FYWlVyNWZOdlNOTSs1eU0xb3hzdFhXTHptMTNGcXJvTTA2?=
 =?utf-8?B?M1ppN1p3OVRQYlBZNFo4bUpwTDRaamlWYkFxZGsxczFUdmwzVHcyUGZwMGR0?=
 =?utf-8?B?TFhEV1dDbEpHbU9NQnFUWGpkcXdLUExXTTRzeVFRblJ6Z1lvMDY2VGlmdmFt?=
 =?utf-8?B?Vlgyd09vcUlvV0dSTnJ0UWhJcXFvemxDbUk2NUlZaExRU1I1bTZTYlFhVXRO?=
 =?utf-8?B?UCthTXJ1U1JWMHI5NVhGVlZXeTR2VmVoVis2aXc4MnNlcVZpcFZ0RSs4aGR1?=
 =?utf-8?B?ZjF4S2tpa3IyQ1Z6eWw2VkViTmRrUzZybmcrb0ZvdHlaRVp6bVB4N1MxYVdz?=
 =?utf-8?B?Ylliay9EQmZ3dnVoaTIrZHVCVWVQaVdkUng4ZFBTcFJBYTRmSjYwd2dqVVV5?=
 =?utf-8?B?dmpvNWVSclJtM1dzM2FxTGVYbE8yUmxid0hxNldXUk9JZjBEZzVaTTNySGFF?=
 =?utf-8?B?UlE1RkVZdk9ackV5cnVhdGNCY2ljMlVZdDZRTjJrUEJEcHBOSC9lS3Bra1lS?=
 =?utf-8?B?dC9rMTl3cTJxZXlqYUVyTGJROVZxcSsvS2lCSGM3dXZiVldmQmI5MDdXMVps?=
 =?utf-8?B?dTVGVkx4dE16d2tubDFRTWFNSllIcWkrdHlFUXNnS3ZSYm9vYS90WkRjL2ZS?=
 =?utf-8?B?cStBaDY0Q1kyendZWGlKQmJTNk96K0ozRG9XWEtSb1ExSCs2TS9YL0VkOGRw?=
 =?utf-8?B?Q3E1cnlVaGUrWHRvK0lnb1V3OFloR2toRXBRNDFrbTJzRCttdW95QWJBZ3gv?=
 =?utf-8?B?MWc1T3c0ZjVmQ2w2bGQyMmc2RUpTU0RQcnFEcjdoWTBxV1dpR0ZYS0ZwdGNp?=
 =?utf-8?B?WTRBMFlFM1Z0N2orYWtSMjFYZFRzOXNUNDNqZnZoSGxkZWx4alA2RVZhT3Bh?=
 =?utf-8?B?cFJ1K2FkYWNPSTkwTXQrZUNaVjh4N1BmTmZZSmMySUhZYnRIYjk0dTh1QmhS?=
 =?utf-8?B?R0Z4YXlEUk9jdEVTdGVBMHZCbC9mbit4bUM5NmI4YTgrU1AvTUJUbTBEUHVC?=
 =?utf-8?B?aGJ6eGZVWm1YTmcrRks5N01QdnJjVlgyVkU2NnZuaXpqaDJabCt1WHhDQmk5?=
 =?utf-8?B?MWJwWlBZQktmcEVjc2ZhTStXOFM0bktTRkZOZVBVTkF5RklPMGdQL0dtWSsx?=
 =?utf-8?B?c0R6ZjltU1ZIRE8xckEybVNTWXoxalZUa21QTFEwT0dMY1VhTGRBYitERUto?=
 =?utf-8?B?WGJQSjExa2VTWHBZSnh2Y252ZmVqU0loaDVDNEg5L3hEMUZlU0hrYzZnYWRN?=
 =?utf-8?B?K0JUdU1PVTRYajZtWDZ2ZUVVbGhEcldDZWJDSVdBOUV1V1B6SDFiMHhJcEVO?=
 =?utf-8?B?MDB5SEVoODE3WHluU3VIVUNxWE9JZUJXUllKdTBtQ2h1S1ZHMXB5Y3p2dlly?=
 =?utf-8?B?bnNSUGFUZ0NzV1BRdEsrQUUwVGJWaVFlU1pVbDB4UG5JbVFaeHRvU1V0bDJv?=
 =?utf-8?B?cGlFSDBuTFZ2K2dQcmg5M2FIcGNkbGFBSlBBOWZiM3ZCOXYxMnZUbDBGREND?=
 =?utf-8?B?L1JtWFY0emRpZm5rSzg5NTJXNmJudnBRbk9uWEd4SFdtMFZBZzdHU3YxM2I2?=
 =?utf-8?B?UFF5TGIvdU5jSmkrZXZVM2xOaE1DMnA4Smo0a0xKcW9EeU9Sb3NQc1RGOVNH?=
 =?utf-8?B?aEh3bjJ5RmRtaHJUdkpnVkMvckg5TmJ0QTVGdVJ6d0JnRUljSjh4dEFtRE1i?=
 =?utf-8?B?Tm9xMFBTejRxQS9tdjd5Z1F1MEs3TVBiNnJ3eE1JYjdQUjRqdXliamUyTGE4?=
 =?utf-8?B?WVBVUXVxeUMvTzI2cmN2K0JiMndoSjc3UUV2Tkpoellic0lTUHpEb2cwVWlx?=
 =?utf-8?B?ekJ3aTFEM0xUbmMvcmVhQlJJa2lkWEdCQnNoblVsbmNpVjZ1OFMwRHFUUmV3?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df3173d-fd05-4bd7-0ec8-08d9dad12b8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 22:23:36.2070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HFEZpN/9CYypSxewPbcCISnqbZPpa4NMMV1H8PWTKydplvdp8XfZXVbJ7FzlwalsXzP+aUo/J/vE1VUDO6QjMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4234
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleGVpIFN0YXJvdm9p
dG92IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBKYW51
YXJ5IDE4LCAyMDIyIDEyOjM4IFBNDQo+IFRvOiBNYWNpZWogxbtlbmN6eWtvd3NraSA8bWF6ZUBn
b29nbGUuY29tPg0KPiBDYzogVHlsZXIgV2VhciAoUVVJQykgPHF1aWNfdHdlYXJAcXVpY2luYy5j
b20+OyBOZXR3b3JrIERldmVsb3BtZW50DQo+IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgYnBm
IDxicGZAdmdlci5rZXJuZWwub3JnPjsgWW9uZ2hvbmcgU29uZw0KPiA8eWhzQGZiLmNvbT47IE1h
cnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNvbT47IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbg0K
PiA8dG9rZUByZWRoYXQuY29tPjsgRGFuaWVsIEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5l
dD47IFNvbmcgTGl1DQo+IDxzb25nQGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
YnBmLW5leHQgdjYgMS8yXSBBZGQgc2tiX3N0b3JlX2J5dGVzKCkgZm9yDQo+IEJQRl9QUk9HX1RZ
UEVfQ0dST1VQX1NLQg0KPiANCj4gV0FSTklORzogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20g
b3V0c2lkZSBvZiBRdWFsY29tbS4gUGxlYXNlIGJlIHdhcnkNCj4gb2YgYW55IGxpbmtzIG9yIGF0
dGFjaG1lbnRzLCBhbmQgZG8gbm90IGVuYWJsZSBtYWNyb3MuDQo+IA0KPiBPbiBGcmksIEphbiAx
NCwgMjAyMiBhdCAxOjE4IFBNIE1hY2llaiDFu2VuY3p5a293c2tpIDxtYXplQGdvb2dsZS5jb20+
DQo+IHdyb3RlOg0KPiA+DQo+ID4gPiA+ID4gPiBUaGlzIGlzIHdyb25nLg0KPiA+ID4gPiA+ID4g
Q0dST1VQX0lORVRfRUdSRVNTIGJwZiBwcm9nIGNhbm5vdCBhcmJpdHJhcnkgY2hhbmdlIHBhY2tl
dA0KPiBkYXRhLg0KPiA+DQo+ID4gSSBhZ3JlZSB3aXRoIHRoaXMgc2VudGltZW50LCB3aGljaCBp
cyB3aHkgdGhlIG9yaWdpbmFsIHByb3Bvc2FsIHdhcw0KPiA+IHNpbXBseSB0byBhZGQgYSBoZWxw
ZXIgd2hpY2ggaXMgb25seSBjYXBhYmxlIG9mIG1vZGlmeWluZyB0aGUNCj4gPiB0b3MvdGNsYXNz
L2RzY3AgZmllbGQsIGFuZCBub3QgYW55IGFyYml0cmFyeSBieXRlcy4gIChub3RlOiB0aGVyZQ0K
PiA+IGFscmVhZHkgaXMgc3VjaCBhIGhlbHBlciB0byBzZXQgdGhlIEVDTiBjb25nZXN0aW9uIG5v
dGlmaWNhdGlvbiBiaXRzLA0KPiA+IHNvIHRoZXJlJ3Mgc29tZXdoYXQgb2YgYSBwcmVjZWRlbnQp
DQo+IA0KPiBUcnVlLiBicGZfc2tiX2Vjbl9zZXRfY2UoKSBpcyBhdmFpbGFibGUgdG8gY2dfc2ti
IHByb2dzLg0KPiBBbiBhcmJpdHJhcnkgdG9zIHJld3JpdGluZyBoZWxwZXIgd291bGQgc2NyZXcg
aXQgdXAuDQoNClBhdGNoIDEgd2FzIGZvciBhIGRzX2ZpZWxkIGhlbHBlciB0byBtb2RpZnkgdGhl
IHRvcCA2IGJpdHMgb2YgVE9TLCBub3QgYW4gYXJiaXRyYXJ5IHJld3JpdGluZy4NClRoaXMgc2hv
dWxkIHN1ZmZpY2Ugc2luY2UgaXQgZG9lc24ndCBpbnRlcmZlcmUgd2l0aCBDRS4NCg0KDQo=
