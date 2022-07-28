Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645265844C7
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 19:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiG1RVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 13:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiG1RU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 13:20:59 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1C65D0E7
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 10:20:58 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id l3so1921123qkl.3
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 10:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VW7oYK4RqwqbJsASlxdjRV3NEVCTNvlDrSDTg61QkOg=;
        b=h8FxtRKKQHF4SZtxhuJuCSHn3CxIjnLxoANRs2Qd79XyLUdqOiqvCZ0nf/TljQOJoz
         7Uyovrfff5RQt4y3dHNonwXKvY7FZUnDtoRHS7lWjuK8E6idQMKrJMS4QFSzUEZF4m66
         TzgFuIxGVMtfqQ0hB1NxW5AKLb+TvhCtZrfm9cueT8LxtqQg9su+cN3ghlP+T2lVpLdI
         ORveshtJMkLA+6KRzWshwGMkPKwKHyh+tpsCEeMexuP4mlBxfIufMDal02TfyaOgJefJ
         /BB58eusHQOE/4dQDk/11j96eQxmE3KTRG8BmpQQQX33x3W6J0jhBI98b3UHF00rtHXj
         TKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VW7oYK4RqwqbJsASlxdjRV3NEVCTNvlDrSDTg61QkOg=;
        b=KZsDRWnjgifwqd9FZ73e4jkXKynzG8b0y2hTdupB0iJk1ktfnTwMUPmAS6lfE1zZEm
         wp7Rg9gLHhEkG54W7yRQYA/DJJ4w2RijmJ2+ajwH9gHS594mMmCtdxna+8rn4wq/Sn7F
         v+K1hgUPE6tKhr5yHzkqWyVg7PRTY8MwW+DFwFsCqbYUqCgle9bglxA3deZCjyqYW5pF
         vSWaWEcc9oWlfXTwR00xppyfPugjESP5Pi+kC0rA2+u/uNDyDrkeujHYv6Ls7tzvJVzS
         xWZgLHPRF0SyGWbOKOeHOwH5IXW56c4FP8akJlr8stbz0EfYR+thWOvVzBznWu3dhKhI
         X23w==
X-Gm-Message-State: AJIora+/W/U5mNztqOqe2DavRFN+SfdbkS670HAevW2wOIjtGZbu/5Hz
        S231/IMDUfzKxd8v3w6eIWW1L9eS1RsEey0lQvii1A==
X-Google-Smtp-Source: AGRyM1s1cDTIG4cHfQoCogY/3yzoi+i9AVUwh2Yd9jME3eEKhA7/dLgzhN0YOvaQCdDe/Lein08hPIbFaXlJKlvCiXY=
X-Received: by 2002:a05:620a:4105:b0:6b6:116b:2265 with SMTP id
 j5-20020a05620a410500b006b6116b2265mr20807430qko.583.1659028857346; Thu, 28
 Jul 2022 10:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <YuK+eg3lgwJ2CJnJ@slm.duckdns.org>
In-Reply-To: <YuK+eg3lgwJ2CJnJ@slm.duckdns.org>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 28 Jul 2022 10:20:46 -0700
Message-ID: <CA+khW7gfzoeHVd5coTSWXuYVfqiVMwoSjXkWsP-CeVdmOm0FqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
To:     Tejun Heo <tj@kernel.org>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tejun,

On Thu, Jul 28, 2022 at 9:51 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, Jul 22, 2022 at 05:48:25PM +0000, Yosry Ahmed wrote:
> > +
> > +     /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> > +      * ancestors of a given cgroup.
> > +      */
> > +     struct {
> > +             /* Cgroup file descriptor. This is root of the subtree if walking
> > +              * descendants; it's the starting cgroup if walking the ancestors.
> > +              * If it is left 0, the traversal starts from the default cgroup v2
> > +              * root. For walking v1 hierarchy, one should always explicitly
> > +              * specify the cgroup_fd.
> > +              */
> > +             __u32   cgroup_fd;
>
> So, we're identifying the starting point with an fd.
>
> > +             __u32   traversal_order;
> > +     } cgroup;
> >  };
> >
> >  /* BPF syscall commands, see bpf(2) man-page for more details. */
> > @@ -6136,6 +6156,16 @@ struct bpf_link_info {
> >                                       __u32 map_id;
> >                               } map;
> >                       };
> > +                     union {
> > +                             struct {
> > +                                     __u64 cgroup_id;
> > +                                     __u32 traversal_order;
> > +                             } cgroup;
>
> but iterating the IDs. IDs are the better choice for cgroup2 as there's
> nothing specific to the calling program or the fds it has, but I guess this
> is because you want to use it for cgroup1, right? Oh well, that's okay I
> guess.
>

Yes, we are identifying the starting point with FD. The cgroup_id here
is the information reported from kernel to userspace for identifying
the cgroup.

We use FD because it is a convention in BPF. Compatibility of cgroup1
is a good feature of this convention. My thoughts: It seems that ID
may be better, for two reasons. First, because ID is stateless, the
userspace doesn't have to remember closing the FD. Second, using
different identifications in two directions (userspace specifies
cgroup using FD, while kernel reports cgroup using ID) introduces a
little complexity when connecting them together.

Hao

> Acked-by: Tejun Heo <tj@kernel.org>
>
> Thanks.
>
> --
> tejun
