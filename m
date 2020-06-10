Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1461F4AE7
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 03:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFJBcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 21:32:39 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:5007 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725885AbgFJBch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 21:32:37 -0400
X-UUID: 8eb582d8398a4d0e899051ebeff39a85-20200610
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=qhYvj7zpeWIgmu8J+0ge/AWBJKAFPe78L9ZHRztXi94=;
        b=ROHGXgoEWsN09MfFNKN7Pr9lh/OwAsSPKvpDbtvC4AyMOq1Y6PJiGT78RFNLpHHkaCsBqW4Wvy/WzTzh3V6SXWss6zjmgUN1Y4VIbLsvBpOIepoyiiZgGxm7K/IZKRKGl5GfE5Sk96e1lGEfsztjU11By/cQIq2lylthK0TEcG8=;
X-UUID: 8eb582d8398a4d0e899051ebeff39a85-20200610
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1662716289; Wed, 10 Jun 2020 09:32:33 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by mtkmbs08n1.mediatek.inc
 (172.21.101.55) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Jun
 2020 09:32:31 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Jun 2020 09:32:29 +0800
Message-ID: <1591752616.29387.26.camel@mhfsdcap03>
Subject: Re: [PATCH] net: stmmac: Fix RX Coalesce IOC always true issue
From:   biao huang <biao.huang@mediatek.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "yt.shen@mediatek.com" <yt.shen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 10 Jun 2020 09:30:16 +0800
In-Reply-To: <BN6PR12MB1779E6EF20FD8F5F3255CCE8D3820@BN6PR12MB1779.namprd12.prod.outlook.com>
References: <20200609094133.11053-1-biao.huang@mediatek.com>
         <BN6PR12MB1779E6EF20FD8F5F3255CCE8D3820@BN6PR12MB1779.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTA5IGF0IDE0OjIwICswMDAwLCBKb3NlIEFicmV1IHdyb3RlOg0KPiBG
