Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA40199E67
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 20:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgCaSwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 14:52:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32996 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgCaSwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 14:52:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id d17so10765414pgo.0;
        Tue, 31 Mar 2020 11:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=AubE5q7cEYcLycAWRUvA7yN1uEq+d0TfbDDMhYhDmYs=;
        b=niuLjdotjKGYp0BShVFhf/lzlcS/wVxkkdeJ8fiYmX4U+qBlJynAEzVCMoOfiphP/c
         U/GxHD9rWknqWiuKSLogWuSgzVBrNiS51Quk5TsPOwp+2sZ/G8qQwNYExB4XNLq+HB1m
         w1rozgsFiS9XRZx3ia8TtdbPiK5AFeVeEjth0xS12atluk5BAVfHsG8geM4WKJyAihZo
         0XtiXuiML1vr9Cy44aQML+bQtwd9y0KdNcox/ggb+6oUxJo0z9hB6Wee1eY7YOuS5KqC
         R0hHatB9RvFNaVJOasdEd2qaFp+8lAHAc1X8wDLOpowdELY0gWKWXKmuMyGvPkr2O6/A
         5vOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AubE5q7cEYcLycAWRUvA7yN1uEq+d0TfbDDMhYhDmYs=;
        b=NcoMC0fHMJM5x/Pfekur02+UvSOncxv9vUa32THHfvZIOC9p+zx6Xq0DkgDshCpBut
         SsptPzSyFPLz4XBQUmTvFDSYr5TU8XoQ3ovLPS6MuUGRwntDOHM0xP8qpBj2QaGhLobv
         unmxpzftXT+g8Sdz1jl6aoeOfXndwwomCr6a7G9da5btyXeHBN+PJ85OAigseLFwQW4q
         CpFBra0W1+m6fbZE7mewWtvNFNVsAJU038NTTb0NSclpkadN2yEasJZKPMdfiUorL+WO
         BR2hGcVTf6k0XBUUL1l/ABWwx6Y0ITCOcUHTvc/yqfiMIJhoMoyasaLXQw5MLOWz5cvp
         Bbtw==
X-Gm-Message-State: ANhLgQ3CGrzcfSrHFXRw/fHttw3aSD66+E4cIpalHG1az1yw6b5kAg6T
        SwLigDvjgNJjGd/iewpr1so=
X-Google-Smtp-Source: ADFU+vtLvHkzaPivAOAOTPbE8CtgUUden4pKxrCEYTVxUGSC3eqfTwIkfhM9nZQPezBdjXf8+tv8tA==
X-Received: by 2002:a65:648e:: with SMTP id e14mr18345018pgv.182.1585680728465;
        Tue, 31 Mar 2020 11:52:08 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:8a85])
        by smtp.gmail.com with ESMTPSA id d26sm12936292pfo.37.2020.03.31.11.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 11:52:07 -0700 (PDT)
Date:   Tue, 31 Mar 2020 11:52:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200331185204.t5nclcyinebypbot@ast-mbp>
References: <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk>
 <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk>
 <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk>
 <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
 <53515939-00bb-174c-bc55-f90eaceac2a3@solarflare.com>
 <20200331040112.5tvvubsf6ij4eupb@ast-mbp>
 <87k130iwrb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k130iwrb.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 01:34:00PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Mon, Mar 30, 2020 at 04:41:46PM +0100, Edward Cree wrote:
> >> On 29/03/2020 21:23, Andrii Nakryiko wrote:
> >> > But you can't say the same about other XDP applications that do not
> >> > use libxdp. So will your library come with a huge warning
> >> What about a system-wide policy switch to decide whether replacing/
> >>  removing an XDP program without EXPECTED_FD is allowed?  That way
> >>  the sysadmin gets to choose whether it's the firewall or the packet
> >>  analyser that breaks, rather than baking a policy into the design.
> >> Then libxdp just needs to say in the README "you might want to turn
> >>  on this switch".  Or maybe it defaults to on, and the other program
> >>  has to talk you into turning it off if it wants to be 'ill-behaved'.
> >
> > yeah. something like this can work for xdp only, but
> > it won't work for tc, since ownership is missing.
> > It looks like such policy knob will bere-inventing bpf_link for
> > one specific xdp case only because xdp has one program per attachment.
> 
> You keep talking about this as though bpf_link was the existing API and
> we're discussing adding another, when in reality it's the other way
> around.

We explained it several times already that it is an existing API.
The _name_ bpf_link was formed only recently, but the concept
existed for very long time.
The raw_tp attach is nothing but bpf_link. It's FD based and it
preserves ownership (program execution guarantee).
Nothing can nuke it from under the process.
This was an api from the day one. See
commit c4f6699dfcb8 ("bpf: introduce BPF_RAW_TRACEPOINT")
from March 2018.
Then FD based [ku]probe and tracepoints were added
with the same two properties of bpf_link concept.
Then fentry/fexit attachment. Also FD based and execution guarantee.
And finally freplace. which is exact equivalent of bpf_link for xdp.
Since freplace can only be one, attaching freplace prog to another
program locks out any other process from attaching a different freplace
prog in the same spot (the same hook/function in the target prog).
To me that behavior looks like 100% equivalency to bpf_link for xdp.
While raw_tp/kprobe/tp/fentry/fexit/bpf_lsm are 100% equivalent to
what we want to do with bpf_link for TC (FD based multi prog with
all progs running and execution guarantee).
