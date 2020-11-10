Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45072AD6F7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 13:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbgKJM6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 07:58:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729898AbgKJM6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 07:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605013119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z+WGCssdGA3YCRbCIXVl6tCa62lOfUTtuf06k0ZXFFU=;
        b=fieMZXO4XUe/9jY0fkJ72rFyqvvmT2wI1sj2ZSWEtYRZNX+Cdju969PSgfs/ct3dQOdTGH
        3q/uLGLM7Zmkl7vWlG2ta2es0UlJ6LlpGCGs+4zsP1jWqZ2XismspmfEwjcYmAc44opwZZ
        cYiU/471vkxAX8JADqKJcUYSbMGu3sM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-902bVExHOPqT_ml-POxNbw-1; Tue, 10 Nov 2020 07:58:37 -0500
X-MC-Unique: 902bVExHOPqT_ml-POxNbw-1
Received: by mail-wm1-f71.google.com with SMTP id s3so1228386wmj.6
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 04:58:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z+WGCssdGA3YCRbCIXVl6tCa62lOfUTtuf06k0ZXFFU=;
        b=r+Ix/AfQV/LBexXiUc/Usk2gFydxle2P86YuBAxFNAGB3HPArEHNcmM750xB2/pROe
         IVPfYUGeLZQonFDvp8zjmSKa6YRNx1yH36KdOQdUIggs5+3cLVeZf/32E9ve6dx83dBa
         Rn91gd0+953eayjkf/km/cQ1HTBSFMYc/FF0Tvpkw0MUglugImIsL7J8ZVmxJp/WaST0
         fGCX5cZrJB7CPoJgRv1+UszwWGNe+nwuuNaXzjOPylMWx0si1VdTUiNsBHTLbT3E3nmP
         a7ZZNhoBwWHmtHJZfkhX5FK20Zvvq9YevbXa+2JZtCsQwjtzTVH48QPjTV2c5x9OPEna
         eS+A==
X-Gm-Message-State: AOAM532891YPYRIGU3POf6nCxM2H3WpOri6enksbGpMGQFztNWxmxIUN
        keb9Ur3SXtjff8Q8nDwN0iLWdQnfIQ44HMCfxpQdew/Mpbkz3AU8EfbNEY3qAscT+wfVStqG6C2
        03qEnKYQEsNb+Gfa4s31fWxNheXgVJC1F
X-Received: by 2002:adf:f2c7:: with SMTP id d7mr20288493wrp.142.1605013116310;
        Tue, 10 Nov 2020 04:58:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweC6IjK+j8sEdC2btLJnlZh8JURX/2BOwz0WpCtJjLKFEyNn9FcQYtGZXXMP66pt+rSaE1GwNqxHeCPjfvT9k=
X-Received: by 2002:adf:f2c7:: with SMTP id d7mr20288476wrp.142.1605013116071;
 Tue, 10 Nov 2020 04:58:36 -0800 (PST)
MIME-Version: 1.0
References: <20201109072930.14048-1-nusiddiq@redhat.com> <20201109213557.GE23619@breakpoint.cc>
 <CAH=CPzqTy3yxgBEJ9cVpp3pmGN9u4OsL9GrA+1w6rVum7B8zJw@mail.gmail.com> <20201110122542.GG23619@breakpoint.cc>
In-Reply-To: <20201110122542.GG23619@breakpoint.cc>
From:   Numan Siddique <nusiddiq@redhat.com>
Date:   Tue, 10 Nov 2020 18:28:24 +0530
Message-ID: <CAH=CPzqRKTfQW05UxFQwVpvMSOZ7wNgLeiP3txY8T45jdx_E5Q@mail.gmail.com>
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp flag
 - BE_LIBERAL per-ct basis.
To:     Florian Westphal <fw@strlen.de>
Cc:     ovs dev <dev@openvswitch.org>, netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 5:55 PM Florian Westphal <fw@strlen.de> wrote:
>
> Numan Siddique <nusiddiq@redhat.com> wrote:
> > On Tue, Nov 10, 2020 at 3:06 AM Florian Westphal <fw@strlen.de> wrote:
> > Thanks for the comments. I actually tried this approach first, but it
> > doesn't seem to work.
> > I noticed that for the committed connections, the ct tcp flag -
> > IP_CT_TCP_FLAG_BE_LIBERAL is
> > not set when nf_conntrack_in() calls resolve_normal_ct().
>
> Yes, it won't be set during nf_conntrack_in, thats why I suggested
> to do it before confirming the connection.

Sorry for the confusion. What I mean is - I tested  your suggestion - i.e called
nf_ct_set_tcp_be_liberal()  before calling nf_conntrack_confirm().

 Once the connection is established, for subsequent packets, openvswitch
 calls nf_conntrack_in() [1] to see if the packet is part of the
existing connection or not (i.e ct.new or ct.est )
and if the packet happens to be out-of-window then skb->_nfct is set
to NULL. And the tcp
be flags set during confirmation are not reflected when
nf_conntrack_in() calls resolve_normal_ct().


>
> > Would you expect that the tcp ct flags should have been preserved once
> > the connection is committed ?
>
> Yes, they are preserved when you set them after nf_conntrack_in(), else
> we would already have trouble with hw flow offloading which needs to
> turn off window checks as well.

Looks they are not preserved for the openvswitch case. Probably
openvswitch is doing something wrong.
I will debug further and see what is going on.

Please let me know if you have any further comments.

Thanks
Numan

>

