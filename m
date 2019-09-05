Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA09AA13C
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 13:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbfIELYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 07:24:34 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33078 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732541AbfIELYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 07:24:34 -0400
Received: by mail-pl1-f193.google.com with SMTP id t11so1175383plo.0
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 04:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oautEYXJNPg/LAxxq6KlzXzuc7s3EzH8MSqml3mnlFM=;
        b=LBAX7V6D1Th2QUfX/hRQEHFvGDknVdyFkdXkIGgUFkxAk71cJS7G6lToozs2iu8Mu8
         IQTQRSRqI+MDORXMr1YoTANBKUF9rZYD55NsSR7xubUHPn/sanRnQw/RSlfnvoEyfpzk
         DsWs4tEgDfO6hnU9U9z5vTyNFILRWeenXG8IP/D+2Y9DHv8+KxklGSvCJDobVsdLzwbf
         pnsqLg/MeGCE0evJfnekkkkUrBQPaO2jyzEMoKp5p7+W59kPOzCkq1W2a7hPII36GUs0
         n+Yx9VprJg/gWKbZz+kda/jHxDOGXMZRgVkj7CPp2//Roi+nGzE/ckhwkFRGyiINfNc+
         5OsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oautEYXJNPg/LAxxq6KlzXzuc7s3EzH8MSqml3mnlFM=;
        b=BZuLDKp9tm4B3fQfcbwZsykeUMXSuTpTnwBpp3mKtP/4qcu/eKMQROppLdZRQU2Fio
         1HIrYRzMewG4auKFlcVGFgUL/CJrTLOyFQi+1rQ/vzGsRZEX8v6T9TaqJYn5KbfcILbZ
         HaDS2OnQEXhx/9WhlqsEqTt38OLwJ3AFiyOV/Asvpt/n1jqzVehlvpBEaPeigN3j7Bo/
         WhxinKQgnzsz/2ORnVk5/B9Ushn48zEculOpGcwPbHH+7fYTmuHwF/mEgdL3wrqBFB5j
         4dG1ZdYQnzVnMOB2XoOg+GDnJREAJb6VhaLbcdCf86JHeogm/0ZADmLrVQcDBUc/Oijl
         8QmQ==
X-Gm-Message-State: APjAAAU+yq9Y/hTdtNREzlVI05aRNmKAeZnEBN2arZXygpWdzDvLKGrq
        v2d6f8/6vsX0Q77NsOe7wQ9ow5gTGD0xhOV2MV6/eQ==
X-Google-Smtp-Source: APXvYqzYlJ+6XFJMLoIVm5KsjILP4hj1Nh+pP6z9kQbgaMFL3BtoAq5YkC9z3vteSvPXzaBhc1WHdlr4zCbLtT7lfnU=
X-Received: by 2002:a17:902:8c92:: with SMTP id t18mr277036plo.147.1567682673098;
 Thu, 05 Sep 2019 04:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000002a95df0591a4f114@google.com> <d6e4d2da-66c6-a8fe-2fea-a3435fa7cb54@gmail.com>
 <20190904154140.45dfb398@hermes.lan> <285edb24-01f9-3f9d-4946-b2f41ccd0774@gmail.com>
In-Reply-To: <285edb24-01f9-3f9d-4946-b2f41ccd0774@gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Thu, 5 Sep 2019 13:24:21 +0200
Message-ID: <CAAeHK+y3eQ7bXvo1tiAkwLCsFkbSU5B+6hsKbdEzkSXP2_Jyzg@mail.gmail.com>
Subject: Re: WARNING in hso_free_net_device
To:     Hui Peng <benquike@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        alexios.zavras@intel.com, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        netdev <netdev@vger.kernel.org>, rfontana@redhat.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>
Content-Type: multipart/mixed; boundary="000000000000dabb730591cc9008"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000dabb730591cc9008
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 5, 2019 at 4:20 AM Hui Peng <benquike@gmail.com> wrote:
>
> Can you guys have  a look at the attached patch?

Let's try it:

#syz test: https://github.com/google/kasan.git eea39f24

FYI: there are two more reports coming from this driver, which might
(or might not) have the same root cause. One of them has a suggested
fix by Oliver.

https://syzkaller.appspot.com/bug?extid=67b2bd0e34f952d0321e
https://syzkaller.appspot.com/bug?extid=93f2f45b19519b289613

