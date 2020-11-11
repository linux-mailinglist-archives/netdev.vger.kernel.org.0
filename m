Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA12D2AF695
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgKKQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgKKQdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 11:33:08 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760ACC0613D1;
        Wed, 11 Nov 2020 08:33:08 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id m13so2882149ioq.9;
        Wed, 11 Nov 2020 08:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3fAjIG3mgbnFVC9OfitJdgU8aFvxA1tcVc+KEAMIaZA=;
        b=iUj4jDELk5UiZXYyi7LM3W05hrAA+UqY7foSzkvRunGEaFk52Ev2xzR0dXDhvVRlin
         tEkNlotJ75SDtUwNQQZ5YJ+YrXyDETfRNR/p5dJUIvlWFvFSllS8HNDhjkyvYXLUIE4t
         0adXs6C7X/tn3oBXh1E/uqmaTc2LXaP8Ud/c25ZYT91UpwaFjbmXfygSU7tDNbyRddAt
         Y3esyNBCZc4ZNtJP8lU2EETxNk+WzJNWdMaoVGxlb3LSsCnM6Hj6GH2PobchZoBGsc2T
         K5IgZB1vmcbQfTILCG7s2GQtog42PMgQtreioybqzenuW/x/5aMLaqUzjh1RPkOpWdmy
         OOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3fAjIG3mgbnFVC9OfitJdgU8aFvxA1tcVc+KEAMIaZA=;
        b=pcgzsUDJTFgHDwDDTnKLiLPNqI0isVkDVLehyNmchyNRKWZqtwD/bsC9HbdIpWOfGs
         u4hsT0OJfRBkf5ta6WuBNhxtit5lhYuz/aWYW2K6Fp+QHCmeZ3h55504aIz/o5d9WFWu
         tE7fUkOOjmnxNjJJk2fBLR7RlFAdmlpXCrl15rwQEgH7EX+60aMaQfHMpAFE3jP8Hhm6
         oWx1R5leRLOfTwPEAkkyKXJJIwb3znsOMq0Kpw4ZtConl0CuQd7FaSNPECAYg5d6Q75Y
         9nJ55L8QwdcjVxzFdb5QE7MNyJc3WsTgzn+eJm4XEsZCoEtUPV76x1D5KbsWuxnUAfwA
         VLjw==
X-Gm-Message-State: AOAM533OX6DHNfcupcIJKuT5/g3iBR/X/rakksjtgWC2uIfDRksLMxh0
        zR6ch0aGO5ICo1o9us5hjmnR/qnie8Q=
X-Google-Smtp-Source: ABdhPJx5rCRIk61jEGHofstkNTXJwLf6Y9A0XfK5hJV8CoD/O2opRHUm8weboEY2J/+qHI1AlMRARg==
X-Received: by 2002:a02:cb99:: with SMTP id u25mr16397606jap.73.1605112387744;
        Wed, 11 Nov 2020 08:33:07 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7980:a277:20c7:aa44])
        by smtp.googlemail.com with ESMTPSA id x14sm1561669ior.7.2020.11.11.08.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 08:33:07 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
 <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
 <20201109014515.rxz3uppztndbt33k@ast-mbp>
 <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
 <20201111004749.r37tqrhskrcxjhhx@ast-mbp> <874klwcg1p.fsf@toke.dk>
 <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8bd665e1-f82b-1543-9791-8b41da855327@gmail.com>
Date:   Wed, 11 Nov 2020 09:33:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/20 8:06 AM, Daniel Borkmann wrote:
> 
> Not really. What you imply here is that we're living in a perfect world
> and that
> all distros follow suite and i) add libbpf dependency to their official
> iproute2
> package, ii) upgrade iproute2 package along with new kernel releases and
> iii)
> upgrade libbpf along with it so that users are able to develop BPF
> programs against
> the feature set that the kernel offers (as intended). These are a lot of
> moving parts
> to get right, and as I pointed out earlier in the conversation, it took
> major distros
> 2 years to get their act together to officially include bpftool as a
> package -

Yes, there are lot of moving parts and that puts a huge burden on
distributions. The trend that related s/w is outdated 2-3 months after a
release can be taken as a sign that bpf is not stable and ready for
distributions to take on and support.

bpftool is only 3 years old (Oct 2017 is first kernel commit). You can
not expect distributions to chase every whim from kernel developers, so
bpftool needed to evolve and prove its usefulness. It has now, so really
the disappointment should be limited to distributions over the past 12
months, especially Ubuntu 20.04 (most recent LTS) not having a libbpf
and bpftool releases. But again, 20.04 was too old for BTF 3 months
after it was released and that comes back to the bigger question of
whether bpf is really ready for distributions to support. More below.

Focusing on the future: for Ubuntu (and Debian?) bpftool is in the
linux-tools-common package. perf has already trained distributions to
release a tools package with kernel releases. That means bpftool updates
follow the kernel cadence. bpftool requires libbpf and I believe given
the feature dependencies will force libbpf versions to follow kernel
releases, so I believe your goal is going to be achieved by those
dependencies.

But there is an on-going nagging problem which needs to be acknowledged
and solved. As an *example*, Ubunutu has kernel updates to get new
hardware support (HWE releases). Updating kernels on an LTS is
problematic when the kernel update requires toolchain updates to
maintain features (DEBUG_INFO_BTF) and library updates to get tools for
that kernel version working. That is a huge disruption to their
customers who want stability — the whole reason for LTS distributions.




