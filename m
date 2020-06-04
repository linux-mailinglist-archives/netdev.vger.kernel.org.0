Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22B81EDC18
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 06:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgFDEJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 00:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgFDEJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 00:09:53 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0C8C03E96D;
        Wed,  3 Jun 2020 21:09:52 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id m2so524751pjv.2;
        Wed, 03 Jun 2020 21:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=roJ1VT2hODxNfHsexsDZ51zcsKofe74M10rlpMeT9Wc=;
        b=XWDoQogHkGeuGdTPrzjPIT1b7CxbyvdjksVKpeGdBpghRtL31gXdXdgaelKTw9ulGa
         1ZmOug1r08gVaev3JQqOHb/JrS3NIH7esDE6wj2gUvD7INuaX/qzBaiZPC4WKj5qOOtj
         tQVAlTRfRaF5xg3ejezZPSOOEK1rAsmHrC7epqhZVkhvcmg7pygnRN6s5xoL/WKSoaR/
         AwxwtQADw/QC/8132uqWwcPOw+WMne47thumt2gEHrRHGxU9fpWNgVGUsigLOYszi7pu
         fJPBQg7EOOOQTddCpa+C77UqBZRAG7lYb3X5bqc2d3jTuMPpNFMTQfVD4eFfjfYdSHYS
         3zEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=roJ1VT2hODxNfHsexsDZ51zcsKofe74M10rlpMeT9Wc=;
        b=StVHXURix1+6/PweaXza20qEdYPA+qXC8EgDSUEg27tqUHqmaAjuMa7vbb8Z0KHbd/
         xU5KDbE/aEt7mehXxWcRUhFzuNUU9dUNdvdo2c34573Tw5/51nVxg0aQHwI827r77+fN
         Cxqm32fb2pSwO/mMkc0P+lvZR+uobWxReQasHK+ZJKgHTOr/04r30ds29JzfO04MaoeM
         0a+dVu3Nf9PTXKfQMoVdPT/osTSF+p9GIjPY7FSUIk7fTh24ihJxGkndpMSJQB3sJxT8
         dkL4KbaIRUFAVLI6hnthYEM9Krc8p0z2p0IDULG7hSXbkbyYE0R46P3ygngX/SN1ZJPD
         7wTA==
X-Gm-Message-State: AOAM532+0U3Nv+uIsVdewQEiK5y2vz5FAHlRj9CVxpWEf39kD4ZNyU4h
        cudLEXMq2qUgQN9mdvm7w0o=
X-Google-Smtp-Source: ABdhPJzi0cBJNkHQogPhj59FZr4Q2IMDNuNsqqwTI3HHTH+IOX9u56tK1mkhb1CbYHOUK47YpwoqLw==
X-Received: by 2002:a17:902:7787:: with SMTP id o7mr2882667pll.52.1591243791591;
        Wed, 03 Jun 2020 21:09:51 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x14sm2750878pgj.14.2020.06.03.21.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 21:09:50 -0700 (PDT)
Date:   Thu, 4 Jun 2020 12:09:40 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200604040940.GL102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com>
 <87zh9t1xvh.fsf@toke.dk>
 <20200603024054.GK102436@dhcp-12-153.nay.redhat.com>
 <87img8l893.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87img8l893.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 01:05:28PM +0200, Toke Høiland-Jørgensen wrote:
> > Hi Toke,
> >
> > Here is the result I tested with 2 i40e 10G ports on physical machine.
> > The pktgen pkt_size is 64.
> 
> These numbers seem a bit low (I'm getting ~8.5MPPS on my test machine
> for a simple redirect). Some of that may just be performance of the
> machine, I guess (what are you running this on?), but please check that
> you are not limited by pktgen itself - i.e., that pktgen is generating
> traffic at a higher rate than what XDP is processing.

Here is the test topology, which looks like

 Host A    |     Host B        |        Host C
 eth0      +    eth0 - eth1    +        eth0

I did pktgen sending on Host A, forwarding on Host B.
Host B is a Dell PowerEdge R730 (128G memory, Intel(R) Xeon(R) CPU E5-2690 v3)
eth0, eth1 is an onboard i40e 10G driver

Test 1: add eth0, eth1 to br0 and test bridge forwarding
Test 2: Test xdp_redirect_map(), eth0 is ingress, eth1 is egress
Test 3: Test xdp_redirect_map_multi(), eth0 is ingress, eth1 is egress

> 
> > Bridge forwarding(I use sample/bpf/xdp1 to count the PPS, so there are two modes data):
> > generic mode: 1.32M PPS
> > driver mode: 1.66M PPS
> 
> I'm not sure I understand this - what are you measuring here exactly?

> Finally, since the overhead seems to be quite substantial: A comparison
> with a regular network stack bridge might make sense? After all we also
> want to make sure it's a performance win over that :)

I though you want me also test with bridge forwarding. Am I missing something?

> 
> > xdp_redirect_map:
> > generic mode: 1.88M PPS
> > driver mode: 2.74M PPS
> 
> Please add numbers without your patch applied as well, for comparison.

OK, I will.
> 
> > xdp_redirect_map_multi:
> > generic mode: 1.38M PPS
> > driver mode: 2.73M PPS
> 
> I assume this is with a single interface only, right? Could you please
> add a test with a second interface (so the packet is cloned) as well?
> You can just use a veth as the second target device.

OK, so the topology on Host B should be like

eth0 + eth1 + veth0, eth0 as ingress, eth1 and veth0 as egress, right?

Thanks
Hangbin
