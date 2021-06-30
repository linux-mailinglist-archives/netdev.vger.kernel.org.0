Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371233B8860
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhF3S2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhF3S2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:28:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FA2C061756;
        Wed, 30 Jun 2021 11:25:33 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b5so1985656plg.2;
        Wed, 30 Jun 2021 11:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RvDcmONdyX10LsCogZh526Ob3MOiNIiyAoMdUbjNYVY=;
        b=IhbSgoSqRJnLgBW0+P9Yus/OfADtejJOvJioaPlYT8TnMYVhk6wKXe0dviexFIDz2h
         3SL1aYsFBV3h4QiJ/oV2RbIQEnScB7ta/T4Agx85ImkxggVv7u/rLnHbEpUFH4usl1R0
         D8tEgceKFC1b+hFoD6roduWWlKQX0JEfEflfQ/vvOqZhxvD9mg9c7ZTNq+fNg6/vw9gU
         ll0k9nWkbHckQFPWm9tV0cD+qzn1TDfJdp3RrdqU8mZw6Otv3fckMn/7irfUOVZvGRlV
         1r65NAenCEvmS1A94qFcKBIPBpNqD6WioQSyKJTJtsmZi/BqxuT4T16UZ8y6O12j6vUz
         s40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RvDcmONdyX10LsCogZh526Ob3MOiNIiyAoMdUbjNYVY=;
        b=TVBT+APJDKHYQurzxvhoC4AYvjwy4QyNvfTUUI3uuItUZBvYbhYevjBFXwYHx4oyL2
         Fd7udTThbtcqlYHVn+xuzZgv79sz7CxppdvMkojDzWijoL84B8oaIVJMKTbTaAn9nsP6
         m5+wWALA/97DHmQab4FJK6J5bgHpEPr0ZTzn2d6/NyoYpsaDp8VFdMYPfjIvPF6f6XuQ
         oSoKu/s5c0z9bA2SDpti/L348493uU8bN1FfbitOoYhRnPIxthnTPCbMhgv33pzLZ1gX
         ETaur86n/QvVKyk3raWLuF28WpQIzBM+/ly+zuGgeXAso/ZQjnfFrVGAOEkkt113ztZw
         1Omg==
X-Gm-Message-State: AOAM531Oe+Qz1D89r0HF7uHpfLQcf3H0PbTp7fAqrkSGM4iVOy4MebqB
        7PiVwiU75o3brhhkXuHj6TY=
X-Google-Smtp-Source: ABdhPJyTWwng5BNPKZMORDtd68eMkisMZMmSgfZ9BQ8f9UMeX7EpBKiEVBUHIZRyaJOGP40V3igW9g==
X-Received: by 2002:a17:90a:8403:: with SMTP id j3mr41618840pjn.212.1625077533070;
        Wed, 30 Jun 2021 11:25:33 -0700 (PDT)
Received: from [192.168.93.106] (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id c24sm20423489pfn.86.2021.06.30.11.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 11:25:32 -0700 (PDT)
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in
 tcp_init_transfer.
To:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com,
        Yuchung Cheng <ycheng@google.com>
References: <20210628144908.881499-1-phind.uet@gmail.com>
 <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
 <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com>
 <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com>
 <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com>
 <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
 <205F52AB-4A5B-4953-B97E-17E7CACBBCD8@gmail.com>
 <CANn89iJbquZ=tVBRg7JNR8pB106UY4Xvi7zkPVn0Uov9sj8akg@mail.gmail.com>
 <1786BBEE-9C7B-45B2-B451-F535ABB804EF@gmail.com>
 <CANn89iK4Qwf0ezWac3Cn1xWN_Hw+-QL-+H8YmDm4cZP=FH+MTQ@mail.gmail.com>
 <CADVnQyk9maCc+tJ4-b6kufcBES9+Y2KpHPZadXssoVWX=Xr1Vw@mail.gmail.com>
From:   Phi Nguyen <phind.uet@gmail.com>
Message-ID: <30527e25-dd66-da7a-7344-494b4539abf7@gmail.com>
Date:   Thu, 1 Jul 2021 02:25:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CADVnQyk9maCc+tJ4-b6kufcBES9+Y2KpHPZadXssoVWX=Xr1Vw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/2021 11:59 PM, Neal Cardwell wrote:
>    On Tue, Jun 29, 2021 at 8:58 AM Eric Dumazet <edumazet@google.com> wrote:
>  From my perspective, the bug was introduced when that 8919a9b31eb4
> commit introduced icsk_ca_initialized and set icsk_ca_initialized to 0
> in tcp_init_transfer(), missing the possibility that a process could
> call setsockopt(TCP_CONGESTION)  in state TCP_SYN_SENT (i.e. after the
> connect() or TFO open sendmsg()), which would call
> tcp_init_congestion_control(). The 8919a9b31eb4 commit did not intend
> to reset any initialization that the user had already explicitly made;
> it just missed the possibility of that particular sequence (which
> syzkaller managed to find!).
> 
>> Although I am not sure what happens at accept() time when the listener
>> socket is cloned.
> 
> It seems that for listener sockets, they cannot initialize their CC
> module state, because there is no way for them to reach
> tcp_init_congestion_control(), since:
> 
> (a) tcp_set_congestion_control() -> tcp_reinit_congestion_control()
> will not call tcp_init_congestion_control() on a socket in CLOSE or
> LISTEN
> 
> (b) tcp_init_transfer() -> tcp_init_congestion_control() can only
> happen for established sockets and successful TFO SYN_RECV sockets
Is this what was mentioned in this commit ce69e563b325(tcp: make sure 
listeners don't initialize congestion-control state)

> --
> [PATCH] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
> 
> This commit fixes a bug (found by syzkaller) that could cause spurious
> double-initializations for congestion control modules, which could cause memory
> leaks orother problems for congestion control modules (like CDG) that allocate
> memory in their init functions.
> 
> The buggy scenario constructed by syzkaller was something like:
> 
> (1) create a TCP socket
> (2) initiate a TFO connect via sendto()
> (3) while socket is in TCP_SYN_SENT, call setsockopt(TCP_CONGESTION),
>      which calls:
>         tcp_set_congestion_control() ->
>           tcp_reinit_congestion_control() ->
>             tcp_init_congestion_control()
> (4) receive ACK, connection is established, call tcp_init_transfer(),
>      set icsk_ca_initialized=0 (without first calling cc->release()),
>      call tcp_init_congestion_control() again.
> 
> Note that in this sequence tcp_init_congestion_control() is called twice
> without a cc->release() call in between. Thus, for CC modules that allocate
> memory in their init() function, e.g, CDG, a memory leak may occur. The
> syzkaller tool managed to find a reproducer that triggered such a leak in CDG.
> 
> The bug was introduced when that 8919a9b31eb4 commit introduced
> icsk_ca_initialized and set icsk_ca_initialized to 0 in tcp_init_transfer(),
> missing the possibility for a sequence like the one above, where a process
> could call setsockopt(TCP_CONGESTION) in state TCP_SYN_SENT (i.e. after the
> connect() or TFO open sendmsg()), which would call
> tcp_init_congestion_control(). The 8919a9b31eb4 commit did not intend to reset
> any initialization that the user had already explicitly made; it just missed
> the possibility of that particular sequence (which syzkaller managed to find).

Could I use your commit message when I resubmit patch?

Thank you.

