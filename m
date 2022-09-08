Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A130F5B21D7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiIHPRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 11:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiIHPRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 11:17:33 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAA740571;
        Thu,  8 Sep 2022 08:17:32 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id go34so3790453ejc.2;
        Thu, 08 Sep 2022 08:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dvC/u7qJ5dN4X47tbsTGAuz++QpERj+4FDleSIpBEMg=;
        b=R0hVOMicuPDSnoQmcmYiJB3LFWFfOFwjBgRBuwuOEWI5JTxT51Lu0OjLr++Gxw/lzs
         Tvik3ezKxyKAnzDTCdQqFNmpHVznLaNacrF9ZuvJc9pBhz0lrAdZi1n+3xp/ijThvgp8
         VOwRWcRDrlK9c+JFS1o8ONZvPVH7bR5r3/0ESeh6jy2zLWd7yU9MbottgDeiLnCTWQUN
         tzuE0V5OqQhzozQQSsV16et/mkj7icGxA9KjWbtIM5r6eFzdxL2e+f9jqf4Nw1JWc8Gp
         zzjf6KnNbCgGJ8j2doSbs7qY9udYo9nEXzEMNqBxnxO5iPN9tehMBETqPTDu68UbIvgn
         qldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dvC/u7qJ5dN4X47tbsTGAuz++QpERj+4FDleSIpBEMg=;
        b=bCVLOJe+uWFWhqRYSGlMsFWddY0ccOuslSZ8SxdL5L4VKGycPyhjMCScLRhrL0wnfH
         RsYzRQaebJgmm78Cg/YaAN4h7x05qFflvpl/48d9F+9zdZvvCyQq7TL4x9K/CZjvJyKp
         MBqif/DNTnyFdBHskvp2mk1B8zH0UkInMhxX7ly6sfwJuQkpGto1JBRRvrIjiFf3x+97
         o5C8f42lClJCCLQaBHcMn+tBo5h3qGNYa5g+kVTJEFlKNVY8QQcOH4CmslmqXyG5fWq1
         vvyGtTkV49j8EDzzYtl4fiB78Cu5BoqX0p4ICS6c4nbSy8sIiz0tWrTpps/jPlbQ+W6X
         NDEg==
X-Gm-Message-State: ACgBeo2kHgehmbKYlK/bn9FOqYfXQFkMOZxRq42BTwPpoWaewC3p1ZtZ
        i4+mAZFTL3LeSGmr2QXgeLi+SG2lq4CZ77J0pa8=
X-Google-Smtp-Source: AA6agR6lkwvnPcInorNKbMkhlPy/kqMnwSqf9ilS5C3PIU+zXOi3rmnC/1PYHJgUShzGaAZn2JBWrMwTREu95J9WrlE=
X-Received: by 2002:a17:907:a04f:b0:772:da0b:e2f1 with SMTP id
 gz15-20020a170907a04f00b00772da0be2f1mr3625960ejc.327.1662650250524; Thu, 08
 Sep 2022 08:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
 <20220906170301.256206-2-roberto.sassu@huaweicloud.com> <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
 <02309cfbc1ce47f7de6be8addc2caa315b1fee1b.camel@huaweicloud.com>
 <CAADnVQ+cEM5Sb7d9yPA72Mp2zimx7VZ5Si3SPVdAZgsdFGpP1Q@mail.gmail.com> <8d7a713e500b5e3fce93e4c5c7b8841eb6dd28e4.camel@huaweicloud.com>
In-Reply-To: <8d7a713e500b5e3fce93e4c5c7b8841eb6dd28e4.camel@huaweicloud.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 8 Sep 2022 08:17:19 -0700
Message-ID: <CAADnVQL7murY8G4SG5sF3855ETBpmrv0S-dueR8Rht4ucm6WwQ@mail.gmail.com>
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

On Thu, Sep 8, 2022 at 6:59 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> On Wed, 2022-09-07 at 09:02 -0700, Alexei Starovoitov wrote:
> >
>
> [...]
>
> > > Well, if you write a security module to prevent writes on a map,
> > > and
> > > user space is able to do it anyway with an iterator, what is the
> > > purpose of the security module then?
> >
> > sounds like a broken "security module" and nothing else.
>
> Ok, if a custom security module does not convince you, let me make a
> small example with SELinux.
>
> I created a small map iterator that sets every value of a map to 5:
>
> SEC("iter/bpf_map_elem")
> int write_bpf_hash_map(struct bpf_iter__bpf_map_elem *ctx)
> {
>         u32 *key = ctx->key;
>         u8 *val = ctx->value;
>
>         if (key == NULL || val == NULL)
>                 return 0;
>
>         *val = 5;
>         return 0;
> }
>
> I create and pin a map:
>
> # bpftool map create /sys/fs/bpf/map type array key 4 value 1 entries 1
> name test
>
> Initially, the content of the map looks like:
>
> # bpftool map dump pinned /sys/fs/bpf/map
> key: 00 00 00 00  value: 00
> Found 1 element
>
> I then created a new SELinux type bpftool_test_t, which has only read
> permission on maps:
>
> # sesearch -A -s bpftool_test_t -t unconfined_t -c bpf
> allow bpftool_test_t unconfined_t:bpf map_read;
>
> So, what I expect is that this type is not able to write to the map.
>
> Indeed, the current bpftool is not able to do it:
>
> # strace -f -etrace=bpf runcon -t bpftool_test_t bpftool iter pin
> writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
> bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0, file_flags=0},
> 144) = -1 EACCES (Permission denied)
> Error: bpf obj get (/sys/fs/bpf): Permission denied
>
> This happens because the current bpftool requests to access the map
> with read-write permission, and SELinux denies it:
>
> # cat /var/log/audit/audit.log|audit2allow
>
>
> #============= bpftool_test_t ==============
> allow bpftool_test_t unconfined_t:bpf map_write;
>
>
> The command failed, and the content of the map is still:
>
> # bpftool map dump pinned /sys/fs/bpf/map
> key: 00 00 00 00  value: 00
> Found 1 element
>
>
> Now, what I will do is to use a slightly modified version of bpftool
> which requests read-only access to the map instead:
>
> # strace -f -etrace=bpf runcon -t bpftool_test_t ./bpftool iter pin
> writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
> bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0,
> file_flags=BPF_F_RDONLY}, 16) = 3
> libbpf: elf: skipping unrecognized data section(5) .eh_frame
> libbpf: elf: skipping relo section(6) .rel.eh_frame for section(5)
> .eh_frame
>
> ...
>
> bpf(BPF_LINK_CREATE, {link_create={prog_fd=4, target_fd=0,
> attach_type=BPF_TRACE_ITER, flags=0}, ...}, 48) = 5
> bpf(BPF_OBJ_PIN, {pathname="/sys/fs/bpf/iter", bpf_fd=5, file_flags=0},
> 16) = 0
>
> That worked, because SELinux grants read-only permission to
> bpftool_test_t. However, the map iterator does not check how the fd was
> obtained, and thus allows the iterator to be created.
>
> At this point, we have write access, despite not having the right to do
> it:

That is a wrong assumption to begin with.
Having an fd to a bpf object (map, link, prog) allows access.
read/write sort-of applicable to maps, but not so much
to progs, links.
That file based read/write flag is only for user processes.
bpf progs always had separate flags for that.
See BPF_F_RDONLY vs BPF_F_RDONLY_PROG.
One doesn't imply the other.
