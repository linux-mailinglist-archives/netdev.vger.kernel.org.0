Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BF01CEAEA
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 04:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgELCgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 22:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgELCgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 22:36:47 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7472C061A0C;
        Mon, 11 May 2020 19:36:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l12so5454332pgr.10;
        Mon, 11 May 2020 19:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DwkcJJkezbH+OWBWg9sYsAUeeDyjJOTxj4zpwJqjZ4E=;
        b=sdbzlbOrjwmsl7fIXziSB8ouemN32bhCfJlEE6Sb535bIEHiOXnhG0vJ8BglktXAQF
         DjDnLRrV/hTUFqc/+1SwtkVG+iElBYtklhABoqPNchhrBpY5bG1HeOzNMaxDKtafkGJz
         SI/96Du+EZJcc5EKDdlibWvR3pEuiNXjBM7uBqoy6jWkDOoNl7jTczW0+ugbwf6iNRCa
         GWAXIFKWjIRGb3pCug4Doqdd6hB5f6ZgOWWtIgNVO0KOG7VwkYQFy3YrD9lRjBPGcds3
         mitjPhb1BwwfVacawQtR+gaNv0omphZMC4G/+KD3Cci9ehu4UxkXDlXzlBzSPk95HW5e
         EIaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DwkcJJkezbH+OWBWg9sYsAUeeDyjJOTxj4zpwJqjZ4E=;
        b=LBzFidtk7XcOFvddkWx4qFh73qTpQzE1dymMrI+10lEcfkCJgcpbHRw+i4ddRbQSGt
         3v7vjyCFudxqlCxpJokiczcxO+Atw1K+PlxGKq0ynQ+WIoj7MpauqSswbMMpjbTV/7kl
         LShja888QVlcQXbcoPal3V2zV0n/KQqkBtlErmxIRlbdP/gpod+wYaDf3XB9GCXPO/VX
         i8RGKldtkrnSaJWoMT0FvCUfFDbHzdSFkG9qnqWa4eq8j5dg34VZN3XTPJWy3WO1WVtZ
         6TqcfsiwiMnSIH3YcLFsVzlldsWMszkXMT3tRfZ9iF6PUZfCw+yBPImFNvxBWF7zTyGg
         kcuQ==
X-Gm-Message-State: AGi0PuZliJsu8GD7SXRyxl9bm5AqCWFQPCqcr6yUFhI4y6C0HMfA0zDP
        Y0nYR7gKHXmT0gevV/5elu4=
X-Google-Smtp-Source: APiQypKl87mtTb2xr/0j9uvsdmMZKI3mlnm59JiOJrw2mZvT9j/EGTWcVTvVe1f6mfoH6pUosYlzGQ==
X-Received: by 2002:a63:6d86:: with SMTP id i128mr10798050pgc.432.1589251006272;
        Mon, 11 May 2020 19:36:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1c7e])
        by smtp.gmail.com with ESMTPSA id a200sm10217618pfa.201.2020.05.11.19.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 19:36:45 -0700 (PDT)
Date:   Mon, 11 May 2020 19:36:41 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     sdf@google.com
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20200512023641.jupgmhpliblkli4t@ast-mbp.dhcp.thefacebook.com>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <20200512001210.GA235661@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512001210.GA235661@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:12:10PM -0700, sdf@google.com wrote:
> On 05/08, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> [..]
> > @@ -3932,7 +3977,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr
> > __user *, uattr, unsigned int, siz
> >   	union bpf_attr attr;
> >   	int err;
> 
> > -	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> > +	if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
> >   		return -EPERM;
> This is awesome, thanks for reviving the effort!
> 
> One question I have about this particular snippet:
> Does it make sense to drop bpf_capable checks for the operations
> that work on a provided fd?

Above snippet is for the case when sysctl switches unpriv off.
It was a big hammer and stays big hammer.
I certainly would like to improve the situation, but I suspect
the folks who turn that sysctl knob on are simply paranoid about bpf
and no amount of reasoning would turn them around.

> The use-case I have in mind is as follows:
> * privileged (CAP_BPF) process loads the programs/maps and pins
>   them at some known location
> * unprivileged process opens up those pins and does the following:
>   * prepares the maps (and will later on read them)
>   * does SO_ATTACH_BPF/SO_ATTACH_REUSEPORT_EBPF which afaik don't
>     require any capabilities
> 
> This essentially pushes some of the permission checks into a fs layer. So
> whoever has a file descriptor (via unix sock or open) can do BPF operations
> on the object that represents it.

cap_bpf doesn't change things in that regard.
Two cases here:
sysctl_unprivileged_bpf_disabled==0:
  Unpriv can load socket_filter prog type and unpriv can attach it
  via SO_ATTACH_BPF/SO_ATTACH_REUSEPORT_EBPF.
sysctl_unprivileged_bpf_disabled==1:
  cap_sys_admin can load socket_filter and unpriv can attach it.

With addition of cap_bpf in the second case cap_bpf process can
load socket_filter too.
It doesn't mean that permissions are pushed into fs layer.
I'm not sure that relaxing of sysctl_unprivileged_bpf_disabled
will be well received.
Are you proposing to selectively allow certain bpf syscall commands
even when sysctl_unprivileged_bpf_disabled==1 ?
Like allow unpriv to do BPF_OBJ_GET to get an fd from bpffs ?
And allow unpriv to do map_update ? 
It makes complete sense to me, but I'd like to argue about that
independently from this cap_bpf set.
We can relax that sysctl later.
