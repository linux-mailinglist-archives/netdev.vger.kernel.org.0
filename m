Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A3C2F10DD
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbhAKLLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:11:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbhAKLLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 06:11:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610363427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iPtimXSa5HaqYXoGFLVWADSAXShvEdzJS6odxkqqUuc=;
        b=FSwGeQXfiOW8cNMVu3NvkCfg3k8ViwwgbHRDtEuNV0kCEnvxHwet+SCYQNqy2NiiVkb7as
        TRewW6Hgn8GxLRmjK6GfFds405E/OKOCZrDL9TFJmVAjGun2bhXk8988rU+YVw1Q4hs/QA
        lDZHH6VgHQ2z1yqk9QQyWIz68LhZWnM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-5OtIk9QDOwy6Q8Nv07F3Ew-1; Mon, 11 Jan 2021 06:10:26 -0500
X-MC-Unique: 5OtIk9QDOwy6Q8Nv07F3Ew-1
Received: by mail-wr1-f72.google.com with SMTP id w8so7659283wrv.18
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 03:10:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iPtimXSa5HaqYXoGFLVWADSAXShvEdzJS6odxkqqUuc=;
        b=PgCTI+p/C3wlletRqyRM4oEYx32boo1snj0vVz7B0l+DikrM/8agcw5afw0m4SPO41
         gIQFkuyz7vyHuuxoE+5TEkJB7dmHXIPB/Kz62CmP0qimifdub0kjSiDmfMzx38j5pQKz
         MvwDHAW1mHFw3fL7OMnZWAc9gAsVYFj6HD8/x6GHCpZgk0WYi5+sTYAlmHKuNGqIMfcw
         UZNQa5SRPRwGN6tT6asNhW7gd0eXUB3B4/QbAvE72/YIwOT8YHxN5alskM8i9e6qV1m1
         MVzMxgqSDtKngKKRNFsfbiG6EOprFmN9uygglPrEKl+QfdtC7uOOJJcp580blvRnlqC9
         tLeQ==
X-Gm-Message-State: AOAM533i+TALWMX2HfcUnafj43J1pjVnHGQChCdEbiFBu/bVnESBnxV8
        STurVsH95SI+cNYf/GCLyR+Bap2MVsJlzxBBnJYJum4N0A+94MZYGFyH3tNxEe12f2wLIw1ulJ7
        9iOUa6tHzoDfnOqn8
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr13987389wml.33.1610363424375;
        Mon, 11 Jan 2021 03:10:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwK8V7Nf6Xd7BuJM/KOGjek5Wby7rOOtWOn0jppbb+9pIG9FWP0ylSztYYPHvBWxqefoaiXMQ==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr13987366wml.33.1610363423994;
        Mon, 11 Jan 2021 03:10:23 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q143sm21430622wme.28.2021.01.11.03.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 03:10:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DE0A418030E; Mon, 11 Jan 2021 12:10:22 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Charlie Somerville <charlie@charlie.bz>, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, Charlie Somerville <charlie@charlie.bz>
Subject: Re: [PATCH net-next 0/2] Introduce XDP_FLAGS_NO_TX flag
In-Reply-To: <20210109024950.4043819-1-charlie@charlie.bz>
References: <20210109024950.4043819-1-charlie@charlie.bz>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 11 Jan 2021 12:10:22 +0100
Message-ID: <875z43n2zl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Charlie Somerville <charlie@charlie.bz> writes:

> This patch series introduces a new flag XDP_FLAGS_NO_TX which prevents
> the allocation of additional send queues for XDP programs.
>
> Included in this patch series is an implementation of XDP_FLAGS_NO_TX
> for the virtio_net driver. This flag is intended to be advisory - not
> all drivers must implement support for it.
>
> Many virtualised environments only provide enough virtio_net send queues
> for the number of processors allocated to the VM:
>
> # nproc
> 8
> # ethtool --show-channels ens3
> Channel parameters for ens3:
> Pre-set maximums:
> RX:     0
> TX:     0
> Other:      0
> Combined:   8
>
> In this configuration XDP is unusable because the virtio_net driver
> always tries to allocate an extra send queue for each processor - even
> if the XDP the program never uses the XDP_TX functionality.
>
> While XDP_TX is still unavailable in these environments, this new flag
> expands the set of XDP programs that can be used.

I don't think adding a new flag is a good idea. Why can't you just fix
the driver?

-Toke

