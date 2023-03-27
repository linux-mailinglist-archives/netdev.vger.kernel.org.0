Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361D26CAB92
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbjC0RKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbjC0RK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:10:27 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51BD5276
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:09:52 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-545e529206eso36523287b3.9
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679936992;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UM0lutb3gRnoqM+uGW40pX2RGiAIW+l60qS4j9UMsrk=;
        b=sFO02bryYdxU+wVRU6RmN+t1quP2Of8oD4DS3VtsikCXv1KBMe0G8cpDXfO5usfEUD
         eJjQT9LVE+LOlWGZVhbQO89rQ5/v4U8tjsy0n5orNMRWXX2iQDXg+1ZWR6+ffYqvnpWj
         cISWxU7fIZnnY/bTSkTf4nHz7AFE5UKI147S5Q0WnH2ja/nioUjIYETkHsvY0OUmzroU
         tKzm1yNk2r4XElkBJYapEWzAu3YNMBmZ1sd9Z06hDoI+J+tAYadEwZBmXrX70Tu2NuAY
         ls//9pJ9FQeUjEyLlMes69tvxIUL2/WCIn0ROcglHC44iwsGY77bBA4HBOrY1J2TUhiW
         mwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679936992;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UM0lutb3gRnoqM+uGW40pX2RGiAIW+l60qS4j9UMsrk=;
        b=k/j7vEy1qOMf/bGmxDzer/4wuZeWd15lx08gXOngF33UA8MBDwLNBSo8M7gAXW65oS
         dEQRofM3bpDwY6955LiLjQB7XLHH+q8zoKfz+SZ+W26GT661x6/YFbj+xpHOmp92bUGI
         XqnPyFbSqO3dqy+3Wbxw/RT9CnMYIO9dr9+a49Pfkh6pfqglfCgiQ2q8HbvCa4tImkEW
         jRzAN4OV5w7IciczGoDzJcEFsPxt9Hze2FRrKYvv5qW9ONF8GWtnjkJ7ad0EPM/CSwqo
         qzWtPONengSCDjCaEoq12unBiPCEOny2RuBYqoIEosNets+90vjmwiiqONZjemewDDBy
         yhCw==
X-Gm-Message-State: AAQBX9cuOXuH4VxWnuChbqb7bnE4SSAW72eGhovh3O0dalK2XVtQ8GT4
        hVw3EGNYZ7Ua5ZfQ7iQpklAPTO8=
X-Google-Smtp-Source: AKy350aQv3UfTYLSVzJIUlfFIirmVYy8QxrY1KIyTy8dhRlf2RIQk1zB1goyyfh52BqUSrKZO2P606s=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a81:ae21:0:b0:543:bbdb:8c2b with SMTP id
 m33-20020a81ae21000000b00543bbdb8c2bmr5870649ywh.10.1679936992009; Mon, 27
 Mar 2023 10:09:52 -0700 (PDT)
Date:   Mon, 27 Mar 2023 10:09:50 -0700
In-Reply-To: <C8C3B8DB-1CF1-4C51-91A1-6D4C6FEFD6D1@avride.ai>
Mime-Version: 1.0
References: <F75020C7-9247-4F15-96CC-C3E6F11C0429@avride.ai>
 <ZB4F7l0Nh2ZYwjci@google.com> <C8C3B8DB-1CF1-4C51-91A1-6D4C6FEFD6D1@avride.ai>
Message-ID: <ZCHN3sbx2Cr0r0hM@google.com>
Subject: Re: Network RX per process per interface statistics
From:   Stanislav Fomichev <sdf@google.com>
To:     Kamil Zaripov <zaripov-kamil@avride.ai>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
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

