Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF3F4B151B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245025AbiBJSRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:17:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbiBJSRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:17:42 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E891FA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:17:42 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso6427408pjg.0
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=5ctaiIlUx4PaZRbOXiZ9NMHSv4Az/V1UNMU6QSdyNzw=;
        b=D0t5dmaiHIXbUMdI2nm142jnvrdhwTLrvQjlkLF+W+WCugBGqyN43QdZ+QkXBEBSmN
         pk7q+FbzfZglzYJeH3lV3wEEWRbxb6zhIk74OfVX9NZOxoVnAJIdayCDiEaqpOauaGd6
         DbnbMB9A9iXdrtpy6tzFbYv4WY8M+i0+Jzd0S8DEyXwLr3wQbW1EtEt6aFq6TgxEgTk9
         X2AwbNspTFjbbVhiUdbi3UXllSk3ZBtw09qLr5clfYsa/KUgeu8m0oCqHDiu1USd+32c
         OVxGcHAHeDH3jcDutrGSJZ8pCwZK0bH7MDjJrTgWL52de00Yjx9ua3+gy1q1zPhy6o5s
         FULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=5ctaiIlUx4PaZRbOXiZ9NMHSv4Az/V1UNMU6QSdyNzw=;
        b=ZqzuddMj87KOKVHJUqiiGzeXSPl5g7ViPawQxRkApJe9+lszo8VTAqemC+11+mjP1A
         6xTrkmIiONNwXCLfGPeSYpXaZfUwEDdB+fIP8l1D86oc/QH5d6gemFspKwxLrDV0H5Kf
         kCCkMbHTEDIvuVYCKZl1RRjwAF1atPy+GmqT5opySyNH24FwvInMSmpi0/P/fU1WLbsD
         j1Lbd5sZ2ncyV/DQMB23D5agNfKJOyiDXxQZtwCvfDedn3xWnqQST4id7t8gyImaHqmf
         hwyGvff7HZcZ+Twt1lGzjPNMQiOxxYswGMGrgC4ikJ4Oh1m9Hvor3wOqwSOTV0iXiJXO
         SnpA==
X-Gm-Message-State: AOAM531rYhKpCTn4+vBComgHpSpL8yz6MFzjqqCQGhi6K7fNsfITmRQz
        SAv8NT6aBMknaJDknY83e4Y=
X-Google-Smtp-Source: ABdhPJyS/+IzK5kSx+y6ih0j11+0vuoo5r4JYL8H+ZWmeo+YLEg3USIUdwQWuRf++sw8x0347JHVlA==
X-Received: by 2002:a17:902:a603:: with SMTP id u3mr8890595plq.113.1644517062510;
        Thu, 10 Feb 2022 10:17:42 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id rj1sm3265608pjb.49.2022.02.10.10.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 10:17:41 -0800 (PST)
Message-ID: <141d43cc-6b66-2fcf-4703-70db51859960@gmail.com>
Date:   Thu, 10 Feb 2022 10:17:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next] net: hsr: fix suspicious usage in
 hsr_node_get_first()
Content-Language: en-US
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
References: <20220210162346.6676-1-claudiajkang@gmail.com>
 <b147e095-4c02-61a0-4cca-18c570eb7d9e@gmail.com>
In-Reply-To: <b147e095-4c02-61a0-4cca-18c570eb7d9e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/10/22 09:47, Eric Dumazet wrote:
>
> On 2/10/22 08:23, Juhee Kang wrote:
>> Currently, to dereference hlist_node which is result of 
>> hlist_first_rcu(),
>> rcu_dereference() is used. But, suspicious RCU warnings occur because
>> the caller doesn't acquire RCU. So it was solved by adding 
>> rcu_read_lock().
>>
>> The kernel test robot reports:
>>      [   53.750001][ T3597] =============================
>>      [   53.754849][ T3597] WARNING: suspicious RCU usage
>>      [   53.759833][ T3597] 5.17.0-rc2-syzkaller-00903-g45230829827b 
>> #0 Not tainted
>>      [   53.766947][ T3597] -----------------------------
>>      [   53.771840][ T3597] net/hsr/hsr_framereg.c:34 suspicious 
>> rcu_dereference_check() usage!
>>      [   53.780129][ T3597] other info that might help us debug this:
>>      [   53.790594][ T3597] rcu_scheduler_active = 2, debug_locks = 1
>>      [   53.798896][ T3597] 2 locks held by syz-executor.0/3597:
>
>
> Please include whole stack.
>
>
>>
>> Fixes: 4acc45db7115 ("net: hsr: use hlist_head instead of list_head 
>> for mac addresses")
>> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
>> Reported-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
>> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
>> ---
>> v2:
>>   - rebase current net-next tree
>>
>>   net/hsr/hsr_framereg.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
>> index b3c6ffa1894d..92abdf855327 100644
>> --- a/net/hsr/hsr_framereg.c
>> +++ b/net/hsr/hsr_framereg.c
>> @@ -31,7 +31,10 @@ struct hsr_node *hsr_node_get_first(struct 
>> hlist_head *head)
>>   {
>>       struct hlist_node *first;
>>   +    rcu_read_lock();
>>       first = rcu_dereference(hlist_first_rcu(head));
>> +    rcu_read_unlock();
>> +
>>       if (first)
>>           return hlist_entry(first, struct hsr_node, mac_list);
>
>
> This is not fixing anything, just silence the warning.



I suggest replacing rcu_dereference() by rcu_dereference_rtnl()



