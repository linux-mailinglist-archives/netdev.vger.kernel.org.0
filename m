Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3B72F570F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbhAMXkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 18:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbhAMXjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 18:39:02 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175DBC061387
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 15:37:56 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q7so2516853pgm.5
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 15:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AI12kr2kbrnosYqAp7Ou40PS7r3dfJdjZdvvQmllJHw=;
        b=lVdgswEwvFQHtthUfZ4ru/47H24kZhTGoLjaB9g2YWXUt+bl0cQLXn+3CopkRH7zw2
         cV75M9I+8XdGjR09zgAOkQ8woKHS4Z30yvkO6CS5pW7v8/BdB2HMDpcLFQpSb7D8hpCy
         OeHAVMjozFNionT+U3WMcFMZt21PdOHtMeAtFnR8wkVyeFYdfobfd0KQfes70mrq0KME
         NRMQ68huFC5EYoJn1otkATtDkRIP2b2EgicDtSLqoFPyL4F/u+qCy6lEk3T7fqnxL9DT
         aGsmLGfMZN6ts2Hxnw0sJalbq76kvtOPAdu3rUcvQ03aKc8Niq6NC/P3dEaQZsFJQBoH
         JvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AI12kr2kbrnosYqAp7Ou40PS7r3dfJdjZdvvQmllJHw=;
        b=JimPKHhBxKPv6Id1OuFW4FFnkIZLnNB030WAJQAWXj69H7cl+ZNrPwFqUfWCSQveKH
         +HOsLX6CxWXdlhT4WChy+63ySie0/h/b24/FkttJKHemirsIyeprMgecsvt6s9kULRQd
         2gIg6/9pvqi4sfnNP+rmVuLvCzGe/TELJB0emf9cB+jJnKOqni2nXxqRDvlNIQfRjrC/
         ax82LGNy+oh7s20ykBhRde+z2IMEcqsMYwqDyFOyWPOnOegixEMErDFe9Tz5ZNlrqV4c
         pVkgDwGfLxu+nKB8ioXjmkpB7xcfv9AgQhkMngyCLxQEc+dNi5qbpIumObw/V0+/Unvp
         xPxQ==
X-Gm-Message-State: AOAM531Mw8RwVFtf0VCiAjs/k7X71Z0Lql/V6Pj8RuYxqLBvTJ5zydPT
        JRgyzAorCfQs0N0dd8d9sfk=
X-Google-Smtp-Source: ABdhPJzQHhe1TYNDJMKXzjBoqYtW6oNNeyj1z3iwiazxlAJGVh/tzbwKyf87MIkdB3cF6u8Ii+mtkA==
X-Received: by 2002:a63:f21:: with SMTP id e33mr4609149pgl.84.1610581075512;
        Wed, 13 Jan 2021 15:37:55 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b5sm3518224pfi.1.2021.01.13.15.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 15:37:54 -0800 (PST)
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: felix: offload port priority
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, vivien.didelot@gmail.com
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-3-olteanv@gmail.com> <X/+D+2AgnOqCxb2d@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <62d9811f-93e4-9d9b-c159-76c35fa919dc@gmail.com>
Date:   Wed, 13 Jan 2021 15:37:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X/+D+2AgnOqCxb2d@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/21 3:36 PM, Andrew Lunn wrote:
> On Wed, Jan 13, 2021 at 05:41:39PM +0200, Vladimir Oltean wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> Even though we should really share the implementation with the ocelot
>> switchdev driver, that one needs a little bit of rework first, since its
>> struct ocelot_port_tc only supports one tc matchall action at a time,
>> which at the moment is used for port policers. Whereas DSA keeps a list
>> of port-based actions in struct dsa_slave_priv::mall_tc_list, so it is
>> much more easily extensible. It is too tempting to add the implementation
>> for the port priority directly in Felix at the moment, which is what we
>> do.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
>>  drivers/net/dsa/ocelot/felix.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
>> index 768a74dc462a..5cc42c3aaf0d 100644
>> --- a/drivers/net/dsa/ocelot/felix.c
>> +++ b/drivers/net/dsa/ocelot/felix.c
>> @@ -739,6 +739,20 @@ static void felix_port_policer_del(struct dsa_switch *ds, int port)
>>  	ocelot_port_policer_del(ocelot, port);
>>  }
>>  
>> +static int felix_port_priority_set(struct dsa_switch *ds, int port,
>> +				   struct dsa_mall_skbedit_tc_entry *skbedit)
>> +{
>> +	struct ocelot *ocelot = ds->priv;
>> +
>> +	ocelot_rmw_gix(ocelot,
>> +		       ANA_PORT_QOS_CFG_QOS_DEFAULT_VAL(skbedit->priority),
> 
> No range check? Seems like -ERANGE or similar would help avoid
> surprises when somebody asks for an unsupported priority and it gets
> masked to something much lower.

You are passing the whole dsa_mall_skbedit_tc_entry  structure here,
only to look up priority, would it make sense for now to pass
skbedit->priority as a parameter which would be matching the function
name and what it is dealing with?
-- 
Florian
