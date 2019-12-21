Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4911285DA
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 01:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfLUADv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 19:03:51 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36507 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfLUADv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 19:03:51 -0500
Received: by mail-pg1-f196.google.com with SMTP id k3so5735483pgc.3;
        Fri, 20 Dec 2019 16:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=xvBECmfdpN4YfzQUHbZFRP8V8JehEc4MHBMzEnJT7+U=;
        b=FcNAvG8VQMyO2J7xmXHpjy0wc1At/w+SJLqnyoGC10WAzMZYgEHcbfXGw1u4/WdnjL
         9rJ6Kzn1sjPikCxiFXBPgU/deUa8UE0KAcjEq9ALrqgerqd0/LtF03k5EbUx6UCIjfil
         xSIor3QlQVV4Tpjg91lf2SRIDCToYJrOgx7cl7iybpB3avKFj6K/IFunNr7l8nwNiV8i
         ddnD2GI3++1gv02v5Pa5waGosdsJCXVuvAJvk3kDrAXzdRhQ1AEM2weWToIS6iR7R1qw
         fawAgoybKVCR6NlnY2s2bUrupdcsu1J2X2LVB2MMEGRmYKUR77nYb4z3O3MncZNwax7w
         veHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=xvBECmfdpN4YfzQUHbZFRP8V8JehEc4MHBMzEnJT7+U=;
        b=kK9egWnOeEQ3gcKlSHFx7CXNL9ic0YZZWsiFDrHA3Ds7332WN4LijdGHSr9mP21Z5t
         c0cjgvLtoeU2KCArjFKpQu3zT1t/rjqtPITB592XtQNytnyiYq2NLWNXoaxkwPkMROub
         RaGny7SSkmfI20165aDgY9Ulk+3L42fQqX8+Czn93sPNhgxgRYK7kVrQwuWnk/KDlI6P
         duuAQJtuhjS4XPpwDyWjDxCxTnAz/JF4Tnznb7Elji1r4tMRQDrWevcrU3reQRZAZCDH
         pej3dCuCHkyNFpUyrw8XR/Z6A835FdA2i8sxCzF1eqi8VxBeTKN7vroD0X3QotPf6+8X
         ktmA==
X-Gm-Message-State: APjAAAU6TJ6xuoISRMzgiALiHJD9RHTGo1y5VEKN4fRNYwmX8Ksxq717
        Bvwj6PhoYjASW5DOPWgOqbE=
X-Google-Smtp-Source: APXvYqx1mZiQB4s1v2QNus1y4w7JFrbh0dFD7XIOBq/0Lx2UVLq/4EFtXIrcgXTGOAxaP7kivf4ltg==
X-Received: by 2002:a65:5ccc:: with SMTP id b12mr17561757pgt.124.1576886630196;
        Fri, 20 Dec 2019 16:03:50 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:827d])
        by smtp.gmail.com with ESMTPSA id a17sm11544869pjv.6.2019.12.20.16.03.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Dec 2019 16:03:49 -0800 (PST)
Date:   Fri, 20 Dec 2019 16:03:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v2 00/12] xsk: clean up ring access functions
Message-ID: <20191221000346.zyeguiinob6olwec@ast-mbp.dhcp.thefacebook.com>
References: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
 <CAJ+HfNh0mGnDnQD0FZqza0oEDZpj+nh_DS=JvWvJMATwsOMJEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNh0mGnDnQD0FZqza0oEDZpj+nh_DS=JvWvJMATwsOMJEA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 11:09:57AM +0100, Björn Töpel wrote:
