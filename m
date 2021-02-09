Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A85314918
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBIGtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhBIGtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 01:49:09 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503FFC061786;
        Mon,  8 Feb 2021 22:48:29 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id q7so17742901iob.0;
        Mon, 08 Feb 2021 22:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vn04CRRunlm4IYIn+hFYIf3vBeSbVNhIrnfDu+YIRzw=;
        b=eVobysR84m97DqPra7MIA+UI0+ln3PFHP4WxpcuZ0gky0kBMV2eu1mU0PTPlO3pxcn
         XwnnUwCryp8CtTNpqXGxSk1kp9law4NEYzOZlMZyQuB4p155bw9lKqBih28k8Ke+8I97
         sni4HrsBTmHlgKKdJzQQynwx9yg90YLPs2uQFcDNtt9UYyT8sppiekS+DOdLQLgqqwQa
         dEfcFegAu0vvhUUJhZqN8RNPplFtQ89LbGRKgHhpLHj3y7S/mFxDUbURskrrFFOw9hda
         v6+lKCnECOPNCkZ4S3lLrRZC4z3RMgt5hPo0/BR0EOkU1dJcCR6k183NSdUUIUhQaNYy
         WYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vn04CRRunlm4IYIn+hFYIf3vBeSbVNhIrnfDu+YIRzw=;
        b=IKr+zaKqrXvZGXrEgEb2xFrHfKYVmgmjxdFWdkFKAIQcDidYCGEwDbRo4MINXoXydh
         Uo33PPgPKYwnr3gRl38GkGybuVcnN1UaPH0DQ5ms6ItwCbA7qrOSKY3LQY44/0RPlwi8
         u82/TKe4XSWI0TrNIFXUQE729ga77dNey2lQBHwJ18dOrs3CZAreiccM2teCOVshArg8
         Rn2xcZwrmfq5bn0//QUNSzerCnAIFs0wzmnQl6NKQaPn178/wbGuu47m6A+PHLJlKhaN
         1nsaM/ki+94WCAAypIF1ePGjJvIaF/3q3yGrW6iEJoIb2p+mh+opuc+kq84+Q1jIKy76
         7+AA==
X-Gm-Message-State: AOAM533BmTm5P1urDKXPuL2zS3QxeRHsfTzkVKeJKT1f7t9c+yUOavbg
        cVM4jN9vcZwKDFLFbdGVBtg=
X-Google-Smtp-Source: ABdhPJyKsKhCvg49Tf/8tkPb/vgI7l3Iz9ERyXuTirX6u8MyskBSKq8KYj3HFyW2GmduF6BIHajJVw==
X-Received: by 2002:a02:e87:: with SMTP id 129mr20808060jae.34.1612853308682;
        Mon, 08 Feb 2021 22:48:28 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id t18sm9180400ioi.33.2021.02.08.22.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 22:48:27 -0800 (PST)
Date:   Mon, 08 Feb 2021 22:48:20 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6022303458ba9_13a65f208f7@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWu8PMbSTfsifBy9j9BLrMn69H2fFkjdRVpGGtbmUURFw@mail.gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-2-xiyou.wangcong@gmail.com>
 <6020f4793d9b5_cc86820866@john-XPS-13-9370.notmuch>
 <CAM_iQpWu8PMbSTfsifBy9j9BLrMn69H2fFkjdRVpGGtbmUURFw@mail.gmail.com>
Subject: Re: [Patch bpf-next 01/19] bpf: rename BPF_STREAM_PARSER to
 BPF_SOCK_MAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, Feb 8, 2021 at 12:21 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Before we add non-TCP support, it is necessary to rename
> > > BPF_STREAM_PARSER as it will be no longer specific to TCP,
> > > and it does not have to be a parser either.
> > >
> > > This patch renames BPF_STREAM_PARSER to BPF_SOCK_MAP, so
> > > that sock_map.c hopefully would be protocol-independent.
> > >
> > > Also, improve its Kconfig description to avoid confusion.
> > >
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> >
> > The BPF_STREAM_PARSER config was originally added because we need
> > the STREAM_PARSER define and wanted a way to get the 'depends on'
> > lines in Kconfig correct.
> >
> > Rather than rename this, lets reduce its scope to just the set
> > of actions that need the STREAM_PARSER, this should be just the
> > stream parser programs. We probably should have done this sooner,
> > but doing it now will be fine.
> 
> This makes sense, but we still need a Kconfig for the rest sockmap
> code, right? At least for the dependency on NET_SOCK_MSG?

Lets just enable NET_SOCK_MSG when CONFIG_BPF_SYSCALL is enabled. We
never put any of the other maps, devmap, cpumap, etc. behind an
explicit flag like this.

> 
> >
> > I can probably draft a quick patch tomorrow if above is not clear.
> > It can go into bpf-next outside this series as well to reduce
> > the 19 patches a bit.
> 
> I can handle it in my next update too, like all other feedbacks.

Great thanks. Especially because I haven't got to it yet today.

> 
> Thanks.


