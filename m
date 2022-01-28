Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8530749FDD8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350003AbiA1QSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbiA1QSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:18:24 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0853AC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:18:24 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id q22so9737079ljh.7
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=0mq6FNkSSKtuqZab08gi+SvT/s3+4SPKOw9723AF+Jg=;
        b=Nux7G9oTp8iWLeEFRm+K5vR4OhMi1J+9JexEUt8PfioMo36/9H9XZd45lx5jJzbu8H
         Jr+OEa0L2MdwqYEezztUdSmhhWVqR5mBpaKXv/qj99yPvMQoOkHLPRtLPvXt5AXVKl9s
         Av1DmLKP74YLWUyEhv7VXjvKI7hkW1VWwaY4RjbBnHazMDOkenKyE1aTX+3BfZmLL+6j
         AjEDMjv2eZvyEt8a4ZWZ9PV38+Ybywboye0JjoKMs/4e4lbLdYiBfGRn48Kvv2+8PcSd
         ubqU7uFj5NCUGbxpZOMzKtn058A8gLWosgMtUCtm2O9H41TXop5qwhXavhHvjcdrep6D
         JIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0mq6FNkSSKtuqZab08gi+SvT/s3+4SPKOw9723AF+Jg=;
        b=SAXp2MMh0yRQM4ucV5EmvDHOHWXS9o/MLBZGs45FDf19J53CEmzEs2FApVAPORLYGv
         nQPUPZ3owFnmdaWdK0d5yu5cTx8L9yZyNDdPA+c9BgDfSk0MWOxgAN6G6oV1YT/0x8mL
         74RTt91KcFabg2K+97gzbVB37osoULyvcvarhLnI5ovX6ZD4Qj9dku2b+6ZH9QStk58S
         HgxVcvpzH+pdp1IY166IOxBgRkNT3W8DeXR7I222TU9+xQU1n36ne3/VNaUnv6B7o7bt
         9A94mpg8rWPDJgCHYnxp4d4I0Ts4wDV9b1y1nIWT7ylIwU1ODOQhzEMqTFE1dJVby7ua
         4uVA==
X-Gm-Message-State: AOAM531ZUU0raIwtfGEJuv2Ln3nGyp9M/tzFnoS/Cmjq9zIxSW3wha8W
        kXR58Z6EIck42Sr1gpq8q4AL53ETH5gJ8A==
X-Google-Smtp-Source: ABdhPJzA6984rVQ0tLBwnINziJmnIqLGHq/QixHDz35JueXv5vx/k+lmlLSVaMRIMtQ9GTbk5HX9LQ==
X-Received: by 2002:a05:651c:4d1:: with SMTP id e17mr6310951lji.441.1643386702127;
        Fri, 28 Jan 2022 08:18:22 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id k4sm1455483lfr.102.2022.01.28.08.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 08:18:21 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
In-Reply-To: <YfQVg4mYYT9iop3x@lunn.ch>
References: <20220128104938.2211441-1-tobias@waldekranz.com>
 <c3bc08f82f1c435ca6fd47e30eb65405@AcuMS.aculab.com>
 <87k0ejc0ol.fsf@waldekranz.com> <YfQVg4mYYT9iop3x@lunn.ch>
Date:   Fri, 28 Jan 2022 17:18:21 +0100
Message-ID: <87h79nbzqq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 17:10, Andrew Lunn <andrew@lunn.ch> wrote:
> On Fri, Jan 28, 2022 at 04:58:02PM +0100, Tobias Waldekranz wrote:
>> On Fri, Jan 28, 2022 at 14:10, David Laight <David.Laight@ACULAB.COM> wrote:
>> > From: Tobias Waldekranz
>> >> Sent: 28 January 2022 10:50
>> >> 
>> >> The individual patches have all the details. This work was triggered
>> >> by recent work on a platform that took 16s (sic) to load the mv88e6xxx
>> >> module.
>> >> 
>> >> The first patch gets rid of most of that time by replacing a very long
>> >> delay with a tighter poll loop to wait for the busy bit to clear.
>> >> 
>> >> The second patch shaves off some more time by avoiding redundant
>> >> busy-bit-checks, saving 1 out of 4 MDIO operations for every register
>> >> read/write in the optimal case.
>> >
>> > I don't think you should fast-poll for the entire timeout period.
>> > Much better to drop to a usleep_range() after the first 2 (or 3)
>> > reads fail.
>> 
>> You could, I suppose. Andrew, do you want a v3?
>
> You have i available, so it would be a simple change. So yes please.

Alright, v3 coming up.

> But saying that, it seems like if the switch does not complete within
> 2 polls, it is likely to be dead and we are about to start a cascade
> of failures. We probably don't care about a bit of CPU usage when the
> devices purpose in being has just stopped working.

Yeah, that's pretty much where my mind went as well.
