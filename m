Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DD22E69B9
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 18:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgL1RbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 12:31:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728193AbgL1RbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 12:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609176573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gqheeXuSb59aslpjArFSGbaeJvg58fMnkkWQl2JDjzE=;
        b=N7nCIZUw2+L74RGj3VI25DA69sdv+5x1ae2AtQt7hSJSj6Gv2UvwLa7xZjRSPzNqVWqVhz
        E4pLNWt67bmUft0ljHbwgwLBOsM96U2f5SEU1SBEgb2tL/auR1mpdAglplENvbCmkIqBhq
        /QMEDs96gpARfmXuh3LWBCfgL5PzaTw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-eGjT2aKQPdedUAUGTfh9hQ-1; Mon, 28 Dec 2020 12:29:31 -0500
X-MC-Unique: eGjT2aKQPdedUAUGTfh9hQ-1
Received: by mail-wr1-f71.google.com with SMTP id w8so6579308wrv.18
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 09:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gqheeXuSb59aslpjArFSGbaeJvg58fMnkkWQl2JDjzE=;
        b=JWCkzKXqauGQr4wFH9u8B3onTtJ2kPz8qJ2cVCbrkPP6ka49Zv3h+mGpdyvcLqdRS3
         YBVcfjMDYO5HbmGKB965BGMVjGDWFuj0Bck/8emam0jh+t3qurzzd3MOV6xyGIXu6PXY
         rz/HIk9L3udVvulqrlFMEECUVpaHP1psPATW1RnaaEcpstHnVWihEVBnIO2F0iZwLZi7
         91ZJts/DylwyC09hsM7bS62Kwp/Oo4gCtOfazMcpIZ4Cq3C9h10FpmKZHKKyu/4eEzfg
         hLutJYbzeKfPvESLyET7tsyjoIMJzn4ohOMXGcS+s70djGS5fPo6UIMcQzE/I2ZT+3Lb
         ZfDw==
X-Gm-Message-State: AOAM530ttM7KAEqa71LvICcORpztRO+hhI3LVo2gvTwQv9KUFfeQeAgr
        KIc1OnI7hBSp4DLIDI3Hct9m1BMqhZesMnHFMgtviDHZKJMQPOy/5LnzgUcjAPNX5XHmYo61/Iq
        e6ATemQwdFb1L5tAJ
X-Received: by 2002:a1c:98cc:: with SMTP id a195mr21585538wme.150.1609176569783;
        Mon, 28 Dec 2020 09:29:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyyjPoX1wv9vUJCGpM1vzOZhx2I0HhVXjs1OYgo5Qgnl9LdLiUKwvZrK3BBqN83Vcd/2tiOJw==
X-Received: by 2002:a1c:98cc:: with SMTP id a195mr21585531wme.150.1609176569653;
        Mon, 28 Dec 2020 09:29:29 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id u3sm64803262wre.54.2020.12.28.09.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 09:29:29 -0800 (PST)
Date:   Mon, 28 Dec 2020 12:29:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jasowang@redhat.com, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH rfc 0/3] virtio-net: add tx-hash, rx-tstamp and tx-tstamp
Message-ID: <20201228122911-mutt-send-email-mst@kernel.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 11:22:30AM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> RFC for three new features to the virtio network device:
> 
> 1. pass tx flow hash and state to host, for routing + telemetry
> 2. pass rx tstamp to guest, for better RTT estimation
> 3. pass tx tstamp to host, for accurate pacing
> 
> All three would introduce an extension to the virtio spec.
> I assume this would require opening three ballots against v1.2 at
> https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
> 
> This RFC is to informally discuss the proposals first.
> 
> The patchset is against v5.10. Evaluation additionally requires
> changes to qemu and at least one back-end. I implemented preliminary
> support in Linux vhost-net. Both patches available through github at
> 
> https://github.com/wdebruij/linux/tree/virtio-net-txhash-1
> https://github.com/wdebruij/qemu/tree/virtio-net-txhash-1

Any data on what the benefits are?

> Willem de Bruijn (3):
>   virtio-net: support transmit hash report
>   virtio-net: support receive timestamp
>   virtio-net: support transmit timestamp
> 
>  drivers/net/virtio_net.c        | 52 +++++++++++++++++++++++++++++++--
>  include/uapi/linux/virtio_net.h | 23 ++++++++++++++-
>  2 files changed, 71 insertions(+), 4 deletions(-)
> 
> -- 
> 2.29.2.729.g45daf8777d-goog

