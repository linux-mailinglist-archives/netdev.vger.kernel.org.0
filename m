Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A75928DD69
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgJNJYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388192AbgJNJU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:20:56 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32606C08EC67
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 16:54:31 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id j13so3090190ilc.4
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 16:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sjm3u8JC4Xlbusb+qeX/5Jk8X4D9CpxdIUDG8wfTrLc=;
        b=h7OqxXGKwj4Mo4JA7yrTBWbdI8dnRHqApiqXyHTpTe991zpKHZkEHCEWyHDvG1qik+
         CxqFaq8V2zp0IIB8Vz1ST135NAoNU5tXd0fqOWAmNisCCPUzBWpFweo0bkm6PY0OfKLl
         9nr5NggqtKFcmLjBEAumVHZ0wFXUnFWNE80roOle4AdU+7WLrd0yYeJwlH1gwjc8HaVR
         4UI6u/hgDaDFrVDnhQnEUAb1LLth6/fHwpenUGo2z+to58CwMJ1kLvCJTwZud0xRXiQi
         +CtWLyhj1h3AOHapWt+ge6Jyt+9mGVuB4vUTqHQ9220EAh94pga7svTjw/F94Z1iMAZ9
         ysZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sjm3u8JC4Xlbusb+qeX/5Jk8X4D9CpxdIUDG8wfTrLc=;
        b=KIsmf9+WOJkd45qgsNMRH4UQci/wPJkfOb6A+lxmjg12VDOYjWW7qUD7dI4gt9ZUpH
         7RksoK4h26AKYI0182Y8Tj0jxBnu7sORgmzHDZvVHMxNrRlFnAMXiu6xvQArt5fjvhQH
         MrZm+1bsIOG90fs5iYi1U14MG7bNve8SV7k7RqAaun+oDJV62C1AU6efsmjfF5RTGGW3
         MygtoIc3J024PKN5y+jvINIVLmb1kB5Zs6a9SYSVn692jTNvChj+3ALeQvoMTI0ONTNa
         d5Kb0ZwyAA+M70cOaGAFz+z04twDllSBy2s4oDuDIsydbvmQgxeEzX1l3wRUNJmuq+us
         BSpg==
X-Gm-Message-State: AOAM533aOnTZ2a3KGvrUf755cDaykYsBbvUj9G2BFKxmXO/8N23YLMhO
        hzdkUVquDpLs5+KG9jTNViiQEORBwSPLtSl8MRqMBg==
X-Google-Smtp-Source: ABdhPJz8qdgbvWOw8zzy1DuQLasgWgEutPD6COUd/uTLi2C5S0MzLmxZtdhCOAHYVnQWeAnrM4Jg1hq+7EDgKgW3Udo=
X-Received: by 2002:a05:6e02:11a8:: with SMTP id 8mr619039ilj.145.1602633270384;
 Tue, 13 Oct 2020 16:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch> <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201010124402.606f2d37@carbon> <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201013224009.77d6f746@carbon> <20201013160726.367e3871@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201013233734.6z3uyrlr43s7etay@ast-mbp>
In-Reply-To: <20201013233734.6z3uyrlr43s7etay@ast-mbp>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 13 Oct 2020 16:54:18 -0700
Message-ID: <CANP3RGdPWxf-TFypoxb0uMtKBy2nVAkzCmbhwjzjKDi8ZguEbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> how about we set __bpf_skb_max_len() to jumbo like 8k and be done with it.

8k is still far too small.  A lot of places do 9K or 16K jumbo frames.
You'd need at least a full 16K for it to be real jumbo compatible.

That said, if we're ever willing to ignore device mtu, then I see no
reason why an 8K or 16K or 32K limit is any better than 64K.
(which is at least max IP packet size compatible [let's ignore ipv6
jumbograms as not realistic])

If something in the firmware/driver fails at 64K it'll probably fail
at 8K as well.
Since the 'bad' hardware is most likely old and only ~1500 (or 1
pagesize) capable anyway...

In practice driver limitations maybe more around the number of pages
or sg sections, then rather on the max packet size anyway...
so failures may depend on individual skb layout...

And as a reminder there are interfaces (like lo) that default to 64K mtu.
(and I have veth setups with 64K mtu as well)

btw. our GCE folks tell us they occasionally see (and now discard)
>mtu packets from Linux VMs (using the virtio-net driver),
we've not had time to debug this (the VMs in question have some pretty
funky routing and for privacy reason I've not been able to get actual
dumps of the problematic frames), but gut feeling is >mtu packets
occasionally leak into the drivers (probably from the tcp stack).

> I guess some badly written driver/fw may still hang with <= 8k skb
> that bpf redirected from one netdev with mtu=jumbo to another
> netdev with mtu=1500, but then it's really a job of the driver/fw
> to deal with it cleanly.
>
> I think checking skb->tx_dev->mtu for every xmited packet is not great.
> For typical load balancer it would be good to have MRU 1500 and MTU 15xx.
> Especially if it's internet facing. Just to drop all known big
> packets in hw via MRU check.
> But the stack doesn't have MRU vs MTU distinction and XDP_TX doesn't
> adhere to MTU. xdp_data_hard_end is the limit.
> So xdp already allows growing the packet beyond MTU.
> I think upgrading artificial limit in __bpf_skb_max_len() to 8k will
> keep it safe enough for all practical cases and will avoid unnecessary
> checks and complexity in xmit path.
