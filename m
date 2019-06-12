Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5282642BDB
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409494AbfFLQNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:13:32 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:41769 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409458AbfFLQNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:13:25 -0400
Received: by mail-pl1-f171.google.com with SMTP id s24so6814235plr.8
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4ItLxshqMfqM68z4YCARRhGpvs/wbTADgtzp6LLi8k=;
        b=EByOcF5oR5p8jLYaIHj/W3OAyPEwMFyxrCSaDMZ710yE5WD1Y/b+UNqhkabWO+KS1l
         IgRWkQvJ2NjRclyAP+f+rEMc+so66/pJayjBsfvCjka+fdtro0rRT+G7kG/mV7cxYud+
         DqLOkvG+jeTuQuRkwivcdqKUg66y8+r9eNK3GSX6WWwVM0LTkEGNYmcMgV8xtaI71jUo
         gFzG+TD6/zdIHpyrirE/qQrbJQeDR0ghIWFeujzm+5W4gmflXpO4QMnJsFIg6kJrAry+
         pv87Rmlg0j8CYSgiU2v0e0ld97KdTEUF+/M94iRv9qKosgsTDP8ev18imoJavVyGJMMs
         5lxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4ItLxshqMfqM68z4YCARRhGpvs/wbTADgtzp6LLi8k=;
        b=kOb8mfmAimgtl61FvGNYqxlZW84Jo/r8z5xbDRqIsNDWar6ZcjGcDLyq24is4sF+Vd
         L5PKBcmbD+9cJJmYsZhWu/J1wgWtyDvzQMsIbec/1eY/oCPkJjVTXWdsL5oh42sgYNwu
         ijLBXN+C6ZoSD9H87oVbI5G2nXvjSPXM3pvz4EoSvaNDCGLUgyHbuKJF3InXtKX3SMxT
         6gLXEBa5uWBn7Yrmm93uUo9uczAaeHVLpFEFcSsu4DUaCTq9CMlwdtgGV3AGUDJaJuhF
         DtLUYovjJN5h8kcBPOksmmp2sUYDx8RVqu/i7dT5rf5Ybu+onzuuhAF9wtXz1Qy6SkIx
         4ZZA==
X-Gm-Message-State: APjAAAXKJlCjZrfVlT264F+j4R6q8P3wmIt4LCGBkXJop4loC/HCo02R
        7CCM/dTNU4+a4VvAGrzBe/5ywgzS9TeOVFqzFkYrEQ==
X-Google-Smtp-Source: APXvYqzmdD5qKrrrXe+HCEiDQQKVQS4JJibsx3w0GVW5imo8nYDvtycFLQxTBoJXvBBVIDupEJMTzYRQD7ldjOaUjJg=
X-Received: by 2002:a17:902:1566:: with SMTP id b35mr84417865plh.147.1560356003612;
 Wed, 12 Jun 2019 09:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000927a7b0586561537@google.com> <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
 <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
 <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 12 Jun 2019 18:13:12 +0200
Message-ID: <CAAeHK+wpzHG73AbB+199-TN35Kb1kEjGrKScSqU++7q7RSUGGg@mail.gmail.com>
Subject: Re: [EXT] INFO: trying to register non-static key in del_timer_sync (2)
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Content-Type: multipart/mixed; boundary="00000000000052860b058b22b16c"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000052860b058b22b16c
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 12, 2019 at 6:03 PM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> Hi Dmitry,
>
> We have a patch to fix this: https://patchwork.kernel.org/patch/10990275/

Hi Ganapathi,

Great, thanks for working on this!

We can ask syzbot to test the fix:

#syz test: https://github.com/google/kasan.git usb-fuzzer

Thanks!

>
> Regards,
> Ganapathi

--00000000000052860b058b22b16c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="mwifiex-avoid-deleting-uninitialized-timer-during-USB-cleanup.diff"
Content-Disposition: attachment; 
	filename="mwifiex-avoid-deleting-uninitialized-timer-during-USB-cleanup.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_jwtfnzut0>
