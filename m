Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39592D3B0F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 06:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgLIFvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 00:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgLIFvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 00:51:14 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C129C0613CF;
        Tue,  8 Dec 2020 21:50:34 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id q25so558529oij.10;
        Tue, 08 Dec 2020 21:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ND2tD+7Jx2gQmpOSM894CsoiaxDjDETPdHa/hyM90oc=;
        b=NrK8G6s9BErmDQfLleIY0KXBEcOlkm+fdiECSvO3k8YuABReFpLp1QBBAXfUhs6y1F
         VixCoiS0GRT6I9XOplAWaRNDkWnCHBaXLjewUryw46E2AhG/Xs+8u/z9uL/8nPmaCdoE
         s4z7uffhXCMefnxPKJwG7LTZvdaFMEXSCtE7HqtOYIe5yZXBBQYzB0ZAdlu3/XgJI11b
         0vUvYmu3h65zApqbhUM4DF+JNvKUXVlnb06qeYm8bWfVTromacXm7ZRqp1qRCZ2XJOsV
         s8djvtpgGhW1of1m8FAlcXbtCVZqrZXl15kyMcbCau8qTxjQHQ3dLzf/Il361WV0SYwG
         sVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ND2tD+7Jx2gQmpOSM894CsoiaxDjDETPdHa/hyM90oc=;
        b=eCc/rGVq0DOuiQhrVteCKzgLcGBcfzFqC9WoYXliQH5v9v2WiwSYZTAj5z0FPf/Sju
         ZrApskRUj/qYkrLoTd2IUve7z8uecC79hIaDDqnfQq2srTCGkXoIEXZu3MsB4f1U7NL0
         YA6OzLfrwR0osSHvsgItfHlIffVnC2UwKedL1js0FHabxsTIDPTNZ9aiK/61QSCbrdMx
         Jzo9kObdRTuw72Chjj/u71bhv0RIi0n+4hTi5aO13eQPh6k71rD3LnojnG2ufHUaCX7F
         oE6w98dyLZKSaFwVkxqo3tXMtO2jFWFaPJH/7vFeNLf4CkahntCTUE2xwJPLB6FO3z+i
         mvSQ==
X-Gm-Message-State: AOAM533byit0ntNPjlFpD5h8S3POQOcHp8lxi2UI0JISsULysdfabqpV
        +CmrfKaMlSvEV7yR20Jsmm0=
X-Google-Smtp-Source: ABdhPJz0SNSBWxF84Jfr/FlBBmsQOaECSAgOcZFYAgfaxZFNTFmQHh1bIgPNC3bMonrMF32/bhOV/g==
X-Received: by 2002:aca:cc01:: with SMTP id c1mr714149oig.18.1607493033489;
        Tue, 08 Dec 2020 21:50:33 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id 60sm182040otn.35.2020.12.08.21.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 21:50:32 -0800 (PST)
Date:   Tue, 08 Dec 2020 21:50:25 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        David Ahern <dsahern@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Message-ID: <5fd065a1479c4_50ce208b1@john-XPS-13-9370.notmuch>
In-Reply-To: <87lfe8ik5c.fsf@toke.dk>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <431a53bd-25d7-8535-86e1-aa15bf94e6c3@gmail.com>
 <20201208092803.05b27db3@carbon>
 <87lfe8ik5c.fsf@toke.dk>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
> =

> > On Mon, 7 Dec 2020 18:01:00 -0700
> > David Ahern <dsahern@gmail.com> wrote:
> >
> >> On 12/7/20 1:52 PM, John Fastabend wrote:
> >> >>
> >> >> I think we need to keep XDP_TX action separate, because I think t=
hat
> >> >> there are use-cases where the we want to disable XDP_TX due to en=
d-user
> >> >> policy or hardware limitations.  =

> >> > =

> >> > How about we discover this at load time though. =

> >
> > Nitpick at XDP "attach" time. The general disconnect between BPF and
> > XDP is that BPF can verify at "load" time (as kernel knows what it
> > support) while XDP can have different support/features per driver, an=
d
> > cannot do this until attachment time. (See later issue with tail call=
s).
> > (All other BPF-hooks don't have this issue)
> >
> >> > Meaning if the program
> >> > doesn't use XDP_TX then the hardware can skip resource allocations=
 for
> >> > it. I think we could have verifier or extra pass discover the use =
of
> >> > XDP_TX and then pass a bit down to driver to enable/disable TX cap=
s.
> >> >   =

> >> =

> >> This was discussed in the context of virtio_net some months back - i=
t is
> >> hard to impossible to know a program will not return XDP_TX (e.g., v=
alue
> >> comes from a map).
> >
> > It is hard, and sometimes not possible.  For maps the workaround is
> > that BPF-programmer adds a bound check on values from the map. If not=

> > doing that the verifier have to assume all possible return codes are
> > used by BPF-prog.
> >
> > The real nemesis is program tail calls, that can be added dynamically=

> > after the XDP program is attached.  It is at attachment time that
> > changing the NIC resources is possible.  So, for program tail calls t=
he
> > verifier have to assume all possible return codes are used by BPF-pro=
g.
> =

> We actually had someone working on a scheme for how to express this for=

> programs some months ago, but unfortunately that stalled out (Jesper
> already knows this, but FYI to the rest of you). In any case, I view
> this as a "next step". Just exposing the feature bits to userspace will=

> help users today, and as a side effect, this also makes drivers declare=

> what they support, which we can then incorporate into the core code to,=

> e.g., reject attachment of programs that won't work anyway. But let's
> do this in increments and not make the perfect the enemy of the good
> here.
> =

> > BPF now have function calls and function replace right(?)  How does
> > this affect this detection of possible return codes?
> =

> It does have the same issue as tail calls, in that the return code of
> the function being replaced can obviously change. However, the verifier=

> knows the target of a replace, so it can propagate any constraints put
> upon the caller if we implement it that way.

OK I'm convinced its not possible to tell at attach time if a program
will use XDP_TX or not in general. And in fact for most real programs it
likely will not be knowable. At least most programs I look at these days
use either tail calls or function calls so seems like a dead end.

Also above somewhere it was pointed out that XDP_REDIRECT would want
the queues and it seems even more challenging to sort that out.=
