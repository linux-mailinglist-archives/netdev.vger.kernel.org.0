Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0467177BD1
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgCCQYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:24:23 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34052 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729508AbgCCQYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:24:23 -0500
Received: by mail-lf1-f68.google.com with SMTP id w27so3312002lfc.1;
        Tue, 03 Mar 2020 08:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WiTToYDThx/+Ltsox5w4BtYSXdBzfbKsRlVlYc+/m7M=;
        b=bIj/eDxD/rTmD1XBZZOPYPECcbHdQCYXd1olkRr3dMjsPJoJnPci5s6RgM+Zili+Uv
         YIuMf3lSYIsnWiYc5+9PbEKBWHZ8k7aOFPxHgUN6PzJqv91yuRXYQvD9pMMmfBioWlKI
         FIiI19hiZzgb/6v5flTePuSTk3q64x4G6krNkyGFJ101tt85GJD+QpRh0xdQL/RVvQTd
         UWcsmH8RXljD+hr5T63uFMEYHDCys9/4TGVRE3o+RkuPBR5xZU+jDjVajbe/CpmChT5a
         gp4Q80kmEDSx0P7FzfuuFnAAIRDv5HP9FexqzIf7ZIlqY8U76nB89LKvNKqpTgf1s15U
         t4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WiTToYDThx/+Ltsox5w4BtYSXdBzfbKsRlVlYc+/m7M=;
        b=GsgQpnxmZ/vT7Bw72zGsTJ3h6yXtY6tw06Viha7sPmo8Fu/tjWY9xdJCBFpKmxbM3D
         hbeHPjkngTqJys2qEAftEiKkM39Q2JNPIzG/qHU9YLzSNfl+Yi1qORuhYx6bKXJOBwp2
         YEFfKGqnfOMskY50AW3328hM6M/cf2MQ08oxdU2PXqq6w4AkfQKn22sbiDVJ1CIyOqKh
         Gl+whV0E2SS6mkMs2byz1GTRDE7DWp4NwTU4mBa+A1IKclbOqKrzxz5ZPGOS89wl+pv9
         LN0HcBKlTgKyKMGS4wc5njuQ4QCgPsc3DnoNVWg7FmA0gMQuFB1qJpkSCszgQ/GREvBj
         FX2w==
X-Gm-Message-State: ANhLgQ1QXWC3NhguYG45Goqn5kIRsEvRoPrlytODPPOFWsGRb8hCymjr
        m0EbxiOmyTmCv7Dwm24JIlWclxpAdYggzvEfZotbjw==
X-Google-Smtp-Source: ADFU+vsjEx587DMAprO7GRfLelYVi88KXOngFfaf6H6l7+h9pBZ2hPeTffBVAIFTTjVswMUtPMJk35v016rDl6b/C3w=
X-Received: by 2002:a05:6512:304c:: with SMTP id b12mr2230358lfb.196.1583252659344;
 Tue, 03 Mar 2020 08:24:19 -0800 (PST)
MIME-Version: 1.0
References: <158289973977.337029.3637846294079508848.stgit@toke.dk>
 <20200228221519.GE51456@rdna-mbp> <87v9npu1cg.fsf@toke.dk>
 <20200303010318.GB84713@rdna-mbp> <877e01sr6m.fsf@toke.dk>
In-Reply-To: <877e01sr6m.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 Mar 2020 08:24:07 -0800
Message-ID: <CAADnVQJM4M38hNRX16sFGMboXT8AwUpuSUrvH_B9bSiGEr8HzQ@mail.gmail.com>
Subject: Re: [PATCH RFC] Userspace library for handling multiple XDP programs
 on an interface
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrey Ignatov <rdna@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Takshak Chahande <ctakshak@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 1:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> This is the reason why I think the 'link' between the main program and
> the replacement program is in the "wrong direction". Instead I want to
> introduce a new attachment API that can be used instead of
> bpf_raw_tracepoint_open() - something like:
>
> prog_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // dispatcher
> func_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // replacement func
> err =3D sys_bpf(BPF_PROG_REPLACE_FUNC, prog_fd, btf_id, func_fd); // does=
 *not* return an fd
>
> When using this, the kernel will flip the direction of the reference
> between BPF programs, so it goes main_prog -> replacement_prog. And
> instead of getting an fd back, this will make the replacement prog share
> its lifecycle with the main program, so that when the main program is
> released, so is the replacement (absent other references, of course).
> There could be an explicit 'release' command as well, of course, and a
> way to list all replacements on a program.

Nack to such api.
We hit this opposite direction issue with xdp and tc in the past.
Not going to repeat the same mistake again.
