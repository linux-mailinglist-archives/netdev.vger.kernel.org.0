Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7621951403B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353928AbiD2Bal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353917AbiD2Bak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:30:40 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBB2B6D3C;
        Thu, 28 Apr 2022 18:27:24 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i19so12711126eja.11;
        Thu, 28 Apr 2022 18:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GOfJpquDKCHF/cE6gKPA+s9U1dQQokb4+5iNEQ4VHsw=;
        b=fQmITz1vqIAa1Rig/p7a7JCI8scGdQTjwS3t/5s/fiUYZxzTFp8CPzigahpq5CLQha
         5wNaGyspzLYpgcva9iGmd/vm4NrvH4cPv4euoQ97ld56anQCQ3u757t77ltcVeY+pyTo
         D+Y2M1G9NK0jlzIZlJSB98xFK+tLJ6AH9iUr5Gp2ITtUJJptX4AOr6ahVFRUK1RB8BuC
         UmRU5cAwSeHYQrtDetqnjgYB/96wCo/nhtCPqIsK/Sgt500WNJwLsL6NAHWdKsjWStfK
         aIS03jV5jtVFhsoYgVtz0nJ/tr4zlwd8jNb2x0sktqJ4oMl/YoFxc66qMUS/kEoHBDGl
         khEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GOfJpquDKCHF/cE6gKPA+s9U1dQQokb4+5iNEQ4VHsw=;
        b=OdL0dhgova5RfIL7RWVExyEOd65MlwirkoIbva/NX8bjdkqMbkkUYON0uxBBibtCTZ
         N+dzxUCftRqCiJwIDnI3Mm3ivLnNW5Wi9UBgvQMOLNQUh6uaD9hIa8PEQzuPz3PNfae0
         bHsZTlQGyo+fvqIHKN7MF6xQxrUG/czpZPjuwWfJ6M4Tpyjt8Q88ImnOg42Gimze7Xwc
         hocH1kpdXNIDFv4EFqqdCtYOcY+zJMlcIrO90rtjyf+sd3NQ/w94ffMRTyybumeLU1d8
         W5SqTk/oTh+GaH/VSq89rO4UHuE8to9EbPqQ/FYgtFM6FvEpA87EOMfN5PSxlmFn1pHm
         1HFQ==
X-Gm-Message-State: AOAM531P08HSmKLGt23e3aLs5wXuHCWCLzLiebbz2F7lSgx02N1OxcTC
        XR7kYajj1poNG1Sed3ka61xr07FBQw4K0d+98fA=
X-Google-Smtp-Source: ABdhPJyU45BbP8G8PcxViFCG5+QXv7LH1zxaXs6jadYOqLNivGKbSLRIXlWl/FzT/ApjVi2MhrMoCSX1Aup8nlgGSEY=
X-Received: by 2002:a17:906:58c9:b0:6f3:9668:b290 with SMTP id
 e9-20020a17090658c900b006f39668b290mr21898249ejs.439.1651195642968; Thu, 28
 Apr 2022 18:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220428073340.224391-1-imagedong@tencent.com>
 <20220428073340.224391-3-imagedong@tencent.com> <87fslxgx6r.fsf@toke.dk>
In-Reply-To: <87fslxgx6r.fsf@toke.dk>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 29 Apr 2022 09:27:11 +0800
Message-ID: <CADxym3Z0bktRmOACS1eayh3batVBuGefKZEoYgRE2Cn6DJfr_A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] net: tcp: add skb drop reasons to route_req()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Biao Jiang <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Martin Lau <kafai@fb.com>, Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Mengen Sun <mengensun@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 9:22 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> menglong8.dong@gmail.com writes:
>
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Add skb drop reasons to the route_req() in struct tcp_request_sock_ops.
> > Following functions are involved:
> >
> >   tcp_v4_route_req()
> >   tcp_v6_route_req()
> >   subflow_v4_route_req()
> >   subflow_v6_route_req()
> >
> > And the new reason SKB_DROP_REASON_SECURITY is added, which is used whe=
n
> > skb is dropped by LSM.
>
> Could we maybe pick a slightly less generic name? If I saw
> "SKB_DROP_REASON_SECURITY" my first thought would be something related
> to *network* security, like a firewall. Maybe just SKB_DROP_REASON_LSM?
>

Thanks for your suggestion, and I think SKB_DROP_REASON_LSM is fine.
I'll change it in the next version.

Menglong Dong

> -Toke
>
