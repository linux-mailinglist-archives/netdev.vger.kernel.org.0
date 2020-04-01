Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220BB19A2CD
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 02:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731536AbgDAAWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 20:22:43 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41918 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgDAAWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 20:22:43 -0400
Received: by mail-qk1-f194.google.com with SMTP id q188so25266558qke.8;
        Tue, 31 Mar 2020 17:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wgLhFik1Yz4VLt7Ww52bG3jwibxRqCg9Dynuv72w1MA=;
        b=NHvcxDs9putsHLpu5wwFXKMhu7U32tRe1zoJXD5AlRt1eQCuYsb0zK6lEII63Jamgy
         J83OjlMWVlTHaJIBa5ISCoiCialL3VsLA79TEOGDJ2W6hw8obU7xcHYgpiJQmF6YaGRf
         1xvcOfn7t1xGQOJnP54r32KcN4MpG9nYD2+ZKVA/pfxjIn7BpIT7KFKrDylPEC51LgVM
         4XPZOrhmf7hMKrdZ/VAFj5y9O92Z0mtNyJG3rga0BtUKpfrHFh0WPTyK2bbkMJl/imR6
         QgaUnvANzVhGtWwtkEKD0GkeHrBNEMITIOxv4FJrRavzrEH48zMzo15KhQtXl2tRM/Ky
         lewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wgLhFik1Yz4VLt7Ww52bG3jwibxRqCg9Dynuv72w1MA=;
        b=d/fJtDmRwutpNhUI0q/OwN5NmNDbj2FUg1SGdKHq4s+pHlM/2kzIXu28rO33U1XzvI
         SM/VKynIpQOegy6YWfHLqANTApKDbfbq97t032Jh9OphQdatWCgWAlperZY7GLNI8HfU
         L1wDRmJBbxyRZ3P6sHDvVfepm42D6XA6HsFAUKveTWGMWzqRh+/Ga5it/nFlz7iwk32m
         fX16a9o9sX2n4bOtx2nr8U4eQOMJ9YJCw/c2bcR77g1f9sf8rKBtY+rNJ8CZFO3Bp/8i
         7bh2khR8f3nD/4a3Gg5nAWSRSy7m+WZOCFhytT3V1e81BlWRSYdxQV9rLuoxDopR0nm/
         hLTQ==
X-Gm-Message-State: ANhLgQ1uuSEmEziVyI5LO28SFrXJi0XDt56DlOtyamf1qvU0/zPP5ZD2
        tRP9yzJumdAibuAHWZgueLyoBkw1/7OAaWsECBk=
X-Google-Smtp-Source: ADFU+vsDKGyU8Ri1S/1PRwrA7Itr3+mfAq52rNzAprUWxpeKoYT7suJBC6+bWdYgQhj+l8kE89uLzx1pUhBI4+J56rA=
X-Received: by 2002:a37:6411:: with SMTP id y17mr7918542qkb.437.1585700562534;
 Tue, 31 Mar 2020 17:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com> <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com> <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com> <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
 <869adb74-5192-563d-0e8a-9cb578b2a601@solarflare.com>
In-Reply-To: <869adb74-5192-563d-0e8a-9cb578b2a601@solarflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Mar 2020 17:22:31 -0700
Message-ID: <CAEf4Bza1ueH=SUccfDNScRyURFoQfa1b2z-x1pOfVXuSpGUpmQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Edward Cree <ecree@solarflare.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 2:52 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 31/03/2020 04:54, Andrii Nakryiko wrote:
> > No need to kill random processes, you can kill only those that hold
> > bpf_link FD. You can find them using drgn tool with script like [0].
> For the record, I find the argument "we don't need a query feature,
>  because you can just use a kernel debugger" *utterly* *horrifying*.
> Now, it seems to be moot, because Alexei has given other, better
>  reasons why query doesn't need to land yet; but can we please not
>  ever treat debugging interfaces as a substitute for proper APIs?

Can you please point out where I was objecting to observability API
(which is LINK_QUERY thing we've discussed and I didn't oppose, and
I'm going to add next)?

What I'm doubtful of is this "human override" functionality. I think a
tool that shows who's using (processes and mounted files in BPF FS)
given bpf_link is way more useful, because it allows you to both
"unblock" BPF hook (by killing "bad" processes and removing mounted
bpf_link files) and know which processes (read applications) are
misbehaving.

I'll address drgn vs not concern in reply to David Ahern, who's also
*utterly horrified*, apparently, so I'll try to calm him as well. ;)

>
> </scream>
> -ed
