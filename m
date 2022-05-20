Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1A52E669
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346593AbiETHld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiETHl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:41:28 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C643B427D2;
        Fri, 20 May 2022 00:41:26 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w200so7080310pfc.10;
        Fri, 20 May 2022 00:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RCiECH/4G+z+xrwvKHneVVOuojV/v569kz7/GW36BxA=;
        b=Y8SCxfyRjKdY8qHJ3D4MDAZ5k3+J3h3mX8JWQ+xBHcE8p3iO9tZ9IBCP5gj32yCPE8
         Clg7iXRfHY0fEx7/ycD4AG4FtmgatsPL53gSb+rNQffMPMQq+aeV4Sbw4RVVJmZxhQu5
         1Owu29+6Z4Ha2goDPmiWf/TyIsNFhmhYVbYH7RxaWBMA5P/4SIoTBrXueUvhjNT2k8gW
         qMY/Y2kIMoC31//gOwbZ8QeLasI0I4hDPGUIGRVFoiiH89bdBuFbnhXt6lkosObFJ4yq
         U0xBnKJpnSaRD0o1i1A5o7yqYLZpXQXDF2twY3a2B97ob6Hz5ulQIqFmU41wGVN+9V3E
         0inA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RCiECH/4G+z+xrwvKHneVVOuojV/v569kz7/GW36BxA=;
        b=sHYaSfHbJKGB/3TMiWHsMjuf6G+U9D4TPVGfUk9jwrQfx1loIve1o20SnFa7ux4Y8B
         mqu0J+2KxJWOUO2geTMfcctD29ZzsD6WXIbZ5tjiaPDnE9ANgLNzhamINefQHmxU5wvn
         kH8OkmnMxdDkqhMRvfLEr32YZSPo3mvs6pGj2ZIw+ZvCX5jKAQ4Q0ne3A8bk2ZfiQPgZ
         TJp5aUXrDBZx10PdwO9T1c1RUYywy8ykGxezzT2hQfKHZeWKgDlPcmjhwATgH40g59Xb
         MR9Rgx1DzzhniztqD097Uv/ZvU7EMckhkoj/i8bIooA8h2eMvDBUc28AQ6Ij89NZJ+k6
         UyxQ==
X-Gm-Message-State: AOAM533e05pqoZ00EFm3rBdWleKiAk0HiFZJ8vY/Y11jgZIu431l6VKu
        JSbQTbeDalWIWGNxj5pYRFc=
X-Google-Smtp-Source: ABdhPJxcTEkof1uQ6x1eykZuGZYblVaFc0hP+mm+mT9iEKeVIpGAv/+B1zkRoAOzKGQG7BIpRCsjyQ==
X-Received: by 2002:a05:6a00:a94:b0:4fd:c14b:21cb with SMTP id b20-20020a056a000a9400b004fdc14b21cbmr8999494pfl.53.1653032486217;
        Fri, 20 May 2022 00:41:26 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:1761])
        by smtp.gmail.com with ESMTPSA id o10-20020a170902d4ca00b0015e8d4eb228sm5091246plg.114.2022.05.20.00.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 00:41:25 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 19 May 2022 21:41:23 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Message-ID: <YodGI73xq8aIBrNM@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520012133.1217211-4-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 01:21:31AM +0000, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
> iter doesn't iterate a set of kernel objects. Instead, it is supposed to
> be parameterized by a cgroup id and prints only that cgroup. So one
> needs to specify a target cgroup id when attaching this iter. The target
> cgroup's state can be read out via a link of this iter.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

This could be me not understanding why it's structured this way but it keeps
bothering me that this is adding a cgroup iterator which doesn't iterate
cgroups. If all that's needed is extracting information from a specific
cgroup, why does this need to be an iterator? e.g. why can't I use
BPF_PROG_TEST_RUN which looks up the cgroup with the provided ID, flushes
rstat, retrieves whatever information necessary and returns that as the
result?

Thanks.

-- 
tejun
