Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27F65AF37F
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 20:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiIFSWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 14:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIFSWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 14:22:12 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C759925A;
        Tue,  6 Sep 2022 11:22:03 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kk26so25170922ejc.11;
        Tue, 06 Sep 2022 11:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PYs3Wuenq4cez94yZW8DSjj5pLfTjpJU6pDayqR/+9k=;
        b=PObnF9bQxkSs4fRurVZSSfRC5Xac9CJVZ7wh7zRfBoKnNdOWc4P7gB3qZpMaVSZvF2
         5H6xPT9EeiQ4b7T7rrJDHnmEvzPGckaKWmtqIc+glfZZqa43RP3xXZMlqP/Jlxm7MYcw
         e2i/ZqiU4MSv7eWCA2MN8xYaiZ32eK64DwbhpycZqHuhCE3ZW0S5BhOJrUFPPuO8B30p
         VUpFMo6kat6H3b3b0uHQXFi7nN9Gcj9IpXX1LIf7bTqw1NnECB0X5diBb79d89bi6UJ1
         0jyk9Q4vHJ0cnJSUbtFfbaPVqZl8/vY82CvFRrttXO92nleJsefEj1HqaSkGqkEyjJ1f
         STSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PYs3Wuenq4cez94yZW8DSjj5pLfTjpJU6pDayqR/+9k=;
        b=erVE95rato0Z6N6wMAq/WrrMO50iLw5XqpgxT/01tiZMvrb5Qnkf8fu0BkJsFpxzcd
         fDMWwLok5sBkT4lQ5W2SnTxeBFnaw/pPkEz7gqXxzbIDEayeBdQ+6FEs7LghI2GJgjJ6
         FCUYwSY/yD2PX45lURh8rkSr6n+gmiyzfVPqCy1GC/SVHOBAUc4IdUOW0+DonRJUkUsd
         Ms8y8/uuF8gLr3PjPUSc9ulCNK1vk714zgBAeCpXsDTtYiuK8Pmegn5Fq8pOptmIO90s
         4XPsbWLvMtV/s0OYgrEtoO602dD0gK0p6Fl8qF0XOe6cit3+uB25rCf31PbeydWI5vCO
         VmLg==
X-Gm-Message-State: ACgBeo20GjOfGRXv7ndJikfDEM4nMERkA3t9F3eZr89Sj/uta5CYae4b
        fsMPu5tZzJuW6GAQ2UuwbTK3b/92G68Dr3nsD0Q=
X-Google-Smtp-Source: AA6agR6beOOrUxBhub74AGhQvPZPMEDywmPNFrEJjj+BZwST5ShLLEz7vW6eHscxPnV3KYB7ieusRN1vrigexE4PGR0=
X-Received: by 2002:a17:907:7b94:b0:731:1b11:c241 with SMTP id
 ne20-20020a1709077b9400b007311b11c241mr41341466ejc.676.1662488521325; Tue, 06
 Sep 2022 11:22:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com> <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
In-Reply-To: <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Sep 2022 11:21:50 -0700
Message-ID: <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
Subject: Re: [PATCH 1/7] bpf: Add missing fd modes check for map iterators
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable <stable@vger.kernel.org>
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

On Tue, Sep 6, 2022 at 10:04 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Commit 6e71b04a82248 ("bpf: Add file mode configuration into bpf maps")
> added the BPF_F_RDONLY and BPF_F_WRONLY flags, to let user space specify
> whether it will just read or modify a map.
>
> Map access control is done in two steps. First, when user space wants to
> obtain a map fd, it provides to the kernel the eBPF-defined flags, which
> are converted into open flags and passed to the security_bpf_map() security
> hook for evaluation by LSMs.
>
> Second, if user space successfully obtained an fd, it passes that fd to the
> kernel when it requests a map operation (e.g. lookup or update). The kernel
> first checks if the fd has the modes required to perform the requested
> operation and, if yes, continues the execution and returns the result to
> user space.
>
> While the fd modes check was added for map_*_elem() functions, it is
> currently missing for map iterators, added more recently with commit
> a5cbe05a6673 ("bpf: Implement bpf iterator for map elements"). A map
> iterator executes a chosen eBPF program for each key/value pair of a map
> and allows that program to read and/or modify them.
>
> Whether a map iterator allows only read or also write depends on whether
> the MEM_RDONLY flag in the ctx_arg_info member of the bpf_iter_reg
> structure is set. Also, write needs to be supported at verifier level (for
> example, it is currently not supported for sock maps).
>
> Since map iterators obtain a map from a user space fd with
> bpf_map_get_with_uref(), add the new req_modes parameter to that function,
> so that map iterators can provide the required fd modes to access a map. If
> the user space fd doesn't include the required modes,
> bpf_map_get_with_uref() returns with an error, and the map iterator will
> not be created.
>
> If a map iterator marks both the key and value as read-only, it calls
> bpf_map_get_with_uref() with FMODE_CAN_READ as value for req_modes. If it
> also allows write access to either the key or the value, it calls that
> function with FMODE_CAN_READ | FMODE_CAN_WRITE as value for req_modes,
> regardless of whether or not the write is supported by the verifier (the
> write is intentionally allowed).
>
> bpf_fd_probe_obj() does not require any fd mode, as the fd is only used for
> the purpose of finding the eBPF object type, for pinning the object to the
> bpffs filesystem.
>
> Finally, it is worth to mention that the fd modes check was not added for
> the cgroup iterator, although it registers an attach_target method like the
> other iterators. The reason is that the fd is not the only way for user
> space to reference a cgroup object (also by ID and by path). For the
> protection to be effective, all reference methods need to be evaluated
> consistently. This work is deferred to a separate patch.

I think the current behavior is fine.
File permissions don't apply at iterator level or prog level.
fmode_can_read/write are for syscall commands only.
To be fair we've added them to lookup/delete commands
and it was more of a pain to maintain and no confirmed good use.
