Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99201E5F8C
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 22:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfJZUeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 16:34:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38886 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfJZUeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 16:34:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id 22so5202923wms.3
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R2IEQI8wmc7enYmQAjJZtEINGxLW8D824oNE1nTCfU4=;
        b=fAMmZcKLYUeltmn49L6jfOCyQ/Opj5cCP6TVeqVEvTEHrIbxqOK2BKALtUurKJCg7s
         NgWLqvvkKycpRkDQJWq+/1vAtQBbCpEfxaCIlrEjQTCj7Bw4hi22ku1S6FqlgftSsHDA
         gA4evohgKmHpkywT1O1Jfdq8OvSw2aB6DQysXwwNuCGeV9qJ9AgN8CAzasbY4pANf2ll
         l56mrgiTQlfxmND2sAI0IPSpD732uBFoKEXxXNd7TlYi8HexnBgEcO2kSQQtpLKtSVWr
         vcaGhH3hJ3nC5kgn3cAUqqu5RHR+QseoeJ1oJTfWzshdYQoz/8nXPbyRq2UtqRwbKLVh
         g0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R2IEQI8wmc7enYmQAjJZtEINGxLW8D824oNE1nTCfU4=;
        b=ewCgo1zwo0m9xeRbMN0oE4VxbgbriSxftn0N3bUFNzXwvRBk5blzMNjAnJOHM8/iYz
         abHnAJ8iK5IUN0h8ebmE+Djuzjsf09Fkphc2ZnXipRORtmsoCsWo/McdvbBg01YOSp/i
         83W+qDuxeRvPr0z0kmeAa/eXaPvjFmb4fpLu+JcCZLyCHh875XxPDTmbMczClGIqo/ad
         DpQDKIXgdSNr6HBvG7XCG4QYaqzIgbwkH3UIKI9nIH6mYqbE2apI51gi+jfe7ei+fzln
         YGzstU8GeZAdeZewo+EatzrX7uW5STgw07PsakOWrAihofEMeAeSknu48z4i5OQ1VQv/
         Q8ew==
X-Gm-Message-State: APjAAAWsAJnBqJ89Xo8i5qq5oBxoWN2uY2t47CJuyTu5h+r4f+5TJU6a
        U+oJoMAJFib/Dy3cv113VIM=
X-Google-Smtp-Source: APXvYqxT9bZTqwrLtizgzjOuovq6ntB1B41EdVyNoFutCCpUomJ/2Lu1yNLzyWYtTmy0BKtmeZkhcA==
X-Received: by 2002:a05:600c:219:: with SMTP id 25mr8676044wmi.174.1572122040268;
        Sat, 26 Oct 2019 13:34:00 -0700 (PDT)
Received: from [10.230.7.147] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id 37sm10483601wrc.96.2019.10.26.13.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Oct 2019 13:33:59 -0700 (PDT)
Subject: Re: [PATCH net 2/2] net: mscc: ocelot: refuse to overwrite the port's
 native vlan
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, vivien.didelot@gmail.com,
        andrew@lunn.ch
References: <20191026180427.14039-1-olteanv@gmail.com>
 <20191026180427.14039-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5a0b7e8b-851e-2523-c6c1-da6fbd0c3dac@gmail.com>
Date:   Sat, 26 Oct 2019 13:33:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191026180427.14039-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/2019 11:04 AM, Vladimir Oltean wrote:
> The switch driver keeps a "vid" variable per port, which signifies _the_
> VLAN ID that is stripped on that port's egress (aka the native VLAN on a
> trunk port).
> 
> That is the way the hardware is designed (mostly). The port->vid is
> programmed into REW:PORT:PORT_VLAN_CFG:PORT_VID and the rewriter is told
> to send all traffic as tagged except the one having port->vid.
> 
> There exists a possibility of finer-grained egress untagging decisions:
> using the VCAP IS1 engine, one rule can be added to match every
> VLAN-tagged frame whose VLAN should be untagged, and set POP_CNT=1 as
> action. However, the IS1 can hold at most 512 entries, and the VLANs are
> in the order of 6 * 4096.
> 
> So the code is fine for now. But this sequence of commands:
> 
> $ bridge vlan add dev swp0 vid 1 pvid untagged
> $ bridge vlan add dev swp0 vid 2 untagged
> 
> makes untagged and pvid-tagged traffic be sent out of swp0 as tagged
> with VID 1, despite user's request.
> 
> Prevent that from happening. The user should temporarily remove the
> existing untagged VLAN (1 in this case), add it back as tagged, and then
> add the new untagged VLAN (2 in this case).>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

[snip]

> +	if (untagged && port->vid != vid) {
> +		if (port->vid) {
> +			dev_err(ocelot->dev,
> +				"Port already has a native VLAN: %d\n",
> +				port->vid);

This sounds like a extended netlink ack candidate for improving user
experience, but this should do for now.
-- 
Florian
