Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6418AEA59
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfD2SnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:43:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44052 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbfD2SnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:43:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id z16so5567333pgv.11;
        Mon, 29 Apr 2019 11:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=BQ3C86GZREydUaCz0afmFgD6JoCVkrw+ph7zwQtPSd8=;
        b=gWXpB2518rHeRXMNSaY9SOXHzJEDw2gQPD3i97nYJ9iSAh3gS/Dsy3MpHdLqKD7O9j
         7M3CFmerec2nVCIgaTBiAkfJsluQ3s8UW2f4A6KX2KVg7n2luzCdtMIaYZVEPkTLlHYk
         QhpGRQ04kgHeTvXEuERtT5f1XZfc7W4Di8Ql+dPNdGcKKecDTnSLLtZ0tien+fodFgNp
         UaCHhY5b6AWmpr7Fx6TYp4VC7fo7ul19GNyNGApyBS041uwDBqpcIzZWr3YnhsWg9V8Y
         TtIjfR8Add42KdkZfYiMBuV4P944MF3feEAuCDdccwBHTvJ3eIzQPWSoJVXIC6VJWNDV
         bZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=BQ3C86GZREydUaCz0afmFgD6JoCVkrw+ph7zwQtPSd8=;
        b=c9XVFlF+87botix4XGr/k7EHwI9a6cOxhnLnCwikN2+GSDQSUqzjOrH2f86ZvYgvKQ
         uU9QEm3JaPvjli2fdc5Mqj8z5yHLmImxgUKwdfzQWRBCr4QgLtrUOcZJ91twwHXlYAfd
         Ljoz7Ta6RDIqblVUh07tb24EMMErB1OLSItO3KOg0roUk1opeSp0gRWK8NLmOW/mFwvC
         rHOUNPLsOOVoCkIdsi5W4Od55b+YpQYJn3bnc0gzIMF33H43c+sFRtmZ0sgZT6G3gssA
         ckPFcGYl2nSG9qQ71Ag7Zkr/vsY5RwwQMr+I5WrOjVkEujc3fi3YnEL2pjrhfNRGX6Vl
         rnhA==
X-Gm-Message-State: APjAAAWUpD/s3ukUaz6Anw7Qa/vtDwUPQkiZgIyf9qE6JGSoU2Ob6BN/
        vKdiyYow1SEMpKmJApKP2j4=
X-Google-Smtp-Source: APXvYqwMKjexBovL0Lkg0tmEZR0WTj2q5zpdxwqjddZNLVGfdIAQMESAaCnzw2RLu/9Jh97Fe6bkjQ==
X-Received: by 2002:a63:521c:: with SMTP id g28mr60165132pgb.431.1556563398136;
        Mon, 29 Apr 2019 11:43:18 -0700 (PDT)
Received: from [172.27.227.196] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id d8sm37252833pgv.34.2019.04.29.11.43.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 11:43:16 -0700 (PDT)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     David Ahern <dsahern@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Julian Anastasov <ja@ssi.bg>, Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp>
 <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp>
 <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com>
 <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp>
 <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com>
 <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
 <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
