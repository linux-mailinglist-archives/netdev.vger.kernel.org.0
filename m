Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6648114FED7
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 20:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgBBTMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 14:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgBBTMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 14:12:20 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11BF62067C;
        Sun,  2 Feb 2020 19:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580670739;
        bh=KO4sn3zO8nvw3QW/QQhkERkdqFJdHcCldco9fJlTlKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RZq6f1Ec+nDj6z5GvStNM1Xj6c9qXy09haeVAMZ7jhUnJxoxQRjj2SUTi9lKCm7FA
         5zxFJKRA0DnkgJ20kn38pXAce4k2V1WsPyT1Xf2peujaNYO7gutvOjLeiQlsrDIEPw
         JzdoZZotYmNHp6LUwCmwT9uspxIEhFMwk1d/8L5M=
Date:   Sun, 2 Feb 2020 11:12:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200202111218.68e2d613@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <f821e692-59cf-ae58-f34f-7bab6a702b46@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126141141.0b773aba@cakuba>
        <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
        <20200127061623.1cf42cd0@cakuba>
        <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
        <20200128055752.617aebc7@cakuba>
        <87ftfue0mw.fsf@toke.dk>
        <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net>
        <f821e692-59cf-ae58-f34f-7bab6a702b46@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Feb 2020 10:45:27 -0700, David Ahern wrote:
> On 2/1/20 10:08 AM, Jakub Kicinski wrote:
> > If EGRESS is only for XDP frames we could try to hide the handling in
> > the core (with slight changes to XDP_TX handling in the drivers),  
> 
> It is not. I have said multiple times it is to work on ALL packets that
> hit the xmit function, both skbs and xdp_frames.

Okay, I should have said "was to be", I guess?

 If EGRESS _was_to_be_ only for XDP frames we could try to hide the
 handling in the core (with slight changes to XDP_TX handling in the
 drivers), making drivers smaller and XDP feature velocity higher.

I understand you'd like a hook for all packets, that is clear.
I'm just trying to highlight the cost and consequences.