X-Attachment-Id: f_jwtfnzut0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC91c2IuYyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC91c2IuYwppbmRleCBjMjM2NWVl
Li45MzlmMWU5IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZp
ZXgvdXNiLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3VzYi5j
CkBAIC0xMzQ4LDYgKzEzNDgsOCBAQCBzdGF0aWMgdm9pZCBtd2lmaWV4X3VzYl9jbGVhbnVwX3R4
X2FnZ3Ioc3RydWN0IG13aWZpZXhfYWRhcHRlciAqYWRhcHRlcikKIAogCWZvciAoaWR4ID0gMDsg
aWR4IDwgTVdJRklFWF9UWF9EQVRBX1BPUlQ7IGlkeCsrKSB7CiAJCXBvcnQgPSAmY2FyZC0+cG9y
dFtpZHhdOworCQlpZiAoIXBvcnQtPnR4X2RhdGFfZXApCisJCQljb250aW51ZTsKIAkJaWYgKGFk
YXB0ZXItPmJ1c19hZ2dyLmVuYWJsZSkKIAkJCXdoaWxlICgoc2tiX3RtcCA9CiAJCQkJc2tiX2Rl
cXVldWUoJnBvcnQtPnR4X2FnZ3IuYWdncl9saXN0KSkpCkBAIC0xMzY1LDggKzEzNjcsNiBAQCBz
dGF0aWMgdm9pZCBtd2lmaWV4X3VucmVnaXN0ZXJfZGV2KHN0cnVjdCBtd2lmaWV4X2FkYXB0ZXIg
KmFkYXB0ZXIpCiAKIAltd2lmaWV4X3VzYl9mcmVlKGNhcmQpOwogCi0JbXdpZmlleF91c2JfY2xl
YW51cF90eF9hZ2dyKGFkYXB0ZXIpOwotCiAJY2FyZC0+YWRhcHRlciA9IE5VTEw7CiB9CiAKQEAg
LTE1MTAsNyArMTUxMCw3IEBAIHN0YXRpYyBpbnQgbXdpZmlleF9wcm9nX2Z3X3dfaGVscGVyKHN0
cnVjdCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIsCiBzdGF0aWMgaW50IG13aWZpZXhfdXNiX2Ru
bGRfZncoc3RydWN0IG13aWZpZXhfYWRhcHRlciAqYWRhcHRlciwKIAkJCXN0cnVjdCBtd2lmaWV4
X2Z3X2ltYWdlICpmdykKIHsKLQlpbnQgcmV0OworCWludCByZXQgPSAwOwogCXN0cnVjdCB1c2Jf
Y2FyZF9yZWMgKmNhcmQgPSAoc3RydWN0IHVzYl9jYXJkX3JlYyAqKWFkYXB0ZXItPmNhcmQ7CiAK
IAlpZiAoY2FyZC0+dXNiX2Jvb3Rfc3RhdGUgPT0gVVNCOFhYWF9GV19ETkxEKSB7CkBAIC0xNTIz
LDEwICsxNTIzLDYgQEAgc3RhdGljIGludCBtd2lmaWV4X3VzYl9kbmxkX2Z3KHN0cnVjdCBtd2lm
aWV4X2FkYXB0ZXIgKmFkYXB0ZXIsCiAJCQlyZXR1cm4gLTE7CiAJfQogCi0JcmV0ID0gbXdpZmll
eF91c2JfcnhfaW5pdChhZGFwdGVyKTsKLQlpZiAoIXJldCkKLQkJcmV0ID0gbXdpZmlleF91c2Jf
dHhfaW5pdChhZGFwdGVyKTsKLQogCXJldHVybiByZXQ7CiB9CiAKQEAgLTE1ODQsNyArMTU4MCwy
OSBAQCBzdGF0aWMgdm9pZCBtd2lmaWV4X3VzYl9zdWJtaXRfcmVtX3J4X3VyYnMoc3RydWN0IG13
aWZpZXhfYWRhcHRlciAqYWRhcHRlcikKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGludCBtd2lm
aWV4X2luaXRfdXNiKHN0cnVjdCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIpCit7CisJc3RydWN0
IHVzYl9jYXJkX3JlYyAqY2FyZCA9IChzdHJ1Y3QgdXNiX2NhcmRfcmVjICopYWRhcHRlci0+Y2Fy
ZDsKKwlpbnQgcmV0ID0gMDsKKworCWlmIChjYXJkLT51c2JfYm9vdF9zdGF0ZSA9PSBVU0I4WFhY
X0ZXX0ROTEQpCisJCXJldHVybiAwOworCisJcmV0ID0gbXdpZmlleF91c2JfcnhfaW5pdChhZGFw
dGVyKTsKKwlpZiAoIXJldCkKKwkJcmV0ID0gbXdpZmlleF91c2JfdHhfaW5pdChhZGFwdGVyKTsK
KworCXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyB2b2lkIG13aWZpZXhfY2xlYW51cF91c2Ioc3Ry
dWN0IG13aWZpZXhfYWRhcHRlciAqYWRhcHRlcikKK3sKKwltd2lmaWV4X3VzYl9jbGVhbnVwX3R4
X2FnZ3IoYWRhcHRlcik7Cit9CisKIHN0YXRpYyBzdHJ1Y3QgbXdpZmlleF9pZl9vcHMgdXNiX29w
cyA9IHsKKwkuaW5pdF9pZiA9CQltd2lmaWV4X2luaXRfdXNiLAorCS5jbGVhbnVwX2lmID0JCW13
aWZpZXhfY2xlYW51cF91c2IsCiAJLnJlZ2lzdGVyX2RldiA9CQltd2lmaWV4X3JlZ2lzdGVyX2Rl
diwKIAkudW5yZWdpc3Rlcl9kZXYgPQltd2lmaWV4X3VucmVnaXN0ZXJfZGV2LAogCS53YWtldXAg
PQkJbXdpZmlleF9wbV93YWtldXBfY2FyZCwK
--00000000000052860b058b22b16c--
