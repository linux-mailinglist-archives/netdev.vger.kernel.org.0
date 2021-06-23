Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF3F3B1E71
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhFWQRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWQRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 12:17:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3242B60233;
        Wed, 23 Jun 2021 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624464904;
        bh=3VryKsqlmKhcKdkqnVgECqS0dNxg8oTKj2aBgAbdXMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ULHQVAQxYgzXNQUz++8+On/dL/vR8gwghJjptSzlaa5yeh8OH72xzSUmruQgs0iU/
         RGuhCGHbY+xHbZe9TszC7Q84JoD/edvaLjTDKeOgmh7xJp3brjdERN12jUraPIvD+n
         jIhLs0isjuJv/g66VMTxD6q0i92JI0tjDZsa9v1PHI9yOvHMVEzImmmcWcNLXxXF+U
         GpQNtPtm0XzDVW+o5ETvlzuePl4Qi0Bbui4aZoCMnY3gijzJKbpVBeBKUisAQAkbIK
         OPXKUvCD08wHEUWC8ONT719LfWAheyC/DnCUxkRYbwCcaNxYE92DHQXaGc00CBNzWK
         9YZpXhu0t+7eQ==
Date:   Wed, 23 Jun 2021 09:14:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, vfedorenko@novek.ru
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
Message-ID: <20210623091458.40fb59c6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <592a8a33-dfb8-c67f-c9e6-0e1bab37b00d@gmail.com>
References: <20210622015254.1967716-1-kuba@kernel.org>
        <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
        <20210622152451.7847bc24@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <592a8a33-dfb8-c67f-c9e6-0e1bab37b00d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 21:47:45 -0600 David Ahern wrote:
> On 6/22/21 4:24 PM, Jakub Kicinski wrote:
> >> would be good to capture the GRE use case that found the bug and the
> >> MPLS version as test cases under tools/testing/selftests/net. Both
> >> should be doable using namespaces.  
> > 
> > I believe Vadim is working on MPLS side, how does this look for GRE?
> 
> I like the template you followed. :-)

:)

> The test case looks good to me, thanks for doing it.

Noob question, why do we need that 2 sec wait with IPv6 sometimes?
I've seen it randomly in my local testing as well I wasn't sure if 
it's a bug or expected.

I make a v6 tunnel on top of a VLAN and for 2 secs after creation 
I get the wrong route in ip -6 r g.
