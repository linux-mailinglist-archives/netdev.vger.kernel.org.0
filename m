Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5C62CF79D
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 00:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgLDXiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgLDXiP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 18:38:15 -0500
Date:   Fri, 4 Dec 2020 15:37:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607125069;
        bh=2zKZF4aBpwhb+MmtpLHvGpRxVERUBzuV++3Ec2ByJz0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=kb22OmZVcuJaafxCVfJjopqrZSRaagiCR2ngoJ+jFkmnqZYUTcYBbndIOrUJNidZI
         an3QG8OTvFzsUz4vbKz6hmtOlsUag6lM+JDdMOU6CR9f6055cieiS7f3QnLy9PdZjB
         bp/ay3CO0rf3z6eePzcK+tMn5DT8U0si6Xoz9eFg2zZlvNnmVCuENJL+dBfZ7XUEQ3
         iiktlXZLoJAjoZ3VWEnpJ8F5MziT9coblJPxbwZ9coK2rsmuBlhTQuQxyjLeUR1Dbe
         wopoKgkQ/9m8Oldjkey9iWae7n9mtGEGosZFWUOd+/csz72dsMTaCMffJlyv/kE1km
         7a+VX+PTF1/Fw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] vrf: packets with lladdr src needs dst at input
 with orig_iif when needs strict
Message-ID: <20201204153748.00715355@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <6199335a-c50f-6f04-48e2-e71129372a35@gmail.com>
References: <20201204030604.18828-1-ssuryaextr@gmail.com>
        <6199335a-c50f-6f04-48e2-e71129372a35@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 09:32:04 -0700 David Ahern wrote:
> On 12/3/20 8:06 PM, Stephen Suryaputra wrote:
> > Depending on the order of the routes to fe80::/64 are installed on the
> > VRF table, the NS for the source link-local address of the originator
> > might be sent to the wrong interface.
> > 
> > This patch ensures that packets with link-local addr source is doing a
> > lookup with the orig_iif when the destination addr indicates that it
> > is strict.
> > 
> > Add the reproducer as a use case in self test script fcnal-test.sh.
> > 
> > Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> > ---
> >  drivers/net/vrf.c                         | 10 ++-
> >  tools/testing/selftests/net/fcnal-test.sh | 95 +++++++++++++++++++++++
> >  2 files changed, 103 insertions(+), 2 deletions(-)
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Should I put something like:

Fixes: b4869aa2f881 ("net: vrf: ipv6 support for local traffic to local addresses")

on this?
