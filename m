Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCFC4D9EC
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfFTTCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbfFTTCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:02:39 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A39581124;
        Thu, 20 Jun 2019 19:02:34 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E30F1001DF6;
        Thu, 20 Jun 2019 19:02:30 +0000 (UTC)
Date:   Thu, 20 Jun 2019 21:02:26 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 08/11] ipv6: Dump route exceptions if
 requested
Message-ID: <20190620210226.724c2893@redhat.com>
In-Reply-To: <26efcecf-5a96-330b-c315-5d9750c99766@gmail.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
        <13c143591fe786dc452ec6c99b8ff1414ef8929d.1560987611.git.sbrivio@redhat.com>
        <26efcecf-5a96-330b-c315-5d9750c99766@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 20 Jun 2019 19:02:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 08:24:22 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/19/19 5:59 PM, Stefano Brivio wrote:
> > +	if (filter->dump_exceptions) {
> > +		struct fib6_nh_exception_dump_walker w = { .dump = arg,
> > +							   .rt = rt,
> > +							   .flags = flags,
> > +							   .skip = skip,
> > +							   .count = 0 };
> > +		int err;
> > +
> > +		if (rt->nh) {
> > +			err = nexthop_for_each_fib6_nh(rt->nh,
> > +						       rt6_nh_dump_exceptions,
> > +						       &w);  
> 
> much like ipv4, the skb can fill in the middle of a fib6_nh bucket, so
> you need to track which nexthop is in progress.

Same as my comment about IPv4, except that, for IPv6, distinction
between skip and skip_in_node is strictly needed, but buckets and
nexthops are traversed in the same order and 'sernum' changes don't
affect that.

-- 
Stefano
