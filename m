Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCA64C8922
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbiCAKVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiCAKVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:21:09 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120051.outbound.protection.outlook.com [40.107.12.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1D749F1B;
        Tue,  1 Mar 2022 02:20:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+s4FbwU3uSc8YeWXvTj+BMw89M51Ngpqd73Yn9abmY8PHta4D0MzXxhYdQKo/S0ftNlUSjZhQZitfiVMsD6zDrr9fYWB+5YD+ZkfNOUMi7QrgLmT/GhmiGYHlSI2p52FWQcDOX1+bErKIhSbe+Yvw1s5fzIyJJxRIHqC/Mwso91owUnS/POkjrU3Kmp8dmvyHNv5pmOE9U3JLoH0CcRlhnupwLa5o1KwD4gaoO0vERT2BsLbfxwVlywd8hKz/chQ1coOg1gRIIudFwt0KVoZNCIE+brApQxgi7B6Dats2/GIYv3crmhTwST4Kg+xIaUNl0qvt95Ec6ZA1JhHU6LvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBvRcz+vilvuC+4tVlgaflWw1pPSv7DwOvdcIG+WXXw=;
 b=KHFRx5C7slDlgfE2xMtMrAN/T3u9ZBMdngNSk20ns/D3eCR105x7Q+Otr5CLTaQHGqYocE8Qr23wJA3mZC6DjnTqVYNRfUsl3wQg8iDF+En3El265oKd7iGIWlHaM07gDPaZwUnulJTLK5xawzuvJJUFvoJ8uRZJKIENsksMR4Qrn7ivmEbW37D1e6TKJEu4OvNMxhxTNasSuF+mZnTsOtnudDNBobHpWvdFknzsN91wL5l+ElkOg3c+upgOzNtQxsCV7v76CqfVp4Xkc+eY8f+z/rFxonmi9oA8uxUyyLgHlIcHU54CcVfh32VTw2zyqvHsbrWTFRiSxu+6HhTU+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3d::7) by
 MR2P264MB0065.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:4::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Tue, 1 Mar 2022 10:20:26 +0000
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b4e1:6a58:710c:54f3]) by MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b4e1:6a58:710c:54f3%6]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:20:26 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Segher Boessenkool' <segher@kernel.crashing.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Remove branch in csum_shift()
Thread-Topic: [PATCH] net: Remove branch in csum_shift()
Thread-Index: AQHYHyQnvQLG+pah+0i2HX/tfT/o2ayQx3QAgABu/ICAAI7sAIAYqEqA
Date:   Tue, 1 Mar 2022 10:20:26 +0000
Message-ID: <de560db6-d29a-8565-857b-b42ae35f80f8@csgroup.eu>
References: <efeeb0b9979b0377cd313311ad29cf0ac060ae4b.1644569106.git.christophe.leroy@csgroup.eu>
 <7f16910a8f63475dae012ef5135f41d1@AcuMS.aculab.com>
 <20220213091619.GY614@gate.crashing.org>
 <476aa649389345db92f86e9103a848be@AcuMS.aculab.com>
