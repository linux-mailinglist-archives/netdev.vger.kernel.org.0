Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8576F45E4
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjEBOQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbjEBOQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:16:22 -0400
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5733E213B;
        Tue,  2 May 2023 07:16:12 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 19006104DE37;
        Tue,  2 May 2023 17:16:10 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 19006104DE37
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1683036970; bh=NwsFmQbz6+BlOslnoZBwnd+UN0Kf3zXVR+E1nVgTkbY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=EfEqAwYgrXVeQBqatxuixlqFGEhgtgu91+1qDnZLSYNld8Nb4NsLNhaUXBySzTogx
         Tg+u68MhCORXKIrcSb+hKaw8HTpYhQxfsKmY+81ubuXMx8ds46szQGfRnWSzbdMMGO
         14hPzQYyeK098Be36AwGsIXi/h8j7H0eQD85SIeQ=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id 134AA30C6665;
        Tue,  2 May 2023 17:16:10 +0300 (MSK)
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
Thread-Index: AQHZfQCkdQ1jdCkRDECme4NmEhZirw==
Date:   Tue, 2 May 2023 14:16:09 +0000
Message-ID: <f9d9ac80-704a-91d7-b120-449b921e8bb0@infotecs.ru>
References: <20230426150414.2768070-1-Ilia.Gavrilov@infotecs.ru>
 <ZEwdd7Xj4fQtCXoe@corigine.com>
 <d0a92686-acc4-4fd8-0505-60a8394d05d8@infotecs.ru>
 <ZFEYpNsp/hBEJAGU@corigine.com>
