Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7FC49C23D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237241AbiAZDnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiAZDm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:42:59 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B25BC06161C;
        Tue, 25 Jan 2022 19:42:58 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id u24so20863547eds.11;
        Tue, 25 Jan 2022 19:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJh6Gl0X5Jxqx/KBCv5jGNWBnDhkT6dufJwLR72NTuM=;
        b=UcYqUe+0Bj1qOmuRE8vr8zwZy+xIshnzUejSCPOp0rOjO3OocyUZtfpULJ5++G8nEu
         18ffB7iyrCEPTIf5AJa3IA6MTIU9ViGnhZ804wQB6V8jrjQ1nFdNHWRK+MBDXYmPlf73
         5vNy08gZ/G6HD5bpm2MYtdr1LU/NBb1IumA4zdu8FOzoNTl4MAWtPr7p5Kw34NPIPf60
         Q9aUhjVFRBpccb2hCKBFS+aixISK4dAFy4G+dRsSuQF8hewDhPGLtan79VHVdDz3fTNB
         2nI5c4JzHOqdLraaEwSOIDn3bJlQvFa6s0mJNM1UUvYM0KdvXZGK53V1X8gV5jfV2Yp2
         CsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJh6Gl0X5Jxqx/KBCv5jGNWBnDhkT6dufJwLR72NTuM=;
        b=vkxZ0pYsjCJoae2EBQxj4uxJz+ix4B+OQa4n+1gTIuUo5yr1tKNQPCDsou2L6AntGG
         KFesFsLmLQEpcxJ2h3e2Vq0rf+JnWagbiQOZeKRcuNNftpaBYnyHUXKqTAHlt6QtbKuz
         IWMDhFRn/43AITQDaHqDkc6TxgV909NDFIZY1o1VzYKGOHeTgEymXUgOwmiFT9Io/nXf
         M8gjvuWNsTMsU2he1UFqv5yxvy3oVX5hcp/wNDfBFwI15VDXLlqra+dCd4kfhxFQZxVT
         JoxgM7lFGFQlND9tcpSeF9Pd1ch1SfDYr4XLTKMEcDFYsVw1Vw3F6GcjVOWPddwz6Dwv
         Zt5Q==
X-Gm-Message-State: AOAM5311oWzfPLH9WXgV/+0GgP6FK4hPsatRfEBIatS9BGnz/MrNBwzn
        rJRkJyKHnvWM+hORWMf3/XIJTLU09JiPSgYSOINQYFfO
X-Google-Smtp-Source: ABdhPJxJEXuebIZ+PWX+MRXv3OdHNFNDKzr78cY3+GIryJ2nqAJtB8K9uKgMfEWQPxPWfEa79zUcXkXIvR7Clnex2n0=
X-Received: by 2002:a05:6402:2812:: with SMTP id h18mr23749163ede.103.1643168577305;
 Tue, 25 Jan 2022 19:42:57 -0800 (PST)
MIME-Version: 1.0
References: <20220124075955.1232426-1-imagedong@tencent.com> <20220125193826.58ee023f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125193826.58ee023f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 26 Jan 2022 11:38:29 +0800
Message-ID: <CADxym3ZJ14sXYVzoecQ97uqyuy_+N+mwjjh0x8Hyy_o7XTVCpw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: drop_monitor: support drop reason
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:38 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 24 Jan 2022 15:59:55 +0800 menglong8.dong@gmail.com wrote:
> > @@ -606,6 +608,7 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
> >  static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
> >                                    size_t payload_len)
> >  {
> > +     enum skb_drop_reason reason = NET_DM_SKB_CB(skb)->reason;
> >       u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
>
> nit: maybe it's better to get a pointer to struct net_dm_skb_cb here
> instead of local var for each field?

Yeah, I think it's a good idea :/

>
> >       char buf[NET_DM_MAX_SYMBOL_LEN];
> >       struct nlattr *attr;
> > @@ -623,6 +626,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
> >       if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
> >               goto nla_put_failure;
> >
> > +     if (nla_put_u32(msg, NET_DM_ATTR_REASON, reason))
> > +             goto nla_put_failure;
