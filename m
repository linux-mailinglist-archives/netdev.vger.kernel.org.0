Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69EA199733
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 15:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgCaNPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 09:15:34 -0400
Received: from mail.neratec.com ([46.140.151.2]:23880 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbgCaNPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 09:15:33 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2020 09:15:32 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id D7B51CE03CE;
        Tue, 31 Mar 2020 15:09:01 +0200 (CEST)
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZzAYA3UuuqJ2; Tue, 31 Mar 2020 15:09:01 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id B8876CE03D3;
        Tue, 31 Mar 2020 15:09:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at neratec.com
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YFUKjsHjKF95; Tue, 31 Mar 2020 15:09:01 +0200 (CEST)
Received: from [10.0.11.180] (asterix1.lan.neratec.com [172.29.100.2])
        by mail.neratec.com (Postfix) with ESMTPSA id 91F3FCE03CE;
        Tue, 31 Mar 2020 15:09:01 +0200 (CEST)
Subject: Re: A robust correct way to display local ip addresses of the device
 Gautieji x
To:     Vaidas BoQsc <vaidas.boqsc@gmail.com>, netdev@vger.kernel.org
References: <CAB+qc9CWOOTNruMhcAugmjhCne8a-FG9kk8X6ty8-Ss5CpKp5w@mail.gmail.com>
From:   Matthias May <matthias.may@neratec.com>
Message-ID: <9910386d-deec-720a-fb2c-7c8c5c6b1f3a@neratec.com>
Date:   Tue, 31 Mar 2020 15:08:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAB+qc9CWOOTNruMhcAugmjhCne8a-FG9kk8X6ty8-Ss5CpKp5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/2020 18:49, Vaidas BoQsc wrote:
> Are there any ways to output only the local ipv4 (inet) addresses of
> the device using ip command?
> 
> I tired this way and both UNKNOWN, Down are not filtered away. Is my
> usage of syntax incorrect?
> 
>  ip --brief address show up
> lo               UNKNOWN        127.0.0.1/8 ::1/128
> enp7s0           DOWN
> wlp8s0           UP             192.168.0.103/24 fe80::22c:79e4:a646:a7b/64
> 
>   Even so, if enp7s0 and lo were filtered, I would still want an
> output of simply 192.168.0.103 from ip command which can't be provided
> without piping into other tools?
> 

Hi

Is enp7s0 actually down, or does it just not plugged in?

Example:
ip -br l show wlan0
wlan0            DOWN           b6:91:7e:4e:94:01
<NO-CARRIER,BROADCAST,MULTICAST,UP>

wlan0 is UP, but has NO-CARRIER, resulting in a state of DOWN.


To filter out ipv6 results, simply only request ipv4:

ip -4 -br a show up

BR
Matthias
