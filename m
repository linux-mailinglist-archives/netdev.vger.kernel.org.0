Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF526F42F6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbjEBLnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbjEBLn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:43:27 -0400
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3EF5260;
        Tue,  2 May 2023 04:43:21 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 9519A10C5D49;
        Tue,  2 May 2023 14:43:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 9519A10C5D49
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1683027800; bh=g9nMPuV2t04Nj1TYYz2m1R/YfuvNWdvcdKhGD9xYWOM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ARKv7XTC3RgexeweLypba3qRfZAW4UnGviPuORFvYiM+G1rJ0HweWQ+3+5XFW7LiR
         1W/ycBCa66deEj4h9XVThXDj0vGacJllb+azcC7tsDe/jukcQblVTgo5qXZoOmat7B
         FU5HQ/RF2RVLq6XtTV+syaZijNec6BoqvbQSUBP4=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id 8E26830C6672;
        Tue,  2 May 2023 14:43:19 +0300 (MSK)
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Thread-Topic: [PATCH] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Thread-Index: AQHZfOtKNP7qiBEqO0uSGzSI9t28iA==
Date:   Tue, 2 May 2023 11:43:19 +0000
Message-ID: <d0a92686-acc4-4fd8-0505-60a8394d05d8@infotecs.ru>
References: <20230426150414.2768070-1-Ilia.Gavrilov@infotecs.ru>
 <ZEwdd7Xj4fQtCXoe@corigine.com>
