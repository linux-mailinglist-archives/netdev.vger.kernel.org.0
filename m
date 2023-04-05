Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAB66D85B3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbjDESKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbjDESKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:10:01 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AD05BA0;
        Wed,  5 Apr 2023 11:09:58 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id dw2so9576843qvb.11;
        Wed, 05 Apr 2023 11:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680718197; x=1683310197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e15NDV90+Lem0WfkCzOryMRGDIn7iIdQ9bmcL/lcTAE=;
        b=CI7LCdF2QkqohUU82RAQYoU4RLrLFYOjC62If1NgVClAuPlpaMmTm42eafKWA9FNkE
         wHbjP9QuDhg3p16ungJEbXZ4ijs4wvhBKbLJFJl3FkSM8p6hURMxIf59C4Wc8nbB6ARO
         oiP4ftHEC9VHnu/6bHOwyeJ7jmpq8J37byNlkKIKUVifSFqTQ43IAFNRzsNnJuD2MPa0
         pvlLpi8DghasiXKxqV1HA2LV0LAMyE4BbtZBweY21sq4yRxvBiqiIZMfOoGT8iLup/5h
         AJMyq+7XJSjAJEQjcM4lh/ED1niiJnGAMmmTgysMvRFf+Gq8+QHoAZtUItoFdVFK/psf
         NAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680718197; x=1683310197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e15NDV90+Lem0WfkCzOryMRGDIn7iIdQ9bmcL/lcTAE=;
        b=dFcRGfb/iGwg4GqS7WyeOITiuz0q+yzjI16ahk1LFNRjVXRdUNC74GihOxoa1gvX+Z
         yr9tESje/3tI/9sAXCqatl6NDb010w0DCjYcEczq6Oss1dzY9SKUoWMWTDLRgmvK6MQI
         373icFzYC67dXSGlUa6ChxPNQUWOKxL/Wdw4yXJ7/4iSV1hpNPHYeiugCV+6kOHZeQIm
         XNvYcbXa9poda2G/n0yahlRA0fNxgkreAtEKYfi44ugb1T6Sz8Z1CJZg65yJiIhxOkQH
         thu0ftKil9+iRbZT3/GlHy2DhkyRSqYTChn64RSxnLwZDIaCc5k69yfs2y3FiPaL0j6D
         iLgQ==
X-Gm-Message-State: AAQBX9cS3P9CUNIczHmrkDP5iesLbPwOcM6e9pifcqULAx5JSBMV2Dxi
        2E8SNMmh+XM1ZVHuIJjlooE=
X-Google-Smtp-Source: AKy350YP40NftxRGoMbZf+cXkc1NDSURNTwz1oVELRpXHFAPANN2531RcTGdwB/ooRMZf7BMyAyolw==
X-Received: by 2002:a05:6214:d81:b0:56e:bdfb:f4c5 with SMTP id e1-20020a0562140d8100b0056ebdfbf4c5mr58808qve.36.1680718197251;
        Wed, 05 Apr 2023 11:09:57 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id c22-20020a056214071600b005dd8b934599sm4408602qvz.49.2023.04.05.11.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 11:09:56 -0700 (PDT)
Message-ID: <dee4b415-0696-90f3-0e2f-2230ff941e1b@gmail.com>
Date:   Wed, 5 Apr 2023 14:09:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: sunhme: move asm includes to below linux
 includes
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Simon Horman <horms@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-m68k@lists.linux-m68k.org
References: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
 <082e6ff7-6799-fa80-81e2-6f8092f8bb51@gmail.com>
 <ZC23vf6tNKU1FgRP@kernel.org> <ZC240XCeYCaSCu0X@casper.infradead.org>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <ZC240XCeYCaSCu0X@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNC81LzIzIDE0OjA3LCBNYXR0aGV3IFdpbGNveCB3cm90ZToNCj4gT24gV2VkLCBBcHIg
