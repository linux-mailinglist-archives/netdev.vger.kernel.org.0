Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC1F5A0726
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiHYCJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHYCJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:09:29 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E901177EA7;
        Wed, 24 Aug 2022 19:09:26 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id v14so304724ejf.9;
        Wed, 24 Aug 2022 19:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=00m4IEZE5ymczAS2BUKtiJ+vi+Xy5c2+SWdERk9o0Uk=;
        b=XUIvvDE9rb07vRHUIuRXdPojnd2u+LRkrd7NUXqdJbASQ4pc6DJzy1xL27y/fUIJUu
         DFYkYSy6vJBh0vjTngR/JYHMFgUYkz5ovrKbIfQ8ti/UNB5X0bAuLknVM3I8dqTySI8v
         aNC6NnXT/bwq7HVDnRjWcviT4NyxzbZ5SyY+msV1T/13fvAiJ/4o5WPyIoHrVBf2AzT+
         VUj1v3TLgjGH9VKySxCO5hYoVGQ1RgGzPDgWUzMh7irERe68LMD3qrFdvxKsjOfCAyzp
         YYjSL2ZzkeY/7L/XxhzTJEopLxiUfMRZNunwMvNXZ/v63LwTj8PXPJm/1aESeSwdrVHp
         LJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=00m4IEZE5ymczAS2BUKtiJ+vi+Xy5c2+SWdERk9o0Uk=;
        b=bcVRjaqaOeR196JXGOrH6ZALBNRi/TIzpIWrTDh3s3CqUqkttpgz2JXRrZaoqdpVLf
         eF9mPvvixrq8wIB2L0wEzXOxOwIRga3yKZVzQ77SBUXiAalIIlSdrBla/9Hqn06tYjVT
         oNkQcmmqm/+glqPghQy7ihva8L8e5gr/Qc8OqbS5vrmfrcDkNQL0qSyg1002alpetivl
         AoWnhFPNpCWB1WFC3dQTi6UxW5kkSFOMYZgb2P74Qigg6uPhwfTQ1lyPVO6Vfm8yHrkf
         XwdGBLHmeFii5hBJLzGV0BBUeozFa//uy2wSYjJ8dat6h0ZvMtMoWh/hNIdwMTSr1T11
         28iw==
X-Gm-Message-State: ACgBeo3NowmSEiPOL2qm7jr0kNt6QVpuX42o8T4AtVRgY4pqGjJ9UJ11
        WKO6u0Vk/FLtFJ3VZfRVpy4U/toSq1FEpyR09qo=
X-Google-Smtp-Source: AA6agR5xH7PowIkM6L2EPJHlcPwZQ+/IQSpb5qiBAaqANQh5nn5ml1VAKGhwbX4ol5FQeupFXspuRSe02UTSkDWsL20=
X-Received: by 2002:a17:906:3a15:b0:73d:80bf:542c with SMTP id
 z21-20020a1709063a1500b0073d80bf542cmr972895eje.633.1661393365478; Wed, 24
 Aug 2022 19:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220824233117.1312810-1-haoluo@google.com> <20220824233117.1312810-6-haoluo@google.com>
In-Reply-To: <20220824233117.1312810-6-haoluo@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 24 Aug 2022 19:09:14 -0700
Message-ID: <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com>
Subject: Re: [RESEND PATCH bpf-next v9 5/5] selftests/bpf: add a selftest for
 cgroup hierarchical stats collection
To:     Hao Luo <haoluo@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
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

On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
> +
> +       for (i = 0; i < N_CGROUPS; i++) {
> +               fd = create_and_get_cgroup(cgroups[i].path);
> +               if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> +                       return fd;
> +
> +               cgroups[i].fd = fd;
> +               cgroups[i].id = get_cgroup_id(cgroups[i].path);
> +
> +               /*
> +                * Enable memcg controller for the entire hierarchy.
> +                * Note that stats are collected for all cgroups in a hierarchy
> +                * with memcg enabled anyway, but are only exposed for cgroups
> +                * that have memcg enabled.
> +                */
> +               if (i < N_NON_LEAF_CGROUPS) {
> +                       err = enable_controllers(cgroups[i].path, "memory");
> +                       if (!ASSERT_OK(err, "enable_controllers"))
> +                               return err;
> +               }
> +       }

It passes BPF CI, but fails in my setup with:

# ./test_progs -t cgroup_hier -vv
bpf_testmod.ko is already unloaded.
Loading bpf_testmod.ko...
Successfully loaded bpf_testmod.ko.
setup_bpffs:PASS:mount 0 nsec
setup_cgroups:PASS:setup_cgroup_environment 0 nsec
setup_cgroups:PASS:get_root_cgroup 0 nsec
setup_cgroups:PASS:create_and_get_cgroup 0 nsec
(cgroup_helpers.c:92: errno: No such file or directory) Enabling
controller memory:
/mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control
setup_cgroups:FAIL:enable_controllers unexpected error: 1 (errno 2)
cleanup_bpffs:FAIL:rmdir /sys/fs/bpf/vmscan/ unexpected error: -1 (errno 2)
#36      cgroup_hierarchical_stats:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

How do I debug it?
