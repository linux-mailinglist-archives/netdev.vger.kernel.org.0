Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415832440C3
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 23:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgHMVgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 17:36:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:57660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgHMVgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 17:36:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4A2C7AD89;
        Thu, 13 Aug 2020 21:36:36 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 703E57F447; Thu, 13 Aug 2020 23:36:13 +0200 (CEST)
Date:   Thu, 13 Aug 2020 23:36:13 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] bonding: show saner speed for broadcast mode
Message-ID: <20200813213613.qvem7gv4ri2trfvv@carpenter>
References: <20200813035509.739-1-jarod@redhat.com>
 <27389.1597296596@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27389.1597296596@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 10:29:56PM -0700, Jay Vosburgh wrote:
> 	Did you notice this by inspection, or did it come up in use
> somewhere?  I can't recall ever hearing of anyone using broadcast mode,
> so I'm curious if there is a use for it, but this change seems
> reasonable enough regardless.

I did actually encountered our customers using broadcast mode twice. But
I have to disappoint you, their "use for it" was rather an abuse.

One of them had a number of hosts, each having two NICs in broadcast
mode bond, one connected to one switch and one connected to another
switch (with no direct connection between the switches). Having each
packet duplicated when everything worked triggered some corner cases in
networking stack (IIRC one issue in fragment reassembly and one in TCP
lockless listener). Thankfully I was eventually able to convince them
that this kind of redundancy does not really work if one host loses
connection to one switch and another host to the other.

I don't remember the other use case from the top of my head but I'm
quite sure it made even less sense.

Michal
