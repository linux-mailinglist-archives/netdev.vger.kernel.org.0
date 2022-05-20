Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BB752EAC3
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243138AbiETL1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348502AbiETL1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:27:42 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7035D118009;
        Fri, 20 May 2022 04:27:41 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y199so7516308pfb.9;
        Fri, 20 May 2022 04:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+9muHQcSOPadjELaK4tBcIlD0k856uUfntUxfRazXLk=;
        b=Ao4YwNxEANIqA3Dyk1b/rxmBdNuHL7GvoYBuDycoCTZQt/Vw7ghB/x/W1uDmrygwUh
         ZCOdrrAEkOWjqjv6YVqpVG4zrjzsDCqFbhMv46EPRRMudfif5CGT4m7OGe5qGXs2xCH6
         gdzX9ygA7ovfxwBmlG4x9Irbwdb3DkHTyKqVVGELOPbMvf9k6p/xlMXriOgcjKGO4rLv
         pPIJvH/5FMQq9/loteNF5RYVpe4mtKF4+lZuVNiVrwpN6GT7rXoipiYq/z2HO9FxiVLd
         tyeTXejon/ephAWoN7uz4Bdz48sZvRU0qsArH1lB8+SpkRWYtZpMHOweZEBpupJDWxFz
         zTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+9muHQcSOPadjELaK4tBcIlD0k856uUfntUxfRazXLk=;
        b=gFuk6fji04CaZOYXOOb06PNv0EwdB6EUqXbflQyPfaGs0/PqX7uyNR6qbwg+9+7O5H
         6pe8eDsI46ZywuPTLyJr17vrLU3A5CDnPdekKLruMCRinEtvBa1iqp1REK9FFYsZtTXB
         yn6FWkfCeyCO2bj1aSbBnz6w7z1RqzrBNPS7nFfPA6heeVeeMfgY72aEis+EYFXQsM4i
         Q9+h22/QfaeZRG0R2MVZzOuau/wVeCPzfzHQJV+Nai0nkgyDUUdFvhlgCIj6Es0iaAPy
         nHTeypXBfko1BKATB7liAjOIrIsaeFt0gLMQZ6YCbrlQaTIJJUzrzauod82n4iqJJrVV
         WT6Q==
X-Gm-Message-State: AOAM530iwUP6UA+0j374oiIOEZO/8r3Xpj7uRzHHvS3pOimC0wh0Ow7J
        4LiI3QxvWv+3fOfYx4vgkCE=
X-Google-Smtp-Source: ABdhPJzVYpoaWqwse1P/Re7U5FfhkDWT1ibsEDDckJa02ugpIftbZLj7MqGPlEhmtk6ZJCxajU43KQ==
X-Received: by 2002:a05:6a00:1690:b0:517:cc9e:3e2d with SMTP id k16-20020a056a00169000b00517cc9e3e2dmr9548003pfc.0.1653046060372;
        Fri, 20 May 2022 04:27:40 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:1761])
        by smtp.gmail.com with ESMTPSA id m9-20020a1709026bc900b0015ea95948ebsm5445350plt.134.2022.05.20.04.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 04:27:39 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 20 May 2022 01:27:38 -1000
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Message-ID: <Yod7Kt4WHUCQF6ZL@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YodNLpxut+Zddnre@slm.duckdns.org>
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

On Thu, May 19, 2022 at 10:11:26PM -1000, Tejun Heo wrote:
> If you *must* do the iterator, can you at least make it a proper iterator
> which supports seeking? AFAICS there's nothing fundamentally preventing bpf
> iterators from supporting seeking. Or is it that you need something which is
> pinned to a cgroup so that you can emulate the directory structure?

Or, alternatively, would it be possible to make a TEST_RUN_PROG to output a
text file in bpffs? There just doesn't seem to be anything cgroup specific
that the iterator is doing that can't be done with exposing a couple kfuncs.

Thanks.

-- 
tejun
