Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1534667180
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbjALMBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjALMA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:00:59 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6D4E7F;
        Thu, 12 Jan 2023 03:55:47 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id AB7685FD04;
        Thu, 12 Jan 2023 14:55:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1673524545;
        bh=Nz29EgusyYqlEdWzaGUAWyVQvp6P9nezbuorMDXTcWY=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=aJs+LZ4UaLHvlc08UDd+RoyGBeNeqNy2hgR/HJXhh40zYGcs9xG10g+ryt7OSONvy
         R/f0m7qLMTxCMhGhjdz2S2I2QnfPDtzAf+iPUTDsV+v7QuyTN9UTx2PCu2VxH5Wmpu
         LLzqcr5fbtRLVyXc3/9oawyDyvxj94KeIupnyWciLOjA3rbdL6fzGJkdhsdabrdBWD
         BIZuKS3/tOpmXdqrAu0gO73qS8XqqxN3Vf6kHyu8dnTrCcfd1aZN9Y8rPh++CNNnwL
         F+eiIC4oH6WfyZ6RDiD8R0PW7Y4zf+K5aAWEU5C5qIea+82UNCjn80pZP5GW7AXG2+
         LdLYIqLSDL/9A==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 12 Jan 2023 14:55:42 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Paolo Abeni <pabeni@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Bobby Eshleman" <bobby.eshleman@bytedance.com>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [PATCH net-next v7 4/4] test/vsock: vsock_perf utility
Thread-Topic: [PATCH net-next v7 4/4] test/vsock: vsock_perf utility
Thread-Index: AQHZJNzkh05g7Bl5cECcJcZFNzV8rq6afOAAgAAAKAA=
Date:   Thu, 12 Jan 2023 11:55:41 +0000
Message-ID: <678816e6-9480-a0d3-4aca-23e58013dbc6@sberdevices.ru>
References: <0a9464eb-ad31-426b-1f30-c19d77281308@sberdevices.ru>
 <455b49a98c98edb1512ba2365adc76ac78a2b71b.camel@redhat.com>
