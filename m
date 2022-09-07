Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477DB5B0A0B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiIGQ1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiIGQ1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:27:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3827C7B7BD;
        Wed,  7 Sep 2022 09:27:22 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id fy31so31602236ejc.6;
        Wed, 07 Sep 2022 09:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5llhNQoegHj47RA4ocj63iybZ451JyQ+C+VFCYoxmlQ=;
        b=IeXT1QKppmnZoHt2LbDbXSy8xbcm3n9VzJqMPtMKc+TFLR2+DRP0dEbDiVAsN7IcYa
         YkagG5Fw/dxRBrVDxjJ8i8YT4/4+c6V43KhUcqXNevP/tXDtTjolvg4DlSSGb6Kq3Nwz
         M+xOqRxAuwQN8rdV9JsWYTG25BTllbeo6k1yK9SMFn3OH8QyVhe02ZsHtrJmPP4vBkq3
         NbHYHvcxAlCTxbwWULmYGBShUQ4M1f1It+ZvIMAI/jm9AD7mAWYmuZO/RBlnjvQryq8+
         XkUnD3DMTVq+Cv1tg+CUTauYxDODzImQXAgYDGgtH9U2SFkqspam2BYOsLNFuFOHH+Xw
         xOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5llhNQoegHj47RA4ocj63iybZ451JyQ+C+VFCYoxmlQ=;
        b=vTSRgTyVBWSSerYC16QxEueU9h7Ke1Iwh00QgwaUV/TFNhFg4OqcN1A1c2dL+at4dn
         1ndOg5SU9XIM+GpL64rB+Fyebs0SeJeuvl1J2vp4DIx9mUCOQKsJ7r0KgBzUYLevsl5d
         rdnt07RpTHIw+lcEATQwzkvdR59Z7AEUV9FbmRAZZSBgQ1BNhFZWAgQ54uBNpwemfzXk
         GO1Yjn4W9QHV0Wno0YjVFQHXj60WzXnICSzEW2x+hY3qpjK0dKhcelHN95W9d6VzmhYz
         LYhEwt3J6PSaA6YoFC7wE1MFu192G4kDETj49/Y6T1qwzBbOWfcrU2L/XZAL1hUSqetp
         spGw==
X-Gm-Message-State: ACgBeo2VsBwn6wwTHdX9xp4/rb2zPXgcrUoWSiGUocmQxDtIGIbYGphD
        gi6ah4ElKns2cZTZ1PE/Jno5w9fvx3N3b3zhneY=
X-Google-Smtp-Source: AA6agR4MeMIGmYaaAHF3RpiWA0wTnsNxF62gU+hfhVf0aJkPhDwXPZ+gSnmumGKEhbHf0mj+kmLkG+QKCPEFD6lT/4A=
X-Received: by 2002:a17:906:dc93:b0:742:133b:42c3 with SMTP id
 cs19-20020a170906dc9300b00742133b42c3mr3016190ejc.502.1662568040459; Wed, 07
 Sep 2022 09:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org> <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
 <YxjEQabWR/BQOzk5@slm.duckdns.org>
In-Reply-To: <YxjEQabWR/BQOzk5@slm.duckdns.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Sep 2022 09:27:09 -0700
Message-ID: <CAADnVQLe4oGE8vrAMoJZ+xAT3BefyOv3EhwY3QVGBQn5x25DkQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
To:     Tejun Heo <tj@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 7, 2022 at 9:18 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Sep 07, 2022 at 09:13:09AM -0700, Alexei Starovoitov wrote:
> > Hmm. We discussed this option already. We definitely don't want
> > to introduce an uapi knob that will allow anyone to skip memcg
> > accounting today and in the future.
>
> cgroup.memory boot parameter is how memcg provides last-resort workarounds
> for this sort of problems / regressions while they're being addressed. It's
> not a dynamically changeable or programmable thing. Just a boot time
> opt-out. That said, if you don't want it, you don't want it.

ahh. boot param.
Are you suggesting a global off switch ? Like nosocket and nokmem.
That would be a different story.
Need to think more about it. It could be ok.
