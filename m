Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12CC4ED1BB
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 04:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiCaC3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 22:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiCaC3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 22:29:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EC67C7BA;
        Wed, 30 Mar 2022 19:27:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so1351960pjb.5;
        Wed, 30 Mar 2022 19:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=brGSPXAAKZq1zv7Rz5aMBtmTUSadoAJBmC11PEMAvD8=;
        b=nlbLJK1J/O6nYUq8evC9fJ339K6x4bHJN538DoapkFJy/VjamB+dwe1Px9feUd1F62
         AuQA+r+MLCydK2yozMl9JBakx4tVgx+dfV8Gdj/+JlJ2s2PcpC4CMNPP5jLvJ+K0I6D/
         58ZJKgDGq1VRIj1iby3BwAtIS+ZYXz1m49h/ISmaUaj8PnLMI0kAPXSIXPcLdRTC0j8J
         U6i3turNOHHTzB3JHSrY9OZO6U8/hg8niDEnBammYq4EML8DPZ5FMpqH75sa8up49yfJ
         k9LF6ybIF0vVv8TCzRBoa6wHQVGrUOF8KESVyx/8Ef7n7ki7hsvStej2Hwrh4SjR6gie
         b89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=brGSPXAAKZq1zv7Rz5aMBtmTUSadoAJBmC11PEMAvD8=;
        b=DVRXoFphc7gbHAFB1qIcASb6DLjHiTJzwj2bGxTEaaZ34E9ApZMEVor1YGZLkktlar
         NPqNrbkIvtBvts50S6U48ENs8/kwiCERqbw1lqWhQweX0r+SRV0rQ38B97ormaKs5dd9
         GSgCC1PVMVfCI4Q5VliqXdoumEHCgYKz+XamQQZsEmwj33cFKmgjLWQYT5bQ8mwv2JpI
         SwjHll9hfgkMiwm1UkT9kn93pTYYppCCRc8VR2kORYjJ4wa7njSqye7Sk9H38Q8o8Ajt
         8ibBPsMWF5Pfx4HUH2H9belWSmuMwznv7998XZmsZAM3FTI/+tFUd0z8qV78SYLXk+Gt
         TnlA==
X-Gm-Message-State: AOAM5329OTfmj/kAcYd75End/6WfKixomIF9vbTYEv50/zBXfNT1VZzT
        kDs9iWQKnJFIlIAZG/x15+vJ2R+eCUk=
X-Google-Smtp-Source: ABdhPJyn/9RKDnn9ebHKMw2O6x7J/GpkAo9yaxB7FFrh7CXFQi1SCyOQyd83zRQ7s2yhmAiT/9wZaA==
X-Received: by 2002:a17:90b:4a48:b0:1c7:bb62:446c with SMTP id lb8-20020a17090b4a4800b001c7bb62446cmr3463303pjb.146.1648693651949;
        Wed, 30 Mar 2022 19:27:31 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::5:756c])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a00229000b004fabe756ba6sm27342617pfe.54.2022.03.30.19.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 19:27:31 -0700 (PDT)
Date:   Wed, 30 Mar 2022 19:27:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     corbet@lwn.net, viro@zeniv.linux.org.uk, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kpsingh@kernel.org,
        shuah@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, zohar@linux.ibm.com,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Message-ID: <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328175033.2437312-1-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 07:50:15PM +0200, Roberto Sassu wrote:
> eBPF already allows programs to be preloaded and kept running without
> intervention from user space. There is a dedicated kernel module called
> bpf_preload, which contains the light skeleton of the iterators_bpf eBPF
> program. If this module is enabled in the kernel configuration, its loading
> will be triggered when the bpf filesystem is mounted (unless the module is
> built-in), and the links of iterators_bpf are pinned in that filesystem
> (they will appear as the progs.debug and maps.debug files).
> 
> However, the current mechanism, if used to preload an LSM, would not offer
> the same security guarantees of LSMs integrated in the security subsystem.
> Also, it is not generic enough to be used for preloading arbitrary eBPF
> programs, unless the bpf_preload code is heavily modified.
> 
> More specifically, the security problems are:
> - any program can be pinned to the bpf filesystem without limitations
>   (unless a MAC mechanism enforces some restrictions);
> - programs being executed can be terminated at any time by deleting the
>   pinned objects or unmounting the bpf filesystem.

So many things to untangle here.

The above paragraphs are misleading and incorrect.
The commit log sounds like there are security issues that this
patch set is fixing.
This is not true.
Looks like there is a massive misunderstanding on what bpffs is.
It's a file system to pin and get bpf objects with normal
file access permissions. Nothing else.
Do NOT use it to pin LSM or any other security sensitive bpf programs
and then complain that root can unpin them.
Yes. Root can and should be able to 'rm -rf' anything in bpffs instance.

> The usability problems are:
> - only a fixed amount of links can be pinned;

where do you see this limit?

> - only links can be pinned, other object types are not supported;

really? progs, maps can be pinned as well.

> - code to pin objects has to be written manually;

huh?

> Solve the security problems by mounting the bpf filesystem from the kernel,
> by preloading authenticated kernel modules (e.g. with module.sig_enforce)
> and by pinning objects to that filesystem. This particular filesystem
> instance guarantees that desired eBPF programs run until the very end of
> the kernel lifecycle, since even root cannot interfere with it.

No.

I suspect there is huge confusion on what these two "progs.debug"
and "maps.debug" files are in a bpffs instance.
They are debug files to pretty pring loaded maps and progs for folks who
like to use 'cat' to examine the state of the system instead of 'bpftool'.
The root can remove these files from bpffs.

There is no reason for kernel module to pin its bpf progs.
If you want to develop DIGLIM as a kernel module that uses light skeleton
just do:
#include <linux/init.h>
#include <linux/module.h>
#include "diglim.lskel.h"

static struct diglim_bpf *skel;

static int __init load(void)
{
        skel = diglim_bpf__open_and_load();
        err = diglim_bpf__attach(skel);
}
/* detach skel in __fini */

It's really that short.

Then you will be able to
- insmod diglim.ko -> will load and attach bpf progs.
- rmmod diglim -> will detach them.

Independantly from these two mistunderstandings of bpffs and light skel
we've been talking about auto exposing loaded bpf progs, maps, links
in a bpffs without incrementing refcnt of them.
When progs get unloaded the files will disappear.
Some folks believe that doing 'ls' in a directory and see one file
for each bpf prog loaded and then doing 'cat' on that file would be
useful for debugging. That idea wasn't rejected. We're still thinking
what would be the best way to auto-expose all bpf objects for debugging
and whether it's actually makes sense to do considering that
bpftool already has commands to list all progs, maps, links, etc
with great detail.
It's pretty much an argument between 'cat+ls' believers and
'bpftool' cmdline believers.
That discussion is orthogonal and should not be mixed with bpffs, lsm,
security or anything else.
