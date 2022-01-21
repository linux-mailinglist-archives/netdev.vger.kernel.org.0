Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF5495B9B
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379152AbiAUIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 03:12:48 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:52813 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343642AbiAUIMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 03:12:45 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20L8A8keC004318, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20L8A8keC004318
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 16:10:08 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 21 Jan 2022 16:10:08 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 00:10:08 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Fri, 21 Jan 2022 16:10:07 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ed Swierk <eswierk@gh.st>
Subject: RE: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Thread-Topic: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Thread-Index: AQHYBCp/WStseF16x0uJ7VAbWo+1y6xqJTFAgAMM/BA=
Date:   Fri, 21 Jan 2022 08:10:07 +0000
Message-ID: <423f474e15c948eda4db5bc9a50fd391@realtek.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com> 
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/1/21_=3F=3F_07:29:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: multipart/mixed;
        boundary="_002_423f474e15c948eda4db5bc9a50fd391realtekcom_"
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_423f474e15c948eda4db5bc9a50fd391realtekcom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


> -----Original Message-----
> From: Pkshih
> Sent: Wednesday, January 19, 2022 5:38 PM
> To: 'Martin Blumenstingl' <martin.blumenstingl@googlemail.com>; linux-wir=
eless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@codeaurora.org; johannes@sipsolutions.n=
et; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Neo Jou <neojou@gmail.com>; Jernej Skrabec =
<jernej.skrabec@gmail.com>; Ed
> Swierk <eswierk@gh.st>
> Subject: RE: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
>=20
> Hi,
>=20
> > -----Original Message-----
> > From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > Sent: Saturday, January 8, 2022 8:55 AM
> > To: linux-wireless@vger.kernel.org
> > Cc: tony0620emma@gmail.com; kvalo@codeaurora.org; johannes@sipsolutions=
.net; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Neo Jou <neojou@gmail.com>; Jernej Skrabe=
c <jernej.skrabec@gmail.com>;
> > Pkshih <pkshih@realtek.com>; Ed Swierk <eswierk@gh.st>; Martin Blumenst=
ingl
> > <martin.blumenstingl@googlemail.com>
> > Subject: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
> >
>=20
> [...]
>=20
> I do stressed test of connection and suspend, and it get stuck after abou=
t
> 4 hours but no useful messages. I will re-build my kernel and turn on loc=
kdep debug
> to see if it can tell me what is wrong.
>=20

I found some deadlock:=20

[ 4891.169653]        CPU0                    CPU1
[ 4891.169732]        ----                    ----
[ 4891.169799]   lock(&rtwdev->mutex);
[ 4891.169874]                                lock(&local->sta_mtx);
[ 4891.169948]                                lock(&rtwdev->mutex);
[ 4891.170050]   lock(&local->sta_mtx);


[ 4919.598630]        CPU0                    CPU1
[ 4919.598715]        ----                    ----
[ 4919.598779]   lock(&local->iflist_mtx);
[ 4919.598900]                                lock(&rtwdev->mutex);
[ 4919.598995]                                lock(&local->iflist_mtx);
[ 4919.599092]   lock(&rtwdev->mutex);

So, I add wrappers to iterate rtw_iterate_stas() and rtw_iterate_vifs() tha=
t
use _atomic version to collect sta and vif, and use list_for_each() to iter=
ate.
Reference code is attached, and I'm still thinking if we can have better me=
thod.

--
Ping-Ke


--_002_423f474e15c948eda4db5bc9a50fd391realtekcom_
Content-Type: application/octet-stream;
	name="0001-rtw88-use-atomic-to-collect-stas-and-does-iterators.patch"
Content-Description: 0001-rtw88-use-atomic-to-collect-stas-and-does-iterators.patch
Content-Disposition: attachment;
	filename="0001-rtw88-use-atomic-to-collect-stas-and-does-iterators.patch";
	size=4314; creation-date="Fri, 21 Jan 2022 06:33:40 GMT";
	modification-date="Fri, 21 Jan 2022 06:33:39 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjOTUzOWVhNWZiYmQ2OTIwMzAzODFhNDJhZDMxZTA4NDkwZjViODA0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4KRGF0
