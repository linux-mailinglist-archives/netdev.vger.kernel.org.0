Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF34A1704F7
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBZQ41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:56:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59540 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727141AbgBZQ41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 11:56:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582736186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CNsyjdxK48Cw49zWT8HuZD4GB+V/KT2uU4ow3+nZTxU=;
        b=CI6Qtqt8mlswNe16SEJyIOnIRrUqPCvUtS9i01yMWb+EciDcz8fS7n0rqZKfDZsby6uT1a
        kmHJkova+F+fPIEMwkEqDW7DpscRdJjqpUD0emPO5ztKELCKFVVDZlhu7jY3gKkPXpExH8
        HpTdwUpqsPrbdcFD59oQYQqrq43N+6M=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-eL6Gf2FxPbOs12dLGaH4uQ-1; Wed, 26 Feb 2020 11:56:24 -0500
X-MC-Unique: eL6Gf2FxPbOs12dLGaH4uQ-1
Received: by mail-qk1-f198.google.com with SMTP id s189so4953398qke.5
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 08:56:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CNsyjdxK48Cw49zWT8HuZD4GB+V/KT2uU4ow3+nZTxU=;
        b=cjxKqSX6FElR1QWjufk2KN/FNC0R92lvDOIow2VvZYNIt2BX5zAdgM/7X5Jt0qLdYP
         fTUw7XIdTRMFh0SpQ13WvlxEiiQ1l64Jh8c5uXVg9cbNMOCQu9W+Nie62XAqoIr8obXz
         pYkkpGfCq2dNWna7B1YvoExCAD8GP7MXsTwJ91Q30EBSwHROp75a7BJgvrBE2dUoY3en
         CfEICuPVaJhHFVb49W+Mt02/iHtv9e+skPH+UlkAqv9TD6YHL5Xkn/Ps1yQ5DU7//MQk
         xivuxzWkgzuzsFn9mN4i2a6T/1GM/AFjvErtSFh/7sPzaSw/z5gpItTuncTXAtcdQwdJ
         iQ1Q==
X-Gm-Message-State: APjAAAUZS5MiAp7aqpsh66EYfgWiJMG+Ex+DTNfjcLiZxlnXPBiOqET0
        jzwMiDFhukN8onynJBAV/MEhtVAomK3TdQDTtLWN5QkpuhpzzGacaa6cSpA3Ev1JeQH5DqBs9MX
        wPwOMtGlkhwe26HdC
X-Received: by 2002:ad4:57ac:: with SMTP id g12mr42470qvx.58.1582736183884;
        Wed, 26 Feb 2020 08:56:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqyXi2y52deki6N94lokgUJkTVwsh+cUvM8nuSphdEpXa+kNqh0UgIZFy74naC5aia6mtQMlcw==
X-Received: by 2002:ad4:57ac:: with SMTP id g12mr42422qvx.58.1582736183134;
        Wed, 26 Feb 2020 08:56:23 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id o17sm1378356qtq.93.2020.02.26.08.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:56:22 -0800 (PST)
Date:   Wed, 26 Feb 2020 11:56:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200226115541-mutt-send-email-mst@kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
 <20200226015113-mutt-send-email-mst@kernel.org>
 <c8f874c6-3271-6bd1-f3b9-4d0b0786cd52@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8f874c6-3271-6bd1-f3b9-4d0b0786cd52@digitalocean.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 09:08:57AM -0700, David Ahern wrote:
> On 2/26/20 12:07 AM, Michael S. Tsirkin wrote:
> > 
> > Well the reason XDP wants to limit MTU is this:
> >     the MTU must be less than a page
> >     size to avoid having to handle XDP across multiple pages
> > 
> > however device mtu basically comes from dhcp.
> 
> Not necessarily.
> 
> > it is assumed that whoever configured it knew
> > what he's doing and configured mtu to match
> > what's going on on the underlying backend.
> > So we are trusting the user already.
> > 
> > But yes, one can configure mtu later and then it's too late
> > as xdp was attached.
> > 
> > 
> >>
> >>
> >> The simple solution is:
> >>
> >> @@ -2489,6 +2495,8 @@ static int virtnet_xdp_set(struct net_device *dev,
> >> struct bpf_prog *prog,
> >>                 }
> >>         }
> >>
> >> +       dev->max_mtu = prog ? max_sz : MAX_MTU;
> >> +
> >>         return 0;
> >>
> >>  err:
> > 
> > 
> > Well max MTU comes from the device ATM and supplies the limit
> > of the underlying backend. Why is it OK to set it to MAX_MTU?
> > That's just asking for trouble IMHO, traffic will not
> > be packetized properly.
> 
> I grabbed that from virtnet_probe() for sake of this discussion:
> 
>         /* MTU range: 68 - 65535 */
>         dev->min_mtu = MIN_MTU;
>         dev->max_mtu = MAX_MTU;
> 
> but yes I see the MTU probe now, so I guess that could be used instead
> of MAX_MTU.
> 
> > 
> > 
> >> The complicated solution is to implement ndo_change_mtu.
> >>
> >> The simple solution causes a user visible change with 'ip -d li sh' by
> >> showing a changing max mtu, but the ndo has a poor user experience in
> >> that it just fails EINVAL (their is no extack) which is confusing since,
> >> for example, 8192 is a totally legit MTU. Changing the max does return a
> >> nice extack message.
> > 
> > Just fail with EBUSY instead?
> > 
> 
> consistency. If other change_mtu functions fail EINVAL, then virtio net
> needs to follow suit.

Maybe we should change them all to EBUSY - that's not too hard ...

-- 
MST

