Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7337BE5E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 15:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhELNlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 09:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhELNle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 09:41:34 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770BFC061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 06:40:26 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id w15so29605298ljo.10
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 06:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LIyfshQU/8yQNnJrZxiYbeec8RPvd1zV0izLRjzdEM=;
        b=x6UdDyTdjf0smNcVgVNK04/0pGGLotfOjtei+KBIpEvw8WpqbMegKlbbmX2SJycUDE
         /Z+NQHCnwGfnCCEZNXXJPMnmNCRMlzKIaF0qQHSxyRh+PGBQqHhlK9QvCAq/5S78+7lZ
         Z0JAp4uGYEdT07vHLlX2LFtil5viaFpoP9r7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LIyfshQU/8yQNnJrZxiYbeec8RPvd1zV0izLRjzdEM=;
        b=ieyVCTgr4WKHmzvy5pnrDC/MEzNvVVjT5poSbbFm4l4PmVxjdAy7PjIAEuDQmi/1UG
         zS/n8Lhw5AxdBvR2n/o++jsjzBatQIN+yzBSDQCmTLIbrh37PuPHq4ELgIFySVGybAhy
         9D9e2ZSZKOElh/N+xIAfLxGSfBfrZwC8mgR8u6i5Z0dl0PH48YnRW7+8UdrQUCmHWx40
         hV0jcLMo4ZhLLK60SM8B8rKZpzZL4TVdbTTDFMWdfDJG2yOALW3TiAAlXLSKYrXRZIB6
         p/js6BLGd7AlCMtPfdSg+zxu0dtoGz+6RY7ZA7VPXCu5jf3dDmep8MocynnwBLWsMxuV
         PGhQ==
X-Gm-Message-State: AOAM5338J/MtbT+7p3HnRMAqdnGNsMdULWzG5FAx6qc0/jgTUVhShO/f
        zWoCgEDSnDk5C49EWC6zuGYaljgjqv8XY5P67YoJAQ==
X-Google-Smtp-Source: ABdhPJxEvZ7tF7fllIIAdJE82qM93y08u9nNpwObsXmV4ToOWKvfujrvvYFVeHRj0WzvNymbue9sPIsj2faUCqSkGHQ=
X-Received: by 2002:a2e:91cb:: with SMTP id u11mr24602570ljg.83.1620826824452;
 Wed, 12 May 2021 06:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
 <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
 <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
 <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
 <20210504044204.kpt6t5kaomj7oivq@ast-mbp> <CAADnVQ+WV8xZqJfWx8em5Ch8aKA8xcPqR0wT0BdFf9M==W5_FQ@mail.gmail.com>
 <CAEf4BzY2z+oh=N0X26RBLEWw0t9pT7_fN0mWyDqfGcwuK8A-kg@mail.gmail.com> <20210511230505.z3rdnppplk3v3jce@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210511230505.z3rdnppplk3v3jce@ast-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 12 May 2021 14:40:13 +0100
Message-ID: <CACAyw9-pYpZO81W+vzEGv1+DmfapDjzco0QgZakfE7giisay6Q@mail.gmail.com>
Subject: Re: bpf libraries and static variables. Was: [PATCH v2 bpf-next 2/6]
 libbpf: rename static variables during linking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 May 2021 at 00:05, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
>
> > It's a pretty long email already and there are a lot things to unpack,
> > and still more nuances to discuss. So I'll put up BPF static linking +
> > BPF libraries topic for this week's BPF office hours for anyone
> > interested to join the live discussion. It would hopefully allow
> > everyone to get more up to speed and onto the same page on this topic.
> > But still curious WDYT?
>
> Sounds great to me. I hope more folks can join the discussion.

I'll be there, but can only stay for the first half hour. Talk to you then!

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
