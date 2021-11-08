Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99564449B72
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhKHSL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:11:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234936AbhKHSL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636394953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cEuhXaEuhD+GKL/lBmFj9KF6WCNj/n+YccNImJPdjg=;
        b=RtDjLOyG+rvejCqdCpqUrTxUmiM+0yQ6Dk3aIr/ytyH3lfKVJemntMIeWjpqeMmZTJs6iR
        Gvqfo2dDOgzvfJCq0VagoMab4VYfHQCBk9SZXM6m4PcY7tM44lkVhYx+lkabhLWVOwpXfe
        37wUPUG9ofma1X5gCwn4olEtKTvLJQY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-uXjV_7kZOduwFELB07_OJg-1; Mon, 08 Nov 2021 13:09:12 -0500
X-MC-Unique: uXjV_7kZOduwFELB07_OJg-1
Received: by mail-ed1-f72.google.com with SMTP id g3-20020a056402424300b003e2981e1edbso15706156edb.3
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 10:09:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1cEuhXaEuhD+GKL/lBmFj9KF6WCNj/n+YccNImJPdjg=;
        b=8K624PVIwQl0WOAK535k4odIe2KXmN9eaulGzOhFlclK1ycGzKIr+M+rLKQ7ycoMGg
         ctWCWj3dsVsgWGkCUXiBA6Bnt92m7fPGbskMkREiwPAWPGMsj9pKPU0q3M4PSr8hcQKk
         o9BIMPCLry5a8WCA27ai1jSmCaPFyYLUlYhRODhVo4kO+E7KF+Thi5XJNGFq+Pmi8NWR
         kZlmjAlX2a2RbL5di096u54uKB/R6+aTD15Hga9mIth50axOzv50p+cOyBi+3BjrZ8Qx
         jImU0qc1BigXstkgamxWvmOVUThJOE6GmrXWtCPnz/7KSnINUvUx0ZW0HNgaPFofWZ/e
         HwoQ==
X-Gm-Message-State: AOAM532epmtofBy1tzNsVVlihALtDXAWv01JiqgfsaFIeADpnyjR7gwf
        99K7umfMAaPsGgdl5EIp3xo4O2dIDEUpCWdxQLGV8M8+jwH2ZUYDUweyVqKJbD/lw7ruHAhj7Kg
        eqws7kATzyEy2wm4z
X-Received: by 2002:a17:907:8692:: with SMTP id qa18mr1467269ejc.7.1636394950738;
        Mon, 08 Nov 2021 10:09:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyClv8tcSrI/UxXplWxRW76JXyVsa3nEi/pu2Ka0nP1mqXKVKeTujb2Aq2XU4+3KU1tY6N6lw==
X-Received: by 2002:a17:907:8692:: with SMTP id qa18mr1467121ejc.7.1636394949701;
        Mon, 08 Nov 2021 10:09:09 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id gn16sm8739933ejc.67.2021.11.08.10.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 10:09:08 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1A5BA18026D; Mon,  8 Nov 2021 19:09:08 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP
 statistics
In-Reply-To: <20211108132113.5152-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
 <20210803163641.3743-4-alexandr.lobakin@intel.com>
 <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
 <20211026092323.165-1-alexandr.lobakin@intel.com>
 <20211105164453.29102-1-alexandr.lobakin@intel.com>
 <87v912ri7h.fsf@toke.dk>
 <20211108132113.5152-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Nov 2021 19:09:08 +0100
Message-ID: <87cznar03f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Date: Mon, 08 Nov 2021 12:37:54 +0100
>
>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
>>=20
>> > From: Alexander Lobakin <alexandr.lobakin@intel.com>
>> > Date: Tue, 26 Oct 2021 11:23:23 +0200
>> >
>> >> From: Saeed Mahameed <saeed@kernel.org>
>> >> Date: Tue, 03 Aug 2021 16:57:22 -0700
>> >>=20
>> >> [ snip ]
>> >>=20
>> >> > XDP is going to always be eBPF based ! why not just report such sta=
ts
>> >> > to a special BPF_MAP ? BPF stack can collect the stats from the dri=
ver
>> >> > and report them to this special MAP upon user request.
>> >>=20
>> >> I really dig this idea now. How do you see it?
>> >> <ifindex:channel:stat_id> as a key and its value as a value or ...?
>> >
>> > Ideas, suggestions, anyone?
>>=20
>> I don't like the idea of putting statistics in a map instead of the
>> regular statistics counters. Sure, for bespoke things people want to put
>> into their XDP programs, use a map, but for regular packet/byte
>> counters, update the regular counters so XDP isn't "invisible".
>
> I wanted to provide an `ip link` command for getting these stats
> from maps and printing them in a usual format as well, but seems
> like that's an unneeded overcomplication of things since using
> maps for "regular"/"generic" XDP stats really has no reason except
> for "XDP means eBPF means maps".

Yeah, don't really see why it would have to: to me, one of the benefits
of XDP is being integrated closely with the kernel so we can have a
"fast path" *without* reinventing everything...

>> As Jesper pointed out, batching the updates so the global counters are
>> only updated once per NAPI cycle is the way to avoid a huge performance
>> overhead of this...
>
> That's how I do things currently, seems to work just fine.

Awesome!

-Toke

