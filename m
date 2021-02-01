Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E21230B1AE
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhBAUo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:44:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBAUo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 15:44:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CBF264ECA;
        Mon,  1 Feb 2021 20:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612212255;
        bh=dCMGiWWctaIt0m7maX4XXhdX80GIpTtiC2n8Laryxn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GSK0CKS73MEzRk3FUoqTkAFMnTd9JEN+c7ghfAmFmj1erGv/7UjMRxVBOHliQkxD6
         0ooAKFExdXw8bnWcSnUjSMTHQKc2jX+ZYxgB8Qn2J+WMuz5jKVTQwD918xVrSwy+8M
         JpRNqwz15rZF74Ls9TS3bIdm8vEZ+wSSXTOOXRoEN4qrhjzcOpMsSF4Ohq9t2UA0T8
         Jt9Rn4HIk59QpM2o0eR9aexs2IzXzwxTpiZAcx6v/66+6PX8XO/GiHKHkzz9gv39Kj
         LKbGdTQiVkxf4c4Q0ZgZ/0cdSbFGtMbEil5Fu0u/USL4FeL+9bHT+AbdOwhi5W7LAQ
         VkTO0C4e9/nHA==
Date:   Mon, 1 Feb 2021 12:44:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Jonas Bonn <jonas@norrbonn.se>,
        Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
Message-ID: <20210201124414.21466bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOrHB_DQTsEPEWpPVEcpSnbkLLz8eWPFvvzzO8wjuYsP4=9-QQ@mail.gmail.com>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
        <20210123195916.2765481-16-jonas@norrbonn.se>
        <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
        <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
        <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se>
        <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
        <20210130104450.00b7ab7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOrHB_DQTsEPEWpPVEcpSnbkLLz8eWPFvvzzO8wjuYsP4=9-QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 12:05:40 -0800 Pravin Shelar wrote:
> On Sat, Jan 30, 2021 at 10:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 29 Jan 2021 22:59:06 -0800 Pravin Shelar wrote:  
> > > On Fri, Jan 29, 2021 at 6:08 AM Jonas Bonn <jonas@norrbonn.se> wrote:  
> > > Following are the reasons for extracting the header and populating metadata.
> > > 1. That is the design used by other tunneling protocols
> > > implementations for handling optional headers. We need to have a
> > > consistent model across all tunnel devices for upper layers.  
> >
> > Could you clarify with some examples? This does not match intuition,
> > I must be missing something.
> 
> You can look at geneve_rx() or vxlan_rcv() that extracts optional
> headers in ip_tunnel_info opts.

Okay, I got confused what Jonas was inquiring about. I thought that the
extension headers were not pulled, rather than not parsed. Copying them
as-is to info->opts is right, thanks!
