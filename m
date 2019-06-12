Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE70343105
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389187AbfFLUcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:32:46 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40557 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388338AbfFLUcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:32:46 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hb9vA-0004NO-4v; Wed, 12 Jun 2019 16:32:42 -0400
Date:   Wed, 12 Jun 2019 16:32:30 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net] sctp: Free cookie before we memdup a new one
Message-ID: <20190612203230.GB23166@hmswarspite.think-freely.org>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
 <20190612003814.7219-1-nhorman@tuxdriver.com>
 <20190612180715.GC3500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612180715.GC3500@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 03:07:15PM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Jun 11, 2019 at 08:38:14PM -0400, Neil Horman wrote:
> > Based on comments from Xin, even after fixes for our recent syzbot
> > report of cookie memory leaks, its possible to get a resend of an INIT
> > chunk which would lead to us leaking cookie memory.
> > 
> > To ensure that we don't leak cookie memory, free any previously
> > allocated cookie first.
> > 
> > ---
> 
> This marker can't be here, as it causes git to loose everything below.
> 
thats intentional so that, when Dave commits it, the change notes arent carried
into the changelog (I.e. the change notes are useful for email review, but not
especially useful in the permanent commit history).

Neil

> > Change notes
> > v1->v2
> > update subsystem tag in subject (davem)
> > repeat kfree check for peer_random and peer_hmacs (xin)
> > 
> > v2->v3
> > net->sctp
> > also free peer_chunks
> > 
> > v3->v4
> > fix subject tags
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
> > CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > CC: Xin Long <lucien.xin@gmail.com>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: netdev@vger.kernel.org
> 
> Anyhow, LGTM and reproducer didn't give any hits in 2 runs of 50mins.
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
