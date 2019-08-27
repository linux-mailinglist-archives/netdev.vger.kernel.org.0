Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC079F4FA
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbfH0VTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:19:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50866 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfH0VTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:19:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A682A1534D21E;
        Tue, 27 Aug 2019 14:19:52 -0700 (PDT)
Date:   Tue, 27 Aug 2019 14:19:50 -0700 (PDT)
Message-Id: <20190827.141950.540994003351676048.davem@davemloft.net>
To:     leonardo@linux.ibm.com
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages
 if IPv6 is disabled on boot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <77c43754ff72e9a2e8048ccd032351cf0186080a.camel@linux.ibm.com>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
        <20190827103541.vzwqwg4jlbuzajxu@salvia>
        <77c43754ff72e9a2e8048ccd032351cf0186080a.camel@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 14:19:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leonardo Bras <leonardo@linux.ibm.com>
Date: Tue, 27 Aug 2019 14:34:14 -0300

> I could reproduce this bug on a host ('ipv6.disable=1') starting a
> guest with a virtio-net interface with 'filterref' over a virtual
> bridge. It crashes the host during guest boot (just before login).
> 
> By that I could understand that a guest IPv6 network traffic
> (viavirtio-net) may cause this kernel panic.

Really this is bad and I suspected bridging to be involved somehow.

If ipv6 is disabled ipv6 traffic should not pass through the machine
by any means whatsoever.  Otherwise there is no point to the knob
and we will keep having to add hack checks all over the tree instead
of fixing the fundamental issue.
