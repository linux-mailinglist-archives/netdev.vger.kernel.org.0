Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FE42CA30E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 13:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389764AbgLAMp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 07:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387954AbgLAMp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 07:45:57 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F8BC0613CF;
        Tue,  1 Dec 2020 04:45:17 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id s63so1133282pgc.8;
        Tue, 01 Dec 2020 04:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=53kDEnlsh13Z85puqPboHlYJLbfO6mVTguHutgRzSPI=;
        b=o0AtWHy1elaaoHCmrTegNbpoT978znZOhsqU6K04KilksR8bbbtfv2abioxxxfNVuk
         Cmq2Wd3IDxp9XKEp4Iw5i9r8KYprutNYj424cBciU0FsUTWrNtvL73QUZTdS/UDaaMKG
         ftv51vX1HrrbWofv4vNGGDYAUM4TgJOHYQgm/pacT2m+k1zpuzBo1twtzHVhg+Arw0ic
         ivfUsd2bgrvOTWeXB11ADfT1ZPrEZu18M/nWRC279YgYRbNwFLGEtHh35arl7D7Brfa0
         x2pkxE2dXkiU8aSlHDHiFtA5YvkcC4x+vWy+UqEQzdRDa1XFLj9Qyy/5wiBthst3qPbw
         rSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=53kDEnlsh13Z85puqPboHlYJLbfO6mVTguHutgRzSPI=;
        b=Z/K4e2ILRTOfA8f2z4O62wXmcridFXm/b/4ZtmgL2iemvvT5JQfnG/iV72IdoYqyn3
         XnfL2XcjDUgJgjfZ7ke8GrvDHaq2AEdFHFWm/2REZRl5DX/sN/GKUk8peXD2IYrSzSQQ
         b0q9g+HKtoWoskj+eDe8t1p1AhLEqJYosfEMijwMz45AeZb4V5egb5ie7LnT0pTtNyPH
         kr9F3y2BjwX8E74oWq03bOwwsCSHzIKf6e0hLnO76pTXe+BAWgz96VHO5KgxBrHQs6Lg
         Yqkd8bPi4azbogiaTzgvUBAxV3PHvAPDlU+ZD17kUTq8/Vt2hqzDiTBi67yiTp7HjAmP
         DCTg==
X-Gm-Message-State: AOAM531Cxiz8MQpGWnOQnidWJnHPKcgzEV6ljdKpQSjvizyigLmD1qVi
        EO3Y7Qtvro+UbbFPo4CsTvg=
X-Google-Smtp-Source: ABdhPJzOfO+U9As1II8kKie7QyvlB1xbLWFlaU5yQFzzbhl8kJib+g67N8dEvVlICx7cQU3Ju0gPoQ==
X-Received: by 2002:a62:1887:0:b029:18c:234a:4640 with SMTP id 129-20020a6218870000b029018c234a4640mr2411984pfy.1.1606826716669;
        Tue, 01 Dec 2020 04:45:16 -0800 (PST)
Received: from [192.168.0.104] ([49.207.197.72])
        by smtp.gmail.com with ESMTPSA id g8sm2634282pgn.47.2020.12.01.04.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 04:45:15 -0800 (PST)
Subject: Re: [PATCH] net: mac80211: cfg: enforce sanity checks for key_index
 in ieee80211_del_key()
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
References: <20201201095639.63936-1-anant.thazhemadam@gmail.com>
 <3025db173074d4dfbc323e91d3586f0e36426cf0.camel@sipsolutions.net>
 <1e5e4471-5cf4-6d23-6186-97f764f4d25f@gmail.com>
 <a6eb69000eb33ca8f59cbaff2afee205e0877eb8.camel@sipsolutions.net>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <a122ca3c-6b1b-3d03-08e3-ac1906ab7389@gmail.com>
Date:   Tue, 1 Dec 2020 18:15:11 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a6eb69000eb33ca8f59cbaff2afee205e0877eb8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/12/20 5:36 pm, Johannes Berg wrote:
> On Tue, 2020-12-01 at 17:26 +0530, Anant Thazhemadam wrote:
>> On 01/12/20 3:30 pm, Johannes Berg wrote:
>>> On Tue, 2020-12-01 at 15:26 +0530, Anant Thazhemadam wrote:
>>>> Currently, it is assumed that key_idx values that are passed to
>>>> ieee80211_del_key() are all valid indexes as is, and no sanity checks
>>>> are performed for it.
>>>> However, syzbot was able to trigger an array-index-out-of-bounds bug
>>>> by passing a key_idx value of 5, when the maximum permissible index
>>>> value is (NUM_DEFAULT_KEYS - 1).
>>>> Enforcing sanity checks helps in preventing this bug, or a similar
>>>> instance in the context of ieee80211_del_key() from occurring.
>>> I think we should do this more generally in cfg80211, like in
>>> nl80211_new_key() we do it via cfg80211_validate_key_settings().
>>>
>>> I suppose we cannot use the same function, but still, would be good to
>>> address this generally in nl80211 for all drivers.
>> Hello,
>>
>> This gave me the idea of trying to use cfg80211_validate_key_settings()
>> directly in ieee80211_del_key(). I did try that out, tested it, and this bug
>> doesn't seem to be getting triggered anymore.
>> If this is okay, then I can send in a v2 soon. :)
>>
>> If there is any reason that I'm missing as to why cfg80211_validate_key_settings()
>> cannot be used in this context, please let me know.
> If it works then I guess that's OK. I thought we didn't have all the
> right information, e.g. whether a key is pairwise or not?
>
> johannes
>
Well,
cfg80211_supported_cipher_suite(&rdev->wiphy, params->cipher) returned
false, and thus it worked for the syzbot reproducer.
Would it be a safer idea to enforce the conditions that I initially put (in
ieee80211_del_key()) directly in cfg80211_validate_key_settings() itself - by
updating max_key_index, and checking accordingly?

Thanks,
Anant

