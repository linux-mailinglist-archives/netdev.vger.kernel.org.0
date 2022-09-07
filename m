Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380325AFE74
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiIGIDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiIGIDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:03:21 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76802AA35F;
        Wed,  7 Sep 2022 01:03:12 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4MMvk82kTkz9xHvd;
        Wed,  7 Sep 2022 15:57:36 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwBnEJQZUBhjW0srAA--.12213S2;
        Wed, 07 Sep 2022 09:02:48 +0100 (CET)
Message-ID: <02309cfbc1ce47f7de6be8addc2caa315b1fee1b.camel@huaweicloud.com>
Subject: Re: [PATCH 1/7] bpf: Add missing fd modes check for map iterators
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        stable <stable@vger.kernel.org>, fengc@google.com,
        linux-security-module@vger.kernel.org
Date:   Wed, 07 Sep 2022 10:02:30 +0200
In-Reply-To: <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
         <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
         <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwBnEJQZUBhjW0srAA--.12213S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF1rCrW8ZF45GF4xKry8Krg_yoWrCFyDpr
        W3t3W2k3Z2yF1xCrn2qan7WFyfAFW3Kw47Xrn8JryxC3s8Wrn2kr4Y93W3uF9ruF17tr1a
        qr4qv3s3A3WDAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAkuxUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAIBF1jj4KycgACs8
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-09-06 at 11:21 -0700, Alexei Starovoitov wrote:
> On Tue, Sep 6, 2022 at 10:04 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Commit 6e71b04a82248 ("bpf: Add file mode configuration into bpf
> > maps")
> > added the BPF_F_RDONLY and BPF_F_WRONLY flags, to let user space
> > specify
> > whether it will just read or modify a map.
> > 
> > Map access control is done in two steps. First, when user space
> > wants to
> > obtain a map fd, it provides to the kernel the eBPF-defined flags,
> > which
> > are converted into open flags and passed to the security_bpf_map()
> > security
> > hook for evaluation by LSMs.
> > 
> > Second, if user space successfully obtained an fd, it passes that
> > fd to the
> > kernel when it requests a map operation (e.g. lookup or update).
> > The kernel
> > first checks if the fd has the modes required to perform the
> > requested
> > operation and, if yes, continues the execution and returns the
> > result to
> > user space.
> > 
> > While the fd modes check was added for map_*_elem() functions, it
> > is
> > currently missing for map iterators, added more recently with
> > commit
> > a5cbe05a6673 ("bpf: Implement bpf iterator for map elements"). A
> > map
> > iterator executes a chosen eBPF program for each key/value pair of
> > a map
> > and allows that program to read and/or modify them.
> > 
> > Whether a map iterator allows only read or also write depends on
> > whether
> > the MEM_RDONLY flag in the ctx_arg_info member of the bpf_iter_reg
> > structure is set. Also, write needs to be supported at verifier
> > level (for
> > example, it is currently not supported for sock maps).
> > 
> > Since map iterators obtain a map from a user space fd with
> > bpf_map_get_with_uref(), add the new req_modes parameter to that
> > function,
> > so that map iterators can provide the required fd modes to access a
> > map. If
> > the user space fd doesn't include the required modes,
> > bpf_map_get_with_uref() returns with an error, and the map iterator
> > will
> > not be created.
> > 
> > If a map iterator marks both the key and value as read-only, it
> > calls
> > bpf_map_get_with_uref() with FMODE_CAN_READ as value for req_modes.
> > If it
> > also allows write access to either the key or the value, it calls
> > that
> > function with FMODE_CAN_READ | FMODE_CAN_WRITE as value for
> > req_modes,
> > regardless of whether or not the write is supported by the verifier
> > (the
> > write is intentionally allowed).
> > 
> > bpf_fd_probe_obj() does not require any fd mode, as the fd is only
> > used for
> > the purpose of finding the eBPF object type, for pinning the object
> > to the
> > bpffs filesystem.
> > 
> > Finally, it is worth to mention that the fd modes check was not
> > added for
> > the cgroup iterator, although it registers an attach_target method
> > like the
> > other iterators. The reason is that the fd is not the only way for
> > user
> > space to reference a cgroup object (also by ID and by path). For
> > the
> > protection to be effective, all reference methods need to be
> > evaluated
> > consistently. This work is deferred to a separate patch.
> 
> I think the current behavior is fine.
> File permissions don't apply at iterator level or prog level.

+ Chenbo, linux-security-module

Well, if you write a security module to prevent writes on a map, and
user space is able to do it anyway with an iterator, what is the
purpose of the security module then?

> fmode_can_read/write are for syscall commands only.
> To be fair we've added them to lookup/delete commands
> and it was more of a pain to maintain and no confirmed good use.

I think a good use would be requesting the right permission for the
type of operation that needs to be performed, e.g. read-only permission
when you have a read-like operation like a lookup or dump.

By always requesting read-write permission, for all operations,
security modules won't be able to distinguish which operation has to be
denied to satisfy the policy.

One example of that is that, when there is a security module preventing
writes on maps (will be that uncommon?), bpftool is not able to show
the full list of maps because it asks for read-write permission for
getting the map info.

Freezing the map is not a solution, if you want to allow certain
subjects to continuously update the protected map at run-time.

Roberto

