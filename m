Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582D86CAAAF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjC0Qdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjC0Qdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:33:50 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48C5273C
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 09:33:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e5-20020a17090301c500b001a1aa687e4bso6102439plh.17
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 09:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679934812;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fA2zieBxTjdVfCwnOph3Od7VcLY7duNKtodxOlsYfxs=;
        b=Hae9QW2JbyAAG5zwkI0VObm5Nf0zp943IdRLLMXg+o3YXLHUXtnRJH5JCN3OyNinPV
         y8/sS4EBKPo/KfUGgzT/qn9ggzA/ZQSSKTRIliZuPxi+OkIF4OF845KM4EBTtdo2UV/4
         jOzMuq0gZ5P1xo6/89MPNoOL7B8EhqXHDiHtZGE1xtYdfxvFyF3VR4AKifERSa5+oYnI
         sVnpCbjr6MjJoXar1CcjbEleTgjeUXOtqxkqoVmDKskiwMOLHibZY0/P7orf8jRlgA5R
         IiPUu/xniM1NfBBJZ6xOrkjOfOLy9ZnVkCmIp9kdMpzvS80x710easGWXsjSh3uOu/hN
         lsDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679934812;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fA2zieBxTjdVfCwnOph3Od7VcLY7duNKtodxOlsYfxs=;
        b=ehwfNSpFbcOQ+np3yxThYqO5aR78sMuMVN06FaKEdsIyroJrUy+Q97gDYWAjuv25eC
         GmYc1UTf/pMp6N5t91GEser/CouPe5odDeVUTogrKhrAfMPcLhIxK15+zveYCWoKRsyH
         QEjDHte1U3InzEutraGIiQfO4A2+Aczf1P5+c+G/0BLMgc/tGnTJ+LlfJhafLwaaZm9c
         6Rrk43T+tCCRDNaQlM9QQTrSVQC6x+oKRLetObugpIm8i9LngU9nyg01ebmcbdryNJiJ
         zQnGDb1ItAEgL5JLkzBBpwEYeatUYkJAD1zI4Y/KUpYmUH8OmpuEdTsOByCGVf2yAw2g
         1lvw==
X-Gm-Message-State: AAQBX9fmeI3pv5qW7Qv/V4uqCVBs/rWA1gdCwuv1YjjxjnoU1zPNJ4f9
        5ays1eGXWXqs1ZpvLKdG6kya1BE=
X-Google-Smtp-Source: AKy350bxpHgRH6Eay2SuXA9l+kzQYxGgY88ZBcHeRlQaBkPizBSLR5rB+LhBAIctnGVZPhtFdV6jWNs=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:24c4:b0:629:f9a2:64e6 with SMTP id
 d4-20020a056a0024c400b00629f9a264e6mr6536393pfv.4.1679934812367; Mon, 27 Mar
 2023 09:33:32 -0700 (PDT)
Date:   Mon, 27 Mar 2023 09:33:30 -0700
In-Reply-To: <ZB9UdB5pgOAacioS@pop-os.localdomain>
Mime-Version: 1.0
References: <20230319191913.61236-1-xiyou.wangcong@gmail.com>
 <CAKH8qBtoYREbbRaedAfv=cEv2a5gBEYLSLy2eqcMYvsN7sqE=Q@mail.gmail.com> <ZB9UdB5pgOAacioS@pop-os.localdomain>
