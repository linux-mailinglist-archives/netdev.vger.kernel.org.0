Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A880D37FD5D
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 20:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhEMSrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 14:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhEMSrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 14:47:12 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B021C06174A
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 11:46:02 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id k127so26497179qkc.6
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 11:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GAV1fXFSKvWHxmFu4phkc9jQpUPZkv5g9G22iOp3JO4=;
        b=dhY3VhupK0SgzKHwPC1xzkYkEk7WxIAa/h81o1Ubypz7lzErRGnMJk9GKcdA21PdUU
         vFqrw9JfClOlVILCb0qqqwsvpD8D0nW5+uHMZM0S9kiv3EEnCY/OfNB8fi0TBVyGQCRr
         LS1ICdSCUG9twMKjwNjwIVF/5bsS6UKhab1uTJ0xU8mmqmzxJXezXh4CRiLcuoE1RgEN
         5zB7YaCdXuBIIZ3Rv8CeqbonhU8hI65SfLkukMxvkMK6/UI/pT7UVs1exq6kbBKdijoq
         Ixzc6ZqVjqRAVoTRNE3d6gT1TJlwwaxb2tZ97za1xLJddXJYL72bkPXx+6ErtcAl5RMf
         9ZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GAV1fXFSKvWHxmFu4phkc9jQpUPZkv5g9G22iOp3JO4=;
        b=jkEQs8kGGv6napLXqUZWgIF2/mrFELTM4CjrhjqQCf4eJRCkpVHqkABhkFbCsuQahO
         NofRREq1Ms6vpeyp8hIYFLSFMJ36OoOUeDoGFFoY+W/ub62RAb2O2usSHOa80D+4X/L8
         sRl88sSL3tUEBTRJ4caQtFO+z49sic4Sg8iQhI+aO4cnbvG4EuDh7IchVVirR+mIZ1/w
         rC9Km6236IRFAky3/7EPzHRIoOxhCQwP1jb+xFnZRvcdJOZ4DCxAiPpN/+vMDoIcJQuE
         2ZgJtbi1QadFuOOkVrOoMt50SYsqR6dVm6IwCDH0Y6o8uZKHY2UVh1Op5bI/A/uBIeJ9
         vcBg==
X-Gm-Message-State: AOAM533BqzdBtuNgbmQLLYQ8HyVSKHKJeAihWrDC5YJfoLcxrh5fZc1H
        HH/hsZ3FSdp7BbFjgSYjAyhOPg==
X-Google-Smtp-Source: ABdhPJx+s0dQGv6W+pE8TlEkGxiT8/a7HLuxRXGljDExQTnHDX698hY1AGv+3w/Cr5dqzrT92h104Q==
X-Received: by 2002:a37:c4d:: with SMTP id 74mr15416387qkm.264.1620931561342;
        Thu, 13 May 2021 11:46:01 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-25-174-95-97-70.dsl.bell.ca. [174.95.97.70])
        by smtp.googlemail.com with ESMTPSA id l16sm2917709qtj.30.2021.05.13.11.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 11:46:00 -0700 (PDT)
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Joe Stringer <joe@cilium.io>, Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp>
 <20210402234500.by3wigegeluy5w7j@ast-mbp>
 <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
 <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
 <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
 <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
 <ac30da98-97cd-c105-def8-972a8ec573d6@mojatatu.com>
Message-ID: <e51f235e-f5b7-be64-2340-8e7575d69145@mojatatu.com>
Date:   Thu, 13 May 2021 14:45:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <ac30da98-97cd-c105-def8-972a8ec573d6@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-12 6:43 p.m., Jamal Hadi Salim wrote:

> 
> Will run some tests tomorrow to see the effect of batching vs nobatch
> and capture cost of syscalls and cpu.
> 

So here are some numbers:
Processor: Intel(R) Xeon(R) Gold 6230R CPU @ 2.10GHz
This machine is very similar to where a real deployment
would happen.

Hyperthreading turned off so we can dedicate the core to the
dumping process and Performance mode on, so no frequency scaling
meddling.
Tests were ran about 3 times each. Results eye-balled to make
sure deviation was reasonable.
100% of the one core was used just for dumping during each run.

bpftool does linear retrieval whereas our tool does batch dumping.
bpftool does print the dumped results, for our tool we just count
the number of entries retrieved (cost would have been higher if
we actually printed). In any case in the real setup there is
a processing cost which is much higher.

Summary is: the dumping is problematic costwise as the number of
entries increase. While batching does improve things it doesnt
solve our problem (Like i said we have upto 16M entries and most
of the time we are dumping useless things)

1M entries
----------

root@SUT:/home/jhs/git-trees/ftables/src# time ./ftables show system 
cache dev enp179s0f1 > /dev/null
real    0m0.320s
user    0m0.004s
sys     0m0.316s

root@SUT:/home/jhs/git-trees/ftables/src# time 
/home/jhs/git-trees/foobar/XDP/bpftool map dump  id 3353 > /dev/null
real    0m5.419s
user    0m4.347s
sys     0m1.072s

4M entries
-----------
root@SUT:/home/jhs/git-trees/ftables/src# time ./ftables show system cache
  dev enp179s0f1 > /dev/null
real    0m1.331s
user    0m0.004s
sys     0m1.325s

root@SUT:/home/jhs/git-trees/ftables/src# time 
/home/jhs/git-trees/foobar/XDP/bpftool map dump id 1178 > /dev/null
real    0m21.677s
user    0m17.269s
sys     0m4.408s
8M Entries
------------

root@SUT:/home/jhs/git-trees/ftables/src# time ./ftables show system 
cache dev enp179s0f1 > /dev/null
real    0m2.678s
user    0m0.004s
sys     0m2.672s

t@SUT:/home/jhs/git-trees/ftables/src# time 
/home/jhs/git-trees/foobar/XDP/bpftool map dump id 2636 > /dev/null
real    0m43.267s
user    0m34.450s
sys     0m8.817s

16M entries
------------
root@SUT:/home/jhs/git-trees/ftables/src# time ./ftables show system cache
  dev enp179s0f1 > /dev/null
real    0m5.396s
user    0m0.004s
sys     0m5.389s

root@SUT:/home/jhs/git-trees/ftables/src# time 
/home/jhs/git-trees/foobar/XDP/bpftool map dump id 1919 > /dev/null
real    1m27.039s
user    1m8.371s
sys     0m18.668s



cheers,
jamal
