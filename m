Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7A41191DE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLJU1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:27:18 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46048 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJU1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:27:17 -0500
Received: by mail-qk1-f196.google.com with SMTP id x1so17549784qkl.12;
        Tue, 10 Dec 2019 12:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5V2NSfZgK4/Je85OyonRM0yBzGLQR7w5GuKR54sNbOU=;
        b=QkVXh212Ftcx8Y6fANY69Ji6EerkudvY1MO9aue92kDcP+/YpQHJgENTSdBNNVgMKJ
         tcLH15dEkZq9IdlW8t/iU8VEtXBf8Zg3qtsXRzg2Xy/IZs3PMiU3CTzB+MO5EGtUVHgs
         4nDmuqrVH/scWoP0NXSiaEQVF2YjdmUAVjEvxOepUksHZXPvzqyMGcQw9GwbHjm4xKoe
         vn9rPJ5av4Y99JhwU/jQc4vQtj4PxhXdC1yI9Yd6DJF/kd6C5ITzFbLFVzrRIURVcyjU
         T3wux1FKUvAOKuhKzsKfBSakZ0HBkIEzobRFO7RVinxb8KPqhIW7BmYg4dJdnMCm2ZWa
         w/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5V2NSfZgK4/Je85OyonRM0yBzGLQR7w5GuKR54sNbOU=;
        b=C9HR2nYEPbOJTaRLvoxbVTz9YufHBTV15hFZD2F1fEdLxdlBIt4BQMoVRejrsKoSwD
         N6+o+B56JTYIo4g3mMm7SQtg/uBe6jefXwVNk0t2v96lYviujZdiGddM44LJdaQz/CK/
         n1ZgWN7BK1TXj5Ic4Ixxb0DmmzKUjrxZPgC5X4e9yCgss8iYn83/+x2krjN4n+EghxiK
         2C6sfJnR3E5db2p1SoycjJAtBX9zcfSru2jGLV9hKk2vukQSyjKCYog8dc+treH4/8Qf
         6UUOAN0VuWeUXEbJOwqOOiADoeoHiERrQSkh+jXpcPU0E7PQI+zaItYQbJmxKdt9AgSw
         AVDA==
X-Gm-Message-State: APjAAAX+F2c1Gt1NtQkQ/kWCgJQEWGqcD4Kz+1WIf22EE+pZxBR/UIRI
        Msx5I10K5AtPNePhRvq/acaDdLN+
X-Google-Smtp-Source: APXvYqwOGFrAxPMqjGVV2dJtk7h9DKrcBSQ0NtzD9IQgVICnNlRvCnUqIZZ9I1lq5uWr9jpKvm5DZw==
X-Received: by 2002:a05:620a:21d4:: with SMTP id h20mr24469639qka.468.1576009636498;
        Tue, 10 Dec 2019 12:27:16 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:6903:116b:63ac:ff23? ([2601:282:800:fd80:6903:116b:63ac:ff23])
        by smtp.googlemail.com with ESMTPSA id b81sm1250595qkc.135.2019.12.10.12.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:27:15 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/5] rtnetlink: provide permanent hardware
 address in RTM_NEWLINK
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
References: <cover.1575982069.git.mkubecek@suse.cz>
 <7c28b1aa87436515de39e04206db36f6f374dc2f.1575982069.git.mkubecek@suse.cz>
 <20191210095105.1f0008f5@cakuba.netronome.com>
 <acd3947857e5be5340239cd49c8e2a51c283b884.camel@sipsolutions.net>
 <0c9148be76615b3b77a3e730df75f311b1001b9f.camel@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <513ce8a1-f3ee-bd5f-a27c-86729e0536fd@gmail.com>
Date:   Tue, 10 Dec 2019 13:27:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0c9148be76615b3b77a3e730df75f311b1001b9f.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 1:23 PM, Johannes Berg wrote:
> On Tue, 2019-12-10 at 21:22 +0100, Johannes Berg wrote:
>> On Tue, 2019-12-10 at 09:51 -0800, Jakub Kicinski wrote:
>>> On Tue, 10 Dec 2019 14:07:53 +0100 (CET), Michal Kubecek wrote:
>>>> @@ -1822,6 +1826,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>>>>  	[IFLA_PROP_LIST]	= { .type = NLA_NESTED },
>>>>  	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
>>>>  				    .len = ALTIFNAMSIZ - 1 },
>>>> +	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
>>>>  };
>>>>  
>>>>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
>>>
>>> Jiri, I just noticed ifla_policy didn't get strict_start_type set when
>>> ALT_IFNAME was added, should we add it in net? 🤔
>>
>> Does it need one? It shouldn't be used with
>> nla_parse_nested_deprecated(), and if it's used with nla_parse_nested()
>> then it doesn't matter?
> 
> No, wait. I misread, you said "when ALT_IFNAME was added" but somehow I
> managed to read "when it was added"...
> 
> So yeah, it should have one. Dunno about net, your call. I'd probably
> not bother for an NLA_REJECT attribute, there's little use including it
> anyway.
> 

It's new in net, so it has to be there not net-next.
