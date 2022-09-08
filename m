Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8060B5B129F
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 04:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiIHCpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 22:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiIHCo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 22:44:58 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3386A26567;
        Wed,  7 Sep 2022 19:44:56 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c10so8771350ljj.2;
        Wed, 07 Sep 2022 19:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=2pHEsap3RFdinHeELihIMRhGO2rHiXvCucqCEo2lx64=;
        b=HerJ8zNIlx4KHJmo5rkripn6dc0/uLP0bHlCb3Ir6cVFH2m4xHRDlcFANr9WVi00R9
         6sJRUd0ROsz/B/WSxkeZRjGIOA0+IWKXv0AaopO3oXVpMylWb92xH5Zi/ylwhUAX2aU1
         +QWG4XSp3f4CMhHjeK7NTMO2hhUPkkgJRlED8qh40XzSnOQBzhSZyU2Rivt4Djs/bDdV
         snK5PCrW2MLxj4H4ARaumC9esLTEeZoAF4eMMgVENnqOaXNULsFmjrUJN+P3BuUyWJzr
         OuXKoUOpXIAZjZqhSlAnD0YZDCO3M7rz2i7xybd/WXS3EceSfNGZzLZ3Ako9A4AFYU7U
         Vlvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=2pHEsap3RFdinHeELihIMRhGO2rHiXvCucqCEo2lx64=;
        b=DVwbOc9v1BiLo2gr8gXJuk1S2hr77s7ucP+vK1uyBKCMZY7+NNy9HmXgc+FrWur8AH
         TLvYomobAFiNk2wyVuSOI0qYmzjF3fgyGPE+ZywYVBTqhFQ7iHpvmgclXMw/65+ruzTM
         oMMyhAzd9K8mPhIh/qvLtz1OCKg8yEAT87w30roH9gU/onoEdERnVZGEsjJO4mSVu4Fv
         IhdN4oUgl/CdnfJJjb6Ugx3mH8MYLwEIr1okAiE+LIq+WegAEAOhzV6dAys0GqheBqwH
         w75r5s7LFU510ndN2DKMEF66gnXUWT87qto3PDAGYC9UxKonHktDks7Mrj3VsKTTKGZE
         ivgQ==
X-Gm-Message-State: ACgBeo0OJgh/Xd34JAVxMFhB9dyjwtLVQqt0+rLlooxeoSa/AS4cnvud
        ECiDh67GqVZNEU3xO2F1lgNLPthuDFiuyljGuuk=
X-Google-Smtp-Source: AA6agR73GsfTr+BVMr92nDb6WrcflbCFjXbxmVQTeONe5M+FnMlrdJlCBIlDqK/OBASRxJHykPZY3DdxLL4K2o9GjY4=
X-Received: by 2002:a2e:9681:0:b0:261:c515:2b13 with SMTP id
 q1-20020a2e9681000000b00261c5152b13mr1837959lji.210.1662605095177; Wed, 07
 Sep 2022 19:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org> <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
 <YxjEQabWR/BQOzk5@slm.duckdns.org> <CAADnVQLe4oGE8vrAMoJZ+xAT3BefyOv3EhwY3QVGBQn5x25DkQ@mail.gmail.com>
 <YxjOawzlgE458ezL@slm.duckdns.org>
In-Reply-To: <YxjOawzlgE458ezL@slm.duckdns.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 8 Sep 2022 10:44:18 +0800
Message-ID: <CALOAHbBEtehfx1NhXKAoqTS+3ZzX4niWV-aWT5joqDhXOO_G1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
To:     Tejun Heo <tj@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

On Thu, Sep 8, 2022 at 1:01 AM Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Sep 07, 2022 at 09:27:09AM -0700, Alexei Starovoitov wrote:
> > On Wed, Sep 7, 2022 at 9:18 AM Tejun Heo <tj@kernel.org> wrote:
> > >
> > > Hello,
> > >
> > > On Wed, Sep 07, 2022 at 09:13:09AM -0700, Alexei Starovoitov wrote:
> > > > Hmm. We discussed this option already. We definitely don't want
> > > > to introduce an uapi knob that will allow anyone to skip memcg
> > > > accounting today and in the future.
> > >
> > > cgroup.memory boot parameter is how memcg provides last-resort workarounds
> > > for this sort of problems / regressions while they're being addressed. It's
> > > not a dynamically changeable or programmable thing. Just a boot time
> > > opt-out. That said, if you don't want it, you don't want it.
> >
> > ahh. boot param.
> > Are you suggesting a global off switch ? Like nosocket and nokmem.
> > That would be a different story.
> > Need to think more about it. It could be ok.
>
> Yeah, nobpf or sth like that. An equivalent cgroup.memory parameter.
>

It may be a useful feature for some cases, but it can't help container users.
The memcg works well to limit the non-pinned bpf-map, that's the
reason why we, a container user, switch to memcg-based bpf charging.
Our goal is to make it also work for pinned bpf-map.

That said,  your proposal may be a useful feature,  but it should be
another different patchset.

-- 
Regards
Yafang
