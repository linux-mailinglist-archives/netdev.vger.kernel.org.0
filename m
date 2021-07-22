Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85AE3D2233
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 12:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhGVKA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhGVKAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 06:00:55 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CD2C061575;
        Thu, 22 Jul 2021 03:41:29 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m2so5425104wrq.2;
        Thu, 22 Jul 2021 03:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:in-reply-to:references:reply-to:date:message-id
         :mime-version;
        bh=hjjYYUQIehI9VeBc6wX+U/RUbbsWqT6Tuj+xVmXLLJs=;
        b=pZWFd3ySNfxCmZ3C+m26RZYye81+LV1ZUBwjPTqMES8A6B3CRDREpZYhJcslazcRMk
         nUmr3IKcjc9XK5dgcHgkWU8xjbyjsTDMwTwSiaR3ahg7T0WSqevXUuaoGsSYSHh3nww8
         eO7ueQSWnhY/HfTgK/lDhp5dQHREk5qP/YeFR1NzY5BiA5mLCf1TOi/EjWKkzIB2rExZ
         XMGBSx2NpZls/tdYvneNNmJivwo7ZMxYZyov+ww7zwVOLojukulUl88x8pm/TVEXdl4Z
         izNU+KS6E/yYMsTgfwrHnc3i3FYYGx5UvU2YjGMWP4+0tds6QCU55K3+gvLmsAoVekf9
         oEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :reply-to:date:message-id:mime-version;
        bh=hjjYYUQIehI9VeBc6wX+U/RUbbsWqT6Tuj+xVmXLLJs=;
        b=VGXA8JrpF2AhBTHOsBXGclcEmkoklNJDON7ORbauALG0X0WxGufB5hoUyEmR+t9qFd
         CHuQ06Syc/omz+7Z4U5gEyIkyHXtlfZRg5IzLSyCiXwKI4Q1V5R1rD7L26nGSMf9iVL3
         UTdZFjyq/M3WB9hQBqlwvDTuDCvKE0jCJE478oYUQgeYx0XHiF5uqe/Cqkniv7CBK230
         hBKYbHX3QU/3Ehcj6PnEx8M1QiOLw3hlcMNISszT74Mx8UjWPZHvqavM+RBDjlQ7rDJF
         G1PBUT8mSFysmVoJ1eJUkBPvl7hZeQtA996mCm2GFezIqKfftc9+6USRwq4tcJScFYyz
         YXSw==
X-Gm-Message-State: AOAM530UsyYT+ZjNfDDofYRZCheml5gRcVYseRbf4GZrqcOsvd0K7Na/
        U00nEORIzxvwmjYvI2fXJwms58tMw7I=
X-Google-Smtp-Source: ABdhPJxmaCmpUOwaVK871lfudvLQYt/t+rKOG7aNEws5RQvVNrtZscqyvC0oroI8FXpKHs83KuwkuQ==
X-Received: by 2002:a5d:59ab:: with SMTP id p11mr29856058wrr.74.1626950488555;
        Thu, 22 Jul 2021 03:41:28 -0700 (PDT)
Received: from jvdspc.jvds.net ([212.129.84.103])
        by smtp.gmail.com with ESMTPSA id p9sm28709072wrx.59.2021.07.22.03.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 03:41:27 -0700 (PDT)
Received: from jvdspc.jvds.net (localhost [127.0.0.1])
        by jvdspc.jvds.net (8.16.1/8.15.2) with ESMTPS id 16MAfQgf019600
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 11:41:26 +0100
Received: (from jvd@localhost)
        by jvdspc.jvds.net (8.16.1/8.16.1/Submit) id 16MAfOKU019599;
        Thu, 22 Jul 2021 11:41:24 +0100
X-Authentication-Warning: jvdspc.jvds.net: jvd set sender to jason.vas.dias@gmail.com using -f
From:   "Jason Vas Dias" <jason.vas.dias@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     linux-kernel@vger.kernel.org, linux-8086@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: /proc/net/{udp,tcp}{,6} : ip address format : RFC : need for
 /proc/net/{udp,tcp}{,6}{{n,h},{le,be}} ?
In-Reply-To: <hhlf60vmj6.fsf@jvdspc.jvds.net>
References: <hhlf60vmj6.fsf@jvdspc.jvds.net>
Reply-To: "Jason Vas Dias" <jason.vas.dias@gmail.com>
Date:   Thu, 22 Jul 2021 11:41:24 +0100
Message-ID: <hhwnpir5pn.fsf@jvdspc.jvds.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


RE: On 20 July 2021 at 23:41, Stephen Hemminger wrote:
>> So, yes what you say makes sense but that was not how the early
>> prehistoric (2.4 or earlier) versions of Linux decided to output addresses
>> and it can never change.

I don't like those words: "it can never change" !:-)

How about either or both Options B & C under sysfs then?

ie. something like /sys/class/net/{udp,tcp}{,6,n,h,ip,bin}
    6: ipv6
 [optionally:
  [ n: hex, network byte order
    h: hex, host byte order
   ip: ipv4 ascii dotted quad decimal IPv4 address with ':' <port>
       suffix, and decimal numbers         
   ip6:ipv6 ascii 32-bit hex words of IPv6 address separated by ':' (or
       '::') with '#' <port> suffix, with decimal numbers
  ] [and / or:
   bin:memory mapped read-only binary table
  ]]

I know ip route and netlink can be used. But since Linux is mandated to
print the IP socket and routing tables in ASCII, which I think is a
great idea for shell / perl / python / java / nodejs / lisp / "script language X" scripts,
in the /proc/net/{udp,tcp}* files, it should net be precluded from providing
a better attempt in new files / filesystems - that is all I am
suggesting.

It is a much more attractive proposition for scripts to parse some ASCII
text rather than having to make a call into a native code library or run an
executable like 'ip' (iproute2) to use netlink sockets for this ;
since Linux has to do this job for the /proc filesystem anyway,
why not at least consider then idea of improving & extending this
excellent support for scripts , and make their task simpler and more
efficient ? ie. they could use one number conversion routine for
all numbers in each new file.

I'd personally find such tables most useful, and might actually develop
a module for them. Especially if they included the netlink IP stats
like 64-bit total counts of rx & tx bytes for each socket as well
as rx & tx queue lengths.

Best Regards,
Jason









