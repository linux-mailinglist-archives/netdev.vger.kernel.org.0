Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9E69BF17
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 19:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfHXRz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 13:55:56 -0400
Received: from mail.nic.cz ([217.31.204.67]:41580 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfHXRz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 13:55:56 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 4F383140BDC;
        Sat, 24 Aug 2019 19:55:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566669354; bh=vy496kdmVSpFlOdGDFe1SRi6DZ+8X+0WzSVw/+yngq8=;
        h=Date:From:To;
        b=R2HKZyxdAI4VrqXl9F4FECS3uh0zmb8KcgOzwMmfmpWaA98nTn1mny4WcVsoEsxwN
         2d+/c3sgLoTm5BTcETptiHOIDhbxlVXBvLwtn8s1C5J/XEm9oVV+tkafD2lSDLiR9v
         WBcT/Kzsr6KIlwZYAccxRtYt5BMIS8kAp4LWfTE0=
Date:   Sat, 24 Aug 2019 19:55:53 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190824195553.71c88aa8@nic.cz>
In-Reply-To: <CA+h21ho=injFxAkm9AByk6An5EzQMOyGVkFA8eKUP-rgGFEW2Q@mail.gmail.com>
References: <20190824024251.4542-1-marek.behun@nic.cz>
        <CA+h21hpBKnueT0QrVDL=Hhcp9X0rnaPW8omxiegq4TkcQ18EVQ@mail.gmail.com>
        <CA+h21ho=injFxAkm9AByk6An5EzQMOyGVkFA8eKUP-rgGFEW2Q@mail.gmail.com>
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

On Sat, 24 Aug 2019 18:44:44 +0300
Vladimir Oltean <olteanv@gmail.com> wrote:

> Just to be clear. You can argue that such switches are weird, and
> that's ok. Just want to understand the general type of hardware for
> which such a patch is intended.

Vladimir,

the general part should solve for devices like Turris 1.x (qca8k) and
Turris Omnia (mv88e6xxx). In these devices the switch is connected to
CPU via 2 ports, and 5 ports are connected to RJ-45s.

I answered Andrew's question about the receive path in previous mail.
To your other question I still would have to think about, but the
general idea is that for other types of frames the switch driver
should only use one CPU port, so that no frame would reach CPU 2 times.

I shall send proposed implementation for mv88e6xxx in next version,
perhaps this night.

Marek
