Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197B6F979A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKLRu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:50:57 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45311 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLRu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 12:50:56 -0500
Received: by mail-qk1-f193.google.com with SMTP id q70so15207101qke.12;
        Tue, 12 Nov 2019 09:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ylsEy4MlIJErY/GVeWNeaZDzsBVBxc5FEWIayo4Qyjo=;
        b=L/AvwS0/Y1MZ20SMB3ivYZroc8LBgL6ZFMjiW/GsU0vEGMoroGXsFu71DJSTUaF40F
         HAnASGcyjiPzyMkkcPF4J/awvnGmPMcF1A6nJS2CSSZ8EnfNLouTDmM+DQG3AFkBpfsG
         GEp2Tjl1zaGARAEmcluupriVsrqFTpJo6SG/7Ay1tRpZVaPJ/kKSAYzPhpLUKX9FLUOl
         h/C2M/XMoS6JF3OuJNgktD93BmGjWRPwV0x7jqiAxLj7Qk3l5Db9ssKNEovzM+PyTexR
         0ExP7CZqYj2lj2OATyPVKgR4cbxmkKvCo5sp6MMawFtamaix3UU5nHrlK6Ns6uLcKIeS
         3MnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ylsEy4MlIJErY/GVeWNeaZDzsBVBxc5FEWIayo4Qyjo=;
        b=DCUJQh2a9KWBLewV5qKbzFUaTfm+q08eF/dplIarMHHWwRDiGjmeo6uNirFVDgDcOd
         L3u1MCwXJa7pqmrdVoipeA/D/ykAQxfaRqIrsud4KJNUwNqQCD7q03xWkVllo41ftAvR
         e7gQfk2mfwCShZAl4MwgGTRXJwtpkU6p8MVMRXU1i61rJe7JdTW24nc1YaO7tz4qU7tz
         bqvcBFqriZCcrX4DZ+7sTG74csu08GcMIjH0h3SFK/FmEc2Bl9ruEJhamOkRyu2x6efT
         nrHGD/l6NaO80QPKXQi3F9DO+tiBbLKSRKcBrz8FQl5739RDkxO0NMUJq0RwsmeBG2+o
         S1MA==
X-Gm-Message-State: APjAAAXQH2K1BR1Taw/7Fy78uZL8XsbSC4U4gfzo6bZ06gtx1f/uL2mO
        +eDO6doFPI42NYxYXI/6J1QVqnowHoNFrUN0y+s=
X-Google-Smtp-Source: APXvYqyoB8p+nd3VwU28X4m1ygubakyjyy3i940CLBO0CujySu+a32k1m4E67Wuew0ZPLfOfe2cqiMju5WI84VEKfpU=
X-Received: by 2002:a37:8a01:: with SMTP id m1mr1867882qkd.147.1573581054354;
 Tue, 12 Nov 2019 09:50:54 -0800 (PST)
MIME-Version: 1.0
References: <87h840oese.fsf@toke.dk> <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com>
 <87wocqrz2v.fsf@toke.dk> <20191027.121727.1776345635168200501.davem@davemloft.net>
 <09817958-e331-63e9-efbf-05341623a006@gmail.com>
In-Reply-To: <09817958-e331-63e9-efbf-05341623a006@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 12 Nov 2019 09:50:17 -0800
Message-ID: <CALDO+SaxbNpON+=3zA4r4k6BE7UhbGU1WovW8Owyi8-9J_Wbkw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        pravin shelar <pshelar@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 5:32 PM Toshiaki Makita
<toshiaki.makita1@gmail.com> wrote:
>
> On 2019/10/28 4:17, David Miller wrote:
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Date: Sun, 27 Oct 2019 16:24:24 +0100
> >
> >> The results in the paper also shows somewhat disappointing performance
> >> for the eBPF implementation, but that is not too surprising given that
> >> it's implemented as a TC eBPF hook, not an XDP program. I seem to reca=
ll
> >> that this was also one of the things puzzling to me back when this was
> >> presented...
> >
> > Also, no attempt was made to dyanamically optimize the data structures
> > and code generated in response to features actually used.
> >
> > That's the big error.
> >
> > The full OVS key is huge, OVS is really quite a monster.
> >
> > But people don't use the entire key, nor do they use the totality of
> > the data paths.
> >
> > So just doing a 1-to-1 translation of the OVS datapath into BPF makes
> > absolutely no sense whatsoever and it is guaranteed to have worse
> > performance.

1-to-1 translation has nothing to do with performance.

eBPF/XDP is faster only when you can by-pass/shortcut some code.
If the number of features required are the same, then an eBPF
implementation should be less than or equal to a kernel module's
performance. "less than" because eBPF usually has some limitations
so you have to redesign the data structure.

It's possible that after redesigning your data structure to eBPF,
it becomes faster. But there is no such case in my experience.

Regards,
William
