Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5187E4EFD90
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 03:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiDBBF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 21:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiDBBFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 21:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD4121AF
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 18:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED6E61C39
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 01:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D71C341C0
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 01:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648861401;
        bh=IbghA2dqiYhWXecxL6uJJ7n1Ce58U1f1jXhOOf0w2DA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qPl5O8et+RIxSlDAMF72fgkZo7E89yXN33hp7R1sFEJRZZh6BeuGyYbe31+nsWmEc
         lychCTK8y19hzo5zGw/lQUyLA5bXYC+qm8B/x1xWmXJghINq1ML6faKem1ZKnr3Fzc
         E4cQrFis0nHEZi3xseZkYRPa7elL5NcohH7lQQ7r+2iEzl1P0tMRmgHDZHLzsErNtJ
         KmjV23iGdMxELFec+B39s1RFnuv2CDg0FC9xCqwdGsndiKVJ79eqpVFPnT1bZab+iP
         ma3WLnbA+HHVnjUB12xWtiKT9qYsEOKIaAyJ9tPqbEp8SekXaLpN+ybqnhsVVVhbE/
         ro2upEuXCL9lw==
Received: by mail-ej1-f50.google.com with SMTP id bg10so9203646ejb.4
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 18:03:21 -0700 (PDT)
X-Gm-Message-State: AOAM533r/Wh0qnGJysOaOZ2frqugbT/OtZ8HGiLvquw6zhCLb5sG2dIS
        PuyE8E0dB6fIJLFOOkWSGYeqyUy+rK3hwhKfcBtOkQ==
X-Google-Smtp-Source: ABdhPJzC1xfADMf8KlFXGnU+O10yqjuLNdQMD6B8hDbX9K5RYwHPXDVlmYgGwvXzZmJ1+ZDG91LG6SDOelwAvnQH2J4=
X-Received: by 2002:a17:907:3f9e:b0:6da:842e:873e with SMTP id
 hr30-20020a1709073f9e00b006da842e873emr2038636ejc.383.1648861399066; Fri, 01
 Apr 2022 18:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
 <b9f5995f96da447c851f7c9db8232a9b@huawei.com> <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
In-Reply-To: <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Sat, 2 Apr 2022 03:03:08 +0200
X-Gmail-Original-Message-ID: <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
Message-ID: <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
Subject: Re: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 2, 2022 at 1:55 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 31, 2022 at 08:25:22AM +0000, Roberto Sassu wrote:
> > > From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> > > Sent: Thursday, March 31, 2022 4:27 AM
> > > On Mon, Mar 28, 2022 at 07:50:15PM +0200, Roberto Sassu wrote:
> > > > eBPF already allows programs to be preloaded and kept running without
> > > > intervention from user space. There is a dedicated kernel module called
> > > > bpf_preload, which contains the light skeleton of the iterators_bpf eBPF
> > > > program. If this module is enabled in the kernel configuration, its loading
> > > > will be triggered when the bpf filesystem is mounted (unless the module is
> > > > built-in), and the links of iterators_bpf are pinned in that filesystem
> > > > (they will appear as the progs.debug and maps.debug files).
> > > >
> > > > However, the current mechanism, if used to preload an LSM, would not
> > > offer
> > > > the same security guarantees of LSMs integrated in the security
> > > subsystem.
> > > > Also, it is not generic enough to be used for preloading arbitrary eBPF
> > > > programs, unless the bpf_preload code is heavily modified.
> > > >
> > > > More specifically, the security problems are:
> > > > - any program can be pinned to the bpf filesystem without limitations
> > > >   (unless a MAC mechanism enforces some restrictions);
> > > > - programs being executed can be terminated at any time by deleting the
> > > >   pinned objects or unmounting the bpf filesystem.
> > >
> > > So many things to untangle here.
> >
> > Hi Alexei
> >
> > thanks for taking the time to provide such detailed
> > explanation.
> >
> > > The above paragraphs are misleading and incorrect.
> > > The commit log sounds like there are security issues that this
> > > patch set is fixing.
> > > This is not true.

