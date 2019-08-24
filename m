Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0719BF0B
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 19:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfHXRps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 13:45:48 -0400
Received: from mail.nic.cz ([217.31.204.67]:41530 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfHXRps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 13:45:48 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id C8784140BBA;
        Sat, 24 Aug 2019 19:45:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566668747; bh=OWGRz1J1bHxrq8F2/RyMLv64CyNOHFet199bgwMGDiA=;
        h=Date:From:To;
        b=Tc/1cuIDejfChtlHH8mWsJoAM3aB8ur9Ne0+LutXvwzG42/oJUy7KLns7WLJHmAx4
         2AzNumhElzdTaPsbTAs1/R3M+YckBaxq8lYrEXMyAeFxzKeZLGc8KwsR5d8h5nBwzn
         W4Hr6BPP1RJ8Dc1MDHr7vmn2B/SthEJHmmWCnFjs=
Date:   Sat, 24 Aug 2019 19:45:46 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190824194546.5c436bd6@nic.cz>
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

> So this is all about transmit from the host out the switch. What about
> receive? How do you tell the switch which CPU interface it should use
> for a port?

Andrew, we use the same. The DSA slave implementation of ndo_set_iflink
will also tell the switch driver to change the CPU port for that port.
Patch 3 also adds operation port_change_cpu_port to the DSA switch
operations. This is called from dsa_slave_set_iflink (at least in this
first proposal).

Marek
