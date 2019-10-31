Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45463EACE9
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJaJ4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:56:47 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:10437 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbfJaJ4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 05:56:47 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id x9V4ZfqH030158;
        Thu, 31 Oct 2019 05:35:41 +0100
Date:   Thu, 31 Oct 2019 05:35:41 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Yue Cao <ycao009@ucr.edu>
Subject: Re: [PATCH net] net: increase SOMAXCONN to 4096
Message-ID: <20191031043541.GA30153@1wt.eu>
References: <20191030163620.140387-1-edumazet@google.com>
 <20191031033632.GE29986@1wt.eu>
 <CANn89i+8FOTfq328Tv4YvhcTEn9fte6Wm4YizqubcRz=0gyiwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+8FOTfq328Tv4YvhcTEn9fte6Wm4YizqubcRz=0gyiwQ@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 08:46:26PM -0700, Eric Dumazet wrote:
> On Wed, Oct 30, 2019 at 8:36 PM Willy Tarreau <w@1wt.eu> wrote:
> > Just a quick question, I remember that when somaxconn is greater than
> > tcp_max_syn_backlog, SYN cookies are never emitted, but I think it
> > recently changed and there's no such constraint anymore. Do you
> > confirm it's no more needed, or should we also increase this latter
> > one accordingly ?
> >
> 
> There is no relationship like that.
> 
> The only place somaxconn is use is in __sys_listen() to cap the
> user-provided backlog.
> 
> somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
> if ((unsigned int)backlog > somaxconn)
>        backlog = somaxconn;

OK, thanks for checking.

Willy
