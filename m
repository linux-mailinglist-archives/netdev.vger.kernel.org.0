Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380E952EA96
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348069AbiETLQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348460AbiETLQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:16:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28908201AE;
        Fri, 20 May 2022 04:16:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id h13so1226896pfq.5;
        Fri, 20 May 2022 04:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cSj1iULxPa/Q17vQx9CvBh+XXwbDyu32iNxH8BDHGWo=;
        b=KAl6JiUblhGNLjQZ5H0XrsEH9sR+zAIGiIrYCvRSOx3z++Jx75Eil0AfqhCM8BbmPR
         qPbECuxldaypu17UE9fgu89sGfMl+EohW1msxEf6R+k1ZrxamBnRam6cYcJcx7mXGEqg
         g/6VIVWY73HuktEyJ9EyJCB4Lddi2viqjElMH2ai6Q9L+7nv7ma1iOTRAbMr0jGRP0sT
         T2ga5r8esXHAIG+CzKW2Pt1e8LuhbOIyKuceUi9Yu5OgSv+9+TSt7xFSfM1lI8rZhdxQ
         aVEFgCYfivV/FDw3ekn39hJpjJ8YmEZ/SpoeZdUduz+g+kLNR+zul2CDNo3FNVhbchS9
         tEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cSj1iULxPa/Q17vQx9CvBh+XXwbDyu32iNxH8BDHGWo=;
        b=0w88yCrOL04HwqV5gLOWjIFgDP0uBZPSjC4HwA7j7jzwRJIzIgVsdCu4FqViL5FvQ7
         MNx4wNSizTpF209qV+DHVEoP95X2w3Oue2vdTgjoHn1uoNT0zBE5ey+NnxVvjTvQxGIi
         FDpQ+BsXBxUCs3PottXCEglZsGEwypRbBNAOSDSlcyM3qk6Z3/QYMuZg9a90/aHCLiEb
         DVooyjnx2J+WFfjceGq2+HaMmEKglBxerSlh4zYRyXzfQwxTQWYP2LwXX7Bo3SyTrauX
         6fXCAmAgYqz/g5jGzkmoszWQNZoVvcdXyJa9i55zjq9j7V6iH6GxHd1UfKAYh4nJh+lj
         mwiA==
X-Gm-Message-State: AOAM533hze85FmLKL61QQUsktWisM+oV9UFKK+YoiqhPPoLb2qMRJLJM
        t1ggoNEy1QLTAwV2bwTj8dy3j/VAgKk=
X-Google-Smtp-Source: ABdhPJyqsW819iNKjHVYIQggrJBIiy7DKH8+i2ACo/uPCYVrkPdFb8BHaiKm7RUnHS5MzQbqtCRdew==
X-Received: by 2002:a63:1a1d:0:b0:3f5:eb02:b6b4 with SMTP id a29-20020a631a1d000000b003f5eb02b6b4mr8196749pga.343.1653045362244;
        Fri, 20 May 2022 04:16:02 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:1761])
        by smtp.gmail.com with ESMTPSA id y6-20020a62ce06000000b005082a7fd144sm1559042pfg.3.2022.05.20.04.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 04:16:01 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 20 May 2022 01:16:00 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Message-ID: <Yod4cN+HayIDhR/c@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
 <YodCPWqZodr7Shnj@slm.duckdns.org>
 <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ@mail.gmail.com>
 <20220520093607.sadvim2igfde6x22@apollo.legion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520093607.sadvim2igfde6x22@apollo.legion>
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

On Fri, May 20, 2022 at 03:06:07PM +0530, Kumar Kartikeya Dwivedi wrote:
> With static noinline, the compiler will optimize away the function. With global
> noinline, it can still optimize away the call site, but will keep the function
> definition, so attach works. Therefore __weak is needed to ensure call is still
> emitted. With GCC __attribute__((noipa)) might have been more appropritate, but
> LLVM doesn't support it, so __weak is the next best thing supported by both with
> the same side effect.

Ah, okay, so it's to prevent compiler from optimizing away call to a noop
function by telling it that we don't know what the function might eventually
be. Thanks for the explanation. Yosry, can you please add a comment
explaining what's going on?

Thanks.

-- 
tejun
