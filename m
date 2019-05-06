Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C33149FC
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 14:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfEFMlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 08:41:50 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35565 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfEFMlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 08:41:50 -0400
Received: by mail-qt1-f195.google.com with SMTP id d20so4373960qto.2
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 05:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sghhwrzz6aZkV/OLGqAmkBc0FTH7SZ0DXeH4FYURIcE=;
        b=AscO9wMjN9lm7t34UzSUH9pHLUAu4/Ocq/nm04cPBhxvkwqW9TytN+gFA8I6fDueV8
         MiuS4FPdmPJhxclQ14z1x7HuuG8WWo25fr4m7mp1clSsXFOkkr8hi9zkB8bHyO8WB7Sh
         8/1kFq7jJlTa5oZQii/dKFTt+rmBCC/bY7L6i9ugwebnLXEqYJRZWrw8TzZRJxGxjE2O
         /Omxr8ZwMrrc/mnv8N3jo5Shhhp+6EtUd8kaJ/+ik/9/lhWlH69TROQfKpr/Yzykb8OV
         m3057GfRq9VCz8bP3Z3C1M8PLREiHrbrhwJipIDk+yZv98C4pVZP1gNCN2l2qiLQUt0Q
         dZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sghhwrzz6aZkV/OLGqAmkBc0FTH7SZ0DXeH4FYURIcE=;
        b=abK4oRzkuEIQPkIswl1avcNxVliAoZf2fYYvhr+DmPxbU2FGdDIGlxoXjX9it0zcP3
         JxH0BNHkumFtx2zbjjk953PcfgTnqlUq41bGrDttW0IZNPIzl5sKqXdV4pN6Er75uNTA
         oQoNxyA9v2whV52cElOdhaUAPIgGkpGkK6RjrIOktjybfZIzWSS5c17IG1mMTtGu88rc
         KmDtfBQH+SYFOpH4toYC89XeyOezO8hSevxXInqzZF8kU0jwIYB6iK4zVOuvvAs9TixD
         159VPm5LFKeKZqF0K+4zLpCn+ocbv89ELePRpTJDvFn0hFnOrV3wSijNXbEqzyYInBuo
         aLTA==
X-Gm-Message-State: APjAAAVOt2p1/yDuBzRDCxUNwzFKkaNHpzUtDBUFVr3oXvrqkItC/Duy
        6LORA2noBrIEmseJhZcXeM+BdA==
X-Google-Smtp-Source: APXvYqz+UlSHllZE4TpPjlCHxM8muF+sjtZh20+hIxLWM0iUbJSsE1lvsOaau1u0RTGK4FRb/z7PbA==
X-Received: by 2002:ac8:1ae1:: with SMTP id h30mr20749012qtk.208.1557146509692;
        Mon, 06 May 2019 05:41:49 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id f1sm3996590qta.10.2019.05.06.05.41.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 05:41:48 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/3] flow_offload: restore ability to collect
 separate stats per action
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
 <20190504022759.64232fc0@cakuba.netronome.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <db827a95-1042-cf74-1378-8e2eac356e6d@mojatatu.com>
Date:   Mon, 6 May 2019 08:41:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504022759.64232fc0@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-04 2:27 a.m., Jakub Kicinski wrote:
> On Fri, 3 May 2019 16:06:55 +0100, Edward Cree wrote:
>> Introduce a new offload command TC_CLSFLOWER_STATS_BYINDEX, similar to
>>   the existing TC_CLSFLOWER_STATS but specifying an action_index (the
>>   tcfa_index of the action), which is called for each stats-having action
>>   on the rule.  Drivers should implement either, but not both, of these
>>   commands.

[..]
> 
> It feels a little strange to me to call the new stats updates from
> cls_flower, if we really want to support action sharing correctly.
> 
> Can RTM_GETACTION not be used to dump actions without dumping the
> classifiers?  If we dump from the classifiers wouldn't that lead to
> stale stats being returned?


Not sure about the staleness factor, but:
For efficiency reasons we certainly need the RTM_GETACTION approach
(as you stated above we dont need to dump all that classifier info if
all we want are stats). This becomes a big deal if you have a lot
of stats/rules.
But we also need to support the reference from the classifier rules,
if for no other reason, to support tc semantics.

If we are going to support RTM_GETACTION, then it is important to
note one caveat: tc uses the index as an identifier for the action;
meaning attributes + stats. You specify the index when i want to change
an attribute or optionally when you create an action,
or do a get attributes and stats.
Example, to change an existing skbedit to set attribute
skbmark of 10 instead of whatever existing value was there:

tc actions replace action skbedit mark 10 index 2

and to get the attributes + stats for a specific
action instance:

tc actions get action skbedit index 2

or dump for specific action type as such:

tc actions ls action police

Most H/W i have seen has a global indexed stats table which is
shared by different action types (droppers, accept, mirror etc).
The specific actions may also have their own tables which also
then refer to the 32 bit index used in the stats table[1].
So for this to work well, the action will need at minimal to have
two indices one that is used in hardware stats table
and another that is kernel mapped to identify the attributes. Of
course we'll need to have a skip_sw flag etc.

cheers,
jamal

[1] except for the policers/meters which tend have their own state
tables and often counters.
