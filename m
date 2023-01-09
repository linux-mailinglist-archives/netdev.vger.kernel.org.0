Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C2266249E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbjAILt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236907AbjAILtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:49:02 -0500
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B538DEC2;
        Mon,  9 Jan 2023 03:48:59 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 9B69D1168200;
        Mon,  9 Jan 2023 14:48:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 9B69D1168200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1673264935; bh=4zdJOxvdZxNjDpaPqZMAHCXnrnK4AhxLy6o/2/aYp9Q=;
        h=From:To:CC:Subject:Date:From;
        b=F6KwgIvVOtEaicCDqUyDeyEZnMP5wNs4hK+56ArpuvzYoTWoVF8xjAQGcdn6BVpJt
         t+ZrlbdBk0XYPKIwSdK1LTBbAU5LtU4sGduhMsIQIJiOXyy9Qk/CIR0QRpvpasTONh
         bUeNC3aR/HcEB2jNCDf21rXWbhBtNGhmNH2Rr78I=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id 9822730D0A0A;
        Mon,  9 Jan 2023 14:48:55 +0300 (MSK)
Received: from msk-exch-01.infotecs-nt (10.0.7.191) by msk-exch-01.infotecs-nt
 (10.0.7.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.12; Mon, 9 Jan
 2023 14:48:55 +0300
Received: from msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07]) by
 msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07%14]) with mapi id
 15.02.1118.012; Mon, 9 Jan 2023 14:48:55 +0300
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: 
Thread-Index: AQHZJCBZf/Vc9wORpEWtf73o0PLEEA==
Date:   Mon, 9 Jan 2023 11:48:55 +0000
Message-ID: <20230109114925.2996149-1-Ilia.Gavrilov@infotecs.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 174564 [Jan 09 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;infotecs.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/01/09 09:37:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/01/09 09:04:00 #20749700
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpEYXRlOiBUdWUsIDIwIERlYyAyMDIyIDE1OjI5OjIzICswMzAwDQpTdWJqZWN0OiBbUEFUQ0hd
IG5ldGZpbHRlcjogaXBzZXQ6IEZpeCBvdmVyZmxvdyBiZWZvcmUgd2lkZW4gaW4gdGhlDQogYml0
bWFwX2lwX2NyZWF0ZSgpIGZ1bmN0aW9uLkBADQoNCldoZW4gZmlyc3RfaXAgaXMgMCwgbGFzdF9p
cCBpcyAweEZGRkZGRkYsIGFuZCBuZXRtYXNrIGlzIDMxLCB0aGUgdmFsdWUgb2YNCmFuIGFyaXRo
bWV0aWMgZXhwcmVzc2lvbiAyIDw8IChuZXRtYXNrIC0gbWFza19iaXRzIC0gMSkgaXMgc3ViamVj
dA0KdG8gb3ZlcmZsb3cgZHVlIHRvIGEgZmFpbHVyZSBjYXN0aW5nIG9wZXJhbmRzIHRvIGEgbGFy
Z2VyIGRhdGEgdHlwZQ0KYmVmb3JlIHBlcmZvcm1pbmcgdGhlIGFyaXRobWV0aWMuDQoNCk5vdGUg
dGhhdCBpdCdzIGhhcm1sZXNzIHNpbmNlIHRoZSB2YWx1ZSB3aWxsIGJlIGNoZWNrZWQgYXQgdGhl
IG5leHQgc3RlcC4NCg0KRm91bmQgYnkgSW5mb1RlQ1Mgb24gYmVoYWxmIG9mIExpbnV4IFZlcmlm
aWNhdGlvbiBDZW50ZXINCihsaW51eHRlc3Rpbmcub3JnKSB3aXRoIFNWQUNFLg0KDQpGaXhlczog
YjlmZWQ3NDgxODVhICgibmV0ZmlsdGVyOiBpcHNldDogQ2hlY2sgYW5kIHJlamVjdCBjcmF6eSAv
MCBpbnB1dCBwYXJhbWV0ZXJzIikNClNpZ25lZC1vZmYtYnk6IElsaWEuR2F2cmlsb3YgPElsaWEu
R2F2cmlsb3ZAaW5mb3RlY3MucnU+DQotLS0NCiBuZXQvbmV0ZmlsdGVyL2lwc2V0L2lwX3NldF9i
aXRtYXBfaXAuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVs
ZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvaXBzZXQvaXBfc2V0X2JpdG1h
cF9pcC5jIGIvbmV0L25ldGZpbHRlci9pcHNldC9pcF9zZXRfYml0bWFwX2lwLmMNCmluZGV4IGE4
Y2UwNGE0YmI3Mi4uYjhmMGZiMzczNzhmIDEwMDY0NA0KLS0tIGEvbmV0L25ldGZpbHRlci9pcHNl
dC9pcF9zZXRfYml0bWFwX2lwLmMNCisrKyBiL25ldC9uZXRmaWx0ZXIvaXBzZXQvaXBfc2V0X2Jp
dG1hcF9pcC5jDQpAQCAtMzA5LDcgKzMwOSw3IEBAIGJpdG1hcF9pcF9jcmVhdGUoc3RydWN0IG5l
dCAqbmV0LCBzdHJ1Y3QgaXBfc2V0ICpzZXQsIHN0cnVjdCBubGF0dHIgKnRiW10sDQoNCiBwcl9k
ZWJ1ZygibWFza19iaXRzICV1LCBuZXRtYXNrICV1XG4iLCBtYXNrX2JpdHMsIG5ldG1hc2spOw0K
IGhvc3RzID0gMiA8PCAoMzIgLSBuZXRtYXNrIC0gMSk7DQotZWxlbWVudHMgPSAyIDw8IChuZXRt
YXNrIC0gbWFza19iaXRzIC0gMSk7DQorZWxlbWVudHMgPSAyVUwgPDwgKG5ldG1hc2sgLSBtYXNr
X2JpdHMgLSAxKTsNCiB9DQogaWYgKGVsZW1lbnRzID4gSVBTRVRfQklUTUFQX01BWF9SQU5HRSAr
IDEpDQogcmV0dXJuIC1JUFNFVF9FUlJfQklUTUFQX1JBTkdFX1NJWkU7DQotLQ0KMi4zMC4yDQoN
Cg0K0KEg0YPQstCw0LbQtdC90LjQtdC8LA0K0JjQu9GM0Y8g0JPQsNCy0YDQuNC70L7Qsg0K0JLQ
tdC00YPRidC40Lkg0L/RgNC+0LPRgNCw0LzQvNC40YHRgg0K0J7RgtC00LXQuyDRgNCw0LfRgNCw
0LHQvtGC0LrQuA0K0JDQniAi0JjQvdGE0L7QotC10JrQoSIg0LIg0LMuINCh0LDQvdC60YIt0J/Q
tdGC0LXRgNCx0YPRgNCzDQoxMjcyODcsINCzLiDQnNC+0YHQutCy0LAsINCh0YLQsNGA0YvQuSDQ
n9C10YLRgNC+0LLRgdC60L4t0KDQsNC30YPQvNC+0LLRgdC60LjQuSDQv9GA0L7QtdC30LQsINC0
0L7QvCAxLzIzLCDRgdGC0YAuIDENClQ6ICs3IDQ5NSA3MzctNjEtOTIgKCDQtNC+0LEuIDQ5MjEp
DQrQpDogKzcgNDk1IDczNy03Mi03OA0KDQoNCklsaWEuR2F2cmlsb3ZAaW5mb3RlY3MucnUNCnd3
dy5pbmZvdGVjcy5ydQ0KDQoNCg==
