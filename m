Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529DD54740E
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 13:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiFKLBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 07:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiFKLBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 07:01:04 -0400
X-Greylist: delayed 117945 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Jun 2022 04:00:57 PDT
Received: from smtpproxy21.qq.com (smtpbg703.qq.com [203.205.195.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59F7319
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 04:00:57 -0700 (PDT)
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: WQH7Uj+YMzXRxKsq6/LDWmfq9EU8t9MipGjVqYniJHV6+aTQu/JTntTEJuYRG
        LsaciIaCsMBlvWhtfAGLQmXqdHO/eSLFd3lYNy37t0FFcxo65Nv7NUmn2qBjdMJiEt99l0X
        vl+JBqdPYr6VV2b1oSKr4y/iGGGSGHOsz78AFgAIBlN62BhxNlapAm4JBOllPALfSkP1R7q
        GPv/Irt15mvw9ETXjQCpGyKSfwNjJYmIu/q54mlqxVWbR/Gt57tNn741ADtdtXco7QDkkoQ
        zmPrXZb+vuYME8K1dxKwM19JvMY43Zfjn1xcq5RCutmPToSRkSf/dU58tyxj84B9jU1SAsv
        OcRGwaNvqbfF/abu4PF1bz/WYtFTCqw2T9/z94jnWobARpz/xt5AnxnYr+7qw==
X-QQ-BUSINESS-ORIGIN: 2
X-Originating-IP: 128.179.229.4
X-QQ-STYLE: 
X-QQ-mid: llogic74t1654945248t194087
From:   "=?utf-8?B?SmlhbmhhbyBYdQ==?=" <jianhao_xu@smail.nju.edu.cn>
To:     "=?utf-8?B?ZWR1bWF6ZXQ=?=" <edumazet@google.com>
Cc:     "=?utf-8?B?RGFuaWVsIEJvcmttYW5u?=" <daniel@iogearbox.net>,
        "=?utf-8?B?amhz?=" <jhs@mojatatu.com>,
        "=?utf-8?B?eGl5b3Uud2FuZ2Nvbmc=?=" <xiyou.wangcong@gmail.com>,
        "=?utf-8?B?amlyaQ==?=" <jiri@resnulli.us>,
        "=?utf-8?B?ZGF2ZW0=?=" <davem@davemloft.net>,
        "=?utf-8?B?a3ViYQ==?=" <kuba@kernel.org>,
        "=?utf-8?B?cGFiZW5p?=" <pabeni@redhat.com>,
        "=?utf-8?B?bmV0ZGV2?=" <netdev@vger.kernel.org>,
        "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: sched: fix potential null pointer deref
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Sat, 11 Jun 2022 13:00:48 +0200
X-Priority: 3
Message-ID: <tencent_4CF4EFF2144A820D7BBECA7D@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20220610021445.2441579-1-jianhao_xu@smail.nju.edu.cn>
        <3f460707-e267-e749-07fc-c44604cd5713@iogearbox.net>
        <tencent_29981C021E6150B064C7DBA3@qq.com>
        <CANn89iKHfi=kQY1FC=07COJfVX4ROTnGkM_1uKvOfPfdhqt4Ow@mail.gmail.com>
In-Reply-To: <CANn89iKHfi=kQY1FC=07COJfVX4ROTnGkM_1uKvOfPfdhqt4Ow@mail.gmail.com>
X-QQ-ReplyHash: 1801730707
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
        by smtp.qq.com (ESMTP) with SMTP
        id ; Sat, 11 Jun 2022 19:00:50 +0800 (CST)
Feedback-ID: llogic:smail.nju.edu.cn:qybgforeign:qybgforeign8
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIGFkdmljZSBhbmQgc29ycnkgZm9yIHRoZSBub2lzZS4NCg0KPiBB
bGwgbmV0ZGV2IGRldmljZXMgaGF2ZSB0aGVpciBkZXYtPl90eCBhbGxvY2F0ZWQgaW4gbmV0
aWZfYWxsb2NfbmV0ZGV2X3F1ZXVlcygpDQo+IA0KPiBUaGVyZSBpcyBhYnNvbHV0ZWx5IG5v
IHdheSBNUSBxZGlzYyBjb3VsZCBiZSBhdHRhY2hlZCB0byBhIGRldmljZSB0aGF0DQo+IGhh
cyBmYWlsZWQgbmV0aWZfYWxsb2NfbmV0ZGV2X3F1ZXVlcygpIHN0ZXAuDQoNCkkgYmVsaWV2
ZSB0aGlzIG1ha2VzIHNlbnNlLiBCdXQgSSBhbSBzdGlsbCBhIGJpdCBjb25mdXNlZCwgZXNw
ZWNpYWxseSBhZnRlciB3ZSANCmNyb3NzLWNoZWNrZWQgdGhlIHNpbWlsYXIgY29udGV4dCBv
ZiBtcSwgbXFwcmlvLCB0YXByaW8uIFRvIGJlIHNwZWNpZmljLCB3ZSANCmNyb3NzLWNoZWNr
ZWQgd2hldGhlciBgbXFfY2xhc3Nfb3BzYCwgYG1xcHJpb19jbGFzc19vcHNgLCBhbmQgDQpg
dGFwcmlvX2NsYXNzX29wc2AgY2hlY2sgdGhlIHJldHVybiB2YWx1ZSBvZiAgdGhlaXIgcmVz
cGVjdGl2ZSB2ZXJzaW9uIG9mIA0KYF9xdWV1ZV9nZXRgIGJlZm9yZSBkZXJlZmVyZW5jaW5n
IGl0LiANCg0KLS0tLS0tLS0tLS0tLS0tIC0tLS0tIC0tLS0tLS0tLSAtLS0tLS0tLS0gDQpj
bGFzc19vcHMgICAgICB3aGV0aGVyIGNoZWNrIHRoZSByZXQgdmFsdWUgb2YgX3F1ZXVlX2dl
dA0KICAgICAgICAgICAgICAgICAgICAgbXEgfCAgbXFwcmlvIHwgdGFwcmlvICAgDQotLS0t
LS0tLS0tLS0tLS0gLS0tLS0gLS0tLS0tLS0tIC0tLS0tLS0tLSAgDQpzZWxlY3RfcXVldWUg
ICAgLSAgICAgLSAgICAgICAgIC0gICAgICAgICANCmdyYWZ0ICAgICAgICAgICAgICAgbm8g
ICAgeWVzICAgICAgeWVzICAgICAgIA0KbGVhZiAgICAgICAgICAgICAgICAgbm8gICAgeWVz
ICAgICAgeWVzICAgICAgIA0KZmluZCAgICAgICAgICAgICAgICB5ZXMgICAgLSAgICAgICAg
IHllcyAgICAgICANCndhbGsgICAgICAgICAgICAgICAgLSAgICAgIC0gICAgICAgICAgLSAg
ICAgICAgIA0KZHVtcCAgICAgICAgICAgICAgbm8gICAgbm8gICAgICAgbm8gICAgICAgIA0K
ZHVtcF9zdGF0cyAgICAgbm8gICAgbm8gICAgICAgbm8gICAgIA0KLS0tLS0tLS0tLS0tLS0t
IC0tLS0tIC0tLS0tLS0tLSAtLS0tLS0tLS0gDQogIA0KQXMgc2hvd24gaW4gdGhpcyB0YWJs
ZSwgYG1xX2xlYWYoKWAgZG9lcyBub3QgY2hlY2sgdGhlIHJldHVybiB2YWx1ZSBvZiANCmBt
cV9fcXVldWVfZ2V0KClgIGJlZm9yZSB1c2luZyB0aGUgcG9pbnRlciwgd2hpbGUgYG1xcHJp
b19sZWFmKClgIGFuZCANCmB0YXByaW9fbGVhZigpYCBkbyBoYXZlIHN1Y2ggYSBOVUxMIGNo
ZWNrLiANCg0KRllJLCBoZXJlIGlzIHRoZSBjb2RlIG9mIGBtcXByaW9fbGVhZigpYCBhbmQg
d2UgY2FuIGZpbmQgdGhlIE5VTEwgY2hlY2suDQpgYGANCi8vbmV0L3NjaGVkL3NjaF9tcXBy
aW8uYw0Kc3RhdGljIHN0cnVjdCBRZGlzYyAqbXFwcmlvX2xlYWYoc3RydWN0IFFkaXNjICpz
Y2gsIHVuc2lnbmVkIGxvbmcgY2wpDQp7DQoJc3RydWN0IG5ldGRldl9xdWV1ZSAqZGV2X3F1
ZXVlID0gbXFwcmlvX3F1ZXVlX2dldChzY2gsIGNsKTsNCg0KCWlmICghZGV2X3F1ZXVlKQ0K
CQlyZXR1cm4gTlVMTDsNCg0KCXJldHVybiBkZXZfcXVldWUtPnFkaXNjX3NsZWVwaW5nOw0K
fQ0KYGBgDQoNClRoYXQgaXMgYWxzbyB0aGUgc2l0dWF0aW9uIG9mIGBtcV9ncmFmdCgpYCwg
YG1xcHJpb19ncmFmdCgpYCBhbmQgYHRhcHJpb19ncmFmdCgpYC4gDQpJIGFtIG5vdCBzdXJl
IHdoZXRoZXIgaXQgaXMgcmVhc29uYWJsZSB0byBleHBlY3QgdGhlIGNsYXNzX29wcyBvZiBt
cSwgbXFwcmlvLCANCmFuZCB0YXByaW8gdG8gYmUgY29uc2lzdGVudCBpbiB0aGlzIHdheS4g
SWYgc28sIGRvZXMgaXQgbWVhbiB0aGF0IGl0IGlzIHBvc3NpYmxlIA0KdGhhdGBtcV9sZWFm
KClgYW5kIGBtcV9ncmFmdGAgbWF5IG1pc3MgYSBjaGVjayBoZXJlLCBvciBtcXByaW8sIHRh
cHJpbyBoYXZlIA0KcmVkdW5kYW50IGNoZWNrcz8NCg0KVGhhbmtzIGFnYWluIGZvciB5b3Vy
IHRpbWUuIEkgYXBvbG9naXplIGlmIG15IHF1ZXN0aW9uIGlzIHN0dXBpZC4=



