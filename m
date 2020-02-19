Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702EA165284
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgBSW3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:29:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21237 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727469AbgBSW3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 17:29:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582151377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BRybc8sxCddd24vT1nlye7r7O7R0DpcpTVIioA7SFcI=;
        b=KQVHNkWSxSe1N3LeiuMbDAZPB6fBr3ZwxjVAWSx6sQGUYQ5pnjgYiE+yrnPpWD/qhwweOr
        xSFWypyaugBulZHGg9Eooj9hP9Jwxp+PNtOf63MgncO1t/z9p/OLOe6nxFxfuKrYDqQq9X
        BkDuH/74IWCfw9h1cdXCAah0WfNPgu0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-Xzv_q1QMPSGREqzecYt-aA-1; Wed, 19 Feb 2020 17:29:35 -0500
X-MC-Unique: Xzv_q1QMPSGREqzecYt-aA-1
Received: by mail-lf1-f70.google.com with SMTP id x79so528043lff.19
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 14:29:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BRybc8sxCddd24vT1nlye7r7O7R0DpcpTVIioA7SFcI=;
        b=dXuD82+9MrBZyo/w1DcDuVk5IDFMnE8DRTYP6ZTYL4Mw0jw/sqFDBT4TVhgqo4pjgD
         8M4jfIN5VEQKuCOKtXW3Xydr/tsug5TTX4hWI+HyWcyc5vLV5rzx92a1MISdod3Orwb3
         pQQwiS/E8RAuqSWT9HBpzycrJr1kLMPCA9bYcr62WFDHZSwWeKF8m8sqC14WlpCVaDoI
         44ziNp5c671ta6ajTsp7Fv+xz4VNgpiyJPWODXwWSNJ3HvFHxc1bkTXRNPOp18rNjOM4
         /8kgiGg8hOdLaPMK/wBuetonoFsHJMJWb3F+6D4z5yUSr6hHYM1imvRPZr1Np6IwxvZf
         vwCw==
X-Gm-Message-State: APjAAAW4rLkpMC+4wXLevc4IHuCFp7latJAKA7P8p4e6zJxTHUomH28G
        TSrHClKR7CTe/IQhuI/cDsGj0/tdPUTKgO5fWuMOvyXES07xlxB8Y/pl6cwge1+32MHkt+9Icpf
        SJJXOlT/DpVzK2xg8
X-Received: by 2002:ac2:555c:: with SMTP id l28mr14691680lfk.52.1582151374212;
        Wed, 19 Feb 2020 14:29:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqxc6aVcfJnfP1VotH2usBJXR3Riq0jeCoNz2ypR8KxRW6Ovyvnd8eBA9IpMzPUNtB288v3RHw==
X-Received: by 2002:ac2:555c:: with SMTP id l28mr14691666lfk.52.1582151373951;
        Wed, 19 Feb 2020 14:29:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y11sm592004lfc.27.2020.02.19.14.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 14:29:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1260B180365; Wed, 19 Feb 2020 23:29:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf] libbpf: Sanitise internal map names so they are not rejected by the kernel
In-Reply-To: <75035604-6cf8-515e-c0b0-569758ffa2e1@fb.com>
References: <20200217171701.215215-1-toke@redhat.com> <9ddddbd6-aca2-61ae-b864-0f12d7fd33b4@iogearbox.net> <a0923745-ee34-3eb0-7f9b-31cec99661ec@fb.com> <87sgj7yhif.fsf@toke.dk> <e7a1f042-a3d7-ad25-e195-fdd5f8b78680@iogearbox.net> <878skyyipy.fsf@toke.dk> <75035604-6cf8-515e-c0b0-569758ffa2e1@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 19 Feb 2020 23:29:30 +0100
Message-ID: <87imk2w6r9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song <yhs@fb.com> writes:

> On 2/19/20 2:28 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>=20
>>> On 2/18/20 5:42 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Yonghong Song <yhs@fb.com> writes:
>>>>> On 2/18/20 6:40 AM, Daniel Borkmann wrote:
>>>>>> On 2/17/20 6:17 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>>>> The kernel only accepts map names with alphanumeric characters,
>>>>>>> underscores
>>>>>>> and periods in their name. However, the auto-generated internal map=
 names
>>>>>>> used by libbpf takes their prefix from the user-supplied BPF object=
 name,
>>>>>>> which has no such restriction. This can lead to "Invalid argument" =
errors
>>>>>>> when trying to load a BPF program using global variables.
>>>>>>>
>>>>>>> Fix this by sanitising the map names, replacing any non-allowed
>>>>>>> characters
>>>>>>> with underscores.
>>>>>>>
>>>>>>> Fixes: d859900c4c56 ("bpf, libbpf: support global data/bss/rodata
>>>>>>> sections")
>>>>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>>>>
>>>>>> Makes sense to me, applied, thanks! I presume you had something like=
 '-'
>>>>>> in the
>>>>>> global var leading to rejection?
>>>>>
>>>>> The C global variable cannot have '-'. I saw a complain in bcc mailing
>>>>> list sometimes back like: if an object file is a-b.o, then we will
>>>>> generate a map name like a-b.bss for the bss ELF section data. The
>>>>> map name "a-b.bss" name will be rejected by the kernel. The workaround
>>>>> is to change object file name. Not sure whether this is the only
>>>>> issue which may introduce non [a-zA-Z0-9_] or not. But this patch ind=
eed
>>>>> should fix the issue I just described.
>>>
>>> Yep, meant object file name, just realized too late after sending. :/
>>>
>>>> Yes, this was exactly my problem; my object file is called
>>>> 'xdp-dispatcher.o'. Fun error to track down :P
>>>>
>>>> Why doesn't the kernel allow dashes in the name anyway?
>>>
>>> Commit cb4d2b3f03d8 ("bpf: Add name, load_time, uid and map_ids to bpf_=
prog_info")
>>> doesn't state a specific reason, and we did later extend it via 3e0ddc4=
f3ff1 ("bpf:
>>> allow . char as part of the object name"). My best guess right now is p=
otentially
>>> not to confuse BPF's kallsyms handling with dashes etc.
>>=20
>> Right, OK, fair enough I suppose. I was just wondering since this is
>> the second time I've run into hard-to-debug problems because of the
>> naming restrictions.
>>=20
>> Really, it would be nice to have something like the netlink extack
>> mechanism so the kernel can return something more than just an error
>> code when a bpf() call fails. Is there any way to do something similar
>> for a syscall? Could we invent something?
>
> Currently, BPF_PROG_LOAD and BPF_BTF_LOAD has log_buf as part of syscall=
=20
> interface. Esp. for BPF_PROG_LOAD, maybe we could put some non-verifier=20
> logs here?
>
> Maybe we could introduce log_buf to other syscall commands if there is
> a great need in user space to get more details about the error code?

Hmm, that's not a bad idea, actually. I guess I'll take a stab at that
the next time I get really annoyed at having to track down an -EINVAL ;)

Unless someone else beats me to it, of course, which would be great!

-Toke

