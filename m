Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C719F2AC58A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgKITzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:55:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729875AbgKITy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 14:54:59 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3C68206B6;
        Mon,  9 Nov 2020 19:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604951699;
        bh=3DQnkztrKW1zx9YcvhGwfo7Fv62Zj+juWFROusHsk7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SmzVD/l0WaoneEBy0JrxPyfsquhi/mXO2UKVmhyA2YYgYtD3REaWCk1ZOXlGzWLGN
         T5wGSQp5cKiwzDemv/tjcIXrBY8IBa+pViWERW9C7iy7zi74Ck3NIEDhyydc0oW0Jw
         P1TbHcrPPVooTg1g6Z2sMlup5hw+9N14nsMTv2zk=
Date:   Mon, 9 Nov 2020 11:54:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     nusiddiq@redhat.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp
 flag - BE_LIBERAL per-ct basis.
Message-ID: <20201109115458.0590541b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109072930.14048-1-nusiddiq@redhat.com>
References: <20201109072930.14048-1-nusiddiq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 12:59:30 +0530 nusiddiq@redhat.com wrote:
> From: Numan Siddique <nusiddiq@redhat.com>
> 
> Before calling nf_conntrack_in(), caller can set this flag in the
> connection template for a tcp packet and any errors in the
> tcp_in_window() will be ignored.
> 
> A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
> sets this flag for both the directions of the nf_conn.
> 
> openvswitch makes use of this feature so that any out of window tcp
> packets are not marked invalid. Prior to this there was no easy way
> to distinguish if conntracked packet is marked invalid because of
> tcp_in_window() check error or because it doesn't belong to an
> existing connection.
> 
> An earlier attempt (see the link) tried to solve this problem for
> openvswitch in a different way. Florian Westphal instead suggested
> to be liberal in openvswitch for tcp packets.
> 
> Link: https://patchwork.ozlabs.org/project/netdev/patch/20201006083355.121018-1-nusiddiq@redhat.com/
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Numan Siddique <nusiddiq@redhat.com>

Please repost Ccing Pablo & netfilter-devel.
