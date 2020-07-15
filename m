Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2B122022E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 04:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgGOCNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:13:01 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:6084
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbgGOCNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 22:13:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qe2REufMfdNGNmBmg4JoBelytt+YwBw2fqXyVkz/iNGxoGgZ0nDxq0padgMqnungy+dNCph7F+CfnyB6fC3mANc8Y1QTKWX2exqpPfto4v8sT/xUQFoKdsGRl/Z5eZzxoVAlk+NMhws6Ddw5n76N58vyhyyxX6PFvm53IpD+wYQinBS/vMYz+JGHDZPBDgRb2GmRWBwO/boA8e9UrUMdP9TXx9wbHczMRG0ZPtrABj9kuk10pU0wtIC1I1PE02u0k6GGdcqPE+cXM5avuHaeodShm/I4WQQc6HT7hFEJtKISv/Z/zGe0Kb4iHFm2Vd1uS+YtnBiCKVR08V1a8pw7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMVyC5uztNdE/4BQpNYD5JsPhG7+A1M/eyiOi2G8bp8=;
 b=n008+97Uj3mOwF7zipBYVNcz4OHAOI6cWaDBBun5ENu0UGAphFGgyVr/AAailue9SlAZyJvskIKtRNeFYWL3NLGRa0V8N+YAU5T0D9BTEsLwP0X1cG3c0PPmRSmj5ZtZJZxY6krHUTdAzP17DuoZ5j7aZTSPzq9M6hEjVRuDVoIX10yLls1Z3eeU8uplyqXAeRAcHoF3xd7dVXTtNughG/msANei1oFC7zqcM93HYPwjPC0jiyjUCUJ9eCMZxHBE4+43KFcO0Z9nxlJTFBAnD+s6nkehczBqK9ArjM/AeSOsh2R2xOliQxhu0TpEP0oqs73RkrI9G02GZNPAJOhx7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMVyC5uztNdE/4BQpNYD5JsPhG7+A1M/eyiOi2G8bp8=;
 b=opeCDQamYjYg6ncjnNbwj7GowYxW4JE5CJx0GxNBa3yVSw+9vaHOqLDXKw7Zu0vRIi8TEIGNNnoy1j4BY4484Bmr2mOJwvjSkSjpvxE4MRsVUDV0LWE4L0+DuI5DYV49gcuHsiIk5RKdSjWQ3HmKE4UKDE3KwR8NnYeLxroBin8=
