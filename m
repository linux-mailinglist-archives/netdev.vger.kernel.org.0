Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A261178D90
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 10:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgCDJhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 04:37:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31076 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729018AbgCDJhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 04:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583314653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0IrcE3YXDvxtZ3La+d/Q/pPChnMHlDDNnxDU+QIM4DE=;
        b=EvrB9wQCJbiAVt4isFKBzNjXd0XqDu9s97BAxM4mZcTP9Br0NY619TZ4IxvyPqP7kmMeLA
        WVprbWjFAAilhE09efXi/+Y1j9Zxj/Osxk8qQN9Ncot/r4x4fGotBIphyAHvvxNNb4uNK3
        L7JKXHfv0+rtvv3KSYnSuz8GzJPlB7E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-Fy-uJHexNVS5qyvYkfjazQ-1; Wed, 04 Mar 2020 04:37:32 -0500
X-MC-Unique: Fy-uJHexNVS5qyvYkfjazQ-1
Received: by mail-wr1-f69.google.com with SMTP id c6so595624wrm.18
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 01:37:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0IrcE3YXDvxtZ3La+d/Q/pPChnMHlDDNnxDU+QIM4DE=;
        b=JYtBXCl9YWL17GScMchDPmRs35ZrcEZWjNUsmYb9BAt1dlBCtDzelLyxErY8vuas/G
         haF/oLZ/LjVrfUgmUDQPmgjMNVR8wpzWVFzlaAAF6yS9mB7pGMyxt7cO+wAbKe/SZDuX
         3XEEn63YDI0sQos72OYt1glU/XrHZB/3TrcGU61dv10lrCZa+ezPEA5tUZOQ4M74uqEb
         RZ8fzx7Z2vH+Q2fTiuuHmEBroTMVFWmRBX0stTpdDncIIBw9ZG96PXMM+um1e3zp2Uj+
         E8Vm6rPgY4Y34xgUosUljQilOQeSGjWDVtgVHixSTiIIvtJsHdEBaf+c1haykAiWDtTD
         DL+Q==
X-Gm-Message-State: ANhLgQ1/VGseUOknzRNsgbOpZqUY2O9LLVXBH19srrB6vTuyO56mRUDP
        XMEicZGtbG8jy5qz92AjyPbuSj7VByUGVbAZwy4yGh2OusNryWN9eWRA64+ypW4GGuHYsbpknZk
        MfB2zb19KP/Jpgcy4
X-Received: by 2002:adf:f588:: with SMTP id f8mr3343994wro.188.1583314650339;
        Wed, 04 Mar 2020 01:37:30 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuCeDL3/OPOWGkyWWV5EFXJuUOMBPOiO8AVCfBsPGnKuTu2rCdFgvUy0flCNFO0RIrzVHkoNA==
X-Received: by 2002:adf:f588:: with SMTP id f8mr3343974wro.188.1583314650144;
        Wed, 04 Mar 2020 01:37:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k66sm644113wmf.0.2020.03.04.01.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:37:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C635A180331; Wed,  4 Mar 2020 10:37:27 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants used from BPF program side to enums
In-Reply-To: <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
References: <20200303003233.3496043-1-andriin@fb.com> <20200303003233.3496043-2-andriin@fb.com> <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net> <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 Mar 2020 10:37:27 +0100
Message-ID: <87blpc4g14.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Mar 3, 2020 at 3:01 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
>> > Switch BPF UAPI constants, previously defined as #define macro, to anonymous
>> > enum values. This preserves constants values and behavior in expressions, but
>> > has added advantaged of being captured as part of DWARF and, subsequently, BTF
>> > type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
>> > for BPF applications, as it will not require BPF users to copy/paste various
>> > flags and constants, which are frequently used with BPF helpers. Only those
>> > constants that are used/useful from BPF program side are converted.
>> >
>> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>
>> Just thinking out loud, is there some way this could be resolved generically
>> either from compiler side or via additional tooling where this ends up as BTF
>> data and thus inside vmlinux.h as anon enum eventually? bpf.h is one single
>> header and worst case libbpf could also ship a copy of it (?), but what about
>> all the other things one would need to redefine e.g. for tracing? Small example
>> that comes to mind are all these TASK_* defines in sched.h etc, and there's
>> probably dozens of other similar stuff needed too depending on the particular
>> case; would be nice to have some generic catch-all, hmm.
>
> Enum convertion seems to be the simplest and cleanest way,
> unfortunately (as far as I know). DWARF has some extensions capturing
> #defines, but values are strings (and need to be parsed, which is pain
> already for "1 << 1ULL"), and it's some obscure extension, not a
> standard thing. I agree would be nice not to have and change all UAPI
> headers for this, but I'm not aware of the solution like that.

Since this is a UAPI header, are we sure that no userspace programs are
using these defines in #ifdefs or something like that?

-Toke

