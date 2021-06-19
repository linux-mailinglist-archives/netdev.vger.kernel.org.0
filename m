Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB53AD9B9
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 13:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhFSLFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 07:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbhFSLFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 07:05:00 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6820C061574;
        Sat, 19 Jun 2021 04:02:48 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id u13so1937867lfk.2;
        Sat, 19 Jun 2021 04:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gh/qA823gv0wUZBQ9vSTS2qs/t2ngMR2CfJ3i7Nee+k=;
        b=qGvvmgl5w1yrnYggtooVweWGrVW8lInIgwxMc2pBs5cNptgsXJDQ+MMT+AklBGwtR+
         wsXZtarIjYAGh+qUcPNFgLDssnOPvxYKZrJgBtBFQ8ebO/c/97pzyQyQQve59K47AaKn
         hfL5GAseR7cNQESzteo0FrbJl60jAudILSAPJekKpU/gCyin3sa96dzU8sZV4ZkcVwL5
         KhjkMt7BVAwLAVtwpNxDsggR1X5Y9BW8K9d2+WhJjGJC/sGyvCdakA8bBarqcQAiKxJp
         vm69pBpsWW5dchkpxdevrVewxxkET3WGfhAAirLwUK+eYy347A/X6JyEO0kuIH61zbt8
         wEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gh/qA823gv0wUZBQ9vSTS2qs/t2ngMR2CfJ3i7Nee+k=;
        b=k2dmGLEFRbBucaDqlLs+McOYtIYCzEqtdC4+w1iS2jsn3zESAesWq6TbC3EeycXcE5
         WAQsdpgzAhbwcqdj+8NH6M+JtyxkfxF3a6UBOyr5Krecsmfy8H28ZTU01wxxtp8Yrqzo
         t2Fn9ezVEkJqwR0oMcfQ8e5IqoprELIm6LTdOj+/UPfDDUPzyQRMFtu9rIKoq5rtQd9r
         phQo5d9MZZx9b2PrlxeaSqxVKijT9ThILldc3D89xXfhbYwxC+tLWHOJpIMhlGVk9/6y
         IbMOkRM7YAMUMLSLBvpb6Awz93BKxJUE0zQQn2rMsNiFEzIrgPqQoR+CQA3wqT9zt9JB
         aYtg==
X-Gm-Message-State: AOAM531QBfhqo2YEvfLxAq037+U96HTG5hdED6iy4OzlgPfThFKzYdQv
        6q5EPpVWavqHewbp5QC1l7E=
X-Google-Smtp-Source: ABdhPJxYj+ZMaQFtctcc7+90N+CUnJOs0pnsPQZIqjJkIQb5K50AFerTOXUCVJuhEpMPxxj+vmbGqg==
X-Received: by 2002:a05:6512:239d:: with SMTP id c29mr6683514lfv.248.1624100567125;
        Sat, 19 Jun 2021 04:02:47 -0700 (PDT)
Received: from [192.168.2.145] (94-29-29-31.dynamic.spd-mgts.ru. [94.29.29.31])
        by smtp.googlemail.com with ESMTPSA id l5sm1306915lfc.250.2021.06.19.04.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Jun 2021 04:02:46 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] cfg80211: Add wiphy_info_once()
To:     Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210511211549.30571-1-digetx@gmail.com>
 <e7495304-d62c-fd20-fab3-3930735f2076@gmail.com>
 <87r1gyid39.fsf@codeaurora.org>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <46a3cb5a-2ce3-997b-154d-dd4e1b7333d1@gmail.com>
Date:   Sat, 19 Jun 2021 14:02:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87r1gyid39.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

19.06.2021 09:27, Kalle Valo пишет:
> Dmitry Osipenko <digetx@gmail.com> writes:
> 
>> 12.05.2021 00:15, Dmitry Osipenko пишет:
>>> Add wiphy_info_once() helper that prints info message only once.
>>>
>>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>>> ---
>>>
>>> Changelog:
>>>
>>> v2: - New patch added in v2.
>>>
>>>  include/net/cfg80211.h | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>>> index 5224f885a99a..3b19e03509b3 100644
>>> --- a/include/net/cfg80211.h
>>> +++ b/include/net/cfg80211.h
>>> @@ -8154,6 +8154,8 @@ bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
>>>  	dev_notice(&(wiphy)->dev, format, ##args)
>>>  #define wiphy_info(wiphy, format, args...)			\
>>>  	dev_info(&(wiphy)->dev, format, ##args)
>>> +#define wiphy_info_once(wiphy, format, args...)			\
>>> +	dev_info_once(&(wiphy)->dev, format, ##args)
>>>  
>>>  #define wiphy_err_ratelimited(wiphy, format, args...)		\
>>>  	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
>>>
>>
>> Ping?
>>
>> Arend, is this series good to you? I assume Kalle could pick it up if
>> you'll give ack. Thanks in advance.
> 
> Normally cfg80211 changes go via Johannes' tree though I guess small
> changes I could take it via my tree, but then I need an ack from
> Johannes.
> 

Thank you for the clarification.

Johannes, are these patches good to you?