In-Reply-To: <ZEwdd7Xj4fQtCXoe@corigine.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB2CC5FD9002C444885CAC781D174509@infotecs.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 177105 [May 02 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 510 510 bc345371020d3ce827abc4c710f5f0ecf15eaf2e, {Tracking_msgid_8}, {Tracking_from_domain_doesnt_match_to}, infotecs.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/02 06:48:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/02 09:07:00 #21205017
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNC8yOC8yMyAyMjoyNCwgU2ltb24gSG9ybWFuIHdyb3RlOg0KPiBPbiBXZWQsIEFwciAyNiwg
MjAyMyBhdCAwMzowNDozMVBNICswMDAwLCBHYXZyaWxvdiBJbGlhIHdyb3RlOg0KPj4gY3Rfc2lw
X3BhcnNlX251bWVyaWNhbF9wYXJhbSgpIHJldHVybnMgb25seSAwIG9yIDEgbm93Lg0KPj4gQnV0
IHByb2Nlc3NfcmVnaXN0ZXJfcmVxdWVzdCgpIGFuZCBwcm9jZXNzX3JlZ2lzdGVyX3Jlc3BvbnNl
KCkgaW1wbHkNCj4+IGNoZWNraW5nIGZvciBhIG5lZ2F0aXZlIHZhbHVlIGlmIHBhcnNpbmcgb2Yg
YSBudW1lcmljYWwgaGVhZGVyIHBhcmFtZXRlcg0KPj4gZmFpbGVkLiBMZXQncyBmaXggaXQuDQo+
Pg0KPj4gRm91bmQgYnkgSW5mb1RlQ1Mgb24gYmVoYWxmIG9mIExpbnV4IFZlcmlmaWNhdGlvbiBD
ZW50ZXINCj4+IChsaW51eHRlc3Rpbmcub3JnKSB3aXRoIFNWQUNFLg0KPj4NCj4+IEZpeGVzOiAw
ZjMyYTQwZmM5MWEgKCJbTkVURklMVEVSXTogbmZfY29ubnRyYWNrX3NpcDogY3JlYXRlIHNpZ25h
bGxpbmcgZXhwZWN0YXRpb25zIikNCj4+IFNpZ25lZC1vZmYtYnk6IElsaWEuR2F2cmlsb3YgPEls
aWEuR2F2cmlsb3ZAaW5mb3RlY3MucnU+DQo+IA0KPiBIaSBHYXZyaWxvdiwNCj4gDQoNCkhpIFNp
bW9uLCB0aGFuayB5b3UgZm9yIHlvdXIgYW5zd2VyLg0KDQo+IGFsdGhvdWdoIGl0IGlzIGEgc2xp
Z2h0bHkgdW51c3VhbCBjb252ZW50aW9uIGZvciBrZXJuZWwgY29kZSwNCj4gSSBiZWxpZXZlIHRo
ZSBpbnRlbnRpb24gaXMgdGhhdCB0aGlzIGZ1bmN0aW9uIHJldHVybnMgMCB3aGVuDQo+IGl0IGZh
aWxzICh0byBwYXJzZSkgYW5kIDEgb24gc3VjY2Vzcy4gU28gSSB0aGluayB0aGF0IHBhcnQgaXMg
ZmluZS4NCj4gDQo+IFdoYXQgc2VlbXMgYSBiaXQgYnJva2VuIGlzIHRoZSB3YXkgdGhhdCBjYWxs
ZXJzIHVzZSB0aGUgcmV0dXJuIHZhbHVlLg0KPiANCj4gMS4gVGhlIGNhbGwgaW4gcHJvY2Vzc19y
ZWdpc3Rlcl9yZXNwb25zZSgpIGxvb2tzIGxpa2UgdGhpczoNCj4gDQo+IAlyZXQgPSBjdF9zaXBf
cGFyc2VfbnVtZXJpY2FsX3BhcmFtKC4uLikNCj4gCWlmIChyZXQgPCAwKSB7DQo+IAkJbmZfY3Rf
aGVscGVyX2xvZyhza2IsIGN0LCAiY2Fubm90IHBhcnNlIGV4cGlyZXMiKTsNCj4gCQlyZXR1cm4g
TkZfRFJPUDsNCj4gCX0NCj4gDQo+ICAgICAgQnV0IHJldCBjYW4gb25seSBiZSAwIG9yIDEsIHNv
IHRoZSBlcnJvciBoYW5kbGluZyBpcyBuZXZlciBpbm9rZWQsDQo+ICAgICAgYW5kIGEgZmFpbHVy
ZSB0byBwYXJzZSBpcyBpZ25vcmVkLiBJIGd1ZXNzIGZhaWx1cmUgZG9lc24ndCBvY2N1ciBpbg0K
PiAgICAgIHByYWN0aWNlLg0KPiANCj4gICAgICBJIHN1c3BlY3QgdGhpcyBzaG91bGQgYmU6DQo+
IA0KPiAJcmV0ID0gY3Rfc2lwX3BhcnNlX251bWVyaWNhbF9wYXJhbSguLi4pDQo+IAlpZiAoIXJl
dCkgew0KPiAJCW5mX2N0X2hlbHBlcl9sb2coc2tiLCBjdCwgImNhbm5vdCBwYXJzZSBleHBpcmVz
Iik7DQo+IAkJcmV0dXJuIE5GX0RST1A7DQo+IAl9DQo+IA0KDQpjdF9zaXBfcGFyc2VfbnVtZXJp
Y2FsX3BhcmFtKCkgcmV0dXJucyAwIGluIHRvIGNhc2VzIDEpIHdoZW4gdGhlIA0KcGFyYW1ldGVy
ICdleHBpcmVzPScgaXNuJ3QgZm91bmQgaW4gdGhlIGhlYWRlciBvciAyKSBpdCdzIGluY29ycmVj
dGx5IHNldC4NCkluIHRoZSBmaXJzdCBjYXNlLCB0aGUgcmV0dXJuIHZhbHVlIHNob3VsZCBiZSBp
Z25vcmVkLCBzaW5jZSB0aGlzIGlzIGEgDQpub3JtYWwgc2l0dWF0aW9uDQpJbiB0aGUgc2Vjb25k
IGNhc2UsIGl0J3MgYmV0dGVyIHRvIHdyaXRlIHRvIHRoZSBsb2cgYW5kIHJldHVybiBORl9EUk9Q
LCANCm9yIGlnbm9yZSBpdCB0b28sIHRoZW4gY2hlY2tpbmcgdGhlIHJldHVybiB2YWx1ZSBjYW4g
YmUgcmVtb3ZlZCBhcyANCnVubmVjZXNzYXJ5Lg0KDQoNCj4gMi4gVGhlIGNhbGxwcm9jZXNzX3Jl
Z2lzdGVyX3JlcXVlc3QoKSBsb29rcyBsaWtlIHRoaXM6DQo+IA0KPiAgICAgICAgICBpZiAoY3Rf
c2lwX3BhcnNlX251bWVyaWNhbF9wYXJhbSguLi4pKSB7DQo+ICAgICAgICAgICAgICAgICAgbmZf
Y3RfaGVscGVyX2xvZyhza2IsIGN0LCAiY2Fubm90IHBhcnNlIGV4cGlyZXMiKTsNCj4gICAgICAg
ICAgICAgICAgICByZXR1cm4gTkZfRFJPUDsNCj4gICAgICAgICAgfQ0KPiANCj4gICAgIEJ1dCB0
aGlzIHNlZW1zIHRvIHRyZWF0IHN1Y2Nlc3MgYXMgYW4gZXJyb3IgYW5kIHZpY2UgdmVyc2EuDQo+
IA0KPiAgICAgICAgICBpZiAoIWN0X3NpcF9wYXJzZV9udW1lcmljYWxfcGFyYW0oLi4uKSkgew0K
PiAgICAgICAgICAgICAgICAgIG5mX2N0X2hlbHBlcl9sb2coc2tiLCBjdCwgImNhbm5vdCBwYXJz
ZSBleHBpcmVzIik7DQo+ICAgICAgICAgICAgICAgICAgcmV0dXJuIE5GX0RST1A7DQo+ICAgICAg
ICAgIH0NCj4gDQo+ICAgIE9yLCBiZXR0ZXI6DQo+IA0KPiAgICAgICAgICByZXQgPSBjdF9zaXBf
cGFyc2VfbnVtZXJpY2FsX3BhcmFtKC4uLik7DQo+IAlpZiAoIXJldCkgew0KPiAJCS4uLg0KPiAJ
fQ0KPiANCg0KSGVyZSBpcyB0aGUgc2FtZSBhcyBpbiBwcm9jZXNzX3JlZ2lzdGVyX3Jlc3BvbnNl
KCkNCg0KcmV0ID0gY3Rfc2lwX3BhcnNlX251bWVyaWNhbF9wYXJhbSguLi4pOw0KaWYgKHJldCA8
IDApIHsNCiAgICAuLi4NCiAgICByZXR1cm4gTkZfRFJPUDsNCn0NCg0KTWF5YmUgaXQncyBiZXR0
ZXIgdG8gcmVtb3ZlIHRoZSBjaGVjayBhbHRvZ2V0aGVyPw0KDQoNCg0KPiANCj4gMy4gVGhlIGlu
dm9jYXRpb24gaW4gbmZfbmF0X3NpcCgpIGxvb2tzIGxpa2UgdGhpczoNCj4gDQo+IAlpZiAoY3Rf
c2lwX3BhcnNlX251bWVyaWNhbF9wYXJhbSguLi4pID4gMCAmJg0KPiAJICAgIC4uLikNCj4gCSAg
ICAuLi4NCj4gDQo+ICAgICBUaGlzIHNlZW1zIGNvcnJlY3QgdG8gbWUuDQoNCkkgYWdyZWUsIGV2
ZXJ5dGhpbmcgc2VlbXMgY29ycmVjdCBoZXJlDQoNCj4gDQo+PiAtLS0NCj4+ICAgbmV0L25ldGZp
bHRlci9uZl9jb25udHJhY2tfc2lwLmMgfCAyICstDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9uZXQvbmV0Zmls
dGVyL25mX2Nvbm50cmFja19zaXAuYyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3NpcC5j
DQo+PiBpbmRleCA3N2Y1ZTgyZDhlM2YuLmQwZWFjMjdmNmJhMCAxMDA2NDQNCj4+IC0tLSBhL25l
dC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3NpcC5jDQo+PiArKysgYi9uZXQvbmV0ZmlsdGVyL25m
X2Nvbm50cmFja19zaXAuYw0KPj4gQEAgLTYxMSw3ICs2MTEsNyBAQCBpbnQgY3Rfc2lwX3BhcnNl
X251bWVyaWNhbF9wYXJhbShjb25zdCBzdHJ1Y3QgbmZfY29ubiAqY3QsIGNvbnN0IGNoYXIgKmRw
dHIsDQo+PiAgIAlzdGFydCArPSBzdHJsZW4obmFtZSk7DQo+PiAgIAkqdmFsID0gc2ltcGxlX3N0
cnRvdWwoc3RhcnQsICZlbmQsIDApOw0KPj4gICAJaWYgKHN0YXJ0ID09IGVuZCkNCj4+IC0JCXJl
dHVybiAwOw0KPj4gKwkJcmV0dXJuIC0xOw0KPj4gICAJaWYgKG1hdGNob2ZmICYmIG1hdGNobGVu
KSB7DQo+PiAgIAkJKm1hdGNob2ZmID0gc3RhcnQgLSBkcHRyOw0KPj4gICAJCSptYXRjaGxlbiA9
IGVuZCAtIHN0YXJ0Ow0KPj4gLS0gDQo+PiAyLjMwLjINCj4+DQoNCg==
