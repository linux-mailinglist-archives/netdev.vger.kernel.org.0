Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0578104A43
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 06:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfKUFag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 00:30:36 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51614 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbfKUFag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 00:30:36 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iXf31-0001ve-6r; Thu, 21 Nov 2019 06:30:31 +0100
Date:   Thu, 21 Nov 2019 06:30:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Byron Stanoszek <gandalf@winds.org>
Cc:     Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel 5.4 regression - memory leak in network layer
Message-ID: <20191121053031.GI20235@breakpoint.cc>
References: <alpine.LNX.2.21.1.1911191047410.30058@winds.org>
 <20191119162222.GA20235@breakpoint.cc>
 <20191120202822.GF20235@breakpoint.cc>
 <alpine.LNX.2.21.1.1911201706510.2521@winds.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1.1911201706510.2521@winds.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byron Stanoszek <gandalf@winds.org> wrote:
> On Wed, 20 Nov 2019, Florian Westphal wrote:
> > Not reproducible.
> > 
> > I'm on
> > 
> > c74386d50fbaf4a54fd3fe560f1abc709c0cff4b ("afs: Fix missing timeout reset").
> 
> I confirm I still see the issue on that commit.

[..]

> netperf -H 172.17.2.11 -t UDP_RR

Ah, thats all it takes.  Its related to UDP_SKB_IS_STATELESS, commit
895b5c9f206eb7d25dc1360a is the culprit.  I'll send a fix shortly.
