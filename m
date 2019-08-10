Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7A2888D4
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 08:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbfHJGaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 02:30:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51974 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfHJGav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 02:30:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so7640880wma.1
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 23:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yf+BYqjqU2x7MCFIER55ri5yMvJNE0jGjKEGHcGA1iM=;
        b=jU0iKciN6WWNsQu33hlF8QJQfQ9R4c2V6mqB7ywwHgUJnxCaWdKjd/uFz5ss5BHwPc
         GvYFgDdSlUVC3lAnUlrZpn8W0XxLa6doMtQL9i3Nlu/WSVVcJ0eu5q9sfxT2dvDGiPA6
         aZUOb8BhOITMaHi1XkkYbeXr3WkRY8kQ3uitiYQWa6DfgNML1ef7tzYSU2wtcHvxYHKF
         Bv/mF1KGsSw1OpyGM+m1TVc8KCqp/DJv6YNa6PpXOAVVebyEt5X5n+ImtJI7TNzRSJ89
         FbIpkqMCnGM7X+S9lA4t+Dt/MPQvnmorrP0xKhY7ktmB0vWYsR4tNmjTj1qyf4+31/9n
         5BbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yf+BYqjqU2x7MCFIER55ri5yMvJNE0jGjKEGHcGA1iM=;
        b=pN+HTPvgIMCCB1TNtjNVAquK1O56LknTEBJzsRvPcZaCxUtPmvqidqPmNxx8amODSS
         fwNQLfX4Ocd8bsm7hgmndygWFsk3gx1rjTCSwLlkkw7Qjz6gGXU/EEZsM5zl9/TgtVLe
         myOxkDYDM17uSyqExJxZhayQyqzvkzJyTfm01L6hEBCUVILgtuQImyly6jaN9TvZy3mc
         KS4bE7ZSZ7GIMEu3SCC7OjPACPF7XhAzGjLsTzHnM0s7GymWXjyFPxtUFJxH4qMXU4J+
         8uU8hg4V1MXfckOztr9JwD/R+Tkj6eR3MIwulK/3SP/lyWwXEF1/Sw97b18wpwuZ75FI
         uYPw==
X-Gm-Message-State: APjAAAXJckrsgQCd3ZT1xp8EyVeKhpKCfoWZHGcWeptGqWI4jCfGeMhn
        8DlMcBZHLHdslwIhaNK973Gl8A==
X-Google-Smtp-Source: APXvYqwYws9Olt//FFFuYZlB3+oZzVbaXiwWtftXg/BE3OzXv2vrF0QZC3KfoPiC4sFwbgYOv54ZJA==
X-Received: by 2002:a05:600c:2486:: with SMTP id 6mr15760724wms.80.1565418649100;
        Fri, 09 Aug 2019 23:30:49 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r11sm153897692wre.14.2019.08.09.23.30.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 23:30:48 -0700 (PDT)
Date:   Sat, 10 Aug 2019 08:30:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190810063047.GC2344@nanopsycho.orion>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 09, 2019 at 06:14:03PM CEST, dsahern@gmail.com wrote:
>On 8/9/19 9:40 AM, Roopa Prabhu wrote:
>>>>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>>>>> index ce2a623abb75..b36cfd83eb76 100644
>>>>> --- a/include/uapi/linux/rtnetlink.h
>>>>> +++ b/include/uapi/linux/rtnetlink.h
>>>>> @@ -164,6 +164,13 @@ enum {
>>>>>         RTM_GETNEXTHOP,
>>>>>  #define RTM_GETNEXTHOP RTM_GETNEXTHOP
>>>>>
>>>>> +       RTM_NEWALTIFNAME = 108,
>>>>> +#define RTM_NEWALTIFNAME       RTM_NEWALTIFNAME
>>>>> +       RTM_DELALTIFNAME,
>>>>> +#define RTM_DELALTIFNAME       RTM_DELALTIFNAME
>>>>> +       RTM_GETALTIFNAME,
>>>>> +#define RTM_GETALTIFNAME       RTM_GETALTIFNAME
>>>>> +
>>>>
>>>> I might have missed the prior discussion, why do we need new commands
>>>> ?. can't this simply be part of RTM_*LINK and we use RTM_SETLINK to
>>>> set alternate names ?
>>>
>>> How? This is to add/remove. How do you suggest to to add/remove by
>>> setlink?
>> 
>> to that point, I am also not sure why we have a new API For multiple
>> names. I mean why support more than two names  (existing old name and
>> a new name to remove the length limitation) ?
>> 
>> Your patch series addresses a very important problem (we run into this
>> limitation all  the time and its hard to explain it to network
>> operators) and
>>  its already unfortunate that we have to have more than one name
>> because we cannot resize the existing one.
>> 
>> The best we can do for simpler transition/management from user-space
>> is to keep the api simple..
>> ie keep it close to the management of existing link attributes. Hence
>> the question.
>> 
>> I assumed this would be like alias. A single new field that can be
>> referenced in lieu of the old one.
>> 
>> Your series is very useful to many of us...but when i think about
>> changing our network manager to accommodate this, I am worried about
>> how many apps will have to change.
>> I agree they have to change regardless but now they will have to
>> listen to yet another notification and msg format for names ?
>> 
>> (apologies for joining the thread late and if i missed prior discussion on this)
>
>I agree with Roopa. I do not understand why new RTM commands are needed.
>The existing IFLA + ifinfomsg struct give more than enough ways to id
>the device for adding / deleting an alternate name.
>

Could you please write me an example message of add/remove?
