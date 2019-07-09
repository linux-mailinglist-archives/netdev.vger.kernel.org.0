Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2606372A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfGINmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:42:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34183 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfGINmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:42:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so4313021wrm.1
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 06:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7CyPjT76jIh9h9egJO7bSxqwc/6BFkLq8/3mJhdQIN0=;
        b=zgE/QPLFqDbc7eNnN6Q3mxb0QK6IoQ7hQBf0f497WTeRgNmSiPglAmlBB0SMTBO+2+
         2ACX5JME85/zewe/LtvXnP8l3kjSD+/hHzPjWUEU/gWTQ3jnU6eyIhrvWkqBA1rf34If
         /QUDWbhwaQ8lNZifBqogTanUE5u+A5RDAcI67xGxBDDLhR9HhLLKxUh38guFB9buy9fh
         0zWtoaHwRftZclhyVNTbKiMQl8i9UR015ZIzZ+uOwcrQF9qZ1675GM9ivc1+8wCx/9+B
         7gKaXyT3DHmzOe7MbqgsV6V8SGx0kpJuP2m4ijXNzVKBWiZ5zHY7GLdetjBlj1qCanBJ
         eung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7CyPjT76jIh9h9egJO7bSxqwc/6BFkLq8/3mJhdQIN0=;
        b=DQyixictOXmbm7DJXBj5ephfX/7qDYEalFr3ZraoDgjWrJgTlx+1RN8q9Dw8mbEfRY
         J/LNAp8ecIoXDhvT2iY1Di5vSYIEJJOXPpf4O4HI+W0bWJSAEwDclYbS9Ug6kjU3hrkP
         FZcO+dnAcvXcRaxcLcTed8FQyl8s1Plp8aFpOlXU/WWgys+769p12ewSqNg9tQnJT6up
         PVzO76YhGrufeWmC+ezSkNtoEfe9gNGelspI91n5+L2ZwWbYUBypb5vaxFBNvMzOMCZy
         CohyGdb9wU3S0Mxd3Zxk4VYna6pIgB5w4/q4/+rmyrPTrPoptGgY/S+G2BFcch6yp89j
         VOpQ==
X-Gm-Message-State: APjAAAWR7tbQb/RVcUfSSIFN0a8LJy1GSxbRmtiKHycB9dqyuckCzF7j
        edcmHCSr6Xtyu2155XtFoQNChw==
X-Google-Smtp-Source: APXvYqwrQzd8aed+JxloTMquZVe7/V7JrMqS9sGdKhaOCytwqcoX0vDUS3fi+DNnI+UE8hDaz2xH4Q==
X-Received: by 2002:adf:fa42:: with SMTP id y2mr23911424wrr.170.1562679733179;
        Tue, 09 Jul 2019 06:42:13 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i18sm21104574wrp.91.2019.07.09.06.42.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 06:42:12 -0700 (PDT)
Date:   Tue, 9 Jul 2019 15:42:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 04/15] ethtool: introduce ethtool netlink
 interface
Message-ID: <20190709134212.GD2301@nanopsycho.orion>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
 <20190702122521.GN2250@nanopsycho>
 <20190702145241.GD20101@unicorn.suse.cz>
 <20190703084151.GR2250@nanopsycho>
 <20190708172729.GC24474@unicorn.suse.cz>
 <20190708192629.GD2282@nanopsycho.orion>
 <20190708202219.GE24474@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708202219.GE24474@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 08, 2019 at 10:22:19PM CEST, mkubecek@suse.cz wrote:
>On Mon, Jul 08, 2019 at 09:26:29PM +0200, Jiri Pirko wrote:
>> Mon, Jul 08, 2019 at 07:27:29PM CEST, mkubecek@suse.cz wrote:
>> >
>> >There are two reasons for this design. First is to reduce the number of
>> >requests needed to get the information. This is not so much a problem of
>> >ethtool itself; the only existing commands that would result in multiple
>> >request messages would be "ethtool <dev>" and "ethtool -s <dev>". Maybe
>> >also "ethtool -x/-X <dev>" but even if the indirection table and hash
>> >key have different bits assigned now, they don't have to be split even
>> >if we split other commands. It may be bigger problem for daemons wanting
>> >to keep track of system configuration which would have to issue many
>> >requests whenever a new device appears.
>> >
>> >Second reason is that with 8-bit genetlink command/message id, the space
>> >is not as infinite as it might seem. I counted quickly, right now the
>> >full series uses 14 ids for kernel messages, with split you propose it
>> >would most likely grow to 44. For full implementation of all ethtool
>> >functionality, we could get to ~60 ids. It's still only 1/4 of the
>> >available space but it's not clear what the future development will look
>> >like. We would certainly need to be careful not to start allocating new
>> >commands for single parameters and try to be foreseeing about what can
>> >be grouped together. But we will need to do that in any case.
>> >
>> >On kernel side, splitting existing messages would make some things a bit
>> >easier. It would also reduce the number of scenarios where only part of
>> >requested information is available or only part of a SET request fails.
>> 
>> Okay, I got your point. So why don't we look at if from the other angle.
>> Why don't we have only single get/set command that would be in general
>> used to get/set ALL info from/to the kernel. Where we can have these
>> bits (perhaps rather varlen bitfield) to for user to indicate which data
>> is he interested in? This scales. The other commands would be
>> just for action.
>> 
>> Something like RTM_GETLINK/RTM_SETLINK. Makes sense?
>
>It's certainly an option but at the first glance it seems as just moving
>what I tried to avoid one level lower. It would work around the u8 issue
>(but as Johannes pointed out, we can handle it with genetlink when/if
>the time comes). We would almost certainly have to split the replies
>into multiple messages to keep the packet size reasonable. I'll have to
>think more about the consequences for both kernel and userspace.
>
>My gut feeling is that out of the two extreme options (one universal
>message type and message types corresponding to current infomask bits),
>the latter is more appealing. After all, ethtool has been gathering
>features that would need those ~60 message types for 20 years.

Yeah, but I think that we have to do one or another. Anything in between
makes the code complex and uapi confusing. Let's start clean :)
