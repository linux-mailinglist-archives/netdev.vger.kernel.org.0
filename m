Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E05338B4B1
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhETQ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 12:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhETQ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 12:57:04 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3675C061574;
        Thu, 20 May 2021 09:55:42 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id o8so20677680ljp.0;
        Thu, 20 May 2021 09:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DX5kfwEY++tWLEgIovywxWgnoHHrEkUMGi91clMC9j4=;
        b=J7/KciBuAZz4srEnNnajNDID4n8DZdIWeVmnAsTNdjAGzuxIuiHcZjab2IbT8GAa7c
         gxmNIRYS14432rY7WognRY6BJOUzt9m4WdhHdo120YA+ASOm+6jvirSmCow183SR7pY0
         RW9ZLMIEjCMQDhKmmndhc1OCDWFvkP2I2aeshUOASKrvcttpiv3xbaGsrnsdq5i/la1v
         Q2RTl5p9QGyfNk9cV0VY3IZuav/Z2e2QR07cvaNnOCICn0we9bCCETC+Y6MorOb7yQNy
         Wi6L9IEXlBtjsB60Oln6mbYUd9kD09CqsN6Cg5PEunc413zy+SAE5Tyd/lGmWQ22IEbV
         12Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DX5kfwEY++tWLEgIovywxWgnoHHrEkUMGi91clMC9j4=;
        b=oS8D+hx8I3RQk5ZVldvvLpxp7BcEcRGFvQw+3DfVQ80W+VrAnkuHf93x3A42Gztry/
         6QvI03Y+DndDFlKYg9R6x7zwn7zXVWb8vtP644KobtuWE5Y49kDKv8QQDpKv9jzdzlnZ
         WfXmH1G/bPj5W8EF1siF/aVQRpUsERKW/R0NlHvzGVkkSsve/9SVWC77TSqDkAMJw2jW
         DzVFaFvZ4iZFxXi8+m6Y6x5RmfbsOiRuOt+3qhjNKuqhuYK37RHfZJu2FMfssxoJ83Cc
         53U5OIVFAlo0BE+68kMn+vgNbk7MiL3K3rjvRgUc5TGG90pJGJpU8BfgRFy/SRLNrNuY
         ufAw==
X-Gm-Message-State: AOAM530lXFsz0pX6+MoT7wFxT1pmW/sTQGdEPad5CqIRperzwJa7frnK
        gCg0dZoVg+lWUsTmal1fe/ilVg3uEslROFYzcGI=
X-Google-Smtp-Source: ABdhPJwgXSGvDn9Izyu4l5D+kOWJCOAw/2AIyJHNB9uFfwb1BUzocc9jhU5mKAtrV6So0yjZozRYJWkhf1jvYwJdY/8=
X-Received: by 2002:a2e:5813:: with SMTP id m19mr3745793ljb.258.1621529741111;
 Thu, 20 May 2021 09:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210517225308.720677-1-me@ubique.spb.ru> <7312CC5D-510B-4BFD-8099-BB754FBE9CDF@fb.com>
 <20210520075323.ehagaokfbazlhhfj@amnesia>
In-Reply-To: <20210520075323.ehagaokfbazlhhfj@amnesia>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 May 2021 09:55:29 -0700
Message-ID: <CAADnVQJbxTikruisH=nfsFrC1UZW5zTXr8bUrL+U0jMBSApTTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/11] bpfilter
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     Song Liu <songliubraving@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 12:53 AM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> On Thu, May 20, 2021 at 04:54:45AM +0000, Song Liu wrote:
> >
> >
> > > On May 17, 2021, at 3:52 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> > >
> > > The patchset is based on the patches from David S. Miller [1] and Daniel
> > > Borkmann [2].
> > >
> > > The main goal of the patchset is to prepare bpfilter for iptables'
> > > configuration blob parsing and code generation.
> > >
> > > The patchset introduces data structures and code for matches, targets, rules
> > > and tables.
> > >
> > > It seems inconvenient to continue to use the same blob internally in bpfilter
> > > in parts other than the blob parsing. That is why a superstructure with native
> > > types is introduced. It provides a more convenient way to iterate over the blob
> > > and limit the crazy structs widespread in the bpfilter code.
> > >
> >
> > [...]
> >
> > >
> > >
> > > 1. https://lore.kernel.org/patchwork/patch/902785/
> >
> > [1] used bpfilter_ prefix on struct definitions, like "struct bpfilter_target"
> > I think we should do the same in this version. (Or were there discussions on
> > removing the prefix?).
>
> There were no discussions about it.
> As those structs are private to bpfilter I assumed that it is
> safe to save some characters.
> I will add the prefix to all internal structs in the next
> iteration.

For internal types it's ok to skip the prefix otherwise it's too verbose.
In libbpf we skip 'bpf_' prefix in such cases.
