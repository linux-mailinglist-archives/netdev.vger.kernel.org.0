Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BF21DD64F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgEUSv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729151AbgEUSv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:51:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120B1C061A0E;
        Thu, 21 May 2020 11:51:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r10so3612140pgv.8;
        Thu, 21 May 2020 11:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=SH5unr8wbll1r0nLOqiPAqTcr8KcbAiLX/s/ShlhUho=;
        b=t1C0b0mkZRIBehE0CL/yZgMz7aFM2J6UU5e3yvyWZAwoDkwFYGGg4WXE4C6sa6FM5Q
         nuPsOzoyEN4e4ggiuq+EfndqCQwGb97y8pDD08YXCEPjM+vQl8aOD8l5V6X/0TsgkPKd
         v4zpa57LidQehmNCNIK/e4tv4ibBlP1aCXadQk30k6xeXA+6RcJU6pVpatUViKiM/59k
         JBvhiPBogs3wREJ/3AAx+oNjZIPE7BVwLsKZ4C/Isoxe4ukVW0CwLxr2LGOlD3IZtPR0
         isY8uSPkIEg+hUYWYQPdeJ7KS/XwiyH/L4IjEleYK8FrkCWeWJk2wdJiHo/786qwgVk6
         2nrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=SH5unr8wbll1r0nLOqiPAqTcr8KcbAiLX/s/ShlhUho=;
        b=UoWVJHmxNyBCVjOWxXGbB9eX1TWgtxSKJTBIJIlvNQVJtLlvM/fu2uuWmGROe48wKD
         IbOvIdpSJQDBzo640hlqtMpYa50BlUjjhlMwsAnd0G06pkR97K5PbV/YDtswsexYZBAZ
         YZXI6adfrCUWo+zpLt9AGssOpOSZTx7dhG6X/UKZvz53TtWQqbwfwAknLHt8emvFTus2
         dlBQtjTYX7N/VsWO4YR0Scq+2JynrZ2eB8ykluQeadloFlLome/zk3uHoWEL8LMjy9Bz
         nq+KX2X9jXSiQu2tJJ8MohpxDJMy52OHnxfjft2x9/tkJCj3hZnWMc3EFyOu+zD6qKNO
         y/Ag==
X-Gm-Message-State: AOAM532jJdvefkiAgQfR1KoBxeFIr7vPqikhq8piEcMAfOl2GsUt7ujQ
        Ua9dAyzdwfq+s/7Vipteeds=
X-Google-Smtp-Source: ABdhPJz0QQ831m5890IF+YT+DynhjgeCXL32XRyiFIdmTwFgL/zqvBhPA0FkNQgRqw6uHghvNaTpXA==
X-Received: by 2002:a63:3c0a:: with SMTP id j10mr10477900pga.35.1590087116597;
        Thu, 21 May 2020 11:51:56 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q25sm5095235pfh.94.2020.05.21.11.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 11:51:55 -0700 (PDT)
Date:   Thu, 21 May 2020 11:51:47 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, jakub@cloudflare.com,
        netdev@vger.kernel.org
Message-ID: <5ec6cdc36590c_71142afbf66925b87e@john-XPS-13-9370.notmuch>
In-Reply-To: <16a158b4-5e85-8ad3-3389-7687add809d1@fb.com>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
 <16a158b4-5e85-8ad3-3389-7687add809d1@fb.com>
Subject: Re: [bpf-next PATCH v3 4/5] bpf: selftests, add sk_msg helpers load
 and attach test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song wrote:
> 
> 
> On 5/21/20 7:35 AM, John Fastabend wrote:
> > The test itself is not particularly useful but it encodes a common
> > pattern we have.
> > 
> > Namely do a sk storage lookup then depending on data here decide if
> > we need to do more work or alternatively allow packet to PASS. Then
> > if we need to do more work consult task_struct for more information
> > about the running task. Finally based on this additional information
> > drop or pass the data. In this case the suspicious check is not so
> > realisitic but it encodes the general pattern and uses the helpers
> > so we test the workflow.
> > 
> > This is a load test to ensure verifier correctly handles this case.
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >   .../selftests/bpf/prog_tests/sockmap_basic.c       |   57 ++++++++++++++++++++
> >   .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   48 +++++++++++++++++
> >   2 files changed, 105 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > index aa43e0b..cacb4ad 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > @@ -1,13 +1,46 @@
> >   // SPDX-License-Identifier: GPL-2.0
> >   // Copyright (c) 2020 Cloudflare
> > +#include <error.h>
> >   
> >   #include "test_progs.h"
> > +#include "test_skmsg_load_helpers.skel.h"
> >   
> >   #define TCP_REPAIR		19	/* TCP sock is under repair right now */
> >   
> >   #define TCP_REPAIR_ON		1
> >   #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
> >   
> > +#define _FAIL(errnum, fmt...)                                                  \
> > +	({                                                                     \
> > +		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
> > +		CHECK_FAIL(true);                                              \
> > +	})
> > +#define FAIL(fmt...) _FAIL(0, fmt)
> > +#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
> > +#define FAIL_LIBBPF(err, msg)                                                  \
> > +	({                                                                     \
> > +		char __buf[MAX_STRERR_LEN];                                    \
> > +		libbpf_strerror((err), __buf, sizeof(__buf));                  \
> > +		FAIL("%s: %s", (msg), __buf);                                  \
> > +	})
> 
> Can we use existing macros in test_progs.h?
> This will be consistent with other test_progs selftests.

That will work. I was planning to come back and cleanup tests that are
not using the test_progs.h variants but good point no point in adding
one more.

> 
> > +
> > +#define xbpf_prog_attach(prog, target, type, flags)                            \
> > +	({                                                                     \
> > +		int __ret =                                                    \
> > +			bpf_prog_attach((prog), (target), (type), (flags));    \
> > +		if (__ret == -1)                                               \
> > +			FAIL_ERRNO("prog_attach(" #type ")");                  \
> > +		__ret;                                                         \
> > +	})
> > +
> > +#define xbpf_prog_detach2(prog, target, type)                                  \
> > +	({                                                                     \
> > +		int __ret = bpf_prog_detach2((prog), (target), (type));        \
> > +		if (__ret == -1)                                               \
> > +			FAIL_ERRNO("prog_detach2(" #type ")");                 \
> > +		__ret;                                                         \
> > +	})
> 
> The above xbpf_prog_attach() and xbpf_prog_detach2()
> are only called once, maybe fold into the calling function itself?
> 

Sure.

Thanks,
John
