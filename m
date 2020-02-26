Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6081704EC
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgBZQzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:55:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47741 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727207AbgBZQzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 11:55:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582736116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QghDX0WPBmZ7Md8D4iHS7l6wh7yMUTG4xDtF/f+kKSQ=;
        b=MPqoT1ls7FVebyLksNZSCg9JJA2w25wIiBknlm4+y0cXRn1wpRV+WQqc3p0n2iyLD3Xtgr
        LA5uF92Ubc//kcp//d0CI4nJDVmVDfGILfA6AkBVtu45bKcV5uZE3G1OFtJEpzMoLkmWD8
        FCnYNjgTj7JMQIItB0KbqF9E37ug65M=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-NWQEhKc2NTu3I6aYuB0-xA-1; Wed, 26 Feb 2020 11:55:13 -0500
X-MC-Unique: NWQEhKc2NTu3I6aYuB0-xA-1
Received: by mail-qk1-f197.google.com with SMTP id n130so4903734qke.19
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 08:55:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QghDX0WPBmZ7Md8D4iHS7l6wh7yMUTG4xDtF/f+kKSQ=;
        b=uEeRE25kW0mWW27tt+M8Zu5Lqo0i/9BTwMPfDsCwblFXPe6VHMWASRoxOm2tR/Sbza
         WTXveVzoiHPfFnTrgzB5Iwl2yEkkuipH0cVPEFogkyLVS52HkXf/HbvTkMEQkk+R/Ph3
         oG01A6PHzaaQWzvlymmM3cO+ssejVP8dYytgLEG/8dzMedGKhhg8gq5UEFufPPNa8XWF
         IqxZ0HP+Mp9GI+CFhhNTH2SEvVjD4TLvlWM0eQUb5eqfD8QcRQzQS2Dy+U3j9vkvHGIc
         Nyqq+KP/jZ5OfPvl7YwmYpxBceue6ARerwofrfIs7/GNKuNjY5CuesAKHqNXif7QNZUi
         5mXg==
X-Gm-Message-State: APjAAAVOiMn8BSzkfBlfXRetObAQxCE7PSRO++V/9tCJ7OmMIdhxgQgx
        KCK11LBIeTsb64K5QtGxerW/L21keoIz7F+xUSZrM1dTVyyOZEojLIBbH0gYIHtEiG2HqJizuan
        e88Wo+fsQTGGdGWn0
X-Received: by 2002:a05:620a:2114:: with SMTP id l20mr46753qkl.214.1582736113439;
        Wed, 26 Feb 2020 08:55:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqzw5irFxxDmVBrHdkXWtpp3/vcxarI3LtSkfDmDJ/Rq9bktG2M/J8V9hPgSasC6rd8cRRK8Mg==
X-Received: by 2002:a05:620a:2114:: with SMTP id l20mr46725qkl.214.1582736113203;
        Wed, 26 Feb 2020 08:55:13 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id a3sm1082321qtb.12.2020.02.26.08.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:55:12 -0800 (PST)
Date:   Wed, 26 Feb 2020 11:55:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200226115258-mutt-send-email-mst@kernel.org>
References: <20200226093330.GA711395@redhat.com>
 <87lfopznfe.fsf@toke.dk>
 <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 09:03:47AM -0700, David Ahern wrote:
> On 2/26/20 2:51 AM, Toke Høiland-Jørgensen wrote:
> > "Michael S. Tsirkin" <mst@redhat.com> writes:
> > 
> >> On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
> >>> Another issue is that virtio_net checks the MTU when a program is
> >>> installed, but does not restrict an MTU change after:
> >>>
> >>> # ip li sh dev eth0
> >>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
> >>> state UP mode DEFAULT group default qlen 1000
> >>>     link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
> >>>     prog/xdp id 13 tag c5595e4590d58063 jited
> >>>
> >>> # ip li set dev eth0 mtu 8192
> >>>
> >>> # ip li sh dev eth0
> >>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
> >>> state UP mode DEFAULT group default qlen 1000
> >>>
> >>>
> >>
> >> Cc Toke who has tested this on other cards and has some input.
> > 
> > Well, my comment was just that we already restrict MTU changes on mlx5
> > when an XDP program is loaded:
> > 
> > $ sudo ip link set dev ens1f1 mtu 8192
> > RTNETLINK answers: Invalid argument
> > 
> > Reading through the rest of the thread I don't have any strong opinions
> > about whether this should propagate out from the host or not. I suspect
> > it would not be worth the trouble, though, and as you say it's already
> > possible to configure regular network devices in a way that is
> > incompatible with the rest of the network.
> > 
> 
> Both mlx5 and sfc restrict MTU change to XDP limits; virtio does not
> which strikes me as a problem.

OK that seems to indicate an ndo callback as a reasonable way
to handle this. Right? The only problem is this might break
guests if they happen to reverse the order of
operations:
	1. set mtu
	2. detach xdp prog
would previously work fine, and would now give an error.

If we want to make it transparent for userspace,
I guess we can defer the actual update until xdp prog is detached.
Sound ugly and might still confuse some userspace ... worth it?

-- 
MST

