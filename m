Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C6E5B09B0
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiIGQFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiIGQEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:04:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD349BC82C;
        Wed,  7 Sep 2022 09:02:46 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e18so20421821edj.3;
        Wed, 07 Sep 2022 09:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=W50vIl8H8okzCAHaiXlJ50UVDkF7Y2icaSoN501LXVk=;
        b=cSXmBeIU8YEd8KpkA8OIVFcCNyIWOpvxJZ3Z76jqeM1Nfr4CcOUHyr8tnCbWvR/Dd3
         a+xIS7mQheRBmXzC3OdoGzFj55wYZgGBbG2U68jKwSZMMHE2S3ucY6qgN9hIVp9V3FXA
         +LjPEjt3YYVTeX7BBNsiwSK2MVLv8QPtTad7Vmwb8R5pwGTDGhzzeWMZFZz76uXc516m
         My1hyOyYiocDp1zCbWRWNhuqssIcspna7958G/dDtEbmGMHOZOleNsGnpq73KIblz4jP
         jcsv52FTlrUZ+Kby6kQkkl7xZ0nqxFZs6XI0Mp20FDB37grdSGlo/nJFAMTSzjlf8LuF
         Zxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=W50vIl8H8okzCAHaiXlJ50UVDkF7Y2icaSoN501LXVk=;
        b=6hYd0tKmEwqNAKHwIbYLX7oYD/cyDkii4ihDWduNCbRibpHTiEJYGwWZwTGz6CcrUK
         0/bL0nheOb8jd226ZNneFs16KiYuhRiayBEBEaqgx2bf60fhqDWWe3FByAFiGtJia+0E
         fk8mS1tbSd2FcmN/ZXdwDRJvCut5VppPjw9bFUIKqnG93ignRDA+dIB2Wur9ONdtszXr
         nXZO/fddyBXbVt0Oe3t6IrmI41tJT/KFWBljMB44pyDRC080hyHfgBEPddR71MM0gHax
         8AMWt5qtADxmEYU7+uaSk9IMzYC/uPZXHLOsPif8HJu+5Cli4lytr4KZ+vl58jdvg63R
         aKjg==
X-Gm-Message-State: ACgBeo1tcMckz4d/UDLD9DuxSX7iS1tyRDDiBo1i920tSM4UlZ2K1nb1
        zZ3JuT79hiE2Zm+n2a8wDnBU2RMvMgmnriw6efY=
X-Google-Smtp-Source: AA6agR627hvEYVrK8cONsjNB6SibCo3kdbrD3+RR1gZlPRM5T5pob6+UKUFsFL+3lVkDMtaz8cWkWFUer8OM7q5tXH4=
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id
 ef11-20020a05640228cb00b0043bc6d7ef92mr3720169edb.333.1662566558177; Wed, 07
 Sep 2022 09:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
 <20220906170301.256206-2-roberto.sassu@huaweicloud.com> <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
 <02309cfbc1ce47f7de6be8addc2caa315b1fee1b.camel@huaweicloud.com>
In-Reply-To: <02309cfbc1ce47f7de6be8addc2caa315b1fee1b.camel@huaweicloud.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Sep 2022 09:02:26 -0700
Message-ID: <CAADnVQ+cEM5Sb7d9yPA72Mp2zimx7VZ5Si3SPVdAZgsdFGpP1Q@mail.gmail.com>
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
        stable <stable@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        LSM List <linux-security-module@vger.kernel.org>
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

