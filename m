Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766374EA7D7
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 08:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiC2G2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 02:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiC2G2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 02:28:46 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E081312658B;
        Mon, 28 Mar 2022 23:27:03 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id lr4so24523198ejb.11;
        Mon, 28 Mar 2022 23:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PtQAn5ODW65E3XLXykBMTJorCx3aj9bBwnMut4CnKzE=;
        b=ZUoGPspv30c62ejTIsHtO5ZU1YfnvxyTw761ZSkw7PAIRbpiJyrNqhceHlBCzOT+ox
         HNWeKQKTBU15DuAJMio+EmNi2QAvOQZ16uKDq3NqqS03R8RYh76TTIZx+QWkgv3ziwqk
         5qh3YiHuMWSLWlsBEXjENws+rU7ziUv14tTcHAkdmWYYaipBcmSfvKI0DcGFbQuK8oUz
         4MM9nNmbmf9d6I4FN7o6iLW0yXts/wwobEhhXi+Gbjo04d4bySLbsTrAXuCdYbOvfLtZ
         QToVKRvVLo/BxILbZFFdUcrdV3Xbf23s/aJ4ZanSwjpl879tz0LOV1pzk5GkRL/D53bj
         6fBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PtQAn5ODW65E3XLXykBMTJorCx3aj9bBwnMut4CnKzE=;
        b=z4leYPTIr9YBdAZIMtPbuH/DNFAbkImvZahrTU3LOClaMsm+tK4Yr1aiiYJsWxfft5
         w/X/sq3Jfa3PQ9T36sIHzYIl4Khbl45XE7VcM11EYwg2o2QpMi7x/Jd0gL0Osnpqgx3y
         CbB0dJDpy8QvmuRV250XhaXuLGfOY0Fg68BzpBnSWyScGuHgMtMfSBewljtITa/dol/o
         DSSZdDHTFOhWp/yEPhtMVIkLqwgCaSCRgEBy1XihBg7thpy2uLFzDRtlMm7xW0VN96WP
         /aDelXZ8zE64chrsoR3EARczhB09v9X50l4SYzp67ni0vmKbj0+LkGvOXUg8LuHwtTv2
         7/Yg==
X-Gm-Message-State: AOAM532eGERR/cwUpCJDffTGvv2+lzUYi8SVq6c493lM9TU/nSA3HSZZ
        d8X6KWHf7FSL97ZwgNYdTvQWb4jUVKtx6G19t7E=
X-Google-Smtp-Source: ABdhPJwv7EAbqlOaqfycWFHp6OI01iRpwa1pCm+J5g9v0BWWkcm6DC7nqihg73CpuPCKnajtzH/L2Bf3AFCe7hdHXJE=
X-Received: by 2002:a17:907:3f8d:b0:6e1:238f:19a0 with SMTP id
 hr13-20020a1709073f8d00b006e1238f19a0mr6762884ejc.439.1648535222371; Mon, 28
 Mar 2022 23:27:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220328042737.118812-1-imagedong@tencent.com> <20220328192103.4df73760@kernel.org>
In-Reply-To: <20220328192103.4df73760@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 29 Mar 2022 14:26:51 +0800
Message-ID: <CADxym3aO7SxDaSU1EChqCg3ySRpbuQjqMfaxYYUoPV8h5xBwaQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 0/4] net: icmp: add skb drop reasons to icmp
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 10:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 28 Mar 2022 12:27:33 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
> > we added the support of reporting the reasons of skb drops to kfree_skb
> > tracepoint. And in this series patches, reasons for skb drops are added
> > to ICMP protocol.
>
> # Form letter - net-next is closed

Okay......Is there anywhere to see if net-next is closed? This link saying
it's open:

http://vger.kernel.org/~davem/net-next.html

>
> We have already sent the networking pull request for 5.18
> and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.
>
> Please repost when net-next reopens after 5.18-rc1 is cut.
>
> RFC patches sent for review only are obviously welcome at any time.
