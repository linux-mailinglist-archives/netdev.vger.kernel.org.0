Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D34935A64F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhDISzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234378AbhDISzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 541B761106;
        Fri,  9 Apr 2021 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617994496;
        bh=ouck/WHZICUo1yLkev6qy2hNxhkdP8XeCRvmC3aKYK4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ofVqcwhRHkGd8kBSO1PMKUeTCMXVY0sVAe3hvZPMADYOLLmrWPmzs+v7qYiHuBjVr
         GZxLKhsg43OQyVqnNfEUncqN2Y98qOOv6OVJCGNhj8YFAkl81pKiRGQVTIK6K9Ij0L
         wV75itDdBZntcSVoTi17jmK6e4KJTZS7g0yk6eHmUgwTd3mYA+XmyXXOO6kKdJ2COo
         3rauNieaaTOCIZ/HXaATv4Om0POQ6MBJgwV8DnAcd2v8MVZkMC0K2x9OHbEL72S9Sl
         ruHIKkzlaBsJ1DkTI6zSou7zgpxXUMlsHjlwUtHMvUf8uuIuUwGZ0vdeuaiesfqc3V
         vUusawo+84bfw==
Date:   Fri, 9 Apr 2021 11:54:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH net-next 2/3] net: use skb_for_each_frag() helper where
 possible
Message-ID: <20210409115455.49e24450@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409180605.78599-3-mcroce@linux.microsoft.com>
References: <20210409180605.78599-1-mcroce@linux.microsoft.com>
        <20210409180605.78599-3-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Apr 2021 20:06:04 +0200 Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> use the new helper macro skb_for_each_frag() which allows to iterate
> through all the SKB fragments.
> 
> The patch was created with Coccinelle, this was the semantic patch:

Bunch of set but not used warnings here. Please make sure the code
builds cleanly allmodconfig, W=1 C=1 before posting.

What pops to mind (although quite nit picky) is the question if the
assembly changes much between driver which used to cache nr_frags and
now always going skb_shinfo(skb)->nr_frags? It's a relatively common
pattern.
