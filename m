Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9888F534256
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 19:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243317AbiEYRn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 13:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiEYRn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 13:43:57 -0400
Received: from fx409.security-mail.net (smtpout140.security-mail.net [85.31.212.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38389D06A
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 10:43:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx409.security-mail.net (Postfix) with ESMTP id BDBB8323696
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 19:43:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1653500631;
        bh=42QBn7XnpLQMgCsfInKNJQYytDxezYJWf4bADJZ8Tc0=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=UZjU8wppJf9nqZKceBowoch298SjRO0nt+la0t34eDLkwaKxiX13qamBmfGQTY4TT
         708NrQHrmQmi9uHNNQGoDc/gi/KES6U6+ksykr4QTfufUb810LM7/n/yTfNSA5l013
         kFUitlMXcSeRRoTW/bQIBQDy83QF2auLOlcaBq6Q=
Received: from fx409 (localhost [127.0.0.1]) by fx409.security-mail.net
 (Postfix) with ESMTP id 1EA223236DA for <netdev@vger.kernel.org>; Wed, 25
 May 2022 19:43:51 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx409.security-mail.net (Postfix) with ESMTPS id 108893237BD; Wed, 25 May
 2022 19:43:49 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 7900C27E04AF; Wed, 25 May 2022
 19:43:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 5A93927E04B8; Wed, 25 May 2022 19:43:49 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 GRUkl9yPppIY; Wed, 25 May 2022 19:43:49 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id 2FD9327E04AF; Wed, 25 May 2022
 19:43:49 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <15237.628e6ad5.9c7c2.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 5A93927E04B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1653500629;
 bh=+xUpuGfqrcJLR9qIo/kh/tLbYQEYh2mRd2ePjX+xoew=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=SBjvs/C4xK3d3lEdbiYsd2NlUre9N/0ofZ2Qdf+W/kBZlKtbRiZZqcyQR0cbDLJJC
 wGZcGBe/lTc+NEZo8S5u5J+ust5UcBB2ZyFWzwvBTKQRux3lFg1yPMbkFA+oopX1Fj
 dHHWGRp9Eb4YY8M7eLK5lZ2vHelouLZoI4bezUB/ekiHqBa5eJQajg1KwgX6pBPZac
 BuhvFPtgBv/Wisc3/d/a0KLXWlW4QPk0C4mh0dcxxj0C+X2ra9HJaFlgrQgo5E9aVM
 4CNY3oXvtKXhXXaJdh3FzvxgFviU/rkQmog8x6GMwDb7Xvz2ocMerdRY4s0bpm7W04
 l8gK8bxfH/uOQ==
Date:   Wed, 25 May 2022 19:43:49 +0200 (CEST)
From:   Vincent Ray <vray@kalrayinc.com>
To:     Guoju Fang <gjfang@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        linyunsheng <linyunsheng@huawei.com>
Cc:     davem <davem@davemloft.net>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>, will <will@kernel.org>,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com
Message-ID: <1010638538.15358411.1653500629126.JavaMail.zimbra@kalray.eu>
In-Reply-To: <90c70f7f-1f07-4cd7-bb41-0f708114bb80@linux.alibaba.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
 <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
 <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
 <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com>
 <1140270297.15304639.1653471897630.JavaMail.zimbra@kalray.eu>
 <60d1e5b8-dae0-38ef-4b9d-f6419861fdab@huawei.com>
 <90c70f7f-1f07-4cd7-bb41-0f708114bb80@linux.alibaba.com>
Subject: Re: packet stuck in qdisc : patch proposal
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary=secu_7ac881b74b6dd460481377d13d981080_part1
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF100
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc : patch proposal
Thread-Index: vDuncPPq8VO2Ubr/r98NboMjPGD5/A==
X-ALTERMIMEV2_out: done
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This message is in MIME format.

--secu_7ac881b74b6dd460481377d13d981080_part1
Content-Type: text/plain; charset=utf-8



----- On May 25, 2022, at 2:40 PM, Guoju Fang gjfang@linux.alibaba.com wrote:

> On 2022/5/25 18:45, Yunsheng Lin wrote:
>> On 2022/5/25 17:44, Vincent Ray wrote:
>>> ----- On May 24, 2022, at 10:17 PM, Eric Dumazet eric.dumazet@gmail.com wrote:
>>>
>>>> On 5/24/22 10:00, Vincent Ray wrote:
>>>>> All,
>>>>>
>>>>> I confirm Eric's patch works well too, and it's better and clearer than mine.
>>>>> So I think we should go for it, and the one from Guoju in addition.
>>>>>
>>>>> @Eric : I see you are one of the networking maintainers, so I have a few
>>>>> questions for you :
>>>>>
>>>>> a) are you going to take care of these patches directly yourself, or is there
>>>>> something Guoju or I should do to promote them ?
>>>>
>>>> I think this is totally fine you take ownership of the patch, please
>>>> send a formal V2.
>>>>
>>>> Please double check what patchwork had to say about your V1 :
>>>>
>>>>
>>>> https://patchwork.kernel.org/project/netdevbpf/patch/1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu/
>>>>
>>>>
>>>> And make sure to address the relevant points
>>>
>>> OK I will.
>>> If you agree, I will take your version of the fix (test_and_set_bit()), keeping
>>> the commit message
>>> similar to my original one.
>>>
>>> What about Guoju's patch ?
>> 
>> @Guoju, please speak up if you want to handle the patch yourself.
> 
> Hi Yunsheng, all,
> 
> I rewrite the comments of my patch and it looks a little clearer. :)
> 
> Thank you.
> 
> Best regards,

