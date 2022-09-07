Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2425B08E6
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIGPng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIGPne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:43:34 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFBD9E2D5;
        Wed,  7 Sep 2022 08:43:33 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso18700114pjh.5;
        Wed, 07 Sep 2022 08:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=P2y+BRPoGQxcqMhj3bfHoCPdDwxzhdrBdUaNfcmh0tE=;
        b=f5sV92bQm4uCzJmJSVchg7K5WurYb/bA7u1+zpo2OohtxddaHLFxpVSinPu25hGluS
         VkVOWz86PqadpIhvGnfZmfe930SnCERVZ2J3AOA0m1LyyfcQEry8dCLvK5fhH9KSEV18
         /rRmvEwReN/H0EpByLp1q/20tf9gmD9mgGGF6nSZdvU47MkCXJlk8293pdZBJKCefA5y
         YYWhiBYlY8h7ehdLbUBnhi1pc7HuYKW1myQIGQxATR/Q0Szx3n2srUQgWD96HzkCvz1Y
         LymO1eHKTcsuqUITTxAhGw24ZQ/KfJpsIFl0lx9Je8dNu3aJcnroCfGUMot1FAOcAwyP
         nK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=P2y+BRPoGQxcqMhj3bfHoCPdDwxzhdrBdUaNfcmh0tE=;
        b=4mssJghjS2lBgrK/cb7MK2dKLu6I+l4cmYUEmEKHw34UpLbX+Yv0YrY35nLtGFNZ7I
         ZYGHlPLRJVVbjB04Ws6dx1SZx7sSTO3nL6aG6tbU1KcUAO5YBGa3XfBfQurBSkjp4dW6
         3kapyAAeIomF3nSSvYZsPEaaNRUzVw2aJ6fkTGF1c+5EanaBMvOR9pGUnBKKhIzx1fAU
         RBEMV4NWOCWu6/kcOD3VP4tv69bVeRKgRB8DYBDbMDEYgzwHXG8qpcA4K5s6yQ72KrT4
         g0xkykEixQBJ85cFEzcdATJ59GhKw/uwj3duvFHGwbsBCsUW0Eq7VFILTtAworI7oAAd
         nTEw==
X-Gm-Message-State: ACgBeo0Kn1uwdCyGZDqlMuCEHefyElC0HufRadq+vbhczpW9pLSSq/IZ
        trmx4s2i316Xq5WAUG9G8nA=
X-Google-Smtp-Source: AA6agR4wkKXd44PtzA2Fo4ApkSYqzqk7KHyAZDGJtqQROW6vcymT6U6Dzu0AdoOFp0/dTQoHV98OKQ==
X-Received: by 2002:a17:903:22cd:b0:176:ca53:3e82 with SMTP id y13-20020a17090322cd00b00176ca533e82mr4672673plg.59.1662565413004;
        Wed, 07 Sep 2022 08:43:33 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id e6-20020a170902784600b00172bf229dfdsm12515263pln.97.2022.09.07.08.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:43:32 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 7 Sep 2022 05:43:31 -1000
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
Message-ID: <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902023003.47124-1-laoar.shao@gmail.com>
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

On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
...
> This patchset tries to resolve the above two issues by introducing a
> selectable memcg to limit the bpf memory. Currently we only allow to
> select its ancestor to avoid breaking the memcg hierarchy further. 
> Possible use cases of the selectable memcg as follows,

As discussed in the following thread, there are clear downsides to an
interface which requires the users to specify the cgroups directly.

 https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org

So, I don't really think this is an interface we wanna go for. I was hoping
to hear more from memcg folks in the above thread. Maybe ping them in that
thread and continue there?

Thanks.

-- 
tejun
