Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B7A27090D
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 01:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgIRXG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 19:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIRXG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 19:06:28 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35610C0613CF
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 16:06:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id m17so8834503ioo.1
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 16:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9bNyiqZRy9v9UN6kOHlDSQbOqmNPV8IizTEQRLcyfn0=;
        b=v1cuLNoXQ+GVGb4l56ge0mP3bK/5G8UVWWN4zIDq0tBYHlT3ihH4H2it9xJZCsv/W7
         qM0Lb++ZebLGePVpFv1qTco8d0zGgfWRHEKqFRTe+l24ktHnsWPuqTGo/xN7OKThoUu6
         mFI2nXjrbz0ylzzWeAnSdOhJe5viXOlU/JCGZeVBo44jIzPZJUF3iEmJQrHStMeDazxL
         gtyzGo2U1jQ/1a/f12uPJZdUoHzXRmyFn8kDJ9L8CijRlHGDqEYrD3FmwYSrRyv+BLZj
         8JwMRJVCVH2EXnOxgKTko6UdH3tBW41a7jsqVkGzKq94UR7odmcrw3co9AY4nWpdtamJ
         GB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9bNyiqZRy9v9UN6kOHlDSQbOqmNPV8IizTEQRLcyfn0=;
        b=KCYmfnSugS8UUGK9oN99hs6ZQ2aghUSWDfpElsfhkrpz726Oe0GE5d/SGLg8xWSafh
         Wal3+KhoFkp+SvinsxryZgmu1uWNrvo8XQO/UWEeblLXK62Mpl1NprM0eqUJlHRrJcwm
         YyBqAN0qGyy+Jpr/r+J8ULx8s5gvadb/4A2V1j6xT4uWJMZPk47dpDBBNqtqlE0740ba
         hFDtMD7mYG0QNDhELDZy/Ow1vlw9Ga/e3SuFFXMwHr6E0TvuLMMDoMFHHAHsU2bdHbJo
         RBSIYLPQBxs3vfBI+mOxnF9AFXu3xu2+t6NwvSTr74brwzwqCsewiRlN369LKb2brcYS
         s3lQ==
X-Gm-Message-State: AOAM532or8zt3oji99X6xE6ic5Cuo99VXK8smrGD+5SMJHtIYOUpULi8
        Jc0hlIO6DUiO6mOYubZg8lCYlSEVITcX0gz9dLMx0g==
X-Google-Smtp-Source: ABdhPJwEMLRoquIHfcHeqo6SsUZIdVaVx2GPzrJ7bsG7/HRNsqafMwUOiC7OJ64e00v2okkmvKLar3TyyKgRs3PDpYE=
X-Received: by 2002:a5e:c017:: with SMTP id u23mr28425394iol.139.1600470383614;
 Fri, 18 Sep 2020 16:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200917143846.37ce43a0@carbon> <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
 <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org> <20200918120016.7007f437@carbon>
In-Reply-To: <20200918120016.7007f437@carbon>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 18 Sep 2020 16:06:13 -0700
Message-ID: <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is a good point.  As bpf_skb_adjust_room() can just be run after
> bpf_redirect() call, then a MTU check in bpf_redirect() actually
> doesn't make much sense.  As clever/bad BPF program can then avoid the
> MTU check anyhow.  This basically means that we have to do the MTU
> check (again) on kernel side anyhow to catch such clever/bad BPF
> programs.  (And I don't like wasting cycles on doing the same check two
> times).

If you get rid of the check in bpf_redirect() you might as well get
rid of *all* the checks for excessive mtu in all the helpers that
adjust packet size one way or another way.  They *all* then become
useless overhead.

I don't like that.  There may be something the bpf program could do to
react to the error condition (for example in my case, not modify
things and just let the core stack deal with things - which will
probably just generate packet too big icmp error).

btw. right now our forwarding programs first adjust the packet size
then call bpf_redirect() and almost immediately return what it
returned.

but this could I think easily be changed to reverse the ordering, so
we wouldn't increase packet size before the core stack was informed we
would be forwarding via a different interface.

> If we do the MTU check on the kernel side, then there are no feedback
> to the program, and how are end-users going to debug this?

What about just adding a net_ratelimited printk in the >mtu but too
late to return error case?
This is only useful though if this should never happen unless you do
something 'evil' in your bpf code.
(ie. to be useful this requires all the bpf helpers to have correct
mtu checks in them)

Alternatively a sysctl that would generate icmp error on such a drop?
Or just always do that anyway?

> Hmm, I don't like wasting cycles on doing the same check multiple times.

I'm not sure this is avoidable without making bpf code error prone...

> In bpf_redirect() we store the netdev we want to redirect to, thus, if
> bpf_skb_adjust_room() is run after bpf_redirect(), we could also do a
> MTU check in bpf_skb_adjust_room() based on this netdev. (maybe there
> are still ways for a BPF-prog to cheat the MTU check?).

Sure but, bpf_redirect() can be from large to small mtu device without
packet ever being modified.
bpf_redirect() needs to check mtu in such a case.
bpf code may decide that if can't redirect then it just wants core
stack to do something with it (like frag it).

> > Another solution is to have an exception function defined in the
> > BPF_prog, this function by itself is another program that can be
> > executed to notify the prog about any exception/err that happened
> > after the main BPF_program exited and let the XDP program react by
> > its own logic.
>
> We are talking about TC-BPF programs here, but the concept and
> usability issue with bpf_redirect() is the same for XDP.
>
> If doing the MTU check (and drop) on kernel side, as was thinking about
> adding a simple tracepoint, for end-users to debug this. It would also
> allow for attaching a BPF-prog to the tracepoint to get more direct
> feedback, but it would not allow sending back an ICMP response.
>
> Your approach of calling a 2nd BPF-prog to deal with exceptions, and
> allow it to alter the packet and flow "action" is definitely
> interesting.  What do others think?
>
>
> > example:
> >
> > BPF_prog:
> >     int XDP_main_prog(xdp_buff) {
> >         xdp_adjust_head/tail(xdp_buff);
> >         return xdp_redirect(ifindex, flags);
> >     }
> >
> >     int XDP_exception(xdp_buff, excption_code) {
> >         if (excetption_code =3D=3D XDP_REDIRECRT_MTU_EXCEEDED) {
> >                 ICMP_response(xdp_buff);
> >                 return XDP_TX;
> >         }
> >         return XDP_DROP;
> >     }
> >
> >
> > netdev_driver_xdp_handle():
> >    act =3D bpf_prog_run_xdp(prog, xdp); // Run XDP_main_prog
> >    if (act =3D=3D XDP_REDIRECT)
> >        err =3D xdp_do_redirect(netdev, xdp, prog);
> >        if (err) {
> >           // Run XDP_exception() function in the user prog
> >           // finds the exception handler of active program
> >           act =3D bpf_prog_run_xdp_exciption(prog, xdp, err);
> >           // then handle exception action in the driver
> > (XDP_TX/DROP/FORWARD)..
> >        }
> >
> > of-course a user program will be notified only on the first err ..
> > if it fails on the 2nd time .. just drop..
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
