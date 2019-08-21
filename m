Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3617896FFC
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 05:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfHUDDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 23:03:00 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:41750 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfHUDDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 23:03:00 -0400
Received: by mail-qk1-f172.google.com with SMTP id g17so589589qkk.8
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 20:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZntrsQhPUJ+2+iPD5kZ0RIYFyfr2ZvUDPWDW/rDrDNg=;
        b=cN5LYEB7J4shHmtJjWdnbXfli+8SFswmr1Ijs0DbGZupC7JJJU4chkImqNOCusUhnD
         ts5cR5HsoKSeJ4JUjhpFf9gsR6qI0+3JqgHJG8GXPHh/cbuD4F45CNXOKhnPkYIdyYgU
         mZPhJxjssDmxAu0ss9McvB7bPl25nlzfB01OYojZVZHOg6p5bwXGlXEEymBv6qkkVgtn
         WQIuzhxNi91Mywdbfx8KVtR6oNMdTRW/tNum0OUfmoXtWf4vdGrYx3iOHdpc74zcoeuW
         PtcVEFR0t2/lZJoKyipvVqwwdfdAdSmIdHayMUHhCJi9vwvhY5r/QTHJIy0lxEwdoyHQ
         CQzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZntrsQhPUJ+2+iPD5kZ0RIYFyfr2ZvUDPWDW/rDrDNg=;
        b=YjMAOy3EL0UtoF5CR+7DOB0rmT/FttvD0WVGjwrJNLVJKFjZP47tCrmDE/fCGtjad0
         R624jAaBO2HZGvvP8lTHlEJMrSCqhyESJehxNQ8BAFVbr4rPqHqi/LB0ZbeO4TEXiJDf
         pCol+c55VnB1AJeSc23F8DRZ8EUDr3go8gJXWmDUB5O747gYMDjS8P8D7nX6DusV25Vv
         gxLOUHLcF4CqvmIq6yaF2UoPF1HdHQhWYs1pIVl3Q7HDNjzJv7gRm65YOy1ASyou0mlM
         rWEweaOeEQoWPXQjxRFJIViVK/BuNzOeBveu/HAMPcK37QQr1sllyaNRP9qVFlghD64d
         K0Iw==
X-Gm-Message-State: APjAAAXx59J2XXY3ulyHbCbEMZmBoRBThSt2lPiyert6wc98n/I+97n9
        LVflQUv6i3uSAoqCoQZxzu9heR1G
X-Google-Smtp-Source: APXvYqzbOn9SUYjnnnI0xvVYHwwUwm+ynRjA8ssl6hfu9D3NtOSygYJpM1IrNvL+OWOOFnuDs9vzPw==
X-Received: by 2002:ae9:e00c:: with SMTP id m12mr29490027qkk.268.1566356579263;
        Tue, 20 Aug 2019 20:02:59 -0700 (PDT)
Received: from dsa-mb.local ([2604:2000:e8c5:d400:d113:a204:634b:da0b])
        by smtp.googlemail.com with ESMTPSA id z7sm9575496qki.88.2019.08.20.20.02.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 20:02:58 -0700 (PDT)
Subject: Re: VRF notes when using ipv6 and flushing tables.
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <8977a25e-29c1-5375-cc97-950dc7c2eb0f@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2a8914bb-56ec-e585-bd76-36b77ca2517d@gmail.com>
Date:   Tue, 20 Aug 2019 23:02:57 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <8977a25e-29c1-5375-cc97-950dc7c2eb0f@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 2:27 PM, Ben Greear wrote:
> I recently spend a few days debugging what in the end was user error on
> my part.
> 
> Here are my notes in hope they help someone else.
> 
> First, 'ip -6 route show vrf vrfX' will not show some of the
> routes (like local routes) that will show up with
> 'ip -6 route show table X', where X == vrfX's table-id
> 
> If you run 'ip -6 route flush table X', then you will loose all of the auto
> generated routes, including anycast, ff00::/8, and local routes.
> 
> ff00::/8 is needed for neigh discovery to work (probably among other
> things)
> 
> local route is needed or packets won't actually be accepted up the stack
> (I think that is the symptom at least)
> 
> Not sure exactly what anycast does, but I'm guessing it is required for
> something useful.
> 
> You must manually re-add those to the table unless you for certain know
> that
> you do not need them for whatever reason.
> 

sorry you went through such a long and painful debugging session.

yes, the kernel doc for VRF needs to be updated that 'ip route show vrf
X' and 'ip route show table X' are different ('show vrf' mimics the main
table in not showing local, broadcast, anycast; 'table vrf' shows all).

A suggestion for others: the documentation and selftests directory have
a lot of VRF examples now. If something basic is not working (e.g., arp
or neigh discovery), see if it works there and if so compare the outputs
of the route table along the way.
