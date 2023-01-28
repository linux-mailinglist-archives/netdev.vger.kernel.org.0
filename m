Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5E467FA70
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 20:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbjA1T3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 14:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjA1T3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 14:29:32 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795717290;
        Sat, 28 Jan 2023 11:29:31 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1631b928691so10536399fac.11;
        Sat, 28 Jan 2023 11:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mnmziyjvyqqt82Bs4pX8LS1YFr0jbsiIDT0Vdx6lh+0=;
        b=gdgFGZ2KK3KcbxPluC6MKbXNLhEHMRNNu8SJnj6tDVQAHY0VoIvs2qr+1rz+0j753r
         PeWxhu0WUzEf5URM66MsaT3YizsqYQ2fMtEYyxtDWPBNVRKwKI2UKV4yOmky2P+C+6+i
         V1P/LTJcNhgS6X6lzBcg0bHog7OLt/PCVRMSHGZcVUN1T2YVsbu72tpv2za1Nmpf83BS
         pmj844dvVxljULeEOJxllnZ+PelXbpw6wwhDUOHDMHesye9LUbWbiZ91AMublhN23wcZ
         5GAAOx2lHUj0h8AlhY6i7zwotKpFmzjsDsroXoRqfujhjoK6eMjTOq8VbZYrSRE04PgE
         bz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mnmziyjvyqqt82Bs4pX8LS1YFr0jbsiIDT0Vdx6lh+0=;
        b=vFMan7l4fHwHDSNE4YKWn1indK8OsA1CBvaFrteBNbUpFuQYmIqCF+Q5BvfnA2BEK6
         i9BdSxhyDwR8QcMOkto+zSld33+eTSjzeyK6t4KwNQN9xNT/NcNhqPmSZUJjakcOyKy8
         n/b0r3chtdnqjwuaFqttxDCOeEhZ+MCxv2xglq6PslZG/zs//oIYPlqSKQsUVaJrMO0o
         bZ1nIZt8xKKkm3uFAeS9IM3+qnrKJeb4j2S4oypyS+pbbI8thdaKPMxDZn6yIGUy2JGq
         DDQBBkxDdPDq+6F2WuRrUjf7UhkAdaEBn9o8Yxp8lmU8kaBSr58FjxSPGoE96aOvi9QU
         MPGg==
X-Gm-Message-State: AFqh2kqQ6KLwp513AP0Bap010AURlqomj8316C056am9fZzwviAeXgOj
        4VQYE1kiiR/3aQilI3AmLbM=
X-Google-Smtp-Source: AMrXdXtzHXQMh7yurMrTPNz61Fztvgj7t7rIyQ1L+DW4J2sKXPSWRd3af/w2nBR2H5SZBMZrS7JmTg==
X-Received: by 2002:a05:6870:17a8:b0:15f:dbf0:20e8 with SMTP id r40-20020a05687017a800b0015fdbf020e8mr16521636oae.43.1674934169961;
        Sat, 28 Jan 2023 11:29:29 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:645d:3006:6c9:4ca1])
        by smtp.gmail.com with ESMTPSA id x206-20020a4a41d7000000b005175b972e52sm499359ooa.31.2023.01.28.11.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 11:29:29 -0800 (PST)
Date:   Sat, 28 Jan 2023 11:29:28 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net: sched: sch: Bounds check priority
Message-ID: <Y9V3mBmLUcrEdrTV@pop-os.localdomain>
References: <20230127224036.never.561-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127224036.never.561-kees@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 02:40:37PM -0800, Kees Cook wrote:
> Nothing was explicitly bounds checking the priority index used to access
> clpriop[]. WARN and bail out early if it's pathological. Seen with GCC 13:
> 
> ../net/sched/sch_htb.c: In function 'htb_activate_prios':
> ../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is outside array bounds of 'struct htb_prio[8]' [-Warray-bounds=]
>   437 |                         if (p->inner.clprio[prio].feed.rb_node)
>       |                             ~~~~~~~~~~~~~~~^~~~~~
> ../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
>   131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO];
>       |                                         ^~~~~~

Reviewed-by: Cong Wang <cong.wang@bytedance.com>

We already have a check in htb_change_class():

2056                 if ((cl->prio = hopt->prio) >= TC_HTB_NUMPRIO)
2057                         cl->prio = TC_HTB_NUMPRIO - 1;

so this patch is just to make GCC 13 happy.

Thanks.
