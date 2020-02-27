Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDCB1724CC
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgB0RQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728413AbgB0RQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 12:16:41 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590FA2469B;
        Thu, 27 Feb 2020 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582823800;
        bh=HZ8JA798jZ3ZkxMdLKYoSksXBTJ+5w5059x5kmCyyXg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bJ3umOcm6DzWHJOznuW0Ph/ofqL6tZ7qMW4FruIl1DSQ2QvUuP3ZaqZaJp1WBELYH
         XobPjsrZZXcI8HeJGFX8bp+VmiKKnILDJfh/EQJ2GbCF1iEWNMqEM8Kvuj9qaRrDkA
         3exAn1dIEAp9NgcNa7SDw0bdPrDbqE9ewxOfU/+8=
Date:   Thu, 27 Feb 2020 09:16:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200227091637.1822b9ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200227030914-mutt-send-email-mst@kernel.org>
References: <20200226093330.GA711395@redhat.com>
        <87lfopznfe.fsf@toke.dk>
        <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
        <20200226115258-mutt-send-email-mst@kernel.org>
        <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com>
        <20200226120142-mutt-send-email-mst@kernel.org>
        <20200226173751.0b078185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200227030914-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 03:14:20 -0500 Michael S. Tsirkin wrote:
> On Wed, Feb 26, 2020 at 05:37:51PM -0800, Jakub Kicinski wrote:
> > On Wed, 26 Feb 2020 12:02:03 -0500 Michael S. Tsirkin wrote:  
> > I'd vote that we don't care. We should care more about consistency
> > across drivers than committing to buggy behavior.
> > 
> > All drivers should have this check (intel, mlx, nfp definitely do),
> > I had a look at Broadcom and it seems to be missing there as well :(
> > Qlogic also. Ugh.  
> 
> Any chance to put it in net core then? Seems straight-forward enough ...

It's not impossible, but generally the RX buf geometry requirements
are not universal (see ixgbe or nfp).
