Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE2447F01
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbhKHLkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:40:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230235AbhKHLko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 06:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636371479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zlpIDeohuxGJKr6/NQGxf0qdewWP/HeI2X9Zoct4WLo=;
        b=L9mv7Wzvbe42e1CbAnv05oCbj8xcueiPsoDNZRRpzHHeNz90zepp44MFDAB5Ig2c3VuFh2
        V2iePOr5/bQ6OyJrUh0fzeYi+Etn+LUBaymtZQoSoCcSWpeEqNfppdpXhuPnSceCrC7PJw
        FQX5XIZh1khAGao2jfLbVc3uYq60Ma8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-MRmop-UMMsCwBc5OMR-SOw-1; Mon, 08 Nov 2021 06:37:58 -0500
X-MC-Unique: MRmop-UMMsCwBc5OMR-SOw-1
Received: by mail-ed1-f71.google.com with SMTP id w12-20020a056402268c00b003e2ab5a3370so14651843edd.0
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 03:37:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zlpIDeohuxGJKr6/NQGxf0qdewWP/HeI2X9Zoct4WLo=;
        b=7Gp1FBrxLZtdLLPznCq60JiP/dpXmCX5Bb0a7oaVBOuV49TlXweCjVST64jywmnOM2
         JaN3XLPddHXxT4o1zWWDMv1M/ECGGUnUYaX+aHpD2XNraZ6SjDi/EuuRG9WQR6z6Jzwa
         d8yIitIlJv7iYLwFraGNvk/hsBJNAHTAqM2fga44VN1KwRzG0OUV27fhoM0+WS9ScErL
         y7u+pNAJETvGItZKQAX22bcOZJj89ptostApB9vDlcr4GW14I+/D9QfLc4pttPMWbhKf
         LGXqRuiHdC7VW7kYupEc4iRnHrCCIHywo7e4xjV6ZWbSZG+IDy7iudyEsrQueQYx39WV
         d6ZQ==
X-Gm-Message-State: AOAM531V5FfiHARLi5Yo+vggEfeL/0NjuLOWvusPtenk7kCj1EGg/QeQ
        t9SSPVpwDyDIrSViBVHJA0hTgTEjudm3MwO6korUCCLPLDm/NU+PH2LeU/1S0hyWN5gNidyIE+T
        yhm93/W2c2F4k1E7P
X-Received: by 2002:a50:ff07:: with SMTP id a7mr107385523edu.338.1636371476591;
        Mon, 08 Nov 2021 03:37:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6xBGQaHNOpSc3bDudxgiZ97suxKqVelKGBfKaraRJUbGpQNsgGOmD1+OdU/l8xcmlE13Mfg==
X-Received: by 2002:a50:ff07:: with SMTP id a7mr107385478edu.338.1636371476247;
        Mon, 08 Nov 2021 03:37:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id sb8sm6393735ejc.51.2021.11.08.03.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 03:37:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2E6B718026D; Mon,  8 Nov 2021 12:37:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
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
In-Reply-To: <20211105164453.29102-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
 <20210803163641.3743-4-alexandr.lobakin@intel.com>
 <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
 <20211026092323.165-1-alexandr.lobakin@intel.com>
 <20211105164453.29102-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Nov 2021 12:37:54 +0100
Message-ID: <87v912ri7h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Date: Tue, 26 Oct 2021 11:23:23 +0200
>
>> From: Saeed Mahameed <saeed@kernel.org>
>> Date: Tue, 03 Aug 2021 16:57:22 -0700
>> 
>> [ snip ]
>> 
>> > XDP is going to always be eBPF based ! why not just report such stats
>> > to a special BPF_MAP ? BPF stack can collect the stats from the driver
>> > and report them to this special MAP upon user request.
>> 
>> I really dig this idea now. How do you see it?
>> <ifindex:channel:stat_id> as a key and its value as a value or ...?
>
> Ideas, suggestions, anyone?

I don't like the idea of putting statistics in a map instead of the
regular statistics counters. Sure, for bespoke things people want to put
into their XDP programs, use a map, but for regular packet/byte
counters, update the regular counters so XDP isn't "invisible".

As Jesper pointed out, batching the updates so the global counters are
only updated once per NAPI cycle is the way to avoid a huge performance
overhead of this...

-Toke

