Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8528BB9C0F
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 05:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405112AbfIUDVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 23:21:49 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:49440 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbfIUDVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 23:21:49 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id x8L3FTe6002435;
        Sat, 21 Sep 2019 05:15:29 +0200
Date:   Sat, 21 Sep 2019 05:15:29 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Swarm <thesw4rm@pm.me>
Cc:     netdev@vger.kernel.org
Subject: Re: Verify ACK packets in handshake in kernel module (Access TCP
 state table)
Message-ID: <20190921031529.GG1889@1wt.eu>
Reply-To: netdev@vger.kernel.org
References: <20190920234346.kz22qswwvjxjins7@chillin-at-nou>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920234346.kz22qswwvjxjins7@chillin-at-nou>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 11:43:50PM +0000, Swarm wrote:
> First time emailing to this mailing list so please let me know if I made a
> mistake in how I sent it. I'm trying to receive a notification from the
> kernel once it verifies an ACK packet in a handshake. Problem is, there is no
> API or kernel resource I've seen that supports this feature for both
> syncookies and normal handshakes. Where exactly in the kernel does the ACK
> get verified? If there isn't a way to be notified of it, where should I start
> adding that feature into the kernel?

Just searching for TCP_ESTABLISHED immediately brought me to tcp_input.c
(tcp_rcv_state_process() to be precise), so I'm not sure you've searched
that much. As you've noticed there's nothing specifically called in this
case, but in practice a caller of accept() on a listening socket will be
woken up.

Hoping this helps,
Willy
