Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A19196317
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 03:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgC1C0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 22:26:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34629 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgC1C0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 22:26:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id a23so4196097plm.1;
        Fri, 27 Mar 2020 19:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ShH8XROG1X5PFwTbpMrwC/lGCcx0Zfv6MQbEm/P5Nus=;
        b=gMBCXAZWpcG/L5NoGx8B/0PzX5LHyaskyZE7T/ZdvEI+OEdOJ9jBRKsR6fYPVL4m6q
         2fNPUazpQVZC8Xd08ylYM8oaosAm2VSlro9LAEUxT74ZXhjpry0Y23e561wbe0vaJW79
         dfuAInKzxA2PsIa5CQpSlY+wC9pETeCwX3A4uylOY8GwBtprxGZ3Uhl5lhHX55yTBe25
         LXgKc+8hVlseb/w2F1Z1aLnjFybo1XdndT1hbbl6DVtMTZNwhNBJZYV5xZKoUP05lc3G
         J/vNWV356UJSh6Yoh5fddvFrKBTVo05VkQ0poQ5ry5heVCIv/W7ClwqOoStCs1yFgFwm
         XwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ShH8XROG1X5PFwTbpMrwC/lGCcx0Zfv6MQbEm/P5Nus=;
        b=jLF7z+DtIAmJSMz8dFaUGPx4d8PUckBLPkVSz4yC3/YHLj/VbYClDHqlTtjKTn0gPX
         Q9i1Z1hZ2VVXXfaq71iYm6mrfrf9A8mUb7SsYNzDBoBr7Nstad7gKKoGWN+SwvQCzTOe
         erBq7FLICiY1RPKcvrZjtEKynS4Cc1CYoo5PCHz7OetRW9kpyxnTeB8BlBOeUDaPqFLD
         SDv9IBRAA3WspppMSDymKcGHl6+drx3mvDA0/rCBBDFUEkZbEn/iJZDy+dB90omnVR2o
         hhUhBINpmEbxyaglwVAoNCDmDa9jGSdZVs2GtDBf1uQezkrW9N958vhSAi2/bRPjaiXA
         n9Jg==
X-Gm-Message-State: ANhLgQ1aFp1DKPRF5hWfLIRBHN3a3OySDm1qvxb31aaNuE9UfdFfUEJB
        8M7dIb4Duy2hh9keLcaXWmo=
X-Google-Smtp-Source: ADFU+vuez8ik+HelayqfbWuPS23RjevFaC+XIeuJao2tJZ39xjPYNmgy9IZQlqVpxzdNFXcBcRHn7g==
X-Received: by 2002:a17:902:8f8e:: with SMTP id z14mr1973585plo.195.1585362374884;
        Fri, 27 Mar 2020 19:26:14 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f1d9])
        by smtp.gmail.com with ESMTPSA id e14sm5086126pfn.196.2020.03.27.19.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 19:26:14 -0700 (PDT)
Date:   Fri, 27 Mar 2020 19:26:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200328022609.zfupojim7see5cqx@ast-mbp>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk>
 <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfnll0eh.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 02:43:18AM +0100, Toke Høiland-Jørgensen wrote:
> 
> No, I was certainly not planning to use that to teach libxdp to just
> nuke any bpf_link it finds attached to an interface. Quite the contrary,
> the point of this series is to allow libxdp to *avoid* replacing
> something on the interface that it didn't put there itself.

Exactly! "that it didn't put there itself".
How are you going to do that?
I really hope you thought it through and came up with magic.
Because I tried and couldn't figure out how to do that with IFLA_XDP*
Please walk me step by step how do you think it's possible.

I'm saying that without bpf_link for xdp libxdp has no ability to identify
an attachment that is theirs.

I suspect what is happening that you found first missing kernel feature
while implementing libxdp and trying to fix it by extending kernel api.
Well the reason libxdp is not part of libbpf is for it to be flexible
in design and have unstable api.
But you're using this unstable project as the reason to add stable apis
both to kernel and libbpf. I don't think that's workable because...

> I could understand why you wouldn't want to do
> that if it was a huge and invasive change; but it really isn't...

Yes. It's a small api extension to both kernel and libbpf.
But it means that by accepting this small change I sign up on maintaining it
forever. And I see how second and third such small experimental change will be
coming in the future. All such design revisions of libxdp will end up on my
plate to support forever in the kernel and in libbpf. I'm not excited to
support all of these experimental code.

I see two ways out of this stalemate:
1. assume that replace_fd extension landed and develop libxdp further
   into fully fledged library. May be not a complete library, but at least
   for few more weeks. If then you still think replace_fd is enough
   I'll land it.
2. I can land replace_fd now, but please don't be surprised that
   I will revert it several weeks from now when it's clear that
   it's not enough.
 
Which one do you prefer?
