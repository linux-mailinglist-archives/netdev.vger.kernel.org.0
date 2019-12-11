Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA7611BAA2
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfLKRwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:52:16 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36429 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLKRwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:52:15 -0500
Received: by mail-qk1-f195.google.com with SMTP id a203so10281603qkc.3
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ubp3/NrxVrJDDtINPT/a+hSSHV009gNRw3e+lHCd4oY=;
        b=adF+8L7mmMBGdqyqkZBGV8RAolhwtRT5MJi4XDmC8JyA8Yg8inVH0VjA4+ybu3zuaD
         1YPKdhK+8TfZ21msXx/JrHJa/+FOMpe6ZHowJnPpMiVEFSELDusxa6vxPZ9suWp6ClwP
         dXFHuz7vx5/nuyiNDPSgh1Kej8iUiQfpEZQD7ERKOfRWjXQ4IvUx6l7f7s0txHNsoTOa
         3+z6D71MHNEI9LhwOrOUmQ61WOJVpur20xLEAQ+byoIIciBwc39Ufh2C4OREUXgfoMUO
         RiqJrC/I+c1n8zoKloIhfhQaag1XQJtj6cRBTGH6GyB7aTBCs0jCK4akIz8ST56b+TcQ
         SwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ubp3/NrxVrJDDtINPT/a+hSSHV009gNRw3e+lHCd4oY=;
        b=DDpuGTd/7j7aYwUGpwGbtiEDdOFOTMLWVx1nrCJ/Pz3aZV3C7NFzyINTMBVh8An3hQ
         qQvISg0YZicg9tAn2ePP8Q8lZ705E5T/ZOUC3/xlYLuUiRp1too5/lVdL8aXRNsUGm3B
         ePfVSIrKYw4is8ayYSYuoMOrJ4Sct4M1MQ6lPEs4sBaJyeJ2RcujZgzLXXdeTY7cFU5c
         JZvu3olI8DzEvormJ3k+8Xx2akeQWciHSjjwEZOTQp+fqlW4rHdvWbef+bbRdUG40Kl8
         M0RLETLu2UEquawyKIRjnhOab+i60W1DzzYDsBWJ7kEsa0hJa1h2g55gcATkvg9T2yZ/
         98Kw==
X-Gm-Message-State: APjAAAV2uv48k9zhEhLxHDySeDMTM3tlMlU2gx22X3fxxe6OmWEg7bUA
        dvzFcJLp1tfVRlHMTxqbDUNv7pbmdj0=
X-Google-Smtp-Source: APXvYqxwtDZIYKpeCCgpCG/KZEMH/FJzehi/GamT4BgWCVomBxb+NdvAgHecKnrloCvhBTfBKASCuw==
X-Received: by 2002:a37:9a46:: with SMTP id c67mr4205650qke.308.1576086734822;
        Wed, 11 Dec 2019 09:52:14 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id f2sm1144098qtm.55.2019.12.11.09.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:52:14 -0800 (PST)
Subject: Re: [PATCH net-next 6/9] ipv4: Handle route deletion notification
 during flush
From:   David Ahern <dsahern@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-7-idosch@idosch.org>
 <7ad891f6-a096-2795-2e7f-5eefc710503b@gmail.com>
Message-ID: <87294c71-3e2d-f45b-43c1-87b233cb8672@gmail.com>
Date:   Wed, 11 Dec 2019 10:52:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7ad891f6-a096-2795-2e7f-5eefc710503b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/19 10:46 AM, David Ahern wrote:
> On 12/10/19 10:23 AM, Ido Schimmel wrote:
>> From: Ido Schimmel <idosch@mellanox.com>
>>
>> In a similar fashion to previous patch, when a route is deleted as part
>> of table flushing, promote the next route in the list, if exists.
>> Otherwise, simply emit a delete notification.
> 
> I am not following your point on a flush. If all routes are getting
> deleted, why do you need to promote the next one in the list?

never mind. I see. The second notifier gets deleted in patch 9 and the
new notifier is needed to remove the offloaded route.

> 
>>
>> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>> ---
>>  net/ipv4/fib_trie.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
>> index 2d338469d4f2..60947a44d363 100644
>> --- a/net/ipv4/fib_trie.c
>> +++ b/net/ipv4/fib_trie.c
>> @@ -1995,6 +1995,8 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
>>  				continue;
>>  			}
>>  
>> +			fib_notify_alias_delete(net, n->key, &n->leaf, fa,
>> +						NULL);
>>  			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL,
>>  						 n->key,
>>  						 KEYLENGTH - fa->fa_slen, fa,
>>
> 

