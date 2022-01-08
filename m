Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4814885E6
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiAHU36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:29:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229822AbiAHU36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:29:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641673797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qj7dsc3TbQTpQjFsevsSiqeeT/F1CxGoWIT53pOVqj8=;
        b=MApipswkaxsv7joeiexyS7lEhCpucfXA9abpGrVmv7Z7BY2mHMzY8J//T7N+2mRquv9ROT
        IN0AB8Tq+Cx1pw7BvrlkSHf9UVMmw7Y94ivay+pshJg/KUXxm+7ufhAB2KqPBvPkbm2SSz
        Wb1maTPKar6wyh19j79LMDS3DFIfD8I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-e2em3PKhMWadt8rJSQgs2g-1; Sat, 08 Jan 2022 15:29:32 -0500
X-MC-Unique: e2em3PKhMWadt8rJSQgs2g-1
Received: by mail-wm1-f71.google.com with SMTP id i81-20020a1c3b54000000b003467c58cbddso6555447wma.5
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:28:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Qj7dsc3TbQTpQjFsevsSiqeeT/F1CxGoWIT53pOVqj8=;
        b=TEd8B0Cf/z5+PjLVmi5BVqvWfUgZ1MZSA5XBQ8gCxLhlV560qddBJ47tXWtcppUH/Z
         HSKdeSoyKn9r9nbvBVdErX/uuYwplDN1J6Kggsczxm+5d6fP7Iyc/dza8KJit2iPLeqc
         ljjpTPuTIgZ6fI6YTMgfdNkRlS9G1cd05bDq9QXI1lRmJZtiA7rF0X1v9KTVXXF18Wu+
         8SdG/G9HaRTcBuQunol/8f3wZiVFHiIsVTQJfownK2+BeEGWnamNzmlorQrNcuzw8fw7
         AfGnqollq8YR9azWtmLx1CJF6LpjsQyxW0EzI3A88V0GrOA8P8jl+bl7mP8IQMD0+ym8
         hZ4w==
X-Gm-Message-State: AOAM531HCBqcA0h4fUp9wlKLhFcydS//Qik67/otJ/VULpYJHxCgqVc/
        eC77gPQVK7C3Y+tmCPPqazSexg6X7YQFeTmtRZ9RqcV6aLNFGYU3KJaK+Hnb7ktVuMccfMvZBdy
        mW6xSKvEfzvNPyeNB
X-Received: by 2002:a05:6402:7c6:: with SMTP id u6mr9518203edy.160.1641673266922;
        Sat, 08 Jan 2022 12:21:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw637OB9UwwEZvCt/PZbRYxN23lqHu9QY6hm8Rbg8fQVT2Rz1bdSsr04k6EiSOvtdrGBjTbLQ==
X-Received: by 2002:a05:6402:7c6:: with SMTP id u6mr9518156edy.160.1641673266013;
        Sat, 08 Jan 2022 12:21:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 26sm767910ejk.138.2022.01.08.12.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:21:05 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 05A7F181F2A; Sat,  8 Jan 2022 21:21:05 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        syzbot <syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf v2 1/3] xdp: check prog type before updating BPF link
In-Reply-To: <CAADnVQLBDwUEcf63Jd2ohe0k5xKAcFaUmPL6tC-h937pSTzcCg@mail.gmail.com>
References: <20220107221115.326171-1-toke@redhat.com>
 <CAADnVQLBDwUEcf63Jd2ohe0k5xKAcFaUmPL6tC-h937pSTzcCg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 08 Jan 2022 21:21:04 +0100
Message-ID: <87k0fa7zdb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Jan 7, 2022 at 2:11 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> The bpf_xdp_link_update() function didn't check the program type before
>> updating the program, which made it possible to install any program type=
 as
>> an XDP program, which is obviously not good. Syzbot managed to trigger t=
his
>> by swapping in an LWT program on the XDP hook which would crash in a hel=
per
>> call.
>>
>> Fix this by adding a check and bailing out if the types don't match.
>>
>> Fixes: 026a4c28e1db ("bpf, xdp: Implement LINK_UPDATE for BPF XDP link")
>> Reported-by: syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com
>> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Thanks a lot for the quick fix!
> The merge window is about to begin.
> We will land it as soon as possible when bpf tree will be ready
> to accept fixes.

You're welcome! That's fine; FWIW, I believe the patch applies cleanly
to bpf-next as well, if that makes things easier on your end :)

-Toke

