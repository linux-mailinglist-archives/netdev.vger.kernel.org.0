Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25DB393F07
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 10:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhE1I5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 04:57:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235819AbhE1I5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 04:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622192164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ffXFvO9b+fZtZKt7yhkRD4j9J8oPOjrzlIRYwaydf4=;
        b=XsU1YVFeVXBUl34viDfuz4guvKM7NW1I6GiHM8cwl+EQVI3k9j+m7WSwuFEJvItUvBlxel
        ER0cowv0npbt54FkZdxyUZ5Hx4GxG2z/yZxyX9u7LFzWvt6kUQVtccZ+SUZjdnQoueDA67
        KwQiuN6uHUmEA6nNkFQGLaLjmDyckxg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-E_EvGeHwPP653mxwcPIbPg-1; Fri, 28 May 2021 04:56:03 -0400
X-MC-Unique: E_EvGeHwPP653mxwcPIbPg-1
Received: by mail-ej1-f71.google.com with SMTP id r20-20020a170906c294b02903e0626b3387so883667ejz.16
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 01:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/ffXFvO9b+fZtZKt7yhkRD4j9J8oPOjrzlIRYwaydf4=;
        b=t4pfQ0/epyRZJSj1AfeO1Ag2nK4MJql8drdItje2TTNEx7tqXPdgO631PezKRooS0y
         mAPIg3+NM2xxMbP+IQhhvUxc9l+G8lwuz1eE4xoX4Z4WLJnt0XUh0n71gGwCD+7k2TAM
         YOv35YYqr0sweFfRO8fOr1I2gBoy/fJdZsFIibb8GrXpOfiG5xVwM6N44HYc0hQPZyJ9
         PaQwqQLl8N1OxBJDBJui2wOpdZcrlTfA7PDAEwszENR7dVa1eckZaI6hbOizS/Y0iU0J
         rw0clcbQ7hjOS1undjeVC9WXs8noRAIkooxv4ow1NVfvMxzLxSC+b3sEBhJL2sbQs+md
         aiIQ==
X-Gm-Message-State: AOAM532foBneYmOnU+fp5wv/Q/9oXIQxd0AVOZgHyPmcNO9+/wW7XDT/
        N0NUl+TSBMm5yQfhPIs+deI/+d9Ugh3OLez0AUem0iOKdjRkrF/99Sel1XThsGoyuxSj83XvaAy
        CLugeVkou3dszGfgM
X-Received: by 2002:a17:906:c247:: with SMTP id bl7mr8248233ejb.288.1622192161249;
        Fri, 28 May 2021 01:56:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzRDw049Jj/ng8PmLhfCr8SgGWE9xbEuUQ3NadEoSAUi77+9chMO6qiEDt8zju1dsWSAmWCg==
X-Received: by 2002:a17:906:c247:: with SMTP id bl7mr8248210ejb.288.1622192160903;
        Fri, 28 May 2021 01:56:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d17sm2056483ejp.90.2021.05.28.01.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 01:56:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5E08818071B; Fri, 28 May 2021 10:55:58 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH bpf-next] xsk: support AF_PACKET
In-Reply-To: <20210528060813.49003-1-xuanzhuo@linux.alibaba.com>
References: <20210528060813.49003-1-xuanzhuo@linux.alibaba.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 May 2021 10:55:58 +0200
Message-ID: <87im33grtt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:

> In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the current
> rx/tx data packets. This feature is very important in many cases. So
> this patch allows AF_PACKET to obtain xsk packages.

You can use xdpdump to dump the packets from the XDP program before it
gets redirected into the XSK:
https://github.com/xdp-project/xdp-tools/tree/master/xdp-dump

Doens't currently work on egress, but if/when we get a proper TX hook
that should be doable as well.

Wiring up XSK to AF_PACKET sounds a bit nonsensical: XSK is already a
transport to userspace, why would you need a second one?

-Toke

