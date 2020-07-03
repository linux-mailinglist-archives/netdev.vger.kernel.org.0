Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A4A213238
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGCDag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgGCDag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:30:36 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C710C08C5C1;
        Thu,  2 Jul 2020 20:30:36 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id z24so10179193ljn.8;
        Thu, 02 Jul 2020 20:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fMHCiIT2igJGwMje+1cDDRM9eOFHpROEjGTjyJAQ6UA=;
        b=cUvReugxvHXq0NF/DEFSRH0pIuBN+80rWrWaSAF7RBrmx6Mbd4uL+mrZjbd0Xm9JJK
         lA5tx3QnaRgImf5ANt03B1zmXajLL+nrRpsl7Nun+p90uzzfOx0RnWw98J9vrYNaxSY6
         HrXixvE7OL2pbIxsHdBlrv4DIPAl87Ev/o+qoddTCv9LYvmcyQsCbG8a31LbIN4PaWux
         Ana6knxghyN7RbLSKA+Ne56q7bhtB+lzGwiWde7sbYHVK1dIZIlZfKlVI6wyZpw7OLxJ
         QzCJaB5Mb0GBTW5CdofhfILZO9i0Z3upiST3DVEBZMK5phveLbBe+KQdBPzK5FE4sU4S
         14oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fMHCiIT2igJGwMje+1cDDRM9eOFHpROEjGTjyJAQ6UA=;
        b=qhfTYrI4f8VsZUgOUulAuC/5SND0SEWVNX14bchd0f1O9uQ65BLEvqKcnqYnyh2XdQ
         wZCapi82kbjxor1sshtCa7au2Hz8y+O0rIllmbz09gVcLadjZcaDv/Ex1PU5r0KLcvU4
         TRurMO2YHmAa1bdBBu+TL8hKJH2cxZjVCzMev/MVV0awXs7mbxHaVHQB8jfpeILa8QBx
         j9DF9siqPnQaMANwqgjXItKv8kLDLpWI+p/9LE+Aa7y7zlDWRJOHcA2R0mquxqUvAg64
         bxiK9vVymYvjcJcGepjpg8tP2lTZC42Vf5NWeQtQE3YqAhaBguBLfNu+fqZe4ztftAHE
         AYpQ==
X-Gm-Message-State: AOAM530NwgscnPfRWXqDhH+Nw0iXCZCevjxAzayi0Rwx+rpg21tTF6nQ
        jJg2YfsMYXxAzUCc+IoVhB5J0xJXdyKGqXL9CLk=
X-Google-Smtp-Source: ABdhPJwvHXVhM286nvN0jfNw6TZ+YFd2D9K4jSUIJiWaOqcFEKj0X5NIE6+LEvJwNzZX0SI9kMNnV4zB7OhTcSTuTiM=
X-Received: by 2002:a2e:8ec8:: with SMTP id e8mr8364149ljl.51.1593747034572;
 Thu, 02 Jul 2020 20:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200703024537.79971-1-songliubraving@fb.com>
In-Reply-To: <20200703024537.79971-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Jul 2020 20:30:23 -0700
Message-ID: <CAADnVQK+7MrnvjowvuNzBJFp9i7L8WK_Zi_9y=+dtaRC6BzXAw@mail.gmail.com>
Subject: Re: [bpf-next] bpf: fix build without CONFIG_STACKTRACE
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 7:45 PM Song Liu <songliubraving@fb.com> wrote:
>
> Without CONFIG_STACKTRACE stack_trace_save_tsk() is not defined. Let
> get_callchain_entry_for_task() to always return NULL in such cases.
>
> Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Applied. Thanks
