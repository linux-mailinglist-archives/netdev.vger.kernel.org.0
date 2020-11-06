Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7FC2A9CB9
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgKFSwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgKFSww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 13:52:52 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27FE206E3;
        Fri,  6 Nov 2020 18:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604688771;
        bh=36lQSTS5YWFqi9u4N7E4DAxiPQZmprr6WyIWZh4ETD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c6J1aMIp9jicpyUDgyFUmoY410GoHqajCStJqmQ+zhds/Rc7DWwEgKHq2L05rVI71
         Fakhieij8rtauaoxjtfdb47P5SlkNMv97ycFtIYPdt3rocLMNLpNomJIgebGLnTZ3j
         kP7yAHsSRQbUtuUlxE8+0UJu2ba10tr0BYD0jF0Q=
Date:   Fri, 6 Nov 2020 10:52:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by
 default
Message-ID: <20201106105249.6b0674a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106092448.5c14808c@redhat.com>
References: <20200423195850.1259827-1-andriin@fb.com>
        <20201105170202.5bb47fef@redhat.com>
        <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com>
        <20201105135338.316e1677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEf4BzZgXO1Uv49cGQ6PMoe6gXiF8obJr9uKBTeE2MzzHEr=PA@mail.gmail.com>
        <20201105145713.10af539e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201106092448.5c14808c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 09:24:48 +0100 Jiri Benc wrote:
> On Thu, 5 Nov 2020 14:57:13 -0800, Jakub Kicinski wrote:
> > If you're saying the driver message would still be there if
> > verification or translation failed that's perfectly fine, we 
> > can definitely adjust the test. But some check that driver 
> > message reporting is working is needed, don't just remove it.  
> 
> Should we change the test to fail the verification? Sounds reasonable
> to me.

Yeah, you'd need a new debugfs knob in netdevsim to trigger the failure
from instruction verification, then (to match where message is printed).
And make the output validation a separate case, not just a check in
some random success load.