MDUsIDIwMjMgYXQgMDg6MDI6MzdQTSArMDIwMCwgU2ltb24gSG9ybWFuIHdyb3RlOg0KPj4g
T24gV2VkLCBBcHIgMDUsIDIwMjMgYXQgMDE6MzQ6MTFQTSAtMDQwMCwgU2VhbiBBbmRlcnNv
biB3cm90ZToNCj4+PiBPbiA0LzUvMjMgMTM6MjksIFNpbW9uIEhvcm1hbiB3cm90ZToNCj4+
Pj4gQSByZWNlbnQgcmVhcnJhbmdlbWVudCBvZiBpbmNsdWRlcyBoYXMgbGVhZCB0byBhIHBy
b2JsZW0gb24gbTY4aw0KPj4+PiBhcyBmbGFnZ2VkIGJ5IHRoZSBrZXJuZWwgdGVzdCByb2Jv
dC4NCj4+Pj4NCj4+Pj4gUmVzb2x2ZSB0aGlzIGJ5IG1vdmluZyB0aGUgYmxvY2sgYXNtIGlu
Y2x1ZGVzIHRvIGJlbG93IGxpbnV4IGluY2x1ZGVzLg0KPj4+PiBBIHNpZGUgZWZmZWN0IGkg
dGhhdCBub24tU3BhcmMgYXNtIGluY2x1ZGVzIGFyZSBub3cgaW1tZWRpYXRlbHkNCj4+Pj4g
YmVmb3JlIFNwYXJjIGFzbSBpbmNsdWRlcywgd2hpY2ggc2VlbXMgbmljZS4NCj4+Pj4NCj4+
Pj4gVXNpbmcgc3BhcnNlIHYwLjYuNCBJIHdhcyBhYmxlIHRvIHJlcHJvZHVjZSB0aGlzIHBy
b2JsZW0gYXMgZm9sbG93cw0KPj4+PiB1c2luZyB0aGUgY29uZmlnIHByb3ZpZGVkIGJ5IHRo
ZSBrZXJuZWwgdGVzdCByb2JvdDoNCj4+Pj4NCj4+Pj4gJCB3Z2V0IGh0dHBzOi8vZG93bmxv
YWQuMDEub3JnLzBkYXktY2kvYXJjaGl2ZS8yMDIzMDQwNC8yMDIzMDQwNDE3NDguMHNRYzRL
NGwtbGtwQGludGVsLmNvbS9jb25maWcNCj4+Pj4gJCBjcCBjb25maWcgLmNvbmZpZw0KPj4+
PiAkIG1ha2UgQVJDSD1tNjhrIG9sZGNvbmZpZw0KPj4+PiAkIG1ha2UgQVJDSD1tNjhrIEM9
MiBNPWRyaXZlcnMvbmV0L2V0aGVybmV0L3N1bg0KPj4+PiAgICAgIENDIFtNXSAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc3VuL3N1bmhtZS5vDQo+Pj4+ICAgIEluIGZpbGUgaW5jbHVkZWQg
ZnJvbSBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdW4vc3VuaG1lLmM6MTk6DQo+Pj4+ICAgIC4v
YXJjaC9tNjhrL2luY2x1ZGUvYXNtL2lycS5oOjc4OjExOiBlcnJvcjogZXhwZWN0ZWQg4oCY
O+KAmSBiZWZvcmUg4oCYdm9pZOKAmQ0KPj4+PiAgICAgICA3OCB8IGFzbWxpbmthZ2Ugdm9p
ZCBkb19JUlEoaW50IGlycSwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MpOw0KPj4+PiAgICAgICAg
ICB8ICAgICAgICAgICBefn5+fg0KPj4+PiAgICAgICAgICB8ICAgICAgICAgICA7DQo+Pj4+
ICAgIC4vYXJjaC9tNjhrL2luY2x1ZGUvYXNtL2lycS5oOjc4OjQwOiB3YXJuaW5nOiDigJhz
dHJ1Y3QgcHRfcmVnc+KAmSBkZWNsYXJlZCBpbnNpZGUgcGFyYW1ldGVyIGxpc3Qgd2lsbCBu
b3QgYmUgdmlzaWJsZSBvdXRzaWRlIG9mIHRoaXMgZGVmaW5pdGlvbiBvciBkZWNsYXJhdGlv
bg0KPj4+PiAgICAgICA3OCB8IGFzbWxpbmthZ2Ugdm9pZCBkb19JUlEoaW50IGlycSwgc3Ry
dWN0IHB0X3JlZ3MgKnJlZ3MpOw0KPj4+PiAgICAgICAgICB8ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn4NCj4+Pg0KPj4+IFRoaXMgc2VlbXMgbGlr
ZSBhIHByb2JsZW0gd2l0aCB0aGUgaGVhZGVyLiBtNjhrJ3MgYXNtL2lycS5oIHNob3VsZCBp
bmNsdWRlIGxpbnV4L2ludGVycnVwdC5oIGJlZm9yZSBpdHMgZGVjbGFyYXRpb25zLg0KPj4N
Cj4+IEhpIFNlYW4sDQo+Pg0KPj4gSSBkbyBzZWUgeW91ciBwb2ludC4gQnV0IFRCSCBJJ20g
dW5zdXJlIHdoaWNoIHdheSB0byBnbyBvbiB0aGlzIG9uZS4NCj4+IEdlZXJ0LCBkbyB5b3Ug
aGF2ZSBhbnkgaW5wdXQ/DQo+IA0KPiBXZSBhbHdheXMgaW5jbHVkZSBsaW51eC8qIGhlYWRl
cnMgYmVmb3JlIGFzbS8qLiAgVGhlICJzb3J0aW5nIiBvZg0KPiBoZWFkZXJzIGluIHRoaXMg
d2F5IHdhcyBpbmFwcHJvcHJpYXRlLg0KDQpJcyB0aGlzIHdyaXR0ZW4gZG93biBhbnl3aGVy
ZT8gSSBjb3VsZG4ndCBmaW5kIGl0IGluIERvY3VtZW50YXRpb24vcHJvY2Vzcy4uLg0KDQot
LVNlYW4NCg==
