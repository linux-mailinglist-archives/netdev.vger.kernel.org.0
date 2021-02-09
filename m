Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8353144C8
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 01:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhBIAUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 19:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBIAUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 19:20:02 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5B4C061786;
        Mon,  8 Feb 2021 16:19:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id t2so601927pjq.2;
        Mon, 08 Feb 2021 16:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eoH5hUsfk5zo7Noxr8SDfpR7j0komRN7J14ECI09DMw=;
        b=pll9bdWtNNRvTs5pqN71Tih5XaheYDbVEbatFKdm2dPB7q3QT/T+fVPSWITfpiO/8m
         Uadlu34LWVHV94ZFGTFPp50za+5L9fcIG7OEgjOx7OgmqUbwk/H2GxEIGD7VdcymtK/f
         DtlQLWtn6C7/Zgnos4/zCqOckrnUmT5LCKbjK91MV3eyM/UV5MG7wsnaEtHeTaHGJdxM
         IAar2VcmwdVMsVYe22FFYpSX95F1WKWfjAOC0YE322sWZ5mrke9M1MsALdznaQnb/Bp6
         fEb7KfqtKUQptI3WQpW274CTC3p48oZI5Xxbx76SzfU5ZZ04qvG7H7iwCWlP8EZlsid/
         lg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eoH5hUsfk5zo7Noxr8SDfpR7j0komRN7J14ECI09DMw=;
        b=AbehOxjuFG+s3Tcq+0punif/lpsm11eAbKHoEV1NSbImNneiVeNGJwBiH4As45zqDg
         uk0XbjenyW9g06S9W9yKFFgitVU0HyFlHRpTXXlLlnt4qeA+JX/6bICMA8vAlvLs3GMK
         EfDNt8R9KcmTpuRYjM+IcVdJrylNGp1zrdeVIT418TwIAIeZXXLC9GwbbhiZwSgViYTF
         NHNbyRvh59yxWltPxrpAscR78YZtGENdFdvlci0wBPBVZ6wAV1HtsboEP4eBK8LgVq6p
         O3BxuRcmfRVMLI+rE5S+vQsEFCjnZaQj+RYiYj3tVlrzjjLNCfOAsYWI05cdkNjWV4bo
         3UFQ==
X-Gm-Message-State: AOAM533FOToTIJik55gRKB7aIzhD74lgdiNWzktArpZol9G5rGEGvOrt
        DKG+uDTerYaxsBHcQnqmam1x2xR6HZN1VvtlGE8=
X-Google-Smtp-Source: ABdhPJyZzsmfRbLwpScGGdulYEkVeP0yKwpvx1KbKOfdbHe3te7wDvfrhVuRKjSoueBe5JgJ29Xv+YZD4C/qFmarQlU=
X-Received: by 2002:a17:902:c3cc:b029:e2:d0cd:4f6e with SMTP id
 j12-20020a170902c3ccb02900e2d0cd4f6emr9539906plj.77.1612829961201; Mon, 08
 Feb 2021 16:19:21 -0800 (PST)
MIME-Version: 1.0
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-3-xiyou.wangcong@gmail.com> <87ft2a4uz4.fsf@cloudflare.com>
 <6020f8b616d4_cc8682087d@john-XPS-13-9370.notmuch>
In-Reply-To: <6020f8b616d4_cc8682087d@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 16:19:10 -0800
Message-ID: <CAM_iQpWK8V4bzv4pK0v45FRb5aG1F=uSN3hrv-Sw92SrttJhQg@mail.gmail.com>
Subject: Re: [Patch bpf-next 02/19] skmsg: get rid of struct sk_psock_parser
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 12:39 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Jakub Sitnicki wrote:
> > On Wed, Feb 03, 2021 at 05:16 AM CET, Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > struct sk_psock_parser is embedded in sk_psock, it is
> > > unnecessary as skb verdict also uses ->saved_data_ready.
> > > We can simply fold these fields into sk_psock.
> > >
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> >
> > This one looks like a candidate for splitting out of the series, as it
> > stands on its own, to make the itself series smaller.
> >
> > Also, it seems that we always have:
> >
> >   parser.enabled/bpf_running == (saved_data_ready != NULL)
> >
> > Maybe parser.enabled can be turned into a predicate function.

Yeah, this looks cleaner.

> >
> > [...]
>
> Agree. To speed this along consider breaking it into three
> series.
>
>  - couple cleanup things: this patch, config option, etc.
>
>  - udp changes
>
>  - af_unix changes.
>
> Although if you really think udp changes and af_unix need to go
> together that is fine imo. I think the basic rule is to try and avoid
> getting patch counts above 10 or so if at all possible.
>
> At least this patch, the renaming patch, and the config patch
> can get pulled out into their own series so we can get those
> merged and out of the way.

Sounds good. Since each patch is already separated, there is no
extra burden on my side to split the whole patchset as suggested
above, except adjusting the cover letters.

Thanks.
