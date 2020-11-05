Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5232A8A38
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgKEW5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbgKEW5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 17:57:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45F2E20719;
        Thu,  5 Nov 2020 22:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604617034;
        bh=4HiUMXFfTMWojhcYABhByqsUoN31oPzYLU2VOxm5slc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGASsWQxXe3caLLm/7vBWyqdqt8vB+YGs/iklalrGZY17PjESICpdi2+Ovy0wd5XA
         /Sx89fXIpP89yBg7H2BfL6qe1cWjTugPCWPWbrIo6YDgnQTmxuNapVP1XMwnxgsP1o
         kfst2YRAXM5dBv64fqz636++qSHj/37CuS31rDww=
Date:   Thu, 5 Nov 2020 14:57:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by
 default
Message-ID: <20201105145713.10af539e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEf4BzZgXO1Uv49cGQ6PMoe6gXiF8obJr9uKBTeE2MzzHEr=PA@mail.gmail.com>
References: <20200423195850.1259827-1-andriin@fb.com>
        <20201105170202.5bb47fef@redhat.com>
        <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com>
        <20201105135338.316e1677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEf4BzZgXO1Uv49cGQ6PMoe6gXiF8obJr9uKBTeE2MzzHEr=PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 14:41:12 -0800 Andrii Nakryiko wrote:
> On Thu, Nov 5, 2020 at 1:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 5 Nov 2020 13:22:12 -0800 Andrii Nakryiko wrote:  
> > > Should we just drop check_verifier_log() checks?  
> >
> > Drivers only print error messages when something goes wrong, so the
> > messages are high priority. IIUC this change was just supposed to
> > decrease verbosity, right?  
> 
> Seems like check_verifier_log() in test_offline.py is only called for
> successful cases. This patch truncates parts of the verifier log that
> correspond to successfully validated code paths, so that in case if
> verification fails, only relevant parts are left. So for completely
> successful verification the log will be almost empty, with only final
> stats available.

If you're saying the driver message would still be there if
verification or translation failed that's perfectly fine, we 
can definitely adjust the test. But some check that driver 
message reporting is working is needed, don't just remove it.

Sorry, don't have cycles to look closely :(
