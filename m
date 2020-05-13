Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086621D1012
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgEMKnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 06:43:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60802 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727794AbgEMKnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 06:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589366624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=By1oHJ55HYnTp2+5ih4+YBVA/OqGbmChr/BDl7CqcIw=;
        b=iblspMsOpLDEorNXFbjZbCgbi1WJNpp7BszNKKm4DeuCH2fDCxMYBHvZP5N/mpLduplE2m
        ImiWspUJ8YD+L8G7s5AG4hsenzzROby4lAgP1gqpAM/yLPOiGSa7svl8q4xHV1wdjTWhW2
        29g7L6B/qNnqK1iMAffun/IQJoQkW60=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Ke8XHpp_O9eaYrXcg-DhjQ-1; Wed, 13 May 2020 06:43:42 -0400
X-MC-Unique: Ke8XHpp_O9eaYrXcg-DhjQ-1
Received: by mail-lf1-f70.google.com with SMTP id c7so5982667lfp.13
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 03:43:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=By1oHJ55HYnTp2+5ih4+YBVA/OqGbmChr/BDl7CqcIw=;
        b=oML6pTIYwgi5T85dt+cRKhrSeBdqpj2xAYUPDxEfw4b9mM20xLdVNTFtt7ta7nV8mK
         NEMGyiL+WC6XfZe6V6ZHBDQkmPK4BNPOzmLDsQONofIzhXkFVOve1tc9q+zEwxToc4Wi
         WuPT7PcpdAs/JxR5wlqfSEeiWEo/MMBVQYM1UhmyH66PgX0B+PTRIwrU33mtKvpl7LoY
         pxE/dm8owjXQjfvL3gUi7gmjf3RiTnF137Hd09Y0RjkrbpOpQ0R9XzBChofrqTHZiPV+
         mPv7Ay7jNFl44IuTK1yc2njkrk9JgxH1L/eLZWA8MjD1BTGYMUnqx7eBBD8FsM31UVWX
         RXuQ==
X-Gm-Message-State: AOAM530IVgR115XnfgpsB8TxoRMIlHsyWv0Y6PccYwBxQMFbJSrtM1kF
        pY0aqalHMNc7Dej8/J8zGsZ/zsU9zxrA9bhRIw1qIqs2EaPOrRiJ/m81wARCWgoEqR12KbdoWLj
        /TOVeI2nAur7nAyi0
X-Received: by 2002:a2e:8047:: with SMTP id p7mr15959233ljg.206.1589366621126;
        Wed, 13 May 2020 03:43:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqz6l4idmYLxxyBCo7YDhy3gx6Get0+fR5Q+8aE+Wt9/2/vDg6/BLhI4laboyuOPLXXu1znQ==
X-Received: by 2002:a2e:8047:: with SMTP id p7mr15959225ljg.206.1589366620919;
        Wed, 13 May 2020 03:43:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j2sm15509102lfm.68.2020.05.13.03.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 03:43:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7F76818150C; Wed, 13 May 2020 12:43:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
In-Reply-To: <20200513014607.40418-1-dsahern@kernel.org>
References: <20200513014607.40418-1-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 May 2020 12:43:39 +0200
Message-ID: <87sgg4t8ro.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> This series adds support for XDP in the egress path by introducing
> a new XDP attachment type, BPF_XDP_EGRESS, and adding a UAPI to
> if_link.h for attaching the program to a netdevice and reporting
> the program. This allows bpf programs to be run on redirected xdp
> frames with the context showing the Tx device.
>
> This is a missing primitive for XDP allowing solutions to build small,
> targeted programs properly distributed in the networking path allowing,
> for example, an egress firewall/ACL/traffic verification or packet
> manipulation based on data specific to the egress device.
>
> Nothing about running a program in the Tx path requires driver specific
> resources like the Rx path has. Thus, programs can be run in core
> code and attached to the net_device struct similar to skb mode. The
> egress attach is done using the new XDP_FLAGS_EGRESS_MODE flag, and
> is reported by the kernel using the XDP_ATTACHED_EGRESS_CORE attach
> flag with IFLA_XDP_EGRESS_PROG_ID making the api similar to existing
> APIs for XDP.
>
> The egress program is run in bq_xmit_all before invoking ndo_xdp_xmit.
> This is similar to cls_bpf programs which run before the call to
> ndo_dev_xmit. Together the 2 locations cover all packets about to be
> sent to a device for Tx.
>
> xdp egress programs are not run on skbs, so a cls-bpf counterpart
> should also be attached to the device to cover all packets -
> xdp_frames and skbs.
>
> v5:
> - rebased to top of bpf-next
> - dropped skb path; cls-bpf provides an option for the same functionality
>   without having to take a performance hit (e.g., disabling GSO).

I don't like this. I makes the egress hook asymmetrical with the ingress
hook (ingress hook sees all traffic, egress only some of it). If the
performance hit of disabling GSO is the concern, maybe it's better to
wait until we figure out how to deal with that (presumably by
multi-buffer XDP)?

-Toke

