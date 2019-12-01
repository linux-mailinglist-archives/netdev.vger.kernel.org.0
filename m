Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3C10E3B9
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 22:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfLAVyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 16:54:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfLAVym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 16:54:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98EE614FD3304;
        Sun,  1 Dec 2019 13:54:41 -0800 (PST)
Date:   Sun, 01 Dec 2019 13:54:39 -0800 (PST)
Message-Id: <20191201.135439.2128495024712395126.davem@davemloft.net>
To:     mst@redhat.com
Cc:     dsahern@gmail.com, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 08/18] tun: run offloaded XDP program in Tx path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191201163730-mutt-send-email-mst@kernel.org>
References: <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
        <20191201.125621.1568040486743628333.davem@davemloft.net>
        <20191201163730-mutt-send-email-mst@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Dec 2019 13:54:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 1 Dec 2019 16:40:22 -0500

> Right. But it is helpful to expose the supported functionality
> to guest in some way, if nothing else then so that
> guests can be moved between different hosts.
> 
> Also, we need a way to report this kind of event to guest
> so it's possible to figure out what went wrong.

On the contrary, this is why it is of utmost importance that all
XDP implementations support the full suite of XDP facilities from
the very beginning.

This is why we keep giving people a hard time when they add support
only for some of the XDP return values and semantics.  Users will get
killed by this, and it makes XDP a poor technology to use because
behavior is not consistent across device types.

That's not acceptable and I'll push back on anything that continues
this trend.

If you can't HW offload it, kick it to software.
