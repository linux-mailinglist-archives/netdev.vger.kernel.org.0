Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA74B115305
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 15:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfLFOVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 09:21:35 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:34896 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfLFOVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 09:21:35 -0500
Received: by mail-pg1-f180.google.com with SMTP id l24so3393178pgk.2;
        Fri, 06 Dec 2019 06:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=m9FvOToT/3pDAr+KR5PpVtiNMReb8JhZS+HVbFTxzeU=;
        b=BhnQJYqXp3dCFKpMyPzbHjs06rzt4rVlEh2Lf1ZtZu2sEmECc8cMTy87Zx3w56I4sF
         9ifFvm/GqXsPtaUgeR9r86tJ/fTUZ54zJaoCMlhXV8/Cj+pIJvAII0A+9+SdCM4I293D
         flTMV580meB0rZHEmBdKxYifYmRvLolcg1ePYqoOJNXRTogZtNR1kCKrCMlOW82Oic9x
         8VipAqPe1ppXeF1eBekFdJQur66u/ruhZxaptIxcNVtJT6B3dwyy2xpbrP0cEvZRyj0S
         4gPhzdYXo6+z5dwx5E7V6sGDTYA7sDJpBk1re0s7xxFal3C64j1iwr2iS0Iz+KY2bR6e
         45bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m9FvOToT/3pDAr+KR5PpVtiNMReb8JhZS+HVbFTxzeU=;
        b=HL5z4yhFFjsdcEAh/DCEevcgj9MzfSB9cevhm9gTuzFXN4h9rHdRNZ8IeAd05WlLd+
         Xe9Mqvr4yyIndSL43wzGaSzwbuaJ8JSJM4Mdo3J3ejrXoFgKe/OTGYrORtDWe78XRCiW
         n7M5GzbHkHfsGjk6ZH41bUGd9g5Pq8Bqec02d3RHBjszTmvpo6nJ6l3wOUThjG7NJJuO
         UiRyMtbAmumz0zWpt+nzsJPOrp8/Po6BtnZ/KnbDSqQsbz53DoJFs1cnZLsyTOx9Tf2m
         oOYtNjIhDZmeqhZvAFq5avV246SNOiLEWz7YnUxlo6yM1Ijkkh+7U75revVibfs6P9Be
         tDMw==
X-Gm-Message-State: APjAAAWzyVo5N429VnprCuyJD7GwBl/j4Vl3yf8SABdDnI/N52TyIbFJ
        tuTTxm1Pe0Fj4FkyIGBIqG5Mmuvz
X-Google-Smtp-Source: APXvYqw2hLHXA/50bzABkNKq4dEOWcAl1WjfkRPVm7jOaj4G5w9/nnJjRCPoHEaGnG/U3KAryQikrg==
X-Received: by 2002:a63:d406:: with SMTP id a6mr3782454pgh.264.1575642094177;
        Fri, 06 Dec 2019 06:21:34 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 23sm6986433pfj.148.2019.12.06.06.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 06:21:33 -0800 (PST)
Subject: Re: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
To:     David Laight <David.Laight@ACULAB.COM>,
        network dev <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <23db23416d3148fa86e54dccc6152266@AcuMS.aculab.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dc10298d-4280-b9b4-9203-be4000e85c42@gmail.com>
Date:   Fri, 6 Dec 2019 06:21:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <23db23416d3148fa86e54dccc6152266@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/19 5:39 AM, David Laight wrote:
> Some tests I've done seem to show that recvmsg() is much slower that recvfrom()
> even though most of what they do is the same.

Not really.

