Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB74A2890E6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390577AbgJISeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390548AbgJISdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:33:46 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF4FC0613D5
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 11:33:44 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q7so10021071ile.8
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 11:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NginWwcSKqK9kM6/V5DaPE4JtW0hMIAcQ0pfU99Whvs=;
        b=A3W2nifNlteMroZ5QlhEmA+6TZZW6d31LWV273MXuHDGP2jkeiwWZw2AJsaGf0i8wJ
         Z9hjYvUGJgF1L2QEdGP+RUwEZOm4fubWc6DOMLXAJAFVrh1xgSVhVJE1b783V/MQYXUv
         q7EtTtxI8koF6yb0gtOEQPBrXd3OlkN2Rejhz7mrLobBraOJF4s6JriNB0f7vfd2Xq4l
         odWyPKQa8YOdgnpxbwG+FSKRRO90qODNeHdNpJH8hSle8X4fhya+okU0NNNR01GtT0Bj
         sf0bSNqVxr3+Q/KnN5XyrumyT3VAFqdJMSBpO9AmPHcXC2ssNDhLvRFbXgsec0kU+R1f
         8+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NginWwcSKqK9kM6/V5DaPE4JtW0hMIAcQ0pfU99Whvs=;
        b=jN6RiunYI5mMcaI9Z/M95crXHCevJto/x69UiUSjQmNXq+kvy7SEZhsH9Z38sFxsaQ
         ldf/T/EQdWU/4u6nd8sFHK/M2I8VTm1ZrLTht75Or8rWoWmHqqiC6oZQcpkD8gR1tUZX
         DNnpktRrDO2DBEWYnAHxSpTu2xKvIAPrUT3/ioA+NXLOM53BQXpvU5LjCx+aBM/FeD1f
         g5XhFMkTO3RB0jhhMbznvc61VxXccoFDkgNsAUcSN0GT1ixp3qamUP1wXuo1y3pD6S/J
         on9U8XadbLn/Q/WA1CLsfcDxmL22acM1tfW56fuhbDbOFlkxfmrLjrEryzOpvL1C9P/K
         hf2w==
X-Gm-Message-State: AOAM530vLZ518O+M6sWvXfGaHNRKji9kjN1xh5QQtKT4Ngc3EGqNfKid
        RiHEna1JlmKTkmjewpgIYI1aRVHa9xEsZqI7r2iQ2g==
X-Google-Smtp-Source: ABdhPJxt6mxMvU44yuRLqC9eHk9F62AtoKA50uMUYTCJ/IIpkzAy4745aQ7IMaJPcOSYu+HnbavDRuh8qGPga7dkOt8=
X-Received: by 2002:a92:ccc2:: with SMTP id u2mr10356666ilq.278.1602268424037;
 Fri, 09 Oct 2020 11:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <160216615767.882446.7384364280837100311.stgit@firesoul> <40d7af61-6840-5473-79d7-ea935f6889f4@iogearbox.net>
In-Reply-To: <40d7af61-6840-5473-79d7-ea935f6889f4@iogearbox.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 9 Oct 2020 11:33:33 -0700
Message-ID: <CANP3RGesHkCNTWsWDoU2uJsFjZ4dgnEpp+F-iEmhb9U0-rcT_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 4/6] bpf: make it possible to identify BPF
 redirected SKBs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This change makes it possible to identify SKBs that have been redirected
> > by TC-BPF (cls_act). This is needed for a number of cases.
> >
> > (1) For collaborating with driver ifb net_devices.
> > (2) For avoiding starting generic-XDP prog on TC ingress redirect.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> Not sure if anyone actually cares about ifb devices, but my worry is that the
> generic XDP vs tc interaction has been as-is for quite some time so this change
> in behavior could break in the wild.

I'm not at all sure of the interactions/implications here.
But I do have a request to enable ifb on Android for ingress rate
limiting and separately we're trying to make XDP work...
So we might at some point end up with cellular interfaces with xdp
ebpf (redirect for forwarding/nat/tethering) + ifb + tc ebpf (for
device local stuff).
But this is still all very vague and 'ideas only' level.
(and in general I think I'd like to get rid of the redirect in tc
ebpf, and leave only xlat64 translation for to-the-device traffic in
there, so maybe there's no problem anyway??)
