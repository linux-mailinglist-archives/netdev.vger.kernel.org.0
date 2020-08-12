Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18F9242979
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 14:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHLMho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 08:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgHLMhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 08:37:43 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0220C06174A
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 05:37:42 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id i10so2059598ljn.2
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 05:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqMZHdI8V7lQU5P7aQ2AQkBFt+c6Pr+EWdReIDL9Rz0=;
        b=Zt+tyB87uAeYq4YfzaagUWs3YNK+oHK9OFwDaHZ4jwI+K6MwwCPMKcKUTJ6SDffI7L
         iU9oYRVrXxBor2eN0SOjYgJm+eJeR+lD5IjVzJktIuvQ6/cam8+PYt44Q68ovUfCTwJa
         4KGKsEiMeaPnwrMOpYC8Zck2xXmubHWyQt/+N/vFLs0lOLMlBy/0S4P6zO+PMr/VQsXi
         poEEP4jCvRDLxfS6c3yaRAZbzFugLls+2sLtGTwURm0wHX6scROSAQ559GgXsqfa2ejR
         m7k/tzAnBKyCfxPPshL+qDOAc6BcFmLGystYtybyuOhzPnwsvAQFWqSs6ecrRkD23Zuv
         zC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqMZHdI8V7lQU5P7aQ2AQkBFt+c6Pr+EWdReIDL9Rz0=;
        b=qLevpzA3NxQvVSzc/aOU+AFi+JxA/vjau6B6PwsUDOmCh6mN8QktvNZI5zhOFmxwNi
         Fxiaj+DLYK8m9fSbMmhh/DHYgH1XXos809WTerfVfKEtMXLpX3yG1HfneQJvj34QRKZk
         LuFVKOOKtbFTld3j8U4AAaCAQnfBxRIIceXREeUfpqP9WTm33BEDjgQ3LWM0IdL+NRhQ
         exrofX0eDBDklPnsJHkA08I8t1VqgHrhNrOg0Hz1dvltLRTLmB8oDzGSnCwSkSogsLzJ
         8v35/0KeJftsBrGx5Ib/BdxYWnxjk4KMSfyJDIY/mHeQl0FWdtbU5cu1d3FOk+ynvT1x
         8n8Q==
X-Gm-Message-State: AOAM532JD+RNZL2d8nbjQNJaaNm4494FHCxHPF2JZjiDo8cwlnMchQOY
        Qf+isRUgYffwa4Ek10TsuxK5feJHFGsYk3AtSag=
X-Google-Smtp-Source: ABdhPJxFoldaka6i7Ca2h46CzlnN4vNVEM3xbt7tYT6anRlStX9FDDaIU+leO39ghAj9w5/eLIDcp+rErKKfqezux6s=
X-Received: by 2002:a2e:8e9a:: with SMTP id z26mr4994068ljk.271.1597235860587;
 Wed, 12 Aug 2020 05:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com> <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
 <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com> <CANXY5yJeCeC_FaQHx0GPn88sQCog59k2vmu8o-h6yRrikSQ3vQ@mail.gmail.com>
 <deb7a653-a01b-da4f-c58e-15b6c0c51d75@gmail.com>
In-Reply-To: <deb7a653-a01b-da4f-c58e-15b6c0c51d75@gmail.com>
From:   mastertheknife <mastertheknife@gmail.com>
Date:   Wed, 12 Aug 2020 15:37:29 +0300
Message-ID: <CANXY5yKNOkBWUTVjOCBBPfACTV_R89ydiOi=YiOZ92in_VEp4w@mail.gmail.com>
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

I tried and it seems i can reproduce it:

# Create test NS
root@host:~# ip netns add testns
# Create veth pair, veth0 in host, veth1 in NS
root@host:~# ip link add veth0 type veth peer name veth1
root@host:~# ip link set veth1 netns testns
# Configure veth1 (NS)
root@host:~# ip netns exec testns ip addr add 192.168.252.209/24 dev veth1
root@host:~# ip netns exec testns ip link set dev veth1 up
root@host:~# ip netns exec testns ip route add default via 192.168.252.100
root@host:~# ip netns exec testns ip route add 192.168.249.0/24
nexthop via 192.168.252.250 nexthop via 192.168.252.252
# Configure veth0 (host)
root@host:~# brctl addif vmbr2 veth0
root@host:~# ip link set veth0 up


# Tests
root@host:~# ip netns exec testns ping -M do -s 1450 192.168.249.116
PING 192.168.249.116 (192.168.249.116) 1450(1478) bytes of data.
From 192.168.252.252 icmp_seq=1 Frag needed and DF set (mtu = 1366)
ping: local error: Message too long, mtu=1366
ping: local error: Message too long, mtu=1366
ping: local error: Message too long, mtu=1366
^C
--- 192.168.249.116 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 81ms

root@host:~# ip netns exec testns ping -M do -s 1450 192.168.249.134
PING 192.168.249.134 (192.168.249.134) 1450(1478) bytes of data.
From 192.168.252.252 icmp_seq=1 Frag needed and DF set (mtu = 1366)
From 192.168.252.252 icmp_seq=2 Frag needed and DF set (mtu = 1366)
From 192.168.252.252 icmp_seq=3 Frag needed and DF set (mtu = 1366)
^C
--- 192.168.249.134 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 40ms

root@host:~# ip netns exec testns ip route show cache
192.168.249.116 via 192.168.252.250 dev veth1
    cache expires 584sec mtu 1366
192.168.249.134 via 192.168.252.250 dev veth1
    cache expires 593sec mtu 1366
root@host:~# ip netns exec testns ip route get 192.168.249.116
192.168.249.116 via 192.168.252.250 dev veth1 src 192.168.252.209 uid 0
    cache expires 578sec mtu 1366
root@host:~# ip netns exec testns ip route get 192.168.249.134
192.168.249.134 via 192.168.252.252 dev veth1 src 192.168.252.209 uid 0
    cache


Please notice the above, 'ip route show cache' and 'ip route get'
return different nexthop for 192.168.249.134, i suspect that may be
part of the problem.

Thank you,
Kfir

On Tue, Aug 11, 2020 at 1:13 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/3/20 12:39 PM, mastertheknife wrote:
> > In summary: It seems that it doesn't matter who is the nexthop. If the
> > ICMP response isn't from the nexthop, it'll be rejected.
> > About why i couldn't reproduce this outside LXC, i don't know yet but
> > i will keep trying to figure this out.
>
> do you have a shell script that reproduces the problem?
