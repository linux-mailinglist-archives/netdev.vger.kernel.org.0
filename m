Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9718113CE6A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgAOU6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:58:25 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46741 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgAOU6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:58:25 -0500
Received: by mail-qk1-f196.google.com with SMTP id r14so17038766qke.13
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 12:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DFj9S/RciLvNGp51b1aXhlez64AQ5Souw8AWh8TXQNM=;
        b=PqYkKM2hxs2S6jdfRUU9pmrD/lEBrXwpq1DJVpyE0nFlWBB6iSjgNYVpXVberJ+tjV
         YjaLFrIsLh8SJfZiflTLzigkdpQyknaEZFaqKRzif91ET1QeBTIsjrNfTEYC9FkDQ1tK
         fI3e6TV0GYx9BKskYAqzWc43hbtoUtnNkJ5088EohmM15gikaT9aWnCTCv6p5I+YIoYP
         ITe0c5CCWGbdwC8XLPETsKVddZ/9cHwvQC5El3UnKt+1n17WQ87tSsBwyP6cZiM+KQiX
         s48ajK6hGiyzs5+tlAvtFzzDBHIHPSZrukaef+Q6TIHUnv1nvnw/ArYtbgJVpuDX4H/1
         MzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DFj9S/RciLvNGp51b1aXhlez64AQ5Souw8AWh8TXQNM=;
        b=BX6m0rkYiOlw+ecN+iJR3wgC0XLnKHKYiqrPDTvTXHymVno6NMqxZjxhT+nnoikl6U
         LWNL3/SVYiZXWvDMz42I+TTJkptuuFdJQxG/iKFZFRa/XwNwU2Tsx7LUB105t6H8o/ls
         /VexRjXaTFmJbIn7GmV41dDTTs5iS0QRUY1Rl4ualpNbFBXE1DE9LzscmM+zjhNdUdK6
         0vdo3jMe+wr1yssyaLLBDHSkvjQwOooDCIpt7RHPxnHg5P3ru43Mya5q5IdyxUM6UCQP
         hw7Y7K9KMWiWnJvLk43ux5WmxyYz8qxeWGXNoNEldWXRarAUk+YqTcjt9I7aE35EFNe1
         mT1g==
X-Gm-Message-State: APjAAAXSvQXhNZWLCN8ZvuJ5vl055w/MgDl0et8KmNqxV2ZpqeVK/tDH
        LTu1tX5fD4cPpW95zReoGns=
X-Google-Smtp-Source: APXvYqzuyrrtMYfhVibxV8BVD4D8Sfaket20/J0lzgns14oZ4tmx5zO9zygXAOxI5YcVpUJhIo2Ycg==
X-Received: by 2002:a37:a086:: with SMTP id j128mr24299483qke.459.1579121904548;
        Wed, 15 Jan 2020 12:58:24 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:b4a4:d30b:b000:b744? ([2601:282:800:7a:b4a4:d30b:b000:b744])
        by smtp.googlemail.com with ESMTPSA id 124sm8974280qko.11.2020.01.15.12.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 12:58:23 -0800 (PST)
Subject: Re: Expose bond_xmit_hash function
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho> <20200115143320.GA76932@unreal>
 <20200115164819.GX2131@nanopsycho>
 <b6ce5204-90ca-0095-a50b-a0306f61592d@gmail.com> <26054.1579111461@famine>
 <4c78b341-b518-2409-1a7a-1fc41c792480@gmail.com>
 <20200115204628.GZ2131@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e8258a8-c18a-f7d1-f4cc-20ca53030806@gmail.com>
Date:   Wed, 15 Jan 2020 13:58:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200115204628.GZ2131@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 1:46 PM, Jiri Pirko wrote:
> Wed, Jan 15, 2020 at 07:12:54PM CET, dsahern@gmail.com wrote:
>> On 1/15/20 11:04 AM, Jay Vosburgh wrote:
>>>
>>>> Something similar is needed for xdp and not necessarily tied to a
>>>> specific bond mode. Some time back I was using this as a prototype:
>>>>
>>>> https://github.com/dsahern/linux/commit/2714abc1e629613e3485b7aa860fa3096e273cb2
>>>>
>>>> It is incomplete, but shows the intent - exporting bond_egress_slave for
>>>> use by other code to take a bond device and return an egress leg.
>>>
>>> 	This seems much less awful, but would it make bonding a
>>> dependency on pretty much everything?
>>>
>>
>> The intent is to hide the bond details beyond the general "a bond has
>> multiple egress paths and we need to pick one". ie., all of the logic
>> and data structures are still private.
>>
>> Exporting the function for use by modules is the easy part.
>>
>> Making it accessible to core code (XDP) means ??? Obviously not a
>> concern when bond is built in but the usual case is a module. One
>> solution is to repeat the IPv6 stub format; not great from an indirect
>> call perspective. I have not followed the work on INDIRECT_CALL to know
>> if that mitigates the concern about the stub when bond is a module.
> 
> Why it can't be an ndo as I previously suggested in this thread? It is
> not specific to bond, others might like to fillup this ndo too (team,
> ovs, bridge).
> 

Sure, that is an option to try. I can not remember if I explored that
option previously; too much time has passed.
