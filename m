Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C221A3B720D
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 14:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhF2May (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 08:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhF2Max (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 08:30:53 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A16C061760;
        Tue, 29 Jun 2021 05:28:25 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m17so10807272plx.7;
        Tue, 29 Jun 2021 05:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=za4Y7630P8OYpKUpgNl6rrMIGOh/MhQGVvlgtl3zsCs=;
        b=QnTo3TD2vtvIsP+5AD1ZK2/zUTSArat8iK7DrLOlztVyIY1XhUOtKTPw86G2zVemrq
         ouKl7BDa9iLBpVv2ZQfd9xxgXUpEAyehaJahtv9+F87rVQX5JXDsehri/enTtXsrlwmt
         GGrKPU8o55bhNNpuOdxZvFpp3IqtsHDkyIUiCXgOCTxD8b8IA7qs4LO0a973dUjLFG6f
         6kCEa1b2Y3CY6ZLcLv15UddTZ1i6rnv8s4tYWDOzCm9MY3qQrReh8FykZphlJiRro+y4
         jgW2ay+W5GhCtzOfX0QeJ51ZqgOJNO6dpZ8a4MPEhr+YcN9eeKW2UziUp96hD9So5+LK
         IgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=za4Y7630P8OYpKUpgNl6rrMIGOh/MhQGVvlgtl3zsCs=;
        b=m96kdgmOY/ajrL3a11u1Fg4yiaFnnjG9VicdFkJ5Zy13fi+WoshnavWY/jcxwsiCYx
         FQ5rcMaT+aGEbARXRrOVoTCnPW20w5bypJ99jO60M2xryDA8jGnk4bKF4IYCXGOH01P4
         chUPitgQoZ2qw3CQ64K6eXXBtYa8Zph1Vb5S5gNImac/6YXodlrBSa4uL+HQSo5qWDjZ
         YGdYnWKP3wb5+fmXbzqTXeyOh7oVT5wsg+eygdxZMQb1yPrxRfG2ekfVKAE/4BwHzws9
         83ld99bNM6uWSkfFu6ql6MZiO7P3s37C9YMmZUr660I/zIES9YQWgUYDdXf9apztblBK
         tA8A==
X-Gm-Message-State: AOAM533pronddvOLn9XfIHRF0g5A0Z9F6Zr5Gb50Nrgeln08zlYDKfFI
        6ns4QrbIt115hUKIgfHw1nI=
X-Google-Smtp-Source: ABdhPJy6DLWhMPC49sYZCSKVrs6ztehkeKvKDBXaSm8tUFDnq+Kxu9ImATUp+Z5kOpRE56ufptFqww==
X-Received: by 2002:a17:902:a70c:b029:118:7b47:e5bf with SMTP id w12-20020a170902a70cb02901187b47e5bfmr27676238plq.9.1624969705086;
        Tue, 29 Jun 2021 05:28:25 -0700 (PDT)
Received: from [10.122.117.192] ([183.90.37.214])
        by smtp.gmail.com with ESMTPSA id c68sm17423218pfc.75.2021.06.29.05.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 05:28:24 -0700 (PDT)
Date:   Tue, 29 Jun 2021 20:28:20 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <CANn89iJbquZ=tVBRg7JNR8pB106UY4Xvi7zkPVn0Uov9sj8akg@mail.gmail.com>
References: <20210628144908.881499-1-phind.uet@gmail.com> <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com> <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com> <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com> <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com> <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com> <205F52AB-4A5B-4953-B97E-17E7CACBBCD8@gmail.com> <CANn89iJbquZ=tVBRg7JNR8pB106UY4Xvi7zkPVn0Uov9sj8akg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in tcp_init_transfer.
To:     Eric Dumazet <edumazet@google.com>
CC:     Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
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
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
Message-ID: <1786BBEE-9C7B-45B2-B451-F535ABB804EF@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On June 29, 2021 4:21:59 PM GMT+08:00, Eric Dumazet <edumazet@google=2Ecom>=
 wrote:
>On Tue, Jun 29, 2021 at 9:17 AM Nguyen Dinh Phi <phind=2Euet@gmail=2Ecom>
>wrote:
>>
>> On June 29, 2021 1:20:19 AM GMT+08:00, Neal Cardwell
><ncardwell@google=2Ecom> wrote:
>> >)
>> >
>> >On Mon, Jun 28, 2021 at 1:15 PM Phi Nguyen <phind=2Euet@gmail=2Ecom>
>wrote:
>> >>
>> >> On 6/29/2021 12:24 AM, Neal Cardwell wrote:
>> >>
>> >> > Thanks=2E
>> >> >
>> >> > Can you also please provide a summary of the event sequence that
>> >> > triggers the bug? Based on your Reported-by tag, I guess this is
>> >based
>> >> > on the syzbot reproducer:
>> >> >
>> >> >
>>
>>https://groups=2Egoogle=2Ecom/g/syzkaller-bugs/c/VbHoSsBz0hk/m/cOxOoTgPC=
AAJ
>> >> >
>> >> > but perhaps you can give a summary of the event sequence that
>> >causes
>> >> > the bug? Is it that the call:
>> >> >
>> >> > setsockopt$inet_tcp_TCP_CONGESTION(r0, 0x6, 0xd,
>> >> > &(0x7f0000000000)=3D'cdg\x00', 0x4)
>> >> >
>> >> > initializes the CC and happens before the connection is
>> >established,
>> >> > and then when the connection is established, the line that sets:
>> >> >    icsk->icsk_ca_initialized =3D 0;
>> >> > is incorrect, causing the CC to be initialized again without
>first
>> >> > calling the cleanup code that deallocates the CDG-allocated
>memory?
>> >> >
>> >> > thanks,
>> >> > neal
>> >> >
>> >>
>> >> Hi Neal,
>> >>
>> >> The gdb stack trace that lead to init_transfer_input() is as
>bellow,
>> >the
>> >> current sock state is TCP_SYN_RECV=2E
>> >
>> >Thanks=2E That makes sense as a snapshot of time for
>> >tcp_init_transfer(), but I think what would be more useful would be
>a
>> >description of the sequence of events, including when the CC was
>> >initialized previous to that point (as noted above, was it that the
>> >setsockopt(TCP_CONGESTION) completed before that point?)=2E
>> >
>> >thanks,
>> >neal
>>
>> I resend my message because I accidently used html format in last
>one=2E I am very sorry for the inconvenience caused=2E
>> ---
>> Yes, the CC had been initialized by the setsockopt, after that, it
>was initialized again in function tcp_init_transfer() because of
>setting isck_ca_initialized to 0=2E
>
>"the setsockopt" is rather vague, sorry=2E
>
>
>The hard part is that all scenarios have to be considered=2E
>
>TCP flows can either be passive and active=2E
>
>CC can be set :
>
>1) Before the connect() or accept()
>2) After the connect() or accept()
>3) after the connect() but before 3WHS is completed=2E
>
>So we need to make sure all cases will still work with any combination
>of CDG CC (before/after) in the picture=2E
>
>Note that a memory leak for a restricted CC (CDG can only be used by
>CAP_NET_ADMIN privileged user)
> is a small problem compared to more serious bug that could be added
>by an incomplete fix=2E
>
>I also note that if icsk_ca_priv] was increased from 104 to 120 bytes,
>tcp_cdg would no longer need a dynamic memory allocation=2E
>
>Thank you=2E

Hi,=20
I will try to see whether I am able to get the full sequence=2E I am also =
affraid of making a change that could affect big part of the kernel=2E
About CDG, how we can get rid of dynamic allocation by increasing icsk_pri=
v_data to 120? because I see that the window size is a module parameter, so=
 I guess it is not a fixed value=2E=20
Because the problem only happens with CDG, is adding check in its tcp_cdg_=
init() function Ok? And about  icsk_ca_initialized, Could I expect it to be=
 0 in CC's init functions?

Thank you=2E