>
> On 9/4/19 6:41 PM, Stephen Hemminger wrote:
> > On Wed, 4 Sep 2019 16:27:50 -0400
> > Hui Peng <benquike@gmail.com> wrote:
> >
> >> Hi, all:
> >>
> >> I looked at the bug a little.
> >>
> >> The issue is that in the error handling code, hso_free_net_device
> >> unregisters
> >>
> >> the net_device (hso_net->net)  by calling unregister_netdev. In the
> >> error handling code path,
> >>
> >> hso_net->net has not been registered yet.
> >>
> >> I think there are two ways to solve the issue:
> >>
> >> 1. fix it in drivers/net/usb/hso.c to avoiding unregistering the
> >> net_device when it is still not registered
> >>
> >> 2. fix it in unregister_netdev. We can add a field in net_device to
> >> record whether it is registered, and make unregister_netdev return if
> >> the net_device is not registered yet.
> >>
> >> What do you guys think ?
> > #1

--000000000000dabb730591cc9008
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Fix-a-wrong-unregistering-bug-in-hso_free_net_device.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-a-wrong-unregistering-bug-in-hso_free_net_device.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k06lry3b0>
X-Attachment-Id: f_k06lry3b0

RnJvbSBmM2ZkZWU4ZmMwM2FhMmJjOTgyZjIyZGExZDI5YmJmNmJjYTcyOTM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSHVpIFBlbmcgPGJlbnF1aWtlQGdtYWlsLmNvbT4NCkRhdGU6
IFdlZCwgNCBTZXAgMjAxOSAyMTozODozNSAtMDQwMA0KU3ViamVjdDogW1BBVENIXSBGaXggYSB3
cm9uZyB1bnJlZ2lzdGVyaW5nIGJ1ZyBpbiBoc29fZnJlZV9uZXRfZGV2aWNlDQoNCkFzIHNob3du
IGJlbG93LCBoc29fY3JlYXRlX25ldF9kZXZpY2UgbWF5IGNhbGwgaHNvX2ZyZWVfbmV0X2Rldmlj
ZQ0KYmVmb3JlIHRoZSBuZXRfZGV2aWNlIGlzIHJlZ2lzdGVyZWQuIGhzb19mcmVlX25ldF9kZXZp
Y2Ugd2lsbA0KdW5yZWdpc3RlciB0aGUgbmV0d29yayBkZXZpY2Ugbm8gbWF0dGVyIGl0IGlzIHJl
Z2lzdGVyZWQgb3Igbm90LA0KdW5yZWdpc3Rlcl9uZXRkZXYgaXMgbm90IGFibGUgdG8gaGFuZGxl
IHVucmVnaXN0ZXJlZCBuZXRfZGV2aWNlLA0KcmVzdWx0aW5nIGluIHRoZSBidWcgcmVwb3J0ZWQg
YnkgdGhlIHN5emJvdC4NCg0KYGBgDQpzdGF0aWMgc3RydWN0IGhzb19kZXZpY2UgKmhzb19jcmVh
dGVfbmV0X2RldmljZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZXJmYWNlLA0KCQkJCQkgICAg
ICAgaW50IHBvcnRfc3BlYykNCnsNCgkuLi4uLi4NCgluZXQgPSBhbGxvY19uZXRkZXYoc2l6ZW9m
KHN0cnVjdCBoc29fbmV0KSwgImhzbyVkIiwgTkVUX05BTUVfVU5LTk9XTiwNCiAgICAgIAkJCSAg
ICBoc29fbmV0X2luaXQpOw0KCS4uLi4uLg0KCWlmICghaHNvX25ldC0+b3V0X2VuZHApIHsNCiAg
IAkgICAJZGV2X2VycigmaW50ZXJmYWNlLT5kZXYsICJDYW4ndCBmaW5kIEJVTEsgT1VUIGVuZHBv
aW50XG4iKTsNCgkJZ290byBleGl0Ow0KCX0NCg0KCS4uLi4uLg0KCXJlc3VsdCA9IHJlZ2lzdGVy
X25ldGRldihuZXQpOw0KCS4uLi4uLg0KZXhpdDoNCgloc29fZnJlZV9uZXRfZGV2aWNlKGhzb19k
ZXYpOw0KCXJldHVybiBOVUxMOw0KfQ0KDQpzdGF0aWMgdm9pZCBoc29fZnJlZV9uZXRfZGV2aWNl
KHN0cnVjdCBoc29fZGV2aWNlICpoc29fZGV2KQ0Kew0KCS4uLi4uLg0KCWlmIChoc29fbmV0LT5u
ZXQpDQoJCXVucmVnaXN0ZXJfbmV0ZGV2KGhzb19uZXQtPm5ldCk7DQoJLi4uLi4uDQp9DQoNCmBg
YA0KDQpUaGlzIHBhdGNoIGFkZHMgYSBuZXRfcmVnaXN0ZXJlZCBmaWVsZCBpbiBzdHJ1Y3QgaHNv
X25ldCB0byByZWNvcmQgd2hldGhlcg0KdGhlIGNvbnRhaW5pbmcgbmV0X2RldmljZSBpcyByZWdp
c3RlcmVkIG9yIG5vdCwgYW5kIGF2b2lkIHVucmVnaXN0ZXJpbmcgaXQNCmlmIGl0IGlzIG5vdCBy
ZWdpc3RlcmVkIHlldC4NCg0KUmVwb3J0ZWQtYnk6IHN5emJvdCs0NGQ1M2M3MjU1YmIxYWVhMjJk
MkBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQpTaWduZWQtb2ZmLWJ5OiBIdWkgUGVuZyA8YmVu
cXVpa2VAZ21haWwuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvdXNiL2hzby5jIHwgNCArKystDQog
MSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvdXNiL2hzby5jIGIvZHJpdmVycy9uZXQvdXNiL2hzby5jDQppbmRl
eCBjZTc4NzE0Li41YjNkZjMzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdXNiL2hzby5jDQor
KysgYi9kcml2ZXJzL25ldC91c2IvaHNvLmMNCkBAIC0xMjgsNiArMTI4LDcgQEAgc3RydWN0IGhz
b19zaGFyZWRfaW50IHsNCiBzdHJ1Y3QgaHNvX25ldCB7DQogCXN0cnVjdCBoc29fZGV2aWNlICpw
YXJlbnQ7DQogCXN0cnVjdCBuZXRfZGV2aWNlICpuZXQ7DQorCWJvb2wgbmV0X3JlZ2lzdGVyZWQ7
DQogCXN0cnVjdCByZmtpbGwgKnJma2lsbDsNCiAJY2hhciBuYW1lWzI0XTsNCiANCkBAIC0yMzYy
LDcgKzIzNjMsNyBAQCBzdGF0aWMgdm9pZCBoc29fZnJlZV9uZXRfZGV2aWNlKHN0cnVjdCBoc29f
ZGV2aWNlICpoc29fZGV2KQ0KIA0KIAlyZW1vdmVfbmV0X2RldmljZShoc29fbmV0LT5wYXJlbnQp
Ow0KIA0KLQlpZiAoaHNvX25ldC0+bmV0KQ0KKwlpZiAoaHNvX25ldC0+bmV0ICYmIGhzb19uZXQt
Pm5ldF9yZWdpc3RlcmVkKQ0KIAkJdW5yZWdpc3Rlcl9uZXRkZXYoaHNvX25ldC0+bmV0KTsNCiAN
CiAJLyogc3RhcnQgZnJlZWluZyAqLw0KQEAgLTI1NDQsNiArMjU0NSw3IEBAIHN0YXRpYyBzdHJ1
Y3QgaHNvX2RldmljZSAqaHNvX2NyZWF0ZV9uZXRfZGV2aWNlKHN0cnVjdCB1c2JfaW50ZXJmYWNl
ICppbnRlcmZhY2UsDQogCQlkZXZfZXJyKCZpbnRlcmZhY2UtPmRldiwgIkZhaWxlZCB0byByZWdp
c3RlciBkZXZpY2VcbiIpOw0KIAkJZ290byBleGl0Ow0KIAl9DQorCWhzb19uZXQtPm5ldF9yZWdp
c3RlcmVkID0gdHJ1ZTsNCiANCiAJaHNvX2xvZ19wb3J0KGhzb19kZXYpOw0KIA0KLS0gDQoyLjcu
NA0KDQo=
--000000000000dabb730591cc9008--
