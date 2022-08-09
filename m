Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BFD58D64C
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 11:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiHIJUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 05:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbiHIJUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 05:20:12 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536101A804;
        Tue,  9 Aug 2022 02:20:09 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 453EF5FD05;
        Tue,  9 Aug 2022 12:20:06 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660036806;
        bh=xMNfpVY1JM1L0r+ir29qY+88IYcz1TPQu1w7NMZ/cc0=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=rRJpMVRIlCOs2vEgC6U9KMsq6VIRPTOzNs8efLV/EJD4RzEP4efVpmm3nnZ7s2D63
         pLqfvK5TKeHnvs6nS4tCQ2QuP5tS5IFytxgiPgagN/FPeIr4pbdgCkHSTDzwJnwxdB
         wA30MK78oXgLgeKKHW21j/SJI8JG5RE4d3X/zU2vKk3bS7sw1oALDyL2VolpPHyQ1X
         EF6PKw2kHzk7TCNWRWO4+XSZT6xTRVfyTwKASLmq4iOWocGwPD7BJTtdCNhZNLWW+O
         iA35HKM+kuq3OwIIxtvwy7QSfyJuKTNsjvtBGRDCDlB75FZ36G/vcjvzGPcQokhN0h
         sIv022yaHv/0g==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Tue,  9 Aug 2022 12:20:01 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "VMware PV-Drivers Reviewers" <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Topic: [RFC PATCH v3 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Index: AQHYpz+pcvNrW+Wes06KlvYKyF5H+a2ksYuAgAFwEQA=
Date:   Tue, 9 Aug 2022 09:19:56 +0000
Message-ID: <4cf2db92-b51c-245e-63ee-db971e84e95e@sberdevices.ru>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <20220808112239.jwzrp7krsyk6za5s@sgarzare-redhat>
In-Reply-To: <20220808112239.jwzrp7krsyk6za5s@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDB751D0B6FF8A4A95D07F8C9A4E906D@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/09 07:32:00 #20083496
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SCC_BODY_URI_ONLY,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDguMDguMjAyMiAxNDoyMiwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBIaSBBcnNl
bml5LA0KPiANCj4gT24gV2VkLCBBdWcgMDMsIDIwMjIgYXQgMDE6NDg6MDZQTSArMDAwMCwgQXJz
ZW5peSBLcmFzbm92IHdyb3RlOg0KPj4gSGVsbG8sDQo+Pg0KPj4gVGhpcyBwYXRjaHNldCBpbmNs
dWRlcyBzb21lIHVwZGF0ZXMgZm9yIFNPX1JDVkxPV0FUOg0KPiANCj4gSSBoYXZlIHJldmlld2Vk
IGFsbCB0aGUgcGF0Y2hlcywgcnVuIHRlc3RzIGFuZCBldmVyeXRoaW5nIHNlZW1zIG9rYXkgOi0p
DQpUaGFuayBZb3UNCj4gDQo+IEkgbGVmdCBzb21lIG1pbm9yIGNvbW1lbnRzIGFuZCBhc2tlZCBC
cnlhbiBhbmQgVmlzaG51IHRvIHRha2UgYSBiZXR0ZXIgbG9vayBhdCBWTUNJIHBhdGNoZXMuDQpP
aywgbGV0J3Mgd2FpdCB0aGVpciByZXBseSBiZWZvcmUgdjQNCj4gDQo+IEluIGdlbmVyYWwgSSBh
c2sgeW91IHRvIHJldmlzaXQgdGhlIHBhdGNoIGRlc2NyaXB0aW9ucyBhIGJpdCAoZm9yIGV4YW1w
bGUgYWRkaW5nIGEgc3BhY2UgYWZ0ZXIgcHVuY3R1YXRpb24pLiBUaGUgbmV4dCB2ZXJzaW9uIEkg
dGhpbmsgY2FuIGJlIHdpdGhvdXQgUkZDLg0KYWNrDQo+IA0KPiBSZW1lbWJlciB0byBzZW5kIGl0
IHdpdGggdGhlIG5ldC1uZXh0IHRhZy4NCj4gTm90ZTogbmV0LW5leHQgaXMgY2xvc2VkIGZvciBu
b3cgc2luY2Ugd2UgYXJlIGluIHRoZSBtZXJnZSB3aW5kb3cuDQo+IEl0IHNob3VsZCByZS1vcGVu
IGluIGEgd2VlayAoeW91IGNhbiBjaGVjayBoZXJlOiBodHRwOi8vdmdlci5rZXJuZWwub3JnL35k
YXZlbS9uZXQtbmV4dC5odG1sKS4NCj4gDQo+IEknbGwgYmUgb24gdmFjYXRpb24gdGhlIG5leHQg
MiB3ZWVrcyAoQXVnIDE1IC0gMjgpLCBidXQgSSdsbCB0cnkgdG8gY2hlY2sgb3V0IHlvdXIgcGF0
Y2hlcyENCk5vIHByb2JsZW0sIHRoYW5rcw0KPiANCj4gVGhhbmtzLA0KPiBTdGVmYW5vDQo+IA0K
DQo=
