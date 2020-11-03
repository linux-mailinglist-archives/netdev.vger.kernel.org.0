Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C642A3BAA
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgKCFJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:09:16 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61532 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725980AbgKCFJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:09:16 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A355FEo027911;
        Mon, 2 Nov 2020 21:09:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=0fZk3DjF6b0dA0cJwKiNs3gIfjtERZf5+SWv81uM760=;
 b=SDevUyMyU6BiStz5599f4rd73x/AXBY41DKFmQ285wn4aly6f5kk1vN5wnhysn/cGf2Y
 kxk73t5/4aFk06ROiCo4jC0GKyY2Iu//ZbwpcRQ6vEMBZeypAf0/fuMqwGeIqwgGv+NY
 pRhwN5IsqIcnBUqXhjvXR1OMNG/XCiVu1KGtrgnKRtglzSymZG+HbN6LtcD+hsoX4D/l
 E9LUXmlcn+Tb/dRcdejITKaXBviR51m85P/UKMXLRJqdEVQOdoF/69KuiAfLbsf5UAzP
 rBlzOaRXyJyZpn7ny5gE/MsF8R/Zx0Zqs+uu0EqYMpKPhiJJaUUcBVNW2OKXXL5iqWJB EA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59mv2yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 21:09:14 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 21:09:13 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 21:09:12 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 2 Nov 2020 21:09:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g89NwluyjHfa9JDJgBD7b6+AKUkSsi5UnqaSQvRKbt2m+NbTzWi2SZGDlzCfSTzqBBiJK2BuevIt/Yqg7TOv8AdEHIWUWUP7ftIHnZNqGe5OhTG40mQzEhkKj0gfu7ULLmoh2L3Zay/8j148u/xsM8EMc19u9upKgpTwqqOA4QJYQ01HD4EtYzJwcZHjiU6j6VnoatKVcWO0A+2tvuI1GRj6VUgr1nnh+1IW3nw++nkYqTen1XERSlmiWxCaMCU8tiqo38kpdpJvb+0wdLUI/RWwMp+5TqU8GjtoLnGcx7Qo68ntZdvBGDm6Rq5IE0O6jOoVSG4Zt4CaiSDSPoy81w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fZk3DjF6b0dA0cJwKiNs3gIfjtERZf5+SWv81uM760=;
 b=IePeKdIE2+usvH2K5z/VYctDZWm/apXALqGLKlFrhksEFGqFdRubi3mpNmPSvhuPUEDTvq509RQvHYVnJiWMmiLgUL4blu9qsl7Uf796yhb2g50t7qmY4rAKFaVX2eXUgk0193FGjvm/Zu2cHSbVayytfbHlOY3W+SXC8kUefoaL7FMu/SMMuKOvknQ5pkxo3x2AfqXRtUfakIXFxkemEvt5oUBljOFOyLCgn10+1iOIoJdlQbe3XdSB8YFKCmG4OxY4UFL7xHk8p54kGcVM4lNzeLyrI41Fkc6XDmg6BdNYlYd9EkO9HsM1A+pIEuKQ1W/AQgASYRicnON2nRAeag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fZk3DjF6b0dA0cJwKiNs3gIfjtERZf5+SWv81uM760=;
 b=p89RiLE7iXbMjAoW6N27I+AN0n5HXjbje7y6TdTyy+SOkrCSd2abmI4AUe33e4l7/LP0bOyaHU/uRoSB2PeluvOcbZ6tC1/aDF+PkSuZ3kyMSRG1CZTc9sbHeLrulb0vKczxfc3o97M2GlyE56vrvfV5tQPI58MAITanzVsGlq8=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM5PR18MB1082.namprd18.prod.outlook.com (2603:10b6:3:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 05:09:11 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 05:09:11 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [PATCH net-next 03/13] octeontx2-af: Generate key field bit mask
 from KEX profile
Thread-Topic: [PATCH net-next 03/13] octeontx2-af: Generate key field bit mask
 from KEX profile
Thread-Index: AdaxnybQwM2rr7EYTEmIgluxIyJRTQ==
Date:   Tue, 3 Nov 2020 05:09:10 +0000
Message-ID: <DM6PR18MB3212E43EB3E4A3BA3552D43EA2110@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [124.123.178.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9a1b812-dfe5-42ca-82c9-08d87fb699b1
x-ms-traffictypediagnostic: DM5PR18MB1082:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1082670984F47229DFCD61D1A2110@DM5PR18MB1082.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zn/gimCj2UwsAvmkkmMAW1SLegwcos42jigl5L6Emw6yy+c8MUH7gepeZjQwlLteUkqRp7LU3xbhrtLSdykBtxXmbGjwpBnLPHlIc7vrwzYIBx3uQUieOW7q5b4ZalIJMsCZQZcwIKdYOdCaHNrCvJyK4kx23Itews9sxEjzcLhae9ziBvNM6kBHqVoS+nD+2gY47xYhs1XaOIJrnF4YbcQUQb/bVx6Z2Puc/FK+Zl/qa4BOR59hx06SeQspL9yAAshkP5PI6hE1whfYlk6nHTONEKNfq2zLqIvOYY9uWbuxjb0q9wU1Idqp7qxpXgDmuZ0LuW4hlnmEYIkp4csxow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(7696005)(66446008)(64756008)(52536014)(83380400001)(54906003)(9686003)(76116006)(66556008)(66476007)(55016002)(8676002)(66946007)(478600001)(5660300002)(316002)(71200400001)(86362001)(107886003)(2906002)(6916009)(186003)(33656002)(53546011)(8936002)(4326008)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FdsrhIbnb8sqOTNdNJfJGm2UWrtMBS+5/4ABA9fKhK9zopNMFYc5vVE64i0xJXZPvEDr6SAUC1T5bLP0XUjsO8iq0CZQiVnQsUjbb3nOzrL9Bp2K6Qv5XaZnmSYIQj2DrwZxf5A7DdQXb9FA/460Tqk441OIcaoNUCliDKEdJ43zhfAG1C0GW3nH55AaTd9+Hb9Geu8S7Wx61v6z9+6WhRIT3XIJtIVr96LqwmCSnjHJCTlXEH5MLGwHSP8oPPsxlrEYReYrTKKAGcKIT0UzbjmqjEFlnoURacPlQeVfjQ+nQGkygpaWduTbPDiA75dq7ZZrqSYMqPMGsvnAbRp7SeWOOsnYexaAFJcCg1iLgPbqU4xCtDllUlH9A9FXqQFs5Yqaaj40BPYeeghDhBZHHsKuWrtnTiIV6Qt2iopJ6TUsyWbuTRtWfdHzkAZYl+S4rQdk7t1iDc8Qq40ooL6g8H8e7d/PvxOOm3qag7fEnCxKYBbee73ltKprTCB5dq9gTz65DOHd76iQ1p5dXzgwGvokUMvVEFB3JnP4shhXvc4NjRDNtDFOvoslYgq5Qlf13j86nAeffvBBMM2JXIzu6WWb/COy1i+rMyrMl6ve/A42nr4CTuCG1xoE4wf6W+POntzaHxFaiENov0pvGRuiMg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a1b812-dfe5-42ca-82c9-08d87fb699b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 05:09:11.0299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YkTUfFIcfNJLSuisRb5HngWNKwx3QTsX0EpWG8bsYVB5mEURjfhG8L3nuHo+XjpI04VmFVKqG6aSp/1+H5S0Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1082
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCBOb3ZlbWJlciAyLCAy
MDIwIDExOjI0IFBNDQo+IFRvOiBOYXZlZW4gTWFtaW5kbGFwYWxsaSA8bmF2ZWVubUBtYXJ2ZWxs
LmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IFN1bmlsIEtvdnZ1cmkgR291dGhhbSA8
c2dvdXRoYW1AbWFydmVsbC5jb20+OyBMaW51DQo+IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwu
Y29tPjsgR2VldGhhc293amFueWEgQWt1bGENCj4gPGdha3VsYUBtYXJ2ZWxsLmNvbT47IEplcmlu
IEphY29iIEtvbGxhbnVra2FyYW4gPGplcmluakBtYXJ2ZWxsLmNvbT47DQo+IFN1YmJhcmF5YSBT
dW5kZWVwIEJoYXR0YSA8c2JoYXR0YUBtYXJ2ZWxsLmNvbT47IEhhcmlwcmFzYWQgS2VsYW0NCj4g
PGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAwMy8x
M10gb2N0ZW9udHgyLWFmOiBHZW5lcmF0ZSBrZXkgZmllbGQgYml0DQo+IG1hc2sgZnJvbSBLRVgg
cHJvZmlsZQ0KPiANCj4gT24gTW9uLCAyIE5vdiAyMDIwIDExOjQxOjEyICswNTMwIE5hdmVlbiBN
YW1pbmRsYXBhbGxpIHdyb3RlOg0KPiA+IEZyb206IFN1YmJhcmF5YSBTdW5kZWVwIDxzYmhhdHRh
QG1hcnZlbGwuY29tPg0KPiA+DQo+ID4gS2V5IEV4dHJhY3Rpb24oS0VYKSBwcm9maWxlIGRlY2lk
ZXMgaG93IHRoZSBwYWNrZXQgbWV0YWRhdGEgc3VjaCBhcw0KPiA+IGxheWVyIGluZm9ybWF0aW9u
IGFuZCBzZWxlY3RlZCBwYWNrZXQgZGF0YSBieXRlcyBhdCBlYWNoIGxheWVyIGFyZQ0KPiA+IHBs
YWNlZCBpbiBNQ0FNIHNlYXJjaCBrZXkuIFRoaXMgcGF0Y2ggcmVhZHMgdGhlIGNvbmZpZ3VyZWQg
S0VYIHByb2ZpbGUNCj4gPiBwYXJhbWV0ZXJzIHRvIGZpbmQgb3V0IHRoZSBiaXQgcG9zaXRpb24g
YW5kIGJpdCBtYXNrIGZvciBlYWNoIGZpZWxkLg0KPiA+IFRoZSBpbmZvcm1hdGlvbiBpcyB1c2Vk
IHdoZW4gcHJvZ3JhbW1pbmcgdGhlIE1DQU0gbWF0Y2ggZGF0YSBieSBTVyB0bw0KPiA+IG1hdGNo
IGEgcGFja2V0IGZsb3cgYW5kIHRha2UgYXBwcm9wcmlhdGUgYWN0aW9uIG9uIHRoZSBmbG93LiBU
aGlzDQo+ID4gcGF0Y2ggYWxzbyB2ZXJpZmllcyB0aGUgbWFuZGF0b3J5IGZpZWxkcyBzdWNoIGFz
IGNoYW5uZWwgYW5kIERNQUMgYXJlDQo+ID4gbm90IG92ZXJ3cml0dGVuIGJ5IHRoZSBLRVggY29u
ZmlndXJhdGlvbiBvZiBvdGhlciBmaWVsZHMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdWJi
YXJheWEgU3VuZGVlcCA8c2JoYXR0YUBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBT
dW5pbCBHb3V0aGFtIDxzZ291dGhhbUBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBO
YXZlZW4gTWFtaW5kbGFwYWxsaSA8bmF2ZWVubUBtYXJ2ZWxsLmNvbT4NCj4gDQo+IExvdHMgb2Yg
bmV3IHdhcm5pbmdzIGxpa2UgdGhpcyBoZXJlOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWFydmVsbC9vY3Rlb250eDIvYWYvcnZ1X25wY19mcy5jOjM1MTozODogd2FybmluZzoNCj4gaW1w
bGljaXQgY29udmVyc2lvbiBmcm9tIOKAmGVudW0gaGVhZGVyX2ZpZWxkc+KAmSB0byDigJhlbnVt
IGtleV9maWVsZHPigJkgWy1XZW51bS0NCj4gY29udmVyc2lvbl0NCj4gICAzNTEgfCAgaWYgKG5w
Y19jaGVja19vdmVybGFwKHJ2dSwgYmxrYWRkciwgTlBDX0VUWVBFLCBzdGFydF9saWQsIGludGYp
KQ0KPiAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+
fn4NCg0KSSB3aWxsIGZpeCB0aGVzZSB3YXJuaW5ncyBpbiB2Mi4NCg0KVGhhbmtzLA0KTmF2ZWVu
DQo=
