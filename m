Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE9F268CF2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgINOJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:09:19 -0400
Received: from mail-eopbgr70134.outbound.protection.outlook.com ([40.107.7.134]:5093
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726360AbgINNs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 09:48:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ju/HFJkCd68rknEiHG8k7/3L9FjxkoiHFkZ4c+Fiigf41hbr7XcCPrpTrfVVFyUY9oNmPitQKJDml7BdgE28A93GaaCrVeCchXtnilusTHhEZwaUU6HABOFKCfdVBpH4VVa2CUtQXGoW60OUwSVH4GY/YYBrwW8e38P66Yx9qa5uU3H7CHUD3tF5a4mqH5Ngf3lxNayxzC38VUqZPVtxtCtCRJpPJbjXdoQ7+1TQvlq8Zpa3r+wdZ26WyaO9NpIqGznmPuB6tX3Fp4xOMPsdh1PRr6zXHUMPgCLhbWBcStk8cBvzJEPrp9ipRmqgQphDuFMWj+n/xJrHW3sWLLCxPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctdJOMAS/8/lk1Wu+dToGMzmf1RnEVFjH623PemXIbg=;
 b=A1Z8hMhhKrddIWJuoZecMTXgVz4HH8ZffG6gUoohkM2PZ+Yybw37eHDRo1//94bo5mQiKc+5lQaYo4YVbmTSNzlYYPp7Oy8eIWmGqhnY+62Iv3VYftpM2yvsKAqrtF/tcT8nTYRFTrW1FYObopKy7NY0GN3lOTnFGXe1aV4XbgH0gwRE0jB357TD0BlXx51lVB/fW18d0nsstnq1Z8GPRvU87DZFeWYgF4vHFWRhe4ELi08c4WfVSG/Ha8sTHdXV5bKrvKNKADKmh9lKJgVtNflLbloeSvAuC4GuoBOYaqd33nCDRkrWZaRnwGCMwuaETfxOgIhLWWuqroQT2YOd0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=habana.ai; dmarc=pass action=none header.from=habana.ai;
 dkim=pass header.d=habana.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=habanalabs.onmicrosoft.com; s=selector2-habanalabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctdJOMAS/8/lk1Wu+dToGMzmf1RnEVFjH623PemXIbg=;
 b=G5D4lceAWko/n3JEEK2mTIb/Bq/9cwUpExfTRQ4Kgqj4RpDii4PI+rcwmQF6xsasIKsP3rVPv65FrwgC8AjFMD2xfthBVbCFBR3MWDISVwuOFs3JFCZ/9RWUTNv4q+JYkOpK/OTvdsavMxfbH/Q8g3etiU0FidyH18JhCfQLkTU=
Received: from AM0PR02MB5523.eurprd02.prod.outlook.com (2603:10a6:208:15e::24)
 by AM0PR02MB4017.eurprd02.prod.outlook.com (2603:10a6:208:d3::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 13:48:14 +0000
Received: from AM0PR02MB5523.eurprd02.prod.outlook.com
 ([fe80::7c43:7d52:92d9:5c93]) by AM0PR02MB5523.eurprd02.prod.outlook.com
 ([fe80::7c43:7d52:92d9:5c93%5]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 13:48:14 +0000
From:   Omer Shpigelman <oshpigelman@habana.ai>
To:     Jakub Kicinski <kuba@kernel.org>,
        Oded Gabbay <oded.gabbay@gmail.com>
CC:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
Thread-Topic: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
Thread-Index: AQHWh40omder6N4vxkGSFhcLRyGM56liS0gAgAACjoCAAAGYgIAAAGuAgAADoQCABcipsA==
Date:   Mon, 14 Sep 2020 13:48:14 +0000
Message-ID: <AM0PR02MB552316B9A1635C18F8464116B8230@AM0PR02MB5523.eurprd02.prod.outlook.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
        <20200910161126.30948-13-oded.gabbay@gmail.com>
        <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf113A_=da2fGxgMbq_V0OcHsxdp5MpfHiUfeew+gEdnjaQ@mail.gmail.com>
        <20200910131629.65b3e02c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf10XdCDhLeyiArc29PAJ_7=BGpdiUvFRotvFHieiaRn=aA@mail.gmail.com>
 <20200910133058.0fe0f5e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910133058.0fe0f5e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=habana.ai;
x-originating-ip: [141.226.12.25]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 865d05dd-f140-43ff-ef37-08d858b4d41d
x-ms-traffictypediagnostic: AM0PR02MB4017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR02MB4017D514703203BF5043DD6DB8230@AM0PR02MB4017.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6T8MTg2QTo8gOLUeI9UuLEia+ZNsSeZKqZVf2UZGpeCf5XO9gy19J78yqb6040ILRGLXn3jTZme/NZaWbM3TMBiRvnr4HVPqaN0aAz99IEiJJYgM2LL8T/Vpx41LSDp+b7f65HsT2CVCp4BD6hCdaU/pLnYvmg61n/2AiNrsdI8UZfrhl84/uGD8g0kcdX26+1fKuedKya0juZyzBY3/vqVoZ/EjMm/bZLZhw90dFT/r2mzD6QDGVDsXXagfPyIFl+Ofa/9udiV2UTZ+iqUZQj990sajhPlDwIUGkayXByvgHN2AIX6KvIJJR4Zz9bjG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5523.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(33656002)(4326008)(26005)(316002)(52536014)(508600001)(5660300002)(71200400001)(2906002)(66446008)(54906003)(66476007)(110136005)(8676002)(64756008)(7696005)(66556008)(66946007)(76116006)(186003)(8936002)(6506007)(9686003)(53546011)(55016002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qWGGXQ1DktplMi0+bu94t2jz92qzXVEZe7FKBWC3sf3WuPKkXtHhEdj78+saDj8w2IH6D49YgWviOnkhu+ijsqJkVauFDmVsk3hiOlzJFOIlACskDaFjutTMGmUllAZFGqlCUeben7yQabNibiwXkdlKS+XeGpjtm3J7tlSDI+QhN0BEvdxqVOucqzr+LnuKSLSW5JQGp+WKL7tjSQrPymp4nLDlqo4GTrcw27kajq102wovZQSwyOJanEWP/MxZxa4nXAdyeFi+yuI5M17wAyRdJipJXv5bZLA6rCwPZDeinU1LBNN7nf2lVfZOqQiA+avx/fDjbpOn9syqhoZ3fpdOxicU9GDrvJoSltVL7JjcooOkSpH1VNjQFXTCt/YiePxKgD6kQ/CP7YlSRrsVRfXA5AnE7ta0C/e6q22wg3j2GO8M9z3B0XbpnJPoZiFgwAMj0VmBwpTeR365YxrwXMNDmVcoI8PBwgqXj1k8aJ4UntpugeUw+ZUm3uty64oFAgQcyjVxCsp1nGjJ32NqP/Jl8LonwFxn1h2C2cK24SEeII+nnKn/8rRp6fsZF7mVtZ3inF1ujmT9dz52VtHMdPv+LTTYPBvEB0V6qfwUqbbdn2Q7uy/sgeupPgHjDHGPn8WigPVRli6H1dzhiLOzqA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: habana.ai
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865d05dd-f140-43ff-ef37-08d858b4d41d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 13:48:14.8344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4d4539-213c-4ed8-a251-dc9766ba127a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GaXmfzDysgq8GnfF2ky0Oaol77F9jTGPcfsQ2af4yjHpQKmrPikzEMadocRt3lZLNRK048/VN2OrOcwOmw7wmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB4017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBTZXAgMTAsIDIwMjAgYXQgMTE6MzEgUE0gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+IE9uIFRodSwgMTAgU2VwIDIwMjAgMjM6MTc6NTkgKzAzMDAgT2Rl
ZCBHYWJiYXkgd3JvdGU6DQo+ID4gPiBEb2Vzbid0IHNlZW0gbGlrZSB0aGlzIG9uZSBzaG93cyBh
bnkgbW9yZSBpbmZvcm1hdGlvbiB0aGFuIGNhbiBiZQ0KPiA+ID4gcXVlcmllZCB3aXRoIGV0aHRv
b2wsIHJpZ2h0Pw0KPiA+IGNvcnJlY3QsIGl0IGp1c3QgZGlzcGxheXMgaXQgaW4gYSBmb3JtYXQg
dGhhdCBpcyBtdWNoIG1vcmUgcmVhZGFibGUNCj4gDQo+IFlvdSBjYW4gY2F0IC9zeXMvY2xhc3Mv
bmV0LyRpZmMvY2FycmllciBpZiB5b3Ugd2FudCAwLzEuDQo+IA0KPiA+ID4gPiBuaWNfbWFjX2xv
b3BiYWNrDQo+ID4gPiA+IGlzIHRvIHNldCBhIHBvcnQgdG8gbG9vcGJhY2sgbW9kZSBhbmQgb3V0
IG9mIGl0LiBJdCdzIG5vdCByZWFsbHkNCj4gPiA+ID4gY29uZmlndXJhdGlvbiBidXQgcmF0aGVy
IGEgbW9kZSBjaGFuZ2UuDQo+ID4gPg0KPiA+ID4gV2hhdCBpcyB0aGlzIGxvb3BiYWNrIGZvcj8g
VGVzdGluZz8NCj4gPg0KPiA+IENvcnJlY3QuDQo+IA0KPiBMb29wYmFjayB0ZXN0IGlzIGNvbW1v
bmx5IGltcGxlbWVudGVkIHZpYSBldGh0b29sIC10DQoNClRoaXMgZGVidWdmcyBlbnRyeSBpcyBv
bmx5IHRvIHNldCB0aGUgcG9ydCB0byBsb29wYmFjayBtb2RlLCBub3QgcnVubmluZyBhIGxvb3Bi
YWNrIHRlc3QuDQpIZW5jZSBJTU8gYWRkaW5nIGEgcHJpdmF0ZSBmbGFnIGlzIG1vcmUgc3VpdGFi
bGUgaGVyZSBhbmQgcGxlYXNlIGNvcnJlY3QgbWUgaWYgSSdtIHdyb25nLg0KQnV0IGVpdGhlciB3
YXksIGRvaW5nIHRoYXQgZnJvbSBldGh0b29sIGluc3RlYWQgb2YgZGVidWdmcyBpcyBub3QgYSBn
b29kIHByYWN0aWNlIGluIG91ciBjYXNlLg0KRHVlIHRvIEhXIGxpbWl0YXRpb25zLCB3aGVuIHdl
IHN3aXRjaCBhIHBvcnQgdG8vZnJvbSBsb29wYmFjayBtb2RlLCB3ZSBuZWVkIHRvIHJlc2V0IHRo
ZSBkZXZpY2UuDQpTaW5jZSBldGh0b29sIHdvcmtzIG9uIHNwZWNpZmljIGludGVyZmFjZSByYXRo
ZXIgdGhhbiBhbiBlbnRpcmUgZGV2aWNlLCB3ZSdsbCBuZWVkIHRvIHJlc2V0IHRoZSBkZXZpY2Ug
MTAgdGltZXMgaW4gb3JkZXIgdG8gc3dpdGNoIHRoZSBlbnRpcmUgZGV2aWNlIHRvIGxvb3BiYWNr
IG1vZGUuDQpNb3Jlb3ZlciwgcnVubmluZyB0aGlzIGNvbW1hbmQgZm9yIG9uZSBpbnRlcmZhY2Ug
YWZmZWN0cyBvdGhlciBpbnRlcmZhY2VzIHdoaWNoIGlzIG5vdCBkZXNpcmFibGUgd2hlbiB1c2lu
ZyBldGh0b29sIEFGQUlLLg0KSXMgdGhlcmUgYW55IG90aGVyIGFjY2VwdGFibGUgZGVidWdmcy1s
aWtlIG1lY2hhbmlzbSBmb3IgdGhhdD8NCg0KVGhhbmtzLA0KT21lcg0K
