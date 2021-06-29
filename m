Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878B93B6EA1
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 09:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhF2HTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 03:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhF2HTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 03:19:54 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C796C061574;
        Tue, 29 Jun 2021 00:17:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id u14so11215342pga.11;
        Tue, 29 Jun 2021 00:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=2+Cu9SpYbGPGq/dBp+lKzry3SpkbCUR6ztL08O/s6WQ=;
        b=Umuv1mRarTEy7QYktWElHfzYOUIMQAxnUe/gAE87BfSvtXV148jd6rBS8Ul1b6lGh+
         xOYYGHOPnoX2KjubjaYmiUeyFjOrZGT8Klzmxc9S9/OH1fxWYcSx/e76lHnrhmEGU/k4
         aTd0452z6DYuwkx+UJEYnmqiLDN5FBj66uizlNWYf6pnhJTI4qO1Mh3F5rfjSEz8TCZG
         nRy31ybaRVlpCLOfEgQmBgAnGQH4jGFJXYrf2rF8Q4CzTYGKl55Rol0mUf6nz3lIaQSj
         hjDOfMgsJAy0S0nMlwPf+U2TkjBZmSCPcn7x8kYgPjUfE+O39TVekj7mJJYhcxM8Q7B9
         P/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=2+Cu9SpYbGPGq/dBp+lKzry3SpkbCUR6ztL08O/s6WQ=;
        b=kefJckr0MJRmZbABxHvRgwS/jd6qPHktBluOHPY63rV98xDkMs6cEbav7ExeGuPpLF
         nC47biV+VspQl3X4Mg2Muc+nlK3tSoZTuTjUzkTBF0bntNmJc7qBwPPAJpykdp13fi9x
         uha9/8zVATo5fj7F/2j68ZyhwuEN6xDe3R1dMqe9+xP6l0bLsDaW08MaV/ffzIbFTF6+
         zWE6fL1ktNQO1zF8gQ0lnY58MYeeey2taElSbh+XXlCsyuTBuYVEKakLsoFurIdgNMVE
         6Mm7vIgaRxo+ZUm1aFY2LhTkaoif/nLX9OwMZDJ/u4se1WfsBcPO0DVLKnGsbtbAP06E
         myWw==
X-Gm-Message-State: AOAM5303C8qQEYJRjtQ5XyA37tjXqZ+xetJj+5K4ukl7iefak5DYkMia
        osUisosPPDJwrbB3GaBqEy4=
X-Google-Smtp-Source: ABdhPJzjAoL145d3X7MXU034uajL/zhC7Mwao65kP6f3NvgS2bgyLNfXBRdAW/gyqWLcWtJQzOnTlw==
X-Received: by 2002:a62:3244:0:b029:308:22b0:52ff with SMTP id y65-20020a6232440000b029030822b052ffmr26641060pfy.68.1624951045936;
        Tue, 29 Jun 2021 00:17:25 -0700 (PDT)
Received: from [10.122.117.192] ([183.90.37.214])
        by smtp.gmail.com with ESMTPSA id w18sm18337383pjg.50.2021.06.29.00.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 00:17:25 -0700 (PDT)
Date:   Tue, 29 Jun 2021 15:17:20 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
References: <20210628144908.881499-1-phind.uet@gmail.com> <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com> <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com> <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com> <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com> <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in tcp_init_transfer.
To:     Neal Cardwell <ncardwell@google.com>
CC:     Eric Dumazet <edumazet@google.com>,
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
Message-ID: <205F52AB-4A5B-4953-B97E-17E7CACBBCD8@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On June 29, 2021 1:20:19 AM GMT+08:00, Neal Cardwell <ncardwell@google=2Eco=
m> wrote:
>)
>
>On Mon, Jun 28, 2021 at 1:15 PM Phi Nguyen <phind=2Euet@gmail=2Ecom> wrot=
e:
>>
>> On 6/29/2021 12:24 AM, Neal Cardwell wrote:
>>
>> > Thanks=2E
>> >
>> > Can you also please provide a summary of the event sequence that
>> > triggers the bug? Based on your Reported-by tag, I guess this is
>based
>> > on the syzbot reproducer:
>> >
>> > =20
>https://groups=2Egoogle=2Ecom/g/syzkaller-bugs/c/VbHoSsBz0hk/m/cOxOoTgPCA=
AJ
>> >
>> > but perhaps you can give a summary of the event sequence that
>causes
>> > the bug? Is it that the call:
>> >
>> > setsockopt$inet_tcp_TCP_CONGESTION(r0, 0x6, 0xd,
>> > &(0x7f0000000000)=3D'cdg\x00', 0x4)
>> >
>> > initializes the CC and happens before the connection is
>established,
>> > and then when the connection is established, the line that sets:
>> >    icsk->icsk_ca_initialized =3D 0;
>> > is incorrect, causing the CC to be initialized again without first
>> > calling the cleanup code that deallocates the CDG-allocated memory?
>> >
>> > thanks,
>> > neal
>> >
>>
>> Hi Neal,
>>
>> The gdb stack trace that lead to init_transfer_input() is as bellow,
>the
>> current sock state is TCP_SYN_RECV=2E
>
>Thanks=2E That makes sense as a snapshot of time for
>tcp_init_transfer(), but I think what would be more useful would be a
>description of the sequence of events, including when the CC was
>initialized previous to that point (as noted above, was it that the
>setsockopt(TCP_CONGESTION) completed before that point?)=2E
>
>thanks,
>neal

I resend my message because I accidently used html format in last one=2E I=
 am very sorry for the inconvenience caused=2E
---
Yes, the CC had been initialized by the setsockopt, after that, it was ini=
tialized again in function tcp_init_transfer() because of setting isck_ca_i=
nitialized to 0=2E
Regards,=20
Phi=2E