In-Reply-To: <ZFEYpNsp/hBEJAGU@corigine.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="utf-8"
Content-ID: <26420190B9CF824AA0E72485EDA55D01@infotecs.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 177122 [May 02 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 510 510 bc345371020d3ce827abc4c710f5f0ecf15eaf2e, {Tracking_msgid_8}, {Tracking_from_domain_doesnt_match_to}, infotecs.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/02 13:01:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/02 12:31:00 #21205949
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8yLzIzIDE3OjA1LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+IE9uIFR1ZSwgTWF5IDAyLCAy
MDIzIGF0IDExOjQzOjE5QU0gKzAwMDAsIEdhdnJpbG92IElsaWEgd3JvdGU6DQo+PiBPbiA0LzI4
LzIzIDIyOjI0LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+Pj4gT24gV2VkLCBBcHIgMjYsIDIwMjMg
YXQgMDM6MDQ6MzFQTSArMDAwMCwgR2F2cmlsb3YgSWxpYSB3cm90ZToNCj4+Pj4gY3Rfc2lwX3Bh
cnNlX251bWVyaWNhbF9wYXJhbSgpIHJldHVybnMgb25seSAwIG9yIDEgbm93Lg0KPj4+PiBCdXQg
cHJvY2Vzc19yZWdpc3Rlcl9yZXF1ZXN0KCkgYW5kIHByb2Nlc3NfcmVnaXN0ZXJfcmVzcG9uc2Uo
KSBpbXBseQ0KPj4+PiBjaGVja2luZyBmb3IgYSBuZWdhdGl2ZSB2YWx1ZSBpZiBwYXJzaW5nIG9m
IGEgbnVtZXJpY2FsIGhlYWRlciBwYXJhbWV0ZXINCj4+Pj4gZmFpbGVkLiBMZXQncyBmaXggaXQu
DQo+Pj4+DQo+Pj4+IEZvdW5kIGJ5IEluZm9UZUNTIG9uIGJlaGFsZiBvZiBMaW51eCBWZXJpZmlj
YXRpb24gQ2VudGVyDQo+Pj4+IChsaW51eHRlc3Rpbmcub3JnKSB3aXRoIFNWQUNFLg0KPj4+Pg0K
Pj4+PiBGaXhlczogMGYzMmE0MGZjOTFhICgiW05FVEZJTFRFUl06IG5mX2Nvbm50cmFja19zaXA6
IGNyZWF0ZSBzaWduYWxsaW5nIGV4cGVjdGF0aW9ucyIpDQo+Pj4+IFNpZ25lZC1vZmYtYnk6IEls
aWEuR2F2cmlsb3YgPElsaWEuR2F2cmlsb3ZAaW5mb3RlY3MucnU+DQo+Pj4NCj4+PiBIaSBHYXZy
aWxvdiwNCj4+Pg0KPj4NCj4+IEhpIFNpbW9uLCB0aGFuayB5b3UgZm9yIHlvdXIgYW5zd2VyLg0K
Pj4NCj4+PiBhbHRob3VnaCBpdCBpcyBhIHNsaWdodGx5IHVudXN1YWwgY29udmVudGlvbiBmb3Ig
a2VybmVsIGNvZGUsDQo+Pj4gSSBiZWxpZXZlIHRoZSBpbnRlbnRpb24gaXMgdGhhdCB0aGlzIGZ1
bmN0aW9uIHJldHVybnMgMCB3aGVuDQo+Pj4gaXQgZmFpbHMgKHRvIHBhcnNlKSBhbmQgMSBvbiBz
dWNjZXNzLiBTbyBJIHRoaW5rIHRoYXQgcGFydCBpcyBmaW5lLg0KPj4+DQo+Pj4gV2hhdCBzZWVt
cyBhIGJpdCBicm9rZW4gaXMgdGhlIHdheSB0aGF0IGNhbGxlcnMgdXNlIHRoZSByZXR1cm4gdmFs
dWUuDQo+Pj4NCj4+PiAxLiBUaGUgY2FsbCBpbiBwcm9jZXNzX3JlZ2lzdGVyX3Jlc3BvbnNlKCkg
bG9va3MgbGlrZSB0aGlzOg0KPj4+DQo+Pj4gCXJldCA9IGN0X3NpcF9wYXJzZV9udW1lcmljYWxf
cGFyYW0oLi4uKQ0KPj4+IAlpZiAocmV0IDwgMCkgew0KPj4+IAkJbmZfY3RfaGVscGVyX2xvZyhz
a2IsIGN0LCAiY2Fubm90IHBhcnNlIGV4cGlyZXMiKTsNCj4+PiAJCXJldHVybiBORl9EUk9QOw0K
Pj4+IAl9DQo+Pj4NCj4+PiAgICAgICBCdXQgcmV0IGNhbiBvbmx5IGJlIDAgb3IgMSwgc28gdGhl
IGVycm9yIGhhbmRsaW5nIGlzIG5ldmVyIGlub2tlZCwNCj4+PiAgICAgICBhbmQgYSBmYWlsdXJl
IHRvIHBhcnNlIGlzIGlnbm9yZWQuIEkgZ3Vlc3MgZmFpbHVyZSBkb2Vzbid0IG9jY3VyIGluDQo+
Pj4gICAgICAgcHJhY3RpY2UuDQo+Pj4NCj4+PiAgICAgICBJIHN1c3BlY3QgdGhpcyBzaG91bGQg
YmU6DQo+Pj4NCj4+PiAJcmV0ID0gY3Rfc2lwX3BhcnNlX251bWVyaWNhbF9wYXJhbSguLi4pDQo+
Pj4gCWlmICghcmV0KSB7DQo+Pj4gCQluZl9jdF9oZWxwZXJfbG9nKHNrYiwgY3QsICJjYW5ub3Qg
cGFyc2UgZXhwaXJlcyIpOw0KPj4+IAkJcmV0dXJuIE5GX0RST1A7DQo+Pj4gCX0NCj4+Pg0KPj4N
Cj4+IGN0X3NpcF9wYXJzZV9udW1lcmljYWxfcGFyYW0oKSByZXR1cm5zIDAgaW4gdG8gY2FzZXMg
MSkgd2hlbiB0aGUNCj4+IHBhcmFtZXRlciAnZXhwaXJlcz0nIGlzbid0IGZvdW5kIGluIHRoZSBo
ZWFkZXIgb3IgMikgaXQncyBpbmNvcnJlY3RseSBzZXQuDQo+PiBJbiB0aGUgZmlyc3QgY2FzZSwg
dGhlIHJldHVybiB2YWx1ZSBzaG91bGQgYmUgaWdub3JlZCwgc2luY2UgdGhpcyBpcyBhDQo+PiBu
b3JtYWwgc2l0dWF0aW9uDQo+PiBJbiB0aGUgc2Vjb25kIGNhc2UsIGl0J3MgYmV0dGVyIHRvIHdy
aXRlIHRvIHRoZSBsb2cgYW5kIHJldHVybiBORl9EUk9QLA0KPj4gb3IgaWdub3JlIGl0IHRvbywg
dGhlbiBjaGVja2luZyB0aGUgcmV0dXJuIHZhbHVlIGNhbiBiZSByZW1vdmVkIGFzDQo+PiB1bm5l
Y2Vzc2FyeS4NCj4gDQo+IFNvcnJ5LCBJIHRoaW5rIEkgbWlzdW5kZXJzdG9vZCB0aGUgaW50ZW50
aW9uIG9mIHlvdXIgcGF0Y2ggZWFybGllci4NCj4gDQo+IERvIEkgKG5vdykgdW5kZXJzdGFuZCBj
b3JyZWN0bHkgdGhhdCB5b3UgYXJlIHByb3Bvc2luZyBhIHRyaXN0YXRlPw0KPiANCj4gYSkgcmV0
dXJuIDEgaWYgdmFsdWUgaXMgZm91bmQ7ICp2YWwgaXMgc2V0DQo+IGIpIHJldHVybiAwIGlmIHZh
bHVlIGlzIG5vdCBmb3VuZDsgKnZhbCBpcyB1bmNoYW5nZWQNCj4gYykgcmV0dXJuIC0xIG9uIGVy
cm9yOyAqdmFsIGlzIHVuZGVmaW5lZA0KDQpZZXMsIGl0IHNlZW1zIHRvIG1lIHRoYXQgdGhpcyB3
YXMgb3JpZ2luYWxseSBpbnRlbmRlZC4NCg==
