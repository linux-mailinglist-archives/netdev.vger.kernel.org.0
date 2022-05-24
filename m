Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E8C533250
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 22:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241491AbiEXURR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 16:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiEXURP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 16:17:15 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B10240B8
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:17:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f21so5040545pfa.3
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I1gLUpNfAZVqDJkxJdo6bQcstkb9pwLPF9N3LzjD3jw=;
        b=Ljvgqa7Mh1mhDMI+bLmreFRb8KyHC03iOmO3zc8FcJJYMUw5ZOkaFmnIOqU3RzgtOO
         r032TLpJuYwhDaw3L8pKqTQAc8jYKJlLwQ1se6hAJhzbIVCEgsalp1DXscRGH7z8aa+m
         EZW7vNJsPMwvqGGRIcYeNbQQnAPikOxJHrQ/s+pmY44/wDBIvwYBKX2gatAb9jUAGZgO
         OTYO8WzFctJFaFTQkS0rPSF5Y9XmKfOs2xVEzpq7vowE9cHgzw8yMax9PriBN1CLKQps
         0mA8KpVfAq+uoEfW5EMfefACv2ql1mrK0DJwKGtWj+n/kv3KNk/AIeYbFySopgwxKaja
         4AQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I1gLUpNfAZVqDJkxJdo6bQcstkb9pwLPF9N3LzjD3jw=;
        b=GWDvyRY1SAgjdfMCtSCpRCh49iJskn8veyyyCvIN83vkOJqf9x0an0sN5N1O5mc/Tz
         k/q3B7s5cQ78JoxID1q5YgpoJXJOwDbf5ScsrpxBF34oX6hgpMOyXK1PCgW4Hl6e8kXu
         CxS05CTG5htVj4FyziYs/8y8FMnuWMl0VAAkH+Dsiew5VU/7BkiVOznqDtaUo8pYm9rC
         8DyUMVdrqypApkRCCz3T85Cu8jmfO4YDcjYk9799fb/gkBolU8dmyz6CDfrwL29Cxv1W
         Qh0s7kpgPRw4bGTR3HQU/5mqf3bRdFccy5cvb0w5OljOAhY0kRTVLxQJb5gQlM0OLnlb
         wciQ==
X-Gm-Message-State: AOAM530nLZnJoTGaw3ZTPdf1m9IjJ+j8XHMMERLy9dqAs3etNnTPP4KD
        p6GI41MYa/54ZGEuBZHCm5w=
X-Google-Smtp-Source: ABdhPJw4rv2RVv6rEZnGVkQDeqzcTzqnAk/WnsBuoaPDw0y+mYuJIQtU/gZfjCu1ewbF+ByoHYs/AQ==
X-Received: by 2002:a63:4e25:0:b0:3f6:8:8c04 with SMTP id c37-20020a634e25000000b003f600088c04mr25309258pgb.458.1653423434199;
        Tue, 24 May 2022 13:17:14 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:be57:a1f8:e69e:e0? ([2620:15c:2c1:200:be57:a1f8:e69e:e0])
        by smtp.gmail.com with ESMTPSA id jf4-20020a170903268400b0015e8d4eb1d5sm7714280plb.31.2022.05.24.13.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 13:17:13 -0700 (PDT)
Message-ID: <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com>
Date:   Tue, 24 May 2022 13:17:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: packet stuck in qdisc : patch proposal
Content-Language: en-US
To:     Vincent Ray <vray@kalrayinc.com>,
        linyunsheng <linyunsheng@huawei.com>
Cc:     davem <davem@davemloft.net>,
        =?UTF-8?B?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Guoju Fang <gjfang@linux.alibaba.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>, will <will@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
 <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
 <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
 <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
 <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/24/22 10:00, Vincent Ray wrote:
> All,
>
> I confirm Eric's patch works well too, and it's better and clearer than mine.
> So I think we should go for it, and the one from Guoju in addition.
>
> @Eric : I see you are one of the networking maintainers, so I have a few questions for you :
>
> a) are you going to take care of these patches directly yourself, or is there something Guoju or I should do to promote them ?

I think this is totally fine you take ownership of the patch, please 
send a formal V2.

Please double check what patchwork had to say about your V1 :


https://patchwork.kernel.org/project/netdevbpf/patch/1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu/


And make sure to address the relevant points

The most important one is the lack of 'Signed-off-by:' tag, of course.


> b) Can we expect to see them land in the mainline soon ?

If your v2 submission is correct, it can be merged this week ;)


>
> c) Will they be backported to previous versions of the kernel ? Which ones ?

You simply can include a proper Fixes: tag, so that stable teams can 
backport

the patch to all affected kernel versions.



>
> Thanks a lot, best,

Thanks a lot for working on this long standing issue.


