Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9BF538BB7
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244414AbiEaHCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243917AbiEaHC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:02:27 -0400
Received: from corp-front09-corp.i.nease.net (corp-front09-corp.i.nease.net [59.111.134.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712BA91561;
        Tue, 31 May 2022 00:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=nsnR0djQq/9pmDo8wLLwucLF31dTM++9yv
        Yi8ZnT4J8=; b=qfmR1CEBXiQPBUw5CFWNKETJYLZr+6PzSCSXCCGG71tBMPLaUV
        pr5QCJUbfFhebLlnCBZDy47OVfZ6frpmfXSUGlshi/JPc25hFXg90O54rzE3S55G
        /JlltLyyqRwKxiZfeDiMXgmWOtzgPDiiReZ08ElfwdzskkSwVqYLFzUoE=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front09-corp.i.nease.net (Coremail) with SMTP id nxDICgAHDWJrvZViB+9jAA--.23009S2;
        Tue, 31 May 2022 15:02:03 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, liuyacan@corp.netease.com,
        netdev@vger.kernel.org, pabeni@redhat.com, ubraun@linux.ibm.com
Subject: Re: SMC-R problem under multithread
Date:   Tue, 31 May 2022 15:02:03 +0800
Message-Id: <20220531070203.1558767-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <YpR/Kjx4L6WoMb26@TonyMac-Alibaba>
References: <YpR/Kjx4L6WoMb26@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nxDICgAHDWJrvZViB+9jAA--.23009S2
X-Coremail-Antispam: 1UD129KBjvJXoW3XF15Jw48tw15GF1UtF1rCrg_yoWftrW5pr
        yvqF12q3W7Jry7XwnrX3WjgF4kXryxtFykJ3Z7Jr1DK3s8JF1q9r1v9w17Gw4rZw1qkrWq
        kr1UJ3savrnxXa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUXEb7IF0VACp39vda4lb7IF0VCFI7km07C26c804VAKzcIF0wAF
        F20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r
        1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAF
        wI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67
        AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4vE1TuYJxujqTIEc-sF
        P3VYkVW5Jr1DJw4UKVWUGwAawVACjsI_Ar4v6c8GOVW06r1DJrWUAwAawVACjsI_Ar4v6c
        8GOVWY6r1DJrWUAwAawVCIc40E5I027xCE548m6r1DJr4UtwAa7VCY0VAaVVAqrcv_Jw1U
        Wr13M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4
        IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCjxxvEw4Wlc2IjII80xcxEwVAK
        I48JMxAIw28IcxkI7VAKI48JMxCjnVAK0II2c7xJMxC20s026xCaFVCjc4AY6r1j6r4UMx
        CIbVAxMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUjhiStUUUUU==
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQADCVt765RIEQAHsO
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Hi experts,
> > > 
> > > I recently used memcached to test the performance of SMC-R relative to TCP, but the results 
> > > are confusing me. When using multithread on the server side, the performance of SMC-R is not as good as TCP.
> > > 
> > > Specifically, I tested 4 scenarios with server thread: 1\2\4\8. The client uses 8threads fixedly. 
> > > 
> > > server: (smc_run) memcached -t 1 -m 16384 -p [SERVER-PORT] -U 0 -F -c 10240 -o modern
> > > client: (smc-run) memtier_benchmark -s [SERVER-IP] -p [SERVER-PORT] -P memcache_text --random-data --data-size=100 --data-size-pattern=S --key-minimum=30 --key-maximum=100  -n 5000000 -t 8
> > > 
> > > The result is as follows:
> > > 
> > > SMC-R:
> > > 
> > > server-thread    ops/sec  client-cpu server-cpu
> > > 1             242k        220%         97%
> > > 2             362k        241%        128%
> > > 4             378k        242%        160%
> > > 8             395k        242%        210%
> > > 
> > > TCP:
> > > server-thread    ops/sec  client-cpu server-cpu
> > > 1             185k       224%         100%
> > > 2             435k       479%         200%
> > > 4             780k       731%         400%
> > > 8             938k       800%         659%                   
> > > 
> > > It can be seen that as the number of threads increases, the performance increase of SMC-R is much slower than that of TCP.
> > > 
> > > Am I doing something wrong? Or is it only when CPU resources are tight that SMC-R has a significant advantage ?  
> > > 
> > > Any suggestions are welcome.
> > 
> > Hi, Tony.
> > 
> > Inline.
> >  
> > > Hi Yacan,
> > > 
> > > This result matches some of our scenarios to some extent. Let's talk
> > > about this result first.
> > > 
> > > Based on your benchmark, the biggest factor affecting performance seems
> > > that the CPU resource is limited. As the number of threads increased,
> > > neither CPU usage nor performance metrics improved, and CPU is limited
> > > to about 200-250%. To make it clear, could you please give out more
> > > metrics about per-CPU (usr / sys / hi / si) and memcached process usage.
> > 
> > Now, I use taskset to limit memcached to use cpu21~cpu28. The result is as follows:
> > 
> > TCP    1 thread 
> > %Cpu21 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu22 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu23 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu24 :  0.0 us,  0.0 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.3 si,  0.0 st
> > %Cpu25 : 14.3 us, 76.3 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi,  9.3 si,  0.0 st
> > %Cpu26 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu27 :  1.0 us,  0.0 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  1.0 si,  0.0 st
> > %Cpu28 :  0.0 us,  0.0 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.3 si,  0.0 st
> >   
> > SMC-R  1 thread
> > %Cpu21 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu22 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu23 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu24 :  0.0 us,  2.8 sy,  0.0 ni, 17.2 id,  0.0 wa,  0.0 hi, 79.9 si,  0.0 st
> > %Cpu25 : 18.9 us, 74.2 sy,  0.0 ni,  7.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu26 :  2.9 us,  0.3 sy,  0.0 ni, 96.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu27 :  0.3 us,  0.0 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu28 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > 
> > TCP    2 thread
> > %Cpu21 : 12.0 us, 81.7 sy,  0.0 ni,  6.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu22 : 11.0 us, 80.0 sy,  0.0 ni,  9.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu23 :  3.0 us, 12.6 sy,  0.0 ni, 84.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu24 :  0.0 us,  0.0 sy,  0.0 ni, 98.3 id,  0.0 wa,  0.0 hi,  1.7 si,  0.0 st
> > %Cpu25 :  0.0 us,  0.0 sy,  0.0 ni, 96.5 id,  0.0 wa,  0.0 hi,  3.5 si,  0.0 st
> > %Cpu26 :  0.0 us,  0.3 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  1.7 si,  0.0 st
> > %Cpu27 :  0.0 us,  0.0 sy,  0.0 ni, 98.3 id,  0.0 wa,  0.0 hi,  1.7 si,  0.0 st
> > %Cpu28 :  2.0 us,  0.3 sy,  0.0 ni, 93.0 id,  0.0 wa,  0.0 hi,  4.7 si,  0.0 st
> >   
> > SMC-R  2 thread
> > %Cpu21 :  4.3 us, 18.1 sy,  0.0 ni, 77.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu22 :  2.7 us, 20.6 sy,  0.0 ni, 76.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu23 :  4.7 us, 28.7 sy,  0.0 ni, 66.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu24 :  0.7 us,  2.3 sy,  0.0 ni, 17.3 id,  0.0 wa,  0.0 hi, 79.7 si,  0.0 st
> > %Cpu25 :  7.7 us, 23.6 sy,  0.0 ni, 68.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu26 :  3.7 us,  8.8 sy,  0.0 ni, 87.5 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu27 :  0.0 us,  0.7 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu28 :  1.3 us,  8.6 sy,  0.0 ni, 90.1 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > 
> > TCP    4  thread
> > %Cpu21 : 10.0 us, 55.3 sy,  0.0 ni, 34.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu22 :  8.7 us, 50.5 sy,  0.0 ni, 40.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu23 : 11.7 us, 63.7 sy,  0.0 ni, 24.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu24 :  3.1 us, 13.9 sy,  0.0 ni, 75.6 id,  0.0 wa,  0.0 hi,  7.5 si,  0.0 st
> > %Cpu25 :  9.3 us, 30.9 sy,  0.0 ni, 49.8 id,  0.0 wa,  0.0 hi, 10.0 si,  0.0 st
> > %Cpu26 :  8.5 us, 28.3 sy,  0.0 ni, 56.3 id,  0.0 wa,  0.0 hi,  6.8 si,  0.0 st
> > %Cpu27 :  4.3 us, 21.4 sy,  0.0 ni, 64.9 id,  0.0 wa,  0.0 hi,  9.4 si,  0.0 st
> > %Cpu28 : 12.4 us, 48.3 sy,  0.0 ni, 30.5 id,  0.0 wa,  0.0 hi,  8.7 si,  0.0 st
> > 
> > SMC-R  4  thread
> > %Cpu21 :  6.1 us, 21.4 sy,  0.0 ni, 72.5 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu22 :  5.9 us, 21.8 sy,  0.0 ni, 72.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu23 :  6.5 us, 28.1 sy,  0.0 ni, 65.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu24 :  4.1 us,  9.3 sy,  0.0 ni,  5.5 id,  0.0 wa,  0.0 hi, 81.0 si,  0.0 st
> > %Cpu25 :  3.7 us,  8.4 sy,  0.0 ni, 87.9 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu26 :  3.3 us, 10.9 sy,  0.0 ni, 85.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu27 :  4.7 us, 11.3 sy,  0.0 ni, 84.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu28 :  1.0 us,  4.3 sy,  0.0 ni, 94.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > 
> > TCP    8  thread
> > %Cpu21 : 14.7 us, 63.2 sy,  0.0 ni, 22.1 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu22 : 14.6 us, 61.1 sy,  0.0 ni, 24.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu23 : 12.9 us, 66.9 sy,  0.0 ni, 20.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu24 : 15.4 us, 52.1 sy,  0.0 ni, 20.3 id,  0.0 wa,  0.0 hi, 12.2 si,  0.0 st
> > %Cpu25 : 11.2 us, 52.7 sy,  0.0 ni, 19.7 id,  0.0 wa,  0.0 hi, 16.3 si,  0.0 st
> > %Cpu26 : 14.3 us, 54.3 sy,  0.0 ni, 20.8 id,  0.0 wa,  0.0 hi, 10.6 si,  0.0 st
> > %Cpu27 : 12.1 us, 52.8 sy,  0.0 ni, 21.4 id,  0.0 wa,  0.0 hi, 13.8 si,  0.0 st
> > %Cpu28 : 14.7 us, 49.1 sy,  0.0 ni, 21.2 id,  0.0 wa,  0.0 hi, 15.0 si,  0.0 st
> > 
> > SMC-R  8  thread 
> > %Cpu21 :  6.3 us, 20.4 sy,  0.0 ni, 73.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu22 :  8.3 us, 18.3 sy,  0.0 ni, 73.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu23 :  5.1 us, 23.3 sy,  0.0 ni, 71.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu24 :  1.3 us,  3.4 sy,  0.0 ni,  1.0 id,  0.0 wa,  0.0 hi, 94.3 si,  0.0 st
> > %Cpu25 :  6.3 us, 15.6 sy,  0.0 ni, 78.1 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu26 :  6.5 us, 12.7 sy,  0.0 ni, 80.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu27 :  7.4 us, 13.5 sy,  0.0 ni, 79.1 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > %Cpu28 :  5.8 us, 13.3 sy,  0.0 ni, 80.9 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > 
> > 
> > It looks like SMC-R only uses one core to do softirq work, I presume this is the rx/tx tasklet, right?
> 
> Yep, it only used one CQ (one CPU core) to handle data (tasklet), which
> is solved in [1].
>  
> > > Secondly, it seems that there is lots of connections in this test.
> > > If it takes too much time to establish a connection, or the number of
> > > final connections does not reach the specified value, the result will be
> > > greatly affected. Could you please give out more details about the
> > > connections numbers during benchmark?
> > 
> > In our environment, client always use 50*8=400 connections.
> 
> 400 connections is not too much. We found some regressions when the
> number of connections reaches the scale of thousands.
> 
> > 
> > > We have noticed SMC has some limitations in multiple threads and many
> > > connections. This benchmark happens to be basically in line with this
> > > scenario. In general, there are some aspects in brief:
> > > 1. control path (connection setup and dismiss) is not as fast as TCP;
> > > 2. data path (lock contention, CQ spreading, etc.) needs further improvement;
> > 
> > SMC-R control path setup time slower than TCP is reasonable and tolerable.
> 
> Connection setup is the one of hardest part to solve. If this is okay, I
> think SMC should suitable for your scenario.
> 
> > 
> > > About CPU limitation, SMC use one CQ and one core to handle data
> > > transmission, which cannot spread workload over multiple cores. There is
> > > is an early temporary solution [1], which also need to improve (new CQ
> > > API, WR refactor). With this early solution, it shows several times the
> > > performance improvement.
> > > 
> > > About the improvement of connection setup, you can see [2] for more
> > > details, which is still a proposal now, and we are working on it now.
> > > This show considerable performance boost.
> > > 
> > > [1] https://lore.kernel.org/all/20220126130140.66316-1-tonylu@linux.alibaba.com/
> > > [2] https://lore.kernel.org/all/1653375127-130233-1-git-send-email-alibuda@linux.alibaba.com/
> > > 
> > > Thanks,
> > > Tony LU
> > > 
> > 
> > We just noticed the CQ per device as well. Actually we tried creating more CQs, multiple rx tasklets, 
> > but nothing seems to work. Maybe we got it wrong somewhere...Now We plan to try [1] first.
> 
> The key point of this patch [1] is to spread CQ vector to different
> cores. It can solve single core issue of tasklet (si high in some CPU
> core).
> 
> Looking forward for your feedback, thanks.
>  
> > Thank you very much for your reply!
> > 
> > [1] https://lore.kernel.org/all/20220126130140.66316-1-tonylu@linux.alibaba.com/
> > 
> > Regards,
> > Yacan
> > 
> > 
> 
> [1] https://lore.kernel.org/all/20220126130140.66316-1-tonylu@linux.alibaba.com/
> 
> Cheers,
> Tony Lu

Hi Tony,

   This patch proved absolutely useful in our environment!
   
    ops/sec   1 thread    2 threads    4 threads    8 threads
   w/o patch   236k          365k        382k           394k
   w/  patch   289k          726k        1061k         1243k
   Ratio       +22%          +98%        +177%         +215%

   Thank you very much.

Regards,
Yacan

