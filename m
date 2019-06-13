Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575CD443DE
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392325AbfFMQdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:33:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41820 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfFMIL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:11:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so19677826wrm.8
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 01:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AitPxLfAJNZhZTcRdPLQwPVtmSp7enkC/up/50kbHLQ=;
        b=xAL1HwJOSEwDffEHuj82ZYSqkaiKIWcL3mTCZ5mRYDjzjI0rewTNyD7oinbev9JKjg
         mlXMBrOrRQWFlXqabQZ6Oo1leWdjGE6YBp591qwz9nbAbeEayO8z+X+szxgZi8OqFJHM
         KYmxKFKRrGlbvfJriEKr0ADIuf18x4xPAQHScLhiuku196ZcIEa8NfvPCPBFfj4vCifX
         teQcs6ZpPu6ulaBlvfmi4jhBJaL1DCbndYDo3RsmhqMowmeR9MH7GF9ePScBOtmK6pDy
         eRyj7zDGpA0PWWEpcO497rfivYntNCh1pkLcLSvXj5+NLGl156QaUX9eRRKmNWwAizWy
         cCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AitPxLfAJNZhZTcRdPLQwPVtmSp7enkC/up/50kbHLQ=;
        b=cXjNqbiqmqLsDxG233dy0bfRI2GDRrIHBmYffmWwVMAaZa9eP3li3nsoqygf/dY1uc
         ulV1NJ/aiUU4cswTMlo7SXnZeyPIArqaUX5pCX4btRq/rL+uOiZHDxc4QPXqKOSuwPXm
         OT9zKxHtjSQZg5npufBfxqJkJqeNW1ofS62x4p0/3C+POOnoCcKt40cHZ9RTHdU7ILbX
         diqBJC0mw8Hi8XTFEe+xOMLvir1Vlx9fc9CGUPzFI0KKeeBtLhb0YzcTdT5AaapoZ4Z0
         s52QowaawdmP9G6vX7CF1JP8TcYW5O4ortWp0mbZI5LJkGu3m0ufbLuD0aopCiXWQisp
         MfNw==
X-Gm-Message-State: APjAAAUp+ocOXjmA3+OaDcYhYhIuPMe5sdFs8CQy/o7ifW6H9T77zff/
        qCTypKLWU7LYldTMW/PHhjEcY1EOfi4=
X-Google-Smtp-Source: APXvYqxnjOGJFVMj2C6ZEIf8tmmHrfl0cpgll84ci04IZ0+XHcWOiDk7FXUG8ARF1UKahrO+dW/SgQ==
X-Received: by 2002:a5d:430c:: with SMTP id h12mr2780016wrq.163.1560413514773;
        Thu, 13 Jun 2019 01:11:54 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l16sm1893857wrw.42.2019.06.13.01.11.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 01:11:53 -0700 (PDT)
Date:   Thu, 13 Jun 2019 10:11:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     vladbu@mellanox.com, pablo@netfilter.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, mlxsw@mellanox.com, alexanderk@mellanox.com,
        pabeni@redhat.com
Subject: Re: tc tp creation performance degratation since kernel 5.1
Message-ID: <20190613081152.GC2254@nanopsycho.orion>
References: <20190612120341.GA2207@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612120341.GA2207@nanopsycho>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I made a mistake during measurements, sorry about that.

This is the correct script:
-----------------------------------------------------------------------
#!/bin/bash

dev=testdummy
ip link add name $dev type dummy
ip link set dev $dev up
tc qdisc add dev $dev ingress

tmp_file_name=$(date +"/tmp/tc_batch.%s.%N.tmp")
pref_id=1

while [ $pref_id -lt 20000 ]
do
        echo "filter add dev $dev ingress proto ip pref $pref_id flower action drop" >> $tmp_file_name
        #echo "filter add dev $dev ingress proto ip pref $pref_id matchall action drop" >> $tmp_file_name
        ((pref_id++))
done

start=$(date +"%s")
tc -b $tmp_file_name
stop=$(date +"%s")
echo "Insertion duration: $(($stop - $start)) sec"
rm -f $tmp_file_name

ip link del dev $dev
-----------------------------------------------------------------------

Note the commented out matchall. I don't see the regression with
matchall. However, I see that with flower:
kernel 5.1
Insertion duration: 4 sec
kernel 5.2
Insertion duration: 163 sec

I don't see any significant difference in perf:
kernel 5.1
    77.24%  tc               [kernel.vmlinux]    [k] tcf_chain_tp_find
     1.67%  tc               [kernel.vmlinux]    [k] mutex_spin_on_owner
     1.44%  tc               [kernel.vmlinux]    [k] _raw_spin_unlock_irqrestore
     0.93%  tc               [kernel.vmlinux]    [k] idr_get_free
     0.79%  tc_pref_scale_o  [kernel.vmlinux]    [k] do_syscall_64
     0.69%  tc               [kernel.vmlinux]    [k] finish_task_switch
     0.53%  tc               libc-2.28.so        [.] __memset_sse2_unaligned_erms
     0.49%  tc               [kernel.vmlinux]    [k] __memset
     0.36%  tc_pref_scale_o  libc-2.28.so        [.] malloc
     0.30%  tc_pref_scale_o  libc-2.28.so        [.] _int_free
     0.24%  tc               [kernel.vmlinux]    [k] __memcpy
     0.23%  tc               [cls_flower]        [k] fl_change
     0.23%  tc               [kernel.vmlinux]    [k] __nla_validate_parse
     0.22%  tc               [kernel.vmlinux]    [k] __slab_alloc


    75.57%  tc               [kernel.kallsyms]  [k] tcf_chain_tp_find
     2.70%  tc               [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     1.13%  tc_pref_scale_o  [kernel.kallsyms]  [k] do_syscall_64
     0.87%  tc               libc-2.28.so       [.] __memset_sse2_unaligned_erms
     0.86%  ip               [kernel.kallsyms]  [k] finish_task_switch
     0.67%  tc               [kernel.kallsyms]  [k] memset
     0.63%  tc               [kernel.kallsyms]  [k] mutex_spin_on_owner
     0.52%  tc_pref_scale_o  libc-2.28.so       [.] malloc
     0.48%  tc               [kernel.kallsyms]  [k] idr_get_free
     0.46%  tc               [kernel.kallsyms]  [k] fl_change
     0.42%  tc_pref_scale_o  libc-2.28.so       [.] _int_free
     0.35%  tc_pref_scale_o  libc-2.28.so       [.] __GI___strlen_sse2
     0.35%  tc_pref_scale_o  libc-2.28.so       [.] __mbrtowc
     0.34%  tc_pref_scale_o  libc-2.28.so       [.] __fcntl64_nocancel_adjusted

Any ideas?
