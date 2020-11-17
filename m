Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50692B6B80
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgKQRPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:15:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgKQRPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 12:15:38 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3037A24248;
        Tue, 17 Nov 2020 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605633337;
        bh=dbuus+7eRdLD6Zd9dYl9GIFN7d8GUvDD4GO94Wrry2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CCgm76HslLISsOLtX1P2PhzyxttXlFyg4+33TtM/o4oW9VDwZdqTCUWbaOuOG+1Fi
         OzDWYNimUrVIsBlRnxUdGulUhRv4lDfRBrNdH7CprCtVHNZphWFhA2wnCErFdOKNiI
         hAoq6brI0hbSajzZjUSMM+U1cvcJyFdK9tnLO89c=
Date:   Tue, 17 Nov 2020 09:15:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 4/4] selftests: add ring and coalesce
 selftests
Message-ID: <20201117091536.5e09ac13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117113236.yqgv3q5csgq3vwqr@yoda.fritz.box>
References: <20201113231655.139948-1-acardace@redhat.com>
        <20201113231655.139948-4-acardace@redhat.com>
        <20201116164503.7dcedcae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201117113236.yqgv3q5csgq3vwqr@yoda.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 12:32:36 +0100 Antonio Cardace wrote:
> On Mon, Nov 16, 2020 at 04:45:03PM -0800, Jakub Kicinski wrote:
> > On Sat, 14 Nov 2020 00:16:55 +0100 Antonio Cardace wrote:  
> > > Add scripts to test ring and coalesce settings
> > > of netdevsim.
> > > 
> > > Signed-off-by: Antonio Cardace <acardace@redhat.com>  
> >   
> > > @@ -0,0 +1,68 @@
> > > +#!/bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-only
> > > +
> > > +source ethtool-common.sh
> > > +
> > > +function get_value {
> > > +    local key=$1
> > > +
> > > +    echo $(ethtool -c $NSIM_NETDEV | \
> > > +        awk -F':' -v pattern="$key:" '$0 ~ pattern {gsub(/[ \t]/, "", $2); print $2}')
> > > +}
> > > +
> > > +if ! ethtool -h | grep -q coalesce; then
> > > +    echo "SKIP: No --coalesce support in ethtool"
> > > +    exit 4  
> > 
> > I think the skip exit code for selftests is 2  
> In the ethtool-pause.sh selftest the exit code is 4 (I copied it from
> there), should I change that too?

Sorry I misremembered it's 4. We can leave that as is.
