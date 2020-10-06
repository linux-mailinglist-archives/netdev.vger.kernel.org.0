Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431F7284E2C
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJFOmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgJFOmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 10:42:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4175206DD;
        Tue,  6 Oct 2020 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601995326;
        bh=hr0YWtmIdZlA3oclz3jyu0K3UZo9+NJh0+MqOqn7sCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CwONichLWXKZ5tDEoQQWTwbYrgCh+Lptz848YfpAIM61GXx/7gHSn/Bw0SmOYoxyP
         +5sFYqNk8c9/dnWiSbIO3afggmZ9hgHTH7iRhtgKdIIoyWXxUNz0xxKpPb5pTrOuJX
         2MUei7EQMYB2jRg4NtbL2Y2KboLFiIl6NwdLCcC8=
Date:   Tue, 6 Oct 2020 07:42:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, gerrit@erg.abdn.ac.uk, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: Re: [RESEND net-next 1/8] net: dccp: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20201006074204.2bd6fd32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006063201.294959-2-allen.lkml@gmail.com>
References: <20201006063201.294959-1-allen.lkml@gmail.com>
        <20201006063201.294959-2-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 12:01:54 +0530 Allen Pais wrote:
> --- a/net/dccp/timer.c
> +++ b/net/dccp/timer.c
> @@ -219,9 +219,10 @@ static void dccp_delack_timer(struct timer_list *t)
>   *
>   * See the comments above %ccid_dequeueing_decision for supported modes.
>   */
> -static void dccp_write_xmitlet(unsigned long data)
> +static void dccp_write_xmitlet(struct tasklet_struct *t)

net/dccp/timer.c:223: warning: Function parameter or member 't' not described in 'dccp_write_xmitlet'
net/dccp/timer.c:223: warning: Excess function parameter 'data' description in 'dccp_write_xmitlet'
