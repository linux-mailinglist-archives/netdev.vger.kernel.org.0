Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EE91EB7E0
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgFBJGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgFBJGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:06:45 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F45C05BD43
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 02:06:44 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x13so2585140wrv.4
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 02:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8v86iOfFTv5BgAxyuvboR4oLRtDNPVTIFHSDTXVpBds=;
        b=M8uuyvAjamNhrQwwq0xYkQclgXmwzuX291UmA2eh4YYt+i6td+xKOzAxr0g38rgSym
         kGLTujiAzXWc3s6IPpbHo8VP8mIkzajR2qEnrc8HK7oQ/gvHcpVN2VXpVrTPMvJ4m7hF
         N54TmJSOkDH+pf8ZJogd+pu+4UDVgU1aLG4Yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8v86iOfFTv5BgAxyuvboR4oLRtDNPVTIFHSDTXVpBds=;
        b=mPL5k+C2ZD9Z7NkSfnqRVU8w3fQI01Fnc/dFiq16FBcGdgia0bsnf+RX3ZyDN23Qbt
         0icixObUrydvoMkSUe+HbR+CZI+K/5W5IS2OHMsHfEoa6A3cR78hHAHRZkUNDu1j9Rv0
         Miwdp3wRStpKGTwE9r7o9lr1xcAjp9nNmEqa0bXg/5GBM08SMqWexA50eTB4pueoSjlU
         /DbE5uLil7wyAOPNjg7V+n0kVbxfSrAuwBeGwuwYs775hCqrBWtfQfooZX0FzXc9P46C
         ou9q+r25SXqmj79NnXJTWfqoMRUV/jo+MNGAlsFjKYmiduiMVaFFeEvjdynZcXmru5Ey
         Ar7g==
X-Gm-Message-State: AOAM532w0B1yHf47E1mVn8VkYc3o5M18Fk+61vjX8lRzR1kkzos9rjfw
        osDA3IIYumknYiH8N9v/hjWPnm6DxJmwcZ3VoiyRgA==
X-Google-Smtp-Source: ABdhPJx6Y9xwmLNgoYiiWind01Az3F7mso6mNpKG2xSrW6WTJ19a8Nsjx96OMPLN9lu0VVk+nD+pZPRubtOi3kJyi7U=
X-Received: by 2002:adf:f30d:: with SMTP id i13mr23946962wro.146.1591088803135;
 Tue, 02 Jun 2020 02:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200531154255.896551-1-jolsa@kernel.org> <CAPhsuW7HevOVgEe-g3RH_OmRqzWedXzGkuoNNzJfSwKhtzGxFw@mail.gmail.com>
 <CAADnVQJquAF=XOjbyj-xmKupyCa=5O76QXWf6Pjq+j+dTvaEpg@mail.gmail.com> <20200602081339.GA1112120@krava>
In-Reply-To: <20200602081339.GA1112120@krava>
From:   KP Singh <kpsingh@chromium.org>
Date:   Tue, 2 Jun 2020 11:06:32 +0200
Message-ID: <CACYkzJ4POnqQk1zGToh5Ct8m5CHtpWyxiwjPWv5-x+gHPS5XiA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Use tracing helpers for lsm programs
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 10:13 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jun 01, 2020 at 03:12:13PM -0700, Alexei Starovoitov wrote:
> > On Mon, Jun 1, 2020 at 12:00 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Sun, May 31, 2020 at 8:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Currenty lsm uses bpf_tracing_func_proto helpers which do
> > > > not include stack trace or perf event output. It's useful
> > > > to have those for bpftrace lsm support [1].
> > > >
> > > > Using tracing_prog_func_proto helpers for lsm programs.
> > >
> > > How about using raw_tp_prog_func_proto?
> >
> > why?
> > I think skb/xdp_output is useful for lsm progs too.
> > So I've applied the patch.
>
> right, it's also where d_path will be as well
>
> >
> > > PS: Please tag the patch with subject prefix "PATCH bpf" for
> > > "PATCH bpf-next". I think this one belongs to bpf-next, which means
> > > we should wait after the merge window.
>
> I must have missed info about that,
> thanks for info

Thanks for adding this! LGTM as well.

- KP

>
> >
> > +1.
> > Jiri,
> > pls tag the subject properly.
>
> will do, sry
>
> thanks,
> jirka
>
