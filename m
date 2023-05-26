Return-Path: <netdev+bounces-5724-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19789712905
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C710A281828
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11ECA261CC;
	Fri, 26 May 2023 15:00:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E72848B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:00:37 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF789C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:00:36 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso70395e9.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685113234; x=1687705234;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KZxUKwlq0yZyclpzR1NI3cPyelUrM3AmuMG5YiylxFw=;
        b=PiL3VbXVjGq8RrPBwDW9WRRf+vJH+n19Qol2yB8Pi0pTFENufwor12HxTFrEGq5mrf
         NVaspnSG/zBL17aM+MBufhgTiW64ssJDDDyK26Jf9Oh5ooiUuVqfTjhOn91elQ9cahDj
         mW+da8q/eUHp3OcGakqOy7WhSHrsOCVjzlCZud/n0JY/UrNmjIKMAbXEylyx73rFzStF
         woVUI+PVilILRiCrR11lsRjWb+VjP80VLTnfZVcQyS454Dqb4q0hAMdzOUcpgIWEuOvY
         O+OLSaWG+iBH1HKhdoQE7s4hw+k4lUvFCKrXG6bZrvS8G9+XiYYUE2JPm/Coed6UvDeh
         //xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685113234; x=1687705234;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KZxUKwlq0yZyclpzR1NI3cPyelUrM3AmuMG5YiylxFw=;
        b=NITLyy2D4i0hkKbHEZ6Vl0+IGMP2kh9iaqiAAUEbhCtS5EV76wjYPhP8LETCyLjtgb
         enFDlJtoOURSPQXqQq5jMp/c8CAQXZka/Far9ElAsAOiO/Am4cngcL4Mz7oBRQi11Yms
         CDJzEvnVG4SN3WSt3kOMe1HUsGzI143V/TZkdnI1tWGjeyzTWOLmO9DaT62K+vWld0lj
         B3877sqyE37ayUNcIZcebJA201eUrQTCjgTm82a4dVw/j0r7drN2DyxRkOIoZQfWRJjK
         rzOhbXXPK6YMzMHv8UyODDRx2wrLPr/KQ8jvKoSWNhMQ3x2HDsQHtTwOtI/vsNeh6ez4
         I+Ig==
X-Gm-Message-State: AC+VfDzk9KuVL1Z0pqq2RMNfxChLoEx/hSfiXeBTMKio1JyH/MllLxu0
	XWK8RT8kj1i/mI8mqb2En4wiKH/6uItxA6l2Sc2NzQ==
X-Google-Smtp-Source: ACHHUZ7TdRT+anDyI/3z61t5hK5mam4fZnN+hM7lYIR4eZfmzDqfrK3kpP8+sDk9FqQKk6yv1mFckMZuSeIgpa4QqIw=
X-Received: by 2002:a05:600c:3c96:b0:3f4:1dce:3047 with SMTP id
 bg22-20020a05600c3c9600b003f41dce3047mr115414wmb.2.1685113234301; Fri, 26 May
 2023 08:00:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 17:00:22 +0200
Message-ID: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
Subject: x86 copy performance regression
To: LKML <linux-kernel@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Linus

While testing unrelated patches using upstream net-next kernels,
I found a big regression in sendmsg()/recvmsg() caused by a series of yours.

Tested platforms :

Intel(R) Xeon(R) Gold 6268L CPU @ 2.80GHz

We can see rep_movs_alternative() using more cycles in kernel profiles
than the previous variant (copy_user_enhanced_fast_string, which was
simply using "rep  movsb"), and we can not reach line rate (as we
could before the series)


Patch series:

commit a5624566431de76b17862383d9ae254d9606cba9
Merge: 487c20b016dc48230367a7be017f40313e53e3bd
034ff37d34071ff3f48755f728cd229e42a4f15d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Apr 24 10:39:27 2023 -0700

    Merge branch 'x86-rep-insns': x86 user copy clarifications

    Merge my x86 user copy updates branch.

IMO this patch seems to think tcp sendmsg() is using small areas.
(tcp_sendmsg() usually copy 32KB at a time, if order-3 pages
allocations are possible)

commit adfcf4231b8cbc2d9c1e7bfaa965b907e60639eb
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Apr 15 13:14:59 2023 -0700

    x86: don't use REP_GOOD or ERMS for user memory copies

    The modern target to use is FSRM (Fast Short REP MOVS), and the other
    cases should only be used for bigger areas (ie mainly things like page
    clearing).

    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



The issue is that (some of) our platforms do have ERMS but not FSRM

Test run on 6.3 (single TCP flow, sending 32 MB of payload to a
zerocopy receiver to make sure the receiver is not the bottleneck).
100Gbit link speed.

# perf stat taskset 02 tcp_mmap -H 2002:a05:6608:295::

 Performance counter stats for 'taskset 02 ./tcp_mmap -H 2002:a05:6608:295::':

          2,815.79 msec task-clock                       #    0.936
CPUs utilized
             2,370      context-switches                 #  841.682
/sec
                 1      cpu-migrations                   #    0.355
/sec
               127      page-faults                      #   45.103
/sec
    10,106,383,352      cycles                           #    3.589
GHz
     6,936,487,168      instructions                     #    0.69
insn per cycle
     1,206,325,691      branches                         #  428.414
M/sec
        10,327,112      branch-misses                    #    0.86% of
all branches

       3.007810265 seconds time elapsed

       0.005158000 seconds user
       2.406125000 seconds sys


Same test from linux-6.4-rc1

# perf stat taskset 02 tcp_mmap -H 2002:a05:6608:295::

 Performance counter stats for 'taskset 02 ./tcp_mmap -H 2002:a05:6608:295::':

          4,039.73 msec task-clock                       #    1.000
CPUs utilized
                12      context-switches                 #    2.970
/sec
                 1      cpu-migrations                   #    0.248
/sec
               130      page-faults                      #   32.180
/sec
    14,639,828,754      cycles                           #    3.624
GHz
    19,443,379,653      instructions                     #    1.33
insn per cycle
     1,931,003,961      branches                         #  478.003
M/sec
        12,349,476      branch-misses                    #    0.64% of
all branches

       4.040825111 seconds time elapsed

       0.012496000 seconds user
       3.560336000 seconds sys

Thanks.

