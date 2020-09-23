Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAC5276072
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgIWStX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgIWStX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:49:23 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF128C0613CE;
        Wed, 23 Sep 2020 11:49:22 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u4so501396ljd.10;
        Wed, 23 Sep 2020 11:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbK+j42dWRK2s1x0oaQhi9+BRDAcyqnHMQWrUaVkakI=;
        b=pxc702TVV231b7p2aL4oSu3UqURyE2IucXBJdE0cFp1S9cLk62cjI12AtE9FGhF+xY
         dAM5vm5GIwLBZZafN/Capt0djv9hzrrfyBv4an1mIowfTj0YNNyBM3DGgqFZWyAJqJu8
         L8gC9SKYsWuyf1iXkE58PO9qVl0DMP/A3MdP3dV4JMIet8VRwrTupmDJGnZ9D3+7aB/6
         65kFdhFikXHJiJM3OgLDQ7at/xQ3njRllnV0vKj9vV9FfRDgkrjj71X59owhG5XuvNO5
         ny4Pf+/WlM4dVRDmwqD6kl9s2SAQGXfJ7BnFxjBRBa5Wt/6F/35YzSw6xJ5kd4LELfE6
         e8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbK+j42dWRK2s1x0oaQhi9+BRDAcyqnHMQWrUaVkakI=;
        b=pYLhDvcQg8h+t19XRaGPwnMB+Rq9HYITG6FNQk6s/80CgJdUG7VBuyjocKrR3TBOux
         mSEP9apNwGxKI+dUAIPU9g1AHlJf6WwzNQhY5doTxIS0UVTXj55nfwQCv9kaY/GZzd7N
         oWTMRfDSxFWoWkUtpO1yNnbFQ8SZfaP+nCpDKCQMWAT8LgGkvzCTcyGm2675LfCveGGq
         wTFESPTRCOAwFHi20WEuDstvUqqTeZh4dYshjzKJVs/p6/W4Q7UhRZMWe3Q8VpLpxrSc
         f9uL4k0gi68pXMW6jwaXHyKrxgTCadFjXsxveVcHGXKmLg+cFPrK5OYP5z2E2cDr5t/+
         lg2Q==
X-Gm-Message-State: AOAM532IsT4rOfseFqXg7G3u2o4DBePINZ0L+8VhpucUAAcJTAY01QQg
        rMTNAiScPQy7TFzxF8cp8y7mPJr9nyo1O3biQik=
X-Google-Smtp-Source: ABdhPJx9ba2vvV0ptXmwQCajVB185yIhjs+5/IVdOR63X4tOvdDDL/i4APGlb0Hyd7AuhWu3FqfAVP4Ofcm7Xsn3bks=
X-Received: by 2002:a05:651c:cb:: with SMTP id 11mr419441ljr.2.1600886961295;
 Wed, 23 Sep 2020 11:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200923160156.80814-1-lmb@cloudflare.com> <CAEf4BzZJQBdW72TRCuW7q0c3kke1Qan59fDzV0DKN_EOAgXGaw@mail.gmail.com>
In-Reply-To: <CAEf4BzZJQBdW72TRCuW7q0c3kke1Qan59fDzV0DKN_EOAgXGaw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Sep 2020 11:49:09 -0700
Message-ID: <CAADnVQ+m+b5GKxk+sw-R+374vQRbQn59MP4g1uKPghnSWt6pVw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: explicitly size compatible_reg_types
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 9:05 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Sep 23, 2020 at 9:03 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > Arrays with designated initializers have an implicit length of the highest
> > initialized value plus one. I used this to ensure that newly added entries
> > in enum bpf_reg_type get a NULL entry in compatible_reg_types.
> >
> > This is difficult to understand since it requires knowledge of the
> > peculiarities of designated initializers. Use __BPF_ARG_TYPE_MAX to size
> > the array instead.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > ---
>
> I like this more as well.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
