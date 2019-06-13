Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445CA445EF
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389170AbfFMQsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:48:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36946 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730244AbfFMEug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 00:50:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id v14so19153475wrr.4
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dt8CXLyEGW4hbQR5ni3vukx12yipOarAWNOeo5Xq++g=;
        b=Gwj1XmwzXxS8nJXz6XCpD+ZtXBK0AhCOyNH8LzgH2EPh9ypDDqdjdgumK1/sGVrqXU
         UAbU94sZq8oObmIAcF7DMFYRicnr+E36n6Her7D7XsxjsAyjXyUvcElwoLNytrpc4/tB
         m2MojuAoAaBPQ/7HOb8yXXxYIYbjfnB6u152bY9G3lq9tAe9xqUR55BrHaifT81Ju4hZ
         eGcwazb/RuhK0F/eR/4sESeTnhiJqvyc9NtuuXHj7vL9bMfsJYTfW1gfpfZdVPH7bkFe
         U9+Y90DNr8IYqGRlyxmryHNexeM35UBR9YI4CbFUizhvBmlWgA3Q1o/voMvx7TqeoZQM
         KsaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Dt8CXLyEGW4hbQR5ni3vukx12yipOarAWNOeo5Xq++g=;
        b=JU52/xROJ5oURNzIktN7f4EC2g3HVMgvXSP12ExftvzbTZl/E+5Qqvxn8PTuivlzA8
         l4yzFpOnjqrl+W6lrZPII8US9ToPlIFtXDzTjMogsejYVxez2ghOEB+5+BOHcpcauV3k
         JBRCYWiF5Vx/uPu/TUt7wGMSYLmRjPSKeQEExtjWed1qadydiuvnJagDOirkQiiYFIeB
         KA3izBjYwiD9Mxwk/L/F6dng2e/NVbSvzk4kH1kWDgyJEuUxlkN+qkvQumFtuVK4Sajj
         5O0cCdN5Sr2fKSJ+DuTs/SN8Ki+PuaMoNxU+/xolErSjaVxckvzU6WQxCNfbZPCcI24u
         Xbhg==
X-Gm-Message-State: APjAAAX2k2Iui8oQHC5TXScoEOCtoDT5VBXxq8WrsUsjvHXT8xUIvGAe
        6gupUEWMyhIWo8Ytg8zvPDLhjA==
X-Google-Smtp-Source: APXvYqx8cbmWPWTjWGOiCzn1foIDQoATD3i4MUc7w8eHnndgjIHliahu7cRGdj4Oz7AwqdmqDOz3ug==
X-Received: by 2002:a5d:4843:: with SMTP id n3mr5598852wrs.77.1560401433465;
        Wed, 12 Jun 2019 21:50:33 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r12sm663115wrt.95.2019.06.12.21.50.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 21:50:33 -0700 (PDT)
Date:   Thu, 13 Jun 2019 06:50:31 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, vladbu@mellanox.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, mlxsw@mellanox.com,
        alexanderk@mellanox.com
Subject: Re: tc tp creation performance degratation since kernel 5.1
Message-ID: <20190613045031.GA2254@nanopsycho.orion>
References: <20190612120341.GA2207@nanopsycho>
 <e11118334595e6517e618e80406e0135402cacf1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e11118334595e6517e618e80406e0135402cacf1.camel@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 12, 2019 at 02:30:37PM CEST, pabeni@redhat.com wrote:
>Hi,
>
>On Wed, 2019-06-12 at 14:03 +0200, Jiri Pirko wrote:
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
>> 
>> Output on net-next:
>>     39.26%  tc               [kernel.vmlinux]  [k] lock_is_held_type
>
>It looks like you have lockdep enabled here, but not on the 5.1 build.
>
>That would explain such a large perf difference.
>
>Can you please double check?

Will do.

>
>thanks,
>
>Paolo
>
