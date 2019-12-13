Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6262511E774
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 17:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfLMQDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 11:03:55 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:43114 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfLMQDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 11:03:55 -0500
Received: by mail-pl1-f179.google.com with SMTP id p27so1405441pli.10;
        Fri, 13 Dec 2019 08:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V5u34mdk1sa4hWDXLxuGfA6FHQiDVJCcuZzPDdPXmiw=;
        b=rtQ+TumT0pABx+WyC68ZGd033Fkzx4T2APjnUC/gm5VIRjkIxZZIIuKqCo2JWOpM12
         oVuCvR4UNPV0Q0SupE0Vc57I4JBq4Sz2LIyoH51BC4z8Q7LdFsCa3mptWxVVreyw5Ib5
         cQ2tyxuxOR30/nO6VARlwbTxwKFpMMLTo4rJTYi/JyFQ8ffoRIHTQPuzIRLRW9vk2Y6G
         LYw+1xY37SiFk5gq0Wl0XR4rrHbaIeEY1xwIxb2aszZtC/MrxXu9teeIw8mSbbRytKmO
         MdLv+rDUGoji3IG38EPktJG/PnLbSXbFsUe0DYcW6IDkWNkFvqb/ffgwVmZxg3U5Fpie
         lyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V5u34mdk1sa4hWDXLxuGfA6FHQiDVJCcuZzPDdPXmiw=;
        b=Yhix6IIvXEdONODbzwQfYk5SvE5oNFlBGQJx79c0LpoE+TDCZ/yR5Mw7ik+Sl8S6Vz
         z49gCOpwTGt24wV0E+4DM6ORDILLnJzUtICZjeSadb2lhWQ8o89kqg1zlCe9nLr7KDpg
         7+Jvrs0pyk6S+jaZLG4Ksz55d0g1UeTNWVAtCbs9u7orOjiLPOECoLzDWLwzhZpW3NLp
         oID339a+u/lEEIInQjKUMd1q1vdvjZzCWhXehOmEPxeqOvSYTCUuNnFzDpTuO8TD9zRN
         71iEvqlqL5B1hIrypf07bpQHHMOcgJ3EQeh11r6PWxSTyFYldPRA2NWk9iofZjXeHDiD
         IOmQ==
X-Gm-Message-State: APjAAAWyLkkeVdDC+XRXUkpYXQKp2fhxBRZOmgavTkBha44HfyxIMHJY
        72uZaj7Bmj7LngzfiCQXTwM=
X-Google-Smtp-Source: APXvYqzr+NduVVi5cLa98Nka4QniMT4vze3R6rRqVYVP8qZAIHjuuDwUOBLcjKlXPJwoVqIqLeTAeQ==
X-Received: by 2002:a17:902:8603:: with SMTP id f3mr58698plo.198.1576253034560;
        Fri, 13 Dec 2019 08:03:54 -0800 (PST)
Received: from [192.168.84.22] (8.100.247.35.bc.googleusercontent.com. [35.247.100.8])
        by smtp.gmail.com with ESMTPSA id w12sm11890329pfd.58.2019.12.13.08.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 08:03:53 -0800 (PST)
Subject: Re: [RFC] tcp: implement new per-interface sysctl "auto_dev_bind"
To:     Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "William J. Tolley" <william@breakpointingbad.com>,
        "Jason A. Donenfeld" <zx2c4@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20191213100730.2153-1-w@1wt.eu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d40a3670-e983-d9fc-0a06-4f62bafe96b2@gmail.com>