ZTogRnJpLCAyMSBKYW4gMjAyMiAxMTowOTo0NSArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHJ0dzg4
OiB1c2UgYXRvbWljIHRvIGNvbGxlY3Qgc3RhcyBhbmQgZG9lcyBpdGVyYXRvcnMKCkNoYW5nZS1J
ZDogSTc2NjUyNjhkMGNhODU5ZDRlM2MzYTYwYjFmMTViNzZmNTQ0NGYwYWIKU2lnbmVkLW9mZi1i
eTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+Ci0tLQogdXRpbC5jIHwgOTIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwog
dXRpbC5oIHwgMTMgKysrKystLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDEwMCBpbnNlcnRpb25zKCsp
LCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3V0aWwuYyBiL3V0aWwuYwppbmRleCAyYzUx
NWFmMi4uMTgzNTk2OGYgMTAwNjQ0Ci0tLSBhL3V0aWwuYworKysgYi91dGlsLmMKQEAgLTEwNSwz
ICsxMDUsOTUgQEAgdm9pZCBydHdfZGVzY190b19tY3NyYXRlKHUxNiByYXRlLCB1OCAqbWNzLCB1
OCAqbnNzKQogCQkqbWNzID0gcmF0ZSAtIERFU0NfUkFURU1DUzA7CiAJfQogfQorCitzdHJ1Y3Qg
cnR3X3N0YXNfZW50cnkgeworCXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsKKwlzdHJ1Y3QgaWVlZTgw
MjExX3N0YSAqc3RhOworfTsKKworc3RydWN0IHJ0d19pdGVyX3N0YXNfZGF0YSB7CisJc3RydWN0
IHJ0d19kZXYgKnJ0d2RldjsKKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7Cit9OworCit2b2lkIHJ0
d19jb2xsZWN0X3N0YV9pdGVyKHZvaWQgKmRhdGEsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEp
Cit7CisJc3RydWN0IHJ0d19pdGVyX3N0YXNfZGF0YSAqaXRlcl9zdGFzID0gKHN0cnVjdCBydHdf
aXRlcl9zdGFzX2RhdGEgKilkYXRhOworCXN0cnVjdCBydHdfc3Rhc19lbnRyeSAqc3Rhc19lbnRy
eTsKKworCXN0YXNfZW50cnkgPSBrbWFsbG9jKHNpemVvZigqc3Rhc19lbnRyeSksIEdGUF9BVE9N
SUMpOworCWlmICghc3Rhc19lbnRyeSkKKwkJcmV0dXJuOworCisJc3Rhc19lbnRyeS0+c3RhID0g
c3RhOworCWxpc3RfYWRkX3RhaWwoJnN0YXNfZW50cnktPmxpc3QsICZpdGVyX3N0YXMtPmxpc3Qp
OworfQorCit2b2lkIHJ0d19pdGVyYXRlX3N0YXMoc3RydWN0IHJ0d19kZXYgKnJ0d2RldiwKKwkJ
ICAgICAgdm9pZCAoKml0ZXJhdG9yKSh2b2lkICpkYXRhLAorCQkJCSAgICAgICBzdHJ1Y3QgaWVl
ZTgwMjExX3N0YSAqc3RhKSwKKwkJCQkgICAgICAgdm9pZCAqZGF0YSkKK3sKKwlzdHJ1Y3QgcnR3
X2l0ZXJfc3Rhc19kYXRhIGl0ZXJfZGF0YTsKKwlzdHJ1Y3QgcnR3X3N0YXNfZW50cnkgKnN0YV9l
bnRyeSwgKnRtcDsKKworCWl0ZXJfZGF0YS5ydHdkZXYgPSBydHdkZXY7CisJSU5JVF9MSVNUX0hF
QUQoJml0ZXJfZGF0YS5saXN0KTsKKworCWllZWU4MDIxMV9pdGVyYXRlX3N0YXRpb25zX2F0b21p
YyhydHdkZXYtPmh3LCBydHdfY29sbGVjdF9zdGFfaXRlciwKKwkJCQkJICAmaXRlcl9kYXRhKTsK
KworCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShzdGFfZW50cnksIHRtcCwgJml0ZXJfZGF0YS5s
aXN0LAorCQkJCSBsaXN0KSB7CisJCWxpc3RfZGVsX2luaXQoJnN0YV9lbnRyeS0+bGlzdCk7CisJ
CWl0ZXJhdG9yKGRhdGEsIHN0YV9lbnRyeS0+c3RhKTsKKwkJa2ZyZWUoc3RhX2VudHJ5KTsKKwl9
Cit9CisKK3N0cnVjdCBydHdfdmlmc19lbnRyeSB7CisJc3RydWN0IGxpc3RfaGVhZCBsaXN0Owor
CXN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWY7CisJdTggbWFjW0VUSF9BTEVOXTsKK307CisKK3N0
cnVjdCBydHdfaXRlcl92aWZzX2RhdGEgeworCXN0cnVjdCBydHdfZGV2ICpydHdkZXY7CisJc3Ry
dWN0IGxpc3RfaGVhZCBsaXN0OworfTsKKwordm9pZCBydHdfY29sbGVjdF92aWZfaXRlcih2b2lk
ICpkYXRhLCB1OCAqbWFjLCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQoreworCXN0cnVjdCBy
dHdfaXRlcl92aWZzX2RhdGEgKml0ZXJfc3RhcyA9IChzdHJ1Y3QgcnR3X2l0ZXJfdmlmc19kYXRh
ICopZGF0YTsKKwlzdHJ1Y3QgcnR3X3ZpZnNfZW50cnkgKnZpZnNfZW50cnk7CisKKwl2aWZzX2Vu
dHJ5ID0ga21hbGxvYyhzaXplb2YoKnZpZnNfZW50cnkpLCBHRlBfQVRPTUlDKTsKKwlpZiAoIXZp
ZnNfZW50cnkpCisJCXJldHVybjsKKworCXZpZnNfZW50cnktPnZpZiA9IHZpZjsKKwlldGhlcl9h
ZGRyX2NvcHkodmlmc19lbnRyeS0+bWFjLCBtYWMpOworCWxpc3RfYWRkX3RhaWwoJnZpZnNfZW50
cnktPmxpc3QsICZpdGVyX3N0YXMtPmxpc3QpOworfQorCit2b2lkIHJ0d19pdGVyYXRlX3ZpZnMo
c3RydWN0IHJ0d19kZXYgKnJ0d2RldiwKKwkJICAgICAgdm9pZCAoKml0ZXJhdG9yKSh2b2lkICpk
YXRhLCB1OCAqbWFjLAorCQkJCSAgICAgICBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKSwKKwkJ
ICAgICAgdm9pZCAqZGF0YSkKK3sKKwlzdHJ1Y3QgcnR3X2l0ZXJfdmlmc19kYXRhIGl0ZXJfZGF0
YTsKKwlzdHJ1Y3QgcnR3X3ZpZnNfZW50cnkgKnZpZl9lbnRyeSwgKnRtcDsKKworCWl0ZXJfZGF0
YS5ydHdkZXYgPSBydHdkZXY7CisJSU5JVF9MSVNUX0hFQUQoJml0ZXJfZGF0YS5saXN0KTsKKwor
CWllZWU4MDIxMV9pdGVyYXRlX2FjdGl2ZV9pbnRlcmZhY2VzX2F0b21pYyhydHdkZXYtPmh3LAor
CQkJSUVFRTgwMjExX0lGQUNFX0lURVJfTk9STUFMLCBydHdfY29sbGVjdF92aWZfaXRlciwgJml0
ZXJfZGF0YSk7CisKKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUodmlmX2VudHJ5LCB0bXAsICZp
dGVyX2RhdGEubGlzdCwKKwkJCQkgbGlzdCkgeworCQlsaXN0X2RlbF9pbml0KCZ2aWZfZW50cnkt
Pmxpc3QpOworCQlpdGVyYXRvcihkYXRhLCB2aWZfZW50cnktPm1hYywgdmlmX2VudHJ5LT52aWYp
OworCQlrZnJlZSh2aWZfZW50cnkpOworCX0KK30KZGlmZiAtLWdpdCBhL3V0aWwuaCBiL3V0aWwu
aAppbmRleCAwNmE1YjRjNC4uZTQ5OTVkYmEgMTAwNjQ0Ci0tLSBhL3V0aWwuaAorKysgYi91dGls
LmgKQEAgLTcsMTggKzcsMjEgQEAKIAogc3RydWN0IHJ0d19kZXY7CiAKLSNkZWZpbmUgcnR3X2l0
ZXJhdGVfdmlmcyhydHdkZXYsIGl0ZXJhdG9yLCBkYXRhKSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBcCi0JaWVlZTgwMjExX2l0ZXJhdGVfYWN0aXZlX2ludGVyZmFjZXMocnR3ZGV2LT5o
dywgICAgICAgICAgICAgICAgICAgICAgICBcCi0JCQlJRUVFODAyMTFfSUZBQ0VfSVRFUl9OT1JN
QUwsIGl0ZXJhdG9yLCBkYXRhKQogI2RlZmluZSBydHdfaXRlcmF0ZV92aWZzX2F0b21pYyhydHdk
ZXYsIGl0ZXJhdG9yLCBkYXRhKSAgICAgICAgICAgICAgICAgICAgICAgIFwKIAlpZWVlODAyMTFf
aXRlcmF0ZV9hY3RpdmVfaW50ZXJmYWNlc19hdG9taWMocnR3ZGV2LT5odywgICAgICAgICAgICAg
ICAgIFwKIAkJCUlFRUU4MDIxMV9JRkFDRV9JVEVSX05PUk1BTCwgaXRlcmF0b3IsIGRhdGEpCi0j
ZGVmaW5lIHJ0d19pdGVyYXRlX3N0YXMocnR3ZGV2LCBpdGVyYXRvciwgZGF0YSkgICAgICAgICAg
ICAgICAgICAgICAgICBcCi0JaWVlZTgwMjExX2l0ZXJhdGVfc3RhdGlvbnMocnR3ZGV2LT5odywg
aXRlcmF0b3IsIGRhdGEpCiAjZGVmaW5lIHJ0d19pdGVyYXRlX3N0YXNfYXRvbWljKHJ0d2Rldiwg
aXRlcmF0b3IsIGRhdGEpICAgICAgICAgICAgICAgICAgICAgICAgXAogCWllZWU4MDIxMV9pdGVy
YXRlX3N0YXRpb25zX2F0b21pYyhydHdkZXYtPmh3LCBpdGVyYXRvciwgZGF0YSkKICNkZWZpbmUg
cnR3X2l0ZXJhdGVfa2V5cyhydHdkZXYsIHZpZiwgaXRlcmF0b3IsIGRhdGEpCQkJICAgICAgIFwK
IAlpZWVlODAyMTFfaXRlcl9rZXlzKHJ0d2Rldi0+aHcsIHZpZiwgaXRlcmF0b3IsIGRhdGEpCit2
b2lkIHJ0d19pdGVyYXRlX3ZpZnMoc3RydWN0IHJ0d19kZXYgKnJ0d2RldiwKKwkJICAgICAgdm9p
ZCAoKml0ZXJhdG9yKSh2b2lkICpkYXRhLCB1OCAqbWFjLAorCQkJCSAgICAgICBzdHJ1Y3QgaWVl
ZTgwMjExX3ZpZiAqdmlmKSwKKwkJICAgICAgdm9pZCAqZGF0YSk7Cit2b2lkIHJ0d19pdGVyYXRl
X3N0YXMoc3RydWN0IHJ0d19kZXYgKnJ0d2RldiwKKwkJICAgICAgdm9pZCAoKml0ZXJhdG9yKSh2
b2lkICpkYXRhLAorCQkJCSAgICAgICBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhKSwKKwkJCQkg
ICAgICAgdm9pZCAqZGF0YSk7CiAKIHN0YXRpYyBpbmxpbmUgdTggKmdldF9oZHJfYnNzaWQoc3Ry
dWN0IGllZWU4MDIxMV9oZHIgKmhkcikKIHsKLS0gCjIuMjUuMQoK

--_002_423f474e15c948eda4db5bc9a50fd391realtekcom_--
