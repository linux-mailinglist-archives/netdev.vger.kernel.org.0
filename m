Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7648A48F7F9
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 17:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiAOQrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 11:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiAOQrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 11:47:07 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87903C061574;
        Sat, 15 Jan 2022 08:47:06 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id a18so46360564edj.7;
        Sat, 15 Jan 2022 08:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=umg3fmIHEU7ouEUqxByuwXez80RylgBi5NxgeR5uNbQ=;
        b=XtM7/t4yjYeD7SB0BHoS/8zjCi3EyHDHyN8e+nPG3/QFmujQ1mEftGtLVzA59gNri8
         N5EOUb0FZImDOY6t+xgq0FqVwNXEMSuIGL651CgPH7ooF5ASBPja9tL8vOv4LsuCpXC9
         EgTXJLVNtSwXVfPBRMcln6JzB52gwoca0kNu4Y7K6zU5I3Px4vCIY7c0c2AWIEBDAajA
         YiI7OjPLq8qUmyPHDc9t8kBS+RCNmgXkyHxf8Y5PiTHKt7JXIkufiuhCaHc1KTuoWler
         yeh7qkRQuaqLP65bFQrf1xvodxCRXRBFt4SlqstNUwoQ7nX73QeHJevivhiASdeiwZBi
         9E2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=umg3fmIHEU7ouEUqxByuwXez80RylgBi5NxgeR5uNbQ=;
        b=BWeApdd+nIB72WcIRjsObTiIs/JOqW25mhqK+O+2+gVeXHwamRGuau35nZEbHmcqbh
         3HPNtYY19R+ed3fF+GcQ9eCsoIX7N9rGc4y19yi0vnpCahZvoUr/55fFIF8TN9X6/7My
         cd48yUWGA9uWgFULUY4GGXXx9RJcNK4AeNNa2A2JoBWmqK43rtIQLACBj+Q1VhoBiuwR
         vVECPCRMbAcVP2d6rnQdfDXtSnbxT3OpKZJTkzg9IVlad+2JoxZQPRGTCZs/M2NRbtKp
         L3GNiW72sz+vM7MAbu91EBINPilJaEjTEYmmGBPLCe2aVGARGfyBtymdZp2xXZS7HDbN
         msaw==
X-Gm-Message-State: AOAM533C9GfiLjjr8JdWNk+S3CUXqP6lQARe0aYLrWfECFA1PtcPJSgM
        rxaCAFFqB5LA7JykS30DkX8faXoRhKyGSOSJl7g=
X-Google-Smtp-Source: ABdhPJyH0UIPV8JqnNsONGk7+0AcajsTKmtphUYvVBb6LJAlzTTQZj8ELY3WoewqdICJa2EcIezozG5CquyVZSmgNis=
X-Received: by 2002:a05:6402:289a:: with SMTP id eg26mr334586edb.318.1642265225026;
 Sat, 15 Jan 2022 08:47:05 -0800 (PST)
MIME-Version: 1.0
References: <20220111192952.49040-1-ivan@cloudflare.com> <CAA93jw6HKLh857nuh2eX2N=siYz5wwQknMaOtpkqLzpfWTGhuA@mail.gmail.com>
 <CABWYdi0ZHYvzzP9SFOCJhnfyMP12Ot9ALEmXg75oeXBWRAD8KQ@mail.gmail.com>
 <CAA93jw5+LjKLcCaNr5wJGPrXhbjvLhts8hqpKPFx7JeWG4g0AA@mail.gmail.com> <CABWYdi1p=rRQM3oySw2+N+mcrUq3bXA5MXm8cHmC3=qfCU5SDA@mail.gmail.com>
In-Reply-To: <CABWYdi1p=rRQM3oySw2+N+mcrUq3bXA5MXm8cHmC3=qfCU5SDA@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sat, 15 Jan 2022 08:46:52 -0800
Message-ID: <CAA93jw435mThYcBA_7Sf1Z6W_bZrLuK8FLHw8AgAwg0+3y6PBw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tcp: bpf: Add TCP_BPF_RCV_SSTHRESH for bpf_setsockopt
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 2:21 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> On Thu, Jan 13, 2022 at 9:44 PM Dave Taht <dave.taht@gmail.com> wrote:
> > Yes, but with the caveats below. I'm fine with you just saying round tr=
ips,
> > and making this api possible.
> >
> > It would comfort me further if you could provide an actual scenario.
>
> The actual scenario is getting a response as quickly as possible on a
> fresh connection across long distances (200ms+ RTT). If an RPC
> response doesn't fit into the initial 64k of rcv_ssthresh, we end up
> requiring more roundrips to receive the response. Some customers are
> very picky about the latency they measure and cutting the extra
> roundtrips made a very visible difference in the tests.
>
> > See also:
> >
> > https://datatracker.ietf.org/doc/html/rfc6928
> >
> > which predates packet pacing (are you using sch_fq?)
>
> We are using fq and bbr.
>
> > > Congestion window is a learned property, not a static number. You
> > > won't get a large initcwnd towards a poor connection.
> >
> > initcwnd is set globally or on a per route basis.

Like I said, retaining state from an existing connection as to the
window is ok. i think arbitrarily declaring a window like this
for a new connection is not.

> With TCP_BPF_IW the world is your oyster.

The oyster has to co-habit in this ocean with all the other life
there, and I would be comforted if your customer also tracked various
other TCP_INFO statistics, like RTT growth, loss, marks, and
retransmits, and was aware of not just the self harm inflicted but of
collateral damage. In fact I really wish more were instrumenting
everything with that, of late we've seen a lot of need for
TCP_NOTSENT_LOWAT in things like apache traffic server in containers.
A simple one line patch for an widely used app I can't talk about, did
wonders for actual perceived throughput and responsiveness by the end
user. Measuring from the reciever is far, far more important than
measuring from the sender. Collecting long term statistics over many
connections, also, from
the real world. I hope y'all have been instrumenting your work as well
as google has, on these fronts.

I know that I'm getting old and crunchy and scarred by seeing so many
(corporate wifi mostly) networks over the last decade essentially in
congestion collapse!

https://blog.apnic.net/2020/01/22/bufferbloat-may-be-solved-but-its-not-ove=
r-yet/

I'm very happy with how well sch_fq + packet pacing works to mitigate
impuses like this, as well as with so many other things like BBR and
BQL, but pacing out !=3D pacing in,
and despite my fervent wish for more FQ+AQM techniques on more
bottleneck links also, we're not there yet.

I like very much that BPF is allowing rapid innovation, but with great
power comes great responsibility.
--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
