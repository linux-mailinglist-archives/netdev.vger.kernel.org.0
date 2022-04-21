Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B350950A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 04:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343518AbiDUCac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 22:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243732AbiDUCac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 22:30:32 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DE62BF0;
        Wed, 20 Apr 2022 19:27:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y20so7142853eju.7;
        Wed, 20 Apr 2022 19:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R3JuWxV3MEVv1Lzcod+dHK0KjwdRCKAyPORx4Cnws3Y=;
        b=YmffCP0vsltafj0PR01HbipYBVztaVFa0dkqW7KzyhMrRRZxn2+UgbgF09l4C6DG23
         vD1E1GS210baqKsSLGQwPTwuPYitinUMRBogRf9EmVi+W43AvkGk3/rm5LcVzcq5/QEi
         8po1wsvLj9nhjnsezpZSW8DJ1RshRr0KZJU1lKWWM9Y4fqvrDXcaWM2ZIT8qXjee6fpa
         D89RRkitKmLFtBM4mOdfjBpYJGZddh6I8LsIDSSeYATKCoHhRxwjbTPz1QiP4pPPOIkB
         +vyBYuDxWdyjksxd9xfaymviHVxjhTWDFI2V54VKG1+Xr0igYxDj08KGEsyDWYCMAk4Z
         nM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R3JuWxV3MEVv1Lzcod+dHK0KjwdRCKAyPORx4Cnws3Y=;
        b=bdQwMgnaGdNgLmgACqYA1a8lxkzynKq2MqL6A7hUozzTdI3j/rtbqmdc1j/yiRFzMf
         7p5a4xof7DffkZ2xeoZEUe3sumhP5ACdOTLtc8+K1kEF2UyEMdCLNXP+v4eLOsJaCMPF
         PPEhD6YVeSmJBr0s0BrtUB3KbyxIH744Y6Vb9Y0K8P1zuDaNQV07hLaVPHy031uOnesj
         EScyk3dPSTS/C98Oghggt8ATszXJpx6gN2ApubRJE6HkKarCk6UH0fEZwb2PvzDrYfTI
         9mdsfjEcSJ4NzO5gXUlWsNKTJYgUELkwIecLgnnVVQ9MAoWY6i39FaRGT76Uof00qSzF
         SdMA==
X-Gm-Message-State: AOAM530BPRO2MxhWYUTEwUvuW5RjLGUzXkwyMsjOTki978WtL/1Krrtt
        YM4sIsSFSr2aDJaM7vbc/x9B2uBkfgRCINUb2CU=
X-Google-Smtp-Source: ABdhPJxvipLBGmLxZpw6NAUSz1qUACyI4Q9SC2Vznyp+9pzjd8/bGlMlbItSS3SvX1Vk9pIjqmwcQsaLXR3ZvRFGZ3M=
X-Received: by 2002:a17:907:7204:b0:6e8:c1e9:49f7 with SMTP id
 dr4-20020a170907720400b006e8c1e949f7mr20948912ejc.251.1650508062095; Wed, 20
 Apr 2022 19:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220420122307.5290-1-xiangxia.m.yue@gmail.com> <878rrzj4r6.fsf@toke.dk>
In-Reply-To: <878rrzj4r6.fsf@toke.dk>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 21 Apr 2022 10:27:05 +0800
Message-ID: <CAMDZJNVo1dwUA3gkUc8UKEthDtM8m2yif-4CE7aGxtJyANVgpw@mail.gmail.com>
Subject: Re: [net-next v1] bpf: add bpf_ktime_get_real_ns helper
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
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

On Wed, Apr 20, 2022 at 8:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@kern=
el.org> wrote:
>
> xiangxia.m.yue@gmail.com writes:
>
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch introduce a new bpf_ktime_get_real_ns helper, which may
> > help us to measure the skb latency in the ingress/forwarding path:
> >
> > HW/SW[1] -> ip_rcv/tcp_rcv_established -> tcp_recvmsg_locked/tcp_update=
_recv_tstamps
> >
> > * Insert BPF kprobe into ip_rcv/tcp_rcv_established invoking this helpe=
r.
> >   Then we can inspect how long time elapsed since HW/SW.
> > * If inserting BPF kprobe tcp_update_recv_tstamps invoked by tcp_recvms=
g,
> >   we can measure how much latency skb in tcp receive queue. The reason =
for
> >   this can be application fetch the TCP messages too late.
>
> Why not just use one of the existing ktime helpers and also add a BPF
> probe to set the initial timestamp instead of relying on skb->tstamp?
Yes, That also looks good to me.
> -Toke



--=20
Best regards, Tonghao
