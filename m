Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A361C0B8
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 04:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfENCv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 22:51:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32934 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfENCv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 22:51:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id z28so8286121pfk.0
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 19:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2bPQFagZGHu/ZUeGFkybsvQZRObUkVG/Vjsps2sBOZY=;
        b=j+3wTWAX5BoYBh7R0CB/xDltGB+zrrwvXW16jtgMF/l+jzlTxOggvixwOhQ10z96di
         uNQjnUDPc3CT9WJcY+4p1QfSsYnY3n/nH42ubb5X/FjCByQECi7s/HtCKD/LPGnUFPev
         0NSyGk/EnUc3f3o6k4+ReKuaVLhVQfGwt3SnMGr6EOqHsfjDUWJlUjHh1jvCcPNItNDg
         8bxM+4ZIBtplp4lGC1bPADhcezBazJ3nioogYuKx9vXPSQHqXIZpM+8RlHQYXDOWAIZO
         g9OOcGJFKwhDk4hfTYgy3XGbdTvW/SyrYGfMeRn9eiOqVRC/CyPL8B1frA67i7Ds/sOv
         XyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2bPQFagZGHu/ZUeGFkybsvQZRObUkVG/Vjsps2sBOZY=;
        b=ks5qFoYCdBv1wGx6brkgPSPfc2Lh4nSdNNLPY1Q6uFhodBlTCzR0D4kDRM1gbt9lGq
         HJih0WErmk6BOAKz9+jaZfi82BOp4yjKEjnnEOwJIpHthzURulUkkeJj31C4sHLPIUQJ
         N4tCySZItP1iukc4BZM6RdIhzbOeB+DkcC9228Kuv6NFz49uhHePFg/Jr4pfMlVbJ3cV
         NMz2s7nyv7NPG3hU4jNTIFDy3jxTLCQYheWwRr/WeeCOXFths9qmUZ6/PqZE8RflrD4X
         kQ2kMTCHcu0yqSA+XbvvcNLM2zyfxtJaDWwqtonwrsHSdfPjipi2VdfqacNI3dsf7jdf
         eFnQ==
X-Gm-Message-State: APjAAAXnwd+7RHuegQuMNKcbA9eMb/76weuTc4C66zdnVfgBbssVbU+9
        i5v3BIuGtZ4vKXUnfdqI6EE=
X-Google-Smtp-Source: APXvYqydqwd3QCoviaS7OH9xxNIM/N6EfA9NdwPU6cXDJgdIpJKDNURfLK7E8Kq9YGTtBqq2jwQGEQ==
X-Received: by 2002:a63:6ac3:: with SMTP id f186mr35222452pgc.326.1557802317502;
        Mon, 13 May 2019 19:51:57 -0700 (PDT)
Received: from [172.27.227.184] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id y10sm21062240pfm.27.2019.05.13.19.51.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 19:51:56 -0700 (PDT)
Subject: Re: [PATCH RFC net-next] netlink: Add support for timestamping
 messages
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20190509155542.25494-1-dsahern@kernel.org>
 <20190509.095134.1780905261988048160.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bc050de1-a6fb-9669-e3c7-0901dfedd8d6@gmail.com>
Date:   Mon, 13 May 2019 20:51:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190509.095134.1780905261988048160.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/19 10:51 AM, David Miller wrote:
> From: David Ahern <dsahern@kernel.org>
> Date: Thu,  9 May 2019 08:55:42 -0700
> 
>> From: David Ahern <dsahern@gmail.com>
>>
>> Add support for timestamping netlink messages. If a socket wants a
>> timestamp, it is added when the skb clone is queued to the socket.
>>
>> Allow userspace to know the actual time an event happened. In a
>> busy system there can be a long lag between when the event happened
>> and when the message is read from the socket. Further, this allows
>> separate netlink sockets for various RTNLGRP's where the timestamp
>> can be used to sort the messages if needed.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> ---
>> one question I have is whether it would be better to add the timestamp
>> when the skb is created so it is the same for all sockets as opposed to
>> setting the time per socket.
> 
> If the importance is that the timestamp is when the "event" occurs
> then you should set it at skb creation time.
> 

The overhead of adding the timestamp is why I was thinking of setting it
based on a socket request.

If I defer setting the timestamp to do_one_broadcast only systems where
a process / socket wanting a timestamp takes the overhead and all
processes / sockets wanting the timestamp see the same the one. Seems
like a good trade-off. It is a very small time gap between the skb
allocation and do_one_broadcast.

Worst case scenario is a notification storm such as a huge route dump
into the kernel. Enabling the timestamp does have a measurable overhead
(~15% for a notification storm of ~240,000/sec). Given all of the other
improvements the end result is still a huge gain, but to defer the
overhead only to users who want it seems like the right thing to do.

