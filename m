Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B6A17A368
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 11:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCEKuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 05:50:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725903AbgCEKuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 05:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583405437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LnaVwTHikH5+Oqr72grcKAz5tPkkznvOJar3gylcTUw=;
        b=ZUjMgrY4YYXF2TIANUSIN2/DXDAO/7W3TNgivB+IVYiVAHtm3Wjh19NriveBBsGPbcQ/Ui
        VTctt1bVzVTcw3YqT8g89mg2x4u/L31bM+BrWCTJgVyLmj34F26pQ8Sp0BGQ2nvaG+XFqs
        wQ1NM/LG7hnVtXtdOARPnEQPoDobmcg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395--T_vE6Y3OJKBxqwh0be4KQ-1; Thu, 05 Mar 2020 05:50:36 -0500
X-MC-Unique: -T_vE6Y3OJKBxqwh0be4KQ-1
Received: by mail-wm1-f71.google.com with SMTP id t2so1423672wmj.2
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 02:50:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LnaVwTHikH5+Oqr72grcKAz5tPkkznvOJar3gylcTUw=;
        b=RQXodoGXjTwqKCrVQ349H90cEFDpUc13TC81dd8GMzbrs0+EWa6F8L7toGIqb2vruY
         k1SdxFWS79Co4QUtn/Bd5ye9y+nZqt8P5arytl1562W9kf4Z4Jt7LU1LbOI6TMeX/cwm
         N1Fa1xlKuL542MtM50JmUE1dDIviTBHeK23l1XGTFX5rL1dBCnKBQzzLQkH09SKfVCSp
         Bkat5mSx31kwiYB7cOvTO116ghjdg+FuE3LJW9rEBIygVBPvfujJpOgZGuhQgVXVSraN
         uRNzLX9/LyZvAU9A+Af4lsuYzxBVvizH99ozuiu0hJgKsDpcpzzROgtsqQlcPc+8S9h+
         9vlA==
X-Gm-Message-State: ANhLgQ1N/euuIRAch6ouRC7gDCVwh1XFKkk50U85vPjdOnOvB3tpfz9l
        WhjzaoZWTLa5EUYN4caVxbjFPVkgITzP7zz8fvp1XgmRv7f3nUqvqeHidrDCJ2/hsX278JC1peb
        E7yyDNcNmhUIeJCTF
X-Received: by 2002:adf:e94c:: with SMTP id m12mr10047427wrn.71.1583405434994;
        Thu, 05 Mar 2020 02:50:34 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuiJS26FMmvgmsl72dprxh6lrHejxMX227sUrqbUl/ws+/SO870XmgAtUX6Jh1dT3ZgA/704g==
X-Received: by 2002:adf:e94c:: with SMTP id m12mr10047404wrn.71.1583405434732;
        Thu, 05 Mar 2020 02:50:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k65sm9223637wmf.1.2020.03.05.02.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 02:50:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B113318034F; Thu,  5 Mar 2020 11:50:32 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants used from BPF program side to enums
In-Reply-To: <c742d2d4-6596-3178-3d03-809270e67183@iogearbox.net>
References: <20200303003233.3496043-1-andriin@fb.com> <20200303003233.3496043-2-andriin@fb.com> <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net> <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com> <87blpc4g14.fsf@toke.dk> <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net> <c742d2d4-6596-3178-3d03-809270e67183@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 05 Mar 2020 11:50:32 +0100
Message-ID: <87y2sf2hzb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 3/4/20 4:38 PM, Daniel Borkmann wrote:
>> On 3/4/20 10:37 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>>> On Tue, Mar 3, 2020 at 3:01 PM Daniel Borkmann <daniel@iogearbox.net> =
wrote:
>>>>>
>>>>> On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
>>>>>> Switch BPF UAPI constants, previously defined as #define macro, to a=
nonymous
>>>>>> enum values. This preserves constants values and behavior in express=
ions, but
>>>>>> has added advantaged of being captured as part of DWARF and, subsequ=
ently, BTF
>>>>>> type info. Which, in turn, greatly improves usefulness of generated =
vmlinux.h
>>>>>> for BPF applications, as it will not require BPF users to copy/paste=
 various
>>>>>> flags and constants, which are frequently used with BPF helpers. Onl=
y those
>>>>>> constants that are used/useful from BPF program side are converted.
>>>>>>
>>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>>>
>>>>> Just thinking out loud, is there some way this could be resolved gene=
rically
>>>>> either from compiler side or via additional tooling where this ends u=
p as BTF
>>>>> data and thus inside vmlinux.h as anon enum eventually? bpf.h is one =
single
>>>>> header and worst case libbpf could also ship a copy of it (?), but wh=
at about
>>>>> all the other things one would need to redefine e.g. for tracing? Sma=
ll example
>>>>> that comes to mind are all these TASK_* defines in sched.h etc, and t=
here's
>>>>> probably dozens of other similar stuff needed too depending on the pa=
rticular
>>>>> case; would be nice to have some generic catch-all, hmm.
>>>>
>>>> Enum convertion seems to be the simplest and cleanest way,
>>>> unfortunately (as far as I know). DWARF has some extensions capturing
>>>> #defines, but values are strings (and need to be parsed, which is pain
>>>> already for "1 << 1ULL"), and it's some obscure extension, not a
>>>> standard thing. I agree would be nice not to have and change all UAPI
>>>> headers for this, but I'm not aware of the solution like that.
>>>
>>> Since this is a UAPI header, are we sure that no userspace programs are
>>> using these defines in #ifdefs or something like that?
>>=20
>> Hm, yes, anyone doing #ifdefs on them would get build issues. Simple exa=
mple:
>>=20
>> enum {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FOO =3D 42,
>> //#define FOO=C2=A0=C2=A0 FOO
>> };
>>=20
>> #ifndef FOO
>> # warning "bar"
>> #endif
>>=20
>> int main(int argc, char **argv)
>> {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return FOO;
>> }
>>=20
>> $ gcc -Wall -O2 foo.c
>> foo.c:7:3: warning: #warning "bar" [-Wcpp]
>>  =C2=A0=C2=A0=C2=A0 7 | # warning "bar"
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 ^~~~~~~
>>=20
>> Commenting #define FOO FOO back in fixes it as we discussed in v2:
>>=20
>> $ gcc -Wall -O2 foo.c
>> $
>>=20
>> There's also a flag_enum attribute, but with the experiments I tried yes=
terday
>> night I couldn't get a warning to trigger for anonymous enums at least, =
so that
>> part should be ok.
>>=20
>> I was about to push the series out, but agree that there may be a risk f=
or #ifndefs
>> in the BPF C code. If we want to be on safe side, #define FOO FOO would =
be needed.
>
> I checked Cilium, LLVM, bcc, bpftrace code, and various others at least t=
here it
> seems okay with the current approach, meaning no such if{,n}def seen that=
 would
> cause a build warning. Also suricata seems to ship the BPF header itself.=
 But
> iproute2 had the following in include/bpf_util.h:
>
> #ifndef BPF_PSEUDO_MAP_FD
> # define BPF_PSEUDO_MAP_FD      1
> #endif
>
> It's still not what was converted though. I would expect risk might be
> rather low.

OK, fair enough; thank you for checking :)

> Toke, is there anything on your side affected?

Nope, we're not #if-testing for any of the variables changed in this
patch in either xdp-tutorial or xdp-tools.

-Toke