Guoju : shouldn't you also include the same Fixes tag suggested by YunSheng ?

Here's mine, attached. Hope it's well formatted this time. Tell me.
I don't feel quite confident with the submission process to produce the series myself, so I'll let Eric handle it if it's ok.

> 
>> 
>>> (adding a smp_mb() between the spin_unlock() and test_bit() in qdisc_run_end()).
>>> I think it is also necessary though potentially less critical.
>>> Do we embed it in the same patch ? or patch series ?
>> 
>> Guoju's patch fixes the commit a90c57f2cedd, so "patch series"
>> seems better if Guoju is not speaking up to handle the patch himself.
>> 
>> 
>>>
>>> @Guoju : have you submitted it for integration ?
>>>
>>>
>>>> The most important one is the lack of 'Signed-off-by:' tag, of course.
>>>>
>>>>
>>>>> b) Can we expect to see them land in the mainline soon ?
>>>>
>>>> If your v2 submission is correct, it can be merged this week ;)
>>>>
>>>>
>>>>>
>>>>> c) Will they be backported to previous versions of the kernel ? Which ones ?
>>>>
>>>> You simply can include a proper Fixes: tag, so that stable teams can
>>>> backport
>>>>
>>>> the patch to all affected kernel versions.
>>>>
>>>
>>> Here things get a little complicated in my head ;-)
>>> As explained, I think this mechanism has been bugged, in a way or an other, for
>>> some time, perhaps since the introduction
>>> of lockless qdiscs (4.16) or somewhere between 4.16 and 5.14.
>>> It's hard to tell at a glance since the code looks quite different back then.
>>> Because of these changes, a unique patch will also only apply up to a certain
>>> point in the past.
>>>
>>> However, I think the bug became really critical only with the introduction of
>>> "true bypass" behavior
>>> in lockless qdiscs by YunSheng in 5.14, though there may be scenarios where it
>>> is a big deal
>>> even in no-bypass mode.
>> 
>> 
>> commit 89837eb4b246 tried to fix that, but it did not fix it completely, and
>> that commit should has
>> been back-ported to the affected kernel versions as much as possible, so I think
>> the Fixes tag
>> should be:
>> 
>> Fixes: 89837eb4b246 ("net: sched: add barrier to ensure correct ordering for
>> lockless qdisc")
>> 
>>>
>>> => I suggest we only tag it for backward fix up to the 5.14, where it should
>>> apply smoothly,
>>>   and we live with the bug for versions before that.
>>> This would mean that 5.15 LT can be patched but no earlier LT
>>>   
>>> What do you think ?
>>>
>>> BTW : forgive my ignorance, but are there any kind of "Errata Sheet" or similar
>>> for known bugs that
>>> won't be fixed in a given kernel ?
>>>
>>>>
>>>>
>>>>>
>>>>> Thanks a lot, best,
>>>>
>>>> Thanks a lot for working on this long standing issue.
>>>>
>>>>
>>>>
>>>>
>>>> To declare a filtering error, please use the following link :
>>>> https://www.security-mail.net/reporter.php?mid=7009.628d3d4c.37c04.0&r=vray%40kalrayinc.com&s=eric.dumazet%40gmail.com&o=Re%3A+packet+stuck+in+qdisc+%3A+patch+proposal&verdict=C&c=0ca08e7b7e420d1ab014cda67db48db71df41f5f
>>>
>>>
>>>
>>>
>>> .
>>>
> 
> To declare a filtering error, please use the following link :
> https://www.security-mail.net/reporter.php?mid=2c69.628e23bf.45908.0&r=vray%40kalrayinc.com&s=gjfang%40linux.alibaba.com&o=Re%3A+packet+stuck+in+qdisc+%3A+patch+proposal&verdict=C&c=6106070134039ab6725b6d3de67bd24d624c8b51



--secu_7ac881b74b6dd460481377d13d981080_part1
Content-Type: application/mbox;
 name=0001-net-sched-fixed-barrier-to-prevent-skbuff-sticking-i.patch
Content-Disposition: attachment;
 filename=0001-net-sched-fixed-barrier-to-prevent-skbuff-sticking-i.patch
Content-Transfer-Encoding: base64

RnJvbSBlOGY0ODE0NTZmNDM1ZDMzMTY3Yjg0MGNmNWJiZTUzODAxZDdiZDk4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWaW5jZW50IFJheSA8dnJheUBrYWxyYXlpbmMuY29tPgpEYXRl
OiBXZWQsIDI1IE1heSAyMDIyIDE3OjU3OjUwICswMjAwClN1YmplY3Q6IFtQQVRDSCBuZXQgVjJd
IG5ldDogc2NoZWQ6IGZpeGVkIGJhcnJpZXIgdG8gcHJldmVudCBza2J1ZmYgc3RpY2tpbmcgaW4g
cWRpc2MKIGJhY2tsb2cKCkluIHFkaXNjX3J1bl9iZWdpbigpLCBzbXBfbWJfX2JlZm9yZV9hdG9t
aWMoKSB1c2VkIGJlZm9yZSB0ZXN0X2JpdCgpCmRvZXMgbm90IHByb3ZpZGUgYW55IG9yZGVyaW5n
IGd1YXJhbnRlZSBhcyB0ZXN0X2JpdCgpIGlzIG5vdCBhbiBhdG9taWMKb3BlcmF0aW9uLiBUaGlz
LCBhZGRlZCB0byB0aGUgZmFjdCB0aGF0IHRoZSBzcGluX3RyeWxvY2soKSBjYWxsIGF0CnRoZSBi
ZWdpbm5pbmcgb2YgcWRpc2NfcnVuX2JlZ2luKCkgZG9lcyBub3QgZ3VhcmFudGVlIGFjcXVpcmUK
c2VtYW50aWNzIGlmIGl0IGRvZXMgbm90IGdyYWIgdGhlIGxvY2ssIG1ha2VzIGl0IHBvc3NpYmxl
IGZvciB0aGUKZm9sbG93aW5nIHN0YXRlbWVudCA6CgppZiAodGVzdF9iaXQoX19RRElTQ19TVEFU
RV9NSVNTRUQsICZxZGlzYy0+c3RhdGUpKQoKdG8gYmUgZXhlY3V0ZWQgYmVmb3JlIGFuIGVucXVl
dWUgb3BlcmF0aW9uIGNhbGxlZCBiZWZvcmUKcWRpc2NfcnVuX2JlZ2luKCkuCgpBcyBhIHJlc3Vs
dCB0aGUgZm9sbG93aW5nIHJhY2UgY2FuIGhhcHBlbiA6CgogICAgICAgICAgIENQVSAxICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBDUFUgMgoKICAgICAgcWRpc2NfcnVuX2JlZ2luKCkgICAg
ICAgICAgICAgICBxZGlzY19ydW5fYmVnaW4oKSAvKiB0cnVlICovCiAgICAgICAgc2V0KE1JU1NF
RCkgICAgICAgICAgICAgICAgICAgICAgICAgICAgLgogICAgICAvKiByZXR1cm5zIGZhbHNlICov
ICAgICAgICAgICAgICAgICAgICAgIC4KICAgICAgICAgIC4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgLyogc2VlcyBNSVNTRUQgPSAxICovCiAgICAgICAgICAuICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIC8qIHNvIHFkaXNjIG5vdCBlbXB0eSAqLwogICAgICAgICAgLiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBfX3FkaXNjX3J1bigpCiAgICAgICAgICAuICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgLgogICAgICAgICAgLiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHBmaWZvX2Zhc3RfZGVxdWV1ZSgpCiAtLS0tPiAvKiBtYXkgYmUgZG9uZSBoZXJlICov
ICAgICAgICAgICAgICAgICAgLgp8ICAgICAgICAgLiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY2xlYXIoTUlTU0VEKQp8ICAgICAgICAgLiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIC4KfCAgICAgICAgIC4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNt
cF9tYiBfX2FmdGVyX2F0b21pYygpOwp8ICAgICAgICAgLiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIC4KfCAgICAgICAgIC4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IC8qIHJlY2hlY2sgdGhlIHF1ZXVlICovCnwgICAgICAgICAuICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAvKiBub3RoaW5nID0+IGV4aXQgICAqLwp8ICAgZW5xdWV1ZShza2IxKQp8ICAg
ICAgICAgLgp8ICAgcWRpc2NfcnVuX2JlZ2luKCkKfCAgICAgICAgIC4KfCAgICAgc3Bpbl90cnls
b2NrKCkgLyogZmFpbCAqLwp8ICAgICAgICAgLgp8ICAgICBzbXBfbWJfX2JlZm9yZV9hdG9taWMo
KSAvKiBub3QgZW5vdWdoICovCnwgICAgICAgICAuCiAtLS0tIGlmICh0ZXN0X2JpdChNSVNTRUQp
KQogICAgICAgIHJldHVybiBmYWxzZTsgICAvKiBleGl0ICovCgpJbiB0aGUgYWJvdmUgc2NlbmFy
aW8sIENQVSAxIGFuZCBDUFUgMiBib3RoIHRyeSB0byBncmFiIHRoZQpxZGlzYy0+c2VxbG9jayBh
dCB0aGUgc2FtZSB0aW1lLiBPbmx5IENQVSAyIHN1Y2NlZWRzIGFuZCBlbnRlcnMgdGhlCmJ5cGFz
cyBjb2RlIHBhdGgsIHdoZXJlIGl0IGVtaXRzIGl0cyBza2IgdGhlbiBjYWxscyBfX3FkaXNjX3J1
bigpLgoKQ1BVMSBmYWlscywgc2V0cyBNSVNTRUQgYW5kIGdvZXMgZG93biB0aGUgdHJhZGl0aW9u
bmFsIGVucXVldWUoKSArCmRlcXVldWUoKSBjb2RlIHBhdGguIEJ1dCB3aGVuIGV4ZWN1dGluZyBx
ZGlzY19ydW5fYmVnaW4oKSBmb3IgdGhlCnNlY29uZCB0aW1lLCBhZnRlciBlbnF1ZXVpbmcgaXRz
IHNrYnVmZiwgaXQgc2VlcyB0aGUgTUlTU0VEIGJpdCBzdGlsbApzZXQgKGJ5IGl0c2VsZikgYW5k
IGNvbnNlcXVlbnRseSBjaG9vc2VzIHRvIGV4aXQgZWFybHkgd2l0aG91dCBzZXR0aW5nCml0IGFn
YWluIG5vciB0cnlpbmcgdG8gZ3JhYiB0aGUgc3BpbmxvY2sgYWdhaW4uCgpNZWFud2hpbGUgQ1BV
MiBoYXMgc2VlbiBNSVNTRUQgPSAxLCBjbGVhcmVkIGl0LCBjaGVja2VkIHRoZSBxdWV1ZQphbmQg
Zm91bmQgaXQgZW1wdHksIHNvIGl0IHJldHVybmVkLgoKQXQgdGhlIGVuZCBvZiB0aGUgc2VxdWVu
Y2UsIHdlIGVuZCB1cCB3aXRoIHNrYjEgZW5xdWV1ZWQgaW4gdGhlCmJhY2tsb2csIGJvdGggQ1BV
cyBvdXQgb2YgX19kZXZfeG1pdF9za2IoKSwgdGhlIE1JU1NFRCBiaXQgbm90IHNldCwKYW5kIG5v
IF9fbmV0aWZfc2NoZWR1bGUoKSBjYWxsZWQgbWFkZS4gc2tiMSB3aWxsIG5vdyBsaW5nZXIgaW4g
dGhlCnFkaXNjIHVudGlsIHNvbWVib2R5IGxhdGVyIHBlcmZvcm1zIGEgZnVsbCBfX3FkaXNjX3J1
bigpLiBBc3NvY2lhdGVkCnRvIHRoZSBieXBhc3MgY2FwYWNpdHkgb2YgdGhlIHFkaXNjLCBhbmQg
dGhlIGFiaWxpdHkgb2YgdGhlIFRDUCBsYXllcgp0byBhdm9pZCByZXNlbmRpbmcgcGFja2V0cyB3
aGljaCBpdCBrbm93cyBhcmUgc3RpbGwgaW4gdGhlIHFkaXNjLCB0aGlzCmNhbiBsZWFkIHRvIHNl
cmlvdXMgdHJhZmZpYyAiaG9sZXMiIGluIGEgVENQIGNvbm5leGlvbi4KCldlIGZpeCB0aGlzIGJ5
IHJlcGxhY2luZyB0aGUgc21wX21iX19iZWZvcmVfYXRvbWljKCkgLyB0ZXN0X2JpdCgpIC8Kc2V0
X2JpdCgpIC8gc21wX21iX19hZnRlcl9hdG9taWMoKSBzZXF1ZW5jZSBpbnNpZGUgcWRzaWNfcnVu
X2JlZ2luKCkKYnkgYSBzaW5nbGUgdGVzdF9hbmRfc2V0X2JpdCgpIGNhbGwsIHdoaWNoIGlzIG1v
cmUgY29uY2lzZSBhbmQKZW5mb3JjZXMgdGhlIG5lZWRlZCBtZW1vcnkgYmFycmllcnMuCgpGaXhl
czogODk4MzdlYjRiMjQ2ICgibmV0OiBzY2hlZDogYWRkIGJhcnJpZXIgdG8gZW5zdXJlIGNvcnJl
Y3Qgb3JkZXJpbmcgZm9yIGxvY2tsZXNzIHFkaXNjIikKU2lnbmVkLW9mZi1ieTogVmluY2VudCBS
YXkgPHZyYXlAa2FscmF5aW5jLmNvbT4KLS0tCiBpbmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oIHwg
MzYgKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
OCBpbnNlcnRpb25zKCspLCAyOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25l
dC9zY2hfZ2VuZXJpYy5oIGIvaW5jbHVkZS9uZXQvc2NoX2dlbmVyaWMuaAppbmRleCA5YmFiMzk2
YzFmM2IuLjgwOTczY2U4MjBmMyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvc2NoX2dlbmVyaWMu
aAorKysgYi9pbmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oCkBAIC0xODcsMzcgKzE4NywxNyBAQCBz
dGF0aWMgaW5saW5lIGJvb2wgcWRpc2NfcnVuX2JlZ2luKHN0cnVjdCBRZGlzYyAqcWRpc2MpCiAJ
CWlmIChzcGluX3RyeWxvY2soJnFkaXNjLT5zZXFsb2NrKSkKIAkJCXJldHVybiB0cnVlOwogCi0J
CS8qIFBhaXJlZCB3aXRoIHNtcF9tYl9fYWZ0ZXJfYXRvbWljKCkgdG8gbWFrZSBzdXJlCi0JCSAq
IFNUQVRFX01JU1NFRCBjaGVja2luZyBpcyBzeW5jaHJvbml6ZWQgd2l0aCBjbGVhcmluZwotCQkg
KiBpbiBwZmlmb19mYXN0X2RlcXVldWUoKS4KKwkJLyogTm8gbmVlZCB0byBpbnNpc3QgaWYgdGhl
IE1JU1NFRCBmbGFnIHdhcyBhbHJlYWR5IHNldC4KKwkJICogTm90ZSB0aGF0IHRlc3RfYW5kX3Nl
dF9iaXQoKSBhbHNvIGdpdmVzIHVzIG1lbW9yeSBvcmRlcmluZworCQkgKiBndWFyYW50ZWVzIHdy
dCBwb3RlbnRpYWwgZWFybGllciBlbnF1ZXVlKCkgYW5kIGJlbG93CisJCSAqIHNwaW5fdHJ5bG9j
aygpLCBib3RoIG9mIHdoaWNoIGFyZSBuZWNlc3NhcnkgdG8gcHJldmVudCByYWNlcwogCQkgKi8K
LQkJc21wX21iX19iZWZvcmVfYXRvbWljKCk7Ci0KLQkJLyogSWYgdGhlIE1JU1NFRCBmbGFnIGlz
IHNldCwgaXQgbWVhbnMgb3RoZXIgdGhyZWFkIGhhcwotCQkgKiBzZXQgdGhlIE1JU1NFRCBmbGFn
IGJlZm9yZSBzZWNvbmQgc3Bpbl90cnlsb2NrKCksIHNvCi0JCSAqIHdlIGNhbiByZXR1cm4gZmFs
c2UgaGVyZSB0byBhdm9pZCBtdWx0aSBjcHVzIGRvaW5nCi0JCSAqIHRoZSBzZXRfYml0KCkgYW5k
IHNlY29uZCBzcGluX3RyeWxvY2soKSBjb25jdXJyZW50bHkuCi0JCSAqLwotCQlpZiAodGVzdF9i
aXQoX19RRElTQ19TVEFURV9NSVNTRUQsICZxZGlzYy0+c3RhdGUpKQorCQlpZiAodGVzdF9hbmRf
c2V0X2JpdChfX1FESVNDX1NUQVRFX01JU1NFRCwgJnFkaXNjLT5zdGF0ZSkpCiAJCQlyZXR1cm4g
ZmFsc2U7CiAKLQkJLyogU2V0IHRoZSBNSVNTRUQgZmxhZyBiZWZvcmUgdGhlIHNlY29uZCBzcGlu
X3RyeWxvY2soKSwKLQkJICogaWYgdGhlIHNlY29uZCBzcGluX3RyeWxvY2soKSByZXR1cm4gZmFs
c2UsIGl0IG1lYW5zCi0JCSAqIG90aGVyIGNwdSBob2xkaW5nIHRoZSBsb2NrIHdpbGwgZG8gZGVx
dWV1aW5nIGZvciB1cwotCQkgKiBvciBpdCB3aWxsIHNlZSB0aGUgTUlTU0VEIGZsYWcgc2V0IGFm
dGVyIHJlbGVhc2luZwotCQkgKiBsb2NrIGFuZCByZXNjaGVkdWxlIHRoZSBuZXRfdHhfYWN0aW9u
KCkgdG8gZG8gdGhlCi0JCSAqIGRlcXVldWluZy4KLQkJICovCi0JCXNldF9iaXQoX19RRElTQ19T
VEFURV9NSVNTRUQsICZxZGlzYy0+c3RhdGUpOwotCi0JCS8qIHNwaW5fdHJ5bG9jaygpIG9ubHkg
aGFzIGxvYWQtYWNxdWlyZSBzZW1hbnRpYywgc28gdXNlCi0JCSAqIHNtcF9tYl9fYWZ0ZXJfYXRv
bWljKCkgdG8gZW5zdXJlIFNUQVRFX01JU1NFRCBpcyBzZXQKLQkJICogYmVmb3JlIGRvaW5nIHRo
ZSBzZWNvbmQgc3Bpbl90cnlsb2NrKCkuCi0JCSAqLwotCQlzbXBfbWJfX2FmdGVyX2F0b21pYygp
OwotCi0JCS8qIFJldHJ5IGFnYWluIGluIGNhc2Ugb3RoZXIgQ1BVIG1heSBub3Qgc2VlIHRoZSBu
ZXcgZmxhZwotCQkgKiBhZnRlciBpdCByZWxlYXNlcyB0aGUgbG9jayBhdCB0aGUgZW5kIG9mIHFk
aXNjX3J1bl9lbmQoKS4KKwkJLyogVHJ5IHRvIHRha2UgdGhlIGxvY2sgYWdhaW4gdG8gbWFrZSBz
dXJlIHRoYXQgd2Ugd2lsbCBlaXRoZXIKKwkJICogZ3JhYiBpdCBvciB0aGUgQ1BVIHRoYXQgc3Rp
bGwgaGFzIGl0IHdpbGwgc2VlIE1JU1NFRCBzZXQKKwkJICogd2hlbiB0ZXN0aW5nIGl0IGluIHFk
aXNjX3J1bl9lbmQoKQogCQkgKi8KIAkJcmV0dXJuIHNwaW5fdHJ5bG9jaygmcWRpc2MtPnNlcWxv
Y2spOwogCX0KLS0gCjIuMzIuMAoK
--secu_7ac881b74b6dd460481377d13d981080_part1--


