Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CD84EFD4D
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 01:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351763AbiDAX5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 19:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiDAX5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 19:57:34 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D03C506F8;
        Fri,  1 Apr 2022 16:55:43 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id bc27so3514007pgb.4;
        Fri, 01 Apr 2022 16:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ITDDF7wJMqoC4D+CMFddkLEBVT+cz8yxZasDs7bEqHU=;
        b=lKGmW1uWP9QHlp4AUB8qvKmffBMuUV67+V/VNWVRF6rOOYUbY+74bGyNvz0/RaZGm0
         /6a1CNZPKF9XX8ufK2skUi/JsjqwRe6QpfBWIMc4Hugbu/pi7xgtDj+QZhrsm47b6P7e
         MOqTKbiXouVj0rKUrNmMDVRTSskLt1rtHCZgGPxPtO+6WMOtlhB0VeWkxpTII8BpF4Ar
         ZZYmaNBpe+zxwun2L8jgoYeVVLVEgsbprrzeDw5z0zV8K8N7UqRI1RkpiMq9kECPUC5M
         X+EyGGzgnmy6ExUyqWapnwBhOaROd4ahOlRCHdELR9gEp0stA9O6L/EGZyJY8XyOLX00
         1z1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ITDDF7wJMqoC4D+CMFddkLEBVT+cz8yxZasDs7bEqHU=;
        b=t6m6Wa6ns29KkvIODqEKUi3IJIvq8yJQJ1SAO2CFxrrY4nh34zbp6GZ4VK4yjgitHq
         gRAbHWUGQ5Tlg7Ff3YhoNSeozgVLUpNs2UqU/M1eenvR+Vf4lLzF5yuyGSUw/YfyUfDm
         6UxHo3iOwjb1BeZteRXbgchtmbiJFivGh7vleyZtHLjCllFldnlz5khDkoJRhcpIeJ4A
         4jSUBJsAu6s4ZEndjLA4gjkcf/5FPn9RK61rK6fDnB0b7Eo7smymT/00hW2PCFIMX2QK
         HyczYje+Hr05tfZEAjlZR8hcNJzolTyyQcC7NTMR2w9JDykMq26Q3eBcgI1r4/6Y8cvO
         rAkw==
X-Gm-Message-State: AOAM530tOaF4jSnxTrm7cwfBoa3r+dgUK9RFrtnBdLvGtr0lIn+WwneT
        2pbiMjQ0EgtwBIRGVS2lfGE=
X-Google-Smtp-Source: ABdhPJw5mHEx3OXRCJwg5BH/o7y2KBgiA/EPycjlEwRTxtui+XCnm3ENGoJTUYt+IJX/yfQbKijNJA==
X-Received: by 2002:a62:84d3:0:b0:4fa:72e2:1c64 with SMTP id k202-20020a6284d3000000b004fa72e21c64mr47407413pfd.29.1648857342449;
        Fri, 01 Apr 2022 16:55:42 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::5:fb6e])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm4230615pfu.56.2022.04.01.16.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 16:55:41 -0700 (PDT)
Date:   Fri, 1 Apr 2022 16:55:37 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
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
Subject: Re: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Message-ID: <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
 <b9f5995f96da447c851f7c9db8232a9b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9f5995f96da447c851f7c9db8232a9b@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 08:25:22AM +0000, Roberto Sassu wrote:
