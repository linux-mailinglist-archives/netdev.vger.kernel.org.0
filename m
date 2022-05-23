Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA5E531F7D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiEWX6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiEWX6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:58:34 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7E15641F;
        Mon, 23 May 2022 16:58:33 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id m2so16646917vsr.8;
        Mon, 23 May 2022 16:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2mIELVIK9I45bOrNaHoPQeyzkFn9jybEus0u38+96s=;
        b=VnHsSTwMUvjWYssSawwJ5pEcHjByONf8kYvt/w+HAsB3Hf7IGHDWS7Y6jAhIIJxgVO
         uoGHf8AFlhnmaVzAx0LDqsXEYOMIdGPPaWZdOMXF2ti7VVCbzwWoI2o+2zpOlp7ZeH3J
         MG1TDy/haiNsWsXjjsgMr33/RadE8QOFl81bmI+r2cxjuo9+SGSEhVv1HObsiUTkmyqb
         LI1Tbohh27CSgCiIQUxZpaBNMPAvQn0IJ6akPOEMssVnm8VnXOVQ8JTz2zkzPUhvWMN1
         g3mXFAPZy5hecxQph9G377xJS3izBXLE4OarMwRfQIzugPfNcTNsD/CykzREfCaaYKOp
         I/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M2mIELVIK9I45bOrNaHoPQeyzkFn9jybEus0u38+96s=;
        b=o1YKi7c58x61vPmQpSgBmj0qQOFWucIBgLfD7+3/X0pwjWiWS5a5lkW0OxsKMdsVJN
         06rphcSiuM4di/KkmTw3SZwX8KvXwMBiYORg3RHYB+OycIEUAEIwS6Prs8nwOkkXy2Ig
         SA0+Lv4VcadMr9dikRmSO/S8fgcP1W6aZq6JZOJYsBAqAkZcHOo8JyapCsaupXMlnm07
         fyeHqVgxSFF+760Mcm9YRZVzT2YOcdk+osTvPMWKWMzrxRi1WKILhfvX0Ax6JRvL501b
         lA1Wj6IfGHOHlCwq2K8aDip0YRPIy2Nx9KzcRW9z9QcIbZv8fA0z/KI5rcxiwaaM+ops
         TZCg==
X-Gm-Message-State: AOAM5330SZyB1aRLJlaCzE9I07HaEbKgEP8A9Ouulok9jhhlHciWd4tJ
        LYhos46Ra/RjBztKoXKGd5wkLsbscZ8T9HAQEQE=
X-Google-Smtp-Source: ABdhPJxwCKmMnH4OgSMhAdsGQBe98EmDee0JQhww6ofjmF/YXQkY8Da7LhFUWMNZKWyVcyCHLboQtG3BzyQK1MYjp9k=
X-Received: by 2002:a05:6102:4b6:b0:335:f244:2286 with SMTP id
 r22-20020a05610204b600b00335f2442286mr7796011vsa.54.1653350312371; Mon, 23
 May 2022 16:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org> <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
 <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
 <Yogc0Kb5ZVDaQ0oU@slm.duckdns.org> <5b301151-0a65-df43-3a3a-6d57e10cfc2d@fb.com>
 <CA+khW7gGrwTrDsfWp7wj=QaCg01FNj381a1QLs1ThsjAkW85eQ@mail.gmail.com>
In-Reply-To: <CA+khW7gGrwTrDsfWp7wj=QaCg01FNj381a1QLs1ThsjAkW85eQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 16:58:21 -0700
Message-ID: <CAEf4BzbaHeyaHK1sChPMF=L4aQsaBGNtU+R3veqCOFz0A+svEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
To:     Hao Luo <haoluo@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
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

On Fri, May 20, 2022 at 7:35 PM Hao Luo <haoluo@google.com> wrote:
>
> On Fri, May 20, 2022 at 5:59 PM Yonghong Song <yhs@fb.com> wrote:
> > On 5/20/22 3:57 PM, Tejun Heo wrote:
> > > Hello,
> > >
> > > On Fri, May 20, 2022 at 03:19:19PM -0700, Alexei Starovoitov wrote:
> > >> We have bpf_map iterator that walks all bpf maps.
> > >> When map iterator is parametrized with map_fd the iterator walks
> > >> all elements of that map.
> > >> cgroup iterator should have similar semantics.
> > >> When non-parameterized it will walk all cgroups and their descendent
> > >> depth first way. I believe that's what Yonghong is proposing.
> > >> When parametrized it will start from that particular cgroup and
> > >> walk all descendant of that cgroup only.
> > >> The bpf prog can stop the iteration right away with ret 1.
> > >> Maybe we can add two parameters. One -> cgroup_fd to use and another ->
> > >> the order of iteration css_for_each_descendant_pre vs _post.
> > >> wdyt?
> > >
> > > Sounds perfectly reasonable to me.
> >
> > This works for me too. Thanks!
> >
>
> This sounds good to me. Thanks. Let's try to do it in the next iteration.

Can we, in addition to descendant_pre and descendant_post walk
algorithms also add the one that does ascendants walk (i.e., start
from specified cgroup and walk up to the root cgroup)? I don't have
specific example, but it seems natural to include it for "cgroup
iterator" in general. Hopefully it won't add much code to the
implementation.
