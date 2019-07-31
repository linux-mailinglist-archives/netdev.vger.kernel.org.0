Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6C77B7D1
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfGaBwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 21:52:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32937 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfGaBwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:52:43 -0400
Received: by mail-pg1-f193.google.com with SMTP id f20so21817398pgj.0
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BfCyrhNuzIz7zMfIxFPsUxkcXLLnH1B7jinChY5NNYw=;
        b=q+Y8Ti8MeMDyuFY+s+KxmfGiDtTy24GTdibFPwhm21arDI7+TiHIrPkI0SKjA1LxJJ
         VMx49bA+7E4OS/hJuxLHJP+pOstVg8KFvVNWt/XSaISH083EQQ9C7MjO4l7ktkJFBncH
         4/rnGF/WIweq3AQ6k6EyilnsHVuptI7WVTbtMFpLxXgLx2bshlw5gDAaMlgscHGKWpJo
         eZMSf7Hl6wtAbxx1KZk6v9/yBiooXfLDZPVMEEfQn3fnI7hYqztYCfX1wCZdr+jKCZ5E
         HQrAcj3/iYn9luiNBQeC9cYtB7c2RuaGwjV9gHbqK1TcI0kRjs/q3V9ky7XGIRFNOptb
         l0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BfCyrhNuzIz7zMfIxFPsUxkcXLLnH1B7jinChY5NNYw=;
        b=SlvnsqzohnMUIJSzmDGcoBd/EcO/8tcfNfPl/cThKYj6+eoSrQlJabcfh3m10vG3XA
         Mh7n+8Dpjdakg4PKk0c0BoB6iohWoP+iFXgzNYUqyTHUUgtVrMzVesQfdCgtVFI+jh2l
         /x+m9QCJvnArpFnPMZeCvEC9/WB6dlBpHI1CIAz8+jhFMwSrvD2GC39EiGX1dfW8Wk7t
         CNvKxRV750hKHJhxYMbBEEVfwrvRVPb3SORMof7TnAxJ7FhvbBrqeMOS0kjeCMcJOjDG
         KYSkjMKDAd7vFnruIGxjsSgB7AsW66mn4i1BK9X5Zdsu2XT08Q8Mezpz+1oxcohc8wFy
         0vsg==
X-Gm-Message-State: APjAAAUYHe3ypNLgqGFCgSJumntdHH241e8sRlt95jwJ3F5g3EVnS0W2
        NNMwBuXAenjAwhto+RV52oE=
X-Google-Smtp-Source: APXvYqxZv8AJvgAQ+D5NwAqmUEXBYD6uUGaLsDnqTJAo5EkU5Wju65yYfGq1O83qXyK6AFXA7RBeNw==
X-Received: by 2002:a17:90a:17a6:: with SMTP id q35mr348311pja.118.1564537962329;
        Tue, 30 Jul 2019 18:52:42 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:af4b])
        by smtp.gmail.com with ESMTPSA id 65sm69390586pgf.30.2019.07.30.18.52.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 18:52:41 -0700 (PDT)
Date:   Tue, 30 Jul 2019 18:52:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load XDP
Message-ID: <20190731015238.3kq3r7rlascv7tzs@ast-mbp>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
 <20190730155915.5bbe3a03@cakuba.netronome.com>
 <20190730231754.efh3fj4mnsbv445l@ast-mbp>
 <20190730170725.279761e7@cakuba.netronome.com>
 <20190731002338.d4lp2grsmm3aaav3@ast-mbp>
 <20190730182144.1355bf50@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730182144.1355bf50@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 06:21:44PM -0700, Jakub Kicinski wrote:
> > > Duplicating the same features in bpftool will only diminish the
> > > incentive for moving iproute2 to libbpf.   
> > 
> > not at all. why do you think so?
> 
> Because iproute2's BPF has fallen behind so the simplest thing is to
> just contribute to bpftool. But iproute2 is the tool set for Linux
> networking, we can't let it bit rot :(

where were you when a lot of libbpf was copy pasted into iproute2 ?!
Now it diverged a lot and it's difficult to move iproute2 back to the main
train which is libbpf.
Same thing with at least 5 copy-pastes of samples/bpf/bpf_load.c
that spawned a bunch of different bpf loaders.

> IMHO vaguely competent users of Linux networking will know ip link.
> If they are not vaguely competent, they should not attach XDP programs
> to interfaces by hand...

I'm a prime example of moderately competent linux user who
doesn't know iproute2. I'm not joking.
I don't know tc syntax and always use my cheat sheet of ip/tc commands
to do anything.

> > 
> > bpftool must be able to introspect every aspect of bpf programming.
> > That includes detaching and attaching anywhere.
> > Anyone doing 'bpftool p s' should be able to switch off particular
> > prog id without learning ten different other tools.
> 
> I think the fact that we already have an implementation in iproute2,
> which is at the risk of bit rot is more important to me that the
> hypothetical scenario where everyone knows to just use bpftool (for
> XDP, for TC it's still iproute2 unless there's someone crazy enough 
> to reimplement the TC functionality :))

I think you're missing the point that iproute2 is still necessary
to configure it.
bpftool should be able to attach/detach from anything.
But configuring that thing (whether it's cgroup or tc/xdp) is
a job of corresponding apis and tools.

> I'm not sure we can settle our differences over email :)
> I have tremendous respect for all the maintainers I CCed here, 
> if nobody steps up to agree with me I'll concede the bpftool net
> battle entirely :)

we can keep arguing forever. Respect to ease-of-use only comes
from the pain of operational experience. I don't think I can
convey that pain in the email either.

