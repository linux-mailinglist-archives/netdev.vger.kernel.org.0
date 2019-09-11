Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB75DB00FF
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfIKQJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:09:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55954 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbfIKQJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 12:09:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id g207so4151173wmg.5
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 09:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5SqilImTM9K9FBHHqCOb0zTzwidpusNdBhVIOX4avgU=;
        b=IUdoGjOX+B/ZcLf4nRxGYY3baDAFNIUthU3PBwlmLJVKAfM8qtI9lt/KjmnEnmW4Q5
         nq/LTmYyETDPPM2ouXUHxaXO5K1Giop6jhpqMd9YYlk03KbK79AznqNeyhlCEOk9xIaC
         TFJYFA6UFXdk0HwVwSzcISoi9xKP8WVV5G7rnfbwxBl4gWNHo3NTRCN/VGhXVLG2hyg5
         bESnO9KTHPvrlXN9Jia7VYFtiIofZsPiFh0QTG910zyKagq4RbVsJ9RhauK1Ys1WGfiu
         9g69Ee2ocvN/Ag5kUGxeX2nbK6awaAjn4tsUwBaUBXYuQbPlO+6xGKbQVVq2LVTzbmHA
         4kZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5SqilImTM9K9FBHHqCOb0zTzwidpusNdBhVIOX4avgU=;
        b=dW4GMA+d/hYA+QPnGF6bVz91nQgwOHWWrFCzHV7Gp4TuNL+WuLWm8iI4P99aBiGnJn
         WZCCPM7+mlTu+iAS64S2nk2dIhOkLVeAZkGmsiIdYEL/uL0HWG/5ddvaQ6PDodBJ/+s4
         40Jx+nuEixYTM0uYTPFh0Rt3MCyPGvYKCdrZnc7HTL9lmj/1x0+3C65t1+p3NZ5nY4ri
         8Aw9LQyF3B6jZgB10BRLCOZSmJJi0ABbX75wf1TQeAPrnsdHPrZZSZV91oHj7SNdK9ID
         uBc1Sf60oMk+oDEU8KbGfPhPcds9gds/agwJmObUdYw/RsQHceqgb/TMzQpXCMHc5C5k
         ilGQ==
X-Gm-Message-State: APjAAAWXBf1LFmFjdQHjY4/Bi6VFDNNdjayMC0cQ/nBunloFuT3XfspR
        xG/5sinu2Hn9G5Xf29UFKqkBiMSl
X-Google-Smtp-Source: APXvYqyBPloGq7Vlo/Quj0ShqeWikqMj8vyKN5pLS3CXTamlnZD11OLTT0148ypv9D9M5CJ70TdF9Q==
X-Received: by 2002:a1c:2bc7:: with SMTP id r190mr5017349wmr.143.1568218178371;
        Wed, 11 Sep 2019 09:09:38 -0700 (PDT)
Received: from dahern-DO-MB.local ([148.69.85.38])
        by smtp.googlemail.com with ESMTPSA id h21sm16255090wrc.71.2019.09.11.09.09.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 09:09:37 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Gowen <gowen@potatocomputing.co.uk>,
        Alexis Bauvin <abauvin@online.net>,
        "mmanning@vyatta.att-mail.com" <mmanning@vyatta.att-mail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <CWLP265MB155485682829AD9B66AB66FCFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB155424EF95E39E98C4502F86FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0fd88da3-a7b1-d2e5-f5b8-0095220a7cc0@gmail.com>
Date:   Wed, 11 Sep 2019 17:09:35 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CWLP265MB155424EF95E39E98C4502F86FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/19 3:01 PM, Gowen wrote:
> Hi all,
> 
> It looks like ip vrf exec checks /etc/resolv.conf (found with strace -e
> trace=file sudo ip vrf exec mgmt-vrf host www.google.co.uk &>
> ~/straceFileOfVrfHost.txt) , but as I'm on an Azure machine using
> netplan, this file isn't updated with DNS servers. I have added my DNS
> server to resolv.conf and now can update the cache with "sudo ip vrf
> exec sudo apt update", if I am correct (which I'm not sure about as not
> really my area) then this might be affecting more than just me.
> 
> Also still not able to fix the updating cache from global VRF - which
> would cause bother in prod environment to others as well so think it
> would be good to get an RCA for it?
> 
> thanks for your help so far, has been really interesting.
> 
> Gareth
> 
> 
> ------------------------------------------------------------------------
> *From:* Gowen <gowen@potatocomputing.co.uk>
> *Sent:* 11 September 2019 13:48
> *To:* David Ahern <dsahern@gmail.com>; Alexis Bauvin
> <abauvin@online.net>; mmanning@vyatta.att-mail.com
> <mmanning@vyatta.att-mail.com>
> *Cc:* netdev@vger.kernel.org <netdev@vger.kernel.org>
> *Subject:* Re: VRF Issue Since kernel 5
>  
> yep no problem:
> 
> Admin@NETM06:~$ sudo sysctl -a | grep l3mdev
> net.ipv4.raw_l3mdev_accept = 1
> net.ipv4.tcp_l3mdev_accept = 1
> net.ipv4.udp_l3mdev_accept = 1
> 
> 
> The source of the DNS issue in the vrf exec command is something to do
> with networkd managing the DNS servers, I can fix it by explicitly
> mentioning the DNS server:
> 
> systemd-resolve --status --no-page
> 
> <OUTPUT OMITTED>
> 
> Link 4 (mgmt-vrf)
>       Current Scopes: none
>        LLMNR setting: yes
> MulticastDNS setting: no
>       DNSSEC setting: no
>     DNSSEC supported: no
> 
> Link 3 (eth1)
>       Current Scopes: DNS
>        LLMNR setting: yes
> MulticastDNS setting: no
>       DNSSEC setting: no
>     DNSSEC supported: no
>          DNS Servers: 10.24.65.203
>                       10.24.65.204
>                       10.25.65.203
>                       10.25.65.204
>           DNS Domain: reddog.microsoft.com
> 
> Link 2 (eth0)
>       Current Scopes: DNS
>        LLMNR setting: yes
> MulticastDNS setting: no
>       DNSSEC setting: no
>     DNSSEC supported: no
>          DNS Servers: 10.24.65.203
>                       10.24.65.204
>                       10.25.65.203
>                       10.25.65.204
>           DNS Domain: reddog.microsoft.com
> 
> there is no DNS server when I use ip vrf exec command (tcpdump shows
> only loopback traffic when invoked without my DNS sever explicitly
> entered) - odd as mgmt-vrf isnt L3 device so thought it would pick up
> eth0 DNS servers?
> 
> I dont think this helps with my update cache traffic from global vrf
> though on port 80
> 

Let's back up a bit: your subject line says vrf issue since kernel 5.
Did you update / change the OS as well?

ie., the previous version that worked what is the OS and kernel version?
What is the OS and kernel version with the problem?
