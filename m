Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D841A3DA48B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbhG2NnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:43:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237427AbhG2Nm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 09:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uIUIB4Rnjiqq7j6EfanH/JGy981SUl0O7aZKRGkrbgo=; b=5XhK5RD51utbGiPQpHgIin/ccm
        sjCqVYvqVIoXa5nk53HKRUUFN1cen26Y15uoV9qzjEwkzbOCwGq9RvBP4okFbob1KvKJXJdrooJ50
        QytB0UogEtLZ6rbepWAszxARQO70tM+9xrC7qkVOrgGtY92KURfZinoZPS8gD2nlBHu8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m96JK-00FJm9-Up; Thu, 29 Jul 2021 15:42:54 +0200
Date:   Thu, 29 Jul 2021 15:42:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: net: dsa: mv88e6xxx: no multicasts rx'd after enabling hw time
 stamping
Message-ID: <YQKwXj8v+NFQs4dw@lunn.ch>
References: <CAFSKS=Pv4qjfikHcvyycneAkQWTXQkKS_0oEVQ3JyE5UL6H=MQ@mail.gmail.com>
 <YQHGe6Rv9T4+E3AG@lunn.ch>
 <20210728222457.GA10360@hoboy.vegasvil.org>
 <CAFSKS=OtAgLCo0MLe8CORUgkapZLRbe6hRiKU7QWSd5a70wgrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=OtAgLCo0MLe8CORUgkapZLRbe6hRiKU7QWSd5a70wgrw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for the feedback. The datasheet covers the 88E6390X, 88E6390,
> 88E6290, 88E6190X, 88E6190 so I expect those work similarly but if
> only the 6352 has been tested that could explain it. It certainly
> helps to know that I'm working with something that may have never
> worked rather than I'm just doing something dumb.

I don't think you are doing something dumb.

What i find interesting is that multicast works, until it does not
work. I would try to find out what call into the driver causes that
change.

Also, general multicast traffic should not really be involved
here. The switch should be identifying PTP packets as management, and
sending them to the CPU port, independent of whatever multicast rules
are set, flooding of unknown multicast etc. This is needed so that PTP
frames get through a bridge which is in STP blocking mode. Do you see
any other problems with management traffic? Do bridge PDUs also not
work?

	Andrew