Message-ID: <ZCHFWr5rqnYNK3qS@google.com>
Subject: Re: [Patch net-next v3] sock_map: dump socket map id via diag
From:   Stanislav Fomichev <sdf@google.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDMvMjUsIENvbmcgV2FuZyB3cm90ZToNCj4gT24gTW9uLCBNYXIgMjAsIDIwMjMgYXQgMTE6
MTM6MDNBTSAtMDcwMCwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiA+IE9uIFN1biwgTWFy
IDE5LCAyMDIzIGF0IDEyOjE54oCvUE0gQ29uZyBXYW5nIDx4aXlvdS53YW5nY29uZ0BnbWFpbC5j
b20+ICANCj4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gRnJvbTogQ29uZyBXYW5nIDxjb25nLndhbmdA
Ynl0ZWRhbmNlLmNvbT4NCj4gPiA+DQo+ID4gPiBDdXJyZW50bHkgdGhlcmUgaXMgbm8gd2F5IHRv
IGtub3cgd2hpY2ggc29ja21hcCBhIHNvY2tldCBoYXMgYmVlbiAgDQo+IGFkZGVkDQo+ID4gPiB0
byBmcm9tIG91dHNpZGUsIGVzcGVjaWFsbHkgZm9yIHRoYXQgYSBzb2NrZXQgY2FuIGJlIGFkZGVk
IHRvIG11bHRpcGxlDQo+ID4gPiBzb2NrbWFwJ3MuIFdlIGNvdWxkIGR1bXAgdGhpcyB2aWEgc29j
a2V0IGRpYWcsIGFzIHNob3duIGJlbG93Lg0KPiA+ID4NCj4gPiA+IFNhbXBsZSBvdXRwdXQ6DQo+
ID4gPg0KPiA+ID4gICAjIC4vaXByb3V0ZTIvbWlzYy9zcyAtdG5haWUgLS1icGYtbWFwDQo+ID4g
PiAgIEVTVEFCICAwICAgICAgMzQ0MzI5ICAgICAxMjcuMC4wLjE6MTIzNCAgICAgMTI3LjAuMC4x
OjQwOTEyICANCj4gaW5vOjIxMDk4IHNrOjUgY2dyb3VwOi91c2VyLnNsaWNlL3VzZXItMC5zbGlj
ZS9zZXNzaW9uLWMxLnNjb3BlIDwtPiAgDQo+IHNvY2ttYXA6IDENCj4gPiA+DQo+ID4gPiAgICMg
YnBmdG9vbCBtYXANCj4gPiA+ICAgMTogc29ja21hcCAgZmxhZ3MgMHgwDQo+ID4gPiAgICAgICAg
IGtleSA0QiAgdmFsdWUgNEIgIG1heF9lbnRyaWVzIDIgIG1lbWxvY2sgNDA5NkINCj4gPiA+ICAg
ICAgICAgcGlkcyBlY2hvLXNvY2ttYXAoNTQ5KQ0KPiA+ID4gICA0OiBhcnJheSAgbmFtZSBwaWRf
aXRlci5yb2RhdGEgIGZsYWdzIDB4NDgwDQo+ID4gPiAgICAgICAgIGtleSA0QiAgdmFsdWUgNEIg
IG1heF9lbnRyaWVzIDEgIG1lbWxvY2sgNDA5NkINCj4gPiA+ICAgICAgICAgYnRmX2lkIDEwICBm
cm96ZW4NCj4gPiA+ICAgICAgICAgcGlkcyBicGZ0b29sKDYyNCkNCj4gPiA+DQo+ID4gPiBJbiB0
aGUgZnV0dXJlLCB3ZSBjb3VsZCBkdW1wIG90aGVyIHNvY2ttYXAgcmVsYXRlZCBzdGF0cyB0b28s
IGhlbmNlIEkNCj4gPiA+IG1ha2UgaXQgYSBuZXN0ZWQgYXR0cmlidXRlLg0KPiA+ID4NCj4gPiA+
IENjOiBKb2huIEZhc3RhYmVuZCA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPg0KPiA+ID4gQ2M6
IEpha3ViIFNpdG5pY2tpIDxqYWt1YkBjbG91ZGZsYXJlLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IENvbmcgV2FuZyA8Y29uZy53YW5nQGJ5dGVkYW5jZS5jb20+DQo+ID4NCj4gPiBMb29rcyBm
aW5lIGZyb20gbXkgUE9XLCB3aWxsIGxldCBvdGhlcnMgY29tbWVudC4NCj4gPg0KPiA+IE9uZSB0
aGluZyBJIHN0aWxsIGRvbid0IHVuZGVyc3RhbmQgaGVyZTogd2hhdCBpcyBtaXNzaW5nIGZyb20g
dGhlDQo+ID4gc29ja2V0IGl0ZXJhdG9ycyB0byBpbXBsZW1lbnQgdGhpcz8gSXMgaXQgYWxsIHRo
ZSBza19wc29ja19nZXQgbWFnaWM/DQo+ID4gSSByZW1lbWJlciB5b3UgZGlzbWlzc2VkIFlvbmdo
b25nJ3Mgc3VnZ2VzdGlvbiBvbiB2MSwgYnV0IGhhdmUgeW91DQo+ID4gYWN0dWFsbHkgdHJpZWQg
aXQ/DQoNCj4gSSBhbSB2ZXJ5IGNvbmZ1c2VkLiBTbyBpbiBvcmRlciB0byBmaWd1cmUgb3V0IHdo
aWNoIHNvY2ttYXAgYSBzb2NrZXQgaGFzDQo+IGJlZW4gYWRkZWQgdG8sIEkgaGF2ZSB0byBkdW1w
ICphbGwqIHNvY2ttYXAncz8/PyBJdCBzZWVtcyB5b3UgYXJlDQo+IHN1Z2dlc3RpbmcgdG8gc29s
dmUgdGhpcyB3aXRoIGEgbW9yZSBjb21wbGV4IGFuZCB1bm5lY2Vzc2FyeSBhcHByb2FjaD8NCj4g
UGxlYXNlIHRlbGwgbWUgd2h5LCBJIGFtIHJlYWxseSBsb3N0LCBJIGRvbid0IGV2ZW4gc2VlIHRo
ZXJlIGlzIGEgcG9pbnQNCj4gdG8gbWFrZSBoZXJlLg0KDQpXaXRoIGEgc29ja2V0IGl0ZXIsIHlv
dSBjYW4gaXRlcmF0ZSBvdmVyIGFsbCBzb2NrZXRzIGFuZCBydW4gc29tZSBicGYNCnByb2dyYW0g
b24gaXQgZG8gZHVtcCBzb21lIHN0YXRlLiBTbyB5b3UnZCBpdGVyYXRlIG92ZXIgdGhlIHNvY2tl
dHMsDQpub3Qgc29ja21hcHMuIEZvciBlYWNoIHNvY2tldCB5b3UgZ2V0IGEgcG9pbnRlciB0byBz
b2NrIGFuZCB5b3UgZG8gdGhlIHNhbWUNCnNrX3Bzb2NrX2dldCtsaXN0X2Zvcl9lYWNoX2VudHJ5
KHBzb2NrLT5saW5rKS4NCg0KKGluIHRoZW9yeTsgd291bGQgYmUgaW50ZXJlc3RpbmcgdG8gc2Vl
IHdoZXRoZXIgaXQgd29ya3MgaW4gcHJhY3RpY2UpDQoNCj4gPg0KPiA+IEFsc286IGEgdGVzdCB3
b3VsZCBiZSBuaWNlIHRvIGhhdmUuIEkga25vdyB5b3UndmUgdGVzdGVkIGl0IHdpdGggdGhlDQo+
ID4gaXByb3V0ZTIsIGJ1dCBoYXZpbmcgc29tZXRoaW5nIHJlZ3VsYXJseSBleGVyY2lzZWQgYnkg
dGhlIGNpIHNlZW1zDQo+ID4gZ29vZCB0byBoYXZlIChhbmQgbm90IGEgdG9uIG9mIHdvcmspLg0K
DQo+IFN1cmUsIHNvIHdoZXJlIGFyZSB0aGUgdGVzdHMgZm9yIHNvY2tldCBkaWFnPyBJIGRvbid0
IHNlZSBhbnkgd2l0aGluIHRoZQ0KPiB0cmVlOg0KDQo+ICQgZ2l0IGdyZXAgSU5FVF9ESUFHX1NP
Q0tPUFQgLS0gdG9vbHMvDQo+ICQNCg0KPiBOb3RlLCB0aGlzIGlzIG5vdCBzdWl0YWJsZSBmb3Ig
YnBmIHNlbGZ0ZXN0cywgYmVjYXVzZSBpdCBpcyBsZXNzIHJlbGV2YW50DQo+IHRvIGJwZiwgbXVj
aCBtb3JlIHJlbGV2YW50IHRvIHNvY2tldCBkaWFnLiBJIHRob3VnaHQgdGhpcyBpcyBvYnZpb3Vz
Lg0KDQpOZXZlciB0b28gbGF0ZSB0byBzdGFydCB0ZXN0aW5nIHRob3NlIHNvY2sgZGlhZyBwYXRo
cyA6LSkNClB1dCB0aGVtIGluIHRoZSBuZXQgc2VsZnRlc3RzIGlmIHlvdSBkb24ndCB0aGluayBi
cGYgc2VsZnRlc3RzIGlzIHRoZSByaWdodA0KZml0Pw0KDQo+IFRoYW5rcy4NCg==
