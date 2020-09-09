Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033EC2638B0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIIVwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgIIVwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:52:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A59C061756;
        Wed,  9 Sep 2020 14:52:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id l191so3049278pgd.5;
        Wed, 09 Sep 2020 14:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZhowZWGtDmhls7G45pPDIJmqABEidVRkH3gLzPOI/UY=;
        b=WK56sLlOjm+fXoA5s3BiLTqFP68YyTSPoZ21+4LS1pdTHXdSVgjG36wEi6fKBGYA+/
         mOkL47NBgQgoA8skxV4VCFp1Av8M/EyruHej18r0Me5lXTVK669/p0BBLDgnFwedflCQ
         VAyuGy+rulqYbHLISGHMFJ6SbDqzBafW59ZugtBAhWPDbTsZSxTKdnIqFjo0gycyDHj4
         8fKJ2E101GbtLV4i+FmDg4C70Hrfv8b3Y9yISJm4HYelZ8UD1kK1PJUux37j5mR9b1ZE
         vRvQx9Ndnr4Z37hrvPMByyg7IxznI6aSInNzrlqTdgD2mJmA7ubxAi1fT0X+eFaQTwA8
         uqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZhowZWGtDmhls7G45pPDIJmqABEidVRkH3gLzPOI/UY=;
        b=IkXWUuMXuCT+Rft+jw7u6Z3ziF9aEG4ZPXpMC8qtCi+fn4Jj6UcRb9hgnOFUDpWoNw
         rBeobtumjeAJygoXlOwT53BIZMMVsOt8Ue2z+hb/dSrnzKcB0Xd4h/iVnzOuJVWVpSZa
         PxoVJyfaOMfFMdkvyxi+DQhvh5ReXdRCviUvTP0VU3MPfqL9ALCEbOcOhShzNHTksswu
         0CXTt7wLvJcsfoetvFCNJcHTOs7T2+TLy38kGZlhqh7lzTj+v93EpUx+OH+L0u46olrx
         paKiqKZgeLHvwR6eBRgcDst7QsuKanZrjToRjxp+ZO/sV/YyBk3VGFpaT8VgiaocKzAw
         AUnQ==
X-Gm-Message-State: AOAM532HrjBcPABwh/NU+p2+Jo3O7eo56cxHKA8Yix1KKOl0KETIZaqV
        UfmiWOb+rVpC6abeGCAnF+s=
X-Google-Smtp-Source: ABdhPJyKD9RUZfg0Dc6rZnJSOyrcqOlYqzxQeeM7v+pWuoJUPRE9BY6KeDjVlwV9+w0TglR9jY6kyw==
X-Received: by 2002:a63:8343:: with SMTP id h64mr2004022pge.445.1599688331661;
        Wed, 09 Sep 2020 14:52:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8178])
        by smtp.gmail.com with ESMTPSA id gb19sm157484pjb.38.2020.09.09.14.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 14:52:10 -0700 (PDT)
Date:   Wed, 9 Sep 2020 14:52:06 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20200907082724.1721685-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907082724.1721685-3-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 04:27:21PM +0800, Hangbin Liu wrote:
> This patch is for xdp multicast support. which has been discussed
> before[0], The goal is to be able to implement an OVS-like data plane in
> XDP, i.e., a software switch that can forward XDP frames to multiple ports.
> 
> To achieve this, an application needs to specify a group of interfaces
> to forward a packet to. It is also common to want to exclude one or more
> physical interfaces from the forwarding operation - e.g., to forward a
> packet to all interfaces in the multicast group except the interface it
> arrived on. While this could be done simply by adding more groups, this
> quickly leads to a combinatorial explosion in the number of groups an
> application has to maintain.
> 
> To avoid the combinatorial explosion, we propose to include the ability
> to specify an "exclude group" as part of the forwarding operation. This
> needs to be a group (instead of just a single port index), because a
> physical interface can be part of a logical grouping, such as a bond
> device.
> 
> Thus, the logical forwarding operation becomes a "set difference"
> operation, i.e. "forward to all ports in group A that are not also in
> group B". This series implements such an operation using device maps to
> represent the groups. This means that the XDP program specifies two
> device maps, one containing the list of netdevs to redirect to, and the
> other containing the exclude list.

"set difference" and BPF_F_EXCLUDE_INGRESS makes sense to me as high level api,
but I don't see how program or helper is going to modify the packet
before multicasting it.
Even to implement a basic switch the program would need to modify destination
mac addresses before xmiting it on the device.
In case of XDP_TX the bpf program is doing it manually.
With this api the program is out of the loop.
It can prepare a packet for one target netdev, but sending the same
packet as-is to other netdevs isn't going to to work correctly.
Veth-s and tap-s don't care about mac and the stack will silently accept
packets even with wrong mac.
The same thing may happen with physical netdevs. The driver won't care
that dst mac is wrong. It will xmit it out, but the other side of the wire
will likely drop that packet unless it's promisc.
Properly implemented bridge shouldn't be doing it, but
I really don't see how this api can work in practice to implement real bridge.
What am I missing?