Date:   Mon, 29 Apr 2019 12:43:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------A130DC68AA00417E350956C2"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------A130DC68AA00417E350956C2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 4/29/19 12:34 PM, David Ahern wrote:
> On 4/27/19 10:22 PM, Tetsuo Handa wrote:
>> On 2019/04/28 8:52, Eric Dumazet wrote:
>>> On 4/27/19 3:33 PM, Tetsuo Handa wrote:
>>>>
>>>> I'm waiting for davem why it is safe to move the dst entry from
>>>> "a device to unregister" to "a loopback device in that namespace".
>>>> I'm waiting for an explanation how the dst entry which was moved to
>>>> "a loopback device in that namespace" is released (i.e. what the
>>>> expected shutdown sequence is).
>>>
>>> The most probable explanation is that we make sure the loopback device
>>> is the last one to be dismantled at netns deletion,
>>> and this would obviously happen after all dst have been released.
>>>
>>
>> rt_flush_dev() becomes a no-op if "dev" == "a loopback device in that
>> namespace". And according to debug printk(), rt_flush_dev() is called
>> on "a loopback device in that namespace" itself.
>>
>> If "a loopback device in that namespace" is the last "one" (== "a network
>> device in that namespace" ?), which shutdown sequence should have called
>> dev_put("a loopback device in that namespace") before unregistration of
>> "a loopback device in that namespace" starts?
>>
>> Since I'm not a netdev person, I appreciate if you can explain
>> that shutdown sequence using a flow chart.
>>
> 
> The attached patch adds a tracepoint to notifier_call_chain. If you have
> KALLSYMS enabled it will show the order of the function handlers:
> 
> perf record -e notifier:* -a -g &
> 
> ip netns del <NAME>
> <wait a few seconds>
> 
> fg
> <ctrl-c on perf-record>
> 
> perf script
> 

with the header file this time.

--------------A130DC68AA00417E350956C2
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-notifier-add-tracepoint-to-notifier_call_chain.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-notifier-add-tracepoint-to-notifier_call_chain.patch"

RnJvbSBkZThiZmFlMDYwNmQ3NDg5MDhhNzBhNDM1ZmVlOWQ5Y2U1N2IxM2VhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+
CkRhdGU6IE1vbiwgMjkgQXByIDIwMTkgMTE6Mzg6NDkgLTA3MDAKU3ViamVjdDogW1BBVENI
XSBub3RpZmllcjogYWRkIHRyYWNlcG9pbnQgdG8gbm90aWZpZXJfY2FsbF9jaGFpbgoKU2ln
bmVkLW9mZi1ieTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPgotLS0KIGluY2x1
ZGUvdHJhY2UvZXZlbnRzL25vdGlmaWVyLmggfCA0OSArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKwoga2VybmVsL25vdGlmaWVyLmMgICAgICAgICAgICAgICB8
ICAzICsrKwogMiBmaWxlcyBjaGFuZ2VkLCA1MiBpbnNlcnRpb25zKCspCiBjcmVhdGUgbW9k
ZSAxMDA2NDQgaW5jbHVkZS90cmFjZS9ldmVudHMvbm90aWZpZXIuaAoKZGlmZiAtLWdpdCBh
L2luY2x1ZGUvdHJhY2UvZXZlbnRzL25vdGlmaWVyLmggYi9pbmNsdWRlL3RyYWNlL2V2ZW50
cy9ub3RpZmllci5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4u
N2M1MzFhMTEzNWNiCi0tLSAvZGV2L251bGwKKysrIGIvaW5jbHVkZS90cmFjZS9ldmVudHMv
bm90aWZpZXIuaApAQCAtMCwwICsxLDQ5IEBACisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMCAqLworI3VuZGVmIFRSQUNFX1NZU1RFTQorI2RlZmluZSBUUkFDRV9TWVNU
RU0gbm90aWZpZXIKKworI2lmICFkZWZpbmVkKF9UUkFDRV9OT1RJRklFUl9IKSB8fCBkZWZp
bmVkKFRSQUNFX0hFQURFUl9NVUxUSV9SRUFEKQorI2RlZmluZSBfVFJBQ0VfTk9USUZJRVJf
SAorCisjaW5jbHVkZSA8bGludXgvbm90aWZpZXIuaD4KKyNpbmNsdWRlIDxsaW51eC9rYWxs
c3ltcy5oPgorI2luY2x1ZGUgPGxpbnV4L3RyYWNlcG9pbnQuaD4KKworVFJBQ0VfRVZFTlQo
bm90aWZpZXJfY2FsbF9jaGFpbiwKKworCVRQX1BST1RPKHN0cnVjdCBub3RpZmllcl9ibG9j
ayAqbmIsIHVuc2lnbmVkIGxvbmcgdmFsKSwKKworCVRQX0FSR1MobmIsIHZhbCksCisKKwlU
UF9TVFJVQ1RfX2VudHJ5KAorCQlfX2ZpZWxkKAl1NjQsCXZhbAkpCisJCV9fZmllbGQoCXU2
NCwJZmNuCSkKKwkJX19keW5hbWljX2FycmF5KGNoYXIsICBmY25zdHIsICAgS1NZTV9TWU1C
T0xfTEVOKQorCSksCisKKwlUUF9mYXN0X2Fzc2lnbigKKwkJdm9pZCAqcCA9IG5iLT5ub3Rp
Zmllcl9jYWxsOworCQljaGFyIHN5bVtLU1lNX1NZTUJPTF9MRU5dOworCisJCV9fZW50cnkt
PnZhbCA9IHZhbDsKKwkJX19lbnRyeS0+ZmNuID0gKHU2NCkgcDsKKworCQlwID0gZGVyZWZl
cmVuY2Vfc3ltYm9sX2Rlc2NyaXB0b3IocCk7CisjaWZkZWYgQ09ORklHX0tBTExTWU1TCisJ
CXNwcmludF9zeW1ib2xfbm9fb2Zmc2V0KHN5bSwgX19lbnRyeS0+ZmNuKTsKKwkJLyogYXZv
aWQgYSBib2d1cyB3YXJuaW5nOgorCQkgKiAidGhlIGFkZHJlc3Mgb2Ygc3ltIHdpbGwgYWx3
YXlzIGV2YWx1YXRlIGFzIHRydWUiCisJCSAqIGJ5IHVzaW5nICZzeW1bMF0KKwkJICovCisJ
CV9fYXNzaWduX3N0cihmY25zdHIsICZzeW1bMF0pOworI2Vsc2UKKwkJX19lbnRyeS0+ZmNu
c3RyWzBdID0gJ1wwJzsKKyNlbmRpZgorCSksCisKKwlUUF9wcmludGsoInZhbCAlbGxkIGZj
biAlbGx4IG5hbWUgJXMiLCBfX2VudHJ5LT52YWwsIF9fZW50cnktPmZjbiwgX19nZXRfc3Ry
KGZjbnN0cikpCispOworI2VuZGlmIC8qIF9UUkFDRV9OT1RJRklFUl9IICovCisKKy8qIFRo
aXMgcGFydCBtdXN0IGJlIG91dHNpZGUgcHJvdGVjdGlvbiAqLworI2luY2x1ZGUgPHRyYWNl
L2RlZmluZV90cmFjZS5oPgpkaWZmIC0tZ2l0IGEva2VybmVsL25vdGlmaWVyLmMgYi9rZXJu
ZWwvbm90aWZpZXIuYwppbmRleCA2MTk2YWY4YTgyMjMuLjliNjVhOWM1NmZkNyAxMDA2NDQK
LS0tIGEva2VybmVsL25vdGlmaWVyLmMKKysrIGIva2VybmVsL25vdGlmaWVyLmMKQEAgLTUs
NiArNSw4IEBACiAjaW5jbHVkZSA8bGludXgvcmN1cGRhdGUuaD4KICNpbmNsdWRlIDxsaW51
eC92bWFsbG9jLmg+CiAjaW5jbHVkZSA8bGludXgvcmVib290Lmg+CisjZGVmaW5lIENSRUFU
RV9UUkFDRV9QT0lOVFMKKyNpbmNsdWRlIDx0cmFjZS9ldmVudHMvbm90aWZpZXIuaD4KIAog
LyoKICAqCU5vdGlmaWVyIGxpc3QgZm9yIGtlcm5lbCBjb2RlIHdoaWNoIHdhbnRzIHRvIGJl
IGNhbGxlZApAQCAtOTAsNiArOTIsNyBAQCBzdGF0aWMgaW50IG5vdGlmaWVyX2NhbGxfY2hh
aW4oc3RydWN0IG5vdGlmaWVyX2Jsb2NrICoqbmwsCiAJCQljb250aW51ZTsKIAkJfQogI2Vu
ZGlmCisJCXRyYWNlX25vdGlmaWVyX2NhbGxfY2hhaW4obmIsIHZhbCk7CiAJCXJldCA9IG5i
LT5ub3RpZmllcl9jYWxsKG5iLCB2YWwsIHYpOwogCiAJCWlmIChucl9jYWxscykKLS0gCjIu
MTEuMAoK
--------------A130DC68AA00417E350956C2--
