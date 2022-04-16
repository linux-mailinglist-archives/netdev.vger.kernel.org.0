Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6317D5037C1
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 19:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiDPR55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 13:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiDPR5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 13:57:55 -0400
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7E02981B;
        Sat, 16 Apr 2022 10:55:22 -0700 (PDT)
Date:   Sat, 16 Apr 2022 17:55:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650131721;
        bh=hUYlD7EnN76aLL3sNghNfcRfJYl0D3zXzjY2HxeciRE=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=p02unh3uNBwOhKDm96RTOSIcRDFBTNulK2v43wYugdd3yEd6K42QNMgN/XkI0xFYP
         6M++ziLek6uiEisFq9RKvX6ywCoHcVNa5R0Ge6zU/R7b952ybwqu5ZFcFLKhYhjQXj
         MsvNyMT6Lb0FhIkAz54KleAy3JB3byftO2qZ+KTe3ukyf1oUksxP3fWinySvrcGs2s
         3Zp9MqMeiRkVrAbem36pS0LyabmgAVNxNwuO3578YQN53lwc9OrMyt9jbxTFHb28g2
         m+/Xej+4j0H/TYSTJVi3qUsMS+1vuHwygS3eWkV0670qCkKJ89SLXa45fXKW1Z3mRJ
         iOTT99LK9aXMA==
To:     Song Liu <song@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH bpf-next 07/11] samples: bpf: fix uin64_t format literals
Message-ID: <20220416174816.198651-1-alobakin@pm.me>
In-Reply-To: <CAPhsuW7FuAKX0fJ1XPfFWWwRS+wTW0qA49V-iQVzxv4jOb47MA@mail.gmail.com>
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-8-alobakin@pm.me> <CAPhsuW7FuAKX0fJ1XPfFWWwRS+wTW0qA49V-iQVzxv4jOb47MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Song Liu <song@kernel.org>
Date: Fri, 15 Apr 2022 16:52:13 -0700

> On Thu, Apr 14, 2022 at 3:46 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > There's a couple places where uin64_t is being passed as an %ld
> > format argument, which is incorrect (should be %lld). Fix them.
>
> This will cause some warning on some 64-bit compiler, no?

Oh wait, I accidentially mentioned %ld and %lld although in fact I
changed %lu to %llu. So there won't be any compiler warnings. I'll
fix the commit message in v2.

>
> Song
>

--- 8< ---

> > --
> > 2.35.2

Thanks,
Al

