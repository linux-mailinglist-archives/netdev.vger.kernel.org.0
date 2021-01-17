Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954EE2F953E
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 21:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbhAQUsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 15:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbhAQUsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 15:48:22 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87A2C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 12:47:41 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id v126so16999384qkd.11
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 12:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JSxb8mAjtf73HAJnuKCga/w+CjRYv/0muMod1GWSJPY=;
        b=cl3FDzftgSFOXMguYAeuD4yPYJ0f8JcCB0jd0DXTmHQJXp78yXvqVD+hxEP3n0S5cO
         b84fLnJWwju3W8zdB6xR0vOzPUcWKjodX5qz8TdQ76X+9NoMx25Onsg6ecXPF1x7kfNP
         zWdz8CVRKjvgvBOE3kKE3Gf6cpn8sycXANZaF61fcT8Rag5cQhdfpWF2Vkec5p9urAp0
         1o/4tu30CgTiqKlbBW40QDFKjqADmYrSXdUXgdyK7/UJUvz09EIt8UAwkGDTy9Np5GGF
         Oeem2Cphc++KrAaaY2Wo+P1oiUXbIYtIytVVODoCTJwNh4h46LiGtiWkJb+CD0fBQNVo
         eQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JSxb8mAjtf73HAJnuKCga/w+CjRYv/0muMod1GWSJPY=;
        b=K1SPpeoGY9Oqq156z3BEGihTDdptbNDiI9D1/jCSNwyQ9NXRV8Yak1Tl+pCn1Y6EPs
         U/EtIny+k5oVYy6PDgXGT8mHoQ1ugp3rwsEdgLDyPxjMDnhg5P/NqZffpFLkpdB9byne
         7qnE51YoxEXhl9WZYLaFZGVfNty4Jr2sGC1a5rvLGxqUZ1/+hrrM3lWnbfvKGEJ9NBGV
         tTNBIykJ+g2jbs3CTPYrPdDpbwzaUexYM2KxO11S5Qbbauy4oh+NrPxQz7gJnQwnc0jV
         h1+XTXZwjYGYA/pZjS1ztHTE5Kd+Xwt0bf5DoBo0CJgYXYc4Zcae25aQqy23FMkyzWSS
         Z6ag==
X-Gm-Message-State: AOAM530FCeaaMDrXDywuIFQT3rcH+Bp8hhE/ImRTqCRUNSv25eGu7PKL
        TYp4+uoom0Kh5Y5UBPcLOp8wuoBRYH42+v8Or7c=
X-Google-Smtp-Source: ABdhPJxR+e3KcK3pBlAAxfsBRkRwvJuUo5eHSt6DWYd8N4JltdBLhN70+xLRUNwXNavBwvzoODXhF0tt3yUixFviUQs=
X-Received: by 2002:a37:5a45:: with SMTP id o66mr21530542qkb.446.1610916460986;
 Sun, 17 Jan 2021 12:47:40 -0800 (PST)
MIME-Version: 1.0
References: <20210110070021.26822-1-pbshelar@fb.com> <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
In-Reply-To: <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 17 Jan 2021 12:47:30 -0800
Message-ID: <CAOrHB_CvFV1K2J_v1L50Q=zhiTVH3maq4tyzskVmyP-di-wXtw@mail.gmail.com>
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling API
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 5:25 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Jakub,
>
> On 17/01/2021 01:46, Jakub Kicinski wrote:
> > On Sat,  9 Jan 2021 23:00:21 -0800 Pravin B Shelar wrote:
> >> Following patch add support for flow based tunneling API
> >> to send and recv GTP tunnel packet over tunnel metadata API.
> >> This would allow this device integration with OVS or eBPF using
> >> flow based tunneling APIs.
> >>
> >> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
> >
> > Applied, thanks!
> >
>
> This patch hasn't received any ACK's from either the maintainers or
> anyone else providing review.  The following issues remain unaddressed
> after review:
>
This patch was first sent out on Dec 10 and you responded on Dec 11. I
think there was a reasonable amount of time given for reviews.

> i)  the patch contains several logically separate changes that would be
> better served as smaller patches
Given this patch is adding a single feature, to add support for LWT, I
sent a single patch. Now sure how much benefit it would be to divide
it in smaller patches. In future I will be more careful with dividing
the patch, since that is THE objection you have presented here.

> ii) functionality like the handling of end markers has been introduced
> without further explanation
This is the first time you are raising this question. End marker is
introduced to handle these packets in a single LWT device. This way
the control plane can use a single device to program all GTP
user-plane functionality.

> iii) symmetry between the handling of GTPv0 and GTPv1 has been
> unnecessarily broken
This is already discussed in previous review: Once we add support for
LWT for v0, we can get symmetry between V1 and V0. At this point there
is no use case to use V0 in LWT, so I do not see a point introducing
the support.

> iv) there are no available userspace tools to allow for testing this
> functionality
>
This is not true. I have mentioned and provided open source tools
multiple times on review tread:

Patch for iproute to add support for LWT GTP devices.
https://github.com/pshelar/iproute2/commit/d6e99f8342672e6e9ce0b71e153296f8e2b41cfc

OVS support with integration test:
https://github.com/pshelar/ovs/blob/6ec6a2a86adc56c7c9dcab7b3a7b70bb6dad35c9/tests/system-layer3-tunnels.at#L158


> I have requested that this patch be reworked into a series of smaller
> changes.  That would allow:
>
> i) reasonable review
> ii) the possibility to explain _why_ things are being done in the patch
> comment where this isn't obvious (like the handling of end markers)
> iii) the chance to do a reasonable rebase of other ongoing work onto
> this patch (series):  this one patch is invasive and difficult to rebase
> onto
>
> I'm not sure what the hurry is to get this patch into mainline.  Large
> and complicated patches like this take time to review; please revert
> this and allow that process to happen.
>

Rather than reverting this patch, I can handle comments you have
posted. Those can be fixed by minor incremental patches.

Let me know if you find any regression introduced by this patch set, I
can quickly fix it.

Thanks,
Pravin.
