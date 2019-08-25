Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4F39C490
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 17:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfHYPBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 11:01:02 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33826 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfHYPBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 11:01:02 -0400
Received: by mail-oi1-f196.google.com with SMTP id g128so10373095oib.1
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 08:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7NEiahcfaYYEnR9bcdun4PUIt9eR+PCrMR5gxrzflLI=;
        b=FHjTeemnI36XkdKFZFJJd08PFHe3PDNdMbC1t41jFGo/IfLpshpzYf9N6y9685s/2C
         rLjlE0seLnnx/UEBDznoXZZfD0yTTBQNZdme5nAF8LZQPLUZxYrDziLkNg277dchAO5h
         2HYKz6imy88BUWyhEsGt3Fk7tZiYJdAcOKzXc8dGgkDZCL9is/SY3zmyR3I4fiMA2zf3
         tjTxQiic2hq1J2htGCzYE9ubEL+ZbLFF7hgWLjpRdxH4tHtq7mAUuncpuSa+HSZcUrRo
         IeuDmi1wBRGwbcC5xoetdgfTzsNJ5JRGeyjRuL4WyfKbjXwEKSpihBiWaIQcVY+2QIgn
         nYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7NEiahcfaYYEnR9bcdun4PUIt9eR+PCrMR5gxrzflLI=;
        b=GLcwX6gsXRfhJHhtHrKnVzbE/skMUcc7psPf2aLYlN2FHg1xKH4fnF9f7WWfQmZ+px
         hNdK0F8is5zqYTOvj6cREsmiZOtp+3tMQmAlfdzOqiUfVY1/LEFrxnjHm1YU5ELynyKD
         AvdubtgC8ZrMpfe9jxYdZfauydpu1KSEDCYFr2rBJ9Qeg4qlDMWtfUklu2lFse/4rsMx
         H0/dCi9D7RpF5u9RMdjnRLjSiGRJhxLwd0INJLhyfii4/EyYUNUOrhuuEnEgP67fQsXn
         WZKSfM+fnbokw9HGyC66u7qExw9AXQnTZLpYrvcuCqf9DFfSAY9MM6tWxZZfxN/kLTcc
         v5Vw==
X-Gm-Message-State: APjAAAWdHpDnBME2nZWpN+X8YsHOmezfiDFgOdve8B6AAQ1bMnZkRn3E
        Olfu5Lom5t2fBptyA7fEZKLuQmvk
X-Google-Smtp-Source: APXvYqwaaOgb9tyco2S8UWY1XxPbXoPUEr++BErcDAiCvqbiURR03rtrbxkLoOStsY8Fk+WaLmvOtw==
X-Received: by 2002:aca:b603:: with SMTP id g3mr9690113oif.170.1566745261369;
        Sun, 25 Aug 2019 08:01:01 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u5sm2542240oic.45.2019.08.25.08.00.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 08:01:00 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Chris Healy <cphealy@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20190824024251.4542-1-marek.behun@nic.cz>
 <a7fed8ab-60f3-a30c-5634-fd89e4daf44d@gmail.com>
 <20190825091337.236ee73a@nic.cz>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8ddb13ff-5d5b-f71e-8392-3678c4860199@gmail.com>
Date:   Sun, 25 Aug 2019 08:00:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190825091337.236ee73a@nic.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/2019 12:13 AM, Marek Behun wrote:
> On Sat, 24 Aug 2019 13:04:04 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
>> Now, the 4.9 kernel behavior actually works just fine because eth1 is
>> not a special interface, so no tagging is expected, and "wifi", although
>> it supports DSA tagging, represents another side of the CPU/host network
>> stack, so you never have to inject frames into the switch, because you
>> can use eth1 to do that and let MAC learning do its job to forward to
>> the correct port of the switch.
> 
> Hi Florian,
> 
> Sorry, I am having trouble understanding what you mean in the
> paragraph I quoted above (and paragraphs afterwards).
> 
> eth0 and eth1 are interfaces created by an ethernet driver.
> wlan0 is an interface created by wireless driver.
> wifi is a slave interface created by DSA for port 5 on the switch.
> eth1 is DSA slave or a DSA master connected to port 5?

"wifi" is a DSA slave network interface, and as you understood, eth1 is
a standard Ethernet driver (which happens to be the same as eth0, since
on that system there are two identical controllers, driver is
bcmsysport.c). The relevant part of the DTS for that system looks like this:

port@5 {
	reg = <5>;
	label = "wifi";
	ethernet = <&enet_1>;
};

port@8 {
	reg = <8>;
	label = "cpu";
	ethernet = <&enet_0>;
};

So as you can see, the devices are all described correctly, simply the
behavior on the Linux change changes whether you have commit
6d4e5c570c2d66c806ecc6bd851fcf881fe8a38e ("net: dsa: get port type at
parse time") included or not. With this commit, the criteria for
determining what is a DSA/CPU port changed: it used to be based on the
label (e.g.: "cpu", "dsa") and then it changed to be based on whether a
phandle property is either "ethernet" (port is CPU) or "link" (port is
DSA), which is the right thing to do, but it no longer allows us to be
specific about which port is going to be elected as the CPU port.
Fortunately the switch driver is coded with the assumption that either
port 5 or 8 could be used.

Note that when we do not have a network device that represents the
switch"side (e.g.: the CPU port or the DSA port), we had to jump through
many hoops in order to make some information visible to the user, or
even overlay specific operations onto the DSA master, that code is under
net/dsa/master.c.

> 
> How does DSA handle two interfaces with same reg property?

This is not happening, see DTS example above.
-- 
Florian
