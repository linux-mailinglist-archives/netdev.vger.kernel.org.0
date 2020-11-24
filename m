Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083692C1C22
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 04:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgKXDe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 22:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgKXDe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 22:34:26 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE15FC0613CF;
        Mon, 23 Nov 2020 19:34:26 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id y7so17076538pfq.11;
        Mon, 23 Nov 2020 19:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+PMZMazjUjzA1MdZzkJCDSzfyJuVVXVirLSFDB0A7JI=;
        b=RlPrxL3Rd+Dq33FrllMJfupdTEvl1ypBzlT6hShy0ltEmrvkQu1WLT6QtY3lUkrwK5
         Lw9lsygzCX/cbZVRuy/Q9/WD/6PUyzjs0pM5Iw5+giSpimUyUiKkjSaQ4mjYxiTfuvrS
         ShGm/Eg5ouYPyXisUUAc8gO1w2dSiFsPuvUngM6vnzzzfMicpt5wGmndI4lpNB6w3ONN
         fYH4BbD89WYimOWwiG3yWYKEeU0O8HmpQAVJ4T8pVaPwoK9iOnXGyOiRhyjLWO9vssOO
         8sMJ6hyQe7bcca/DUJ8mpbVKXdH55MxNrfpnZF3YhV/NzUABgHlSbQrM3PQgvGSsuArB
         x+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+PMZMazjUjzA1MdZzkJCDSzfyJuVVXVirLSFDB0A7JI=;
        b=oTpYpd/geaMZbjiE56TyTzKVIG5/U63EatwbtfDcrM8+l5g+YUTTS0SMNz5gS2RWW1
         uhxYOCBICrJ3aBLng2RmQXX/fLSBqDzhz1OnlMTL1LYGAlSncnqAX6WsZEjMR435EbNn
         8si82RGLwwtmbZ1HKHAj6gtTwD2kvgxXoCCoKZwJUF6sxPycLUAYjliYw8o6hqq9lbeN
         Y1lqvo5n9m406Pd0oM+W34E7iRz7zS6djinhKh8AGw6Q5JQoBZCoMfnR4iQQ1gz1Iidn
         EaHEKMY7H/cp4wkxoIFgVtXyY+OH55p3ps1TCHzRHVWMaxMA5uSATB8IQxz9Wl36i4E9
         kt7Q==
X-Gm-Message-State: AOAM530k+E0TGgaGNe1yPsfB983C73KiZfo9SeeoRFTy2Cs3zEocbPTM
        mXxxDnQMqmJSR4sxIlwSvjk=
X-Google-Smtp-Source: ABdhPJw0N8WoGcnn2MhwgL8AEQcbABbOzvzhogJZD/YqPYOCBKJcKAGmU26LcDjzNVR3wTlU+T4qhw==
X-Received: by 2002:a63:4605:: with SMTP id t5mr2083019pga.244.1606188866158;
        Mon, 23 Nov 2020 19:34:26 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:2397])
        by smtp.gmail.com with ESMTPSA id a12sm825896pjh.48.2020.11.23.19.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 19:34:25 -0800 (PST)
Date:   Mon, 23 Nov 2020 19:34:22 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Lukas Wunner <lukas@wunner.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20201124033422.gvwhvsjmwt3b3irx@ast-mbp>
References: <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
 <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
 <20201011082657.GB15225@wunner.de>
 <20201121185922.GA23266@salvia>
 <CAADnVQK8qHwdZrqMzQ+4Q9Cg589xLX5zTve92ZKN_zftJg_WHw@mail.gmail.com>
 <20201122110145.GB26512@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201122110145.GB26512@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 12:01:45PM +0100, Pablo Neira Ayuso wrote:
> Hi Alexei,
> 
> On Sat, Nov 21, 2020 at 07:24:24PM -0800, Alexei Starovoitov wrote:
> > On Sat, Nov 21, 2020 at 10:59 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > We're lately discussing more and more usecases in the NFWS meetings
> > > where the egress can get really useful.
> > 
> > We also discussed in the meeting XYZ that this hook is completely pointless.
> > Got the hint?
> 
> No need to use irony.
> 
> OK, so at this point it's basically a bunch of BPF core developers
> that is pushing back on these egress support series.
> 
> The BPF project is moving on and making progress. Why don't you just
> keep convincing more users to adopt your solution? You can just
> provide incentives for them to adopt your software, make more
> benchmarks, more documentation and so on. That's all perfectly fine
> and you are making a great job on that field.
> 
> But why you do not just let us move ahead?
> 
> If you, the BPF team and your users, do not want to use Netfilter,
> that's perfectly fine. Why don't you let users choose what subsystem
> of choice that they like for packet filtering?
> 
> I already made my own mistakes in the past when I pushed back for BPF
> work, that was wrong. It's time to make peace and take this to an end.

Please consider using bpf egress for what you want to accomplish.
k8s networking is a great goal. It's challenging, since it demands more from
the kernel than the existing set of hardcoded features provide. Clearly you
cannot solve it with in-kernel iptables/nft and have to use out-of-tree kernel
modules that plug into netfilter hooks. The kernel community always had and
always will have a basic rule that the kernel does not add APIs for out-of-tree
projects. That's why the kernel is so successful. The developers have to come
back to the kernel community. nft egress hook is trying to cheat its way in by
arguing its usefulness for some hypothetical case. If it was not driven by
out-of-tree kernel module I wouldn't have any problem with it. nft egress is
not a normal path of kernel development. It's a missing hook for out-of-tree
module. That's why it stinks so much.
So please consider augmenting your nft k8s solution with a tiny bit of bpf.
bpf can add a new helper to call into nf_hook_slow(). The helper would be
equivalent to "int nf_hook_ingress(struct sk_buff *skb)" function. With tiny
bpf prog you'll be able to delegate skb processing to nft everywhere where bpf
sees an skb. That's a lot more places than tc-egress.
