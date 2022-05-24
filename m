Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2B532046
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 03:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiEXBae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 21:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiEXBac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 21:30:32 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA106FD01;
        Mon, 23 May 2022 18:30:31 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id a10so17026542ioe.9;
        Mon, 23 May 2022 18:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WWmcSlMLXyPAtUCAvd6HT22Q24cwWlGO+SKtL9DeqKU=;
        b=g2y1NFt4Sseyx742KMl6xBdUityeBuD37EEwViwqBrkw+a2f6FepgoHeNqAcHs4pnS
         0d1Nacm02K76ckrC3k60Cc4C8TIqbozizgZCpdm9jM366ElB583C3x0+qMEiKbQa79DU
         YHDMuqpINrn+W61mvf7NC/5707+lHWwF+Tx1zT+xJQt83X08GyKfcGSLHmDD3wcDUyir
         po18oBXtV7uTSIYeNHC59VElipZiBC9rlK0g45oJrdVu0oHLfbAF5/b+3h665gFYveW/
         UjseAlbhaDpLGIt8CVLkZtoWQnBcZcOnoemVbm/5tZaLqXOTTdnmZXZGuhjPdA4Nr1ff
         j5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WWmcSlMLXyPAtUCAvd6HT22Q24cwWlGO+SKtL9DeqKU=;
        b=ANCSUm8y4iPMs/k1ZgOeYd9zz5DtxYtFR11Ky0uYDfp6lOT9DPn63VA4o+Fos2UsKZ
         x8thq+MWlYGvKMQh+E9ZKYoJU0m+r0vAywNdDlmCW1n4QlVMi6T1JQ3sZfBd/vPJaZ4A
         JRTT4F0RM52fkMhSIHmThfswutA1OoF/N/yG/yjHkzKGOqe+ooZIGE5YL9ql6BdJ65G3
         nIHzzeaRmUg8L7Sp9OGGWsCbzChBklpu2WFLYXfqxem7pZBCbXbDd8pOXRXQyGYmMpyh
         7rRUQKPHeTgnP4Bb+Ltcduw83ynwpByJBuOANJ1LbhP0sFF9iMGedFmr8dwCBiVDJYYp
         zkTQ==
X-Gm-Message-State: AOAM5327Qs8gNlxvjDEtZ++tX+3qPGxVtCMwPJF+nZul+dfLxFZqwAlx
        13UQGZcrFppArHfmhXDqwPHSuwA0QS7aSZJFXlA=
X-Google-Smtp-Source: ABdhPJwJ0HxGpuHzjlxDM9gFmOF4eLOzadWHpqw1yyOV7Hg8tQXEiwNz+geTsT3zy8fXNVnYebhfAjqXReaLuaUp2N8=
X-Received: by 2002:a05:6638:2393:b0:32e:319d:c7cc with SMTP id
 q19-20020a056638239300b0032e319dc7ccmr12749526jat.103.1653355831019; Mon, 23
 May 2022 18:30:31 -0700 (PDT)
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
 <CAEf4BzbaHeyaHK1sChPMF=L4aQsaBGNtU+R3veqCOFz0A+svEA@mail.gmail.com> <CA+khW7h-fgo+X=OUxAWDe2sPMyWDXUmp574Kq_J884j9whoBfw@mail.gmail.com>
In-Reply-To: <CA+khW7h-fgo+X=OUxAWDe2sPMyWDXUmp574Kq_J884j9whoBfw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 18:30:20 -0700
Message-ID: <CAEf4BzZOE0zXnRs3rEiO4+KZix7Druu5TqkJH+xX01tgMfQOtQ@mail.gmail.com>
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

On Mon, May 23, 2022 at 5:53 PM Hao Luo <haoluo@google.com> wrote:
>
> On Mon, May 23, 2022 at 4:58 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, May 20, 2022 at 7:35 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > On Fri, May 20, 2022 at 5:59 PM Yonghong Song <yhs@fb.com> wrote:
> > > > On 5/20/22 3:57 PM, Tejun Heo wrote:
> > > > > Hello,
> > > > >
> > > > > On Fri, May 20, 2022 at 03:19:19PM -0700, Alexei Starovoitov wrote:
> > > > >> We have bpf_map iterator that walks all bpf maps.
> > > > >> When map iterator is parametrized with map_fd the iterator walks
> > > > >> all elements of that map.
> > > > >> cgroup iterator should have similar semantics.
> > > > >> When non-parameterized it will walk all cgroups and their descendent
> > > > >> depth first way. I believe that's what Yonghong is proposing.
> > > > >> When parametrized it will start from that particular cgroup and
> > > > >> walk all descendant of that cgroup only.
> > > > >> The bpf prog can stop the iteration right away with ret 1.
> > > > >> Maybe we can add two parameters. One -> cgroup_fd to use and another ->
> > > > >> the order of iteration css_for_each_descendant_pre vs _post.
> > > > >> wdyt?
> > > > >
> > > > > Sounds perfectly reasonable to me.
> > > >
> > > > This works for me too. Thanks!
> > > >
> > >
> > > This sounds good to me. Thanks. Let's try to do it in the next iteration.
> >
> > Can we, in addition to descendant_pre and descendant_post walk
> > algorithms also add the one that does ascendants walk (i.e., start
> > from specified cgroup and walk up to the root cgroup)? I don't have
> > specific example, but it seems natural to include it for "cgroup
> > iterator" in general. Hopefully it won't add much code to the
> > implementation.
>
> Yep. Sounds reasonable and doable. It's just adding a flag to specify
> traversal order, like:
>
> {
>   WALK_DESCENDANT_PRE,
>   WALK_DESCENDANT_POST,
>   WALK_PARENT_UP,

Probably something more like BPF_CG_WALK_DESCENDANT_PRE and so on?

> };
>
> In bpf_iter's seq_next(), change the algorithm to yield the parent of
> the current cgroup.
