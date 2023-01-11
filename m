Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AF76652AE
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbjAKEKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjAKEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:10:21 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1450BF037
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:10:19 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s8so7160916plk.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=InTV3x0nIeGund/c1wpkRJXAGYhtxh6bQyY7aWznSlo=;
        b=c2iRBpyISw5H7ycUbRecfsa6iOX/KfAzCfk4wdt2xQkIreYeVLgA+LkekNGV2jgMi3
         J2pTHTyeVY88xeNh3VSG0WmAi6Y+NL3jUWFG0QrXP+ZweEnDTZZDDwJ3hpzO+tg8T9bk
         PLMToXokdE12d3qcHYfgr0sfaUmaoFPCA3j6PxjTKxf47WeCBkUC21wIme54O8zuSbK1
         RT5IOnHCizrs81R7+Jzdmr1yKW+TnmvqgmMCsxbTwc7xSMt58Lq2jn2JcfUiVqaD/QR/
         6cGkHOwDEnzvD1wdjXeppFZKuuB9+Dc3mbTGBMY6zdELlLvl4iTfDBOKtJH0kowT6W0o
         bpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=InTV3x0nIeGund/c1wpkRJXAGYhtxh6bQyY7aWznSlo=;
        b=YJxdgREW95+U8V1EBeVye557qPrAzJpEdHhA798pCuUTV1tKdGz1xqioZ2OF3yBPPu
         n+Z+88Vkk4L/B/lSVHr1G5oFfarWadiEktBN0Esu408ZuIfalvM4hzPKXbzklt5anOF0
         8w16IE2qVPJf26yuvOlhBJ0N+PAcArnBPBTm5pUoewrEEEYpcX5uYuTF/i/rC21m69IP
         oJpOf26eO2yzHgEJ7yCi+w/sx0NjddvAxcI0+ik0d60QbWv0ryB2vqi8HhXhSBChz9nj
         wshc9IRLloK6nnTdV3f5JdhxCxkA9PW0hTJh7sOFhynxJpgp/OiwgFumG1Ar7Cc1XsPm
         wARQ==
X-Gm-Message-State: AFqh2krcN4d5JwJbYfMCuRat0edalNE5MLRSWpL1vXcC5rphqrL1fbXt
        ipUISq6Cg1KauE4eavx6gORUcktl3QsIxRpJzUk=
X-Google-Smtp-Source: AMrXdXtWl7YHdgwUhpAvDq5+RjhyNXwkTv0/Zqz+qGGtk8BujXt8P0WKoUQIJlfis7zDPGtaUk3mZA==
X-Received: by 2002:a17:902:8688:b0:192:fc9c:a238 with SMTP id g8-20020a170902868800b00192fc9ca238mr19906362plo.66.1673410218512;
        Tue, 10 Jan 2023 20:10:18 -0800 (PST)
Received: from [10.16.128.218] (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id j14-20020a170903024e00b00189667acf19sm8914775plh.95.2023.01.10.20.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 20:10:18 -0800 (PST)
Message-ID: <28b421af-838d-e70a-ec95-2f14f21e3a90@igel.co.jp>
Date:   Wed, 11 Jan 2023 13:10:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC PATCH 4/9] vringh: unify the APIs for all accessors
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221227022528.609839-1-mie@igel.co.jp>
 <20221227022528.609839-5-mie@igel.co.jp>
 <20221227020007-mutt-send-email-mst@kernel.org>
 <CANXvt5pRy-i7=_ikNkZPp2HcRmWZYNJYpjO_ieBJJVc90nds+A@mail.gmail.com>
 <CANXvt5qUUOqB1CVgAk5KyL9sV+NsnJSKhatvdV12jH5=kBjjJw@mail.gmail.com>
 <20221227075332-mutt-send-email-mst@kernel.org>
 <CANXvt5qTbGi7p5Y7eVSjyHJ7MLjiMgGKyAM-LEkJZXvhtSh7vw@mail.gmail.com>
 <20221228021354-mutt-send-email-mst@kernel.org>
