Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE31309F38
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 23:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhAaW12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 17:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhAaWVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 17:21:38 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF265C06174A;
        Sun, 31 Jan 2021 14:20:56 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id df22so784039edb.1;
        Sun, 31 Jan 2021 14:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DHUUmMepH2teJF00B27CJvMsSr8ShoqZntH4j9eDohk=;
        b=SPtZ0mXppVAiASgxZ9VPs22urbjqMruMKM6c7WVxL4w7U44C2hRHzsPqx1Td8iOxDT
         1up/tUYCFxZVnY9qnyKxZzoHeI6SpegEmHD0e+DY0Ts8O0K5vD3cuNm8Q9Efd5D/YhNW
         hDc4yUrNGjYqYoeigXYeEznVn/snNZAM54PYuEyTNn6harTYZEPsg+wwss9YK0XKDSUM
         NYUWrN4mu+G8bVzTPu9f3152D/FRT0oyx11V/IsaLwQpyYYnwjgEZdBSUN5GWpRzIyJK
         CDtqR/h7J70Gh8+AEQf6Hr0tbBS63gG9Qp723SKWuOTqRJZ71pART65LkzdxmAtzvKtF
         6ZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DHUUmMepH2teJF00B27CJvMsSr8ShoqZntH4j9eDohk=;
        b=baRvqL3ncgtBH4gEUKf2cMxmo8lGje2va0DR5d+wPfiif4vYkJONTnuE5Prszvc4wK
         GDD3ZKRuYvR6RCrEt9oeetW/bjT4trcoI5t92jqiSr81rjevjqMGsWm0dSDHx9UBhwi/
         9Qlgg/Hh/eDwoQT2YYVePcJlbyZDJuNTVmsKWUyejV9qsGKcFKm7fysDI7FTG6yxA//4
         AeVzBvwazXZsBDqNlN3nJEdBufKHWg9i4KikulE6BwxaV+HrxLiWJWD/YNg8Xv9mip1J
         Lxlr/k07p+A3hh2ZRzsKCRe5Sa7WtKerQstH12RCSZtbYTlnMlDeqp7iUDiEJYOEFBDR
         ADOQ==
X-Gm-Message-State: AOAM533MVr+HV7sYG5MVMoDEttPgWsUFPeLs3lc2KPSt/4zAtJjx7QrP
        LsKYEJ2jK58LSnDqnCksX+o=
X-Google-Smtp-Source: ABdhPJxf7CLPIJBZSBEiHhiSxVCyrbX3/bOBnveY8+nIRQUt/LoweLkjmk/GEAS3+MbrqUbpZICfzA==
X-Received: by 2002:aa7:d399:: with SMTP id x25mr2179324edq.237.1612131655585;
        Sun, 31 Jan 2021 14:20:55 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z2sm7072566ejd.44.2021.01.31.14.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 14:20:54 -0800 (PST)
Date:   Mon, 1 Feb 2021 00:20:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: override existent unicast
 portvec in port_fdb_add
Message-ID: <CA+h21hrn6q8NAdma3Djov82sNzHTz_tF480Nqpw-A+JLv_TYcQ@mail.gmail.com>
X-TUID: ujGFqEzNl8hx
References: <20210130134334.10243-1-dqfext@gmail.com>
 <20210131003929.2rlr6pv5fu7vfldd@skbuf>
 <CALW65jYF5jpm+wQQ9yPZPa_gCSwr4gWiPZ35rBXiACmzCbABLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jYF5jpm+wQQ9yPZPa_gCSwr4gWiPZ35rBXiACmzCbABLA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 09:13:15AM +0800, DENG Qingfang wrote:
> This bug is exposed when I try your patch series on kernel 5.4
> https://lore.kernel.org/netdev/20210106095136.224739-1-olteanv@gmail.com/
> https://lore.kernel.org/netdev/20210116012515.3152-1-tobias@waldekranz.com/
>
> Without this patch, DSA will add a new port bit to the existing
> portvec when a client moves to the software part of a bridge. When it
> moves away, DSA will clear the port bit but the existing one will
> remain static. This results in connection issues when the client moves
> to a different port of the switch, and the kernel log below.
>
> mv88e6085 f1072004.mdio-mii:00: ATU member violation for
> xx:xx:xx:xx:xx:xx portvec dc00 spid 0

Ah, ok, DSA adds an FDB entry behind the user's back and it relies upon
the driver behavior being 'override'. A bit subtle, though it gives one
good reason against someone suggesting "why don't you just refuse adding
the new entry instead of overriding, like the software bridge does".
Probably the refusal of overwriting an entry is what needs to be handled
at upper layers, we do need to be able to override from DSA.
I had a quick look through our other drivers and it seems that all of
them are happy to override an existing FDB entry (or at least the
software part is).
