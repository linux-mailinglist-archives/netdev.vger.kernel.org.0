Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2735164213
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgBSK2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:28:16 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33627 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726487AbgBSK2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 05:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582108094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXI0vzQ/32o7Z8p5s0zKYHP5YIIZ9uPsSeeuIvMaYPk=;
        b=RmpgJnXDkf4NVHWusImHOCtl7/RzPdDfu+uQPWTWe+H4vwvcHZSK3Qz4PobOs3goa/AgaV
        dsTrjMRLgtZTm8l9RedjI1yVIBgmNONprZqU21685LWDB0sIt1hYLDX6lUuOYas/Zo/Zj9
        DKS/p7aUBKoTugtRnNZX0mieLIumtoA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-V5zJmZxvPyuaFzNh3AVdaw-1; Wed, 19 Feb 2020 05:28:12 -0500
X-MC-Unique: V5zJmZxvPyuaFzNh3AVdaw-1
Received: by mail-lf1-f72.google.com with SMTP id i29so2924212lfc.18
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 02:28:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=vXI0vzQ/32o7Z8p5s0zKYHP5YIIZ9uPsSeeuIvMaYPk=;
        b=FGy2fFkQuAgSUUbiaU9WsioYVcaRNsAAHwLbCMSqHh51ryZxItJfGuyb6A/zNZfra4
         knJ/H33F/6E8V455Ohu2cvUmysc0mye8VjzLo2ZB/fD+lqFTOlMvV0On3cwGLryhbQo2
         oOGHAyWa20GsShK1HjJqAGfBcXEBhA5tXs1GT7XZjVK+2WsDoVpfVc82uPxzczZeMVs4
         LOzTob+Yv2/v0c6msCMrOE3cXdVh4wKW9UMNmoDD+6lh6vn+zfYHfl/3QmynSmajRUyb
         TbFB0ViFf0LXgSHIaz8lUvKlY548QX3qNsZld8SMv978pmdux3zFReUKIzDFHjFlsJTw
         S6eQ==
X-Gm-Message-State: APjAAAXk2TeZgmJH8pyD4nwjjYOUx0W2CoD3nW6qDwhKa5vGgL5z8bbn
        5v+9VhoDpMX8QVZjhyPDfbgQjwJH1+2QP1Me0w8g52U9/AIb/CeQvjNE2nvDFcUeWlavQ7ABZZo
        JyiZikeGBKNm85Mf9
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr15691804lja.16.1582108090945;
        Wed, 19 Feb 2020 02:28:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqxf4fBztSDmrjRNU4tO6ynotwCqNMQvOY7VRbFJDZ9p9yu/ijggDFH6aB3OGsvS978dpq7GLg==
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr15691794lja.16.1582108090681;
        Wed, 19 Feb 2020 02:28:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k4sm954208lfo.48.2020.02.19.02.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 02:28:09 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 49136180365; Wed, 19 Feb 2020 11:28:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf] libbpf: Sanitise internal map names so they are not rejected by the kernel
In-Reply-To: <e7a1f042-a3d7-ad25-e195-fdd5f8b78680@iogearbox.net>
References: <20200217171701.215215-1-toke@redhat.com> <9ddddbd6-aca2-61ae-b864-0f12d7fd33b4@iogearbox.net> <a0923745-ee34-3eb0-7f9b-31cec99661ec@fb.com> <87sgj7yhif.fsf@toke.dk> <e7a1f042-a3d7-ad25-e195-fdd5f8b78680@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 19 Feb 2020 11:28:09 +0100
Message-ID: <878skyyipy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 2/18/20 5:42 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Yonghong Song <yhs@fb.com> writes:
>>> On 2/18/20 6:40 AM, Daniel Borkmann wrote:
>>>> On 2/17/20 6:17 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>> The kernel only accepts map names with alphanumeric characters,
>>>>> underscores
>>>>> and periods in their name. However, the auto-generated internal map n=
ames
>>>>> used by libbpf takes their prefix from the user-supplied BPF object n=
ame,
>>>>> which has no such restriction. This can lead to "Invalid argument" er=
rors
>>>>> when trying to load a BPF program using global variables.
>>>>>
>>>>> Fix this by sanitising the map names, replacing any non-allowed
>>>>> characters
>>>>> with underscores.
>>>>>
>>>>> Fixes: d859900c4c56 ("bpf, libbpf: support global data/bss/rodata
>>>>> sections")
>>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>>
>>>> Makes sense to me, applied, thanks! I presume you had something like '=
-'
>>>> in the
>>>> global var leading to rejection?
>>>
>>> The C global variable cannot have '-'. I saw a complain in bcc mailing
>>> list sometimes back like: if an object file is a-b.o, then we will
>>> generate a map name like a-b.bss for the bss ELF section data. The
>>> map name "a-b.bss" name will be rejected by the kernel. The workaround
>>> is to change object file name. Not sure whether this is the only
>>> issue which may introduce non [a-zA-Z0-9_] or not. But this patch indeed
>>> should fix the issue I just described.
>
> Yep, meant object file name, just realized too late after sending. :/
>
>> Yes, this was exactly my problem; my object file is called
>> 'xdp-dispatcher.o'. Fun error to track down :P
>>=20
>> Why doesn't the kernel allow dashes in the name anyway?
>
> Commit cb4d2b3f03d8 ("bpf: Add name, load_time, uid and map_ids to bpf_pr=
og_info")
> doesn't state a specific reason, and we did later extend it via 3e0ddc4f3=
ff1 ("bpf:
> allow . char as part of the object name"). My best guess right now is pot=
entially
> not to confuse BPF's kallsyms handling with dashes etc.

Right, OK, fair enough I suppose. I was just wondering since this is
the second time I've run into hard-to-debug problems because of the
naming restrictions.

Really, it would be nice to have something like the netlink extack
mechanism so the kernel can return something more than just an error
code when a bpf() call fails. Is there any way to do something similar
for a syscall? Could we invent something?

-Toke

