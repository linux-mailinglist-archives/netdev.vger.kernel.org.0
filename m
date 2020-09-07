Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21874260118
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbgIGQ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731070AbgIGQ7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:59:08 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC589C061573;
        Mon,  7 Sep 2020 09:59:07 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o8so5824994ejb.10;
        Mon, 07 Sep 2020 09:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FSSQ5eEjvBfhK807SWIcw97DGS95KSklYE2gmtef1t0=;
        b=hdUgddej3tJJcBEACrFgAVYJeTJBrmtxkkiIZgZ5crLTxdO5vBp6/vqVL7OOtLdWU+
         B/b++CvkPUsj75RtGRYARrHiKWG26UpWPNaHHWjiKDgVNnH7bl7H9dF+yCiP0JJr3SsZ
         2KMBVCkINnAJRoqAhOL/japDvVF1GQmKTC3HETcPZ9Br58r97a+0S0iKo0bbUDysvkD7
         thgFNCC5BkKoADP6mIhRToUobE8BD4mtZGJsqD22aH7v5+eoA+L9ScnWkCy2AbK/Spy9
         u8DNo7SVJ0tX8TvaT72yIEF3KdY7OL0xmjGWDAxzVl6oWRSqQsDWFu0vbBm1CIu+im55
         pOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FSSQ5eEjvBfhK807SWIcw97DGS95KSklYE2gmtef1t0=;
        b=cWdYFvU6995Zy79V/joBR3eouDsMCz3346IMg81aqehdGIOJckFGk0NMZmxjfXm/eK
         WAMDdjxxm2QbxcXtHmtzuZcJ9Jc5X6YEukLU8hPdLY7XhLAsWxAl+0F5TMuykv3f+nET
         TNcNFCVLjCEI5T1VIvXNeaACRqThju7JoQR8/MD0uUtqrwlWsTSAL0vCGde9gz2N3s9C
         kblzr+FWd/UCZZHAe2W/sksshLaPQzPlNT9wBrfePQ068Eo/+kce1W+lCbtKiaJS9jNK
         tEo93YzWWXNukg+vxW/Rq1dayLlHBlLGWITDKzQYDx2p76Dt3kMvPsQmXk2R0wOGqH2y
         Sj9w==
X-Gm-Message-State: AOAM530DVjCWSSBjHvsVBq5KYdJ1EZZIdK5XqSD5/j0YSlp5e88aGi29
        jXMJ/8D/TP4rA6TvqGMmt3AEEuDdl2Noi73oQA==
X-Google-Smtp-Source: ABdhPJw0eeuTYNiz4u8KLsJa0QaI0XDiRttA1yFczCd1re+DXlZlEibVxxBwnSsWyc34jTKiLtZc76yaC2LFgDEtfaY=
X-Received: by 2002:a17:906:4c51:: with SMTP id d17mr21659428ejw.28.1599497946504;
 Mon, 07 Sep 2020 09:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200905154137.24800-1-danieltimlee@gmail.com> <5f562f6a.1c69fb81.b9e0.0669SMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <5f562f6a.1c69fb81.b9e0.0669SMTPIN_ADDED_BROKEN@mx.google.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 8 Sep 2020 01:58:57 +0900
Message-ID: <CAEKGpzj5QszNFeDbj7aZsg0jxRYhHC3j4wPhTGTLhZMwZjut=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: refactor xdp_sample_pkts_kern with
 BTF-defined map
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 10:02 PM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> Daniel T. Lee writes:
> > Most of the samples were converted to use the new BTF-defined MAP as
> > they moved to libbbpf, but some of the samples were missing.
> >
> > Instead of using the previous BPF MAP definition, this commit refactors
> > xdp_sample_pkts_kern MAP definition with the new BTF-defined MAP format.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/xdp_sample_pkts_kern.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
>
> I see that samples/bpf/ibumad_kern.c and samples/bpf/xdp_monitor_kern.c
> still have old style BPF map definitions. Maybe you could change them as
> well?


Thanks for the review!

Actually, I'm well aware that there are some samples left with old style map
definitions, But those examples should be transferred from bpf_load to
libbbpf, not just bpf map changes.

I'm also planning to refactor those patches in the future.
For now I've just refactored this file, but if you think this patch
size is small,
I'll send it with other changes.
