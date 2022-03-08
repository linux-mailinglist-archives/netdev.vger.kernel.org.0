Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4644D2474
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350811AbiCHWoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344759AbiCHWoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:44:14 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A063615D;
        Tue,  8 Mar 2022 14:43:17 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRiXx-000BWH-6i; Tue, 08 Mar 2022 23:43:13 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRiXw-0005MY-Up; Tue, 08 Mar 2022 23:43:12 +0100
Subject: Re: [PATCH bpf v2] tools: fix unavoidable GCC call in Clang builds
To:     Adrian Ratiu <adrian.ratiu@collabora.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kernel@collabora.com,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Manoj Gupta <manojgupta@chromium.com>,
        Nathan Chancellor <nathan@kernel.org>, bpf@vger.kernel.org
References: <20220308121428.81735-1-adrian.ratiu@collabora.com>
 <6e82ffbb-ebc8-30e8-2326-95712578ee07@iogearbox.net>
 <87fsnsrt1t.fsf@ryzen9.i-did-not-set--mail-host-address--so-tickle-me>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <29531b96-5fbc-a332-365d-8f6a1e5cc619@iogearbox.net>
Date:   Tue, 8 Mar 2022 23:43:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87fsnsrt1t.fsf@ryzen9.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26475/Tue Mar  8 10:31:43 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMy84LzIyIDExOjE0IFBNLCBBZHJpYW4gUmF0aXUgd3JvdGU6DQo+IE9uIFR1ZSwgMDgg
TWFyIDIwMjIsIERhbmllbCBCb3JrbWFubiA8ZGFuaWVsQGlvZ2VhcmJveC5uZXQ+IHdyb3Rl
Og0KPj4gT24gMy84LzIyIDE6MTQgUE0sIEFkcmlhbiBSYXRpdSB3cm90ZToNCj4+PiBJbiBD
aHJvbWVPUyBhbmQgR2VudG9vIHdlIGNhdGNoIGFueSB1bndhbnRlZCBtaXhlZCBDbGFuZy9M
TFZNIGFuZCBHQ0MvYmludXRpbHMgdXNhZ2UgdmlhIHRvb2xjaGFpbiB3cmFwcGVycyB3aGlj
aCBmYWlsIGJ1aWxkcy7CoCBUaGlzIGhhcyByZXZlYWxlZCB0aGF0IEdDQyBpcyBjYWxsZWQg
dW5jb25kaXRpb25hbGx5IGluIENsYW5nIGNvbmZpZ3VyZWQgYnVpbGRzIHRvIHBvcHVsYXRl
IEdDQ19UT09MQ0hBSU5fRElSLiBBbGxvdyB0aGUgdXNlciB0byBvdmVycmlkZSBDTEFOR19D
Uk9TU19GTEFHUyB0byBhdm9pZCB0aGUgR0NDIGNhbGwgLSBpbiBvdXIgY2FzZSB3ZSBzZXQg
dGhlIHZhciBkaXJlY3RseSBpbiB0aGUgZWJ1aWxkIHJlY2lwZS7CoMKgIEluIHRoZW9yeSBD
bGFuZyBjb3VsZCBiZSBhYmxlIHRvIGF1dG9kZXRlY3QgdGhlc2Ugc2V0dGluZ3Mgc28gdGhp
cyBsb2dpYyBjb3VsZCBiZSByZW1vdmVkIGVudGlyZWx5LCBidXQgaW4gcHJhY3RpY2UgYXMg
dGhlIGNvbW1pdCBjZWJkYjczNzQ1NzcgKCJ0b29sczogSGVscCBjcm9zcy1idWlsZGluZyB3
aXRoIGNsYW5nIikgbWVudGlvbnMsIHRoaXMgZG9lcyBub3QgYWx3YXlzIHdvcmssIHNvIGdp
dmluZyBkaXN0cmlidXRpb25zIG1vcmUgY29udHJvbCB0byBzcGVjaWZ5IHRoZWlyIGZsYWdz
ICYgc3lzcm9vdCBpcyBiZW5lZmljaWFsLsKgwqAgU3VnZ2VzdGVkLWJ5OiBNYW5vaiBHdXB0
YSA8bWFub2pndXB0YUBjaHJvbWl1bS5jb20+IFN1Z2dlc3RlZC1ieTogTmF0aGFuIENoYW5j
ZWxsb3IgPG5hdGhhbkBrZXJuZWwub3JnPiBBY2tlZC1ieTogTmF0aGFuIENoYW5jZWxsb3Ig
PG5hdGhhbkBrZXJuZWwub3JnPiBTaWduZWQtb2ZmLWJ5OiBBZHJpYW4gUmF0aXUgPGFkcmlh
bi5yYXRpdUBjb2xsYWJvcmEuY29tPiAtLS0gQ2hhbmdlcyBpbiB2MjogwqDCoCAqIFJlcGxh
Y2VkIHZhcmlhYmxlIG92ZXJyaWRlIEdDQ19UT09MQ0hBSU5fRElSIC0+IMKgwqAgQ0xBTkdf
Q1JPU1NfRkxBR1MgDQo+Pg0KPj4gQXMgSSB1bmRlcnN0YW5kIGl0IGZyb20gWzBdIGFuZCBn
aXZlbiB3ZSdyZSBsYXRlIGluIHRoZSBjeWNsZSwgdGhpcyBpcyB0YXJnZXRlZCBmb3IgYnBm
LW5leHQgbm90IGJwZiwgcmlnaHQ/DQo+IA0KPiBZZXMsIGxldCdzIHRhcmdldCB0aGlzIGZv
ciBicGYtbmV4dC4gVGhlIGlzc3VlIHdhcyBpbnRyb2R1Y2VkIGluIHRoZSA1LjE3IGN5Y2xl
IGJ1dCBpbmRlZWQgaXQncyBsYXRlLiBJIGNhbiBkbyBhIHN0YWJsZSBiYWNrcG9ydCB0byA1
LjE3IGFmdGVyIGl0IHJlbGVhc2VzLg0KDQpPaywgc2d0bS4gR2l2ZW4gaXQgaGFzIGFuIEFj
ayBieSBOYXRoYW4sIEkndmUgcHVzaGVkIGl0IHRvIGJwZi1uZXh0Lg0KDQpUaGFua3MgZXZl
cnlvbmUsDQpEYW5pZWwNCg==
