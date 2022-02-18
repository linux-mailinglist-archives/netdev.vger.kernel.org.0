Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651C54BBC76
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237140AbiBRPur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:50:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237211AbiBRPuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:50:46 -0500
Received: from m2.came.com (m2.came.com [185.158.232.192])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D56D2C663
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 07:50:25 -0800 (PST)
X-Envelope-From: <rferrazzo@came.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=came.com; s=hqs1;
        t=1645199415; bh=q6QFR4wFKzZN4oRBk8KBFG9epo/vvtWvpCpYh6Ehr0o=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=Wtch1HJ/vXsf71CQqP7cYJRoWx32CrMOKQhAnvMIOLaqC+wWFmvoP6WEwMn/H3VmR
         gLofc0taron60T+2IhAwfKAdmr4dZqZJOWaJYU1UlG+nJNvMG/PbKIEJveK+flk9Wb
         RpftE2vORKPIQ4xPuK86dCVwZnGINpwTFfPjEdLA=
Received: from mail.came.com (exch.camegroup.local [172.17.10.18])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by m2.came.com (Postfix) with ESMTPS id D335A41ADF;
        Fri, 18 Feb 2022 16:50:15 +0100 (CET)
Received: from EXCH01SERVER.camegroup.local (172.17.10.18) by
 EXCH01SERVER.camegroup.local (172.17.10.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Fri, 18 Feb 2022 16:50:15 +0100
Received: from EXCH01SERVER.camegroup.local ([fe80::4c87:c04d:9e86:91dc]) by
 EXCH01SERVER.camegroup.local ([fe80::4c87:c04d:9e86:91dc%8]) with mapi id
 15.01.2375.018; Fri, 18 Feb 2022 16:50:15 +0100
From:   Riccardo Ferrazzo <rferrazzo@came.com>
To:     =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] staging: wfx: fix scan with WFM200 and WW regulation
Thread-Topic: [PATCH] staging: wfx: fix scan with WFM200 and WW regulation
Thread-Index: AQHYJLXqgTJEtVhygkqmI4jmjTDnvqyZEoqAgAAA3wCAAAMMAIAAPNCo///zhgCAACzfmQ==
Date:   Fri, 18 Feb 2022 15:50:15 +0000
Message-ID: <00c200c56dad4b1180d644e740112706@came.com>
References: <20220218105358.283769-1-Jerome.Pouiller@silabs.com>
 <3527203.aO2mCyqpp7@pc-42>
 <5feac65fc71f4060abb7421ee4571af4@came.com>,<3633390.6h3MoT29mx@pc-42>