+1 these are not security issues. They are limitations of your MAC policy.

> >
> > I reiterate the goal: enforce a mandatory policy with
> > an out-of-tree LSM (a kernel module is fine), with the
> > same guarantees of LSMs integrated in the security
> > subsystem.
>
> To make it 100% clear:
> Any in-kernel feature that benefits out-of-tree module will be rejected.
>
> > The root user is not part of the TCB (i.e. is untrusted),
> > all the changes that user wants to make must be subject
> > of decision by the LSM enforcing the mandatory policy.
> >
> > I thought about adding support for LSMs from kernel
> > modules via a new built-in LSM (called LoadLSM), but

Kernel modules cannot implement LSMs, this has already been
proposed on the lists and has been rejected.

>
> Such approach will be rejected. See above.
>
> > > I suspect there is huge confusion on what these two "progs.debug"
> > > and "maps.debug" files are in a bpffs instance.
> > > They are debug files to pretty pring loaded maps and progs for folks who
> > > like to use 'cat' to examine the state of the system instead of 'bpftool'.
> > > The root can remove these files from bpffs.
> > >
> > > There is no reason for kernel module to pin its bpf progs.
> > > If you want to develop DIGLIM as a kernel module that uses light skeleton
> > > just do:
> > > #include <linux/init.h>
> > > #include <linux/module.h>
> > > #include "diglim.lskel.h"
> > >
> > > static struct diglim_bpf *skel;
> > >
> > > static int __init load(void)
> > > {
> > >         skel = diglim_bpf__open_and_load();
> > >         err = diglim_bpf__attach(skel);
> > > }
> > > /* detach skel in __fini */
> > >
> > > It's really that short.
> > >
> > > Then you will be able to
> > > - insmod diglim.ko -> will load and attach bpf progs.
> > > - rmmod diglim -> will detach them.
> >
> > root can stop the LSM without consulting the security
> > policy. The goal of having root untrusted is not achieved.

Ofcourse, this is an issue, if you are using BPF to define a MAC
policy, the policy
needs to be comprehensive to prevent itself from being overridden. This is why
We have so many LSM hooks. If you think some are missing, let's add them.

This is why implementing a policy is not trivial, but we need to allow
users to build
such policies with the help from the kernel and not by using
out-of-tree modules.

I do think we can add some more helpers (e.g. for modifying xattrs
from BPF) that
would help us build complex policies.

>
> Out-of-tree module can do any hack.
> For example:
> 1. don't do detach skel in __fini
>   rmmod will remove the module, but bpf progs will keep running.
> 2. do module_get(THIS_MODULE) in __init
>   rmmod will return EBUSY
>   and have some out-of-band way of dropping mod refcnt.
> 3. hack into sys_delete_module. if module_name==diglem return EBUSY.
> 4. add proper LSM hook to delete_module

+1 I recommend this (but not from an out of tree module)

>
> > My point was that pinning progs seems to be the
> > recommended way of keeping them running.
>
> Not quite. bpf_link refcnt is what keeps progs attached.
> bpffs is mainly used for:
> - to pass maps/links from one process to another
> when passing fd is not possible.
> - to solve the case of crashing user space.
> The user space agent will restart and will pick up where
> it's left by reading map, link, prog FDs from bpffs.
> - pinning bpf iterators that are later used to 'cat' such files.
> That is what bpf_preload is doing by creating two debug
> files "maps.debug" and "progs.debug".
>
> > Pinning
> > them to unreachable inodes intuitively looked the
> > way to go for achieving the stated goal.
>
> We can consider inodes in bpffs that are not unlinkable by root
> in the future, but certainly not for this use case.

Can this not be already done by adding a BPF_LSM program to the
inode_unlink LSM hook?

>
> > Or maybe I
> > should just increment the reference count of links
> > and don't decrement during an rmmod?
>
> I suggest to abandon out-of-tree goal.
> Only then we can help and continue this discussion.

+1
