Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0B232B3AA
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449906AbhCCEEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbhCBSGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 13:06:14 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF77FC061797;
        Tue,  2 Mar 2021 10:05:29 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id t9so2441718pjl.5;
        Tue, 02 Mar 2021 10:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N+zqWtCPFGAO5H3z7d1fgYW+zfhgXhVyeYtUOypIpX8=;
        b=vEffHnQxFLC9erto9H62zINfAr4JuwSHmnoS04Fwtbjb0KeT9W7tBQQsTVF4aSF0O0
         k+MeIyA6xAkb6LpC0rMaruMzzdqWXgjhq1/SR2Rsf0lDZo7tgKLR5x5gnmkGelnB9N8x
         imaj/I6vdi8qSSP50Pkbn+/7TIOiZp9Iczeo3PWszsVim88vLSObpE15vN2d+MeO+MY/
         j39+UTLjnfMhMdwtQY9zxFYXfwsgm+5b6R0xxnIjc5emTwyfWkDrBmdJkmSP1U+M/bup
         80RRvNZKgizAZj9aE32bHgsC9ONBmYufTkLfqzQ0A45jzGS0RsfzaJ0qlKZbbyJTQ9/L
         K0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N+zqWtCPFGAO5H3z7d1fgYW+zfhgXhVyeYtUOypIpX8=;
        b=sl8dJiLrVQym5aTrhGvoMmPAEME0I0b07le/KoGhX8jtGJduEAezLzhVP0lKN3qG1G
         yYXQQ0DcI/GiZrfUihHqDNspflAnCasbE8jSW/gnqRVlmA211s0QwvHNKjt8Omjy0K9V
         81ZvVMmzngH4jI2CTOKIVp7+uvqNQuuVpQ6wf1Ymba9mGpo94QMxZ6VXnd6CsWTnCb8F
         lUre7sdFSunTG6r1kE5ygTBAuHsrwXFGuC+f4QXzuuh1E20rwEwvSDUf2rf81LI3Q0Lf
         B6UlMVlgyXqKNSv1cpyodwROHyjP93CK2klYwcD2qv6RPD9Yk97FDnFwtSjU0G2GYx9X
         w20A==
X-Gm-Message-State: AOAM533rU/bNyDQbGTSBOdOFRAL5QHWzG6ATj5pclwxkXXRy/v8Yce+9
        YRCuem//zRQun9OCx4PVDpj2578a6SZou+2qVOk=
X-Google-Smtp-Source: ABdhPJzt0iBqz5zNdr37OxXwHW60npSQ2y4M6w30ZJj8DrQuoWadMv0AQa4K3JDp/uXcyerLS7Ghz8e09p7Fv8QiPNQ=
X-Received: by 2002:a17:90a:ce92:: with SMTP id g18mr5766718pju.52.1614708329428;
 Tue, 02 Mar 2021 10:05:29 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-10-xiyou.wangcong@gmail.com> <CACAyw9-wmN-pGYPkk4Ey_bazoycWAn+1-ewccTKeo-ebpHqyPA@mail.gmail.com>
In-Reply-To: <CACAyw9-wmN-pGYPkk4Ey_bazoycWAn+1-ewccTKeo-ebpHqyPA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 2 Mar 2021 10:05:18 -0800
Message-ID: <CAM_iQpX3qqpKyOW2ohYo0e-5GO_wpoBBqv1BnrLLRsufMwO2rg@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 9/9] selftests/bpf: add a test case for udp sockmap
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 8:32 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 2 Mar 2021 at 02:38, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Add a test case to ensure redirection between two UDP sockets work.
>
> I basically don't understand how splicing works, but watching from the
> sidelines makes me think it'd be good to have more thorough tests.
> tools/testing/selftests/bpf/test_sockmap.c has quite elaborate tests
> for the TCP part, it'd be nice to get similar tests going for UDP. For

Sure, TCP supports more than just BPF_SK_SKB_VERDICT, hence
why it must have more tests than UDP. ;)

> example:
>
> * sendfile?
> * sendmmsg

Does UDP support any of these? I don't think so, at least not in my
patchset.

> * Something Jakub mentioned: what happens when a connected, spliced
> socket is disconnected via connect(AF_UNSPEC)? Seems like we don't
> hook sk_prot->disconnect anywhere.

But we hook ->unhash(), right?

Thanks.
