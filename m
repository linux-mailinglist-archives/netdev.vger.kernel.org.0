Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B9659CBA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfF1NOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:14:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfF1NOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 09:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lwS9Zf2XPQpqm57b4LSqoXQuGRkzIyhDmhyObwfZdkI=; b=GxqjYj4AlmDpLT3vH31HAhZMIM
        H76Ib9Y0fU3f5tder19+vxWV6bhu1ztC8tkxYNFWxRx/N1kWEDljoSXZGXPlFN+Rcx45z1Y9m0Ta1
        6hB743BpIy5XC3T/i2JbhAGJ2yTHjiCGr6uu7+g3iTDLaIfQgFVCrPdrD2AIta5dn1LY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgqhV-0007RK-J6; Fri, 28 Jun 2019 15:14:01 +0200
Date:   Fri, 28 Jun 2019 15:14:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628131401.GA27820@lunn.ch>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
 <20190627183948.GK27240@unicorn.suse.cz>
 <20190627122041.18c46daf@hermes.lan>
 <20190628111216.GA2568@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628111216.GA2568@nanopsycho>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 01:12:16PM +0200, Jiri Pirko wrote:
> Thu, Jun 27, 2019 at 09:20:41PM CEST, stephen@networkplumber.org wrote:
> >On Thu, 27 Jun 2019 20:39:48 +0200
> >Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> >> > 
> >> > $ ip li set dev enp3s0 alias "Onboard Ethernet"
> >> > # ip link show "Onboard Ethernet"
> >> > Device "Onboard Ethernet" does not exist.
> >> > 
> >> > So it does not really appear to be an alias, it is a label. To be
> >> > truly useful, it needs to be more than a label, it needs to be a real
> >> > alias which you can use.  
> >> 
> >> That's exactly what I meant: to be really useful, one should be able to
> >> use the alias(es) for setting device options, for adding routes, in
> >> netfilter rules etc.
> >> 
> >> Michal
> >
> >The kernel doesn't enforce uniqueness of alias.
> >Also current kernel RTM_GETLINK doesn't do filter by alias (easily fixed).
> >
> >If it did, then handling it in iproute would be something like:
> 
> I think that it is desired for kernel to work with "real alias" as a
> handle. Userspace could either pass ifindex, IFLA_NAME or "real alias".
> Userspace mapping like you did here might be perhaps okay for iproute2,
> but I think that we need something and easy to use for all.
> 
> Let's call it "altname". Get would return:
> 
> IFLA_NAME  eth0
> IFLA_ALT_NAME_LIST
>    IFLA_ALT_NAME  eth0
>    IFLA_ALT_NAME  somethingelse
>    IFLA_ALT_NAME  somenamethatisreallylong

Hi Jiri

What is your user case for having multiple IFLA_ALT_NAME for the same
IFLA_NAME?

	Thanks
		Andrew
 