On Wed, Sep 7, 2022 at 1:03 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> On Tue, 2022-09-06 at 11:21 -0700, Alexei Starovoitov wrote:
> > On Tue, Sep 6, 2022 at 10:04 AM Roberto Sassu
> > <roberto.sassu@huaweicloud.com> wrote:
> > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > >
> > > Commit 6e71b04a82248 ("bpf: Add file mode configuration into bpf
> > > maps")
> > > added the BPF_F_RDONLY and BPF_F_WRONLY flags, to let user space
> > > specify
> > > whether it will just read or modify a map.
> > >
> > > Map access control is done in two steps. First, when user space
> > > wants to
> > > obtain a map fd, it provides to the kernel the eBPF-defined flags,
> > > which
> > > are converted into open flags and passed to the security_bpf_map()
> > > security
> > > hook for evaluation by LSMs.
> > >
> > > Second, if user space successfully obtained an fd, it passes that
> > > fd to the
> > > kernel when it requests a map operation (e.g. lookup or update).
> > > The kernel
> > > first checks if the fd has the modes required to perform the
> > > requested
> > > operation and, if yes, continues the execution and returns the
> > > result to
> > > user space.
> > >
> > > While the fd modes check was added for map_*_elem() functions, it
> > > is
> > > currently missing for map iterators, added more recently with
> > > commit
> > > a5cbe05a6673 ("bpf: Implement bpf iterator for map elements"). A
> > > map
> > > iterator executes a chosen eBPF program for each key/value pair of
> > > a map
> > > and allows that program to read and/or modify them.
> > >
> > > Whether a map iterator allows only read or also write depends on
> > > whether
> > > the MEM_RDONLY flag in the ctx_arg_info member of the bpf_iter_reg
> > > structure is set. Also, write needs to be supported at verifier
> > > level (for
> > > example, it is currently not supported for sock maps).
> > >
> > > Since map iterators obtain a map from a user space fd with
> > > bpf_map_get_with_uref(), add the new req_modes parameter to that
> > > function,
> > > so that map iterators can provide the required fd modes to access a
> > > map. If
> > > the user space fd doesn't include the required modes,
> > > bpf_map_get_with_uref() returns with an error, and the map iterator
> > > will
> > > not be created.
> > >
> > > If a map iterator marks both the key and value as read-only, it
> > > calls
> > > bpf_map_get_with_uref() with FMODE_CAN_READ as value for req_modes.
> > > If it
> > > also allows write access to either the key or the value, it calls
> > > that
> > > function with FMODE_CAN_READ | FMODE_CAN_WRITE as value for
> > > req_modes,
> > > regardless of whether or not the write is supported by the verifier
> > > (the
> > > write is intentionally allowed).
> > >
> > > bpf_fd_probe_obj() does not require any fd mode, as the fd is only
> > > used for
> > > the purpose of finding the eBPF object type, for pinning the object
> > > to the
> > > bpffs filesystem.
> > >
> > > Finally, it is worth to mention that the fd modes check was not
> > > added for
> > > the cgroup iterator, although it registers an attach_target method
> > > like the
> > > other iterators. The reason is that the fd is not the only way for
> > > user
> > > space to reference a cgroup object (also by ID and by path). For
> > > the
> > > protection to be effective, all reference methods need to be
> > > evaluated
> > > consistently. This work is deferred to a separate patch.
> >
> > I think the current behavior is fine.
> > File permissions don't apply at iterator level or prog level.
>
> + Chenbo, linux-security-module
>
> Well, if you write a security module to prevent writes on a map, and
> user space is able to do it anyway with an iterator, what is the
> purpose of the security module then?

sounds like a broken "security module" and nothing else.

> > fmode_can_read/write are for syscall commands only.
> > To be fair we've added them to lookup/delete commands
> > and it was more of a pain to maintain and no confirmed good use.
>
> I think a good use would be requesting the right permission for the
> type of operation that needs to be performed, e.g. read-only permission
> when you have a read-like operation like a lookup or dump.
>
> By always requesting read-write permission, for all operations,
> security modules won't be able to distinguish which operation has to be
> denied to satisfy the policy.
>
> One example of that is that, when there is a security module preventing
> writes on maps (will be that uncommon?),

lsm that prevents writes into bpf maps? That's a convoluted design.
You can try to implement such an lsm, but expect lots of challenges.

> bpftool is not able to show
> the full list of maps because it asks for read-write permission for
> getting the map info.

completely orthogonal issue.

> Freezing the map is not a solution, if you want to allow certain
> subjects to continuously update the protected map at run-time.
>
> Roberto
>