In-Reply-To: <476aa649389345db92f86e9103a848be@AcuMS.aculab.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6587308a-9f7b-4b9b-07b6-08d9fb6d1a63
x-ms-traffictypediagnostic: MR2P264MB0065:EE_
x-microsoft-antispam-prvs: <MR2P264MB00656CB7842E747C26694456ED029@MR2P264MB0065.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 23Rdg6e1zTQYk53hXF4u7/+XzjeN30gTPf809GwqrsLfuCvWL9/Rb/onGYTuJ29IgvGDU7IRithgVFcQ8Fyz0VVSNhljC6c3jDj8Ao7NhnAx/HzWiE7Mahu64EkapHFaNj3O7dGJzPk7a5fGXAExbUIN7TwZ0nPdhYxBoCEtLZHY42NBVS54J6rKM/gxigfeKPcOn66PVvF07AOTvKGK8VeG3aiP4xw4SuF/OOcSn1Qx01WlP9Ldz/6lsdZ3wmdYAVFeHu8l6+mMY2HAmY8nnUouinF49DyIpXgEm4GfJnAp/5v4zijGnJnpdzq9HPtRQCtuc5lG5rdn3FrPLvMdaGefyE6WEAXLC/UMBCJWmfBcDwtbC5MYpXBzgT9Rkzsa/9kUdSVHBziJh06+c+QvaABw2b9it+fYL42zJsyUs8N5jK8HEhYjwXTIjVumKZV7b6qnTfdMDLoUb5EPzN9VcFfcZrMoCsKvhmCVKw6pPor4Gcc3fv/AbSnYRABgPkbyVrJtFllg+gZG8O0p+twdYnKozkR/A9/VIU8iN7UsJYC5N2n69ml5wvHK8qWBGU5R8pPZ02vYiSOi8jJioGRDJ2qMoRaZcaYvo8HB3t2m5xkZyX1cR3dmTwz3JmqKdUPCBvScA1NcZq7oLBSgSOEIYoyaTNX+kY23FALPyPUKaMC8b9XO3wiPUtdHHrpDNGzCsPuut2x1FQQzZm4Ax14V3VI/zXdtEcUToIGGqwjF6S8rKd9tMh0caxTKBkjYFjlL7xtj30PYnblQhu8Ji+BH2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(5660300002)(54906003)(508600001)(110136005)(44832011)(6486002)(66946007)(66476007)(64756008)(4326008)(76116006)(38070700005)(91956017)(66556008)(8676002)(31686004)(66446008)(71200400001)(2616005)(26005)(186003)(36756003)(122000001)(38100700002)(6506007)(2906002)(6512007)(31696002)(86362001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnVxZk81Ty9ZMG1HdVRaVzdSeitIRDRnRVBVd2FFMmxrVTJNdThhWmRqdFN2?=
 =?utf-8?B?cE9FNWU0dlBTTkFucTh5UFM0OTRFb0FDTHdFM1dzbzgxcXVTMWNQd05DUmti?=
 =?utf-8?B?WGxnOVlFb2ZaUy9BMEVSamRrc0R6ekMzQWpub3BtTTcvb0VRVDFQQ2ZEU2x0?=
 =?utf-8?B?SkVacXRnWUtyYlljVmVHMFFYMDFSK3o5QlBDaGVGbHIycEZxeEFIalV6ZmE1?=
 =?utf-8?B?MVNHWkhFcUd3VzlSdmVYNUc1Z0l0ZWdyS2RsREtoUGJ1V3FSWkRrUUFnRlpS?=
 =?utf-8?B?R0RTaXdzYzEwZDNSWFl3U1dWZW54bHBtZzlWeDRNWWhhREI3OUN5SVpUbDM2?=
 =?utf-8?B?V01nbWo4QldpQkE2alVzaXBZNG5NUWNnKytkNWR1aG5xcWVQQTFDRU1aek1i?=
 =?utf-8?B?bm5MSnpGWXN4Q2czcUpaK2lVL3lhZVpIZmNjS1VtYzRUWWljbVF2c3A5V0w5?=
 =?utf-8?B?cmNLNHpVZzlGL0JlLzRaSlJ1N2M5NXYrMk1lc3hacUtCd01FZWU1Y0FGcXlw?=
 =?utf-8?B?Wmk2dlhtZUR3aktXcUFkd0twRkxGRzdXV2o2dEZaYXZ6dVlqTFhEYVA5QW1j?=
 =?utf-8?B?ZHFmV3grbzA0UVY1TXc3dEYzVDhLZEdVVmpBQ0d3UEY1WWl2ckt1R2FlWHFI?=
 =?utf-8?B?WmhtYjk0dWVFb0JRRWtDdmdqUzNlYm5xVW1DRzh2Unc2VUlDS2xvSy9HSmQ4?=
 =?utf-8?B?MlZnMnowaGNkK29jckFZZHNoa2JWSUtFY0VzZ3RYa2M2b1IxWE4wT29WRUZz?=
 =?utf-8?B?TmlHZ0JvTGZDMlVGL1dJSm1FRHFpQlVxQWlUelMybDNIMjI5ZFpJcDRwdmpR?=
 =?utf-8?B?UCs3Ulc3RFQvRzErck9keW5JRk91TG85VFJUK2sxWkdvUG5FV1RSeGxXOVVB?=
 =?utf-8?B?a3pLRWRDeVJFQ1NvYzZzZVR1Nnd0b3hTQi9GUGNhZnVYY2l6TlFwdEEzaUFh?=
 =?utf-8?B?aTY3dUdXTFlHQzhWSXpSOFlhNEpNMUQwOVhYeDkzN0oxYU04Y0h0TXA4eEhh?=
 =?utf-8?B?RHZ3dHpZOS9RZmtDZ0VJZHRUdGRYK1NtcnRoTm40RUM2V1B0ZmtNcjU5aDRL?=
 =?utf-8?B?ZEtyVFN1SnNQWnF5RURyWDF0NFBOZXBiLzZzd1EzbW1sOUxzZms1cWtycUht?=
 =?utf-8?B?bHZER3RiTHZ4L09rMlR0aEV6cFIyTTRuT2tUeXN1bFRQQ1dyRCs3NzhZNWlt?=
 =?utf-8?B?Tm9ISjhldXZnOGFGb3ZkL0lWbTRFWDZkVkE3eW82OTNVTWpubVNpOGhSSEQ3?=
 =?utf-8?B?MU9JcEdLSWpkc1Nva0l2TXF3ZnE4eGRjVWg2VUlRVnhBViswellHREs2aVM4?=
 =?utf-8?B?MDJwVGhyRzlib2tJTGc5TGVwTGk4K3FtdW1xK2dFRVlvbk5pY2N5cmdieEl3?=
 =?utf-8?B?czdLekdvU3dmUnZEKytPOFNuYjlMeER1cXNkV291c3dicTRVLzN4RGM0Znlq?=
 =?utf-8?B?SUJMT3hGdi9WRjE5RUtkeWFGVHVaaFJYUFVvRDUvaXJYeXJmN241T0w2Z2Z3?=
 =?utf-8?B?SzU1cm9zVWdjT3dGVG5EWkxSRzhEb01KQmZ4aU05elp6OUZpWmhoUE5uT3VF?=
 =?utf-8?B?Wkt5akh1dGpoamthOWFrcllodVJ3U2gzRFZjWnRzSjZQazJvZm1FQURaeG45?=
 =?utf-8?B?bUsrNVhUelo2NnpXOGNBaUtpakMwcU1oQkhCdndGL3VWa1E3SHZ1VDQrUmVF?=
 =?utf-8?B?TEFBcGc1VjJYWVlQSTlyOElqWXIra1g0WlgybFFTQ3RiYzlmZWdDRmYzTy9y?=
 =?utf-8?B?cnpJa2RZYnVLK1Q3cHhnQXdleVJibEtQNXpwQjVzYVJFL1JoOVdXUG1PNEg5?=
 =?utf-8?B?WVJ5VVBzYzNKbDUvR3FrbERsdmxreUwvNHl4TUlKU3BER2NZYnVnWW9wMUlo?=
 =?utf-8?B?ajRmSy9BblpkSkVlb2d2T2IwZTB2RTVYZHRRWTkrMHhvVXRRVUFjVk1mLzNj?=
 =?utf-8?B?enVwQmJlRm1JSFJVWmxvRFlWLzRVSC9VMFljdkJ0dDFkT1BERUdKVUVVVjNK?=
 =?utf-8?B?VGl2Wk5vdFYyQmlKOFlBZzdpa2R5MENBdk9SU2diTkJ4YzBzZy9SYmZ5a2Fm?=
 =?utf-8?B?eXpkVDBDYnZBWmdjclBwQTBROTN1YnpjSU85UkYvWFJBUStMVXVwbERSV09n?=
 =?utf-8?B?eU40Q3E5ZFhTejRnMnQvcUQ3ZTk1YUV5RlAzSjlnSmJUVGc5NmlZYXVYQ3gy?=
 =?utf-8?B?eDRnUDl0UmJDZGZuRzVKQ1hTWSthZEJpbWNnTGVHNVE1TUpJM25RUHRURUNO?=
 =?utf-8?Q?SAeIEaOnsT7tFBtpk0tDdJH3o8sOpneJG6izYkUB50=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D5E6D8A46C8DF4397B9D4E90A35D6CE@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6587308a-9f7b-4b9b-07b6-08d9fb6d1a63
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2022 10:20:26.1715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8hjINA1NIhKO+7nhkglh0HZvl1hLA2mU5V8nJ0bLZnD6Fa0XfJHcRScOKgtZ2HVO98LNrVIONirxLIoXmKSvta7jX6Zh6iDEXKGyJhibz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0065
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDEzLzAyLzIwMjIgw6AgMTg6NDcsIERhdmlkIExhaWdodCBhIMOpY3JpdMKgOg0KPiBG
cm9tOiBTZWdoZXIgQm9lc3Nlbmtvb2wNCj4+IFNlbnQ6IDEzIEZlYnJ1YXJ5IDIwMjIgMDk6MTYN
Cj4gLi4uLg0KPj4NCj4+PiBXaGF0IGhhcHBlbnMgb24geDg2LTY0Pw0KPj4+DQo+Pj4gVHJ5aW5n
IHRvIGRvIHRoZSBzYW1lIGluIHRoZSB4ODYgaXBjc3VtIGNvZGUgdGVuZGVkIHRvIG1ha2UgdGhl
IGNvZGUgd29yc2UuDQo+Pj4gKEFsdGhvdWdoIHRoYXQgdGVzdCBpcyBmb3IgYW4gb2RkIGxlbmd0
aCBmcmFnbWVudCBhbmQgY2FuIGp1c3QgYmUgcmVtb3ZlZC4pDQo+Pg0KPj4gSW4gYW4gaWRlYWwg
d29ybGQgdGhlIGNvbXBpbGVyIGNvdWxkIGNob29zZSB0aGUgb3B0aW1hbCBjb2RlIHNlcXVlbmNl
cw0KPj4gZXZlcnl3aGVyZS4gIEJ1dCB0aGF0IHdvbid0IGV2ZXIgaGFwcGVuLCB0aGUgc2VhcmNo
IHNwYWNlIGlzIHdheSB0b28NCj4+IGJpZy4gIFNvIGNvbXBpbGVycyBqdXN0IHVzZSBoZXVyaXN0
aWNzLCBub3QgZXhoYXVzdGl2ZSBzZWFyY2ggbGlrZQ0KPj4gc3VwZXJvcHQgZG9lcy4gIFRoZXJl
IGlzIGEgbWlkZGxlIHdheSBvZiBjb3Vyc2UsIHNvbWV0aGluZyB3aXRoIGRpcmVjdGVkDQo+PiBz
ZWFyY2hlcywgYW5kIG1heWJlIGluIGEgZmV3IGRlY2FkZXMgc3lzdGVtcyB3aWxsIGJlIGZhc3Qg
ZW5vdWdoLiAgVW50aWwNCj4+IHRoZW4gd2Ugd2lsbCB2ZXJ5IG9mdGVuIHNlZSBjb2RlIHRoYXQg
aXMgMTAlIHNsb3dlciBhbmQgMzAlIGJpZ2dlciB0aGFuDQo+PiBuZWNlc3NhcnkuICBBIHNpbmds
ZSBpbnNuIG1vcmUgdGhhbiBuZWVkZWQgaXNuJ3Qgc28gYmFkIDotKQ0KPiANCj4gQnV0IGl0IGNh
biBiZSBhIGxvdCBtb3JlIHRoYW4gdGhhdC4NCj4gDQo+PiBNYWtpbmcgdGhpbmdzIGJyYW5jaC1m
cmVlIGlzIHZlcnkgbXVjaCB3b3J0aCBpdCBoZXJlIHRob3VnaCENCj4gDQo+IEkgdHJpZWQgdG8g
ZmluZCBvdXQgd2hlcmUgJ2hlcmUnIGlzLg0KPiANCj4gSSBjYW4ndCBnZXQgZ29kYm9sdCB0byBn
ZW5lcmF0ZSBhbnl0aGluZyBsaWtlIHRoYXQgb2JqZWN0IGNvZGUNCj4gZm9yIGEgY2FsbCB0byBj
c3VtX3NoaWZ0KCkuDQo+IA0KPiBJIGNhbid0IGFjdHVhbGx5IGdldCBpdCB0byBpc3N1ZSBhIHJv
dGF0ZSAoeDg2IG9mIHBwYykuDQo+IA0KPiBJIHRoaW5rIGl0IGlzIG9ubHkgYSBzaW5nbGUgaW5z
dHJ1Y3Rpb24gYmVjYXVzZSB0aGUgY29tcGlsZXINCj4gaGFzIHNhdmVkICdvZmZzZXQgJiAxJyBt
dWNoIGVhcmxpZXIgaW5zdGVhZCBvZiBkb2luZyB0ZXN0aW5nDQo+ICdvZmZzZXQgJiAxJyBqdXN0
IHByaW9yIHRvIHRoZSBjb25kaXRpb25hbC4NCj4gSXQgY2VydGFpbmx5IGhhcyBhIG5hc3R5IGhh
Yml0IG9mIGRvaW5nIHRoYXQgcGVzc2ltaXNhdGlvbi4NCj4gDQo+IFNvIHdoaWxlIGl0IGhlbHBz
IGEgc3BlY2lmaWMgY2FsbCBzaXRlIGl0IG1heSBiZSBtdWNoDQo+IHdvcnNlIGluIGdlbmVyYWwu
DQo+IA0KDQpUaGUgbWFpbiB1c2VyIG9mIGNzdW1fc2hpZnQoKSBpcyBjc3VtX2FuZF9jb3B5X3Rv
X2l0ZXIoKS4NCg0KWW91IGNsZWFybHkgc2VlIHRoZSBkaWZmZXJlbmNlIGluIG9uZSBvZiB0aGUg
aW5zdGFuY2VzIGJlbG93IGV4dHJhY3RlZCANCmZyb20gb3V0cHV0IG9mIG9iamR1bXAgLVMgbGli
L2lvdl9pdGVyLm86DQoNCg0KV2l0aG91dCB0aGUgcGF0Y2g6DQoNCglzdW0gPSBjc3VtX3NoaWZ0
KGNzc3RhdGUtPmNzdW0sIGNzc3RhdGUtPm9mZik7DQogICAgIDIxYTg6CTkyIGUxIDAwIDRjIAlz
dHcgICAgIHIyMyw3NihyMSkNCiAgICAgMjFhYzoJN2MgNzcgMWIgNzggCW1yICAgICAgcjIzLHIz
DQogICAgIDIxYjA6CTkzIDAxIDAwIDUwIAlzdHcgICAgIHIyNCw4MChyMSkNCiAgICAgMjFiNDoJ
N2MgYjggMmIgNzggCW1yICAgICAgcjI0LHI1DQogICAgIDIxYjg6CTkzIDYxIDAwIDVjIAlzdHcg
ICAgIHIyNyw5MihyMSkNCiAgICAgMjFiYzoJN2MgZGIgMzMgNzggCW1yICAgICAgcjI3LHI2DQog
ICAgIDIxYzA6CTkzIDgxIDAwIDYwIAlzdHcgICAgIHIyOCw5NihyMSkNCiAgICAgMjFjNDoJODEg
MDUgMDAgMDQgCWx3eiAgICAgcjgsNChyNSkNCiAgICAgMjFjODoJODMgODUgMDAgMDAgCWx3eiAg
ICAgcjI4LDAocjUpDQp9DQoNCnN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgX193c3VtIGNzdW1fc2hp
ZnQoX193c3VtIHN1bSwgaW50IG9mZnNldCkNCnsNCgkvKiByb3RhdGUgc3VtIHRvIGFsaWduIGl0
IHdpdGggYSAxNmIgYm91bmRhcnkgKi8NCglpZiAob2Zmc2V0ICYgMSkNCiAgICAgMjFjYzoJNzEg
MDkgMDAgMDEgCWFuZGkuICAgcjkscjgsMQkJPD09IHRlc3Qgb2RkaXR5DQogICAgIDIxZDA6CTQx
IGEyIDAwIDA4IAliZXEgICAgIDIxZDgJCTw9PSBicmFuY2gNCiAgKiBAd29yZDogdmFsdWUgdG8g
cm90YXRlDQogICogQHNoaWZ0OiBiaXRzIHRvIHJvbGwNCiAgKi8NCnN0YXRpYyBpbmxpbmUgX191
MzIgcm9yMzIoX191MzIgd29yZCwgdW5zaWduZWQgaW50IHNoaWZ0KQ0Kew0KCXJldHVybiAod29y
ZCA+PiAoc2hpZnQgJiAzMSkpIHwgKHdvcmQgPDwgKCgtc2hpZnQpICYgMzEpKTsNCiAgICAgMjFk
NDoJNTcgOWMgYzAgM2UgCXJvdGx3aSAgcjI4LHIyOCwyNAk8PT0gcm90YXRlDQogICAgIDIxZDg6
CTJiIDhhIDAwIDAzIAljbXBsd2kgIGNyNyxyMTAsMw0KICAgICAyMWRjOgk0MSA5ZSAwMSBlYyAJ
YmVxICAgICBjcjcsMjNjOCA8Y3N1bV9hbmRfY29weV90b19pdGVyKzB4MjM0Pg0KDQoNCg0KDQpX
aXRoIHRoZSBwYXRjaDoNCg0KCXN1bSA9IGNzdW1fc2hpZnQoY3NzdGF0ZS0+Y3N1bSwgY3NzdGF0
ZS0+b2ZmKTsNCiAgICAgMjFhODoJOTIgYzEgMDAgNDggCXN0dyAgICAgcjIyLDcyKHIxKQ0KCWlm
ICh1bmxpa2VseShpb3ZfaXRlcl9pc19waXBlKGkpKSkNCiAgICAgMjFhYzoJMjggMDggMDAgMDMg
CWNtcGx3aSAgcjgsMw0KICAgICAyMWIwOgk5MiBlMSAwMCA0YyAJc3R3ICAgICByMjMsNzYocjEp
DQogICAgIDIxYjQ6CTdjIDc2IDFiIDc4IAltciAgICAgIHIyMixyMw0KICAgICAyMWI4Ogk5MyA0
MSAwMCA1OCAJc3R3ICAgICByMjYsODgocjEpDQogICAgIDIxYmM6CTdjIGI3IDJiIDc4IAltciAg
ICAgIHIyMyxyNQ0KICAgICAyMWMwOgk5MyA4MSAwMCA2MCAJc3R3ICAgICByMjgsOTYocjEpDQog
ICAgIDIxYzQ6CTdjIGRhIDMzIDc4IAltciAgICAgIHIyNixyNg0KCXN1bSA9IGNzdW1fc2hpZnQo
Y3NzdGF0ZS0+Y3N1bSwgY3NzdGF0ZS0+b2ZmKTsNCiAgICAgMjFjODoJODAgZTUgMDAgMDQgCWx3
eiAgICAgcjcsNChyNSkNCiAgKiBAd29yZDogdmFsdWUgdG8gcm90YXRlDQogICogQHNoaWZ0OiBi
aXRzIHRvIHJvbGwNCiAgKi8NCnN0YXRpYyBpbmxpbmUgX191MzIgcm9sMzIoX191MzIgd29yZCwg
dW5zaWduZWQgaW50IHNoaWZ0KQ0Kew0KCXJldHVybiAod29yZCA8PCAoc2hpZnQgJiAzMSkpIHwg
KHdvcmQgPj4gKCgtc2hpZnQpICYgMzEpKTsNCiAgICAgMjFjYzoJODEgMjUgMDAgMDAgCWx3eiAg
ICAgcjksMChyNSkNCn0NCg0Kc3RhdGljIF9fYWx3YXlzX2lubGluZSBfX3dzdW0gY3N1bV9zaGlm
dChfX3dzdW0gc3VtLCBpbnQgb2Zmc2V0KQ0Kew0KCS8qIHJvdGF0ZSBzdW0gdG8gYWxpZ24gaXQg
d2l0aCBhIDE2YiBib3VuZGFyeSAqLw0KCXJldHVybiAoX19mb3JjZSBfX3dzdW0pcm9sMzIoKF9f
Zm9yY2UgdTMyKXN1bSwgKG9mZnNldCAmIDEpIDw8IDMpOw0KICAgICAyMWQwOgk1NCBlYSAxZiAz
OCAJcmx3aW5tICByMTAscjcsMywyOCwyOA0KICAgICAyMWQ0Ogk1ZCAzYyA1MCAzZSAJcm90bHcg
ICByMjgscjkscjEwCTw9PSByb3RhdGUNCglpZiAodW5saWtlbHkoaW92X2l0ZXJfaXNfcGlwZShp
KSkpDQogICAgIDIxZDg6CTQxIDgyIDAxIGUwIAliZXEgICAgIDIzYjggPGNzdW1fYW5kX2NvcHlf
dG9faXRlcisweDIyND4NCg0KDQpDaHJpc3RvcGhl
