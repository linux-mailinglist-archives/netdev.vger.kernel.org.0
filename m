Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B4748D032
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 02:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiAMBiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 20:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiAMBiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 20:38:07 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F9DC06173F;
        Wed, 12 Jan 2022 17:38:06 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo8540555pjb.2;
        Wed, 12 Jan 2022 17:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1Zv2hfu98FpKbkQI6Mx3GlXR6/32ZuuHl0Apa07shxY=;
        b=n0zfQ6+mcPdpYj0OGGQNDNtUMM4llTV2p6EZHb0i8BDrREac8PJWqlkBbyoLO12gkM
         nUFSD46/e+NQ+skCIr+YGQJ4iHyS22LmAlcTBSG3Lt6lZe1ISRvJvitiqGU22XpfgHF9
         CyAKe8XrHhq3niIT6jlzg24UNw3ohgNjstKNq04do1u/pt2PAraXbWKVrWHESIezT8ZU
         7dyX29Jp6jzGDhEDQ/1AM/WYhMTQ8WRhINhnGnqRrD4o2UFnUn8dv8mu1jrjUksVu2Jx
         cWmqvTwRQjLQHumrCBaYrmqDvA34fes0POE8OJhv3ioU/aZOgDcJgzePVk9i29iJ69M4
         ddFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1Zv2hfu98FpKbkQI6Mx3GlXR6/32ZuuHl0Apa07shxY=;
        b=d6LG+XMq/smFBUuRuDj16rABFiZBOfl9cJF++ue+hWDBHo4BbL8BwXDg06zYdzKFNd
         XDvb6fIDBLL1cJlmwvW/NgFTcMbpTOonpWNxwwkPE3U+8GAS6nO20NNVGG7MaHbJur2g
         vaXJPjSyTe6ELOK/B/PhQhsVT+XGicTnE+wuKkug74qlj8FQ1X5Mo8qqrptcwKWTdaIx
         bevzW2H9recNInHjcEhFx66mGD14eevFei9zW7RV1s//240281dJfD820/MGfpIYZaT1
         pZ1TO5eQTI84xgHfrfdz62MxhuZ3AZhiPflQ4SfMygGzxaJ7S8Vc3gRKhN5MBj6zilYs
         79hg==
X-Gm-Message-State: AOAM530KiZTl0B7ILx3YbEJO4SlCyN0h4c/plgZZgFQaynZsms1qm5RW
        YsWfVrmrgqMow7/IPI1S14AbkHfmhaitdKNroY4grfWB
X-Google-Smtp-Source: ABdhPJzm2WzaNhMtVTWlgGfPKDlg4lkkaIq1vUEEbYn3v+/rAQfjZz7OA3jKu3ZIA8jmPbICxofmO0PAlh81eT3MQgw=
X-Received: by 2002:a17:90b:34f:: with SMTP id fh15mr11917726pjb.122.1642037885810;
 Wed, 12 Jan 2022 17:38:05 -0800 (PST)
MIME-Version: 1.0
References: <20220107215438.321922-1-toke@redhat.com> <20220107215438.321922-2-toke@redhat.com>
 <CAADnVQ+uftgnRQa5nvG4FTJga_=_FMAGxuiPB3O=AFKfEdOg=A@mail.gmail.com>
 <87pmp28iwe.fsf@toke.dk> <CAADnVQLWjbm03-3NHYyEx98tWRN68LSaOd3R9fjJoHY5cYoEJg@mail.gmail.com>
 <87mtk67zfm.fsf@toke.dk> <20220109022448.bxgatdsx3obvipbu@ast-mbp.dhcp.thefacebook.com>
 <87ee5h852v.fsf@toke.dk>
In-Reply-To: <87ee5h852v.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Jan 2022 17:37:54 -0800
Message-ID: <CAADnVQLk6TLdA7EG8TKGHM_R93GgQf76J60PEJohjup8JaP+Xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 1/3] bpf: Add "live packet" mode for XDP in bpf_prog_run()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 9, 2022 at 4:30 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> I left that out on purpose: I feel it's exposing an internal
> implementation detail as UAPI (as you said). And I'm not convinced it
> really needed (or helpful) - see below.

It's irrelevant whether it's documented or not.
Once this implementation detail is being relied upon
by user space it becomes an undocumented uapi that we cannot change.

> I'll try implementing a TCP stream mode in xdp_trafficgen just to make
> sure I'm not missing something. But I believe that sending out a stream
> of packets that looks like a coherent TCP stream should be simple
> enough, at least. Dealing with the full handshake + CWND control loop
> will be harder, though, and right now I think it'll require multiple
> trips back to userspace.

The patch set looks very close to being able to do such TCP streaming.
Let's make sure nothing is missing from API before we land it.
