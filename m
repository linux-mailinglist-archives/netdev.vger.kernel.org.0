Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C981335353B
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 20:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhDCSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 14:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbhDCSWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 14:22:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1FDC0613E6;
        Sat,  3 Apr 2021 11:21:58 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id h3so798228pfr.12;
        Sat, 03 Apr 2021 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bDafbjF9fSu1FMwOwXasSOKmYpWgCnT0ByRHS4AhmtE=;
        b=uEmDXd+5gG7NWhCWL7hNKI7pUMIsBLucOsmey82O5pIjQYcXbYbj9WLqQxtV9zxcob
         ZEbgPuloFuwWfuchMtfSPmriHFfbmXz0haf2IMOJPnbJytm67v7z1etW5EMx4XIWAu2F
         xMKlKHY8iYzj56auhv4P0ey3tpkvBe9tWoqplagTa8snIh4ZM4s0DeGvYYyFoqzuI4Z8
         uxA4h9OoSqwTf9kvAQMiPr5MpSFgb5IFl8/hrL2vvn3BBR1gUFqqMMHJAhKKNb5eE2OR
         RMkSvdYJP6WmPW+260SwQw1xDKgkxlXYgttcib0uiAKHUHZFiFLJsMFbTaMFDfu9w+hc
         9G5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bDafbjF9fSu1FMwOwXasSOKmYpWgCnT0ByRHS4AhmtE=;
        b=qTf0vJYeRsbo36s8omEctcmE8lJQ/3HI8JHw/cf102LJ/dn49Jc1BY1iovZNNe/A0E
         dGpl2kfivzDLMsABGyhMXsm0xknW1FmG0tR2GHNDUJxyz5gXumshm4Ch3pL/8r2kzQhc
         dH4cMxdnUgfqz9f9hFjHYTj0L1vFYBtH/FcTtJCJrA7n9PkhpQ2fjVwWlN7DVEnAfCyd
         B3QfQmD8ZvbKjhQ0z2YFxTEc3I3bWXcRFBnkJ4dK9cHBaqpy7V2xKUvyw0yYJ2zcXC4A
         i0saFQtnjnv+HNdLEm9mQ+qqyU/+fL+H14VVt55s5nUKnQnWq74OIqrMg74r4ppdWHZ7
         x9Sg==
X-Gm-Message-State: AOAM533NbkIr9PF9j6/P69gDYrU09DAEYb0OtWEGxZKBDhEPwSBVTN40
        GKPDI/63bbPhCUpsn/FzHVM=
X-Google-Smtp-Source: ABdhPJxxO25x7v9vPMRtmLCd9zajbI86tucoVb3o9JelqZtD9zmsTg7xr24Xna3KRajYyiXj/cXy1A==
X-Received: by 2002:a63:9811:: with SMTP id q17mr16834302pgd.238.1617474118379;
        Sat, 03 Apr 2021 11:21:58 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f671])
        by smtp.gmail.com with ESMTPSA id y9sm11140457pja.50.2021.04.03.11.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 11:21:57 -0700 (PDT)
Date:   Sat, 3 Apr 2021 11:21:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
Message-ID: <20210403182155.upi6267fh3gsdvrq@ast-mbp>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-2-jolsa@kernel.org>
 <87blavd31f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87blavd31f.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 01:24:12PM +0200, Toke Høiland-Jørgensen wrote:
> >  	if (!prog->aux->dst_trampoline && !tgt_prog) {
> > -		err = -ENOENT;
> > -		goto out_unlock;
> > +		/*
> > +		 * Allow re-attach for tracing programs, if it's currently
> > +		 * linked, bpf_trampoline_link_prog will fail.
> > +		 */
> > +		if (prog->type != BPF_PROG_TYPE_TRACING) {
> > +			err = -ENOENT;
> > +			goto out_unlock;
> > +		}
> > +		if (!prog->aux->attach_btf) {
> > +			err = -EINVAL;
> > +			goto out_unlock;
> > +		}
> 
> I'm wondering about the two different return codes here. Under what
> circumstances will aux->attach_btf be NULL, and why is that not an
> ENOENT error? :)

The feature makes sense to me as well.
I don't quite see how it would get here with attach_btf == NULL.
Maybe WARN_ON then?
Also if we're allowing re-attach this way why exclude PROG_EXT and LSM?
