Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A56547760
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 21:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiFKT5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 15:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiFKT5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 15:57:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41046B7A;
        Sat, 11 Jun 2022 12:57:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so5261800pjm.2;
        Sat, 11 Jun 2022 12:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=69qufdjHZYbeHsBwGe+HrL6zSpg4GE3ElfZE/CEpkyQ=;
        b=f++YpzR5KW9PWNVQnwBZeC4BYVySUNWUywzBPcqEkDMsHP7whRtKdbDnED0JnsAIUY
         DuNFL3fl5QyGoXE1x1+G0bZaVqZQL+D4Z619LX9xiI4NOLrPokU9c3QjLyuygt3seQzj
         7dEK/IY5CU31UAi8ZqkoiEM1kp1xp0wKpL5N2gQqr1EP7UrZANkI8+S1Ilv7Ca+Wr38K
         6M1N0uWjM87BhWhVVx6drQ5VybmkFoRqGepvynIsSIUMBHPUKuR88corOkKV92gJg2e8
         UR2HpKIwpu4cZJIw9tdjlxDmupZrQs2ugBNEhO9hQw7cGynYbMO8Uk666TNMu7cQwkwf
         O80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=69qufdjHZYbeHsBwGe+HrL6zSpg4GE3ElfZE/CEpkyQ=;
        b=HJd2RrPBUer/JpBFvSqa+J0X4r13qV9P9XcWaViY5SSS/ncqdxMbt1prPHmYe3Vl/P
         eHSqKyaR1Ak+tJEQNbS/Sgz32n9Z8brMP5dw0loV1MfOIrebiovORner4ygawnv9i//w
         GDLFvnZvpOKEii2EoFLTXuzYbwv8cyfiYK22iRrJ9D0TW8FAT1su5lhJOnMSh+boQCzH
         ekhS8huo0MZQm/8rspG9yriBEHEGDau84NFF6aBmTK2k0D9WxEUPiZ95B6Fnnay1Xfk5
         y0xGqTTgxQ1gqeWd3dWG0EgH8xh+K5vN7aEdHS3TAUlhYcMmQVqdDrwlvjMG4+FiL4rq
         riog==
X-Gm-Message-State: AOAM531POjvDgPMktGv5VUN+d5wACxfYHVXFfhwntlHLZIvul78wHx/M
        ErBFWBP9jD/3WC9FfVKLCUE=
X-Google-Smtp-Source: ABdhPJz6sVxevR2EC7IdVU5xVRIhXQzrxc0LNvyBp78nOWXzKhD+dJuZKt+yjFTOjzu5UZ7OHK2wTw==
X-Received: by 2002:a17:90b:17c7:b0:1e8:5136:c32a with SMTP id me7-20020a17090b17c700b001e85136c32amr6690635pjb.43.1654977431686;
        Sat, 11 Jun 2022 12:57:11 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::4:93e3])
        by smtp.gmail.com with ESMTPSA id cp20-20020a056a00349400b0050dc7628150sm1966521pfb.42.2022.06.11.12.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 12:57:10 -0700 (PDT)
Date:   Sat, 11 Jun 2022 12:57:06 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Michal Hocko <mhocko@kernel.org>, kbuild-all@lists.01.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Message-ID: <20220611195706.j62cqsodmlnd2ba3@macbook-pro-3.dhcp.thefacebook.com>
References: <20220610194435.2268290-7-yosryahmed@google.com>
 <202206110544.D5cTU0WQ-lkp@intel.com>
 <CAJD7tkZqCrqx0UFHVXv3VMNNk8YJrJGtVVy_tP3GDTryh375PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkZqCrqx0UFHVXv3VMNNk8YJrJGtVVy_tP3GDTryh375PQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 02:30:00PM -0700, Yosry Ahmed wrote:
> 
> AFAICT these failures are because the patch series depends on a patch
> in the mailing list [1] that is not in bpf-next, as explained by the
> cover letter.
> 
> [1] https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires@redhat.com/

You probably want to rebase and include that patch as patch 1 in your series
preserving Benjamin's SOB and cc-ing him on the series.
Otherwise we cannot land the set, BPF CI cannot test it, and review is hard to do.
