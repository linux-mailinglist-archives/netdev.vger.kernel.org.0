Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A04EA36
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfD2Se7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:34:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35982 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbfD2Se7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:34:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id v80so1158755pfa.3;
        Mon, 29 Apr 2019 11:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=R95+cNuWkIFZnhdtaDboYNwHP5ScfwcWH/l0fWKKkd8=;
        b=K2Bgw87tnwhI/93ci3Ltv0UORl164W9D6VfuYRN8aASftib4j62ARHOR8NJkgmsGwd
         kn4f09U0KwCIQ+TPINseJLDOfBWW88aGGA5MFNRZPki2wyjg3pDl53rchUfuy0qzq3e0
         u8t5+Qq5zKLaEYGIVhQxn0EqefFcP1TxDOrdHI2JXgG6Pgfg1/1XAVp7abz7SW71gNHC
         nWhXlCAAQ70vhezdPhMbQM0Qew9BoBEWxFcTy1Eu/7Dj+tvlZdvFY5+kFhARYn2/5T9B
         W8svw1yJbsSQW62U55pTcqnofCUM3zUg+4osOYdoeHSU7lIj6rjOe6hxFA21zXBtzHCW
         Lr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=R95+cNuWkIFZnhdtaDboYNwHP5ScfwcWH/l0fWKKkd8=;
        b=szBa6vgTkrD1Ht+d5/Wi6o2s1kvhrO+u618oL13KY/HXrOuY0fbEuoy4ZPuyMiideL
         yf9cl8SsjZ+pscquOZYCTjrJLyQ8+hfHMBOSF6xUbDZ8p1J9hOas0COj8IxUsRl7wMDd
         ZCxM2HmPbUM7GTeZOoWuSyK6XAGHLgnsJBnDLzSCJxZMviaxVTZvUI5xjLv+w9CpLBkh
         CUZ9nVXrWIN/xKayytzIMBsj2cnh834GbBC8Zgaprbo4imhTJj9aONr8/HZzt2SDcPYD
         5gKM5jRs4geL+t72uA1ZTuOlHvQrxYvJCByF4+trHouyWLEpuwmKG1v5B2wvG6RCI3Rv
         YQyg==
X-Gm-Message-State: APjAAAUXp2gBK366AENXA9+CxL+S5Y7mMvFepltz2evb23oZWOY5yHjF
        VL54Ntc3WoIDfXQ/IeOP/5s=
X-Google-Smtp-Source: APXvYqxHVzbrr3n6aKge7sXVjBxYitHE198LQU9yGpgqT2irmKf4QLdPRr27quFeiMMwGS/HJjas+Q==
X-Received: by 2002:a63:8949:: with SMTP id v70mr12135945pgd.196.1556562898523;
        Mon, 29 Apr 2019 11:34:58 -0700 (PDT)
Received: from [172.27.227.196] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id f71sm68850310pfc.109.2019.04.29.11.34.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 11:34:56 -0700 (PDT)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
Date:   Mon, 29 Apr 2019 12:34:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
Content-Type: multipart/mixed;
 boundary="------------A2951BECD619E8BAAC5FD632"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------A2951BECD619E8BAAC5FD632
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 4/27/19 10:22 PM, Tetsuo Handa wrote:
> On 2019/04/28 8:52, Eric Dumazet wrote:
>> On 4/27/19 3:33 PM, Tetsuo Handa wrote:
>>>
>>> I'm waiting for davem why it is safe to move the dst entry from
>>> "a device to unregister" to "a loopback device in that namespace".
>>> I'm waiting for an explanation how the dst entry which was moved to
>>> "a loopback device in that namespace" is released (i.e. what the
>>> expected shutdown sequence is).
>>
>> The most probable explanation is that we make sure the loopback device
>> is the last one to be dismantled at netns deletion,
>> and this would obviously happen after all dst have been released.
>>
> 
> rt_flush_dev() becomes a no-op if "dev" == "a loopback device in that
> namespace". And according to debug printk(), rt_flush_dev() is called
> on "a loopback device in that namespace" itself.
> 
> If "a loopback device in that namespace" is the last "one" (== "a network
> device in that namespace" ?), which shutdown sequence should have called
> dev_put("a loopback device in that namespace") before unregistration of
> "a loopback device in that namespace" starts?
> 
> Since I'm not a netdev person, I appreciate if you can explain
> that shutdown sequence using a flow chart.
> 

The attached patch adds a tracepoint to notifier_call_chain. If you have
KALLSYMS enabled it will show the order of the function handlers:

perf record -e notifier:* -a -g &

ip netns del <NAME>
<wait a few seconds>

fg
<ctrl-c on perf-record>

perf script

--------------A2951BECD619E8BAAC5FD632
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-notifier-add-tracepoint-to-notifier_call_chain.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-notifier-add-tracepoint-to-notifier_call_chain.patch"

RnJvbSA1NTEwYzE0ZTU2ZjNlOTllN2RmZDkyMDg3NDIxNDM3OTFlMTRhMmUyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+
CkRhdGU6IE1vbiwgMjkgQXByIDIwMTkgMTE6MjI6MDcgLTA3MDAKU3ViamVjdDogW1BBVENI
XSBub3RpZmllcjogYWRkIHRyYWNlcG9pbnQgdG8gbm90aWZpZXJfY2FsbF9jaGFpbgoKU2ln
bmVkLW9mZi1ieTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPgotLS0KIGtlcm5l
bC9ub3RpZmllci5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykK
CmRpZmYgLS1naXQgYS9rZXJuZWwvbm90aWZpZXIuYyBiL2tlcm5lbC9ub3RpZmllci5jCmlu
ZGV4IDYxOTZhZjhhODIyMy4uOWI2NWE5YzU2ZmQ3IDEwMDY0NAotLS0gYS9rZXJuZWwvbm90
aWZpZXIuYworKysgYi9rZXJuZWwvbm90aWZpZXIuYwpAQCAtNSw2ICs1LDggQEAKICNpbmNs
dWRlIDxsaW51eC9yY3VwZGF0ZS5oPgogI2luY2x1ZGUgPGxpbnV4L3ZtYWxsb2MuaD4KICNp
bmNsdWRlIDxsaW51eC9yZWJvb3QuaD4KKyNkZWZpbmUgQ1JFQVRFX1RSQUNFX1BPSU5UUwor
I2luY2x1ZGUgPHRyYWNlL2V2ZW50cy9ub3RpZmllci5oPgogCiAvKgogICoJTm90aWZpZXIg
bGlzdCBmb3Iga2VybmVsIGNvZGUgd2hpY2ggd2FudHMgdG8gYmUgY2FsbGVkCkBAIC05MCw2
ICs5Miw3IEBAIHN0YXRpYyBpbnQgbm90aWZpZXJfY2FsbF9jaGFpbihzdHJ1Y3Qgbm90aWZp
ZXJfYmxvY2sgKipubCwKIAkJCWNvbnRpbnVlOwogCQl9CiAjZW5kaWYKKwkJdHJhY2Vfbm90
aWZpZXJfY2FsbF9jaGFpbihuYiwgdmFsKTsKIAkJcmV0ID0gbmItPm5vdGlmaWVyX2NhbGwo
bmIsIHZhbCwgdik7CiAKIAkJaWYgKG5yX2NhbGxzKQotLSAKMi4xMS4wCgo=
--------------A2951BECD619E8BAAC5FD632--
