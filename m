Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8094040DCF6
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbhIPOkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236152AbhIPOkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B0B16120C;
        Thu, 16 Sep 2021 14:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631803127;
        bh=VizvyrKA/9G+ItaOY/JY1TvKtQ6RYDHfj7esRMFMBEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KrTIiPJhTAtfCx/XLWrZwg1PkKsxc0I0pfi6RduJEvRxRUnLknsOowkEottopLauQ
         bAXfz2xCbNJIHTV+liX94Uyd25Hk4NDafKrKhNJh6J0zJtDrGMLFepx/Eh2DvqopkP
         K3UuOhrBW1BHVFedY+YGanzFoXLwzPr9y026vqJ4mVpXQnXFUhS9m6VprJTLR5R5Fe
         EiaQXFC63aNSU+OYV/S0iW7YUlOTCZFXy0rbmBZG61tIzgnPMOz85W0wwCF1C8YuxQ
         ccbwk7DJhn0ZfsKyP7db8/bJ6IhNohovdblszG6Zsz5j1fULaljcpRXpkZlWmJkkZ4
         zk9kV9Y8amo2w==
Date:   Thu, 16 Sep 2021 07:38:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     pshelar@ovn.org, davem@davemloft.net, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Fix condition check by using nla_ok()
Message-ID: <20210916073846.31b43b2a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916073640.7e87718a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1631756603-3706451-1-git-send-email-jiasheng@iscas.ac.cn>
        <20210916073640.7e87718a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 07:36:40 -0700 Jakub Kicinski wrote:
> On Thu, 16 Sep 2021 01:43:23 +0000 Jiasheng Jiang wrote:
> > Just using 'rem > 0' might be unsafe, so it's better
> > to use the nla_ok() instead.
> > Because we can see from the nla_next() that
> > '*remaining' might be smaller than 'totlen'. And nla_ok()
> > will avoid it happening.
> > 
> > Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>  
> 
> Are the attributes coming from the user space here or are generated 
> by the kernel / were already validated?  Depending on that this is
> either a fix and needs to be backported or a possible cleanup.
> 
> Please repost with the explanation where attrs come from in the commit
> message, and if it's indeed a bug please add a Fixes tag.

And please use different subject for each patch, otherwise patchwork
bot thinks this is just two versions of the same patch and marks the 
one posted earlier as Superseded.

> If we do need the nla_ok() we should probably also switch to
> nla_for_each_attr() and nla_for_each_nested().

