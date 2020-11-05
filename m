Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E982A8447
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbgKEQ6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730862AbgKEQ6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:58:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5683A2073A;
        Thu,  5 Nov 2020 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604595500;
        bh=WPfKbYRANsaYY5+y24dfY+e9RC7MfQyTqEBf6L+3aEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZH2FZ7NzGwDzL2Er6PUXZVBDRy83tC97s/FO6GPnUd/nmdTIXGPib4KGpPYhAEB6t
         qegoWzpJgUEUXW7lz3lnfMtK3ZPE0ZVOhz8xiBliQeK8B08zvX4+6gK4u2WQvj4MgQ
         wB/htahwttIct/GH6qQWrodaV+WODv+klzsRNeRM=
Date:   Thu, 5 Nov 2020 08:58:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kernel-team@fb.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [RFC PATCH bpf-next 4/5] bpf: load and verify kernel module
 BTFs
Message-ID: <20201105085818.4f20f3ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105164616.GA1201462@kroah.com>
References: <20201105045140.2589346-1-andrii@kernel.org>
        <20201105045140.2589346-5-andrii@kernel.org>
        <20201105083925.68433e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201105164616.GA1201462@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 17:46:16 +0100 Greg Kroah-Hartman wrote:
> On Thu, Nov 05, 2020 at 08:39:25AM -0800, Jakub Kicinski wrote:
> > On Wed, 4 Nov 2020 20:51:39 -0800 Andrii Nakryiko wrote:  
> > > Add kernel module listener that will load/validate and unload module BTF.
> > > Module BTFs gets ID generated for them, which makes it possible to iterate
> > > them with existing BTF iteration API. They are given their respective module's
> > > names, which will get reported through GET_OBJ_INFO API. They are also marked
> > > as in-kernel BTFs for tooling to distinguish them from user-provided BTFs.
> > > 
> > > Also, similarly to vmlinux BTF, kernel module BTFs are exposed through
> > > sysfs as /sys/kernel/btf/<module-name>. This is convenient for user-space
> > > tools to inspect module BTF contents and dump their types with existing tools:  
> > 
> > Is there any precedent for creating per-module files under a new
> > sysfs directory structure? My intuition would be that these files 
> > belong under /sys/module/  
> 
> Ick, why?  What's wrong with them under btf?  The module core code
> "owns" the /sys/modules/ tree.  If you want others to mess with that, 
> it will get tricky.

It's debug info, that's where I would look for it. 

Clearly I'd be wrong to do so :)
