Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287BA445B0
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbfFMQpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:45:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54172 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730350AbfFMFtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 01:49:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so8739717wmj.3
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 22:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WcHziIB9nit0amDgrt/dDy3PqyydiorC7SLPWwzMhZ4=;
        b=zvtVGBmR6Z+/c942DrT1EDqmKLfCxUde2263C8jzh/ufHA4OUNqJRBkLkSGxRigu0P
         eunZ0SaHMXw6IfIYickWc1ZLb2NsuHf2utMiUunYCqQR7FmSDmgBwOwgIh9dA+KTvPmW
         0273xEm26RxQrHmkXvhzZdIZWrOUTsKryWgEFRzfSZQnsfDaPQxTsxid2DWTWGzW9ChR
         SYgPKTYppcJ2+tlzFz80PpoNpFny0x8RAAdt5nE4Tf0mybImrqN2Hkjhs2U2sU/o6NSs
         LGtSaZPQ3GIbUHxi2czwKy4YLkmdLm33wH2iFwi02mwr0sVPEekf2MY3J3fyFN+2xuiH
         97NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WcHziIB9nit0amDgrt/dDy3PqyydiorC7SLPWwzMhZ4=;
        b=Ol+/9hBDfXNHVHcv8av7kAjB5LAQM1GgS4r3FNlUSGHvGwujegiyZhauhqXEbw0Phx
         Gs/JaQ67OK/IsZrenKw84UErpwHsET8IqaNvnybUb5xwIWIfG08W1usj+pWBtch/RIq0
         ekQJAVAmEezrfZyzaxeg9zsA5x5xeo0+eEQIjEPKRxOFe2sl8fmcqwb8XP4QHse3XE0P
         b5vLjvVFmfECZ+oNWegOoUiCa1MjyB6/0+4gynedKHmCGDI+NEsGZxqd8slbssRKmbrb
         d6FP+e3ew6+4nkgNmQNZWOO7ie8mC2HuUTrr4J6fCPlkBgL1lDjhwbCxTK228POcNWK/
         WX5A==
X-Gm-Message-State: APjAAAVBXBjQyTlqSS+5O8AWFrpqb5lCh1sidVIa0Q2ImKtx8BWTWBrm
        VYUCamtZnogO42/j0ewZ19ObNg==
X-Google-Smtp-Source: APXvYqyXhE85TC21MX3GkOkgxvgP/SlOMXKs2mSPUX+2zlZUzvwrj8IO+2TpGLhg5K0F49r/bhwMCg==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr2104060wmk.40.1560404948444;
        Wed, 12 Jun 2019 22:49:08 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y6sm1511729wrp.12.2019.06.12.22.49.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 22:49:07 -0700 (PDT)
Date:   Thu, 13 Jun 2019 07:49:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>, mlxsw <mlxsw@mellanox.com>,
        Alex Kushnarov <alexanderk@mellanox.com>
Subject: Re: tc tp creation performance degratation since kernel 5.1
Message-ID: <20190613054907.GB2254@nanopsycho.orion>
References: <20190612120341.GA2207@nanopsycho>
 <vbfy327yocq.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vbfy327yocq.fsf@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 12, 2019 at 02:34:02PM CEST, vladbu@mellanox.com wrote:
>
>On Wed 12 Jun 2019 at 15:03, Jiri Pirko <jiri@resnulli.us> wrote:
>> Hi.
>>
>> I came across serious performance degradation when adding many tps. I'm
>> using following script:
>>
>> ------------------------------------------------------------------------
>> #!/bin/bash
>>
>> dev=testdummy
>> ip link add name $dev type dummy
>> ip link set dev $dev up
>> tc qdisc add dev $dev ingress
>>
>> tmp_file_name=$(date +"/tmp/tc_batch.%s.%N.tmp")
>> pref_id=1
>>
>> while [ $pref_id -lt 20000 ]
>> do
>>         echo "filter add dev $dev ingress proto ip pref $pref_id matchall action drop" >> $tmp_file_name
>>         ((pref_id++))
>> done
>>
>> start=$(date +"%s")
>> tc -b $tmp_file_name
>> stop=$(date +"%s")
>> echo "Insertion duration: $(($stop - $start)) sec"
>> rm -f $tmp_file_name
>>
>> ip link del dev $dev
>> ------------------------------------------------------------------------
>>
>> On my testing vm, result on 5.1 kernel is:
>> Insertion duration: 3 sec
>> On net-next this is:
>> Insertion duration: 54 sec
>>
>> I did simple prifiling using perf. Output on 5.1 kernel:
>>     77.85%  tc               [kernel.kallsyms]  [k] tcf_chain_tp_find
>>      3.30%  tc               [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
>>      1.33%  tc_pref_scale.s  [kernel.kallsyms]  [k] do_syscall_64
>>      0.60%  tc_pref_scale.s  libc-2.28.so       [.] malloc
>>      0.55%  tc               [kernel.kallsyms]  [k] mutex_spin_on_owner
>>      0.51%  tc               libc-2.28.so       [.] __memset_sse2_unaligned_erms
>>      0.40%  tc_pref_scale.s  libc-2.28.so       [.] __gconv_transform_utf8_internal
>>      0.38%  tc_pref_scale.s  libc-2.28.so       [.] _int_free
>>      0.37%  tc_pref_scale.s  libc-2.28.so       [.] __GI___strlen_sse2
>>      0.37%  tc               [kernel.kallsyms]  [k] idr_get_free
>
>Are these results for same config? Here I don't see any lockdep or
>KASAN. However in next trace...
>
>>
>> Output on net-next:
>>     39.26%  tc               [kernel.vmlinux]  [k] lock_is_held_type
>>     33.99%  tc               [kernel.vmlinux]  [k] tcf_chain_tp_find
>>     12.77%  tc               [kernel.vmlinux]  [k] __asan_load4_noabort
>>      1.90%  tc               [kernel.vmlinux]  [k] __asan_load8_noabort
>>      1.08%  tc               [kernel.vmlinux]  [k] lock_acquire
>>      0.94%  tc               [kernel.vmlinux]  [k] debug_lockdep_rcu_enabled
>>      0.61%  tc               [kernel.vmlinux]  [k] debug_lockdep_rcu_enabled.part.5
>>      0.51%  tc               [kernel.vmlinux]  [k] unwind_next_frame
>>      0.50%  tc               [kernel.vmlinux]  [k] _raw_spin_unlock_irqrestore
>>      0.47%  tc_pref_scale.s  [kernel.vmlinux]  [k] lock_acquire
>>      0.47%  tc               [kernel.vmlinux]  [k] lock_release
>
>... both lockdep and kasan consume most of CPU time.
>
>BTW it takes 5 sec to execute your script on my system with net-next
>(debug options disabled).

You are right, my bad. Sorry for the fuzz.


>
>>
>> I didn't investigate this any further now. I fear that this might be
>> related to Vlad's changes in the area. Any ideas?
>>
>> Thanks!
>>
>> Jiri