> One thought is that the difference is all the extra copy_from_user() needed by
> recvmsg. CONFIG_HARDENED_USERCOPY can add a significant cost.
> 
> I've built rebuilt my 5.4-rc7 kernel with all the copy_to/from_user() in net/socket.c
> replaced with the '_' prefixed versions (that don't call check_object()).
> And also changed rw_copy_check_uvector() in fs/read_write.c.
> 
> Schedviz then showed the time spent by the application thread that calls
> recvmsg() (about) 225 times being reduced from 0.9ms to 0.75ms.
> 
> I've now instrumented the actual recv calls. It show some differences,
> but now enough to explain the 20% difference above.
> (This is all made more difficult because my Ivy Bridge i7-3770 refuses
> to run at a fixed frequency.)
> 
> Anyway using PERF_COUNT_HW_CPU_CYCLES I've got the following
> histograms for the number of cycles in each recv call.
> There are about the same number (2.8M) in each column over
> an elapsed time of 20 seconds.
> There are 450 active UDP sockets, each receives 1 message every 20ms.
> Every 10ms a RT thread that is pinned to a cpu reads all the pending messages.
> This is a 4 core hyperthreading (8 cpu) system.
> During these tests 5 other threads are also busy.
> There are no sends (on those sockets).
> 
>          |       recvfrom      |       recvmsg
>  cycles  |   unhard  |    hard |   unhard  |    hard
> -----------------------------------------------------
>    1472:         29          1          0          0
>    1600:       8980       4887          3          0
>    1728:     112540     159518       5393       2895
>    1856:     174555     270148     119054     111230
>    1984:     126007     168383     152310     195288
>    2112:      80249      87045     118941     168801
>    2240:      61570      54790      81847     110561
>    2368:      95088      61796      57496      71732
>    2496:     193633     155870      54020      54801
>    2624:     274997     284921     102465      74626
>    2752:     276661     295715     160492     119498
>    2880:     248751     264174     206327     186028
>    3008:     207532     213067     230704     229232
>    3136:     167976     164804     226493     238555
>    3264:     133708     124857     202639     220574
>    3392:     107859      95696     172949     189475
>    3520:      88599      75943     141056     153524
>    3648:      74290      61586     115873     120994
>    3776:      62253      50891      96061      95040
>    3904:      52213      42482      81113      76577
>    4032:      42920      34632      69077      63131
>    4160:      35472      28327      60074      53631
>    4288:      28787      22603      51345      46620
>    4416:      24072      18496      44006      40325
>    4544:      20107      14886      37185      34516
>    4672:      16759      12206      31408      29031
>    4800:      14195       9991      26843      24396
>    4928:      12356       8167      22775      20165
>    5056:      10387       6931      19404      16591
>    5184:       9284       5916      16817      13743
>    5312:       7994       5116      14737      11452
>    5440:       7152       4495      12592       9607
>    5568:       6300       3969      11117       8592
>    5696:       5445       3421       9988       7237
>    5824:       4683       2829       8839       6368
>    5952:       3959       2643       7652       5652
>    6080:       3454       2377       6442       4814
>    6208:       3041       2219       5735       4170
>    6336:       2840       2060       5059       3615
>    6464:       2428       1975       4433       3201
>    6592:       2109       1794       4078       2823
>    6720:       1871       1382       3549       2558
>    6848:       1706       1262       3110       2328
>    6976:       1567       1001       2733       1991
>    7104:       1436        873       2436       1819
>    7232:       1417        860       2102       1652
>    7360:       1414        741       1823       1429
>    7488:       1372        814       1663       1239
>    7616:       1201        896       1430       1152
>    7744:       1275       1008       1364       1049
>    7872:       1382       1120       1367        925
>    8000:       1316       1282       1253        815
>    8128:       1264       1266       1313        792
>   8256+:      19252      19450      34703      30228
> ----------------------------------------------------
>   Total:    2847707    2863582    2853688    2877088
> 
> This does show a few interesting things:
> 1) The 'hardened' kernel is slower, especially for recvmsg.
> 2) The difference for recvfrom isn't enough for the 20% reduction I saw.
> 3) There are two peaks at the top a 'not insubstantial' number are a lot
>    faster than the main peak.
> 4) There is second peak way down at 8000 cycles.
>    This is repeatable.
> 
> Any idea what is actually going on??
> 

Real question is : Do you actually need to use recvmsg() instead of recvfrom() ?

If recvmsg() provides additional cmsg, this is not surprising it is more expensive.

recvmsg() also uses an indirect call, so CONFIG_RETPOLINE=y is probably hurting.

err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, flags);

Maybe a INDIRECT_CALL annotation could help, or rewriting this to not let gcc
use an indirect call.


diff --git a/net/socket.c b/net/socket.c
index ea28cbb9e2e7a7180ee63de2d09a81aacb001ab7..752714281026dab6db850ec7fa75b7aa6240661f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2559,7 +2559,10 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
 
        if (sock->file->f_flags & O_NONBLOCK)
                flags |= MSG_DONTWAIT;
-       err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, flags);
+       if (nosec)
+               err = sock_recvmsg_nosec(sock, msg_sys, flags);
+       else
+               err = sock_recvmsg(sock, msg_sys, flags);
        if (err < 0)
                goto out;
        len = err;



