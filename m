Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E35644D48F
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 11:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhKKKC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 05:02:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232635AbhKKKCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 05:02:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636624795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJZyqwp1ZfPiiIIAKWZ1DfaVeDawYq4abX63m+PU+To=;
        b=Y7WigNEiQAQVyYxSZdA5SNGcaXkf8DVTcnH0N2mZdbpuhHWq44rWw2VFCVWZ4Q35ggoI1l
        yBASPRJRmJd7DfGsWuUSisM7xqB5+bITYE3rkvhNcxWxD3pxOfbP9SXmDQ7iZUq/2uoA1D
        UUUQBd/h/+YSmfB9gHLPk3huNAHxldE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-iF2ZUna8MTq2gCHN872KuA-1; Thu, 11 Nov 2021 04:59:54 -0500
X-MC-Unique: iF2ZUna8MTq2gCHN872KuA-1
Received: by mail-wr1-f69.google.com with SMTP id p3-20020a056000018300b00186b195d4ddso911972wrx.15
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 01:59:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JJZyqwp1ZfPiiIIAKWZ1DfaVeDawYq4abX63m+PU+To=;
        b=xUm9tRqVVqBLGgUppFn7iEmtR3HSYYWSjk1Wf4m0hQpXjoTUhUWvyM/BhluPnEj3F1
         mfg1hP9hlWszQnz4+uCAIYpKbu4/AqSVlOrNuMGvcM0o/HT7RXdglfqXNmNcXodvfmnQ
         /5KSftxWzZzMNuNGDudoIDcEN6OR6AwXnjQPRR/f/WWGv9tNYa2nRhWw8xQ17W3xucvN
         Z4d5bqZnlLvaBcavo0l115fbcK8n9vhQtHivMpTh7LOILMrM2U6G6ctV2yiJhAOhvis2
         IdiA/weP+je1QM9IISXCKfY3esDZsJmoTrpCHD+taABjCrESHRMc1nUvHAAaBh1TdQoQ
         WxOw==
X-Gm-Message-State: AOAM532G3oBeswKpgBnoiy1G+HzkWBrEjt+lHcQf+5W5JAQ8WaQxWc3o
        TvqBafNRPwZ3ByUVxjlbAUupjONAvEXwOtyUz7tY5hjUD0noMMv/MeevU3RU/eCnKmJqfXvVv9g
        SZxQmzzeoTVLm1vyM
X-Received: by 2002:a05:6000:1acd:: with SMTP id i13mr7515128wry.398.1636624792244;
        Thu, 11 Nov 2021 01:59:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCMFguV57azEtjX0H9g2qbHnrf05evwsn7R3U/X/5WhRj7wS9zZ6r9M/+fj7ufva631F1UwQ==
X-Received: by 2002:a05:6000:1acd:: with SMTP id i13mr7515110wry.398.1636624792096;
        Thu, 11 Nov 2021 01:59:52 -0800 (PST)
Received: from [192.168.3.132] (p4ff23ee8.dip0.t-ipconnect.de. [79.242.62.232])
        by smtp.gmail.com with ESMTPSA id d6sm2404299wrx.60.2021.11.11.01.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 01:59:51 -0800 (PST)
Message-ID: <864f67e1-6250-57ac-511b-60a3590af2c2@redhat.com>
Date:   Thu, 11 Nov 2021 10:59:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/7] fs/exec: make __get_task_comm always get a nul
 terminated string
Content-Language: en-US
To:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
 <20211108083840.4627-3-laoar.shao@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211108083840.4627-3-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.11.21 09:38, Yafang Shao wrote:
> If the dest buffer size is smaller than sizeof(tsk->comm), the buffer
> will be without null ternimator, that may cause problem. Using
> strscpy_pad() instead of strncpy() in __get_task_comm() can make the string
> always nul ternimated.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