In-Reply-To: <455b49a98c98edb1512ba2365adc76ac78a2b71b.camel@redhat.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE54B1650D7F1B49B42131C7EC25324B@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/01/12 05:58:00 #20761738
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIuMDEuMjAyMyAxNDo1MywgUGFvbG8gQWJlbmkgd3JvdGU6DQo+IE9uIFR1ZSwgMjAyMy0w
MS0xMCBhdCAxMDoxOCArMDAwMCwgQXJzZW5peSBLcmFzbm92IHdyb3RlOg0KPj4gVGhpcyBhZGRz
IHV0aWxpdHkgdG8gY2hlY2sgdnNvY2sgcngvdHggcGVyZm9ybWFuY2UuDQo+Pg0KPj4gVXNhZ2Ug
YXMgc2VuZGVyOg0KPj4gLi92c29ja19wZXJmIC0tc2VuZGVyIDxjaWQ+IC0tcG9ydCA8cG9ydD4g
LS1ieXRlcyA8Ynl0ZXMgdG8gc2VuZD4NCj4+IFVzYWdlIGFzIHJlY2VpdmVyOg0KPj4gLi92c29j
a19wZXJmIC0tcG9ydCA8cG9ydD4gLS1yY3Zsb3dhdCA8U09fUkNWTE9XQVQ+DQo+Pg0KPj4gU2ln
bmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+
PiAtLS0NCj4+ICB0b29scy90ZXN0aW5nL3Zzb2NrL01ha2VmaWxlICAgICB8ICAgMyArLQ0KPj4g
IHRvb2xzL3Rlc3RpbmcvdnNvY2svUkVBRE1FICAgICAgIHwgIDM0ICsrKw0KPj4gIHRvb2xzL3Rl
c3RpbmcvdnNvY2svdnNvY2tfcGVyZi5jIHwgNDI3ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4+ICAzIGZpbGVzIGNoYW5nZWQsIDQ2MyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQo+PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfcGVy
Zi5jDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svTWFrZWZpbGUgYi90
b29scy90ZXN0aW5nL3Zzb2NrL01ha2VmaWxlDQo+PiBpbmRleCBmODI5M2M2OTEwYzkuLjQzYTI1
NGYwZTE0ZCAxMDA2NDQNCj4+IC0tLSBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svTWFrZWZpbGUNCj4+
ICsrKyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svTWFrZWZpbGUNCj4+IEBAIC0xLDggKzEsOSBAQA0K
Pj4gICMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KPj4gLWFsbDogdGVz
dA0KPj4gK2FsbDogdGVzdCB2c29ja19wZXJmDQo+PiAgdGVzdDogdnNvY2tfdGVzdCB2c29ja19k
aWFnX3Rlc3QNCj4+ICB2c29ja190ZXN0OiB2c29ja190ZXN0Lm8gdGltZW91dC5vIGNvbnRyb2wu
byB1dGlsLm8NCj4+ICB2c29ja19kaWFnX3Rlc3Q6IHZzb2NrX2RpYWdfdGVzdC5vIHRpbWVvdXQu
byBjb250cm9sLm8gdXRpbC5vDQo+PiArdnNvY2tfcGVyZjogdnNvY2tfcGVyZi5vDQo+PiAgDQo+
PiAgQ0ZMQUdTICs9IC1nIC1PMiAtV2Vycm9yIC1XYWxsIC1JLiAtSS4uLy4uL2luY2x1ZGUgLUku
Li8uLi8uLi91c3IvaW5jbHVkZSAtV25vLXBvaW50ZXItc2lnbiAtZm5vLXN0cmljdC1vdmVyZmxv
dyAtZm5vLXN0cmljdC1hbGlhc2luZyAtZm5vLWNvbW1vbiAtTU1EIC1VX0ZPUlRJRllfU09VUkNF
IC1EX0dOVV9TT1VSQ0UNCj4+ICAuUEhPTlk6IGFsbCB0ZXN0IGNsZWFuDQo+PiBkaWZmIC0tZ2l0
IGEvdG9vbHMvdGVzdGluZy92c29jay9SRUFETUUgYi90b29scy90ZXN0aW5nL3Zzb2NrL1JFQURN
RQ0KPj4gaW5kZXggNGQ1MDQ1ZTdkMmMzLi44NGVlMjE3YmE4ZWUgMTAwNjQ0DQo+PiAtLS0gYS90
b29scy90ZXN0aW5nL3Zzb2NrL1JFQURNRQ0KPj4gKysrIGIvdG9vbHMvdGVzdGluZy92c29jay9S
RUFETUUNCj4+IEBAIC0zNSwzICszNSwzNyBAQCBJbnZva2UgdGVzdCBiaW5hcmllcyBpbiBib3Ro
IGRpcmVjdGlvbnMgYXMgZm9sbG93czoNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgIC0tY29u
dHJvbC1wb3J0PSRHVUVTVF9JUCBcDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAtLWNvbnRy
b2wtcG9ydD0xMjM0IFwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgIC0tcGVlci1jaWQ9Mw0K
Pj4gKw0KPj4gK3Zzb2NrX3BlcmYgdXRpbGl0eQ0KPj4gKy0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+
ICsndnNvY2tfcGVyZicgaXMgYSBzaW1wbGUgdG9vbCB0byBtZWFzdXJlIHZzb2NrIHBlcmZvcm1h
bmNlLiBJdCB3b3JrcyBpbg0KPj4gK3NlbmRlci9yZWNlaXZlciBtb2Rlczogc2VuZGVyIGNvbm5l
Y3QgdG8gcGVlciBhdCB0aGUgc3BlY2lmaWVkIHBvcnQgYW5kDQo+PiArc3RhcnRzIGRhdGEgdHJh
bnNtaXNzaW9uIHRvIHRoZSByZWNlaXZlci4gQWZ0ZXIgZGF0YSBwcm9jZXNzaW5nIGlzIGRvbmUs
DQo+PiAraXQgcHJpbnRzIHNldmVyYWwgbWV0cmljcyhzZWUgYmVsb3cpLg0KPj4gKw0KPj4gK1Vz
YWdlOg0KPj4gKyMgcnVuIGFzIHNlbmRlcg0KPj4gKyMgY29ubmVjdCB0byBDSUQgMiwgcG9ydCAx
MjM0LCBzZW5kIDFHIG9mIGRhdGEsIHR4IGJ1ZiBzaXplIGlzIDFNDQo+PiArLi92c29ja19wZXJm
IC0tc2VuZGVyIDIgLS1wb3J0IDEyMzQgLS1ieXRlcyAxRyAtLWJ1Zi1zaXplIDFNDQo+PiArDQo+
PiArT3V0cHV0Og0KPj4gK3R4IHBlcmZvcm1hbmNlOiBBIEdiaXRzL3MNCj4+ICsNCj4+ICtPdXRw
dXQgZXhwbGFuYXRpb246DQo+PiArQSBpcyBjYWxjdWxhdGVkIGFzICJudW1iZXIgb2YgYml0cyB0
byBzZW5kIiAvICJ0aW1lIGluIHR4IGxvb3AiDQo+PiArDQo+PiArIyBydW4gYXMgcmVjZWl2ZXIN
Cj4+ICsjIGxpc3RlbiBwb3J0IDEyMzQsIHJ4IGJ1ZiBzaXplIGlzIDFNLCBzb2NrZXQgYnVmIHNp
emUgaXMgMUcsIFNPX1JDVkxPV0FUIGlzIDY0Sw0KPj4gKy4vdnNvY2tfcGVyZiAtLXBvcnQgMTIz
NCAtLWJ1Zi1zaXplIDFNIC0tdnNrLXNpemUgMUcgLS1yY3Zsb3dhdCA2NEsNCj4+ICsNCj4+ICtP
dXRwdXQ6DQo+PiArcnggcGVyZm9ybWFuY2U6IEEgR2JpdHMvcw0KPj4gK3RvdGFsIGluICdyZWFk
KCknOiBCIHNlYw0KPj4gK1BPTExJTiB3YWtldXBzOiBDDQo+PiArYXZlcmFnZSBpbiAncmVhZCgp
JzogRCBucw0KPj4gKw0KPj4gK091dHB1dCBleHBsYW5hdGlvbjoNCj4+ICtBIGlzIGNhbGN1bGF0
ZWQgYXMgIm51bWJlciBvZiByZWNlaXZlZCBiaXRzIiAvICJ0aW1lIGluIHJ4IGxvb3AiLg0KPj4g
K0IgaXMgdGltZSwgc3BlbnQgaW4gJ3JlYWQoKScgc3lzdGVtIGNhbGwoZXhjbHVkaW5nICdwb2xs
KCknKQ0KPj4gK0MgaXMgbnVtYmVyIG9mICdwb2xsKCknIHdha2UgdXBzIHdpdGggUE9MTElOIGJp
dCBzZXQuDQo+PiArRCBpcyBCIC8gQywgZS5nLiBhdmVyYWdlIGFtb3VudCBvZiB0aW1lLCBzcGVu
dCBpbiBzaW5nbGUgJ3JlYWQoKScuDQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy92c29j
ay92c29ja19wZXJmLmMgYi90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3BlcmYuYw0KPj4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCj4+IGluZGV4IDAwMDAwMDAwMDAwMC4uYTcyNTIwMzM4Zjg0DQo+
PiAtLS0gL2Rldi9udWxsDQo+PiArKysgYi90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3BlcmYu
Yw0KPj4gQEAgLTAsMCArMSw0MjcgQEANCj4+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMC1vbmx5DQo+PiArLyoNCj4+ICsgKiB2c29ja19wZXJmIC0gYmVuY2htYXJrIHV0aWxp
dHkgZm9yIHZzb2NrLg0KPj4gKyAqDQo+PiArICogQ29weXJpZ2h0IChDKSAyMDIyIFNiZXJEZXZp
Y2VzLg0KPj4gKyAqDQo+PiArICogQXV0aG9yOiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBz
YmVyZGV2aWNlcy5ydT4NCj4+ICsgKi8NCj4+ICsjaW5jbHVkZSA8Z2V0b3B0Lmg+DQo+PiArI2lu
Y2x1ZGUgPHN0ZGlvLmg+DQo+PiArI2luY2x1ZGUgPHN0ZGxpYi5oPg0KPj4gKyNpbmNsdWRlIDxz
dGRib29sLmg+DQo+PiArI2luY2x1ZGUgPHN0cmluZy5oPg0KPj4gKyNpbmNsdWRlIDxlcnJuby5o
Pg0KPj4gKyNpbmNsdWRlIDx1bmlzdGQuaD4NCj4+ICsjaW5jbHVkZSA8dGltZS5oPg0KPj4gKyNp
bmNsdWRlIDxzdGRpbnQuaD4NCj4+ICsjaW5jbHVkZSA8cG9sbC5oPg0KPj4gKyNpbmNsdWRlIDxz
eXMvc29ja2V0Lmg+DQo+PiArI2luY2x1ZGUgPGxpbnV4L3ZtX3NvY2tldHMuaD4NCj4+ICsNCj4+
ICsjZGVmaW5lIERFRkFVTFRfQlVGX1NJWkVfQllURVMJKDEyOCAqIDEwMjQpDQo+PiArI2RlZmlu
ZSBERUZBVUxUX1RPX1NFTkRfQllURVMJKDY0ICogMTAyNCkNCj4+ICsjZGVmaW5lIERFRkFVTFRf
VlNPQ0tfQlVGX0JZVEVTICgyNTYgKiAxMDI0KQ0KPj4gKyNkZWZpbmUgREVGQVVMVF9SQ1ZMT1dB
VF9CWVRFUwkxDQo+PiArI2RlZmluZSBERUZBVUxUX1BPUlQJCTEyMzQNCj4+ICsNCj4+ICsjZGVm
aW5lIEJZVEVTX1BFUl9HQgkJKDEwMjQgKiAxMDI0ICogMTAyNFVMTCkNCj4+ICsjZGVmaW5lIE5T
RUNfUEVSX1NFQwkJKDEwMDAwMDAwMDBVTEwpDQo+PiArDQo+PiArc3RhdGljIHVuc2lnbmVkIGlu
dCBwb3J0ID0gREVGQVVMVF9QT1JUOw0KPj4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIGJ1Zl9zaXpl
X2J5dGVzID0gREVGQVVMVF9CVUZfU0laRV9CWVRFUzsNCj4+ICtzdGF0aWMgdW5zaWduZWQgbG9u
ZyB2c29ja19idWZfYnl0ZXMgPSBERUZBVUxUX1ZTT0NLX0JVRl9CWVRFUzsNCj4+ICsNCj4+ICtz
dGF0aWMgdm9pZCBlcnJvcihjb25zdCBjaGFyICpzKQ0KPj4gK3sNCj4+ICsJcGVycm9yKHMpOw0K
Pj4gKwlleGl0KEVYSVRfRkFJTFVSRSk7DQo+PiArfQ0KPiANCj4gRm9yIHRoZSByZWNvcmRzLCBJ
IHN1Z2dlc3RlZCB0byB1c2UgdGhlIGV4aXN0aW5nIGVycm9yKCkgbGliY2FsbCwgc2VlDQo+IG1h
biAzIGVycm9yLg0KPiANCj4gTm90IGEgYmlnIGRlYWwuIFRoaXMgY2FuIGJlIG1lcmdlZCBhcy1p
cywgYW5kIHlvdSBjYW4gZm9sbG93LXVwLCBpdCB5b3UNCj4gZmluZCBpdCB1c2VmdWwuDQoNCkFo
aGhoaCwgSSBzZWUsIHRoYW5rcyENCg0KVGhhbmtzLCBBcnNlbml5DQoNCj4gDQo+IENoZWVycywN
Cj4gDQo+IFBhb2xvDQo+IA0KDQo=
