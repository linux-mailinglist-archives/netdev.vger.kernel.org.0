Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160E12D1B55
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgLGUxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgLGUxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 15:53:12 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DC2C0617B0;
        Mon,  7 Dec 2020 12:52:32 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id k9so839662oop.6;
        Mon, 07 Dec 2020 12:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=RklTgRBKQUgWmR6BHgH9xR8XmPcsLhO51o9sqkCp/H4=;
        b=CMcRNXX+Eon1iKbdZt+vmUOYnSJqG+HqwGVdVe+aILQmnQjMalunxEU/NDO8ZA8bhw
         oMkqduYJa5qu+ygOjqnb850ESiQhSKOg6C4GYXIcQmNuJuLuCRb6d+i3roe3HF7ORaDg
         53tVBOxJc0m7rV0+ff54qh3ACAAY8iq4MhZlR9lhiJ0hdIwgmVSSoYwcBTsvCO9EzrhL
         TpzwyMoN7a5OrrWqcmWZ4h2040CcnBtzYJZaXqJi/tJliuy8g3yJgnJFkDeldkvqVuHp
         zkc+TyC9A/c41UPGbHtETHtxN9m7BlbEiuTpmuFHtRu7kPEVj7WDWCIKxP0tZB89UEMm
         WyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=RklTgRBKQUgWmR6BHgH9xR8XmPcsLhO51o9sqkCp/H4=;
        b=p//Ie9XWeOLjgU+QUIsc3C0PYNu6GqvGtxqBFJkZbsLOxDql2tVF3zXS1YPOXUuh6M
         CzYtuzD+eZ5v4/Xr0WLu4AuZkaysJVQg7T09yI/yC/JSWRwgrGBMJ95VXflxZdXpxtmS
         hnWlowyEzRb8L2Ct5HX3ARXXZhqFRlkhqA9s5zInVEK9ANZ6l1BN/3+QT2swaSXLFUx7
         3tZz7VG40DaKllCgjoh4Eqr1BuMEsYEFQaducq3VSJ6xNGBVwrDJpy9SylragcNc8uG3
         5/o7JzXAxNCT+8eCfKH9bs3fog1Q3MR7tv3RsvdUrNUosuoiCf4IpPBYlMudY2XfrCLh
         VlTg==
X-Gm-Message-State: AOAM533BJE1fOdnInG8MnE1VcEUPe3x9bGBGjUXKmzJCvAHwtthys+TU
        E8xk+Uo3+wJLWio+t4i0njY=
X-Google-Smtp-Source: ABdhPJyWjCKxK5nBqzlnyipZHT5KIFh9+CgOw05Al+fMEW8GQsfv/bpaWw+rziV0qJ6fo9SubFtHog==
X-Received: by 2002:a4a:a7c5:: with SMTP id n5mr60131oom.9.1607374351459;
        Mon, 07 Dec 2020 12:52:31 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id i24sm463017oot.42.2020.12.07.12.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 12:52:30 -0800 (PST)
Date:   Mon, 07 Dec 2020 12:52:22 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Message-ID: <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
In-Reply-To: <20201207135433.41172202@carbon>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Fri, 4 Dec 2020 16:21:08 +0100
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> =

> > On 12/4/20 1:46 PM, Maciej Fijalkowski wrote:
> > > On Fri, Dec 04, 2020 at 01:18:31PM +0100, Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:  =

> > >> alardam@gmail.com writes:  =

> > >>> From: Marek Majtyka <marekx.majtyka@intel.com>
> > >>>
> > >>> Implement support for checking what kind of xdp functionality a n=
etdev
> > >>> supports. Previously, there was no way to do this other than to t=
ry
> > >>> to create an AF_XDP socket on the interface or load an XDP progra=
m and see
> > >>> if it worked. This commit changes this by adding a new variable w=
hich
> > >>> describes all xdp supported functions on pretty detailed level:  =

> > >>
> > >> I like the direction this is going! :)
> =

> (Me too, don't get discouraged by our nitpicking, keep working on this!=
 :-))
> =

> > >>  =

> > >>>   - aborted
> > >>>   - drop
> > >>>   - pass
> > >>>   - tx  =

> > =

> > I strongly think we should _not_ merge any native XDP driver patchset=

> > that does not support/implement the above return codes. =

> =

> I agree, with above statement.
> =

> > Could we instead group them together and call this something like
> > XDP_BASE functionality to not give a wrong impression?
> =

> I disagree.  I can accept that XDP_BASE include aborted+drop+pass.
> =

> I think we need to keep XDP_TX action separate, because I think that
> there are use-cases where the we want to disable XDP_TX due to end-user=

> policy or hardware limitations.

How about we discover this at load time though. Meaning if the program
doesn't use XDP_TX then the hardware can skip resource allocations for
it. I think we could have verifier or extra pass discover the use of
XDP_TX and then pass a bit down to driver to enable/disable TX caps.

> =

> Use-case(1): Cloud-provider want to give customers (running VMs) abilit=
y
> to load XDP program for DDoS protection (only), but don't want to allow=

> customer to use XDP_TX (that can implement LB or cheat their VM
> isolation policy).

Not following. What interface do they want to allow loading on? If its
the VM interface then I don't see how it matters. From outside the
VM there should be no way to discover if its done in VM or in tc or
some other stack.

If its doing some onloading/offloading I would assume they need to
ensure the isolation, etc. is still maintained because you can't
let one VMs program work on other VMs packets safely.

So what did I miss, above doesn't make sense to me.

> =

> Use-case(2): Disable XDP_TX on a driver to save hardware TX-queue
> resources, as the use-case is only DDoS.  Today we have this problem
> with the ixgbe hardware, that cannot load XDP programs on systems with
> more than 192 CPUs.

The ixgbe issues is just a bug or missing-feature in my opinion.

I think we just document that XDP_TX consumes resources and if users
care they shouldn't use XD_TX in programs and in that case hardware
should via program discovery not allocate the resource. This seems
cleaner in my opinion then more bits for features.

> =

> =

> > If this is properly documented that these are basic must-have
> > _requirements_, then users and driver developers both know what the
> > expectations are.
> =

> We can still document that XDP_TX is a must-have requirement, when a
> driver implements XDP.

+1

> =

> =

> > >>>   - redirect  =

> > >>
> =

> =

> -- =

> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> =