Received: from DM6PR11MB2635.namprd11.prod.outlook.com (2603:10b6:5:c5::29) by
 DM6PR11MB2635.namprd11.prod.outlook.com (2603:10b6:5:c5::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Wed, 15 Jul 2020 02:12:58 +0000
Received: from DM6PR11MB2635.namprd11.prod.outlook.com
 ([fe80::74cd:7ab:7255:2e90]) by DM6PR11MB2635.namprd11.prod.outlook.com
 ([fe80::74cd:7ab:7255:2e90%3]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 02:12:57 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "tuong.t.lien@dektech.com.au" <tuong.t.lien@dektech.com.au>,
        "Xue, Ying" <Ying.Xue@windriver.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIHYyXSB0aXBjOiBEb24ndCB1c2luZyBzbXBfcHJvY2Vz?=
 =?gb2312?Q?sor=5Fid()_in_preemptible_code?=
Thread-Topic: [PATCH v2] tipc: Don't using smp_processor_id() in preemptible
 code
Thread-Index: AQHWWbRfIzSLUoSFxESt6m2E0WcCo6kHHx8AgADHpzY=
Date:   Wed, 15 Jul 2020 02:12:57 +0000
Message-ID: <DM6PR11MB2635949FCEAF1EF90B93B5D1FF7E0@DM6PR11MB2635.namprd11.prod.outlook.com>
References: <20200714080559.9617-1-qiang.zhang@windriver.com>,<bf395370-219a-7c87-deee-7f3edce8c9dc@gmail.com>
In-Reply-To: <bf395370-219a-7c87-deee-7f3edce8c9dc@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be56786d-beed-48f9-1444-08d8286497b1
x-ms-traffictypediagnostic: DM6PR11MB2635:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB2635F2668DA93B681CF78BE0FF7E0@DM6PR11MB2635.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mEueVUoyRkL6F2JZP6DKwd3ukE90U9P74UajSx+beWA999ESVLd9WB1Z9kBJt6rDAcmm3c+0U8AuA/P2o2BV9xJD2nNxSEDgBkTYsRk/UdrQ4Q9aRayiuqDaIGTP8ynQI9hzko3ErIsrSbNTkSDQGpMmJ6fjBPhwMKJu0gkQxIEM5Ylodgpc/EoaMKRC0WHiHfXoPDWVfqDn/fIleGPOnOogvpOCriSdhclH2J1XkSChljVYarRs/ynfEgZWjFIlicg6o55HNsPWSrdO/EVuH5fjWAdOxHW9RIDKHW+fQ3RnAdngE/ixFqkAWzAvp+Sbl2YR6SrKikI5+iV45/iPTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2635.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(396003)(376002)(136003)(366004)(478600001)(6506007)(53546011)(7696005)(2906002)(6636002)(33656002)(91956017)(64756008)(76116006)(224303003)(66946007)(54906003)(66446008)(66556008)(66476007)(4326008)(71200400001)(316002)(86362001)(8936002)(83380400001)(110136005)(52536014)(26005)(5660300002)(55016002)(186003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Zt4hlXIPoi3ClfLUWyJeNIm7TRfPbii+bwiKCqGLTdLS6C84jEJeP6a25+3rJSC+0Z9BHjDC9/EpfdCjLlFkYtUJ+RzlmamHBV5vwcanWZ052YJuyx9zOAzxb6+EUVopzDte0d6dKWZKj6TwjcfhK9vuPSmXD5LGBVFfcfWkRLnV0amwiSt5GTVTWGsfU4RimuhiIEU2DLCDGUDYlU3Aq8BwSzvGXyimF9Jk2a2qsLbIZQFeDXTBIwOluaX+q+XxlZMn8AvuwLi6E9D/IEyHfdBgQOUhPyHBmCdns6EmHSLjnZRgMH/EtiDpqXoGJ87OtFcI3VWevJrPLivsZzz4zQtOwfPHayKLUhLDp4WUOP/HQ8Qt5BNcShdT4hwWaYcgmphkCWewy7GHncK5l3ExjkyPWV7KGMSY3vxACzYtECcSaiZn7s801p+frSIMXVCRfiGPBrtM92OlyTPxuaZkAMksS0i70laNxMDo5W9mNJM=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2635.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be56786d-beed-48f9-1444-08d8286497b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 02:12:57.8930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dyTRecKEWn88gfvKWBUqLqO7or34Uvmg/Dc8CfNTI9MGVJf3+Mgw+6KmKOIWqCQcHwHz617/F2xQmQfZbblc71i4EcO3ViuV5u61CAEYM3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2635
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogRXJpYyBE
dW1hemV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPgq3osvNyrG85DogMjAyMMTqN9TCMTTI1SAy
MjoxNQrK1bz+yMs6IFpoYW5nLCBRaWFuZzsgam1hbG95QHJlZGhhdC5jb207IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgdHVvbmcudC5saWVuQGRla3RlY2guY29tLmF1OyBl
cmljLmR1bWF6ZXRAZ21haWwuY29tOyBYdWUsIFlpbmcKs63LzTogbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgdGlwYy1kaXNjdXNzaW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldDsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZwrW98ziOiBSZTogW1BBVENIIHYyXSB0aXBjOiBEb24ndCB1c2luZyBz
bXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUgY29kZQoKCgpPbiA3LzE0LzIwIDE6MDUg
QU0sIHFpYW5nLnpoYW5nQHdpbmRyaXZlci5jb20gd3JvdGU6Cj4gRnJvbTogWmhhbmcgUWlhbmcg
PHFpYW5nLnpoYW5nQHdpbmRyaXZlci5jb20+Cj4KPiBDUFU6IDAgUElEOiA2ODAxIENvbW06IHN5
ei1leGVjdXRvcjIwMSBOb3QgdGFpbnRlZCA1LjguMC1yYzQtc3l6a2FsbGVyICMwCj4gSGFyZHdh
cmUgbmFtZTogR29vZ2xlIEdvb2dsZSBDb21wdXRlIEVuZ2luZS9Hb29nbGUgQ29tcHV0ZSBFbmdp
bmUsCj4gQklPUyBHb29nbGUgMDEvMDEvMjAxMQo+Cj4gRml4ZXM6IGZjMWI2ZDZkZTIyMDggKCJ0
aXBjOiBpbnRyb2R1Y2UgVElQQyBlbmNyeXB0aW9uICYgYXV0aGVudGljYXRpb24iKQo+IFJlcG9y
dGVkLWJ5OiBzeXpib3QrMjYzZjhjMGQwMDdkYzA5YjJkZGFAc3l6a2FsbGVyLmFwcHNwb3RtYWls
LmNvbQo+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFFpYW5nIDxxaWFuZy56aGFuZ0B3aW5kcml2ZXIu
Y29tPgo+IC0tLQo+ICB2MS0+djI6Cj4gIGFkZCBmaXhlcyB0YWdzLgo+Cj4gIG5ldC90aXBjL2Ny
eXB0by5jIHwgMyArKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQo+Cj4gZGlmZiAtLWdpdCBhL25ldC90aXBjL2NyeXB0by5jIGIvbmV0L3RpcGMvY3J5
cHRvLmMKPiBpbmRleCA4YzQ3ZGVkMmVkYjYuLjUyMGFmMGFmZTFiMyAxMDA2NDQKPiAtLS0gYS9u
ZXQvdGlwYy9jcnlwdG8uYwo+ICsrKyBiL25ldC90aXBjL2NyeXB0by5jCj4gQEAgLTM5OSw5ICsz
OTksMTAgQEAgc3RhdGljIHZvaWQgdGlwY19hZWFkX3VzZXJzX3NldChzdHJ1Y3QgdGlwY19hZWFk
IF9fcmN1ICphZWFkLCBpbnQgdmFsKQo+ICAgKi8KPiAgc3RhdGljIHN0cnVjdCBjcnlwdG9fYWVh
ZCAqdGlwY19hZWFkX3RmbV9uZXh0KHN0cnVjdCB0aXBjX2FlYWQgKmFlYWQpCj4gIHsKPiAtICAg
ICBzdHJ1Y3QgdGlwY190Zm0gKip0Zm1fZW50cnkgPSB0aGlzX2NwdV9wdHIoYWVhZC0+dGZtX2Vu
dHJ5KTsKPiArICAgICBzdHJ1Y3QgdGlwY190Zm0gKip0Zm1fZW50cnkgPSBnZXRfY3B1X3B0cihh
ZWFkLT50Zm1fZW50cnkpOwo+Cj4gICAgICAgKnRmbV9lbnRyeSA9IGxpc3RfbmV4dF9lbnRyeSgq
dGZtX2VudHJ5LCBsaXN0KTsKPiArICAgICBwdXRfY3B1X3B0cih0Zm1fZW50cnkpOwo+ICAgICAg
IHJldHVybiAoKnRmbV9lbnRyeSktPnRmbTsKPiAgfQo+Cj4KCj4gWW91IGhhdmUgbm90IGV4cGxh
aW5lZCB3aHkgdGhpcyB3YXMgc2FmZS4KPgo+ICBUaGlzIHNlZW1zIHRvIGhpZGUgYSByZWFsIGJ1
Zy4KPgo+IFByZXN1bWFibHkgY2FsbGVycyBvZiB0aGlzIGZ1bmN0aW9uIHNob3VsZCBoYXZlIGRp
c2FibGUgcHJlZW1wdGlvbiwgYW5kIG1heWJlID4gaW50ZXJydXB0cyBhcyB3ZWxsLgo+Cj5SaWdo
dCBhZnRlciBwdXRfY3B1X3B0cih0Zm1fZW50cnkpLCB0aGlzIHRocmVhZCBjb3VsZCBtaWdyYXRl
IHRvIGFub3RoZXIgY3B1LCA+YW5kIHN0aWxsIGFjY2Vzcwo+ZGF0YSBvd25lZCBieSB0aGUgb2xk
IGNwdS4KClRoYW5rcyBmb3IgeW91IHN1Z2dlc3QsIEkgd2lsbCBjaGVjayBjb2RlIGFnYWluLgoK
Cg==
