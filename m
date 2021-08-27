Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9833F9D2E
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhH0RCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhH0RCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:02:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFEDC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 10:01:41 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m4so4351899pll.0
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 10:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dsw23o6USp2WfFifAs70U71OSapONXsxUpTycUHny6o=;
        b=rPY8O1Kp7mePHoH6GtdcKnBXt5SwN9f3rFc/Z1EIqhFQlt9gMjp7jvHWv/F7oadrIf
         Ix4ySwWH4xBi/JB40aqAelYr+0IFSA/FOm0XnP1EvHPej9GYM7RTPaef+ULk/n+m0icb
         Xc1hT9NFrbXPdLcPRjNHERPAVPlFgg94emw2RA2LIvp5FROxBrpJd3MSUb4c1cItLTJb
         uzmjp68Kq14QAWXRGzIUjrTqWuHrrE5gXA1V+G2qEY3QYlyzytqru1RP9rjCkRz9IEG1
         hlCqJ0SMYteIeWY7sgRy3y2qp0b93LGkOji+obBwPoUuHxqTD2hVteiER9qwkxPGzVDi
         2GaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dsw23o6USp2WfFifAs70U71OSapONXsxUpTycUHny6o=;
        b=Rrqg+I/xPV/gQGz8DvASRmVRqFEjdfvHClle+xPxLWXICzLkPBS0f2+oS2Lpfv4Haz
         FWiB7woz6mha/JGS80tNgaedqHOcFuaGmKQsUuyxpGsJu7RL1fSDEdNH2LwDJd5dfT8X
         7OA+05jQqkMUCBDnz98eGl3cvMstWHbLqRUGdJhK/sxiAKDnajeTkSrER0hPX/a2YYma
         zkoCxaIZWEC3Fw/zET3D+Vm3QadujzDDMftH6owGp2oWERMTwSeynRx+E0FDmQjBnJVX
         urp/zuwxRGAy9MZbk5yXnFW9kA/M/TP4DSQL1AUKOVoTU9UVOVcknjiscuN3t9GbNnYH
         QXSA==
X-Gm-Message-State: AOAM53022z63C8cT7m9BjMNyviHbk8mwUSyt/yX/Bzb1BlQQPOYbyhME
        fLwXNp21aIO7p7C06gl7Rzk=
X-Google-Smtp-Source: ABdhPJxawwDZCwO87KXVSfIUnjmZPtvAG/7h2qekoxXGQtvxJ2NPCrGxwPvA9z8XW1vUNGU0gyTf+g==
X-Received: by 2002:a17:90a:514a:: with SMTP id k10mr9264375pjm.46.1630083700902;
        Fri, 27 Aug 2021 10:01:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id s200sm3237095pfs.89.2021.08.27.10.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 10:01:40 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 01/17] ip: bridge: add support for
 mcast_vlan_snooping
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        Joachim Wiberg <troglobit@gmail.com>, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210826130533.149111-1-razor@blackwall.org>
 <20210826130533.149111-2-razor@blackwall.org>
 <20210826080851.1716e024@hermes.local>
 <3594d516-288c-d84e-83ec-91c5288b452c@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c5dcc86b-00e2-6970-334f-9f55ddb0fa17@gmail.com>
Date:   Fri, 27 Aug 2021 10:01:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3594d516-288c-d84e-83ec-91c5288b452c@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/21 8:11 AM, Nikolay Aleksandrov wrote:
> On 26/08/2021 18:08, Stephen Hemminger wrote:
>> On Thu, 26 Aug 2021 16:05:17 +0300
>> Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>
>>> +		} else if (matches(*argv, "mcast_vlan_snooping") == 0) {
>>> +			__u32 mcvl_bit = 1 << BR_BOOLOPT_MCAST_VLAN_SNOOPING;
>>
>> Using matches() is problematic.  since it will change how 'mcast' is
>> handled.
>>
>> Overall, bridge command (and rest of iproute2) needs to move
>> away from matches
>>
> 
> Sure, I can send a follow up if you don't mind to switch all matches calls. I used it
> to be in line with the current code.
> 

existing options need to stay using matches(); new options need to use
full strcmp().

