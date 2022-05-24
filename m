Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B2F532002
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 02:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiEXAxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 20:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiEXAxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 20:53:14 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C35184A10
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 17:53:13 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id v6so10774354qtx.12
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 17:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x4jbl/h/9IkQPtvCa68VGCFyvxT/KOdRev2otsqHtfM=;
        b=CLD8VfehPsBJZKAJX5SPjbU2o9Q0pXOcAnEDp/JCvbkisTN6aYTXXFyQR9tQD56GBx
         aRURvpzT0qMlj0TBitxFWqDDvCT7U90MMnkPOH7LbK07zbOfHREkSn8Li4gc75TrIKyc
         4uuiItRFMVlt6QQAOggQDGe1AiKerD3SvjRiu1ENyYtAh/rfWdUH/ZJsQT2ThcD8PAv6
         MpBn3JnnKsqLEd+RT++NjvLR95c5HM9CWQ14xRsasQpZu9B/Kr/L3k4fd7DFsj3y950S
         k2CC+P/CT3/lw9ZSnEFMFi9WjEGj+g0wqyyOnP98XBItvA/gQpr2iamhbFL0JA0bVPw5
         pL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x4jbl/h/9IkQPtvCa68VGCFyvxT/KOdRev2otsqHtfM=;
        b=E1tXtUr7WyOZYHj1WN9YoCW0uyFT51j/5TTigx4SdvOsWwANpnjzuIgpTocUOfLDsP
         qt1HaeKjIdzai+kS4Hkm8Mfw8eymoxLR9h1XBVrLnewdFlZXFYPMOOu3dAu+h1yRxlbk
         VFpEdmTHsGT22W6QhP5Jl0zbLbY25pg4aBjNTU3e3DU5e6ifi19ITEya4xnsAxQbKFN2
         vbPC0BjQ14uZJHv0LdHzSJ8FEH7ZEP+BgKvUxeT30pnFLEzvs+HRuzid+JKaTwPNYHff
         6Lb2KuLX+W9z6+d+tYsdWmyvqX4BMbb8pLMaPFXm3fWbg2UvciAYOAr2/WxhvjgJI9EV
         g2QA==
X-Gm-Message-State: AOAM531QE0IcZ4/hhIKux1PXF+1i+0uSgihkesDsbgnnpsoUFS0dhokc
        YfvgF+gVQ2UyPojsgBb8Xu+oMW6AsRkvfa2ptqwLbg==
X-Google-Smtp-Source: ABdhPJyGEys6JfQRUYrN7pDaX/KGucRDwfhBe/O+mHLPshN0j3kd0anhBzJgJBbI6ZnFCsm3UfNhDzfmz09/ZuJ3224=
X-Received: by 2002:ac8:7d86:0:b0:2f3:c523:19a2 with SMTP id
 c6-20020ac87d86000000b002f3c52319a2mr18366810qtd.566.1653353592069; Mon, 23
 May 2022 17:53:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org> <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
 <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
 <Yogc0Kb5ZVDaQ0oU@slm.duckdns.org> <5b301151-0a65-df43-3a3a-6d57e10cfc2d@fb.com>
 <CA+khW7gGrwTrDsfWp7wj=QaCg01FNj381a1QLs1ThsjAkW85eQ@mail.gmail.com> <CAEf4BzbaHeyaHK1sChPMF=L4aQsaBGNtU+R3veqCOFz0A+svEA@mail.gmail.com>
In-Reply-To: <CAEf4BzbaHeyaHK1sChPMF=L4aQsaBGNtU+R3veqCOFz0A+svEA@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 23 May 2022 17:53:00 -0700
Message-ID: <CA+khW7h-fgo+X=OUxAWDe2sPMyWDXUmp574Kq_J884j9whoBfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 4:58 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, May 20, 2022 at 7:35 PM Hao Luo <haoluo@google.com> wrote:
> >
> > On Fri, May 20, 2022 at 5:59 PM Yonghong Song <yhs@fb.com> wrote:
> > > On 5/20/22 3:57 PM, Tejun Heo wrote:
> > > > Hello,
> > > >
> > > > On Fri, May 20, 2022 at 03:19:19PM -0700, Alexei Starovoitov wrote:
> > > >> We have bpf_map iterator that walks all bpf maps.
> > > >> When map iterator is parametrized with map_fd the iterator walks
> > > >> all elements of that map.
> > > >> cgroup iterator should have similar semantics.
> > > >> When non-parameterized it will walk all cgroups and their descendent
> > > >> depth first way. I believe that's what Yonghong is proposing.
> > > >> When parametrized it will start from that particular cgroup and
> > > >> walk all descendant of that cgroup only.
> > > >> The bpf prog can stop the iteration right away with ret 1.
> > > >> Maybe we can add two parameters. One -> cgroup_fd to use and another ->
> > > >> the order of iteration css_for_each_descendant_pre vs _post.
> > > >> wdyt?
> > > >
> > > > Sounds perfectly reasonable to me.
> > >
> > > This works for me too. Thanks!
> > >
> >
> > This sounds good to me. Thanks. Let's try to do it in the next iteration.
>
> Can we, in addition to descendant_pre and descendant_post walk
> algorithms also add the one that does ascendants walk (i.e., start
> from specified cgroup and walk up to the root cgroup)? I don't have
> specific example, but it seems natural to include it for "cgroup
> iterator" in general. Hopefully it won't add much code to the
> implementation.

Yep. Sounds reasonable and doable. It's just adding a flag to specify
traversal order, like:

{
  WALK_DESCENDANT_PRE,
  WALK_DESCENDANT_POST,
  WALK_PARENT_UP,
};

In bpf_iter's seq_next(), change the algorithm to yield the parent of
the current cgroup.
