Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F02378F50
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbhEJNnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351209AbhEJNVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 09:21:30 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765CBC061763
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:20:24 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id u3so24427780eja.12
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XnLqubyFOR9LLpachU5WliqicYmoNsbEP8N7g/v6r6U=;
        b=k/bfDeWhlQNeG23nj64PAeOmwKRfvE2ovDxO6X2A1L3YeT5UYbWjRhbwVJPMGptd6Z
         sH4Y89NMdaZjDLOUhBtTf+rKgJzWHy7HcEyydPkWaP8Z5seKbE2/6TCydWgBdzt2Rtv5
         UHJ9Q+w5V7q4/qL2E5Bn8cqBbbCH4wAzHq6kgdHMm6/HmBNQ7piu0+rlSQBnNml9HySx
         oACdJ9WoZL98kwXnxAv+dQcVxFetvguq1eNonYQp2bhpAc2SlK+/LUfeiNmZjMzAHNWp
         cTaBJfVirHbCslxUU9nyAE2dDvWRa8NdNE4VsuqKZFKTq+shDGPk7eVoRTNtea38SV61
         O/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XnLqubyFOR9LLpachU5WliqicYmoNsbEP8N7g/v6r6U=;
        b=Y8CD/J7lI+gC5rrAd4RkRFI+PhCtzdLw1syLgdLU1VFNOZFa7PInBTFVUBwGk0X/Uz
         MOwnK69x45smb9zYTrCbjoSA+3TPKeoebnVykiRFNevfik4eOIuEzyoHi3AMMLzvcRU0
         C/G7kQ2yMfkD8NGIAaerkSuz5E1Puuw4XH9IDo+vfPzTjDOrzKBtYmMXc8xobbok/S5+
         oycApM8o0qKAirlJZb1+8+p1q5dadReR0NY+lvOsUVhv0YFHEjX16gVRakR2GLGeGReL
         sDdO/nZwxj2Gw4Ju3xVSjDBGqlQrMQIAZZpbmQ2u7ExVgWoEXNcNjOTHoa7JmrIdQf/L
         yLEg==
X-Gm-Message-State: AOAM531K9EiPkAuwz0Whj0LIyZsviA5xjWZ5iIWSK4/PADekeM//8QAg
        M2oRrQTR0zof1jyEIRaclXeOfeLZRIM=
X-Google-Smtp-Source: ABdhPJz2S2kwzF57Rf/TsiQy2VEiRaVkKidh0yh/hkr3GRZjRbdCHIcYGmlXyxj3B8R1RBZHhmmj3A==
X-Received: by 2002:a17:906:9990:: with SMTP id af16mr24973390ejc.195.1620652822843;
        Mon, 10 May 2021 06:20:22 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id e11sm11178153edq.76.2021.05.10.06.20.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 06:20:21 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id i128so9160825wma.5
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:20:21 -0700 (PDT)
X-Received: by 2002:a1c:c385:: with SMTP id t127mr26715596wmf.169.1620652820784;
 Mon, 10 May 2021 06:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com> <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
 <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com> <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
 <02c801d7421f$65287a90$2f796fb0$@samsung.com> <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
 <001801d742db$68ab8060$3a028120$@samsung.com> <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
 <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com> <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
 <007001d7431a$96281960$c2784c20$@samsung.com> <CAF=yD-L9pxAFoT+c1Xk5YS42ZaJ+YLVQVnV+fvtqn-gLxq9ENg@mail.gmail.com>
 <00c901d74543$57fa3620$07eea260$@samsung.com>
In-Reply-To: <00c901d74543$57fa3620$07eea260$@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 10 May 2021 09:19:43 -0400
X-Gmail-Original-Message-ID: <CA+FuTSepShKoXUJo7ELMMJ4La11J6CsZggJWsQ5MB2_uhAi+OQ@mail.gmail.com>
Message-ID: <CA+FuTSepShKoXUJo7ELMMJ4La11J6CsZggJWsQ5MB2_uhAi+OQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > That generates TCP packets with different MSS within the same stream.
> >
> > My suggestion remains to just not change MSS at all. But this has to
> > be a new flag to avoid changing established behavior.
>
> I don't understand why the mss size should be kept in GSO step. Will
> there be any issue with different mss?

This issue has come up before and that has been the feedback from
TCP experts at one point.

> In general, upgrading mss make sense when 6 to 4. The new flag would be
> set by user to not change mss. What happened if user does not set the
> flag? I still think we should fix the issue with a general approach. Or
> can we remove the skb_increase_gso_size line?

Admins that insert such BPF packets should be aware of these issues.
And likely be using clamping. This is a known issue.

We arrived that the flag approach in bpf_skb_net_shrink. Extending
that  to bpf_skb_change_proto would be consistent.
