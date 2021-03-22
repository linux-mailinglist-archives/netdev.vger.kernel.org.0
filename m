Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D492A3451FD
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCVVrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:47:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230095AbhCVVrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 17:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616449634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BYH+ALHHuUp2nY1Tf4LO1X9cBqJmh5q5ergCiNTIsFA=;
        b=fMzNZrnqkbupAYDCyPlkZVA4H1sqdid/N23+e4Dp6swIA5JpMJqL9b2ZOHp/bQIoSqoeS5
        nXn3Kn4goz2p6lvcX1ixn96M/O1xkaFRG3pfXXNUdH0RSfqaxU9LAClhnaU4/7jqj1LM+G
        JmwQviKfApLVfG3pAhBT5lpzIAoJjVI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-H3ScGiJnOMCtZJL9T32K4Q-1; Mon, 22 Mar 2021 17:47:12 -0400
X-MC-Unique: H3ScGiJnOMCtZJL9T32K4Q-1
Received: by mail-ed1-f72.google.com with SMTP id a2so157288edx.0
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 14:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BYH+ALHHuUp2nY1Tf4LO1X9cBqJmh5q5ergCiNTIsFA=;
        b=ODo5uLz4UH+T3kJoWtmjSbNqJarshag80/yUQDIqoCphC3ZQvyBOvHjDNTYP62NjGL
         BEJuIDqf3Uotu+15BzQcuEpz3LXgYeAh8hgB4L0JtQH0PWV/UMXB+HoqG1oLoWu4JYvF
         gjvDtaXKAAqy1N60L6A7i/Wt/GElAvlyFEEGaXqYMMeIOX5+PPZh6wghMFXX2qyXStSX
         kaakiU3vXGuDASHzpPcOzpFcpRaL8nz250w3NBv18y+oFTlgw547VyElpukCSc1fEuKU
         kZE8CuZxmRQiaLNRT3fA+sCDN6k3HXczUSpHNev6Q1Dh+6YvSXQsPOtMY0XVRHWbSi8h
         N5gw==
X-Gm-Message-State: AOAM532v20Rsujd7cfcFAjNXE08DvFwRtYVNjm39wqCraMZg4+0eNYqD
        UxxyChPYt1clrZKhbDctFexHW1L/aWkraT7apK7Az3V0SarLBJhtq7IEeHUhY4dj9bQCTqtqZZR
        uJxaGTuj2j9RtocA4
X-Received: by 2002:aa7:cf95:: with SMTP id z21mr1668645edx.76.1616449631760;
        Mon, 22 Mar 2021 14:47:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGx0BGOGgfTXiKJV8s2OrCDJkou1EZOucbXM2fC8InHZfQ99sRZLaQtAxxQHygPvmUBl4/1g==
X-Received: by 2002:aa7:cf95:: with SMTP id z21mr1668630edx.76.1616449631619;
        Mon, 22 Mar 2021 14:47:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f19sm12129383edu.12.2021.03.22.14.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 14:47:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8FA5C180281; Mon, 22 Mar 2021 22:47:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH v3 bpf-next 06/17] libbpf: xsk: use bpf_link
In-Reply-To: <20210322205816.65159-7-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
 <20210322205816.65159-7-maciej.fijalkowski@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 22 Mar 2021 22:47:09 +0100
Message-ID: <87wnty7teq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> Currently, if there are multiple xdpsock instances running on a single
> interface and in case one of the instances is terminated, the rest of
> them are left in an inoperable state due to the fact of unloaded XDP
> prog from interface.
>
> Consider the scenario below:
>
> // load xdp prog and xskmap and add entry to xskmap at idx 10
> $ sudo ./xdpsock -i ens801f0 -t -q 10
>
> // add entry to xskmap at idx 11
> $ sudo ./xdpsock -i ens801f0 -t -q 11
>
> terminate one of the processes and another one is unable to work due to
> the fact that the XDP prog was unloaded from interface.
>
> To address that, step away from setting bpf prog in favour of bpf_link.
> This means that refcounting of BPF resources will be done automatically
> by bpf_link itself.
>
> Provide backward compatibility by checking if underlying system is
> bpf_link capable. Do this by looking up/creating bpf_link on loopback
> device. If it failed in any way, stick with netlink-based XDP prog.
> Otherwise, use bpf_link-based logic.

So how is the caller supposed to know which of the cases happened?
Presumably they need to do their own cleanup in that case? AFAICT you're
changing the code to always clobber the existing XDP program on detach
in the fallback case, which seems like a bit of an aggressive change? :)

-Toke

