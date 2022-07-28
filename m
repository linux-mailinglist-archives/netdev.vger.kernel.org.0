Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BA5584464
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiG1Qvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiG1Qvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:51:44 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2963C8F1;
        Thu, 28 Jul 2022 09:51:40 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pw15so2355052pjb.3;
        Thu, 28 Jul 2022 09:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=g9oYMpODJJiPiB2rG5r6ze/G4kA+eKDoO8ibYbMUthA=;
        b=nHorLRBiYzmmSktLnl0atkrBfVHNyyqWryD458vytfEJBaXVXMMcX4m2rfOoLOYOrO
         7CmpGdfiijs8RUe6Kt411Sd+TehxZvLZPuopvtDJcnxLtxO0mXnuT7djug52tPwPqGRX
         Ooj8+29eag0pUpvI6EPOcZ8wta+4mRAuOtEeeVDMJ3Mnqalmpm3pFskgMG1ZDFvrHst9
         9JoL9omKy7Omv3IUkHczcAavUUQRTv+M9WLWQj3LUaGkJ1txxRzw3RRmfaDGEIPs+rmB
         M7nSG5K3BGew/DWOdRVMVQ7vvHQ55Qt2n8sXLH3nzdvqqjOHnGtwn55e1qCsB9UABkb7
         Bq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=g9oYMpODJJiPiB2rG5r6ze/G4kA+eKDoO8ibYbMUthA=;
        b=mx97JIHBeYrThCaoN3BPSJoIh1Kj4ZveCNNczr7A/xju9BApXIioyryHqzLPn1Wuc2
         prdeYj+wlGJdYZPeh40MIToed1G8UD2McYeCC3TCqGy0iSjcZUBAUD/wszuWlWBTp/fn
         VrEAiqyrkd19C5qmYo9D14WoYFbFN7l+DJ51coJqqWLoCRxOMhfm74+wk8qSPjYHFVfX
         R6MQGsLHVO/97k1LKwrWU7zfgQGr7igLkUpJOBlFbfaRI7ofExdnJZq974XXSjkTRfl4
         bI2cQFpexxgiUv6fUzVOS7EFl3+ePv+SwnaIz6VU5UyIxE/gQ8CgNWNngtXzVgjjOaWw
         dgDw==
X-Gm-Message-State: ACgBeo2BQ2iW8DkjkPsD1vwD1Ztx+sRPrj0YczN9w5QtGDdRhiwqu9xG
        pk5CnhYZhj7MuJgdre03oiY=
X-Google-Smtp-Source: AA6agR4Yf7pIKPqWzbyTtw8ySQc4NgU3XE31DTwqCbwWg0UWkf8LTdBHDmDSbHsp1hrjO1q2Z2OGPQ==
X-Received: by 2002:a17:90a:7a8b:b0:1f0:80db:129c with SMTP id q11-20020a17090a7a8b00b001f080db129cmr264513pjf.209.1659027100070;
        Thu, 28 Jul 2022 09:51:40 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0016db7f49cc2sm1541486plg.115.2022.07.28.09.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 09:51:39 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 28 Jul 2022 06:51:38 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 2/8] cgroup: enable cgroup_get_from_file() on
 cgroup1
Message-ID: <YuK+monxlKfeZmQb@slm.duckdns.org>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722174829.3422466-3-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 05:48:23PM +0000, Yosry Ahmed wrote:
> cgroup_get_from_file() currently fails with -EBADF if called on cgroup
> v1. However, the current implementation works on cgroup v1 as well, so
> the restriction is unnecessary.
> 
> This enabled cgroup_get_from_fd() to work on cgroup v1, which would be
> the only thing stopping bpf cgroup_iter from supporting cgroup v1.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