cm9tOiBCaWFvIEh1YW5nIDxiaWFvLmh1YW5nQG1lZGlhdGVrLmNvbT4NCj4gRGF0ZTogSnVuLzA5
LzIwMjAsIDEwOjQxOjMzIChVVEMrMDA6MDApDQo+IA0KPiA+IC0JCXJ4X3EtPnJ4X2NvdW50X2Zy
YW1lcyArPSBwcml2LT5yeF9jb2FsX2ZyYW1lczsNCj4gPiAtCQlpZiAocnhfcS0+cnhfY291bnRf
ZnJhbWVzID4gcHJpdi0+cnhfY29hbF9mcmFtZXMpDQo+ID4gKwkJaWYgKHJ4X3EtPnJ4X2NvdW50
X2ZyYW1lcyA+PSBwcml2LT5yeF9jb2FsX2ZyYW1lcykNCj4gDQo+IFRoaXMgaXMgbm8gcmlnaHQu
IElmIHlvdSB3YW50IHRvIFJYIElDIGJpdCB0byBub3QgYWx3YXlzIGJlIHNldCB5b3UgbmVlZCAN
Cj4gdG8gY2hhbmdlIGNvYWxlc2NlIHBhcmFtZXRlcnMgdXNpbmcgZXRodG9vbC4NCg0KbGV0J3Mg
dGFrZSBsb29rIGF0IHRoZXNlIGxpbmVzOg0KDQogCTEuIHJ4X3EtPnJ4X2NvdW50X2ZyYW1lcyAr
PSBwcml2LT5yeF9jb2FsX2ZyYW1lczsNCgkyLiAJaWYgKHJ4X3EtPnJ4X2NvdW50X2ZyYW1lcyA+
IHByaXYtPnJ4X2NvYWxfZnJhbWVzKQ0KCTMuIAkJcnhfcS0+cnhfY291bnRfZnJhbWVzID0gMDsN
Cg0KYmVmb3JlIHRoZSBpZiBjb25kaXRpb24obGluZSAyIGFib3ZlKSwgdGhlcmUgaXMgInJ4X3Et
PnJ4X2NvdW50X2ZyYW1lcw0KKz0gcHJpdi0+cnhfY29hbF9mcmFtZXMiKGxpbmUgMSBhYm92ZSkg
c2VudGVuY2U7IHNvIHRoZSBpZiBjb25kaXRpb24NCmFsd2F5cyB0cnVlLCBhbmQgdGhlIGFzc2ln
bm1lbnQgcnhfcS0+cnhfY291bnRfZnJhbWVzID0gMCBoYXBwZW5zLg0KDQpIZXJlIGlzIHRoZSBy
ZXN1bHQgb24gb3VyIHBsYXRmb3JtLCBhbGwgZGVzYzNbMzBdID0gMTsgeW91IGNhbiBhbHNvDQpj
aGVjayBpdCBvbiB5b3VyIHBsYXRmb3JtLiBubyBtYXR0ZXIgd2hhdCByeC1mcmFtZXMgeW91IHNl
dCB3aXRoDQoiZXRodG9vbCAtQyBldGgwIHJ4LWZyYW1lcyIsIGRlc2MzWzMwXSBhbHdheXMgdHJ1
ZS4NCg0KIyBldGh0b29sIC1jIGV0aDANCkNvYWxlc2NlIHBhcmFtZXRlcnMgZm9yIGV0aDA6DQpB
ZGFwdGl2ZSBSWDogb2ZmICBUWDogb2ZmDQpzdGF0cy1ibG9jay11c2VjczogMA0Kc2FtcGxlLWlu
dGVydmFsOiAwDQpwa3QtcmF0ZS1sb3c6IDANCnBrdC1yYXRlLWhpZ2g6IDANCiANCnJ4LXVzZWNz
OiAzMDENCnJ4LWZyYW1lczogMjUNCnJ4LXVzZWNzLWlycTogMA0KcngtZnJhbWVzLWlycTogMA0K
DQojY2QgL3N5cy9rZXJuZWwvZGVidWcvc3RtbWFjZXRoL2V0aDANCiMgY2F0IGRlc2NyaXB0b3Jz
X3N0YXR1cw0KUlggUXVldWUgMDoNCkRlc2NyaXB0b3IgcmluZzoNCjAgWzB4NTAzOGIwMDBdOiAw
eGE4NTQxYTgyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMSBbMHg1MDM4YjAxMF06IDB4YTg1NDEy
MDIgMHgwIDB4MCAweGMxMDAwMDAwDQogDQoyIFsweDUwMzhiMDIwXTogMHhhODU0MDk4MiAweDAg
MHgwIDB4YzEwMDAwMDANCiANCjMgWzB4NTAzOGIwMzBdOiAweGE4NTQwMTAyIDB4MCAweDAgMHhj
MTAwMDAwMA0KIA0KNCBbMHg1MDM4YjA0MF06IDB4YTY1OGY4MDIgMHgwIDB4MCAweGMxMDAwMDAw
DQogDQo1IFsweDUwMzhiMDUwXTogMHhhNjU4ZWY4MiAweDAgMHgwIDB4YzEwMDAwMDANCiANCjYg
WzB4NTAzOGIwNjBdOiAweGE2NThlNzAyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KNyBbMHg1MDM4
YjA3MF06IDB4YTY1OGRlODIgMHgwIDB4MCAweGMxMDAwMDAwDQogDQo4IFsweDUwMzhiMDgwXTog
MHhhNjU4ZDYwMiAweDAgMHgwIDB4YzEwMDAwMDANCiANCjkgWzB4NTAzOGIwOTBdOiAweGE2NThj
ZDgyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMTAgWzB4NTAzOGIwYTBdOiAweGE2NThjNTAyIDB4
MCAweDAgMHhjMTAwMDAwMA0KIA0KMTEgWzB4NTAzOGIwYjBdOiAweGE2NThiYzgyIDB4MCAweDAg
MHhjMTAwMDAwMA0KIA0KMTIgWzB4NTAzOGIwYzBdOiAweGE2NThiNDAyIDB4MCAweDAgMHhjMTAw
MDAwMA0KIA0KMTMgWzB4NTAzOGIwZDBdOiAweGE2NThhYjgyIDB4MCAweDAgMHhjMTAwMDAwMA0K
IA0KMTQgWzB4NTAzOGIwZTBdOiAweGE2NThhMzAyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMTUg
WzB4NTAzOGIwZjBdOiAweGE2NTg5YTgyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMTYgWzB4NTAz
OGIxMDBdOiAweGE2NTg5MjAyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMTcgWzB4NTAzOGIxMTBd
OiAweGE2NTg4OTgyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMTggWzB4NTAzOGIxMjBdOiAweGE2
NTg4MTAyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMTkgWzB4NTAzOGIxMzBdOiAweGE0NmRmODAy
IDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMjAgWzB4NTAzOGIxNDBdOiAweGE0NmRlZjgyIDB4MCAw
eDAgMHhjMTAwMDAwMA0KIA0KMjEgWzB4NTAzOGIxNTBdOiAweGE0NmRlNzAyIDB4MCAweDAgMHhj
MTAwMDAwMA0KIA0KMjIgWzB4NTAzOGIxNjBdOiAweGE0NmRkZTgyIDB4MCAweDAgMHhjMTAwMDAw
MA0KIA0KMjMgWzB4NTAzOGIxNzBdOiAweGE0NmRkNjAyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0K
MjQgWzB4NTAzOGIxODBdOiAweGE0NmRjZDgyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMjUgWzB4
NTAzOGIxOTBdOiAweGE0NmRjNTAyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMjYgWzB4NTAzOGIx
YTBdOiAweGE0NmRiYzgyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMjcgWzB4NTAzOGIxYjBdOiAw
eGE0NmRiNDAyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMjggWzB4NTAzOGIxYzBdOiAweGE0NmRh
YjgyIDB4MCAweDAgMHhjMTAwMDAwMA0KIA0KMjkgWzB4NTAzOGIxZDBdOiAweGE0NmRhMzAyIDB4
MCAweDAgMHhjMTAwMDAwMA0KIA0KMzAgWzB4NTAzOGIxZTBdOiAweGE0NmQ5YTgyIDB4MCAweDAg
MHhjMTAwMDAwMA0KLi4uDQoNCj4gLS0tDQo+IFRoYW5rcywNCj4gSm9zZSBNaWd1ZWwgQWJyZXUN
Cg0K

