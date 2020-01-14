Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78103139FED
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgAND0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:26:01 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:39139 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgAND0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 22:26:00 -0500
Received: by mail-io1-f67.google.com with SMTP id c16so12221647ioh.6;
        Mon, 13 Jan 2020 19:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lc+FzOA81GzDaKFVamw+KMRZXs6s+TuqkFNIei4yl7E=;
        b=LTah/TXKAb16Y7C4RXihay1XNjXKKBcMnTFjXq/9Xjtght+fvKDvXxSTE/DaYUB3GB
         Njz0asFp3Lv2jMA7eRAHCffZB5unKGexIfQT1TPi0qj6ybKXvcaFSF+jEAWCCBUztYmL
         mQoQlYg8u/t42ihct9ndQ2/mjK7mFT/MI44+aQdyCEEXI4rA6UiF6Yz+FRsfcMvnJ/28
         KXAsA+HdtnW8cpvsfQlmAo82VsSJJTVwJicUT1IkRVVcU06ULrms1dcKeW9AWArxAq++
         sOnfUjtXPR2mWY3c5A1ZVZ1SW0qHhwxe1EzqRkDeFHIgtyazKdeOGZyyDjznF3OLyhOI
         4sIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lc+FzOA81GzDaKFVamw+KMRZXs6s+TuqkFNIei4yl7E=;
        b=e5leoUDeIe8CHU4D1IpeE6Sh3dNDdsBt3DhHMkE60J/SjoH4x9FbLpbQw+F3hxzKEm
         dnr0NCs/JeiOjmnsRopdY0qQsU2bqLhnGnc1hYmfxI6aBZH5gyEwL9Bs81AizwW4AMN7
         aqOi2TouSkVwVTBzjob2/+a94UMA7rNPemTNUAIwpN9jjj0HehN6vLjTKNpTt1QzZpD4
         JERNQZxZTYAWUSStPZFJTl0mRZYielMpx3Kr/Qbc4u7eXGRoVUHcjR6n7ZSMwtlGhi/H
         TtDQPvt9pXFM1NEJatzcdoA+GpfglOpspBcfFCdlU5hBKzjYVmLID3xjHMsvz1kHxKRE
         0IbQ==
X-Gm-Message-State: APjAAAWRem26/ABEiyODvfKhtqjuaO157QS70dNUkPr9yWassbAl/lhd
        ef9DjhCikmBTBFzfg8VWDM8=
X-Google-Smtp-Source: APXvYqz0quPj1x3hKzho5OP2a7QJC80UpPCv19TmUgPkZIZYVfAR8xSMftPJmmj+9iMBNFai4nLajQ==
X-Received: by 2002:a6b:710f:: with SMTP id q15mr15686912iog.103.1578972360168;
        Mon, 13 Jan 2020 19:26:00 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d12sm4522452iln.63.2020.01.13.19.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 19:25:59 -0800 (PST)
Date:   Mon, 13 Jan 2020 19:25:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        toshiaki.makita1@gmail.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Message-ID: <5e1d34bfbf1f5_78752af1940225b41c@john-XPS-13-9370.notmuch>
In-Reply-To: <20200112064948.GA24292@ranger.igk.intel.com>
References: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
 <157879666276.8200.5529955400195897154.stgit@john-Precision-5820-Tower>
 <20200112064948.GA24292@ranger.igk.intel.com>
Subject: Re: [bpf-next PATCH v2 2/2] bpf: xdp, remove no longer required
 rcu_read_{un}lock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> On Sat, Jan 11, 2020 at 06:37:42PM -0800, John Fastabend wrote:
> > Now that we depend on rcu_call() and synchronize_rcu() to also wait
> > for preempt_disabled region to complete the rcu read critical section
> > in __dev_map_flush() is no longer required. Except in a few special
> > cases in drivers that need it for other reasons.
> > 
> > These originally ensured the map reference was safe while a map was
> > also being free'd. And additionally that bpf program updates via
> > ndo_bpf did not happen while flush updates were in flight. But flush
> > by new rules can only be called from preempt-disabled NAPI context.
> > The synchronize_rcu from the map free path and the rcu_call from the
> > delete path will ensure the reference there is safe. So lets remove
> > the rcu_read_lock and rcu_read_unlock pair to avoid any confusion
> > around how this is being protected.
> > 
> > If the rcu_read_lock was required it would mean errors in the above
> > logic and the original patch would also be wrong.
> > 
> > Now that we have done above we put the rcu_read_lock in the driver
> > code where it is needed in a driver dependent way. I think this
> > helps readability of the code so we know where and why we are
> > taking read locks. Most drivers will not need rcu_read_locks here
> > and further XDP drivers already have rcu_read_locks in their code
> > paths for reading xdp programs on RX side so this makes it symmetric
> > where we don't have half of rcu critical sections define in driver
> > and the other half in devmap.
> > 
> > Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---

[...]

> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 4d7d5434..2c11f82 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -498,12 +498,16 @@ static int virtnet_xdp_xmit(struct net_device *dev,
> >  	void *ptr;
> >  	int i;
> >  
> > +	rcu_read_lock();
> > +
> >  	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
> >  	 * indicate XDP resources have been successfully allocated.
> >  	 */
> >  	xdp_prog = rcu_dereference(rq->xdp_prog);
> 
> We could convert that rcu_dereference to rcu_access_pointer so that we
> don't need the rcu critical section here at all. Actually this was
> suggested some time ago by David Ahern during the initial discussion
> around this code. Not sure why we didn't change it.

Makes sense I'll send a v3 with a middle patch to do this and then drop
this segment.

> 
> Veth is also checking the xdp prog presence and it is doing that via
> rcu_access_pointer so such conversion would make it more common, no?

veth derefernces rcv netdevice and this accesses it. The logic to
drop the rcu here is less obvious to me. At least I would have to
study it closely.

> 
> xdp_prog is only check against NULL, so quoting the part of comment from
> rcu_access_pointer:
> "This is useful when the value of this pointer is accessed, but the pointer
> is not dereferenced, for example, when testing an RCU-protected pointer
> against NULL."

+1 thanks it does make the cleanup nicer.