From:   Shunsuke Mie <mie@igel.co.jp>
In-Reply-To: <20221228021354-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/12/28 16:20, Michael S. Tsirkin wrote:
> On Wed, Dec 28, 2022 at 11:24:10AM +0900, Shunsuke Mie wrote:
>> 2022年12月27日(火) 23:37 Michael S. Tsirkin <mst@redhat.com>:
>>> On Tue, Dec 27, 2022 at 07:22:36PM +0900, Shunsuke Mie wrote:
>>>> 2022年12月27日(火) 16:49 Shunsuke Mie <mie@igel.co.jp>:
>>>>> 2022年12月27日(火) 16:04 Michael S. Tsirkin <mst@redhat.com>:
>>>>>> On Tue, Dec 27, 2022 at 11:25:26AM +0900, Shunsuke Mie wrote:
>>>>>>> Each vringh memory accessors that are for user, kern and iotlb has own
>>>>>>> interfaces that calls common code. But some codes are duplicated and that
>>>>>>> becomes loss extendability.
>>>>>>>
>>>>>>> Introduce a struct vringh_ops and provide a common APIs for all accessors.
>>>>>>> It can bee easily extended vringh code for new memory accessor and
>>>>>>> simplified a caller code.
>>>>>>>
>>>>>>> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
>>>>>>> ---
>>>>>>>   drivers/vhost/vringh.c | 667 +++++++++++------------------------------
>>>>>>>   include/linux/vringh.h | 100 +++---
>>>>>>>   2 files changed, 225 insertions(+), 542 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>>>>>>> index aa3cd27d2384..ebfd3644a1a3 100644
>>>>>>> --- a/drivers/vhost/vringh.c
>>>>>>> +++ b/drivers/vhost/vringh.c
>>>>>>> @@ -35,15 +35,12 @@ static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
>>>>>>>   }
>>>>>>>
>>>>>>>   /* Returns vring->num if empty, -ve on error. */
>>>>>>> -static inline int __vringh_get_head(const struct vringh *vrh,
>>>>>>> -                                 int (*getu16)(const struct vringh *vrh,
>>>>>>> -                                               u16 *val, const __virtio16 *p),
>>>>>>> -                                 u16 *last_avail_idx)
>>>>>>> +static inline int __vringh_get_head(const struct vringh *vrh, u16 *last_avail_idx)
>>>>>>>   {
>>>>>>>        u16 avail_idx, i, head;
>>>>>>>        int err;
>>>>>>>
>>>>>>> -     err = getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
>>>>>>> +     err = vrh->ops.getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
>>>>>>>        if (err) {
>>>>>>>                vringh_bad("Failed to access avail idx at %p",
>>>>>>>                           &vrh->vring.avail->idx);
>>>>>> I like that this patch removes more lines of code than it adds.
>>>>>>
>>>>>> However one of the design points of vringh abstractions is that they were
>>>>>> carefully written to be very low overhead.
>>>>>> This is why we are passing function pointers to inline functions -
>>>>>> compiler can optimize that out.
>>>>>>
>>>>>> I think that introducing ops indirect functions calls here is going to break
>>>>>> these assumptions and hurt performance.
>>>>>> Unless compiler can somehow figure it out and optimize?
>>>>>> I don't see how it's possible with ops pointer in memory
>>>>>> but maybe I'm wrong.
>>>>> I think your concern is correct. I have to understand the compiler
>>>>> optimization and redesign this approach If it is needed.
>>>>>> Was any effort taken to test effect of these patches on performance?
>>>>> I just tested vringh_test and already faced little performance reduction.
>>>>> I have to investigate that, as you said.
>>>> I attempted to test with perf. I found that the performance of patched code
>>>> is almost the same as the upstream one. However, I have to investigate way
>>>> this patch leads to this result, also the profiling should be run on
>>>> more powerful
>>>> machines too.
>>>>
>>>> environment:
>>>> $ grep 'model name' /proc/cpuinfo
>>>> model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
>>>> model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
>>>> model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
>>>> model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
>>>>
>>>> results:
>>>> * for patched code
>>>>   Performance counter stats for 'nice -n -20 ./vringh_test_patched
>>>> --parallel --eventidx --fast-vringh --indirect --virtio-1' (20 runs):
>>>>
>>>>            3,028.05 msec task-clock                #    0.995 CPUs
>>>> utilized            ( +-  0.12% )
>>>>              78,150      context-switches          #   25.691 K/sec
>>>>                 ( +-  0.00% )
>>>>                   5      cpu-migrations            #    1.644 /sec
>>>>                 ( +-  3.33% )
>>>>                 190      page-faults               #   62.461 /sec
>>>>                 ( +-  0.41% )
>>>>       6,919,025,222      cycles                    #    2.275 GHz
>>>>                 ( +-  0.13% )
>>>>       8,990,220,160      instructions              #    1.29  insn per
>>>> cycle           ( +-  0.04% )
>>>>       1,788,326,786      branches                  #  587.899 M/sec
>>>>                 ( +-  0.05% )
>>>>           4,557,398      branch-misses             #    0.25% of all
>>>> branches          ( +-  0.43% )
>>>>
>>>>             3.04359 +- 0.00378 seconds time elapsed  ( +-  0.12% )
>>>>
>>>> * for upstream code
>>>>   Performance counter stats for 'nice -n -20 ./vringh_test_base
>>>> --parallel --eventidx --fast-vringh --indirect --virtio-1' (10 runs):
>>>>
>>>>            3,058.41 msec task-clock                #    0.999 CPUs
>>>> utilized            ( +-  0.14% )
>>>>              78,149      context-switches          #   25.545 K/sec
>>>>                 ( +-  0.00% )
>>>>                   5      cpu-migrations            #    1.634 /sec
>>>>                 ( +-  2.67% )
>>>>                 194      page-faults               #   63.414 /sec
>>>>                 ( +-  0.43% )
>>>>       6,988,713,963      cycles                    #    2.284 GHz
>>>>                 ( +-  0.14% )
>>>>       8,512,533,269      instructions              #    1.22  insn per
>>>> cycle           ( +-  0.04% )
>>>>       1,638,375,371      branches                  #  535.549 M/sec
>>>>                 ( +-  0.05% )
>>>>           4,428,866      branch-misses             #    0.27% of all
>>>> branches          ( +- 22.57% )
>>>>
>>>>             3.06085 +- 0.00420 seconds time elapsed  ( +-  0.14% )
>>>
>>> How you compiled it also matters. ATM we don't enable retpolines
>>> and it did not matter since we didn't have indirect calls,
>>> but we should. Didn't yet investigate how to do that for virtio tools.
>> I think the retpolines certainly affect performance. Thank you for pointing
>> it out. I'd like to start the investigation that how to apply the
>> retpolines to the
>> virtio tools.
>>>>> Thank you for your comments.
>>>>>> Thanks!
>>>>>>
>>>>>>
>>>>> Best,
>>>>> Shunsuke.
> This isn't all that trivial if we want this at runtime.
> But compile time is kind of easy.
> See Documentation/admin-guide/hw-vuln/spectre.rst

Thank you for showing it.


I followed the document and added options to CFLAGS to the tools Makefile.

That is

---

diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 1b25cc7c64bb..7b7139d97d74 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -4,7 +4,7 @@ test: virtio_test vringh_test
  virtio_test: virtio_ring.o virtio_test.o
  vringh_test: vringh_test.o vringh.o virtio_ring.o

-CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. 
-I../include/ -I ../../usr/include/ -Wno-pointer-sign 
-fno-strict-overflow -fno-strict-aliasing -fno-common -MMD 
-U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
+CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. 
-I../include/ -I ../../usr/include/ -Wno-pointer-sign 
-fno-strict-overflow -fno-strict-aliasing -fno-common -MMD 
-U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h 
-mfunction-return=thunk -fcf-protection=none -mindirect-branch-register
  CFLAGS += -pthread
  LDFLAGS += -pthread
  vpath %.c ../../drivers/virtio ../../drivers/vhost
---

And results of evaluation are following:

- base with retpoline

$ sudo perf stat --repeat 20 -- nice -n -20 ./vringh_test_retp_origin 
--parallel --eventidx --fast-vringh
Using CPUS 0 and 3
Guest: notified 0, pinged 98040
Host: notified 98040, pinged 0
...

  Performance counter stats for 'nice -n -20 ./vringh_test_retp_origin 
--parallel --eventidx --fast-vringh' (20 runs):

           6,228.33 msec task-clock                #    1.004 CPUs 
utilized            ( +-  0.05% )
            196,110      context-switches          #   31.616 
K/sec                    ( +-  0.00% )
                  6      cpu-migrations            #    0.967 
/sec                     ( +-  2.39% )
                205      page-faults               #   33.049 
/sec                     ( +-  0.46% )
     14,218,527,987      cycles                    #    2.292 
GHz                      ( +-  0.05% )
     10,342,897,254      instructions              #    0.73  insn per 
cycle           ( +-  0.02% )
      2,310,572,989      branches                  #  372.500 
M/sec                    ( +-  0.03% )
        178,273,068      branch-misses             #    7.72% of all 
branches          ( +-  0.04% )

            6.20406 +- 0.00308 seconds time elapsed  ( +-  0.05% )

- patched (unified APIs) with retpoline

$ sudo perf stat --repeat 20 -- nice -n -20 ./vringh_test_retp_patched 
--parallel --eventidx --fast-vringh
Using CPUS 0 and 3
Guest: notified 0, pinged 98040
Host: notified 98040, pinged 0
...

  Performance counter stats for 'nice -n -20 ./vringh_test_retp_patched 
--parallel --eventidx --fast-vringh' (20 runs):

           6,103.94 msec task-clock                #    1.001 CPUs 
utilized            ( +-  0.03% )
            196,125      context-switches          #   32.165 
K/sec                    ( +-  0.00% )
                  7      cpu-migrations            #    1.148 
/sec                     ( +-  1.56% )
                196      page-faults               #   32.144 
/sec                     ( +-  0.41% )
     13,933,055,778      cycles                    #    2.285 
GHz                      ( +-  0.03% )
     10,309,004,718      instructions              #    0.74  insn per 
cycle           ( +-  0.03% )
      2,368,447,519      branches                  #  388.425 
M/sec                    ( +-  0.04% )
        211,364,886      branch-misses             #    8.94% of all 
branches          ( +-  0.05% )

            6.09888 +- 0.00155 seconds time elapsed  ( +-  0.03% )

As a result, at the patched code, the branch-misses was increased but
elapsed time became faster than the based code. The number of 
page-faults was
a little different. I'm suspicious of that the page-fault penalty leads the
performance result.

I think that a pattern of memory access for data is same with those, but
for instruction is different. Actually a code size (.text segment) was a
little smaller. 0x6a65 and 0x63f5.

$ readelf -a ./vringh_test_retp_origin |grep .text -1
        0000000000000008  0000000000000008  AX       0     0     8
   [14] .text             PROGBITS         0000000000001230 00001230
        0000000000006a65  0000000000000000  AX       0     0     16
--
    02     .interp .note.gnu.build-id .note.ABI-tag .gnu.hash .dynsym 
.dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt
    03     .init .plt .plt.got .text .fini
    04     .rodata .eh_frame_hdr .eh_frame


$ readelf -a ./vringh_test_retp_patched |grep .text -1
        0000000000000008  0000000000000008  AX       0     0     8
   [14] .text             PROGBITS         0000000000001230 00001230
        00000000000063f5  0000000000000000  AX       0     0     16
--
    02     .interp .note.gnu.build-id .note.ABI-tag .gnu.hash .dynsym 
.dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt
    03     .init .plt .plt.got .text .fini
    04     .rodata .eh_frame_hdr .eh_frame

I'll keep this investigation. I was wondering if you could comment me.

Best

>
