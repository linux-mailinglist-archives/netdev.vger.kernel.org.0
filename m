Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DAD3DE550
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 06:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhHCE1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 00:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbhHCE0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 00:26:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBA8C061764
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 21:26:40 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so2179213pjs.0
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 21:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1ViiRFeieBGUG6LLmINz1h8G+qFupL4upaV9eKwjvk=;
        b=gA9ggEAYgE9x8XO7Qo2NLx4eQS5U2wTar10ZRL1Hl879fZOrY9w2SGUGq3O6xcs/y1
         M/Z745CoyZOO6wz4Jl0bq0jIy2rcvoMnt2kH2phIUvLou+rFbsCje1XCh7bjK15GjHrO
         v1TIrD0A7wYiONKgwl2J+fU7EBf7FEMtZfdHL/sddV+htgvYUx9uxMdQRGmyDEAxxkDd
         /7s0X4Q745O8wgcBGy9cSGS0kJKMcAckHC1ogSTK7ZvIy2FbwsrRji0ap7D94SUh6vcz
         i0UayIO8gYaWRXwwB8m4w+vxgYQ+R3PelPJNfgqj/GBhtCwWJYBmcZha4eSl1zNkhQVX
         Vnyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1ViiRFeieBGUG6LLmINz1h8G+qFupL4upaV9eKwjvk=;
        b=RAJmiP/c7t8WifmaJdv3eyDXWJgduK3bi4cNwdoqpgfdADHL/d8VzC3Wqbtt/StlVe
         idzpdCS2PxpcHD3hNiV4ugviS6Z7DwZBWJ1E7VdJT7DY3eYaEZj0HdTyvOXFeqL+JoXj
         ptb/jhodVZvot4Rv93u7cZRHG1py4OmOKs+gOkc1gJbWoTGMHn24Iywvp424/V+iseQa
         1/njv4bs2SpVrzSO5N93EsBjcenj4Zb/eYOugPfO+t3ABmzXzwQn5jPf+u982MyI3G4k
         19wD2dQVfmbPf+bJolxkd91PAUXVnd050T7qRIEILZBoT8OPrN0N/eypdWkQgSZLc7Jb
         AYTw==
X-Gm-Message-State: AOAM532vq0kTEOpYnVsYUm3PC4iEzwb7nWTwZ2NCX5SxTzN3kT8hQpm4
        zpECIHNAVAov2W4nIRnd/1DMIUmoKMq95/Dsnc0=
X-Google-Smtp-Source: ABdhPJxQlKbKo3QzVs78axRstlmlMs98o0kH+PcdRBUvtbHIWhKYRkS4Y0MQkbujqARQoyHgJpalwMG2jp0kiwWQCG0=
X-Received: by 2002:a17:90a:b10f:: with SMTP id z15mr11338128pjq.56.1627964798109;
 Mon, 02 Aug 2021 21:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
 <CAM_iQpU--x8PRprG8W6btdXFBr0bNnYaJF6CorELmK+tOgry=Q@mail.gmail.com> <YQRSlETLgowgik2x@dcaratti.users.ipa.redhat.com>
In-Reply-To: <YQRSlETLgowgik2x@dcaratti.users.ipa.redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 2 Aug 2021 21:26:26 -0700
Message-ID: <CAM_iQpVDyPdpm--L6iEzg4AxBsL6F0cF2EHzBPSCO-H5_Yqu8A@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: store the last executed chain also
 for clsact egress
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 12:28 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> hello Cong, thanks for looking at this!
>
> On Wed, Jul 28, 2021 at 03:16:02PM -0700, Cong Wang wrote:
> > On Wed, Jul 28, 2021 at 11:40 AM Davide Caratti <dcaratti@redhat.com> wrote:
> > >
> > > currently, only 'ingress' and 'clsact ingress' qdiscs store the tc 'chain
> > > id' in the skb extension. However, userspace programs (like ovs) are able
> > > to setup egress rules, and datapath gets confused in case it doesn't find
> > > the 'chain id' for a packet that's "recirculated" by tc.
> > > Change tcf_classify() to have the same semantic as tcf_classify_ingress()
> > > so that a single function can be called in ingress / egress, using the tc
> > > ingress / egress block respectively.
> >
> > I wonder if there is any performance impact with this change? As
> > tcf_classify() now may allocate skb ext (tc_skb_ext_alloc()) too,
> > right after __tcf_classify().
> >
> > Thanks.
>
> I think there is some performance drop for users that activate
> TC_SKB_EXT, in case packet doesn't match the filter *and* last
> executed_chain is non-zero. But in this case, I also think it's a good
> choice to spend some cycles to save the chain id in the extension: I
> might be wrong, but AFAIK openvswitch is the only "user" that configures
> TC in this way.
>
> Do you have in mind a specific case where performance can be degraded
> because of this commit? if so, I can try to investigate more.

I do not have any case, just want a double check here in case of any
performance regression.

Thanks for checking it.
