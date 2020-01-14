Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B426513A86F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgANLb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:31:57 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50054 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgANLb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:31:56 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1irKQK-00054u-6S; Tue, 14 Jan 2020 12:31:52 +0100
Date:   Tue, 14 Jan 2020 12:31:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [net,v2] netfilter: nat: fix ICMP header corruption on ICMP
 errors
Message-ID: <20200114113152.GN795@breakpoint.cc>
References: <20200114080350.4693-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114080350.4693-1-eyal.birger@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eyal Birger <eyal.birger@gmail.com> wrote:
> Commit 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
> made nf_nat_icmp_reply_translation() use icmp_manip_pkt() as the l4
> manipulation function for the outer packet on ICMP errors.
> 
> However, icmp_manip_pkt() assumes the packet has an 'id' field which
> is not correct for all types of ICMP messages.
> 
> This is not correct for ICMP error packets, and leads to bogus bytes
> being written the ICMP header, which can be wrongfully regarded as
> 'length' bytes by RFC 4884 compliant receivers.
> 
> Fix by assigning the 'id' field only for ICMP messages that have this
> semantic.

Looks good, thanks Eyal.

Acked-by: Florian Westphal <fw@strlen.de>
