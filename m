Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB17C4F056A
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 20:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbiDBSmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 14:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiDBSmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 14:42:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784DD41F81
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 11:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gI7jz7qfkFrK6VH1luLM/2XurrzFb8cxh1FvlbASeb4=; b=GYkVqN1mjGxF2vCQMi/qZa2A2E
        vD7/qIEnBrTk72YmsWR1Et7wZE1QPBVj7hCt/4m9g8NdaxWDzqJWQsW+BFYyu9GHMd5CflN4qeJTm
        QMuT6AdOGyOjqKksXK80dSo+fqSJ/zPLLlNJ/fX0pdCzYgav0pyBZkDrZQG7qtIxXFyI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naifQ-00DrqQ-Rt; Sat, 02 Apr 2022 20:40:08 +0200
Date:   Sat, 2 Apr 2022 20:40:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ian Wienand <iwienand@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <YkiYiLK+zvwiS4t+@lunn.ch>
References: <20220401063430.1189533-1-iwienand@redhat.com>
 <Ykb6d3EvC2ZvRXMV@lunn.ch>
 <YkeVzFqjhh1CcSkf@fedora19.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkeVzFqjhh1CcSkf@fedora19.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > and we will get surprises when
> > interfaces which were not previously renamed now are? It would be nice
> > to see some justification this is actually safe to do.
> 
> I came to this through inconsistency of behaviour in a heterogeneous
> OpenStack cloud environment.  Most of the clouds are kvm-based and
> have NICS using virtio which fills in
> /sys/class/net/<interface>/name_assign_type and this bubbles up
> through udev/systemd/general magic to get the devices renamed.
> However we have one outlier using Xen and the xen-netfront driver,
> which I traced to here, where name_assign_type isn't set.

Hi Ian

So is there a risk here that Xen user suddenly find their network
interfaces renamed, where as before they were not, and their
networking thus breaks?

Consistency is good, but it is hard to do in retrospect when there are
deployed systems potentially dependent on the inconsistency.

	 Andrew

