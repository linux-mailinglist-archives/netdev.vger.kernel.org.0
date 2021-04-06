Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D71355F8C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhDFXjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbhDFXjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:39:43 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CAAC06174A;
        Tue,  6 Apr 2021 16:39:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 98B924D2493A4;
        Tue,  6 Apr 2021 16:39:26 -0700 (PDT)
Date:   Tue, 06 Apr 2021 16:39:21 -0700 (PDT)
Message-Id: <20210406.163921.1678926610292877597.davem@davemloft.net>
To:     mail@anirudhrb.com
Cc:     kuba@kernel.org, oneukum@suse.com, kernel@esmil.dk,
        geert@linux-m68k.org, zhengyongjun3@huawei.com, rkovhaev@gmail.com,
        gregkh@linuxfoundation.org,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hso: fix null-ptr-deref during tty device
 unregistration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210406124402.20930-1-mail@anirudhrb.com>
References: <20210406124402.20930-1-mail@anirudhrb.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 06 Apr 2021 16:39:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5pcnVkaCBSYXlhYmhhcmFtIDxtYWlsQGFuaXJ1ZGhyYi5jb20+DQpEYXRlOiBUdWUs
ICA2IEFwciAyMDIxIDE4OjEzOjU5ICswNTMwDQoNCj4gTXVsdGlwbGUgdHR5cyB0cnkgdG8gY2xh
aW0gdGhlIHNhbWUgdGhlIG1pbm9yIG51bWJlciBjYXVzaW5nIGEgZG91YmxlDQo+IHVucmVnaXN0
cmF0aW9uIG9mIHRoZSBzYW1lIGRldmljZS4gVGhlIGZpcnN0IHVucmVnaXN0cmF0aW9uIHN1Y2Nl
ZWRzDQo+IGJ1dCB0aGUgbmV4dCBvbmUgcmVzdWx0cyBpbiBhIG51bGwtcHRyLWRlcmVmLg0KPiAN
Cj4gVGhlIGdldF9mcmVlX3NlcmlhbF9pbmRleCgpIGZ1bmN0aW9uIHJldHVybnMgYW4gYXZhaWxh
YmxlIG1pbm9yIG51bWJlcg0KPiBidXQgZG9lc24ndCBhc3NpZ24gaXQgaW1tZWRpYXRlbHkuIFRo
ZSBhc3NpZ25tZW50IGlzIGRvbmUgYnkgdGhlIGNhbGxlcg0KPiBsYXRlci4gQnV0IGJlZm9yZSB0
aGlzIGFzc2lnbm1lbnQsIGNhbGxzIHRvIGdldF9mcmVlX3NlcmlhbF9pbmRleCgpDQo+IHdvdWxk
IHJldHVybiB0aGUgc2FtZSBtaW5vciBudW1iZXIuDQo+IA0KPiBGaXggdGhpcyBieSBtb2RpZnlp
bmcgZ2V0X2ZyZWVfc2VyaWFsX2luZGV4IHRvIGFzc2lnbiB0aGUgbWlub3IgbnVtYmVyDQo+IGlt
bWVkaWF0ZWx5IGFmdGVyIG9uZSBpcyBmb3VuZCB0byBiZSBhbmQgcmVuYW1lIGl0IHRvIG9idGFp
bl9taW5vcigpDQo+IHRvIGJldHRlciByZWZsZWN0IHdoYXQgaXQgZG9lcy4gU2ltaWxhcnksIHJl
bmFtZSBzZXRfc2VyaWFsX2J5X2luZGV4KCkNCj4gdG8gcmVsZWFzZV9taW5vcigpIGFuZCBtb2Rp
ZnkgaXQgdG8gZnJlZSB1cCB0aGUgbWlub3IgbnVtYmVyIG9mIHRoZQ0KPiBnaXZlbiBoc29fc2Vy
aWFsLiBFdmVyeSBvYnRhaW5fbWlub3IoKSBzaG91bGQgaGF2ZSBjb3JyZXNwb25kaW5nDQo+IHJl
bGVhc2VfbWlub3IoKSBjYWxsLg0KPiANCj4gUmVwb3J0ZWQtYnk6IHN5emJvdCtjNDlmZTYwODlm
Mjk1YTA1ZTZmOEBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+IFRlc3RlZC1ieTogc3l6Ym90
K2M0OWZlNjA4OWYyOTVhMDVlNmY4QHN5emthbGxlci5hcHBzcG90bWFpbC5jb20NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IEFuaXJ1ZGggUmF5YWJoYXJhbSA8bWFpbEBhbmlydWRocmIuY29tPg0KDQpU
aGlzIGFkZHMgYSBuZXcgYnVpbGQgd2FybmluZzoNCg0KICBDQyBbTV0gIGRyaXZlcnMvbmV0L3Vz
Yi9oc28ubw0KZHJpdmVycy9uZXQvdXNiL2hzby5jOiBJbiBmdW5jdGlvbiChaHNvX3NlcmlhbF9j
b21tb25fY3JlYXRlojoNCmRyaXZlcnMvbmV0L3VzYi9oc28uYzoyMjU2OjY6IHdhcm5pbmc6IHVu
dXNlZCB2YXJpYWJsZSChbWlub3KiIFstV3VudXNlZC12YXJpYWJsZV0NCg0KUGxlYXNlIGZpeCB0
aGlzIGFuZCBhZGQgYW4gYXBwcm9wcmlhdGUgRml4ZXM6IHRhZywgdGhhbmsgeW91Lg0K
