Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCD25135CB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbiD1N5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiD1N5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:57:18 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 211A7B42DE;
        Thu, 28 Apr 2022 06:53:59 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 28 Apr 2022 21:53:28
 +0800 (GMT+08:00)
X-Originating-IP: [125.120.151.211]
Date:   Thu, 28 Apr 2022 21:53:28 +0800 (GMT+08:00)
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
In-Reply-To: <YmqYgu++0OuhfFxy@kroah.com>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
 <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
 <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
 <YmpNZOaJ1+vWdccK@kroah.com>
 <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
 <YmpcUNf7O+OK6/Ax@kroah.com> <20220428060628.713479b2@kernel.org>
 <f51aa1.41ae.180705614b5.Coremail.linma@zju.edu.cn>
 <YmqYgu++0OuhfFxy@kroah.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6ad27014.42f6.1807072bb39.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: cS_KCgDnzkVZnGpiHuj8AQ--.9822W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwIOElNG3GhaBwAAsh
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

SGVsbG8gdGhlcmUKCj4gCj4gSG93IGRvIHlvdSBwaHlzaWNhbGx5IHJlbW92ZSBhIE5GQyBkZXZp
Y2UgZnJvbSBhIHN5c3RlbT8gIFdoYXQgdHlwZXMgb2YKPiBidXNzZXMgYXJlIHRoZXkgb24/ICBJ
ZiBub24tcmVtb3ZhYmxlIG9uZSwgdGhlbiBvZGRzIGFyZSB0aGVyZSdzIG5vdAo+IGdvaW5nIHRv
IGJlIG1hbnkgcmFjZXMgc28gdGhpcyBpcyBhIGxvdy1wcmlvcml0eSB0aGluZy4gIElmIHRoZXkg
Y2FuIGJlCj4gb24gcmVtb3ZhYmxlIGJ1c3NlcyAoVVNCLCBQQ0ksIGV0Yy4pLCB0aGVuIHRoYXQn
cyBhIGJpZ2dlciB0aGluZy4KCldlbGwsIHRoZXNlIGFyZSBncmVhdCBxdWVzdGlvbnMgd2UgZGlk
bid0IGV2ZW4gdG91Y2ggdG8geWV0LgpGb3IgdGhlIEJULCBIQU1SQURJTywgYW5kIE5GQy9OQ0kg
Y29kZSwgd2Ugc2ltcGx5IHVzZSBwc2V1ZG8tdGVybWluYWwgKyBsaW5lCmRpc2NpcGxpbmUgdG8g
ZW11bGF0ZSBhIG1hbGljaW91cyBkZXZpY2UgZnJvbSB1c2VyLXNwYWNlIChDQVBfTkVUX0FETUlO
IHJlcXVpcmVkKS4KCldlIHdpbGwgdGhlbiBzdXJ2ZXkgdGhlIGFjdHVhbCBwaHlzaWNhbCBidXMg
Zm9yIHRoZSBJUkwgdXNlZCBORkMgZGV2aWNlLgoKPiAKPiBCdXQgYWdhaW4sIHRoZSBORkMgYnVz
IGNvZGUgc2hvdWxkIGhhbmRsZSBhbGwgb2YgdGhpcyBmb3IgdGhlIGRyaXZlcnMsCj4gdGhlcmUn
cyBub3RoaW5nIHNwZWNpYWwgYWJvdXQgTkZDIHRoYXQgc2hvdWxkIHdhcnJhbnQgYSBzcGVjaWFs
IG5lZWQgZm9yCj4gdGhpcyB0eXBlIG9mIHRoaW5nLgo+IAoKQWdyZWUsIGJ1dCBpbiBteSBvcGlu
aW9uLCBldmVyeSBsYXllciBiZXNpZGVzIHRoZSBidXMgY29kZSBoYXMgdG8gaGFuZGxlIHRoaXMg
cmFjZS4KClRoZSBjbGVhbnVwIHJvdXRpbmUgaXMgZnJvbQoiZG93biIgdG8gInVwIiBsaWtlIC4u
LiAtPiBUVFkgLT4gTkZDTVJWTCAtPiBOQ0kgLT4gTkZDIGNvcmUKd2hpbGUgdGhlIG90aGVyIHJv
dXRpbmVzLCBsaWtlIG5ldGxpbmsgY29tbWFuZCBpcyBmcm9tICJ1cCIgdG8gImRvd24iCnVzZXIg
c3BhY2UgLT4gbmV0bGluayAtPiBORkMgLT4gTkNJIC0+IE5GQ01SVkwgLT4gLi4uCgpUaGVpciBk
aXJlY3Rpb25zIGFyZSB0b3RhbGx5IHJldmVyc2VkIGhlbmNlIG9ubHkgZWFjaCBsYXllciBvZiB0
aGUgc3RhY2sgcGVyZm9ybSBnb29kCnN5bmNocm9uaXphdGlvbiBjYW4gdGhlIGNvZGUgYmUgcmFj
ZSBmcmVlLgoKRm9yIGV4YW1wbGUsIHRoaXMgZGV0YWNoaW5nIGV2ZW50IGF3YWtlIGNvZGUgaW4g
YnVzLCB0aGUgcnVubmluZyB0YXNrIGluIGhpZ2hlciBsYXllcgppcyBub3QgYXdhcmUgb2YgdGhp
cy4gVGhlIGNsZWFudXAgb2YgZWFjaCBsYXllciBoYXMgdG8gbWFrZSBzdXJlIGFueSBydW5uaW5n
IGNvZGUgd29uJ3QKY2F1c2UgdXNlLWFmdGVyLWZyZWUuIAoKPiB0aGFua3MsCj4gCj4gZ3JlZyBr
LWgKClRoYW5rcwpMaW4gTWE=
