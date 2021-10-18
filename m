Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B881F432A2B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhJRXRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbhJRXRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 19:17:39 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ECFC06161C;
        Mon, 18 Oct 2021 16:15:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m14so15944096pfc.9;
        Mon, 18 Oct 2021 16:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z/xe73V/unDhGYmcbyF11NwV1IQXWU64zvss60wAVmM=;
        b=o1vv/+jZljOb0kc5OjY7DLNoxhW3rtz2CSLe0oNXVWPIFWLUx5KzT76yuvBcO3/IFG
         dAsyUqQqGIYaWS4fxJ+VEJliVbBhThziFrct4VZYCVhUFITcLhY4zd2z1RZFASwqPb3S
         YrZR7ZGpJp56jNt+hrVVu7NGfW2KeZqdu9wQ0OksvFMEWsK5I4x/nh6oJ7PQp+I/e9nF
         IhhE3UyRtoSwRO+fPfEdz8WPaZlblWrrp6N7L5P0taNP8C03tHyGiPxNLqUqcZdum5Yc
         hZy21DRCiWg3D143CnfejHqKXIF2n/1WRspft0iy1c6jD5kATBoDo7MBtw4lohvK7DQz
         56wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z/xe73V/unDhGYmcbyF11NwV1IQXWU64zvss60wAVmM=;
        b=hX4lYlcLSx3/pgh38WrzBSj7rA0dBmsbW+TwvAKyRrafMIX4tJrrmSCq2uML69x6o9
         x3LHNIDhDHJo4EiqdPlTpDb5YVttyIaG+QV50j8mjQ80jhRUM7HQQpQ7/++iNMWtjsm0
         Gfs7wPWBYN43sLFU1ekOq90tNWsJfURFmS2gxTstBnUhjF2Z6ccTxbHk39R97KgLE63N
         CITBluUmRhKb4GlJbCrWaC7cgm05J/RLsWt4Ld6GliLODA2oN2epMa5JcrU6SK9S2vxk
         R4QCHOP/tbTCU+PSrQDfmL3qrNYZYu34ttM01dldyMe5QnNvzKyVbFK88SE7qLE4KsC7
         TXCg==
X-Gm-Message-State: AOAM532WtGupunHLrmldpnXsoqSVWXsAEOkXj2o4Uav9IMCCYETeRsxB
        mFaffUa8bLyOHPCkxhhQ9/w=
X-Google-Smtp-Source: ABdhPJy3gTBiJ1Z7kTqOwstIcqZvAfvvrGWyS1SxGZzGZsJoa5rUiDK072RrFwUjPhYeVQKo/qRfhw==
X-Received: by 2002:a62:1806:0:b0:44c:5c79:59a7 with SMTP id 6-20020a621806000000b0044c5c7959a7mr31178145pfy.22.1634598927748;
        Mon, 18 Oct 2021 16:15:27 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f01f])
        by smtp.gmail.com with ESMTPSA id g11sm14097571pgn.41.2021.10.18.16.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 16:15:27 -0700 (PDT)
Date:   Mon, 18 Oct 2021 16:15:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joe Burton <jevburton@google.com>
Cc:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Introduce BPF map tracing capability
Message-ID: <20211018231525.tvkzacueudzceq2f@ast-mbp>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
 <20211005051306.4zbdqo3rnecj3hyv@ast-mbp>
 <CAL0ypaB3=cPnCGdwfEHhSLf8zh_mMJ=mL5T_3EfTsPFbNuLSAA@mail.gmail.com>
 <20211006164143.fuvbzxjca7cxe5ur@ast-mbp.dhcp.thefacebook.com>
 <CAL0ypaCwmGkQ0VK3nvfimHsO+OhBZb8cew-5c1gjZoZVZb1bBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL0ypaCwmGkQ0VK3nvfimHsO+OhBZb8cew-5c1gjZoZVZb1bBg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 02:05:55PM -0700, Joe Burton wrote:
> > Just to make sure we're on the same patch I'm proposing something like
> > the patch below...
> 
> The proposed patch seems reasonable overall:
> + eliminates a lot of boilerplate
> + enables map update filtering
> + minimal perf cost when not tracing maps
> + avoids adding complexity to verifier
> - requires touching every map type's implementation
> - tracing one map implies tracing all maps

right. The single 'if' filter inside attached bpf prog should be fast enough.

> I can rev this RFC with hooks inside the common map types' update() and
> delete() methods.
> 
> > Especially for local storage... doing tracing from bpf program itself
> > seems to make the most sense.
> 
> I'm a little unclear on how this should work. There's no off-the-shelf
> solution that can do this for us, right?
> 
> In particular I think we're looking for an interface like this:
> 
>         /* This is a BPF program */
>         int my_prog(struct bpf_sock *sk) {
>                 struct MyValue *v = bpf_sk_storage_get(&my_map, sk, ...);
>                 ...
>                 bpf_sk_storage_trace(&my_map, sk, v);
>                 return 0;
>         }
>
>
> I.e. we need some way of triggering a tracing hook from a BPF program.

I mean that above can be done as bpf prog.
bpf_sk_storage_trace() can be an empty global function inside a bpf program.
The attach to it is either fentry or even freplace.
