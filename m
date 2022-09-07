Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40825B09EC
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiIGQSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIGQSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:18:12 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93424A0617;
        Wed,  7 Sep 2022 09:18:11 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id j12so2687581pfi.11;
        Wed, 07 Sep 2022 09:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=uhG7u+w7VyCcpyqgRvdj5juA1UtJgIUngIaiJnQjnlg=;
        b=fLpa63LacDyjcE/vOT2FJdnhbj72Sx8714QLP6Qn/d9p6+I87lcQWgOvbCBbSsukSH
         mH12lh3sQ1gujRjvOcEfh94G9ku2t9m8Mb9vOyK6pPhM1vwODGEcCESbxd6uCu0W7HFn
         7tHmH+luQvssLOTPgS2yHi/9wDhCFwGJUBcQpk29GxG7/GSThV5wNh+85ZC15/l1Oh3U
         cUg0t+i5EIyHSimnTaevPPoNAic7cxVG723kdP19q3TQOf0ZSa8twTUsQaAsYk2euSoO
         NLkrw9UCDqG5UlJL/R5d6PRHXT5URnD5nC3OgOwKhBDQLw4Na20v+/qa3fSpRYjCreS3
         u/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=uhG7u+w7VyCcpyqgRvdj5juA1UtJgIUngIaiJnQjnlg=;
        b=nKx8r1urFGbRincTVEnJrDMiOPFyDz/SfhU1YtG+67PqYQlMzCknlnLAd5yklJJYJO
         EM2W2LV7Czt4KQbB/DqcN8kNGvKuGIV/a61IDgzLwdgg40warb6pIYO1DwsB/bVSWI9P
         GB818t+EmdMfHvk6uVGAx4TwyjH8vDfOP6QcpEQOBW/jEeNTx433V8k1JSH9+e2VMYOQ
         PFdI3fWlm6jd7XwY7lhoiBWE/+sG0hMtOZxoiOprtYhflLSosG1mPUy4gAVrTBZjoPb4
         A9vSjML0QT0fnb6pksy+Hok0Yr5EltX6fiWrgtgWMLhVyuIa3SF4srpdRsL6kdYWySrP
         UEPw==
X-Gm-Message-State: ACgBeo2vprzBnTpomJ0QLur/DhXZ8kMToKICj2Mde4x4tNxE3c2UTjNw
        Q25QevZ+b0VdyUt8FwYJnnA=
X-Google-Smtp-Source: AA6agR6wNx9LxOCETAzDYG1oTNWybOA4XXGzQe/Kn3DjNxx2RlymyCZXDh5ou60S2sruh1qtJIzZPA==
X-Received: by 2002:a63:b4b:0:b0:433:5e5b:a540 with SMTP id a11-20020a630b4b000000b004335e5ba540mr4073972pgl.271.1662567490747;
        Wed, 07 Sep 2022 09:18:10 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902b18900b00174f62a14e5sm12572006plr.153.2022.09.07.09.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 09:18:10 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 7 Sep 2022 06:18:09 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for
 bpf map
Message-ID: <YxjEQabWR/BQOzk5@slm.duckdns.org>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
 <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
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

On Wed, Sep 07, 2022 at 09:13:09AM -0700, Alexei Starovoitov wrote:
> Hmm. We discussed this option already. We definitely don't want
> to introduce an uapi knob that will allow anyone to skip memcg
> accounting today and in the future.

cgroup.memory boot parameter is how memcg provides last-resort workarounds
for this sort of problems / regressions while they're being addressed. It's
not a dynamically changeable or programmable thing. Just a boot time
opt-out. That said, if you don't want it, you don't want it.

Thanks.

-- 
tejun
