Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2253F2E1773
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgLWDKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbgLWDKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 22:10:17 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8946FC0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 19:09:36 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id z20so9779735pgh.18
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 19:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IQ0Qx44OK2RIPX1fqXRvuwqi8v00WWJehzRQIJJdt78=;
        b=AQhzzeMPZiggsa1o0X5/do5St9pB5j+aXTO4iOUS/wNkLDaKFYWKzAXv8ucJ4/F9Fp
         2b+foY+J9e5BLzbQP8Ku6b5qLx5Mitv8IqD+HQDSd7n5jgv6Rc2B7h6J/18WA44S3z6D
         3/FjW+ApQW1VXk2Iq15qf26pMyRNDOtB6pFDph/T3aNSLYcjIAri7NlyWPHI6MchubCz
         ZatBHZTqfbFqlIPsLCFK1jNEMnMnEdhqbXx0NsHLkOzFxUgSPIp0bGRO7SRqINolaiTl
         vR7hWzPB4I1siF7IRtJiODh7ekcRtuIaC3TEa8mGr4gUwRpSVvr/Rt3FV9wN6JhJEP2G
         Lfkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IQ0Qx44OK2RIPX1fqXRvuwqi8v00WWJehzRQIJJdt78=;
        b=kgBGaoZwJwuistaRH1bvBeZshqfih48lrVR7Vk1LBulr0ga3ehu2Bm8ex9PlRk+260
         vz2KgVYEToHIZwmwcqs0rK0JrO8gA19iKyQmMkPw+7EnEg+TqGeA+UcCByBc5bNY1ybd
         h8vOhPiAkpQ9pGINQMDCIjYcEBrKsfM1fUPVE85W6iiiMixI19NN5ubdjP9sZF3xz+oJ
         +C/yJgXuo4mCwoQLCdvBgOR3IH8hpaH0yEo5uY8zZfa2jv6JOj0qP4XivTQAosqMD7pk
         9KsqNM5FDWsgeVrlNJtTM+NtksmRFfpgbQ+SsWQ1S556/AXwV98UmJ92mdHQ3aZPZVH+
         JQgQ==
X-Gm-Message-State: AOAM5300VdujTlbejS/2IpukbJfMI9/DdRgq+3eTluf/Pk66ZJxLwz1j
        7tz7nu3yhp71Qrp82ha6CJTVI44=
X-Google-Smtp-Source: ABdhPJwVsSI0uyG3ae/9ix2056ZV+FQPFFzi0mJagMNHlT91ie5sG+gzJ7BkeGUwkl9tVtXaJMYxMXM=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:90a:8b94:: with SMTP id
 z20mr162522pjn.1.1608692975589; Tue, 22 Dec 2020 19:09:35 -0800 (PST)
Date:   Tue, 22 Dec 2020 19:09:33 -0800
In-Reply-To: <20201222191107.bbg6yafayxp4jx5i@kafai-mbp.dhcp.thefacebook.com>
Message-Id: <X+K07Rh+2qECwxJp@google.com>
Mime-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com> <20201217172324.2121488-2-sdf@google.com>
 <20201222191107.bbg6yafayxp4jx5i@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22, Martin KaFai Lau wrote:
> On Thu, Dec 17, 2020 at 09:23:23AM -0800, Stanislav Fomichev wrote:
> > When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> > syscall starts incurring kzalloc/kfree cost. While, in general, it's
> > not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
> > TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> > fastpath for incoming TCP, we don't want to have extra allocations in
> > there.
> >
> > Let add a small buffer on the stack and use it for small (majority)
> > {s,g}etsockopt values. I've started with 128 bytes to cover
> > the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> > currently, with some planned extension to 64 + some headroom
> > for the future).
> >
> > It seems natural to do the same for setsockopt, but it's a bit more
> > involved when the BPF program modifies the data (where we have to
> > kmalloc). The assumption is that for the majority of setsockopt
> > calls (which are doing pure BPF options or apply policy) this
> > will bring some benefit as well.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/filter.h |  3 +++
> >  kernel/bpf/cgroup.c    | 41 +++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 42 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 29c27656165b..362eb0d7af5d 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -1281,6 +1281,8 @@ struct bpf_sysctl_kern {
> >  	u64 tmp_reg;
> >  };
> >
> > +#define BPF_SOCKOPT_KERN_BUF_SIZE	128
> Since these 128 bytes (which then needs to be zero-ed) is modeled after
> the TCP_ZEROCOPY_RECEIVE use case, it will be useful to explain
> a use case on how the bpf prog will interact with
> getsockopt(TCP_ZEROCOPY_RECEIVE).
The only thing I would expect BPF program can do is to return EPERM
to cause application to fallback to non-zerocopy path (and, mostly,
bypass). I don't think BPF can meaningfully mangle the data in struct
tcp_zerocopy_receive.

Does it address your concern? Or do you want me to add a comment or
something?
