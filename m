Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF46A23AC84
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgHCSjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:39:47 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5A5C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:39:46 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id w25so5322824ljo.12
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 11:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+rScAl/xTOZUdhR0Y5pwpHwXeriyc0V4z68eT1xOoIU=;
        b=eqlxMm0t0gqA63m6qub4N25hPgSWFA87I1cOSrzWZ93FzGo/9M77pgKd3nLfitWe71
         qXXTTNFf9VL3lh4N2IQPfFzmPpZ3+kbQiEDxxUkWJPM+vzKnhbKpXnZmbv4Xh0cAsMQC
         0XNoxsLShfqcfqg4NrSZq+8an+i/SwJ1a8z8UXri4C2q6oGZ2E1aJOZqIvAAoIklVjtP
         s6kZ6XPllrd8hjdlOlbuNmAu+7HOkwuFHn3YzhJEyBaiBkCuJRWn82iEuPcEaY+RnJBb
         A58cka/utL3WlTv5yY76QInMpb7WSAJfEAUHrN3iXZo4F/GkQsN8KwCbgtEn9iSmqLJ9
         8VTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+rScAl/xTOZUdhR0Y5pwpHwXeriyc0V4z68eT1xOoIU=;
        b=UyWhRvoV1+qJO4MRGQMdbOGigJcaIAjzVwKyglOtvwc6jwXIFpWCEJjkJvJRr2zVU+
         SXoMaTmsT9HkWjmXxlTXu1Buux51CLGkvrOnv+AzdAO9oe7DX4wWfjlpd9T1Holrx/d5
         HpT8Xhpjo3662aMy/53qzAz+wFV+KH7GZaBWrBWfhMB+YRiTddRjlGPg3cPFBKlzzTjv
         Bjn/uZpp3u6OAX7bTKza6e2e/NPOlPlBngNKOzaj7Dsb2847hMMoFhYR9GU+AD7CVQ6H
         i8m0nsVWROWwGutttQvE0qpDIy4QLxZ4Ju16Dbsgjju/AGaX4+m6E7rjZZv4f+Fg2j6m
         tvwA==
X-Gm-Message-State: AOAM533JIO84p3NFZSS2Lwraq+v6nBAQeFECntBXQ6fcxTFKwbdSNt+h
        0X5Cx0BHBQdf1EazVJXjkZaTtXiMi7r6oMzISAs=
X-Google-Smtp-Source: ABdhPJyoV1G665PIos5KJ7YmO6n3rSPmDIPOSFqiefP8QDMqcydVULJcpYlABWkCoWVkmb2Vbb2Da6fK7RFWOxp1W0Q=
X-Received: by 2002:a2e:9888:: with SMTP id b8mr8856037ljj.383.1596479985243;
 Mon, 03 Aug 2020 11:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com> <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
 <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com>
In-Reply-To: <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com>
From:   mastertheknife <mastertheknife@gmail.com>
Date:   Mon, 3 Aug 2020 21:39:34 +0300
Message-ID: <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

I found something that can shed some light on the issue.
The issue only happens if the ICMP response doesn't come from the first nexthop.
In my case, both nexthops are linux routers, and they are the ones
generating the ICMP (because of IPSEC next). This is what I meant
earlier,
that the ICMP path is identical to the original message path.

Test IP #1 - 192.168.249.116 - Hash will choose nexthop #1
Test IP #2 - 192.168.249.117 - Hash will choose nexthop #2

Test with 252.250 as nexthop #1:
--------------------------------
root@lxctest:[~] # ip route add 192.168.249.0/24 dev eth1 nexthop via
192.168.252.250 dev eth1 nexthop via 192.168.252.252 dev eth1
root@lxctest:[~] # ping -M do -s 1450 192.168.249.116
PING 192.168.249.116 (192.168.249.116) 1450(1478) bytes of data.
From 192.168.252.250 icmp_seq=1 Frag needed and DF set (mtu = 1446)
ping: local error: Message too long, mtu=1446
ping: local error: Message too long, mtu=1446
ping: local error: Message too long, mtu=1446
^C
--- 192.168.249.116 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 3067ms
root@testlxc:[~] # ping -M do -s 1450 192.168.249.117
PING 192.168.249.117 (192.168.249.117) 1450(1478) bytes of data.
From 192.168.252.252 icmp_seq=1 Frag needed and DF set (mtu = 1446)
From 192.168.252.252 icmp_seq=2 Frag needed and DF set (mtu = 1446)
From 192.168.252.252 icmp_seq=3 Frag needed and DF set (mtu = 1446)
^C
--- 192.168.249.117 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2052ms

Test with 252.252 as nexthop #1:
--------------------------------
root@testlxc:[~] # ip route add 192.168.249.0/24 dev eth1 nexthop via
192.168.252.252 dev eth1 nexthop via 192.168.252.250 dev eth1
root@testlxc:[~] # ping -M do -s 1450 192.168.249.116
PING 192.168.249.116 (192.168.249.116) 1450(1478) bytes of data.
From 192.168.252.252 icmp_seq=1 Frag needed and DF set (mtu = 1446)
ping: local error: Message too long, mtu=1446
ping: local error: Message too long, mtu=1446
^C
--- 192.168.249.116 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2044ms
root@testlxc:[~] # ping -M do -s 1450 192.168.249.117
PING 192.168.249.117 (192.168.249.117) 1450(1478) bytes of data.
From 192.168.252.250 icmp_seq=1 Frag needed and DF set (mtu = 1446)
From 192.168.252.250 icmp_seq=2 Frag needed and DF set (mtu = 1446)
From 192.168.252.250 icmp_seq=3 Frag needed and DF set (mtu = 1446)
^C
--- 192.168.249.117 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2046ms

In summary: It seems that it doesn't matter who is the nexthop. If the
ICMP response isn't from the nexthop, it'll be rejected.
About why i couldn't reproduce this outside LXC, i don't know yet but
i will keep trying to figure this out.

Let me know if you need me to test this.
Thank you,
Kfir Itzhak

On Mon, Aug 3, 2020 at 6:38 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/3/20 8:24 AM, mastertheknife wrote:
> > Hi David,
> >
> > In this case, both paths are in the same layer2 network, there is no
> > symmetric multi-path routing.
> > If original message takes path 1, ICMP response will come from path 1
> > If original message takes path 2, ICMP response will come from path 2
> > Also, It works fine outside of LXC.
> >
> >
>
> I'll take a look when I get some time; most likely end of the week.
