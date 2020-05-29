Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0B11E8656
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgE2SJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgE2SJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:09:58 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F155C03E969;
        Fri, 29 May 2020 11:09:58 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d10so243221pgn.4;
        Fri, 29 May 2020 11:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=80vBavyDrtgkerq51SzM+QtqxhSCU7Go2pUSAaWO15M=;
        b=QCvzld6VvUsBMgKQk0LAhOxI8cd484PIDwr1VSe/D6VcAFbaJctQmwvzPM1QsuCiEG
         mxnEnP8HQ9hl50f0zlImq4xCli8HQ/1oU9fG7PdCx+wtYdTe8LyTijodfelKPLiiInJ5
         LemgEd82KY5cAAykEwERcAhd2967MGMvkuUguVJRbU+Sea9JS6KFPGNxN0OfX4GrKI50
         aUIRFL1FSPQaHh5rIXCkimVbxTHfEV1aJuUi5vsRZUKX7vWEwwIsEEDo5CctW0v52LtR
         ok/6BX5zH4QYc8ebzQ9gr3xJsNrc0yoXt49R17g4yAS4ECag3oRXHAEekXGTs5wo60ui
         dTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=80vBavyDrtgkerq51SzM+QtqxhSCU7Go2pUSAaWO15M=;
        b=ME7cjoOgakNqTOxDddjYpNx0x7Py9moxVhRDBbM1pXnjtxRu31GsiYwgO0wyYw8ipq
         SNlwapt/j7lWwWWwv9rltb6cvyhvHLsOpl6UkEGbtHTutfLA1nJVLGw/51OolI1ajrF/
         zcjHY1z8QCt53yUNdJlvhhdsun5M/2/r76Zmz00Y0NbpJkHChJndXYX0P2etKXmc7lAP
         69FPi2O/OShkunQby5lIJqd0cJbiv8ru+wt7xk6GUo3V8xnZDP8CsRYiOpkZrCOVjqJo
         ZK798hRAKTyX0REBXROMsNavgWVDviJq4u2ObsMMo6zneqgTyvwtMOjoW7m6x39jwzIu
         vFOA==
X-Gm-Message-State: AOAM530Go2h1IEMqBQqLqjzwVKIKEjkO2ak+i+drZ2nOr1eUGBQsJ0ho
        jgkTVbyqFw5m1FkGQO9NKfg=
X-Google-Smtp-Source: ABdhPJzilrt8uz48UOWrWGKLIL4BLSvkKVi0dp722LpfkftUoh+VRjdt1TrHzd1hKCwR2cKr1pJEoA==
X-Received: by 2002:aa7:9d92:: with SMTP id f18mr10064301pfq.266.1590775798042;
        Fri, 29 May 2020 11:09:58 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b15sm120523pjb.18.2020.05.29.11.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 11:09:57 -0700 (PDT)
Subject: Re: general protection fault in inet_unhash
To:     Andrii Nakryiko <andriin@fb.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, guro@fb.com,
        kuba@kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <00000000000018e1d305a6b80a73@google.com>
 <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
 <CACT4Y+aNBkhxuMOk4_eqEmLjHkjbw4wt0nBvtFCw2ssn3m2NTA@mail.gmail.com>
 <da6dd6d1-8ed9-605c-887f-a956780fc48d@fb.com>
 <b1b315b5-4b1f-efa1-b137-90732fa3f606@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0d25f022-e68d-6a46-e0ad-813b56c66a88@gmail.com>
Date:   Fri, 29 May 2020 11:09:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b1b315b5-4b1f-efa1-b137-90732fa3f606@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/29/20 10:32 AM, Eric Dumazet wrote:

> L2TP seems to use sk->sk_node to insert sockets into l2tp_ip_table, _and_ uses l2tp_ip_prot.unhash == inet_unhash
> 
> So if/when BPF_CGROUP_RUN_PROG_INET_SOCK(sk) returns an error and inet_create() calls sk_common_release()
> bad things happen, because inet_unhash() expects a valid hashinfo pointer.
> 
> I guess the following patch should fix this.
> 
> Bug has been there forever, but only BPF_CGROUP_RUN_PROG_INET_SOCK(sk) could trigger it.
>

Official submission : https://patchwork.ozlabs.org/project/netdev/patch/20200529180838.107255-1-edumazet@google.com/

