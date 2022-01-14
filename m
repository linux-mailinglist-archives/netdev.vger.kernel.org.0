Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA8B48E467
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbiANGto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:49:44 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.142.165]:21919 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiANGtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:49:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1642142983; x=1642747783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q2zBgNYy0t/Y3f73VDcTjXYT9qjKYpHX7vv0w1tnY8Y=;
  b=d1+5iEped2iSk++zq7BtwSHy4iZQKvoqPbXGH6MmACeuLHt0wi4MLzdd
   rciKCoIp/LjW6RxY4fk+FqQ+iA2t+ayu7DHUvM71EDMS8hp8kktmn9e9I
   eENRT61+u5AASkt8sEtFuiYzeXzaNtVFh3oKygKe4il8pGz63DDQyNU85
   g=;
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 06:49:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWlerL1Z6D5X2i5J0pSBVvxPY+4Pn+UFweJzpJvp+ElXzAfe3gp1LPp+qN+/OR2McNdaLIPPKpJjB52NGfyoZk3IOTo/7YJUqmdxJsenFBuKBqWsttxd91kt2EV+3YkNvGs3sW8RvXT9LhiQsVHvII64Iwquc5EA8f2Xb0DNcipRZzQj1eOvnthdYcK72Yjg4b/DIIX5m14BFge3M23gZvJqCcp6uuQMUakZwJuAkp/C0LPsvLoxDmCvF5YzVdTm2GF8av3pNfLgpDAzqfjjxE/uirunBK3q3zcG1L++asi5u6FK8jXrzcpQlMdaV3u2qTfi83B7SWz9hru1ev4mfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2zBgNYy0t/Y3f73VDcTjXYT9qjKYpHX7vv0w1tnY8Y=;
 b=b9+qEtObmGNxL4e0p41Jea+n5OYJM4CEnhxhCmUGLTdBzviJ80wtuW8qO44ZodWbW+OZPLal5xz5fPIdchXwyEDqrDMtd1pYpcbwSV3fjCC0IAZ5Q0CAtYxUMy0TeO063O5S9ZwVcmA/d+k/isfsG4PPbtKzVmQHchiSO8z2hFwbXh+z3eSmYw8v1+LBTLsUhP99PHSHIjUqKgnylEocI73d8fx69L5NlPGRzsaDPI+cqhXt8sdk8VE4/qvHEudxkg0+5KAH5ScPjsQIQVrsdKy6+tcEb2PGAFVUyjUtVKYahGp05lT4p7AxLuX4Uhu/RZFs8fvpLKPqb7nxX+LNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by CH2PR02MB6247.namprd02.prod.outlook.com (2603:10b6:610:7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 14 Jan
 2022 06:49:38 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07%6]) with mapi id 15.20.4867.012; Fri, 14 Jan 2022
 06:49:38 +0000
From:   "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?utf-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Subject: RE: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Thread-Topic: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Thread-Index: AQHYCBF+ZP8hLSSObUirLFFwasTGhaxgNl8AgAAxUjCAAao8sA==
Date:   Fri, 14 Jan 2022 06:49:38 +0000
Message-ID: <BYAPR02MB5238AEC23C7287A41C44C307AA549@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20220113000650.514270-1-quic_twear@quicinc.com>
 <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
 <BYAPR02MB523848C2591E467973B5592EAA539@BYAPR02MB5238.namprd02.prod.outlook.com>
