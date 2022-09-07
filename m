Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3066F5B08F5
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiIGPpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIGPpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2145D11B;
        Wed,  7 Sep 2022 08:45:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so11301317pjl.0;
        Wed, 07 Sep 2022 08:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=2Bs5WeryLUwa4Em1EtgsOFsgucZrdl6s2s+rxtjCKv0=;
        b=GxZU/LPMUM2KaQzz22yGfVZ0We3v/2AvN6pejZw2UwV51PxFDYfmieeDwxAEIBEbCe
         FQ72oqE3rYDNlKuQBtdr6/CLx48G2JCzMLv/Sa0M9GDF54vR4yoAeJeHyrM7R86jGHa6
         2+w3e5Ntk8A04yteNqP3T/ta9icCvGnrcwvuI0UuKUcr2RGXcULYUEdOcHFphnDLPUsK
         GnbL5qo3awvEkIfiBOSJXiOfkERKwb9ES7IZLbTNMwFWimoAS1+h7t9SatGqjur9L5Ev
         GIDbpI9wn5g/vtaZeKua6lIh8BgDP+2yocrlNWS9DJ70hRjjf2vmPNSyNvV5Bnd9ld4g
         RMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2Bs5WeryLUwa4Em1EtgsOFsgucZrdl6s2s+rxtjCKv0=;
        b=uxYwI79O6SH/PQXa61M+9QXjy5tXFhydeGGVoZiXbe42w+uKrg73cv4ymthCKm2xZW
         WEg5sXGVNDm+inaubQyj6jLtVJStu4856w5XIP0km7i2riPJ5NaaygaAW8/p5aF5jqo2
         QDLMzUI74awmr6OKhJU36sQd+3SVyPp4tpPM8xFZEkgSnCEOvwS8+Ld1UwXW1PpvMGHv
         YX7QDg/YguvgJIjQu2lFvdWHVEX/5aIvGnFuCUmbcvvcuJFogSjooY6oI/r0D115LzH6
         81iTm4/1Ol71C/cfH4CFxmyMv6t3YFDRMA8rwZZytynmfTuUVYXB7uxzOBew+elQlKDY
         rRpA==
X-Gm-Message-State: ACgBeo3ceaqmo5CTYjynf0Z4XHThJvXvORG/DEivQV8dfZMYCrSWniqm
        sQPYLqvfE7c6yILkaDVpB1cTzUaRReE=
X-Google-Smtp-Source: AA6agR6i5fmZcERBsBE/o4wuPIE+v1IqIaxzMYQsvK1QTKGQ/xkfOPZ+F7IgGN7ueffOchvyeQOiPQ==
X-Received: by 2002:a17:90b:4b08:b0:1fe:54ac:6b6 with SMTP id lx8-20020a17090b4b0800b001fe54ac06b6mr4794370pjb.208.1662565516758;
        Wed, 07 Sep 2022 08:45:16 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id 125-20020a620483000000b0053dea60f3c8sm5793866pfe.87.2022.09.07.08.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:45:16 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 7 Sep 2022 05:45:15 -1000
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
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for
 bpf map
Message-ID: <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
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

On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> ...
> > This patchset tries to resolve the above two issues by introducing a
> > selectable memcg to limit the bpf memory. Currently we only allow to
> > select its ancestor to avoid breaking the memcg hierarchy further. 
> > Possible use cases of the selectable memcg as follows,
> 
> As discussed in the following thread, there are clear downsides to an
> interface which requires the users to specify the cgroups directly.
> 
>  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> 
> So, I don't really think this is an interface we wanna go for. I was hoping
> to hear more from memcg folks in the above thread. Maybe ping them in that
> thread and continue there?

Ah, another thing. If the memcg accounting is breaking things right now, we
can easily introduce a memcg disable flag for bpf memory. That should help
alleviating the immediate breakage while we figure this out.

Thanks.

-- 
tejun