In-Reply-To: <3633390.6h3MoT29mx@pc-42>
Accept-Language: it-IT, en-US
Content-Language: it-IT
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.244.98]
x-c2processedorg: a31d4ad1-e59b-425b-8b09-d5eff97e4ea3
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CAME-Libra-ESVA-Information: Please contact CAME for more information
X-CAME-Libra-ESVA-ID: D335A41ADF.ADE9C
X-CAME-Libra-ESVA: No virus found
X-CAME-Libra-ESVA-From: rferrazzo@came.com
X-CAME-Libra-ESVA-Watermark: 1645804218.74232@4mG+8eCEAtX6cMEcm+BxEA
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PkRhOiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+DQo+SW52
aWF0bzogdmVuZXJkw6wgMTggZmViYnJhaW8gMjAyMiAxNTowNA0KPkE6IEdyZWcgS3JvYWgtSGFy
dG1hbjsgUmljY2FyZG8gRmVycmF6em8NCj5DYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwu
b3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBLYWxsZSBWYWxvOyBkZXZlbEBkcml2ZXJkZXYu
b3N1b3NsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgRGF2aWQgUyAuIE1pbGxl
cg0KPk9nZ2V0dG86IFJlOiBbUEFUQ0hdIHN0YWdpbmc6IHdmeDogZml4IHNjYW4gd2l0aCBXRk0y
MDAgYW5kIFdXIHJlZ3VsYXRpb24NCj4NCj5IZWxsbyBSaWNjYXJkbywNCj4NCj4NCj5PbiBGcmlk
YXkgMTggRmVicnVhcnkgMjAyMiAxNDo1MzozNSBDRVQgUmljY2FyZG8gRmVycmF6em8gd3JvdGU6
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogUmljY2FyZG8gRmVycmF6em8gPHJmZXJyYXp6b0BjYW1l
LmNvbT4NCj4+DQo+Pg0KPj4gU29ycnkgZm9yIHRoZSBmb290ZXIgaXQgaXMgYWRkZWQgYXV0b21h
dGljYWxseQ0KPj4NCj4NCj5Zb3VyIG1haWwgaGFzIHByb2JhYmx5IG5vdCBiZWVuIHJlY2VpdmVk
IGJ5IGV2ZXJ5b25lIHNpbmNlIHlvdSBzZW50IGl0DQo+aW4gaHRtbFsxXSAodHJ5IGFsc28gdG8g
YXZvaWQgdG9wLXBvc3RpbmcpLg0KPg0KPk5ldmVydGhlbGVzcywgR3JlZywgaXMgaXQgc3VmZmlj
aWVudCBmb3IgeW91Pw0KPg0KPlsxXTogIGh0dHBzOi8vdXJsc2FuZC5lc3ZhbGFicy5jb20vP3U9
aHR0cHMlM0ElMkYlMkZ1c2VwbGFpbnRleHQuZW1haWwlMkYmZT0wOTczM2Y5NCZoPTFlYzU1NzFl
JmY9eSZwPW4NCj4NCj4+IE9uIEZyaWRheSAxOCBGZWJydWFyeSAyMDIyIDEyOjAwOjU0IENFVCBH
cmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+PiA+IE9uIEZyaSwgRmViIDE4LCAyMDIyIGF0IDEx
OjU3OjQ3QU0gKzAxMDAsIErDqXLDtG1lIFBvdWlsbGVyIHdyb3RlOg0KPj4gPiA+IE9uIEZyaWRh
eSAxOCBGZWJydWFyeSAyMDIyIDExOjUzOjU4IENFVCBKZXJvbWUgUG91aWxsZXIgd3JvdGU6DQo+
PiA+ID4NCg0KUmljY2FyZG8gRmVycmF6em8NClImRCBTb2Z0d2FyZSBEZXNpZ25lcg0KcmZlcnJh
enpvQGNhbWUuY29tDQpDQU1FIFMucC5BLg0KDQo+IEZyb206IFJpY2NhcmRvIEZlcnJhenpvIDxy
ZmVycmF6em9AY2FtZS5jb20+DQo+PiA+ID4gPg0KPj4gPiA+ID4gU29tZSB2YXJpYW50cyBvZiB0
aGUgV0YyMDAgZGlzYWxsb3cgYWN0aXZlIHNjYW4gb24gY2hhbm5lbCAxMiBhbmQgMTMuDQo+PiA+
ID4gPiBGb3IgdGhlc2UgcGFydHMsIHRoZSBjaGFubmVscyAxMiBhbmQgMTMgYXJlIG1hcmtlZCBJ
RUVFODAyMTFfQ0hBTl9OT19JUi4NCj4+ID4gPiA+DQo+PiA+ID4gPiBIb3dldmVyLCB0aGUgYmVh
Y29uIGhpbnQgcHJvY2VkdXJlIHdhcyByZW1vdmluZyB0aGUgZmxhZw0KPj4gPiA+ID4gSUVFRTgw
MjExX0NIQU5fTk9fSVIgZnJvbSBjaGFubmVscyB3aGVyZSBhIEJTUyBpcyBkaXNjb3ZlcmVkLiBU
aGlzIHdhcw0KPj4gPiA+ID4gbWFraW5nIHN1YnNlcXVlbnQgc2NhbnMgdG8gZmFpbCBiZWNhdXNl
IHRoZSBkcml2ZXIgd2FzIHRyeWluZyBhY3RpdmUNCj4+ID4gPiA+IHNjYW5zIG9uIHByb2hpYml0
ZWQgY2hhbm5lbHMuDQo+PiA+ID4gPg0KPj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KPj4gPiA+DQo+PiA+ID4gSSBm
b3Jnb3QgdG8gbWVudGlvbiBJIGhhdmUgcmV2aWV3ZWQgb24gdGhpcyBwYXRjaDoNCj4+ID4gPg0K
Pj4gPiA+IFJldmlld2VkLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNp
bGFicy5jb20+DQo+PiA+DQo+PiA+IFJldml3ZWQtYnkgaXMgaW1wbGllZCB3aXRoIHNpZ25lZC1v
ZmYtYnkuDQo+PiA+DQo+PiA+IEJ1dCB3aGF0IGhhcHBlbmVkIHRvIHRoZSBzaWduZWQtb2ZmLWJ5
IGZyb20gdGhlIGF1dGhvciBvZiB0aGlzIGNoYW5nZT8NCj4+DQo+PiBUaGUgYXV0aG9yIGhhc24n
dCB1c2VkIGZvcm1hdC1wYXRjaCB0byB0cmFuc21pdCB0aGlzIHBhdGNoLg0KPj4NCj4+IFJpY2Nh
cmRvLCBjYW4geW91IHJlcGx5IHRvIHRoaXMgbWFpbCB3aXRoIHRoZSBtZW50aW9uICJTaWduZWQt
b2ZmLWJ5Og0KPj4gWW91ciBuYW1lIDx5b3VyLW1haWxAZG9tLmNvbT4iPyBJdCBjZXJ0aWZpZXMg
dGhhdCB5b3Ugd3JvdGUgaXQgb3INCj4+IG90aGVyd2lzZSBoYXZlIHRoZSByaWdodCB0byBwYXNz
IGl0IG9uIGFzIGFuIG9wZW4tc291cmNlIHBhdGNoWzFdLg0KPj4NCj4+DQo+PiBbMV0gIGh0dHBz
Oi8vdXJsc2FuZC5lc3ZhbGFicy5jb20vP3U9aHR0cHMlM0ElMkYlMkZ3d3cua2VybmVsLm9yZyUy
RmRvYyUyRmh0bWwlMkZ2NC4xNyUyRnByb2Nlc3MlMkZzdWJtaXR0aW5nLXBhdGNoZXMuaHRtbCUy
M3NpZ24teW91ci13b3JrLXRoZS1kZXZlbG9wZXItcy1jZXJ0aWZpY2F0ZS1vZi1vcmlnaW4mZT0w
OTczM2Y5NCZoPWUwOWYyZWZhJmY9eSZwPW48aHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0
dHBzOi8vdXJsc2FuZC5lc3ZhbGFicy5jb20vP3U9aHR0cHMqM0EqMkYqMkZ3d3cua2VybmVsLm9y
ZyoyRmRvYyoyRmh0bWwqMkZ2NC4xNyoyRnByb2Nlc3MqMkZzdWJtaXR0aW5nLXBhdGNoZXMuaHRt
bCoyM3NpZ24teW91ci13b3JrLXRoZS1kZXZlbG9wZXItcy1jZXJ0aWZpY2F0ZS1vZi1vcmlnaW4m
ZT0wOTczM2Y5NCZoPWUwOWYyZWZhJmY9eSZwPW5fXztKU1VsSlNVbEpTVWwhIU4zMENzN0pyIUdS
Z0JfSmxoWkYyWHphREVCMVpEblNiTGlNbUQ4WGRybUNfdXF5TG9jelI1ZTA1dnZNbERDZ3lLbEV1
M1h5STNQZEpLJD4NCj4+DQo+PiBUaGFuayB5b3UsDQo+Pg0KPj4gLS0NCj4+IErDqXLDtG1lIFBv
dWlsbGVyDQo+Pg0KPj4NCj4+DQo+DQo+LS0NCj5Kw6lyw7RtZSBQb3VpbGxlcg0KDQpNaWdodCBs
b29rIGJldHRlciBub3cNClNpZ25lZC1vZmYtYnk6IFJpY2NhcmRvIEZlcnJhenpvIDxyZmVycmF6
em9AY2FtZS5jb20+DQo=
