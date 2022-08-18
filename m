Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F5E599060
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244301AbiHRWUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346323AbiHRWUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:20:37 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C66D7CFA;
        Thu, 18 Aug 2022 15:20:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso3167097pjj.4;
        Thu, 18 Aug 2022 15:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=tr2YfKFFpUU37xf4ManQv+y3/4pV4AbAVOF71yP0UDM=;
        b=KY80Ec2EYHn5WFnbgKROZvwVrPBKR9TCPDJ4Bw/+YH1nWvZ8zBC4HiM3kL62FVSIHI
         V0sdJqE1+X9/hYSAmkHX0ttVunBfUUbxdDrijYE1S/aTAyrKetMJtSJdoIjYHfPOQ3gD
         BQwpS4K/1PXEiiH3xvM+lKbDEHg7ytztTUVJXVqOAJI9gHejz/CO3QZAQx8IfbGXsn4J
         5bGMKpnl8EWu/l4SxhTYFUOiXMIhjxYbCo3JCHVlgJw0rKdbSnaJKuxVV3Hg2XNzKGy/
         ykd1zcDd2xq+d6sycmuHscFeHGXchvlK3L+cVKS4i45SaDcrLIhwWniy+rYMw7SUKrM1
         BomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=tr2YfKFFpUU37xf4ManQv+y3/4pV4AbAVOF71yP0UDM=;
        b=z0UhjmP5LdmQ5rGHxrmwXyOq+OfvzIABtUiGs2ftqK4Tpib4tS2NIqoYjtavXcCg9H
         1Mq5MY/5cG26pJbqVM1klgtOau92NoKPqpsGg+W4sMA+rDVPq1ZB6myxCwmV83XAx0XF
         FnAmVVx/aALCYRcPaLQnHlAPtF1CkPQHpKy1qJ+5JODX7ekkA86bMY6grosWq1/jXtQO
         kie+eoEq1SzlJW4aii902J8gvN7VQPwAjsy+LXNjYyhblocfRCsfo3FU9EcJPhU6+NX9
         Kpc3UGV+P/Ob3vyFGPG4z8m3XR6G/EZFifl/THsOiS4iUmrI1YAHnBCTV66iS9jBYol/
         ftyA==
X-Gm-Message-State: ACgBeo3sJyMcLvTZP8AjqNph6PxLB4WHciQIgeScNLYlLtBZRLpC/CHq
        3A5awWQOXX/YMljr3yLYOxE=
X-Google-Smtp-Source: AA6agR6n9/ROxNFwoI1/6v2qOdwWNT55R5GNh1WmF2RNjQvaps8yoCjJOuhOltGV9kEx+rTK8QvldQ==
X-Received: by 2002:a17:903:1205:b0:171:4f8d:22a8 with SMTP id l5-20020a170903120500b001714f8d22a8mr4336955plh.11.1660861235443;
        Thu, 18 Aug 2022 15:20:35 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:3b7])
        by smtp.gmail.com with ESMTPSA id j2-20020a63fc02000000b0041a615381d5sm1736207pgi.4.2022.08.18.15.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 15:20:34 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 18 Aug 2022 12:20:33 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        lizefan.x@bytedance.com, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for
 bpf map
Message-ID: <Yv67MRQLPreR9GU5@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818143118.17733-1-laoar.shao@gmail.com>
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

Hello,

On Thu, Aug 18, 2022 at 02:31:06PM +0000, Yafang Shao wrote:
> After switching to memcg-based bpf memory accounting to limit the bpf
> memory, some unexpected issues jumped out at us.
> 1. The memory usage is not consistent between the first generation and
> new generations.
> 2. After the first generation is destroyed, the bpf memory can't be
> limited if the bpf maps are not preallocated, because they will be
> reparented.
> 
> This patchset tries to resolve these issues by introducing an
> independent memcg to limit the bpf memory.

memcg folks would have better informed opinions but from generic cgroup pov
I don't think this is a good direction to take. This isn't a problem limited
to bpf progs and it doesn't make whole lot of sense to solve this for bpf.

We have the exact same problem for any resources which span multiple
instances of a service including page cache, tmpfs instances and any other
thing which can persist longer than procss life time. My current opinion is
that this is best solved by introducing an extra cgroup layer to represent
the persistent entity and put the per-instance cgroup under it.

It does require reorganizing how things are organized from userspace POV but
the end result is really desirable. We get entities accurately representing
what needs to be tracked and control over the granularity of accounting and
control (e.g. folks who don't care about telling apart the current
instance's usage can simply not enable controllers at the persistent entity
level).

We surely can discuss other approaches but my current intuition is that it'd
be really difficult to come up with a better solution than layering to
introduce persistent service entities.

So, please consider the approach nacked for the time being.

Thanks.

-- 
tejun
