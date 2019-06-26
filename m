Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A271256E56
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfFZQHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:07:33 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33014 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZQHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:07:32 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so1711613plo.0
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=FSm80DP9x2T2d+NSJfdEE1lGNqPX0kwHuWhpimm0dk8=;
        b=24uA97qdbMqcQG3UmtZ9hNIrG2PKEAa0HYG2gTL40belvdDnfAYA4ed1LLCAIKAsC0
         Wsmdxu+Cfw7jMypaBy3Mfa92xS7Ym72fL6kTIaBPP0nGFKp6OKhQ8u8OyVQ3NNkT6ucH
         Q16sQdImCHsGdFgfXt8ikoCfHwLqz5s2xXAPJ0qCZqFHX6dY9o4PvEkHphnU06lHttB8
         dFkoN6Ib2T5WO2m0dZPTXMnQn5zYaYdUG5+z2+6u/wHcxPnqdiyRyU0l30AVPvfBMV5S
         VBilyLNBSbmpPiNZIJeqk8d3oZ2JGUjnAmai4eg9NFI2iWKWiocLRdlfkrEBYpf2qtaG
         zJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FSm80DP9x2T2d+NSJfdEE1lGNqPX0kwHuWhpimm0dk8=;
        b=WB07Laty/ijb+iFdtc4CQ4vFyaWvAaMBueUo/BhATspgd48uQkBANgoBa1NvrisQK2
         /PaPsvgvRmZT3vBu5najzkoojXf2XCNOvFH+9AORL/OILcGTbU3uagk6YIhpMRmyil/m
         dFXXMfsR+JcDueFCQPSvIQuRqUVZvsWCdV2C46XFd04KCBJfTdyFECFxUqgUFz6bvzNT
         pRTfwFM4vZhcJmHAAlj+dCZSa3BPvmdSygLw+FykWHy2B4dYkoEs1PCpYGflmyrtylDG
         5uQLsI8auE8EFyczlownr4u9zqDnX+4GvtZhXNzuiZOvhJ9DiHmmCikg/sTfaAECyvsM
         sCig==
X-Gm-Message-State: APjAAAUCaLBb+tostGdkF5h2cT+HK0+cWLgqIYgzKyzr6bC6obMx+jSB
        3v83pNeejdX6XxbwGNmrMLrUJyEBaSg=
X-Google-Smtp-Source: APXvYqwlgtRz92n2b4lQ6LUR+3y9z/Qzze8Mtkh5Mf5qFfp0ZssU1uW84Aj+P21YoqmsdL5QC1OE1g==
X-Received: by 2002:a17:902:b215:: with SMTP id t21mr6412037plr.123.1561565251765;
        Wed, 26 Jun 2019 09:07:31 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e26sm19116014pfn.94.2019.06.26.09.07.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 09:07:31 -0700 (PDT)
Subject: Re: [PATCH net-next 13/18] ionic: Add initial ethtool support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-14-snelson@pensando.io>
 <20190625165412.0e1206ce@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4ffa2c70-9ae7-15eb-3b21-34148de89b44@pensando.io>
Date:   Wed, 26 Jun 2019 09:07:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625165412.0e1206ce@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 4:54 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:19 -0700, Shannon Nelson wrote:
>> +	running = test_bit(LIF_UP, lif->state);
>> +	if (running)
>> +		ionic_stop(netdev);
>> +
>> +	lif->ntxq_descs = ring->tx_pending;
>> +	lif->nrxq_descs = ring->rx_pending;
>> +
>> +	if (running)
>> +		ionic_open(netdev);
>> +	clear_bit(LIF_QUEUE_RESET, lif->state);
>> +	running = test_bit(LIF_UP, lif->state);
>> +	if (running)
>> +		ionic_stop(netdev);
>> +
>> +	lif->nxqs = ch->combined_count;
>> +
>> +	if (running)
>> +		ionic_open(netdev);
>> +	clear_bit(LIF_QUEUE_RESET, lif->state);
> I think we'd rather see the drivers allocate/reserve the resources
> first, and then perform the configuration once they are as sure as
> possible it will succeed :(  I'm not sure it's a hard requirement,
> but I think certainly it'd be nice in new drivers.
I think I know what you mean, but I suspect it depends upon which 
resources.  I think the point of the range checking already being done 
covers what the driver is pretty sure it can handle, as early on it went 
through some sizing work to figure out the max queues, interrupts, 
filters, etc.

If we're looking at memory resources, then it may be a little harder: 
should we try to allocate a whole new set of buffers before dropping 
what we have, straining memory resources even more, or do we try to 
extend or contract what we currently have, a little more complex 
depending on layout?

Interesting...

sln


