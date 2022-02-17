Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8EE4B95D5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiBQCQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:16:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiBQCQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:16:24 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357C229410A;
        Wed, 16 Feb 2022 18:16:11 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id i5so4469944oih.1;
        Wed, 16 Feb 2022 18:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OqSul6ANW/QbWM5nJmKFQS7sLKmAgK3oE6LVLATJcUM=;
        b=WBQqF/wMYngujPO86PUQoJDnYbW1Kza0Afi0kWbcC4O0xeaoiR1JLAlhYLxg0U+aeQ
         KllsxJZh6Lgfge7TFv/qJLh9On+WBvApc9b4D+lJqa3ZX9ifgfm5thq/1uzpy6IuZ8JJ
         +QiwUx9BS3uoNtW5HHZDddoT1cwuXMFscN4ceVgNAodPsOmdLNV9IZHFtHyrK8tca0uN
         3vfjdzcpTC0q3UPHBs5RU8ts0DFVXpCm902JQft+eJBk5xrGUEVhFZhIbxmt+FBcKNC2
         8tfxiWwNHAS8qK8+dH4wxodiKg7/AYMd53RPxg+inPEe6kRTNsxoGUZS25omY4Cn++Xv
         9SuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OqSul6ANW/QbWM5nJmKFQS7sLKmAgK3oE6LVLATJcUM=;
        b=622I5myiYVuwOqlpajblyzPlIYdY2ohRRSa0BxaVpz/9yW57PRO/x/yoBNn/HpYhkh
         VLp+rmMInI0rC31CubOGjE37GRykVhzFdMpTpOqdt0H2hX+L0vxp1TL2ceC8uYoj8YCq
         XcLqcuZXV0AGyygxr9Tq1Y31Ax/ch+1XViaAyhngFBJU0U7nLT4utYXUDhCCDykRyzq0
         tgieDSwbkaFCgNCHoPu+8AZZSZrcSaY0QfGcib9LTh44tHz4oGVR6Gxhs6ORboRGAj4s
         AfdBqOVNT9FUjrbzoy+jksj5ocjcg9QyV0Ybd6+fYr5gE/FlA4fHLGxyiNvaoQzpNpbz
         byAg==
X-Gm-Message-State: AOAM530XBHVISi3W51B56zvIrUcw9eOh/e0uoG4oiU/JRS2hWJFLWRgX
        WwvDlJxCk1WGz98jbzr2+zZ2xLSPcd6kJZmx2FU=
X-Google-Smtp-Source: ABdhPJzaclshwR5cQLstIxZ+jLltu47WD/h0Kg9Bcy075XYW5dO9RoFPJYY+ZUKRXE7u1rvnBgs2iud51CDLXZSO/AE=
X-Received: by 2002:aca:1812:0:b0:2d4:426d:c9e0 with SMTP id
 h18-20020aca1812000000b002d4426dc9e0mr1835063oih.129.1645064170519; Wed, 16
 Feb 2022 18:16:10 -0800 (PST)
MIME-Version: 1.0
References: <20220216050320.3222-1-kerneljasonxing@gmail.com>
 <CANn89i+6Hc7q-a=zh_jcTn9_GM5xP6fzv2RcHY+tneqzE3UnHw@mail.gmail.com>
 <CAL+tcoBnSDjHk_Xhd_ohQjpMu-Ns2Du4mWhUybrK6+VPXHoETQ@mail.gmail.com> <CANn89iJTrH1sgstrEw17OUwC8jLBS9_uk_oUd5Hj0-FypTvvPw@mail.gmail.com>
In-Reply-To: <CANn89iJTrH1sgstrEw17OUwC8jLBS9_uk_oUd5Hj0-FypTvvPw@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 17 Feb 2022 10:15:30 +0800
Message-ID: <CAL+tcoCOX8A4gFDr5_QdLJ0PgwdBAbECtu4yh+RVTTJSp7yQyA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: introduce SO_RCVBUFAUTO to let the
 rcv_buf tune automatically
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Wei Wang <weiwan@google.com>,
        Alexander Aring <aahringo@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Florian Westphal <fw@strlen.de>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>
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

On Thu, Feb 17, 2022 at 12:56 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Feb 15, 2022 at 10:58 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > Just now, I found out that the latest kernel has merged a similar
> > patch (commit 04190bf89) about three months ago.
>
> There you go :)
>
> >
> > Is it still necessary to add another separate option to clear the
> > SOCK_RCVBUF_LOCK explicitly?
>
> What do you mean, SO_BUF_LOCK is all that is needed.

Yeah, I think SO_BUF_LOCK is enough and we don't have to add a new
option like SOCK_RCVBUF_LOCK as we've talked about before. Thanks,
Eric.
