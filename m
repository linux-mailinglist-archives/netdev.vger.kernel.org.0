Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5F7E7B49
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfJ1VWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:22:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38283 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729265AbfJ1VWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:22:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id c13so7812240pfp.5
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 14:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ghF2T58c6S9slMAJkpCLtc3UdC1RItqnkJJASi25+To=;
        b=Hs5ja3P3D6dVlTop62PWNevoF76220HFaQC+KWCqFfqb4aMJbKdyv8Y2OPUF6EsVE7
         Iph5Rl1hsQd3tHeXMlQ/nDf161cJamH/NswfSb+iVY3vP8vypgzgNXPVcclTGuFfeID4
         JUXFakbU7LG8hyN+GFaHs5EI+7s26DXxeSM2Ill0ySp88JWpBXiwAkbiG9DC3gCQacXs
         ag2dqpzvYUlCkZvO/hOaCrUCmXJqlq65HU20G7D50H3dnlvwL92rmOpajJ1ED0e7txC4
         rhawDuU9U6x+BWsH0CIKG+3cE8di/mD8+JfHYaSLX5Zpl5kbU2IRkkEs7hnkykUue1H+
         984w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ghF2T58c6S9slMAJkpCLtc3UdC1RItqnkJJASi25+To=;
        b=HUcLCPuGS69TmZS15VsL0ApLqj6nIOa1v60LFOy1l9BbP4Xa3j/cUKh28SjyDg5t7O
         tKWkpd73QxFY/72Dxa3RTNaTy4fhDg95YOnY1uczPRl0e1CjCbBdt9Q3KnOy2ieBmIqo
         v71PHi9jDwNbTC+n3tN6aUYr2tCY41gIU+FmbNr7mFFwUloMjPSIgUjNkH8Qn6zlUtzk
         +kdlBP1UWlmHsEbb8F0saWkWfEX58bJcsOIhh22JxFxDx2cXI31w6KedtA3VrDWB/L6Q
         9a4MgSQ0Oz27q6Jt+LYvwcNGVUeubNisKT3XcyFIjrnvQuLB38oSnwfFQGMefj9TxZXz
         lrHg==
X-Gm-Message-State: APjAAAWtF8qQB9kyPDWou1rWEtk0Tyhol3dvMH++kHontu1kH1TIRjj4
        FvRiUAIdEJp74f3yVv24VTI=
X-Google-Smtp-Source: APXvYqw+IHg2Qmfwu9N9+oriFx58BwktVpROtcl4tMmGxEODEQ3pEXUOJ1CuwuKcqWbtMK+pmhOlQg==
X-Received: by 2002:a63:1b58:: with SMTP id b24mr23006146pgm.127.1572297734657;
        Mon, 28 Oct 2019 14:22:14 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id y17sm3443306pfl.7.2019.10.28.14.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 14:22:13 -0700 (PDT)
Subject: Re: Fw: [Bug 205339] New: epoll can fail to report a socket readable
 after enabling SO_OOBINLINE
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, njs@pobox.com
References: <20191028081107.38b73eb1@hermes.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a863e2a4-8d31-c8d8-2f85-7fe3fa30104f@gmail.com>
Date:   Mon, 28 Oct 2019 14:22:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028081107.38b73eb1@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please Stephen CC the reporter when you forward a bugzilla bug to the list

On 10/28/19 8:11 AM, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Mon, 28 Oct 2019 02:55:44 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 205339] New: epoll can fail to report a socket readable after enabling SO_OOBINLINE
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=205339
> 
>             Bug ID: 205339
>            Summary: epoll can fail to report a socket readable after
>                     enabling SO_OOBINLINE
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.0
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: low
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: njs@pobox.com
>         Regression: No

> Created attachment 285671
>   --> https://bugzilla.kernel.org/attachment.cgi?id=285671&action=edit  
> reproducer
> 
> Consider the following sequence of events:
> 
> 1. OOB data arrives on a socket.
> 2. The socket is registered with epoll with EPOLLIN
> 3. The socket has SO_OOBINLINE toggled from False → True
> 
> In this case, the socket is now readable, and select() reports that it's
> readable, but epoll does *not* report that it's readable.
> 
> This is a pretty minor issue, but it seems like an unambiguous bug so I figured
> I'd report it.
> 
> Weirdly, this doesn't appear to be a general problem with SO_OOBINLINE+epoll.
> For example, this very similar sequence works correctly:
> 
> 1. The socket is registered with epoll with EPOLLIN
> 2. OOB data arrives on the socket.
> 3. The socket has SO_OOBINLINE toggled from False → True
> 
> After step 2, epoll reports the socket as not readable, and then after step 3
> it reports it as readable, as you'd expect.
> 
> In the attached reproducer script, "scenario 4" is the buggy one, and "scenario
> 3" is the very similar non-buggy one. Output on Ubuntu 19.04, kernel
> 5.0.0-32-generic, x86-64:
> 
> -- Scenario 1: no data --
> select() says: sock is NOT readable
> epoll says: sock is NOT readable
> reality: NOT readable
> 
> -- Scenario 2: OOB data arrives --
> select() says: sock is NOT readable
> epoll says: sock is NOT readable
> reality: NOT readable
> 
> -- Scenario 3: register -> OOB data arrives -> toggle SO_OOBINLINE=True --
> select() says: sock is readable
> epoll says: sock is readable
> reality: read succeeded
> 
> -- Scenario 4: OOB data arrives -> register -> toggle SO_OOBINLINE=True --
> select() says: sock is readable
> epoll says: sock is NOT readable
> reality: read succeeded
> 

I really wonder how much energy we should put in maintaining this archaic thing.

We do not have a single packetdrill test at Google using URG stuff.
