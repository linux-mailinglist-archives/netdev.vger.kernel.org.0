Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535C343A9FC
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJZB5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:57:34 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:42114 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhJZB5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 21:57:34 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 2EEEE20222;
        Tue, 26 Oct 2021 09:55:08 +0800 (AWST)
Message-ID: <f40cddba6f6fae5d3106da33a2968543d00d64e2.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v5] mctp: Implement extended addressing
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, matt@codeconstruct.com.au,
        esyr@redhat.com
Date:   Tue, 26 Oct 2021 09:55:08 +0800
In-Reply-To: <20211025.161549.899716517054473254.davem@davemloft.net>
References: <20211025032757.2317020-1-jk@codeconstruct.com.au>
         <20211025.161549.899716517054473254.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> putting a variably sized type in the skb control blocxk is not a good
> idea.  Overruns will be silent, nothing in the typing protects you
> from udsing more space han exists in skb->cb.

There is a check using MCTP_SKB_CB_HADDR_MAXLEN, but setting the size of
the struct member typing would allow for better enforcement, yes.

> Plrease find another way, thank you.

OK, we can use MAX_ADDR_LEN here; we currently have enough space in the
cb for the maximum possible addressing sizes (and can check that through
a BUILD_BUG_ON too).

v6 coming right up.

Cheers,


Jeremy