Date:   Fri, 13 Dec 2019 08:03:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213100730.2153-1-w@1wt.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/19 2:07 AM, Willy Tarreau wrote:
> This sysctl, when set, makes sure that any TCP socket connecting through
> that interface or accepted from this interface will automatically be
> bound to this device so that the socket cannot migrate by accident to
> another interface if the current one goes down, and that incoming traffic
> from other interfaces may never reach the socket regardless of rp_filter.
> This can be useful for example, in order to protect connections made over
> a VPN interface, such as the attack described here:
> 
>    https://seclists.org/oss-sec/2019/q4/122.
> 
> It might possibly have other use cases such as preventing traffic from
> leaking to the default route interface during a temporary outage of a
> tunnel interface, or sending traffic out of the host when a local
> address is removed.
> 
> Only TCPv4 and TCPv6 are covered by this patch.
> 
> Reported-by: "William J. Tolley" <william@breakpointingbad.com>
> Cc: "Jason A. Donenfeld" <zx2c4@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> 
> ---
> 
> This issue was recently brought on the security list by William and was
> discussed with Eric and Jason. This patch is just a proposal to open
> the discussion around a clean solution to address the issue. It currently
> covers TCPv4 and TCPv6 (both tested). I have no idea whether this is
> the best way to proceed; I'm not sure whether we want to address other
> connected protocols (e.g. UDP can be "connected" but do we care?); and
> very likely the patch will need to be split in two for IPv4/IPv6 but
> I found it was more convenient for a review to have both parts together.
> 
> --- test reports below
> 
> IPv4: simple test over an ipip tunnel
> 
>   left (.236):
>     ip tunnel add t4 mode ipip remote 192.168.0.176
>     ip li set t4 up && ip a a 192.0.2.1/30 dev t4
> 
>   right (.176):
>     ip tunnel add t4 mode ipip remote 192.168.0.236
>     ip li set t4 up && ip a a 192.0.2.2/30 dev t4
> 
>   left:~# echo 0 > /proc/sys/net/ipv4/conf/t4/auto_dev_bind
>   right:~# nc -lp4000
>   left:~# telnet 192.0.2.2 4000 &
>   left:~# netstat -atn|grep :4000
>   tcp        0      0 192.0.2.1:19536          192.0.2.2:4000          ESTABLISHED
> 
>   attacker:~# nping --tcp --flags SA --source-ip 192.0.2.2 -g 4000 --dest-ip 192.0.2.1 -p 19536 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87
> 
>   left:~# tcpdump -Sni t4
>   16:20:13.289142 IP 192.0.2.1.19536 > 192.0.2.2.4000: . ack 2220548823 win 507
>   16:20:13.955344 IP 192.0.2.1.19536 > 192.0.2.2.4000: . ack 2220548823 win 507
> 
>   left:~# echo 1 > /proc/sys/net/ipv4/conf/t4/auto_dev_bind
>   left:~# telnet 192.0.2.2 4000 &
>   left:~# netstat -atn|grep :4000
>   tcp        0      0 192.0.2.1:19540          192.0.2.2:4000          ESTABLISHED
> 
>   attacker:~# nping --tcp --flags SA --source-ip 192.0.2.2 -g 4000 --dest-ip 192.0.2.1 -p 19540 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87
> 
>   left:~# tcpdump -Sni t4
>   16:22:41.933842 IP 192.0.2.1.19540 > 192.0.2.2.4000: R 2405575235:2405575235(0) win 0
>   16:22:42.266897 IP 192.0.2.1.19540 > 192.0.2.2.4000: R 2405575235:2405575235(0) win 0
>   16:22:42.599940 IP 192.0.2.1.19540 > 192.0.2.2.4000: R 2405575235:2405575235(0) win 0
> 
> IPv6: simple test over an sit tunnel
> 
>   left (.236):
>     ip tunnel add t6 mode sit  remote 192.168.0.176
>     ip li set t6 up && ip -6 a a 2001:db8::1/64 dev t6
> 
>   right (.176):
>     ip tunnel add t6 mode sit  remote 192.168.0.236
>     ip li set t6 up && ip -6 a a 2001:db8::2/64 dev t6
> 
>   left:~# echo 0 > /proc/sys/net/ipv4/conf/t4/auto_dev_bind
>   right:~# nc6 -lp4000
>   left:~# telnet -6 2001:db8::2 4000 &
>   left:~# netstat -atn|grep :4000
>   tcp        0      0 2001:db8::1:50636       2001:db8::2:4000        ESTABLISHED
>   attacker:~# nping -6 --tcp --flags SA --source-ip 2001:db8::2 -g 4000 --dest-ip 2001:db8::1 -p 50636 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87 --source-mac e8:b6:74:5d:19:ed
> 
>   left:~# tcpdump -Sni t6
>   16:29:19.842821 IP6 2001:db8::1.50636 > 2001:db8::2.4000: . ack 245909702 win 511
>   16:29:20.508811 IP6 2001:db8::1.50636 > 2001:db8::2.4000: . ack 245909702 win 511
> 
>   left:~# echo 1 > /proc/sys/net/ipv6/conf/t6/auto_dev_bind
>   right:~# nc6 -lp4000
>   left:~# telnet -6 2001:db8::2 4000 &
>   left:~# netstat -atn|grep :4000
>   tcp        0      0 2001:db8::1:56750       2001:db8::2:4000        ESTABLISHED
> 
>   attacker:~# nping -6 --tcp --flags SA --source-ip 2001:db8::2 -g 4000 --dest-ip 2001:db8::1 -p 56750 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87 --source-mac e8:b6:74:5d:19:ed
> 
>   left:~# tcpdump -Sni t6
>   16:46:34.264607 IP6 2001:db8::1.56750 > 2001:db8::2.4000: R 3346985589:3346985589(0) win 0
>   16:46:34.597653 IP6 2001:db8::1.56750 > 2001:db8::2.4000: R 3346985589:3346985589(0) win 0
>   16:46:34.931292 IP6 2001:db8::1.56750 > 2001:db8::2.4000: R 3346985589:3346985589(0) win 0
> 
> Test of incoming connection:
>   right~# nc 2001:db8::1 22
>   left:~# netstat -atn|grep :22
>   tcp        0      0 2001:db8::1:22          2001:db8::2:35990       ESTABLISHED
> 
>   attacker:~# nping -6 --tcp --flags SA --source-ip 2001:db8::2 -g 35990 --dest-ip 2001:db8::1 -p 22 --rate 3 -c 3 -e eth0 --dest-mac 18:66:c7:53:ae:87 --source-mac e8:b6:74:5d:19:ed
> 
>   left:~# tcpdump -Sni t6
>   16:53:20.810751 IP6 2001:db8::1.22 > 2001:db8::2.35990: R 1630812853:1630812853(0) win 0
>   16:53:21.144036 IP6 2001:db8::1.22 > 2001:db8::2.35990: R 1630812853:1630812853(0) win 0
>   16:53:21.477052 IP6 2001:db8::1.22 > 2001:db8::2.35990: R 1630812853:1630812853(0) win 0
> ---
>  include/linux/ipv6.h      |  1 +
>  include/uapi/linux/ip.h   |  1 +
>  include/uapi/linux/ipv6.h |  1 +
>  net/ipv4/devinet.c        |  1 +
>  net/ipv4/tcp_ipv4.c       | 11 +++++++++++
>  net/ipv6/addrconf.c       | 10 ++++++++++
>  net/ipv6/tcp_ipv6.c       | 13 +++++++++++++
>  7 files changed, 38 insertions(+)
> 

Hi Willy, thanks for working on this.

Could you check if your patch works with syncookies mode ?

echo 2 >/proc/sys/net/ipv4/tcp_syncookies

I wonder if your patch could be simpler if you were plugging the logic for passive
flows in inet_request_bound_dev_if() ?

