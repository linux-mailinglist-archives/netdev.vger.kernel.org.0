Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A174F2CA202
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 13:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390242AbgLAL5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgLAL5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 06:57:22 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B45C0613CF;
        Tue,  1 Dec 2020 03:56:42 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id l23so1103550pjg.1;
        Tue, 01 Dec 2020 03:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5hgImp7mtfyoIITXeXte4NNvXY5OiJT0esiIV50KJpM=;
        b=lWOTJbbbgEMI60IivvuuQmAV2odlXSz6fZw8/Iszp7pYWor6b3zFNFQFsFM6Up5Kdp
         QFqBHeutH7Yw0GaA2mJ3koaPoWpIk72FVZu5RMo2nEtrkss9ZlPkYb0qHl1U1Z4nvMcE
         wwLFuCMN0dlmweMQgSs+zbrmSbkJ2HxmO0jM00flUSXb7vSBn7ia+Pe3VBFrgy2+4Jza
         AtFlxBVsYL5ZcODz2pnTH97xjSoNRIsVdv9gDeWZZoh2vXamSt4AQ18M1z91oBXOPBOu
         uTmLb+NUodI1LrwNSNnlK6rnSVvTy+lU2ZCw1eu2TXyCGRZh6h7YMWGPr7agsuQscdCI
         rCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5hgImp7mtfyoIITXeXte4NNvXY5OiJT0esiIV50KJpM=;
        b=WWogOGBkbxrhCgBQnqyQl3aZjMpsvQHyfC0wQfNsovyPhGgPW2WwOSG/AfkQecb8oy
         erQjkJjcWXRosyauBudAtamYtrThjrk/GEs20JmwZTin8eve7MqxcIho1mLziLgL4L/S
         wdRxG/it06KxJgonfE8E46Yva3vzmsf0/+ZNoZBuasmb2G8BC7SGbiLvrcDe5q3qCkLU
         qr6230nebD/NRKp47jmE4RG8JhGl5obWZMsNxpRI6S3jahwxdkqtCWAxLI9kEmFgOaKY
         MWoYpwfLHpW3F6YPVHH8t4+wpsCwktlymx5VmQToGs9sA0gpQQ7yUyvXXRPuE1gpyHAd
         fe5A==
X-Gm-Message-State: AOAM5311ZJlkbgjTP3TG6Sy609gfIrFzIMWR6O+0cGqkCxpX9P3VQfL8
        Tx1b6ah6qtL2J05WOOQq6eY=
X-Google-Smtp-Source: ABdhPJzJQXCJUZt03XNnhIFMYuHfxE6/gQWdjcgU4X26SNEJ+vUFu73++gnhJ342p3YQhBQNExwl7A==
X-Received: by 2002:a17:902:c155:b029:da:9460:99a0 with SMTP id 21-20020a170902c155b02900da946099a0mr2471436plj.20.1606823802205;
        Tue, 01 Dec 2020 03:56:42 -0800 (PST)
Received: from [192.168.0.104] ([49.207.197.72])
        by smtp.gmail.com with ESMTPSA id h11sm2574403pfo.69.2020.12.01.03.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 03:56:41 -0800 (PST)
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
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <1e5e4471-5cf4-6d23-6186-97f764f4d25f@gmail.com>
Date:   Tue, 1 Dec 2020 17:26:37 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3025db173074d4dfbc323e91d3586f0e36426cf0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/12/20 3:30 pm, Johannes Berg wrote:
> On Tue, 2020-12-01 at 15:26 +0530, Anant Thazhemadam wrote:
>> Currently, it is assumed that key_idx values that are passed to
>> ieee80211_del_key() are all valid indexes as is, and no sanity checks
>> are performed for it.
>> However, syzbot was able to trigger an array-index-out-of-bounds bug
>> by passing a key_idx value of 5, when the maximum permissible index
>> value is (NUM_DEFAULT_KEYS - 1).
>> Enforcing sanity checks helps in preventing this bug, or a similar
>> instance in the context of ieee80211_del_key() from occurring.
> I think we should do this more generally in cfg80211, like in
> nl80211_new_key() we do it via cfg80211_validate_key_settings().
>
> I suppose we cannot use the same function, but still, would be good to
> address this generally in nl80211 for all drivers.

Hello,

This gave me the idea of trying to use cfg80211_validate_key_settings()
directly in ieee80211_del_key(). I did try that out, tested it, and this bug
doesn't seem to be getting triggered anymore.
If this is okay, then I can send in a v2 soon. :)

If there is any reason that I'm missing as to why cfg80211_validate_key_settings()
cannot be used in this context, please let me know.

Thanks,
Anant

