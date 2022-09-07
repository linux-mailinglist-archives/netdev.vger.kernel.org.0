Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659DE5B0AE7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIGRBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIGRBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:01:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C35FAD998;
        Wed,  7 Sep 2022 10:01:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so18944151pja.4;
        Wed, 07 Sep 2022 10:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=TqbLb+KgxPbnQGfynSMlarvTL8mplWrZYa3AXE4SSEA=;
        b=M0aSp3XVpFQ7bWIdvytb5uhz2wbLWyKSJsDmE9iidJ8FRw/dGS/Z3jvvkleFpXTenY
         QvgPAhYJNZLM593j1hyz554JcYK8lZ17U3nLGgfYdjLbBQ9qrvhmKVafghSFKOweQsDt
         49OmiKoUXdb3cmQeHkvJODY4gw4stBvrtAKYgAcbjSZQqbBBEg3vrUP+5nqp+OAAsjUB
         1Op9sgJ3u9W1LoKbhiLq2DFuc2BbWHEHEaWGHqZ6uBfV7XfBwtUlKt7iTyXLlYJh6nmM
         tRBVFjN8unCaFVD691+iDdrGPoPjsqPsGx0qb0NHCgUXsy5Kb3jqfIaZkSNQjtbTpZ2h
         vPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TqbLb+KgxPbnQGfynSMlarvTL8mplWrZYa3AXE4SSEA=;
        b=iSyS21ESlm2QaQNNzLBqWgNWTRIwrq05npo6udclExtiUXYqXLo13g+68G+LlZAOyF
         S+n9Po1Cm3AUMTLLg+n28AMOO9/AIYuO058d+8urNzRnfSYsUcoEGFip9ZNB7s368CMM
         QFXFEywUbnIp0ZjgksaxySnf+VITIkyyBfCOUvl7Je+piOi0TDVkkzYkuZzsPTDlniuV
         nRbo8CJyVPWwqugGYeJ0BkN4bpxeZL0K1UrYx+Q0hb4tsYRti87i4tT+pzNB1iX9cEe/
         mEbv6vweQ5DXggNoPvM54hOj3OT/pFT+hqTUotFHIlYeZyiQpKKHEhuPAntIRhtZvUXP
         6Hug==
X-Gm-Message-State: ACgBeo20MZ9h6ir7xrjI7D3s6yxnYj3atXPUZPcwBF5B5nbgcfB4sQtf
        o9KbWnDqQHVyqfS9NErIZDI=
X-Google-Smtp-Source: AA6agR5XuW96crLv372qzBHFxbIiWvRWgr6yOvfA1vq/ggrJyf5TJOCYQNT8b+wBNPtAq3IvAjOTpw==
X-Received: by 2002:a17:90b:1c8e:b0:1f7:524f:bfcc with SMTP id oo14-20020a17090b1c8e00b001f7524fbfccmr5080854pjb.132.1662570093582;
        Wed, 07 Sep 2022 10:01:33 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id e10-20020a17090301ca00b0016dbdf7b97bsm12654950plh.266.2022.09.07.10.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 10:01:33 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 7 Sep 2022 07:01:31 -1000
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
Message-ID: <YxjOawzlgE458ezL@slm.duckdns.org>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
 <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
 <YxjEQabWR/BQOzk5@slm.duckdns.org>
 <CAADnVQLe4oGE8vrAMoJZ+xAT3BefyOv3EhwY3QVGBQn5x25DkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLe4oGE8vrAMoJZ+xAT3BefyOv3EhwY3QVGBQn5x25DkQ@mail.gmail.com>
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

On Wed, Sep 07, 2022 at 09:27:09AM -0700, Alexei Starovoitov wrote:
> On Wed, Sep 7, 2022 at 9:18 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > Hello,
> >
> > On Wed, Sep 07, 2022 at 09:13:09AM -0700, Alexei Starovoitov wrote:
> > > Hmm. We discussed this option already. We definitely don't want
> > > to introduce an uapi knob that will allow anyone to skip memcg
> > > accounting today and in the future.
> >
> > cgroup.memory boot parameter is how memcg provides last-resort workarounds
> > for this sort of problems / regressions while they're being addressed. It's
> > not a dynamically changeable or programmable thing. Just a boot time
> > opt-out. That said, if you don't want it, you don't want it.
> 
> ahh. boot param.
> Are you suggesting a global off switch ? Like nosocket and nokmem.
> That would be a different story.
> Need to think more about it. It could be ok.

Yeah, nobpf or sth like that. An equivalent cgroup.memory parameter.

Thanks.

-- 
tejun
