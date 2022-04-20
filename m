Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB18508D3C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 18:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380543AbiDTQ3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 12:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380479AbiDTQ3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 12:29:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27A421E00;
        Wed, 20 Apr 2022 09:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F116619FF;
        Wed, 20 Apr 2022 16:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9F5C385A0;
        Wed, 20 Apr 2022 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650472021;
        bh=fb9ado0/3F7FYlTFjG0Q6SH3RLQ9ehGzpmSE/fDCKoY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pBMye+1yrl7l8crweJudwjifXcMbVlXiemfA+9K6AHu6l/QjSVIuyitLLm4Jdux/9
         hAOMKzQHDj547K//MuJD7PJcLnGxOk5+NbRJAj+gTuojYIAWY717h4Csr/zEqeGbxY
         r0hY9A/thV4EHui+/4lKaXIRADaortYLKkBFQwM77tkx2PuUZmDJWvPhb3xNWOXTSj
         FXE0VaD3eZ91/DWtSrc3j/PgGV0iykbam1OJ2qZJ9cbIapUPg8aaX4ZZg7F+G496ER
         EpYTKSRPXL4hczS3eTUcvALShCDyxe1sarg94f1aHLWGq362hktT8HN522EtkiWoCp
         3b5j96cNLYYYw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D7C462D1C96; Wed, 20 Apr 2022 18:26:57 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [net-next v1] bpf: add bpf_ktime_get_real_ns helper
In-Reply-To: <CAEf4Bzafe3Am5uep7erd7r+-pgdGRc9hsJASYfFH47ty8x9mTA@mail.gmail.com>
References: <20220420122307.5290-1-xiangxia.m.yue@gmail.com>
 <878rrzj4r6.fsf@toke.dk>
 <CAEf4Bzafe3Am5uep7erd7r+-pgdGRc9hsJASYfFH47ty8x9mTA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Apr 2022 18:26:57 +0200
Message-ID: <87wnfjhga6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Apr 20, 2022 at 5:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@ke=
rnel.org> wrote:
>>
>> xiangxia.m.yue@gmail.com writes:
>>
>> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>> >
>> > This patch introduce a new bpf_ktime_get_real_ns helper, which may
>> > help us to measure the skb latency in the ingress/forwarding path:
>> >
>> > HW/SW[1] -> ip_rcv/tcp_rcv_established -> tcp_recvmsg_locked/tcp_updat=
e_recv_tstamps
>> >
>> > * Insert BPF kprobe into ip_rcv/tcp_rcv_established invoking this help=
er.
>> >   Then we can inspect how long time elapsed since HW/SW.
>> > * If inserting BPF kprobe tcp_update_recv_tstamps invoked by tcp_recvm=
sg,
>> >   we can measure how much latency skb in tcp receive queue. The reason=
 for
>> >   this can be application fetch the TCP messages too late.
>>
>> Why not just use one of the existing ktime helpers and also add a BPF
>> probe to set the initial timestamp instead of relying on skb->tstamp?
>>
>
> You don't even need a BPF probe for this. See [0] for how retsnoop is
> converting bpf_ktime_get_ns() into real time.
>
>   [0] https://github.com/anakryiko/retsnoop/blob/master/src/retsnoop.c#L6=
49-L668

Uh, neat! Thanks for the link :)

-Toke