> On Thu, 19 Dec 2019 at 13:40, Magnus Karlsson <magnus.karlsson@intel.com> wrote:
> >
> > This patch set cleans up the ring access functions of AF_XDP in hope
> > that it will now be easier to understand and maintain. I used to get a
> > headache every time I looked at this code in order to really understand it,
> > but now I do think it is a lot less painful.
> >
> > The code has been simplified a lot and as a bonus we get better
> > performance in nearly all cases. On my new 2.1 GHz Cascade Lake
> > machine with a standard default config plus AF_XDP support and
> > CONFIG_PREEMPT on I get the following results in percent performance
> > increases with this patch set compared to without it:
> >
> > Zero-copy (-N):
> >           rxdrop        txpush        l2fwd
> > 1 core:    -2%            0%            3%
> > 2 cores:    4%            0%            3%
> >
> > Zero-copy with poll() (-N -p):
> >           rxdrop        txpush        l2fwd
> > 1 core:     3%            0%            1%
> > 2 cores:   21%            0%            9%
> >
> > Skb mode (-S):
> > Shows a 0% to 5% performance improvement over the same benchmarks as
> > above.
> >
> > Here 1 core means that we are running the driver processing and the
> > application on the same core, while 2 cores means that they execute on
> > separate cores. The applications are from the xdpsock sample app.
> >
> > On my older 2.0 Ghz Broadwell machine that I used for the v1, I get
> > the following results:
> >
> > Zero-copy (-N):
> >           rxdrop        txpush        l2fwd
> > 1 core:     4%            5%            4%
> > 2 cores:    1%            0%            2%
> >
> > Zero-copy with poll() (-N -p):
> >           rxdrop        txpush        l2fwd
> > 1 core:     1%            3%            3%
> > 2 cores:   22%            0%            5%
> >
> > Skb mode (-S):
> > Shows a 0% to 1% performance improvement over the same benchmarks as
> > above.
> >
> > When a results says 21 or 22% better, as in the case of poll mode with
> > 2 cores and rxdrop, my first reaction is that it must be a
> > bug. Everything else shows between 0% and 5% performance
> > improvement. What is giving rise to 22%? A quick bisect indicates that
> > it is patches 2, 3, 4, 5, and 6 that are giving rise to most of this
> > improvement. So not one patch in particular, but something around 4%
> > improvement from each one of them. Note that exactly this benchmark
> > has previously had an extraordinary slow down compared to when running
> > without poll syscalls. For all the other poll tests above, the
> > slowdown has always been around 4% for using poll syscalls. But with
> > the bad performing test in question, it was above 25%. Interestingly,
> > after this clean up, the slow down is 4%, just like all the other poll
> > tests. Please take an extra peek at this so I have not messed up
> > something.
> >
> > The 0% for several txpush results are due to the test bottlenecking on
> > a non-CPU HW resource. If I eliminated that bottleneck on my system, I
> > would expect to see an increase there too.
> >
> > Changes v1 -> v2:
> > * Corrected textual errors in the commit logs (Sergei and Martin)
> > * Fixed the functions that detect empty and full rings so that they
> >   now operate on the global ring state (Maxim)
> >
> > This patch has been applied against commit a352a82496d1 ("Merge branch 'libbpf-extern-followups'")
> >
> > Structure of the patch set:
> >
> > Patch 1: Eliminate the lazy update threshold used when preallocating
> >          entries in the completion ring
> > Patch 2: Simplify the detection of empty and full rings
> > Patch 3: Consolidate the two local producer pointers into one
> > Patch 4: Standardize the naming of the producer ring access functions
> > Patch 5: Eliminate the Rx batch size used for the fill ring
> > Patch 6: Simplify the functions xskq_nb_avail and xskq_nb_free
> > Patch 7: Simplify and standardize the naming of the consumer ring
> >          access functions
> > Patch 8: Change the names of the validation functions to improve
> >          readability and also the return value of these functions
> > Patch 9: Change the name of xsk_umem_discard_addr() to
> >          xsk_umem_release_addr() to better reflect the new
> >          names. Requires a name change in the drivers that support AF_XDP
> >          zero-copy.
> > Patch 10: Remove unnecessary READ_ONCE of data in the ring
> > Patch 11: Add overall function naming comment and reorder the functions
> >           for easier reference
> > Patch 12: Use the struct_size helper function when allocating rings
> >
> > Thanks: Magnus
> >
> 
> Very nice cleanup (and performance boost)!
> 
> For the series:
> Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
> Tested-by: Björn Töpel <bjorn.topel@intel.com>
> Acked-by: Björn Töpel <bjorn.topel@intel.com>

Applied, Thanks