In-Reply-To: <BYAPR02MB523848C2591E467973B5592EAA539@BYAPR02MB5238.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43a16880-7806-4b60-f6be-08d9d72a08c0
x-ms-traffictypediagnostic: CH2PR02MB6247:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <CH2PR02MB6247E7F701AB882BE5D149ACFB549@CH2PR02MB6247.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZAD9bJy5f5ZXlJEa64PX2j8oxH3FGm9bRZbyGX+IeJXGJ1bXMh5dhHJPGwv+EfZC2m8Jz0RQu7/vi06A3zZWxLti726GRt/l3FFtuyHUaMy43Vy42MWBP6W57WlVyxKEUA7jppJU7Qx4FlIN7VKVMrwGZZALcQmVoMtsp8UsFD7k7jaczmy9p8uIv/OOEKw9v7D11myfGfXv1ccKv5OQ6sK4P2vf97z2L8S3CnIvd5CMTG53TW+y8ymFCt304PqPtAn6kOw3sbiVcJ4yK/W7/p0TcXdPeieJfatB1JxJvlVdW7c6YYEX+RPGRzptCOWj4FqSsKuyeGgIJjlyQEw7ePz4V8oaJgU6nE4X4lV12W1L5hC+yHJezMd0y27gNGqDtMhceZi3r7yfONbiFuoaWe6c4KFB+K6znBE+ww/y8pcWrlxufg5fzAY5KjS73K++H6QNt1FuKiYqWdP71GISowA4119l2E7esQu1QuOtLC43PuJziAisIM5f2XfEhiNmkNdNC+xhW4mlrd3VS74VN+N82hlFFdFEQzNh/x/F2QfrlUF7fLucyWt2Pnc63VxouD/b/J0MkB/xPHXsANR2ZE9uWXiW5DYkic8RpJRxNsOBGNyvcGmAjjro7s7kEVvmRYrDM2MIWqjQ7sIjBMeJmwsrtdC/4pKg+RCWBN2z2lE0CIDRxp6grWxgXYE3+iLn2Tfp+TtClJ1R0q+mlbrc2KktRwEv08QFUj/B6A51IXpCkodU6N5c13iI87HY/wP5jq2/0WHEvkjgWhZfPV1U95BGJOa1rjUJ4dhXrOhxN0A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(64756008)(4326008)(66556008)(66476007)(76116006)(66946007)(122000001)(66446008)(5660300002)(316002)(38100700002)(966005)(71200400001)(38070700005)(9686003)(186003)(508600001)(52536014)(53546011)(2906002)(55016003)(8676002)(6506007)(8936002)(66574015)(7696005)(83380400001)(26005)(110136005)(33656002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnlwdmdvU1Fsd2RKVVFVZGg2SjYxSHB2RHE1MGhydXBqWTJpckszb2x6Mm9i?=
 =?utf-8?B?SVNyaDZ3b3VXdFhab0J2THBIRlNwUVJoL0hGWDRhR0ZkeSt4Uy9Td2k2eGta?=
 =?utf-8?B?Ui8yb0hSWS8zN2lTSDdhd2tZeXo4cGU1a2VXR1JzK0FqUzQxd2NkY2NzcWNk?=
 =?utf-8?B?N1k0akE5L2JkbWxyeFJ0SHdtMlMzVFI3SG9CVjllRm5BMFRFeXJmSnZSVGhY?=
 =?utf-8?B?dXdrOHBRczlTY2pWOVI5RUU3b0I2ZWlzVzZIZUlxRmVpK000c2o4TmxEb1NZ?=
 =?utf-8?B?YlhqdTFCaFVFYzNmTVFpVHFPVGN2N1IwZzViK3kxaC9sbDVHcWxVbGRPZzVV?=
 =?utf-8?B?ZE91WnJmLzNXQWsrdkZ1dWY1T1U5Y2lKazZOZnZCMG4xYUg3ZkpSUzU4Y1hk?=
 =?utf-8?B?dGpMS2MzN0VYOTlualRRaUJFYXE1c0k2cy9UUEJreWNUSTBXenIySUVYejk2?=
 =?utf-8?B?YnhQWGZCWDFidzdzaGhaajNoRzdLdDhlUmdqUTZXZElYMkVvcGVsU08zMzhI?=
 =?utf-8?B?Ukg2ZlFaU3FoRFVuVTRVVVNlUFZnd2xUWXR5UVpOQmk4MG1OMFE4MWd1cnBS?=
 =?utf-8?B?ZHlDRnBIbU5vNHhqTEZnV2dIajZyYi9FNTdheFplSTE2ZG9mUkpiZWdOL3FI?=
 =?utf-8?B?Sk54UTNPa3lsb2g3YStzV3JmbUdXZG40MU9SOE5XNERnL1ZOMXRsdytXbGFI?=
 =?utf-8?B?UUtuYVl4ZzJrQXU0dnlHU3dubUpxSWVlODkxcXlPLzFEazBxNG1xelRiL0FO?=
 =?utf-8?B?THptZlVWWkRJcG83VTQxSFVsNlNuTnVQa1NHL2N0UDh6eWl6clNIdTBuUktz?=
 =?utf-8?B?ZVZxbVZTUDliSTlRS2l2aVpWZjdMYVN6WGJ0MW5ORk9HOFYwbVUwMmttMy91?=
 =?utf-8?B?a0F1T1BWdWJ0ajhhUjUyUkQva0JmNWRpZHpOakVpYVJidHZ0U2RBMXBnZDY5?=
 =?utf-8?B?VWk4eStmRjVlbS9uME5Gb28xczl4TENMbHhhN0JNVGlFRkNvcCtKa3pZcEZy?=
 =?utf-8?B?eUQrbTUvdC91MUpUSzdGZUNrYjVOYWJzbUI0ek9iaDJ2N2pIRkdaU01vS0xM?=
 =?utf-8?B?eGk4OGdNZmM4TlNpSGprcTFZVWtLelpxTGhEN0s1dlV6WnJnQklGaHJsWnk1?=
 =?utf-8?B?VndoY1FlYUJVRXFpbGZ0RW02WHhGRDVZTzZCQTlYQ3MwdUFzdG5zc3N5RVJV?=
 =?utf-8?B?VHlQL0lxTG1VeGlqOXh3TUZocEZRbHlXM1g0aForZEpOMzgwNktENnArczFJ?=
 =?utf-8?B?OGlwaThhOFlTanMxdk1GSnYrbmhQWW9JWUlrajBmZUh1cjB2TWRsRDRRR01I?=
 =?utf-8?B?VTl0Q1kwY0lETmF3NVhZejFKcWEzZmNtQ1FMZHM1MHlwNVFsKzQ5bENBNDB6?=
 =?utf-8?B?MGl4NGJaZEtISTVDTW9lQUIvSzFpYVRUVEx4N0lqOFREUGhhVTNnK0FaajY4?=
 =?utf-8?B?clJQekN5R3RjT3hhY0ZVbW9aVmF6RHlKUytLU1o0akRFTWRDMVRIVGtndDlw?=
 =?utf-8?B?SzZZYlBpaHArSVFDbmh6QW5xRU81Z2JqY2RGcFN2VGNUUkFVMThXRkhWcTIw?=
 =?utf-8?B?S1JCREFWMTdzYkQ2YkpweVJPQXZPaHhiS0k4Sm5IR2VIT3AzZVhRdHNuUjNx?=
 =?utf-8?B?SFM5NU5RaXlNaDdjREQxQzBFWEJmdmtiRlNQb1RVRzlzK01ScXJMQ2Q2UjNm?=
 =?utf-8?B?NEFGaFV3aW92MXIxTnZyMS85N2VhMWNiU3JvTzNzWlVkMDBQM0swblFoVXZt?=
 =?utf-8?B?dDg5THZpZ0R1bzlHd3FIbXdmdFZrRkNNTEhRQ2Q2clVob0hDZkF2cWZXTkx6?=
 =?utf-8?B?bCtIMkRadmoydHd1N0ZGQmFhL3lOam1Gc1RiQWd0MzVjSkJQcDhjUHJGYnor?=
 =?utf-8?B?MFVaQXJQTEJBOUFYbFNsdXBCb3VhejNvelVST0ViQWdidExPeHdlK0p5cVNR?=
 =?utf-8?B?MWFLQ2tLc1FQQVArOXNlcytaL0ZZK0ovekh6SlhhakxCMXBadjZ3cTVIbTZP?=
 =?utf-8?B?aHREVzdFVlJ1V1gzWExsM1hYNDd5Q2xVODhqV2k3UCtBczZHQk9iSHNOUW5W?=
 =?utf-8?B?VlB4bUxBV2srNG5ZWTRPaUlRdGN5MWxIMWNKNEZwd1lDUS9HUzBQTGtIWGJV?=
 =?utf-8?B?dHJ3Y1AyWFpHbXM2ZVRubU8yaGVjb2ptWkp5OUt4MEpINE5zOU4yU1N5ZWht?=
 =?utf-8?B?OGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a16880-7806-4b60-f6be-08d9d72a08c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 06:49:38.4160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: caEZg8yCihQ+ILYLGSvGNcikFb2daH1+Q1yoM1QheGeMLzYRaxwLzF7QH9c2L9L6Z1BgwMJMIPJU2ox5FoctEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6247
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVHlsZXIgV2VhciA8dHdl
YXJAcXVpY2luYy5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgSmFudWFyeSAxMiwgMjAyMiA5OjEz
IFBNDQo+IFRvOiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5j
b20+OyBUeWxlciBXZWFyIChRVUlDKQ0KPiA8cXVpY190d2VhckBxdWljaW5jLmNvbT4NCj4gQ2M6
IE5ldHdvcmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBicGYNCj4gPGJw
ZkB2Z2VyLmtlcm5lbC5vcmc+OyBNYWNpZWogxbtlbmN6eWtvd3NraSA8bWF6ZUBnb29nbGUuY29t
PjsNCj4gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT47IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFp
QGZiLmNvbT47IFRva2UNCj4gSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPjsg
RGFuaWVsIEJvcmttYW5uDQo+IDxkYW5pZWxAaW9nZWFyYm94Lm5ldD47IFNvbmcgTGl1IDxzb25n
QGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggYnBmLW5leHQgdjYgMS8yXSBBZGQg
c2tiX3N0b3JlX2J5dGVzKCkgZm9yDQo+IEJQRl9QUk9HX1RZUEVfQ0dST1VQX1NLQg0KPiANCj4g
DQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogQWxleGVpIFN0
YXJvdm9pdG92IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPg0KPiA+IFNlbnQ6IFdlZG5l
c2RheSwgSmFudWFyeSAxMiwgMjAyMiA2OjE0IFBNDQo+ID4gVG86IFR5bGVyIFdlYXIgKFFVSUMp
IDxxdWljX3R3ZWFyQHF1aWNpbmMuY29tPg0KPiA+IENjOiBOZXR3b3JrIERldmVsb3BtZW50IDxu
ZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgYnBmDQo+ID4gPGJwZkB2Z2VyLmtlcm5lbC5vcmc+OyBN
YWNpZWogxbtlbmN6eWtvd3NraSA8bWF6ZUBnb29nbGUuY29tPjsNCj4gWW9uZ2hvbmcNCj4gPiBT
b25nIDx5aHNAZmIuY29tPjsgTWFydGluIEthRmFpIExhdSA8a2FmYWlAZmIuY29tPjsgVG9rZQ0K
PiA+IEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT47IERhbmllbCBCb3JrbWFu
bg0KPiA+IDxkYW5pZWxAaW9nZWFyYm94Lm5ldD47IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+
DQo+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBicGYtbmV4dCB2NiAxLzJdIEFkZCBza2Jfc3RvcmVf
Ynl0ZXMoKSBmb3INCj4gPiBCUEZfUFJPR19UWVBFX0NHUk9VUF9TS0INCj4gPg0KPiA+IFdBUk5J
Tkc6IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgUXVhbGNvbW0uIFBsZWFz
ZSBiZQ0KPiA+IHdhcnkgb2YgYW55IGxpbmtzIG9yIGF0dGFjaG1lbnRzLCBhbmQgZG8gbm90IGVu
YWJsZSBtYWNyb3MuDQo+ID4NCj4gPiBPbiBXZWQsIEphbiAxMiwgMjAyMiBhdCA1OjE1IFBNIFR5
bGVyIFdlYXIgPHF1aWNfdHdlYXJAcXVpY2luYy5jb20+DQo+ID4gd3JvdGU6DQo+ID4gPg0KPiA+
ID4gTmVlZCB0byBtb2RpZnkgdGhlIGRzIGZpZWxkIHRvIHN1cHBvcnQgdXBjb21pbmcgV2lmaSBR
b1MgQWxsaWFuY2Ugc3BlYy4NCj4gPiA+IEluc3RlYWQgb2YgYWRkaW5nIGdlbmVyaWMgZnVuY3Rp
b24gZm9yIGp1c3QgbW9kaWZ5aW5nIHRoZSBkcyBmaWVsZCwNCj4gPiA+IGFkZCBza2Jfc3RvcmVf
Ynl0ZXMgZm9yIEJQRl9QUk9HX1RZUEVfQ0dST1VQX1NLQi4NCj4gPiA+IFRoaXMgYWxsb3dzIG90
aGVyIGZpZWxkcyBpbiB0aGUgbmV0d29yayBhbmQgdHJhbnNwb3J0IGhlYWRlciB0byBiZQ0KPiA+
ID4gbW9kaWZpZWQgaW4gdGhlIGZ1dHVyZS4NCj4gPiA+DQo+ID4gPiBDaGVja3N1bSBBUEkncyBh
bHNvIG5lZWQgdG8gYmUgYWRkZWQgZm9yIGNvbXBsZXRlbmVzcy4NCj4gPiA+DQo+ID4gPiBJdCBp
cyBub3QgcG9zc2libGUgdG8gdXNlIENHUk9VUF8oU0VUfEdFVClTT0NLT1BUIHNpbmNlIHRoZSBw
b2xpY3kNCj4gPiA+IG1heSBjaGFuZ2UgZHVyaW5nIHJ1bnRpbWUgYW5kIHdvdWxkIHJlc3VsdCBp
biBhIGxhcmdlIG51bWJlciBvZg0KPiA+ID4gZW50cmllcyB3aXRoIHdpbGRjYXJkcy4NCj4gPiA+
DQo+ID4gPiBWNCBwYXRjaCBmaXhlcyB3YXJuaW5ncyBhbmQgZXJyb3JzIGZyb20gY2hlY2twYXRj
aC4NCj4gPiA+DQo+ID4gPiBUaGUgZXhpc3RpbmcgY2hlY2sgZm9yIGJwZl90cnlfbWFrZV93cml0
YWJsZSgpIHNob3VsZCBtZWFuIHRoYXQNCj4gPiA+IHNrYl9zaGFyZV9jaGVjaygpIGlzIG5vdCBu
ZWVkZWQuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogVHlsZXIgV2VhciA8cXVpY190d2Vh
ckBxdWljaW5jLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIG5ldC9jb3JlL2ZpbHRlci5jIHwgMTIg
KysrKysrKysrKysrDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4g
PiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZmlsdGVyLmMgYi9uZXQvY29yZS9maWx0
ZXIuYyBpbmRleA0KPiA+ID4gNjEwMmYwOTNkNTlhLi5mMzBkOTM5Y2I0Y2YgMTAwNjQ0DQo+ID4g
PiAtLS0gYS9uZXQvY29yZS9maWx0ZXIuYw0KPiA+ID4gKysrIGIvbmV0L2NvcmUvZmlsdGVyLmMN
Cj4gPiA+IEBAIC03Mjk5LDYgKzcyOTksMTggQEAgY2dfc2tiX2Z1bmNfcHJvdG8oZW51bSBicGZf
ZnVuY19pZA0KPiBmdW5jX2lkLA0KPiA+IGNvbnN0IHN0cnVjdCBicGZfcHJvZyAqcHJvZykNCj4g
PiA+ICAgICAgICAgICAgICAgICByZXR1cm4gJmJwZl9za19zdG9yYWdlX2RlbGV0ZV9wcm90bzsN
Cj4gPiA+ICAgICAgICAgY2FzZSBCUEZfRlVOQ19wZXJmX2V2ZW50X291dHB1dDoNCj4gPiA+ICAg
ICAgICAgICAgICAgICByZXR1cm4gJmJwZl9za2JfZXZlbnRfb3V0cHV0X3Byb3RvOw0KPiA+ID4g
KyAgICAgICBjYXNlIEJQRl9GVU5DX3NrYl9zdG9yZV9ieXRlczoNCj4gPiA+ICsgICAgICAgICAg
ICAgICByZXR1cm4gJmJwZl9za2Jfc3RvcmVfYnl0ZXNfcHJvdG87DQo+ID4gPiArICAgICAgIGNh
c2UgQlBGX0ZVTkNfY3N1bV91cGRhdGU6DQo+ID4gPiArICAgICAgICAgICAgICAgcmV0dXJuICZi
cGZfY3N1bV91cGRhdGVfcHJvdG87DQo+ID4gPiArICAgICAgIGNhc2UgQlBGX0ZVTkNfY3N1bV9s
ZXZlbDoNCj4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gJmJwZl9jc3VtX2xldmVsX3Byb3Rv
Ow0KPiA+ID4gKyAgICAgICBjYXNlIEJQRl9GVU5DX2wzX2NzdW1fcmVwbGFjZToNCj4gPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm4gJmJwZl9sM19jc3VtX3JlcGxhY2VfcHJvdG87DQo+ID4gPiAr
ICAgICAgIGNhc2UgQlBGX0ZVTkNfbDRfY3N1bV9yZXBsYWNlOg0KPiA+ID4gKyAgICAgICAgICAg
ICAgIHJldHVybiAmYnBmX2w0X2NzdW1fcmVwbGFjZV9wcm90bzsNCj4gPiA+ICsgICAgICAgY2Fz
ZSBCUEZfRlVOQ19jc3VtX2RpZmY6DQo+ID4gPiArICAgICAgICAgICAgICAgcmV0dXJuICZicGZf
Y3N1bV9kaWZmX3Byb3RvOw0KPiA+DQo+ID4gVGhpcyBpcyB3cm9uZy4NCj4gPiBDR1JPVVBfSU5F
VF9FR1JFU1MgYnBmIHByb2cgY2Fubm90IGFyYml0cmFyeSBjaGFuZ2UgcGFja2V0IGRhdGEuDQo+
ID4gVGhlIG5ldHdvcmtpbmcgc3RhY2sgcG9wdWxhdGVkIHRoZSBJUCBoZWFkZXIgYXQgdGhhdCBw
b2ludC4NCj4gPiBJZiB0aGUgcHJvZyBjaGFuZ2VzIGl0IHRvIHNvbWV0aGluZyBlbHNlIGl0IHdp
bGwgYmUgY29uZnVzaW5nIG90aGVyDQo+ID4gbGF5ZXJzIG9mIHN0YWNrLiBuZWlnaChMMikgd2ls
bCBiZSB3cm9uZywgZXRjLg0KPiA+IFdlIGNhbiBzdGlsbCBjaGFuZ2UgY2VydGFpbiB0aGluZ3Mg
aW4gdGhlIHBhY2tldCwgYnV0IG5vdCBhcmJpdHJhcnkgYnl0ZXMuDQo+ID4NCj4gPiBXZSBjYW5u
b3QgY2hhbmdlIHRoZSBEUyBmaWVsZCBkaXJlY3RseSBpbiB0aGUgcGFja2V0IGVpdGhlci4NCj4g
PiBJdCBjYW4gb25seSBiZSBjaGFuZ2VkIGJ5IGNoYW5naW5nIGl0cyB2YWx1ZSBpbiB0aGUgc29j
a2V0Lg0KPiANCj4gV2h5IGlzIHRoZSBEUyBmaWVsZCB1bmNoYW5nZWFibGUsIGJ1dCBlY24gaXMg
Y2hhbmdlYWJsZT8NCg0KUGVyIHNwZWMgdGhlIHJlcXVpcmVtZW50IGlzIHRvIG1vZGlmeSB0aGUg
ZHMgZmllbGQgb2YgZWdyZXNzIHBhY2tldHMgd2l0aCBEU0NQIHZhbHVlLiBTZXR0aW5nIGRzIGZp
ZWxkIG9uIHNvY2tldCB3aWxsIG5vdCBzdWZmaWNlIGhlcmUuDQpBbm90aGVyIGNhc2UgaXMgd2hl
cmUgZGV2aWNlIGlzIGEgbWlkZGxlLW1hbiBhbmQgbmVlZHMgdG8gbW9kaWZ5IHRoZSBwYWNrZXRz
IG9mIGEgY29ubmVjdGVkIHRldGhlcmVkIGNsaWVudCB3aXRoIHRoZSBEU0NQIHZhbHVlLCB1c2lu
ZyBhIHNvY2sgd2lsbCBub3QgYmUgYWJsZSB0byBjaGFuZ2UgdGhlIHBhY2tldCBoZXJlLg0KDQpT
cGVjIGRvYyBjYW4gYmUgZm91bmQgYXQ6IGh0dHBzOi8vd3d3LndpLWZpLm9yZy9kaXNjb3Zlci13
aS1maS93aS1maS1xb3MtbWFuYWdlbWVudA0KDQo+IA0KPiA+DQo+ID4gVEMgbGF5ZXIgaXMgd2hl
cmUgcGFja2V0IG1vZGlmaWNhdGlvbnMgYXJlIGFsbG93ZWQuDQoNCg==
