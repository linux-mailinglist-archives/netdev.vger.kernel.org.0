Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC3BF5800
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbfKHUAn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 15:00:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729833AbfKHUAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:00:42 -0500
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 60F4E821E2
        for <netdev@vger.kernel.org>; Fri,  8 Nov 2019 20:00:42 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id x5so1524362ljh.9
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 12:00:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qG5pX45gqbqgt+VLx3ZjRVv+L6FBbAKqh5UrCUuYNjo=;
        b=nZnJtcxwzXnYOMG5K+2ASzNFsXUX3fRkQWFZ+2+eryoRDFJ3aZ8SFLxGGW605IxEJk
         Iutku/VqYE1Decj+MGGIyqa5z/NcT3S6xMBLqOLiX07gjPM461m67UugVCB5BF7dDDlr
         i7HJQEI6Ns73Z7k7mSh3lq7kUjq+vxfNA/DLzKiEcII9jNCMg6Jz/NxFx2i0F2Izo+BQ
         PLpqOtkQn3GVl+kRzUBjo3MNK4qIKVpTv9otf9mKnq50nciQbIII+50T3SiylRCJBzrm
         B+dOcmbw87Gvn5XZw09Mwv9iGzlgILW3bU6+c4xLOVMomT1p0GOkvbojPCBQJH9A5Aae
         Farw==
X-Gm-Message-State: APjAAAUswdlWhTZvsOW32NHe7nbPIHd0TQLOhKNz0o3ZKUa25JZWAQXD
        I65pR3fc99uZVN8jBiRy9TkbNa2Kghy9Yk1kQASD2390E5WrapRxeZWx8PfQwoLSq9eNDmWxjNz
        ShjWuCCoea9cicHMz
X-Received: by 2002:a05:6512:cf:: with SMTP id c15mr541384lfp.92.1573243240928;
        Fri, 08 Nov 2019 12:00:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3KRIyyJtyr6xfpzu00SYuEjhR/UcZ7yKD4FlZJR7wm45/z141T9Wkea9jRVLo9JN2qMv0mQ==
X-Received: by 2002:a05:6512:cf:: with SMTP id c15mr541374lfp.92.1573243240775;
        Fri, 08 Nov 2019 12:00:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id a11sm3186951ljp.97.2019.11.08.12.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 12:00:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0DE861818B6; Fri,  8 Nov 2019 21:00:39 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/6] selftests/bpf: Add tests for automatic map unpinning on load failure
In-Reply-To: <CAPhsuW5stGGGiVH9dSHC4i0kwNcrUhj892DypkfzL=b7woRLvA@mail.gmail.com>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk> <157314554027.693412.3764267220990589755.stgit@toke.dk> <CAPhsuW5stGGGiVH9dSHC4i0kwNcrUhj892DypkfzL=b7woRLvA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 08 Nov 2019 21:00:39 +0100
Message-ID: <87tv7ecf4o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu <liu.song.a23@gmail.com> writes:

> On Thu, Nov 7, 2019 at 8:52 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> This add tests for the different variations of automatic map unpinning on
>> load failure.
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>
> [...]
>
>> diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/testing/selftests/bpf/progs/test_pinning.c
>> index f69a4a50d056..f20e7e00373f 100644
>> --- a/tools/testing/selftests/bpf/progs/test_pinning.c
>> +++ b/tools/testing/selftests/bpf/progs/test_pinning.c
>> @@ -21,7 +21,7 @@ struct {
>>  } nopinmap SEC(".maps");
>>
>>  struct {
>> -       __uint(type, BPF_MAP_TYPE_ARRAY);
>> +       __uint(type, BPF_MAP_TYPE_HASH);
>
> Why do we need this change?

Because it needs to be different from the top map: I'm changing which of
the maps to use for the "check for parameter mismatch" selftest; the
last map needs to be the one that fails, so that a previous one can
succeed first and get removed on failure clean-up (which we can then
test for)...

-Toke
