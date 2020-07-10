Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C2521B04A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 09:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgGJHhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 03:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgGJHhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 03:37:04 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEDCC08C5CE;
        Fri, 10 Jul 2020 00:37:04 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 1so2164946pfn.9;
        Fri, 10 Jul 2020 00:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1rbQxhJD3OcVtjYVeMjpacjvkEB8PUL2KZQOSYDbhD4=;
        b=EtSKDgvKc8+nvApGzNpeST1dvAt0kRH6GOt/jG/GjUFQOgsDr+YNNK2gMQth4IXjuM
         HkPw5X03KVNeTakvh28uo6dZtdTN7tBnAepM90m7bNGD01PEWXnjhWYtuItH6IR4u6HM
         s9OAjmJQuvTUEOLshf8jqKk5zkDlWo3P0OUAC1d+G/eYGmXtkwCYyfuu/nx5G2yuECQl
         niDKY4UfDhUdUqgS+w5Q3fWdR7lmaCyfASCXztxJxCnb0e57wLElTG6VL+CXiD1w3CSB
         OtUvtxb343UMrl5BWyDN8CBqXxbBX5dSTR1CY+ztMWalGZ1lXkmFQ2Q6eLLV6g5xTGCw
         Uapw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1rbQxhJD3OcVtjYVeMjpacjvkEB8PUL2KZQOSYDbhD4=;
        b=N6Dl73JQQbEP548MnA6092k0DSNpSnJ385tNOP14fY59L/GkwRpI3FzOQdRW5PZFb4
         ppp8Qhs5Bvctk5HPws8GIpgNU9ajYieY03oBDBrIKT9shJiOlvQg4pgzyas+hoE5hpw6
         YSYoEQQwafJrYedTqetN/SeOeQWofLS5hFsyOh4NGzbJftng+OV27rLrwRF6GP1UcDNC
         r2fdMXl8We8II4JS7235XGjpCxMrCfgMTZtYSO4xYTLkt6X46uhpgTKzNZQ/vHHrl52q
         0NKnBWCIXyvukEWfpU0zZ434sjt3DFolWGt/0uVKl3ZCfmsl59Q0oPkO7BCBDKn5hZzy
         QrHQ==
X-Gm-Message-State: AOAM533yIf/Rjpur/z5982Wun+Adei8BafElmkVU4hK9WqK2+TQlAzQs
        2YR2oMR2LrVPhJ5WSt00LKzdiJXlXLTwzQ==
X-Google-Smtp-Source: ABdhPJyOpenU7ptfGvV3stvQoHFnUnpdgOVn6xBWt/KDE4Pm0dtZYhntD3mrkWe1cFRGSskI061Log==
X-Received: by 2002:a62:7991:: with SMTP id u139mr2039555pfc.87.1594366623903;
        Fri, 10 Jul 2020 00:37:03 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 22sm5014919pfx.94.2020.07.10.00.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 00:37:03 -0700 (PDT)
Date:   Fri, 10 Jul 2020 15:36:52 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv6 bpf-next 0/3] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200710073652.GC2531@dhcp-12-153.nay.redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <7c80ca4b-4c7d-0322-9483-f6f0465d6370@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c80ca4b-4c7d-0322-9483-f6f0465d6370@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 12:37:59AM +0200, Daniel Borkmann wrote:
> On 7/9/20 3:30 AM, Hangbin Liu wrote:
> > This patch is for xdp multicast support. which has been discussed before[0],
> > The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
> > a software switch that can forward XDP frames to multiple ports.
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
> Could you move this description as part of patch 1/3 instead of cover
> letter? Mostly given this helps understanding the rationale wrt exclusion
> map which is otherwise lacking from just looking at the patch itself.

OK, I will

> 
> Assuming you have a bond, how does this look in practice for your mentioned
> ovs-like data plane in XDP? The map for 'group A' is shared among all XDP
> progs and the map for 'group B' is managed per prog? The BPF_F_EXCLUDE_INGRESS

Yes, kind of. Since we have two maps as parameter. The 'group A map'(include map)
will be shared between the interfaces in same group/vlan. The 'group B map'
(exclude map) is interface specific. Each interface will hold it's own exclude map.

As most time each interface only exclude itself, a null map + BPF_F_EXCLUDE_INGRESS
should be enough.

For bond situation. e.g. A active-backup bond0 with eth1 + eth2 as slaves.
If eth1 is active interface, we can add eth2 to the exclude map.

> is clear, but how would this look wrt forwarding from a phys dev /to/ the
> bond iface w/ XDP?

As bond interface doesn't support native XDP, This forwarding only works for
physical slave interfaces.

For generic xdp, maybe we can forward to bond interface directly, but I
haven't tried.

> 
> Also, what about tc BPF helper support for the case where not every device
> might have native XDP (but they could still share the maps)?

I haven't tried tc BPF. This helper works for both generic and native xdp
forwarding. I think it should also works if we load the prog with native
xdp mode in one interface and generic xdp mode in another interface, couldn't
we?

Thanks
Hangbin
