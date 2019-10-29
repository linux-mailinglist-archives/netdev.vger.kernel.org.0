Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8B1E8E17
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfJ2R3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:29:24 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36148 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfJ2R3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:29:23 -0400
Received: by mail-ed1-f66.google.com with SMTP id bm15so11395454edb.3
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 10:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=InKFbvD0px/g8dMpbilYBgPtyAvwKrDpGEcYIAOth54=;
        b=j57caUNW//CPVBr4nV11snKZG2Z5L1Y1EqN5aAiHx6YRmSYqPFtLl88R2cCozNVGCK
         np74zyz1CuOBUyiFhwRg9crXWnNTNqNISwKIgo4gTuazFEhCTZkQHWO4hXWfUqruyJwb
         vvo2LXGY8Q3QI3PZdPuzJ/ooMobhiN5i8PjADtbfLoPMFsPkocmKtdl0PToZ0KIBOX6o
         D+ioYRm0KGa027KDtJpDKXo6/n4boNTi7KcvHUHi9DwS4Yh22xJHDQXxP3K851bfC7J0
         XejdvyNgWm9BHgeM163ne0DBbH89IGhmiNequW1S/JGf2hSDWQyqaa9ZBXbZ+i9wnzEm
         arDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=InKFbvD0px/g8dMpbilYBgPtyAvwKrDpGEcYIAOth54=;
        b=DGnk+TT5wtIqgzdwyDTACTHOiiFHOo0q8bYyCiaFse9NVIQQ4NN97tUfZSsQnuMCBS
         5J13LXL5ZQrxvUPL7/fMZf5tySitC2IYFnqCy2aPCALlNPROVylWGKW2eA3/x/ECX1DH
         OmN1Ra6IVoLEJXUlm/VkFh4fWHsSSMj/6BnSQS5OZCgC7b35CLGyTRFZEbwTSnp1VPx6
         o26j8xxNHEKoNIY66h1nRdR8bnf4iKP8MixdcOSDQMYvSr/W5uxxVafXkBk3qPlFdIr0
         TSUsQWigW09XDxrwNo1PKjPLODpGLdleinj8+Elw+Nn0meuBq5nqcJnkfEoQ6iAnf923
         sWkA==
X-Gm-Message-State: APjAAAUXqFKxtVn60MQq3zyeN9nKFcTlv+iVJDPbewag/v7XI8Pshogn
        YyaUghx/nZeSvDPPcxJ/5bc=
X-Google-Smtp-Source: APXvYqxmFaM09mpgrypnHcT3zrXLAtJHNFfC30COKJPFiryreLeahwsy1UG4Ow6EVOh16BllLbYypQ==
X-Received: by 2002:a05:6402:60d:: with SMTP id n13mr25800838edv.218.1572369819537;
        Tue, 29 Oct 2019 10:23:39 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p20sm673902edt.63.2019.10.29.10.23.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 10:23:38 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: Add ability to elect CPU port
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20191028223236.31642-1-f.fainelli@gmail.com>
 <20191028223236.31642-2-f.fainelli@gmail.com>
 <20191029013938.GG15259@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <21f28a95-9eea-19b4-fee9-c9f436bf2416@gmail.com>
Date:   Tue, 29 Oct 2019 10:23:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029013938.GG15259@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 10/28/19 6:39 PM, Andrew Lunn wrote:
> On Mon, Oct 28, 2019 at 03:32:35PM -0700, Florian Fainelli wrote:
>> In a configuration where multiple CPU ports are declared within the
>> platform configuration, it may be desirable to make sure that a
>> particular CPU port gets used. This is particularly true for Broadcom
>> switch that are fairly flexible to some extent in which port can be the
>> CPU port, yet will be more featureful if port 8 is elected.
> 
>> -static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
>> +static struct dsa_port *dsa_tree_find_cpu(struct dsa_switch_tree *dst)
>>  {
>> +	struct dsa_switch *ds;
>>  	struct dsa_port *dp;
>> +	int err;
>>  
>> -	list_for_each_entry(dp, &dst->ports, list)
>> -		if (dsa_port_is_cpu(dp))
>> +	list_for_each_entry(dp, &dst->ports, list) {
>> +		ds = dp->ds;
>> +		if (!dsa_port_is_cpu(dp))
>> +			continue;
>> +
>> +		if (!ds->ops->elect_cpu_port)
>>  			return dp;
>>  
>> +		err = ds->ops->elect_cpu_port(ds, dp->index);
>> +		if (err == 0)
>> +			return dp;
>> +	}
>> +
>>  	return NULL;
>>  }
> 
> Hi Florian
> 
> I think is_preferred_cpu_port() would be a better name, and maybe a
> bool?
> 
> Also, i don't think we should be returning NULL at the end like
> this. If the device tree does not have the preferred port as CPU port,
> we should use dsa_tree_find_cpu() to pick one of the actually offered
> CPU ports in DT? It sounds like your hardware will still work if any
> port is used as the CPU port.

It would indeed work, although most likely in a degraded mode, so not a
great fit usually.

> 
> And maybe we need a is_valid_cpu_port()? Some of the chipsets only
> have a subset which can be CPU ports, the hardware is not as flexible.
> The core can then validate the CPU port really is valid, rather than
> the driver, e.g. qca8k, validating the CPU port in setup() and
> returning an error.

Initially I had added a port_validate() function and had it be called
from dsa_switch_parse_ports_of() and dsa_switch_parse_ports() such that
the driver could check whether the port type (DSA, USER, CPU) was valid
and return 0, an error or -EAGAIN if the CPU port was not the preferred one.

Later on, I did introduce is_preferred_cpu_port() returning a bool, but
thought this was too long of a name and went for elect_cpu_port which is
not really an election process.... Now you know my thought process :)

Let me sleep on it a bit, maybe coming back with the port_validate()
approach is the most flexible/capable solution.
-- 
Florian
