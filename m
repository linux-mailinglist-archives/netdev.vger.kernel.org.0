Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CBF1324FF
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 12:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgAGLfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 06:35:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38743 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727650AbgAGLfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 06:35:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578396912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7QiSRr6DSbeXibbzalEIi2IuNRX1MSEkqaZ1Ery9Ncs=;
        b=Hrovnk6dQCsmdL2kPCbOmAdbUoWa836I65/RN9orFPEJpifhA0XdBSxFvOnbNqMv5W/zHK
        njHRwp0C5P+cYHfpNdiAXcJE6Dt+JK7Ne74WCjYvZd7ja7Fhot2caviOY9VhTdg+KvVktc
        xWIFsL1/9SMs+cdJsM6YZzucse+VhBI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-xszgP11rOeGaKr1_eyJ0Gw-1; Tue, 07 Jan 2020 06:35:11 -0500
X-MC-Unique: xszgP11rOeGaKr1_eyJ0Gw-1
Received: by mail-wr1-f71.google.com with SMTP id b13so10864136wrx.22
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 03:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7QiSRr6DSbeXibbzalEIi2IuNRX1MSEkqaZ1Ery9Ncs=;
        b=lVIZu/BTU3Jakh0ekgLkh5C/zSlQ5FlKrcNhu4eRkrOKGhTLHeHdffgOJdjBzUQLXY
         WKeCEcKzH5qWPQbpeaXO9Q1lv0+jYh6KUvCXgNy7iOyDLbImZ8g1cbkGCnlVU6fpsDtX
         Y5TqWtKmRoTtKL8lOxTMJqUkGp4BS+WIQzuo2f4QumWgIbmZMorwp8xGppBuDfUfDQnp
         Zz6bvMth5UCsrCVec6u4LJWyL2LwR8YyQObgpxlczGzBbfDJWBk1C7dyCqaTiRXAx/ot
         /C+Ln/rbtpmyY9+sLI6c11I73BTgxUpEsjqJ9n7d+J4qOPKh0htyI5h0+8GenveAIWre
         ciqA==
X-Gm-Message-State: APjAAAUIgDA15/UK5kPjKXwSDCuoJRdCzMzRx2nSp4Yz1NkUaUhpYtNG
        OML/r5JHmPabcZiYR4aRpJJ4ybnCGlAGEO9g+x021gGbbY/JdWnISa4Ox2HXk67U7UYgHc3V84b
        x6KWayqfxIWTcfuGO
X-Received: by 2002:adf:f6c1:: with SMTP id y1mr116777016wrp.17.1578396908109;
        Tue, 07 Jan 2020 03:35:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqw157MHGFCUdC58G4DVCKhPzqHp+e6l3TDn+XlTuLkAoveEDIFg9mgMxBclwgL68tu+ZzzXGg==
X-Received: by 2002:adf:f6c1:: with SMTP id y1mr116776996wrp.17.1578396907922;
        Tue, 07 Jan 2020 03:35:07 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p26sm25921873wmc.24.2020.01.07.03.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 03:35:06 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C2484180960; Tue,  7 Jan 2020 12:35:04 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: Re: [RFC v2 net-next 01/12] net: introduce BPF_XDP_EGRESS attach type for XDP
In-Reply-To: <a479866f-c8c8-27a4-ea1b-23132494b0ba@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com> <20191226023200.21389-2-prashantbhole.linux@gmail.com> <20191227152752.6b04c562@carbon> <a479866f-c8c8-27a4-ea1b-23132494b0ba@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 07 Jan 2020 12:35:04 +0100
Message-ID: <87woa3ijo7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prashant Bhole <prashantbhole.linux@gmail.com> writes:

> On 12/27/2019 11:27 PM, Jesper Dangaard Brouer wrote:
>> On Thu, 26 Dec 2019 11:31:49 +0900
>> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>> 
>>> This patch introduces a new bpf attach type BPF_XDP_EGRESS. Programs
>>> having this attach type will be allowed to run in the tx path. It is
>>> because we need to prevent the programs from accessing rxq info when
>>> they are running in tx path. Verifier can reject the programs those
>>> have this attach type and trying to access rxq info.
>>>
>>> Patch also introduces a new netlink attribute IFLA_XDP_TX which can
>>> be used for setting XDP program in tx path and to get information of
>>> such programs.
>>>
>>> Drivers those want to support tx path XDP needs to handle
>>> XDP_SETUP_PROG_TX and XDP_QUERY_PROG_TX cases in their ndo_bpf.
>> 
>> Why do you keep the "TX" names, when you introduce the "EGRESS"
>> attachment type?
>> 
>> Netlink attribute IFLA_XDP_TX is particularly confusing.
>> 
>> I personally like that this is called "*_XDP_EGRESS" to avoid confusing
>> with XDP_TX action.
>
> It's been named like that because it is likely that a new program
> type tx path will be introduced later. It can re-use IFLA_XDP_TX
> XDP_SETUP_PROG_TX, XDP_QUERY_PROG_TX. Do think that it should not
> be shared by two different type of programs?

I agree that the *PROG_TX stuff is confusing.

Why not just keep the same XDP attach command, and just make this a new
attach mode? I.e., today you can do

bpf_set_link_xdp_fd(ifindex, prog_fd, XDP_FLAGS_DRV_MODE);

so for this, just add support for:

bpf_set_link_xdp_fd(ifindex, prog_fd, XDP_FLAGS_EGRESS_MODE);

No need for a new command/netlink attribute. We already support multiple
attach modes (HW+DRV), so this should be a straight-forward extension,
no?

-Toke

