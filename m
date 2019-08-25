Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D6B9C19D
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 06:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbfHYETz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 00:19:55 -0400
Received: from mail.nic.cz ([217.31.204.67]:44294 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfHYETz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 00:19:55 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id BD058140BBA;
        Sun, 25 Aug 2019 06:19:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566706793; bh=nwfskNTsFlPqIHv4geGWi1rMSdkiWStqexiTrco8ChI=;
        h=Date:From:To;
        b=cSk7ZgjAdq1bogjD7eQ4ivhrQttDu9dTu537HuiaGW9FnOIxCJtiZs3f0OFy52Wsz
         jC1Nd9EE3qv7uWkk1+xnP4nAU9XSetFe0N3T2ztwHe2jUsrl4ubtHFExS86dNxtOdu
         /udaOeZGTcDXKChgg+zAHCIYAPopie+nfn0Jeols=
Date:   Sun, 25 Aug 2019 06:19:53 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190825061953.6c5c43b7@nic.cz>
In-Reply-To: <20190824152407.GA8251@lunn.ch>
References: <20190824024251.4542-1-marek.behun@nic.cz>
        <20190824152407.GA8251@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Aug 2019 17:24:07 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> That is a new idea. Interesting.
> 
> I would like to look around and see what else uses this "lan1@eth0"
> concept. We need to ensure it is not counter intuitive in general,
> when you consider all possible users.

There are not many users of ndo_get_iflink besides DSA slave:
  ip6_gre, ip6_vti, sit, ip6_tunnel
  ip_gte, ip_vti, ipmr, ipip,
  macsec, macvlan, veth
  ipvlan
  ipoib
and a few other. What these have in common is that all these interfaces
are linked somehow to another interfacem, ie. a macvlan interface eth0.1
is linked to it's master interface eth0. All of these are virtual
interfaces.

Marek
