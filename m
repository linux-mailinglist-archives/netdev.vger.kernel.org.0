Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E32453BB3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhKPVhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhKPVhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 16:37:08 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2655861263;
        Tue, 16 Nov 2021 21:34:10 +0000 (UTC)
Date:   Tue, 16 Nov 2021 16:34:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, davem@davemloft.net, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: snmp: add tracepoint support for snmp
Message-ID: <20211116163407.7e0c6129@gandalf.local.home>
In-Reply-To: <20211111133530.2156478-2-imagedong@tencent.com>
References: <20211111133530.2156478-1-imagedong@tencent.com>
        <20211111133530.2156478-2-imagedong@tencent.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 21:35:29 +0800
menglong8.dong@gmail.com wrote:

> +#define DEFINE_SNMP_EVENT(proto)				\
> +DEFINE_EVENT(snmp_template, snmp_##proto,			\
> +	TP_PROTO(struct sk_buff *skb, int field, int val),	\
> +	TP_ARGS(skb, field, val)				\
> +)
> +
> +#define TRACE_SNMP(skb, proto, field, val) \
> +	trace_snmp_##proto(skb, field, val)
> +
> +#endif

Why make a separate trace event for each protocol, and not just create an
enum that gets passed to the trace event? Then you could just filter on
what you want.

-- Steve
