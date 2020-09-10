Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2F0263AA0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgIJCgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730791AbgIJCfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 22:35:18 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D3C061757;
        Wed,  9 Sep 2020 19:35:18 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a9so2284135pjg.1;
        Wed, 09 Sep 2020 19:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NQAvrxBVvn4Gq/GkT4WehU171lIuWdPk7x5ikVwhHJY=;
        b=tC1NYZVAv9hzmwhyhAf+QxzPEbBWnIR01Z0iJXfCk/sU+2JAl8dknJ5FQeltJaWJgs
         YDB7DUbkFTp0j17LCN27/ZwvZWmlaYfS7R9JRUAE6SmAAWTF3E/0WQjGDU8tIDUIvPp6
         FSMmZjSXX0Zfw1VnVzDwFJTR1+1qzRMHYhVk5hl0ihvijmF1WfbMK/PJ9NZcSbegd66I
         oFj5FxI5NRD5boG4NP4HfcfrfbC6yE/4fY3sFbudNZANzTBiQ1IUcxIoMiNXmXxxB3CO
         BWa12knQQaT2EsTXiGly3dqjaCk+V+WptM7ySwmWgGkFImrx/aPuet+WhhAqUiV7dRy+
         45Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NQAvrxBVvn4Gq/GkT4WehU171lIuWdPk7x5ikVwhHJY=;
        b=MwxI7ZCZ+nh1C9RNWxE0miI+V2PeQ5R0f+4UUrP8YiEtoS12UupCF4h+ewXSgZUUW3
         OLbhl8ClgdB4SvHI6Pat5O1MILkfakOZhOqoAMzJpRXobuuBZrx5ZGNQEgxKlSuC9dcg
         8in+0mKDzGjtIC0eHFzIkASG/t0UuOvjXfcbgSeSfYe87GzKPHDxBaBycZ9GzW69v5qY
         JpbtxQA/vz8uM32BSPKsA5cFRk/WtXweeQJ8PwrbyA8t1CDclMtH7MqQzAPv54Xght++
         ubBp8W6xezoReqCHJ0DLCisTE2CmPDUh2vCDccZpdVC2hqjbGAof1FUr3wRHRf1EABIF
         /xwA==
X-Gm-Message-State: AOAM530D2yL9g4mfJV1C/NXBd6xI83Hw2lbeT793Or/55S+GmCWOU34i
        Qo3ZF+A1wX6UVwM0DM/GiLI=
X-Google-Smtp-Source: ABdhPJzorwk3+Pjv96zYPDmXW6v9gJSTcJoZSoFAv/zYiGz/XhB4Ze+ivdD+elXpBuKPJBIBjD7yCg==
X-Received: by 2002:a17:902:8647:: with SMTP id y7mr3571797plt.155.1599705318020;
        Wed, 09 Sep 2020 19:35:18 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y4sm3887577pfq.215.2020.09.09.19.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 19:35:17 -0700 (PDT)
Date:   Thu, 10 Sep 2020 10:35:06 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200910023506.GT2531@dhcp-12-153.nay.redhat.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20200907082724.1721685-3-liuhangbin@gmail.com>
 <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Wed, Sep 09, 2020 at 02:52:06PM -0700, Alexei Starovoitov wrote:
> On Mon, Sep 07, 2020 at 04:27:21PM +0800, Hangbin Liu wrote:
> > This patch is for xdp multicast support. which has been discussed
> > before[0], The goal is to be able to implement an OVS-like data plane in
> > XDP, i.e., a software switch that can forward XDP frames to multiple ports.
> > 
> > To achieve this, an application needs to specify a group of interfaces
> > to forward a packet to. It is also common to want to exclude one or more
> > physical interfaces from the forwarding operation - e.g., to forward a
> > packet to all interfaces in the multicast group except the interface it
> > arrived on. While this could be done simply by adding more groups, this
> > quickly leads to a combinatorial explosion in the number of groups an
> > application has to maintain.
> > 
> > To avoid the combinatorial explosion, we propose to include the ability
> > to specify an "exclude group" as part of the forwarding operation. This
> > needs to be a group (instead of just a single port index), because a
> > physical interface can be part of a logical grouping, such as a bond
> > device.
> > 
> > Thus, the logical forwarding operation becomes a "set difference"
> > operation, i.e. "forward to all ports in group A that are not also in
> > group B". This series implements such an operation using device maps to
> > represent the groups. This means that the XDP program specifies two
> > device maps, one containing the list of netdevs to redirect to, and the
> > other containing the exclude list.
> 
> "set difference" and BPF_F_EXCLUDE_INGRESS makes sense to me as high level api,
> but I don't see how program or helper is going to modify the packet
> before multicasting it.
> Even to implement a basic switch the program would need to modify destination
> mac addresses before xmiting it on the device.
> In case of XDP_TX the bpf program is doing it manually.
> With this api the program is out of the loop.
> It can prepare a packet for one target netdev, but sending the same
> packet as-is to other netdevs isn't going to to work correctly.

Yes, we can't modify the packets on ingress as there are multi egress ports
and each one may has different requirements. So this helper will only forward
the packets to other group(looks like a multicast group) devices.

I think the packets modification (edit dst mac, add vlan tag, etc) should be
done on egress, which rely on David's XDP egress support.

> Veth-s and tap-s don't care about mac and the stack will silently accept
> packets even with wrong mac.
> The same thing may happen with physical netdevs. The driver won't care
> that dst mac is wrong. It will xmit it out, but the other side of the wire
> will likely drop that packet unless it's promisc.
> Properly implemented bridge shouldn't be doing it, but
> I really don't see how this api can work in practice to implement real bridge.
> What am I missing?

Not sure if I missed something. Does current linux bridge do dst mac
modification? I thought it only forward packets(although it has fdb instead of
flush the packet to all ports)

On patch 4/5 there is an example about forwarding packets. It still need
to get remote's mac address by arp/nd.

Thanks
Hangbin
