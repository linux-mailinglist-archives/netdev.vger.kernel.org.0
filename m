Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4EF5134F3
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbiD1N0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346967AbiD1N0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:26:13 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 3E860AC91D;
        Thu, 28 Apr 2022 06:22:53 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 28 Apr 2022 21:22:11
 +0800 (GMT+08:00)
X-Originating-IP: [125.120.151.211]
Date:   Thu, 28 Apr 2022 21:22:11 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     "Duoming Zhou" <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data
 race-able
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220428060628.713479b2@kernel.org>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
 <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
 <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
 <YmpNZOaJ1+vWdccK@kroah.com>
 <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
 <YmpcUNf7O+OK6/Ax@kroah.com> <20220428060628.713479b2@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <f51aa1.41ae.180705614b5.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: cS_KCgAXGfAElWpiuIz8AQ--.797W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwMOElNG3GhOdQAEsC
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gdGhlcmUsCgo+IAo+IFllcywgdGhhdCBsb29rcyBiZXR0ZXIsIAoKQ29vbCwgdGhhbmtz
IGFnYWluIGZvciBnaXZpbmcgY29tbWVudHMuIDopCgo+IGJ1dCB3aGF0IGlzIHRoZSByb290IHBy
b2JsZW0gaGVyZSB0aGF0IHlvdSBhcmUKPiB0cnlpbmcgdG8gc29sdmU/ICBXaHkgZG9lcyBORkMg
bmVlZCB0aGlzIHdoZW4gbm8gb3RoZXIgc3Vic3lzdGVtIGRvZXM/Cj4gCgpXZWxsLCBpbiBmYWN0
LCBtZSBhbmQgRHVvbWluZyBhcmUga2VlcCBmaW5kaW5nIGNvbmN1cnJlbmN5IGJ1Z3MgdGhhdCBo
YXBwZW4gCmJldHdlZW4gdGhlIGRldmljZSBjbGVhbnVwL2RldGFjaCByb3V0aW5lIGFuZCBvdGhl
ciB1bmRlcmdvaW5nIHJvdXRpbmVzLgoKVGhhdCBpcyB0byBzYXksIHdoZW4gYSBkZXZpY2UsIG5v
IG1hdHRlciByZWFsIG9yIHZpcnR1YWwsIGlzIGRldGFjaGVkIGZyb20gCnRoZSBtYWNoaW5lLCB0
aGUga2VybmVsIGF3YWtlIGNsZWFudXAgcm91dGluZSB0byByZWNsYWltIHRoZSByZXNvdXJjZS4g
CkluIGN1cnJlbnQgY2FzZSwgdGhlIGNsZWFudXAgcm91dGluZSB3aWxsIGNhbGwgbmZjX3VucmVn
aXN0ZXJfZGV2aWNlKCkuCgpPdGhlciByb3V0aW5lcywgbWFpbmx5IGZyb20gdXNlci1zcGFjZSBz
eXN0ZW0gY2FsbHMsIG5lZWQgdG8gYmUgY2FyZWZ1bCBvZiAKdGhlIGNsZWFudXAgZXZlbnQuIElu
IGFub3RoZXIgd29yZCwgdGhlIGtlcm5lbCBuZWVkIHRvIHN5bmNocm9uaXplIHRoZXNlIApyb3V0
aW5lcyB0byBhdm9pZCByYWNlIGJ1Z3MuCgpJbiBvdXIgcHJhY3RpY2UsIHdlIGZpbmQgdGhhdCBt
YW55IHN1YnN5c3RlbXMgYXJlIHByb25lIHRvIHRoaXMgdHlwZSBvZiBidWcuCgpGb3IgZXhhbXBs
ZSwgaW4gYmx1ZXRvb3RoIHdlIGZpeAoKQlQgc3Vic3lzdGVtCiogZTJjYjZiODkxYWQyICgiYmx1
ZXRvb3RoOiBlbGltaW5hdGUgdGhlIHBvdGVudGlhbCByYWNlIGNvbmRpdGlvbiB3aGVuIHJlbW92
aW5nCnRoZSBIQ0kgY29udHJvbGxlciIpCiogZmE3OGQyZDFkNjRmICgiQmx1ZXRvb3RoOiBmaXgg
ZGF0YSByYWNlcyBpbiBzbXBfdW5yZWdpc3RlcigpLCBzbXBfZGVsX2NoYW4oKSIpCi4uCgpBWDI1
IHN1YnN5c3RlbQoqIDFhZGU0OGQwYzI3ZCAoImF4MjU6IE5QRCBidWcgd2hlbiBkZXRhY2hpbmcg
QVgyNSBkZXZpY2UiKQouLgoKd2UgY3VycmVudGx5IGZvY3VzIG9uIHRoZSBuZXQgcmVsZXZhbnQg
c3Vic3lzdGVtcyBhbmQgd2Ugbm93IGlzIGF1ZGl0aW5nIHRoZSBORkMgCmNvZGUuCgpJbiBhbm90
aGVyIHdvcmQsIGFsbCBzdWJzeXN0ZW1zIG5lZWQgdG8gdGFrZSBjYXJlIG9mIHRoZSBzeW5jaHJv
bml6YXRpb24gaXNzdWVzLgpCdXQgc2VlbXMgdGhhdCB0aGUgc29sdXRpb25zIGFyZSB2YXJpZWQg
YmV0d2VlbiBkaWZmZXJlbnQgc3Vic3lzdGVtLiAKCkVtcGlyaWNhbGx5IHNwZWFraW5nLCBtb3N0
IG9mIHRoZW0gdXNlIHNwZWNpZmljIGZsYWdzICsgc3BlY2lmaWMgbG9ja3MgdG8gcHJldmVudAp0
aGUgcmFjZS4gCgpJbiBzdWNoIGNhc2VzLCBpZiB0aGUgY2xlYW51cCByb3V0aW5lIGZpcnN0IGhv
bGQgdGhlIGxvY2ssIHRoZSBvdGhlciByb3V0aW5lcyB3aWxsCndhaXQgb24gdGhlIGxvY2tzLiBT
aW5jZSB0aGUgY2xlYW51cCByb3V0aW5lIHdyaXRlIHRoZSBzcGVjaWZpYyBmbGFnLCB0aGUgb3Ro
ZXIKcm91dGluZSwgYWZ0ZXIgY2hlY2sgdGhlIHNwZWNpZmljIGZsYWcsIHdpbGwgYmUgYXdhcmUg
b2YgdGhlIGNsZWFudXAgc3R1ZmYgYW5kIGp1c3QKYWJvcnQgdGhlaXIgdGFza3MuCklmIHRoZSBv
dGhlciByb3V0aW5lcyBmaXJzdCBob2xkIHRoZSBsb2NrLCB0aGUgY2xlYW51cCByb3V0aW5lIGp1
c3Qgd2FpdCB0aGVtIHRvIApmaW5pc2guCgpORkMgaGVyZSBpcyBzcGVjaWFsIGJlY2F1c2UgaXQg
dXNlcyBkZXZpY2VfaXNfcmVnaXN0ZXJlZC4gSSB0aG91Z2h0IHRoZSBhdXRob3IgbWF5CmJlbGll
dmUgdGhpcyBtYWNybyBpcyByYWNlIGZyZWUuIEhvd2V2ZXIsIGl0IGlzIG5vdC4gU28gd2UgbmVl
ZCB0byByZXBsYWNlIHRoaXMgY2hlY2sKdG8gbWFrZSBzdXJlIHRoZSBuZXRsaW5rIGZ1bmN0aW9u
cyB3aWxsIDEwMCBwZXJjZW50IGJlIGF3YXJlIG9mIHRoZSBjbGVhbnVwIHJvdXRpbmUKYW5kIGFi
b3J0IHRoZSB0YXNrIGlmIHRoZXkgZ3JhYiB0aGUgZGV2aWNlX2xvY2sgbGF0ZWx5LiBPdGhlcndp
c2UsIHRoZSBuZWxpbmsgcm91dGluZQp3aWxsIGNhbGwgc3ViLWxheWVyIGNvZGUgYW5kIHBvc3Np
bGJ5IGRlcmVmZXJlbmNlIHJlc291cmNlcyB0aGF0IGFscmVhZHkgZnJlZWQuCgpGb3IgZXhhbXBs
ZSwgb25lIG9mIG15IHJlY2VudCBmaXggM2UzYjVkZmNkMTZhICgiTkZDOiByZW9yZGVyIHRoZSBs
b2dpYyBpbiAKbmZjX3t1bix9cmVnaXN0ZXJfZGV2aWNlIikgdGFrZXMgdGhlIHN1Z2dlc3Rpb24g
ZnJvbSBtYWludGFpbmVyIGFzIGhlIHRob3VnaHQgdGhlIApkZXZpY2VfaXNfcmVnaXN0ZXJlZCBp
cyBlbm91Z2guIEFuZCBmb3Igbm93IHdlIGZpbmQgb3V0IHRoaXMgZGV2aWNlX2lzX3JlZ2lzdGVy
ZWQKaXMgbm90IGVub3VnaC4KCklmIHlvdSBhcmUgd29uZGVyaW5nIGlmIG90aGVyIHN1YnN5c3Rl
bXMgdXNlIHRoZSBjb21iaW5hdGlvbiBvZiBkZXZpY2VfaXNfcmVnaXN0ZXJlZAphcyBjaGVjayB0
byBhdm9pZCB0aGUgcmFjZSwgSSBoYXZlIHRvIHNheSBJIGRvbid0IGtub3cuIElmIHRoZSBhbnN3
ZXIgaXMgeWVzLCB0aGF0IGNvZGUKaXMgcG9zc2libHkgYWxzbyBwcm9uZSB0byB0aGlzIHR5cGUg
b2YgY29uY3VycmVudCBidWcuCgo+IHRoYW5zaywKPiAKPiBncmVnIGstaAoKVGhhbmtzIGFnYWlu
LgoKTGluIE1h
