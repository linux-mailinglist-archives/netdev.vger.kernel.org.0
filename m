Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1D0EA9B4
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 04:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfJaDgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 23:36:51 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:10296 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfJaDgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 23:36:51 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id x9V3aWbB030051;
        Thu, 31 Oct 2019 04:36:32 +0100
Date:   Thu, 31 Oct 2019 04:36:32 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Yue Cao <ycao009@ucr.edu>
Subject: Re: [PATCH net] net: increase SOMAXCONN to 4096
Message-ID: <20191031033632.GE29986@1wt.eu>
References: <20191030163620.140387-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030163620.140387-1-edumazet@google.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 09:36:20AM -0700, Eric Dumazet wrote:
> SOMAXCONN is /proc/sys/net/core/somaxconn default value.
> 
> It has been defined as 128 more than 20 years ago.
> 
> Since it caps the listen() backlog values, the very small value has
> caused numerous problems over the years, and many people had
> to raise it on their hosts after beeing hit by problems.
> 
> Google has been using 1024 for at least 15 years, and we increased
> this to 4096 after TCP listener rework has been completed, more than
> 4 years ago. We got no complain of this change breaking any
> legacy application.
> 
> Many applications indeed setup a TCP listener with listen(fd, -1);
> meaning they let the system select the backlog.
> 
> Raising SOMAXCONN lowers chance of the port being unavailable under
> even small SYNFLOOD attack, and reduces possibilities of side channel
> vulnerabilities.

Just a quick question, I remember that when somaxconn is greater than
tcp_max_syn_backlog, SYN cookies are never emitted, but I think it
recently changed and there's no such constraint anymore. Do you
confirm it's no more needed, or should we also increase this latter
one accordingly ?

Willy
