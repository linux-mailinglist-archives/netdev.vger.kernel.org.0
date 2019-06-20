Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69E44D1C5
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbfFTPML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:12:11 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45912 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfFTPML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 11:12:11 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so726795ioc.12
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 08:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2LdiRQEqgt42L7t3ByQeOwhH7hgHYwJw8sUZCnyDFZs=;
        b=aaJxTw4rct+48MTcZ1nvAYC8xhZidSc4MJ9rcb/KOxqNrn1VsKzSa9xeeuOCghZefV
         aiwXtOkox0KNGr/1Vh3v8lUSY9geeJshq90sJJsV4dSfoQyZHb3eH48fPqB6vBnlA7HO
         /qvyrrVtJYpD91GPK3r3vyUF8L+g+CHsNoC4C3orIIIMa5sd5dO1kICLX8C8lTFrAynY
         7lk2WfJbgB3MzrhAPe4xECxXkVNakJLDQ/EIYYsMKmVC491JVzcMJqYdOTfYwyM9XFhR
         DRQOB6khKxn2X7PPTwwR7X5aSPH2XXlVGWG5FU47BBwbjlDRmid3cVxkKyyveTATCiXS
         irDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2LdiRQEqgt42L7t3ByQeOwhH7hgHYwJw8sUZCnyDFZs=;
        b=Oa5Y5H/Y5u9DHuF7qpZdxu/jloT9MQLpnx1FrRVziFB1jmp+EsQX2sUVpIGQvNVocJ
         Xjb9e6OpTYeYuvioxpB0FLZOr6NJVUzxlVJbUOCY+/4OfcaB72tJO9WA7L7EsEOeFvqC
         xCIojD2b7kTvdQar2ogBmnnVZal2sl30Cf0hhxMNZd5gsyBVwG5NX4tp7TToR/nF+q0+
         KzxlNS9A/bDC/KIod0ATKaHnlhPxUIlAYTcQhlGnf7RquQDOtmqIzWovxJQpqev9TqqQ
         1B036g3YqvLdrAsSgZDSJbyU5AcqbE8uv8TePB7jonD0ZHgf+m8e7v5OJ4kU2EmmCJya
         Ofgg==
X-Gm-Message-State: APjAAAWlXxyb00pU23fMWMP5GGIi8uIDFD184dgSlqNVauc/d8jIQvco
        xRX+o6qjpxG1RHpBMLK+zO8JZ6TX
X-Google-Smtp-Source: APXvYqynIyRnih9U4iGbnERqhjRUXzyqKXScvHCTJYOLkNdaxYieKnS6CK6Ef7uWw9nC1djx6i7utQ==
X-Received: by 2002:a02:c918:: with SMTP id t24mr106359451jao.111.1561043530307;
        Thu, 20 Jun 2019 08:12:10 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id l11sm97214ioj.32.2019.06.20.08.12.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 08:12:08 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix neighbour resolution with raw socket
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb3ed305-0161-8d6a-975c-54b29cfcb0ef@gmail.com>
Date:   Thu, 20 Jun 2019 09:12:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 6:34 AM, Nicolas Dichtel wrote:
> The scenario is the following: the user uses a raw socket to send an ipv6
> packet, destinated to a not-connected network, and specify a connected nh.
> Here is the corresponding python script to reproduce this scenario:
> 
>  import socket
>  IPPROTO_RAW = 255
>  send_s = socket.socket(socket.AF_INET6, socket.SOCK_RAW, IPPROTO_RAW)
>  # scapy
>  # p = IPv6(src='fd00:100::1', dst='fd00:200::fa')/ICMPv6EchoRequest()
>  # str(p)
>  req = b'`\x00\x00\x00\x00\x08:@\xfd\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\xfd\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfa\x80\x00\x81\xc0\x00\x00\x00\x00'
>  send_s.sendto(req, ('fd00:175::2', 0, 0, 0))
> 
> fd00:175::/64 is a connected route and fd00:200::fa is not a connected
> host.
> 
> With this scenario, the kernel starts by sending a NS to resolve
> fd00:175::2. When it receives the NA, it flushes its queue and try to send
> the initial packet. But instead of sending it, it sends another NS to
> resolve fd00:200::fa, which obvioulsy fails, thus the packet is dropped. If
> the user sends again the packet, it now uses the right nh (fd00:175::2).
> 

what's the local address and route setup? You reference fd00:100::1 and
fd00:200::fa with connected route fd00:175::/64.