T24gMDMvMjcsIEthbWlsIFphcmlwb3Ygd3JvdGU6DQo+ID4gQnkgIm1vZGlmaWVzIiAtIGRvIHlv
dSBtZWFuIHRoZSBwYXlsb2FkL2hlYWRlcnM/IFlvdSBjYW4gcHJvYmFibHkgdXNlDQo+ID4gdGhl
IHNrYiBwb2ludGVyIGFkZHJlc3MgYXMgYSB1bmlxdWUgaWRlbnRpZmllciB0byBjb25uZWN0IGFj
cm9zcyAgDQo+IGRpZmZlcmVudA0KPiA+IHRyYWNlcG9pbnRzPw0KDQo+IE5vLCBJIG1lYW4gd2hl
biBzaXR1YXRpb25zIHdoZW4gc2FtZSBwYWNrYWdlIHRocm91Z2ggaXRzIHdheSB0byB0aGUgIA0K
PiBuZXR3b3JrIHN0YWNrIGNoYW5nZSBza19idWZmIHBvaW50ZXIuIEZvciBleGFtcGxlLCBhZnRl
ciBza2JfY2xvbmUoKSAgDQo+IGNhbGwuIEkgaGF2ZSBtYWRlIHNvbWUgdGVzdCBhbmQgZm91bmQg
b3V0IChlbXBpcmljYWxseSkgdGhhdCBwb2ludGVyIHRvICANCj4gdGhlIHNrYi0+aGVhZCBhIG11
Y2ggYmV0dGVyIHRyYWNraW5nIElELiBIb3dldmVyLCBJIGFtIG5vdCBzdXJlIHRoYXQgIA0KPiB0
aGVyZSBpcyBubyBvdGhlciBjb3JuZXIgY2FzZXMgd2hlbiBza2ItPmhlYWQgYWxzbyBjYW4gY2hh
bmdlLg0KDQpZZWFoLCB0aG9zZSBhcmUgdHJpY2t5IDotKA0KDQo+ID4gTm90aGluZyBwb3BzIHRv
IG15IG1pbmQuIEJ1dCBJIHRoaW5rIHRoYXQgaWYgeW91IHN0b3JlIHNrYmFkZHI9ZGV2IGZyb20N
Cj4gPiBuZXRpZl9yZWNlaXZlX3NrYiwgeW91IHNob3VsZCBiZSBhYmxlIHRvIGxvb2sgdGhpcyB1
cCBhdCBhIGxhdGVyIHBvaW50DQo+ID4gd2hlcmUgeW91IGtub3cgc2tiLT5wcm9jZXNzIGFzc29j
aWF0aW9uPw0KDQo+IFllcywgSSBoYXZlIGFscmVhZHkgaW1wbGVtZW50ZWQgYW5kIG1ha2Ugc29t
ZSB0ZXN0IG9mIHRoaXMgYXBwcm9hY2g6IEnigJltICANCj4gbGlzdGVuaW5nIGF0IG5ldGlmX3Jl
Y2VpdmVfc2tiIHRyYWNlcG9pbnQgdG8gY3JlYXRlIHNrYl9oZWFkLT5uZXRpZiBtYXAgIA0KPiBh
bmQgdGhlbiBsaXN0ZW5pbmcgZm9yIF9fa2ZyZWVfc2tiIGNhbGxzIHRvIGNyZWF0ZSBwaWQtPnNr
Yl9oZWFkIG1hcC4gIA0KPiBIb3dldmVyLCB0aGlzIGFwcHJvYWNoIGhhdmUgc29tZSB3ZWFrbmVz
c2VzOg0KPiAtIFBhcnQgb2YgcGFja2FnZXMgb2YgVENQIHByb3RvY29sIHBhY2thZ2VzIChBQ0ss
IGZvciBleGFtcGxlKSBhcmUgIA0KPiBoYW5kbGVkIGJ5IHRoZSBrZXJuZWwsIHNvIEkgYWNjb3Vu
dCB0aGlzIHBhY2thZ2VzIGFzIGtlcm5lbCBhY3Rpdml0eS4gQnV0ICANCj4gYWxtb3N0IGV2ZXJ5
IFRDUCBBQ0sgcGFja2FnZSBoYXZlIHNvbWUgIGFzc29jaWF0ZWQgc29ja2V0LCB3aGljaCwgaW4g
IA0KPiB0dXJuLCBoYXZlIGFzc29jaWF0ZWQgcHJvY2Vzcy4NCj4gLSBJIGFtIG5vdCBzdXJlIHRo
YXQgYWxsIHBhY2thZ2UgY29uc3VtZXMgY2FsbCBfX2tmcmVlX3NrYiBhdCB0aGUgZW5kLiAgDQo+
IE1heWJlIHRoZXJlIGlzIHNvbWUgb3RoZXIgbWlzY291bnRpbmcgaW4gdGhpcyBwbGFjZS4NCg0K
PiBNYXliZSB0aGVyZSBpcyBzb21lIG90aGVyIGFwcHJvYWNoZXMgdG8gbWFwIHBhY2thZ2VzIHRv
IHByb2Nlc3Nlcz8NCg0KSSdtIG5vdCBzdXBlciBmYW1pbGlhciB3aXRoIHRob3NlIHRyYWNpbmcg
aG9va3MuIE1heWJlIHlvdSBuZWVkIHRvDQpoYW5kbGUgY29uc3VtZV9za2IgYXMgd2VsbD8NCg0K
SWYgSSB3ZXJlIHRvIHNvbHZlIHNvbWV0aGluZyBsaWtlIHRoaXMsIEknZCBwcm9iYWJseSBsb29r
IGF0IGNncm91cC9pbmdyZXNzDQpob29rcy4gVGhvc2UgYXJlIGd1YXJhbnRlZWQgdG8gcnVuIGZv
ciBldmVyeSBpbmNvbWluZyBwYWNrZXQgaW50byBjZ3JvdXAncw0Kc29ja2V0cy4gKGF0IGxlYXN0
IHJlbW92ZXMgdGhhdCBrZnJlZV9za2IgdnMgY29uc3VtZV9za2IgaXNzdWUpLg0KDQpCdXQgaXQg
ZG9lc24ndCBzb2x2ZSB5b3VyIHByb2JsZW0gd2l0aCB0aGUgY2xvbmVzLi4uDQo=
