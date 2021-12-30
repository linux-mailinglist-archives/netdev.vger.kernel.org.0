Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4012C481F5C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241755AbhL3TCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:02:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240323AbhL3TCp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 14:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sJR4W94MNfg89p/kJmhJCDL5Vi3LDfqZy4Tblm8nfMA=; b=NhqqV/hPBHNQxqM4lSo/fW4cAA
        wGtupKog9T/wZjR7FSvZEhvz/jz+EKmjM/1+DcEHgJndBqMTG2FyHAjXq3/CmTrf8eCtL4EUT5oB8
        J9To/q/NSKctCPJTdPHnmFVPnAq5k52Y4Au1+AATMl9UQs1kvkKxaqGSiTZ0ple+5hv8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n30hG-000BUp-CN; Thu, 30 Dec 2021 20:02:42 +0100
Date:   Thu, 30 Dec 2021 20:02:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/8] net/funeth: probing and netdev ops
Message-ID: <Yc4CUp9T/p69m7k8@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-4-dmichail@fungible.com>
 <Yc3vDQ0cFE6vm0Ul@lunn.ch>
 <CAOkoqZ=ba_QiOdKbN==LU7gKCNSSfAbq29UJBPKB8MvX5sMJPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOkoqZ=ba_QiOdKbN==LU7gKCNSSfAbq29UJBPKB8MvX5sMJPQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 10:33:03AM -0800, Dimitris Michailidis wrote:
> On Thu, Dec 30, 2021 at 9:40 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +static int msg_enable;
> > > +module_param(msg_enable, int, 0644);
> > > +MODULE_PARM_DESC(msg_enable, "bitmap of NETIF_MSG_* enables");
> > > +
> >
> > Module params are not liked. Please implement the ethtool op, if you
> > have not already done so.
> 
> The associated ethtool op is implemented. I think this module param is
> fairly common
> to control messages during probe and generally before the ethtool path
> is available.

It is common in order drivers, but in general new drivers don't have
module parameters at all. Anybody debugging code before ethtool is
available from user space is probably also capable of recompiling the
driver to change the default value.

       Andrew
