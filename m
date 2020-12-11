Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669D42D811F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 22:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395183AbgLKV2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 16:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391247AbgLKV2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 16:28:25 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC93C0613CF;
        Fri, 11 Dec 2020 13:27:45 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t37so7998424pga.7;
        Fri, 11 Dec 2020 13:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AxBo7DuCrY0w5ou/wBwlnRTDbvkCAR5nr/KwMCjdb68=;
        b=KvLRscuSEUJV1BFdXM0yFL+IE8NvUQW9mxdaFu9r9eCcvitCd38Q/7Kd5/7EaSBJUE
         +Jj3nTQzmfrcBAV7eDCZaXPyLozwExHULFF33G5+5UKlxYu8Iq2/ug0uzRFQOzsqy84h
         nwEZjVJBNyM0Zq4tUdu98uqPpMaurHzy2YJB9cKU1jcJG/VmJF6ujNmkJajnsts8IZ0z
         UiWxK0pGaorJl0zZmAJkexlHoANSzd176vBoQ7pjn9keQqa9AInsoyk8Z9KqWj21fIbu
         sSbWaVhAglBOzhUehaxF8WtbglAcXpcg6fjszeAj5Zy6svE6hSQ6pRYbW6tX/QodAaHh
         XT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AxBo7DuCrY0w5ou/wBwlnRTDbvkCAR5nr/KwMCjdb68=;
        b=Qjw4JEl2XRMZu3DRNXfatIgUXvvfhn2bR0iB4ajen30CFTSE7srndw4A8DSXUWtcOE
         jxh1u/cVgBhUGHCgR48QaKkqa2ymaZ6MM/D+tA3fbHm603M3TnSaMnn9ECPR4Fc/mwGl
         to0chQXt35lIavwrxuR6iR34i9J1/lPuj0xCEpeb43QyK3cDh+Ai8qUabUZjadyB0say
         NQQm4OvMOUXh6ERXjBDPxxujmmuNlDhUqm14gpfBP/o3pr/EkBPkZomvguIxjHEfv83f
         E3W6P//2U1kszyvla748S9jBmuTe5RutukIhsyXlslDEtMMwV8qeM+a+lcDPDVcF6QW8
         CMRg==
X-Gm-Message-State: AOAM5314AgRKyGm2c1BmQHfPlvJ7vGTb+tTe1vDEP8usnUBjUfHPr51+
        J3duhs3bdH6yDh0HkfIqRoo9Nh6qAMM=
X-Google-Smtp-Source: ABdhPJx3t6YXv33M0E7++zQ+biP6+i2ejP610JaePUsbaeGNYoAe6RG9XY7q0PJRj46db3rFHzlyWw==
X-Received: by 2002:a63:1450:: with SMTP id 16mr13822220pgu.279.1607722064831;
        Fri, 11 Dec 2020 13:27:44 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:70e5])
        by smtp.gmail.com with ESMTPSA id g16sm11124221pfh.187.2020.12.11.13.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 13:27:43 -0800 (PST)
Date:   Fri, 11 Dec 2020 13:27:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH RFC bpf-next  2/4] bpf: support BPF ksym variables in
 kernel modules
Message-ID: <20201211212741.o2peyh3ybnkxsu5a@ast-mbp>
References: <20201211042734.730147-1-andrii@kernel.org>
 <20201211042734.730147-3-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211042734.730147-3-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 08:27:32PM -0800, Andrii Nakryiko wrote:
> During BPF program load time, verifier will resolve FD to BTF object and will
> take reference on BTF object itself and, for module BTFs, corresponding module
> as well, to make sure it won't be unloaded from under running BPF program. The
> mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
...
> +
> +	/* if we reference variables from kernel module, bump its refcount */
> +	if (btf_is_module(btf)) {
> +		btf_mod->module = btf_try_get_module(btf);

Is it necessary to refcnt the module? Correct me if I'm wrong, but
for module's BTF we register a notifier. Then the module can be rmmod-ed
at any time and we will do btf_put() for corresponding BTF, but that BTF may
stay around because bpftool or something is looking at it.
Similarly when prog is attached to raw_tp in a module we currently do try_module_get(),
but is it really necessary ? When bpf is attached to a netdev the netdev can
be removed and the link will be dangling. May be it makes sense to do the same
with modules?  The raw_tp can become dangling after rmmod and the prog won't be
executed anymore. So hard coded address of a per-cpu var in a ksym will
be pointing to freed mod memory after rmmod, but that's ok, since that prog will
never execute.
On the other side if we envision a bpf prog attaching to a vmlinux function
and accessing per-cpu or normal ksym in some module it would need to inc refcnt
of that module, since we won't be able to guarantee that this prog will
not execute any more. So we cannot allow dangling memory addresses.
If latter is what we want to allow then we probably need a test case for it and
document the reasons for keeping modules pinned while progs access their data.
Since such pinning behavior is different from other bpf attaching cases where
underlying objects (like netdev and cgroup) can go away.