> > From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> > Sent: Thursday, March 31, 2022 4:27 AM
> > On Mon, Mar 28, 2022 at 07:50:15PM +0200, Roberto Sassu wrote:
> > > eBPF already allows programs to be preloaded and kept running without
> > > intervention from user space. There is a dedicated kernel module called
> > > bpf_preload, which contains the light skeleton of the iterators_bpf eBPF
> > > program. If this module is enabled in the kernel configuration, its loading
> > > will be triggered when the bpf filesystem is mounted (unless the module is
> > > built-in), and the links of iterators_bpf are pinned in that filesystem
> > > (they will appear as the progs.debug and maps.debug files).
> > >
> > > However, the current mechanism, if used to preload an LSM, would not
> > offer
> > > the same security guarantees of LSMs integrated in the security
> > subsystem.
> > > Also, it is not generic enough to be used for preloading arbitrary eBPF
> > > programs, unless the bpf_preload code is heavily modified.
> > >
> > > More specifically, the security problems are:
> > > - any program can be pinned to the bpf filesystem without limitations
> > >   (unless a MAC mechanism enforces some restrictions);
> > > - programs being executed can be terminated at any time by deleting the
> > >   pinned objects or unmounting the bpf filesystem.
> > 
> > So many things to untangle here.
> 
> Hi Alexei
> 
> thanks for taking the time to provide such detailed
> explanation.
> 
> > The above paragraphs are misleading and incorrect.
> > The commit log sounds like there are security issues that this
> > patch set is fixing.
> > This is not true.
> 
> I reiterate the goal: enforce a mandatory policy with
> an out-of-tree LSM (a kernel module is fine), with the
> same guarantees of LSMs integrated in the security
> subsystem.

To make it 100% clear:
Any in-kernel feature that benefits out-of-tree module will be rejected.

> The root user is not part of the TCB (i.e. is untrusted),
> all the changes that user wants to make must be subject
> of decision by the LSM enforcing the mandatory policy.
> 
> I thought about adding support for LSMs from kernel
> modules via a new built-in LSM (called LoadLSM), but

Such approach will be rejected. See above.

> > I suspect there is huge confusion on what these two "progs.debug"
> > and "maps.debug" files are in a bpffs instance.
> > They are debug files to pretty pring loaded maps and progs for folks who
> > like to use 'cat' to examine the state of the system instead of 'bpftool'.
> > The root can remove these files from bpffs.
> > 
> > There is no reason for kernel module to pin its bpf progs.
> > If you want to develop DIGLIM as a kernel module that uses light skeleton
> > just do:
> > #include <linux/init.h>
> > #include <linux/module.h>
> > #include "diglim.lskel.h"
> > 
> > static struct diglim_bpf *skel;
> > 
> > static int __init load(void)
> > {
> >         skel = diglim_bpf__open_and_load();
> >         err = diglim_bpf__attach(skel);
> > }
> > /* detach skel in __fini */
> > 
> > It's really that short.
> > 
> > Then you will be able to
> > - insmod diglim.ko -> will load and attach bpf progs.
> > - rmmod diglim -> will detach them.
> 
> root can stop the LSM without consulting the security
> policy. The goal of having root untrusted is not achieved.

Out-of-tree module can do any hack.
For example:
1. don't do detach skel in __fini
  rmmod will remove the module, but bpf progs will keep running.
2. do module_get(THIS_MODULE) in __init
  rmmod will return EBUSY
  and have some out-of-band way of dropping mod refcnt.
3. hack into sys_delete_module. if module_name==diglem return EBUSY.
4. add proper LSM hook to delete_module

> My point was that pinning progs seems to be the
> recommended way of keeping them running. 

Not quite. bpf_link refcnt is what keeps progs attached.
bpffs is mainly used for:
- to pass maps/links from one process to another
when passing fd is not possible.
- to solve the case of crashing user space.
The user space agent will restart and will pick up where
it's left by reading map, link, prog FDs from bpffs.
- pinning bpf iterators that are later used to 'cat' such files.
That is what bpf_preload is doing by creating two debug
files "maps.debug" and "progs.debug".

> Pinning
> them to unreachable inodes intuitively looked the
> way to go for achieving the stated goal. 

We can consider inodes in bpffs that are not unlinkable by root
in the future, but certainly not for this use case.

> Or maybe I
> should just increment the reference count of links
> and don't decrement during an rmmod?

I suggest to abandon out-of-tree goal.
Only then we can help and continue this discussion.
